Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0241C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237066AbhKWMXT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 07:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236958AbhKWMXS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 07:23:18 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0087C061574
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 04:20:09 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 137so15020305wma.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 04:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Fx4E5KR6RBFi26xzPRK+p26ha7W12FZTvQ9Ky03uBmg=;
        b=QyVIvhgZiM+GZ2fD7lR/Wm0Un0LneffmuWv7uYcrG4lb2A5wFWQqMapdWL4rKouUwO
         Le0m+tFGf8AALpuAqatlSo1aL5x02y6loibl3VeQnzPUKjw3txjrSS+NweG4WP3E3FLO
         kIS3eFKaZUKRLxLToob6XR+Xg3/yzsgmzAH28xUW0877IxVV9onTSzyZcssdq1qnQR2Q
         pEdjDHK0H07E9N3zlv/kEVv00k9vF7zAJwfBmwhuxEXpMTAOafr5aWpsHzixNs/59/yy
         Emjp4CY5H874koQT8O3FjhvEY1RfatppXbgqz5mPaii+5lbDD7mKLJYyrHdZvQieCdqK
         Tp3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Fx4E5KR6RBFi26xzPRK+p26ha7W12FZTvQ9Ky03uBmg=;
        b=wu9BT28G2p5LWOlOv3+yu1PpeGiy8Qgx2pDPY1uB4YQw8ejYJh8rWOkR0CSlQW6zyi
         bNnRFI4jRIrbeoLC8yEbNhHXYS+MOIBA70D7AGfOS1BBRMYMMT3K+y6IVE2NgPB6msU9
         PckuZhIQ+hzcDl2gTeDMer71cmrzLZXefVSkvtipLOkSnZ+c7iDzE8ZlXveXHER1Yu6g
         R+5eRNdgI6RyOZH9/ALUWHyydDnZ0nkvaUqo+7wi4AIdenVD2QOIvb40DVg5Ll5Zbjxz
         wjUxck5cE9etLnTvjgHNOVvmLRdIemtJLQCQOqc72kGIdW83Y4979vPcn4uy1FOZQFzX
         QKbQ==
X-Gm-Message-State: AOAM5338PUWoRsdWXtqRUkFcp2C8Ybna4dyOdi8uoMmGtI1g3s14JJ1d
        598JHx4KU6AxgMc0umN8dDU=
X-Google-Smtp-Source: ABdhPJxgF7BYoCSa7GKRWK8SmZG7JPMI6WnsxEpD9Gb1NDLxI2d4H/I4gOCaMunqS+NY042Ykmagpg==
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr2621977wms.74.1637670008436;
        Tue, 23 Nov 2021 04:20:08 -0800 (PST)
Received: from p200300e94719c9d28b21d2c5b178159d.dip0.t-ipconnect.de (p200300e94719c9d28b21d2c5b178159d.dip0.t-ipconnect.de. [2003:e9:4719:c9d2:8b21:d2c5:b178:159d])
        by smtp.googlemail.com with ESMTPSA id v6sm986464wmh.8.2021.11.23.04.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 04:20:08 -0800 (PST)
Message-ID: <5dc2cf927a0e196067b7207ee1800a09cd769de6.camel@gmail.com>
Subject: Re: [PATCH v2 11/20] scsi: ufs: Switch to
 scsi_(get|put)_internal_cmd()
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
Date:   Tue, 23 Nov 2021 13:20:06 +0100
In-Reply-To: <20211119195743.2817-12-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
         <20211119195743.2817-12-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-11-19 at 11:57 -0800, Bart Van Assche wrote:
