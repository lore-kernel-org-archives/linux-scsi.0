Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DE4C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 16 May 2021 04:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A34461176
	for <linux-scsi@archiver.kernel.org>; Sun, 16 May 2021 04:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhEPEd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 May 2021 00:33:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48693 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEPEd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 May 2021 00:33:58 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210516043241epoutp04dd6c067f606561f39822cf6bd75e8079~-cdeZn7N63101831018epoutp04Q
        for <linux-scsi@vger.kernel.org>; Sun, 16 May 2021 04:32:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210516043241epoutp04dd6c067f606561f39822cf6bd75e8079~-cdeZn7N63101831018epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1621139561;
        bh=FAjJzd44BeUzcZRUIxAzaieXYiY2hmbKzJ7Lc4FwNQ0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=p1HJe9fkbjxkoX4QZkZVs1u2UzBzDVc7chNc0vMmFxRhSgaq3zCSU17d4mvd8G1ZJ
         L6JqALAxUph/tXi2s44VW2HW8Tm+TZAprIAGijs3gclWFFz6Rzmckryksn82W954wm
         /xDo5tbo2lE2x6xMDuGivnDh3sVzObtMtUzk8BZM=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210516043240epcas5p3df8422b4edc6713ab606a6b578c78d38~-cddJg0fK0981509815epcas5p3N;
        Sun, 16 May 2021 04:32:40 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.C2.09697.860A0A06; Sun, 16 May 2021 13:32:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210516021235epcas5p4dbc584f819d019b8bac0ac7174fcf599~-ajJ0Y7cF0564905649epcas5p4e;
        Sun, 16 May 2021 02:12:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210516021235epsmtrp26c54f4305a4f2938e0d8712265329f47~-ajJzn6X11092410924epsmtrp2d;
        Sun, 16 May 2021 02:12:35 +0000 (GMT)
X-AuditID: b6c32a4a-639ff700000025e1-b3-60a0a068e532
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.9E.08163.39F70A06; Sun, 16 May 2021 11:12:35 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210516021234epsmtip1a53b3109b8a64ddb67a055e9e4156d75~-ajIxp1EU2243522435epsmtip1C;
        Sun, 16 May 2021 02:12:34 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'James E . J . Bottomley'" <jejb@linux.vnet.ibm.com>
