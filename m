Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97921C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 21:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A00320791
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 21:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="En5mbcxK";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="N+qR8Yco"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHNVEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 17:04:21 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:42170 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgHNVEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2020 17:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1597439059; x=1628975059;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JEtJsBQy17ir6fuFI1NpAgYu5ykHGXI2IrV8NVqhi5I=;
  b=En5mbcxK8yoMQJhoz1dYhh+edQXEqHDG5VmwuNt1PhW/BZOhPGwPh6+v
   IeHwFEJmBxWPbMwwQ11oRCky+82K3lMiSqEaknavg4e4OK2PBTM2rwtT+
   9z6S8IE7qIkgYlR9naUWmw+Ln50887e8R3rynuUVHzYgfOv7mk5Lzrj2o
   OIKe5P1EmDJpnX9kTau7m4kW6C2Js3RKtsfjEILZ1gTbnl0Ry8ZyEdwkA
   21Hzpmrlqa40UoLwF5TGCfjd6ZBcXixzLrnyb4ADlo+HsSoqi0sJBot/4
   n7FQMXdWULMFhAOyjv4OvIqPS38EWixMEUde8JmnNFMFZPVc9UfLp3I0L
   w==;
IronPort-SDR: +eP4ihPDC68WCGOMis8Q8VjfIZtLm/wm1w++4Y0mVxiZo5mAbuGHxG+Ph6nOQfRq9vqneZTNby
 E52WFTrg1qchllTL8NiPfP6jfksg+5iK3RzH4TyN70vIXQ9sAO/714rGQaGnOFaq/NHU0jlwc8
 4QISVxq2CBKicKj02+K8FZPrTRS8tQSNcy7PnzAgsy7q8S5z/x47FGUoQqkRNoIGpmh2OG3A9J
 4kR/tykYABbb3i4Ni7l/d02FO4JamIR/I87xKAqX1XmqAMe9HULC9kkFMLFfwdlTE9kARtUHYX
 9ys=
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="91819566"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Aug 2020 14:04:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 14 Aug 2020 14:03:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Fri, 14 Aug 2020 14:04:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQ81/lelhDeSRX6mRCz+iB8c2A6ckuPdSBM0o98Or1kDbR0OE/4GUFTfehuRkIlRZAExy9wxuLaBQ5vXB+ZthUeuLb9YaqqxssrPgfxDhdqLabRM+qC7/u7r7bC5errqaVOe01sVbKKRIKwhmn/GsF9Zyz6PVca9hdzVosDy2gvlbwVeTNVTiAXbpW4I2btcwvcrHlmIH4IUK7jvZUzwazTgV1HTlRBOBNdYIGbLKuo7nXWsbx102VJEIvDhPe6KT99Y4pESPHxfkJrD4jGduEcOms7bdzzfRWt503h2OSwMsAhdkyaqxKqg0p2WReRHWSJSgkW/VkD70ymSsIpt9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEtJsBQy17ir6fuFI1NpAgYu5ykHGXI2IrV8NVqhi5I=;
 b=gYF2aT5H1tHdIlrkbMLrwLlT54tYkzV1F+Cm0kFLQUHDW4bf0QothO0WheAiBmm3sYd7M1Q6JpIVxjPHURr7g7Ek1QDU3ut6ouGbEO1L4z4unxgcUOKWjZadu+YodN+t1FOtESyzWkMWRRIMKYPpnF0/AWn4I/1fQbOURrBrgPmgSCfNpDiylwbkV7xNl7Kh/MGeUWUDRBlYEt4BqE5BZKfX0WVCeiBZYaLMDbX6OE7UZkrJ2g3RB1Q9cv5ZgzZia6t6rEicmWBFHhs/fVWL6S/hmk/2ojLBFkQXpknAt7X4B8eInnFAaU/SmemivwTLP03SLGgN1wb0wJ0CPRg0zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEtJsBQy17ir6fuFI1NpAgYu5ykHGXI2IrV8NVqhi5I=;
 b=N+qR8YcoZ9XKRi+Vt2yQnXW7IAsUKc1km5XdLMBasNvi2ldI3voB1D1PysP2JA3Zs+wclZ/CjkkvLHSVbtkBRmymGAS9tTw3XRdqa6tA2sdu8UVSv3NNEvP2MWUuSeq6RXCoxugJTTQwvqHQeI5MlZd+XiAIcXEBXJxDvOwfWp4=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA0PR11MB4720.namprd11.prod.outlook.com (2603:10b6:806:72::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Fri, 14 Aug
 2020 21:04:16 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::91b:b9d9:867e:c00f]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::91b:b9d9:867e:c00f%5]) with mapi id 15.20.3283.022; Fri, 14 Aug 2020
 21:04:16 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <hare@suse.de>, <don.brace@microsemi.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
