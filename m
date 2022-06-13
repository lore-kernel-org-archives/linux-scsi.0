Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D87C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 06:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiFMG2o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 02:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiFMG2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 02:28:43 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62B1D9E
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jun 2022 23:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655101722; x=1686637722;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5lX/QpSRaOV58X6OnIKJuV0TAm0yQq5AK7II920Y/GI=;
  b=FurQIeJQL5mW/bi4EdYpvVH6llceAURHgTmXBHFmvnI6L778Qj7UmPgi
   l/24iEN/bb7pmsq7nLOTGxog6BDqz6P8WQZpTP168W3UmZ5Lpnp+5MEOY
   ONVV0rJFNgt6K4oXzD+UQAGfVwwWfaAL1L5nzvHMwT9A3xPywBub1C13S
   tTSg+j/rsIdQlmq4vQhR9qyEMntktk7AMU+VMLtJPm9pjtIZCAbIzxUr9
   LPQZ0HhPk95rnh5hU6iLPthg7teiRc+hC+tQMXAVJve7zw+Yp/G6qf/Hz
   2dTDCnxL++OPe245X0QBRDsXknRxeKK1icK5y8dsVhsCm3cy3hcAdSdEe
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="275715143"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="275715143"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2022 23:28:42 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="639548437"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.58.193])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2022 23:28:40 -0700
Message-ID: <de4b45a6-1e67-0bc5-39c4-62d7982d55fa@intel.com>
Date:   Mon, 13 Jun 2022 09:28:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH] scsi: ufs: Fix a race between the interrupt handler and
 the reset handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
References: <20220610232915.2916712-1-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220610232915.2916712-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/06/22 02:29, Bart Van Assche wrote:
> Prevent that both the interrupt handler and the reset handler try to
> complete a request at the same time. This patch is the result of the
> analysis of the following crash:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000120
> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           OE     5.10.107-android13-4-00051-g1e48e8970cca-ab8664745 #1
> pc : ufshcd_release_scsi_cmd+0x30/0x46c
> lr : __ufshcd_transfer_req_compl+0x4fc/0x9c0
> Call trace:
>  ufshcd_release_scsi_cmd+0x30/0x46c
>  __ufshcd_transfer_req_compl+0x4fc/0x9c0
>  ufshcd_poll+0xf0/0x208
>  ufshcd_sl_intr+0xb8/0xf0
>  ufshcd_intr+0x168/0x2f4
>  __handle_irq_event_percpu+0xa0/0x30c
>  handle_irq_event+0x84/0x178
>  handle_fasteoi_irq+0x150/0x2e8
>  __handle_domain_irq+0x114/0x1e4
>  gic_handle_irq.31846+0x58/0x300
>  el1_irq+0xe4/0x1c0
>  cpuidle_enter_state+0x3ac/0x8c4
>  do_idle+0x2fc/0x55c
>  cpu_startup_entry+0x84/0x90
>  kernel_init+0x0/0x310
>  start_kernel+0x0/0x608
>  start_kernel+0x4ec/0x608
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1fb3a8b9b03e..279691ff3562 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6966,6 +6966,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>   */
>  static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
>  {
> +	unsigned long flags, completed_reqs = 0;
>  	struct Scsi_Host *host;
>  	struct ufs_hba *hba;
>  	u32 pos;
> @@ -6984,13 +6985,18 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
>  	}
>  
>  	/* clear the commands that were pending for corresponding LUN */
> -	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
> -		if (hba->lrb[pos].lun == lun) {
> -			err = ufshcd_clear_cmd(hba, pos);
> -			if (err)
> -				break;
> -			__ufshcd_transfer_req_compl(hba, 1U << pos);
> -		}
> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
> +	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs)
> +		if (hba->lrb[pos].lun == lun)
> +			__set_bit(pos, &completed_reqs);
> +	hba->outstanding_reqs &= ~completed_reqs;
> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> +
> +	for_each_set_bit(pos, &completed_reqs, hba->nutrs) {
> +		err = ufshcd_clear_cmd(hba, pos);
> +		if (err)
> +			break;

Having cleared the bit in hba->outstanding_reqs, shouldn't we
always complete the request? i.e. we should not 'break' here

> +		__ufshcd_transfer_req_compl(hba, 1U << pos);
>  	}
>  
>  out:

