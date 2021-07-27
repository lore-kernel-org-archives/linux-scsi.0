Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4E7C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 10:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E670061527
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 10:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbhG0KOf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 06:14:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60320 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236109AbhG0KOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 06:14:33 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210727101432epoutp04c48f530df2983eebaf98907ae37308f3~VnkfmwIcB0449904499epoutp04z
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 10:14:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210727101432epoutp04c48f530df2983eebaf98907ae37308f3~VnkfmwIcB0449904499epoutp04z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627380872;
        bh=nZ1LCnQEGfjxzpmsjN08zuPFIpxfoOlId6rhiX44kIw=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=km3mQd3wYH2R7ikr2WIZCcLK4PA2ZH+JpGS4LVbpN9i0sm577ebLqdtJt4/YPNd9I
         H+Fz1LudJJ6TJY7REi6oS8ELX4jGuupZ5udyZGMjXon33U5cARNAZHUPYcUh70SUu/
         dJ1AL5VbGK8m54ooxIb/sqe9O35272QS/D5y5qYU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210727101430epcas2p4aa8950c6b075720f16f5616e6c00d52d~VnkeoTVtH0094800948epcas2p4Q;
        Tue, 27 Jul 2021 10:14:30 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GYt1x60WBz4x9Q0; Tue, 27 Jul
        2021 10:14:29 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.F3.09921.58CDFF06; Tue, 27 Jul 2021 19:14:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210727101429epcas2p31b7bdb200636151e5db7581075d6e730~Vnkc6QtGy2125721257epcas2p3N;
        Tue, 27 Jul 2021 10:14:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210727101429epsmtrp23ff64c19799c9fc76eb51001d0a8672c~Vnkc4cFym1459314593epsmtrp2X;
        Tue, 27 Jul 2021 10:14:29 +0000 (GMT)
X-AuditID: b6c32a45-fb3ff700000026c1-79-60ffdc85aca8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.58.08394.48CDFF06; Tue, 27 Jul 2021 19:14:28 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210727101428epsmtip17fd4a4ef22105533c8a0130908eba7d4~VnkckeuyL0258102581epsmtip1U;
        Tue, 27 Jul 2021 10:14:28 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Bean Huo'" <huobean@gmail.com>,
        "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <602ee8bc56891f0f0429afe274d7174ec325172e.camel@gmail.com>
