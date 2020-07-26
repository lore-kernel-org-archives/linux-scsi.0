Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65896C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 06:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224AE20663
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 06:30:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DKpkVyZL";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cNKCWqcm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgGZGag (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 02:30:36 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:61427 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgGZGag (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2020 02:30:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595745034; x=1627281034;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ELEnD0QxH/CwVtEfXoTT9ikeTakhoRREn4mwaqR/nes=;
  b=DKpkVyZLC4vkoNsO/HKZtHVCMy1pA+lN52EF406UEjNLmCXDcD/hwm7h
   2REBmQn1fSh8ZCSI1RCR39KqPlJdF1FmCXBMaKFOwobx0Lapds8tw+Ugr
   AbCmkWWSJlT4JKRTyWm7M3kou02O9nhzWOkSIyOl7BnsRJKVHPlT2e6mI
   CfesBikasvyBmhznaQBXTcTQGrAii0cn7KZWfeCw8ogJJHtSxx5uiFCj0
   0k+yJc3ez3NCN7W1HFGjgLl7EbLS/fZa2SAOYnciia9LfD2KlDqIk9HU+
   h0rMbptQRHIrpYoJLwduHmLi5NdjVrUMz1UiZ89vI0lhCDcAonOpFU/RA
   A==;
IronPort-SDR: i+6b4n3c2XLz3U6TlW3saC3Xp2ZJXFdE+YBvgdMgkceOT/jjMftvZ5+57ZkEdd7DWnfohrCO3L
 uqNO6rXXYw7dCtFwBcGwDmVzBX960lCYrQ3QjYMqaM6T0i/5NYxcJygEgEmmQ19j/MsI5ZdOXK
 Q9f/qDnFGf5pk2h0J9jauV/nOL9nRZZu2NcdGREu/6aEYpDZ+Ho4HycnNWvJqmr9ImavQUcTCl
 HqpcGv16pgV1OGYa1EsRBt+rcqd6c5gLFelr8SGk8XIh6h1undJ5MuOQG+p2PhSXFBGvC4KYWU
 X98=
