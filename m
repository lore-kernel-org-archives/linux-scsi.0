Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2231C55199
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 07:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA46D21556
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 07:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Mizt19xW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AP6a+Ouh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgD0HyH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 03:54:07 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20750 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgD0HyG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 03:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587974047; x=1619510047;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zmgEn75UXI3Eo9CxotkYz/LHdIrkG9iy3UP7Pr6t4y8=;
  b=Mizt19xWJNwlDE6DYwqSlN0hBfBUZxya8TT0oUU11u4RPOjxR1aaVghC
   XIaiYMkGVussRJnSfsL94EImbpnQvFxZnZOG8cloMe+FSQ+l+rNw7b0Yk
   a7yeMn1wlTe9YoG24WKJH9NNHvyL4q//8/hfc0mFscexbWaY6YNHeKZHr
   YiGFJ9Vsa2pjzg/uYZRNE/EHs3iCfBX4dziD8hhsp8kxVnyYEuOvhdRIw
   5P18gxsN6p2ljTZmKCBlN3HUF7tuevN+t+DRm7DcVIbooj3cwRHL051c4
   jHOvRFh4GLqMoY/hTyB13ZCUIVLrNvPYjlXmFUMPVVCS+v7fUWybBSDdr
   w==;
IronPort-SDR: Y2GQf0DjvDr81bZfAR4neNUIQ1qZJ7JVAm3EU72pgBF0kdZZ/cgdie3nfB1sOIXKVzUY9nhrdJ
 m0Fo3+QwzW+Et2tO+VuYBFb5DOEY9NHFzKS7dywhSvZPvcmvqBYvNOqe2k4eahAxemogjkj74L
 uB4bcdMmqKz/4ISYU7QxZeblkHMIaKZVNTw4vqUEhfx0wyWBV7eaTPWhKYVICP/Dy1WxI1sFpe
 DcCGQxugLLEqxiI3hMT4J0BOFIP91qOTMOZn1yGYZPieLYhGScI3m+1p4VpfY86WUy3Aly8YXs
 vP8=
X-IronPort-AV: E=Sophos;i="5.73,323,1583164800"; 
   d="scan'208";a="140579903"
