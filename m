Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8A6C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 10:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D799420774
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 10:53:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OIuSaTKa";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xpktw5v+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgGIKxW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 06:53:22 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:31407 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgGIKxV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 06:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594292000; x=1625828000;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=q3qSZRcEUL7f7i8kQ968sWrhxBwYxxBeTrFW1ZuLIV8=;
  b=OIuSaTKaaSAQh4ERAie6nEEXtWsDZsTnFVLVOpf1m3i52ikj2VF0XBV8
   KNx1IMGG3wOtWIPVnGjppneAj4abGzQYNy7nPQxOU0YjVlu+LEPg7IbOO
   qJ+evPfPmYsawHROp4H8/IVEHSezkhSg0Z4rVOTt47bK2dFPuj4c7utl9
   EtMhLc00OEUKyEAiHJPgYCi1yJ2yRXSveTmrsCMRw6RAqrAOdEugWYN+r
   nKbv076oYVGkVpn0Wri0qf+puP824vHk9uHIPeXjt/JRh+wNBFiGhONH4
   cBFDtAUN0aPjisUZK8TtOsiS3IO54nOgqQywKH4Q+3JPEH8WqS6rC/7ii
   Q==;
IronPort-SDR: GbxZ4kTa+MHERL7h8mpSRmNYkPozC5Ce3OCne4YK4VVocZa5J5N6Jgta8EVbYGYYFtiOEQORUz
 Q7ocUSsNwzye4QX417X4TVksSrR4s0PzkwrLZ08tPv9Ry9bOZH7lpYZiniJcPaBZc4+Jpkd7mv
 XXRBVUbVQOJPXwo+EhXqiabElOPLmH/kkL/fD6hOejlLhrrLn39t9Tn3XARvDHFqFyNrJPL7Ce
 NpvhtU27Svfg0jXDrO1wxYxDEWxBMOh/8HHVpv+9dMp8X/Z5QrGJVEAj3EO7xNGNmiP+rpE6fK
 WpU=
X-IronPort-AV: E=Sophos;i="5.75,331,1589212800"; 
   d="scan'208";a="142011261"
Received: from mail-cys01nam02lp2058.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.58])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2020 18:53:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBh5r4VtoJUrEX5Bic0PDj9Ao906KbEW0rk0sOY75HMeBv4qP6sqPi7sBuh/WtF6HlA1qIsVC1ut8kJdkTQCFtAXh+rpKhZid66Xpu5B6HPqRZIsLpZgADJZHVaWd3eZoDGg2xArhRfku6hvGONplAB9XXc7AZcI7YG5I3pUCp9XBF3fJiRbniZfX8x8fM7aMkGLAzCfFeZzqjSJEA1QVRn9RWzxtLO5xjtLRsr1HsN1kgzRDKxKNzOCo8E4oxl6QIX3XSjeRj+kySXKHSIZz0thVTvrDc+0C4PSaJdAZm7b5ycZOwrnct49bb8dxFwKeuevT2XyThGnod2jJvHNmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3qSZRcEUL7f7i8kQ968sWrhxBwYxxBeTrFW1ZuLIV8=;
 b=W5tO/R7YugdBDUDWbJwEdE5Pp2Ca86bJ5oR5mFEcqz9WzOiiNkLBfiKoCFxozqjiLxte1GlvmEKvaA3Mc3DIvkQ4kNxq5nS7BRwiHN48gnR5TEn/tjLjRm277YV4LvvxbtOp3AsqXpPrc9GMgzBDD6JwgDZKfPBKyK2VvKOuBzciyPvqgqdh57vsy0xL8SvHhMgyJuTokU46JufmY8ugsjlD+E9UkaQC2BIxApD0lYl5QsTO7wrvv3Z4IJRE4dCN04htrg5ABXoaOSV1Tl30FTzyRMc8kW920uFv3gm/3kI73TNFpFFYUPbtGXZeX/hLRdcu9RKYIHlP9OfhZ36uiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3qSZRcEUL7f7i8kQ968sWrhxBwYxxBeTrFW1ZuLIV8=;
 b=xpktw5v++yQ45AfmMmmVVoXg9DujcLCq+0MVy24+eGJRRLpkdhDHwhlyHyL/ybnrIrLUgVnetT0Xfb3+A5OVk/dpEfxayVM7GfuzQxd8/xTX0hfiWD8h/b8+OjZ2yFXlDNZklffC/laJasp+ea7wrJZyF2Kg10uHaWUzRzUMNFQ=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BY5PR04MB6833.namprd04.prod.outlook.com (2603:10b6:a03:224::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Thu, 9 Jul
 2020 10:53:16 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::40d:aa59:cf3:2386]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::40d:aa59:cf3:2386%7]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 10:53:16 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Lee Sang Hyun <sh425.lee@samsung.com>,
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
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>
Subject: RE: [RFC PATCH v1] scsi: ufs: set STATE_ERROR when ufshcd_probe_hba()
 failed
Thread-Topic: [RFC PATCH v1] scsi: ufs: set STATE_ERROR when
 ufshcd_probe_hba() failed
Thread-Index: AQHWVbpPwLXdOZamj0+zJePXLKZXiqj/Eiow
Date:   Thu, 9 Jul 2020 10:53:16 +0000
Message-ID: <BYAPR04MB462904E21565C4A8D0F8BB1FFC640@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <CGME20200709062926epcas2p1ecedcc07c6fd502a4335007418e982c2@epcas2p1.samsung.com>
 <1594275690-19896-1-git-send-email-sh425.lee@samsung.com>
