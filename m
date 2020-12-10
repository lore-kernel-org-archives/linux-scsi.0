Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091A5C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 07:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B010523B97
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 07:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgLJHre (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 02:47:34 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:47372 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbgLJHre (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 02:47:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607587395; x=1639123395;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Is2wvUH9qnRbaw2drluzY/8GEebrizNvEBIpkpw4tjA=;
  b=MiWHti2Iy9JxedDaM5xeDGnxdbShSRpVoH3eYp9uf1sjn42ZaBiEs7nm
   nkZ9mz2YFKGzvueZyL5ncmjBTKtPDBABJLL/C3M1wj2oNzgi0rVsesarD
   RcnzUcBEN51QRZ4a79dD6niDM/mTmkRZueT2/FiJ6eCS9tES2Il4ilv08
   yYKonR4yPjkyCDuECDzY8eL/m8mJliWnp/nOE88d7FsUuZLuXP+F3ixme
   2NGlstDqwGekWYPk8zenUWxk0bq3kDbn0Ez2AQNMXNQAtwCZfyob29uWA
   AMRaJdP9Y+gzFcRhOXoZmpWPnXKI29DWVbzKoLUO0WSYVJT6uMihm1IwQ
   w==;
IronPort-SDR: +zI7LU6CkRgfIlMlc4irRwhM4JsldnDoijGLDiGJZLjSygKkWHqyApgRyFciAnWhNY6xdQ2tHG
 ZZNThYUX/NP6I9L6C68lpRsR+7nZwbAZVxeTkJbt5QcK/FZVNRBwIEnoWDe2Vx4wtWr9l2gIjG
 lrxHgpT8aoNrwqfd5/LqcbMwKoTqw0ixOMv4sszF5HeRSPBHN5T3pseZssRCGcnsI4uOmt4Oa7
 w5iFlgDik4CCU4sUA7M0pL+Ukk398vkGrj59bwkgQep915W416UwnB5k3ZvCcPlDDOBeWor2Z/
 4aA=
X-IronPort-AV: E=Sophos;i="5.78,407,1599494400"; 
   d="scan'208";a="258563130"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2020 16:01:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7RSA8bkAui9Go0h5Qy6u0lRWPqROwx1zOSf87CMk5TgVGsr6m4JaGO8UzTP2XJQCpbHhxd+WXnYQbU87tMKw9DU3oB1cpo9zVo/cCX+H83bslCuyeM/8w+R7r5cQsl7HXS0hh1P1HB+IjAOttufvz76IaJmNR2HHe62qlxUIpZIDA4JqOOhysse/9vhRgljG4O7C/FO9Gf8ASjv2I9YBN9w90nI1wvMBvqU52BZCTZKhjarZC0QLuDYpGstnwqKY+2+/ecVm9dWLJLYC0+fhl9Ch6186Blp61YWVe0fIDB//KcXZtzmoFlyTpWr8PSGv3Jl3RbY/wf6klucMy9cHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Is2wvUH9qnRbaw2drluzY/8GEebrizNvEBIpkpw4tjA=;
 b=hyjAli3KItbp4esYWuyZ3q4bhxO0JGq8O6/HJny0ehgedv7t+o7h9lwNhiWxMcyBFpBO6jjcRqSZxtX6jOEzVwanZUGIIwTg+zNcQ2MEBPrxJe8CBuooC0zcURiambioeenJoQXrhrEHZT4XZY78WvnbgHs5q4gjhLqu/GRgT8pF8vn+APg5lR+lxUG8i9oT5DrFW5eFYaRmustizAsE1/3AwkCMVF9yyTS5H2bNby9NlTBWcCPqP3tOOsZF6fPmBeG44UWTUw9k68Kn3c4hDVDhipY+XiBgl91Dhn0MpO2IrmnXEWESSUwp/s8pGcA53XST3qKOA2yshRzcRjO31Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Is2wvUH9qnRbaw2drluzY/8GEebrizNvEBIpkpw4tjA=;
 b=MgEsXhDV+pKfu0yHdbVBgQwij8bvoruZ3yBWUfivf4yXOvRVvk5TRc5s4WG8DSeBME0dbdj2Y5qUaIC/qb10+wgetvgL785SPDhRAaBTn3dxme3sqfBYS/Y6Pvm+BlMdYSeAHp/I/sxwpC5VSWDQ/5P99YRiyTjoQ1Zy0HxANnc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6140.namprd04.prod.outlook.com (2603:10b6:5:12c::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Thu, 10 Dec 2020 07:46:25 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3654.012; Thu, 10 Dec 2020
 07:46:25 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Topic: [PATCH v3 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Index: AQHWzaZ8p0p5Ox8520exeCmeSmtzuanuYT1AgADx2oCAAJ/uYA==
Date:   Thu, 10 Dec 2020 07:46:25 +0000
Message-ID: <DM6PR04MB657504D6828919BAB731B16DFCCB0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201208210941.2177-1-huobean@gmail.com>
         <20201208210941.2177-3-huobean@gmail.com>
         <DM6PR04MB6575B928898B319E8ACF1395FCCC0@DM6PR04MB6575.namprd04.prod.outlook.com>
 <c95e0518fd5c73dead0139054c04dda2243af620.camel@gmail.com>
In-Reply-To: <c95e0518fd5c73dead0139054c04dda2243af620.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 856134fb-f200-40b7-bcb2-08d89cdfb26f
x-ms-traffictypediagnostic: DM6PR04MB6140:
x-microsoft-antispam-prvs: <DM6PR04MB6140DF90C57936391024D819FCCB0@DM6PR04MB6140.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8iY8Xf5lTTByhPtkTaZ/q3a7FfgfliSjQYRSNd4nSCGb3miAJ6QpBF8zLhFC0JikWh34+AZBGWN7TzQphCvrEH2PuMLMghy1xzOIv3kyAU2tBsr+lMoh001uWbkBpj1n5GhfSxmhSbk8nH2ImwY7ePjU6YMLw5nhdP6HlEJuHvW+yP8QNAJnUdxufIlYbf44c/5qXhxut5tFrpbadUdSExL2GyUDSR+y2i03HwAnTZM+sJNEY4hE7iuBZQWVQVN8ZzQhH+bVi3YaHV5rJjGmf6dLbFZExnfitS5Jra6Q8ZIXzpHZ6QkEwyPEF7AVOAn/x2lUbQvhqPp3giiyhNMjiYFFvQIR4tDT8t8h68eDTsjVQH5h/hEht8VD++BqOQnNt/KxHFOkWmDfxCO7+1u78hZFM6ZErmmED+4tjDHX2Js=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(6506007)(7696005)(86362001)(54906003)(55016002)(110136005)(9686003)(921005)(8676002)(76116006)(8936002)(4326008)(52536014)(508600001)(71200400001)(66476007)(66446008)(26005)(64756008)(66946007)(66556008)(7416002)(33656002)(2906002)(83380400001)(5660300002)(186003)(145543001)(213903007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QllHVFQwT0lvZUpvOTZWVnd2SU5wYXl2QlVsRE5hMUNsWkx6ZnRUbithSi96?=
 =?utf-8?B?aXFDQy83UUV5Z1lXVmlmSnNwb2swMXkwMGtWRmhQbnFOejZNcEZBeDNIRzc5?=
 =?utf-8?B?emdMRndXRi9JaHVocUFDM0xkZlBRcmZ1U0ZZNmdTTlJrbzJUb00zbzBpS0pr?=
 =?utf-8?B?Tmt0djBNQjlrOFFNdjVZajhad09yK1AzaHUvSEMwb1ZpNWhSNEVrQWpkT2xR?=
 =?utf-8?B?RCtuSStMcmpNZzh6ZEJ0QUdOUTI5TDNPaEIvVjlQM2UwV0ZGdjdKeGxGVzli?=
 =?utf-8?B?WWNqV0hhK21OeHVWOUR6VjRZenBLdzFzb05sY2d5VmxWbG9iY2NiZU5RUjN5?=
 =?utf-8?B?N0xOMWl2UWVsN05QWFA2UFMvaWdCQXgrRzhWODlGcFR1ZWxVbjJIL3ZGbGM3?=
 =?utf-8?B?RG8yU1lIK1UwL3R3ZzNMMGFtQXZuakwxNERGUEE3dnkzUWlEd3hSMU5YeXhP?=
 =?utf-8?B?L1BSMTNxN3R3b0krUWNvYlpEcWY3blEwL2VPazVxeXFucm9TZkhBQmdhYWh2?=
 =?utf-8?B?UEhRWm5GVlM0dlFJbStqTzd4NXJmeUJJQWh0RXJvOXMwQ2ppZENsVG5EMWpZ?=
 =?utf-8?B?cGxlbXBCdkZMNXIySDNzeVZpdSt4SExQUC85bDVnMDQrVGdkUnlyWXBLVFNt?=
 =?utf-8?B?SjFrajVLTWdDeU1MbGJjN3JuNkxYK1BhZkM4bWg1ZmtVTWRwSmVmWWVzNUo4?=
 =?utf-8?B?dWM0T01VdWtzaU85QjJmTWtPNS9xaDRlMGRYemd4WkREZDZzb04vY0JkQmpS?=
 =?utf-8?B?cVNwdXpaQlV5ejhNSUZWMUFRSVoyS3EvZ01GZ1JNZVN5ZjJQRG9lTFdpQ1Jr?=
 =?utf-8?B?N2pFL1MxV0JEMTJ4SHJNaHdGTUxwY3ZEREtLaG1YTHNSRW83elM3YXJUeFF4?=
 =?utf-8?B?cnp1QVRpblg3UVJpYVVOZ2paTWk0L0lINkwwS21CZlkrNm1aa0Z4bzlmUHVy?=
 =?utf-8?B?ZDBmcHRHQXJuVXNMcFFmUm9FdkdMMkFRUTk0NGNCZTNta21ZYmJlMUVXV0V4?=
 =?utf-8?B?RnBDamhIWktYb056R3Q1YUQzL1FEc1l2d2M3WllyQVZTY21sUCtwcWxNeExa?=
 =?utf-8?B?cWR3cWtld3dQdFFQSFZCano5VXBXQ29NcURvMVhsNVhhZWNzMGJtL28rMFlv?=
 =?utf-8?B?QndKK1BFYkNwRVNmWmRBOWNUVk1PemQySm11OXMweXppZ2xDNVlnWWwydG1M?=
 =?utf-8?B?QXhWUXhla205MFdIckZ6TW9CTzlKVDY5UGppMURLS1hkV0UxbURPdVlRZnV3?=
 =?utf-8?B?emF6c2VWakh4eE5wcnNTMnB5djg0Kzh5Y3VVcXhlbXdTVXkzWWtJaFh5WkNO?=
 =?utf-8?Q?xo6G7m/a2gLM4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856134fb-f200-40b7-bcb2-08d89cdfb26f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2020 07:46:25.6619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EoOq2RPLey4glrtSNljRKKM/0qkIao9wA6uoRPaDMEZ1nOEV8Y7R9dWdvwEpU8VDvDeTexR+AkH3dqyvW1u6aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiBXZWQsIDIwMjAtMTItMDkgYXQgMDc6NDAgKzAwMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0K
PiA+ID4gQWNjb3JkaW5nIHRvIHRoZSBKRURFQyBVRlMgMy4xIFNwZWMsIElmDQo+ID4gPiBmV3Jp
dGVCb29zdGVyQnVmZmVyRmx1c2hEdXJpbmdIaWJlcm5hdGUNCj4gPiA+IGlzIHNldCB0byBvbmUs
IHRoZSBkZXZpY2UgZmx1c2hlcyB0aGUgV3JpdGVCb29zdGVyIEJ1ZmZlciBkYXRhDQo+ID4gPiBh
dXRvbWF0aWNhbGx5DQo+ID4gPiB3aGVuZXZlciB0aGUgbGluayBlbnRlcnMgdGhlIGhpYmVybmF0
ZSAoSElCRVJOOCkgc3RhdGUuIFdoaWxlIHRoZQ0KPiA+ID4gZmx1c2hpbmcNCj4gPiA+IG9wZXJh
dGlvbiBpcyBpbiBwcm9ncmVzcywgdGhlIGRldmljZSBzaG91bGQgYmUga2VwdCBpbiBBY3RpdmUg
cG93ZXINCj4gPiA+IG1vZGUuDQo+ID4gPiBDdXJyZW50bHksIHdlIHNldCB0aGlzIGZsYWcgZHVy
aW5nIHRoZSBVRlNIQ0QgcHJvYmUgc3RhZ2UsIGJ1dCB3ZQ0KPiA+ID4gZGlkbid0IGRlYWwNCj4g
PiA+IHdpdGggaXRzIHByb2dyYW1taW5nIGZhaWx1cmUuIEV2ZW4gdGhpcyBmYWlsdXJlIGlzIGxl
c3MgbGlrZWx5IHRvDQo+ID4gPiBvY2N1ciwgYnV0DQo+ID4gPiBzdGlsbCBpdCBpcyBwb3NzaWJs
ZS4NCj4gPg0KPiA+IEhvdyBhYm91dCByZWFkaW5nIGl0IG9uIGV2ZXJ5IHVmc2hjZF93Yl9uZWVk
X2ZsdXNoPw0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IEF2cmkNCj4gDQo+IA0KPiBIaSBBdnJpDQo+
IEkgd2FzIHVzaW5nIHRoYXQgd2F5LCBubyBkaWZmZXJlbnQgZnJvbSB0aGUgY3VycmVudCBteSB3
YXkuIEluc3RlYWQsDQo+IHJlYWRpbmcgb24gZXZlcnkgdGltZSB3aWxsIGFkZCBzb21lIGRlbGF5
LiBBcyBsb25nIGFzIHRoZSBVRlMgZGV2aWNlDQo+IHJldHVybnMgdGhlIHN1Y2Nlc3NmdWwsIHdl
IGFzc3VtZSB0aGF0IHRoaXMgZmxhZyBoYXMgYmVlbiBwcm9wZXJseQ0KPiBzZXQuICBzbywganVz
dCBrZWVwaW5nIGlzX2hpYmVybjhfd2JfZmx1c2ggaWYgc2V0LCBJIHRoaW5rIGl0IGlzDQo+IGVu
b3VnaC4NClJpZ2h0Lg0KQnV0IGl0IGlzIGEgc21hbGwgcHJpY2UsIGFuZCB5b3Ugbm8gbG9uZ2Vy
IG5lZWQgdG8gd29ycnkgYWJvdXQgcmFyZSBlcnJvciBldmVudC4NCkFsc28gYWRkaW5nIGFuIGlm
IChmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hEdXJpbmdIaWJlcm5hdGUgPT0gMSkgd2lsbCBhbGxv
dyBzb21lIG1vcmUgZmxleGliaWxpdHksDQplLmcuIHNodXR0aW5nIGl0IG9mZiBmcm9tIHVzZXIt
c3BhY2UgKHVmcy11dGlscyksIHVubGlrZSB0b2RheSwNCnRoYXQgaXQgaXMgY2F0ZWdvcmljYWxs
eSBvbiBmb3IgYWxsIHBsYXRmb3JtcyAvIGRldmljZXMuDQoNCkFueXdheSwgaWYgeW91IGRlY2lk
ZWQgdG8gYWRkIG5ldyBjYXBhYmlsaXR5LA0KUHJlZmVyYWJsZSB0byBkbyBpdCBpbiBhIGRpZmZl
cmVudCBzZXJpZXMuDQoNClRoYW5rcywNCkF2cmkNCg==
