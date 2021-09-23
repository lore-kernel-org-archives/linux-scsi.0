Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33200C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 04:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1318960FC1
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 04:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239076AbhIWEYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 00:24:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24290 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhIWEYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 00:24:38 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210923042306epoutp018f2a72a882770cceedc5e29226f6b4c1~nWMNjk96C2524425244epoutp01p
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 04:23:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210923042306epoutp018f2a72a882770cceedc5e29226f6b4c1~nWMNjk96C2524425244epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632370986;
        bh=rRwinmd6UMF3YWgDzL56bj2r/fGFqsjDMjKKorDMFag=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=PhKllIs/srAlkiiexQC0GHtKEESwI52UalNJ04R37CqJmluKyjOZa7sebFT5azbOS
         qA+cpGUp6j6i8fFxYixrnZNUuJrzFblvDQf1lVajEqvPfmHhEf8OXsjuFq3G/RQ/Mo
         bSpKKXV/40/BhJc1D/+A67HLgBnq90D1SrR9Aq+Y=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210923042304epcas5p390014910bf008f8ac4a0cf0250d0fce4~nWMMaARVE1598615986epcas5p3E;
        Thu, 23 Sep 2021 04:23:04 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HFMTZ0Lp8z4x9QC; Thu, 23 Sep
        2021 04:22:58 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.EB.59762.1210C416; Thu, 23 Sep 2021 13:22:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20210923041447epcas5p13f8667b73e52e6a22e379a54584cd7ac~nWE9VsWB91034410344epcas5p1M;
        Thu, 23 Sep 2021 04:14:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210923041447epsmtrp20555ab459c0dc355229dab3985ff5711~nWE9Ur9I90364503645epsmtrp2P;
        Thu, 23 Sep 2021 04:14:47 +0000 (GMT)
X-AuditID: b6c32a49-125ff7000000e972-b3-614c0121241c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.D2.08750.73FFB416; Thu, 23 Sep 2021 13:14:47 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210923041444epsmtip1d2f3e8ba950339f95bcd894730c84cf9~nWE60J-aJ2950429504epsmtip1n;
        Thu, 23 Sep 2021 04:14:44 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Chanho Park'" <chanho61.park@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>
Cc:     "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <20210917065436.145629-10-chanho61.park@samsung.com>
Subject: RE: [PATCH v3 09/17] scsi: ufs: ufs-exynos: correct timeout value
 setting registers
Date:   Thu, 23 Sep 2021 09:44:43 +0530
Message-ID: <001501d7b031$8bb26790$a31736b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQEFFhnDAOXa6Wap+WXaUA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsWy7bCmuq4io0+iwcG/VhYnn6xhs3j58yqb
        xcGHnSwW0z78ZLb4tH4Zq8Xl/doWPTudLU5PWMRk8WT9LGaLRTe2MVlsfPuDyeLmlqMsFjPO
        72Oy6L6+g81i+fF/TA78HpeveHvMauhl87jc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPH9/Ud
        bB4fn95i8ejbsorR4/MmOY/2A91MATxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqG
        lhbmSgp5ibmptkouPgG6bpk5QN8oKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgpM
        CvSKE3OLS/PS9fJSS6wMDQyMTIEKE7IzZnXfYSw4J1TxdOMOxgbGVQJdjJwcEgImEq8/9bF2
        MXJxCAnsZpRY3fOeEcL5xCix78paFgjnM6PEnZ6dTDAtz7svM0EkdjFKHJu+F8p5ySix7scO
        sCo2AV2JHYvb2EASIgKNTBKnH29mBnGYBaYyS8xaO4MZpIpTwFHiTfthMFtYIE7i+IXX7CA2
        i4CqxKmJN8BsXgFLiUdX/7NB2IISJ2c+YQGxmQW0JZYtfM0McZOCxM+ny1hBbBEBJ4mlOxcx
        QdSIS7w8eoQdoqaZU6JxnlMXIweQ7SLxbp4sRFhY4tXxLVAlUhKf3+1lgyjJlujZZQwRrpFY
        Ou8YC4RtL3HgyhwWkBJmAU2J9bv0IcKyElNPrYNayifR+/sJNLB4JXbMg7FVJZrfXYUaIy0x
        sbubdQKj0iwkf81C8tcsJPfPQti2gJFlFaNkakFxbnpqsWmBYV5qOTzCk/NzNzGCE7uW5w7G
        uw8+6B1iZOJgPMQowcGsJML7+YZXohBvSmJlVWpRfnxRaU5q8SFGU2BgT2SWEk3OB+aWvJJ4
        QxNLAxMzMzMTS2MzQyVx3o+vLROFBNITS1KzU1MLUotg+pg4OKUamKy2ffSfGmJtai6x2YLp
        /LV3Od2HGy/HvFm5senx3Q9dkWlFBTdvGobOYJ64k1E8uF3K8rBlxByFyWLBp5f/Mno5WfPY
        DeuiD6/OZ7ptW2vlG8/jkuEud0fNbk9+WJHi7jeHFe04PHV/lb24UTi/cPr8+Utm/bn5Ouho
        mweTCN/xn9Fz9x/azrR8BdMa2e3JBdcvPYydfKrKMN98fnRQjM7tlLSlpVeErd1TeTo335V4
        feG0T9LzmsKvT5xeJ+ypss6oNJ7rLNFi9KtmWpLs4fnR2ZkRUjJHZr5YK/B32p7D3FfzG0/P
        bzSOjWTaefH2ar32kC3hSdJaJ+TtjNlnd3dWvn6fbMyyzueZj+1dJSWW4oxEQy3mouJEADSY
        fyR1BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWy7bCSnK75f+9Eg9ab5hYnn6xhs3j58yqb
        xcGHnSwW0z78ZLb4tH4Zq8Xl/doWPTudLU5PWMRk8WT9LGaLRTe2MVlsfPuDyeLmlqMsFjPO
        72Oy6L6+g81i+fF/TA78HpeveHvMauhl87jc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPH9/Ud
        bB4fn95i8ejbsorR4/MmOY/2A91MATxRXDYpqTmZZalF+nYJXBmfG3YxFzQJVbxc1sDYwPiI
        v4uRk0NCwETiefdlpi5GLg4hgR2MEpP/vmaESEhLXN84gR3CFpZY+e85O0TRc0aJY3cegRWx
        CehK7FjcxgaSEBFoZpKY2XCGEcRhFpjLLLFy7n6olmOMEnNf94G1cAo4SrxpP8wMYgsLxEg8
        WjQLLM4ioCpxauINsH28ApYSj67+Z4OwBSVOznzCAmIzC2hLPL35FM5etvA1M8R9ChI/ny5j
        BbFFBJwklu5cxARRIy7x8ugR9gmMwrOQjJqFZNQsJKNmIWlZwMiyilEytaA4Nz232LDAKC+1
        XK84Mbe4NC9dLzk/dxMjOMa1tHYw7ln1Qe8QIxMH4yFGCQ5mJRHezze8EoV4UxIrq1KL8uOL
        SnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgqhXzvGUVyK/zNupG2jWGXRe/
        PO3xmWDAtepEv8LbE+YaM1VnVb3LW7LMubs99b3Jks5wpd/C76ffOHZVLOsrr9+dDRarLnmc
        TXx/RzJ7woHbjPZbVSe52vpeW7Y769CzjCOsggc6X96K3pIS5rXw06fzDfr3znXkP9/0/o3r
        wunVm/K5VSvfxR+SzT3OZfu9916sUdeRngevMrMyppleipV+xqK0askSM2XPioMfT6gk5Uxx
        ESn82qnCEvnzYH/GvgN+oXLLVize4Zu4M7L+Zba8xoffve6986atO+luMnGCwfT465qGNy61
        XjS54GTSm2d25d7DiyH6ST/0lzF2RIrcYxfP3vt22tUk5xsHdyqxFGckGmoxFxUnAgCVY3yU
        YAMAAA==
