Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A629EC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 11:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7703920663
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 11:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mAOndCLz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bR2rDhpa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgG0L35 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:29:57 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33244 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgG0L34 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 07:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595849396; x=1627385396;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ickbac8KK+C+2HFBO/GgSdHax76noZZoo9iJgqolLj0=;
  b=mAOndCLzMImb098rAXm2N+cMpB/9XIjhE+deQZfjMZ7IbiGAl4DBHwNY
   OvgrU+Q2xDI8aI1O/iByqd9AQHL3kHObDSQIJSAiZHIv2qwi4OoAoUURm
   qejfiDpzWos7DE8zpGz9Dx/gb8LdSFLmPfQLcO9DgsarYFqm2TwL6M01c
   ga2alOiGe4Le0iJJkroG39Zk9Y1EiEf/pnxRHKnjqGFz4vsdgPuxv/Lns
   bTPhpDwWnLQEPkIdxl4absnQd3/6lcfWFys2DEzYNOVOPtFRqhd0XCta+
   kuIh4X0PNUOpMOk28dO5RgMLHt/Od2yAiRHb2tzBlnhLGUdtj02tBPtaA
   g==;
IronPort-SDR: o5O76+uSeOF9ewdlEj/Hci55JOAnsEKkxrCzK9VRyokghRd9OoD0C4WXzXimGKJokfibp10zvl
 ilUVBhBNguBQBRtt+ymscazCvY4n3tjd9qFJpfJdo6gXh3RDSuS0IxQcE2hByeAqHoIvM07POq
 a0EKNhMolKNW8OXlprLru2942bZqy3I3QU3Ho/NV22/Ca6paS3tMFQVJCihxWxIsLFAzJonCfq
 N+kErESSGpnrDoQJF0laZHeLJ79/0cj8VhrzFgNtkfL0XvulsNhZ+ju04oTK5gcmdcj4Nl2lnE
 WIU=
