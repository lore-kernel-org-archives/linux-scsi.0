Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0C9C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 09:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C518B2077D
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 09:08:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DCq1mAXx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387603AbgDBJIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 05:08:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43206 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbgDBJIK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 05:08:10 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200402090808euoutp026612e45100bb8b76a6fa0dd12b467b6b~B9YNoMh_G2580325803euoutp02j
        for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2020 09:08:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200402090808euoutp026612e45100bb8b76a6fa0dd12b467b6b~B9YNoMh_G2580325803euoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585818488;
        bh=asznQ57AgKXctQyXnSLxpd9aafCh0Jk4sgBlNpSnANU=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=DCq1mAXxIDaSxHxpeRIVkne8Wj7EmZloM/tdjWAcOmOCJECrruQ1CVh/vyiPHrcOw
         aPi/PFq+WQojiM8QzV1a26nfs69xZSaE5fSn9PQ5Mfj0AWB3cZbfidTjBuAwk8mKtF
         JiLQgl5Tjqob102AIjW/FmhhyCbtCyvqq13rvYY4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200402090808eucas1p1fbfc3689c5f07a6a265c2b3ed47adb4c~B9YNYBsuP3050630506eucas1p1k;
        Thu,  2 Apr 2020 09:08:08 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 89.4F.60679.87BA58E5; Thu,  2
        Apr 2020 10:08:08 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200402090807eucas1p28d1d6230415b824480aa85b26799e557~B9YM86rAZ0745007450eucas1p2m;
        Thu,  2 Apr 2020 09:08:07 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200402090807eusmtrp15838a1b52c2cc4e831f78afe3915b957~B9YM8Gyby0619506195eusmtrp1j;
        Thu,  2 Apr 2020 09:08:07 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-95-5e85ab78b09b
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 7A.9B.07950.77BA58E5; Thu,  2
        Apr 2020 10:08:07 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200402090807eusmtip1e36bef344917b921797df3b92c373652~B9YMfgCMF1756717567eusmtip1s;
        Thu,  2 Apr 2020 09:08:07 +0000 (GMT)
