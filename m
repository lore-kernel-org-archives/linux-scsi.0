Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BCAC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 02:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6E5E20771
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 02:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VaX50bmW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbgFWCOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 22:14:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61051 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbgFWCOt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2020 22:14:49 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200623021444epoutp03e3cd74112d81519ccddaa47c688f77a5~bCorrnCGc2764927649epoutp03N
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2020 02:14:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200623021444epoutp03e3cd74112d81519ccddaa47c688f77a5~bCorrnCGc2764927649epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592878485;
        bh=XXfjzlQkMOYMn/q/nPb1EdilxuO+iFDT9wo3YVqNbQM=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=VaX50bmWjYtZb6uNCvMSxTr4jW9XsmxI4OupJs2+Wm2ITRukEtOpqMUUy9gcspu2k
         fzYHRRgeynjvAwXeaGPcqbu6AR/ZZoFN3V0/C99M3RTj4RlZiXf17X2UrfH20/Qd7Q
         kSkNgTR7yW1Y7eBHi7DY8akvhC0+P55r1h81obtM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200623021444epcas2p201109914485ca2f716e5f10280824d11~bCorKGc8Q3207632076epcas2p27;
        Tue, 23 Jun 2020 02:14:44 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 49rVGV2LFlzMqYkV; Tue, 23 Jun
        2020 02:14:42 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        39.33.27013.29561FE5; Tue, 23 Jun 2020 11:14:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200623021441epcas2p2cde6e0f545a37c96a6a2071e51769c71~bCoo2m_ve3207632076epcas2p20;
        Tue, 23 Jun 2020 02:14:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200623021441epsmtrp1b50d640775f3aca6020551922ba9dbfb~bCoo1xAjv0322103221epsmtrp1O;
        Tue, 23 Jun 2020 02:14:41 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-52-5ef16592a17c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C1.21.08303.19561FE5; Tue, 23 Jun 2020 11:14:41 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200623021441epsmtip1d1a6cdff9fddc9efcd0e515ff2ae296f~bCooqI4d-1436914369epsmtip1D;
        Tue, 23 Jun 2020 02:14:41 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>
In-Reply-To: <SN6PR04MB46402E9A01DE395EAAE223D3FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v1 0/2] support various values per device
Date:   Tue, 23 Jun 2020 11:14:41 +0900
Message-ID: <001b01d64904$0e039160$2a0ab420$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJdGUAKyYrt7Gwxtk8eU4yrz5KyMQJXX9isAmI7FVunsgKFgA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmhe6k1I9xBvsu8lo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3Jovv6DjaL5cf/MTlwely+4u1xua+XyWPCogOM
        Ht/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwVwROXYZKQmpqQWKaTmJeenZOal2yp5B8c7x5ua
        GRjqGlpamCsp5CXmptoqufgE6Lpl5gCdp6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUot
        SMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMn4eFCz4C1fxfPld9kaGGfydjFycEgImEhc
        nVbdxcjJISSwg1Fi5W+gMBeQ/YlRYvqt04wQzmdGidYdG5hBqkAajj6/xQbRsYtR4sA/R4ii
        F4wS3/4tYgRJsAloS0x7uJsVJCEi8ItR4sPZs2DdnAKxEt//7wTrFhZwlHjbcYMJxGYRUJV4
        vmAmWA2vgKXE2lULoWxBiZMzn7CA2MxAQ5ctfA11hYLEz6fLWEFsEQEniY7fd5khakQkZne2
        MYMslhBYySGxYuMZRogGF4lrk09ANQtLvDq+hR3ClpJ42d8GZddL7JvawArR3MMo8XTfP6hm
        Y4lZz9oZQQHGLKApsX6XPiTslCWO3IK6jU+i4/Bfdogwr0RHmxBEo7LEr0mToYZISsy8eQdq
        k4fE79eXWCcwKs5C8uUsJF/OQvLNLIS9CxhZVjGKpRYU56anFhsVmCBH9SZGcMLV8tjBOPvt
        B71DjEwcjIcYJTiYlUR4Xwe8ixPiTUmsrEotyo8vKs1JLT7EaAoM94nMUqLJ+cCUn1cSb2hq
        ZGZmYGlqYWpmZKEkzvvO6kKckEB6YklqdmpqQWoRTB8TB6dUA1P7FsVj9ucXH5iQ8uuQQvCc
        jNPtp8ouCUzhzzUrOsXXuMK6Vv9pTtgK+0O35A+s3a19KSZk+c/fPqpPhRXULHh3iqyQ3r1Y
        dH4k85KkwAklL53OiATEcT1caNm0eIbp4auL/u/Qd3W++K3gm4ru4kTjiIyu5ztlu/ds7f94
        cNnm6HNu9o3iZh/zuuf5Bt5fzB21vWxTstgcSSazEIMTR3frfpkwy4njhE+d7DMRXhZF5s/V
        rBczm1ZG/TE98mePZO6zeY4STBcTz3RtYaiex784Xfz/Gsnq+G/Wi5VYc52Vaw/NjWr6cGPn
        bKnij2cKO5vWJB9iFHwka6jePflrhFIFg+ju2z9j1zjr8S3OzFZiKc5INNRiLipOBACKt4u3
        QQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnO7E1I9xBu8+GFs8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3Jovv6DjaL5cf/MTlwely+4u1xua+XyWPCogOM
        Ht/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwVwRHHZpKTmZJalFunbJXBlrPv+k6XgGk/FofXT
        mBsY27i6GDk5JARMJI4+v8XWxcjFISSwg1Hi8c7vrBAJSYkTO58zQtjCEvdbjrBCFD1jlHix
        GSLBJqAtMe3hbrCEiEALk8TsD13MIAkhgReMEl9mG4LYnAKxEt//72QDsYUFHCXedtxgArFZ
        BFQlni+YCVbPK2ApsXbVQihbUOLkzCcsIDYz0ILeh62MMPayha+ZIS5SkPj5dBnYpSICThId
        v+8yQ9SISMzubGOewCg0C8moWUhGzUIyahaSlgWMLKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz
        0vWS83M3MYIjTUtrB+OeVR/0DjEycTAeYpTgYFYS4X0d8C5OiDclsbIqtSg/vqg0J7X4EKM0
        B4uSOO/XWQvjhATSE0tSs1NTC1KLYLJMHJxSDUxz5MRXve1837p7beLNgj2XfC271pZuuVDa
        /aJzx4t7SrtMaxNefPY9sU1yp+9Uzf64gzmnnfl2Rvn3p27tf29cp5J2TP4405aIw0Fn1Tti
        uVR9W+f6T2w6pppWMNmY7879sC0nQvYu+pN45WjEmuNh84/MO3E/YsorZ0ORL1/PXd33eXv3
        6U+HvsxQDr83nyXm6M2MG81hplNfGbyUn3/raof0M8MNhU0v9dlDT9xXFryRrLNw04uU6Ml/
        TAtDwr//YlkuUxTwi4Pl0ZyJzr6saScEO+MKbMtj2lJfVTDqlK1K/6dqofm0Ifmf5dGTpuu4
        n+Rzebb2PLnE3LFX0Mb8/M3rsz7UCi2YcDTq0ZJJSizFGYmGWsxFxYkAjxlnSyMDAAA=
