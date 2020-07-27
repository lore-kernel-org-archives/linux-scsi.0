Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB933C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 11:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9399E20663
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 11:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="e7UfsjSn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgG0Ldk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:33:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10420 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgG0Ldj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 07:33:39 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200727113334epoutp02ebb495db1e94f01ead839c5fb5c7905f~lmMTdYKST1713517135epoutp02d
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 11:33:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200727113334epoutp02ebb495db1e94f01ead839c5fb5c7905f~lmMTdYKST1713517135epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595849614;
        bh=iS3FqrpMNSegLSoZHgNMBryvguF/bcnZ05FntCgwulI=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=e7UfsjSnFans0xQBuPyxBTjTd/i4duntte188eFcpOAFsRg0PlzlPQuecthDwABgw
         gcnRbyVH1cWNf7sWNhzztgYw4+MNMDMD8+PgrllyG9FUfUM5q+cCUbzEM2kM6Thjqz
         b1Ak3ygo2H90/iGOYsrDNZIMs9cHnSn57HCpuYLs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200727113332epcas2p3025f7f7cecdc9fcf9a55e30a143271aa~lmMSQZRay1409514095epcas2p3W;
        Mon, 27 Jul 2020 11:33:32 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4BFd3Z1Z50zMqYkW; Mon, 27 Jul
        2020 11:33:30 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.FD.27441.A8BBE1F5; Mon, 27 Jul 2020 20:33:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200727113329epcas2p48d282df016500ce4743a842bac5f247e~lmMPIHf9j0842608426epcas2p4e;
        Mon, 27 Jul 2020 11:33:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200727113329epsmtrp2eecf900a9474b071a93507334d7f1e18~lmMPHVine2344723447epsmtrp27;
        Mon, 27 Jul 2020 11:33:29 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-ab-5f1ebb8a2988
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.F8.08382.98BBE1F5; Mon, 27 Jul 2020 20:33:29 +0900 (KST)
Received: from KORDO040863 (unknown [12.36.185.126]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200727113329epsmtip2900edd529f14df45b9f76b5ec1f6d483~lmMO3LQ1u2951729517epsmtip27;
        Mon, 27 Jul 2020 11:33:29 +0000 (GMT)
From:   =?UTF-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>
In-Reply-To: <SN6PR04MB464021D20A5AE11F60F48718FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 2/3] scsi: ufs: modify function call name When
 ufs reset and restore, need to disable write booster
