Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7423CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 05:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5153160FED
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 05:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhI0F0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 01:26:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11659 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbhI0F0k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 01:26:40 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210927052502epoutp04da76f5660040063bf2f39884f7fdc99e~olnbgTH3L1159011590epoutp046
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 05:25:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210927052502epoutp04da76f5660040063bf2f39884f7fdc99e~olnbgTH3L1159011590epoutp046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632720302;
        bh=zBJv4WyN6g4DWac8lig5y59kgRoCzRhrQBiNHEUIPJg=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=a8pNGgeLxA1aVHe4IdrCH62LtJTtlGbfnMhYUtfVB2wfXzFzL/EPCod4pF8Bauvj4
         hkX2iZK+/DBC/Eel97gQaDaWnhBefOkx5qkjqN3NTy2sHyEVhSFc8UiaKos5yRBW6d
         Gk1xct6EWNNm0ueeCSlZhlEJlAFz9fCgIQpwmHxs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210927052501epcas3p4729af9f6eb8e2dc8a7910869b3ac7254~olna8Vunz3074630746epcas3p4a;
        Mon, 27 Sep 2021 05:25:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4HHrgK43vlz4x9Pt; Mon, 27 Sep 2021 05:25:01 +0000
        (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210927052117epcas1p2adf962bedc6a69d1c75d45dbcc7aad84~olkKNO2Px0564405644epcas1p25;
        Mon, 27 Sep 2021 05:21:17 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210927052117epsmtrp1445ac29c48de21d8e0c3889f2df216e0~olkKMKb-l3064830648epsmtrp19;
        Mon, 27 Sep 2021 05:21:17 +0000 (GMT)
X-AuditID: b6c32a29-d87ff70000002383-d6-615154cd14be
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.D9.09091.DC451516; Mon, 27 Sep 2021 14:21:17 +0900 (KST)
Received: from [10.113.221.211] (unknown [10.113.221.211]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210927052116epsmtip2326b6ef5367b99981c6bc614625ad571~olkJqxI2N0436404364epsmtip2f;
        Mon, 27 Sep 2021 05:21:16 +0000 (GMT)
Subject: Re: [PATCH v3 15/17] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        cpgs@samsung.com
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Kiwoong Kim <kwmad.kim@samsung.com>
From:   Inki Dae <inki.dae@samsung.com>
Message-ID: <1891546521.01632720301546.JavaMail.epsvc@epcpadp3>
Date:   Mon, 27 Sep 2021 14:31:43 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
        Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917065436.145629-16-chanho61.park@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWy7bCSvO7ZkMBEg0X7BC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23x8pCmRc9OZ4vTExYxWTxZP4vZYtGNbUwWG9/+
        YLK4ueUoi8WM8/uYLLqv72CzWH78H5ODoMflK94esxp62Twu9/UyeWxeoeWxeM9LJo9NqzrZ
        PCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBPFJdNSmpOZllqkb5dAlfG+Yb17AVz
        lCv2TzjJ3sB4VqaLkZNDQsBE4tH1n0xdjFwcQgK7GSW2X37K3sXIAZSQkNiylQPCFJY4fLgY
        ouQto0TzyqNsIL3CAnESnSdnsoAkRATWMEl82d7LDOIwC3xkktjw+R8LRMspRokprzcyg7Sw
        CahKTFxxH6ydV8BO4sOSa4wgNgtQvPXjXrC4qECkRNOJrVA1ghInZz5hAbE5BRwlzr95A1bP
        LKAu8WfeJWYIW1zi1pP5TBC2vETz1tnMExiFZiFpn4WkZRaSlllIWhYwsqxilEwtKM5Nzy02
        LDDMSy3XK07MLS7NS9dLzs/dxAiObC3NHYzbV33QO8TIxMF4iFGCg1lJhDeYxT9RiDclsbIq
        tSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBibWn6mT5z9r4uwsdnEp
        7qpNPfzV0DZhsdy9qRXhi1YnTWqwv3Tt1hERpT3TDG3m5Z0/1jnr27aPsdIqTX0hwsenLAmY
        f+PKhT/7Tit3Gry/7nLH2vLAgzMHpZdnZ137rv6yQHB3302Reo6crsUy575tDP4s336zxySN
        e72H6g+f8DtXhZQ4zISnL4qpfuDyI/X6f3Xv4uas3uSwuqhzvXH2021nBsUnr9jzqYOpX2Vp
        7sy96x4unDtD4ZiOzo/sF1ZrLonESJ1tb2l7XVgdOf1EnsqBeXJRVienWRaZGnwTfmB4m+v2
        7aJZbRocz3ZWM6YyvZTb8lMvPopfI1TOQNdhpvLVZaLp7qe1DgbablZiKc5INNRiLipOBAD/
        dYPQWwMAAA==
X-CMS-MailID: 20210927052117epcas1p2adf962bedc6a69d1c75d45dbcc7aad84
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210917065524epcas2p18a720757ef3c4fc08d4bc8d16f9fe7fe
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065524epcas2p18a720757ef3c4fc08d4bc8d16f9fe7fe@epcas2p1.samsung.com>
        <20210917065436.145629-16-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



21. 9. 17. 오후 3:54에 Chanho Park 이(가) 쓴 글:
> UFS controller of ExynosAuto v9 SoC supports multi-host interface for I/O
> virtualization. In general, we're using para-virtualized driver to
> support a block device by several virtual machines. However, it should
> be relayed by backend driver. Multi-host functionality extends the host
> controller by providing register interfaces that can be used by each
> VM's ufs drivers respectively. By this, we can provide direct access to
> the UFS device for multiple VMs. It's similar with SR-IOV of PCIe.
> 
> We divide this M-HCI as PH(Physical Host) and VHs(Virtual Host). The PH
> supports all UFSHCI functions(all SAPs) same as conventional UFSHCI but
> the VH only supports data transfer function. Thus, except UTP_CMD_SAP and
> UTP_TMPSAP, the PH should handle all the physical features.
> 
> This patch provides an initial implementation of PH part. M-HCI can
> support up to four interfaces but this patch initially supports only 1
> PH and 1 VH. For this, we uses TASK_TAG[7:5] field so TASK_TAG[4:0] for
> 32 doorbel will be supported. After the PH is initiated, this will send
> a ready message to VHs through a mailbox register. The message handler
> is not fully implemented yet such as supporting reset / abort cases.
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Kiwoong Kim <kwmad.kim@samsung.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufs-exynos.c | 45 +++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index 28f027d45917..0ca21cd8e76e 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -83,6 +83,21 @@
>  #define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
>  #define UFS_SHAREABILITY_OFFSET	0x710
>  
> +/* Multi-host registers */
> +#define MHCTRL					0xC4
> +#define MHCTRL_EN_VH_MASK			(0xE)
> +#define MHCTRL_EN_VH(vh)			(vh << 1)
> +#define PH2VH_MBOX				0xD8
> +
> +#define MH_MSG_MASK				(0xFF)
> +
> +#define MH_MSG(id, msg)				((id << 8) | (msg & 0xFF))
> +#define MH_MSG_PH_READY				0x1
> +#define MH_MSG_VH_READY				0x2
> +
> +#define HCI_MH_ALLOWABLE_TRAN_OF_VH		0x30C
> +#define HCI_MH_IID_IN_TASK_TAG			0X308
> +
>  enum {
>  	UNIPRO_L1_5 = 0,/* PHY Adapter */
>  	UNIPRO_L2,	/* Data Link */
> @@ -173,6 +188,20 @@ static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
>  	return 0;
>  }
>  
> +static int exynosauto_ufs_post_hce_enable(struct exynos_ufs *ufs)
> +{
> +	struct ufs_hba *hba = ufs->hba;
> +
> +	/* Enable Virtual Host #1 */
> +	ufshcd_rmwl(hba, MHCTRL_EN_VH_MASK, MHCTRL_EN_VH(1), MHCTRL);
> +	/* Default VH Transfer permissions */
> +	hci_writel(ufs, 0x03FFE1FE, HCI_MH_ALLOWABLE_TRAN_OF_VH);

How about using a defined macro instead of constant value, 0x03FFE1FE for code readability? And maybe 0x03FFE1FE to 0x3FFE1FE.

Thanks,
Inki Dae

> +	/* IID information is replaced in TASKTAG[7:5] instead of IID in UCD */
> +	hci_writel(ufs, 0x1, HCI_MH_IID_IN_TASK_TAG);
> +
> +	return 0;
> +}
> +
>  static int exynosauto_ufs_pre_link(struct exynos_ufs *ufs)
>  {
>  	struct ufs_hba *hba = ufs->hba;
> @@ -231,6 +260,20 @@ static int exynosauto_ufs_pre_pwr_change(struct exynos_ufs *ufs,
>  	return 0;
>  }
>  
> +static int exynosauto_ufs_post_pwr_change(struct exynos_ufs *ufs,
> +					  struct ufs_pa_layer_attr *pwr)
> +{
> +	struct ufs_hba *hba = ufs->hba;
> +	u32 enabled_vh;
> +
> +	enabled_vh = ufshcd_readl(hba, MHCTRL) & MHCTRL_EN_VH_MASK;
> +
> +	/* Send physical host ready message to virtual hosts */
> +	ufshcd_writel(hba, MH_MSG(enabled_vh, MH_MSG_PH_READY), PH2VH_MBOX);
> +
> +	return 0;
> +}
> +
>  static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
>  {
>  	struct ufs_hba *hba = ufs->hba;
> @@ -1395,8 +1438,10 @@ static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
>  				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
>  				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
>  	.drv_init		= exynosauto_ufs_drv_init,
> +	.post_hce_enable	= exynosauto_ufs_post_hce_enable,
>  	.pre_link		= exynosauto_ufs_pre_link,
>  	.pre_pwr_change		= exynosauto_ufs_pre_pwr_change,
> +	.post_pwr_change	= exynosauto_ufs_post_pwr_change,
>  };
>  
>  static struct exynos_ufs_drv_data exynos_ufs_drvs = {
> 

