Return-Path: <SRS0=U1jj=22=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDBBC33C9A
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 16:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 991EE2077B
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 16:40:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="U/Iz8yMv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Z8MLGF/b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgAEQkH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jan 2020 11:40:07 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:19570 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgAEQkG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2020 11:40:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578242407; x=1609778407;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o6v7kswxB+kQK3MbMK/j3XVKjA+EkM9m3g9GM7Rwpb8=;
  b=U/Iz8yMvIs0W/99GgoAZyeY9lPMzMRC6bpdrMC/hL7BhXKs1FBznRy6i
   iY7il2xBDEJTeRKu256x18Qp9gD5ysbTHPuWDboe1lOLrHn619MgbFYKd
   6T4TjAIR1NqtmTfbe+wGLdIrdLV8IrD+AtCcy09sHWJUaaTQg+sIBEzEg
   cBcuJU2X17Nd5qWrrUP3Su1ryKnKkPuO2/m65FzLQAsPo+M1DBgAzyXqw
   ubcKH9DJsRVaxs5S4ApLJWIbp+YinMei74TXjdGVE+L3xULKCqhYo/q3S
   0FBP6706X1lvAz8oP68iex4ThDbBVINb24KRJrFHYdIv8UiAt/UDGYrKk
   Q==;
IronPort-SDR: t18BIxUjT1leyurv/zBGXvMZCPOb6TrLa1Hjf81GSVZvH8XXSasZf8rTdk1gjINYa/TBCM5lRK
 +HrVm2107n7S1uPNWIiRTq0ugY0G9YnQFzwJy3gBKFYIc8nOtJ1nAix8pTegmKGSK3vFUNquJM
 3yuWpuGgHpP0u5bGfXyMBTS9t1iKbo8sMLMov8T+SFH6sdTNMW6t8jxnWXxJhJG0ARslUSN9a6
 YX3rjecJBIwdzZqATI5doPtf/ISUO4a4qRaN2UHSR8bWCHWSCHoALak2D5kpACl2audYi0VUcX
 4Yk=
X-IronPort-AV: E=Sophos;i="5.69,399,1571673600"; 
   d="scan'208";a="127475997"
Received: from mail-bn8nam11lp2173.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.173])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jan 2020 00:40:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxAVKrEz2pSvHBbfhJGI9aBulwmIAqbOP7/KauaqWrX+EQI8WG7k8XE9cB/LjCcdNOpWLgJBjvoOySu4o5KwWZtXIaoFtTddbthvXTAvp1EieODZPljmIBz9VburGLAD3F1vZMU3WYOliVxTORVDtd3NH1+eXWBQP5DM2VnmU5dlINKwF8arPCZNzN+W4Rhixjmc1VM1tMoTyn/QF4vt/XuLq9hcxJqIAsRDyVG6WzZkqG9b9/WzoMeWEu/uVb7kx8Bd38opJSNzq8wx2TkdPBr7AJ/RtE3C6i8dhzmKqBica9EFJc14Za9zAjU43AthDBDyOZ63dXqi5P8VpClTng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6v7kswxB+kQK3MbMK/j3XVKjA+EkM9m3g9GM7Rwpb8=;
 b=LZ2CY4pEOXXufJgJcMUpdx2MSw0TM3vkuI59qKX3BbSwnGyyBiBU2Kydtj/xZunPBd2IKmiP9wASJqrfzGI9+Vp9fFBQLfTgt49NSDFSMkgQ2LRM9o7JwXdLYwSfk5PJfAjpGO4bvFt+5pDQQJUyOOFwv5VLp0XbMCHuGWEzA82n0Nd51+dbVPzKhn51z+O8I2SLysNu46lDtkm0/ECg0KpFgXplGHuIfyqzq+IyXDRvebChF64rsi/5MABeNe8gkeEWlYs3dI/ftFWYT1AANWMIQhaUZ5k5qn3cyra+LNZH/I2V99sJLd9Wzh6RgpjRAzUyIHJ0HjPyGyEeMoZPfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6v7kswxB+kQK3MbMK/j3XVKjA+EkM9m3g9GM7Rwpb8=;
 b=Z8MLGF/bfcKspBHGKPyaBBKm9xqH8Av8gqNGS9J+BGZ/5snkTuzBFSLq/vfcVJKHObsf50Hkx+Wx7bRpglRPuMVBym4dtuZdYHuDazeCCMtso8s8ZAx11Rzc44VodkNbvxvNKx+eFFPNb7BQhhpOyrCgjxL3cWga/YNU9H6Vqig=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5631.namprd04.prod.outlook.com (20.179.23.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Sun, 5 Jan 2020 16:40:01 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45%4]) with mapi id 15.20.2602.015; Sun, 5 Jan 2020
 16:40:01 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v1 0/3] scsi: ufs: pass device information to
 apply_dev_quirks
