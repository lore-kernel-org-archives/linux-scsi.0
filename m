Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE71C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 05:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB77960E08
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 05:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhJEFI0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 01:08:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:14709 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230493AbhJEFI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Oct 2021 01:08:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="225551325"
X-IronPort-AV: E=Sophos;i="5.85,347,1624345200"; 
   d="scan'208";a="225551325"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 22:06:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,347,1624345200"; 
   d="scan'208";a="487853096"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga008.jf.intel.com with ESMTP; 04 Oct 2021 22:06:33 -0700
Subject: Re: [PATCH RFC 2/6] scsi: ufs: Rename clk_scaling_lock to host_rw_sem
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20211004120650.153218-1-adrian.hunter@intel.com>
 <20211004120650.153218-3-adrian.hunter@intel.com>
 <453b33d4-4e53-3b31-ef9a-3a63989de7a8@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <a94a44e0-ff6e-6521-7822-134b7211ddca@intel.com>
Date:   Tue, 5 Oct 2021 08:06:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <453b33d4-4e53-3b31-ef9a-3a63989de7a8@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/10/2021 19:52, Bart Van Assche wrote:
> On 10/4/21 5:06 AM, Adrian Hunter wrote:
>> To fit its new purpose as a more general purpose sleeping lock for the
>> host.
>>
>> [ ... ]
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 9b1ef272fb3c..495e1c0afae3 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -897,7 +897,7 @@ struct ufs_hba {
>>       enum bkops_status urgent_bkops_lvl;
>>       bool is_urgent_bkops_lvl_checked;
>>   -    struct rw_semaphore clk_scaling_lock;
>> +    struct rw_semaphore host_rw_sem;
>>       unsigned char desc_size[QUERY_DESC_IDN_MAX];
>>       atomic_t scsi_block_reqs_cnt;
> 
> Hi Adrian,

Thanks for looking at this.

> 
> It seems to me that this patch series goes in another direction than the
> direction the JEDEC UFS committee is going into. The UFSHCI 4.0 specification
> will support MCQ (Multi-Circular queue). We will benefit most from the v4.0
> MCQ support if there is no contention between the CPUs that submit UFS commands
> to different queues. I think the intention of this patch series is to make a
> single synchronization object protect all submission queues.

The intention is to make the locking easier to understand.  We need either to
share access to the host (e.g. ufshcd_queuecommand) or provide for exclusive
ownership (e.g. ufshcd_err_handler, PM, Shutdown).  We should be able to do
that with 1 rw_semaphore.

> I'm concerned that
> this will prevent to fully benefit from multiqueue support. Has it been

You are talking about contention between ufshcd_queuecommand() running
simultaneously on 2 CPUs right?  In that case, down_read() should be practically
atomic, so no contention unless a third process is waiting on down_write()
which never happens under normal circumstances.

> Has it been
> considered to eliminate the clk_scaling_lock and instead to use RCU to
> serialize clock scaling against command processing? One possible approach is to
> use blk_mq_freeze_queue() and blk_mq_unfreeze_queue() around the clock scaling
> code. A disadvantage of using RCU is that waiting for an RCU grace period takes
> some time - about 10 ms on my test setup. I have not yet verified what the
> performance and time impact would be of using an expedited RCU grace period
> instead of a regular RCU grace period.

It is probably worth measuring the performance of clk_scaling_lock first.
