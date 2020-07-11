Return-Path: <SRS0=uOdR=AW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DEEAC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 05:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A58206E2
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 05:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="byumUWCt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgGKF6d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 01:58:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56338 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgGKF6d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 01:58:33 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200711055830epoutp0272e769a2adf854ff0c224be62db7118f~gnTLu9Ll_2108221082epoutp02b
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2020 05:58:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200711055830epoutp0272e769a2adf854ff0c224be62db7118f~gnTLu9Ll_2108221082epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594447110;
        bh=LWjtdIITBSJRLXlDVUl2GK08Df9CFvMg4eRAApAHD5M=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=byumUWCtecDXq/vxCN4nVC6tmijtLLOW5vzSMOeQ+t8x6y02dr3iRGeAeiwgzMZbn
         fvDvVwK4HBscdq6jpU6kdJj9tbmm7y177bm4gvTITbRaS/8bFaOZViMx5DL3D/Yfjc
         G3+HGUSbvacfzYLqGGvM5qVP0ADZ0QnmPH5qJKnQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200711055829epcas2p216c64b54818e0f0c0fa4c1110fa8c0a3~gnTKtWmVU0924709247epcas2p2O;
        Sat, 11 Jul 2020 05:58:29 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B3fNM0xprzMqYkV; Sat, 11 Jul
        2020 05:58:27 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.15.18874.205590F5; Sat, 11 Jul 2020 14:58:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200711055826epcas2p4e2fbaf8f07ed3d5e87b4acdff838d549~gnTIdwHVg0840308403epcas2p4_;
        Sat, 11 Jul 2020 05:58:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200711055826epsmtrp2cd9e04c537dd5b380636fe2b89984506~gnTIaPBMh1335313353epsmtrp2G;
        Sat, 11 Jul 2020 05:58:26 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-63-5f09550231fc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.58.08382.205590F5; Sat, 11 Jul 2020 14:58:26 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200711055826epsmtip2206e03df8024badc583250e4be363209~gnTIKVw6E2582725827epsmtip2O;
        Sat, 11 Jul 2020 05:58:26 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB46401E72E1C0C4B8FEBF6156FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RESEND RFC PATCH v4 2/3] ufs: exynos: introduce command
 history
