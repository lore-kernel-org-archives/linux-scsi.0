Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B602C4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 16:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05124222C3
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 16:57:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FEG3d8LE";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="KKl4eoB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfIZQ5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 12:57:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37888 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727444AbfIZQ5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Sep 2019 12:57:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8QGt9xc025906;
        Thu, 26 Sep 2019 09:57:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=xQ3rtKKZsvg0H1ohAGm0RKGj3ZYHlpPIv6/forYg9Wc=;
 b=FEG3d8LE4gPuuF5YuyB80GDhHgjaMpivHGA02hZR1oeWBKeIVVcwaCWKEsDa6joRgJAW
 ZAp9DHvZpDEBqCYo8IXrMHSFVjqLGgpjnH88lVSoYuVGUuClATs1klXt+GYFm1dJFFeH
 MeZpBEWNPGG/ecr1BxeRT6tBoxNqh/9MwAVLa5BrqlqcGBtVbrt6KqC8pHLDPNqq8RSL
 7wXi0AVGbi6SBWjWf+xqw2nfIxH/4ie5l/ogZxV1N2HeLeA0BMnoc5AoZ9+rXyuCIR4G
 T+Efyogb2kShQBq2isyoryI8o9xvmCFhrQ9iNWQGy1unAbGyJJ8+gILWI1m4tqw15JmV ww== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2v8vf21ana-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Sep 2019 09:57:00 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 26 Sep
 2019 09:56:58 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 26 Sep 2019 09:56:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iN8mJb1w26a+wXCtga0TYzhjheG50qLmG1E8gNWkeEmnrkp9p957erNnt3G+1bsqUuBJsxjBTyw5FhpZTtKhgW1sj/NsI7FiRqZdWg0bjlWaK/M9mL365cLwtC+RrXnl8WIDtYVEmD7JoJRjFmh7ZQS7YpdC13L+PP2Oy+qX6txcszl4I8AJbHPIQa0idlhWFr34eZLNBpPchBnEThQptlVreoz+zn3NFpgMcVQxAGLPtAo3OuqqFfhEa3PHccgRDdlElwgyMUb/8HmKtPNXgm7H5Jsj+TyxiNaznQBCt98fVMmLUSjp+jUQUqXGYEpbWDWQCr9mBU9hVPEyRRLONg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQ3rtKKZsvg0H1ohAGm0RKGj3ZYHlpPIv6/forYg9Wc=;
 b=RHStIBoMMW81uIBIu5cKWh2x+b0yRZMKrIErQLTPWvudG9CSXf82/gKd5hmAWoThxo1ZDrMoK4+AXQiBFSnO07VDNtgGktPTaPMYMctwlnVtfqldP5DVQO+yHW/KH2qYqnBg961sUu+l8DlIubsCLSfQoeniAbrX20/rN1sTvbb/Ad+UkxOYZYo2aHDtoPpPNxNe99zyz0ac5NYyhYaHP+/rvJmqFt5dMX4zD/6QdzBvmbEvbZ4j+EPvLAgxEnpzMWFOn4fqkyPxyAhzCbjRjxGkh7yMVDYQ+BGDTwmYq5ZNHF3Ya1YSqsZ9YVeTwOsj64HeiH/5NeEbtkJG2It8Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQ3rtKKZsvg0H1ohAGm0RKGj3ZYHlpPIv6/forYg9Wc=;
 b=KKl4eoB3/7NhfX9JWtPBa/zla8oZXLPCSo04s0nMAkov9SAIe72c/gFKhqKo5Q/CY8v8f62UdWvZXkPq6ZWlmoKi3H2uAduDHPOzwZ8aFMZY/1A6q+B/F/nJqf+w7ueIY8yjciEOCmjZ+RfB6/WUZiJ2boAYuHN9d+yhS9FDnEw=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (20.179.58.88) by
 BYAPR18MB2407.namprd18.prod.outlook.com (20.179.91.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.22; Thu, 26 Sep 2019 16:56:57 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::8d62:b220:5ff4:9d4a]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::8d62:b220:5ff4:9d4a%3]) with mapi id 15.20.2284.023; Thu, 26 Sep 2019
 16:56:57 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Martin Wilck <mwilck@suse.de>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v2 04/14] qla2xxx: Optimize NPIV tear down
 process
