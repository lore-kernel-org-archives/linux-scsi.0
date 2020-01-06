Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77C8C33C9B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 17:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74ADF2146E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 17:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="JM3oXppf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgAFRpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 12:45:34 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:58930 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbgAFRpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 12:45:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578332732; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=aE88VHpKzshop14jt/7qVz5iKKzIOcAtFxm19yTXAyw=;
 b=JM3oXppf9CO5AUp2Zw4PzWb/pFqV7m8fBosbeja2U3ak8b+PuG85z2GZBJaQMW1DQSJ70xsl
 nQiMYJPKsP9xSwvN+6JFCXEjd3Ohz0iUJh73j0T/CNSom8A8kGGhNOO/fkFpjpyg4oyv60a8
 lUBXRiuOduCC/Fu33PIoS230N6c=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e137238.7f95a7fb9810-smtp-out-n03;
 Mon, 06 Jan 2020 17:45:28 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 18EF4C447B4; Mon,  6 Jan 2020 17:45:27 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 00987C433A2;
        Mon,  6 Jan 2020 17:45:25 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 06 Jan 2020 09:45:25 -0800
From:   asutoshd@codeaurora.org
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        linux-scsi-owner@vger.kernel.org
Subject: Re: [PATCH v2 1/2] scsi: ufs: pass device information to
 apply_dev_quirks
In-Reply-To: <1578270431-9873-2-git-send-email-stanley.chu@mediatek.com>
References: <1578270431-9873-1-git-send-email-stanley.chu@mediatek.com>
 <1578270431-9873-2-git-send-email-stanley.chu@mediatek.com>
Message-ID: <5eafff63c1c2e4ca6fdaf2d349a74dac@codeaurora.org>
X-Sender: asutoshd@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-05 16:27, Stanley Chu wrote:
> Pass UFS device information to vendor-specific variant callback
> "apply_dev_quirks" because some platform vendors need to know such
> information to apply special handlings or quirks in specific devices.
> 
> In the same time, modify existed vendor implementation according to
> the new interface.
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Matthias Brugger <matthias.bgg@gmail.com>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 3 ++-
>  drivers/scsi/ufs/ufshcd.c   | 5 +++--
>  drivers/scsi/ufs/ufshcd.h   | 7 ++++---
>  3 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index c69c29a1ceb9..ebb5c66e069f 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -949,7 +949,8 @@ static int
> ufs_qcom_quirk_host_pa_saveconfigtime(struct ufs_hba *hba)
>  	return err;
>  }
> 
> -static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hba)
> +static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hba,
> +				     struct ufs_dev_desc *card)
>  {
>  	int err = 0;
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1b97f2dc0b63..9abf0ea8c308 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6803,7 +6803,8 @@ static int
> ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
>  	return ret;
>  }
> 
> -static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
> +static void ufshcd_tune_unipro_params(struct ufs_hba *hba,
> +				      struct ufs_dev_desc *card)
>  {
>  	if (ufshcd_is_unipro_pa_params_tuning_req(hba)) {
>  		ufshcd_tune_pa_tactivate(hba);
> @@ -6817,7 +6818,7 @@ static void ufshcd_tune_unipro_params(struct 
> ufs_hba *hba)
>  	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
>  		ufshcd_quirk_tune_host_pa_tactivate(hba);
> 
> -	ufshcd_vops_apply_dev_quirks(hba);
> +	ufshcd_vops_apply_dev_quirks(hba, card);
>  }
> 
>  static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index e05cafddc87b..4f3fa71303da 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -320,7 +320,7 @@ struct ufs_hba_variant_ops {
>  	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
>  	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
>  					enum ufs_notify_change_status);
> -	int	(*apply_dev_quirks)(struct ufs_hba *);
> +	int	(*apply_dev_quirks)(struct ufs_hba *, struct ufs_dev_desc *);
>  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>  	void	(*dbg_register_dump)(struct ufs_hba *hba);
> @@ -1052,10 +1052,11 @@ static inline void
> ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
>  		return hba->vops->hibern8_notify(hba, cmd, status);
>  }
> 
> -static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
> +static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba,
> +					       struct ufs_dev_desc *card)
>  {
>  	if (hba->vops && hba->vops->apply_dev_quirks)
> -		return hba->vops->apply_dev_quirks(hba);
> +		return hba->vops->apply_dev_quirks(hba, card);
>  	return 0;
>  }

Please separate the vendor code (ufs-qcom, in this case) to a separate 
patch.

-asd
