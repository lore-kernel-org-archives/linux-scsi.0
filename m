Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E99C32771
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 04:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D22602077C
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 04:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="van0jARa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgATEuh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 23:50:37 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16681 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729078AbgATEuh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 23:50:37 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Deepak.Ukey@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="Deepak.Ukey@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Deepak.Ukey@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: HMjv2/0JbZmGmB53fvTPI2n0EivbFNAAFR+Gp90foFlz+1zkUgXx4KNqM7uuOZtGu8B6dSGJCg
 9kj/IOzKjvn6uQqnG9KOmWtuTCpeuC5jPeLfCTeAPUcp8t8dW5MVt4vixbKZb18227dpNWwMBf
 c+BP7L+EKhNCpfwn+SF7Sq0upvBu6gH4jXb6DwQI35tgK8odo7QVO32EcPAFNpCdLsyBlFjjOR
 52GiDcutHW/4yC7FkoO8JC09x2DWcq6uemKeIix6orDV47Bt3kIlGfAb1Dwximu9AEqf+BL8jk
 RHQ=
X-IronPort-AV: E=Sophos;i="5.70,340,1574146800"; 
   d="scan'208";a="65255308"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2020 21:50:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 19 Jan 2020 21:50:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Sun, 19 Jan 2020 21:50:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkX9g7614QHqKMP2abmJWVpfhpFQNE9wPTd/WDCzMx7HfiSgPOBEq5P52E5OS+nGd6YprfolCNXRNXf1nGv2nlq6RSa0kB7Wxmvo0FhoiG/2Xzm0jDT90rTRZOX0Jst1aMud8IN+3d+l7yZWzzPo8jFgdNIfPDpVWCM6i7Gf+Nr8q4EFXMvgRduuZyOr5z9LR2K6jXRVbWx5Afct8XZeic2liQou1Kq7DcnUfOZ9ODjTeKJYd6edDtvUPXYlIH0GWg8G3FTL5f0o/16mPpGn4yxvxiUMm37g4KU4Y6lmXFoEMMDYqpddhegvi5VkXxbX7QAv8Sb/ZL5AukqYx6AsXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGTY94KJURU/dSjHeJixB5iTlAIopNk5HnUCxMX+S2w=;
 b=AKwmitir4IFCdiQ7H/dH4xbRlPkAEPq2o4r9RgnTkfjCnJcYZMzAEzkMEGfl1z8MZokXUexN6PuzF6iS/DHCM+04XqiDvvuOv08K+fWEx76sQvP0KgA4ggFCFFvOTwoHotYceqv48n/QFj0QyPeiPJ3ZU0iLUdG5xM7qV38qEbZhaIDhmo6JkDtk5ePkaA7TMD6BG/NikLCq5wyKscpTdhLFWmqE2bsAgp+zyJyI4d3yrTrqvyxAy7gTPozQKEHHjJDz0Fcsk7XwD9OmnUSCWLnspFGszjYUsCL/wWDIqVmKoz5qgQ5zH0A1BlIv0Um7U04f5mwvLeHERP4eOBJY7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGTY94KJURU/dSjHeJixB5iTlAIopNk5HnUCxMX+S2w=;
 b=van0jARaqtxCFwCh8hJyXdlUAjfWipQGffDwT1nek+r/z4rPsSUC/LCsRDzWFGolj0mH8mZ9lJP2Gy+CKPoKK+AB9WqC4/ykfjKlr36DNhsKX57rXTJaQYX0yzfELQXLOiechB1BFzFefY4d6slE3TM9CqHtYK650HKqA35mp5M=
Received: from MN2PR11MB3550.namprd11.prod.outlook.com (20.178.251.149) by
 MN2PR11MB4335.namprd11.prod.outlook.com (52.135.38.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Mon, 20 Jan 2020 04:50:18 +0000
Received: from MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961]) by MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961%5]) with mapi id 15.20.2644.023; Mon, 20 Jan 2020
 04:50:18 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH V2 06/13] pm80xx : sysfs attribute for number of phys.
Thread-Topic: [PATCH V2 06/13] pm80xx : sysfs attribute for number of phys.
Thread-Index: AQHVzQVM4m0312Tz00K+Oc6s0kRuNKfu6LIAgAQWXPA=
Date:   Mon, 20 Jan 2020 04:50:18 +0000
Message-ID: <MN2PR11MB355086B3596903D935F678DCEF320@MN2PR11MB3550.namprd11.prod.outlook.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-7-deepak.ukey@microchip.com>
 <CAMGffEmBVJcDxZ1mkwzHwhsocvwHUxbZ-Xvvs4U+BGk7duxR7A@mail.gmail.com>
