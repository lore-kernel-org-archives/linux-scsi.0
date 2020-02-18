Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885F3C3404C
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56706208E4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:58:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Dl763EJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgBRX6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 18:58:01 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11690 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgBRX6A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 18:58:00 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200218235758epoutp01d61ce12ffa0f39ac83147783bc7f4e00~0pIlblQ_R2943229432epoutp01V
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2020 23:57:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200218235758epoutp01d61ce12ffa0f39ac83147783bc7f4e00~0pIlblQ_R2943229432epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1582070279;
        bh=MsbnX2949KZkB9cDTkdoHivI+S/igUyV9JYoG0jjCe0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Dl763EJJiH88/2yzeaKhx5mqRER3OSIGQtp6TpUR8HxZN8u0IlBqJ9oMf+FXwt52B
         dWG7w7aCzZl++OaMM4jvYy7mHFUVN4awrNeDN9Nyuo6s2TEd1PvlvkQBo9e92PW8ci
         vJLYNaoZ04/ksCyx4DgP2nVcsMGFUy9TAUkj04l0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200218235758epcas2p44792c2a10928d7eba8f3414b617beee4~0pIlJKQzm0853708537epcas2p47;
        Tue, 18 Feb 2020 23:57:58 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 48Md8N1Q7JzMqYkf; Tue, 18 Feb
        2020 23:57:56 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        3B.55.20039.20A7C4E5; Wed, 19 Feb 2020 08:57:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200218235753epcas2p418e7a5d0e6d76ae30fa6d585c175e308~0pIgrVVea1759917599epcas2p4C;
        Tue, 18 Feb 2020 23:57:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200218235753epsmtrp2a567eae0674bd6dec910eff17b32b9b6~0pIgMkwtX0235702357epsmtrp2v;
        Tue, 18 Feb 2020 23:57:53 +0000 (GMT)
