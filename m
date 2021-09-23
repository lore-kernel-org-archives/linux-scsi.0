Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F79C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 03:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6C946103C
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 03:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhIWDuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 23:50:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39100 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239518AbhIWDuR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 23:50:17 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210923034845epoutp03450675bedbad490230b2e2790d6c5cbe~nVuOPrjrF1535915359epoutp03n
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 03:48:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210923034845epoutp03450675bedbad490230b2e2790d6c5cbe~nVuOPrjrF1535915359epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632368925;
        bh=pnRA8yd3s5z8IaEgSKtRsaMRao7uSd+SxzsoLcc7U/I=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=j9r5yoL8PmIghU0Kxg9ddl12502RRhPyynLfGznAL9ytiwb++YDBJQF6lc0tIuj1r
         it1d3De6sZ030vDk/OyNeM+3kiF/tiT0TW6x2xU/hhC1o0cFbapWvQXWyqbSYibCMf
         JupRzcRH87+xDdGb6oWvGYcJk8Fw7nUONo4FA9rs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210923034844epcas5p1eaae2bbca3d086d2574043b496e8c402~nVuN1PwcE2043620436epcas5p15;
        Thu, 23 Sep 2021 03:48:44 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HFLjw0kjLz4x9Pw; Thu, 23 Sep
        2021 03:48:36 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.C0.10367.219FB416; Thu, 23 Sep 2021 12:48:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210923034446epcas5p43166337f89f0adc69299f5de060a9afb~nVqwEdOA00735407354epcas5p4x;
        Thu, 23 Sep 2021 03:44:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210923034446epsmtrp16d2fd230b9f9b7b675c84d7abe66ae04~nVqwFlyIH2196821968epsmtrp1d;
        Thu, 23 Sep 2021 03:44:46 +0000 (GMT)
X-AuditID: b6c32a4a-b17ff7000000287f-fa-614bf91249b6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D2.4F.08750.E28FB416; Thu, 23 Sep 2021 12:44:46 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210923034444epsmtip14b4f125e5668102758d6acb8aa45e342~nVqt5-LaZ1031610316epsmtip1y;
        Thu, 23 Sep 2021 03:44:44 +0000 (GMT)
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
        "'jongmin jeong'" <jjmin.jeong@samsung.com>
In-Reply-To: <20210917065436.145629-2-chanho61.park@samsung.com>
Subject: RE: [PATCH v3 01/17] scsi: ufs: add quirk to handle broken UIC
 command
Date:   Thu, 23 Sep 2021 09:14:42 +0530
Message-ID: <000601d7b02d$5a2e2730$0e8a7590$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQCrfpxgAVmb4T6p+Iw8IA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsWy7bCmuq7QT+9Eg+9/1CxOPlnDZvHy51U2
        i4MPO1kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3CYuPbH0wWM87v
        Y7Lovr6DzWL58X9MDvwel694e8xq6GXzuNzXy+SxeYWWx+I9L5k8Nq3qZPOYsOgAo8f39R1s
        Hh+f3mLx6NuyitHj8yY5j/YD3UwBPFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
        FuZKCnmJuam2Si4+AbpumTlAzygplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCkwK
        9IoTc4tL89L18lJLrAwNDIxMgQoTsjOudTexF5wSr7ixdz9rA2OvSBcjJ4eEgIlE66sLTF2M
        XBxCArsZJc5cuMkG4XxilDg/4zqU85lR4tWch8wwLZvWXGSBSOxilLi2qBHKeckocWHDb1aQ
        KjYBXYkdi9vA2kUEGpkkTj/eDNbOLDCTWWL1K0MQm1PAQeL67OtMILawQKDE/J23wWwWAVWJ
        l70r2UBsXgFLiY0XDrNC2IISJ2c+YYGYoy2xbOFrqJMUJH4+XQZWIyLgJLHm0ieoXeISL48e
        YQc5QkLgP4fE0sWtLBANLhI/Hp2AahaWeHV8CzuELSXxsr8NyOYAsrMlenYZQ4RrJJbOOwbV
        ai9x4MocFpASZgFNifW79CHCshJTT61jgljLJ9H7+wkTRJxXYsc8GFtVovndVagx0hITu7tZ
        JzAqzULy2Swkn81C8sEshG0LGFlWMUqmFhTnpqcWmxYY5aWWw2M8OT93EyM4sWt57WB8+OCD
        3iFGJg7GQ4wSHMxKIryfb3glCvGmJFZWpRblxxeV5qQWH2I0BQb3RGYp0eR8YG7JK4k3NLE0
        MDEzMzOxNDYzVBLn/fjaMlFIID2xJDU7NbUgtQimj4mDU6qBKfz8yemZ6ySSVO4/UGpWin9X
        7/ZGaI1uZrZZQO28vxfzf4q++1CdsEA/6IeT6D/GJw8jjnwQ+9DR+WtvB3Nn/dwtWyLaFaRn
        tb1h/sjypveF66neyo/f/DqXcHpenLxvblZDW1GITYTcco/zx423Lf/8saaeWdxZUkEv4JrJ
        orlJb6uWLLNvsNRaldOrzv7xhePTxCd1msVaS32/H45xf7Ivq/zq7ZgdO5b+/nJyStDdJfzi
        wpWTsp3bnwt7FPML2MSf2nZZIjuSY0H98vf3JJYZixbO6fyn2qz34diSZwdnfcuT7e6S0zX9
        9eTLozs33tsUdU1ftWHzrNu2f/KVpXRei5547c3W+PLC7s9njyuxFGckGmoxFxUnAgAH3hcn
        dQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHe885nh1N6egk3yxM1pWJ64If3mpEdw5ZFuUHM9OWHqa0mW4t
        TYKmYpeZa1CazcicqblGyyW2mpiZJqutzFVmRGDT2byQZdEsGTFX4bffw//yPPBQeJiNiKSy
        so+zsmyRhEcGES1PeFGxAk+8aHWDLgpZBw0kck+9IdHjgfMEqpiYwtE3Y30AcjyKQRcebEXP
        NToMDRq1ONK9a8FQ41uEmsY9GKp82Yah0j4ziRq6vdimeYzjdTyjVZaRjENdhjH3bvGZ2lY3
        xpj050lGo2sHzE/jOZL5OvSeYNTNesBMmqKYs+2l2N7g5CBhBivJOsHKVm08HJR5Z3KAzJme
        n2+rdAMlsHBVIJCCdBw0GV4RKhBEhdFmAHu830m/sBD2NWk4fubCRu8wx28aBtCltuM+gaRj
        obn2DOkTwuliDF5V2oBvwOkaHH7yXvzb2wXg04fPA3yRQHoT7Kvqw3zMpfdA02/rDBP0Mugu
        a5zZHUKvg009TwL8HAqtVwcJH+N0DBzqH/rP9TWjuP++aDg1VD/jD6e3QEPvN9zviYDurk6O
        BnC1s6q0s6q0s6q0syI3AKEHC9gcuVQsla/JWZvN5gnkIqlckS0WpB+TmsDMw/l8M2jVTwg6
        AEaBDgApnBceMvlupygsJEN0soCVHUuTKSSsvAMspAheREiPypoWRotFx9mjLJvDyv6pGBUY
        qcTyUPOVpSBp3q+U3k5OcQql/lJIx51aQdbFuh2lruHq6Pzv1mLbAnBasZw33Drm+YHxe5Je
        Kdpyg130zkI8L3Q6/nOAJUFq7BwtkUiFJqFNWLD45rVDc8Qwr6j/df9BYmLbmHjEZeFWEUsS
        d00D84vMuaYjznXrYxaV3I5N3B6d2BUxRzy9st9p/11grBhRvS2R1UfP3a8+oLtS88N1qVv1
        lV9RHmc3ZFUZdhdyrwefEjrsRKinsfSX016eO44pMrrUIFVSnVpMVwqc1P3uXvZZd5HeYoEb
        NsecUGKXS3ZU3l2bPvihzoPqOOW9u/Yl7P6occ7nr06+5C3iEfJM0Ro+LpOL/gDzsvjuXwMA
        AA==
