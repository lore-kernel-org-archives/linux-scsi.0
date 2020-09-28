Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E973AC2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 20:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 682AC2072E
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 20:07:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fw4Bjzw2";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="iSYRSbx7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgI1UHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 16:07:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57266 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgI1UHp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Sep 2020 16:07:45 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08SK6CdA013414;
        Mon, 28 Sep 2020 13:07:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=k8xRUxI04RQvw/VrEK5Wy+5ohYcqWDjBRpz0/fGwMfE=;
 b=fw4Bjzw2CepqjYTTU9LNX0q2e8l0aSPRq/DOolIitfsfSKBpPEoIw9iVfvi5V5wY31W+
 grUHUZ8DKqjQgNRuPywCeLXWgr9OocH2c5xUfDdD+r1Q8+/DoUcXFjvGcebXW9DHYJMB
 rUZkmfJBmBf7WMqdhKnxPM+gNSEBFQLB4CDMsWJPMZWQsciwCYIKUHZ+hCx+S4kgTZ2j
 ECepvdG6IeyObVGKHml+7tajL7bMCA3Qt9sx4vQiZTALeZzy58pWu0OjvkNxWFlfEsRk
 OgM7bRStAg8hqs+4XpIHtOuCU1RENhJ84k01hbo+JXJ/hVvzMMrNlG7RFGRnPSBB6NP2 Rg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55p2xfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 13:07:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 28 Sep
 2020 13:07:40 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 28 Sep
 2020 13:07:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 28 Sep 2020 13:07:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CathvEAzU8WVb3qFpgS2uy3tZp/ir9QPwR80UwJTn0j+n+t0+77AZVOkuNCtwXhdnTaG5cGr+jftrfXWM+3W2cAeZryIb8kDalV9u4yGW1SCRFgPOHxsPfLOflNHGNmyZ06jiyKp03NrzZzCb3FFj9b8tiToQevVP3Kd0TdX0z1wHVOtdnTZQrj5Gvva+5vfKCmYI76Vd7+j3dq3APL8uXXxQlmqKXgU64VCHv3emkLKlOMXBsHezLwIN9CwNEC7udqfOuaJCOhCTlaTgWpcKQ+HfrfPu7LILTHWHxxDndr2arrcIwPbKWpM6WSCEfJTO1jgMK7dYf/8/vBDBjElfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8xRUxI04RQvw/VrEK5Wy+5ohYcqWDjBRpz0/fGwMfE=;
 b=Y78Bu8D+uPngavQ2+feE40fH9wZtBnFuWZwuiXK0htGSYT78WBfRnDFSfzT0x0HrzwjscV0tKhcyIT8O5rr+2YHvlImGB+Ja2ulYijaes9WFgXu4fUgmpaH3Q8ilWbUPcCysky7Dj9cUSH2qhlpJS8SUBSXYnHP4FYJD5GPpH8TIIbF1BFw63Hthzy7Zt+wuaSg1I3oDEzufeXYQ28fYYi71wmbx1lQFKScBLEwgEXeKMFNPl8Q3ACMUV/X0HqipqGMzG52Ky/fqGKDYnKdi0UqtrxK7dhd1GLNwM4ikmt5nyngeztpswRbQkoiHUGI0QuWjawCH+2INSPrC0pQn1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8xRUxI04RQvw/VrEK5Wy+5ohYcqWDjBRpz0/fGwMfE=;
 b=iSYRSbx7LKTLClCNckfmfY/e5Tu5o7knOC86UXJN38h5PYL47qSLG+LCYfSUJ/ZwtSb4OEZmoS51kc/+Ki6u0hy4M0sTN3kRmQ7Z6BCL2WlCCkBNuF1B1kCBtmktP5yCvppGbDEMEEOlrVuHXSz2LY4mKLkfAA1ozTagGCdWWjY=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BY5PR18MB3201.namprd18.prod.outlook.com (2603:10b6:a03:196::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Mon, 28 Sep
 2020 20:07:37 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fc12:a6a9:5e02:cfa9]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fc12:a6a9:5e02:cfa9%6]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 20:07:37 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     James Smart <james.smart@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 1/2] scsi: fc: Update statistics for host and rport on
 FPIN reception.