Subject: RE: [PATCH v2 14/15] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
Date:   Tue, 27 Jul 2021 19:14:28 +0900
Message-ID: <004601d782d0$2f43cd20$8dcb6760$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJIF3zu3g+/Awptn47LJA2vs45sGwKSU/P/Ail7aZYBcufzmAMJoF0fATgHUheqIduGwA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmmW7rnf8JBqte6VqcfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC16djpbnJ6wiMliztkGJosn62cxWyy6sY3JYuU1C4vz5zewW9zc
        cpTFYsb5fUwW3dd3sFksP/6PyUHA4/IVb4/Lfb1MHjtn3WX32LxCy2PxnpdMHptWdbJ5TFh0
        gNHj49NbLB59W1YxenzeJOfRfqCbKYA7KscmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
        0NLCXEkhLzE31VbJxSdA1y0zB+gbJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6B
        oWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsbExQvYC7awVpzddpilgbGHpYuRk0NCwETi5r7r
        7F2MXBxCAjsYJfb1tzKBJIQEPjFKPHvjCZH4xiix6uBsJpiOH5+a2CASexklnixuZIVwXjBK
        LF3eywZSxSagL/GyYxsriC0CkuhfLApSxCxwglli4a8pzCAJTgF3ianLJoMdIiwQJ3F5+TZG
        EJtFQFVi2cU1QDUcHLwClhLTTqWBhHkFBCVOznwCVs4soC2xbOFrZoiLFCR+Pl0GtStMouHX
        GyaIGhGJ2Z1tzCB7JQSaOSXuHV0C9bSLxIRte6GahSVeHd/CDmFLSXx+t5cNoqGbUaL10X+o
        xGpGic5GHwjbXuLX9C2sIMcxC2hKrN+lD2JKCChLHLkFdRufRMfhv+wQYV6JjjYhiEZ1iQPb
        p0NdICvRPecz6wRGpVlIPpuF5LNZSD6YhbBrASPLKkax1ILi3PTUYqMCQ+TI3sQITularjsY
        J7/9oHeIkYmD8RCjBAezkgivw4rfCUK8KYmVValF+fFFpTmpxYcYTYFBPZFZSjQ5H5hV8kri
        DU2NzMwMLE0tTM2MLJTEeTXiviYICaQnlqRmp6YWpBbB9DFxcEo1MPGruaQ69M352HXo6Kf3
        fCx8ytdnOC2YISe6Zk1msbfzHKWL91yrM6cpbb50t8ie9yzn+zj/ZgXvixxerfxykjZpi39O
        3LO4546VWX6iTvFevU9X2++uUEtbHBKg+Ftw4U/+JVv2/ouS8/NS1XC1St01nZV7Z7ZO5hmp
        9U+3bOx+kTlDpWLH1VeGYsKh/U6OT7Zndufz2m/cfGFpkmlYfMfp/49f6Bmd4A09H7v7wdpe
        7/WeKlUZ5yYGM3Zt5L63WcXyx4E2ngs3pZa+f+Q2z35feWBr2eST0ZU/l/7+rJvHt/n8h1ee
        i+3Kuq4kJCa6zmCvE8qcueL53o2JP08oHRXLlj78W3m/ufffufH+t5VYijMSDbWYi4oTAW6y
        +bpyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWy7bCSnG7Lnf8JBt9azC1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBY9O50tTk9YxGQx52wDk8WT9bOYLRbd2MZksfKahcX58xvYLW5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8flvl4mj52z7rJ7bF6h5bF4z0smj02rOtk8Jiw6
        wOjx8ektFo++LasYPT5vkvNoP9DNFMAdxWWTkpqTWZZapG+XwJWxYPY7toI5rBWNG88xNTB+
        Ye5i5OSQEDCR+PGpiQ3EFhLYzSgx54cuRFxW4tm7HewQtrDE/ZYjrF2MXEA1zxglZj5aC9bA
        JqAv8bJjG1hCROAVo8SJq+1sIA6zwAVmiev/f7JBtLxikvi16BsjSAungLvE1GWTWUBsYYEY
        iWMbNoDFWQRUJZZdXAN0EwcHr4ClxLRTaSBhXgFBiZMzn4CVMwtoS/Q+bGWEsZctfA31goLE
        z6fLWEFsEYEwiYZfb5ggakQkZne2MU9gFJ6FZNQsJKNmIRk1C0nLAkaWVYySqQXFuem5xYYF
        hnmp5XrFibnFpXnpesn5uZsYwfGtpbmDcfuqD3qHGJk4GA8xSnAwK4nwOqz4nSDEm5JYWZVa
        lB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QD07Wu9Am+ZeESxrs7eNUO
        G7AbHlza7HD51pvzzhVfKhuOnPEzS/n5yHb1/NIvB6IEmz6GnsqVMZncaLNhmfZy9/cN0+1X
        +29W7764V/HjUrfqrqe80RM/y0qUBedPuCDNXz3j3MoXJr7MXzfoHPX8mB/0+M79zHlH40Uu
        9HV7uq+5FWYdeL/zU+a0Fesz8kqu7taVLRHPWpXYsjp9Z1F93ENelZorq2fqBvJxuDbNemD7
        cDdTSND8/YUyxu3vTzSaMboIxL6K46vr2mgx5c+92s+SNalfsm023Vkn85lbWenV0YWOTp5/
        jFc1am+6E/OYXy+40FPuwW5hW902vh974yrkN259L5v8XTZtwTIXJZbijERDLeai4kQAHyIs
        F14DAAA=
X-CMS-MailID: 20210727101429epcas2p31b7bdb200636151e5db7581075d6e730
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab@epcas2p3.samsung.com>
        <20210714071131.101204-15-chanho61.park@samsung.com>
        <2b4f4e6d76cdc517843fe8880312541c754d5352.camel@gmail.com>
        <000601d7820a$9aa11210$cfe33630$@samsung.com>
        <602ee8bc56891f0f0429afe274d7174ec325172e.camel@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > A PH has its own doorbell register and each VHs also has it as well.
> >
> > The TASK_TAG=5B7:5=5D can be used to distinguish the origin of the
> > request among VHs and remaining TASK_TAG=5B4:0=5D will be used for
> > supporting 32 tags.
> >
> >
> >
> > Best Regards,
> >
> > Chanho Park
>=20
> Thanks for your reply.
>=20
> so you split the =22Task Tag=22 filed byte3 in the UPIU header to two
> parts, bit7=7Ebit5 is for the VHs ID, and bit4=7Ebit0 is for the task ID.
> but this is not defined in the Spec 2.1. correct?
>=20

You're right.
For PH, TASK_TAG=5B7:5=5D will be set to =220=22 but a VHID will be used in=
 case of VH.

Best Regards,
Chanho Park

