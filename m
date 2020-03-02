Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFF4C3F2CD
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 23:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3635224673
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 23:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fHY34cGx";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="ABcMXwMa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCBXBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 18:01:03 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13334 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726785AbgCBXBD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2020 18:01:03 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022N11fl020727
        for <linux-scsi@vger.kernel.org>; Mon, 2 Mar 2020 15:01:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=zcan2EH4n5xH+OZQWChTqZvWc2vtPg6+xXZ1BiZH1Dk=;
 b=fHY34cGxhepJtGS1VCCWmcRq6NbFRS28DdU7z00FWoQULAN10Xm28R2/Uj1AuZu4PHk5
 92HVHqa1Wg9ItjvPJAOwtqj/WTYgKvpLgwBEjs7QyKhHVt4gOFy0qHSpZZyj2g/P1sI4
 MLQMD9ENbhMA0r0+sqiZW5g99X/Yz72cuSHFi3oard1LNtWwvFstLI+du3or/11ZIPVU
 xs1QS5JaoGTrAh4hIO8u5XMYyCF/6Ux5f1qHvYc4RAKH/0cW/dYunlmJO0iiFhC/W9D9
 W8PCCU/MvBs374FX5MiY8p0R5jHopfOiIxlfAm7lAHttTXb3ALmjAaNXlqJLhKWsPJC2 Eg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yfrbu10dm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2020 15:01:01 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Mar
 2020 15:00:54 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Mar
 2020 15:00:53 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 2 Mar 2020 15:00:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrtyPPFLVy0V2rVeW8oVsXmUAoYNZvDIMx/FUU6tQDW2d5ERJzTjEhDaKnu0lXn9VMMWuufF/CpZIqynRAbCuu2vjgL0iELAmYbjaBlkX4DWuDc3qtAswErzK0tRsOsNwV/9pSJcZQzrroGKam1sogU0I4zXSg1RhLrf2BRjK0NTIrMtT9lz3TAMH60OGAOYfBp41tFbEl0t+e92uvV1yZWFD03kCTGuKEXge1Dd3V019K/ehFKIpDkBWR2WzImPyVIXiVY4UMCB2EXdldEN7r1deBi3WVXOr02v859/qxePDoEnxkOPvu6BoiDevxxNdTtCcEZMJIo1ZAjPih47Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcan2EH4n5xH+OZQWChTqZvWc2vtPg6+xXZ1BiZH1Dk=;
 b=kiZ46OnE78C+kEJCjJNlLXGmI0kITwLPAMO5wBhPyU6VGo/TrOVryka2RGivQqfZk/XqAsmOE3s4hxp/B10gVB68sS1X50tjtSgHEv5vs5CzvQBqtkznFLFTxQ6OJ3wYG9636YtRiJ3pUQtPTqF6Ehj+LJyEju6Y+cK5SkNZbXCbc9+nkc+C/AknJtstdqyGYfOk9I6f6LwCxcUvUdAyK6g1vMZyIGF6HvNNo6dGQ6RfCN7HGXH6xLqkuGGHo9RpmVIbHw36rwMEPhffWakKrHfmoZtJykaHrQ7s6uLTaFGl1auX2besb3QXYRbgPUm2UZVLpQD6d2KnDS4szqiv+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcan2EH4n5xH+OZQWChTqZvWc2vtPg6+xXZ1BiZH1Dk=;
 b=ABcMXwMat112wv3IHA/h5186tt1IYDmIBIfkjm8SZ/Xvs87OKb2jKhnJHYJm43FJNESPTGBPaankXQKpI9nY/248YE3NTtSeVgG81gP3QXmkqG0N9ZJ7mIfQKLBhJmreztzUkP6B2eN9IyDgMoKXSxtf0sOSYUe+YMGgc55f3Ww=
