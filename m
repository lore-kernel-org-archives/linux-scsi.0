Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF24CC433E4
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 07:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B8BC207BC
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 07:22:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WDRQEVmn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgGLHWg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 03:22:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36330 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgGLHWf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jul 2020 03:22:35 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200712072234epoutp024ac982db2fbc2936ddec008730704e62~g8F3ko7-51557415574epoutp022
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2020 07:22:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200712072234epoutp024ac982db2fbc2936ddec008730704e62~g8F3ko7-51557415574epoutp022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594538554;
        bh=nROLA0EIa0nWkRPk+LNVk3aELwURil72NU6GrBUWDlA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=WDRQEVmnHHql3VbJRSg7t/W/t3cUwOAEd1GndCtUB+bYjn2qhGyue6IN0x6Nji28l
         uFnzaZtYGFJ3JtPOqr7o/e9F3A10gKK0T/iPr9ySPAmK2Zj0DOwnisOHGw6pnC9EPT
         C292fQRH/BJ28MZggET3NvYyL1tMIhfkdg1HMRzg=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200712072232epcas5p40e7fd319bd1f10166afd7d08cbbd0b3a~g8F2fB1E32144521445epcas5p4u;
        Sun, 12 Jul 2020 07:22:32 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.E9.09475.83ABA0F5; Sun, 12 Jul 2020 16:22:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200712015832epcas5p3506ba61f6435ed3e51339527e295a8a3~g3q9ZLHv32943129431epcas5p3k;
        Sun, 12 Jul 2020 01:58:32 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200712015832epsmtrp21d709626bb95778689454fc33a1174ec~g3q9VmN0c0750307503epsmtrp2p;
        Sun, 12 Jul 2020 01:58:32 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-7f-5f0aba387d4d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B7.D8.08303.84E6A0F5; Sun, 12 Jul 2020 10:58:32 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200712015829epsmtip1a53b8fc12f08026707fe1abbf76406f6~g3q6LQTnX2577325773epsmtip1N;
        Sun, 12 Jul 2020 01:58:29 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        <linux-scsi@vger.kernel.org>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>
In-Reply-To: <cover.1594450408.git.kwmad.kim@samsung.com>
Subject: RE: [RFC PATCH v5 0/3] ufs: exynos: introduce the way to get cmd
 info
