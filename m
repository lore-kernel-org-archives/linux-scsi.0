Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7287FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 16:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0A6A2311B
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 16:35:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="C0hb9rQJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nbuN/6Sd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgHFQfM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:35:12 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:60815 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbgHFQfB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 12:35:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596731700; x=1628267700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VHA0qeH2yw2/AFVvg+W+xai59mP7Ch4SKf3p3G4a/8U=;
  b=C0hb9rQJqNg4rFoJK3BPrZMTw4+AoZAooZWYNpfO3mZXBlQytiEJHK4D
   CAutoGe0QodOidfXpDYstP+FvtwDKnz8rMnZScexWAejvkYmyn8JcrcXM
   V3KmJ2Sx+ght1XLrac+yq94wikSN+iMnXUIDhUqWxDsXuNVXt93GiKOjd
   PdfbUvm0zB77AJkUJ5vZ+sXPmRwUDIpLQZkBqPzPhaSszNfn2GDJfpWDz
   102QRiFfP/zwSyhppqOfMuzhrGLMJEPpbopf2m9e+Qgm+vWVLkKFk0tgx
   sXSdSOrGjM7iSPoKwWznkOQUqqhaUeNvci8eiN/c9x8rk88jXPllyTsgJ
   g==;
IronPort-SDR: S2graD+maO8V3MUMC6/irBlXw/+xFjLL1aXaxrc7OmODdd4R5JRnZiQzA7hCtzXbrxXnUYvkq+
 Z21iyjLJU+l4Zn4tRqSiWTDS/jjfjOfnG45Kk+lvPGdOI+Y3BbHyrUNwPEvwqHVvEIQxo/nDXg
 lbtViR/bayiX96wzcSgiU/MMNrp3WzT4IBZxOXppGe1Ne3zQHMHzR4lYpyvHz1yeakBJyqbXDA
 2geFw/Ep8PDOt8HpeHb/bUre+7tbgUsJqpgrhtVWlrFNrVyS6Nsu/pE76odadfZKJJ6jl/pm30
 2MM=