X-IronPort-AV: E=Sophos;i="5.75,402,1589212800"; 
   d="scan'208";a="144720877"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2020 19:29:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMPlJtRbq0/aNrAP2YbROGbPF9XjA/cShak0LFWyREjHGCJ3YdVhUbPlaSuNYcVArbK9kuTmL14YNgX51ufGChnUXgnn/gr8Im9J01HkOcZgijjDuLibzsvm35dsaRkqb4KEo+6+CAgxVKkeTyKE2QF7+vr4zEXPk12wk9uTehwaGNEpyIrSzDDVz8iFTV5jwa6r2qsO4ornNpiIU1S5SMxEMrBLgwkg/fqHMisQgiPyoPzAWIit0fqzO4tdtWtMoK+FTBG9J8bIq7XxngDtdvP46CxhXfli+cmxcv9KDQEG+Au9ctt+IJjC0DfvtiSsXaF1ROLX2D7YtoRK0z3C1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ickbac8KK+C+2HFBO/GgSdHax76noZZoo9iJgqolLj0=;
 b=lxP7OWg3LYOHzDMMO8Ozj7/nPAq0RwFg1PLfzVVMrlhRPSxZYG47D/LDSV8hePpopexxvjNazwM40g1nbYiqqFced0KxEizdTCNF4OhCk/k+QrPQg6C355/YU17iDRfkAY1An/h0e/HMhdWc2o+yACilUhqmMCyFZsJJKMPvgkStVa72wLaftcD2b/NjQ1uQkfDSsVH8xdQcWFWUxYWpXLaUo98UUV5K25XW7WjmOEmEexxN6pCt6kWlWRa8Az7HPTlb/0tu025ewwhSTVGSyOhv3sxc5l0u48mcsMmi896oB7UP8CMUpQ9Gow7AfC6op5v2qOltTgUm/XXjvfJO8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ickbac8KK+C+2HFBO/GgSdHax76noZZoo9iJgqolLj0=;
 b=bR2rDhpaWph6zXyVzjf5eG1/OLINXaZNzOIPlahuJqWCXGvyJHmnvNWKki9TD6RzgtGosnQJoporeiGYPVGJWoSkGRIuZ+BnH/+kuJU4OmlqFox1qKVH5Ajgks8jGC9JvRVGOSnzWpValFRRHWyu55blcL1zBvdtp1W8yyP/TTM=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4429.namprd04.prod.outlook.com (2603:10b6:805:37::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.27; Mon, 27 Jul
 2020 11:29:52 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 11:29:52 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     =?utf-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>
Subject: RE: [RFC PATCH v3 2/3] scsi: ufs: modify function call name When ufs
 reset and restore, need to disable write booster
Thread-Topic: [RFC PATCH v3 2/3] scsi: ufs: modify function call name When ufs
 reset and restore, need to disable write booster
Thread-Index: AQHWX0VJqBHPLYVB10GjzhrbXFF0QKkZbgDAgAHNYoCAAAKckIAAFVWAgAAAaNA=
Date:   Mon, 27 Jul 2020 11:29:52 +0000
Message-ID: <SN6PR04MB464021D20A5AE11F60F48718FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095653epcas2p4575db5cbcd8897662ad19465339128b2@epcas2p4.samsung.com>
        <52e4453499a65ad276df5af9a0f057e960704f93.1595325064.git.hy50.seo@samsung.com>
        <SN6PR04MB4640E7CB5A7F2E406323CFBAFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
        <071e01d663fc$f6bce010$e436a030$@samsung.com>
        <SN6PR04MB4640B30915D3D402B3B47F79FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
 <074001d66408$efdc5a80$cf950f80$@samsung.com>
In-Reply-To: <074001d66408$efdc5a80$cf950f80$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 05a35883-60f2-4e8f-d254-08d83220613f
x-ms-traffictypediagnostic: SN6PR04MB4429:
x-microsoft-antispam-prvs: <SN6PR04MB44293248740B7E0C1592D9A8FC720@SN6PR04MB4429.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2+f+Sw0u5WUEzn4rALXNf2fful1Lus3cXicY4fQeuBQ/EaRGrOsCNQuPny+0gHIXCU3oqf3wNU+Yh974qDaxhEJcDCYXd6b3UWx1lQzyhZAFbylmlHw40BHSfEgS48WtDY+gJ1c3S2pOZIsWNbhiNJFUcs4obbuY6AXoz02Rj9oM2+Hf8WdZQNBlFwgS81t+KtR/Yj/bOXE36Au5WeIHhvbJnJK1VTtDKKMcctKQAW081/kwiBz0cCl6FNylyg78YVH87jbO3O3JhkyGDKlBSR0hc7fJCD2ADpvYVE4G6OCm/RxwiOkabVvvk76pxdqKzRBhwJ0asytavmxuLF1jrlrFXwYLY3DNqrlz9bc2lJU+PVYLdVtSbWHMi6WPtUv6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(478600001)(55016002)(2906002)(7696005)(83380400001)(86362001)(4744005)(33656002)(66556008)(8936002)(64756008)(66446008)(9686003)(66476007)(7416002)(8676002)(110136005)(6506007)(5660300002)(186003)(316002)(52536014)(76116006)(66946007)(71200400001)(26005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uXibgjmdstARxIYZVuh9hrunsL8F9S3XRwYlhqIrVCXLSDVYEvLQRiACIS28J9nATHLV5QVcy9FHezsF8q49Z0VRFkGd6l5rj3D0pTveVfMlSyWSir71f407pUaP/axSPKuEiFyL7iApsC9vzoRbycUcz86uHU7HIdR6Xm8SQ151+N358+3Vv+OrTPkhweI9NXbIXW2AWQ+Rx/mQiN3+T7a2QcrcMVXwK/WWd+TUS5G5HTbOKAsfTuX8ryuNVLLRif9DYP9n+rUaAcZYVsNJ3/LUUkBH+XkkZTiqpxgzn1WRVEfIUN000bfKPAlOP0KNpRu6Ggt2ALupwa+iH/n6HY4m9lj1A0QrfY3DbW1iz71+5lo9WQZM9uJgARL1cK513RETq7eifGMLgrh/T9mm3wZrA4CrfUMwNUr8JUwdv4e2Pori6Yk96b7WcuT9nA8F0sLV0zX9IZFFfSwYlT6SXpsQUgsJElT6ZNdObQuYCf3AoIS3H0k5AWwvlHIBnCM7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a35883-60f2-4e8f-d254-08d83220613f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 11:29:52.3740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zNqOow+PnyiQbNeqr/05x1fhOEqHuVlfpv9x3NkX3UwCpDY0GBpMFDeqvx7JCPYOymJ+5syFzvPBMm3Ng5G45A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4429
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gPiBUaGlzIHBhdGNoIGlzIG5vdCByZWFsbHkgbmVlZGVkIC0ganVzdCBzcXVhc2ggaXQg
dG8gdGhlIHByZXZpb3VzIG9uZS4NCj4gPiA+IFdoeSB5b3Ugc2FpZCB0aGlzIHBhdGNoIGlzIG5v
dCByZWFsbHkgbmVlZGVkPw0KPiA+ID4gSSBkb24ndCB1bmRlcnN0YW5kDQo+ID4gPiBPdXIgV0Ig
ZGV2aWNlIG5lZWQgdG8gZGlzYWJsZSBXQiB3aGVuIGNhbGxlZA0KPiA+ID4gdWZzaGNkX3Jlc2V0
X2FuZF9yZXN0b3JlKCkgZnVuYy4NCj4gPiA+IFBsZWFzZSBleHBsYWluIHJlYXNvbi4NCj4gPiBU
aGlzIHBhdGNoIG9ubHkgY2hhbmdlIHRoZSBuYW1lcyBvZiBzb21lIGZ1bmN0aW9ucyBkZWZpbmVk
IGluIHRoZSBmaXJzdA0KPiA+IHBhdGNoLg0KPiA+IFNxdWFzaCBpdCB0byB0aGUgZmlyc3Qgb25l
Lg0KPiANCj4gIkFzdXRvc2ggRGFzIChhc2QpIDxhc3V0b3NoZEBjb2RlYXVyb3JhLm9yZz4iIHNh
aWQgdGhpcyBmdW5jdGlvbiBub3QNCj4gY2xlYXJseS4NCj4gU28gSSBtb2RpZnkgdGhpcyBmdW5j
dGlvbiBuYW1lLg0KPiBJIHRoaW5rIHRoaXMgbmFtZSBpcyBjbGVhciB0aGFuIHRoZSBwcmV2aW91
cyBuYW1lLg0KSSBhbSBub3QgYXJndWluZyBhYm91dCB0aGF0Lg0KQXJlIHlvdSBmYW1pbGlhciB3
aXRoIHRoZSBjb25jZXB0IG9mIHNxdWFzaD8NCg==