X-CMS-MailID: 20210923041447epcas5p13f8667b73e52e6a22e379a54584cd7ac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p15b648b88af85252fe12ff8026307526a
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p15b648b88af85252fe12ff8026307526a@epcas2p1.samsung.com>
        <20210917065436.145629-10-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>-----Original Message-----
>From: Chanho Park =5Bmailto:chanho61.park=40samsung.com=5D
>Sent: Friday, September 17, 2021 12:24 PM
>To: Alim Akhtar <alim.akhtar=40samsung.com>; Avri Altman
><avri.altman=40wdc.com>; James E . J . Bottomley <jejb=40linux.ibm.com>; M=
artin
>K . Petersen <martin.petersen=40oracle.com>; Krzysztof Kozlowski
><krzysztof.kozlowski=40canonical.com>
>Cc: Bean Huo <beanhuo=40micron.com>; Bart Van Assche
><bvanassche=40acm.org>; Adrian Hunter <adrian.hunter=40intel.com>; Christo=
ph
>Hellwig <hch=40infradead.org>; Can Guo <cang=40codeaurora.org>; Jaegeuk Ki=
m
><jaegeuk=40kernel.org>; Gyunghoon Kwon <goodjob.kwon=40samsung.com>;
>linux-samsung-soc=40vger.kernel.org; linux-scsi=40vger.kernel.org; Chanho =
Park
><chanho61.park=40samsung.com>; Kiwoong Kim <kwmad.kim=40samsung.com>
>Subject: =5BPATCH v3 09/17=5D scsi: ufs: ufs-exynos: correct timeout value=
 setting
>registers
>
>PA_PWRMODEUSERDATA0 -> DL_FC0PROTTIMEOUTVAL
>PA_PWRMODEUSERDATA1 -> DL_TC0REPLAYTIMEOUTVAL
>PA_PWRMODEUSERDATA2 -> DL_AFC0REQTIMEOUTVAL
>
>Cc: Alim Akhtar <alim.akhtar=40samsung.com>
>Cc: Kiwoong Kim <kwmad.kim=40samsung.com>
>Cc: Krzysztof Kozlowski <krzysztof.kozlowski=40canonical.com>
>Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
>---
Please add a =5BFixes=5D tag with the original commit which introduce this

With the above fix, feel free to add

Reviewed-by: Alim Akhtar <alim.akhtar=40samsung.com>

> drivers/scsi/ufs/ufs-exynos.c =7C 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c=
 index
>2024e44a09d7..e32f7d09db1a 100644
>--- a/drivers/scsi/ufs/ufs-exynos.c
>+++ b/drivers/scsi/ufs/ufs-exynos.c
>=40=40 -644,9 +644,9 =40=40 static int exynos_ufs_pre_pwr_mode(struct ufs_=
hba
>*hba,
> 	=7D
>
> 	/* setting for three timeout values for traffic class =230 */
>-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 8064);
>-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
>28224);
>-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
>20160);
>+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_FC0PROTTIMEOUTVAL), 8064);
>+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_TC0REPLAYTIMEOUTVAL),
>28224);
>+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), 20160);
>
> 	return 0;
> out:
>--
>2.33.0