Received: from mail-bl2nam02lp2052.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.52])
  by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2020 15:54:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqTdOa9cqqk7k/cp2zHHryEFawLvshhE3/kahReUQHt74Xo3SZ4ZlaGBnX9SoBDn1zBhwkcKMQqxUIRi8mB0IZu1fbcK6JLCZs91oXi4cd3gqQOu4qedBbNZpy6hEeB9o7BM7O/q8F2lSuPq0vnxxRUx7BAyspJit445uvW+6hz8OdwvXguKreukxWKtZt7FOfU3GUEbVOMGRLyd6hfLaNy6VULBp8RMNWFowebN/qNYTQrW5yMHS/1a3shbEo/cpHYziOLom7yE0wr8pARIiLE2zwbkqqQMRpksYtsDLa8T2KzK2qArJ02DBZ9gFXZ9tiMH7Cd6wYCW/vIGOnK/UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmgEn75UXI3Eo9CxotkYz/LHdIrkG9iy3UP7Pr6t4y8=;
 b=CfrMcBHah9/BcSHnniDfg2mWsNtCjPhLPrFjKXSowovqUzFzu0l9l32mf9FXPKZUkiT5jj4KSzvbtqI0fuHNt9v+0Nx94IvCH7Bv0EUQvgMhxlL1Fu/nz4+ixaHN4mhSquUJzdEld4KXFrn1qY2MLmFmrDwEVq+zUqzanvjmJM8KQ/tllUfwo5QRZZq7O2mMEcUqC9TTjTW+DS9wJsbN6kNnUUgBWL7ngknZuAIivc99p0LuCf1ev8WlwEdY5gjaEjcmnaTqpxHFwUttEwBGO2M0THlzdHGgcd7KpBxlSfsTxmAaTtTpp6O1aG6uLUp5bqQUmVydLR7fIERzOTy5FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmgEn75UXI3Eo9CxotkYz/LHdIrkG9iy3UP7Pr6t4y8=;
 b=AP6a+OuhkH53UAttsjzz47j8JR98VO0kltaoauo+iyZLYE0aSn4iH8EFPWe8t+zpx9HoJfpfBdJ2mv97kotvDSFxH2PjTx0VOEtcLuREU52po+Z+yzd89+7pCbixdLjCdCW5onhbOMMrRC5C78fR42/Tdg7g4H75KzYrZHxMM8g=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (52.135.119.19) by
 SN6PR04MB5184.namprd04.prod.outlook.com (20.177.253.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Mon, 27 Apr 2020 07:54:03 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2937.023; Mon, 27 Apr 2020
 07:54:03 +0000
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
Subject: RE: [PATCH v7 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Thread-Topic: [PATCH v7 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Thread-Index: AQHWG/IMeK6/8LgtMEaLxBE20AY1VqiMmdEQ
Date:   Mon, 27 Apr 2020 07:54:03 +0000
Message-ID: <SN6PR04MB4640687552E59ABDE613BB1AFCAF0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
        <CGME20200426174213epcas5p3f5b403eafe77d98cbe0b92ccb3fd56b2@epcas5p3.samsung.com>
 <20200426173024.63069-6-alim.akhtar@samsung.com>
In-Reply-To: <20200426173024.63069-6-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2712f33f-2ddd-4409-6dd2-08d7ea802790
x-ms-traffictypediagnostic: SN6PR04MB5184:
x-microsoft-antispam-prvs: <SN6PR04MB5184D368BA4A49B5B4F19D01FCAF0@SN6PR04MB5184.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(9686003)(186003)(5660300002)(86362001)(7416002)(6506007)(478600001)(26005)(316002)(2906002)(33656002)(110136005)(54906003)(52536014)(8676002)(81156014)(8936002)(7696005)(66946007)(66476007)(66556008)(64756008)(66446008)(76116006)(55016002)(4744005)(71200400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GpIX13RDIoPXU9RGx01eJuRCwXywtmgeiMyr2VavsUAUnKJwXXqiZV/qwbYKzuz3U9396z8k2wxa/eZ3pJWAk4cDiowPbbVdb6vr+Z8OQdiqsHi7HWMZo5U68Zs9f094YTk45qkVe7AfUSmEJ4Bw+QqIiK5gGF40EAmPlT6dbKGkdc8wiyshkn39+iuZX8ZOofG0LYDSKljFr3jAmPSFmbdNNiNK4GfPeK9d/Drpl//yr61cMJACKH2A17r6EF0IgAjCxGxd1hHHEcRQoENb1/SWF/K1zvXz+o670o7RhkDAmOS2YH8uByOs7c66vRwn1Cj+famLeU2rjaLxm73XlesKXDbExVyH1mJxb5fvxfY9FsTfM19fecTr886YQxj4iSVBtJbmuRMWQVVW80+lIJfgVWS8vom1VY2L+DUgLy28Y8kpFe4o52vny5zrn1Dt
x-ms-exchange-antispam-messagedata: 70lCKAuZp0uIfe6gbQjtnq/zwWTF6NiBbwoz+197GZBqepTY0hV+1gcb7M/yXP7PneRsBU/vhOr1HrP6VPxVlk/deHiLC2Fb5y9F2gi1c+luovTcOG/3z+Kt1ho1Qots4s4Ew7963d+Nua2DxTzXhIMYPGWX5mmOId8mZzz4WIkYmtINA1RvjMAZ2MlKpuKB8OwH5MDJpT12EifcQXfh2EyT/bUArLuD/ol2xh8yFDT2OoxEA0oCudlScwMJO9JQUOTdJVNYK3+zr2X5aAJoidDOvOzrhTiXNaFIcazMyseThoaTozkLVgSPHw4auE+Sp3r5rqMk3inmOTBkK9gtWkfx4bg0S+qXG5RXVBvDzUxeiFbOYJ4DxjmmZoWdRGIL8hWTF30Y3HDU5N3QC338+hFwm0ziohaxxAs2foD3bOfEiFL8gST7HjMPf8gx3dIwsE/uD3jSxeRWNf1d6PiE7fWLx5oGnOnzHY8S9Ns7MFBID4qgCfRUrt+JDOE10JSVJtnGmznYGH3VMdwEaUPyZvLSfuuaEdGrblWn7I8Q3QvkY7LzsRZmEt0WwYexPje0w3KxrlxI4kuZxHj7PD7bWlVArWI3Njsf2uaSXcFwcrQ8ksTjkKYiQzNKxPtC1wVKg+PoL23cSLY/D65FO9kbfZZtyE8LkKjNHB6zOrkkdZjJdoX1fsIUBmC1ixBaxtQS0ScBvU3Cui7j1hoDJRXaNkkTbvpcPbB+B6Ey9zm/+ORmhd0bgjPlv6jtVi45O1+NDRqHnA1/fwumCbCCHYmJiqdMh5c3BgUnPjcvao7zUBI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2712f33f-2ddd-4409-6dd2-08d7ea802790
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 07:54:03.5595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RlwgEWUbrTTNBQJRj9dGz/SKWVmxx0tgrNENbzNy4HRxm/nMhjbg8RQVTD552LP3iEwHxFDw/7OO/8BdF4Ay8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5184
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBGcm9tOiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNhbXN1bmcuY29tPg0KPiANCj4gU29t
ZSBjb250cm9sbGVyIGxpa2UgRXh5bm9zIGRldGVybWluZXMgaWYgRkFUQUwgRVJST1IgKDB4NykN
Cj4gaW4gT0NTIGZpZWxkIGluIFVUUkQgb2NjdXJzIGZvciB2YWx1ZXMgb3RoZXIgdGhhbiBHT09E
ICgweDApDQo+IGluIFNUQVRVUyBmaWVsZCBpbiByZXNwb25zZSB1cGl1IGFzIHdlbGwgYXMgZXJy
b3JzIHRoYXQgYQ0KPiBob3N0IGNvbnRyb2xsZXIgY2FuJ3QgY292ZXIuDQo+IFRoaXMgcGF0Y2gg
aXMgdG8gcHJldmVudCBmcm9tIHJlcG9ydGluZyBjb21tYW5kIHJlc3VsdHMgaW4NCj4gdGhvc2Ug
Y2FzZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNhbXN1
bmcuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGltIEFraHRhciA8YWxpbS5ha2h0YXJAc2Ftc3Vu
Zy5jb20+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQoN
Cg==
