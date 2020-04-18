Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194F7C38A2F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 16:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E962121D6C
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 16:04:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="beu4al1M";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kN+5Dcur"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgDRQEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 12:04:52 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:64361 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgDRQEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Apr 2020 12:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587225891; x=1618761891;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VT9asYG9+dpl6wZ6GecFzcx6XD7ODddghu32tuHgovk=;
  b=beu4al1MNKRuM6UktQZKtS/KGBMaEwpoWNZVevMuCzq+quxhTjI7nUlA
   JnhpzIBnfNvFZ73GEZRNmkxHr7DrfNTQ4JiXOWDfpCIXDu5sGx++L8u4a
   OBlaOQ5KNIEjjhCctugycKLmwkp0dcfbKZHmy3dO9f/E60744251f0xCa
   UxH4+TmZ8QJpKo+edNs+EfemVBJGwPACP7bR0xcXlAXHooWcR8Tt7lfhm
   4t1SUaioJI405rMGyKDCOgunRzOHV4wqczPi/SBXtqovowh3BSvqkZqkp
   L1OqJ2Y2d4BDm0TUDbMBQtecHS+XzyLFFC2wA9xCD47/JAipn332K9Xnq
   w==;
IronPort-SDR: NHwlOT3JApH8Oj4w6TaxWTHp3pHGgLe/ha12+IyFLE/1pZBvhkXnegCLj8Hfz/Ws1VrmCll5ba
 +7574xOH/7lpHYlpVk/L7/VFlwLv+A2gtLAR3HDyqoat6a70kDdGhOgeDGerIk4sWOHn8OYRH4
 QXh8XtZRquEMSp5f55V98ccTjTj6asb08b5IDbdrqBC8w+FRItcq9uXf+T+fxUushIOzjSNW47
 /0wUoFjJcL58DgIiotMyLLr+yHsVYq0TXQFym4qaSZSE+0kxLdKUgFovgRbbhQQQFYXeaz0J5P
 EZE=
X-IronPort-AV: E=Sophos;i="5.72,399,1580745600"; 
   d="scan'208";a="139967679"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2020 00:04:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeoJ/awOp584n7EWGviWtoP9oF6kNebsFTHnEmpHsrqhfRheZgmHtN7AUFFRCxpshUTBdFAOy7iCvaTR0rv1tk4GQv0U4J3x9MvY6e8wLuVNyLKRL/gOVPODYFVrLPlH22SXfhlsypR5pYZPxGlbsTb7HmrosE0crs2KtRIAeHQiwNLi/tk1ZGpqJM/puQSHDM5Qb5JHQWudmtdNseOFJ8C3/8ILaPiT+c6fgH3uQzdnkQQmHrFicwLVxnAUz8UTHdgNLsUBPbEy/ilBSrgSr4bBYwcRkYzWhv4sKtvgfaUoqaS5Y2cxffLj56WL09FjRDRMSZAFZySROVb+Bjfg9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VT9asYG9+dpl6wZ6GecFzcx6XD7ODddghu32tuHgovk=;
 b=gQHe+SREPkIWl14NLtWZfcXNX3BRKw1C9s2NiGEFwQonjwgBLKwy8YKeBlbdqfC4JhxMTg0U5VozctWbQevesNww9hl5Um7e35BeF4LAmTEZiMhIkJqo1fre30vBdMcz+yEhHK02OV3FSPlURZHiXZmiToW9jIPXIalHR5++czIeVnjVmuwfDeqqE+XzkYbcbjqSuIUrjBUO/Ab8GWhUk+Zlawm3Dnl19GyCFaamC6scM27A2Mk1SMADjzNhzMwBAOIBaAl5VihMVptDAAEbi4dfKD2xJcyIxPG+0mWBplg4AQTT9Pf7bQ8rJHgiCnf1QlM8vvBSaX46JNsE3wWV1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VT9asYG9+dpl6wZ6GecFzcx6XD7ODddghu32tuHgovk=;
 b=kN+5Dcur3fqON7CBYFGtXnNIUus4zo5YoRQ9JYCCfDQn/CBTLmXoeXn0UPkq63FVK723O6btvhZ4owMC/Rgc41VX26bMUHxeBN41GbxSs7NkFr5ElbRrGhkoU3wVFXwEMpTtaHx0Vf1tvAcjEK3EiPiSrxVKK1v/Iw9jGD5eqM0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5134.namprd04.prod.outlook.com (2603:10b6:805:90::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26; Sat, 18 Apr
 2020 16:04:47 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.027; Sat, 18 Apr 2020
 16:04:47 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "robh@kernel.org" <robh@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 0/10] exynos-ufs: Add support for UFS HCI
