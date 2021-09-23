Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDE5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 04:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2393B610A0
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 04:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbhIWEnB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 00:43:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42902 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238259AbhIWEm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 00:42:57 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210923044125epoutp010223bab827fa25b94cba81dda9bbfccb~nWcNFm0qI1141211412epoutp01I
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 04:41:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210923044125epoutp010223bab827fa25b94cba81dda9bbfccb~nWcNFm0qI1141211412epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632372085;
        bh=yRHDRouJAW5IeHzOP/w9wjy+cTK4zGdaKeDTly6TpOI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=J9JJng6i98AX5glj7xKJgijKA6lf9QNs0ratk/2xFkSH3waRU+zXjs6BmkU7ogCcC
         G92NuLvbgUGWeiOJMouQjOju3YXtabGf1ZYm3Cf1X9mnjlXGzzRhXy6GfAJ14W/ZMR
         hu3OUpmCHSvBlyLs+cO/eXtQIIqvtkcHnrXGjXwQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20210923044124epcas5p268d28a3e021dcaaabd8f91755683da3d~nWcMf6Fb72717927179epcas5p2W;
        Thu, 23 Sep 2021 04:41:24 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HFMtg1YmYz4x9QC; Thu, 23 Sep
        2021 04:41:15 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E2.82.59762.8650C416; Thu, 23 Sep 2021 13:41:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20210923043236epcas5p11be92802b457867d3f7ec462dfef0804~nWUgxutTX1703217032epcas5p1u;
        Thu, 23 Sep 2021 04:32:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210923043236epsmtrp1dcc7f4af5903f3693910255fdf2c53a2~nWUgwzmiW2117821178epsmtrp1H;
        Thu, 23 Sep 2021 04:32:36 +0000 (GMT)
X-AuditID: b6c32a49-10fff7000000e972-02-614c0568672d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A5.71.09091.4630C416; Thu, 23 Sep 2021 13:32:36 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210923043234epsmtip238dbaf2f2a8ba0d15f326532ea1f9cd8~nWUepTjbM1671416714epsmtip2H;
        Thu, 23 Sep 2021 04:32:34 +0000 (GMT)
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
In-Reply-To: <20210917065436.145629-12-chanho61.park@samsung.com>
Subject: RE: [PATCH v3 11/17] scsi: ufs: ufs-exynos: add
 EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
Date:   Thu, 23 Sep 2021 10:02:33 +0530
Message-ID: <001701d7b034$08cb2d00$1a618700$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQHzRyONAZYLouep7HhxoA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfVCTdRzv9zzPHobX5BHx+AFJ+NyZCQ22NuhZx0sp2pNYN/Pyzq6LnoMn
        4Nie7baR4dndgM6cc4AaCNNQIF6OwDVYOKckQsjxohUvB1FWCgbDIhx3Aodl2x4p/vt8Pt/P
        9+33IkSDJ/FwYQ5nYHUcoyLxdVh79/bnxdmCvYykqCCR6ptqxin38ihOXb9jwqjy+WWU8tjq
        BdTwtRjqxOWd1EBpDUJN2awoVTPejlD2P5cQ6kdHD0ZVfPcNQpnHnDjV0PsP8koQPTySRluN
        FpweLrYgdFtjNF171Y3QrU0mnC6t6QT0ou0YTj+4N4HRxY4mQC+0RtKfdpoR5dPv5CZms0wm
        q4tiuQxNZg6XlUSm7U/fmR6fIJGKpQrqJTKKY9RsEpm6VynenaPybkNGfcio8rySktHrybjk
        RJ0mz8BGZWv0hiSS1WaqtHJtrJ5R6/O4rFiONbwslUhejPca38/NPlPfK9DWbfrIWViFG8FE
        8HEQKISEHJrLRsFxsE4YTFwB8BePRcATD4DT3Y9RnjwEsMPdj66mWCcrET7QAeCZR78H8MQN
        4E/fDwf4XDghhs7ao7gvEEIUIHBgss1fCyXKUGhtqfDXCiRehb/arwp8eCPBwq67duDDGLEV
        dkx84feICAVcKFgU8HgD7KucwnwYJWJgffX9JzNFweV79X5PCLEDtvxRifOeUOju+dY/HiSK
        AmGz6aF3cKGXpMKyhn187kY42+sI4HE4dJccDeAtufCES8bLR2Bd1Q2Mxymwc+Qc5rOgxHZo
        c8Xx8mZY1n8R4buuh5aVKYTXRdBZtYq3wqK50SdlIuBJs1lQCkjrmsWsaxazrlnA+n+3CwBr
        AmGsVq/OYvXxWinHHvrvxjM06lbgf+3RrzvB7d/mY7sAIgRdAApRMkS0ML6HCRZlMvmHWZ0m
        XZenYvVdIN572ifR8E0ZGu934QzpUrlCIk9ISJArZAlSMlT04L6CCSayGAOby7JaVreahwgD
        w42I6NnbFskoESSbX/rMRq4wjoKwiEVsZsTmcdSmXPx42LKr5Dkw2KRoyDVdq9FtW5lt+1lu
        ljjeqO5688643eRqpnSHJouORD6TbO9saag+kF5MDynzuZ7alMYPPne5UmMvvbY/P7GjZLc4
        NPLGykTau47TxFnl5lTrGPjkhfK/6it6z53+u1D5pf1uu7xtJOjtQU6WF9P7Q+vswE22rudx
        p6y/9Lpxn2y6Fo+bKbwVdOGtW+sDIkxPJQ+e31De9vXBbWpzedBXTbqZ7sPxly917wrbMiSe
        Uw71OeejGw/0HdtCsGcHPPZHoTsc3MEe49y00YWrFk45rtwcS9SY33MvjZCYPpuRRqM6PfMv
        pIRoKHYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWy7bCSvG4Ks0+iwaMOKYuTT9awWbz8eZXN
        4uDDThaLaR9+Mlt8Wr+M1eLyfm2Lnp3OFqcnLGKyeLJ+FrPFohvbmCw2vv3BZHFzy1EWixnn
        9zFZdF/fwWax/Pg/Jgd+j8tXvD1mNfSyeVzu62Xy2LxCy2PxnpdMHptWdbJ5TFh0gNHj+/oO
        No+PT2+xePRtWcXo8XmTnEf7gW6mAJ4oLpuU1JzMstQifbsEroyXnU/ZCo6JVLx//IOlgfGv
        YBcjJ4eEgInErMczmboYuTiEBHYzSkxbMpMNIiEtcX3jBHYIW1hi5b/n7BBFzxklXvxayAiS
        YBPQldixuI0NJCEi0MwkMbPhDCOIwywwl1li5dz9UC3HGCUWb2xkBWnhFHCUuL9xD5gtLJAs
        8fjzAyYQm0VAVWLvrSXMIDavgKXE58bvrBC2oMTJmU9YQGxmAW2JpzefwtnLFr5mhrhPQeLn
        02Vg9SICThJr30D8wCwgLvHy6BH2CYzCs5CMmoVk1Cwko2YhaVnAyLKKUTK1oDg3PbfYsMAw
        L7Vcrzgxt7g0L10vOT93EyM4xrU0dzBuX/VB7xAjEwfjIUYJDmYlEd7PN7wShXhTEiurUovy
        44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamCazZfxaNtR41X/Zu5osvf+
        xGq3IPhdg0xh15nyrXfN/i9U35y0dLqEZiXT1lMXbixb95P3wrMrkyV43AJLbmqHVytpfn9U
        meYY86fopJB0697fmWcE2SMO16TuvcDOUrfI1Pf77tAdk9k/ba0w2uk5t2GKeIvJpQ+GW7Zx
        +zPEcL/X3vR03+nPbHyTJZ1zevfbvT10YsKemFNs884x+GdU8Ya/qXW9yn1gl+j2ewdEpxUV
        xLVz6qkL8O8yeO9coWfxukie98xJ49feJt0yQdpCN/u+Hmo4+aE/qf7V4io55772H171oeXG
        z/ecU59yIvVJaTffVYUkS3O9duPkBoFkbe/m3Zb9s+3LP3X/KFZiKc5INNRiLipOBADeB7IW
        YAMAAA==