In-Reply-To: <CAMGffEmBVJcDxZ1mkwzHwhsocvwHUxbZ-Xvvs4U+BGk7duxR7A@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c22c010c-5995-4bb4-7e0f-08d79d643f9d
x-ms-traffictypediagnostic: MN2PR11MB4335:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB433515E6587ADFA1A5DE57CBEF320@MN2PR11MB4335.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(376002)(366004)(136003)(199004)(189003)(54906003)(7696005)(33656002)(316002)(7416002)(86362001)(8676002)(6916009)(55016002)(478600001)(186003)(53546011)(6506007)(4326008)(4744005)(9686003)(81156014)(81166006)(8936002)(26005)(66476007)(71200400001)(76116006)(66946007)(66556008)(52536014)(5660300002)(66446008)(64756008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4335;H:MN2PR11MB3550.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1MZojjcVjUai7t2PdZwtZV6pxX9iuMTKJ9mm8l1xVioPtKoS8apqbRUvhb0pfP5KCqodDyT37biTG1/apjAZeqdv9rmldvDlLc8al2zj/+OCTJzLux9jGWrNl6kAStU8vpN+5K0bgirnjF/XmDe3Ia6Dav+hvgP6H7mAI5JC3fAIZZJEMmo+vPNwTjDpBq/0SBDGmSyJYs7Ez0ldRAVp6s3p2YloUMA7IuSIXsOd6ydlZUe6rJCGddvlLrQm9O+5viGJ1O3VZxfbhA3LaP34xxmm8yxszlMyDI6XGqx+HqEJGcijTvdtvzmdk4DSjUUxo9k97EQtU/yUazpMx1YoqzvLdzoe5wwoWS50okqg/FeafQhdnE4Mr03VPpsyl09vU2LxJFSrH6S0y6CuMZwMXrlyC1RX9zg516c5DMYRf5AzvQcrbp9nzpe6rRSMVGMk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c22c010c-5995-4bb4-7e0f-08d79d643f9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 04:50:18.4361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ENOz4KbaU/Fko807H++Xr1KYJwHeb+Cx1L6lXmnBx4JFSKtxGgg9Bdps8K9q3RUcGB4HJJPOhLFabyssvkKCj5IWdn4rQIESCqayVlb/Nbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4335
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMg
dW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCg0KT24gRnJpLCBKYW4gMTcsIDIw
MjAgYXQgODoxMCBBTSBEZWVwYWsgVWtleSA8ZGVlcGFrLnVrZXlAbWljcm9jaGlwLmNvbT4gd3Jv
dGU6DQo+DQo+IEZyb206IFZpc3dhcyBHIDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tPg0KPg0KPiBB
ZGRlZCBzeXNmcyBhdHRyaWJ1dGUgdG8gc2hvdyBudW1iZXIgb2YgcGh5cy4NCj4NCj4gU2lnbmVk
LW9mZi1ieTogRGVlcGFrIFVrZXkgPGRlZXBhay51a2V5QG1pY3JvY2hpcC5jb20+DQo+IFNpZ25l
ZC1vZmYtYnk6IFZpc3dhcyBHIDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tPg0KPiBTaWduZWQtb2Zm
LWJ5OiBSYWRoYSBSYW1hY2hhbmRyYW4gPHJhZGhhQGdvb2dsZS5jb20+DQpJIGFncmVlIHdpdGgg
Sm9obiBHYXJ5LCB0aGUgbWdtdCB0b29sIGNhbiBnZXQgdGhlIGluZm8gZnJvbSAvc3lzL2NsYXNz
L3Nhc19waHksIG5vIG5lZWQgdG8gYWRkIGFuIGV4dHJhIHN5c2ZzLg0KDQpJIHN1Z2dlc3QgZHJv
cHBpbmcgdGhlIHBhdGNoLg0KPiBXZSBoYXZlIEhCQSBhcHBsaWNhdGlvbiBhbHJlYWR5IGluIHVz
ZSBieSBjdXN0b21lciB3aGljaCB1c2VzIHRoaXMgc3lzZnMgZW50cnkuIFNvIGlzIGl0IGZpbmUg
dG8ga2VlcCB0aGlzIHBhdGNoPw0KVGhhbmtzIQ0K
