Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD8DC433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 21:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22D81206C2
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 21:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfHMVHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 17:07:53 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:21278 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726771AbfHMVHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 17:07:52 -0400
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7DL0whR010890;
        Tue, 13 Aug 2019 21:07:46 GMT
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        by mx0b-002e3701.pphosted.com with ESMTP id 2uc287s1y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Aug 2019 21:07:46 +0000
Received: from G2W6311.americas.hpqcorp.net (g2w6311.austin.hp.com [16.197.64.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g4t3427.houston.hpe.com (Postfix) with ESMTPS id EE5867E;
        Tue, 13 Aug 2019 21:07:45 +0000 (UTC)
Received: from G9W8674.americas.hpqcorp.net (16.220.49.0) by
 G2W6311.americas.hpqcorp.net (16.197.64.53) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 13 Aug 2019 21:07:36 +0000
Received: from G9W9210.americas.hpqcorp.net (2002:10dc:429b::10dc:429b) by
 G9W8674.americas.hpqcorp.net (2002:10dc:3100::10dc:3100) with Microsoft SMTP
 Server (TLS) id 15.0.1367.3; Tue, 13 Aug 2019 21:07:14 +0000
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (15.241.52.11) by
 G9W9210.americas.hpqcorp.net (16.220.66.155) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3 via Frontend Transport; Tue, 13 Aug 2019 21:07:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfeuXigjfBwOZXD/2FpeFiDIIfKwy1LfnxhHy8q9/LJSOwrwidfHXWRWtVTalzYFpvciJ0CAMpRsrOZnrP6C6ryelED20eaPh7q3RQd22eO+y1alSPY4p4NMC6y2wdQw57CD27J6sIQckTBtHm1TsF4kSLODcLZo/Nj/mp/hK1cEw9bkv1hnwiD0FLQSt7fdb6NyHs7UYgKjYqcfNboVusNOOnvlERu88JtruythlXg9a3Z2LJ0EBu4GbIozM66nq8AC8XwxA4bMEG3MzdtN0uoOMXSNq12RRay+lSNYz+i/76SD2FWXF1mJaKn3VTQN4vO5z8I7DA06vsedUhcZlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JaDmP9iI6ORYjjLHPueOH1tdE2HWLdyJDp4DtNycZOU=;
 b=fvz1CSkWBnRGkfPb3PGWKDMFuHXEbij4mLyOVv6uYO0fl92Yml1pq8UOg3+929uGwnorCT29II7idDsqPStyiTZFarRN8U2VwbK94o1n7MY73n+H2yFebxpcr2uHQ+CDDXSaIFlG7Od182PvRgHvW4CF1okocJxeatXUCimG5IvHerMndxSPspPUC/maWcivORuZIzYgGrmT/a/oa1Gl8Mx3lfbJep9Vu2jHIDrfoU78AjSLM5xF/Zu1NlBrIMUrTQ46W7hK6De4uwYywgk+FYQ3IU+za7JLd3YPjuFgTM7llIpSOR7D2FhkzN5BKsA1NuKDi/PlTvoGwgDBQAWagw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from CS1PR8401MB0727.NAMPRD84.PROD.OUTLOOK.COM (10.169.15.135) by
 CS1PR8401MB1141.NAMPRD84.PROD.OUTLOOK.COM (10.169.14.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Tue, 13 Aug 2019 21:07:13 +0000
Received: from CS1PR8401MB0727.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::9dd6:863e:f72c:e742]) by CS1PR8401MB0727.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::9dd6:863e:f72c:e742%10]) with mapi id 15.20.2157.022; Tue, 13 Aug
 2019 21:07:13 +0000
From:   "Vaden, Tom (HPE Server OS Architecture)" <tom.vaden@hpe.com>
To:     Christoph Hellwig <hch@lst.de>, Tony Luck <tony.luck@intel.com>,
        "Fenghua Yu" <fenghua.yu@intel.com>,
        "Travis, Mike" <mike.travis@hpe.com>,
        "Sivanich, Dimitri" <dimitri.sivanich@hpe.com>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/28] ia64: remove CONFIG_PCI ifdefs