X-CMS-MailID: 20210923034446epcas5p43166337f89f0adc69299f5de060a9afb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065522epcas2p49ce06e9686c9b6f5cb1dd16ca9d82052
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065522epcas2p49ce06e9686c9b6f5cb1dd16ca9d82052@epcas2p4.samsung.com>
        <20210917065436.145629-2-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Chanho=20

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
>linux-samsung-soc=40vger.kernel.org; linux-scsi=40vger.kernel.org; jongmin=
 jeong
><jjmin.jeong=40samsung.com>; Chanho Park <chanho61.park=40samsung.com>
>Subject: =5BPATCH v3 01/17=5D scsi: ufs: add quirk to handle broken UIC co=
mmand
>
>From: jongmin jeong <jjmin.jeong=40samsung.com>
>
>samsung ExynosAuto9 SoC has two types of host controller interface to supp=
ort
>the virtualization of UFS Device.
>One is the physical host(PH) that the same as conventaional UFSHCI, and th=
e
>other is the virtual host(VH) that support data transfer function only.
>
>In this structure, the virtual host does not support UIC command.
>To support this, we add the quirk and return 0 when the UIC command send
>function is called.
>
>Cc: Alim Akhtar <alim.akhtar=40samsung.com>
>Cc: James E.J. Bottomley <jejb=40linux.ibm.com>
>Cc: Martin K. Petersen <martin.petersen=40oracle.com>
>Cc: Bart Van Assche <bvanassche=40acm.org>
>Signed-off-by: jongmin jeong <jjmin.jeong=40samsung.com>
>Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
>---
Reviewed-by: Alim Akhtar <alim.akhtar=40samsung.com>

> drivers/scsi/ufs/ufshcd.c =7C 3 +++
> drivers/scsi/ufs/ufshcd.h =7C 6 ++++++
> 2 files changed, 9 insertions(+)
>
>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
>3841ab49f556..8a45e8c05965 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>=40=40 -2324,6 +2324,9 =40=40 int ufshcd_send_uic_cmd(struct ufs_hba *hba,=
 struct
>uic_command *uic_cmd)
> 	int ret;
> 	unsigned long flags;
>
>+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
>+		return 0;
>+
> 	ufshcd_hold(hba, false);
> 	mutex_lock(&hba->uic_cmd_mutex);
> 	ufshcd_add_delay_before_dme_cmd(hba);
>diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
>52ea6f350b18..e1d8fd432614 100644
>--- a/drivers/scsi/ufs/ufshcd.h
>+++ b/drivers/scsi/ufs/ufshcd.h
>=40=40 -588,6 +588,12 =40=40 enum ufshcd_quirks =7B
> 	 * This quirk allows only sg entries aligned with page size.
> 	 */
> 	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		=3D 1 << 14,
>+
>+	/*
>+	 * This quirk needs to be enabled if the host controller does not
>+	 * support UIC command
>+	 */
>+	UFSHCD_QUIRK_BROKEN_UIC_CMD			=3D 1 << 15,
> =7D;
>
> enum ufshcd_caps =7B
>--
>2.33.0


