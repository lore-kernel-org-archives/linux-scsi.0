Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C788C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8468206E6
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="30uRFkuF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgAQNMf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:12:35 -0500
Received: from mail-co1nam11on2058.outbound.protection.outlook.com ([40.107.220.58]:10337
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbgAQNMf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jan 2020 08:12:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDxSx2Z4iqZRg6+SM9IFmwBAxCLLVU9+/G0L3DTn+9Vu1fAUDIFbcX0qSABQlYUdaUWujRKaMyPBC1ksda2xcSaqKFcnGZ1PxdeQZfSDRELSceaZqiebByD0pYaLp3ZUIFny3Qv3ex4scXAj/aSoryvGpTCuUDxUNotrrg4niEjlL7p5lW+oEIptpns0QWlnyugVKt7OrXTLzFTvWXCmksBjg+cn1IZxwGkSed52EP+pq98wE19GD3hmNxpgXgVLVmYeljxsDnReY+OErRrA+8gtPAsVO8BduHXPsf7cSTfZqqoisfqyOMHnLXrnHuMNQ8bkwNdOOqoulhi+OjffIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtzd/JY9YIm9iKcNtF+B3KFY5Xp7yhKcnxJv2MgothE=;
 b=gVc5ynYZ9pt2vStwfPCmGtmpcNAMz3iVYR7Kzcb/sgZq8KD/DW4THaaqSGoEfhGBUui9WVdMXRbwL/p/2Iitg/pUFjOTlCBzyI4Lk3bDesePUiZnoy/kiCze6pnuPLmr/JuQNNo6MYPjBHI1HNuvvtw6ndIFdgbu4f4M+wjxC6CwfIvZEZqp8TIJ09IsfmGptP9OISAYuWxmXgzvvybu4pCUqc7BL+CmgocBhxOdWnA0nKOLPf2V1+PwTtUBw9oN/1/FUkGbT1+2aUDB7t1Hm6aZO2q3AVG/HCAFlGxMXf9slRliZhT7cycypD+llYZopC5CRpJbdA82sqjLTkARwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtzd/JY9YIm9iKcNtF+B3KFY5Xp7yhKcnxJv2MgothE=;
 b=30uRFkuFFC38WWVoElrvaUXEit9JzmsN2/szCI5z/sPYkv7OhrCQiKZvtDtuTy7XkZEnUS1Zj3ryoRC5MEykXK5SVHN4VPqGW+xb6ex9OBpOVeaiAch9Ke5rj9DaEYyEoWkbn4v+pram0eJzOuJ1CDX9RUTiZ5aquiptSs3nEaM=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB6068.namprd08.prod.outlook.com (20.176.179.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Fri, 17 Jan 2020 13:12:30 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2644.021; Fri, 17 Jan 2020
 13:12:30 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>, Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 6/9] scsi: ufs: Delete is_init_prefetch from
 struct ufs_hba
Thread-Topic: [EXT] Re: [PATCH v2 6/9] scsi: ufs: Delete is_init_prefetch from
 struct ufs_hba
Thread-Index: AQHVzOqg637w2PyIckCIvV5EgEWaY6fu0a4w
Date:   Fri, 17 Jan 2020 13:12:30 +0000
Message-ID: <BN7PR08MB56848F46B73F3D9DF7E6AD3ADB310@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-7-huobean@gmail.com>
 <125ff67c-bcd5-69e7-2ec8-203b805c246b@acm.org>
In-Reply-To: <125ff67c-bcd5-69e7-2ec8-203b805c246b@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTAyMDQ4MWJjLTM5MmItMTFlYS04Yjg4LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwwMjA0ODFiZC0zOTJiLTExZWEtOGI4OC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE0NjIiIHQ9IjEzMjIzNzQwMzQ3OTA2Nzg0NCIgaD0ib0o0UUV1cnJiQVdPNUJpL21vUTRKOWRPYXFFPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b7d487d-fb1a-4c09-1827-08d79b4ee897
x-ms-traffictypediagnostic: BN7PR08MB6068:|BN7PR08MB6068:|BN7PR08MB6068:
x-microsoft-antispam-prvs: <BN7PR08MB60683CB6576324D6EFA75449DB310@BN7PR08MB6068.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(81156014)(86362001)(71200400001)(26005)(76116006)(7696005)(6506007)(8676002)(81166006)(9686003)(8936002)(110136005)(5660300002)(66556008)(316002)(66446008)(66476007)(33656002)(478600001)(7416002)(54906003)(52536014)(186003)(4326008)(64756008)(2906002)(55016002)(66946007)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB6068;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gKbEOM70ScPg96K0K1vwVDOkxgJcpu52I0srrYlnZSewEXvNP2MLsxJtNvXnJks8LD2uWrkP7jXhRfbCdXGQ4jhmJnfZNPtzHBd6bcgtrc5qt1DmJYdet3f8TKz166AoYHYfi8tMWEQxsB7jDINj/zCNigKYHVZivUgORMRL1lhB/DA/DvBqh5iIe/7l/Iga64A3lPlJRjapJOT9PW+3mhT0AtFqdvC5rfghQZrnwKfedsWjBY3x8Kvki/epffeW7JG7KZkS1Tqa9LuZYnVFS3LqVTcs1qDVclb1L0dfNzeDmPzWwu1bZCFh0fmMpt6R4e3WzgjfPpuEOTVjEH7wH+UsGeJ5H5p/q/vY03CMtYELrGsGYEwXnbYsF0uJyNu1Oa3856kawxLx8L+6ZHke0SwwtqguBUXA0CAIpmGGip8lsx7fDtgPRdeqdetF7sLDYZWWrplg3rC6qzvrbPbZsnmKDQTw+TNAaEvY9YBMwkzIIk1vC6a4NMzkEmKqvVMI
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b7d487d-fb1a-4c09-1827-08d79b4ee897
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 13:12:30.6675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9OeCQ5kV/mAQgIFBxRwRHhl1xbO43V+b14h82qh9aK/x3opGcYRMSqyjQSsCWjInhhvJxmRqL/g1k0i9tQGLtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB6068
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJhcnQNCg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+IGluZGV4IDQ0YjdjMGE0NGI4ZC4uMzFiNmUy
YTdjMTY2IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiAr
KysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gQEAgLTY5NjcsOCArNjk2Nyw3IEBA
IHN0YXRpYyBpbnQgdWZzX2x1X2FkZChzdHJ1Y3QgdWZzX2hiYSAqaGJhKSAgew0KPiA+ICAJaW50
IHJldDsNCj4gPg0KPiA+IC0JaWYgKCFoYmEtPmlzX2luaXRfcHJlZmV0Y2gpDQo+ID4gLQkJdWZz
aGNkX2luaXRfaWNjX2xldmVscyhoYmEpOw0KPiA+ICsJdWZzaGNkX2luaXRfaWNjX2xldmVscyho
YmEpOw0KPiA+DQo+ID4gIAkvKiBBZGQgcmVxdWlyZWQgd2VsbCBrbm93biBsb2dpY2FsIHVuaXRz
IHRvIHNjc2kgbWlkIGxheWVyICovDQo+ID4gIAlyZXQgPSB1ZnNoY2Rfc2NzaV9hZGRfd2x1cyho
YmEpOw0KPiA+IEBAIC02OTk0LDggKzY5OTMsNiBAQCBzdGF0aWMgaW50IHVmc19sdV9hZGQoc3Ry
dWN0IHVmc19oYmEgKmhiYSkNCj4gPiAgCXNjc2lfc2Nhbl9ob3N0KGhiYS0+aG9zdCk7DQo+ID4g
IAlwbV9ydW50aW1lX3B1dF9zeW5jKGhiYS0+ZGV2KTsNCj4gPg0KPiA+IC0JaWYgKCFoYmEtPmlz
X2luaXRfcHJlZmV0Y2gpDQo+ID4gLQkJaGJhLT5pc19pbml0X3ByZWZldGNoID0gdHJ1ZTsNCj4g
PiAgb3V0Og0KPiA+ICAJcmV0dXJuIHJldDsNCj4gPiAgfQ0KPiANCj4gVGhlIGN1cnJlbnQgY29k
ZSBjYWxscyB1ZnNoY2RfaW5pdF9pY2NfbGV2ZWxzKCkgb25jZSBwZXIgSEJBLiBUaGlzIHBhdGNo
IGNoYW5nZXMNCj4gdGhhdCBpbnRvIG9uZSBjYWxsIHBlciBMVU4uIEl0IHNlZW1zIGxpa2UgdGhl
IHBhdGNoIGRlc2NyaXB0aW9uIGNvbnRyYWRpY3RzIHRoZQ0KPiBjb2RlIEkgc2VlIGFib3ZlLg0K
PiANCk5vLCBpdCBpcyBzdGlsbCBjYWxsZWQgb25jZSBwZXIgSEJBLiAgVGhlIGN1cnJlbnQgVUZT
IGRyaXZlciBkb2Vzbid0IGhhdmUgcGVyIExVIGluaXRpYWxpemF0aW9uIHBhdGguDQpBZnRlciB0
aGlzIHBhdGNoLCB0aGUgcGF0aCBsaWtlcyB0aGlzOg0KDQp1ZnNoY2RfcGx0ZnJtX2luaXQocGRl
diwgb2ZfaWQtPmRhdGEpOw0KCXVmc2hjZF9pbml0KGhiYSwgbW1pb19iYXNlLCBpcnEpOw0KCQl1
ZnNoY2RfYXN5bmNfc2NhbigpDQoJCQl1ZnNfbHVfYWRkKCktLT51ZnNoY2RfaW5pdF9pY2NfbGV2
ZWxzKCkNCgkNCkkgc2hvdWxkIGNoYW5nZSB1ZnNfbHVfYWRkKCkgbmFtZSB0byB1ZnNfbHVzX2Fk
ZCgpLCB3aWxsIG1ha2UgaXQgY2xlYXJlci4NCg0KLy9CZWFuDQo=
