Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC4FC46467
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Jan 2023 06:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjAKGUq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 01:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235922AbjAKGUi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 01:20:38 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143EEE0EA
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2023 22:20:34 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230111062031epoutp01dd6bd386f8da8252a13792973125ca7c~5LNVsg5Dc2124921249epoutp018
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 06:20:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230111062031epoutp01dd6bd386f8da8252a13792973125ca7c~5LNVsg5Dc2124921249epoutp018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673418031;
        bh=nr97TZL60HiqpG3IAr6GquBVhAWwFcDVumK8sUGr8Hg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=gXKvuHsXYM5U5KFMB2rJAjXSwALGF0cR7SrAJKT4jL6ZR/gD0Njep64WN/9pj7PGs
         SLQq1DjhSF5pu55VUNAJ+1aGl8IFPd3MIdiTfdr0cAg1D2XSKARhQnHSNTqv+MxJqd
         NazOMQBKzhi00xJdFNhL8I94B7/HV1TjEBFnCo38=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230111062031epcas5p2ac36ebcb452cb4471be64add7d527d0b~5LNVMe5iN2023720237epcas5p2y;
        Wed, 11 Jan 2023 06:20:31 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NsHbx5vdwz4x9Q9; Wed, 11 Jan
        2023 06:20:29 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.65.62806.D255EB36; Wed, 11 Jan 2023 15:20:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230111062029epcas5p1f958e1cde24c817b1d9e757d9cfa35cf~5LNTVaFvA0761507615epcas5p1H;
        Wed, 11 Jan 2023 06:20:29 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230111062029epsmtrp1da80a4a8ca2e0a4bfa72901d922ad47c~5LNTUPpVI0084600846epsmtrp1G;
        Wed, 11 Jan 2023 06:20:29 +0000 (GMT)
X-AuditID: b6c32a4a-ea5fa7000000f556-c7-63be552d7e7c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C1.C8.10542.D255EB36; Wed, 11 Jan 2023 15:20:29 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230111062026epsmtip2d370b7df45179a01e509cdfbd5fedb80~5LNRIGBwy1990619906epsmtip2D;
        Wed, 11 Jan 2023 06:20:26 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@linaro.org>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Stanley Chu'" <stanley.chu@mediatek.com>,
        "'Jinyoung Choi'" <j-young.choi@samsung.com>,
        "'Chanho Park'" <chanho61.park@samsung.com>,
        "'Arthur Simchaev'" <Arthur.Simchaev@wdc.com>,
        "'Keoseong Park'" <keosung.park@samsung.com>,
        "'Yoshihiro Shimoda'" <yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230106215800.2249344-2-bvanassche@acm.org>
Subject: RE: [PATCH 1/3] scsi: ufs: Exynos: Fix DMA alignment for PAGE_SIZE
 != 4096