Cc:     <linux-scsi@vger.kernel.org>, "'Christoph Hellwig'" <hch@lst.de>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <20210509213817.4348-1-bvanassche@acm.org>
Subject: RE: [PATCH] ufs-exynos: Move definitions from .h to .c
Date:   Sun, 16 May 2021 07:42:33 +0530
Message-ID: <21f801d749f8$efd9e2b0$cf8da810$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKku+Hkh5bAtCxFxzJe2BZbjRzc+gE7NfH+qUCfSUA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsWy7bCmpm7GggUJBl8O8FtM+/CT2WLl6qNM
        Fqsm5lnc3HKUxaL7+g42i+XH/zE5sHlcvuLt8eDQZhaP3Tcb2Dw+Pr3F4tG3ZRWjx+dNcgFs
        UVw2Kak5mWWpRfp2CVwZ7x4eZi3Yp1bx6/N+1gbGK/JdjJwcEgImEq3vZrN1MXJxCAnsZpRY
        PeE9E4TziVHi0sV7jBDOZ0aJbdPuADkcYC1bD5lAxHcxSixfMgeq/SWjxOPd3Uwgc9kEdCV2
        LG4DS4gIzAWqetnCCpJgFsiX2Pn1KCOIzSlgLrHk312wBmEBe4lXG9eC2SwCqhJ/T89lA9nG
        K2ApsaPBHCTMKyAocXLmExaIMfIS29/OYYb4QUHi59NlYONFBKwkvl8+xQ5RIy5x9GcPM8gN
        EgIzOSQ+LdsI9YGLxP6GSIheYYlXx7ewQ9hSEp/f7WWDKMmW6NllDBGukVg67xgLhG0vceDK
        HBaQEmYBTYn1u/QhwrISU0+tY4LYyifR+/sJE0ScV2LHPBhbVaL53VWoMdISE7u7WScwKs1C
        8tgsJI/NQvLALIRtCxhZVjFKphYU56anFpsWGOWllusVJ+YWl+al6yXn525iBCcgLa8djA8f
        fNA7xMjEwXiIUYKDWUmE91PY/AQh3pTEyqrUovz4otKc1OJDjNIcLErivCseTk4QEkhPLEnN
        Tk0tSC2CyTJxcEo1MClM3iF1Rc1ivc6OvBi1101eG3R22WtFeSsFP97i9d+paaMnX2TJc2Y+
        9xMPOXICbnut2vw689RvjeQDWf7z1/tfUW9UP8a5neW0StESPf1Kj4S9DFLsE///fHg6Yumd
        vZfss13WvuNgWsJl+uu10uOmfzcU/rWxRbD6T63uqwzeYNx9cnPrw4660CS1tk8u1t0+JSEf
        T52aFb1nQs3dv13PVeYUK97iaJjWwLCi/XdusnnNVsmUVfbOiz/9ONIgMz14o4jyzmV/9k2c
        0cDhZH8k+OnvYpUfGdsWHUv6zR/B+oy350vqo/UCzJe5baS2MZRd/z3xNq9SRJZq2cyJd03m
        XFj/ZdJuucvv1y/eJ6rEUpyRaKjFXFScCACXWyh3rwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWy7bCSnO7k+gUJBs3XNCymffjJbLFy9VEm
        i1UT8yxubjnKYtF9fQebxfLj/5gc2DwuX/H2eHBoM4vH7psNbB4fn95i8ejbsorR4/MmuQC2
        KC6blNSczLLUIn27BK6Mdw8PsxbsU6v49Xk/awPjFfkuRg4OCQETia2HTLoYuTiEBHYwSlzY
        u4ipi5ETKC4tcX3jBHYIW1hi5b/n7BBFzxklLq6dyAKSYBPQldixuI0NJCEiMJdRYtWc92Ad
        zAKFEmu+bITq6GCUmNV5lREkwSlgLrHk312wFcIC9hKvNq4Fs1kEVCX+np7LBnISr4ClxI4G
        c5Awr4CgxMmZT1hAwswCehJtGxkhxstLbH87hxniOAWJn0+XsYLYIgJWEt8vn4I6QVzi6M8e
        5gmMwrOQTJqFMGkWkkmzkHQsYGRZxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yfu4kRHEda
        WjsY96z6oHeIkYmD8RCjBAezkgjvp7D5CUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcS
        SE8sSc1OTS1ILYLJMnFwSjUw7c2bL/pDylp7+toFR+4prnlz47HWqsc5Ytyn3j18PkvDRK8i
        OHMtX9STxVzc+1Ymuj/dWLFswUOhFtdQ/jjNjSYMJoU6ZvsPxm0U2Papa53H3JYJ07yL9P31
        Vp5a4rSNy1K691vXQzb3g+/MJvNNaO3d5lfLb6+6mOGkVoWv6r6XC4/l5iz53B1iec/4e+yW
        H5pqbkz81utNIjW0rkw63Wll9yQopeKye5bQbZunqZ8Wsew5Yivyb+OewssMcY6uM48pLmjP
        unNyo4lcQPndaoHjLmaze/OPMXFr6ll/Wtducon76uOv/j9+zD3sNmmWD/Mu+wwnz52tk5gZ
        tCM5FV5zrD6WcfGY44bE22/DlFiKMxINtZiLihMBiwlzaRIDAAA=
X-CMS-MailID: 20210516021235epcas5p4dbc584f819d019b8bac0ac7174fcf599
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210509213827epcas5p173b48dab49036c8d85eadfc8bda9efd8
References: <CGME20210509213827epcas5p173b48dab49036c8d85eadfc8bda9efd8@epcas5p1.samsung.com>
        <20210509213817.4348-1-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: 10 May 2021 03:08
