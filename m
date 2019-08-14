Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B45C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 14:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D527206C1
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 14:08:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Khmwpdso";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="rIl7EAJ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfHNOIb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 10:08:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35912 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbfHNOIb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 10:08:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7EE4q9X002216;
        Wed, 14 Aug 2019 07:08:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=jyHrq3E8LW/gcfijRFBDiGPWGV49pxifSfdiNZ3whCA=;
 b=KhmwpdsoFJaBRhsJVgYfE++LmRAVhO3viQliJV4kHpZZgQLFuLuQ+1yMB7ncUu6Urba5
 41BrZtgNjysD+siwakwkvk+2cNuvG9WNa/WzwaIbLsEIlMvNZNie2IZiay0eSdlcMgg3
 ePdwbi9pOuEdHxj3wzgYg2mwZuTuFK58fXW/oFlnP6rNbctxkufEUWvOELwqrxnCS6vo
 Q8EgNdwpFmTXPb9JzYQ89TXxOedRvdtF67Agr3W5hxt1ggQqu4xi6GRJRoDZ3QJfgGOg
 JqqPY87D8a4/OfG/tkNAXGIY3mgcrhtrZkbOGRQcyU1PRLV6P/LuFyqCVoXEyKoHexN9 4Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ubfabfady-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 07:08:16 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 14 Aug
 2019 07:08:14 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.57) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 14 Aug 2019 07:08:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RePqxPOkZUKmzHE5sfGo6phnU+HVoGOlBppFtSs9O9zJeYTJv2VuoHRC1SBgg5pJIKtXCqBknoOUTXJkoD1oFNaycywAtb2LxB9VbwDTFErOTCtH0UjFZ064LCK6HJzqq3MEmU4Okoejem1sTW6yb+uuqzorctVDFkJcYtKkd9lRtK08ZDEtBHW358jige5xdMQ+MhPpIyYlImSWe2S9b83fsW4nHW/0pdx9tZyVgtMEYnTAQaIjh2Nu4Aiu5CMHn4I65Nhw7K/hGgU5272zbOJLsWxMAeBpOiaAjzIlS0vYdabIwgeepeuYj9ZVO3To5MtPykwBOz0LyBCvI36dsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyHrq3E8LW/gcfijRFBDiGPWGV49pxifSfdiNZ3whCA=;
 b=WtCks2AjoYK5HLR6A1qIsE7i4ED8liA2+rAkr081xh8Oh+oreZVG/JvZRovRFluJZLBysb0h74AywHwp5yoTCZvq4tcaoUpZUEHteiHb/b03jzWV1BUeF9JGDimdCp+tm4qNlp56uL+OGIu6g/0YvBfQ/V9l77RbvkMdViFWGKpPmC23LFjz6vJVC7/VcyNKLbNwakmwKcZ1RT/TZ3Y8r2vRNpDkD8yIvTw+ZzpaKWu01OtBff3HR/tG+PBj5hbliyHjWBumgqBV9kI6saVnyNdTtIkpWRzKbgcmzQnO1i1YoCiKzTYyQW+Ke8EGFh0JXz05QVeGeq6UllcvhW9PwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyHrq3E8LW/gcfijRFBDiGPWGV49pxifSfdiNZ3whCA=;
 b=rIl7EAJ32lmd7ZiXGg2nAEEVoae4CSvpEFalv7O058HN2VYSE5x3r7Pivce2o4m4ZeT67cbotqlOA59ZCASXd+Bt6qXa7xzIeUB14vGWxE7dftrJJJnx2LkK4wUxxC8mf5JgOJO4VuR0Y48iqGJx+8ISA5YBFiHF64s2pEt+tUo=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3438.namprd18.prod.outlook.com (10.255.239.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Wed, 14 Aug 2019 14:08:09 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a%6]) with mapi id 15.20.2157.021; Wed, 14 Aug 2019
 14:08:09 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: replace snprintf with strscpy