Date:   Wed, 11 Jan 2023 11:50:25 +0530
Message-ID: <018c01d92584$ccff6260$66fe2720$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQFZzN7Pa8YB12UZCtrq39dv9ZdUcwLWTWUKAmOrQgOvbZ7DgA==
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUxbVRzN7Xt9tHM1b4ByV8eEh8sEUmgZdI9lbNMt+kKJkixIoi7do322
        hPLatUUHIlnkYwMcH1NYqAwQYhFc5KvUsvE1hDDYRkygAhN1DEZSNpDRTUWWYcubyn/nnJxz
        fzm/e68A8V3AxIJU1swYWVpHYNtQ+w+heyWSpF6VdPXbMHJk/jJGFpZb+aRrzYmR12YLUbJy
        ZQ0hx/vCyfOlnRg532JByPopO48cHlkGZM/9Th9y2jaEksWTDoxsHH7KI7/unAbk4x43dgSn
        xicUVEO3i0e1Nxdi1MxP3RhVVt8PqLyRPpT6s+UcRj28dxul/rhZjlIltmZAudt3U2f7i3mJ
        299NO6hlaDVjDGJYlV6dymriCMVx5VFljFwqk8hiyf1EEEunM3HEsYREyRupOk8pIuhDWpfh
        kRJpk4mIPHTQqM8wM0FavckcRzAGtc4QbYgw0emmDFYTwTLmAzKpNCrGYzyZps29+xlquL7r
        9OdLD8AZ0AWLgFAA8WiYb3ViRWCbwBe/CmBzxSUeR1YBnF268Yy4ARwfd3iIYDNy9WI8p18B
        sGvhEuCIC0Dnp3Wo91wMl0BHQwHmDfjjath3Z6fXg+AbKHSftSNejxA/AC09ZZvYD0+CDwZt
        m1kU3wMvzMzzvViEx8KSxVs8Du+AI1Xzmx4Efxl+v1SNcB2C4No9K5/TA6BraNDHi/3x12Fx
        TRPqHQzxUiFsnX7E5xocg0uDgVzWDy4O23w4LIau0gIfzkLB+idiTtbCpcYWwOHDsH+iGvVa
        EDwUtlyJ5KY+D8+vzz9bjwieK/Dl3Htg7rIT5fBLsLy4mM9hCjYuf8EvA8GWLb0sW3pZtnSx
        /D+sDqDNYCdjMKVrGFOMIYplPvrvtlX69Haw+eDD4h1g9s5KxADgCcAAgAKE8Bc1CbtVviI1
        nZnFGPVKY4aOMQ2AGM+yyxHxCyq958ewZqUsOlYaLZfLo2P3yWVEgIjprFX54hrazKQxjIEx
        /pvjCYTiM7yQtlcL6ui8X1ZqnpzITF0Pv0bFo4OhJ6crL1/oHivpzu1K/8o+MdOqtN4UBd46
        Ab7zWclXPPqm8rVAyScpqjn/I/2at8IfXncnR+Yn/z1W0VYpzEl6j+0xdcj79lH2mJKxjRf/
        StRRzueyR61T0p+HmgMij3dMjWmyNxoyqnpPv5/X+0rHXcXFQLWy4/ejwmQ2++mv0sxayyid
        57ZCW4rD3DT1eEcAcJNZJftz12vflLZoq26kuSreGXbsXY8asC+uNiUEl1K7nMbbk3JMUfPl
        wgc5kSO7TwX4TW7PEfe1pYTc50sPJ4TMjSKngueyV6t/LEr+rcLv0MdvZ2XZaGK9lUBNWloW
        hhhN9D9ytIaXeQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsWy7bCSvK5u6L5kg/NXmS1OPlnDZtE5cRmr
        xcufV9ksDj7sZLGY9uEns8Xl/doWvf1b2SyerJ/FbLHoxjYmi+Mn3zFa7H29ld3i5pajLBbd
        13ewWSw//o/JYunWm4wWX/d+ZnMQ8Lh8xdtj8Z6XTB6bVnWyedy5tofNY8KiA4weLSf3s3h8
        X9/B5vHx6S0Wj29nJrJ49G1ZxejxeZOcR/uBbqYAnigum5TUnMyy1CJ9uwSujOZHPSwFJ2Qq
        Jr99w9jAuFOii5GDQ0LARGL3dK8uRi4OIYEdjBLXNzxj7GLkBIpLS1zfOIEdwhaWWPnvOTtE
        0XNGiY/fNrOBJNgEdCV2LG4Ds0UEUiRmLPgIVsQs0M4q8fT9YzaIjp2MEhsvb2MFqeIUsJKY
        tXcCM4gtLBAs8X39XDCbRUBVYtKdJ2A1vAKWEn2vzjJB2IISJ2c+YQE5lVlAT6JtI9h1zALy
        EtvfzmGGuE5B4ufTZawQcXGJl0ePsEMc5CTRPW8lywRG4VlIJs1CmDQLyaRZSLoXMLKsYpRM
        LSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjnQtrR2Me1Z90DvEyMTBeIhRgoNZSYR3Jeee
        ZCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYXHStXFdN
        UeE+uC9z5jK7rPQwt8cZwod7j80x4d5tMNv24Cn+N/Xi17dx1kZVf/Rx/GO1dI3kpGAeIc1C
        7sVBR/QTrTd+OXbdm+n5Icfb36zm3mZiaFkcdmnqYsUO10mLdjV+PnMlpXbvkqDXT9jn/UpW
        /LNtzbvdTlJhR6ySSo4bSobtSwhSMyrb0rptkXJ8yd2jqQ4rj+jXbIqwOhAiwRt5KlZiz/YD
        An8m3Ob9o746ZOFGu1PH/NbIddSUPZygeJHLwSr1xv3ItI937P7JrD0472CrjYcdQ9t8hVnL
        RBJeaXQIyN/5/KdJ44byvtM1xwTlV1qb3sp8Yufx/lnQilMttoLKBQ/uZt1Xf75YXImlOCPR
        UIu5qDgRAAt+Y8NjAwAA