Thread-Topic: [PATCH v1 0/3] scsi: ufs: pass device information to
 apply_dev_quirks
Thread-Index: AQHVw4RnKOmg85o31Eufk/ca9N3SIafbkG15gAB7awCAADp4MA==
Date:   Sun, 5 Jan 2020 16:40:01 +0000
Message-ID: <MN2PR04MB699151E6AEC7D15CBE1224A2FC3D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
         <MN2PR04MB69913F0B671032A388747CF7FC3D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <1578229802.17435.3.camel@mtkswgap22>
In-Reply-To: <1578229802.17435.3.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.137.86.228]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea8ff0d8-1397-41a6-a1a8-08d791fde908
x-ms-traffictypediagnostic: MN2PR04MB5631:
x-microsoft-antispam-prvs: <MN2PR04MB5631C3F8D846BB866A11C46AFC3D0@MN2PR04MB5631.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 027367F73D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(199004)(189003)(55016002)(52536014)(71200400001)(4326008)(8936002)(81156014)(9686003)(81166006)(7416002)(8676002)(478600001)(6916009)(76116006)(66476007)(66556008)(64756008)(66946007)(66446008)(26005)(33656002)(6506007)(54906003)(2906002)(316002)(7696005)(186003)(86362001)(5660300002)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5631;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s0UKCPbaVIEYfrJoR64SFOIDbL45K3L9TpSx8tY2RYlAOCrOtD+PLtsmIaOZzEp+Mto4HwQ1X53l1QVp7s3Y7DfIqWfAqpAVZ50BbA7Cx/1DPSKvWka0AbqFkFOK5pXuwM2r0lS4XH5sKu5XlWlnZq6v7OdebOLi8hPKZ7tjvosSoheNG1xEQE4RBYynvLJyCKOCFFokxAJa7+sSCpnU9LEHLRYfKX08ktjp3pRDtFcWAnbDGiUwrTgGTXRT+jb+0GBCPo9tKh6q+mRRXfRk0dqEvWCj9ZjUBLOdvN/JnthbfYev8Ay2EDj9q5CWq4dvqBN5XxbjrZs2XD9amXq9QoCZQe88aPfkkuuT5GxbLvsSh5LmX3YXMEJ9fkX1F808RqW3MOFW+tnGZe3yTXo6bJIP04Ep5XPZvB/KJ1GBsuquB//HBCkOkiGQVLhq63fy
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8ff0d8-1397-41a6-a1a8-08d791fde908
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2020 16:40:01.6096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OdKrKHwBDq0oyKqbvZooTj+iza5vcjwY7eezVZIRu/93CqMg8lQVb1zRH6Knz4GSHN0iF+WnxHgfp/QeTKtWEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5631
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBIaSBBdnJpLA0KPiANCj4gT24gU3VuLCAyMDIwLTAxLTA1IGF0IDA1OjUxICswMDAwLCBB
dnJpIEFsdG1hbiB3cm90ZToNCj4gPiBZb3UgaGF2ZSB0byBzcXVhc2ggcGF0Y2ggMSAmIDIsIG90
aGVyd2lzZSB5b3VyIHBhdGNoIDEgd29uJ3QgY29tcGlsZS4NCj4gPiBPdGhlciB0aGFuIHRoYXQ6
IGxvb2tzIGdvb2QgdG8gbWUuDQo+ID4gVGhhbmtzLA0KPiA+IEF2cmkNCj4gDQo+IFNvcnJ5IGJl
Y2F1c2UgSSBzZW50IDIgc2VyaWVzIGluIHRoZXNlIHR3byBkYXlzLg0KPiANCj4gV291bGQgeW91
IG1lYW4gcGF0Y2ggMSBpcyBzZXJpZXM6ICJzY3NpOiB1ZnM6IGZpeCBlcnJvciBoaXN0b3J5IGFu
ZCBjb21wbGV0ZQ0KPiBkZXZpY2UgcmVzZXQgaGlzdG9yeSIgYW5kIHBhdGNoIDIgaXMgc2VyaWVz
ICJzY3NpOiB1ZnM6IHBhc3MgZGV2aWNlIGluZm9ybWF0aW9uIHRvDQo+IGFwcGx5X2Rldl9xdWly
a3MiPw0KPiANCj4gT3IgcGF0Y2ggMSAmIDIgbWVhbiB0aGUgZmlyc3QgMiBjb21taXRzIGluIHRo
aXMgc2VyaWVzOiAic2NzaTogdWZzOiBwYXNzIGRldmljZQ0KPiBpbmZvcm1hdGlvbiB0byBhcHBs
eV9kZXZfcXVpcmtzIj8NClRoaXMgb25lLg0KDQo+IA0KPiBUaGFua3MgYSBsb3QuDQo+IFN0YW5s
ZXkNCg==
