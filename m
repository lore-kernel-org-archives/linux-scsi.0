Return-Path: <SRS0=uOdR=AW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC620C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 05:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D95620725
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 05:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AYg1cCwc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgGKFnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 01:43:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64447 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgGKFnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 01:43:16 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200711054314epoutp01d3ce3855213a2495a809a2fb188ab51f~gnF25JpjH0343603436epoutp01S
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2020 05:43:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200711054314epoutp01d3ce3855213a2495a809a2fb188ab51f~gnF25JpjH0343603436epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594446194;
        bh=Fc+G9cEgRDAwtZnC6nL4FEzG8Xh1h8wSRMJLnh4bITg=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=AYg1cCwcPNZMO+DDixJSGdS3ALl1AMJwLC+WD4hN26Fr/i/ihIdYNsWIJdIs/m4qP
         gvr/9V0xyBhB3LbgLltzhh8qAfySDWivLY4qdKu9+5Klv4lUrMDDjXulVEjbKrz2Sf
         cegAfNGBWc4pBYn2fUnrzdSCKKQ/jypJCbuFE8ww=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200711054313epcas2p3fb9cdb0cc07294499b347f1752cd7bff~gnF2DuMe11901419014epcas2p3U;
        Sat, 11 Jul 2020 05:43:13 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4B3f2k1blXzMqYm0; Sat, 11 Jul
        2020 05:43:10 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.23.18874.C61590F5; Sat, 11 Jul 2020 14:43:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200711054307epcas2p38f68f112590c51489b67bd98a67c4a65~gnFwn6U0R1649216492epcas2p3P;
        Sat, 11 Jul 2020 05:43:07 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200711054307epsmtrp18c25909e7bd8138a76689398bee27e75~gnFwnDpbJ2970129701epsmtrp1c;
        Sat, 11 Jul 2020 05:43:07 +0000 (GMT)
X-AuditID: b6c32a46-503ff700000049ba-8a-5f09516c1a31
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        02.5D.08303.B61590F5; Sat, 11 Jul 2020 14:43:07 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200711054307epsmtip2334d8cfdeba503b1e6e12fd2e6a4e25d~gnFwVL-Ri2005520055epsmtip2I;
        Sat, 11 Jul 2020 05:43:07 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <BYAPR04MB4629BA9BFCD4C40BCB9EB920FC640@BYAPR04MB4629.namprd04.prod.outlook.com>
Subject: RE: [RESEND RFC PATCH v4 1/3] ufs: introduce a callback to get info
 of command completion