X-AuditID: b6c32a47-7fbff70000014e47-ac-5e4c7a0253b2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        26.14.10238.10A7C4E5; Wed, 19 Feb 2020 08:57:53 +0900 (KST)
Received: from KORCO002087 (unknown [180.236.228.110]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200218235752epsmtip174b0bac18c9a88a1b0e9b4d62d0da3a4~0pIfFUIkh0056100561epsmtip1c;
        Tue, 18 Feb 2020 23:57:51 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Christoph Hellwig'" <hch@lst.de>, <linux-scsi@vger.kernel.org>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>
In-Reply-To: <20200218234450.69412-2-hch@lst.de>
Subject: RE: [PATCH 1/2] ufshcd: remove unused quirks
Date:   Wed, 19 Feb 2020 08:58:02 +0900
Message-ID: <0afc01d5e6b7$42700960$c7501c20$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQILhGpIhqON/cyZC1C5H9fF+e+4swIQdyCfAWtbKVCnmocX8A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42LZdljTTJepyifOoHObgMWDedvYLF7+vMpm
        sXL1USaL7us72BxYPHbfbGDz6NuyitHj8yY5j/YD3UwBLFE5NhmpiSmpRQqpecn5KZl56bZK
        3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAK5UUyhJzSoFCAYnFxUr6djZF+aUlqQoZ
        +cUltkqpBSk5BYaGBXrFibnFpXnpesn5uVaGBgZGpkCVCTkZczqeMRc0OVRMezeJpYFxqnEX
        IyeHhICJxIkjR5i7GLk4hAR2MEps6m1jBkkICXxilFh0vQAi8Y1Ron3jTBaYjq9HJzNBJPYy
        Shx708EK0fGaUeLQhUIQm01AW2Law91gcREBF4ntyxrYQGxmgTCJhVt2gQ3iFDCQ2HriDFiN
        sICpxNw5mxlBbBYBVYmX1zaAxXkFLCVW3T0JZQtKnJz5hAVijrzE9rdzmCEOUpD4+XQZ1C4n
        ibV9C9ghakQkZne2gb0mIXCCTeLojr1ADgeQ4yLxaoE7RK+wxKvjW9ghbCmJz+/2skHY9RL7
        pjawQvT2MEo83fePESJhLDHrWTsjyBxmAU2J9bv0IUYqSxy5BXUan0TH4b/sEGFeiY42IYhG
        ZYlfkyZDDZGUmHnzDvsERqVZSB6bheSxWUgemIWwawEjyypGsdSC4tz01GKjAmPkqN7ECE6M
        Wu47GLed8znEKMDBqMTDe+Cid5wQa2JZcWXuIUYJDmYlEV5vca84Id6UxMqq1KL8+KLSnNTi
        Q4ymwHCfyCwlmpwPTNp5JfGGpkZmZgaWphamZkYWSuK8m7hvxggJpCeWpGanphakFsH0MXFw
        SjUwqrds7Pgr0hR93+5gZXazkXqKYHjDt2fKvT+cPcyynm2c/+nD/HDDbSWX3O7brvU+b8Br
        2GPwYMP8L+qLdJecKD8453sps6Msi576wSWX07mW/jZUEnrs7JVyjHFz3Jb7G3NcT32bXJd7
        bp7V1qrpnDqhLTzHOlUWJcb12TQbi9fKGbZqu21VYinOSDTUYi4qTgQAAht9yaIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWy7bCSnC5jlU+cwaWrfBYP5m1js3j58yqb
        xcrVR5ksuq/vYHNg8dh9s4HNo2/LKkaPz5vkPNoPdDMFsERx2aSk5mSWpRbp2yVwZczpeMZc
        0ORQMe3dJJYGxqnGXYycHBICJhJfj05m6mLk4hAS2M0o0dB3lxEiISlxYudzKFtY4n7LEVaI
        opeMEi1XP4El2AS0JaY93M0KYosIuElcn3GapYuRg4NZIEziyZFKiPqljBKNu9Yzg9RwChhI
        bD1xBqxeWMBUYu6czWBzWARUJV5e2wAW5xWwlFh19ySULShxcuYTqJl6Em0bwcqZBeQltr+d
        wwxxm4LEz6fLoE5wkljbt4AdokZEYnZnG/MERuFZSCbNQpg0C8mkWUg6FjCyrGKUTC0ozk3P
        LTYsMMxLLdcrTswtLs1L10vOz93ECI4RLc0djJeXxB9iFOBgVOLhzTjvHSfEmlhWXJl7iFGC
        g1lJhNdb3CtOiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/TvGORQgLpiSWp2ampBalFMFkmDk6p
        BsYCvyV3uLlv7g7r/K4fFCTxt8dEnzXc8POV4hlLX9neclj/gKc/b8794gW/5E79ksn59ZVZ
        y5j3WOgtJ4kGS4b9sSqls7s67qddbrovscrHaHvfsmMlPmx17Dx3zz8Km+DXeig4qeaC5OqJ
        x19XNXUc2W62OCNIvyXQ+9Sv1Cqm9ZYnfOr3RyqxFGckGmoxFxUnAgAY3+yJjQIAAA==
X-CMS-MailID: 20200218235753epcas2p418e7a5d0e6d76ae30fa6d585c175e308
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200218234505epcas2p1ddd6db560233ff6aab1e1f0c30fd4eb2
References: <20200218234450.69412-1-hch@lst.de>
        <CGME20200218234505epcas2p1ddd6db560233ff6aab1e1f0c30fd4eb2@epcas2p1.samsung.com>
        <20200218234450.69412-2-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>
> On Behalf Of Christoph Hellwig
> Sent: Wednesday, February 19, 2020 8:45 AM
> To: linux-scsi@vger.kernel.org
> Cc: Alim Akhtar <alim.akhtar@samsung.com>; Avri Altman
> <avri.altman@wdc.com>
> Subject: [PATCH 1/2] ufshcd: remove unused quirks
> 
> Remove various quirks that don't have users, as well as the dead code
> keyed off them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/ufs/ufshcd.c | 120 +++++---------------------------------
>  drivers/scsi/ufs/ufshcd.h |  22 -------
>  2 files changed, 13 insertions(+), 129 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> abd0e6b05f79..2eb86851af7a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -642,11 +642,7 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb
> *lrbp)
>   */
>  static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)  {
> -	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
> -		ufshcd_writel(hba, (1 << pos),
> REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> -	else
> -		ufshcd_writel(hba, ~(1 << pos),
> -				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> +	ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
>  }
> 
>  /**
> @@ -656,10 +652,7 @@ static inline void ufshcd_utrl_clear(struct ufs_hba
> *hba, u32 pos)
>   */
>  static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)  {
> -	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
> -		ufshcd_writel(hba, (1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
> -	else
> -		ufshcd_writel(hba, ~(1 << pos),
REG_UTP_TASK_REQ_LIST_CLEAR);
> +	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
>  }
> 
>  /**
> @@ -2093,13 +2086,8 @@ static int ufshcd_map_sg(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  		return sg_segments;
> 
>  	if (sg_segments) {
> -		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
> -			lrbp->utr_descriptor_ptr->prd_table_length =
> -				cpu_to_le16((u16)(sg_segments *
> -					sizeof(struct ufshcd_sg_entry)));
> -		else
> -			lrbp->utr_descriptor_ptr->prd_table_length =
> -				cpu_to_le16((u16) (sg_segments));
> +		lrbp->utr_descriptor_ptr->prd_table_length =
> +			cpu_to_le16((u16) (sg_segments));
> 
>  		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
> 
> @@ -3403,21 +3391,12 @@ static void ufshcd_host_memory_configure(struct
> ufs_hba *hba)
> 
> 	cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
> 
>  		/* Response upiu and prdt offset should be in double words
> */
> -		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN) {
> -			utrdlp[i].response_upiu_offset =
> -				cpu_to_le16(response_offset);
> -			utrdlp[i].prd_table_offset =
> -				cpu_to_le16(prdt_offset);
> -			utrdlp[i].response_upiu_length =
> -				cpu_to_le16(ALIGNED_UPIU_SIZE);
> -		} else {
> -			utrdlp[i].response_upiu_offset =
> -				cpu_to_le16((response_offset >> 2));
> -			utrdlp[i].prd_table_offset =
> -				cpu_to_le16((prdt_offset >> 2));
> -			utrdlp[i].response_upiu_length =
> -				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> -		}
> +		utrdlp[i].response_upiu_offset =
> +			cpu_to_le16((response_offset >> 2));
> +		utrdlp[i].prd_table_offset =
> +			cpu_to_le16((prdt_offset >> 2));
> +		utrdlp[i].response_upiu_length =
> +			cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> 
>  		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
>  		hba->lrb[i].utrd_dma_addr = hba->utrdl_dma_addr + @@ -
> 3460,52 +3439,6 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>  			"dme-link-startup: error code %d\n", ret);
>  	return ret;
>  }
> -/**
> - * ufshcd_dme_reset - UIC command for DME_RESET
> - * @hba: per adapter instance
> - *
> - * DME_RESET command is issued in order to reset UniPro stack.
> - * This function now deal with cold reset.
> - *
> - * Returns 0 on success, non-zero value on failure
> - */
> -static int ufshcd_dme_reset(struct ufs_hba *hba) -{
> -	struct uic_command uic_cmd = {0};
> -	int ret;
> -
> -	uic_cmd.command = UIC_CMD_DME_RESET;
> -
> -	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> -	if (ret)
> -		dev_err(hba->dev,
> -			"dme-reset: error code %d\n", ret);
> -
> -	return ret;
> -}
> -
> -/**
> - * ufshcd_dme_enable - UIC command for DME_ENABLE
> - * @hba: per adapter instance
> - *
> - * DME_ENABLE command is issued in order to enable UniPro stack.
> - *
> - * Returns 0 on success, non-zero value on failure
> - */
> -static int ufshcd_dme_enable(struct ufs_hba *hba) -{
> -	struct uic_command uic_cmd = {0};
> -	int ret;
> -
> -	uic_cmd.command = UIC_CMD_DME_ENABLE;
> -
> -	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> -	if (ret)
> -		dev_err(hba->dev,
> -			"dme-reset: error code %d\n", ret);
> -
> -	return ret;
> -}
> 
>  static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
> { @@ -4217,7 +4150,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba
> *hba, bool can_sleep)  }
> 
>  /**
> - * ufshcd_hba_execute_hce - initialize the controller
> + * ufshcd_hba_enable - initialize the controller
>   * @hba: per adapter instance
>   *
>   * The controller resets itself and controller firmware initialization @@
> -4226,7 +4159,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba,
> bool can_sleep)
>   *
>   * Returns 0 on success, non-zero value on failure
>   */
> -static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
> +int ufshcd_hba_enable(struct ufs_hba *hba)
>  {
>  	int retry;
> 
> @@ -4274,32 +4207,6 @@ static int ufshcd_hba_execute_hce(struct ufs_hba
> *hba)
> 
>  	return 0;
>  }
> -
> -int ufshcd_hba_enable(struct ufs_hba *hba) -{
> -	int ret;
> -
> -	if (hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) {
> -		ufshcd_set_link_off(hba);
> -		ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
> -
> -		/* enable UIC related interrupts */
> -		ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
> -		ret = ufshcd_dme_reset(hba);
> -		if (!ret) {
> -			ret = ufshcd_dme_enable(hba);
> -			if (!ret)
> -				ufshcd_vops_hce_enable_notify(hba,
POST_CHANGE);
> -			if (ret)
> -				dev_err(hba->dev,
> -					"Host controller enable failed with
non-
> hce\n");
> -		}
> -	} else {
> -		ret = ufshcd_hba_execute_hce(hba);
> -	}
> -
> -	return ret;
> -}
>  EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
> 
>  static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer) @@ -
> 4869,8 +4776,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct
> ufs_hba *hba)
>  	 * false interrupt if device completes another request after
> resetting
>  	 * aggregation and before reading the DB.
>  	 */
> -	if (ufshcd_is_intr_aggr_allowed(hba) &&
> -	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
> +	if (ufshcd_is_intr_aggr_allowed(hba))
>  		ufshcd_reset_intr_aggr(hba);
> 
>  	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> 2ae6c7c8528c..9c2b80f87b9f 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -612,28 +612,6 @@ struct ufs_hba {
>  	 */
>  	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		0x20
> 
> -	/*
> -	 * This quirk needs to be enabled if the host contoller regards
> -	 * resolution of the values of PRDTO and PRDTL in UTRD as byte.
> -	 */
> -	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			0x80
> -
> -	/*
> -	 * Clear handling for transfer/task request list is just opposite.
> -	 */
> -	#define UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		0x100
> -
> -	/*
> -	 * This quirk needs to be enabled if host controller doesn't allow
> -	 * that the interrupt aggregation timer and counter are reset by
> s/w.
> -	 */
> -	#define UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		0x200
> -
> -	/*
> -	 * This quirks needs to be enabled if host controller cannot be
> -	 * enabled via HCE register.
> -	 */
> -	#define UFSHCI_QUIRK_BROKEN_HCE				0x400
>  	unsigned int quirks;	/* Deviations from standard UFSHCI spec.
> */
> 
>  	/* Device deviations from standard UFS device spec. */
> --
> 2.24.1


