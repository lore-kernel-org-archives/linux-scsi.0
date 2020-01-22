Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A564C2D0DB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 10:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57DC02467A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 10:13:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="2vJ9pl3D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgAVKNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:13:10 -0500
Received: from mail-eopbgr700050.outbound.protection.outlook.com ([40.107.70.50]:13837
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbgAVKNJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jan 2020 05:13:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FU7RRtLbYfK7FcdcPFGB8NuVG4GJeqb593nu03D4jgsDcpb+HkYvjXZa8cx8gPl2rBC1cQC3TMYsvlonmG4vdIyXbDS13eLFLinejEY2M1lwnjVpVwHMngNJLOmWazEMru273QNhzSX3u204VavtzuWlGm1Uc4AP9XEbod/qRLvezLhKUxLdmoGN6lUQu0WTqF8geQI8FumF9uPhQ3rp1+4jKJC8CPSy97/KSHOi8tJQiyvvtOh5HcA/KBLixn9n2YFlPb8VHGUqlmvL/mr32pqYnnX9ZhJNa581MQ6XfbnuCgInKHrpcm9J/pyLbJwsQsgBfLtH6zOVcNXxkc/Oiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CX6pziGARa/L/n723SZiftpSYWzqGTRf5azDIn2lG0I=;
 b=UnCDTklj/FSHzIvL1vd5ezAGiYt6KUlQdrr4qqWf1BQlWXkAE6p5BBiCjT4lBSmGGbB4Jmcmu+/tRc4x+G3Bh4M8FzHKyeVQWyachy4qD1VVOrsecgiUrihgEhhksNz8q+djD4B8pozwxfc2Zhv7uD+ck4vnhoG0ErC3QtAc6uyM8uSrXGnIcp/oBvygCVrjVWU6tag1FVlY3VcUJFdXkgShXdjB4jRQtKBMunLK40ht1sCvM9qfRODrb3tv0YCtGHQU43HEaFp2OU9Q7H7fSHIPn4bLom8CDjpZv6HKolq56OZtQFzheLM14YLDvukacECs0+gK8jIH00xeZQptpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CX6pziGARa/L/n723SZiftpSYWzqGTRf5azDIn2lG0I=;
 b=2vJ9pl3DIHO+qHf3G/3Y8U5bJehWDTpbsmwaivKJXvndANx4kslnVUja2k3McC+b3OdthWCW1sktAv3l2WGhEGYfIzphSa6toHF5LzjAKYSBkGqcf1DH7vqe2nyQS/n+aE8vUsQgQO59TwPky1buFFD7rgxbiXRrXPpd658iW4g=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5618.namprd08.prod.outlook.com (20.176.30.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Wed, 22 Jan 2020 10:13:07 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 10:13:07 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>, Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v4 6/8] scsi: ufs: Delete is_init_prefetch from
 struct ufs_hba
Thread-Topic: [EXT] Re: [PATCH v4 6/8] scsi: ufs: Delete is_init_prefetch from
 struct ufs_hba
Thread-Index: AQHV0OKpEYphl34CEkWQTtHRyWVo1qf2dIKw
Date:   Wed, 22 Jan 2020 10:13:06 +0000
Message-ID: <BN7PR08MB568440B056F3BD215C1C7B52DB0C0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200120130820.1737-1-huobean@gmail.com>
 <20200120130820.1737-7-huobean@gmail.com>
 <6b6a7998-b6e3-6019-8588-18dbf622579a@acm.org>
In-Reply-To: <6b6a7998-b6e3-6019-8588-18dbf622579a@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWM2Mzk1OWJjLTNjZmYtMTFlYS04Yjg5LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxjNjM5NTliZC0zY2ZmLTExZWEtOGI4OS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9Ijg4OCIgdD0iMTMyMjQxNjE1ODM5NTI2NTc1IiBoPSJqOUNxdXZoOXh3dnZFNTBGSUV2eC9GYzF6UDA9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUN2ZnFPSUROSFZBYVdRSlhNS1VSUndwWkFsY3dwUkZIQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQS9oVEN2d0FBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3cf65c31-7b7e-444d-cba4-08d79f23acf6
x-ms-traffictypediagnostic: BN7PR08MB5618:|BN7PR08MB5618:|BN7PR08MB5618:
x-microsoft-antispam-prvs: <BN7PR08MB5618B87A1C72CB0E414FC520DB0C0@BN7PR08MB5618.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(199004)(189003)(52536014)(55236004)(8676002)(71200400001)(86362001)(6506007)(53546011)(4744005)(55016002)(5660300002)(7696005)(186003)(33656002)(9686003)(7416002)(2906002)(26005)(316002)(54906003)(478600001)(66556008)(110136005)(8936002)(76116006)(4326008)(66946007)(64756008)(66476007)(81166006)(81156014)(66446008)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5618;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HrwxaRxliwVhrvawu7Zz/I0uI5zaNgDF3p5/Mj0RZWRo7BPDD5vs/61HaX2w2qA8pzKe/ApKOHe3p/ooFM/BsBYS+AJ1pID5iX+eRWGBc02T65WTqBvAND+Y7EOyLZrocOCMS0LqkI6WljwSFNp4oeQeP+2Dkk3CsfpgVgUtXGhxDdZEN52Df+Q3ey+idz7T9/lerLHF1RtOb/gILIhMZsbIqCdIGQcXn0w+KMZTMFKkFHyHYTszwY02n5bw4hx4TAFevwSRfHhEEs4qBpe52TGFZhlHCCUvrfM8HA37bHimHZ21ksDjthbsarm3DKQZ0Spi4WMwWKmBZB4mloGsyLEz7vmrrqLf2t8Q76tazyC2k/ieCXLLjU6vMELK5oAJetRBe+hovbsstExx1AJmmC6mOQN6mFxgFojBH7uosNUZDkEWls0eVZEBN039BYmNSGE6ZUgoTBpUvoBzyg/5ZWj/+AOXRdEr3JW3LztDwSMEFZn7Dd8Go9v/ZFiB6VJs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf65c31-7b7e-444d-cba4-08d79f23acf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 10:13:06.8562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tLX08kEqIcRvQhSfKgfx0wkP2fgRUwTpuw+O+tyfPOmvz3AG0bpJ/DD/BU19gvqs8hsrFmmMY0AQkeqGbq9Kug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5618
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJhcnQNCg0KPiANCj4gT24gMjAyMC0wMS0yMCAwNTowOCwgQmVhbiBIdW8gd3JvdGU6DQo+
ID4gV2l0aG91dCB2YXJpYWJsZSBpc19pbml0X3ByZWZldGNoLCB0aGUgY3VycmVudCBsb2dpYyBj
YW4gZ3VhcmFudGVlDQo+ID4gdWZzaGNkX2luaXRfaWNjX2xldmVscygpIHdpbGwgZXhlY3V0ZSBv
bmx5IG9uY2UsIGRlbGV0ZSBpdCBub3cuDQo+IA0KPiBIb3cgYWJvdXQgY2hhbmdpbmcgdGhpcyBk
ZXNjcmlwdGlvbiBpbnRvIHRoZSBmb2xsb3dpbmc6DQo+IA0KPiBBIHByZXZpb3VzIHBhdGNoIGlu
IHRoaXMgc2VyaWVzIGludHJvZHVjZWQgdWZzaGNkX2FkZF9sdXMoKS4gVGhhdCBmdW5jdGlvbiBp
cw0KPiBjYWxsZWQgb25jZSBwZXIgSEJBIHdoaWNoIG1ha2VzIHRoZSBpc19pbml0X3ByZWZldGNo
IG1lbWJlciBzdXBlcmZsdW91cy4NCj4gSGVuY2UgcmVtb3ZlIHRoZSBpc19pbml0X3ByZWZldGNo
IG1lbWJlci4NCj4gDQo+IEFueXdheToNCj4gDQo+IFJldmlld2VkLWJ5OiBCYXJ0IFZhbiBBc3Nj
aGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCg0KVmllbGVuIERhbmsuICANClllcywgSSBhZ3JlZSB5
b3VyIGNvbW1pdCBtZXNzYWdlIGlzIGJldHRlciB0aGFuIG1pbmUuIGJ1dCB0aGV5IGhhdmUgdGhl
IHNhbWUgZmluYWwgbWVhbmluZy4NCkFuZCBJIHNlZSBNYXJ0aW4gaGFzIG1haW5saW5lZCBteSBw
YXRjaGVzLCAgaWYgaGUgbmVlZCBteSBuZXh0IG9uZSwgSSB3aWxsIGNoYW5nZSB0byB5b3VyIGRl
c2NyaXB0aW9uLg0KDQpUaGFua3MsIA0KDQovL0JlYW4NCg==
