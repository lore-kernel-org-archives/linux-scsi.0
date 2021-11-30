Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFD9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 19:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241880AbhK3TFz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 14:05:55 -0500
Received: from mga04.intel.com ([192.55.52.120]:51246 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240334AbhK3TFy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Nov 2021 14:05:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="235023403"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="235023403"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 11:02:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="540529283"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga001.jf.intel.com with ESMTP; 30 Nov 2021 11:02:32 -0800
Subject: Re: [PATCH v2 14/20] scsi: ufs: Introduce ufshcd_release_scsi_cmd()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-15-bvanassche@acm.org>
 <1383eeb3-dc40-6498-7388-b5d35b923f88@intel.com>
 <4e4fb79a-6783-0613-9fbd-d22b7c18d079@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <7d135f3b-dcf3-f612-dfba-8a72f1026c79@intel.com>
Date:   Tue, 30 Nov 2021 21:02:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <4e4fb79a-6783-0613-9fbd-d22b7c18d079@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/11/2021 20:00, Bart Van Assche wrote:
> On 11/24/21 4:03 AM, Adrian Hunter wrote:
>> On 19/11/2021 21:57, Bart Van Assche wrote:
>>> +/* Release the resources allocated for processing a SCSI command. */
>>> +static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
>>> +                    struct ufshcd_lrb *lrbp)
>>> +{
>>> +    struct scsi_cmnd *cmd = lrbp->cmd;
>>> +
>>> +    scsi_dma_unmap(cmd);
>>> +    lrbp->cmd = NULL;    /* Mark the command as completed. */
>>> +    ufshcd_release(hba);
>>> +    ufshcd_clk_scaling_update_busy(hba);
>>> +}
>>
>> That seems to leave a gap in the handling of tracing.
>>
>> Wouldn't we be better served to tweak the monitoring code
>> in __ufshcd_transfer_req_compl() and then use
>>   __ufshcd_transfer_req_compl()? i.e.
>>
>>     result = ufshcd_transfer_rsp_status(hba, lrbp);
>>     if (unlikely(!result && ufshcd_should_inform_monitor(hba, lrbp)))
>>         ufshcd_update_monitor(hba, lrbp);
> 
> Which gap are you referring to? 

As in: you are not handling tracing.

ufshcd_abort() only calls
> ufshcd_release_scsi_cmd() after ufshcd_try_to_abort_task() succeeded.
> That means that the command has not completed and hence that
> ufshcd_update_monitor() must not be called.

AFAICT the monitor is for successful commands, which is why I suggested
checking the 'result'.

So make that change to __ufshcd_transfer_req_compl() and then it will
work for ufshcd_abort() and provide tracing.
