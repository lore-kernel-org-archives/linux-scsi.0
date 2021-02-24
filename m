Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA62CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 10:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98B5E64D79
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 10:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhBXKZU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 05:25:20 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36605 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbhBXKZR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 05:25:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614162317; x=1645698317;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6OZ355LrEN4yKN6mAH2r4p0Wkwz0HGcBWvwchga0f+Y=;
  b=IOwhLFwxtB6ss/vzsVRNERnt7FTIvjYycOcgvU2CAa+elovyg0XJ1EmG
   mcqv/5b2hvtzsWPPrz70ibDLWwen9XlxvyUkYId9R6jHxxrTffOwxSBzQ
   VJ50iWHkYohP5y7XoVWcblDMVXYXUNQK9pwDpgcD3bGQ+6dcVpQK3tRMl
   Aagpagzz7apnGF+nnZEgV54PdIwnbJUzhVlrsZnTEJTvI0rOxMLI0aWK8
   NT4sJOoD0CrovxsOAR7I9ERT3qZCuRL35DMqGXs6sAlNXbebqETuyxrtS
   PVFZtZaDNlmMv2uukoKsuxXgAifcTajMt8gHxI0dOCYAorER1CR43kzII
   A==;
IronPort-SDR: T8D4mLGienTk10DHCKSeuh5SzOMal8aA2mQ6kt0kEypbJuh1evff72ZklXEkfQ5MS5vmrnvsJx
 2yq2ECyv+XLXAei2zqrVKbW+nvBAsrtk9JIUSJYLJ1d0FZiLomN50c20lEObFSZaDdlrkzckeM
 EdgalPsi+u+4hH2U4zuHQAPEeODJJJWhhljfF2svwX+mWY2JW8+DkOAFlb4noWLYRi7H+8Gixc
 WYtfsl0qVEfQTsVKA/Ue6Eql4dHW8oKzWm3SQTBnarRSRTBR/T1Q7Bvga6O2COL3yc3vD2PU5K
 EnY=
