Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74970C46467
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 16:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjASQvz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 11:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjASQvt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 11:51:49 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A598CE60
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 08:51:45 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230119165144epoutp046056e9550aa90d0bde1dd74dc584bdc6~7w_vL1NFI0362003620epoutp04F
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 16:51:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230119165144epoutp046056e9550aa90d0bde1dd74dc584bdc6~7w_vL1NFI0362003620epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1674147104;
        bh=exifaxuy3w7f0HxDChS6uAK5ne3KNv4/UnmsP89OK6s=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=HAxZ5ckgNZ+N/VWMkfElwmlltmNlL9lK1AJ0kN18QigadW74Fgnp3fMMeBUAGvyT1
         200L3dhUIj5eU5zUmPbIk4sRTh72lWmb2AeNe0bAGkZ6C7XGoHf28A5GHtrFjhqcGB
         k128mWu6Mzi/BIhASrjP8FggKH4zpUdhowUhUX3A=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230119165143epcas5p4f4fdbf7aa99fc3a09b03c26254c2705f~7w_uzVN3W2429924299epcas5p4G;
        Thu, 19 Jan 2023 16:51:43 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NyTDZ096dz4x9Pp; Thu, 19 Jan
        2023 16:51:42 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.2E.10528.D1579C36; Fri, 20 Jan 2023 01:51:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230119165141epcas5p454b53c718ae71ffe835b27c64452c712~7w_sqEVVL2429924299epcas5p4D;
        Thu, 19 Jan 2023 16:51:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230119165141epsmtrp170c25026c83a550d8145d8695fcee449~7w_spL3bI2601726017epsmtrp1k;
        Thu, 19 Jan 2023 16:51:41 +0000 (GMT)
X-AuditID: b6c32a49-e75fa70000012920-b6-63c9751d6246
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.9A.17995.D1579C36; Fri, 20 Jan 2023 01:51:41 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230119165139epsmtip18c91e3a5329958f2aa0df3d212db4f5a~7w_rEM7ma2568525685epsmtip1i;
        Thu, 19 Jan 2023 16:51:39 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Jaegeuk Kim'" <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Stanley Chu'" <stanley.chu@mediatek.com>,
        "'Jinyoung Choi'" <j-young.choi@samsung.com>
In-Reply-To: <20230112234215.2630817-4-bvanassche@acm.org>
Subject: RE: [PATCH v2 3/3] scsi: ufs: Enable DMA clustering
Date:   Thu, 19 Jan 2023 22:21:38 +0530
Message-ID: <0a3701d92c26$4ddb0900$e9911b00$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMm5ykAdtwQU0o+6B5Pbw7bIF/e7ACiTKZFAMM6HQur/1HAcA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUwbZRz2vTuOgoHdCoOXmkLXBB0kZa1ry/FR3NhCziAOs0XjpsClPT5C
        aWuvHW4misgYUAsli2ZrJsMS3CwLjRUqsgkdG+uabEsUKoKbgoKxS9hABC2YRcqB8t/ze97n
        eX/P7/3gofxRXMCr0pkYo47WivFozHMjbY9EaParpdbJbNI/ewUng6EATl6facbIjxdCKGlt
        68fJWZcdJR0/eBBysm8UIy0TAzh5yfcEIbv7J8H+p6mx8UKq61oQodzOZpyyObyAavAPY9Rf
        riacWpybwqjWPiegltzJ1BmvBSmOPladW8nQGsYoYnRqvaZKV6ESFx4pPViqUEplElkWmSkW
        6egaRiU+9FKxpKBKux5ZLDpBa83rVDHNsuK9eblGvdnEiCr1rEklZgwarUFuyGDpGtasq8jQ
        MaZsmVT6vGJdWFZd+XXoCjD0xr/tnwtidaBzZwuI4kFCDn/sbwctIJrHJ64COPJlA8YVfwDY
        0XN7s1gCcMb2Lbpl6b54M5JbGATwl/fdKFcEAZwfHgJhFU5I4EBXI94CeLx4QgOHp5PCGpQI
        IbB+cRULa6KIbDjh+zwijOOIXGjzfIKHMUakwvbr4xt8DJEFl30BhMM7of/87IYXJVLgV/MX
        NhOJYGjusw19PJEPXb2PUU6TCIOjXFJIjPPg0M3hSM5wCP7+52WEw3Hwoa9vkxfAYFtjZDg0
        JCjo+EfA0ZVw/pILcPgF6B2/gIUlKJEGXYN7uVax0Lo2i3DOGNjUyOfUqfCDRwGMw8/Adosl
        YmvzxdUcG9ht3zaXfdtc9m357f/36gSYEyQxBramgmEVBpmOqf3vutX6GjfYeM/pLw6AB9ML
        GSMA4YERAHmoOD5mh8un5sdo6JOnGKO+1GjWMuwIUKwfdjsq2KXWr38InalUJs+SypVKpTxr
        n1ImTox5TuVX84kK2sRUM4yBMW75EF6UoA7RdMQmpgjvZu9vPT3Q4TKPLR7LMT51cfeY0y37
        qDzzwNEQ2aM6GDie+aDe2lXxZs7tkpVdU0nPluXm1ia3Lhfhp+99x/91/OUSKmltWZCSML1W
        tJZ8H5syyS4runvL51mH6O+7qfK8kil0T41kdeFcYW2Ptuln75k6KMTi0q/2O0LerPv2k7bX
        qGvVTucEsaNt0NPw7tmiGwXaW1rq1XujwrNVh1sEZunKhytpT754Kx+3BAwnvNHDeUOPE88J
        yyLqZ2KJI99Y195LqPPTS+WG5rHDWDSWbBn5bdXz+p3vjz56p1N1p+enV944XnBqOlBSfgt+
        2m3ZV1CQ8LD4vD5fe0CMsZW0LB01svS/PfCpH1gEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWy7bCSnK5s6clkg7+ruC1OPlnDZvHy51U2
        i4MPO1kspn34yWzR27+VzeLJ+lnMFotubGOyuLnlKItF9/UdbBbLj/9jsli69SajA7fH5Sve
        Hov3vGTy2LSqk81jwqIDjB4tJ/ezeHxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAFcVlk5Ka
        k1mWWqRvl8CVsfPnGsaCdSIVJ5++ZGlgXCDYxcjJISFgIrF0/hH2LkYuDiGBHYwSx09+ZoRI
        SEtc3ziBHcIWllj57zmYLSTwnFHi7U0hEJtNQFdix+I2NhBbRCBFYsaCj2A1zAL/mSSaW2Mg
        6ncySiz6Gg5icwpYSVw/vpIVxBYWsJGYsG0uWC+LgKrExINXwOK8ApYSX49fZYKwBSVOznzC
        0sXIATRTT6JtIyPEeHmJ7W/nMEOcpiDx8+kyVogTnCTWr3vPDFEjLvHy6BH2CYzCs5BMmoUw
        aRaSSbOQdCxgZFnFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcoVpaOxj3rPqgd4iR
        iYPxEKMEB7OSCC//+uPJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgt
        gskycXBKNTBpLs22ESmIC3edwyRbYse8/efR4yqe3C9VFqxvf7bcKlXi5q3VfbOyZjErhLOt
        teScX91+6fGzm8KGUe/7ijkLav+cX7GM1aDrQv2tl9P+X4l2jwvmOMjGmBjBWHFr2ycpvgnK
        Jqe3GHgb5RRW+c+ssJuhd09BYM7Veby8s5yVnpzf/EGgctERg9DGayaP7ZMra20ylea9e16y
        +qy0xsy7s2IPuoWa89+JEp4SavNsc6CMoechZdbJnVfDjGVFNJsystdw1Rx/6pDp4Fuiaype
        vEnttf2rBvZj//+9TStZNNHi4fvas9myF//6Pgpym6i2oqK/KtZzqvqys8kXn/y9pvD2WhiX
        DNOzaHm7BUosxRmJhlrMRcWJAJYWnCY/AwAA
