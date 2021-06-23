Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D12C4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ACED6128C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFWHpG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 03:45:06 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:31101 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230002AbhFWHpD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 03:45:03 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624434166; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=SuVj6NDe+l0W6pRpz+jBa82A/gkCm4/qg0J6I1eppKY=;
 b=H840gUn3oWQbQDen0Y7sV7hklSpGA95wv7OkUAd7y7W7vNM9JGaLkGzzWL1GmSZ4O3PXLqYq
 XnOaghN9z94Y1oc2RUZ0d+OFAGIHzanjTvMx0hlSq2J+ERxSg14QSry/mOhKdPTvKt4b2x3S
 RfjmL85injtNfKrmh7MhRC26Z4E=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60d2e5f2dc4628fe7e0b3810 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Jun 2021 07:42:42
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EA654C43145; Wed, 23 Jun 2021 07:42:41 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B5BA5C433F1;
        Wed, 23 Jun 2021 07:42:40 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Jun 2021 15:42:40 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH RFC 3/4] ufs: Improve static type checking for the host
 controller state
In-Reply-To: <20210619005228.28569-4-bvanassche@acm.org>
References: <20210619005228.28569-1-bvanassche@acm.org>
 <20210619005228.28569-4-bvanassche@acm.org>
Message-ID: <1b508ae21e3c81c690a8b875b8ed84b3@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-19 08:52, Bart Van Assche wrote:
> Assign a name to the enumeration type for UFS host controller states 
> and
> remove the default clause from switch statements on this enumeration 
> type
> to make the compiler warn about unhandled enumeration labels.
> 
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 15 ---------------
>  drivers/scsi/ufs/ufshcd.h | 25 +++++++++++++++++++++++--
>  2 files changed, 23 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 71c720d940a3..c213daec20f7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -128,15 +128,6 @@ enum {
>  	UFSHCD_CAN_QUEUE	= 32,
>  };
> 
> -/* UFSHCD states */
> -enum {
> -	UFSHCD_STATE_RESET,
> -	UFSHCD_STATE_ERROR,
> -	UFSHCD_STATE_OPERATIONAL,
> -	UFSHCD_STATE_EH_SCHEDULED_FATAL,
> -	UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
> -};
> -
>  /* UFSHCD error handling flags */
>  enum {
>  	UFSHCD_EH_IN_PROGRESS = (1 << 0),
> @@ -2738,12 +2729,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  		set_host_byte(cmd, DID_ERROR);
>  		cmd->scsi_done(cmd);
>  		goto out;
> -	default:
> -		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
> -				__func__, hba->ufshcd_state);
> -		set_host_byte(cmd, DID_BAD_TARGET);
> -		cmd->scsi_done(cmd);
> -		goto out;
>  	}
> 
>  	hba->req_abort_count = 0;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index c98d540ac044..f2796ea25598 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -476,6 +476,27 @@ struct ufs_stats {
>  	struct ufs_event_hist event[UFS_EVT_CNT];
>  };
> 
> +/**
> + * enum ufshcd_state - UFS host controller state
> + * @UFSHCD_STATE_RESET: Link is not operational. Postpone SCSI command
> + *	processing.
> + * @UFSHCD_STATE_OPERATIONAL: The host controller is operational and
> can process
> + *	SCSI commands.
> + * @UFSHCD_STATE_EH_SCHEDULED_NON_FATAL: The error handler has been 
> scheduled.
> + *	SCSI commands may be submitted to the controller.
> + * @UFSHCD_STATE_EH_SCHEDULED_FATAL: The error handler has been 
> scheduled. Fail
> + *	newly submitted SCSI commands with error code DID_BAD_TARGET.
> + * @UFSHCD_STATE_ERROR: An unrecoverable error occurred, e.g. link 
> recovery
> + *	failed. Fail all SCSI commands with error code DID_ERROR.
> + */
> +enum ufshcd_state {
> +	UFSHCD_STATE_RESET,
> +	UFSHCD_STATE_OPERATIONAL,
> +	UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
> +	UFSHCD_STATE_EH_SCHEDULED_FATAL,
> +	UFSHCD_STATE_ERROR,
> +};
> +

Hi Bart,

FYI, in my error handling update change series, I have one change
(https://lore.kernel.org/patchwork/patch/1450656/) which moves the
enumeration from ufshcd.c to ufshcd.h, which shall conflict with
this one. What shall we do?

Thanks,

Can Guo.

>  enum ufshcd_quirks {
>  	/* Interrupt aggregation support is broken */
>  	UFSHCD_QUIRK_BROKEN_INTR_AGGR			= 1 << 0,
> @@ -687,7 +708,7 @@ struct ufs_hba_monitor {
>   * @tmf_tag_set: TMF tag set.
>   * @tmf_queue: Used to allocate TMF tags.
>   * @pwr_done: completion for power mode change
> - * @ufshcd_state: UFSHCD states
> + * @ufshcd_state: UFSHCD state
>   * @eh_flags: Error handling flags
>   * @intr_mask: Interrupt Mask Bits
>   * @ee_ctrl_mask: Exception event control mask
> @@ -785,7 +806,7 @@ struct ufs_hba {
>  	struct mutex uic_cmd_mutex;
>  	struct completion *uic_async_done;
> 
> -	u32 ufshcd_state;
> +	enum ufshcd_state ufshcd_state;
>  	u32 eh_flags;
>  	u32 intr_mask;
>  	u16 ee_ctrl_mask; /* Exception event mask */