X-IronPort-AV: E=Sophos;i="5.75,441,1589212800"; 
   d="scan'208";a="148614339"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2020 21:56:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/RsLpu0vqiE20yYYlhwWwgLgCMixPpStiUT4ZClZImR5/KShmqetgVZv60K6zX4JPNPU9YU/89JWfreQVib7ztglKqvKV+dTqDuUdbM/bdw5x4eF81NUdTwNoh8scxsoMoC7n3WIXIsqG5CigahpPNDuk7EODaH3zZjXJ6/Opa+V0YAoFdF3DFVti/aC8tRi9VsVq3e4m3qaTCBe+cpm4x5pC2sDyLluziWKx+RtU00jvCUu/qoAJMmqG2x3+iNQvRIc1RlwBWUcf3g3P2pX+PHwJ4RAW3px323WhJ20PmIcBXpiK1Ma8nByXF6k4Ty2dIw8mFUleDrmSir9vZEVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHA0qeH2yw2/AFVvg+W+xai59mP7Ch4SKf3p3G4a/8U=;
 b=CBd6kIQCWPAKIQ80q27e/qYh68xRctio5ALkVyULb/QzhF3FDsobO1WbzPaJq3lkF4Y7X9aRrlTgnMcwMLAOSWJ4lFaj6Cp+4mtIvIEAiW1xdj3XmZLq5MVs2m/AZpWD/2d/Ibfii8poYXe8SLu3ooyxPCbYUT/xQ8fTWM5KgGRM0bYVeNZU/yGoWoNykdNo//MemdD/6wGZW7RRYVqe2Ey6Y55xB/uFc3KS+HDd+s8xqtSDA9ZJa7twIwwXnXBcDoL109XWEJEdQRTgYS5PvwXKhAAlBVR/MWNrKsqMajH77ebxyVuDtbu3PE85sDbTQdcp2NIc3R+D4QbMyDaAnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHA0qeH2yw2/AFVvg+W+xai59mP7Ch4SKf3p3G4a/8U=;
 b=nbuN/6SdaqUgdDxWzOEXIJ/tzKwEoRorgAk1IVJNVuPv+YR0ljZPRQoteXVVxh+CDf4TQpX9gMa2CVjZO52o0jMHzhgxVr4m0UB3z4avWtqPFa7nfTWsZZuJVJJxic8vsD7ReGARABlGc7Tdd9bF7fFJ/MO2TG01Y6BdqlWvAH8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4720.namprd04.prod.outlook.com (2603:10b6:805:b2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Thu, 6 Aug
 2020 13:56:34 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3239.022; Thu, 6 Aug 2020
 13:56:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWa8+0AqkNRErINUCUKezc5qYxwKkq1vwAgAAAvyCAAAH2AIAAATCQgAAGPQCAADW7EA==
Date:   Thu, 6 Aug 2020 13:56:34 +0000
Message-ID: <SN6PR04MB464069DD70022FC3C55265B6FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
         <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
         <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
         <SN6PR04MB4640CE297AAB3CF4D37EE002FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
         <39c546268abead68f4c00f17dc47c1597f3e0273.camel@gmail.com>
         <SN6PR04MB4640210D586CBA053F56DCF0FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
 <e3aba7fba7c208ac58c638139bd615c871d2e52e.camel@gmail.com>
In-Reply-To: <e3aba7fba7c208ac58c638139bd615c871d2e52e.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3d9560ee-e826-4b8c-a659-08d83a1087c9
x-ms-traffictypediagnostic: SN6PR04MB4720:
x-microsoft-antispam-prvs: <SN6PR04MB4720F25BA7308FFB4AACE8ABFC480@SN6PR04MB4720.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rWvYa1MNZPJaX72FUBFi8GdO6Vwr4N3TOZ6cyGA51/9jB/ep+cJU2+qztCIiaQje19ouqTzc3N3HAUKr7ZuwCm7jAu0aodSa7FiV/vSOrUv2pes0hsQwgbvFCbg3fz4xG3bmvFluqqEl3VpMtfd2LhFdsItNC0y3VRzIuhWruzU9nkPV0eqMLP/7jvc6RzJ3BQQ2qCYT3LeQS4bkNMkHH3vJK4nfjb62Z4BpcLkOQttSHMp62AV8tVY9apef0FNTSKZkRq5j+jeJ0knpbzVjATyJbvhF/k8kJcf3AtdqO9ojZflDr2/rPji18mTdJO5Y74cryQgoAK71MlUDE5+D+ExOylb7Dpyv5g3J9FDY9rjvV1SGGOzuUQj9Ms2RRmHCzGXskyLla6RhRjKDbyocXEd3AeRnGc06lmnJsCd1H/ils2kVPCPvvhEnGa5/0REN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(316002)(54906003)(8676002)(5660300002)(33656002)(9686003)(2906002)(110136005)(71200400001)(8936002)(4326008)(55016002)(66946007)(186003)(26005)(52536014)(83380400001)(966005)(478600001)(6506007)(66556008)(66446008)(76116006)(66476007)(7696005)(64756008)(7416002)(86362001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xHnkRP75LoPfqfgCa3LwSrHx6qZ2YOpXEUj06lGwqP660DsVl1SXKwXqcdrdXaX5mtkDnCGItwcpY9/fCCtT+SKGEX5wMqHXf2nNkZVWwV1cLhLhOUIGW0pSXFt8G76U0TsA3aknsY6KxLmZIrBjq2Jkc7Vxyb8/DePAk9ZHVlvofUZp6z2zHD3qtsrBmYGKjByfzn+xp50TvGb9b4DfI8sElCnrUQPu+YYNBhrrPslKP4KwB8Gla2TjtANWL4jsS48ncYwAEhdiEr/oFvwdQseRIIMqTZwYtaCOovxufyJRZydhhkD2cfqPMiUmNtTGEsAeUWk8x6BiFDgxH6Ka84MdXh/OjDj+fe2ZMNg6YIY3xM32obT0doDRQ1oP5BB+oUIordzXsgdjOQkXuDyJL0fJiUsdOKA/Yc0ld1u8wkEB3Bmcm7u1v7DAtOA9tpt3wbtOGZFXx2YPJpLxQby9mym+BnatEL3n+bsQO7RAiNgL5wpvz9OaOB1//CwPoxAjviAAaKWLP79MdIjJMVjKcXlrdqDOJI8gGCb5cfPKaZJQIUkV1dtF2QesYAyPLDCz9WGU06bAOmPrkgFyXIM6rYQ3Asiz8rVyFstq421P70NLIXwNhzDlN6S90s1X9t/GSWIVVMbyhSuhx4eZnjTQdg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9560ee-e826-4b8c-a659-08d83a1087c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2020 13:56:34.3333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6yWbxX9ej76PDiehPMh4n92KJnoIGLuk3qAFCYYi4DPdZQ5/8T1pgq9+yZ5G16X5XnrM0vxaz49h5AlbGnC65Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4720
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gT24gVGh1LCAyMDIwLTA4LTA2IGF0IDEwOjEyICswMDAwLCBBdnJpIEFsdG1hbiB3
cm90ZToNCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiB3ZSBkaWRuJ3Qgc2VlIHlvdSBBY2tlZC1ieSBp
biB0aGUgcGF0aHdvcmssIHdvdWxkIHlvdSBsaWtlIHRvIGFkZA0KPiA+ID4gdGhlbT8NCj4gPiA+
IEp1c3QgZm9yIHJlbWluZGluZyB1cyB0aGF0IHlvdSBoYXZlIGFncmVlZCB0byBtYWlubGluZSB0
aGlzIHNlcmllcw0KPiA+ID4gcGF0Y2hzZXQuDQo+ID4NCj4gPiBJIGFja2VkIGl0IC0gaHR0cHM6
Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbGludXgtc2NzaS9tc2cxNDQ2NjAuaHRtbA0KPiA+IEFu
ZCBhc2tlZCBNYXJ0aW4gdG8gbW92ZSBmb3J3YXJkIC0NCj4gPiBodHRwczovL3d3dy5zcGluaWNz
Lm5ldC9saXN0cy9saW51eC1zY3NpL21zZzE0NDczOC5odG1sDQo+ID4gV2hpY2ggaGUgZGlkLCBh
bmQgZ290IHNvbWUgc3BhcnNlIGVycm9yczoNCj4gPiBodHRwczovL3d3dy5zcGluaWNzLm5ldC9s
aXN0cy9saW51eC1zY3NpL21zZzE0NDk3Ny5odG1sDQo+ID4gV2hpY2ggSSBhc2tlZCBEYWVqdW4g
dG8gZml4IC0NCj4gPiBodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC1zY3NpL21z
ZzE0NDk4Ny5odG1sDQo+ID4NCj4gPiBGb3IgdGhlIG5leHQgY2hhaW4gb2YgZXZlbnRzIEkgZ3Vl
c3MgeW91IGNhbiBmb2xsb3cgYnkgeW91cnNlbGYuDQo+ID4NCj4gPiBUaGFua3MsDQo+ID4gQXZy
aQ0KPiANCj4gQXZyaQ0KPiBTb3JyeSBmb3IgbWFraW5nIHlvdSBjb25mdXNpbmcuIHllcywgSSBr
bmV3IHRoYXQsIGFuZCBmb2xsb3dpbmcuDQo+IEkgbWVhbiBBY2tlZC1ieSB0YWcgaW4gdGhlIHBh
dGNoc2V0LCB0aGVuIHdlIHNlZSB5b3VyIGFja2VkIGluIHRoZQ0KPiBwYXRjaHdvcmssIGFuZCBs
ZXQgb3RoZXJzIGtub3cgdGhhdCB5b3UgYWNrZWQgaXQsIHJhdGhlciB0aGFuIGdvaW5nDQo+IGJh
Y2t0cmFjayBoaXN0b3J5IGVtYWlsLg0KPiANCj4gSGkgRGFlanVuDQo+IEkgdGhpbmsgeW91IGNh
biBhZGQgQXZyaSdzIEFja2VkLWJ5IHRhZyBpbiB5b3VyIHBhdGNoc2V0LCBqdXN0IGZvcg0KPiBx
dWlja2x5IG1vdmluZyBmb3J3YXJkIGFuZCByZW1pbmRpbmcuDQpBaGhoIC0gT25lIG1vbWVudCBw
bGVhc2UgLSANCldoaWxlIHJlYmFzaW5nIHRoZSB2OCBvbiBteSBwbGF0Zm9ybSwgSSBub3RpY2Vk
IHNvbWUgc3Vic3RhbnRpYWwgY2hhbmdlcyBzaW5jZSB2Ni4NCmUuZy4gdGhlIGhwYiBsdW4gcmVm
IGNvdW50aW5nIGlzbid0IHRoZXJlIGFueW1vcmUsIGFzIHdlbGwgYXMgc29tZSBtb3JlIHN0dWZm
Lg0KV2hpbGUgdGhvc2UgY2hhbmdlcyBtaWdodCBiZSBvbmx5IGZvciB0aGUgYmVzdCwgIEkgdGhp
bmsgYW55IHRlc3RlZC1ieSB0YWcgc2hvdWxkIGJlIHJlLWFzc2lnbi4NCg0KQW55d2F5LCBhcyBm
b3IgbXlzZWxmLCBJIGFtIG5vdCBwbGFubmluZyB0byBwdXQgYW55IG1vcmUgdGltZSBpbiB0aGlz
LA0KdW50aWwgdGhlcmUgaXMgYSBjbGVhciBkZWNpc2lvbiB3aGVyZSB0aGlzIHNlcmllcyBpcyBn
b2luZyB0by4NCg0KTWFydGluIC0gQXJlIHlvdSBjb25zaWRlcmluZyB0byBtZXJnZSB0aGUgSFBC
IGZlYXR1cmUgZXZlbnR1YWxseSB0byBtYWlubGluZSBrZXJuZWw/DQoNClRoYW5rcywNCkF2cmkN
Cj4gDQo+IHRoYW5rcywNCj4gQmVhbg0KDQo=