Date:   Sat, 11 Jul 2020 14:43:07 +0900
Message-ID: <000801d65746$276bed00$7643c700$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJ3IuC2j48zjcAhrcL1upjrEzI4TgJByUvjAi5JfYQBvtHU0qeOzvAw
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJsWRmVeSWpSXmKPExsWy7bCmmW5OIGe8wfQmUYsH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBbd13ewWSw//o/JouvuDUaL
        pf/esjjwely+4u1xua+XyWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwVwROXYZKQm
        pqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCdrKRQlphTChQK
        SCwuVtK3synKLy1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMk4dXo5
        a8F+toqVZw+yNjBOZe1i5OSQEDCRuL73KVsXIxeHkMAORokdl+8xQzifGCWWPvgO5XxmlFjY
        tx+u5duxiSwQiV2MEhNP/YZyXjBKPJg6mwmkik1AW2Law92sIAkRgftMEkd2PmABSXAKxEp8
        2vcIbJSwQIrEzDcv2EFsFgFViY/3foA18wpYSmw50wRlC0qcnPkErJdZQF5i+9s5zBBnKEj8
        fLoMbI6IgJvE6UcHmCFqRCRmd7aB3S0hcIZDouHIISaIBheJXY/fQDULS7w6voUdwpaSeNnf
        BmXXS+yb2sAK0dzDKPF03z9GiISxxKxn7UA2B9AGTYn1u/RBTAkBZYkjt6Bu45PoOPyXHSLM
        K9HRJgTRqCzxa9JkqCGSEjNv3oEq8ZC4v1FxAqPiLCRPzkLy5Cwkz8xCWLuAkWUVo1hqQXFu
        emqxUYERcmxvYgSnZy23HYxT3n7QO8TIxMF4iFGCg1lJhDdalDNeiDclsbIqtSg/vqg0J7X4
        EKMpMNgnMkuJJucDM0ReSbyhqZGZmYGlqYWpmZGFkjhvveKFOCGB9MSS1OzU1ILUIpg+Jg5O
        qQam/o+B63debLnx1cq5ofbnoxlbZvvuWslZ4j6BR9X59RyRrGWTowKtLnt099dF/P019f6q
        oDZLs+Jfu/9f8xYXXcnIphI3w+n6UdY72s9Xbq7R59s84ZVfiuE5y+CFdZtvLVbf7hsn/XTX
        +pBPjxMXXGl9p745+6WFSOuWW88t4m6uW7HE/OLy2cqvRBqvZrJyysxPSzhu/EBWonOn9cvP
        rSKcBWu45HqF54W8ufdi59+gDQlrUybMu/731JLS7n8dMtc4rwUmr7SI4PEOUp5mdeOe90/N
        4/v6/7dwXNT/f2jtq0lmCU/Y686W3w5Y/v/7m6fLa4uOLD33Nm/LqvScM4yeR6Q2C6qLdgRr
        TjnX8lKJpTgj0VCLuag4EQCtr/6mWAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSvG52IGe8wb1jihYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKOHV6OWvBfraKlWcPsjYwTmXtYuTkkBAwkfh2bCJLFyMXh5DADkaJhUufs0Ek
        JCVO7HzOCGELS9xvOcIKUfSMUWLSwY/sIAk2AW2JaQ93gyVEBN4ySdy5fZkJomo1k8TnLRNY
        QKo4BWIlPu17BLZPWCBJYsWldWDdLAKqEh/v/WACsXkFLCW2nGmCsgUlTs58AtbLDLSh92Er
        I4QtL7H97RxmiJMUJH4+XQY2U0TATeL0owPMEDUiErM725gnMArNQjJqFpJRs5CMmoWkZQEj
        yypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOCY1NLawbhn1Qe9Q4xMHIyHGCU4mJVE
        eKNFOeOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ836dtTBOSCA9sSQ1OzW1ILUIJsvEwSnVwDTz
        yD7taEm7qesTzUryGr4VWPyP03i1qXJO9b7ZArKlmZf9jXj2Zrq9uXNLqv9P3PzY7mNWM5fr
        vfujzXIkaKF08vSn23z/ajseZo7q/djCyNFpnN7b0bBq2qtXXIutSltVL65caqzMumvn+nf7
        LjT1vDozYVL8goOGBQ3/dBqDd7ZH79kTxeS8y/2x1rKAr8/fzq47+vjU7JerLy3+Wfz04/XA
        tOPmx387Tn4o0cSov4D9UpyB8REJ2xVvVStuSWrwqc/9wvPMN3RehussTUnRB7HztzBNsPZ0
        i/2ydPKl5lX9nUYzyufwzsvxbZl4oT3zfEbRYe0beklh1a05+5SOfpk695Dvshlpdc4p6g5K
        LMUZiYZazEXFiQCN8YQLOAMAAA==
X-CMS-MailID: 20200711054307epcas2p38f68f112590c51489b67bd98a67c4a65
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708023155epcas2p3ac30e4b0c24855e0a3466126bba9c612
References: <cover.1594174981.git.kwmad.kim@samsung.com>
        <CGME20200708023155epcas2p3ac30e4b0c24855e0a3466126bba9c612@epcas2p3.samsung.com>
        <89b90646c310fb0048701f219eb23c4b35ef7dcf.1594174981.git.kwmad.kim@samsung.com>
        <BYAPR04MB4629BA9BFCD4C40BCB9EB920FC640@BYAPR04MB4629.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Some SoC specific might need command history for various reasons, such
> > as stacking command contexts in system memory to check for debugging
> > in the future or scaling some DVFS knobs to boost IO throughput.
> >
> > What you would do with the information could be variant per SoC
> > vendor.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > Acked-By: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> 
> It will require another spin however, because you'll need to rebase it
> After Stanley's (scsi: ufs: Fix and simplify setup_xfer_req vop and
> request's completion timestamp) Is accepted.
> 
> Thanks,
> Avri

Got it.
And is there any way that you can recommend to rebase, not by hand?
I tried to find how but failed.

Thanks.
Kiwoong Kim