X-CMS-MailID: 20200623021441epcas2p2cde6e0f545a37c96a6a2071e51769c71
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620073912epcas2p469d0082af35ff54a8e84793feed2ab6d
References: <CGME20200620073912epcas2p469d0082af35ff54a8e84793feed2ab6d@epcas2p4.samsung.com>
        <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
        <SN6PR04MB46402E9A01DE395EAAE223D3FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Respective UFS devices have their own characteristics and many of them
> > could be a form of numbers, such as timeout and a number of retires.
> > This introduces the way to set those things per specific device vendor
> > or specific device.
> >
> > I wrote this like the style of ufs_fixups stuffs.
> Looks like your preparing the ground of making quirks a common practice..=
.
> Anyway, we already have that option per platform/vendor - what is that yo=
u
> are missing?
>=20
> And as far as fDeviceInit  - the spec says:
> =22The host polls the fDeviceInit flag to check the completion of the
> process.=22
> Your changes are align with that definition, so I am not sure that even a
> new quirk is needed?
>=20
> Thanks,
> Avri

I see what you're saying and thank you for your opinion.

But I don=E2=80=99t=20think=20what=20the=20spec=20mentions=20fits=20in=20op=
erating=20system=20all=20the=20time.=0D=0AIn=20fact,=20current=20driver=20d=
oesn't=20work=20exactly=20the=20same=20with=20the=20description,=0D=0Asince=
=20current=20driver=20somehow=20terminates=20the=20waiting=20after=20a=20se=
ries=20of=20retrying.=0D=0ABesides,=20I'm=20not=20sure=20if=20waiting=20som=
ething=20infinitely=20is=20great=20for=20Linux=20kernel,=0D=0AMany=20are=20=
suffering=20from=20things=20like=20that=20point=20in=20the=20mobile=20indus=
try=0D=0Abecause=20that=20makes=20harder=20to=20figure=20out=20what's=20hap=
pening.=20Someone=20could=20tell=0D=0Athat=20kernel=20log=20shows=20it=20bu=
t=20in=20many=20development=20environments,=20it's=20difficult=20to=20=0D=
=0Acheck=20and=20occurring=20errors=20for=20timed-out=20is=20beneficial,=20=
I=20think.=0D=0A=0D=0AThat's=20why=20errors=20for=20not=20completing=20some=
thing=20have=20been=20introduced=20in=20some=20domains,=0D=0Apossibly=20eve=
n=20some=20architectures=20which=20don't=20define=20that.=0D=0A=0D=0A
