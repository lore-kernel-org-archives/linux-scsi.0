Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C94C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 11:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 744A82312D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 11:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgLVLfE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 06:35:04 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:13229 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbgLVLfE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 06:35:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608636878; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=CGuxgbpv0qWFddC98LkeZGfeYaVURHqEjzHXuReTvxw=;
 b=OOKFx9mzMdHZDnxvqNyWCeQOXhA5NO89qi20/roGIeebdxkCxtBTHytLwoJiYqBMufp6hfei
 GXtpjLVrnyeYHGQtVkAvspGPtUh5sWhP5knGUlzPmvveRH1Anj0+kmqIpwhO1CrzE5liuwqO
 p3gYA1UPQ2UGdHPybx+bO6vfovM=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fe1d9af6d011aad668d2a0b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 11:34:07
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 54ED1C43464; Tue, 22 Dec 2020 11:34:07 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 49C85C433C6;
        Tue, 22 Dec 2020 11:34:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 22 Dec 2020 19:34:06 +0800
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
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Subject: Re: [PATCH v2 2/2] scsi: ufs: Relax the condition of
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
In-Reply-To: <20201222072905.32221-3-stanley.chu@mediatek.com>
References: <20201222072905.32221-1-stanley.chu@mediatek.com>
 <20201222072905.32221-3-stanley.chu@mediatek.com>
Message-ID: <948718782f2a1f82b3c6de964a37f8ac@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-22 15:29, Stanley Chu wrote:
> UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL is aimed to skip enabling
> fWriteBoosterBufferFlushEn while WriteBooster is initializing.
> Therefore it is better to apply the checking during WriteBooster
> initialization only.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9d61dc3eb842..e50b19925236 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -289,7 +289,8 @@ static inline void ufshcd_wb_config(struct ufs_hba 
> *hba)
>  	if (ret)
>  		dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
>  			__func__, ret);
> -	ufshcd_wb_toggle_flush(hba, true);
> +	if (!(hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL))
> +		ufshcd_wb_toggle_flush(hba, true);
>  }
> 
>  static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
> @@ -5401,9 +5402,6 @@ static int
> ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
> 
>  static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool 
> enable)
>  {
> -	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
> -		return;
> -
>  	if (enable)
>  		ufshcd_wb_buf_flush_enable(hba);
>  	else

Thanks for the change, I was thinking about the same.

Reviewed-by: Can Guo <cang@codeaurora.org>