X-CMS-MailID: 20230111062029epcas5p1f958e1cde24c817b1d9e757d9cfa35cf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230106215848epcas5p2f0d732867938d23852ba8c4c59bd2a2b
References: <20230106215800.2249344-1-bvanassche@acm.org>
        <CGME20230106215848epcas5p2f0d732867938d23852ba8c4c59bd2a2b@epcas5p2.samsung.com>
        <20230106215800.2249344-2-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

>-----Original Message-----
>From: Bart Van Assche [mailto:bvanassche@acm.org]
>Sent: Saturday, January 7, 2023 3:28 AM
>To: Martin K . Petersen <martin.petersen@oracle.com>
>Cc: Jaegeuk Kim <jaegeuk@kernel.org>; Avri Altman
><avri.altman@wdc.com>; Adrian Hunter <adrian.hunter@intel.com>; linux-
>scsi@vger.kernel.org; Bart Van Assche <bvanassche@acm.org>; Kiwoong Kim
><kwmad.kim@samsung.com>; James E.J. Bottomley <jejb@linux.ibm.com>;
>Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>; Bean Huo
><beanhuo@micron.com>; Stanley Chu <stanley.chu@mediatek.com>;
>Jinyoung Choi <j-young.choi@samsung.com>; Chanho Park
><chanho61.park@samsung.com>; Alim Akhtar <alim.akhtar@samsung.com>;
>Arthur Simchaev <Arthur.Simchaev@wdc.com>; Keoseong Park
><keosung.park@samsung.com>; Yoshihiro Shimoda
><yoshihiro.shimoda.uh@renesas.com>
>Subject: [PATCH 1/3] scsi: ufs: Exynos: Fix DMA alignment for PAGE_SIZE !=
>4096
>
>The Exynos UFS controller only supports scatter/gather list elements that
are
>aligned on a 4 KiB boundary. Fix DMA alignment in case PAGE_SIZE != 4096.
>Rename UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE into
>UFSHCD_QUIRK_4KB_DMA_ALIGNMENT.
>
>Cc: Kiwoong Kim <kwmad.kim@samsung.com>
>Fixes: 2b2bfc8aa519 ("scsi: ufs: Introduce a quirk to allow only
page-aligned sg
>entries")
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---
Thanks!

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

Tested on platforms containing Exynos HCI, so feel free to add

Tested-by: Alim Akhtar <alim.akhtar@samsung.com>

> drivers/ufs/core/ufshcd.c     | 4 ++--
> drivers/ufs/host/ufs-exynos.c | 2 +-
> include/ufs/ufshcd.h          | 4 ++--
> 3 files changed, 5 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
>99ca5b035028..be18edf4ef7f 100644
>--- a/drivers/ufs/core/ufshcd.c
>+++ b/drivers/ufs/core/ufshcd.c
>@@ -5029,8 +5029,8 @@ static int ufshcd_slave_configure(struct scsi_device
>*sdev)
> 	ufshcd_hpb_configure(hba, sdev);
>
> 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD -
>1);
>-	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
>-		blk_queue_update_dma_alignment(q, PAGE_SIZE - 1);
>+	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
>+		blk_queue_update_dma_alignment(q, 4096 - 1);
> 	/*
> 	 * Block runtime-pm until all consumers are added.
> 	 * Refer ufshcd_setup_links().
>diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
>index c3628a8645a5..3cdac89a28b8 100644
>--- a/drivers/ufs/host/ufs-exynos.c
>+++ b/drivers/ufs/host/ufs-exynos.c
>@@ -1673,7 +1673,7 @@ static const struct exynos_ufs_drv_data
>exynos_ufs_drvs = {
>
>UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
>
>UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
>
>UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING |
>-
>UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE,
>+				  UFSHCD_QUIRK_4KB_DMA_ALIGNMENT,
> 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
>
>EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
> 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
>diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
>dd5912b4db77..583611444f12 100644
>--- a/include/ufs/ufshcd.h
>+++ b/include/ufs/ufshcd.h
>@@ -567,9 +567,9 @@ enum ufshcd_quirks {
> 	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
>
> 	/*
>-	 * This quirk allows only sg entries aligned with page size.
>+	 * Align DMA SG entries on a 4 KiB boundary.
> 	 */
>-	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
>+	UFSHCD_QUIRK_4KB_DMA_ALIGNMENT			= 1 <<
>14,
>
> 	/*
> 	 * This quirk needs to be enabled if the host controller does not