Thread-Topic: [PATCH 18/28] ia64: remove CONFIG_PCI ifdefs
Thread-Index: AQHVUah19chxf4ZgqEGw+jc8gAfut6b5ktKA
Date:   Tue, 13 Aug 2019 21:07:12 +0000
Message-ID: <69070d1b-9353-0ae7-e16f-d3feb84bd2a6@hpe.com>
References: <20190813072514.23299-1-hch@lst.de>
 <20190813072514.23299-19-hch@lst.de>
In-Reply-To: <20190813072514.23299-19-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:208:160::25) To CS1PR8401MB0727.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:750d::7)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2601:85:c100:2d8d:dbb0:2ed9:59d1:461]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1859b59b-1070-4ef6-b91f-08d720323659
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CS1PR8401MB1141;
x-ms-traffictypediagnostic: CS1PR8401MB1141:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CS1PR8401MB1141B16A93A24C8FCFC3BE09E8D20@CS1PR8401MB1141.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(136003)(39860400002)(199004)(189003)(6506007)(66476007)(64756008)(66946007)(6436002)(6636002)(81166006)(386003)(99286004)(71190400001)(102836004)(81156014)(478600001)(31686004)(186003)(71200400001)(53546011)(8676002)(66446008)(66556008)(486006)(305945005)(6486002)(4326008)(46003)(52116002)(76176011)(6116002)(316002)(110136005)(86362001)(476003)(6512007)(446003)(5660300002)(2616005)(11346002)(36756003)(8936002)(229853002)(25786009)(7736002)(14454004)(6246003)(2906002)(256004)(54906003)(31696002)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:CS1PR8401MB1141;H:CS1PR8401MB0727.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: hpe.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gIVbIWMkeeflAfOW5xVJh8hRXR8tp/Zia+zux8/WLXb1XcclUbtAIZ/KYlau4lYw4RemDsACu/mJbcjHAClIMC3bzx8vYdG6hc+ny7tfyMkaWQO2O/OBjdJyxQEAWUeFvqxGWBpsJ5n73mTOEFFlypDIXrfHvK5SvhCPmy99dTx3FqVcWBwUIWkYrrIlFmHTtAP5TxtNw5H68ax7Ygo/UoyHccAPh4GGB2UujnYs2W61mGO+iMcdItrbaVgd46E5dBmm8qPzoxwBlevjxELyA28an4peMq3E9+qk3MRYpezInOQuNA0EbUdmQZTVqDz+X5WQo3x3ON5qxWMELgB9NIEaCQ32Gt5NHEsz39IBNdGXPo6XTWkDZeUM3Y6WvTM5sJFnUCegSF4rDdwA/H6MQuPUHKoxwm0w5Shqymg1VgU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D0E555F56608749953F398E7A5FA760@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1859b59b-1070-4ef6-b91f-08d720323659
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 21:07:12.9977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M9NEQRw+Fyt+TLvTz9fct/kNC/6KyIIVbn9M/wB/d48ugRBovtEafR79ppgMN8sraR2CZqk05oWCBrFtJq9NQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CS1PR8401MB1141
X-OriginatorOrg: hpe.com
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130201
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCk9uIDgvMTMvMTkgMzoyNSBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IE5vdyB0
aGF0IGhwc2ltIHN1cHBvcnQgaXMgZ29uZSwgQ09ORklHX1BDSSBpcyBmb3JjZWQgb24gZm9yIGlh
NjQsIGFuZA0KPiB3ZSBjYW4gcmVtb3ZlIGEgZmV3IGlmZGVmcyBmb3IgaXQuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCg0KT2theSB0byByZW1v
dmUgaHBzaW0gc3VwcG9ydA0KQWNrZWQtYnk6IFRvbSBWYWRlbiA8dG9tLnZhZGVuQGhwZS5jb20+
DQoNCj4gLS0tDQo+ICAgYXJjaC9pYTY0L01ha2VmaWxlICAgICAgICAgICAgICB8ICAyICstDQo+
ICAgYXJjaC9pYTY0L2hwL2NvbW1vbi9zYmFfaW9tbXUuYyB8IDEwICstLS0tLS0tLS0NCj4gICBh
cmNoL2lhNjQvaW5jbHVkZS9hc20vZG1hLmggICAgIHwgIDYgKy0tLS0tDQo+ICAgYXJjaC9pYTY0
L2tlcm5lbC9zeXNfaWE2NC5jICAgICB8IDE4IC0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgIGFyY2gv
aWE2NC9tbS9pbml0LmMgICAgICAgICAgICAgfCAgMiAtLQ0KPiAgIDUgZmlsZXMgY2hhbmdlZCwg
MyBpbnNlcnRpb25zKCspLCAzNSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNo
L2lhNjQvTWFrZWZpbGUgYi9hcmNoL2lhNjQvTWFrZWZpbGUNCj4gaW5kZXggOGI4NjZmYzFmOWNi
Li5jMDY4MDI3OTk2NTkgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvaWE2NC9NYWtlZmlsZQ0KPiArKysg
Yi9hcmNoL2lhNjQvTWFrZWZpbGUNCj4gQEAgLTU3LDcgKzU3LDcgQEAgY29yZS0kKENPTkZJR19J
QTY0X0hQX1pYMSkJKz0gYXJjaC9pYTY0L2RpZy8NCj4gICBjb3JlLSQoQ09ORklHX0lBNjRfSFBf
WlgxX1NXSU9UTEIpICs9IGFyY2gvaWE2NC9kaWcvDQo+ICAgY29yZS0kKENPTkZJR19JQTY0X1NH
SV9VVikJKz0gYXJjaC9pYTY0L3V2Lw0KPiAgIA0KPiAtZHJpdmVycy0kKENPTkZJR19QQ0kpCQkr
PSBhcmNoL2lhNjQvcGNpLw0KPiArZHJpdmVycy15CQkJKz0gYXJjaC9pYTY0L3BjaS8NCj4gICBk
cml2ZXJzLSQoQ09ORklHX0lBNjRfSFBfWlgxKQkrPSBhcmNoL2lhNjQvaHAvY29tbW9uLyBhcmNo
L2lhNjQvaHAvengxLw0KPiAgIGRyaXZlcnMtJChDT05GSUdfSUE2NF9IUF9aWDFfU1dJT1RMQikg
Kz0gYXJjaC9pYTY0L2hwL2NvbW1vbi8gYXJjaC9pYTY0L2hwL3p4MS8NCj4gICBkcml2ZXJzLSQo
Q09ORklHX0lBNjRfR0VORVJJQykJKz0gYXJjaC9pYTY0L2hwL2NvbW1vbi8gYXJjaC9pYTY0L2hw
L3p4MS8gYXJjaC9pYTY0L3V2Lw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L2hwL2NvbW1vbi9z
YmFfaW9tbXUuYyBiL2FyY2gvaWE2NC9ocC9jb21tb24vc2JhX2lvbW11LmMNCj4gaW5kZXggM2Qy
NGNjNDMzODViLi4xODMyMWNlOGJmYTAgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvaWE2NC9ocC9jb21t
b24vc2JhX2lvbW11LmMNCj4gKysrIGIvYXJjaC9pYTY0L2hwL2NvbW1vbi9zYmFfaW9tbXUuYw0K
PiBAQCAtMjUxLDEyICsyNTEsOCBAQCBzdGF0aWMgU0JBX0lOTElORSB2b2lkIHNiYV9mcmVlX3Jh
bmdlKHN0cnVjdCBpb2MgKiwgZG1hX2FkZHJfdCwgc2l6ZV90KTsNCj4gICBzdGF0aWMgdTY0IHBy
ZWZldGNoX3NwaWxsX3BhZ2U7DQo+ICAgI2VuZGlmDQo+ICAgDQo+IC0jaWZkZWYgQ09ORklHX1BD
SQ0KPiAtIyBkZWZpbmUgR0VUX0lPQyhkZXYpCSgoZGV2X2lzX3BjaShkZXYpKQkJCQkJCVwNCj4g
KyNkZWZpbmUgR0VUX0lPQyhkZXYpCSgoZGV2X2lzX3BjaShkZXYpKQkJCQkJCVwNCj4gICAJCQkg
PyAoKHN0cnVjdCBpb2MgKikgUENJX0NPTlRST0xMRVIodG9fcGNpX2RldihkZXYpKS0+aW9tbXUp
IDogTlVMTCkNCj4gLSNlbHNlDQo+IC0jIGRlZmluZSBHRVRfSU9DKGRldikJTlVMTA0KPiAtI2Vu
ZGlmDQo+ICAgDQo+ICAgLyoNCj4gICAqKiBETUFfQ0hVTktfU0laRSBpcyB1c2VkIGJ5IHRoZSBT
Q1NJIG1pZC1sYXllciB0byBicmVhayB1cA0KPiBAQCAtMTc0MSw5ICsxNzM3LDcgQEAgaW9jX3Nh
Y19pbml0KHN0cnVjdCBpb2MgKmlvYykNCj4gICAJY29udHJvbGxlci0+aW9tbXUgPSBpb2M7DQo+
ICAgCXNhYy0+c3lzZGF0YSA9IGNvbnRyb2xsZXI7DQo+ICAgCXNhYy0+ZG1hX21hc2sgPSAweEZG
RkZGRkZGVUw7DQo+IC0jaWZkZWYgQ09ORklHX1BDSQ0KPiAgIAlzYWMtPmRldi5idXMgPSAmcGNp
X2J1c190eXBlOw0KPiAtI2VuZGlmDQo+ICAgCWlvYy0+c2FjX29ubHlfZGV2ID0gc2FjOw0KPiAg
IH0NCj4gICANCj4gQEAgLTIxMjEsMTMgKzIxMTUsMTEgQEAgc2JhX2luaXQodm9pZCkNCj4gICAJ
fQ0KPiAgICNlbmRpZg0KPiAgIA0KPiAtI2lmZGVmIENPTkZJR19QQ0kNCj4gICAJew0KPiAgIAkJ
c3RydWN0IHBjaV9idXMgKmIgPSBOVUxMOw0KPiAgIAkJd2hpbGUgKChiID0gcGNpX2ZpbmRfbmV4
dF9idXMoYikpICE9IE5VTEwpDQo+ICAgCQkJc2JhX2Nvbm5lY3RfYnVzKGIpOw0KPiAgIAl9DQo+
IC0jZW5kaWYNCj4gICANCj4gICAjaWZkZWYgQ09ORklHX1BST0NfRlMNCj4gICAJaW9jX3Byb2Nf
aW5pdCgpOw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L2luY2x1ZGUvYXNtL2RtYS5oIGIvYXJj
aC9pYTY0L2luY2x1ZGUvYXNtL2RtYS5oDQo+IGluZGV4IDIzNjA0ZDZhMmNiMi4uNTk2MjVlOWMx
ZjljIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2lhNjQvaW5jbHVkZS9hc20vZG1hLmgNCj4gKysrIGIv
YXJjaC9pYTY0L2luY2x1ZGUvYXNtL2RtYS5oDQo+IEBAIC0xMiwxMSArMTIsNyBAQA0KPiAgIA0K
PiAgIGV4dGVybiB1bnNpZ25lZCBsb25nIE1BWF9ETUFfQUREUkVTUzsNCj4gICANCj4gLSNpZmRl
ZiBDT05GSUdfUENJDQo+IC0gIGV4dGVybiBpbnQgaXNhX2RtYV9icmlkZ2VfYnVnZ3k7DQo+IC0j
ZWxzZQ0KPiAtIyBkZWZpbmUgaXNhX2RtYV9icmlkZ2VfYnVnZ3kgCSgwKQ0KPiAtI2VuZGlmDQo+
ICtleHRlcm4gaW50IGlzYV9kbWFfYnJpZGdlX2J1Z2d5Ow0KPiAgIA0KPiAgICNkZWZpbmUgZnJl
ZV9kbWEoeCkNCj4gICANCj4gZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9rZXJuZWwvc3lzX2lhNjQu
YyBiL2FyY2gvaWE2NC9rZXJuZWwvc3lzX2lhNjQuYw0KPiBpbmRleCA5ZWJlMWQ2MzNhYmMuLmUx
NGRiMjUxNDZjMiAxMDA2NDQNCj4gLS0tIGEvYXJjaC9pYTY0L2tlcm5lbC9zeXNfaWE2NC5jDQo+
ICsrKyBiL2FyY2gvaWE2NC9rZXJuZWwvc3lzX2lhNjQuYw0KPiBAQCAtMTY2LDIxICsxNjYsMyBA
QCBpYTY0X21yZW1hcCAodW5zaWduZWQgbG9uZyBhZGRyLCB1bnNpZ25lZCBsb25nIG9sZF9sZW4s
IHVuc2lnbmVkIGxvbmcgbmV3X2xlbiwgdQ0KPiAgIAkJZm9yY2Vfc3VjY2Vzc2Z1bF9zeXNjYWxs
X3JldHVybigpOw0KPiAgIAlyZXR1cm4gYWRkcjsNCj4gICB9DQo+IC0NCj4gLSNpZm5kZWYgQ09O
RklHX1BDSQ0KPiAtDQo+IC1hc21saW5rYWdlIGxvbmcNCj4gLXN5c19wY2ljb25maWdfcmVhZCAo
dW5zaWduZWQgbG9uZyBidXMsIHVuc2lnbmVkIGxvbmcgZGZuLCB1bnNpZ25lZCBsb25nIG9mZiwg
dW5zaWduZWQgbG9uZyBsZW4sDQo+IC0JCSAgICB2b2lkICpidWYpDQo+IC17DQo+IC0JcmV0dXJu
IC1FTk9TWVM7DQo+IC19DQo+IC0NCj4gLWFzbWxpbmthZ2UgbG9uZw0KPiAtc3lzX3BjaWNvbmZp
Z193cml0ZSAodW5zaWduZWQgbG9uZyBidXMsIHVuc2lnbmVkIGxvbmcgZGZuLCB1bnNpZ25lZCBs
b25nIG9mZiwgdW5zaWduZWQgbG9uZyBsZW4sDQo+IC0JCSAgICAgdm9pZCAqYnVmKQ0KPiAtew0K
PiAtCXJldHVybiAtRU5PU1lTOw0KPiAtfQ0KPiAtDQo+IC0jZW5kaWYgLyogQ09ORklHX1BDSSAq
Lw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L21tL2luaXQuYyBiL2FyY2gvaWE2NC9tbS9pbml0
LmMNCj4gaW5kZXggYWFlNzVmZDdiODEwLi45YTRhMTY0Mzk5MDAgMTAwNjQ0DQo+IC0tLSBhL2Fy
Y2gvaWE2NC9tbS9pbml0LmMNCj4gKysrIGIvYXJjaC9pYTY0L21tL2luaXQuYw0KPiBAQCAtNjMy
LDE0ICs2MzIsMTIgQEAgbWVtX2luaXQgKHZvaWQpDQo+ICAgCUJVR19PTihQVFJTX1BFUl9QTUQg
KiBzaXplb2YocG1kX3QpICE9IFBBR0VfU0laRSk7DQo+ICAgCUJVR19PTihQVFJTX1BFUl9QVEUg
KiBzaXplb2YocHRlX3QpICE9IFBBR0VfU0laRSk7DQo+ICAgDQo+IC0jaWZkZWYgQ09ORklHX1BD
SQ0KPiAgIAkvKg0KPiAgIAkgKiBUaGlzIG5lZWRzIHRvIGJlIGNhbGxlZCBfYWZ0ZXJfIHRoZSBj
b21tYW5kIGxpbmUgaGFzIGJlZW4gcGFyc2VkIGJ1dCBfYmVmb3JlXw0KPiAgIAkgKiBhbnkgZHJp
dmVycyB0aGF0IG1heSBuZWVkIHRoZSBQQ0kgRE1BIGludGVyZmFjZSBhcmUgaW5pdGlhbGl6ZWQg
b3IgYm9vdG1lbSBoYXMNCj4gICAJICogYmVlbiBmcmVlZC4NCj4gICAJICovDQo+ICAgCXBsYXRm
b3JtX2RtYV9pbml0KCk7DQo+IC0jZW5kaWYNCj4gICANCj4gICAjaWZkZWYgQ09ORklHX0ZMQVRN
RU0NCj4gICAJQlVHX09OKCFtZW1fbWFwKTsNCj4gDQo=
