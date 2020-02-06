Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0042FC35247
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 19:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7C4721927
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 19:32:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XOwMeuVN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="f/av+iZA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgBFTcY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 14:32:24 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:61558 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBFTcX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 14:32:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581017544; x=1612553544;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AXkjFc7FZ+M+nxZ5aabWyVr0PNT9oATPuHM1lrv9zvA=;
  b=XOwMeuVNNbV318PFty1d6i2oGJtIV9gVf8g72mCQn98gCatfG2/Vgoyo
   8/liG+uZVU8GY8aZNEbkhU6jgqNDnNIDUZ8kHI01mVMJNffKwH+nGutdh
   cOfQ526AJ8SM6egYpnVgsyHLSXTEHjutUGo+Wed97133QsnDMcWhbB7r2
   0J04WOr6bf6kbeH6GaV7TmzVROSk/GR45DqJ1fnRVtZ84kxidXo5WWHs5
   HnEopfZp99QnX2FEgCk/Mqyf65o/pRyCflBcad7KWMbkvzCNKUi4x4RXc
   gp2NVR+SKnlg5QjUPjOMXIfXJ9xxsxJLnDp8F/C0JE2EQh2+VtdiIAvvk
   w==;
IronPort-SDR: BWKiskbfdRmkhVYTLH1PdnVkcgYK37HaCN7IqKatUvPvlbQMrmyw9fplMh/c3NCCA78XsaJFZW
 RaMst6vRikfaJl/KzT9wTgSnewgUhMUnXwmEJ1KG4OTliDBIFLhaRORDN9LCcFECbwSk3M09Dw
 zCH1vBYLWEm1PxS23xvcrVyae8HQkZC1bqHaS+XvOp5OAM9tZXCcVOeva3Vtj0kLdEXcopTptx
 GOYVkhhGtFsI8gg7NrWuQUUea9DKBqoCJBVzYho0O5ASdWx+iITy5tdPTXNDLpOk400JuGz0WY
 SSw=