Thread-Topic: [PATCH] scsi: qla2xxx: replace snprintf with strscpy
Thread-Index: AQHVQq1r2m4vuuNEjU6H5Hb3H+MN0qb6ejkA
Date:   Wed, 14 Aug 2019 14:08:09 +0000
Message-ID: <534C4F87-2E58-48D1-ADC0-7136F85743D1@marvell.com>
References: <20190725054653.30729-1-xywang.sjtu@sjtu.edu.cn>
In-Reply-To: <20190725054653.30729-1-xywang.sjtu@sjtu.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1b.0.190715
x-originating-ip: [2600:1700:211:eb30:5871:9d72:f424:86ba]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7341a53-f28f-43d9-e424-08d720c0d62f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3438;
x-ms-traffictypediagnostic: MN2PR18MB3438:
x-microsoft-antispam-prvs: <MN2PR18MB3438C5F312917A3B8B192327D6AD0@MN2PR18MB3438.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:49;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(199004)(189003)(6486002)(25786009)(2171002)(478600001)(76176011)(186003)(99286004)(6506007)(229853002)(102836004)(6246003)(2906002)(4326008)(6436002)(6916009)(316002)(6116002)(58126008)(66476007)(66556008)(64756008)(66446008)(33656002)(305945005)(71200400001)(76116006)(5660300002)(66946007)(53936002)(8676002)(8936002)(91956017)(71190400001)(81156014)(7736002)(81166006)(6512007)(86362001)(446003)(11346002)(486006)(36756003)(476003)(14454004)(256004)(46003)(2616005)(156123004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3438;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9l5P/x0q9s0Qz1gymJidjmxu1/JIZQJb9+Ryh3dIhK7bcP4Gz4JGlosrfvc5yXJuPRbPzDOtAPPTCTcDN6gWIJ/QBQYC616DjVA+QwiFBuWs0kz+7Z5KCoz4E0dmNYcf13YH6JDJGAOOpWXZuG2T8QoKZw/Op0aDpl/JnFO2tgrpWYs9EOLLPbqCYr9OuEVBfS1N1sL+qW3z1xjJegfaC69BXH1TjW+gy+pZDHz2ikScJX03jqSDI08kSQwqVIScNY2fO+WbjcU5I1xxkTiS+2+09kq8bMHqsQ5NpW2bnzKG28FEDzgFf2+eQp+eTpHMuvDUUo+NSg/eb+tROb6Ug0HNaO1xjF/a55fCEhgYZ16wF5BIv3/drNbqHEQkXZlO8KLHdW6JF1IHdPyj8f6DQw/n0DNhEOQwoDiZkLcf4fw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D71F4D5A3BF7D249A41EA4D59CE1843D@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b7341a53-f28f-43d9-e424-08d720c0d62f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 14:08:09.4647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FxLwpDeQ4NpoxTW6XEPSfFRgWkIrE+oG19+PsWJ/xJc5Yhou7VWRs7xIBRmvKIgQdbyHDCh1vrj2ecMeAbaiNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3438
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-14_05:2019-08-14,2019-08-14 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDcvMjUvMTksIDEyOjU0IEFNLCAibGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgb24gYmVoYWxmIG9mIFdhbmcgWGlheWFuZyIgPGxpbnV4LXNjc2ktb3duZXJAdmdlci5r
ZXJuZWwub3JnIG9uIGJlaGFsZiBvZiB4eXdhbmcuc2p0dUBzanR1LmVkdS5jbj4gd3JvdGU6DQoN
CiAgICBBcyBjb21taXQgYTg2MDI4ZjhlM2VlICgic3RhZ2luZzogbW9zdDogc291bmQ6IHJlcGxh
Y2Ugc25wcmludGYNCiAgICB3aXRoIHN0cnNjcHkiKSBzdWdnZXN0ZWQsIHVzaW5nIHNucHJpbnRm
IHdpdGhvdXQgYSBmb3JtYXQgc3BlY2lmaWVyDQogICAgaXMgcG90ZW50aWFsbHkgcmlza3kgaWYg
YTAtPnZlbmRvcl9uYW1lIG9yIGEwLT52ZW5kb3JfcG4gbWlzdGFrZW5seQ0KICAgIGNvbnRhaW4g
Zm9ybWF0IHNwZWNpZmllcnMuIEluIGFkZGl0aW9uLCBhcyBjb21wYXJlZCBpbiB0aGUNCiAgICBp
bXBsZW1lbnRhdGlvbiwgc3Ryc2NweSBsb29rcyBtb3JlIGxpZ2h0LXdlaWdodCB0aGFuIHNucHJp
bnRmLg0KICAgIA0KICAgIFRoaXMgcGF0Y2ggZG9lcyBub3QgaW5jdXIgYW55IGZ1bmN0aW9uYWwg
Y2hhbmdlLg0KICAgIA0KICAgIFNpZ25lZC1vZmYtYnk6IFdhbmcgWGlheWFuZyA8eHl3YW5nLnNq
dHVAc2p0dS5lZHUuY24+DQogICAgLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9p
bml0LmMgfCA0ICsrLS0NCiAgICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCiAgICANCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2luaXQuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCiAgICBpbmRleCA0
MDU5NjU1NjM5ZDkuLjA2OGI1NDIxOGZmNCAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Njc2kv
cWxhMnh4eC9xbGFfaW5pdC5jDQogICAgKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lu
aXQuYw0KICAgIEBAIC0zNDYxLDEyICszNDYxLDEyIEBAIHN0YXRpYyB2b2lkIHFsYTJ4eHhfcHJp
bnRfc2ZwX2luZm8oc3RydWN0IHNjc2lfcWxhX2hvc3QgKnZoYSkNCiAgICAgCWludCBsZWZ0b3Zl
ciwgbGVuOw0KICAgICANCiAgICAgCW1lbXNldChzdHIsIDAsIFNUUl9MRU4pOw0KICAgIC0Jc25w
cmludGYoc3RyLCBTRkZfVkVOX05BTUVfTEVOKzEsIGEwLT52ZW5kb3JfbmFtZSk7DQogICAgKwlz
dHJzY3B5KHN0ciwgYTAtPnZlbmRvcl9uYW1lLCBTRkZfVkVOX05BTUVfTEVOKzEpOw0KICAgICAJ
cWxfZGJnKHFsX2RiZ19pbml0LCB2aGEsIDB4MDE1YSwNCiAgICAgCSAgICAiU0ZQIE1GRyBOYW1l
OiAlc1xuIiwgc3RyKTsNCiAgICAgDQogICAgIAltZW1zZXQoc3RyLCAwLCBTVFJfTEVOKTsNCiAg
ICAtCXNucHJpbnRmKHN0ciwgU0ZGX1BBUlRfTkFNRV9MRU4rMSwgYTAtPnZlbmRvcl9wbik7DQog
ICAgKwlzdHJzY3B5KHN0ciwgYTAtPnZlbmRvcl9wbiwgU0ZGX1BBUlRfTkFNRV9MRU4rMSk7DQog
ICAgIAlxbF9kYmcocWxfZGJnX2luaXQsIHZoYSwgMHgwMTVjLA0KICAgICAJICAgICJTRlAgUGFy
dCBOYW1lOiAlc1xuIiwgc3RyKTsNCiAgICAgDQogICAgLS0gDQogICAgMi4xMS4wDQogICAgDQog
ICAgDQpMb29rcyBHb29kLiANCg0KQWNrZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhtYWRoYW5p
QG1hcnZlbGwuY29tPg0KDQo=
