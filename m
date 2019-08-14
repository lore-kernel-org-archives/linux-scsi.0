Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C04C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 14:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE90A2084F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 14:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kARokdPp";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="JWEnLSra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfHNOEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 10:04:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18720 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726865AbfHNOEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 10:04:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7EE4KjK009024;
        Wed, 14 Aug 2019 07:04:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=ETIiCtVaRCHQwP4ajMFgBcjHx7HuaFl/vqQLoAGG+tk=;
 b=kARokdPpvyttd2YgcWInz3H9H3enqKZmqgMKuDly9Os8C7KlLMQ+maVXqv0jqZkaYKss
 vFVkgyQRmKSYzsmBCBWYdWSl4rIsBG+0c2ttpfWpyT2wuz+JTGL5bcudMOtxKONRQxi6
 sorrCJiWKeA3+rHiJyRutednQPi4oNmtFx9q/FRsgFAQhSlrE1qONSBcn5ftA7LEMV87
 RSk7G1CaEJNMz8Ub6Ga7GHF1eCePTEe2CU7nQD4rUdNXy9KMf6yx8N8691bU99lOm2bc
 3s+RWVr42xCb6OKIsQy8ame/ne8ljKXgIM3BAQAklhab+2TtS5kqB4HzHvCYcCZLh4W4 1w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ubfacysyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 07:04:47 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 14 Aug
 2019 07:04:46 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.56) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 14 Aug 2019 07:04:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUW8oAI0SY+j4xJZsL9GIPeWEYSlTdyEYvNpkU21UcDY0K6QSJC4zaR/95RB/nuoYANwscZkEGIX1cRIxxRaBQXfiNtO9P76LUYydj1++1vMIGCWO8NDlOJ7czfG0CNq9Mk5zAt88eJEkmjJH/mcR7yHt3LXfTXshgbcfCQwi5A6bNUh54bWpYeUDbUXagvXqN1AYDGZ1ETSeuoW4fPAldR+umKJYbf4g/o31un8lMYE4r5N+aiZnm+kuGAIrAU2zPimPA9U91BxJa8aHzaTperBh3ZuAGSPfabOV0Zn40c1aZ7eRgH9vNnIj4FgBwiK4tNstQP8j2EBYPFfOowh6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETIiCtVaRCHQwP4ajMFgBcjHx7HuaFl/vqQLoAGG+tk=;
 b=jDOp6Yeda3/b3jmObXRJyB+p9VgpU4j4Ox8NLtikT8kGccY9JcIMcn31rq03pcwvEs3aItE31a9nnobKJMPU41MoIh7APjs/bF/chOYEfuSyhzUWgYmJftF8Sb6dJg/iv0FrxxuTi9qWkKC89GehMXrGvnQzBZPzBrLv1oKET6kDqqo8IeypaKI4eaerQ/EvESL7MJ78cJLPyE9ghvmQX3zc/XaJt7IBN3alHJHsjlGGYej7nPsBmDKa5RvYX/Br3XZ7fV9QSvVpIdQTYJLAwKPto3jROxp4Wh6Li0DAEoinwR8RE8r8bDf17lnq60LNzlCG2RW7CqLVLZPf3XxZ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETIiCtVaRCHQwP4ajMFgBcjHx7HuaFl/vqQLoAGG+tk=;
 b=JWEnLSraXQmT5WVrTAisYVseEkK2ROcJFkPdWBcAmh2jVG65iqvLxaSP6AfXrhIScjhKhTacxK+buQt01LsQM3hQuXQZlmTVsp4vCixX9GJdaLWeU2v2R+5+VWZCq5/Chg3+xLeUPbyyMqDFOEqlyMt8EdZg/4obSmgJyVhD/p8=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2688.namprd18.prod.outlook.com (20.179.83.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.13; Wed, 14 Aug 2019 14:04:40 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a%6]) with mapi id 15.20.2157.021; Wed, 14 Aug 2019
 14:04:40 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bill Kuzeja <William.Kuzeja@stratus.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] qla2xxx: Fix gnl.l memory leak on adapter init failure
Thread-Topic: [PATCH] qla2xxx: Fix gnl.l memory leak on adapter init failure
Thread-Index: AQHVPAhBG5WRUfqF50WX3m82dlmVM6b6hoqA
Date:   Wed, 14 Aug 2019 14:04:40 +0000
Message-ID: <D30D256C-EC3B-4E12-9DBD-89E54A77ECF8@marvell.com>
References: <1563303039-4367-1-git-send-email-William.Kuzeja@stratus.com>
In-Reply-To: <1563303039-4367-1-git-send-email-William.Kuzeja@stratus.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1b.0.190715
x-originating-ip: [2600:1700:211:eb30:5871:9d72:f424:86ba]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 385c58a9-48da-478f-27a0-08d720c05977
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2688;
x-ms-traffictypediagnostic: MN2PR18MB2688:
x-microsoft-antispam-prvs: <MN2PR18MB268887D68405DF8666C065C4D6AD0@MN2PR18MB2688.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(2501003)(66476007)(91956017)(8676002)(76116006)(71190400001)(25786009)(11346002)(5660300002)(446003)(71200400001)(486006)(66556008)(476003)(66446008)(64756008)(66946007)(2616005)(110136005)(2906002)(186003)(102836004)(6506007)(36756003)(6486002)(81166006)(81156014)(229853002)(99286004)(58126008)(46003)(8936002)(76176011)(86362001)(14454004)(316002)(478600001)(53936002)(7736002)(6246003)(14444005)(305945005)(256004)(6436002)(6512007)(6116002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2688;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ho07c4qirF0dWsj9SMH1yk17nDzi/wYHeY+0pz+k0PE29MkbE7e0/kUYfOqRFYalCzeOjJOunxjEVezpSMAFAepNBIt/aeTEWU0zOmg1wqLq/KyRx53DE0mPTL6J1v3IVq0O4EjUiyisumUaWoxJg2+ToADjKpdk7s5eJr7JRkIQw/0ORe69r7XvH6ZbunWfh4Baqgqz9kzeg7IcdApg+rpqSciJb07syQ3OjuomzW98+gcxuJ+Vk4X49lTjJSMeZ4cDgS953XDoK4QClvqLMc5Mk3dbY7jHasBKtsWU5b2fzG+jrlGuijmSTVze8Y6tmnDlVk0wkIUQi/mDXppBvlRezNYluzJoJnCcySEV1DXfN7z1t4us6OxnurBJbUZ58rPu19wIHm6DH2wBamKUAPIBb3Dc+nSaTOWrjC14LQw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C0BAEDCA9B52141ADFA4C2524439BAF@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 385c58a9-48da-478f-27a0-08d720c05977
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 14:04:40.2035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q4CkcRJ6Ksep/5yVZeIhXfRKHPF6Gvl8xRhucX9Op7uwDGEwLJI/ACt4CI8WZ3el0wCEaGYE4XjMrxWoOKb8Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2688
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-14_05:2019-08-14,2019-08-14 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDcvMTYvMTksIDE6NTcgUE0sICJsaW51eC1zY3NpLW93bmVyQHZnZXIua2VybmVs
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
LS0gDQogICAgMS44LjMuMQ0KICAgIA0KTG9va3MgR29vZC4gDQoNCkFja2VkLWJ5OiBIaW1hbnNo
dSBNYWRoYW5pIDxobWFkaGFuaUBtYXJ2ZWxsLmNvbT4NCiAgICANCg0K
