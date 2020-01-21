Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC47C2D0CE
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 19:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2356D21835
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 19:19:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WidWWwk+";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="K+vsOM4z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgAUTTc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 14:19:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47784 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727360AbgAUTTc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jan 2020 14:19:32 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00LJENSh004473;
        Tue, 21 Jan 2020 11:19:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=QFnVW3XuQ+zrlHMnqIbFw72JF3aTO0x2leWkYbGlQsM=;
 b=WidWWwk+vrGmZ0UUXTbpwlKfzLzGxNS9kwMPMq1m+LQZQgEYrgOtUkpY3ZTvsVCVBVC1
 F1xKzyLysVetnKxietJJVwg8mdIPK6EoD3j/yHZaS6OWDweu3cooX2LnVuUuiiAEBkfv
 QA0MDsy0p5fjAj8eEXa6mt6CRxJOv8UIIEySU2LP53vucGyJFxQCxf8EssVmipgiEXQU
 MIu/VjkyXPCqgab62yCy93cNw0E2jAzPaXJZKSGbJaE3IqJa2iE3rcjg0r2myib5bbTK
 CKC7wauikSqChtb1u6gPj4DLxEDFziVcicTxvPmjniyuEuaB+B17H9yUgoHAyDFwaLKp nA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xm08vc7kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Jan 2020 11:19:30 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jan
 2020 11:19:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 21 Jan 2020 11:19:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAJJpNCVjOACRWQsT+qwWYX4hlvbv8Wye5ZetV71Um8edKKmozXsnHJdx/08NY9omdKIwYylkR8lstfkFPkoD3QSFgLv2EWeJH3Dltq9V4hIRNJvra1iCLnLfwTwkblR0x/gGJ0rIvcNxK1AeIIaWNdEaXGgzWx8LjbO1DWFkrSguEFcXB25Tx0HSYbs+xK/Kq1kWpxGSGSVxezOdnOJv5X8BsLDDRLnudRQWId/oH7L2NjFoA0CkVEjDeq9dYzCOQfrZUDv43nrRIMQkWUKozsUjZnMgjRhrqSCsOGo0bIDdu0v1GBASzdoElRCDoWgegsUn3EYhC//Se+jrgM4bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFnVW3XuQ+zrlHMnqIbFw72JF3aTO0x2leWkYbGlQsM=;
 b=memUM2uJcOt5Kd7ENEeQuV+hMcdWrDF2xTUR49Xk3NXyvXMACb6vGxL6aJNPOpHq4kRPiUGPV5gai05GS7qMXHmkHu/ozSFCOYGCYHqNiflN2A5w3ewvTTD/rMMSNjQ42L4y4K+i5gh4eQ4xApxlY61mcqbZXvz6WFUCEabqTYySmuPyS0he2bMu36tUkcZ5mmlzFoLsGfEGBWdIs0A+9Ys/aNvXH5IZ8PMO8z8FYC3uB+YP6ggjsTIEEmY85IY40cJ2EWMiiV41AnnvljIGd25oaUVBSl5n3ZMZ1NIadnUVaVhGY532Hj2j5zR5mB4KLizU6o3y5vdhf3HjfJvKug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFnVW3XuQ+zrlHMnqIbFw72JF3aTO0x2leWkYbGlQsM=;
 b=K+vsOM4zqVOjjp/9KCF83Y/ZWC9Tf+MgJ608VvvGwF9LmL9VoSI/fEH7oL3SfiOXZ2/HECrS9xslsXfXpT97GdoLNpP6TstrXfG4AZqKkRjy/QYL9aKi/8V5ZcUIzZsovysH+SJH3SIZNH81l8jzUJXA7dFOlGcYhL/uX5LERB4=
Received: from MWHPR18MB1071.namprd18.prod.outlook.com (10.173.123.137) by
 MWHPR18MB1680.namprd18.prod.outlook.com (10.173.240.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Tue, 21 Jan 2020 19:19:27 +0000
Received: from MWHPR18MB1071.namprd18.prod.outlook.com
 ([fe80::15d2:5e1b:a2b9:fb56]) by MWHPR18MB1071.namprd18.prod.outlook.com
 ([fe80::15d2:5e1b:a2b9:fb56%10]) with mapi id 15.20.2644.026; Tue, 21 Jan
 2020 19:19:27 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] qla2xxx: Fix unbound NVME response length
