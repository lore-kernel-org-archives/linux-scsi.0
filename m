Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6FBC433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 05:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 111E5207EA
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 05:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="M4P0h06g";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nMi951gF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgGSFhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 01:37:13 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:22496 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgGSFhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2020 01:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595137046; x=1626673046;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=AgZ+dYS8+IkKtYyEr2C2nxeCWTYhQOvk4t//GztqecU=;
  b=M4P0h06gIZWneX2Rtad3cFdM53KQaAeIY2dAdR+LENKvYXBhPSU2hGbQ
   70gp/b3xI938owMfbQqq25FIlhvP5NFLJXQ/aWmmStIV1ovSlOl2i5KLe
   BWG2f4z0UmZjD0u3DheAoTm5PYM0N2GXmgB8ug62YMApl8f84YT6SFR3n
   XlggWSi76XIFB6xhtBruNXtc09bGXpA0PysBZcHT6s+g6GL28Chta9ayB
   bjp+E/M38734WNPXgIO+6RXpq0acpccjSdyRNv6mL0eHtblD9XlRpWvRr
   6s/YOVaNHgPOdOF/23S18qr6tRxFlQWOm8DT+unOSW7KMH9ArXqc+KzSp
   w==;
IronPort-SDR: 7+OdMrmHddaY+/cMVUZDFs1HwUu8KpTeN7WfwpEueDkYx6qJvaAULRCLS/ve78RSS8yqhL2fsR
 8q2QkNYP36hGYFQygXUVaJ81I5PtzCEUjBaekuEOhw3dHe5IOtH5gvrJl7zZWSHfdSOuzj90ez
 KsY/ha4OvmyVUA1YKKLUv39JRQwyXrY+NSMT/Hj1uXoDC+8lhC51HU7Gw7GcEfkMgAKRFGyG6O
 R5fRtZba5MdebCk2sVaOu1YCuxi9VNiL3t9ic8HdlRyDV2TPdNF/ZJGT60OLXpvl2lKpo3LBka
 +qc=
