Return-Path: <SRS0=uhQV=4K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDE7C35666
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 12:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96768206EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 12:55:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cUMXb1sv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JeWefYhG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgBVMzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Feb 2020 07:55:11 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60118 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgBVMzK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Feb 2020 07:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582376110; x=1613912110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uyy4u1rTmR1FICB1y8ykwjp+KBlGCWkcpc0y9O1/Rsk=;
  b=cUMXb1svEQ4QZXzcHs0KJm4YsicsrdrJz4aJf90LZ/xbDnWlbKzh4Rs7
   +83StHLMnLIfqQHOxPuSus4RUrf6VRivafD/0LbXyPX78vk9OIId4mRgz
   Aa/vF8J5H4BD6zAUdAne4Oip+HAfXcUxmHtRASPijpe811jmM9yc9HGtA
   MWsKenmaUbmmOEATPr8MFhxO1/DnGz6pOtCoaHaD9ai+GUzXauwAnZfTW
   SFe6Qth+gutz4rMUisTa0D6XLVHl2qVlJTYe0t7DJghNXYmqsnZa5duHn
   LPVw2gHvgAZdIMwM//+h01fkKe70srNRGkSIEdhn52gFrNywBvDJXqneY
   w==;
IronPort-SDR: jT6O+HPndOojCMtugNb6d50xHkas/9ix6ZMvlcwSunjx+Cc7+E64jdZ90AwNbAvyHT4/qG+Ay2
 vazadMPSS+b3Lxln8Tj4imRJChlsuuxOqF0ACHp3A/O2gFKLNWI4XNBcsNIC4Jo9C+LCqN7U3c
 LscqjYrxq1pQeeA+f8Fkxq4FZd2/PzmZGnotGBe+3JEWkVDciOOvHsZZET+Mwyku3wQA9lERHn
 NCXosJs4StWz/SYIqB0APrGORQR84K7nNSoPL/yi/ZrsAjyUEwvwRkG+Mb7RRPPVSNLRBeSmcZ
 SKw=