Thread-Topic: [PATCH v6 0/10] exynos-ufs: Add support for UFS HCI
Thread-Index: AQHWFONyboJhjuJWAki6eibLTJAA36h+0jPwgAAI5ICAAC8qUIAAAdbg
Date:   Sat, 18 Apr 2020 16:04:47 +0000
Message-ID: <SN6PR04MB4640E907A9A8F0709D4417D9FCD60@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200417181006epcas5p269f8c4b94e60962a0b0318ef64a65364@epcas5p2.samsung.com>
        <20200417175944.47189-1-alim.akhtar@samsung.com>
        <SN6PR04MB46402211952BC3D427AADA00FCD60@SN6PR04MB4640.namprd04.prod.outlook.com>
 <002a01d61582$72250990$566f1cb0$@samsung.com>
 <SN6PR04MB464066C386886C45202E6107FCD60@SN6PR04MB4640.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB464066C386886C45202E6107FCD60@SN6PR04MB4640.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 997d5c93-dfa0-4882-7fa0-08d7e3b237eb
x-ms-traffictypediagnostic: SN6PR04MB5134:
x-microsoft-antispam-prvs: <SN6PR04MB513446D58F7CAE1564A3B968FCD60@SN6PR04MB5134.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0377802854
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(71200400001)(66556008)(66476007)(66946007)(8936002)(64756008)(76116006)(66446008)(7416002)(186003)(5660300002)(2906002)(81156014)(8676002)(316002)(33656002)(54906003)(9686003)(55016002)(7696005)(110136005)(6506007)(53546011)(26005)(4326008)(2940100002)(478600001)(52536014)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3C+FMcceb1gQgWt54cm3x4dSpeZXao8FInPPhV2uI4pAhwKl6KmNXAyvov8CYlFP+txppBzYH/ro3XmAaZKgEA274kZf1EFykp+Q7JpUN60dUY12RJNVxjrwmG1kvwgAxV2VBkP6RbhkrliArtOgcsHtkXjjL46DxBSOkxpk4aCgf/BHl6dnbJ8ktSpq3+ym4APGr9FXetBCuCD2ZEoqJlXcBu9d5+zpVoJLvrcNIXf9A4+QL0NeJqTi/ib5c6Zth9oCtIYpwX4RZQmfhLoJdNkzXYmXrYpTzHyR8yPaLmy2IUxzAn9KEeUNnhpJBJ/VJ7M4iVcSg/mxhH/V3Srd2CqydtwbqI0myy7aClmiiMrhCnWjvhOvkxS+upVKyLnSi8m0ZAk5xfAuICD2nctVSPIayGxGfV7S/eievx+7EXBlLBbjFrxKGw4Wfpq8Ivf/
x-ms-exchange-antispam-messagedata: Uf14vXdhiL71Ou1fr1epUb4mYXxm2zZ2BkXsmfcohqKYUBfAaQloQSteQ7RuW4/rmmeqj4OnxWO0b+skJPGCWvuiKksLzVA0a8R9Lxc+QY7SET7vU+TnXTbA3t6EK4rGXLwPyb/vN3EXwGNxqipftg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 997d5c93-dfa0-4882-7fa0-08d7e3b237eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2020 16:04:47.7379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 012jZ+GclxiUjX3XM06snxtoXaFAp5gIL/2UVdYbyKroVrSShzJiU2/Kzn74lSO+3awfmozj4I2AXUT4FjJiPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5134
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXZyaSBBbHRtYW4NCj4g
U2VudDogU2F0dXJkYXksIEFwcmlsIDE4LCAyMDIwIDc6MDAgUE0NCj4gVG86IEFsaW0gQWtodGFy
IDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT47IHJvYmhAa2VybmVsLm9yZw0KPiBDYzogZGV2aWNl
dHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOw0KPiBrcnpr
QGtlcm5lbC5vcmc7IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tOyBrd21hZC5raW1Ac2Ftc3Vu
Zy5jb207DQo+IHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbTsgY2FuZ0Bjb2RlYXVyb3JhLm9yZzsg
bGludXgtc2Ftc3VuZy0NCj4gc29jQHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLWtlcm5lbEBs
aXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBT
dWJqZWN0OiBSRTogW1BBVENIIHY2IDAvMTBdIGV4eW5vcy11ZnM6IEFkZCBzdXBwb3J0IGZvciBV
RlMgSENJDQo+IA0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206
IEF2cmkgQWx0bWFuIDxBdnJpLkFsdG1hbkB3ZGMuY29tPg0KPiA+ID4gU2VudDogMTggQXByaWwg
MjAyMCAxODowOQ0KPiA+ID4gVG86IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNv
bT47IHJvYmhAa2VybmVsLm9yZw0KPiA+ID4gQ2M6IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsNCj4gPiBrcnprQGtlcm5lbC5vcmc7DQo+ID4g
PiBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsga3dtYWQua2ltQHNhbXN1bmcuY29tOw0KPiA+
ID4gc3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tOyBjYW5nQGNvZGVhdXJvcmEub3JnOyBsaW51eC1z
YW1zdW5nLQ0KPiA+ID4gc29jQHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLWtlcm5lbEBsaXN0
cy5pbmZyYWRlYWQub3JnOyBsaW51eC0NCj4gPiA+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
PiA+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggdjYgMC8xMF0gZXh5bm9zLXVmczogQWRkIHN1cHBvcnQg
Zm9yIFVGUyBIQ0kNCj4gPiA+DQo+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBUaGlzIHBhdGNoLXNl
dCBpbnRyb2R1Y2VzIFVGUyAoVW5pdmVyc2FsIEZsYXNoIFN0b3JhZ2UpIGhvc3QNCj4gPiA+ID4g
Y29udHJvbGxlciBzdXBwb3J0IGZvciBTYW1zdW5nIGZhbWlseSBTb0MuIE1vc3RseSwgaXQgY29u
c2lzdHMgb2YgVUZTDQo+ID4gPiA+IFBIWSBhbmQgaG9zdCBzcGVjaWZpYyBkcml2ZXIuDQo+ID4g
PiA+DQo+ID4gPiA+IC0gQ2hhbmdlcyBzaW5jZSB2NToNCj4gPiA+ID4gKiByZS1pbnRyb2R1Y2Ug
dmFyaW91cyBxdWlja3Mgd2hpY2ggd2FzIHJlbW92ZWQgYmVjYXVzZSBvZiBubyBkcml2ZXINCj4g
PiA+ID4gKiBjb25zdW1lciBvZiB0aG9zZSBxdWlya3MsIGluaXRpYWwgNCBwYXRjaGVzIGRvZXMg
dGhlIHNhbWUuDQo+ID4gPiBZb3UgZm9yZ290IHRvIGFkZCB0aG9zZSBxdWlya3MgdG8gdWZzX2Zp
eHVwcy4NCj4gPg0KPiA+IHVmc19maXh1cHMgYXJlIGZvciB1ZnMgX19kZXZpY2VfXyByZWxhdGVk
IHF1aXJrcywgd2hhdCBJIGhhdmUgcG9zdGVkIGFyZSBhbGwNCj4gPiBob3N0IGNvbnRyb2xsZXIg
cXVpcmtzLg0KPiBSaWdodC4NCj4gU28gd2hhdCBJIGFtIHNheWluZyBpcyB0aGF0IEkgYW0gbWlz
c2luZyB0aGUgaGJhLT5xdWlya3MgfD0NCj4gVUZTSENJX1FVSVJLXzxuZXctcXVpcms+DQo+IElu
IHVmcy1leHlub3MuYyBmb3IgZWFjaCBvbmUgb2YgdGhlIG5ldyBxdWlya3MuDQpPaCwgYnV0IHlv
dSBhZGQgdGhvc2UgaW4gcGF0Y2ggIzkgLSANCk9rLiAgR290IGl0LiAgU29ycnkgYWJvdXQgdGhl
IGNvbmZ1c2lvbi4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo=
