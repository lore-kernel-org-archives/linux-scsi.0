Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934E6C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 08:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38FAD23A61
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 08:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgLHIhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 03:37:10 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:12559 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgLHIhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 03:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607417219; x=1638953219;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q1DH6kRuyviLmTYp38knzwXFGKa/OX2gmvXYF9HACHo=;
  b=aH2Khs1cJ/FF4bbJcuIl/ocvqGn02yK3pmdmKTXnq89XfHNdcaOr+sFk
   baYUJT/mQ1MNiq9Cnw/j0hokKSuilS1xOWX19WALn6DiZmzjJdIsixvkN
   ybJoAAsvgqQNLvUGlyRDUnGSY6VKlno/x0jH5TNdCcn8iWiCwk2Pi0vF1
   MhVxvKgB8st/nt3dlXhEqmCvwp6ov2TvlJlaMYmm0AYQkDIok8oHJ75rD
   RcnmToMTMP0qInUpPTIxrsoa5ZnrQufec6Re7u+LC5DnE/17PvMTB8ePo
   7DSPXKB92sDxAljRNJ8pNLxuPCH7Zd9EDElA7cgbbIFX/AQSKvA782uE8
   g==;
IronPort-SDR: HyB+qzGtRsSaeD1G0y7UDw2EAKBs6pvZ1Nm2NwMj9wlftayFjYjl05JqGV/+rjGFXMR3SeM5W2
 1Hl/09Yy6shGqnxBbEahqr2zqw6hGTivTOw/+dFtC5E0kZnq00X9BYtMSefUTTO8r2HE1ijHiG
 v6oJEKjesUsk7tVIbu/vXz211BTfABg8LhW9gTj6qI3n1gQJ6S8oxn43puolx279giVV7bb31Q
 DKRghU4Is9rlatKyOj3P+MjUzmepwQTeHA1PHYBlRklAT+iIzxSvjZ9xDOVOzlSmFYcqoF9tdG
 z0s=
X-IronPort-AV: E=Sophos;i="5.78,402,1599494400"; 
   d="scan'208";a="258387568"