Subject: Re: [PATCH v2] scsi: hisi_sas: Fix build error without SATA_HOST
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, chenxiang66@hisilicon.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <c4e9d7a0-668a-5dee-2a15-5e5392c2f275@samsung.com>
Date:   Thu, 2 Apr 2020 11:08:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200402085812.32948-1-yuehaibing@huawei.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsWy7djP87oVq1vjDJqX81lcv3aF0WLRjW1M
        Fpv2N7FaXN41h82i+/oONovlx/8xWdz5+pzFgd3j8dyN7B4tR96yekxYdIDR4+PTWywenzfJ
        BbBGcdmkpOZklqUW6dslcGWc6ZzEXLCWq+LrwltsDYxHOLoYOTkkBEwkXl9/wtLFyMUhJLCC
        UeLwhd/sEM4XRokXr58yg1QJCXxmlDh+LAOmo3nyVSaIouWMEs+evmWDcN4CtR9sYAKpEhbw
        lJjTvQbMFhFQk2g5tYUZpIhZYBGjxLeFc8ESbAJWEhPbVzGC2LwCdhLt2z6zgtgsAioS/060
        s4PYogIREp8eHGaFqBGUODkT5FhODk4Ba4m3dy+B9TILiEvcejKfCcKWl9j+dg7YMgmBXewS
        L3tWskDc7SJx7slBKFtY4tXxLewQtozE6ck9LBAN6xgl/na8gOreziixfPI/Nogqa4k7534B
        2RxAKzQl1u/Shwg7Sty5e5MRJCwhwCdx460gxBF8EpO2TWeGCPNKdLQJQVSrSWxYtoENZm3X
        zpXMExiVZiF5bRaSd2YheWcWwt4FjCyrGMVTS4tz01OLjfJSy/WKE3OLS/PS9ZLzczcxAtPQ
        6X/Hv+xg3PUn6RCjAAejEg9vRUZLnBBrYllxZe4hRgkOZiURXscZrXFCvCmJlVWpRfnxRaU5
        qcWHGKU5WJTEeY0XvYwVEkhPLEnNTk0tSC2CyTJxcEo1MNbo9nfp6hllOT3o2udRN2+SGNdL
        5sU712UemaouFnLir+TbyzyeVpEitlIFf45d+f398xELGReubJs+cfNsfmGTfO7+iuD/fy9o
        hToqq/v/Zb2vOv379yTDHzNmnmq5lsl5LlS+6fb8W1FX0p+032K5yN+mZaW29u3qmi0XXVJv
        WDlmLNugpsRSnJFoqMVcVJwIANGFncQ/AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t/xu7rlq1vjDO4u1rW4fu0Ko8WiG9uY
        LDbtb2K1uLxrDptF9/UdbBbLj/9jsrjz9TmLA7vH47kb2T1ajrxl9Ziw6ACjx8ent1g8Pm+S
        C2CN0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7UyMlXSt7NJSc3JLEst0rdL0Ms4
        0zmJuWAtV8XXhbfYGhiPcHQxcnJICJhINE++ytTFyMUhJLCUUeLH1dUsXYwcQAkZiePryyBq
        hCX+XOtig6h5zSjx4MsjNpCEsICnxJzuNUwgtoiAmkTLqS3MIEXMAosYJVYu6WGE6NjPKLH8
        3D12kCo2ASuJie2rGEFsXgE7ifZtn1lBbBYBFYl/J9rBakQFIiQO75gFVSMocXLmExYQm1PA
        WuLt3UtgcWYBdYk/8y4xQ9jiEreezGeCsOUltr+dwzyBUWgWkvZZSFpmIWmZhaRlASPLKkaR
        1NLi3PTcYiO94sTc4tK8dL3k/NxNjMC423bs55YdjF3vgg8xCnAwKvHwVmS0xAmxJpYVV+Ye
        YpTgYFYS4XWc0RonxJuSWFmVWpQfX1Sak1p8iNEU6LmJzFKiyfnAlJBXEm9oamhuYWlobmxu
        bGahJM7bIXAwRkggPbEkNTs1tSC1CKaPiYNTqoFxQtJvltCWo1PYuFc8fP+Fg8122r4yuZj2
        +tpXuYpv/H0P186ctc3gZFptzRmDtlUlrl32C0O89Nr4l+UvWWr3tjHhjnbSrMmnfj5LO/Qj
        brtld1DlrrUrE2a+PnXuB9O5dRtzf5Y/iljc9X/Z8/1pmf4WK8rTlM44LJ9R6nX6zII5s6Iv
        CbquVGIpzkg01GIuKk4EANCH//DRAgAA
X-CMS-MailID: 20200402090807eucas1p28d1d6230415b824480aa85b26799e557
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200402085851eucas1p2b2173a11582e32a73689d4fc98d94c6a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200402085851eucas1p2b2173a11582e32a73689d4fc98d94c6a
References: <20200402063021.34672-1-yuehaibing@huawei.com>
        <CGME20200402085851eucas1p2b2173a11582e32a73689d4fc98d94c6a@eucas1p2.samsung.com>
        <20200402085812.32948-1-yuehaibing@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 4/2/20 10:58 AM, YueHaibing wrote:
> If SATA_HOST is n, build fails:
> 
> drivers/scsi/hisi_sas/hisi_sas_main.o: In function `hisi_sas_fill_ata_reset_cmd':
> hisi_sas_main.c:(.text+0x2500): undefined reference to `ata_tf_to_fis'
> 
> Select SATA_HOST to fix this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: bd322af15ce9 ("ata: make SATA_PMP option selectable only if any SATA host driver is enabled")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

PS I have audited all drivers dependent on ATA again and this is
the only driver needing fixing.

> ---
> v2: use correct Fixes tag
> ---
>  drivers/scsi/hisi_sas/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
> index 90a17452a50d..13ed9073fc72 100644
> --- a/drivers/scsi/hisi_sas/Kconfig
> +++ b/drivers/scsi/hisi_sas/Kconfig
> @@ -6,6 +6,7 @@ config SCSI_HISI_SAS
>  	select SCSI_SAS_LIBSAS
>  	select BLK_DEV_INTEGRITY
>  	depends on ATA
> +	select SATA_HOST
>  	help
>  		This driver supports HiSilicon's SAS HBA, including support based
>  		on platform device
> 

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
