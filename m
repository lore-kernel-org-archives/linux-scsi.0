Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CB9C10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 07:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8546124673
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 07:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="led3BRO/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgCJHxN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 03:53:13 -0400
Received: from mail-dm6nam10on2041.outbound.protection.outlook.com ([40.107.93.41]:2625
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726202AbgCJHxM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 03:53:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvB8VJmbkHxzGzHO6V+ot5QRYvBvUI4LDSBLSPBaV+idbo3odnWUlkj8c39cKk54FsKb9bFVdAcmSsw+bxWxfduu7Z/Lc+6rvT9juPcTjiAChQGP2FoDENnz+FRc+D/PXXtJm9Ub47DU+pFV6GOijDO04imW0iXje2UfwtwHxmp5X8DiCsjQI68jM95Cz9BCafHTIDNWTaGqvIGF94fzzSTjIFCKq8sQmPi4Cn9RdmPoffixjae+fWFe6OTkrqrjv0iI8vR9RMRNcn1R8G01qekYpGG0VW+CaWvQFrvxKP9CY5+zLewnUQ24rUoRI7RFHSP35k26USARyYkRNb1zYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsPy290iqWCxaeYYZBjFevix6t35nCydLAwDKRBiNXo=;
 b=O0ztSVv3o5U9y3oGH909wDng1YS5d1yBoZa5JdUDWZgyuO9roEO5HsqmkVDM/d22+4tgc1nF6JU1KBJjFM8+WyI01j+H2qffFMcxH3PH9tb/sHO00cOIns81c4RvS/sootADcwJ7s7vIcMUo0U+FagjOjV3PF0UbikZ+9Un/N/8txEryOnpdYkJh+go9U/NJ5CJBOIE0fz0aeGCENUX7ybkTG1J2LMw6bzctN7NPQjMdMKgKEta7FyW9x3UQ4DxgWJ0byamg7tgdz6S/gRMTunklNxANfd8l+jKiGeIqESjdWs7nVah4gxHHxXziYSG5J1m9BYafGLRLHx/5JnMsjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsPy290iqWCxaeYYZBjFevix6t35nCydLAwDKRBiNXo=;
 b=led3BRO/KUxP3Nxe0SzkORHxxiMtdybEWD++A/p6fO1kjyJdLflPc57eUb95S74Sdpowo6PI/m7fWqGmhdLvmqqP9DukTF7zNVvByY+UcZ0a0xZvSOyzrKsxKjh+Cduwe+lp2ROnd+JPBkKA5wZbUCb55Z9tIC74RHOyUWk+mSQ=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB5089.namprd08.prod.outlook.com (2603:10b6:408:2f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14; Tue, 10 Mar
 2020 07:53:09 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135%5]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 07:53:09 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
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
Subject: RE: [EXT] Re: [PATCH v3 1/1] scsi: ufs: fix LRB pointer incorrect
 initialization issue
Thread-Topic: [EXT] Re: [PATCH v3 1/1] scsi: ufs: fix LRB pointer incorrect
 initialization issue
Thread-Index: AQHV9n9eeuH1M6BoXESDolwuE5aB9ahBcyjA
Date:   Tue, 10 Mar 2020 07:53:09 +0000
Message-ID: <BN7PR08MB5684F9667DE1CD05D0D01EE6DBFF0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200309161057.9897-1-beanhuo@micron.com>
 <20200309161057.9897-2-beanhuo@micron.com>
 <ede4addf-73c7-e5f8-5143-91eb0cd3eb9b@acm.org>
In-Reply-To: <ede4addf-73c7-e5f8-5143-91eb0cd3eb9b@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTJjNTVmMTEwLTYyYTQtMTFlYS04YjhkLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwyYzU1ZjExMS02MmE0LTExZWEtOGI4ZC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjExMDkiIHQ9IjEzMjI4MzAwMzg1NzI2MDA3MCIgaD0iZ2NJTm1EOFpjZWh5U3UrZzQ2d2RKcWhtbGRnPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFBbXpydnVzUGJWQWVPak1qL0NtMk1xNDZNeVA4S2JZeW9BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUE5cm1ud1FBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac56c3fe-1606-46fd-136f-08d7c4c8134a
x-ms-traffictypediagnostic: BN7PR08MB5089:|BN7PR08MB5089:|BN7PR08MB5089:
x-microsoft-antispam-prvs: <BN7PR08MB5089FCE8EB32F24C52211E09DBFF0@BN7PR08MB5089.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(199004)(189003)(52536014)(54906003)(9686003)(110136005)(186003)(7416002)(8676002)(86362001)(33656002)(4326008)(26005)(81166006)(81156014)(6506007)(55016002)(2906002)(5660300002)(316002)(8936002)(478600001)(66946007)(64756008)(66446008)(4744005)(71200400001)(55236004)(53546011)(76116006)(66476007)(66556008)(7696005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5089;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k6N55SbPpgHm63TKEaxtakZIcYBoUJJle7vn3FcrHCdtNPMdS0OMXYDV1gyiLRYmkrn4aGXAcgJHn91a/ECJ7ZACES9cH0bVb89Y6020sM6fmd9SqIOKavwMe4nrknrPoqAJtskBtbGbSMcpLXbzpG1lqwnJ0zZdXYWIV7SWKA6XY/J09szUrEXoo4fW1NKH7K8zTnBJBcBiHYiVEb+N+x/BBgxZe9ioiWb8yzbWOMiOD1Af2nrtEA/oeTcLQHPlhhl7rZCAzsU/q2+FEg0OIUtb28KLm+EpkkUCnd9ybdk/zGqyr5AmKJK8w3JNIZ8n7X3RnS8kBBb7S5ZT7mWUWRPTgdzncA3OIMdYSCuBuzpn7szbMaN7dpFRg8lDaEmMl+JSiw+oCjsfM8YauCrq17E874uUOmVScYXxMql5tike7ShegmFBpZFzinc3TbLYg/vJC/ElqrgT9uy7CehomUL2IKgZY/lDPlBthObBkKYd3fVYJWJu3dZ+PIYAG/zN
x-ms-exchange-antispam-messagedata: nGwpLemIqe947Jll8pST68FVQgPU8zeQ9tXW/eKCdBMJysTMNBaRjHP7KsKLmABca9d8eJoX1mb1JdJazPojthYg+g5dpGP0qNeKHHtNyl+tqhljjDqLmrGxAljnc/kXqVRAo+ntE7KHE9FGTdrkLw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac56c3fe-1606-46fd-136f-08d7c4c8134a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2020 07:53:09.1570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qmFRJigt7rjRk5g81HxTzEn05uBBGollPwErz0yU9Z+Z07g/EzsW4bL0OP6VWAMyDVE0OtKOC72qxkG1U0snhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5089
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJhcnQgDQoNCj4gU3ViamVjdDogW0VYVF0gUmU6IFtQQVRDSCB2MyAxLzFdIHNjc2k6IHVm
czogZml4IExSQiBwb2ludGVyIGluY29ycmVjdCBpbml0aWFsaXphdGlvbg0KPiBpc3N1ZQ0KPiAN
Cj4gT24gMjAyMC0wMy0wOSAwOToxMCwgaHVvYmVhbkBnbWFpbC5jb20gd3JvdGU6DQo+ID4gQEAg
LTQ4MzQsNiArNDgyOSw3IEBAIHN0YXRpYyB2b2lkIF9fdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21w
bChzdHJ1Y3QNCj4gdWZzX2hiYSAqaGJhLA0KPiA+ICAJCQljb250aW51ZTsNCj4gPiAgCQljbWQg
PSBibGtfbXFfcnFfdG9fcGR1KHJlcSk7DQo+ID4gIAkJbHJicCA9IHNjc2lfY21kX3ByaXYoY21k
KTsNCj4gPiArCQl1ZnNoY2RfaW5pdF9scmIoaGJhLCBscmJwLCBpbmRleCk7DQo+ID4gIAkJaWYg
KHVmc2hjZF9pc19zY3NpKHJlcSkpIHsNCj4gPiAgCQkJdWZzaGNkX2FkZF9jb21tYW5kX3RyYWNl
KGhiYSwgcmVxLCAiY29tcGxldGUiKTsNCj4gPiAgCQkJcmVzdWx0ID0gdWZzaGNkX3RyYW5zZmVy
X3JzcF9zdGF0dXMoaGJhLCBscmJwKTsNCj4gDQo+IFRoaXMgdWZzaGNkX2luaXRfbHJiKCkgY2Fs
bCBsb29rcyBpbmNvcnJlY3QgdG8gbWUuIEkgdGhpbmsgdGhhdA0KPiB1ZnNoY2RfaW5pdF9scmIo
KSBzaG91bGQgb25seSBiZSBjYWxsZWQgYmVmb3JlIGEgcmVxdWVzdCBpcyBzdWJtaXR0ZWQgdG8g
dGhlIFVGUw0KPiBjb250cm9sbGVyIGFuZCBhbHNvIHRoYXQgdWZzaGNkX2luaXRfbHJiKCkgc2hv
dWxkIG5vdCBiZSBjYWxsZWQgZnJvbSB0aGUNCj4gY29tcGxldGlvbiBwYXRoLg0KPiANCg0KX191
ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkNCgl1ZnNoY2RfdHJhbnNmZXJfcnNwX3N0YXR1cygp
ICB3aWxsIGFjY2VzcyBscmJwLT51Y2RfcnNwX3B0ci4NCldpdGhvdXQgY2FsbGluZyB1ZnNoY2Rf
aW5pdF9scmIoKSBoZXJlLCB0aGVyZSB3aWxsIGJlIGFuIGVycm9yLg0KDQovL0JlYW4NCg0KIA0K
PiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K
