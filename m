Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CB6C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 05:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43E9260F48
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 05:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhJRFuP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 01:50:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10553 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhJRFuO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 01:50:14 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211018054802epoutp022a75f610b6909a0d407547930f43321b~vCegNU0xE0319503195epoutp02x
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 05:48:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211018054802epoutp022a75f610b6909a0d407547930f43321b~vCegNU0xE0319503195epoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634536082;
        bh=paT3NoQVhT86t/CVBhPDwFkK6kwy0rgp62JJBgiWVVA=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Y3t69YxGmiJUVr26BWOC94VbRoJ/FxLsN+hRkt4gLVA/0pJcFYCHfEcfDnLncCQBX
         WH0T7d+JDv5V6gVAXET08MW8WrcrKlqWMpL25YAVVFZQVLMSZ5b2+AXJ1vRttTKRdz
         6z/56hC8MZX6L7XzPYAtQZWaXWiObKH6TeODFXN4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20211018054801epcas3p1b4f7666e797af2d3134da190c4ef502c~vCeflZZ712287222872epcas3p1c;
        Mon, 18 Oct 2021 05:48:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4HXmB92BH8z4x9QH; Mon, 18 Oct 2021 05:48:01 +0000
        (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211018052330epcas1p19b3e01c087b1f43c878883d3dc256eac~vCJFzVEMH1284512845epcas1p13;
        Mon, 18 Oct 2021 05:23:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211018052330epsmtrp299f94315c855e1957f3d3fbd488b1bee~vCJFx_B2Y0509505095epsmtrp2M;
        Mon, 18 Oct 2021 05:23:30 +0000 (GMT)
X-AuditID: b6c32a29-14bff700000022c6-c6-616d04d2ce83
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.84.08902.2D40D616; Mon, 18 Oct 2021 14:23:30 +0900 (KST)
Received: from [10.113.221.211] (unknown [10.113.221.211]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018052330epsmtip280700a75d516d9925cbaa68159e341d5~vCJFYDO_A1759317593epsmtip2E;
        Mon, 18 Oct 2021 05:23:30 +0000 (GMT)
Subject: Re: [PATCH v4 14/16] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "cpgs ." <cpgs@samsung.com>
From:   Inki Dae <inki.dae@samsung.com>
Message-ID: <1891546521.01634536081285.JavaMail.epsvc@epcpadp4>
Date:   Mon, 18 Oct 2021 14:34:14 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
        Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211007080934.108804-15-chanho61.park@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRzGe885O50tl6dZ7XVdrHXVaroyeEGR7pwwRSLCjLTRjhdyc2xl
        2nUZqVtp80vp0SxvGSuwbJuaYTa7aFaWW2Rq6WoWRpEaWVp0mRb47cfzPL//lz+Fi54REipJ
        vY/VqhXJUlJA2JqkfivaCZUiKO+WL2pxXyVRb7GNRP0jz0l0x2Ug0NmBERwNVV3iIcftZajf
        7o9O161HraZSDLmrOByVdtgw1DGayUPXP33H0EvLPQLltzVg6NSLWhJVPviFoR8jdmyND+Nw
        hjOcPodkHLk5GHPjcgBTdqsfY6rNBpIxlTYC5ltVNskM9nUSTK7FDJgv1XOZrMZTWJRXjCBU
        ySYnpbLawLDdgsTM8+dITde8tDZnvB58kxgBn4J0MBwqceJGIKBEdD2Aw0VFk42A+ltAaLFS
        4+gDm5p045NPAJaWVAKP60PHQu5nDfAU02kOg06Xe+wQTr/EYVbmY3JceQhgt2GQ9CgkvQjm
        Xe4ZYyEdBnve5/M8TPzNTWdcmIdn0DtgRrP132YabClwEx7m02shV983tsHpJfBncTs+zmLY
        6b7wL/eDJ6yFuAmIuAk6N0HhJijcBOUiIMzAl9XoVAkqnVwjV7MHZDqFSrdfnSDbk6KqBmNf
        D/CvBTXmAZkdYBSwA0jh0unCqYPJCpFQqUg/yGpT4rT7k1mdHcyiCKlY+NTYEieiExT72L0s
        q2G1/1uM4kv02Oa845WRN4ejWvXRiW8iU80fczXh3dHY/bAV3uL44dEFDd7anFfzpgSbsv0c
        jERjUy1YveuJFXE9vQe2lfFN209YQg5fWa4Mn/I8VTn7emyORvxI9r4ww2KNcyCvxcpp9g1p
        ZGNDyiaBzfghQp77IG7mSe+7GExq2ygJKUzkHLKd5VvvrTvUWDE6X9485BXya1V9s3ODb7Wz
        y7A9aNGWh+fdal5o2ZHgcpW57od/n/3aZ1tWgaszL3DtUia7O3slCAuaeyPaS+2yBnaP7C5P
        b/lIQ+EWpXhhwaGa9LtXl+gtx3/vLWl/zetQfX3XUBwxUOF/7MIsw9G0OeSkmGH+WymhS1TI
        A3CtTvEHc2KPQGQDAAA=
X-CMS-MailID: 20211018052330epcas1p19b3e01c087b1f43c878883d3dc256eac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20211007081135epcas2p410e67850fdd25fc762b0bfa49c6e24f1
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p410e67850fdd25fc762b0bfa49c6e24f1@epcas2p4.samsung.com>
        <20211007080934.108804-15-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



21. 10. 7. 오후 5:09에 Chanho Park 이(가) 쓴 글:
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
> Cc: Inki Dae <inki.dae@samsung.com>
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufs-exynos.c | 68 +++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index 9d32f19395b8..32f73c906018 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -83,6 +83,44 @@
>  #define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
>  #define UFS_SHAREABILITY_OFFSET	0x710
>  
> +/* Multi-host registers */
> +#define MHCTRL			0xC4
> +#define MHCTRL_EN_VH_MASK	(0xE)
> +#define MHCTRL_EN_VH(vh)	(vh << 1)
> +#define PH2VH_MBOX		0xD8
> +
> +#define MH_MSG_MASK		(0xFF)
> +
> +#define MH_MSG(id, msg)		((id << 8) | (msg & 0xFF))
> +#define MH_MSG_PH_READY		0x1
> +#define MH_MSG_VH_READY		0x2
> +
> +#define ALLOW_INQUIRY		BIT(25)
> +#define ALLOW_MODE_SELECT	BIT(24)
> +#define ALLOW_MODE_SENSE	BIT(23)
> +#define ALLOW_PRE_FETCH		GENMASK(22, 21)
> +#define ALLOW_READ_CMD_ALL	GENMASK(20, 18)	/* read_6/10/16 */
> +#define ALLOW_READ_BUFFER	BIT(17)
> +#define ALLOW_READ_CAPACITY	GENMASK(16, 15)
> +#define ALLOW_REPORT_LUNS	BIT(14)
> +#define ALLOW_REQUEST_SENSE	BIT(13)
> +#define ALLOW_SYNCHRONIZE_CACHE	GENMASK(8, 7)
> +#define ALLOW_TEST_UNIT_READY	BIT(6)
> +#define ALLOW_UNMAP		BIT(5)
> +#define ALLOW_VERIFY		BIT(4)
> +#define ALLOW_WRITE_CMD_ALL	GENMASK(3, 1)	/* write_6/10/16 */
> +
> +#define ALLOW_TRANS_VH_DEFAULT	(ALLOW_INQUIRY | ALLOW_MODE_SELECT | \
> +				 ALLOW_MODE_SENSE | ALLOW_PRE_FETCH | \
> +				 ALLOW_READ_CMD_ALL | ALLOW_READ_BUFFER | \
> +				 ALLOW_READ_CAPACITY | ALLOW_REPORT_LUNS | \
> +				 ALLOW_REQUEST_SENSE | ALLOW_SYNCHRONIZE_CACHE | \
> +				 ALLOW_TEST_UNIT_READY | ALLOW_UNMAP | \
> +				 ALLOW_VERIFY | ALLOW_WRITE_CMD_ALL)
> +
> +#define HCI_MH_ALLOWABLE_TRAN_OF_VH		0x30C
> +#define HCI_MH_IID_IN_TASK_TAG			0X308
> +
>  enum {
>  	UNIPRO_L1_5 = 0,/* PHY Adapter */
>  	UNIPRO_L2,	/* Data Link */
> @@ -174,6 +212,20 @@ static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
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
> +	hci_writel(ufs, ALLOW_TRANS_VH_DEFAULT, HCI_MH_ALLOWABLE_TRAN_OF_VH);
> +	/* IID information is replaced in TASKTAG[7:5] instead of IID in UCD */
> +	hci_writel(ufs, 0x1, HCI_MH_IID_IN_TASK_TAG);
> +

Reviewed-by : Inki Dae <inki.dae@samsung.com>

Thanks,
Inki Dae

