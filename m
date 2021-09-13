Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB84C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 17:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F1D961056
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 17:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbhIMROq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 13:14:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:21904 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232274AbhIMROq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 13:14:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="221404834"
X-IronPort-AV: E=Sophos;i="5.85,290,1624345200"; 
   d="scan'208";a="221404834"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 10:13:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,290,1624345200"; 
   d="scan'208";a="609089516"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by fmsmga001.fm.intel.com with ESMTP; 13 Sep 2021 10:13:27 -0700
Subject: Re: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210905095153.6217-1-adrian.hunter@intel.com>
 <20210905095153.6217-2-adrian.hunter@intel.com>
 <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
 <835c5eab-5a7b-269d-7483-227978b80cd7@intel.com>
 <d9656961-4abb-aff0-e34d-d8082a1f4eaa@acm.org>
 <e5307bbe-1cda-fdd2-a666-ae57cd90de07@acm.org>
 <36245674-b179-d25e-84c3-417ef2d85620@intel.com>
 <9220f68e-dc5e-9520-6e55-2a4d86809b44@acm.org>
 <fae15188-2c1d-b953-f6e4-6e5ac1902b24@intel.com>
 <2997f7f9-d136-4bad-6490-5e19abccba00@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <cad73161-f124-e764-964f-3c205aaca2d9@intel.com>
Date:   Mon, 13 Sep 2021 20:13:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2997f7f9-d136-4bad-6490-5e19abccba00@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/09/21 7:33 pm, Bart Van Assche wrote:
> On 9/13/21 1:53 AM, Adrian Hunter wrote:
>> scsi_dec_host_busy() is called for any non-zero return value like
>> SCSI_MLQUEUE_HOST_BUSY:
>>
>> i.e.
>>     reason = scsi_dispatch_cmd(cmd);
>>     if (reason) {
>>         scsi_set_blocked(cmd, reason);
>>         ret = BLK_STS_RESOURCE;
>>         goto out_dec_host_busy;
>>     }
>>
>>     return BLK_STS_OK;
>>
>> out_dec_host_busy:
>>     scsi_dec_host_busy(shost, cmd);
>>
>> And that will wake the error handler:
>>
>> static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>> {
>>     unsigned long flags;
>>
>>     rcu_read_lock();
>>     __clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>>     if (unlikely(scsi_host_in_recovery(shost))) {
>>         spin_lock_irqsave(shost->host_lock, flags);
>>         if (shost->host_failed || shost->host_eh_scheduled)
>>             scsi_eh_wakeup(shost);
>>         spin_unlock_irqrestore(shost->host_lock, flags);
>>     }
>>     rcu_read_unlock();
>> }
> 
> Returning SCSI_MLQUEUE_HOST_BUSY is not sufficient to wake up the SCSI
> error handler because of the following test in scsi_error_handler():
> 
>     shost->host_failed != scsi_host_busy(shost)

SCSI_MLQUEUE_HOST_BUSY causes scsi_host_busy() to decrement by calling
scsi_dec_host_busy() as described above, so the request is not being
counted in that condition anymore.

> 
> As I mentioned in a previous email, all pending commands must have failed
> or timed out before the error handler is woken up. Returning
> SCSI_MLQUEUE_HOST_BUSY from ufshcd_queuecommand() does not fail a command
> and prevents it from timing out. Hence my suggestion to change
> "return SCSI_MLQUEUE_HOST_BUSY" into set_host_byte(cmd, DID_IMM_RETRY)
> followed by cmd->scsi_done(cmd). A possible alternative is to move the
> blk_mq_start_request() call in the SCSI core such that the block layer
> request timer is not reset if a SCSI LLD returns SCSI_MLQUEUE_HOST_BUSY.
> 
> Bart.