Date:   Sat, 11 Jul 2020 14:58:26 +0900
Message-ID: <000b01d65748$4b25d240$e17176c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJ3IuC2j48zjcAhrcL1upjrEzI4TgHBLgI6Ae9pZ38AwrMW2Kecr73Q
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIJsWRmVeSWpSXmKPExsWy7bCmuS5zKGe8QftVJosH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBbd13ewWSw//o/JouvuDUaL
        pf/esjjwely+4u1xua+XyWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwVwROXYZKQm
        pqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCdrKRQlphTChQK
        SCwuVtK3synKLy1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMn4POMz
        S0EnZ8XRm6UNjDvYuxg5OCQETCT+3U7sYuTiEBLYwSix8O50ti5GTiDnE6PE7hl6EIlvjBKr
        X+xmB0mANPzfNIkRIrGXUeLX5zZ2COcFo0TX+RYWkCo2AW2JaQ93s4IkRATuM0kc2fmABWQf
        p0CsxN0/wSA1wgL+EjtnvAKrZxFQlTj78gkTiM0rYClx5eIfFghbUOLkzCdgNjPQzGULXzND
        XKEg8fPpMlYQW0TATaJp8XlmiBoRidmdbVA1Jzgkfj1ThrBdJM6uvssKYQtLvDq+BeobKYnP
        7/ayQdj1EvumNoDdLCHQwyjxdN8/RoiEscSsZ+2MIPczC2hKrN+lDwk6ZYkjt6BO45PoOPwX
        GqK8Eh1tQhCNyhK/Jk2GGiIpMfPmHaitHhKnJm1lm8CoOAvJk7OQPDkLyTOzEPYuYGRZxSiW
        WlCcm55abFRghBzTmxjBaVnLbQfjlLcf9A4xMnEwHmKU4GBWEuGNFuWMF+JNSaysSi3Kjy8q
        zUktPsRoCgz2icxSosn5wMyQVxJvaGpkZmZgaWphamZkoSTOW694IU5IID2xJDU7NbUgtQim
        j4mDU6qByfLzg3svTl819LCXUH5n9HuN6anbP+LdvSJdl/y0OnHvh6Tp+c0XQ5uWmj/0DtV+
        b/a1ZvmueXYdMl/utv/p+sixMmOToG3H/jzfQx9akqb4vpDQ2W62kF9+5uQX53dw6XD+ktbh
        2il/wdNl316tmZ/4/4d8iOx4K1Ozw+aoia1IXcT5yS+6eM5d+cuWvP8SR4rf3c+WU2+63Nt3
        cWL1Ue2VSuY3pmQblthHlXjPtls2JfrHyZxDqR5enZHrzRq9Tv3KTZzj/Ow896PPpQetKqo0
        EqZEnmBqCdY/3FiWlCGydLO61u079mv2TxV9/3Q50+y0+Iy7s8542Bw37q//YvuRmbvP7Nzb
        9oPP2u6nZSmxFGckGmoxFxUnAgC0vHTIVAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSvC5TKGe8wb11MhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKOLNuLVvBb46KFY+/szUwLmPvYuTkkBAwkfi/aRJjFyMXh5DAbkaJ29P/MUEk
        JCVO7HzOCGELS9xvOcIKUfSMUWL77GusIAk2AW2JaQ93gyVEBN4ySdy5fZkJomo1k8SPuf1A
        7RwcnAKxEnf/BIM0CAv4Slz/cgdsA4uAqsTZl0/AbF4BS4krF/+wQNiCEidnPgGzmYEW9D5s
        ZYSxly18zQxxkYLEz6fLwI4QEXCTaFp8nhmiRkRidmcb8wRGoVlIRs1CMmoWklGzkLQsYGRZ
        xSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHJFamjsYt6/6oHeIkYmD8RCjBAezkghv
        tChnvBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeG4UL44QE0hNLUrNTUwtSi2CyTBycUg1MO36q
        zl5nPzduQh/zr5CEI88ddGo54zUKfrhMLLho+s4+NVXJdZdA5c7f63pXbuVs25DP9sNCzyDy
        wo4b9W57bWWZYwX//5I2PlGu9iu7cfmp1HpxBZ21PXM+vJs2ObxXVsty88XoWttv4q12jPcf
        h/tZfbM5+k9SXMkrJ3JGjKD/8p2qKqt2/dMt1Hvn1vZp/eR+SeXtReeEasImqYTvcj10Werr
        txmnwy88+i53xSrdxb+eqyojU/UcS+H50jWCmjmCf4rYlbQPV8l8vFtZ/eqP0YvT/+7N/R6f
        t61y2/37P+pPfuop4D57KSs68YlF/s+PVudNe0xCFz63uF7Dc15esDdvwvddWfduF+YrsRRn
        JBpqMRcVJwIAFEBZxzcDAAA=
X-CMS-MailID: 20200711055826epcas2p4e2fbaf8f07ed3d5e87b4acdff838d549
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708023156epcas2p416ac7979ed0a0a7a71de1636defb0ec7
References: <cover.1594174981.git.kwmad.kim@samsung.com>
        <CGME20200708023156epcas2p416ac7979ed0a0a7a71de1636defb0ec7@epcas2p4.samsung.com>
        <da700e31d9a8598c247269746aef3c09a92e71e8.1594174981.git.kwmad.kim@samsung.com>
        <SN6PR04MB46401E72E1C0C4B8FEBF6156FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +         EXYNOS specific, such as vendor specific hardware contexts.
> > +
> > +         Select this if you want to get and print the information.
> > +         If unsure, say N.
> > diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> > index f0c5b95..d9e4da7 100644
> > --- a/drivers/scsi/ufs/Makefile
> > +++ b/drivers/scsi/ufs/Makefile
> > =40=40 -4,7 +4,7 =40=40 obj-=24(CONFIG_SCSI_UFS_DWC_TC_PCI) +=3D tc-dwc=
-g210-pci.o
> > ufshcd-dwc.o tc-dwc-g210.
> >  obj-=24(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-pltfrm.o
> > ufshcd-dwc.o tc-dwc-g210.o
> >  obj-=24(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D cdns-pltfrm.o
> >  obj-=24(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
> > -obj-=24(CONFIG_SCSI_UFS_EXYNOS) +=3D ufs-exynos.o
> > +obj-=24(CONFIG_SCSI_UFS_EXYNOS) +=3D ufs-exynos.o ufs-exynos-dbg.o
> If the key functionality depends on SCSI_UFS_EXYNOS_CMD_LOG, Why not use
> it for make as well, and in your header as well?=20
I assume somebody including me will add dumping vendor register or another =
item=20
in the file. That's why I did.
But currently, you're right and I will do.

Thanks.
Kiwoong Kim