Received: from DM5PR1801MB1820.namprd18.prod.outlook.com (2603:10b6:4:6a::12)
 by DM5PR1801MB1883.namprd18.prod.outlook.com (2603:10b6:4:62::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19; Mon, 2 Mar
 2020 23:00:51 +0000
Received: from DM5PR1801MB1820.namprd18.prod.outlook.com
 ([fe80::3cc1:38d7:b255:9e2b]) by DM5PR1801MB1820.namprd18.prod.outlook.com
 ([fe80::3cc1:38d7:b255:9e2b%3]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 23:00:51 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Rob Jones <rjones@marvell.com>
Subject: Re: [EXT] [PATCH] qla2xxx: add ring buffer for tracing debug logs.
Thread-Topic: [EXT] [PATCH] qla2xxx: add ring buffer for tracing debug logs.
Thread-Index: AQHV4g2Xg1Suln24yECMfXsNVgH9lag1pCQA
Date:   Mon, 2 Mar 2020 23:00:51 +0000
Message-ID: <6A3546C1-17F6-4EF4-8BF0-64ADC784A6AD@marvell.com>
References: <1581557368-32080-1-git-send-email-rajan.shanmugavelu@oracle.com>
In-Reply-To: <1581557368-32080-1-git-send-email-rajan.shanmugavelu@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.22.0.200209
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3a7d1e6-8c6b-4a40-5544-08d7befd8dfe
x-ms-traffictypediagnostic: DM5PR1801MB1883:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1801MB188321DEC5FDCA2B383F54CAD6E70@DM5PR1801MB1883.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(136003)(39850400004)(189003)(199004)(5660300002)(478600001)(316002)(110136005)(66946007)(66446008)(66556008)(64756008)(91956017)(76116006)(6512007)(66476007)(186003)(71200400001)(26005)(81166006)(8676002)(8936002)(81156014)(6506007)(2906002)(33656002)(36756003)(6636002)(6486002)(2616005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR1801MB1883;H:DM5PR1801MB1820.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i+ZD91mlF4qyKmOlxicNelAei2PS6UyS5cQVYnT+c92G08XqEZ5snu5lAoPX52spJDdV8DHdetwMmKj8gA0NsvQxMAWy69ztfOdMY2oFXQyS8xM4r9JvZMkPRUK7kFw83S8xV+WAvKZ3kPchic71tBH9vwMXtzfv1+1uJovKkEtZPK+EiVE3FXV6WObJo6Uhq8Er5Adsm+oDbEp6dkEn4CBocU9rvHKrUluPc5xdxOmtM1x8KtQF/u6ahlFOe6qrKG+rs3Q4F9YfQ5OdiG8IN1CCLtQk0D+JupfxiN5ykc7T70rEeZx5H96zRllzMlkSrezc5zcnHExzxlPffXcYeS04eXxrEspEkqAhegvzbs7excq112Js2/Ojr9b9Jwp+V3Ksp03OWWCLYbcZd58nSybFnygmiMl6tv6HmQROPt001qlDi3Shl+YGzwiAvDQA
x-ms-exchange-antispam-messagedata: hsI7mAdQ1BHVw5hZbQskT4PaidQOQ5+Kq4oKii+RCnIafUsauWaoaj69hf0LBZAvDzZ1rRLkgSv/RYSIYl17VEHtDHp2TeEHaOlBRNppxjn2Bv0nzya0odEIzR2VJtkiww/yRRwaXQFpbjAecHcyCg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <56FE63B599127E4AA4C104D7987729EB@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a7d1e6-8c6b-4a40-5544-08d7befd8dfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 23:00:51.2254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +X54w/Z4THgfI7iHEEld4V1GwLBo5iRhWp2rIsaWtlY/nb1Bg7VA922BHd9hzEAPfkfuhXM3nLgR+1QSpGNuhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1801MB1883
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_09:2020-03-02,2020-03-02 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UmFqYW4sIA0KDQoNCu+7v09uIDIvMTIvMjAsIDc6MzMgUE0sICJSYWphbiBTaGFubXVnYXZlbHUi
IDxyYWphbi5zaGFubXVnYXZlbHVAb3JhY2xlLmNvbT4gd3JvdGU6DQoNCiAgICBFeHRlcm5hbCBF
bWFpbA0KICAgIA0KICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCiAgICAgICAgSGF2aW5nIHRoaXMgbG9nIGlu
IGEgcmluZ2J1ZmZlciBoZWxwcyB0byBkaWFnbm9zZSBxbGEyeHh4IGRyaXZlciBhbmQNCiAgICAg
ICAgZmlybXdhcmUgaXNzdWVzIGluc3RlYWQgb2YgaGF2aW5nIGl0IHJ1biBhZ2FpbiB3aXRoIGV4
dGVuZGVkX2xvZ2dpbmcNCiAgICAgICAgZW5hYmxlZCBzYXZpbmcgY3ljbGVzIGFuZCBoYXJkIHRv
IHJlcHJvZHVjZSBwcm9ibGVtLg0KICAgIA0KICAgIFNpZ25lZC1vZmYtYnk6IFJhamFuIFNoYW5t
dWdhdmVsdSA8cmFqYW4uc2hhbm11Z2F2ZWx1QG9yYWNsZS5jb20+DQogICAgU2lnbmVkLW9mZi1i
eTogSm9lIEppbiA8am9lLmppbkBvcmFjbGUuY29tPg0KICAgIC0tLQ0KICAgICBkcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfZGJnLmMgfCAyMyArKysrKysrKysrKysrKysrKysrKy0tLQ0KICAgICBp
bmNsdWRlL3RyYWNlL2V2ZW50cy9xbGEuaCAgICAgfCAzOSArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysNCiAgICAgMiBmaWxlcyBjaGFuZ2VkLCA1OSBpbnNlcnRpb25zKCsp
LCAzIGRlbGV0aW9ucygtKQ0KICAgICBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVkZS90cmFjZS9l
dmVudHMvcWxhLmgNCiAgICANCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2RiZy5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2RiZy5jDQogICAgaW5kZXggMzBh
ZmM1OS4uY2Y3ZjkyNSAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFf
ZGJnLmMNCiAgICArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZGJnLmMNCiAgICBAQCAt
NzMsNiArNzMsOCBAQA0KICAgICAjaW5jbHVkZSAicWxhX2RlZi5oIg0KICAgICANCiAgICAgI2lu
Y2x1ZGUgPGxpbnV4L2RlbGF5Lmg+DQogICAgKyNkZWZpbmUgQ1JFQVRFX1RSQUNFX1BPSU5UUw0K
ICAgICsjaW5jbHVkZSA8dHJhY2UvZXZlbnRzL3FsYS5oPg0KICAgICANCiAgICAgc3RhdGljIHVp
bnQzMl90IHFsX2RiZ19vZmZzZXQgPSAweDgwMDsNCiAgICAgDQogICAgQEAgLTI1NDMsMTUgKzI1
NDUsMzAgQEANCiAgICAgew0KICAgICAJdmFfbGlzdCB2YTsNCiAgICAgCXN0cnVjdCB2YV9mb3Jt
YXQgdmFmOw0KICAgIC0NCiAgICAtCWlmICghcWxfbWFza19tYXRjaChsZXZlbCkpDQogICAgLQkJ
cmV0dXJuOw0KICAgICsJY2hhciBwYnVmWzY0XTsNCiAgICAgDQogICAgIAl2YV9zdGFydCh2YSwg
Zm10KTsNCiAgICAgDQogICAgIAl2YWYuZm10ID0gZm10Ow0KICAgICAJdmFmLnZhID0gJnZhOw0K
ICAgICANCiAgICArCWlmICghcWxfbWFza19tYXRjaChsZXZlbCkpIHsNCiAgICArCQlpZiAodmhh
ICE9IE5VTEwpIHsNCiAgICArCQkJY29uc3Qgc3RydWN0IHBjaV9kZXYgKnBkZXYgPSB2aGEtPmh3
LT5wZGV2Ow0KICAgICsJCQkvKiA8bW9kdWxlLW5hbWU+IDxtc2ctaWQ+Ojxob3N0PiBNZXNzYWdl
ICovDQogICAgKwkJCXNucHJpbnRmKHBidWYsIHNpemVvZihwYnVmKSwgIiVzIFslc10tJTA0eDol
bGQ6ICIsDQogICAgKwkJCSAgICBRTF9NU0dIRFIsIGRldl9uYW1lKCYocGRldi0+ZGV2KSksIGlk
LA0KICAgICsJCQkgICAgdmhhLT5ob3N0X25vKTsNCiAgICArCQl9IGVsc2Ugew0KICAgICsJCQlz
bnByaW50ZihwYnVmLCBzaXplb2YocGJ1ZiksICIlcyBbJXNdLSUwNHg6IDogIiwNCiAgICArCQkJ
ICAgIFFMX01TR0hEUiwgIjAwMDA6MDA6MDAuMCIsIGlkKTsNCiAgICArCQl9DQogICAgKwkJcGJ1
ZltzaXplb2YocGJ1ZikgLSAxXSA9IDA7DQogICAgKwkJdHJhY2VfcWxfZGJnX2xvZyhwYnVmLCAm
dmFmKTsNCiAgICArCQl2YV9lbmQodmEpOw0KICAgICsJCXJldHVybjsNCiAgICArCX0NCiAgICAr
DQogICAgIAlpZiAodmhhICE9IE5VTEwpIHsNCiAgICAgCQljb25zdCBzdHJ1Y3QgcGNpX2RldiAq
cGRldiA9IHZoYS0+aHctPnBkZXY7DQogICAgIAkJLyogPG1vZHVsZS1uYW1lPiA8cGNpLW5hbWU+
IDxtc2ctaWQ+Ojxob3N0PiBNZXNzYWdlICovDQogICAgZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJh
Y2UvZXZlbnRzL3FsYS5oIGIvaW5jbHVkZS90cmFjZS9ldmVudHMvcWxhLmgNCiAgICBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KICAgIGluZGV4IDAwMDAwMDAwLi5iNzFmNjgwDQogICAgLS0tIC9kZXYv
bnVsbA0KICAgICsrKyBiL2luY2x1ZGUvdHJhY2UvZXZlbnRzL3FsYS5oDQogICAgQEAgLTAsMCAr
MSwzOSBAQA0KICAgICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCAqLw0KICAg
ICsjaWYgIWRlZmluZWQoX1RSQUNFX1FMQV9IXykgfHwgZGVmaW5lZChUUkFDRV9IRUFERVJfTVVM
VElfUkVBRCkNCiAgICArI2RlZmluZSBfVFJBQ0VfUUxBX0hfDQogICAgKw0KICAgICsjaW5jbHVk
ZSA8bGludXgvdHJhY2Vwb2ludC5oPg0KICAgICsNCiAgICArI3VuZGVmIFRSQUNFX1NZU1RFTQ0K
ICAgICsjZGVmaW5lIFRSQUNFX1NZU1RFTSBxbGENCiAgICArDQogICAgKyNkZWZpbmUgUUxBX01T
R19NQVggMjU2DQogICAgKw0KICAgICtERUNMQVJFX0VWRU5UX0NMQVNTKHFsYV9sb2dfZXZlbnQs
DQogICAgKwlUUF9QUk9UTyhjb25zdCBjaGFyICpidWYsDQogICAgKwkJc3RydWN0IHZhX2Zvcm1h
dCAqdmFmKSwNCiAgICArDQogICAgKwlUUF9BUkdTKGJ1ZiwgdmFmKSwNCiAgICArDQogICAgKwlU
UF9TVFJVQ1RfX2VudHJ5KA0KICAgICsJCV9fc3RyaW5nKGJ1ZiwgYnVmKQ0KICAgICsJCV9fZHlu
YW1pY19hcnJheShjaGFyLCBtc2csIFFMQV9NU0dfTUFYKQ0KICAgICsJKSwNCiAgICArCVRQX2Zh
c3RfYXNzaWduKA0KICAgICsJCV9fYXNzaWduX3N0cihidWYsIGJ1Zik7DQogICAgKwkJdnNucHJp
bnRmKF9fZ2V0X3N0cihtc2cpLCBRTEFfTVNHX01BWCwgdmFmLT5mbXQsICp2YWYtPnZhKTsNCiAg
ICArCSksDQogICAgKw0KICAgICsJVFBfcHJpbnRrKCIlcyAlcyIsIF9fZ2V0X3N0cihidWYpLCBf
X2dldF9zdHIobXNnKSkNCiAgICArKTsNCiAgICArDQogICAgK0RFRklORV9FVkVOVChxbGFfbG9n
X2V2ZW50LCBxbF9kYmdfbG9nLA0KICAgICsJVFBfUFJPVE8oY29uc3QgY2hhciAqYnVmLCBzdHJ1
Y3QgdmFfZm9ybWF0ICp2YWYpLA0KICAgICsJVFBfQVJHUyhidWYsIHZhZikNCiAgICArKTsNCiAg
ICArDQogICAgKyNlbmRpZiAvKiBfVFJBQ0VfUUxBX0ggKi8NCiAgICArDQogICAgKyNkZWZpbmUg
VFJBQ0VfSU5DTFVERV9GSUxFIHFsYQ0KICAgICsNCiAgICArI2luY2x1ZGUgPHRyYWNlL2RlZmlu
ZV90cmFjZS5oPg0KICAgIC0tIA0KICAgIDEuOC4zLjENCiAgICANClNvcnJ5IGZvciBsb25nIGRl
bGF5LiAgTG9va3MgR29vZC4NCg0KQWNrZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhtYWRoYW5p
QG1hcnZlbGwuY29tPg0KDQo=