Received: from mail-cys01nam02lp2052.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.52])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 16:45:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjbxGnBxUxI++I5oYm7YkvBVWHWIOOHMEbH0G2h1Is20hWRJfY1dyzmpwJIjS4Bti3TB8zAC/qHxr+rd36xRwfUCeiwuODvw1r3+7zzKU5+Ce/0FWaLez6gP4mODxgat+9GzoBiGUZCOq5+OVcRtEj4+9l2l3gSrjtARix1qqE7sAS+Avah92sgC8vtfkCTmnhseP88XlQSCwszusd/l09Wai167oYEiYsTrrib1u9t0ywe+wRWJesnI21Rpf/Nm5C+1pPe60E2z8Fojlel4ZDhXVZarDFHSxHx+uIM8MS+YWc2ssICEOq6NW7mAoeu+AZEodkW73fZ03SJETSugDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1DH6kRuyviLmTYp38knzwXFGKa/OX2gmvXYF9HACHo=;
 b=P5DVWUijL0VSm+TL9hjjKdgvBGJ4WzW7ly0Rp60d1UJw6RGVNanWeUYXbQm49LF/ytryTUpJD4FhFdddXjJTN17fPUT2Zp7MbL1ficDYL3ApdWZwCWHMWKZoeckkI44rxCK1qnndPYHnNFhl46AVC53lCGNs7XyBpWEnysSxvW5fQq7NQZwR7ozyT9SRM8WlbfyDoKzDxFL6ve2jaTmybq+I4WvinSBBQT1wkw5UN09AprN6QpMALtMZDVxwV0weFYlhoiFJ46NpvTvaTCG+brnzgMBjitpyRs7PBtxvs7owt//22TmygvGsib5cHgl6Gb38Vh0yGiqpXF6NmErysw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1DH6kRuyviLmTYp38knzwXFGKa/OX2gmvXYF9HACHo=;
 b=DKnwiJaS/4Lk4nzitDfK7EssMd8K+mndiublIsWF58JtbY9HBPGN1nO+DAv+YkFXTmmDu2I6APIpua9JHhi7PaLnXW4rcFAQChtUEExvnrc1jCtNmsM1y+paOcXpJUs0TLSXMn8D3qr06u70f2qywmCBd7eHmJsWeCUqiJjdKCo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4425.namprd04.prod.outlook.com (2603:10b6:5:a1::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.18; Tue, 8 Dec 2020 08:35:57 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 08:35:57 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: RE: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
Thread-Topic: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
Thread-Index: AQHWy+7VP58/cpTtqkiyF4OIctzYqqnrRKJQgAA3pwCAAWEF4A==
Date:   Tue, 8 Dec 2020 08:35:57 +0000
Message-ID: <DM6PR04MB65757385EE651DBAAC468BD1FCCD0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206164226.6595-1-huobean@gmail.com>
         <20201206164226.6595-4-huobean@gmail.com>
         <DM6PR04MB6575197B8626D3F91C9231C4FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
 <c4333f6ad6172d991f6afdaea3698c75fb0f7c36.camel@gmail.com>
In-Reply-To: <c4333f6ad6172d991f6afdaea3698c75fb0f7c36.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 597fa360-f4ad-45d7-66d7-08d89b5448cb
x-ms-traffictypediagnostic: DM6PR04MB4425:
x-microsoft-antispam-prvs: <DM6PR04MB4425AD1198C24A65F806F455FCCD0@DM6PR04MB4425.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IWJfVJsGEtMi5UnM7fo+WR24RrGK56lE2B4Ikn2Qb1xrG26Ays1P3FfqA3p0b8+kfQ4oVv+N5T1EIre1qHHY65ePtj6GOUW4v3Rs5xRdEJLpL6qI0DDRUIIA47Lp70HMdnntJvsatDqOWk8i8x55LqCXtAyQXncGTJVoRuzNZbmVBL4DQNyYisMnEdv+BOc18OmgjWtc9EAApB80ftivRbu+JSoIytpt6xZkIAQCEVrNJ0hOGT1Wl3ulRxb32sIrs1yROzO5dYiXPK+Z5H0kjNFfuBLaTQnsppcCsSwx/EnKIDgAYZssXZegAIOp+IPY833M4rVbWQbJ6ceLDgbeX79W9S7nXjBRvuLBkOkyuuL1bzMCm0VF7Dz2mGTC29I8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(64756008)(26005)(71200400001)(55016002)(7696005)(478600001)(83380400001)(110136005)(7416002)(2906002)(66446008)(76116006)(4326008)(86362001)(186003)(9686003)(33656002)(8676002)(8936002)(66556008)(52536014)(6506007)(66476007)(66946007)(921005)(54906003)(5660300002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Q004cFJtQUg1MTdUWGQ0a1A2ZFRXQXd4SUo2Wld4dkRGeUtKOEFzZ1N4VW1E?=
 =?utf-8?B?OUVWNmFoUEM1R1BNU290OCt6RDFyZWh0T25HeEhwQXd1RzFNT0kvZGgzV3I4?=
 =?utf-8?B?Mno0eXlPVzhOMFUzN1hqR3liMVhjMXh3Y3hxR21UdU1wcmpmMnFuVlVWeFRa?=
 =?utf-8?B?Nml4ejJUMkZTWmlWSE1EQjdLNUcxR01kaFZHdHlFV0VDWEtvazdDamFVREdi?=
 =?utf-8?B?WFU1TWViTzltTVVNRUpUcjcrYTAxSSt3U0N2ZlJpNGxqc05RNEsyRGp1SWRm?=
 =?utf-8?B?UVFqOHRKdWtCckIxcnl0c1huSERNVGZTNDdQNkEyeTZWVWlEYmExb080Mlov?=
 =?utf-8?B?SUJVbnF4eUZUb0NPM05QZ2xnc2MyNkNPNVdXbGpkRUpVd1VhcUkvOEFPaktB?=
 =?utf-8?B?djFhSHQ3SzJudWRlK2hCNEt4dVFORlFNcmMxUnNTR3EvR3NiYkpIVXlZaTA0?=
 =?utf-8?B?WkVheW1IZ2oxbHRtaWZXczJkQ2s4cHJOK2loVVpMZjdiNnFsR1hSZE9oMTc1?=
 =?utf-8?B?VlJxa2IxQlZ0VzJwT0xNMDJlendsVUlHU3dNcGFhcWFEazF1K29MRWZMdUY3?=
 =?utf-8?B?VWVsaGF4anFUeXJsV1YrcWNnNURJZVdiWmwxZG9BdmJBTXFBSVNySzRmTVU2?=
 =?utf-8?B?amhDaDluL2pJVWlaOU4wcG8wOUNkbWIydVpZc1J2bEh3WXV2MzhpSUczdjhB?=
 =?utf-8?B?bG00YWtrclZNTk94My8rSHhibmJDWGZ2NEtzaWY1N2F1RGNGN2Jlb0REQ280?=
 =?utf-8?B?K0E1czNnQm9rTW85UEVldkZWcFBsdXVmVWVMcnpmcFVDMFZ2SXdBeldKdnZ3?=
 =?utf-8?B?RXdINTgybjVScUdyeXZadWhNWFBZZFIyYUNPKzFGS1YzVUg4Z3d6SGo3Wnd6?=
 =?utf-8?B?QnNGNE5Wbkp3OGJqWW13SEJVVmp5UDg2M2NwRE9OaUt4VFdwdFBUdzViUzR4?=
 =?utf-8?B?S0dzbmtzZzJDZ1p4ZWR5ZlZJd0dGQVJSU3NLNTZtNmFFTi9aS0NRUlBlZEdO?=
 =?utf-8?B?VXoybXp0UDFFV3E5Q2FGMmZ0UXJjUGNuNHZMeHQzWng4R0ZRV0V1bW1QVEJ2?=
 =?utf-8?B?QWtIV1FzajAxTXY4NklSNDU0T0xZaW51ZVgrb2RMTEc4U2xHQXVaVVpHbVdH?=
 =?utf-8?B?STJZSVl2Mk9SaXJhdmNDRGZrd3paMkUwcXhNSnlWVWRQTHhRdGR4aHZKMTBt?=
 =?utf-8?B?VXlJcEQrMFB0NGpZYnNTcWZwdURiQXZwUUUxeVc4U3N5cWdxbTZFRTA4RGFl?=
 =?utf-8?B?RWF0cjNEcWtOVWZEcSs3aVZtQW5aOU9yRlg5dzZldXJZN2ZxeVVGd3FyNG9x?=
 =?utf-8?Q?W6Rf8TOJk6N+c=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 597fa360-f4ad-45d7-66d7-08d89b5448cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 08:35:57.2996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RSDrradbLfSwqofbMcWtm7D2VgF+2vAigX4LqjbZRsdf/CrlVOxjxdIabHUCRClT4yt1aZlAgQ1q9BhU1Hpy6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4425
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gTW9uLCAyMDIwLTEyLTA3IGF0IDA3OjU3ICswMDAwLCBBdnJpIEFsdG1hbiB3cm90
ZToNCj4gPiA+ICAgICAgICAgIFRQX3ByaW50aygNCj4gPiA+IC0gICAgICAgICAgICAgICAiJXM6
ICVzOiBIRFI6JXMsIENEQjolcyIsDQo+ID4gPiArICAgICAgICAgICAgICAgIiVzOiAlczogSERS
OiVzLCAlczolcyIsDQo+ID4gPiAgICAgICAgICAgICAgICAgIF9fZ2V0X3N0cihzdHIpLCBfX2dl
dF9zdHIoZGV2X25hbWUpLA0KPiA+ID4gICAgICAgICAgICAgICAgICBfX3ByaW50X2hleChfX2Vu
dHJ5LT5oZHIsIHNpemVvZihfX2VudHJ5LT5oZHIpKSwNCj4gPiA+ICsgICAgICAgICAgICAgICBf
X2dldF9zdHIodHNmX3R5cGUpLA0KPiA+DQo+ID4gVGhpcyBicmVha3Mgd2hhdCBjdXJyZW50IHBh
cnNlcnMgZXhwZWN0cy4NCj4gPiBXaHkgc3RyIGlzIG5vdCBlbm91Z2ggdG8gZGlzdGluZ3Vpc2gg
YmV0d2VlbiB0aGUgY29tbWFuZD8NCj4gPg0KPiA+IFRoYW5rcywNCj4gPiBBdnJpDQo+IA0KPiBI
aSBBdnJpDQo+IFR0IGRvbmVzbid0IGJyZWFrIG9yaWdpbmFsIENEQiBwYXJzZXIuIGZvciB0aGUg
Q0RCLCBpdCBpcyBzdGlsbCB0aGUNCj4gc2FtZSBhcyBiZWZvcmUuIEhlcmUganVzdCBtYWtlIFRy
YW5zYWN0aW9uIFNwZWNpZmljIEZpZWxkcyBpbiB0aGUgVVBJVQ0KPiBwYWNrYWdlIG11Y2ggY2xl
YXJlci4NCkl0IGRvZXMgYnJlYWtzIG91ciBjdXJyZW50IHBhcnNlciB0aGF0IGV4cGVjdHMgIkNE
QjoiIGZvciBhbGwgdXBpdSB0eXBlcw0KDQo+IA0KPiBJIG1lbnRpb25lZCBpbiB0aGUgY29tbWl0
cyBtZXNzYWdlOg0KPiANCj4gVHJhbnNhY3Rpb24gU3BlY2lmaWMgRmllbGRzIChUU0YpIGluIHRo
ZSBVUElVIHBhY2thZ2UgY291bGQgYmUgQ0RCDQo+IChTQ1NJL1VGUyBDb21tYW5kIERlc2NyaXB0
b3IgQmxvY2spLCBPU0YgKE9wY29kZSBTcGVjaWZpYyBGaWVsZCksIGFuZA0KPiBUTSBJL08gcGFy
YW1ldGVyIChUYXNrIE1hbmFnZW1lbnQgSW5wdXQvT3V0cHV0IFBhcmFtZXRlcikuIEJ1dCB3ZQ0K
PiBkaWRuJ3QgZGlmZmVyZW5jaWF0ZSB0aGVtLiB3ZSB0YWtlIGFsbCBvZiB0aGVzZSBhcyBDREIu
IFRoaXMgaXMgd3JvbmcuDQo+IA0KPiBJIHdhbnQgdG8gbWFrZSBpdCBjbGVhcmVyIGFuZCBtYWtl
IFVQSVUgdHJhY2UgaW4gbGluZSB3aXRoIHRoZSBTcGVjLg0KPiB3aGF0J3MgbW9yZSwgIGhvdyBk
byB5b3UgZmlsdGVyIE9TRiwgVE0gcGFyYW1ldGVycyB3aXRoIGN1cnJlbnQgVVBJVQ0KPiB0cmFj
ZT8geW91IHRha2UgYWxsIG9mIHRoZW0gYXMgQ0RCPyBpZiBzbywgSSB0aGluaywgaXQncyBiZXR0
ZXIgdG8NCj4gY2hhbmdlIHBhcnNlci4NCkluZGVlZCwgaXQgaXMganVzdCBhIHNtYWxsIGNoYW5n
ZSwgYnV0IGJyZWFraW5nIHVzZXItc3BhY2UgaXMgbm90IGFuIGFjY2VwdGFibGUgYXBwcm9hY2gu
DQpBbHNvLCB0aGUgdXBpdSB0cmFjZXIgd2FzIG5ldmVyIG1lYW50IHRvIGJlIGh1bWFuLXJlYWRh
YmxlOiBpdCBqdXN0IGR1bXAgdGhlIHVwaXUsDQpXaGljaCBjb250YWlucyBhbGwgdGhlIGluZm8g
cmVxdWlyZWQgdG8gcGFyc2UgaXQgYW55d2F5LA0KU28gYnJlYWtpbmcgdXNlci1zcGFjZSBqdXN0
IHRvIG1ha2luZyBpdCBtb3JlIHJlYWRhYmxlIGRvZXNuJ3QgcmVhbGx5IG1ha2Ugc2Vuc2U/DQoN
Ckxvb2tpbmcgYXQgdGhlIHByZXZpb3VzIDIgcGF0Y2hlcyBvZiB0aGlzIHNlcmllcywgSSB3YXMg
aG9waW5nIHRoYXQgeW91IHdpbGwgZG8gdGhlIHNhbWUgZm9yDQpDb21tYW5kIHVwaXUsIGFzIHdl
bGw/DQpBZ2FpbiAtIHNhbWUgY29tbWVudDogaWYgeW91IGFyZSBkb2luZyB0aGF0IG5lZWQgdG8g
Y2hhbmdlIHRoZSBzdHIgbm90IHRvIGJyZWFrIGN1cnJlbnQgcGFyc2Vycy4NCg0KVGhhbmtzLA0K
QXZyaQ0KDQoNCj4gDQo+IFRoYW5rcywNCj4gQmVhbg0KPiANCj4gDQo+IA0KPiANCj4gDQoNCg==
