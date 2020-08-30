Return-Path: <SRS0=rOw5=CI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43796C433E7
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 18:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20AED2078D
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 18:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJUQHy0M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgH3SMC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 14:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgH3SL7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 14:11:59 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368F6C061573;
        Sun, 30 Aug 2020 11:11:59 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id oz20so5592874ejb.5;
        Sun, 30 Aug 2020 11:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r4K/lSbWzlASRKqOD2SH+z5dVnoVuXy4pnbEv1z5A3I=;
        b=TJUQHy0MzTt5eHgX8kNhWRyN70MSlVhlAbp2hxKA/EufPl7OhPFsdb1q28guVRMPdq
         Y6qNbd+LLtqPeaP+3po9kIltj8Vq5mQIevpXtNPSlaeb/4cI5slZQr+TqNo9dcIjXsPF
         WPc7qfXMItiCuIijmkePt5YoW5cDule/AJU/Anx+4J7bJ2B+XoNss+DhJAbsUhsMBoS6
         uZu+xWleSuF0o6rHRXLaSl/25yyW//BP+yc626ItR5riwWcD2qIv0nE8fZ+h8XOw5XjU
         PMTRrf9wrNGeYNN8gqOPunKTd99oHY/RcpFKymmEJJ9Z9lcGwid7T5R6GlF4yqJsvQTB
         /7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r4K/lSbWzlASRKqOD2SH+z5dVnoVuXy4pnbEv1z5A3I=;
        b=rEyjn3VTD3j8qtT7GVUuI2AgK6zgS/aGTyzEwqINLSrN9KC4R0NgNVlxGSyJCFTLH9
         Ek7cVWIao5hzFmARZYKG0mMThypjV/suZ6550MU+l3la3b/cxFXnnBZiuf2F9j7MNpal
         zdluyYaCc/XO3sAtklnIqeS/g+x+bXIx/jgfckcoH4YMOPRd14Zmc3nj+RzhQ+nCyywp
         nxSaj/D2bMvCvzrLl9twIRBGt+me9tDSCIPhKkbcW8FcVaPkCecNyenH08RqExPRc4W/
         YBzPpMF06dJ+7/SnAcn3TkSCBR0YhdzTX6XCYu3wgCpS09SGRDZfcIKHsky3RAL7pIiD
         e0dg==
X-Gm-Message-State: AOAM533p3E11JN4LqsOsldaVBe6sFyRXrb/PMrlFmplISTtNnjA/dd89
        4j9cVp6bQJzbsM5bswKDm10=
X-Google-Smtp-Source: ABdhPJz2kT17lF/eZzFk4p6nIi9d7gfx1KeUE42fJCNq0dTsJYEMMsVHh/BbuqP7NKRedP2o1ka09A==
X-Received: by 2002:a17:906:393:: with SMTP id b19mr8572133eja.268.1598811114148;
        Sun, 30 Aug 2020 11:11:54 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfce6.dynamic.kabel-deutschland.de. [95.91.252.230])
        by smtp.googlemail.com with ESMTPSA id m14sm2601513ejn.8.2020.08.30.11.11.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 30 Aug 2020 11:11:53 -0700 (PDT)
Message-ID: <26bfbdf4e5c5802cce6b0ddf5eddbd75bd306d0f.camel@gmail.com>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Sun, 30 Aug 2020 20:11:52 +0200
In-Reply-To: <1598321228-21093-2-git-send-email-cang@codeaurora.org>
References: <1598321228-21093-1-git-send-email-cang@codeaurora.org>
         <1598321228-21093-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can
This patch conflicts and be not in line with this series patches : h
ttps://patchwork.kernel.org/cover/11709279/, which has been applied
into 5.9/scsi-fixes. But they are not apppiled in the 5.9/scsi-queue.

Maybe you should rebase your patch from scsi-fixes branch. or do you
have another better option?

Thanks,
Bean