Thread-Topic: [EXT] Re: [PATCH v2 04/14] qla2xxx: Optimize NPIV tear down
 process
Thread-Index: AQHVaZVC8Tam/RtvOEOitxP7gp+F4qc93bAA///wmwA=
Date:   Thu, 26 Sep 2019 16:56:56 +0000
Message-ID: <CFC8098F-46C2-49E6-9BC3-7E220F6F2535@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
 <20190912180918.6436-5-hmadhani@marvell.com>
 <767fe8f1a50b10d430c30886031251c8f9e4c2dd.camel@suse.de>
In-Reply-To: <767fe8f1a50b10d430c30886031251c8f9e4c2dd.camel@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.186.1.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79f7aeac-176a-4980-04e3-08d742a28a79
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR18MB2407;
x-ms-traffictypediagnostic: BYAPR18MB2407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB24071A9A8E3D055EEABF3888D5860@BYAPR18MB2407.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(189003)(199004)(8936002)(76116006)(25786009)(81166006)(71200400001)(2616005)(476003)(6116002)(3846002)(4326008)(6512007)(33656002)(11346002)(2501003)(7736002)(478600001)(6486002)(110136005)(14444005)(305945005)(446003)(256004)(71190400001)(14454004)(229853002)(2201001)(66066001)(8676002)(66476007)(66446008)(102836004)(64756008)(76176011)(66556008)(2906002)(6506007)(6436002)(316002)(36756003)(6246003)(86362001)(5660300002)(26005)(186003)(486006)(81156014)(66946007)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2407;H:BYAPR18MB2759.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SP+IMkZsV5m6Gl0+YtqBK99Z+91pmnxT5UATNanLmhg2R6cHYpPSnbk9MBPkCogLMUoaSFj0+h1PFgdr/pdi85qEICgrurgFhLtxf5Olg3uEaWwmMhv5ImXaJk9Kg3ctRXELJkIF9tTt+z/q6rTNv+Xe476stu6WrEEnamdNGRstgugXXK9S/0ygOxbGiwzYEo914/kMl9PgVzX9zNARgde2SE9IEbuXzEjLkMRvpyJPjLTXFAhcEknTD8wDJNtsbBqfk/I3cF1IuPDW30i+CkMfF+o543CA9Ky4kgekY2o/0pKXyPglWdMW7YFqUpQCb3J1KnXDf8gLxOeL530g7EhLxycKZ87tBCugagGTNodlsELkfI5CHjBxG11Snbi059sXiz1xFWa0sRkZ+DKpT+TS5nnxoNMbvAM7WfUBfow=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56B307F92D23B04FA0E6E04E624181D8@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f7aeac-176a-4980-04e3-08d742a28a79
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 16:56:56.9467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZv1Xpy3gDYg4McVEl5RABVzP8pOZ4bbsjaMCRGVjcKR6n2dkYHJaGdUdrp83oalkHbAc0JCsmzJM08C128Xvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2407
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-26_07:2019-09-25,2019-09-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQrvu79PbiA5LzI2LzE5LCAzOjUyIEFNLCAiTWFydGluIFdpbGNrIiA8bXdpbGNrQHN1c2UuZGU+
IHdyb3RlOg0KDQogICAgRXh0ZXJuYWwgRW1haWwNCiAgICANCiAgICAtLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQog
ICAgT24gVGh1LCAyMDE5LTA5LTEyIGF0IDExOjA5IC0wNzAwLCBIaW1hbnNodSBNYWRoYW5pIHdy
b3RlOg0KICAgID4gRnJvbTogUXVpbm4gVHJhbiA8cXV0cmFuQG1hcnZlbGwuY29tPg0KICAgID4g
DQogICAgPiBJbiB0aGUgY2FzZSBvZiBOUElWIHBvcnQgaXMgYmVpbmcgdG9ybiBkb3duLCB0aGlz
IHBhdGNoIHdpbGwNCiAgICA+IHNldCBhIGZsYWcgdG8gaW5kaWNhdGUgVlBPUlRfREVMRVRFLiBU
aGlzIHdvdWxkIHByZXZlbnQgcmVsb2dpbg0KICAgID4gdG8gYmUgdHJpZ2dlcmVkLg0KICAgID4g
DQogICAgPiBTaWduZWQtb2ZmLWJ5OiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQog
ICAgPiBTaWduZWQtb2ZmLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxobWFkaGFuaUBtYXJ2ZWxsLmNv
bT4NCiAgICA+IC0tLQ0KICAgID4gIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9hdHRyLmMgICB8
ICAyICsrDQogICAgPiAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2RlZi5oICAgIHwgIDEgKw0K
ICAgID4gIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9ncy5jICAgICB8ICAzICsrLQ0KICAgID4g
IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9taWQuYyAgICB8IDMyICsrKysrKysrKysrKysrKysr
KysrKystLS0tLS0tDQogICAgPiAtLS0NCiAgICA+ICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFf
b3MuYyAgICAgfCAgNyArKysrKystDQogICAgPiAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3Rh
cmdldC5jIHwgIDEgKw0KICAgID4gIDYgZmlsZXMgY2hhbmdlZCwgMzQgaW5zZXJ0aW9ucygrKSwg
MTIgZGVsZXRpb25zKC0pDQogICAgPiANCiAgICA+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9taWQuYw0KICAgID4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21pZC5jDQog
ICAgPiBAQCAtNjYsNiArNjYsNyBAQCBxbGEyNHh4X2RlYWxsb2NhdGVfdnBfaWQoc2NzaV9xbGFf
aG9zdF90ICp2aGEpDQogICAgPiAgCXVpbnQxNl90IHZwX2lkOw0KICAgID4gIAlzdHJ1Y3QgcWxh
X2h3X2RhdGEgKmhhID0gdmhhLT5odzsNCiAgICA+ICAJdW5zaWduZWQgbG9uZyBmbGFncyA9IDA7
DQogICAgPiArCXU4IGk7DQogICAgPiAgDQogICAgPiAgCW11dGV4X2xvY2soJmhhLT52cG9ydF9s
b2NrKTsNCiAgICA+ICAJLyoNCiAgICA+IEBAIC03NSw4ICs3Niw5IEBAIHFsYTI0eHhfZGVhbGxv
Y2F0ZV92cF9pZChzY3NpX3FsYV9ob3N0X3QgKnZoYSkNCiAgICA+ICAJICogZW5zdXJlcyBubyBh
Y3RpdmUgdnBfbGlzdCB0cmF2ZXJzYWwgd2hpbGUgdGhlIHZwb3J0IGlzDQogICAgPiByZW1vdmVk
DQogICAgPiAgCSAqIGZyb20gdGhlIHF1ZXVlKQ0KICAgID4gIAkgKi8NCiAgICA+IC0Jd2FpdF9l
dmVudF90aW1lb3V0KHZoYS0+dnJlZl93YWl0cSwgIWF0b21pY19yZWFkKCZ2aGEtDQogICAgPiA+
dnJlZl9jb3VudCksDQogICAgPiAtCSAgICAxMCpIWik7DQogICAgPiArCWZvciAoaSA9IDA7IGkg
PCAxMCAmJiBhdG9taWNfcmVhZCgmdmhhLT52cmVmX2NvdW50KTsgaSsrKQ0KICAgID4gKwkJd2Fp
dF9ldmVudF90aW1lb3V0KHZoYS0+dnJlZl93YWl0cSwNCiAgICA+ICsJCSAgICBhdG9taWNfcmVh
ZCgmdmhhLT52cmVmX2NvdW50KSwgSFopOw0KICAgIA0KICAgIEFyZSB5b3UgbWlzc2luZyBhIG5l
Z2F0aW9uIGluIHRoaXMgbGFzdCBsaW5lPw0KICAgIEFsc28sIHdoYXQncyB0aGUgcG9pbnQgb2Yg
YWRkaW5nIHRoaXMgbG9vcD8gDQoNClFUOiAgZ29vZCBjYXRjaC4gIFRoZSBpZGVhIGlzIHRvIG5v
dCBzbGVlcCB0aGUgZnVsbCAxMEh6LCBpZiB0aGUgdnJlZl9jb3VudCBhbHJlYWR5IHJlYWNoZXMg
emVybyBvciByZWFjaGVzIHplcm8gdW5kZXIgMTBIei4gIE90aGVyd2lzZSwgbG9vcC93YWl0IGZv
ciAxMEh6LiAgIFdlJ3JlIHRyeWluZyB0byBnZXQgTlBJViB0ZWFyIGRvd24gdG8gZ28gZmFzdGVy
Lg0KICAgIA0KICAgIA0KICAgID4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMN
CiAgICA+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jDQogICAgPiBAQCAtMTEx
NSw5ICsxMTE1LDE0IEBAIHN0YXRpYyBpbmxpbmUgaW50DQogICAgPiB0ZXN0X2ZjcG9ydF9jb3Vu
dChzY3NpX3FsYV9ob3N0X3QgKnZoYSkNCiAgICA+ICB2b2lkDQogICAgPiAgcWxhMngwMF93YWl0
X2Zvcl9zZXNzX2RlbGV0aW9uKHNjc2lfcWxhX2hvc3RfdCAqdmhhKQ0KICAgID4gIHsNCiAgICA+
ICsJdTggaTsNCiAgICA+ICsNCiAgICA+ICAJcWxhMngwMF9tYXJrX2FsbF9kZXZpY2VzX2xvc3Qo
dmhhLCAwKTsNCiAgICA+ICANCiAgICA+IC0Jd2FpdF9ldmVudF90aW1lb3V0KHZoYS0+ZmNwb3J0
X3dhaXRRLCB0ZXN0X2ZjcG9ydF9jb3VudCh2aGEpLA0KICAgID4gMTAqSFopOw0KICAgID4gKwlm
b3IgKGkgPSAwOyBpIDwgMTA7IGkrKykNCiAgICA+ICsJCXdhaXRfZXZlbnRfdGltZW91dCh2aGEt
PmZjcG9ydF93YWl0USwNCiAgICA+IHRlc3RfZmNwb3J0X2NvdW50KHZoYSksDQogICAgPiArCQkg
ICAgSFopOw0KICAgID4gKw0KICAgID4gIAlmbHVzaF93b3JrcXVldWUodmhhLT5ody0+d3EpOw0K
ICAgID4gIH0NCiAgICANCiAgICBQZXJoYXBzIGhlcmUsIHRoZSBsb29wIHNob3VsZCBiZSBleGl0
ZWQgaWYgdGVzdF9mY3BvcnRfY291bnQodmhhKSBnZXRzDQogICAgVFJVRT8gQW5kIGFnYWluLCB3
aHkgaXMgdGhlIGxvb3AgbmVjZXNzYXJ5Pw0KUVQ6ICBZZXMuICAgICBTYW1lIGFuc3dlciBhcyBh
Ym92ZSB3aXRoIHRoZSBsb29waW5nLg0KDQogICAgUmVnYXJkcw0KICAgIE1hcnRpbg0KICAgIA0K
ICAgIA0KICAgIA0KDQo=