> The only functional change in this patch is the addition of a
> blk_mq_start_request() call in ufshcd_issue_devman_upiu_cmd().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 46 +++++++++++++++++++++++++----------
> ----
>  1 file changed, 30 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fced4528ee90..dfa5f127342b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2933,6 +2933,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>  {
>  	struct request_queue *q = hba->cmd_queue;
>  	DECLARE_COMPLETION_ONSTACK(wait);
> +	struct scsi_cmnd *scmd;
>  	struct request *req;
>  	struct ufshcd_lrb *lrbp;
>  	int err;
> @@ -2945,15 +2946,18 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>  	 * Even though we use wait_event() which sleeps indefinitely,
>  	 * the maximum wait time is bounded by SCSI request timeout.
>  	 */
> -	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
> -	if (IS_ERR(req)) {
> -		err = PTR_ERR(req);
> +	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
> +	if (IS_ERR(scmd)) {
> +		err = PTR_ERR(scmd);
>  		goto out_unlock;
>  	}
> +	req = scsi_cmd_to_rq(scmd);
>  	tag = req->tag;
>  	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
> -	/* Set the timeout such that the SCSI error handler is not
> activated. */
> -	req->timeout = msecs_to_jiffies(2 * timeout);
> +	/*
> +	 * Start the request such that blk_mq_tag_idle() is called when
> the
> +	 * device management request finishes.
> +	 */
>  	blk_mq_start_request(req);
>  
>  	lrbp = &hba->lrb[tag];
> @@ -2972,7 +2976,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>  				    (struct utp_upiu_req *)lrbp-
> >ucd_rsp_ptr);
>  
>  out:
> -	blk_mq_free_request(req);
> +	scsi_put_internal_cmd(scmd);
> +
>  out_unlock:
>  	up_read(&hba->clk_scaling_lock);
>  	return err;
> @@ -6573,17 +6578,16 @@ static int __ufshcd_issue_tm_cmd(struct
> ufs_hba *hba,
>  	struct request_queue *q = hba->tmf_queue;
>  	struct Scsi_Host *host = hba->host;
>  	DECLARE_COMPLETION_ONSTACK(wait);
> +	struct scsi_cmnd *scmd;
>  	struct request *req;
>  	unsigned long flags;
>  	int task_tag, err;
>  
> -	/*
> -	 * blk_mq_alloc_request() is used here only to get a free tag.
> -	 */
> -	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
> -	if (IS_ERR(req))
> -		return PTR_ERR(req);
> +	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
> +	if (IS_ERR(scmd))
> +		return PTR_ERR(scmd);
>  
> +	req = scsi_cmd_to_rq(scmd);
>  	req->end_io_data = &wait;
>  	ufshcd_hold(hba, false);
>  
> @@ -6636,7 +6640,8 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba
> *hba,
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  
>  	ufshcd_release(hba);
> -	blk_mq_free_request(req);
> +
> +	scsi_put_internal_cmd(scmd);
>  
>  	return err;
>  }
> @@ -6714,6 +6719,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  {
>  	struct request_queue *q = hba->cmd_queue;
>  	DECLARE_COMPLETION_ONSTACK(wait);
> +	struct scsi_cmnd *scmd;
>  	struct request *req;
>  	struct ufshcd_lrb *lrbp;
>  	int err = 0;
> @@ -6722,13 +6728,19 @@ static int
> ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>  
>  	down_read(&hba->clk_scaling_lock);
>  
> -	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
> -	if (IS_ERR(req)) {
> -		err = PTR_ERR(req);
> +	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
> +	if (IS_ERR(scmd)) {
> +		err = PTR_ERR(scmd);
>  		goto out_unlock;
>  	}
> +	req = scsi_cmd_to_rq(scmd);
>  	tag = req->tag;
>  	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
> +	/*
> +	 * Start the request such that blk_mq_tag_idle() is called when
> the
> +	 * device management request finishes.
> +	 */
> +	blk_mq_start_request(req);

Bart,

Calling blk_mq_start_request() will inject the trace print of the block
issued, but we do not have its paired completion trace print.
In addition, blk_mq_tag_idle() will not be called after the device
management request is completed, it will be called after the timer
expires.

I remember that we used to not allow this kind of LLD internal commands
to be attached to the block layer. I now find that to be correct way. 

Bean

