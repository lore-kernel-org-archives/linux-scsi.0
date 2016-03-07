From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v6 17/17] scsi: ufs-qcom: add printouts of testbus debug
 registers
Date: Mon, 7 Mar 2016 08:54:52 -0000
Message-ID: <c05ebfc933b93abfd0b2b3b115dbf5df.squirrel@us.codeaurora.org>
References: <1457265358-31635-1-git-send-email-ygardi@codeaurora.org>
    <1457265358-31635-18-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60910 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbcCGIyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 03:54:54 -0500
In-Reply-To: <1457265358-31635-18-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>

> This change adds printouts of testbus and debug registers.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 77
> +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-qcom.h |  9 ++++++
>  2 files changed, 86 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 849fcf3..3aedf73 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -58,6 +58,12 @@ static void ufs_qcom_dump_regs(struct ufs_hba *hba, int
> offset, int len,
>  			len * 4, false);
>  }
>
> +static void ufs_qcom_dump_regs_wrapper(struct ufs_hba *hba, int offset,
> int len,
> +		char *prefix, void *priv)
> +{
> +	ufs_qcom_dump_regs(hba, offset, len, prefix);
> +}
> +
>  static int ufs_qcom_get_connected_tx_lanes(struct ufs_hba *hba, u32
> *tx_lanes)
>  {
>  	int err = 0;
> @@ -1397,6 +1403,74 @@ out:
>  	return err;
>  }
>
> +static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
> +		void *priv, void (*print_fn)(struct ufs_hba *hba,
> +		int offset, int num_regs, char *str, void *priv))
> +{
> +	u32 reg;
> +	struct ufs_qcom_host *host;
> +
> +	if (unlikely(!hba)) {
> +		pr_err("%s: hba is NULL\n", __func__);
> +		return;
> +	}
> +	if (unlikely(!print_fn)) {
> +		dev_err(hba->dev, "%s: print_fn is NULL\n", __func__);
> +		return;
> +	}
> +
> +	host = ufshcd_get_variant(hba);
> +	if (!(host->dbg_print_en & UFS_QCOM_DBG_PRINT_REGS_EN))
> +		return;
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_REG_OCSC);
> +	print_fn(hba, reg, 44, "UFS_UFS_DBG_RD_REG_OCSC ", priv);
> +
> +	reg = ufshcd_readl(hba, REG_UFS_CFG1);
> +	reg |= UFS_BIT(17);
> +	ufshcd_writel(hba, reg, REG_UFS_CFG1);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_EDTL_RAM);
> +	print_fn(hba, reg, 32, "UFS_UFS_DBG_RD_EDTL_RAM ", priv);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_DESC_RAM);
> +	print_fn(hba, reg, 128, "UFS_UFS_DBG_RD_DESC_RAM ", priv);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_PRDT_RAM);
> +	print_fn(hba, reg, 64, "UFS_UFS_DBG_RD_PRDT_RAM ", priv);
> +
> +	ufshcd_writel(hba, (reg & ~UFS_BIT(17)), REG_UFS_CFG1);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_UAWM);
> +	print_fn(hba, reg, 4, "UFS_DBG_RD_REG_UAWM ", priv);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_UARM);
> +	print_fn(hba, reg, 4, "UFS_DBG_RD_REG_UARM ", priv);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TXUC);
> +	print_fn(hba, reg, 48, "UFS_DBG_RD_REG_TXUC ", priv);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_RXUC);
> +	print_fn(hba, reg, 27, "UFS_DBG_RD_REG_RXUC ", priv);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_DFC);
> +	print_fn(hba, reg, 19, "UFS_DBG_RD_REG_DFC ", priv);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TRLUT);
> +	print_fn(hba, reg, 34, "UFS_DBG_RD_REG_TRLUT ", priv);
> +
> +	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TMRLUT);
> +	print_fn(hba, reg, 9, "UFS_DBG_RD_REG_TMRLUT ", priv);
> +}
> +
> +static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
> +{
> +	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
> +		ufshcd_rmwl(host->hba, TEST_BUS_EN, TEST_BUS_EN, REG_UFS_CFG1);
> +	else
> +		ufshcd_rmwl(host->hba, TEST_BUS_EN, 0, REG_UFS_CFG1);
> +}
> +
>  static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host)
>  {
>  	/* provide a legal default configuration */
> @@ -1505,6 +1579,7 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host
> *host)
>  	ufshcd_rmwl(host->hba, mask,
>  		    (u32)host->testbus.select_minor << offset,
>  		    reg);
> +	ufs_qcom_enable_test_bus(host);
>  	ufshcd_release(host->hba);
>  	pm_runtime_put_sync(host->hba->dev);
>
> @@ -1521,8 +1596,10 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba
> *hba)
>  	ufs_qcom_dump_regs(hba, REG_UFS_SYS1CLK_1US, 16,
>  			"HCI Vendor Specific Registers ");
>
> +	ufs_qcom_print_hw_debug_reg_all(hba, NULL, ufs_qcom_dump_regs_wrapper);
>  	ufs_qcom_testbus_read(hba);
>  }
> +
>  /**
>   * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
>   *
> diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
> index 36249b3..a19307a 100644
> --- a/drivers/scsi/ufs/ufs-qcom.h
> +++ b/drivers/scsi/ufs/ufs-qcom.h
> @@ -241,6 +241,15 @@ struct ufs_qcom_host {
>  	struct ufs_qcom_testbus testbus;
>  };
>
> +static inline u32
> +ufs_qcom_get_debug_reg_offset(struct ufs_qcom_host *host, u32 reg)
> +{
> +	if (host->hw_ver.major <= 0x02)
> +		return UFS_CNTLR_2_x_x_VEN_REGS_OFFSET(reg);
> +
> +	return UFS_CNTLR_3_x_x_VEN_REGS_OFFSET(reg);
> +};
> +
>  #define ufs_qcom_is_link_off(hba) ufshcd_is_link_off(hba)
>  #define ufs_qcom_is_link_active(hba) ufshcd_is_link_active(hba)
>  #define ufs_qcom_is_link_hibern8(hba) ufshcd_is_link_hibern8(hba)
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