X-CMS-MailID: 20230119165141epcas5p454b53c718ae71ffe835b27c64452c712
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230112234327epcas5p18cee53e3d0a473f52d3347437a4ea72e
References: <20230112234215.2630817-1-bvanassche@acm.org>
        <CGME20230112234327epcas5p18cee53e3d0a473f52d3347437a4ea72e@epcas5p1.samsung.com>
        <20230112234215.2630817-4-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>-----Original Message-----
>From: Bart Van Assche [mailto:bvanassche@acm.org]
>Sent: Friday, January 13, 2023 5:12 AM
>To: Martin K . Petersen <martin.petersen@oracle.com>
>Cc: Jaegeuk Kim <jaegeuk@kernel.org>; linux-scsi@vger.kernel.org; Adrian
>Hunter <adrian.hunter@intel.com>; Alim Akhtar
><alim.akhtar@samsung.com>; Bart Van Assche <bvanassche@acm.org>; Avri
>Altman <avri.altman@wdc.com>; Kiwoong Kim <kwmad.kim@samsung.com>;
>James E.J. Bottomley <jejb@linux.ibm.com>; Bean Huo
><beanhuo@micron.com>; Stanley Chu <stanley.chu@mediatek.com>;
>Jinyoung Choi <j-young.choi@samsung.com>
>Subject: [PATCH v2 3/3] scsi: ufs: Enable DMA clustering
>
>All UFS host controllers support DMA clustering. Hence enable DMA
>clustering.
>
>Notes:
>- The max_segment_size parameter implements the 256 KiB limit for the
>  PRDT. The dma_boundary parameter represents a boundary that must not
>  be crossed by DMA scatter/gather lists. I'm not aware of any
>  restrictions on DMA scatter/gather lists in the UFSHCI specification
>  other than the 256 KiB limit for the PRDT and the 32-bit address
>  restriction for controllers that only support 32-bits DMA. The latter
>  restriction is already handled by ufshcd_set_dma_mask().
>- Without patch "Exynos: Fix the maximum segment size", this patch
>  breaks support for the Exynos controller.
>
>The history of the dma_boundary parameter in the UFS driver is as
>follows:
>* The initial UFS driver did not set the dma_boundary parameter.
>* Commit 4dd4130a722f ("scsi: make sure all drivers set the
>  use_clustering flag") set the .use_clustering flag.
>* Commit 4af14d113bcf ("scsi: remove the use_clustering flag") removed
>  the use_clustering flag and set the dma_boundary parameter instead.
>
>Acked-by: Adrian Hunter <adrian.hunter@intel.com>
>Cc: Avri Altman <avri.altman@wdc.com>
>Cc: Alim Akhtar <alim.akhtar@samsung.com>
>Cc: Kiwoong Kim <kwmad.kim@samsung.com>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>


> drivers/ufs/core/ufshcd.c | 1 -
> 1 file changed, 1 deletion(-)
>
>diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
>5fdbc983ce2e..d28b44a1ffcf 100644
>--- a/drivers/ufs/core/ufshcd.c
>+++ b/drivers/ufs/core/ufshcd.c
>@@ -8460,7 +8460,6 @@ static struct scsi_host_template
>ufshcd_driver_template = {
> 	.max_host_blocked	= 1,
> 	.track_queue_depth	= 1,
> 	.sdev_groups		= ufshcd_driver_groups,
>-	.dma_boundary		= PAGE_SIZE - 1,
> 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
> };
>

