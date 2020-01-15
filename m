Return-Path: <SRS0=obCF=3E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F258DC33CB1
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jan 2020 16:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABA11214AF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jan 2020 16:14:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dLfecLbC";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="f9iEdbND"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAOQOs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 11:14:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43582 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbgAOQOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Jan 2020 11:14:48 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00FGDaan027787;
        Wed, 15 Jan 2020 08:14:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=WhPGcebyJSH/GZr2ro/YGUfNAMgC6vAPk4iyk1LQuL0=;
 b=dLfecLbCRrTCDt3k7Hc1D4fbNSI9hrw6YAPHcbyH5X22FmGfZfhm/gXBcXoGePg6wveB
 286qaXmhdEEVwfDxX8+Yrk7Z99q2OEdUxLJ1HSJqyNHw1r5qLPlHQMmCKfkpbmf9nZyJ
 NPixWMXblCUQFRksXlMj/43fUQm0fktNWB2WppSqhmDhnE5w8tRPJ9QMDxoGudn/Qf67
 0CSps5LXQ5lMXpo3fyr4ZIMxSgiA5S1+k/Wour0pxnajRaTzKo7JmOnFoGJebYXacXeY
 baz28EHFhmThs4TE+Z9+PS+L5c/NWQrRAOebrh+1BWBbaXDsaq+MnA2g9ORU4oI4FFmt Vw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xhrhe2xn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jan 2020 08:14:42 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jan
 2020 08:14:40 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 15 Jan 2020 08:14:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGyajLKz2Y+T429X5F+w7Q5ofjSY0qLF5o82WbyMWWsCjrU8Rn2h2heYTzGzWhVjtH1IN6lpGkS0ZJtsrS+DXw1Q8Ld2k0bbUhHlC7m4ySce+0BZjQ1rbuJS+kZLoUwoU92lhw5RlXa9FIj44Miu4+McvbXM3hn33PlepEOms7KeJNhOC3Trjr4jf7k1+ak+gVnpul5IRVI5yaXpqlfCjaPmEaOWjBrmO6dyS7AWGN41DvHlNtOWxMeJV13dXMdoocenxxA1iWaJIvvh0R2Fzbko4cnIecytlaChWw5OLCI2SJ0ATxfjKxvBINKEV0abwLf5yhwi2ug6yrs0JhtNmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhPGcebyJSH/GZr2ro/YGUfNAMgC6vAPk4iyk1LQuL0=;
 b=P1mlED/BBlOjJ3tYnjuylsanrZtTVsIUUYx0zvN38HbJSuYx3yZkeagqVHBY6znZ2W/m+KbRcZULIm+10a97B6CtoGKDW7Sj+XWQvJGSMXXgGeV8gqgnA2Q/PJCANIozid9IXz7ElNYCmscoFP0TIM3UR9FZ4dkQWVAizJ4ErKSo3j/OHOqDYIo0zG+sgy+ru3joLxjF8vB9luiWVjGbbsotrqMaUAwN8HQqYetRvfhPgd78HFkkFXkwgU40IIg5MAIUIMqW5amRaWsGaqOuO+Q6/Ik9P097AK0fRa9pTWUh/MlWl6jzFjOEN34w4CM/unpvSkRQpwnP12v6a0hvhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhPGcebyJSH/GZr2ro/YGUfNAMgC6vAPk4iyk1LQuL0=;
 b=f9iEdbNDQHglPxe/s4sMLlZvhLG1VOBZouCFfCRu6z/TbHNro+9yGxMUpNlqXrQ7vHsoohnlDJy/PaYMANaL7miKoIdwrmqmkCPZwE6+VSawnGAac5wJRsJz4D56Dn4MjdOU7YIozuDu9wzf+SiojoE5de8q6oEVjMOQChPJr3s=
Received: from MWHPR18MB1071.namprd18.prod.outlook.com (10.173.123.137) by
 MWHPR18MB1454.namprd18.prod.outlook.com (10.175.7.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 16:14:38 +0000
Received: from MWHPR18MB1071.namprd18.prod.outlook.com
 ([fe80::15d2:5e1b:a2b9:fb56]) by MWHPR18MB1071.namprd18.prod.outlook.com
 ([fe80::15d2:5e1b:a2b9:fb56%10]) with mapi id 15.20.2623.017; Wed, 15 Jan
 2020 16:14:38 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH] qla2xxx: Fix unbound NVME response length
Thread-Topic: [EXT] Re: [PATCH] qla2xxx: Fix unbound NVME response length
Thread-Index: AQHVy025BtyFCkfovE+I/XCzrRSPtafr5oqA//+cBwA=
Date:   Wed, 15 Jan 2020 16:14:38 +0000
Message-ID: <9D53CC32-C90A-4323-AE08-C58BFF0271CB@marvell.com>
References: <20200115024431.5421-1-hmadhani@marvell.com>
 <97b53726-b26f-9074-a41c-eff4a6ec8613@acm.org>