Date:   Mon, 27 Jul 2020 20:33:29 +0900
Message-ID: <074201d66409$c013ba90$403b2fb0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHLP/cB05Q6MF8BaP7+redz0q/FGgLfFFEPASU1gksBdMSJPAFM0QFRAfHkSm8BuzrKMwH5uWVkqM4tMEA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmmW7Xbrl4gz+ruSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARlWOTkZqYklqkkJqXnJ+SmZduq+Qd
        HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SjkkJZYk4pUCggsbhYSd/Opii/tCRVISO/
        uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ+PI3wVMBTPYKo6tecbWwHiXpYuR
        k0NCwERi2se57F2MXBxCAjsYJe69fsUC4XxilPh28xMrhPONUWLVkQ3MMC2NO+awgdhCAnuB
        qv4JQtgvGSX2rpMGsdkETCX6tq0AaxYRmMYksfvXIqYuRg4OToFYidaNiiA1wgINjBKnn9uA
        2CwCqhI9W46AzecVsJS4cvEJE4QtKHFy5hOwU5kF5CW2v50DdYOCxI6zrxlBbBGBJIlP/WfY
        IWpEJGZ3tjGD7JUQ2MIhsaF3IdSfLhJXD++DsoUlXh3fwg5hS0l8freXDcKul5hybxULRHMP
        o8SeFSeYIBLGErOetTOCPMAsoCmxfpc+iCkhoCxx5BbUbXwSHYf/skOEeSU62oQgGpUkzsy9
        DRWWkDg4Owci7CHxf9lrlgmMirOQPDkLyZOzkDwzC2HtAkaWVYxiqQXFuempxUYFxshRvYkR
        nHq13Hcwznj7Qe8QIxMH4yFGCQ5mJRFeblGZeCHelMTKqtSi/Pii0pzU4kOMpsBgn8gsJZqc
        D0z+eSXxhqZGZmYGlqYWpmZGFkrivMVWF+KEBNITS1KzU1MLUotg+pg4OKUamFiOHQh9v6L2
        UvJiga9P1v45ddouuCCd8baM6bGL/97N/lGx6Kb2m5TNE/RWPpy6c+M6EZnLH3vX/PzOmd7S
        euyHXMjyj2etMj2Wr9/Q1/XZZ7bcxuVeGsYG3pOecnzidWz79nI31+q567NSK9rXPbj69teB
        4tNThPUMGFbvnfb6VP+eVdEN3tInnyaHbyn+vs3K6FnXuzc5d7qF7S44C1ifO7B65nHdBx3z
        H///d3nyMWO57uO7Wfb/flVU8nh+YZWsYmx2FpNh6T3FjL2/57EbLpwjk2Rn33TXZl/n5Uz9
        h138pTdVOGwtV8gpRVv4TrQNaD10ZGakzL3ajaui7lboPNZ8/d3BUD+n7cq/J9+ElViKMxIN
        tZiLihMBJtiAXUYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvG7nbrl4g+cPpS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJVx5O8CpoIZ
        bBXH1jxja2C8y9LFyMkhIWAi0bhjDlsXIxeHkMBuRolnpz+zQyQkJP4vbmKCsIUl7rccYYUo
        es4o0fRpK1gRm4CpRN+2FWAJEYEFTBKPVu9ngqhaziIx618TUIaDg1MgVqJ1oyJIg7BAnUTX
        r2aw1SwCqhI9W44wg9i8ApYSVy4+YYKwBSVOznwCVsMsoC3R+7CVEcKWl9j+dg4zxEUKEjvO
        vgaLiwgkSXzqP8MOUSMiMbuzjXkCo9AsJKNmIRk1C8moWUhaFjCyrGKUTC0ozk3PLTYsMMxL
        LdcrTswtLs1L10vOz93ECI45Lc0djNtXfdA7xMjEwXiIUYKDWUmEl1tUJl6INyWxsiq1KD++
        qDQntfgQozQHi5I4743ChXFCAumJJanZqakFqUUwWSYOTqkGpijGp855PdlF72w1PbvPCeyV
        el/H4GlQI1xVysgx6bDvZQ/D6i1zjuyrUrv0yMPd1W9nyv0NL9ufyC2qMJb+l7/Fz++P6pSb
        yw+EBXw9vm+nkpLzp3MzUv0k8o272DgrUplFF9Z0JVf2ZYq0ft0VdyBY9NR+R9Elhg4fYt83
        XtnEUvN9htJDznN+3bqHZ5wstg4M5i7hWrqF5bn51KKNRYVF176x//+3dTvzqvRz59x/aTnP
        6738/Ud7qmjTTgu+DUZ7nvMdW1LvOaNLdfLDfGUejWDxre/nR+QvyeHg/bgo3yBwqkw2m/Gc
        dUHHli42nPvywqLL+6zarjzkDMi56R3D9dxr7Z7tv2UEj6uLKLEUZyQaajEXFScCABtNKnso
        AwAA
X-CMS-MailID: 20200727113329epcas2p48d282df016500ce4743a842bac5f247e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200721095653epcas2p4575db5cbcd8897662ad19465339128b2
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095653epcas2p4575db5cbcd8897662ad19465339128b2@epcas2p4.samsung.com>
        <52e4453499a65ad276df5af9a0f057e960704f93.1595325064.git.hy50.seo@samsung.com>
        <SN6PR04MB4640E7CB5A7F2E406323CFBAFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
        <071e01d663fc$f6bce010$e436a030$@samsung.com>
        <SN6PR04MB4640B30915D3D402B3B47F79FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
        <074001d66408$efdc5a80$cf950f80$@samsung.com>
        <SN6PR04MB464021D20A5AE11F60F48718FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > > > This patch is not really needed - just squash it to the previous
> one.
> > > > Why you said this patch is not really needed?
> > > > I don't understand
> > > > Our WB device need to disable WB when called
> > > > ufshcd_reset_and_restore() func.
> > > > Please explain reason.
> > > This patch only change the names of some functions defined in the
> > > first patch.
> > > Squash it to the first one.
> >
> > "Asutosh Das (asd) <asutoshd@codeaurora.org>" said this function not
> > clearly.
> > So I modify this function name.
> > I think this name is clear than the previous name.
> I am not arguing about that.
> Are you familiar with the concept of squash?
Sorry, I misunderstand.
I do not know very well. Please can you explain concept of squash to me?


