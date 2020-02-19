Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E1BC34031
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 00:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3174208E4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 00:00:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="L1KdBuOI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgBSAA2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 19:00:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:29416 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgBSAA2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 19:00:28 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200219000025epoutp020e18ddfad23eecacfd6171e5c6aa3f25~0pKuQVKZP1809018090epoutp02d
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 00:00:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200219000025epoutp020e18ddfad23eecacfd6171e5c6aa3f25~0pKuQVKZP1809018090epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1582070425;
        bh=CH7EhCLizrRiJFZMs2kep10d/rAfY7tnPTlEOOErAiY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=L1KdBuOI9AENVSwM8x7DPd79u7S5V1lfLF8yoERWQna2ImQmzIK36DGTODh574iCU
         rFb6h3BdvJQWTOsDtLSd8/BtlDRRhdMU/Q0Y41xhSxznx967ehB4IJeyl4IZsouq4C
         GW+krqYZRY7Ps5IERn3s/KYgrwCub6QRXCDqtxz4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200219000024epcas2p31fa022c9ddd4fe4aaa798d5d3e55916a~0pKtGuT000326403264epcas2p3H;
        Wed, 19 Feb 2020 00:00:24 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 48MdCB10cZzMqYkl; Wed, 19 Feb
        2020 00:00:22 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.F7.17960.49A7C4E5; Wed, 19 Feb 2020 09:00:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200219000018epcas2p4b4e2428451a9b3fccf56796379a680cb~0pKm7s5S60634006340epcas2p4E;
        Wed, 19 Feb 2020 00:00:18 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200219000018epsmtrp2f9d3c846d11a75c4131a0fb433b5e7f9~0pKm7FOk50401604016epsmtrp2_;
        Wed, 19 Feb 2020 00:00:18 +0000 (GMT)
X-AuditID: b6c32a48-0f5ff70000014628-f4-5e4c7a949d24
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.07.06569.19A7C4E5; Wed, 19 Feb 2020 09:00:17 +0900 (KST)
Received: from KORCO002087 (unknown [180.236.228.110]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200219000016epsmtip2a598b2213489bb4088d1cb1b8ada4ae2~0pKlUV8Q12485824858epsmtip2i;
        Wed, 19 Feb 2020 00:00:16 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Christoph Hellwig'" <hch@lst.de>, <linux-scsi@vger.kernel.org>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>
In-Reply-To: <20200218234450.69412-2-hch@lst.de>
Subject: RE: [PATCH 1/2] ufshcd: remove unused quirks
Date:   Wed, 19 Feb 2020 09:00:26 +0900
Message-ID: <0afd01d5e6b7$988cddf0$c9a699d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQILhGpIhqON/cyZC1C5H9fF+e+4swIQdyCfAWtbKVCnmocfQA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdljTTHdKlU+cwbHXJhYP5m1js3j58yqb
        xcrVR5ksuq/vYHNg8dh9s4HNo2/LKkaPz5vkPNoPdDMFsETl2GSkJqakFimk5iXnp2Tmpdsq
        eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYArVRSKEvMKQUKBSQWFyvp29kU5ZeWpCpk
        5BeX2CqlFqTkFBgaFugVJ+YWl+al6yXn51oZGhgYmQJVJuRknLp7lrHgqmNF17avLA2Mx0y6
        GDk4JARMJKb3KnUxcnEICexglPi7bCdrFyMnkPOJUWLhOyj7G6PE049sMPUXLlpD1O9llDjb
        sokVwnnNKHFk73pmkAY2AW2JaQ93gzWLCLhIbF/WwAZiMwuESSzcsosFxOYUMJDYeuIMWI2w
        gKnE3DmbGUFsFgFViVsPboPV8ApYSrzZs5QRwhaUODnzCQvEHHmJ7W/ngO2SEFCQ+Pl0GSvI
        cSICThLPPqhAlIhIzO5sYwa5TULgMpvEktYvTBD1LhJPH2xlhbCFJV4d38IOYUtJfH63lw3C
        rpfYN7WBFaK5B+j5ff8YIRLGErOetTOCLGMW0JRYv0sfEijKEkduQZ3GJ9Fx+C87RJhXoqNN
        CKJRWeLXpMlQQyQlZt68wz6BUWkWksdmIXlsFpIPZiHsWsDIsopRLLWgODc9tdiowAQ5ojcx
        gpOilscOxgPnfA4xCnAwKvHwHrjoHSfEmlhWXJl7iFGCg1lJhNdb3CtOiDclsbIqtSg/vqg0
        J7X4EKMpMNwnMkuJJucDE3ZeSbyhqZGZmYGlqYWpmZGFkjjvJu6bMUIC6YklqdmpqQWpRTB9
        TBycUg2MBQeD9qc7/N+6c9WtSWeq+C7u+F9uK/hptghHj11Dbun+DXWh8U4blPcw5e9wOX9Y
        22jVyzV5jSwHdsR/XL04lI0vrlDDhLPmF9ecbSuk87Mqdvlly62XdNTb2zM9gr0z7A7j5eWc
        Z8+/WbDja6gT34030yY/6DSb+PlgVrjuF+lJ0eY7A55vUWIpzkg01GIuKk4EAKipvJmgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSvO7EKp84g+cbrS0ezNvGZvHy51U2
        i5WrjzJZdF/fwebA4rH7ZgObR9+WVYwenzfJebQf6GYKYInisklJzcksSy3St0vgyjh19yxj
        wVXHiq5tX1kaGI+ZdDFycEgImEhcuGjdxcjFISSwm1Hi56KnTF2MnEBxSYkTO58zQtjCEvdb
        jrBCFL1klOi/84MdJMEmoC0x7eFuVhBbRMBN4vqM0ywgQ5kFwiSeHKmEqF/KKNG4az0zSA2n
        gIHE1hNnwOqFBUwl5s7ZDLaARUBV4taD2ywgNq+ApcSbPUsZIWxBiZMzn0DN1JNo2wgWZhaQ
        l9j+dg4zxG0KEj+fLmMFKRERcJJ49kEFokREYnZnG/MERuFZSAbNQhg0C8mgWUg6FjCyrGKU
        TC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI4PLa0djCdOxB9iFOBgVOLhPXDRO06INbGs
        uDL3EKMEB7OSCK+3uFecEG9KYmVValF+fFFpTmrxIUZpDhYlcV75/GORQgLpiSWp2ampBalF
        MFkmDk6pBkaFwH93BZ/kzlbeGBi5huXZkV0iYqtk9QtffhJ2zDy/TF1im8c3kTxr568sXYtM
        /hixNl5yWFdrlHrvw4/vRtOLQ5Qu+21eUyYrc+JLhMaO8hubDqk8T/Jdd8Tx7J3AtbuYVRqX
        P3S997Eg/Kn3p1MrZns0v5HdrbFG9+7dVZtPGLOvWPNGZM0tJZbijERDLeai4kQAS4pkN4sC
        AAA=
X-CMS-MailID: 20200219000018epcas2p4b4e2428451a9b3fccf56796379a680cb
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

Exynos specific driver sets and is using the following quirks but the driver
is not updated
yet. I'll do upstream it in the future.
- UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR
- UFSHCD_QUIRK_PRDT_BYTE_GRAN
- UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR


