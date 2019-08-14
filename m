Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE56C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 17:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A046120679
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 17:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ekik86h2";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="KAqPpZHG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfHNRhs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 13:37:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33194 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728128AbfHNRhs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 13:37:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7EGt5Y7014545;
        Wed, 14 Aug 2019 10:37:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=yLCHoJG+qOy1HmLLl7eSsvFiyBmMyfLMYONf2PfYs/Q=;
 b=ekik86h2+nRgCdv9pCkV45QH2jpKyxKxGNznE4LH17DoaViIc1Hd8AKwnxDoR1YJDDtf
 5H7UTYSPD0w59Fgy4BNuzR0kr+ojh6+4hlg2lZ41g3+yuE9y2rhXOy9MyIVWZKcBfkU4
 Je6i905/70YpxBsq4wVQO6/PfK2p+VzRALX5DVkAOIOEHoj85vhMusS2eTSuxtjmv/xu
 SOJywOo4diZlph/NdTmgjeL5W+Bl+3V6EApEuAjRxI7uRoYnM3nETSaZaX4bpwnm/AS2
 W4wgKdscPRdn0kVRCe115ldjs8kP4xWGeV3wsovQOG67O2xQ1sws+0+tELVfmO9bYFIv EA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ubfad0nk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 10:37:44 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 14 Aug
 2019 10:37:43 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.58) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 14 Aug 2019 10:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2yg00UFoxc76zXcXC6L9+FPhEPb1ox4jn0714ZEsYywHttwhvl5aRm5Gavh04A/BfIxvmGqV6D2H38mhTenmjPXgkhBf6EWYPPyt1R5BSHgK4jywE6Ez+rVLsQqoViEM1/UNFWcQdfB2XZ22SaFpdinjDl0gWPhNEurLIlDe6odH2G+ioN7th7MvLEY5GrBAIWTR4Qywo1dbqyIjY8GRQFvYMH4Sj6eFXhrVBbpZ0Q2w41KWnUmcz0rq0L22Mp4TXp3Xk+yPApED65lHIKFXIYAJXZrcYvqG6hpLx9YxMyRGO1F9hHC4F4ISWk6JloEZw09JLxowiOP+0Pey8JhWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLCHoJG+qOy1HmLLl7eSsvFiyBmMyfLMYONf2PfYs/Q=;
 b=Iejz+7KH7mpbAqI8F7/JQWPTNnlJ5Dp8LLKOPVX7KUZpIo1JIcwYozdoEa2+n/l/9Yv0i/QkHTBeSn9nvk5kfg3vCzruUNT21I0S3kIH6YZRmwn/h2WPsCWKYDn8Yz42BShBcou8UorVYBsnbgbpd8V6N/a1m7FMdnKovwrTySFvGWunOXEPEWbsEB2xUanwndO4ZWrnvAf+JxVDLd89pHToYRqFBYH7BkBH6+oX0WeL5cvM6aazio5tW+KrbydgaDCCbPJaL6EsFsJIOMS6iPpEdIVG/fQPL/hoAFKDPL16P2ixnn9RB4jnvoKYdKPNPT3Zn09BDQAme1QCBTPkPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLCHoJG+qOy1HmLLl7eSsvFiyBmMyfLMYONf2PfYs/Q=;
 b=KAqPpZHGV/pDZlWD8Opgz4xL/ELCGkvZQQJ6yFKs9wmCrFpV2EHQjbEwWMHkpHR/wXUsRDuhIzBJlHqO2HZPfDy9EAo8fkFBnckYZki+UadLaKvRQqVQyq5KO+Gp9O7U9C8bhxCRHgdTkimVAtP+SNadRgYpca0LgUlmq5ucWQU=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3359.namprd18.prod.outlook.com (10.255.238.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Wed, 14 Aug 2019 17:37:42 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a%6]) with mapi id 15.20.2157.021; Wed, 14 Aug 2019
 17:37:42 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bill Kuzeja <William.Kuzeja@stratus.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>
Subject: Re: [PATCH RESEND] qla2xxx: Fix gnl.l memory leak on adapter init
 failure
Thread-Topic: [PATCH RESEND] qla2xxx: Fix gnl.l memory leak on adapter init
 failure