Thread-Topic: [PATCH 1/1] qla2xxx: Fix unbound NVME response length
Thread-Index: AQHV0I8xP2krqAIx1k+1zoqvTuxoRqf1GbAA
Date:   Tue, 21 Jan 2020 19:19:27 +0000
Message-ID: <E7463863-11C6-42D6-84DD-9B4A0F203381@marvell.com>
References: <20200121191546.31843-1-hmadhani@marvell.com>
In-Reply-To: <20200121191546.31843-1-hmadhani@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.21.0.200113
x-originating-ip: [50.84.246.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8032b9b4-e93e-49c4-74b7-08d79ea6d53a
x-ms-traffictypediagnostic: MWHPR18MB1680:
x-microsoft-antispam-prvs: <MWHPR18MB1680C8A57C25BBA6D445729CD60D0@MWHPR18MB1680.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39850400004)(396003)(346002)(376002)(189003)(199004)(4326008)(6512007)(5660300002)(71200400001)(6486002)(8676002)(81166006)(81156014)(66476007)(110136005)(86362001)(66556008)(316002)(91956017)(66946007)(6506007)(66446008)(76116006)(8936002)(64756008)(36756003)(2906002)(186003)(478600001)(33656002)(26005)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR18MB1680;H:MWHPR18MB1071.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k8EezlElNTfyaftVq47Lo026LgQiYbcsmJ0PAaDWrKUXOFgLlngbk4pkV3LnrxPdeRHCOsJV0B81DSfjuapIjqx19f9b6qlrLxApU4PCgUikZqw/LA1uhOX6myzLnnUqM/QHs9995J8cMb1mOgiLpQcC6PiM96WXbSPdRnXoEaudxki4git40AB1dv2n68sbQX0pZUP3XF5qQssP/s1ytfGETf1T9wHyrDtu/vnR72c5o4w9KfsdEIJ7d7Owk+Xd2WcoF9kMDFspu3mQ7RjFXe21YfGNySAom5raU8IGuqJf+kxGwJNBDg+L4ydVI0El44wHWCxAkPwTGIAEcekKvlgIXrHW2FABVAGvlRyopVtvPiD1HF17+xcX2h71nWGPFZUZrhRIjxyUcP/+xwdDfk5GIkVtSQd7hN9PfQTEsC0iQMyIINqrtvqGKgI8qwLA
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD75375F946B144AAF195FFF178B1E7D@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8032b9b4-e93e-49c4-74b7-08d79ea6d53a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 19:19:27.4012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Od/x+yXTJcOePD0z8AHsTzmMpXsVPvX3NblUScJgsr2LVNx3jTvUWWqr/rszxi9OwOnLSXdF4ibW9GOBGsuLgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1680
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.634
 definitions=2020-01-21_06:2020-01-21,2020-01-21 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SSBzZW50IHRoaXMgb3V0IHByZW1hdHVyZWx5IC4uIHBsZWFzZSBpZ25vcmUuIFdpbGwgc2VuZCBj