X-URL-LookUp-ScanningError: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574092800"; 
   d="scan'208";a="129840313"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2020 03:32:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mbc4iFjKs0lTmExFuLhnJnGyODPyBgdgIsPVtxJN48K7Y3UggmNaFpLnKdx1i/i8UfoGVI5OdijdwCpsvtu3ikUUngPcf6lNRemNtraGRB6joKuiJGb3vsaYK0cW80R0YbZgd6HRYvQ078doAtuWfkeTwUul12pDEBJIxLbCfodMrII/dzTnTkY+cazH8X9rbEROJhBXipd0WXL+fFnLWQ+vHwPE9P/uwZrGCKH+YsYtMqrtb0MkERSzjAYcaaNSqLtmZwfNbOn2RD06epCrUOAVzmKhkAujNa669mdfBUpb+U8n6EuQ9tR/C8D+pSTHn2n6Z0WXAMGtxaGjeo5V7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXkjFc7FZ+M+nxZ5aabWyVr0PNT9oATPuHM1lrv9zvA=;
 b=VG7RH7HSTQPSrJ/5EUWa5gcypfwso7mBfnehoT2G+JGVvCSrVpEHrQ5EwqYO0bartOSxHGA88bwHSWRnR/vffhOVLwYuDpaB5hqB7/YVrYYmG1P6zB+lTJb2dqSurPbWcRtqkui0gDE27iEGhauFV9edbwsew/M2NMERp2X6Na5Zy1rEYvFUgxtlMRQ3OD42cMaAqEAoQwUINcDSStQZMUMpnk+/XxxO9vJ0SW8nD24PgBDchPXV/F8QLu9hxbHnbVnw52WSB6cBbRhLkNlL0qNC3dxOadrosWSQrzpjzf+pRRMLc1nYWLUFTxSfe8F+lEwDYsMMeOsTLq9ZB6aeiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXkjFc7FZ+M+nxZ5aabWyVr0PNT9oATPuHM1lrv9zvA=;
 b=f/av+iZA+t9eqkfvS3x8Vgo0W8HlWiUTcET+OeDa2cHH7zRUXMnZwgKP5SWAKNZv9c6U7bOz+0s1O6EECEP37RJxTU8JL6WTQ/TXYa/S7A86EXH5AUiXN9EBH7RvfThZ+KCvusLC6a5QabOa/E42opsPTr+eRjgnFicVeKLmAoE=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6719.namprd04.prod.outlook.com (10.141.117.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Thu, 6 Feb 2020 19:32:12 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.020; Thu, 6 Feb 2020
 19:32:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Julian Calaby <julian.calaby@gmail.com>
CC:     Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Topic: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Index: AQHV2bYgyCYLCd8TvkGCDJX1L0irp6gISGeAgAEWVwCAAC+qAIAAZ98AgAANYYCAAIzHgIADb7iAgAAQtgCAAAb1sIAACmKAgAAMGmCAAChwAIAANn2Q
Date:   Thu, 6 Feb 2020 19:32:12 +0000
Message-ID: <MN2PR04MB699192FB02C86DE567785A83FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net>
 <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net>
 <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net>
 <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
 <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
 <CAGRGNgWG2fvY33j0m00SkguU8N4TJttY4KeNtOxZ7HzTTXA=yw@mail.gmail.com>
 <MN2PR04MB6991848EBC8DED439FCD7C49FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGRGNgUA=LHbWqZY+hsYjfsTbyftc3uoGv6S3p8E4zPQyqsOGQ@mail.gmail.com>
 <MN2PR04MB699190E3474F82BEF9B91A58FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGRGNgWob+0t35AYXfzCqKtLjBgw=p8MhqDCKF=5_JGe5veqtQ@mail.gmail.com>
In-Reply-To: <CAGRGNgWob+0t35AYXfzCqKtLjBgw=p8MhqDCKF=5_JGe5veqtQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.137.114.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 66148e00-7da6-4432-df85-08d7ab3b43c5
x-ms-traffictypediagnostic: MN2PR04MB6719:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6719CD7973D4CF0736565F2AFC1D0@MN2PR04MB6719.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(189003)(199004)(6916009)(66476007)(66946007)(66446008)(52536014)(64756008)(2906002)(81156014)(316002)(81166006)(66556008)(76116006)(4326008)(8676002)(71200400001)(966005)(7696005)(6506007)(5660300002)(53546011)(478600001)(54906003)(55016002)(8936002)(86362001)(9686003)(33656002)(186003)(26005)(16940595002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6719;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IbwKvYmglFswdFgGDHsbno9Ib2O2rE+mi53KvhAlfyGCOaapmgahM8v3hS3g4+DUHPzTUrmLWX8pSl+16hmpRQvfDNJ/tcKfqHl6q/WrStvM0/wEl6p8qeUvcnt+C6dfp7LBj089NjfE3iAdqufKR06Nakz7waUR2So6L1OxsYXkXhlCFrVAcZxRqpHBai9jTMJsLjq5WpAJH/24xXaj/KWxLC8774S+8iDvQSbw/Fa/O1v3XJva1uDOPF/yefMIW4N1Pe8MXgrd8dpLW82yWMoTvcDt5Gth02Zz8oO3535K2Fx1rfEqGy7A7sx86+OBIw+lnEJbxjr5PGgzFrBtqNjOd+s2sJDuwHcZdoFQZtUB/bdCopmMtaYwGDBAJjnV2/d6+Nb8BKrQpNSjIvRzCkUn7YGqPzYCHL3mD1xqS6dHL62jVL13bKk1Oiebw7G9qDOAgCzEju+piLoTR7TSJ8hOGlQmXoqTkkl8JOo7u2lnaT0ISZ/C1Rimc3Wo4ipTAOxZva8DmNd6nn3KZFqsJgRLv/uIsIToiKjDagzVTxw6WTuGSpcVYsLsZSNaDiY5p1b+vW4CteUcD+oQRwovwA==
x-ms-exchange-antispam-messagedata: z2+w15Wn/fcIHpYqdXPhd1Y3G5qLr+l5jTt8XV7O4sPeHxVTUAYbFQzmJaB5voz+b+OynXvtoHCOELUuu0UR5e1BwXU/VoqMfnvKp9Jnmlp02xfyxZDMtN/KraToljCtAhDLdUvcsP7pg1RpJ015aQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66148e00-7da6-4432-df85-08d7ab3b43c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 19:32:12.2545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tyIfR+jDohBLoOu8NO0H5wUkXESHXHg2mVFudC8ArS6B0TQuUcELDVS5KiRz+iQFVFJVaGRKSU5iOJ5qG+8J+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6719
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSnVsaWFuLA0KDQo+IA0KPiANCj4gSGkgQXZyaSwNCj4gDQo+IE9uIEZyaSwgRmViIDcsIDIw
MjAgYXQgMTI6NDEgQU0gQXZyaSBBbHRtYW4gPEF2cmkuQWx0bWFuQHdkYy5jb20+IHdyb3RlOg0K
PiA+DQo+ID4gPg0KPiA+ID4gSGkgQXZyaSwNCj4gPiA+DQo+ID4gPiBPbiBUaHUsIEZlYiA2LCAy
MDIwIGF0IDExOjA4IFBNIEF2cmkgQWx0bWFuIDxBdnJpLkFsdG1hbkB3ZGMuY29tPg0KPiA+ID4g
d3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBIaSBBdmksDQo+
ID4gPiA+ID4NCj4gPiA+ID4gPiBPbiBUaHUsIEZlYiA2LCAyMDIwIGF0IDk6NDggUE0gQXZpIFNo
Y2hpc2xvd3NraQ0KPiA+ID4gPiA+IDxBdmkuU2hjaGlzbG93c2tpQHdkYy5jb20+IHdyb3RlOg0K
PiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEFzIGl0IGJlY29tZSBldmlkZW50IHRoYXQgdGhlIGh3
bW9uIGlzIG5vdCBhIHZpYWJsZSBvcHRpb24gdG8NCj4gPiA+IGltcGxlbWVudA0KPiA+ID4gPiA+
IHVmcyB0aGVybWFsIG5vdGlmaWNhdGlvbiwgSSB3b3VsZCBhcHByZWNpYXRlIHNvbWUgY29uY3Jl
dGUgY29tbWVudHMNCj4gb2YNCj4gPiA+IHRoaXMNCj4gPiA+ID4gPiBzZXJpZXMuDQo+ID4gPiA+
ID4NCj4gPiA+ID4gPiBUaGF0IGlzbid0IG15IHJlYWRpbmcgb2YgdGhpcyB0aHJlYWQuDQo+ID4g
PiA+ID4NCj4gPiA+ID4gPiBZb3UgaGF2ZSB0d28gb3B0aW9uczoNCj4gPiA+ID4gPiAxLiBleHRl
bmQgZHJpdmV0ZW1wIGlmIHRoYXQgbWFrZXMgc2Vuc2UgZm9yIHRoaXMgcGFydGljdWxhciBhcHBs
aWNhdGlvbi4NCj4gPiA+ID4gPiAyLiBmb2xsb3cgdGhlIG1vZGVsIG9mIG90aGVyIGRldmljZXMg
dGhhdCBoYXBwZW4gdG8gaGF2ZSBhIGJ1aWx0LWluDQo+ID4gPiA+ID4gdGVtcGVyYXR1cmUgc2Vu
c29yIGFuZCBleHBvc2UgdGhlIGh3bW9uIGNvbXBhdGlibGUgYXR0cmlidXRlcyBhcw0KPiBhDQo+
ID4gPiA+ID4gc3ViZGV2aWNlDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBJdCBhcHBlYXJzIHRoYXQg
b3B0aW9uIDEgaXNuJ3QgdmlhYmxlLCBzbyB3aGF0IGFib3V0IG9wdGlvbiAyPw0KPiA+ID4gPiBU
aGlzIHdpbGwgcmVxdWlyZSB0byBleHBvcnQgdGhlIHVmcyBkZXZpY2UgbWFuYWdlbWVudCBjb21t
YW5kcywNCj4gPiA+ID4gV2hpY2ggaXMgcHJpdmV0IHRvIHRoZSB1ZnMgZHJpdmVyLg0KPiA+ID4g
Pg0KPiA+ID4gPiBUaGlzIGlzIG5vdCBhIHZpYWJsZSBvcHRpb24gYXMgd2VsbCwgYmVjYXVzZSBp
dCB3aWxsIGFsbG93IHVucmVzdHJpY3RlZA0KPiBhY2Nlc3MNCj4gPiA+ID4gKEluY2x1ZGluZyBm
b3JtYXQgZXRjLikgdG8gdGhlIHN0b3JhZ2UgZGV2aWNlLg0KPiA+ID4gPg0KPiA+ID4gPiBTb3Jy
eSBmb3Igbm90IG1ha2luZyBpdCBjbGVhcmVyIGJlZm9yZS4NCj4gPiA+DQo+ID4gPiBJIHNob3Vs
ZCBoYXZlIGNsYXJpZmllZCBmdXJ0aGVyOiBJIG1lYW50IGhhdmluZyB0aGUgVUZTIGRldmljZQ0K
PiA+ID4gcmVnaXN0ZXIgYSBIV01PTiBkcml2ZXIgdXNpbmcgdGhpcyBBUEk6DQo+ID4gPiBodHRw
czovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9od21vbi9od21vbi1rZXJuZWwtDQo+
IGFwaS5odG1sDQo+ID4gPg0KPiA+ID4gKk5vdCogd3JpdGluZyBhIHNlcGFyYXRlIEhXTU9OIGRy
aXZlciB0aGF0IHVzZXMgc29tZSBwcml2YXRlDQo+IGludGVyZmFjZS4NCj4gPiBPay4NCj4gPiBK
dXN0IG9uZSBsYXN0IHF1ZXN0aW9uOg0KPiA+IFRoZSB1ZnMgc3BlYyByZXF1aXJlcyB0byBiZSBh
YmxlIHRvIHJlYWN0IHVwb24gYW4gZXhjZXB0aW9uIGV2ZW50IGZyb20gdGhlDQo+IGRldmljZS4N
Cj4gPiBUaGUgdGhlcm1hbCBjb3JlIHByb3ZpZGVzIGFuIGFwaSBpbiB0aGUgZm9ybSBvZg0KPiB0
aGVybWFsX25vdGlmeV9mcmFtZXdvcmsoKS4NCj4gPiBXaGF0IHdvdWxkIGJlIHRoZSBod21vbiBl
cXVpdmFsZW50IGZvciB0aGF0Pw0KPiANCj4gTXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IEhXTU9O
IGlzIGp1c3QgYSBzdGFuZGFyZGlzZWQgd2F5IHRvIHJlcG9ydA0KPiBoYXJkd2FyZSBzZW5zb3Ig
ZGF0YSB0byB1c2Vyc3BhY2UuIFRoZXJlIGFyZSAiYWxhcm0iIGZpbGVzIHRoYXQgY2FuIGJlDQo+
IHVzZWQgdG8gcmVwb3J0IGZhdWx0IGNvbmRpdGlvbnMsIHNvIGFueSBhY3Rpb24gdGFrZW4gd291
bGQgaGF2ZSB0byBiZQ0KPiBlaXRoZXIgbWFuYWdlZCBieSB1c2Vyc3BhY2Ugb3IgY29uZmlndXJl
ZCB1c2luZyB0aGVybWFsIHpvbmVzDQo+IGNvbmZpZ3VyZWQgaW4gdGhlIGhhcmR3YXJlJ3MgZGV2
aWNldHJlZS4NClRob3NlICJhbGFybXMiIGFyZSAgaW1wbGVtZW50ZWQgYXMgcGFydCBvZiB0aGUg
bW9kdWxlcyB1bmRlciBkcml2ZXJzL2h3bW9uLyBpc24ndCBpdD8NCldlIGFscmVhZHkgZXN0YWJs
aXNoZWQgdGhhdCB0aGlzIGlzIG5vdCBhbiBvcHRpb24gZm9yIHRoZSB1ZnMgZHJpdmVyLg0KDQo+
IA0KPiB0aGVybWFsX25vdGlmeV9mcmFtZXdvcmsoKSBpcyBhIHdheSB0byBub3RpZnkgdGhlICJv
dGhlciBzaWRlIiBvZiBhDQo+IHRoZXJtYWwgem9uZSB0byBkbyBzb21ldGhpbmcgdG8gcmVkdWNl
IHRoZSB0ZW1wZXJhdHVyZSBvZiB0aGF0IHpvbmUuDQo+IEUuZy4gc3BpbiB1cCBhIGZhbiBvciBz
d2l0Y2ggdG8gYSBsb3dlci1wb3dlciBzdGF0ZSB0byBjb29sIGEgQ1BVLg0KPiBMb29raW5nIGF0
IHlvdXIgY29kZSwgeW91J3JlIG9ubHkgaW1wbGVtZW50aW5nIHRoZSAic2Vuc29yIiBzaWRlIG9m
DQo+IHRoZSB0aGVybWFsIHpvbmUgZnVuY3Rpb25hbGl0eSwgc28geW91ciBjYWxscyB0bw0KPiB0
aGVybWFsX25vdGlmeV9mcmFtZXdvcmsoKSB3b24ndCBkbyBhbnl0aGluZy4NClJpZ2h0LiAgVGhl
IHRoZXJtYWwgY29yZSBhbGxvd3MgdG8gcmVhY3QgdG8gc3VjaCBub3RpZmljYXRpb25zLA0KUHJv
dmlkZWQgdGhhdCB0aGUgdGhlcm1hbCB6b25lIGRldmljZSBoYXMgYSBnb3Zlcm5vciBkZWZpbmVk
LA0KQW5kL29yIG5vdGlmeSBvcHMgZXRjLg0KDQpTaG91bGQgdGhlIGN1cnJlbnQgcGF0Y2hlcyBp
bXBsZW1lbnQgdGhvc2UgY2FsbGJhY2tzIG9yIG5vdCwNCkNhbiBiZSBkaXNjdXNzZWQgZHVyaW5n
IHRoZWlyIHJldmlldyBwcm9jZXNzLg0KQnV0IHRoZSBpbXBvcnRhbnQgdGhpbmcgaXMgdGhhdCB0
aGUgdGhlcm1hbCBjb3JlIHN1cHBvcnQgaXQgaW4gYW4gaW50dWl0aXZlIGFuZCBzaW1wbGUgd2F5
LA0KV2hpbGUgdGhlIGh3bW9uIGRvZXNuJ3QuDQoNCldlIGFyZSBpbmRpZmZlcmVuY2Ugd2l0aCBy
ZXNwZWN0IG9mIHdoaWNoIHN1YnN5c3RlbSB0byB1c2UuDQpUaGUgdGhlcm1hbCBjb3JlIHdhcyBv
dXIgZmlyc3QgY2hvaWNlIGJlY2F1c2Ugd2UgYnVtcGVkIGludG8gaXQsDQpMb29raW5nIGZvciBh
IHdheSB0byByYWlzZSB0aGVybWFsIGV4Y2VwdGlvbnMuDQpJdCBwcm92aWRlcyB0aGUgZnVuY3Rp
b25hbGl0eSB3ZSBuZWVkLCBhbmQgb3RoZXIgZGV2aWNlcyB1c2VzIGl0LA0KV2h5IHRoZSBpbnNp
c3RlbmNlIG5vdCB0byB1c2UgaXQ/DQoNCg0KVGhhbmtzLA0KQXZyaQ0KIA0KPiANCj4gVGhhbmtz
LA0KPiANCj4gLS0NCj4gSnVsaWFuIENhbGFieQ0KPiANCj4gRW1haWw6IGp1bGlhbi5jYWxhYnlA
Z21haWwuY29tDQo+IFByb2ZpbGU6IGh0dHA6Ly93d3cuZ29vZ2xlLmNvbS9wcm9maWxlcy9qdWxp
YW4uY2FsYWJ5Lw0K