X-CMS-MailID: 20210923043236epcas5p11be92802b457867d3f7ec462dfef0804
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p3b178e3d9d2d4db628f597732be9c6856
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p3b178e3d9d2d4db628f597732be9c6856@epcas2p3.samsung.com>
        <20210917065436.145629-12-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>-----Original Message-----
>From: Chanho Park =5Bmailto:chanho61.park=40samsung.com=5D
>Sent: Friday, September 17, 2021 12:25 PM
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
>Subject: =5BPATCH v3 11/17=5D scsi: ufs: ufs-exynos: add
>EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
>
>To skip exynos_ufs_config_phy_*_attr settings for exynos-ufs variant, this=
 patch
>provides EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR as an opts flag.
>
Please add a bit more information on why this has to be skipped for this HC=
I.

Thanks

>Cc: Alim Akhtar <alim.akhtar=40samsung.com>
>Cc: Kiwoong Kim <kwmad.kim=40samsung.com>
>Cc: Krzysztof Kozlowski <krzysztof.kozlowski=40canonical.com>
>Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
>---
> drivers/scsi/ufs/ufs-exynos.c =7C 6 ++++--  drivers/scsi/ufs/ufs-exynos.h=
 =7C 1 +
> 2 files changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c=
 index
>a3160d9bd234..73833c186ca9 100644
>--- a/drivers/scsi/ufs/ufs-exynos.c
>+++ b/drivers/scsi/ufs/ufs-exynos.c
>=40=40 -831,8 +831,10 =40=40 static int exynos_ufs_pre_link(struct ufs_hba=
 *hba)
>
> 	/* m-phy */
> 	exynos_ufs_phy_init(ufs);
>-	exynos_ufs_config_phy_time_attr(ufs);
>-	exynos_ufs_config_phy_cap_attr(ufs);
>+	if (=21(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR)) =7B
>+		exynos_ufs_config_phy_time_attr(ufs);
>+		exynos_ufs_config_phy_cap_attr(ufs);
>+	=7D
>
> 	exynos_ufs_setup_clocks(hba, true, POST_CHANGE);
>
>diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h=
 index
>bc4b8b0324bd..a0899aaa902e 100644
>--- a/drivers/scsi/ufs/ufs-exynos.h
>+++ b/drivers/scsi/ufs/ufs-exynos.h
>=40=40 -200,6 +200,7 =40=40 struct exynos_ufs =7B
> =23define EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL	BIT(2)
> =23define EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX	BIT(3)
> =23define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
>+=23define EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR	BIT(5)
> =7D;
>
> =23define for_each_ufs_rx_lane(ufs, i) =5C
>--
>2.33.0