X-IronPort-AV: E=Sophos;i="5.75,397,1589212800"; 
   d="scan'208";a="143387558"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jul 2020 14:30:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFQqoEScFHlKVYFUvMVj9ouBaYSRvvgzsHXV7Cm4O/gZwAoIfQG805qrd9/Ngt06KSEm3XJQ6W++IigLjmuhIbVE3Vg4iPtu77K28yiVXvnHk5px8btqUMhXePM0Bzq8vg9l/ptvInWHXLiG9KXuUjLQjDqrOLsHr2ciNayf2HxfYmKjUbF/fZUNPyShzGjjXYY9GLSXh2QBJ+aRsxc+Q/9a/FMY7Qxn7awhSIrMvoIIU5vw7ivnLb3hpCRJnoaxIn661FuRPKHAhPfgH4VqCOzwar2hk+sQnoakQfJjSwEG/0rYSMsKMCh7UyrtdCER1eZjnPYcGlHgbHH9ZUwW6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ELEnD0QxH/CwVtEfXoTT9ikeTakhoRREn4mwaqR/nes=;
 b=YZnQB+g/fdzCdXttYLbbmxb4hBsGChO++lxYiQH5brYRceZag4QMG6h0yuGhyAcyaqy8+ZJMihiaXR2eyi0zQ4KPw0OVrHB1nZMZNu83gXWc/X0jtP8+ZR1Ti2In79Z4z98TyP2NDJdm8PtGCVOIebE4cIhIscO/WUVl+OHeVZ5HYJWK/I4v1WyCKCgal8764OU0I+v4p+Pbnrl4nniBtCRJJrfIoYaPhbCAFUwJgA6DvaNm7C+SKEA4hquUbfQpi27OWNm+VNm6OTjx0wNvxWmmbRtvWFmEdhhvarOlh/3YEY9qclK32N8eoZdvfwdGq7uAmVsCtGmPW5p24eu1ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ELEnD0QxH/CwVtEfXoTT9ikeTakhoRREn4mwaqR/nes=;
 b=cNKCWqcmhbuay/eNI+O700ak5HfH4SKGP3TcyzC5ERahfvc+LZdReunKbZmPPbNiFRPD89OyEVUUbooqiyPsqzM47y0bg3iQ/Oq6a6E8cm4hYh2+zEDf/GNEeAft96fl0RWZHB2FHH93l7J+rpp26oEGnOItQyP90kIhYws9vYQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4350.namprd04.prod.outlook.com (2603:10b6:805:3b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Sun, 26 Jul
 2020 06:30:32 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3216.030; Sun, 26 Jul 2020
 06:30:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     SEO HOYOUNG <hy50.seo@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>
Subject: RE: [RFC PATCH v3 1/3] scsi: ufs: modify write booster
Thread-Topic: [RFC PATCH v3 1/3] scsi: ufs: modify write booster
Thread-Index: AQHWX0VHDp/H9W3ONkKVkhESMJIZA6kZbLvg
Date:   Sun, 26 Jul 2020 06:30:31 +0000
Message-ID: <SN6PR04MB46406E701D8571E3A1EB5FDFFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095648epcas2p18c3d496076ecd1537e47081c19dbb97e@epcas2p1.samsung.com>
 <90ad671ed4a2b4f6035e9858153a13f7c00a1904.1595325064.git.hy50.seo@samsung.com>
In-Reply-To: <90ad671ed4a2b4f6035e9858153a13f7c00a1904.1595325064.git.hy50.seo@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d125cfbe-7b74-470d-5446-08d8312d65ac
x-ms-traffictypediagnostic: SN6PR04MB4350:
x-microsoft-antispam-prvs: <SN6PR04MB43507F4EA95CACA266A6C5ACFC750@SN6PR04MB4350.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NgBTp70aJIEKgvQGddx8FiCK/128TH8xCrb+mANy6JHE9XDGPcKlFHG3epjCxuZKo8WYYrVbk3cnPdqjhonJj9ItszwqIjWMW93oIwsIyUYT2kRvMZABPKqgsjJDqZHR5lGvAyLWuSNdiJXb8DyzexRWCvNPSxYCurVBwgdTyem9zR5p82dVQBfml2rZYk8qUzLzKnTwP3R9aTTAN/oxKaR0mZytigsi0KfAI/X1B/N9hp0pX/RBWj+ju43QUtoVbshiI1llKaia9AVjECsOHc1bJXx6zYPGQgsMD5gio4eM51Q+yuqnoAmhbnlRqE4tU+5CwmIpIHhNB0W0KOyj1lF3VY0dCRU90kY1X3kUcY6sxXndCKbZvgXO+Z8bEUi7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(39850400004)(366004)(396003)(5660300002)(7416002)(52536014)(33656002)(66556008)(66476007)(66946007)(66446008)(316002)(2906002)(55016002)(76116006)(64756008)(9686003)(86362001)(6506007)(186003)(26005)(8676002)(110136005)(8936002)(7696005)(478600001)(71200400001)(83380400001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: lRhsgKvMXQH81Wd0HHFX8gaFY33JUlr15Mf+wnvE5pNMPUYr7Dhi1lIu6LMttzT3hRAur1quxu8huaoGUsDfZORAQKFmcZZ2erOASXg/GAr830PNIkNKIvYYhM1QvTM3wE1xYcL3Cxd6GGdLCsXIfrKaQPDbVwtW16rCdHHCXfSqcNt+xztY+yr1XH5N00y700zrOUNAsFL97/06BjjKhOBHSImCy0bBGjNZbPh60XmpqOcevEbVRJ+e++GtMs4vsyPfnekVDwzlqkw9fvY8jQgk3pdSVRT9PkqO5QcTFOmh81wGha/2Pd1T5oQgBaXZIiKvgGmkLZQCK9f6oQRGZyMZdAT2q4E4kuJ1nrNZ1j+EJju4uY+3ZwYqRRgEjQZPmMVzCDjJwq+/brLE25GhLmuTPA+ilt23L9FO36QTXa6BOB9DWqHVXCGB4rR8Ae/G9ggX5xd2s6wcePQyFfaplJddPdoeKqOQj+iJ6lcSQLg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d125cfbe-7b74-470d-5446-08d8312d65ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2020 06:30:32.0937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mlmi8zqhjNHFJh3rAfjyRGXknyJGG/x8/yMEHU7sw/UXq5JEgR6AIJbUriedXGufGMdhkRN4sx5nDMMiB+JGBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4350
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBBZGQgdmVuZG9yIHNwZWNpZmljIGZ1bmN0aW9ucyBmb3IgV0INCj4gVXNlIGNhbGxiYWNr
IGFkZGl0aW9uYWwgc2V0dGluZyB3aGVuIHVzZSB3cml0ZSBib29zdGVyLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogU0VPIEhPWU9VTkcgPGh5NTAuc2VvQHNhbXN1bmcuY29tPg0KPiAtLS0NCj4gIGRy
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAyMiArKysrKysrKysrKysrKystLS0tLQ0KPiAgZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8IDQzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA2MCBpbnNlcnRpb25zKCspLCA1IGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IGluZGV4IGVmYzBhNmNiZmUyMi4uOTI2MTUxOWU3
ZTlhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gQEAgLTMzMDYsMTEgKzMzMDYsMTEgQEAgaW50IHVm
c2hjZF9yZWFkX3N0cmluZ19kZXNjKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+IHU4IGRlc2NfaW5k
ZXgsDQo+ICAgKg0KPiAgICogUmV0dXJuIDAgaW4gY2FzZSBvZiBzdWNjZXNzLCBub24temVybyBv
dGhlcndpc2UNCj4gICAqLw0KPiAtc3RhdGljIGlubGluZSBpbnQgdWZzaGNkX3JlYWRfdW5pdF9k
ZXNjX3BhcmFtKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+IC0gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBpbnQgbHVuLA0KPiAtICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgZW51bSB1bml0X2Rlc2NfcGFyYW0gcGFyYW1fb2Zmc2V0
LA0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTggKnBh
cmFtX3JlYWRfYnVmLA0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgdTMyIHBhcmFtX3NpemUpDQo+ICtpbnQgdWZzaGNkX3JlYWRfdW5pdF9kZXNjX3BhcmFt
KHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
aW50IGx1biwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBlbnVtIHVuaXRfZGVz
Y19wYXJhbSBwYXJhbV9vZmZzZXQsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
dTggKnBhcmFtX3JlYWRfYnVmLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHUz
MiBwYXJhbV9zaXplKQ0KPiAgew0KPiAgICAgICAgIC8qDQo+ICAgICAgICAgICogVW5pdCBkZXNj
cmlwdG9ycyBhcmUgb25seSBhdmFpbGFibGUgZm9yIGdlbmVyYWwgcHVycG9zZSBMVXMgKExVTiBp
ZA0KPiBAQCAtMzMyMiw2ICszMzIyLDcgQEAgc3RhdGljIGlubGluZSBpbnQNCj4gdWZzaGNkX3Jl
YWRfdW5pdF9kZXNjX3BhcmFtKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+ICAgICAgICAgcmV0dXJu
IHVmc2hjZF9yZWFkX2Rlc2NfcGFyYW0oaGJhLCBRVUVSWV9ERVNDX0lETl9VTklULCBsdW4sDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcGFyYW1fb2Zmc2V0LCBwYXJh
bV9yZWFkX2J1ZiwgcGFyYW1fc2l6ZSk7DQo+ICB9DQo+ICtFWFBPUlRfU1lNQk9MX0dQTCh1ZnNo
Y2RfcmVhZF91bml0X2Rlc2NfcGFyYW0pOw0KTGlrZSBJIGFscmVhZHkgdG9sZCB5b3UgaW4geW91
ciB2MToNCklmIHlvdSBhcmUgcmVsYXlpbmcgb24gdWZzZmVhdHVyZXMgLSB5b3UgbmVlZCB0byB3
YWl0IGZvciBpdCB0byBiZSBtZXJnZWQuDQpNZWFud2hpbGUsIGl0IGdvdCBuYWNrZWQgKG5hY2te
MiBhY3R1YWxseSksIHNvIHlvdSBuZWVkIHRvIHRha2UgdGhpcyBpbnRvIGFjY291bnQuDQoNClRo
YW5rcywNCkF2cmkNCg==
