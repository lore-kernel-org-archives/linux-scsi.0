Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28655C4346E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 18:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD5D82084C
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 18:27:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="h2w0SUn3";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Z0CQm+WP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgIUS1k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 14:27:40 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47930 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726456AbgIUS1k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Sep 2020 14:27:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08LHU9o1021112;
        Mon, 21 Sep 2020 10:30:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=O+WCJK3xquZ+727StjL8AU521Zuk7GVz/e1Trr1nGjQ=;
 b=h2w0SUn3nD2TA8kIOVraYgCJQg5K9CADlGH7pME+2UfXA4x5zU7l2gWjZlvTe/dGosVk
 tu0j1UZVtjd+UkYMU8yv0O5U6GhO1zE3p2jKlKlKRM6lZ9a3iZwPcCWBA9B+bq20+4n5
 bL1QCwgDwYIrYFFfT4z5NpQwWcHeEw5JIcLyIi5fbmLBU35zYXZE4NbfIJyXYTSKRMbk
 Ci1Ynfs341jTAqO5v8YnGCEH3ShiMyNnZ6pEmY5VylyR6h7sfU4+h7YBO4jfSQOaHS//
 S2BuGIO+3xXu13sbEbe+AKSW6d9I2hCjR7Cnq/+qCJTgOqhBB6yBd9fsYK0YPFaqBZmi HQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33nhgn6p5c-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 10:30:16 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Sep
 2020 10:30:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 21 Sep 2020 10:30:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVUMEYVN6J3tCzEpJTm5d5vP+O4WwO20W42A66TMQBkGXTSCVAzMv9sPzCcPiiueqB8Nao4taV67bWhdf/ammUUxNBY2UBte9vW2BlTwDPtqzPluW7dNcdmKGRzg5uruY1V9NKxU5Rqo7T8AkJ3OeUbNO3uBahOlt0Vwo9v+86/xVDs2wLdaK1z8S9QmDh3fy3+7IhH7jDnRaUxCi+msrlAVsl2GmVbLx2B+l81VWqKV17ATpqY9FSAspZw+0J0trk8OB1WQUxL9msb6ZbfUD/oNRjtfL/4zGY9PNFS2VAYhFe5QOE3wkD5UsQ5BatqAqxBDSWlOWeRY/uZrH2uCnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+WCJK3xquZ+727StjL8AU521Zuk7GVz/e1Trr1nGjQ=;
 b=kAoD05fLrrm2+JuJSdEUbwdEy+nXwuw3IRK9Lgij6fYxg5Q6km9eKnPchw5sNV6DUx80Cf7n9xzGarwr6VbmIeIvkh/kBb70sCkBjGFj634hNM3gNW8d5EsZ0DhkDkpE0MSg8iLPdqOlV37cThE3kQHZdZEcYaSfs+CIfHLHVTwg+A89NOpQGY38ohbASYDUUJQAfd1iqOKUO64ucI35ZwUZktKChz3CyNDN6t8gAf5MG0mRlNr6HllTqjHNqyHTAmY1slI5WLqAP2nzYiHI19ogjZXa7OjEet6EOGYgaaP/NiMMO4xmHpDmiCkwJWhNSYyXdfqKL48yv3fjGLDKkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+WCJK3xquZ+727StjL8AU521Zuk7GVz/e1Trr1nGjQ=;
 b=Z0CQm+WPRaLaTkZMoYyKsA0Ls/PjabDk11eTMFHS5KU7Qi2KRZfw/ZPiqZo/MyB2JciF5QGhmgdMALQ0TL21uCX5VKVvaiNh5729rFpAC8nZfkKLLN7laUwurCRQvld4SJP+1v+vffIgGIYieXDQCgcZXxlm83QgCBrtpmgGyek=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM6PR18MB2505.namprd18.prod.outlook.com (2603:10b6:5:185::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Mon, 21 Sep
 2020 17:30:11 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::905a:ebb4:369c:ae1b]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::905a:ebb4:369c:ae1b%7]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 17:30:11 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Quinn Tran <qutran@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v3 11/13] qla2xxx: Add IOCB resource tracking