> To: Martin K . Petersen <martin.petersen@oracle.com>; James E . J .
> Bottomley <jejb@linux.vnet.ibm.com>
> Cc: linux-scsi@vger.kernel.org; Christoph Hellwig <hch@lst.de>; Bart Van
> Assche <bvanassche@acm.org>; Alim Akhtar <alim.akhtar@samsung.com>;
> Kiwoong Kim <kwmad.kim@samsung.com>
> Subject: [PATCH] ufs-exynos: Move definitions from .h to .c
> 
> In the Linux kernel definitions of data structures should occur in .c
files.
> Hence move the exynos7_uic_attr definition from a .h into a .c file.
> Additionally, declare exynos_ufs_drvs static. This patch fixes the
following
> two sparse warnings:
> 
> drivers/scsi/ufs/ufs-exynos.h:248:28: warning: symbol 'exynos_ufs_drvs'
> was not declared. Should it be static?
> drivers/scsi/ufs/ufs-exynos.h:250:28: warning: symbol 'exynos7_uic_attr'
> was not declared. Should it be static?
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Kiwoong Kim <kwmad.kim@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
Just for the subject tag consistency, can add subsystem name , scsi: ufs:
<driver_name> 
Rest looks good.
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufs-exynos.c | 27 ++++++++++++++++++++++++++-
> drivers/scsi/ufs/ufs-exynos.h | 26 --------------------------
>  2 files changed, 26 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index 70647eacf195..4c38689ecdd2 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -107,6 +107,7 @@ enum {
> 
>  #define CNTR_DIV_VAL 40
> 
> +static struct exynos_ufs_drv_data exynos_ufs_drvs;
>  static void exynos_ufs_auto_ctrl_hcc(struct exynos_ufs *ufs, bool en);
> static void exynos_ufs_ctrl_clkstop(struct exynos_ufs *ufs, bool en);
> 
> @@ -1231,8 +1232,32 @@ static int exynos_ufs_remove(struct
> platform_device *pdev)
>  	return 0;
>  }
> 
> -struct exynos_ufs_drv_data exynos_ufs_drvs = {
> +static struct exynos_ufs_uic_attr exynos7_uic_attr = {
> +	.tx_trailingclks		= 0x10,
> +	.tx_dif_p_nsec			= 3000000,	/* unit: ns */
> +	.tx_dif_n_nsec			= 1000000,	/* unit: ns */
> +	.tx_high_z_cnt_nsec		= 20000,	/* unit: ns */
> +	.tx_base_unit_nsec		= 100000,	/* unit: ns */
> +	.tx_gran_unit_nsec		= 4000,		/* unit: ns */
> +	.tx_sleep_cnt			= 1000,		/* unit: ns */
> +	.tx_min_activatetime		= 0xa,
> +	.rx_filler_enable		= 0x2,
> +	.rx_dif_p_nsec			= 1000000,	/* unit: ns */
> +	.rx_hibern8_wait_nsec		= 4000000,	/* unit: ns */
> +	.rx_base_unit_nsec		= 100000,	/* unit: ns */
> +	.rx_gran_unit_nsec		= 4000,		/* unit: ns */
> +	.rx_sleep_cnt			= 1280,		/* unit: ns */
> +	.rx_stall_cnt			= 320,		/* unit: ns */
> +	.rx_hs_g1_sync_len_cap		= SYNC_LEN_COARSE(0xf),
> +	.rx_hs_g2_sync_len_cap		= SYNC_LEN_COARSE(0xf),
> +	.rx_hs_g3_sync_len_cap		= SYNC_LEN_COARSE(0xf),
> +	.rx_hs_g1_prep_sync_len_cap	= PREP_LEN(0xf),
> +	.rx_hs_g2_prep_sync_len_cap	= PREP_LEN(0xf),
> +	.rx_hs_g3_prep_sync_len_cap	= PREP_LEN(0xf),
> +	.pa_dbg_option_suite		= 0x30103,
> +};
> 
> +static struct exynos_ufs_drv_data exynos_ufs_drvs = {
>  	.compatible		= "samsung,exynos7-ufs",
>  	.uic_attr		= &exynos7_uic_attr,
>  	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
> diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
> index 06ee565f7eb0..67505fe32ebf 100644
> --- a/drivers/scsi/ufs/ufs-exynos.h
> +++ b/drivers/scsi/ufs/ufs-exynos.h
> @@ -245,30 +245,4 @@ static inline void
> exynos_ufs_disable_dbg_mode(struct ufs_hba *hba)
>  	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), FALSE);  }
> 
> -struct exynos_ufs_drv_data exynos_ufs_drvs;
> -
> -struct exynos_ufs_uic_attr exynos7_uic_attr = {
> -	.tx_trailingclks		= 0x10,
> -	.tx_dif_p_nsec			= 3000000,	/* unit: ns */
> -	.tx_dif_n_nsec			= 1000000,	/* unit: ns */
> -	.tx_high_z_cnt_nsec		= 20000,	/* unit: ns */
> -	.tx_base_unit_nsec		= 100000,	/* unit: ns */
> -	.tx_gran_unit_nsec		= 4000,		/* unit: ns */
> -	.tx_sleep_cnt			= 1000,		/* unit: ns */
> -	.tx_min_activatetime		= 0xa,
> -	.rx_filler_enable		= 0x2,
> -	.rx_dif_p_nsec			= 1000000,	/* unit: ns */
> -	.rx_hibern8_wait_nsec		= 4000000,	/* unit: ns */
> -	.rx_base_unit_nsec		= 100000,	/* unit: ns */
> -	.rx_gran_unit_nsec		= 4000,		/* unit: ns */
> -	.rx_sleep_cnt			= 1280,		/* unit: ns */
> -	.rx_stall_cnt			= 320,		/* unit: ns */
> -	.rx_hs_g1_sync_len_cap		= SYNC_LEN_COARSE(0xf),
> -	.rx_hs_g2_sync_len_cap		= SYNC_LEN_COARSE(0xf),
> -	.rx_hs_g3_sync_len_cap		= SYNC_LEN_COARSE(0xf),
> -	.rx_hs_g1_prep_sync_len_cap	= PREP_LEN(0xf),
> -	.rx_hs_g2_prep_sync_len_cap	= PREP_LEN(0xf),
> -	.rx_hs_g3_prep_sync_len_cap	= PREP_LEN(0xf),
> -	.pa_dbg_option_suite		= 0x30103,
> -};
>  #endif /* _UFS_EXYNOS_H_ */