b3JyZWN0IHY0IG9mIHRoaXMgcGF0Y2guDQoNCu+7v09uIDEvMjEvMjAsIDE6MTUgUE0sICJIaW1h
bnNodSBNYWRoYW5pIiA8aG1hZGhhbmlAbWFydmVsbC5jb20+IHdyb3RlOg0KDQogICAgRnJvbTog
QXJ1biBFYXNpIDxhZWFzaUBtYXJ2ZWxsLmNvbT4NCiAgICANCiAgICBPbiBjZXJ0YWluIGNhc2Vz
IHdoZW4gcmVzcG9uc2UgbGVuZ3RoIGlzIGxlc3MgdGhhbiAzMiwgTlZNRSByZXNwb25zZSBkYXRh
DQogICAgaXMgc3VwcGxpZWQgaW5saW5lIGluIElPQ0IuIFRoaXMgaXMgaW5kaWNhdGVkIGJ5IHNv
bWUgY29tYmluYXRpb24gb2Ygc3RhdGUNCiAgICBmbGFncy4gVGhlcmUgd2FzIGFuIGluc3RhbmNl
IHdoZW4gYSBoaWdoLCBhbmQgaW5jb3JyZWN0LCByZXNwb25zZSBsZW5ndGggd2FzDQogICAgaW5k
aWNhdGVkIGNhdXNpbmcgZHJpdmVyIHRvIG92ZXJydW4gYnVmZmVycy4gRml4IHRoaXMgYnkgY2hl
Y2tpbmcgYW5kDQogICAgbGltaXRpbmcgdGhlIHJlc3BvbnNlIHBheWxvYWQgbGVuZ3RoLg0KICAg
IA0KICAgIEZpeGVzOiA3NDAxYmMxOGQxZWUzICgic2NzaTogcWxhMnh4eDogQWRkIEZDLU5WTWUg
Y29tbWFuZCBoYW5kbGluZyIpDQogICAgQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCiAgICBT
aWduZWQtb2ZmLWJ5OiBBcnVuIEVhc2kgPGFlYXNpQG1hcnZlbGwuY29tPg0KICAgIFNpZ25lZC1v
ZmYtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhtYWRoYW5pQG1hcnZlbGwuY29tPg0KICAgIC0tLQ0K
ICAgIEhpIE1hcnRpbiwNCiAgICANCiAgICBXZSBkaXNjb3ZlcmVkIGlzc3VlIHdpdGggb3VyIG5l
d2VyIEdlbjcgYWRhcHRlciB3aGVuIHJlc3BvbnNlIGxlbmd0aA0KICAgIGhhcHBlbnMgdG8gYmUg
bGFyZ2VyIHRoYW4gMzIgYnl0ZXMsIGNvdWxkIHJlc3VsdCBpbnRvIGNyYXNoLg0KICAgIA0KICAg
IFBsZWFzZSBhcHBseSB0aGlzIHRvIDUuNS9zY3NpLWZpeGVzIGJyYW5jaCBhdCB5b3VyIGVhcmxp
ZXN0IGNvbnZlbmllbmNlLg0KICAgIA0KICAgIENoYW5nZXMgZnJvbSB2MyAtPiB2Mg0KICAgIA0K
ICAgIG8gdXNlICJzaXplb2Yoc3RydWN0IG52bWVfZmNfZXJzcF9pdSkiIGluIG1pc3NlZCBwbGFj
ZS4NCiAgICANCiAgICBDaGFuZ2VzIGZyb20gdjIgLT4gdjMNCiAgICANCiAgICBvIFVzZSAic2l6
ZW9mKHN0cnVjdCBudm1lX2ZjX2Vyc3BfaXUpIiB0byBpbmRpY2F0ZSByZXNwb25zZSBwYXlsb2Fk
IHNpemUuDQogICAgDQogICAgQ2hhbmdlcyBmcm9tIHYxIC0+IHYyDQogICAgDQogICAgbyBGaXhl
ZCB0aGUgdGFnIGZvciBzdGFibGUuDQogICAgbyBSZW1vdmVkIGxvZ2l0IHdoaWNoIGdvdCBzcGls
bGVkIGZyb20gb3RoZXIgcGF0Y2ggdG8gcHJldmVudCBjb21waWxlIGZhaWx1cmUuDQogICAgDQog
ICAgVGhhbmtzLA0KICAgIEhpbWFuc2h1DQogICAgLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9pc3IuYyB8IDEwICsrKysrKysrKysNCiAgICAgMSBmaWxlIGNoYW5nZWQsIDEwIGlu
c2VydGlvbnMoKykNCiAgICANCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2lzci5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jDQogICAgaW5kZXggZTdi
YWQwYmZmZmRhLi40Y2FlYzk0ZDhlOTkgMTAwNjQ0DQogICAgLS0tIGEvZHJpdmVycy9zY3NpL3Fs
YTJ4eHgvcWxhX2lzci5jDQogICAgKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5j
DQogICAgQEAgLTE5MzksNiArMTkzOSwxNiBAQCBzdGF0aWMgdm9pZCBxbGEyNHh4X252bWVfaW9j
Yl9lbnRyeShzY3NpX3FsYV9ob3N0X3QgKnZoYSwgc3RydWN0IHJlcV9xdWUgKnJlcSwNCiAgICAg
CQlpbmJ1ZiA9ICh1aW50MzJfdCAqKSZzdHMtPm52bWVfZXJzcF9kYXRhOw0KICAgICAJCW91dGJ1
ZiA9ICh1aW50MzJfdCAqKWZkLT5yc3BhZGRyOw0KICAgICAJCWlvY2ItPnUubnZtZS5yc3BfcHls
ZF9sZW4gPSBsZTE2X3RvX2NwdShzdHMtPm52bWVfcnNwX3B5bGRfbGVuKTsNCiAgICArCQlpZiAo
dW5saWtlbHkoaW9jYi0+dS5udm1lLnJzcF9weWxkX2xlbiA+DQogICAgKwkJICAgIHNpemVvZihz
dHJ1Y3QgbnZtZV9mY19lcnNwX2l1KSkpIHsNCiAgICArCQkJV0FSTl9PTkNFKDEsICJVbmV4cGVj
dGVkIHJlc3BvbnNlIHBheWxvYWQgbGVuZ3RoICV1LlxuIiwNCiAgICArCQkJICAgIGlvY2ItPnUu
bnZtZS5yc3BfcHlsZF9sZW4pOw0KICAgICsJCQlxbF9sb2cocWxfbG9nX3dhcm4sIGZjcG9ydC0+
dmhhLCAweDUxMDAsDQogICAgKwkJCSAgICAiVW5leHBlY3RlZCByZXNwb25zZSBwYXlsb2FkIGxl
bmd0aCAldS5cbiIsDQogICAgKwkJCSAgICBpb2NiLT51Lm52bWUucnNwX3B5bGRfbGVuKTsNCiAg
ICArCQkJaW9jYi0+dS5udm1lLnJzcF9weWxkX2xlbiA9DQogICAgKwkJCSAgICBzaXplb2Yoc3Ry
dWN0IG52bWVfZmNfZXJzcF9pdSk7DQogICAgKwkJfQ0KICAgICAJCWl0ZXIgPSBpb2NiLT51Lm52
bWUucnNwX3B5bGRfbGVuID4+IDI7DQogICAgIAkJZm9yICg7IGl0ZXI7IGl0ZXItLSkNCiAgICAg
CQkJKm91dGJ1ZisrID0gc3dhYjMyKCppbmJ1ZisrKTsNCiAgICAtLSANCiAgICAyLjEyLjANCiAg
ICANCiAgICANCg0K