X-IronPort-AV: E=Sophos;i="5.81,202,1610380800"; 
   d="scan'208";a="161851106"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2021 18:24:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1NWXDZM5z+WhCJ1NKlVL9EWBEtk7oa89Y8j2Z6cF8/AoT5DVC/tLe01NQhSllJwwfwnA3T1USh3ypetCSbIudOUSB9olYFK5/hd/BkhWKbICNi4rbDnpR0uUJwWi/f9pHvaaXdSsgkjFuBGSvKpas06mjlrG7qukxjaRnVVidY6b8V6rmAKnpbKzUymcEZtrPArQCLkdbEANsusraRddqUgFgBp5GRcJSbpnFMz/aNFk0Ocr/jPIJqQKwsIwkQ6LZmKEEaeS0EDj+JUr7x1fxnMdI+FMhZ1eaIBm6ODpMjLNEGuLDOp0YtM+ltHedp1cc0mOYuenl5dnxPdIJ7Cyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OZ355LrEN4yKN6mAH2r4p0Wkwz0HGcBWvwchga0f+Y=;
 b=avNTGL9JTHL0uWM+LmIrvc9qc1NEQ1V+1n9oMySYHf1doJP67/UeKeRJjcoMiaWM8Nj+AQxGidOkDlGip4d6Seb4C/jUk7nfQucx0aAHngn1jvFaVb2QvyO2CF8Ts/C4pfXYwsEMl0VY0A4rkl1r4eL2FiW8CKWqJdoxn7Faot6DS997wVwisjw9XIJEc9iBUGYoenOpWNaevvfBHzw2vR4DYukRZT5tyfvSyP1LsRwVhFxn9zzTlL58BQDDNV69OYnyeyC1fqXbHYS7O5ZWOQ4xDlEPMzoByKMTQoqQ/8Lok75T/aou1vNswwfcCNqrLHbSe132UmU1248hyHg8UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OZ355LrEN4yKN6mAH2r4p0Wkwz0HGcBWvwchga0f+Y=;
 b=A1rkPIL2rcp3lZUtqnvPCMQdXwj6DZY0KQINzh8JMLI0ucrWzjbPH195ILg9YxytZleB5gCzjFLGPwU9oRV74nE6CrTxlEUYcIHU98C8rFqzIItVaAIvFlgasbVp3L1rOewfOD0DR4I0xuSmgv92Ak1UqL9hlcAjLlHNXvIwvzs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6636.namprd04.prod.outlook.com (2603:10b6:5:24e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.32; Wed, 24 Feb 2021 10:24:07 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 10:24:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v24 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v24 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXCmlPpjVkLGqQUkG6P1vSKUTKEqpnFyBA
Date:   Wed, 24 Feb 2021 10:24:07 +0000
Message-ID: <DM6PR04MB65759C2968CDEFF32A0A95FDFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
        <CGME20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p2>
 <20210224045532epcms2p2215025506b062e2fdbad73e51563dca6@epcms2p2>
In-Reply-To: <20210224045532epcms2p2215025506b062e2fdbad73e51563dca6@epcms2p2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e4d36ca9-b94b-45a2-b99d-08d8d8ae5160
x-ms-traffictypediagnostic: DM6PR04MB6636:
x-microsoft-antispam-prvs: <DM6PR04MB6636C52AAB9E0509D6D5ADD3FC9F9@DM6PR04MB6636.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xxXC6SyXwE7GC3LMYKpUcstZJVO6izl1zU/f7NXuN2oq/dbhxFKR6BJClcTYHpp17rmHEpQ40YOKVx96pgSuqhcKVXxH4hltJUizarKigz3IylebW95Cyh+kVpkNCdzsaG7LhwGDJlaMq3KNeLuGyGx8pbo3ZJ8jkfWEHWCZaP4b3nDdc5aR36KIY7YdwKo8w9QJp+PgCe5LTXDIZlkKrNCw1+8ZWPaHF8L2E/AmRHeh1NQ5J3LYsNEG8zk8uFlu0kkd7X5Uh4XGrWjYNIKg25bbw1wtVUSZTT3yBKNMjggPCjQ8F8XM8GJHw4vRMcmNEuDuS4gs9/FTxGrhjkTauMU3868NHdxQMdg13d6JkzgMGeDFRHzLGTWN9ukgkPfUflNZOYOjl7uDgXjzc3wTxvdOgb8IT4SKuOuf+3BmY1zIsimpCIsYPJPNJYC9nX8nGf6R7UNGWk3vcZtsh1JhOaufPTswDa5s2oLD3xRuIVhYWKk1Br7S66QAXTZGO1KNNz1HwuoX03vQWWD6m4WUQC9KIXdtvV/xIZEyzSPl9JHjAEpGNw8xSEty0BcXIFdj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(33656002)(921005)(83380400001)(6506007)(54906003)(8936002)(7696005)(86362001)(316002)(71200400001)(478600001)(7416002)(52536014)(26005)(8676002)(2906002)(4744005)(5660300002)(186003)(55016002)(110136005)(4326008)(66946007)(66476007)(64756008)(66556008)(66446008)(76116006)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?R0pDZk4wdXp0RDlFelFYYU1hcnFJQlVlVE5yNlF0Z1hpcnc2SUtkdDNmUFBu?=
 =?utf-8?B?M0RlUmRJc29RQkhaZlBkOUJpRUxuOXRnSGIzNTZiczl2UG9wcDBlTmJOT3V0?=
 =?utf-8?B?bGl3NlVwcVdqL2k5UmtnMm43ZVlxcVp2VjRKQ21kcUJZN003eHBNeE9GeHFS?=
 =?utf-8?B?K3BsMTFSajVrVXBicmwxNFk4dm45amdITDl3WGFtYzBocTZ6RGFGcTl1OC83?=
 =?utf-8?B?aGdLSEg2UVZ0SXRZaTIwZHdwVGxiWkFzRHZTK3I3SXNWZnhUNjFoQk9NeGtF?=
 =?utf-8?B?L0x3SFhxT0o5SnIyckM5cG45ejlwNmErU3dDNTVZL0hDKzlPS0NNNVU0NVhM?=
 =?utf-8?B?ZUxEQm5tOG1WRWhKMmVuUWFyZnpHZ05XSUpDVWJ3THRNV1UvQzgxMG93RXZq?=
 =?utf-8?B?eFEySkFQRUZVVENuSFgwdEg3d3htV1lOUjdvbUN3T3dFUitVZ0Q3ZTE5bXlp?=
 =?utf-8?B?OUkvUmxLRTBQTHBIOHVOekI1MWlQRFZrTm01LzNQTUI4eklFT0tteFd2UXdx?=
 =?utf-8?B?OTRIY2tFUTgxMzYrQ3d0VlNyYXVHWk5CVStIRll0M2FTM3BSbUFrOExNc2FR?=
 =?utf-8?B?QkhRcXZibnJFL0hLK0lKL0x6Uk42azVqZG92Q0RHdnVuTkw1ZEJJdXJRUVpk?=
 =?utf-8?B?a0x0cUcwY2FDUTkrQ1EyMmw3dmVvUEROaWxLUFJvMU8wUXVGeVRVQjNNa2l1?=
 =?utf-8?B?YWFONDhralQvclZDZ3U0cWJqbmlzUE00djVpbks0N3ZrOG9QVmZQYUpxY3Nh?=
 =?utf-8?B?VlAxMmU5b2xpM2RRU3Q5VExtYm1XVkFZZ05RY294NmNSVGJyR2ZGcGxZbGJz?=
 =?utf-8?B?RHA2aE1MeCtFaHY3SkEvR01OZkNBdjJwa3YzRlJqUGlpWVdwVFRCZkR0alRl?=
 =?utf-8?B?VG1qRHI5THVzbTF6d3BVY2dNa2M0R0hIdUdDQ0JGanR1VmpWRUJ0QjB6bUhi?=
 =?utf-8?B?RXBaenp6ZlErZGNFODU1T2hDcFJ4UWRFOERsT2xYOXZvc01DejZ2SitrdEN4?=
 =?utf-8?B?OE0vKzZTNlE5azNDbG8yYnVDaHdGSldXRWJCREVxTitUdCtvRWhWM3FseHAw?=
 =?utf-8?B?RkkxVXBEZ2RVaGJWUExhRytodG1WSW5vcFYvYTdKTkM3YVJFSGlHbGxnRSti?=
 =?utf-8?B?Y25xQ0dUZ0x6S1FhenNFQStBdWkxZVFna1JUa1d3cWlCOUJhRWFxQ01OMXNB?=
 =?utf-8?B?am53VFpqMVAyUVBWcU5lc3MvZDBwMGFUSTVGOUc3cFgvbFpCV3N5eXptQ0JL?=
 =?utf-8?B?eDNlbHcwTEpyc2Naa2g1bUkrZXQ3dFArK1dIYXZDNFBaOXY5L2hyUzNYVkhQ?=
 =?utf-8?B?UWJoYmhEWml0MHhxcm95S1lCdzFXMG43UVVmekpSU1Y1STB3cFN4UlZLbE43?=
 =?utf-8?B?a1IzQUxzUFBEYmkyRFFFajkwa25pWmNtT0VMMkNsSmJpaGg1VHovdUtsYjJo?=
 =?utf-8?B?aHFwMDlMRXhxQXE2L0QvL1c1NGdqb3pWdDMweUU2U3RndHlheThaTlJVMXZZ?=
 =?utf-8?B?a0N4dmIrMVZBZnJhamRGZmVtT0pQb1lHaGVvV1hUY1pCSDlqOTZtbnN6UGF2?=
 =?utf-8?B?OVRRcHdwQXZzTXVSbjhmZFZaK2lnYkJ1bERCd2hmb3lRazBxcWtJSHRaeUdN?=
 =?utf-8?B?aHdhR3JyR254QU5vVEx3T3VpSFErcHFlM3hLZnBVckw4eDRrL2pSbEJzeVdH?=
 =?utf-8?B?YjRUSjJvbS9NZlBsQjFOY0h1RVVwWE4wb1Y2QVhDaytScGVOZldyejBXZGJV?=
 =?utf-8?Q?D7NoyOQm7tXopgoN9AuA64KLB+f0tcgZeH76RRx?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d36ca9-b94b-45a2-b99d-08d8d8ae5160
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 10:24:07.2933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8pXzpHoboPVl8Zrk8KkYyGZUL3h2yHbRmpz4JeupqPUQCQmKWKISOfrPYFAvyXhkBc7vIv828CHSAOcs3yJxeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6636
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICtzdGF0aWMgaW50IHVmc2hwYl9pc3N1ZV91bWFwX2FsbF9yZXEoc3RydWN0IHVmc2hwYl9s
dSAqaHBiKQ0KTWF5YmUgdWZzaHBiX2lzc3VlX3VtYXBfYWxsX3JlcSBpcyBqdXN0IGEgd3JhcHBl
ciBmb3IgdWZzaHBiX2lzc3VlX3VtYXBfcmVxPw0KZS5nIGl0IGNhbGxzIHVmc2hwYl9pc3N1ZV91
bWFwX3JlcShocGIsIGludCByZWFkX2J1ZmVycl9pZCA9IDB4MykgPw0KVGhlbiBvbiBob3N0IG1v
ZGUgaW5hY3RpdmF0aW9uOg0Kc3RhdGljIGludCB1ZnNocGJfaXNzdWVfdW1hcF9zaW5nbGVfcmVx
KHN0cnVjdCB1ZnNocGJfbHUgKmhwYikNCnsNCglyZXR1cm4gdWZzaHBiX2lzc3VlX3VtYXBfcmVx
KGhwYiwgMHgxKTsNCn0NCg0KPiBAQCAtMTY5MSw2ICsyMTgwLDcgQEAgc3RhdGljIHZvaWQgdWZz
aHBiX2hwYl9sdV9wcmVwYXJlZChzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICB1ZnNocGJfc2V0X3N0YXRlKGhwYiwgSFBCX1BSRVNFTlQpOw0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICBpZiAoKGhwYi0+bHVfcGlubmVkX2VuZCAtIGhwYi0+bHVfcGlu
bmVkX3N0YXJ0KSA+IDApDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcXVldWVf
d29yayh1ZnNocGJfd3EsICZocGItPm1hcF93b3JrKTsNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgdWZzaHBiX2lzc3VlX3VtYXBfYWxsX3JlcShocGIpOw0KSWYgKCFpc19sZWdhY3kpDQo=