Date:   Sun, 12 Jul 2020 07:28:27 +0530
Message-ID: <000101d657ef$f1fbf570$d5f3e050$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGxDc+xvp0qxsGCpMetX3YDvIMySgIueMtDqTxP1UA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7bCmpq7FLq54g7+PTSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MG2t2Mha8Yqto+fSHtYHxAWsXIyeHhICJxPU9z9m6GLk4hAR2M0r0
        PJ7MBOF8YpTYtuMII0iVkMBnRonjc4xgOiatussOUbSLUWLljW8sEM4bRom7026BdbAJ6Ers
        WNwGNldE4DaTxNqjnewgCWagxMknS5lAbE4BS4mzTy+wgNjCAgESb/q2gdWwCKhKrJ+5GWwQ
        L1BN49ttbBC2oMTJmU9YIObIS2x/O4cZ4iQFiZ9Pl4E9JCJgJbH0zy82iBpxiaM/e5hBjpAQ
        uMMh0bVlB1ARB5DjIrHyhCJEr7DEq+Nb2CFsKYnP7/ayQZRkS/TsMoYI10gsnXeMBcK2lzhw
        ZQ4LSAmzgKbE+l36EGFZiamn1jFBbOWT6P39hAkiziuxYx6MrSrR/O4q1BhpiYnd3awTGJVm
        IXlsFpLHZiF5YBbCtgWMLKsYJVMLinPTU4tNC4zzUsv1ihNzi0vz0vWS83M3MYITnZb3DsZH
        Dz7oHWJk4mA8xCjBwawkwhstyhkvxJuSWFmVWpQfX1Sak1p8iFGag0VJnFfpx5k4IYH0xJLU
        7NTUgtQimCwTB6dUA9NGjTMcOTObZ90IPRF8x3pV8PO+cua3iXGaW+KiNmS5vE0tPX3yVLOo
        3qF5u479jr/gts+zYO2Wubw3mA5JnM370frnwK6jJ1TqVM9vr/92c+uJ3UnHhdk8rv40+KW/
        cUdvxcTeo68Sjq43tvK6IzC3O/bece13+5clTnixMa7Jh+kaE8eLzW9+3+hw/hiyM/v02ncs
        +0J2uDw0cy0XtwlgsV/ZbO949a/yofzAng2r70eUPmhjZtDJMrjPN+/5x/f+C+LWVv17lsrO
        8J1n7lS5tZnt0rV6AX29Kpl39PjWtUzj4H7/Jz0lqOXajUl/Vs6LX+13w3qaoMSra8k7PCsn
        p++eZX//1weZvsdanbzFSizFGYmGWsxFxYkAGPAcVuMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWy7bCSnK5HHle8wZoedYsH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBY3txxlsei+voPNYvnxf0wW
        XXdvMFos/feWxYHP4/IVb4/Lfb1MHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAj
        issmJTUnsyy1SN8ugSvjxpqdjAWv2CpaPv1hbWB8wNrFyMkhIWAiMWnVXfYuRi4OIYEdjBI/
        Hy1lgUhIS1zfOIEdwhaWWPnvOVTRK0aJR9NvMIIk2AR0JXYsbmMDSYgIvGaSuHfmFxNIghko
        cfLJUiaIji5GiV0X1jODJDgFLCXOPr0AtkJYwE/i6s8fYCtYBFQl1s/cDDaVF6im8e02Nghb
        UOLkzCcsEEO1JZ7efAply0tsfzuHGeI8BYmfT5eB/SMiYCWx9M8vNogacYmjP3uYJzAKz0Iy
        ahaSUbOQjJqFpGUBI8sqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgqNXS2sG4Z9UH
        vUOMTByMhxglOJiVRHijRTnjhXhTEiurUovy44tKc1KLDzFKc7AoifN+nbUwTkggPbEkNTs1
        tSC1CCbLxMEp1cAk8u9D5ael76bvC9pwRdkn6zXPzJr2ByrH3WNvtKYKOwb0SByeaNY397Hp
        2YbyDWY3Z56VuPxRkd2ryyq22zP6pcWboFKLv/37ji1v5+aaMrPAfmGL4cagaUuyut/G3dgR
        Ndkk+Dj3zTLlGcq8Xy7Nu2zal37t99X1Ft/61HzTojRrthVoNXAXrNz7R3/9jiduWRWb8qc2
        azX3taW9rObcK58l8T7uQNbXQI8lgl6Wd2oLN+4uDYs8YxGW1mHbYLVreR/foh2h1QHNd79L
        rJBfLcZ6+OH3ExuuxQo52OYdDc5zlWBVk/qakr18Tc2SthlyX+5uVg28e5jlnLq7a8mmmYdS
        H8Vo8c+O0F/6Wl2JpTgj0VCLuag4EQDFbaihSQMAAA==
X-CMS-MailID: 20200712015832epcas5p3506ba61f6435ed3e51339527e295a8a3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200711070541epcas2p47678883840df461f649becfc73792da5
References: <CGME20200711070541epcas2p47678883840df461f649becfc73792da5@epcas2p4.samsung.com>
        <cover.1594450408.git.kwmad.kim@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kiwoong 

> -----Original Message-----
> From: Kiwoong Kim <kwmad.kim@samsung.com>
> Sent: 11 July 2020 12:28
> To: linux-scsi@vger.kernel.org; alim.akhtar@samsung.com;
> avri.altman@wdc.com; jejb@linux.ibm.com; martin.petersen@oracle.com;
> beanhuo@micron.com; asutoshd@codeaurora.org; cang@codeaurora.org;
> bvanassche@acm.org; grant.jung@samsung.com; sc.suh@samsung.com;
> hy50.seo@samsung.com; sh425.lee@samsung.com
> Cc: Kiwoong Kim <kwmad.kim@samsung.com>
> Subject: [RFC PATCH v5 0/3] ufs: exynos: introduce the way to get cmd info
> 
> v4 -> v5
> Rebased on Stanley's patch (scsi: ufs: Fix and simplify ..
> Change cmd history print order
> rename config to SCSI_UFS_EXYNOS_DBG
> feature functions in ufs-exynos-dbg.c by SCSI_UFS_EXYNOS_DBG
> 
After fixing comment on patch 2/3, please send a non-RFC patch for review.
Thanks!

> 2.7.4