Thread-Topic: [PATCH 1/2] scsi: fc: Update statistics for host and rport on
 FPIN reception.
Thread-Index: AQHWZvHMYsYd/GGqgEmobmWmo+FBnal1q3sAgAi3TAA=
Date:   Mon, 28 Sep 2020 20:07:37 +0000
Message-ID: <1230F28E-B730-4022-B4CA-6A47C49F15FD@marvell.com>
References: <20200730061116.20111-1-njavali@marvell.com>
 <20200730061116.20111-2-njavali@marvell.com>
 <31d735ac-90d6-a601-0d8e-c15739684d23@broadcom.com>
In-Reply-To: <31d735ac-90d6-a601-0d8e-c15739684d23@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.40.20081000
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:21ca:40de:8c16:51c4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb1fd2e9-2379-41eb-7517-08d863ea255f
x-ms-traffictypediagnostic: BY5PR18MB3201:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB32016580139C31E6F041A4E7B4350@BY5PR18MB3201.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SsQellb7vJnPbrZoz6IQNOqeE+poPPYfe4BZP/3noVXYaOOoP+9bYj0oCs34IJrC3jBwjOywEnrTHRvUSln9ah+WkdRU+BlK6covxs7wZaJSjj1ZZdFb8da/MnmemDV/tL3n17v3gSZp4wzxtueJjjTBpC1fhkGh0WxbPq0+0h0G6x+1+qIKJ4VxbptjrCeyD++qulIDwdgMGdEQ+lQAa7JyUXU0ODMAU93IQMqCPlXqUIdzeuitVPFFolC3ceVJi3yFWiWYkfXLfJxRL3syc2Akzu5n0Hnhbeq8nlB6CsqLEHPa8czX4Ux5wz/kjLRNT8OgVYSbZ1rOBWBWbqF6fkvI4keu1Z3jC8cpWwQt40rc4R+r6yRy2OWSihXNKHq8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(5660300002)(66556008)(66476007)(64756008)(66446008)(86362001)(110136005)(2616005)(76116006)(8676002)(8936002)(66946007)(107886003)(33656002)(36756003)(478600001)(186003)(15650500001)(2906002)(71200400001)(54906003)(6506007)(83380400001)(6512007)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QOt74h6u7z1ItJVpQ0X8FXK9Qg/jlO301qzMuomPy+dLotNeKbkFnpVUtHu1GpwPN4Cu6PMa0gr2pJdsFKTCY/MobWIh+vrCWQm8WLcVRezQEAMDjhiKp1Mg6cuYRHsAD5XB647PByHXnw9zoFUrylLb/eXB/+A6hLUoaA/+KsXmv9zVXi0kuYlXLWReNTfFghzMft+++Am0e1L5B+oJLyGT+vAMgj/+LKZBtCn64AWdBJaeznudC5hZISBgAyzL1Nr21+X0zFiathJf1bJeOMavhTZ8gMbhWhQ/l9Gue/fL1XeKyE5eXfZFXFk3smAuAddPlQv9Z2xCtgv0Je9+eqeJrqld79XTR9U4n8ybvR1PnRL2xmn32G47jmQ38S1r5/jm/C1TJtI5k2omMyWMi4wF0MNd8lyjse2+5HwJskx7QNcRZspmReuFYJQTv0W6bCMx2jKk9Zg49UrM1qpzieQ869EN3h665kM4jXsOUU8MTJ2/sddp8C9F22vlCueylNT3CjPhQmhAVxsS4pLqIzJFSFMV/IdpCJjk1nyfear43VcbLHdh7P2lShwbnDbjI0FgA3izmPrU8Siyf8JiiHRqEBvIuL1kpPxCgScj9rY7SaKOn8quKmgOtdJBRCNdOxCTifb4DZ17WkAczK9GOXmWDZW+/kmWiuC4B646AJJEMCXWg3iQ6HRkK4UHDnqeG7dRsdFhofJAd2qv/9hGYQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <87AE03A26D701849ACA53F08CDAFEA34@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2805.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb1fd2e9-2379-41eb-7517-08d863ea255f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 20:07:37.2315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AcD9dWwOlkYYILODrkCdgr1TF+8v+r1D6KvjuVjnggIvxiUSeKKeyYlScbWEdaBoL5yBbhdmy6EwyxIbVmovzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3201
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_22:2020-09-28,2020-09-28 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ICAgID4gKw0KICAgID4gKy8qDQogICAgPiArICogZmNfZnBpbl9saV9zdGF0c191cGRhdGUgLSBy
b3V0aW5lIHRvIHVwZGF0ZSBMaW5rIEludGVncml0eQ0KICAgID4gKyAqIGV2ZW50IHN0YXRpc3Rp
Y3MuDQogICAgPiArICogQHNob3N0OgkJaG9zdCB0aGUgRlBJTiB3YXMgcmVjZWl2ZWQgb24NCiAg
ICA+ICsgKiBAdGx2OgkJcG9pbnRlciB0byBsaW5rIGludGVncml0eSBkZXNjcmlwdG9yDQogICAg
PiArICoNCiAgICA+ICsgKi8NCiAgICA+ICtzdGF0aWMgdm9pZA0KICAgID4gK2ZjX2ZwaW5fbGlf
c3RhdHNfdXBkYXRlKHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LCBzdHJ1Y3QgZmNfdGx2X2Rlc2Mg
KnRsdikNCiAgICA+ICt7DQogICAgPiArCXU4IGk7DQogICAgPiArCXN0cnVjdCBmY19ycG9ydCAq
cnBvcnQgPSBOVUxMOw0KICAgID4gKwlzdHJ1Y3QgZmNfcnBvcnQgKmRldF9ycG9ydCA9IE5VTEws
ICphdHRhY2hfcnBvcnQgPSBOVUxMOw0KICAgID4gKwlzdHJ1Y3QgZmNfaG9zdF9hdHRycyAqZmNf
aG9zdCA9IHNob3N0X3RvX2ZjX2hvc3Qoc2hvc3QpOw0KICAgID4gKwlzdHJ1Y3QgZmNfZm5fbGlf
ZGVzYyAqbGlfZGVzYyA9IChzdHJ1Y3QgZmNfZm5fbGlfZGVzYyAqKXRsdjsNCiAgICA+ICsJdTY0
IHd3cG47DQogICAgPiArDQogICAgPiArCXJwb3J0ID0gZmNfZmluZF9ycG9ydF9ieV93d3BuKHNo
b3N0LA0KICAgID4gKwkJCQkgICAgICBiZTY0X3RvX2NwdShsaV9kZXNjLT5kZXRlY3Rpbmdfd3dw
bikpOw0KICAgID4gKwlpZiAocnBvcnQpIHsNCiAgICA+ICsJCWRldF9ycG9ydCA9IHJwb3J0Ow0K
ICAgID4gKwkJZmNfbGlfc3RhdHNfdXBkYXRlKGxpX2Rlc2MsICZkZXRfcnBvcnQtPnN0YXRzKTsN
Cg0KICAgIHRoaXMgbG9va3Mgb2RkIC0gd2h5IGFyZSB0aGUgc3RhdHMgY291bnRpbmcgYWdhaW5z
dCBib3RoIHRoZSBkZXRlY3RpbmcgDQogICAgYW5kIGF0dGFjaGVkIHBvcnRzIC0gSSB3b3VsZCB0
aGluayBpdCBvbmx5IGNvdW50cyBhZ2FpbnN0IHRoZSAiYXR0YWNoZWQiIA0KICAgIHBvcnQuDQoN
CiAgICBBcyBpdCdzIHRoZSBzYW1lIGNvdW50ZXJzIC0geW91IGxvb3NlIHRoZSBkaXN0aW5jdGlv
biBvZiB3aGF0IGl0IA0KICAgIGRldGVjdGVkIHZzIHdoYXQgaXQgaXMgZ2VuZXJhdGluZy4gIE15
IGd1ZXNzIGlzIG1vc3Qgb2YgdGhlIGRldGVjdGluZyANCiAgICBwb3J0cyB3b3VsZCBoYXZlIGJl
ZW4gYSBzd2l0Y2ggcG9ydCBhbmQgaXQgd291bGRuJ3QgaGF2ZSBiZWVuIGZvdW5kIGJ5IA0KICAg
IHRoZSBycG9ydF9ieV93d3BuLCBzbyB0aGlzIGJsb2NrIHdhc24ndCBnZXR0aW5nIGV4ZWN1dGVk
Lg0KDQpTaHlhbTogSmFtZXMsIHRoZSBpZGVhIGhlcmUgd2FzLCBmb3IgRlBJTnMgZGV0ZWN0ZWQv
aW5pdGlhdGVkIGJ5IHRoZSBmYWJyaWMgd2lsbCBoYXZlIHRoZSBwb3J0IG9mIGludGVyZXN0ICh0
aGlzIEhCQS90YXJnZXQgdGhhdCB0aGUgSEJBIGlzIGNvbm5lY3RlZCB0bykgYXMgdGhlICJhdHRh
Y2hlZCIgcG9ydC4gSG93ZXZlciwgYXMgRlBJTiBjb3VsZCBhbHNvIGJlIGdlbmVyYXRlZCBieSB0
aGUgTnhfUG9ydCwgaWYgaXQgb3JpZ2luYXRlZCB0aGUgRlBJTiBhbmQgdGhlIGZhYnJpYyBoYWQg
YnJvYWRjYXN0ZWQgaXQsIHRoZW4gdGhlIHBlZXIgcG9ydCB3b3VsZCBzaG93IGFzIHRoZSAiZGV0
ZWN0aW5nIiBwb3J0IGluIHRoYXQgY2FzZS4gQWxzbywgSSBhbSBhc3N1bWluZyB0aGF0IHdoaWxl
IGJyb2FkY2FzdGluZywgdGhlIGZhYnJpYyBkb2VzIG5vdCBmb3J3YXJkIGFuIEZQSU4gZ2VuZXJh
dGVkIGJ5IEhCQSBYIGJhY2sgdG8gaXRzZWxmLiBJZiBpdCBkb2VzLCB0aGVuIHdlIG1pZ2h0IGlu
ZGVlZCBkbyBhIGRvdWJsZSBhY2NvdW50aW5nLiBJJ2xsIGNoZWNrIGJhY2sgd2l0aCB0aGUgRmFi
cmljIGZvbGtzIG9uIHRoYXQuDQoNCkZvciBhIGdpdmVuIEZQSU4sIHdlIG9ubHkgZXhwZWN0IG9m
IHRoZXNlIHRvIGJlIHRydWUuDQpJIGFtIG9wZW4gdG8gcmVtb3ZpbmcgdGhlIGFjY291bnRpbmcg
YWdhaW5zdCB0aGUgImRldGVjdGluZyIgcG9ydCBmb3Igbm93LCBnaXZlbiB0aGF0IGN1cnJlbnRs
eSwgdGhlcmUgYXJlIG5vIGtub3duIGltcGxlbWVudGF0aW9ucyB3aGVyZSB0aGUgTl9Qb3J0IGlu
aXRpYXRlcyB0aGUgRlBJTiBFTFMuDQpMZXQgbWUga25vdyB3aGF0IHlvdSB0aGluay4NCg0KICAg
ID4gKwl9DQogICAgPiArDQogICAgPiArCXJwb3J0ID0gZmNfZmluZF9ycG9ydF9ieV93d3BuKHNo
b3N0LA0KICAgID4gKwkJCQkgICAgICBiZTY0X3RvX2NwdShsaV9kZXNjLT5hdHRhY2hlZF93d3Bu
KSk7DQogICAgPiArCWlmIChycG9ydCkgew0KICAgID4gKwkJYXR0YWNoX3Jwb3J0ID0gcnBvcnQ7
DQogICAgPiArCQlmY19saV9zdGF0c191cGRhdGUobGlfZGVzYywgJmF0dGFjaF9ycG9ydC0+c3Rh
dHMpOw0KICAgID4gKwl9DQogICAgPiArDQogICAgPiArCWlmIChiZTMyX3RvX2NwdShsaV9kZXNj
LT5wbmFtZV9jb3VudCkgPiAwKSB7DQogICAgPiArCQlmb3IgKGkgPSAwOw0KICAgID4gKwkJICAg
IGkgPCBiZTMyX3RvX2NwdShsaV9kZXNjLT5wbmFtZV9jb3VudCk7DQogICAgPiArCQkgICAgaSsr
KSB7DQogICAgPiArCQkJd3dwbiA9IGJlNjRfdG9fY3B1KGxpX2Rlc2MtPnBuYW1lX2xpc3RbaV0p
Ow0KICAgID4gKwkJCXJwb3J0ID0gZmNfZmluZF9ycG9ydF9ieV93d3BuKHNob3N0LCB3d3BuKTsN
CiAgICA+ICsJCQlpZiAocnBvcnQgJiYgcnBvcnQgIT0gZGV0X3Jwb3J0ICYmDQogICAgPiArCQkJ
ICAgIHJwb3J0ICE9IGF0dGFjaF9ycG9ydCkgew0KICAgID4gKwkJCQlmY19saV9zdGF0c191cGRh
dGUobGlfZGVzYywgJnJwb3J0LT5zdGF0cyk7DQoNCiAgICBJIGd1ZXNzIHRoaXMgaXMgb2sgLSBi
dXQgaXQgbWFrZXMgaXQgaGFyZCBmb3IgYWRtaW5pc3RyYXRvcnMuICBJIGJlbGlldmUgDQogICAg
dGhpcyBpcyB0aGUgbGlzdCBvZiB0aGUgb3RoZXIgbnBvcnRzIChha2EgbnBpdikgb24gdGhlICJh
dHRhY2hlZCBwb3J0IiANCiAgICB0aGF0IGlzIGdlbmVyYXRpbmcgdGhlIGVycm9yLiAgSW4gdGhh
dCByZXNwZWN0LCBpdCBpcyBjb3JyZWN0IHRvIA0KICAgIGluY3JlbWVudCB0aGVpciBjb3VudGVy
cyAtIGJ1dCBJIGhvcGUgdGhhdCBhbiBhZG1pbmlzdHJhdG9yIGtub3dzIHRoYXQgDQogICAgbWF5
IHJlc29sdmUgdG8gYSBzaW5nbGUgcGh5c2ljYWwgcG9ydCB3aXRoIG9ubHkgMS9OIHRoZSBlcnJv
ciBjb3VudC4gIA0KICAgICBGcm9tIG91ciB1c2UgY2FzZSBpbiBsaW51eCwgYXMgYW4gaW5pdGlh
dG9yLCB0byBtYXRjaCBhbiBycG9ydCBpdCBtdXN0IA0KICAgIGJlIGEgdGFyZ2V0IHBvcnQgdXNp
bmcgbnBpdiBhbmQgZnJvbSBvdXIgcG9pbnQgb2YgdmlldyB3ZSBkb24ndCBrbm93IA0KICAgIHRo
YXQgdGhleSBhcmUgYWxsIHNoYXJpbmcgdGhlIHNhbWUgcGh5c2ljYWwgcG9ydC4NCg0KU2h5YW06
IEkgYWdyZWUuIEJ1dCB3aXRoIHRoZSBpbmZvcm1hdGlvbiBpbiBoYW5kLCBJIGFtIG5vdCBzdXJl
IGhvdyB3ZSBjb3VsZCBkbyB0aGlzIGJldHRlciBhdCB0aGlzIHBvaW50LiANCg0KICAgID4gKwkJ
CX0NCiAgICA+ICsJCX0NCiAgICA+ICsJfQ0KICAgID4gK30NCiAgICA+ICsNCiAgICA+ICsvKg0K
ICAgID4gKyAqIGZjX2ZwaW5fY29uZ25fc3RhdHNfdXBkYXRlIC0gcm91dGluZSB0byB1cGRhdGUg
Q29uZ2VzdGlvbg0KICAgID4gKyAqIGV2ZW50IHN0YXRpc3RpY3MuDQogICAgPiArICogQHNob3N0
OgkJaG9zdCB0aGUgRlBJTiB3YXMgcmVjZWl2ZWQgb24NCiAgICA+ICsgKiBAdGx2OgkJcG9pbnRl
ciB0byBjb25nZXN0aW9uIGRlc2NyaXB0b3INCiAgICA+ICsgKg0KICAgID4gKyAqLw0KICAgID4g
K3N0YXRpYyB2b2lkDQogICAgPiArZmNfZnBpbl9jb25nbl9zdGF0c191cGRhdGUoc3RydWN0IFNj
c2lfSG9zdCAqc2hvc3QsDQogICAgPiArCQkJICAgc3RydWN0IGZjX3Rsdl9kZXNjICp0bHYpDQog
ICAgPiArew0KICAgID4gKwlzdHJ1Y3QgZmNfaG9zdF9hdHRycyAqZmNfaG9zdCA9IHNob3N0X3Rv
X2ZjX2hvc3Qoc2hvc3QpOw0KICAgID4gKwlzdHJ1Y3QgZmNfZm5fY29uZ25fZGVzYyAqY29uZ24g
PSAoc3RydWN0IGZjX2ZuX2NvbmduX2Rlc2MgKil0bHY7DQogICAgPiArDQogICAgPiArCWZjX2Nu
X3N0YXRzX3VwZGF0ZShiZTE2X3RvX2NwdShjb25nbi0+ZXZlbnRfdHlwZSksICZmY19ob3N0LT5z
dGF0cyk7DQogICAgPiArfQ0KICAgID4gKw0KICAgID4gICAvKioNCiAgICA+ICAgICogZmNfaG9z
dF9yY3ZfZnBpbiAtIHJvdXRpbmUgdG8gcHJvY2VzcyBhIHJlY2VpdmVkIEZQSU4uDQogICAgPiAg
ICAqIEBzaG9zdDoJCWhvc3QgdGhlIEZQSU4gd2FzIHJlY2VpdmVkIG9uDQogICAgPiBAQCAtNjM5
LDggKzkwNSw0MSBAQCBFWFBPUlRfU1lNQk9MKGZjX2hvc3RfcG9zdF92ZW5kb3JfZXZlbnQpOw0K
ICAgID4gICB2b2lkDQogICAgPiAgIGZjX2hvc3RfZnBpbl9yY3Yoc3RydWN0IFNjc2lfSG9zdCAq
c2hvc3QsIHUzMiBmcGluX2xlbiwgY2hhciAqZnBpbl9idWYpDQogICAgPiAgIHsNCiAgICA+ICsJ
c3RydWN0IGZjX2Vsc19mcGluICpmcGluID0gKHN0cnVjdCBmY19lbHNfZnBpbiAqKWZwaW5fYnVm
Ow0KICAgID4gKwlzdHJ1Y3QgZmNfdGx2X2Rlc2MgKnRsdjsNCiAgICA+ICsJdTMyIGRlc2NfY250
ID0gMCwgYnl0ZXNfcmVtYWluOw0KICAgID4gKwl1MzIgZHRhZzsNCiAgICA+ICsNCiAgICA+ICsJ
LyogVXBkYXRlIFN0YXRpc3RpY3MgKi8NCiAgICA+ICsJdGx2ID0gKHN0cnVjdCBmY190bHZfZGVz
YyAqKSZmcGluLT5mcGluX2Rlc2NbMF07DQogICAgPiArCWJ5dGVzX3JlbWFpbiA9IGZwaW5fbGVu
IC0gb2Zmc2V0b2Yoc3RydWN0IGZjX2Vsc19mcGluLCBmcGluX2Rlc2MpOw0KICAgID4gKwlieXRl
c19yZW1haW4gPSBtaW5fdCh1MzIsIGJ5dGVzX3JlbWFpbiwgYmUzMl90b19jcHUoZnBpbi0+ZGVz
Y19sZW4pKTsNCiAgICA+ICsNCiAgICA+ICsJd2hpbGUgKGJ5dGVzX3JlbWFpbiA+PSBGQ19UTFZf
REVTQ19IRFJfU1ogJiYNCiAgICA+ICsJICAgICAgIGJ5dGVzX3JlbWFpbiA+PSBGQ19UTFZfREVT
Q19TWl9GUk9NX0xFTkdUSCh0bHYpKSB7DQogICAgPiArCQlkdGFnID0gYmUzMl90b19jcHUodGx2
LT5kZXNjX3RhZyk7DQogICAgPiArCQlzd2l0Y2ggKGR0YWcpIHsNCiAgICA+ICsJCWNhc2UgRUxT
X0RUQUdfTE5LX0lOVEVHUklUWToNCiAgICA+ICsJCQlmY19mcGluX2xpX3N0YXRzX3VwZGF0ZShz
aG9zdCwgdGx2KTsNCiAgICA+ICsJCQlicmVhazsNCiAgICA+ICsJCWNhc2UgRUxTX0RUQUdfREVM
SVZFUlk6DQogICAgPiArCQkJZmNfZnBpbl9kZWxpX3N0YXRzX3VwZGF0ZShzaG9zdCwgdGx2KTsN
CiAgICA+ICsJCQlicmVhazsNCiAgICA+ICsJCWNhc2UgRUxTX0RUQUdfUEVFUl9DT05HRVNUOg0K
ICAgID4gKwkJCWZjX2ZwaW5fcGVlcl9jb25nbl9zdGF0c191cGRhdGUoc2hvc3QsIHRsdik7DQog
ICAgPiArCQkJYnJlYWs7DQogICAgPiArCQljYXNlIEVMU19EVEFHX0NPTkdFU1RJT046DQogICAg
PiArCQkJZmNfZnBpbl9jb25nbl9zdGF0c191cGRhdGUoc2hvc3QsIHRsdik7DQogICAgPiArCQl9
DQogICAgPiArDQogICAgPiArCQlkZXNjX2NudCsrOw0KICAgID4gKwkJYnl0ZXNfcmVtYWluIC09
IEZDX1RMVl9ERVNDX1NaX0ZST01fTEVOR1RIKHRsdik7DQogICAgPiArCQl0bHYgPSBmY190bHZf
bmV4dF9kZXNjKHRsdik7DQogICAgPiArCX0NCiAgICA+ICsNCiAgICA+ICAgCWZjX2hvc3RfcG9z
dF9mY19ldmVudChzaG9zdCwgZmNfZ2V0X2V2ZW50X251bWJlcigpLA0KICAgID4gLQkJCQlGQ0hf
RVZUX0xJTktfRlBJTiwgZnBpbl9sZW4sIGZwaW5fYnVmLCAwKTsNCiAgICA+ICsJCQkgICAgICBG
Q0hfRVZUX0xJTktfRlBJTiwgZnBpbl9sZW4sIGZwaW5fYnVmLCAwKTsNCiAgICA+ICsNCiAgICA+
ICAgfQ0KICAgID4gICBFWFBPUlRfU1lNQk9MKGZjX2hvc3RfZnBpbl9yY3YpOw0KDQogICAgUXVl
c3Rpb246IEkga25vdyB3ZSd2ZSBiZWVuIGFza2VkIHRvIGxvZyB0aGUgZnBpbnMgdG8gdGhlIGtl
cm5lbCBsb2cuICANCiAgICBIb2xkaW5nIG9uIHRvIHRoZSBjb3VudHMgYW5kIHNvIGlzIGdvb2Qs
IGJ1dCBpdCBzdGlsbCBsb3NlcyBzb21lIG9mIHRoZSANCiAgICByZWxhdGlvbnNoaXAgb2YgdGhl
IGRldGVjdGVkIHBvcnQgKHdoYXQgZGV0ZWN0ZWQgd2hhdCBhdHRhY2hlZCBwb3J0KS4gIA0KICAg
IFdoYXQncyB5b3VyIHRoaW5raW5nIG9uIGl0LiBTaG91bGQgaXQgYmUgc29tZXRoaW5nIGluIHRo
ZXNlIGNvbW1vbiANCiAgICByb3V0aW5lcyBhbmQgZW5hYmxlZC9kaXNhYmxlZCBieSBhIHN5c2Zz
IHRvZ2dsZSA/DQoNClNoeWFtOiBTbyBmYXIsIEkgaGF2ZSBiZWVuIGxvb2tpbmcgYXQgaXQgZnJv
bSB0aGUgcG9pbnQgb2YgZ2F0aGVyaW5nIGFuZCBtYWludGFpbiB0aGUgZXJyb3Igc3RhdHMsIGNs
b3Nlc3QgdG8gdGhlIHNvdXJjZSBvZiB0aGVpciBvcmlnaW4uDQpTbyBpcnJlc3BlY3RpdmUgb2Yg
aWYgYW4gZXJyb3Igd2FzICJkZXRlY3RlZCIgYnkgdGhlIE54X1BvcnQgaXRzZWxmLCBvciBieSB0
aGUgRl9Qb3J0IGF0dGFjaGVkIHRvIGl0LCB3ZSBhcmUgcG9pbnRpbmcgdGhlIGFkbWluaXN0cmF0
b3IgdG93YXJkcyB0aGUgTnhfUG9ydCAoYnkgYWNjb3VudGluZyBmb3IgdGhlIGVycm9yIGFuZCB0
eWluZyBpdCB0byB0aGF0IHBvcnQpLg0KDQpIYXZpbmcgc2FpZCB0aGF0LCBJIGRvIG5vdCB0aGlu
ayBJIGNvbXBsZXRlbHkgZ3Jhc3AgdGhlIGVzc2VuY2Ugb2YgeW91ciBxdWVzdGlvbiBoZXJlLCBh
bmQgeW91ciBwcm9wb3NhbCBvZiB0dXJuaW5nIGl0IG9uL29mZi4gQ291bGQgeW91IHBsZWFzZSBl
bGFib3JhdGUuDQoNCkFsbCB0aGUgb3RoZXIgY29tbWVudHMgbWFrZSBzZW5zZSB0byBtZS4gSSds
bCByb2xsIHRoZW0gaW4gYW5kIHNlbmQgb3V0IGFub3RoZXIgcGF0Y2hzZXQgc2hvcnRseS4NCg0K
UmVnYXJkcw0KU2h5YW0NCg0KDQo=