In-Reply-To: <97b53726-b26f-9074-a41c-eff4a6ec8613@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
x-originating-ip: [66.73.206.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2727752-08cb-46e2-97be-08d799d60514
x-ms-traffictypediagnostic: MWHPR18MB1454:
x-microsoft-antispam-prvs: <MWHPR18MB1454C53DC493D1FBE1DE8991D6370@MWHPR18MB1454.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(189003)(199004)(2906002)(6486002)(110136005)(91956017)(76116006)(66556008)(64756008)(66476007)(66446008)(316002)(71200400001)(26005)(66946007)(81166006)(4326008)(6512007)(86362001)(81156014)(6506007)(33656002)(478600001)(186003)(8936002)(36756003)(2616005)(8676002)(5660300002)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR18MB1454;H:MWHPR18MB1071.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qdZUPpriLGHmbWfIvkzVPIZ9LT52mRN+iCZsqCSslMjqWYLaBNnM4AWdU83a96OEDbdRPnePfzf15OEaht5sKqyKyN+9Kauf3Fe1nNd1QFPdfDC3pKqojzfu3SOI4IJXRsMXk8wDkXc30maP6JMnpv1/4WptEm1Exa1u1FJ2CQ7uYagcrLeTBXHCS2AenMUVgcX4BXZGLo4yBRn8nfSKEZZJqTviDA49I4UzvSQBiCPKSjQ3dZlWFgeS2J2DI/GiFhtNIzcASFysr11V1FM2a08EUtaosPUKYZ8m1zPLS9S+sbIxcgs2FzUnTQakVJ4pZz8K+65D6JlzWjscwLNXHb2sSQDY3iRXLOJYDZrs90bL6VRffpQJ/o/L7z/RxaHuVfWVg4AxGs5SpXH5wjWemY+nPNiuzz4LjfKDY2g5nZ9knGUKEZtbRbV9pnaBU4Qg
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E30D04B7ED935545AC139CC236664777@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c2727752-08cb-46e2-97be-08d799d60514
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 16:14:38.0572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MluAJzBXRW6IUuFXn9QhhFaWq3yb+GvoLanrfBA0RTtjWbS0pu4alBsC7KeStgvu2gAy+a14BZdjBnJJbtHeKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1454
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_02:2020-01-15,2020-01-15 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDEvMTUvMjAsIDEwOjEyIEFNLCAiQmFydCBWYW4gQXNzY2hlIiA8YnZhbmFzc2No
ZUBhY20ub3JnPiB3cm90ZToNCg0KICAgIEV4dGVybmFsIEVtYWlsDQogICAgDQogICAgLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KICAgIE9uIDEvMTQvMjAgNjo0NCBQTSwgSGltYW5zaHUgTWFkaGFuaSB3cm90ZToN
CiAgICA+IEZyb206IEFydW4gRWFzaSA8YWVhc2lAbWFydmVsbC5jb20+DQogICAgPiANCiAgICA+
IE9uIGNlcnRhaW4gY2FzZXMgd2hlbiByZXNwb25zZSBsZW5ndGggaXMgbGVzcyB0aGFuIDMyLCBO
Vk1FIHJlc3BvbnNlIGRhdGENCiAgICA+IGlzIHN1cHBsaWVkIGlubGluZSBpbiBJT0NCLiBUaGlz
IGlzIGluZGljYXRlZCBieSBzb21lIGNvbWJpbmF0aW9uIG9mIHN0YXRlDQogICAgPiBmbGFncy4g
VGhlcmUgd2FzIGFuIGluc3RhbmNlIHdoZW4gYSBoaWdoLCBhbmQgaW5jb3JyZWN0LCByZXNwb25z
ZSBsZW5ndGggd2FzDQogICAgPiBpbmRpY2F0ZWQgY2F1c2luZyBkcml2ZXIgdG8gb3ZlcnJ1biBi
dWZmZXJzLiBGaXggdGhpcyBieSBjaGVja2luZyBhbmQNCiAgICA+IGxpbWl0aW5nIHRoZSByZXNw
b25zZSBwYXlsb2FkIGxlbmd0aC4NCiAgICA+IA0KICAgID4gRml4ZXM6IDc0MDFiYzE4ZDFlZTMg
KCJzY3NpOiBxbGEyeHh4OiBBZGQgRkMtTlZNZSBjb21tYW5kIGhhbmRsaW5nIikNCiAgICA+IENj
OiBzdGFibGVAdmdlci5rZXJuZWwuY29tDQogICAgPiBTaWduZWQtb2ZmLWJ5OiBBcnVuIEVhc2kg
PGFlYXNpQG1hcnZlbGwuY29tPg0KICAgID4gU2lnbmVkLW9mZi1ieTogSGltYW5zaHUgTWFkaGFu
aSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQogICAgPiAtLS0NCiAgICA+IEhpIE1hcnRpbiwNCiAg
ICA+IA0KICAgID4gV2UgZGlzY292ZXJlZCBpc3N1ZSB3aXRoIG91ciBuZXdlciBHZW43IGFkYXB0
ZXIgd2hlbiByZXNwb25zZSBsZW5ndGgNCiAgICA+IGhhcHBlbnMgdG8gYmUgbGFyZ2VyIHRoYW4g
MzIgYnl0ZXMsIGNvdWxkIHJlc3VsdCBpbnRvIGNyYXNoLg0KICAgID4gDQogICAgPiBQbGVhc2Ug
YXBwbHkgdGhpcyB0byA1LjUvc2NzaS1maXhlcyBicmFuY2ggYXQgeW91ciBlYXJsaWVzdCBjb252
ZW5pZW5jZS4NCiAgICA+IA0KICAgID4gVGhhbmtzLA0KICAgID4gSGltYW5zaHUNCiAgICA+IC0t
LQ0KICAgID4gICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMgfCA5ICsrKysrKysrKw0K
ICAgID4gICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspDQogICAgPiANCiAgICA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMgYi9kcml2ZXJzL3Njc2kv
cWxhMnh4eC9xbGFfaXNyLmMNCiAgICA+IGluZGV4IGU3YmFkMGJmZmZkYS4uOTBlODE2ZDEzYjBl
IDEwMDY0NA0KICAgID4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jDQogICAg
PiArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMNCiAgICA+IEBAIC0xOTM5LDYg
KzE5MzksMTUgQEAgc3RhdGljIHZvaWQgcWxhMjR4eF9udm1lX2lvY2JfZW50cnkoc2NzaV9xbGFf
aG9zdF90ICp2aGEsIHN0cnVjdCByZXFfcXVlICpyZXEsDQogICAgPiAgIAkJaW5idWYgPSAodWlu
dDMyX3QgKikmc3RzLT5udm1lX2Vyc3BfZGF0YTsNCiAgICA+ICAgCQlvdXRidWYgPSAodWludDMy
X3QgKilmZC0+cnNwYWRkcjsNCiAgICA+ICAgCQlpb2NiLT51Lm52bWUucnNwX3B5bGRfbGVuID0g
bGUxNl90b19jcHUoc3RzLT5udm1lX3JzcF9weWxkX2xlbik7DQogICAgPiArCQlpZiAodW5saWtl
bHkoaW9jYi0+dS5udm1lLnJzcF9weWxkX2xlbiA+IDMyKSkgew0KICAgID4gKwkJCVdBUk5fT05D
RSgxLCAiVW5leHBlY3RlZCByZXNwb25zZSBwYXlsb2FkIGxlbmd0aCAldS5cbiIsDQogICAgPiAr
CQkJCQlpb2NiLT51Lm52bWUucnNwX3B5bGRfbGVuKTsNCiAgICA+ICsJCQlxbF9sb2cocWxfbG9n
X3dhcm4sIGZjcG9ydC0+dmhhLCAweDUxMDAsDQogICAgPiArCQkJCSJVbmV4cGVjdGVkIHJlc3Bv
bnNlIHBheWxvYWQgbGVuZ3RoICV1LlxuIiwNCiAgICA+ICsJCQkJaW9jYi0+dS5udm1lLnJzcF9w
eWxkX2xlbik7DQogICAgPiArCQkJaW9jYi0+dS5udm1lLnJzcF9weWxkX2xlbiA9IDMyOw0KICAg
ID4gKwkJCWxvZ2l0ID0gMTsNCiAgICA+ICsJCX0NCiAgICA+ICAgCQlpdGVyID0gaW9jYi0+dS5u
dm1lLnJzcF9weWxkX2xlbiA+PiAyOw0KICAgID4gICAJCWZvciAoOyBpdGVyOyBpdGVyLS0pDQog
ICAgPiAgIAkJCSpvdXRidWYrKyA9IHN3YWIzMigqaW5idWYrKyk7DQogICAgPiANCiAgICANCiAg
ICBQbGVhc2UgY2hhbmdlIHRoZSBjb25zdGFudCAnMzInIGludG8gc2l6ZW9mKC4uLikgb3IgaW50
byBhIHN5bWJvbGljIG5hbWUuDQogICAgDQpXaWxsIGRvIHRoYXQuIFRoYW5rcy4NCg0KICAgIFRo
YW5rcywNCiAgICANCiAgICBCYXJ0Lg0KICAgIA0KDQo=
