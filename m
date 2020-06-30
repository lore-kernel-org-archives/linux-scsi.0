Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E59C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 13:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07ABA206B6
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 13:28:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bxZDM8iP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LtN13WBY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbgF3N2R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 09:28:17 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:15650 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbgF3N2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 09:28:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593523695; x=1625059695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cBED9TLHTJvpmY4niprRApGagpu0F3P5G3M+Z+1Hm5A=;
  b=bxZDM8iPN0JegkeckiNF0wRGXqjCWL+AqeReXnTu2IydkFI9OCAdt2xq
   8m2rahn6y3pjI03Qhikn9LMyaXUstf0oYVFEbRQqxykisbP7ksJ8Ptb8O
   6vLFO97oWcfhlI+euC8l0mYx330Md+yZCFS144C85+DrK8OwlB7Stn+nF
   nBEgKbF1pFp9yGfRKNJP62HkUC2UXbCcrN3SGdofjS+blUS7+VDws2NMC
   Kip2bZQhKjAg1xDjW7WqFwj9Taz7+qnIwz8p/DlG2FjBA5J8DoFrcSUn9
   M0SXTq62yOraNp3mVXz3RGgD8C81MT2fBKIWmTpxA1lwgDlIH7+OPIMoo
   w==;
IronPort-SDR: 52HC2wf+z+dmRbXujO+zkyAzLJ/pl97/QwfD5wiaA1M53bNlAv/9KxoxmhMwKALaqcIjnzyzYU
 ncdFrva5SbZVVi/xRKGB7Yo67Rg1ehHgqioILB8uTflGUua3pvwi+sgv08U7rEKqWPWZB0eNQD
 hZdOdD15qUNiBrdB7uTfJKv67gVSueDhgi6ol7Szyk3b9Arlke23sPUmfZvZBYhyBw9GgtGyXj
 N0IC7SueTkKu7xFeiZqVYSM/uxR2Jjego+BVTN7C1nRS5n+8438KEY+Edd4L7PnhP+ogl5nbSW
 bqw=
X-IronPort-AV: E=Sophos;i="5.75,297,1589212800"; 
   d="scan'208";a="141486770"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 21:28:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+99QbokkNWlN1CbUjE0eHuwBIIB/yZRFE25OQvKhRbIPG+bPavK9FjJFHIvbzy+YiRC1gMk2ynu7Y3q02kQP0DDAmsgXWjGK+gV5ckpNSjGNFzuGo9AaLa32vdloe9BrjzqQQvkE23zj7KULd6vsWUaSiXVnJGsYa/XiRGYtZHO2hm2zJrogqHqDNPTbifBiNyNrRBwzYZ18jHnNvErUvguabvGEET2NOpCOMdQogxZrwXVEcLPyLOra0+K3vo66HYKMDmppz+ZY+4HLll9ziNtlZV3vt3s67fNF3k/mhjy3ZNW4pTouKHeVPlXb/obeUR0W3CXJIKXqzDsudlGUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBED9TLHTJvpmY4niprRApGagpu0F3P5G3M+Z+1Hm5A=;
 b=lh2SdCx8YI+LzA5HNX+OjY2r168kjo6w04PkykPXD+TAcH+ztiXBzPIVIM5hLpXxPATu+sEx1LHkqrpNbNPNNiJgNR9laOwoLRQq99DBDAOFoz9cKTkKtNT7uV4m9Qk+5Jiu8cwdCnhmIpcItENhGl00XqJt5CJqvdmzeBaRBZRJvQCvjgHJsed03hkbRCM2o9KdH0iH3ecM2CYTDp379sR4WDA+3FKSWMEpRyg69ERnlvE0VyYcrkVdt1MBQQO4MTHkIajwCgWoIWWXTe0Epn/zTVpfhzH0mAOarccqBrzXcrSIsJAAbSDkiEiszVvL00uN8OB0lW7nb8dlzTFQAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBED9TLHTJvpmY4niprRApGagpu0F3P5G3M+Z+1Hm5A=;
 b=LtN13WBYB6E4rxrVGylnheQ5NBpIkMtqo/VBZRPYkxftH0LL3oKJuDEg99T02QFIm05wluHZRW8EZv0UyJzpHxtAxEC52fED/BIOi+qqCz6LfiWGDYbzjUO3TGkv9FSMEO0tp4eYhLNWeMgMc7Z9msre63MnxqODysSxDj5zrQM=
