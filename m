Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E49EC4167B
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 07:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiLBHic (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 02:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiLBHi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 02:38:29 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BA5A7AA1
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 23:38:26 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id h193so3725181pgc.10
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 23:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LnoX7NMS749gHaHaMrlO+RqnODlHQ21OO457WlTgAcw=;
        b=HsJTbbg8xWv9wCDADe4WPc6sNNK/QYEpjFVaIE+lN+AsiHupKUSNfq5P3DejWmqvGP
         g1jBlr9qqom6077HCYBYKI+NwUZ6JQ1nbFqHvQsVzH2NuTNRR8Yykc4VKTHPPGYp6b1Q
         oQhSyxgIopIXhsUlbnVOU8mqA77jHmcPqL9lGjPw2YStKQZNwzgE5VNRCTphQDb7Fj6P
         WNaYBk7Q2PtKvgi8geWafakpisAPammljleADgiOaXSjk1QV2DPPAWD0ovIIOUSRMOij
         qQ1arhbdecZ6F2DoI/78DYvvEAnmGpN3nRq5uZLUjbHplF9QbouSPlGnkfcCQMyrkClo
         PKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LnoX7NMS749gHaHaMrlO+RqnODlHQ21OO457WlTgAcw=;
        b=GQYoqDKw/mQwNvgUB7Ox5U2XDgwEyq6vz8oPTchSjf3fw3yBmskoN/8GKhz8oIu5kT
         MNW/cCkesgOQwbpGvFeynAYLXFMUXxFFY35EQJtkDO47+KDGKoREdmmkXvElaAmT2iH7
         clw84wise8NSsBYYSFg6XopNppgF+SS0nj0x++AREq1w1Mk3l2ddrhb1Crxm4rEj2XIW
         zkuPowTEOECJlmD2ccI6/ZuUNqFXzBoD1+F9eJ7B/ULejFdCBAyIacJm06szMdWdeaxf
         7ZFoT9qMsJAVDOPVpsOczHKlCCAg2skXtc6SEjfCyIbV/W5PUvKH2VTF6tRXWddith0N
         0ZMg==
X-Gm-Message-State: ANoB5pnWwqeMNfL2vbVuqAvYD7dffg/spCCBVk9u+ScGr2iX58W7vObu
        ePSF1NutGs2aVWA29SGOG9lb
X-Google-Smtp-Source: AA0mqf7ofvd8rwhX7cwm0rlBmMIbFlWCCL+4agMbRIN3/Fa5JM0r79jIXgmE+szlXkgCHmB9H+Ecdw==
X-Received: by 2002:a62:687:0:b0:56e:924e:ee22 with SMTP id 129-20020a620687000000b0056e924eee22mr51493018pfg.34.1669966705977;
        Thu, 01 Dec 2022 23:38:25 -0800 (PST)
Received: from thinkpad ([27.111.75.154])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902e74300b00189988a1a9esm4892588plf.135.2022.12.01.23.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 23:38:25 -0800 (PST)
Date:   Fri, 2 Dec 2022 13:08:18 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     andersson@kernel.org, agross@kernel.org, konrad.dybcio@linaro.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        p.zabel@pengutronix.de, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] scsi: ufs: ufs-qcom: Clean up dbg_register_dump
Message-ID: <20221202073818.GC5356@thinkpad>
References: <20221201230810.1019834-1-ahalaney@redhat.com>
 <20221201230810.1019834-3-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221201230810.1019834-3-ahalaney@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 01, 2022 at 05:08:08PM -0600, Andrew Halaney wrote:
> The current implementation has abstractions that don't give any
> benefits.
> 
> The print_fn callback (and its only callback implementation,
> ufs_qcom_dump_regs_wrapper()) was only used by
> ufs_qcom_print_hw_debug_reg_all() and just multiplies len by 4
> before calling ufshcd_dump_regs().
> 
> ufs_qcom_print_hw_debug_reg_all() is only called by
> ufs_qcom_dump_dbg_regs().
> 
> There's no real gain in those abstractions, so let's just do the work
> directly in ufs_qcom_dump_dbg_regs() (the dbg_register_dump callback).
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  drivers/ufs/host/ufs-qcom.c | 106 ++++++++++++++++--------------------
>  1 file changed, 47 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 70e25f9f8ca8..1b0dfbbdcdf3 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -52,12 +52,6 @@ static struct ufs_qcom_host *rcdev_to_ufs_host(struct reset_controller_dev *rcd)
>  	return container_of(rcd, struct ufs_qcom_host, rcdev);
>  }
>  
> -static void ufs_qcom_dump_regs_wrapper(struct ufs_hba *hba, int offset, int len,
> -				       const char *prefix, void *priv)
> -{
> -	ufshcd_dump_regs(hba, offset, len * 4, prefix);
> -}
> -
>  static int ufs_qcom_host_clk_get(struct device *dev,
>  		const char *name, struct clk **clk_out, bool optional)
>  {
> @@ -1195,58 +1189,6 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba,
>  	return err;
>  }
>  
> -static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
> -		void *priv, void (*print_fn)(struct ufs_hba *hba,
> -		int offset, int num_regs, const char *str, void *priv))
> -{
> -	u32 reg;
> -	struct ufs_qcom_host *host;
> -
> -	host = ufshcd_get_variant(hba);
> -	if (!(host->dbg_print_en & UFS_QCOM_DBG_PRINT_REGS_EN))
> -		return;
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_REG_OCSC);
> -	print_fn(hba, reg, 44, "UFS_UFS_DBG_RD_REG_OCSC ", priv);
> -
> -	reg = ufshcd_readl(hba, REG_UFS_CFG1);
> -	reg |= UTP_DBG_RAMS_EN;
> -	ufshcd_writel(hba, reg, REG_UFS_CFG1);
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_EDTL_RAM);
> -	print_fn(hba, reg, 32, "UFS_UFS_DBG_RD_EDTL_RAM ", priv);
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_DESC_RAM);
> -	print_fn(hba, reg, 128, "UFS_UFS_DBG_RD_DESC_RAM ", priv);
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_PRDT_RAM);
> -	print_fn(hba, reg, 64, "UFS_UFS_DBG_RD_PRDT_RAM ", priv);
> -
> -	/* clear bit 17 - UTP_DBG_RAMS_EN */
> -	ufshcd_rmwl(hba, UTP_DBG_RAMS_EN, 0, REG_UFS_CFG1);
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_UAWM);
> -	print_fn(hba, reg, 4, "UFS_DBG_RD_REG_UAWM ", priv);
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_UARM);
> -	print_fn(hba, reg, 4, "UFS_DBG_RD_REG_UARM ", priv);
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TXUC);
> -	print_fn(hba, reg, 48, "UFS_DBG_RD_REG_TXUC ", priv);
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_RXUC);
> -	print_fn(hba, reg, 27, "UFS_DBG_RD_REG_RXUC ", priv);
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_DFC);
> -	print_fn(hba, reg, 19, "UFS_DBG_RD_REG_DFC ", priv);
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TRLUT);
> -	print_fn(hba, reg, 34, "UFS_DBG_RD_REG_TRLUT ", priv);
> -
> -	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TMRLUT);
> -	print_fn(hba, reg, 9, "UFS_DBG_RD_REG_TMRLUT ", priv);
> -}
> -
>  static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
>  {
>  	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN) {
> @@ -1365,10 +1307,56 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
>  
>  static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
>  {
> +	u32 reg;
> +	struct ufs_qcom_host *host;
> +
> +	host = ufshcd_get_variant(hba);
> +
>  	ufshcd_dump_regs(hba, REG_UFS_SYS1CLK_1US, 16 * 4,
>  			 "HCI Vendor Specific Registers ");
>  
> -	ufs_qcom_print_hw_debug_reg_all(hba, NULL, ufs_qcom_dump_regs_wrapper);
> +	if (!(host->dbg_print_en & UFS_QCOM_DBG_PRINT_REGS_EN))
> +		return;
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_REG_OCSC);
> +	ufshcd_dump_regs(hba, reg, 44 * 4, "UFS_UFS_DBG_RD_REG_OCSC ");
> +
> +	reg = ufshcd_readl(hba, REG_UFS_CFG1);
> +	reg |= UTP_DBG_RAMS_EN;
> +	ufshcd_writel(hba, reg, REG_UFS_CFG1);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_EDTL_RAM);
> +	ufshcd_dump_regs(hba, reg, 32 * 4, "UFS_UFS_DBG_RD_EDTL_RAM ");
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_DESC_RAM);
> +	ufshcd_dump_regs(hba, reg, 128 * 4, "UFS_UFS_DBG_RD_DESC_RAM ");
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_PRDT_RAM);
> +	ufshcd_dump_regs(hba, reg, 64 * 4, "UFS_UFS_DBG_RD_PRDT_RAM ");
> +
> +	/* clear bit 17 - UTP_DBG_RAMS_EN */
> +	ufshcd_rmwl(hba, UTP_DBG_RAMS_EN, 0, REG_UFS_CFG1);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_UAWM);
> +	ufshcd_dump_regs(hba, reg, 4 * 4, "UFS_DBG_RD_REG_UAWM ");
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_UARM);
> +	ufshcd_dump_regs(hba, reg, 4 * 4, "UFS_DBG_RD_REG_UARM ");
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TXUC);
> +	ufshcd_dump_regs(hba, reg, 48 * 4, "UFS_DBG_RD_REG_TXUC ");
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_RXUC);
> +	ufshcd_dump_regs(hba, reg, 27 * 4, "UFS_DBG_RD_REG_RXUC ");
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_DFC);
> +	ufshcd_dump_regs(hba, reg, 19 * 4, "UFS_DBG_RD_REG_DFC ");
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TRLUT);
> +	ufshcd_dump_regs(hba, reg, 34 * 4, "UFS_DBG_RD_REG_TRLUT ");
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TMRLUT);
> +	ufshcd_dump_regs(hba, reg, 9 * 4, "UFS_DBG_RD_REG_TMRLUT ");
>  }
>  
>  /**
> -- 
> 2.38.1
> 

-- 
மணிவண்ணன் சதாசிவம்