On Mon, 2020-08-24 at 19:07 -0700, Can Guo wrote:
> To recovery non-fatal errors, no full reset is required, err_handler
> only
> clears those pending TRs/TMRs so that scsi layer can re-issue them.
> In
> current err_handler, TRs are directly cleared from UFS host's
> doorbell but
> not aborted from device side. However, according to the UFSHCI JEDEC
> spec,
> the host software shall use UTP Transfer Request List CLear Register
> to
> clear a task from UFS host's doorbell only when a UTP Transfer
> Request is
> expected to not be completed, e.g. when the host software receives a
> “FUNCTION COMPLETE” Task Management response which means a Transfer
> Request
> was aborted. To follow the UFSHCI JEDEC spec, in err_handler, aborts
> one TR
> before clearing it from doorbell.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 143 ++++++++++++++++++++++++++--------
> ------------
>  1 file changed, 81 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b8441ad..000895f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -235,6 +235,7 @@ static int ufshcd_setup_hba_vreg(struct ufs_hba
> *hba, bool on);
>  static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
>  static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
>  					 struct ufs_vreg *vreg);
> +static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
>  static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
>  static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
>  static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
> @@ -5657,8 +5658,8 @@ static void ufshcd_err_handler(struct
> work_struct *work)
>  {
>  	struct ufs_hba *hba;
>  	unsigned long flags;
> -	u32 err_xfer = 0;
> -	u32 err_tm = 0;
> +	bool err_xfer = false;
> +	bool err_tm = false;
>  	int err = 0;
>  	int tag;
>  	bool needs_reset = false;
> @@ -5734,7 +5735,7 @@ static void ufshcd_err_handler(struct
> work_struct *work)
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	/* Clear pending transfer requests */
>  	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
> -		if (ufshcd_clear_cmd(hba, tag)) {
> +		if (ufshcd_try_to_abort_task(hba, tag)) {
>  			err_xfer = true;
>  			goto lock_skip_pending_xfer_clear;
>  		}
> @@ -6486,7 +6487,7 @@ static void ufshcd_set_req_abort_skip(struct
> ufs_hba *hba, unsigned long bitmap)
>  }
>  
>  /**
> - * ufshcd_abort - abort a specific command
> + * ufshcd_try_to_abort_task - abort a specific task
>   * @cmd: SCSI command pointer
>   *
>   * Abort the pending command in device by sending UFS_ABORT_TASK
> task management
> @@ -6495,6 +6496,80 @@ static void ufshcd_set_req_abort_skip(struct
> ufs_hba *hba, unsigned long bitmap)
>   * issued. To avoid that, first issue UFS_QUERY_TASK to check if the
> command is
>   * really issued and then try to abort it.
>   *
> + * Returns zero on success, non-zero on failure
> + */
> +static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
> +{
> +	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
> +	int err = 0;
> +	int poll_cnt;
> +	u8 resp = 0xF;
> +	u32 reg;
> +
> +	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
> +		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp-
> >task_tag,
> +				UFS_QUERY_TASK, &resp);
> +		if (!err && resp ==
> UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
> +			/* cmd pending in the device */
> +			dev_err(hba->dev, "%s: cmd pending in the
> device. tag = %d\n",
> +				__func__, tag);
> +			break;
> +		} else if (!err && resp ==
> UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> +			/*
> +			 * cmd not pending in the device, check if it
> is
> +			 * in transition.
> +			 */
> +			dev_err(hba->dev, "%s: cmd at tag %d not
> pending in the device.\n",
> +				__func__, tag);
> +			reg = ufshcd_readl(hba,
> REG_UTP_TRANSFER_REQ_DOOR_BELL);
> +			if (reg & (1 << tag)) {
> +				/* sleep for max. 200us to stabilize */
> +				usleep_range(100, 200);
> +				continue;
> +			}
> +			/* command completed already */
> +			dev_err(hba->dev, "%s: cmd at tag %d
> successfully cleared from DB.\n",
> +				__func__, tag);
> +			goto out;
> +		} else {
> +			dev_err(hba->dev,
> +				"%s: no response from device. tag = %d,
> err %d\n",
> +				__func__, tag, err);
> +			if (!err)
> +				err = resp; /* service response error
> */
> +			goto out;
> +		}
> +	}
> +
> +	if (!poll_cnt) {
> +		err = -EBUSY;
> +		goto out;
> +	}
> +
> +	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
> +			UFS_ABORT_TASK, &resp);
> +	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> +		if (!err) {
> +			err = resp; /* service response error */
> +			dev_err(hba->dev, "%s: issued. tag = %d, err
> %d\n",
> +				__func__, tag, err);
> +		}
> +		goto out;
> +	}
> +
> +	err = ufshcd_clear_cmd(hba, tag);
> +	if (err)
> +		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d,
> err %d\n",
> +			__func__, tag, err);
> +
> +out:
> +	return err;
> +}
> +
> +/**
> + * ufshcd_abort - scsi host template eh_abort_handler callback
> + * @cmd: SCSI command pointer
> + *
>   * Returns SUCCESS/FAILED
>   */
>  static int ufshcd_abort(struct scsi_cmnd *cmd)
> @@ -6504,8 +6579,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	unsigned long flags;
>  	unsigned int tag;
>  	int err = 0;
> -	int poll_cnt;
> -	u8 resp = 0xF;
>  	struct ufshcd_lrb *lrbp;
>  	u32 reg;
>  
> @@ -6574,63 +6647,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		goto out;
>  	}
>  
> -	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
> -		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp-
> >task_tag,
> -				UFS_QUERY_TASK, &resp);
> -		if (!err && resp ==
> UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
> -			/* cmd pending in the device */
> -			dev_err(hba->dev, "%s: cmd pending in the
> device. tag = %d\n",
> -				__func__, tag);
> -			break;
> -		} else if (!err && resp ==
> UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> -			/*
> -			 * cmd not pending in the device, check if it
> is
> -			 * in transition.
> -			 */
> -			dev_err(hba->dev, "%s: cmd at tag %d not
> pending in the device.\n",
> -				__func__, tag);
> -			reg = ufshcd_readl(hba,
> REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -			if (reg & (1 << tag)) {
> -				/* sleep for max. 200us to stabilize */
> -				usleep_range(100, 200);
> -				continue;
> -			}
> -			/* command completed already */
> -			dev_err(hba->dev, "%s: cmd at tag %d
> successfully cleared from DB.\n",
> -				__func__, tag);
> -			goto out;
> -		} else {
> -			dev_err(hba->dev,
> -				"%s: no response from device. tag = %d,
> err %d\n",
> -				__func__, tag, err);
> -			if (!err)
> -				err = resp; /* service response error
> */
> -			goto out;
> -		}
> -	}
> -
> -	if (!poll_cnt) {
> -		err = -EBUSY;
> -		goto out;
> -	}
> -
> -	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
> -			UFS_ABORT_TASK, &resp);
> -	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> -		if (!err) {
> -			err = resp; /* service response error */
> -			dev_err(hba->dev, "%s: issued. tag = %d, err
> %d\n",
> -				__func__, tag, err);
> -		}
> -		goto out;
> -	}
> -
> -	err = ufshcd_clear_cmd(hba, tag);
> -	if (err) {
> -		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d,
> err %d\n",
> -			__func__, tag, err);
> +	err = ufshcd_try_to_abort_task(hba, tag);
> +	if (err)
>  		goto out;
> -	}
>  
>  	spin_lock_irqsave(host->host_lock, flags);
>  	__ufshcd_transfer_req_compl(hba, (1UL << tag));