In-Reply-To: <1594275690-19896-1-git-send-email-sh425.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c0d51ab5-d44d-4c2b-2bc3-08d823f648f0
x-ms-traffictypediagnostic: BY5PR04MB6833:
x-microsoft-antispam-prvs: <BY5PR04MB6833BE11325694523812B22FFC640@BY5PR04MB6833.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:565;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P09zwNPxxOiUFJpWLBYCfH2PzbjYcOO047YECMfHnvSp5BemLPCmed+DFRt/gXRWJKCr5CQofqnFWTqCJwSFMs0a8h+lippQUoGmCw4D9XIBsfHw0id2srWm3R9KRxM/2zGjOyXp7zSKnsdwBDH19E38kos8FPp8UDeLKQdWxy6iDI42bX2UIF/zXRMp7WZz1vhoR2bYSI1u+DVt1JM27EeyY1EY2nzzp7c7tzk/GtoT+qtIc7Uq8f/TCZCIG5thiucIpNlmVehC50JHveuY4SpQwlZHeerW1vDZguItKJ3lKvkQTspaJrl334v0sOkhnkwAKTFMGUa3QDmW6AoJ6acZhEXljRb1Sl9j3QzxcXt9tHbh1GlLMlGqcpGa+aBY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(2906002)(66556008)(4744005)(52536014)(66946007)(186003)(8676002)(110136005)(316002)(86362001)(8936002)(478600001)(83380400001)(7696005)(9686003)(55016002)(66476007)(64756008)(66446008)(6506007)(71200400001)(26005)(33656002)(7416002)(5660300002)(76116006)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: oUn2f9sKbUjEP0l3rCs8G5oFmrlvdqFnJeaXKUVjxH/f5I12CmmAAn86XeBrAiGUpaRbqcZosZGE7Oc3VX7jRVEUSsjsluRORlAsY8Bk2ElqPwITIMoEPWy/F8El0EyhG6e7uCMWxAHJhLr4GkzXClqu1uolvzVfRPvPjiKJcd6kSJAbQlmBuVZypMxtTBIeaK217YDSajy2J9yQo0mww4MrtPvwDtxRr5bS/BMPXBmuLcocGdUQW6kei4CUJV91QOpUVoV5Gj1Tvtua6Oh0aFJPBWNztX9UC3yeA8HR91KN2RuMrZ4Sn/ygsHJXD9WHW4ID9wThDjEVz0xxmDLVSap2P2TWFU4/0KQYa/X5/T2NwgKb6Z6Ps5iiXkOSJfIWH1sVfIuwf5AWoqXMEFcVxFDpdpTh62MwuYhuG0Yr8O19GPq8CFA1xodzEk5WQnHTTOHQXXKEB5R4UGLrf+eMauimEPU+8uC+OHBrPYvi2nyTBYqk69yf++npvPxAVvSZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4629.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d51ab5-d44d-4c2b-2bc3-08d823f648f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 10:53:16.4172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6zwF6YtW1iufarl8QaK6kdyM8XzHkZJhB28nPY07gPQLdphn7BQ1C4Knwlu0yW5LpU5vfmMXCIWdgaN1+3DcYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6833
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gc2V0IFNUQVRFX0VSUiBsaWtlIGJlbG93IHRvIHByZXZlbnQgYSBsb2NrdXAoSU8gc3R1
Y2spDQo+IHdoZW4gdWZzaGNkX3Byb2JlX2hiYSgpIHJldHVybnMgZXJyb3IuDQo+IA0KPiBDaGFu
Z2UtSWQ6IEk2Yzg1ZmYyOTA1MDNjYzk0MTRkN2Y1ZmRkOTM0Mjk1NDk3Yjg1NGZmDQo+IFNpZ25l
ZC1vZmYtYnk6IExlZSBTYW5nIEh5dW4gPHNoNDI1LmxlZUBzYW1zdW5nLmNvbT4NCj4gLS0tDQo+
ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgNSArKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQs
IDUgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IGluZGV4IGFkNGZjODIuLjk3ODBh
NWEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gKysrIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBAQCAtNzQzOSw2ICs3NDM5LDExIEBAIHN0YXRpYyBp
bnQgdWZzaGNkX3Byb2JlX2hiYShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiBib29sIGFzeW5jKQ0K
PiAgICAgICAgIHVmc2hjZF9hdXRvX2hpYmVybjhfZW5hYmxlKGhiYSk7DQo+IA0KPiAgb3V0Og0K
PiArICAgICAgIGlmIChyZXQpIHsNCj4gKyAgICAgICAgICAgICAgIHNwaW5fbG9ja19pcnFzYXZl
KGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQpJcyB0aGlzIGNvbXBpbGluZz8gdWZzaGNk
X3Byb2JlX2hiYSBoYXMgbm8gdW5zaWduZWQgbG9uZyBmbGFncyB2YXJpYWJsZS4NCg0KDQo+ICsg
ICAgICAgICAgICAgICBoYmEtPnVmc2hjZF9zdGF0ZSA9IFVGU0hDRF9TVEFURV9FUlJPUjsNCj4g
KyAgICAgICAgICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xv
Y2ssIGZsYWdzKTsNCj4gKyAgICAgICB9DQo+IA0KPiAgICAgICAgIHRyYWNlX3Vmc2hjZF9pbml0
KGRldl9uYW1lKGhiYS0+ZGV2KSwgcmV0LA0KPiAgICAgICAgICAgICAgICAga3RpbWVfdG9fdXMo
a3RpbWVfc3ViKGt0aW1lX2dldCgpLCBzdGFydCkpLA0KPiAtLQ0KPiAyLjcuNA0KDQo=