Thread-Topic: [PATCH v3 11/13] qla2xxx: Add IOCB resource tracking
Thread-Index: AQHWgne76VtCFfW3yEeNItFGtBbfaalYnVmAgBRwkQCAABMNgIAGEAVQ
Date:   Mon, 21 Sep 2020 17:30:11 +0000
Message-ID: <DM6PR18MB3052A4B20D0C5AA509A7918BAF3A0@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20200904045128.23631-1-njavali@marvell.com>
 <20200904045128.23631-12-njavali@marvell.com>
 <bd547541-5a29-5ec5-305a-8614d5a8792c@acm.org>
 <BYAPR18MB2759BFC109D95D019D027304D53E0@BYAPR18MB2759.namprd18.prod.outlook.com>
 <BYAPR18MB2759B6FC4D9A4E89CDA31CA7D53E0@BYAPR18MB2759.namprd18.prod.outlook.com>
In-Reply-To: <BYAPR18MB2759B6FC4D9A4E89CDA31CA7D53E0@BYAPR18MB2759.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [59.90.38.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33b263a2-c505-4bd9-0d07-08d85e53fe3b
x-ms-traffictypediagnostic: DM6PR18MB2505:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB2505DEF4C3C3E53139A82FBCAF3A0@DM6PR18MB2505.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gZJgv20xFier6Q6ZckZ6Nu+2CpfnmEi9EvllKpJnjVjk/Hi88+8+zmIeqpuydCIbIwMarWOA1N57b6NiPocSf/MYApEle33OkUu9ufSp8BEEbBEz6nvpAA0CLQ1LrEf4oPH0Fl0MOCdE/Fg/DYo6XUZSGWB3ubwuGhUcb7UCc12dWKIlkErnnHPLbMpZxgKrl6uS2kB6/KnSsWsnZDKYtNlV3QJWPI2H+I5m8k3msl8Rm+R/UgZY1LA3i0BSMr9AafxX+xuCxdy9HZ515NC7p7yvWrLdeuf5FT/UVzlcJ5UqM6YIKseckIG55euUttkrebHomwtI4WbjxQYscGkCSwLU3MuNXUTwljR3duYL72TCHh2fhiKgMBrV/wVc7+Ch
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(71200400001)(66446008)(66556008)(8676002)(2906002)(52536014)(9686003)(64756008)(83380400001)(66946007)(66476007)(478600001)(5660300002)(76116006)(54906003)(186003)(26005)(55016002)(4326008)(316002)(33656002)(53546011)(7696005)(6506007)(86362001)(110136005)(107886003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: m9TbYExmrXJ+gZwjpiaLIRW3iDrS/WmjX0Fc8ckYB1aZlPtG4i6mtLUGwGXtI1TM/qWZ4nKgOPFxDXD6ORF5eUE261A0sfbJxX7StngF7a9fTbhKbTtKsueWTKIBzmPJOFSrc7kFqm/vkavmgibRSAqEm/Fw2JUhHN2DJr27olrEsuLuu89Z9+okoJyUWubmT20UWOiQSShpK24dLq4eJzGX5JQEMwdS5dpRHEiyt5wfweimA5C6SWBA2zFFdJ4xEkt6WEf3JaduBm+GBqmCxxdAsSoRAZxgBRipdKAOlo2KmfZQx8+WRuW3f4dqMYsORN2SM6gSL5uyxpT8Wvhnah1PztdUfkpJ40TXCRZeXbfDR0DDxmrvPVUiB1lkoXqPoVKEW8WanYvMu9AEr06Jac3xm1C5Di5z7/POgJtGZ5AOiYeqK12T3LwcI/ibAgR0w2LsWyGkW+fo8rYQCrup3oEnyNzj4L2toSXYmcF5nyKjgTbI9Ju/lEbOwlYYlRDhi1rSJvMY1wC2Hu44olXfgKIPFQBNBRAswDzRwBHvQrEeNDknRTEdpkUU8c5as6S0UqkaihhdzYmcFVrwvtjmtmHG+JMql8TiVhW2Mqm0rsHEG1GAgFwls3+7+lXNpjlagQzRe7N24yAvukrkUENlEQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b263a2-c505-4bd9-0d07-08d85e53fe3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 17:30:11.2045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dW8sQTBpJfdcIEWVHfUUoSdW7kU1jzKTpOpGMyhUE2mzlcf5hBkEgRtMWfu6pymapw8mK8rACZjjrbmh+nHTdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2505
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_06:2020-09-21,2020-09-21 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWFydGluLA0KV2UgZG8gbm90IGFudGljaXBhdGUgZnVydGhlciBjaGFuZ2VzIHRvIHRoaXMgcGF0
Y2ggb3IgdjMgc2VyaWVzLg0KDQpUaGFua3MsDQpOaWxlc2gNCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQo+IFNl
bnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMTcsIDIwMjAgMTA6MjMgUE0NCj4gVG86IEJhcnQgVmFu
IEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPjsgTmlsZXNoIEphdmFsaQ0KPiA8bmphdmFsaUBt
YXJ2ZWxsLmNvbT47IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tDQo+IENjOiBsaW51eC1zY3Np
QHZnZXIua2VybmVsLm9yZzsgR1ItUUxvZ2ljLVN0b3JhZ2UtVXBzdHJlYW0gPEdSLVFMb2dpYy0N
Cj4gU3RvcmFnZS1VcHN0cmVhbUBtYXJ2ZWxsLmNvbT4NCj4gU3ViamVjdDogUkU6IFtQQVRDSCB2
MyAxMS8xM10gcWxhMnh4eDogQWRkIElPQ0IgcmVzb3VyY2UgdHJhY2tpbmcNCj4gDQo+IA0KPiBP
biAyMDIwLTA5LTAzIDIxOjUxLCBOaWxlc2ggSmF2YWxpIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2gg
dHJhY2tzIG51bWJlciBvZiBJT0NCIHJlc291cmNlcyB1c2VkIGluIHRoZSBJTyBmYXN0IHBhdGgu
DQo+ID4gSWYgdGhlIG51bWJlciBvZiB1c2VkIElPQ0JzIHJlYWNoIGEgaGlnaCB3YXRlciBsaW1p
dCwgZHJpdmVyIHdvdWxkDQo+ID4gcmV0dXJuIHRoZSBJTyBhcyBidXN5IGFuZCBsZXQgdXBwZXIg
bGF5ZXIgcmV0cnkuIFRoaXMgcHJldmVudHMgb3Zlcg0KPiA+IHN1YnNjcmlwdGlvbiBvZiBJT0NC
IHJlc291cmNlcyB3aGVyZSBhbnkgZnV0dXJlIGVycm9yIHJlY292ZXJ5IGNvbW1hbmQNCj4gPiBp
cyB1bmFibGUgdG8gY3V0IHRocm91Z2guDQo+ID4gRW5hYmxlIElPQ0IgdGhyb3R0bGluZyBieSBk
ZWZhdWx0Lg0KPiANCj4gUGxlYXNlIHVzZSB0aGUgYmxvY2sgbGF5ZXIgcmVzZXJ2ZWQgdGFnIG1l
Y2hhbmlzbSBpbnN0ZWFkIG9mIGFkZGluZyBhDQo+IG1lY2hhbmlzbSB0aGF0IGlzIChhKSByYWN5
IGFuZCAoYikgdHJpZ2dlcnMgY2FjaGUgbGluZSBwaW5nLXBvbmcuDQo+IA0KPiBRVDogVGhlIEJs
b2NrIGxheWVyIHJlc2VydmUgdGFnIGRvZXMgZml0IHJlc291cmNlIHdlJ3JlIHRyYWNraW5nLiAg
VGhlIHJlc2VydmUNCj4gdGFnIGlzIHBlciBjb21tYW5kLiAgVGhlIElPQ0IgcmVzb3VyY2UgaXMg
YWRhcHRlciBzcGVjaWZpYyBiZWhpbmQgIGFsbA0KPiBjb21tYW5kcy4NCj4gDQo+IFFUOiBJIG1l
YW4gIiBUaGUgQmxvY2sgbGF5ZXIgcmVzZXJ2ZSB0YWcgZG9lcyBOT1QgZml0IHRoZSByZXNvdXJj
ZSB3ZSdyZQ0KPiB0cmFja2luZyINCj4gDQoNCg==