Received: from MN2PR04MB6223.namprd04.prod.outlook.com (2603:10b6:208:db::14)
 by MN2PR04MB5903.namprd04.prod.outlook.com (2603:10b6:208:a4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 30 Jun
 2020 13:28:08 +0000
Received: from MN2PR04MB6223.namprd04.prod.outlook.com
 ([fe80::899f:1d14:ad80:400e]) by MN2PR04MB6223.namprd04.prod.outlook.com
 ([fe80::899f:1d14:ad80:400e%4]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 13:28:08 +0000
From:   Matias Bjorling <Matias.Bjorling@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: RE: [PATCH 2/2] block: add BLKSETDESCZONE ioctl for Zoned Block
 Devices
Thread-Topic: [PATCH 2/2] block: add BLKSETDESCZONE ioctl for Zoned Block
 Devices
Thread-Index: AQHWTaAfmbEfcvbYB0yiyIbWbfhXOqju0CaAgAJY4WA=
Date:   Tue, 30 Jun 2020 13:28:07 +0000
Message-ID: <MN2PR04MB6223940C9DEDCEB7209FB7D2F16F0@MN2PR04MB6223.namprd04.prod.outlook.com>
References: <20200628230102.26990-1-matias.bjorling@wdc.com>
 <20200628230102.26990-3-matias.bjorling@wdc.com>
 <cbb91e7d-5cc8-eeb7-5219-b712545cb5c4@acm.org>
In-Reply-To: <cbb91e7d-5cc8-eeb7-5219-b712545cb5c4@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [185.50.194.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 638fbdca-e40e-46d1-f897-08d81cf96d63
x-ms-traffictypediagnostic: MN2PR04MB5903:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB590372493857AFCF3A957CB1F16F0@MN2PR04MB5903.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TiLa7pb8+TfxforNhRkHH78Phuq7mkvFakvB6lAu65QV/uchw+XCnklkR6EE7o/RVJzlT3laFNuqz2Zap31cuGBrFXO16paLMBYGEDOHiyKNwkgTeR2GRT7U3LOpCPJSoiX8570WtwUkgcGxSucgFztYIea+Pq3azqQaUFgfdo+17wD9BCXwAZvvXZZS4pwF35ysrBtlg3f4CMeHC6q93qQIwe48mSiTIv0lg4SRciutgch9SPBnGBxsR4PtxNUn6G26gPfMBaVMnpP0M3HFlOGqVd3JyI4ddQtHHiAp2t3flrmOPFfjs6nOomFlA5+9Z0sHnzrDEtK3/2eFj6htZZgRXR8SUiPBHWOddaRfnRryyS1SbbbZvyi++Uzu0lVp3P+2wgeSA+3V9C067zLEOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6223.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(478600001)(966005)(7696005)(316002)(2906002)(8676002)(8936002)(110136005)(7416002)(66946007)(54906003)(6506007)(6636002)(52536014)(33656002)(66476007)(76116006)(53546011)(64756008)(66446008)(5660300002)(66574015)(83380400001)(66556008)(86362001)(4326008)(9686003)(186003)(71200400001)(55016002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ZpYaF+Wo3AFSY2tk6qKLEoj/kA0P7zbLLkcR9wQK3NrMjguYq4bxtXNOlS0MZ4pwvMr2bCxjEmHnbJc5oQdRJd2kC9amAZIXRNov5ouDUC9Y2GCR0eXVs7RGDVNzILkU3rrc4ULfLZ0MJZEiPBeLDsssH2lKlZwhQZBUlbnzF0bwjJtAgk4yfygo35CBEs+op1EuvPbYyI9TJZGlfvqU/n5wlgUe3TeHpJYyNiHxJj21DIe9sIz0myOxrVrpWftvb3cPSa5eN9l7Ae855UiJjJG7vRIUVmIoPAWVBCt6eGsHmSN1KD4hTpYIify5whlWAzDv6IpZ1tgizFVFn/XoxqkQ5GWyKpzVPFb13NtqR3LySRsaMSepyhObzpb4E0hufmt8Wf1wAVusMutnYc+qXE0ZhYTmzgGv+EHrJNhoOFKDUispgdfbWeYkJHo4qVF0aLSXQQWVdKi+X3kOImuelcTshEIKgFMzwGYFP2zWEBc/UOAEh75XUKQFK2RR403x
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6223.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638fbdca-e40e-46d1-f897-08d81cf96d63
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 13:28:07.9018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4XTjrgdxMWkfPoqtgblqsAg0FO0FkVgwEjQPl/Wh1EQZh4WXtvRZUxw7bWMcBYox7eNJSa57Lm8XPYzrYyEAhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5903
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2
YW5hc3NjaGVAYWNtLm9yZz4NCj4gU2VudDogTW9uZGF5LCAyOSBKdW5lIDIwMjAgMDMuMzYNCj4g
VG86IE1hdGlhcyBCam9ybGluZyA8TWF0aWFzLkJqb3JsaW5nQHdkYy5jb20+OyBheGJvZUBrZXJu
ZWwuZGs7DQo+IGtidXNjaEBrZXJuZWwub3JnOyBoY2hAbHN0LmRlOyBzYWdpQGdyaW1iZXJnLm1l
Ow0KPiBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsgRGFtaWVuIExlIE1vYWwgPERhbWllbi5M
ZU1vYWxAd2RjLmNvbT47DQo+IE5pa2xhcyBDYXNzZWwgPE5pa2xhcy5DYXNzZWxAd2RjLmNvbT47
IEhhbnMgSG9sbWJlcmcNCj4gPEhhbnMuSG9sbWJlcmdAd2RjLmNvbT4NCj4gQ2M6IGxpbnV4LXNj
c2lAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC0N
Cj4gYmxvY2tAdmdlci5rZXJuZWwub3JnOyBsaW51eC1udm1lQGxpc3RzLmluZnJhZGVhZC5vcmcN
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCAyLzJdIGJsb2NrOiBhZGQgQkxLU0VUREVTQ1pPTkUgaW9j
dGwgZm9yIFpvbmVkIEJsb2NrDQo+IERldmljZXMNCj4gDQo+IE9uIDIwMjAtMDYtMjggMTY6MDEs
IE1hdGlhcyBCasO4cmxpbmcgd3JvdGU6DQo+ID4gKwkvKiBUaGlzIG1heSB0YWtlIGEgd2hpbGUs
IHNvIGJlIG5pY2UgdG8gb3RoZXJzICovDQo+ID4gKwljb25kX3Jlc2NoZWQoKTsNCj4gPiArDQo+
ID4gKwlyZXR1cm4gc3VibWl0X2Jpb193YWl0KCZiaW8pOw0KPiANCj4gQSBjb25kX3Jlc2NoZWQo
KSBjYWxsIGJlZm9yZSBhIHN1Ym1pdF9iaW9fd2FpdCgpIGNhbGw/IEkgdGhpbmsgaXQncyB0aGUg
Zmlyc3QgdGltZQ0KPiB0aGF0IEkgc2VlIHRoaXMuIElzIHRoYXQgY2FsbCByZWFsbHkgbmVjZXNz
YXJ5PyBJc24ndCB0aGUNCj4gd2FpdF9mb3JfY29tcGxldGlvbigpIGNhbGwgaW5zaWRlIHN1Ym1p
dF9iaW9fd2FpdCgpIHN1ZmZpY2llbnQ/DQo+IA0KDQpPbmUgY2FuJ3QgYmUgdG9vIGNhcmVmdWwg
dGhlc2UgZGF5cywgaGVoLiBJJ2xsIGZpeCBpdCB1cC4gVGhhbmtzIQ0KDQo+ID4gKwkvKiBubyBm
bGFncyBpcyBjdXJyZW50bHkgc3VwcG9ydGVkICovDQo+ICAgICAgICAgICAgICAgICAgICAgXl4N
Cj4gICAgICAgICAgICAgICAgICAgICBhcmU/DQo+IA0KPiA+ICsJLyogYWxsb2NhdGUgdGhlIHNp
emUgb2YgdGhlIHpvbmUgZGVzY3JpcHRvciBleHRlbnNpb24gYW5kIGZpbGwNCj4gPiArCSAqIHdp
dGggdGhlIGRhdGEgaW4gdGhlIHVzZXIgZGF0YSBidWZmZXIuIElmIHRoZSBkYXRhIHNpemUgaXMg
bGVzcw0KPiA+ICsJICogdGhhbiB0aGUgem9uZSBkZXNjcmlwdG9yIGV4dGVuc2lvbiBzaXplLCB0
aGVuIHRoZSByZXN0IG9mIHRoZQ0KPiA+ICsJICogem9uZSBkZXNjcmlwdGlvbiBleHRlbnNpb24g
ZGF0YSBidWZmZXIgaXMgemVyby1maWxsZWQuDQo+ID4gKwkgKi8NCj4gPiArCXpzZF9kYXRhID0g
KHZvaWQgKikgZ2V0X3plcm9lZF9wYWdlKEdGUF9LRVJORUwpOw0KPiA+ICsJaWYgKCF6c2RfZGF0
YSkNCj4gPiArCQlyZXR1cm4gLUVOT01FTTsNCj4gPiArDQo+ID4gKwlpZiAoY29weV9mcm9tX3Vz
ZXIoenNkX2RhdGEsIGFyZ3AgKyBzaXplb2Yoc3RydWN0IGJsa196b25lX3NldF9kZXNjKSwNCj4g
PiArCQkJICAgenNkLmxlbikpIHsNCj4gPiArCQlyZXQgPSAtRUZBVUxUOw0KPiA+ICsJCWdvdG8g
ZnJlZTsNCj4gPiArCX0NCj4gDQo+IEhhcyBpdCBiZWVuIGNvbnNpZGVyZWQgdG8gdXNlIGttYWxs
b2MoKSBpbnN0ZWFkIG9mIGdldF96ZXJvZWRfcGFnZSgpPw0KPiANCj4gPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaCBiL2luY2x1ZGUvbGludXgvYmxrX3R5cGVzLmgNCj4g
PiBpbmRleCBjY2I4OTVmOTExYjEuLjUzYjdiMDViMDAwNCAxMDA2NDQNCj4gPiAtLS0gYS9pbmNs
dWRlL2xpbnV4L2Jsa190eXBlcy5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMu
aA0KPiA+IEBAIC0zMTYsNiArMzE2LDggQEAgZW51bSByZXFfb3BmIHsNCj4gPiAgCVJFUV9PUF9a
T05FX0ZJTklTSAk9IDEyLA0KPiA+ICAJLyogd3JpdGUgZGF0YSBhdCB0aGUgY3VycmVudCB6b25l
IHdyaXRlIHBvaW50ZXIgKi8NCj4gPiAgCVJFUV9PUF9aT05FX0FQUEVORAk9IDEzLA0KPiA+ICsJ
LyogYXNzb2NpYXRlIHpvbmUgZGVzYyBleHRlbnNpb24gZGF0YSB0byBhIHpvbmUgKi8NCj4gPiAr
CVJFUV9PUF9aT05FX1NFVF9ERVNDCT0gMTQsDQo+ID4NCj4gPiAgCS8qIFNDU0kgcGFzc3Rocm91
Z2ggdXNpbmcgc3RydWN0IHNjc2lfcmVxdWVzdCAqLw0KPiA+ICAJUkVRX09QX1NDU0lfSU4JCT0g
MzIsDQo+IA0KPiBEb2VzIFJFUV9PUF9aT05FX1NFVF9ERVNDIGNvdW50IGFzIGEgcmVhZCBvciBh
cyBhIHdyaXRlIG9wZXJhdGlvbj8gU2VlDQo+IGFsc286DQo+IA0KPiBzdGF0aWMgaW5saW5lIGJv
b2wgb3BfaXNfd3JpdGUodW5zaWduZWQgaW50IG9wKSB7DQo+IAlyZXR1cm4gKG9wICYgMSk7DQo+
IH0NCj4gDQo+ID4gKy8qKg0KPiA+ICsgKiBzdHJ1Y3QgYmxrX3pvbmVfc2V0X2Rlc2MgLSBCTEtT
RVRERVNDWk9ORSBpb2N0bCByZXF1ZXN0cw0KPiA+ICsgKiBAc2VjdG9yOiBTdGFydGluZyBzZWN0
b3Igb2YgdGhlIHpvbmUgdG8gb3BlcmF0ZSBvbi4NCj4gPiArICogQGZsYWdzOiBGZWF0dXJlIGZs
YWdzLg0KPiA+ICsgKiBAbGVuOiBzaXplLCBpbiBieXRlcywgb2YgdGhlIGRhdGEgdG8gYmUgYXNz
b2NpYXRlZCB0byB0aGUgem9uZS4NCj4gPiArICogQGRhdGE6IGRhdGEgdG8gYmUgYXNzb2NpYXRl
ZC4NCj4gPiArICovDQo+ID4gK3N0cnVjdCBibGtfem9uZV9zZXRfZGVzYyB7DQo+ID4gKwlfX3U2
NAkJc2VjdG9yOw0KPiA+ICsJX191MzIJCWZsYWdzOw0KPiA+ICsJX191MzIJCWxlbjsNCj4gPiAr
CV9fdTgJCWRhdGFbMF07DQo+ID4gK307DQo+IA0KPiBJc24ndCB0aGUgcmVjb21tZW5kZWQgc3R5
bGUgdG8gdXNlIGEgZmxleGlibGUgYXJyYXkgKFtdIGluc3RlYWQgb2YgWzBdKT8NCj4gU2VlIGFs
c28NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIwMDYwODIxMzcxMS5HQTIyMjcx
QGVtYmVkZGVkb3IvLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