Thread-Index: AQHVUqwu0P8klvCQ90Sc+sGzyO8AUKb6lMeA
Date:   Wed, 14 Aug 2019 17:37:41 +0000
Message-ID: <0C4501DB-B2B6-45B0-9282-9D6C55DADBC0@marvell.com>
References: <1565792681-9641-1-git-send-email-William.Kuzeja@stratus.com>
In-Reply-To: <1565792681-9641-1-git-send-email-William.Kuzeja@stratus.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1b.0.190715
x-originating-ip: [2600:1700:211:eb30:5871:9d72:f424:86ba]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33e237dc-8bc8-4ecd-382e-08d720de1bf6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB3359;
x-ms-traffictypediagnostic: MN2PR18MB3359:
x-microsoft-antispam-prvs: <MN2PR18MB335984423665B69CF06A8753D6AD0@MN2PR18MB3359.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(199004)(189003)(64756008)(6116002)(186003)(7736002)(8676002)(229853002)(305945005)(5660300002)(71190400001)(36756003)(71200400001)(6246003)(99286004)(25786009)(316002)(6512007)(102836004)(58126008)(478600001)(110136005)(6486002)(6436002)(53936002)(4326008)(86362001)(6506007)(81166006)(8936002)(76176011)(486006)(66446008)(91956017)(446003)(11346002)(46003)(2906002)(476003)(76116006)(2616005)(14444005)(66946007)(2501003)(256004)(33656002)(14454004)(66556008)(81156014)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3359;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1ixWb6262h+NHzUk3IQDnZgEo0Ara4RNiTBH6LSiSCfUNB1VqUyu8aMaYUMBrKqeybCsPU8kzCX77Y7gF2XsQAVQXXX6h8EV2+1sQjItiu00M5UrfKcEAXQgHnKmPBBAOy/xoLCd+6yhPmyVF3+uL5xIbdNCQPquQ/0f4ZQ0mhWkygP9f0/aHPnO5oiyUfi9spESR6LwJWcAW5iqIq+x/d+Rnn1KhE8/pmqpViI/ZO088cSHiaNGv1Nnae7/X1lYzQ8LdGV7W18jU68CQuzxakZk6t0XBgyyAwm7gHzkpXm/eP94S4BfDW+jOOj+WLKRly1i0tnbx/db5jVtSDwqMbqp1tFb3odnHQhNIBeNIzvdPNAJWi+yyX8vLjtggA5n76tn4fMfVjeaRlMMlOaFOBnKJ2qJX8CH11XN3T3LCpk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1B40861C86D5D4D885DC15AB5486305@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e237dc-8bc8-4ecd-382e-08d720de1bf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 17:37:41.9284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u5qrUVttHZ5ue21Foc4dVbkoKKO4kKvtnxDWpJGx7ZPBMMlN+pXGQqSHBggdnW376JDCifCiGcsv3mCZyfkvhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3359
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-14_06:2019-08-14,2019-08-14 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDgvMTQvMTksIDk6MjUgQU0sICJsaW51eC1zY3NpLW93bmVyQHZnZXIua2VybmVs
Lm9yZyBvbiBiZWhhbGYgb2YgQmlsbCBLdXplamEiIDxsaW51eC1zY3NpLW93bmVyQHZnZXIua2Vy
bmVsLm9yZyBvbiBiZWhhbGYgb2YgV2lsbGlhbS5LdXplamFAc3RyYXR1cy5jb20+IHdyb3RlOg0K
DQogICAgSWYgSEJBIGluaXRpYWxpemF0aW9uIGZhaWxzIHVuZXhwZWN0ZWRseSAoZXhpdGluZyB2
aWEgcHJvYmVfZmFpbGVkOiksIHdlIA0KICAgIG1heSBmYWlsIHRvIGZyZWUgdmhhLT5nbmwubC4g
U28gdGhhdCB3ZSBkb24ndCBhdHRlbXB0IHRvIGRvdWJsZSBmcmVlLA0KICAgIHNldCB0aGlzIHBv
aW50ZXIgdG8gTlVMTCBhZnRlciBhIGZyZWUgYW5kIGNoZWNrIGZvciBOVUxMIGF0IHByb2JlX2Zh
aWxlZDoNCiAgICBzbyB3ZSBrbm93IHdoZXRoZXIgb3Igbm90IHRvIGNhbGwgZG1hX2ZyZWVfY29o
ZXJlbnQuIA0KICAgIA0KICAgIFNpZ25lZC1vZmYtYnk6IEJpbGwgS3V6ZWphIDx3aWxsaWFtLmt1
emVqYUBzdHJhdHVzLmNvbT4NCiAgICAtLS0NCiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2F0dHIuYyB8ICAyICsrDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jICAgfCAx
MSArKysrKysrKysrLQ0KICAgICAyIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCiAgICANCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2F0dHIuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9hdHRyLmMNCiAgICBpbmRleCA4
ZDU2MGM1Li42YjdiMzkwIDEwMDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3Fs
YV9hdHRyLmMNCiAgICArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfYXR0ci5jDQogICAg
QEAgLTI5NTYsNiArMjk1Niw4IEBAIHZvaWQgcWxhX2luc2VydF90Z3RfYXR0cnModm9pZCkNCiAg
ICAgCWRtYV9mcmVlX2NvaGVyZW50KCZoYS0+cGRldi0+ZGV2LCB2aGEtPmdubC5zaXplLCB2aGEt
PmdubC5sLA0KICAgICAJICAgIHZoYS0+Z25sLmxkbWEpOw0KICAgICANCiAgICArCXZoYS0+Z25s
LmwgPSBOVUxMOw0KICAgICsNCiAgICAgCXZmcmVlKHZoYS0+c2Nhbi5sKTsNCiAgICAgDQogICAg
IAlpZiAodmhhLT5xcGFpciAmJiB2aGEtPnFwYWlyLT52cF9pZHggPT0gdmhhLT52cF9pZHgpIHsN
CiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMgYi9kcml2ZXJz
L3Njc2kvcWxhMnh4eC9xbGFfb3MuYw0KICAgIGluZGV4IDJlNThjZmYuLjk4ZTYwYTMgMTAwNjQ0
DQogICAgLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMNCiAgICArKysgYi9kcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYw0KICAgIEBAIC0zNDQwLDYgKzM0NDAsMTIgQEAgc3Rh
dGljIHZvaWQgcWxhMngwMF9pb2NiX3dvcmtfZm4oc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0K
ICAgICAJcmV0dXJuIDA7DQogICAgIA0KICAgICBwcm9iZV9mYWlsZWQ6DQogICAgKwlpZiAoYmFz
ZV92aGEtPmdubC5sKSB7DQogICAgKwkJZG1hX2ZyZWVfY29oZXJlbnQoJmhhLT5wZGV2LT5kZXYs
IGJhc2VfdmhhLT5nbmwuc2l6ZSwNCiAgICArCQkJCWJhc2VfdmhhLT5nbmwubCwgYmFzZV92aGEt
PmdubC5sZG1hKTsNCiAgICArCQliYXNlX3ZoYS0+Z25sLmwgPSBOVUxMOw0KICAgICsJfQ0KICAg
ICsNCiAgICAgCWlmIChiYXNlX3ZoYS0+dGltZXJfYWN0aXZlKQ0KICAgICAJCXFsYTJ4MDBfc3Rv
cF90aW1lcihiYXNlX3ZoYSk7DQogICAgIAliYXNlX3ZoYS0+ZmxhZ3Mub25saW5lID0gMDsNCiAg
ICBAQCAtMzY3Myw3ICszNjc5LDcgQEAgc3RhdGljIHZvaWQgcWxhMngwMF9pb2NiX3dvcmtfZm4o
c3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KICAgICAJaWYgKCFhdG9taWNfcmVhZCgmcGRldi0+
ZW5hYmxlX2NudCkpIHsNCiAgICAgCQlkbWFfZnJlZV9jb2hlcmVudCgmaGEtPnBkZXYtPmRldiwg
YmFzZV92aGEtPmdubC5zaXplLA0KICAgICAJCSAgICBiYXNlX3ZoYS0+Z25sLmwsIGJhc2Vfdmhh
LT5nbmwubGRtYSk7DQogICAgLQ0KICAgICsJCWJhc2VfdmhhLT5nbmwubCA9IE5VTEw7DQogICAg
IAkJc2NzaV9ob3N0X3B1dChiYXNlX3ZoYS0+aG9zdCk7DQogICAgIAkJa2ZyZWUoaGEpOw0KICAg
ICAJCXBjaV9zZXRfZHJ2ZGF0YShwZGV2LCBOVUxMKTsNCiAgICBAQCAtMzcxMyw2ICszNzE5LDgg
QEAgc3RhdGljIHZvaWQgcWxhMngwMF9pb2NiX3dvcmtfZm4oc3RydWN0IHdvcmtfc3RydWN0ICp3
b3JrKQ0KICAgICAJZG1hX2ZyZWVfY29oZXJlbnQoJmhhLT5wZGV2LT5kZXYsDQogICAgIAkJYmFz
ZV92aGEtPmdubC5zaXplLCBiYXNlX3ZoYS0+Z25sLmwsIGJhc2VfdmhhLT5nbmwubGRtYSk7DQog
ICAgIA0KICAgICsJYmFzZV92aGEtPmdubC5sID0gTlVMTDsNCiAgICArDQogICAgIAl2ZnJlZShi
YXNlX3ZoYS0+c2Nhbi5sKTsNCiAgICAgDQogICAgIAlpZiAoSVNfUUxBRlgwMChoYSkpDQogICAg
QEAgLTQ4MTYsNiArNDgyNCw3IEBAIHN0cnVjdCBzY3NpX3FsYV9ob3N0ICpxbGEyeDAwX2NyZWF0
ZV9ob3N0KHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgKnNodCwNCiAgICAgCQkgICAgIkFsbG9j
IGZhaWxlZCBmb3Igc2NhbiBkYXRhYmFzZS5cbiIpOw0KICAgICAJCWRtYV9mcmVlX2NvaGVyZW50
KCZoYS0+cGRldi0+ZGV2LCB2aGEtPmdubC5zaXplLA0KICAgICAJCSAgICB2aGEtPmdubC5sLCB2
aGEtPmdubC5sZG1hKTsNCiAgICArCQl2aGEtPmdubC5sID0gTlVMTDsNCiAgICAgCQlzY3NpX3Jl
bW92ZV9ob3N0KHZoYS0+aG9zdCk7DQogICAgIAkJcmV0dXJuIE5VTEw7DQogICAgIAl9DQogICAg
LS0gDQogICAgMS44LjMuMQ0KDQpUaGFua3MgZm9yIHJlc2VuZCBCaWxsDQogICAgDQpQYXRjaCBM
b29rcyBHb29kLiANCg0KQWNrZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhtYWRoYW5pQG1hcnZl
bGwuY29tPg0KDQoNCg0K