X-IronPort-AV: E=Sophos;i="5.70,471,1574092800"; 
   d="scan'208";a="130975867"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 22 Feb 2020 20:55:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7g20WiLWUSOv0/xVNo4020WpjVM7qbtIxF6R51fAq0b2m1YJdXDpWuvz91tRvGA4MA+KzbNOZQNd9/J/MEfh2hAfdwugQL3rTGisgpucBIL7txim+eg7cGSqPlaP+7QZOcaxgHhG37JZC/yMWBg7cG/JJwveLqwwFoFwiB46LW3r+Z5lzPZAz5Ap5j8NKc2CMK9gGq8wczhB0Euc3MSChl74DjYgwbiCf3oXPRd6P0USWH4vevH+98tP8g/mNzLw5lR9rVRlZUQeKU5mERPYTxgOcSXIRITSPq409dm7zMT3J/M+LxbKM0+rohQl4JYMODpJM88r6a+T+giRQopFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyy4u1rTmR1FICB1y8ykwjp+KBlGCWkcpc0y9O1/Rsk=;
 b=HlCCeltMEeV+j90CzNv/RoFqs4Q40YtWc1XavkK6AAGrhIE9BwTo5pLL6BXz09+buuHsnDcLa2cnEsnMVGopMoEZwVMOvBDUWN7v6ieHqh7D/7OM8SxSpwvxnToxxQD2VYu9tLMiWZUQIzkiatLopK1FVQjkWandCLiVU354Xfw6zIitOpRgXUIy+t7w6T67c0itqaHXAhAxlFweTfsN1HmJWBLIiabBM83+bRG2+JqyQw0QO2As/l4Ee0FmymX0zInfuYS/7iEJkLC3se7xBj7g47BzdnC/D2dX0pvqpgUxejtaB0W5b1EaSGv/6RAOEwiHL0nDQZ+1itntkJO8tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyy4u1rTmR1FICB1y8ykwjp+KBlGCWkcpc0y9O1/Rsk=;
 b=JeWefYhG0ah+4rwZJSGMoRN+xmp652Hf0WUxnqPX9xZfSw7GHk3hKMmvDsEY405E8DupiLxUx9K7jaUaFgIqsLDJSdRSEK68x+rYyo7Mx84s48ctsiKJ4+BQBDFPRrnOzpVgm8lp0ExfgNxm61MrxbdZRez3gdnP0RWC7rsWbs4=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (2603:10b6:208:1e1::17)
 by MN2PR04MB6238.namprd04.prod.outlook.com (2603:10b6:208:e4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22; Sat, 22 Feb
 2020 12:55:08 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2750.021; Sat, 22 Feb 2020
 12:55:08 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@gmail.com>, Christoph Hellwig <hch@lst.de>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RE: [PATCH 1/2] ufshcd: remove unused quirks
Thread-Topic: [PATCH 1/2] ufshcd: remove unused quirks
Thread-Index: AQHV6MBhunq90rSFlECrNkKl2U8RUKgmiGiAgACkA2A=
Date:   Sat, 22 Feb 2020 12:55:08 +0000
Message-ID: <MN2PR04MB6991F27B8D61DF9C024DFCFBFCEE0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200221140812.476338-1-hch@lst.de>
 <20200221140812.476338-2-hch@lst.de>
 <CAGOxZ52TVc4NEb6=bxH6potSgmRhjZt2NGsBMODweEbWkKJM5A@mail.gmail.com>
In-Reply-To: <CAGOxZ52TVc4NEb6=bxH6potSgmRhjZt2NGsBMODweEbWkKJM5A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [37.142.2.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c9cff104-3efb-4d10-6951-08d7b796720d
x-ms-traffictypediagnostic: MN2PR04MB6238:
x-microsoft-antispam-prvs: <MN2PR04MB6238F9FC9C68BDF51351FD37FCEE0@MN2PR04MB6238.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 03218BFD9F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(189003)(199004)(52536014)(478600001)(33656002)(26005)(5660300002)(7696005)(110136005)(6506007)(53546011)(66946007)(76116006)(316002)(186003)(9686003)(86362001)(54906003)(55016002)(64756008)(8936002)(66556008)(66476007)(81156014)(71200400001)(66446008)(8676002)(81166006)(2906002)(4326008)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6238;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 34Pb308V/03DPsH6/bFhxIgcd1A8V8rdhvP8AV7O5kym/zyTzqfOIFnR5MDrlc8Z7eRrrBiYnOTBsjbcEJFy4lsDpltMuc7ChBdu/zdoOdsz8lXV81zKoyA3lKpPbh/kaXrkPKfQJQTc82uu0qVftYslyKrzgOh1FJIzES7Zdvz8Hz1h9Ta48Mq+++ZGp1Nf0vGl4KCF7K+00fvKaE0PA7deeEfTqY0rIFKXBLQWDTvGKBIqV4rZli/hBlw12DI3y6SBbyqEkAB90EVJxERGoet6ErZMNvFO9Kk0osFwbBliKGPDucVxVoDJrx49KjKfhxv5IRYdd4mgDlgOrYESdkx2paAa1BsQEjE4uRPoKUaTVV7c8PcHQGjdA4vjkyW1NiKvHFYeNwgaTDBumL+LBHz2qmMoW+Nu6S1zFOAw5sh9KvYX7Hx+JB4H1pcwS/ja
x-ms-exchange-antispam-messagedata: OpLQp5CHZGs7x0A49xNbBjLzFRpgU9UwGbW1rKtbPlRNZwlmQIzdPN+5XRz+Y6DGtdNBfyVSXs6RLkjaLRQkfrgNtzdAkBw0n6QjQmbR1bQrnIwlYNVPkjel5Wm/KvhYE8tUcTgwNw+W2S5cvzsDeQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9cff104-3efb-4d10-6951-08d7b796720d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2020 12:55:08.1374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: whDoe6XN1C8si8hs16HSn5rjracGH5qGyMqp4s1e4WDgEpSJDeUSPCuVY5Fykkle4dZG+3Da3gcvPWf+KgsFOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6238
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gT24gRnJpLCBGZWIgMjEsIDIwMjAgYXQgNzozOCBQTSBDaHJpc3RvcGggSGVsbHdp
ZyA8aGNoQGxzdC5kZT4gd3JvdGU6DQo+ID4NCj4gPiBSZW1vdmUgdmFyaW91cyBxdWlya3MgdGhh
dCBkb24ndCBoYXZlIHVzZXJzLCBhcyB3ZWxsIGFzIHRoZSBkZWFkIGNvZGUNCj4gPiBrZXllZCBv
ZmYgdGhlbS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPg0KPiANCj4gDQo+IFRoaXMgZG9lcyBub3QgbWFrZSBzZW5zZSB0byByZW1vdmUgaXQg
bm93IGFuZCByZXZlcnQgdGhlIHBhdGNoIGEgZmV3IHdlZWsNCj4gbGF0ZXIuDQo+IE1hcnRpbiAv
IEF2cmkgeW91ciB0aG91Z2h0IHBsZWFzZS4NClllYWggLSBJIGFncmVlIHdpdGggeW91LCBwcm92
aWRlZCB0aGF0IGluZGVlZCBpdCBpcyBqdXN0IGZldyB3ZWVrcy4NCg0KVGhhbmtzLA0KQXZyaQ0K
