Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F88AC5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 21:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C510F2087E
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 21:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="cU8gP0My"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfKEVrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 16:47:14 -0500
Received: from mail-eopbgr800070.outbound.protection.outlook.com ([40.107.80.70]:58702
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726751AbfKEVrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Nov 2019 16:47:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PuFCKVpMSBMxXbIC/gwzbY6w1lZ0w29rtFweMts5xykkRcc749n8xQCHh/vu95Wn0RjesSePOpr9CjpRCGeQ5WFx219Iunfvg11Q76/DyQawB9oNqK9lu0o2pRRL1O3h+KSIIBt10MmrQeL6o3kfjXhLz8IzT7wVbLHAxb/MRa9u8nfy9CHDpdhn+1xiXWzvySbpwmJJcwuFUztbiA16yXOnMdnbfAp/S+Np0EgXTu5MWefQLg8x+oNm2QsfoRTS2TsguBDSUv4Yfrib+wbbLyRn0zUDyvIlwFPcTC2nLjc/k3B69Cx673rImigHJ4uGYsJi2qkNVEmNVeACPtk6HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eoq5uYS58y5tLdGdBsQUaIywBhtOhfCxB1rWP46IvH0=;
 b=OHE5O/tyjP3vWT6dXRFTwycPgXvsdX0k9Otd3uwNh9hZGhoawdPmP6vuO8mg2h9lfZVORLNK93H0TpZMmvU7HAhUCRDLRD9F6dalHfTx+CPrtJA5trfhUT46+gcQpOBmwq1SCmWGj/Q/KMNE3p6cAsRk1OSR6FJbVl43pXBbKwa6TSJHHjer7jBRG9Yudx9a3ku8c3JBHde8az2daQyvdLFC/E+0pPjhLUExwxbasR3VeVWJAcZ7BWkcxZmyjs7xb6dktVCxa+Jdukw2ENaDLfQOhpp7xMcBE9f88z1jr8ZnF5wfxm/4gEMfi876NziN7oy7MkDXV97KwUQ6E37T/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eoq5uYS58y5tLdGdBsQUaIywBhtOhfCxB1rWP46IvH0=;
 b=cU8gP0MyUbkIZqZIRw2wYB6ePWf9gMrPRLILlH6rElYMnuMRRccQSUpsi+pVoAoOdlpsL03Y6h70eMrcu1cAMFV2oZ1SAqupsPVjMOi2pLdRXfSj6Nyf1qnTJ3kmbWAC5bodUaYKWgaUgVGCBXHGJQTLYu3zRoOjAYUuryMjBe0=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4322.namprd08.prod.outlook.com (52.135.249.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 21:47:11 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 21:47:11 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [EXT] [PATCH RFC v2 2/5] ufs: Use reserved tags for TMFs
Thread-Topic: [EXT] [PATCH RFC v2 2/5] ufs: Use reserved tags for TMFs
Thread-Index: AQHVk3Hu+vKK5UpByE6NhmIiHnKyoqd8eXOQgABVPoCAAElzYA==
Date:   Tue, 5 Nov 2019 21:47:11 +0000
Message-ID: <BN7PR08MB56841C9F0D42B50A8CBDE0F5DB7E0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20191105004226.232635-1-bvanassche@acm.org>
 <20191105004226.232635-3-bvanassche@acm.org>
 <BN7PR08MB56849F96E16115321F44F257DB7E0@BN7PR08MB5684.namprd08.prod.outlook.com>
 <11e7ba67-84ca-2f86-0bce-78646ced9612@acm.org>
In-Reply-To: <11e7ba67-84ca-2f86-0bce-78646ced9612@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWNmY2M5ZmRmLTAwMTUtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxjZmNjOWZlMC0wMDE1LTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjEzNjMiIHQ9IjEzMjE3NDY0MDI3OTQ1Mzk2NSIgaD0iR1J5azY1NW1VVFZZMDRrcHBhMUlZWVFHZnRVPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6dceb54-45d3-4d7e-9701-08d76239b6ab
x-ms-traffictypediagnostic: BN7PR08MB4322:|BN7PR08MB4322:|BN7PR08MB4322:
x-microsoft-antispam-prvs: <BN7PR08MB4322E4A4AAFA3562884707D8DB7E0@BN7PR08MB4322.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(189003)(199004)(81166006)(229853002)(2906002)(66446008)(102836004)(8676002)(64756008)(55236004)(6246003)(26005)(7696005)(99286004)(71190400001)(71200400001)(86362001)(81156014)(76176011)(14444005)(256004)(9686003)(55016002)(6436002)(66946007)(25786009)(66556008)(8936002)(53546011)(76116006)(6116002)(11346002)(446003)(7416002)(3846002)(486006)(66066001)(6506007)(66476007)(52536014)(4326008)(5660300002)(33656002)(476003)(54906003)(74316002)(186003)(7736002)(478600001)(316002)(305945005)(110136005)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4322;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EQPL7jQq9MrHdUXqhk0WaWOfjQLOjAKFdPXjGQKfz0MQizH56Gitc4XKYC5YMTt1o5QJ4YtcE6Hl6IaHG9G71bgo9n13Rokn+ZxYVdyOpu836u+f+u40Bw3ih6l3kdqhnMsU+r4BkGqzEtTx2zgKGKEqSjEhPuLP0i/Necyzl3iHB0GNYRI3FOA6anZu111b1RbhG6bOxprssFupbuz+bBdm/kecOnSY7xTeSmfrvFpeMp0zEOXRwZUTcjQazSwMZ7ObEsOzh2VDCRfraBRH3KDBl57IVYtDSEa1dhWSQYrSq49v5AP9IYTpLJNSCbUGxDji6HmGQlNXUifSuvSJaqpKxuasDtFpaiX+MjTht0L+7EKonV2iz9FeACG5+ghHH18bHqYrgN9Nbq0x5bhXV3kIRRBTTK40axnYVUiPSwaRCyfssSUtplEmVcZLY4Vz
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6dceb54-45d3-4d7e-9701-08d76239b6ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 21:47:11.1502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G5kvufjrWLBQfW91JP0UpaOQ1vOaWhckhV0vVMW+BVCDvcxX4dxzFGreKum86g8Wrkc/VWiOLpFBshBL5aUzgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4322
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gMTEvNS8xOSAzOjU4IEFNLCBCZWFuIEh1byAoYmVhbmh1bykgd3JvdGU6DQo+ID4+
ICAgCWhvc3QgPSBjbWQtPmRldmljZS0+aG9zdDsNCj4gPj4gICAJaGJhID0gc2hvc3RfcHJpdiho
b3N0KTsNCj4gPj4gLQl0YWcgPSBjbWQtPnJlcXVlc3QtPnRhZzsNCj4gPj4gKwl0YWcgPSBjbWQt
PnJlcXVlc3QtPnRhZyAtIGhiYS0+bnV0bXJzOw0KPiA+PiArCVdBUk5fT05fT05DRSghdWZzaGNk
X3ZhbGlkX3RhZyhoYmEsIHRhZykpOw0KPiA+DQo+ID4gQ2hhbmdpbmcgcmVxdWVzdCB0YWcgbnVt
YmVyIGhlcmUgaXMgbm90IHByb3BlciB3YXksIHdlIGhhdmUgdHJhY2UgdG9vbA0KPiA+IHVzaW5n
IHRoaXMgdGFnIHRvIHRyYWNrIHJlcXVlc3QgZnJvbSBibG9jaywgU0NTSSB0byBVRlMgbGF5ZXIu
IElmIHRhZ3MgYmVpbmcNCj4gY2hhbmdlZCBpbiBVRlMgZHJpdmVyLCB0aGVyZSB3aWxsIGJlIGEg
Y29uZnVzaW9uLg0KPiANCj4gSGkgQmVhbiwNCj4gDQo+IFRoYW5rcyBmb3IgaGF2aW5nIHRha2Vu
IGEgbG9vay4gV2hpY2ggaW5mb3JtYXRpb24gaXMgdXNlZCBieSB0aGUgdHJhY2luZyB0b29sPw0K
PiBjbWQtPnJlcXVlc3QtPnRhZyBvciB0aGUgdmFyaWFibGUgY2FsbGVkICd0YWcnIGFib3ZlPyBU
aGUgbGF0dGVyIHNob3VsZCBub3QgYmUNCj4gbW9kaWZpZWQgYnkgdGhpcyBwYXRjaC4gY21kLT5y
ZXF1ZXN0LT50YWcgaXMgbW9kaWZpZWQgaG93ZXZlciBmb3IgZXZlcnkNCj4gY29tbWFuZCB0aGF0
IGlzIG5vdCBhIFRNRi4gUHJlc2VydmluZyB0aGUgYmxvY2sgbGF5ZXIgdGFnIHZhbHVlIGlzIHBv
c3NpYmxlIGJ1dA0KPiB3b3VsZCByZXF1aXJlIHRvIGludHJvZHVjZSBhIG5ldyB0YWcgc2V0IGZv
ciBUTUZzLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGksIEJhcnQNCg0KV2UgYXJl
IHVzaW5nIGxhdHRlciB2YXJpYWJsZSAndGFnJy4gIA0KV2hhdCBJIGNvbmNlcm4gaXMgdGhhdCBj
bWQtPnJlcXVlc3QtPnRhZyBhbmQgdmFyaWFibGUgdGFnKFVGUyBkcml2ZXIgdXNlcyB0aGlzIHZh
cmlhYmxlIHRhZykNCmFyZSBjb25zaXN0ZW50IHdpdGhvdXQgdGhpcyBwYXRjaCwgYW5kIG5vdyB3
ZSBzaG91bGQgY2hhbmdlIG91ciB0YWcgdHJhY2tpbmcgaGFuZGxpbmcgbWVjaGFuaXNtLg0KQnV0
IGl0IGlzIG5vdCBiaWcgZGVhbCwgd2UgY2FuIHBsdXMgaGJhLT5udXRtcnMgc3VidHJhY3RlZCBi
ZWZvcmUgIGluIG9yZGVyIHRvIGluIGxpbmUgd2l0aCBibG9jay9zY3NpIHRhZy4gDQoNClRoYW5r
cywNCg0KLy9CZWFuDQogDQoNCg==
