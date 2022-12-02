Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D7DC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 07:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiLBHkB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 02:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLBHj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 02:39:59 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3337AD98E
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 23:39:58 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id f9so3743577pgf.7
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 23:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EKdJy8iwYIrzA6eUcHS1xN++4Pj6b6rZ6Y+yBBYokW8=;
        b=Uw1oClizcn3XTQesSOqhOmB5uui3mQLM2nfnZLp7ch36IdWnVz33clXfk4pw4FoI/W
         XMkc7MJawfHhIBKsjA0b/bl1oSzxHbPhekaCKF/HdvEi+2F6lZ+R7V/YtSU/EtzoDwtv
         yFXYWYBmMWAPn/yQGpLx+AtN48qzfQA4/InfnhgC1EMYmzfSpJdu1x19LCBWOgXh2yp7
         IKui+F7vxprrEQ3XXvuyZgrTyDanXVjL0VI3Q1l+MTQLdB+UfSj7blpsnLxlK7IDS/ul
         M+dOR4h8DD9s3wn9qRi+N1ZmPnV7oKxB8TNvZkNJgVfNGNISX/ECEeyP4enPo8A5dvCJ
         HLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKdJy8iwYIrzA6eUcHS1xN++4Pj6b6rZ6Y+yBBYokW8=;
        b=bkV+j9uRC4uZoMeWpdlFGwRjuODqybf3imELlAN5MMc+sJmiW2bCfq9XqPaRfIJUTI
         Q97TWC6z6CTC5aBCDlc1XmY/1F5aAa7Lea/KuVoHXq88iZL5j/k6LHr1LO80cJ1m5Og1
         QXqREGplGJktkWzadq1Zh/a0vRxjEjH369Q07HdKRDU2GwxntNJMakSTaDKarSgpfwM5
         7paa9trkTja67mCpD9MWqkQISzX0k0GwPZhtMHWZWbI7pHeLyksZXwOmE/mBt//iX25r
         bO60UsHoTkreYTznG07ruNbB1FBKj/CEIUodkIEr4NbMcXbuZgqWtpr4LSYPtY3n9g6h
         dw+w==
X-Gm-Message-State: ANoB5plDPVAi0ooQNHcgKAzETkowge0wPZS8heVasfrFaSxm2zhs75wI
        OvUpmhBBbDEcJw7SX/9yUC8iIOrSgMxrwAQ=
X-Google-Smtp-Source: AA0mqf4RHtpfIlj5JeeEw6Da3Yq5R9fgzfWHMLyg5+ZY64vcJqKkS0zVLdyfP/r8TE+O0RRrfjgcOw==
X-Received: by 2002:a62:840b:0:b0:575:2199:70e8 with SMTP id k11-20020a62840b000000b00575219970e8mr25115627pfd.14.1669966798480;
        Thu, 01 Dec 2022 23:39:58 -0800 (PST)
Received: from thinkpad ([27.111.75.154])
        by smtp.gmail.com with ESMTPSA id bd12-20020a170902830c00b001894198d0ebsm4849251plb.24.2022.12.01.23.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 23:39:57 -0800 (PST)
Date:   Fri, 2 Dec 2022 13:09:51 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     andersson@kernel.org, agross@kernel.org, konrad.dybcio@linaro.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        p.zabel@pengutronix.de, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: ufs: ufs-qcom: Remove usage of dbg_print_en
Message-ID: <20221202073951.GD5356@thinkpad>
References: <20221201230810.1019834-1-ahalaney@redhat.com>
 <20221201230810.1019834-4-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221201230810.1019834-4-ahalaney@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 01, 2022 at 05:08:09PM -0600, Andrew Halaney wrote:
> This bitmask is unconditionally set in the current driver,
> so all conditionals using it can be considered bit rot.
> 
> Let's take the current default conditional path everywhere and remove
> dbg_print_en from the driver.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  drivers/ufs/host/ufs-qcom.c | 18 +++---------------
>  drivers/ufs/host/ufs-qcom.h | 11 -----------
>  2 files changed, 3 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 1b0dfbbdcdf3..b1fcff1fad0c 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -22,9 +22,6 @@
>  #include <ufs/ufshci.h>
>  #include <ufs/ufs_quirks.h>
>  
> -#define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
> -	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
> -
>  enum {
>  	TSTBUS_UAWM,
>  	TSTBUS_UARM,
> @@ -1040,7 +1037,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	if (hba->dev->id < MAX_UFS_QCOM_HOSTS)
>  		ufs_qcom_hosts[hba->dev->id] = host;
>  
> -	host->dbg_print_en |= UFS_QCOM_DEFAULT_DBG_PRINT_EN;
>  	ufs_qcom_get_default_testbus_cfg(host);
>  	err = ufs_qcom_testbus_config(host);
>  	if (err) {
> @@ -1191,14 +1187,9 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba,
>  
>  static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
>  {
> -	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN) {
> -		ufshcd_rmwl(host->hba, UFS_REG_TEST_BUS_EN,
> -				UFS_REG_TEST_BUS_EN, REG_UFS_CFG1);
> -		ufshcd_rmwl(host->hba, TEST_BUS_EN, TEST_BUS_EN, REG_UFS_CFG1);
> -	} else {
> -		ufshcd_rmwl(host->hba, UFS_REG_TEST_BUS_EN, 0, REG_UFS_CFG1);
> -		ufshcd_rmwl(host->hba, TEST_BUS_EN, 0, REG_UFS_CFG1);
> -	}
> +	ufshcd_rmwl(host->hba, UFS_REG_TEST_BUS_EN,
> +			UFS_REG_TEST_BUS_EN, REG_UFS_CFG1);
> +	ufshcd_rmwl(host->hba, TEST_BUS_EN, TEST_BUS_EN, REG_UFS_CFG1);
>  }
>  
>  static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host)
> @@ -1315,9 +1306,6 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
>  	ufshcd_dump_regs(hba, REG_UFS_SYS1CLK_1US, 16 * 4,
>  			 "HCI Vendor Specific Registers ");
>  
> -	if (!(host->dbg_print_en & UFS_QCOM_DBG_PRINT_REGS_EN))
> -		return;
> -
>  	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_REG_OCSC);
>  	ufshcd_dump_regs(hba, reg, 44 * 4, "UFS_UFS_DBG_RD_REG_OCSC ");
>  
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index 44466a395bb5..e567e4636357 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -113,15 +113,6 @@ enum {
>  	MASK_CLK_NS_REG                     = 0xFFFC00,
>  };
>  
> -/* QCOM UFS debug print bit mask */
> -#define UFS_QCOM_DBG_PRINT_REGS_EN	BIT(0)
> -#define UFS_QCOM_DBG_PRINT_ICE_REGS_EN	BIT(1)
> -#define UFS_QCOM_DBG_PRINT_TEST_BUS_EN	BIT(2)
> -
> -#define UFS_QCOM_DBG_PRINT_ALL	\
> -	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_ICE_REGS_EN | \
> -	 UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
> -
>  /* QUniPro Vendor specific attributes */
>  #define PA_VS_CONFIG_REG1	0x9000
>  #define DME_VS_CORE_CLK_CTRL	0xD002
> @@ -212,8 +203,6 @@ struct ufs_qcom_host {
>  
>  	u32 dev_ref_clk_en_mask;
>  
> -	/* Bitmask for enabling debug prints */
> -	u32 dbg_print_en;
>  	struct ufs_qcom_testbus testbus;
>  
>  	/* Reset control of HCI */
> -- 
> 2.38.1
> 

-- 
மணிவண்ணன் சதாசிவம்