X-IronPort-AV: E=Sophos;i="5.75,369,1589212800"; 
   d="scan'208";a="245860315"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2020 13:37:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZjhCxFTMMYdY21PW07buONCkU71ZeJ2zJkBoGVU0huxwUUuPlpB67kvHQDfQ6Y7p4enqCDpeqFoh5KBEajFZrphXUYAUPlQeh4pNJnS+mCY+ZSDkqgmrqZENanZbr78tfwQaK3aD6+UIbnoI6RaIK1EI/Azo+KsebGJnzti1IrSzvw1vETGmidsZs2aOPPEVAdWpyhFmwvWM3+gVYR7V2suX0zBNoYzRHmHJYrAxj2f0aTIJvgtZscQiSruEKAfwIGQBJVf7alsL4yiWBUefNmol/Kwlc4gMTOEK9KN5NBzhx2Glfb8q7OwISwR0Jd/w7+JSSlzXd2XQ1PpnbPmMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgZ+dYS8+IkKtYyEr2C2nxeCWTYhQOvk4t//GztqecU=;
 b=LlMSQO74GOYMB6HZ3a8AArr8OIu1zx125RPY49AwLVlAo10l87RtTfh1bwxERrGtTVXOfvla9kYGTdp2mJXKwWTUUopQAENIB3O94oCzAeoFizUG4N5gSsYmkFlKD1dspxdVhrfy56kk4BqKRwdXz95y3Gvjh+d/IjSh+j6xQEC9pSkRq1xaFSyWnmzYI1UWQ9SFWRj94qCyc3tj+969LYVm60UCn7SSlIvJFkoUVqCQzqskd6Baa0vJaUM8afSsdvjwmk6Wlh5g9SLbQb3947eluOdNaK3dK5TBajAfWCA6dfFCVAQTkvCocijVywbqjXW8e+li6DuoJhTPw5FlwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgZ+dYS8+IkKtYyEr2C2nxeCWTYhQOvk4t//GztqecU=;
 b=nMi951gF+QLahHoe5rcV3+tHidw6Pi/LcRraVCkGYGlatwYD6gLH4zoDPeEyzZzcWvRhmcv3uDlyRNj4N5VNU/kdLXD+hmt9Err9QEpQWO2zVFcmNuwk/J5Fwn4qOcW3aS2EzShnf0BqoyVlTylSko/BVwQrgkHk0pbQhmGjtV0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5040.namprd04.prod.outlook.com (2603:10b6:805:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Sun, 19 Jul
 2020 05:37:06 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3195.023; Sun, 19 Jul 2020
 05:37:06 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [PATCH v6 3/3] ufs: exynos: implement dbg_register_dump
Thread-Topic: [PATCH v6 3/3] ufs: exynos: implement dbg_register_dump
Thread-Index: AQHWWnxIRw5+zpXfx0mra5VtLMZoTqkOaBLw
Date:   Sun, 19 Jul 2020 05:37:06 +0000
Message-ID: <SN6PR04MB4640C1B7C9E1560EA1C18935FC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1594798514.git.kwmad.kim@samsung.com>
        <CGME20200715074759epcas2p2a2046f8fc8548601d644089c141ab7cd@epcas2p2.samsung.com>
 <a8ae2f2c4c9a2422ffb2318d7bb92e21154d6cf1.1594798514.git.kwmad.kim@samsung.com>
In-Reply-To: <a8ae2f2c4c9a2422ffb2318d7bb92e21154d6cf1.1594798514.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cb79b113-8bc4-4e32-dcb9-08d82ba5c607
x-ms-traffictypediagnostic: SN6PR04MB5040:
x-microsoft-antispam-prvs: <SN6PR04MB50400E411E2E791FE12269B6FC7A0@SN6PR04MB5040.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:418;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R75jmPXlRtyRcAYlNI3OzoWGXbUm/PRsXnLkgm26cbvipFop9AYEsRWwWocX1knKcg9MMGcvFNvGeG7PDEw5oHpkKlY+swTgps4h63hhFVyJuOe5DOOabjz+xv7yebFSUKVvHjs9ka5/hpMRSmfPpD2PAWESqjxWzionY41c+m3sPRqeuEGRn+lJd336ETBgUY9Nao7UkTKq9wlODCItasEJH5MmE+cJ6X0yioas37eU+uS3b4opUZtCTIRHnUv0OWXbmLwcjyvY3ffk7uyuBsYpJGjAN4M6nhSJPed9i7HPV2EA5qD9Kkc44W9qEC0U4iM/If5WzXaZljguqoJwMqaxJOohEEEjpM6Wl9FDksMg24UUWxO12iB94EcaAgrB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(7416002)(83380400001)(8936002)(7696005)(66946007)(71200400001)(55016002)(9686003)(66476007)(64756008)(66446008)(66556008)(76116006)(52536014)(86362001)(5660300002)(2906002)(316002)(8676002)(186003)(6506007)(110136005)(478600001)(33656002)(26005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wUaZXyJPFpMukTi+a8B75XVGNBSuq2C/c5PnBYd1zEuRM2B/DTL/LUtSo5pdN676TnAQKcTZrGOzmdnWFHmgG/hUvfE045GRWHz7io4FMi2fFZwVFsqMJ5J4D24dz/aUd5xsiZNLsAvz68oylff0hvuVzhoVSmLaupKR8LNXEUs2h7ETt0wL/i/mi17wjpm9wN7q8BmUhRUACbj+Au08jESxeeJ9MywHtBcXVRPPTrl2TSdk8YplK8AtMgPGI5T82nrQYKaZAm/QoCBscWXFy3JvOln+sqTWZPClvSBX0nQOzYDA1rUxdD2N/0ga+2nb2+Ht6ZtKBdbBBTHvYXa5vI2N99wpwc430k9nAFn0WIfgjSkP06NqOnG4IkQlDjn3YbGRObgYI6twYwJhLc9m3iTGLDb15CkPTyUGi4jKCI688JaYdL3TKNwlMjzEbjvZY5k8l+ooPnRDgkRHUtpO5bUbPEGXd8h8Pzyfzy5UTLs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb79b113-8bc4-4e32-dcb9-08d82ba5c607
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2020 05:37:06.4037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bB7lyRZyBzfY860KeCX8zESApy46ggExa7h+jISJETdqI6qMFVc76PocdWRDyJf8QUppyYD2oOO4iniqP9k+RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5040
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gDQo+IEF0IHByZXNlbnQsIEkganVzdCBhZGQgY29tbWFuZCBoaXN0b3J5IHByaW50IGFu
ZA0KPiB5b3UgY2FuIGFkZCB2YXJpb3VzIHZlbmRvciByZWdpb25zLg0KPiANCj4gSSB0cmllZCB0
aGlzIHdpdGggZm9yY2UgZXJyb3IgaW5qZWN0aW9uIHRvIHZlcmlmeQ0KPiB0aGlzOg0KPiANCj4g
WyAgNDIxLjg3Njc1MV0gZXh5bm9zLXVmcyAxMzEwMDAwMC51ZnM6IDotLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gWyAgNDIxLjg3Njc2N10gZXh5
bm9zLXVmcyAxMzEwMDAwMC51ZnM6IDpceDA5XHgwOVNDU0kgQ01EKDE5MjYyKQ0KPiBbICA0MjEu
ODc2Nzc5XSBleHlub3MtdWZzIDEzMTAwMDAwLnVmczogOi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBbICA0MjEuODc2NzkzXSBleHlub3MtdWZz
IDEzMTAwMDAwLnVmczogOk9QLCBUQUcsIExCQSwgU0NULCBSRVRSSUVTLCBTVElNRSwNCj4gRVRJ
TUUsIFJFUVNceDBhDQo+IC4uLg0KPiBbICA0MjEuODc2OTc5XSBleHlub3MtdWZzIDEzMTAwMDAw
LnVmczogOiAweDJhLCAwMCwgMHgwMDEyZjFhZSwgMHgxMDAwMCwgNSwNCj4gNDE1OTc5ODM2MTQz
LCAwLCAweDANCj4gWyAgNDIxLjg3Njk5MV0gZXh5bm9zLXVmcyAxMzEwMDAwMC51ZnM6IDogMHgy
YSwgMDAsIDB4MDBmN2RkYmMsIDB4NDEwMDAwLCA1LA0KPiA0MTYyNDYyNTcxMDMsIDAsIDB4MA0K
PiBbICA0MjEuODc3MDA0XSBleHlub3MtdWZzIDEzMTAwMDAwLnVmczogOiAweDJhLCAwMSwgMHgw
MDEzMGU2MiwgMHg4MDAwMCwgNSwNCj4gNDE2MjQ2Mjk2ODM0LCAwLCAweDENCj4gWyAgNDIxLjg3
NzAxN10gZXh5bm9zLXVmcyAxMzEwMDAwMC51ZnM6IDogMHgyYSwgMDIsIDB4MDA4NTU5N2YsIDB4
NDAwMDAsIDUsDQo+IDQxNjI0NjMwOTk4OCwgMCwgMHgzDQo+IFsgIDQyMS44NzcwMzBdIGV4eW5v
cy11ZnMgMTMxMDAwMDAudWZzOiA6IDB4MmEsIDAzLCAweDAwODU1OTg1LCAweDI0MDAwMCwgNSwN
Cj4gNDE2MjQ2MzMxMzczLCAwLCAweDcNCj4gLi4uDQo+IFsgIDQyMS44NzcyMDZdIGV4eW5vcy11
ZnMgMTMxMDAwMDAudWZzOiA6IDB4MmEsIDAwLCAweDAwMTJmMWI5LCAweDEwMDAwLCA1LA0KPiA0
MTc2NzY4Mjg1OTgsIDAsIDB4MA0KPiBbICA0MjEuODc3MjE3XSBleHlub3MtdWZzIDEzMTAwMDAw
LnVmczogOiAweDJhLCAwMCwgMHgwMDEyZjFiYSwgMHgxMDAwMCwgNSwNCj4gNDE3Njc3NDYyMTM2
LCAwLCAweDANCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtpd29vbmcgS2ltIDxrd21hZC5raW1Ac2Ft
c3VuZy5jb20+DQo+IFRlc3RlZC1ieTogS2l3b29uZyBLaW0gPGt3bWFkLmtpbUBzYW1zdW5nLmNv
bT4NClJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCg==
