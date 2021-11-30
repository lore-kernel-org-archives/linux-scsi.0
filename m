Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D67C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 08:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbhK3I6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 03:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239920AbhK3I61 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 03:58:27 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1685C06175F
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 00:54:58 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id t9so25744192wrx.7
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 00:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=DVtcILBkSrk4V5AyPkiUB9rsaZQAZmfkezGMsZ0zAlQ=;
        b=S1pRPd11ovAUnLLLQjRQlkEB5oeMQhDI6SSLvJpMJsMXiKlW5Z38K4x72x65x5room
         3UD6OkE12ov/T3tsHVh3mqdTxbKQk/zRGqnsgqQk+0qMCX5V9hhGAvCgz+FVjd3ihrLt
         t2+i4uScenHQJsqJZ/5Jx5gLahF/63Lslv/iP/8PyUxu27mt7Bo6WSYyxrwBdSe6uYxb
         dT4VvzUoRk78xsJ6doS5DYFyoWQ8WLcT+WFia41f4feYRQYKhOhjjCgoKarI8M0AxOmX
         qyp40DqTJdJK5hPTT14o6tZNys0g0xMvMURL814RDkoWixAeyf/p4QhNcX8HqAlE9g3Z
         8KRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DVtcILBkSrk4V5AyPkiUB9rsaZQAZmfkezGMsZ0zAlQ=;
        b=mLqrbhLWqZeuP34p+Ok68ghhBiJDrfnBt2QSBfuTmxD49e2bVZnE4LRWEG9MdXjZVh
         F8N0sJbYjSvUV27myBNcCxS0ymynRThmtQLddEDTpsoLjdcFm+diq7dMPzMB9yK370+p
         CLFG4ssd9piPQWukHlZGZnv/MJTyaQLdxzLpWPCbEUZ2zBw53AFOL/TN5JN4SOWIOaLx
         LOEukEPOutDpBXDIGVqlOOwX/xQzoRZbB1vtlfuhmvQIMr+OxmqJCwuYqniSE8nUXbuk
         z9pYWDrNhnjluQooLDDcNPquNhZRWxT5/wzNUcJCn/UZXrzzNy9hOqYJ0YgCwFZIuswV
         Zf1A==
X-Gm-Message-State: AOAM533p4kNxfZ2WAdWgDJDxgx+qOqMZoCDNeNRyNi5Fj4c2nlod8RrS
        IRwT6T6KnADxczvz+IxgNrI=
X-Google-Smtp-Source: ABdhPJyRM+0La4UEFtjv3xJJhDTD89aDFe3u3geuQ4Umd8LHiko7wmnZ0CIGDWccqty8B2jZMfq2Zg==
X-Received: by 2002:a05:6000:52:: with SMTP id k18mr39836853wrx.192.1638262497416;
        Tue, 30 Nov 2021 00:54:57 -0800 (PST)
Received: from p200300e94719c91f05d9351815d7236e.dip0.t-ipconnect.de (p200300e94719c91f05d9351815d7236e.dip0.t-ipconnect.de. [2003:e9:4719:c91f:5d9:3518:15d7:236e])
        by smtp.googlemail.com with ESMTPSA id z11sm15967383wrt.58.2021.11.30.00.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 00:54:57 -0800 (PST)
Message-ID: <788d060573ed475a902f17bc32d05540b78e66da.camel@gmail.com>
Subject: Re: [PATCH v2 13/20] scsi: ufs: Fix a deadlock in the error handler
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Tue, 30 Nov 2021 09:54:56 +0100
In-Reply-To: <20211119195743.2817-14-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
         <20211119195743.2817-14-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

The concern of this patch is that it reduces the UFS data transmission
queue depth. The cost is a bit high. We are looking for alternative
methods: for example, to fix this problem from the SCSI layer;
Add a new dedicated hardware device management queue on the UFS device
side.

Kind regards,
Bean

On Fri, 2021-11-19 at 11:57 -0800, Bart Van Assche wrote:
> The following deadlock has been observed on a test setup:
> * All tags allocated.
> * The SCSI error handler calls ufshcd_eh_host_reset_handler()
> * ufshcd_eh_host_reset_handler() queues work that calls
> ufshcd_err_handler()
> * ufshcd_err_handler() locks up as follows:
> 
> Workqueue: ufs_eh_wq_0 ufshcd_err_handler.cfi_jt
> Call trace:
>  __switch_to+0x298/0x5d8
>  __schedule+0x6cc/0xa94
>  schedule+0x12c/0x298
>  blk_mq_get_tag+0x210/0x480
>  __blk_mq_alloc_request+0x1c8/0x284
>  blk_get_request+0x74/0x134
>  ufshcd_exec_dev_cmd+0x68/0x640
>  ufshcd_verify_dev_init+0x68/0x35c
>  ufshcd_probe_hba+0x12c/0x1cb8
>  ufshcd_host_reset_and_restore+0x88/0x254
>  ufshcd_reset_and_restore+0xd0/0x354
>  ufshcd_err_handler+0x408/0xc58
>  process_one_work+0x24c/0x66c
>  worker_thread+0x3e8/0xa4c
>  kthread+0x150/0x1b4
>  ret_from_fork+0x10/0x30
> 
> Fix this lockup by making ufshcd_exec_dev_cmd() allocate a reserved
> request.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a241ef6bbc6f..03f4772fc2e2 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -128,8 +128,9 @@ EXPORT_SYMBOL_GPL(ufshcd_dump_regs);
>  enum {
>  	UFSHCD_MAX_CHANNEL	= 0,
>  	UFSHCD_MAX_ID		= 1,
> -	UFSHCD_CMD_PER_LUN	= 32,
> -	UFSHCD_CAN_QUEUE	= 32,
> +	UFSHCD_NUM_RESERVED	= 1,
> +	UFSHCD_CMD_PER_LUN	= 32 - UFSHCD_NUM_RESERVED,
> +	UFSHCD_CAN_QUEUE	= 32 - UFSHCD_NUM_RESERVED,
>  };
>  
>  static const char *const ufshcd_state_name[] = {
> @@ -2941,12 +2942,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>  
>  	down_read(&hba->clk_scaling_lock);
>  
> -	/*
> -	 * Get free slot, sleep if slots are unavailable.
> -	 * Even though we use wait_event() which sleeps indefinitely,
> -	 * the maximum wait time is bounded by SCSI request timeout.
> -	 */
> -	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
> +	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE,
> BLK_MQ_REQ_RESERVED);
>  	if (IS_ERR(scmd)) {
>  		err = PTR_ERR(scmd);
>  		goto out_unlock;
> @@ -8171,6 +8167,7 @@ static struct scsi_host_template
> ufshcd_driver_template = {
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
>  	.can_queue		= UFSHCD_CAN_QUEUE,
> +	.reserved_tags		= UFSHCD_NUM_RESERVED,
>  	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
>  	.max_host_blocked	= 1,
>  	.track_queue_depth	= 1,
> @@ -9531,8 +9528,8 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  	/* Configure LRB */
>  	ufshcd_host_memory_configure(hba);
>  
> -	host->can_queue = hba->nutrs;
> -	host->cmd_per_lun = hba->nutrs;
> +	host->can_queue = hba->nutrs - UFSHCD_NUM_RESERVED;
> +	host->cmd_per_lun = hba->nutrs - UFSHCD_NUM_RESERVED;
>  	host->max_id = UFSHCD_MAX_ID;
>  	host->max_lun = UFS_MAX_LUNS;
>  	host->max_channel = UFSHCD_MAX_CHANNEL;