Subject: RE: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Thread-Topic: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Thread-Index: AQHWP01RAs2BRuCN0k+i3rLwgMsJTKkG5J+AgAABKwCAAAMVAIAgQ/rQgADXkYCAAGEqcIABUPKAgA7GHXA=
Date:   Fri, 14 Aug 2020 21:04:15 +0000
Message-ID: <SN6PR11MB2848E10B3322C7186B82F1BCE1400@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
 <SN6PR11MB28489516D2F4E7631A921BD9E14D0@SN6PR11MB2848.namprd11.prod.outlook.com>
 <ccc119c8-4774-2603-fb79-e8c31a1476c6@huawei.com>
 <SN6PR11MB2848F0DD0CB3357541DBDAA9E14A0@SN6PR11MB2848.namprd11.prod.outlook.com>
 <013d4ba6-9173-e791-8e36-8393bde73588@huawei.com>
In-Reply-To: <013d4ba6-9173-e791-8e36-8393bde73588@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9946a2d5-d810-42bf-22fc-08d840959a99
x-ms-traffictypediagnostic: SA0PR11MB4720:
x-microsoft-antispam-prvs: <SA0PR11MB4720EBFC99DF8E0E7D286301E1400@SA0PR11MB4720.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9j06mQtqwvAJa0X/L87dj0pQGFfzIz40qYPr5jczbX4X5taLxzmdmaWjcps7pF3YijiShfuvfpFiah8+fE5g1m1tw7sZWooXhvvOHeBrWArIN0BQB0q3jz/ywoXNtO1d9GDMiCEJSBzBxRZqHOUl1O1SXdgr3xiUqHZ9PWhe0nKAxUCD/XFCbz+uR6KWYFCdm5J0uMBIhB0csYTUxI+3kvd7jqTi6PYz2/CVT7VdCT64VNIYg8fQZrKsQCUwH/xbjDx+oKCpNzw5KxmiGIqv5v7Ixs3szn/i0u/QQaUqsSs1qPzGvHV6fZ73g5CAErDpbiYffDLBelZw4jkHE1hQoDcKs6SSOwEt2y8W14wCJllHj19oFsKm4+e1Lu18LAVmfGW2bVR8enJi+4W7s5Ch2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(376002)(346002)(39860400002)(366004)(66556008)(76116006)(4326008)(66446008)(186003)(6506007)(2906002)(966005)(66476007)(478600001)(64756008)(86362001)(83380400001)(9686003)(7696005)(52536014)(26005)(66946007)(316002)(110136005)(54906003)(8676002)(8936002)(5660300002)(55016002)(71200400001)(33656002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: kotrlqF0S4cak0Nbp/ahjW663RmrMXiABNdyUgozcnoa+2Z+vsk0xzylbbeRwzsF7OuSIe3V0S5keR/yKsVJG3nnGRuoPXIVG++r1fgcJ1vbFhjwXzlkCjmboeudEnFRmBDHCHdS6KIzQ4JKmmvFX4+k8rJpmlSetfVmCrHuIPS07pc3s1GgsCJ4oBoLYRdKUrUe4I00w/eMHq6h+rRUpe+51PL+Pl+mUR3gFZdS2w8V+FXH4fagDQaR3IkVWhF75zjh4Bk7exA8xR6B1/1r3wNUQkaWM1ZeFJpqarejqa07clHdwyVZ+ajzPkC63EpAub/dOPksbrGWUeAncF6TXkYsQ/ituD+tivRN/mVZPSxFb/s44b1oxArEA5ww8rOt4g8FnnTQRnJJPxtRdfE6iMs+DdzL3p5iPc4cT8GavT25CViUcA1VjKmFu72ArSeFMd5yHACYFuWlfJPtnJkJnSYqYb6e7+ljENFAnIodug/q9oqF414PF5CCFPsXUUkpJ5SLgAUbmF/gfxq9iLQJBTHc8v73KhynxpwE5iNNVCjqhrq0OAPpwgHLpCiaLID0SQ82hREtDHKPdNWZrVOPyilt+73VuXNDmum7VnTr7Ag7RueCGTN44ys3+zy0oIgMV580fSq9kIHz3hkVyGeZLA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9946a2d5-d810-42bf-22fc-08d840959a99
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2020 21:04:15.8488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cc1XytOgFBotJtDS4AU0z94ujooEBUghK0F0FNaZfJKPXq0VPjiY4PPfM1Yx90KVOHIEBgxOYBwsk7qm463qnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4720
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3ViamVjdDogUmU6IFtQQVRDSCBSRkMgdjcgMTIvMTJdIGhwc2E6IGVuYWJsZSBob3N0X3RhZ3Nl
dCBhbmQgc3dpdGNoIHRvIE1RDQoNCj4gSSdsbCBjb250aW51ZSB3aXRoIG1vcmUgSS9PIHN0cmVz
cyB0ZXN0aW5nLg0KDQo+Pm9rLCBncmVhdC4gUGxlYXNlIGxldCBtZSBrbm93IGFib3V0IHlvdXIg
dGVzdGluZywgYXMgSSBtaWdodCBqdXN0IGFkZCB0aGF0IHNlcmllcyB0byB0aGUgdjggYnJhbmNo
Lg0KDQo+PkNoZWVycywNCj4+Sm9obg0KDQpJIGNsb25lZCB5b3VyIGJyYW5jaCBmcm9tIGh0dHBz
Oi8vZ2l0aHViLmNvbS9oaXNpbGljb24va2VybmVsLWRldg0KICBhbmQgY2hlY2tvdXQgYnJhbmNo
OiBvcmlnaW4vcHJpdmF0ZS10b3BpYy1ibGstbXEtc2hhcmVkLXRhZ3MtcmZjLXY3DQoNCkJ5IHRo
ZW1zZWx2ZXMsIHRoZSBicmFuY2ggY29tcGlsZWQgYnV0IHRoZSBkcml2ZXIgZGlkIG5vdCBsb2Fk
Lg0KDQpJIGNoZXJyeS1waWNrZWQgdGhlIGZvbGxvd2luZyBwYXRjaGVzIGZyb20gSGFubmVzOg0K
ICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvaGFyZS9zY3Np
LWRldmVsLmdpdA0KICBicmFuY2g6IHJlc2VydmVkLXRhZ3MudjYNCg0KNmE5ZDFhOTZlYTQxIGhw
c2E6IG1vdmUgaHBzYV9oYmFfaW5xdWlyeSBhZnRlciBzY3NpX2FkZF9ob3N0KCkNCmVlYjVjZDFm
Y2E1OCBocHNhOiB1c2UgcmVzZXJ2ZWQgY29tbWFuZHMNCgljb25maWN0OiByZW1vdmFsIG9mIGZ1
bmN0aW9uIGhwc2FfZ2V0X2NtZF9pbmRleCwNCiAgICAgICAgICAgICAgIG5vbi1mdW5jdGlvbmFs
IGlzc3VlLg0KN2RmN2Q4MzgyOTAyIGhwc2E6IHVzZSBzY3NpX2hvc3RfYnVzeV9pdGVyKCkgdG8g
dHJhdmVyc2Ugb3V0c3RhbmRpbmcgY29tbWFuZHMNCjQ4NTg4MWQ2ZDhkYyBocHNhOiBkcm9wIHJl
ZmNvdW50IGZpZWxkIGZyb20gQ29tbWFuZExpc3QNCmM0OTgwYWQ1ZTVjYiBzY3NpOiBpbXBsZW1l
bnQgcmVzZXJ2ZWQgY29tbWFuZCBoYW5kbGluZw0KCWNvbmZsaWN0OiBkcml2ZXJzL3Njc2kvc2Nz
aV9saWIuYw0KICAgICAgICAgICAgICAgbWlub3IgY29udGV4dCBpc3N1ZSBhZGRpbmcgY29tbWVu
dCwNCiAgICAgICAgICAgICAgIG5vbi1mdW5jdGlvbmFsIGlzc3VlLg0KMzRkMDNmYTk0NWMwIHNj
c2k6IGFkZCBzY3NpX3tnZXQscHV0fV9pbnRlcm5hbF9jbWQoKSBoZWxwZXINCgljb25mbGljdDog
ZHJpdmVycy9zY3NpL3Njc2lfbGliLmMNCiAgICAgICAgICAgICAgIG1pbm9yIGNvbnRleHQgaXNz
dWUgYXJvdW5kIHNjc2lfZ2V0X2ludGVybmFsX2NtZA0KICAgICAgICAgICAgICAgd2hlbiBhZGRp
bmcgbmV3IGNvbW1lbnQsDQogICAgICAgICAgICAgICBub24tZnVuY3Rpb25hbCBpc3N1ZQ0KNDU1
NmU1MDQ1MGM4IGJsb2NrOiBhZGQgZmxhZyBmb3IgaW50ZXJuYWwgY29tbWFuZHMNCjEzODEyNWY3
NGIyNSBzY3NpOiBocHNhOiBMaWZ0IHtCSUdfLH1JT0NUTF9Db21tYW5kX3N0cnVjdCBjb3B5e2lu
LG91dH0gaW50byBocHNhX2lvY3RsKCkNCmNiMTdjMWI2OWIxNyBzY3NpOiBocHNhOiBEb24ndCBi
b3RoZXIgd2l0aCB2bWFsbG9jIGZvciBCSUdfSU9DVExfQ29tbWFuZF9zdHJ1Y3QNCjEwMTAwZmZk
NWY2NSBzY3NpOiBocHNhOiBHZXQgcmlkIG9mIGNvbXBhdF9hbGxvY191c2VyX3NwYWNlKCkNCjA2
YjQzZjk2OGRiNSBzY3NpOiBocHNhOiBocHNhX2lvY3RsKCk6IFRpZHkgdXAgYSBiaXQNCmEzODE2
MzdmOGE2ZSBzY3NpOiB1c2UgcmVhbCBpbnF1aXJ5IGRhdGEgd2hlbiBpbml0aWFsaXNpbmcgZGV2
aWNlcw0KNmU5ODg0YWVmZTY2IHNjc2k6IFVzZSBkdW1teSBpbnF1aXJ5IGRhdGEgZm9yIHRoZSBo
b3N0IGRldmljZQ0KNzdkY2I5MmMzMWFlIHNjc2k6IHJldmFtcCBob3N0IGRldmljZSBoYW5kbGlu
Zw0KDQpBZnRlciB0aGUgYWJvdmUgcGF0Y2hlcyB3ZXJlIGFwcGxpZWQsIHRoZSBkcml2ZXIgbG9h
ZGVkIGFuZCBJIHJhbiB0aGUgZm9sbG93aW5nIHRlc3RzOg0KaW5zbW9kL3JtbW9kDQpyZWJvb3QN
ClJhbiBhbiBJL08gc3RyZXNzIHRlc3QgY29uc2lzdGluZyBvZjoNCgk2IFNBVEEgSEJBIGRpc2tz
DQoJMiBTQVMgSEJBIGRpc2tzDQoJMiBSQUlEIDUgdm9sdW1lcyB1c2luZyAzIFNBUyBIRERzDQoJ
MiBSQUlEIDUgdm9sdW1lcyB1c2luZyAzIFNBUyBTU0RzIChpb2FjY2VsIGVuYWJsZWQpDQoNCgkx
KSBmaW8gdGVzdHMgdG8gcmF3IGRpc2tzLg0KCTIpIG1rZTJmcyB0ZXN0cw0KCTMpIG1vdW50DQoJ
NCkgZmlvIHRvIGZpbGUgc3lzdGVtcw0KCTUpIHVtb3VudA0KCTYpIGZzY2sNCg0KCUFuZCBydW5u
aW5nIHJlc2V0IHRlc3RzIGluIHBhcmFsbGVsIHRvIHRoZSBhYm92ZSA2IHRlc3RzIHVzaW5nIHNn
X3Jlc2V0DQoNCkkgcmFuIHNvbWUgcGVyZm9ybWFuY2UgdGVzdHMgdG8gSEJBIGFuZCBMT0dJQ0FM
IFZPTFVNRVMgYW5kIGRpZCBub3QgZmluZCBhIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24uDQoNCldl
IGFyZSBhbHNvIHJlY29uc2lkZXJpbmcgY2hhbmdpbmcgc21hcnRwcWkgb3ZlciB0byB1c2UgaG9z
dCB0YWdzIGJ1dCBpbiBzb21lIHByZWxpbWluYXJ5IHBlcmZvcm1hbmNlIHRlc3RzLCBJIGZvdW5k
IGEgcGVyZm9ybWFuY2UgcmVncmVzc2lvbi4NCk5vdGU6IEkgb25seSB1c2VkIHlvdXIgVjcgcGF0
Y2hlcyBmb3Igc21hcnRwcWkuDQogICAgICBJIGhhdmUgbm90IGhhZCB0aW1lIHRvIGRldGVybWlu
ZSB3aGF0IGlzIGNhdXNpbmcgdGhpcywgYnV0IHdhbnRlZCB0byBtYWtlIG5vdGUgb2YgdGhpcy4N
Cg0KRm9yIGhwc2E6DQoNCldpdGggYWxsIG9mIHRoZSBwYXRjaGVzIG5vdGVkIGFib3ZlLA0KVGVz
dGVkLWJ5OiBEb24gQnJhY2UgPGRvbi5icmFjZUBtaWNyb3NlbWkuY29tPg0KDQpGb3IgaHBzYSBz
cGVjaWZpYyBwYXRjaGVzOg0KUmV2aWV3ZWQtYnk6IERvbiBCcmFjZSA8ZG9uLmJyYWNlQG1pY3Jv
c2VtaS5jb20+DQoNClRoYW5rcyBmb3IgeW91ciBpbnB1dCBhbmQgeW91ciBwYXRjaGVzLA0KRG9u
DQoNCg==
