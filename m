Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7B5C71155
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 05:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C92921527
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 05:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgLCFti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 00:49:38 -0500
Received: from m42-5.mailgun.net ([69.72.42.5]:53542 "EHLO m42-5.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbgLCFti (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Dec 2020 00:49:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606974554; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=NJ4IfsZbGPDKNl9KMbMJltvvUnRSFPpja3eddaNzntw=;
 b=Ecg/zk/Dp5a+h95QCbj33cObW7X548ojGR6swgmFtDJNnZAbCZuRDen1D6x+FwB99IsL6eIy
 Umruqij0pnVLPwMs6I8f2cHqvjRqBHmDmqBCv9EuPTWg3fzBk75UgRETHb2O9JzA9l/jNNnD
 YzqgPUf4cZJc/rjP0tQQzJgSDyM=
X-Mailgun-Sending-Ip: 69.72.42.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5fc87c53a1906b87a6a0d6a0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Dec 2020 05:49:07
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5A309C43463; Thu,  3 Dec 2020 05:49:06 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5AFD3C433C6;
        Thu,  3 Dec 2020 05:49:05 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Dec 2020 13:49:05 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com,
        huadian.liu@mediatek.com
Subject: Re: [PATCH v1 3/3] scsi: ufs: Introduce notify_event variant function
In-Reply-To: <20201126053839.25889-4-stanley.chu@mediatek.com>
References: <20201126053839.25889-1-stanley.chu@mediatek.com>
 <20201126053839.25889-4-stanley.chu@mediatek.com>
Message-ID: <b8d2d4e45e1738865925de17d53dcaa7@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-26 13:38, Stanley Chu wrote:
> Introduce notify_event variant function to allow
> vendor to get notified of important events and connect
> to any proprietary debugging facilities.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |  2 ++
>  drivers/scsi/ufs/ufshcd.h | 11 +++++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 7194bed1f10b..63fe37e1c908 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4484,6 +4484,8 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba,
> u32 id, u32 val)
>  	e->val[e->pos] = val;
>  	e->tstamp[e->pos] = ktime_get();
>  	e->pos = (e->pos + 1) % UFS_EVENT_HIST_LENGTH;
> +
> +	ufshcd_vops_notify_event(hba, id, &val);
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 82c2fc5597bb..a81ca36c1715 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -317,6 +317,7 @@ struct ufs_pwr_mode_info {
>   * @phy_initialization: used to initialize phys
>   * @device_reset: called to issue a reset pulse on the UFS device
>   * @program_key: program or evict an inline encryption key
> + * @notify_event: called to notify important events
>   */
>  struct ufs_hba_variant_ops {
>  	const char *name;
> @@ -352,6 +353,8 @@ struct ufs_hba_variant_ops {
>  					void *data);
>  	int	(*program_key)(struct ufs_hba *hba,
>  			       const union ufs_crypto_cfg_entry *cfg, int slot);
> +	void	(*notify_event)(struct ufs_hba *hba,
> +				enum ufs_event_type evt, void *data);
>  };
> 
>  /* clock gating state  */
> @@ -1097,6 +1100,14 @@ static inline int
> ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
>  	return 0;
>  }
> 
> +static inline void ufshcd_vops_notify_event(struct ufs_hba *hba,
> +					    enum ufs_event_type evt,
> +					    void *data)
> +{
> +	if (hba->vops && hba->vops->notify_event)
> +		hba->vops->notify_event(hba, evt, data);
> +}
> +
>  static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool 
> on,
>  					enum ufs_notify_change_status status)
>  {

Reviewed-by: Can Guo <cang@codeaurora.org>
