Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4262C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 08:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9855464ED6
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 08:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhBXIMm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:12:42 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43445 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbhBXIM3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 03:12:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614154349; x=1645690349;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JdBowUOR9xhpvypdFCLhGt1cLUn85NmP6WmORySDPSY=;
  b=JnWCJHQ8Hb9KhkIAmrR4P4i6hDCcB8JAAN7hL9eBnfcZcPslAX1XSW/R
   bTaA+i2S1zAiv0caPj54PkO0Ud5CX+vdjgi19gh/BDoZcFMwzgf2lek4A
   JagDqfOS4DNGRnC0Dfdee+T47m17Nvde7QfGHeQMnOm3PMIDbrjLtdp16
   0CjEqoehcP2XP4/B9zI5vuqL/1fy6D3vPQ3dr9yZib/HM60w5ejl5nrWZ
   yUzl2J6sh42NDAQHG9EQ5H8LaGtZvFOs3Gh0uEgdqNWpO2snAq3zT98uh
   U3lII/0lZliNr3QvStjaMeMDQoZW5NE0VQkOlxJedW4tE0xlZKXFYclcm
   A==;
IronPort-SDR: T3yFq6R6kCjHYBjg7BqZMthf+wre2n6OZBtiHrCpuLNdAVrVODMFZbIktC5VLGGi8UmICPpRUW
 f7XDSLa1UdsMIxkFH37o9+1D6D3FsNqv0J/GiTt6kpgbLZgfQ18lQWiM7wjkBIWrtz3gsdSgRh
 7WVL/1Y+HwqvGGMwmWd0zYFWJTyIv+mDfAekJaMhVgoQEuyEeOVIBsDoK6fAPQD70h/16SBU1u
 gBzxc8ngY26rPn5pM1VSuYVZT1sqoNWrBcYotx4eaRyVURCH9MgOAdvWO5+zqrnZt5IRKPHAZb
 nB8=
X-IronPort-AV: E=Sophos;i="5.81,202,1610380800"; 
   d="scan'208";a="161841683"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2021 16:11:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHwTFpqJa6N5uvTbUppBhNrN5ewyfVWx38OXeb3uu3y0JXqkoEBSvqvCDZlaJ1/Vegle3UqcNHpOq0m/TJP22tSUkCKwrVuteMWy5mY6/WPaJV3/lLMo4q74NHEFqR9UgP1wktKn7BzwOHGTNicWXuGxs7LFVLjP/PzDSNVYyVjc5N7A7fK6M613Eo4W1HGNWfMQRChaOzSimQ4CLecm79oei44ap1jE3W0KK274MW1uJneQJS8CieK8PU6B8CUn3nGIAixn+qn1U06/Jlee54t2E+98gwbhtSpkGY0GNSLgLAjmuzOQiucK1KL3h49zRTLST4hAE/pdu/XqvMAYUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdBowUOR9xhpvypdFCLhGt1cLUn85NmP6WmORySDPSY=;
 b=gOecampWB2nqHxBytekaUfqOJH5bTPs9dG+r4bFOZQodRFryJDvwlq1m4QDn0TUH7O6BKuDNVTgLTbejhE23dJcnejwDIdo9DgQnvc29cMHskCKe/hu9N+d38l2Uk0yCeaRphKF6HMU0INBeCtmu629jAIKg5rCcoTmkD5gmp1KMFNTbjcqaag72nohzxoOPvMypWeM8CeSRBkx3qCq0ZATEyNVvGan/RZ/sesuvRyea9lrlt4D0OyebJ97HKS3LuS7omKay5nXogn3fahxBO1Gs1fReO53ark7Q4KRxIikHmaN5lwIc5zD3jzm7fR/B4ZZXykLgYzJkVC2cvmDZqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdBowUOR9xhpvypdFCLhGt1cLUn85NmP6WmORySDPSY=;
 b=0Hm46IdJEgg7miE86Fucx97csSgVg3n/3Vg0LIa7Kr3Yia2x4fnNI7ssLW+VecCEDyYr1ULay25yLnKjedAqlp1HDiKc6uUNck7aTBvdhhmtb56TuL6yZqi1stnMRnkQGKeZrO9sGJuQX3TDXVgmcSAueN5LBHG2yrgmsU4kP0Q=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4172.namprd04.prod.outlook.com (2603:10b6:5:99::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.32; Wed, 24 Feb 2021 08:11:18 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 08:11:18 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXCP2Y/e9Fs0BGVk+8HmhkjtrqFapm8BjA
Date:   Wed, 24 Feb 2021 08:11:18 +0000
Message-ID: <DM6PR04MB65752D7DA8F8CFAF06FFE213FC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p1>
 <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
In-Reply-To: <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 644cf576-1106-40d7-4d71-08d8d89bc3cd
x-ms-traffictypediagnostic: DM6PR04MB4172:
x-microsoft-antispam-prvs: <DM6PR04MB417213DB728B2888A79A934AFC9F9@DM6PR04MB4172.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mSSLDCzQvQxwXL/0edJDJrpXhe9aNMdsppwFHXbHlj/3AoEz7ajONX6+qZqaQzvolJHgonuQk1sfzSWsPI6xhzFfVuW+OQAnnS241INpmEMYJ3xdgn1MWTmauu/cXACE49Wh4rGp7NDhZpnXKeBS51UBApM3wzsZBrvg2+JuAqJKVaG6fK47Cl1Yhn5LzNOX5n2K+W8G4uNVDQt8LzfTGcT90pySHTvQkweJyB43HfMEfuXn2roWdJaWhZRnlq4kOZ7Jyg6NzZJ6Nl9wFGJp/G55feZiPhQC4gcrNhorswboqJzO3QrDem8T/djG+O+5KjVmoDG1CBe/8P0U3TFnFa5y+Xt8Qzay8AuoQwlRZUDVczdXpJTcfFAD7rOW+8xCjq1/oBQrkmnjOX61qz+PZNZgJAfVAsuT11f0PVSa+BFz4crhRie6xdJ4wpakOTvM7YGWxndqQ0HqXSyqfusa7SS3XaDaoC3wjkJnkzpcG8OgrrjfH2D16Gn4FONAfLLmIcc4RL8G3FNORaOrS3dC+K4FWKU1ouQHJW2iHvgb1vO4cCCM9S4vK122kLjHNrxM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(7416002)(110136005)(52536014)(54906003)(921005)(71200400001)(26005)(7696005)(6506007)(2906002)(316002)(5660300002)(4326008)(8936002)(33656002)(76116006)(9686003)(4744005)(66446008)(55016002)(86362001)(66946007)(478600001)(64756008)(66476007)(8676002)(66556008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bU4reEt1YkpNUnlCK2puOG8vN2laNkNIVGF1MHhsdFZxWm45TitUNUhrdUk4?=
 =?utf-8?B?ZmVwNVI0TllVZmZMMkIrZjAwd2RXNE9hWHJmZWczTXNydjFDMjZETUVWSFps?=
 =?utf-8?B?cjZHdkM1cjFITU1nWkE1VkVQR203Y3NiMmlXMVA3YlhFN080cWwwRTltRkYv?=
 =?utf-8?B?WWtLSWhKZFpKSEJxZXBta3o5OE56dFFMN1FJa3RLR3FRbE9SeVJaWFhNUk9D?=
 =?utf-8?B?UW1JY3QxTXlFYjMwNVhKZlp3NnlyUElZdlk2RitKMTcreURIanZEL0lJUTA5?=
 =?utf-8?B?anFXRmk3Si8zcU40Z3VUb1hBNTc5dXhPWFZ1WEQxUU01c0wyTjNFcEo5R1dy?=
 =?utf-8?B?dWo1bnFrbGhyV1F0T2pYOVVka3REMCt0MmtGNVlqZW9wYVFZL0Nzc2pkK1Nt?=
 =?utf-8?B?eFJOdVFORGxvSk9GQllvWGYrSmdHK0NjQTNIdS9Wbk1nSERkNEU3d2hEMlE5?=
 =?utf-8?B?bXZuZXB4QytCa0JVRE9CUXJBVFdXZ21QWXc3OVhKalBkY0gvbURYbVgxSFJr?=
 =?utf-8?B?aG4yRGdKa0YxWElrdTlvM3orT2xkei9aMlR5VUdFejArWjRLNzZ6SjJpWkNk?=
 =?utf-8?B?eHNwU2dzRzVYSU4ySkFDMVZQN3gzM3pwKy8rQWZjd2xrQWNpa096N1FSSExJ?=
 =?utf-8?B?RlZER3Nyc2hnajBwVGNUU1hxTGQ4U1ZKY3pOWFJRdHlLb2N5ODF3VmlrMjY5?=
 =?utf-8?B?TFJkYVJod0QwRHExTWJ0NVlmN0hhc3FWb01WR2hHUHBKeUUyYXpwaGFLWTV4?=
 =?utf-8?B?c2ZUWGk2VTdvbGh5UzF0Z2d3UEZlTEdQeFlJbEtPRzhxTDFLOFZ4RnZLajE2?=
 =?utf-8?B?NzBpK29aMDZLMFlEenRLTTJmenE2UFQ4ejJvNktyVm1xWTk5dmRpN3pNNnFl?=
 =?utf-8?B?OVFEM3dHMmcraURjTWFSeXRTTStJSGRHU1NjaDZsSHpDRWJGQTlvYkJNQmx6?=
 =?utf-8?B?WDBiNnVMak9jZnpnK3BBSUVjZXBBZGsweUdSdjIvZ2xiM1k4T1N1SEVVR09R?=
 =?utf-8?B?WnZmMHUxalZOcEZhUXpXTWNFN2dDSnJ1cjF3SXFvNXVyVjBrSjE4K2VlRWE4?=
 =?utf-8?B?WlRtRmQvVjZtRitmZ3QrNkRUeUZZQnpBQUpoUVJFaHB5VUtTYmhnTDJyRGZC?=
 =?utf-8?B?NEM1NjBYb3Vza3Fod29xNDF6U1ZlaG9FYWkxKzFJeGJNak9ha3RZV3BxWWM5?=
 =?utf-8?B?b1l0MnFRTjc0VDdLdG1PcWppNTh0aTl0cXJhckpxMWt5ekwvdDJCamFSYnZJ?=
 =?utf-8?B?bWJ4R1RLK3B1MThUaE95d2xUMC9yUHVtODI1Y0dqV2xYUjdRSld1RFZ0YnJX?=
 =?utf-8?B?QWZ1ak1wQWdaY2srNDBxejZScW5jVURNa3NWUEJPdjJBMUJ3WUROVG4zZkEw?=
 =?utf-8?B?eGZNNnI3YWdrTFZ1Z1ZuRDhENmF1R0VIZ0dPZUhMQXl2K3RVaE5pcm5UaVRy?=
 =?utf-8?B?MG5mMExSOW4wNDNWVHV0cThrRVhFWTBJZHlyY1BxQUpjZTMydHFmYzBzNnM5?=
 =?utf-8?B?RmVrMWdtTjFBYlF4aE43ZDB3aFVZVUtmKzgreUEweXhWK3p1emNENllXYVA3?=
 =?utf-8?B?OWdhdEMwOHlpQkE3a2tnTHlOb3piWWtCZGo5UWY0SXF2V2ZLUFhvRUt5ZG9p?=
 =?utf-8?B?cEdiT3NLOEtuQkhSdWo5SHR3dllrczd4WEs1VzhBVUE0KzNBdlYzRlRWVndr?=
 =?utf-8?B?K3VtNW9CaVlaRDlyemVSRG5MYnJrUXR3Tm1BMlNOMlJLWk1VdkcyeEFIUWoy?=
 =?utf-8?Q?MbAyVZVRXPMTPeN+rQnzxfUGsXMlb5JnOB4ZQ86?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 644cf576-1106-40d7-4d71-08d8d89bc3cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 08:11:18.8471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cjFNmlW68nopw3adId8MVLN70EQizOW5J0dW4qXgyyh037mWIKuMRYxo5EKyo+b7E8qgmTnaq6ZI5GYbhohT1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4172
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICsgICAgICAgY29waWVkID0gdWZzaHBiX2ZpbGxfcHBuX2Zyb21fcGFnZShocGIsIHNyZ24t
Pm1jdHgsIHNyZ25fb2Zmc2V0LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgcHJlX3JlcS0+d2IubGVuIC0gb2Zmc2V0LA0KPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgJmFkZHJbb2Zmc2V0XSk7DQo+ICsNCj4gKyAgICAgICBp
ZiAoY29waWVkIDwgMCkNCj4gKyAgICAgICAgICAgICAgIGdvdG8gbWN0eF9lcnJvcjsNCj4gKw0K
PiArICAgICAgIG9mZnNldCArPSBjb3BpZWQ7DQo+ICsgICAgICAgc3Jnbl9vZmZzZXQgKz0gb2Zm
c2V0Ow0KVGhpcyBzZWVtcyB3cm9uZy4NCkhvdyBjb21lIHRoZSByZWdpb24gb2Zmc2V0IGlzIGFm
ZmVjdGVkIGZyb20gdGhlIG9mZnNldCBpbnNpZGUgdGhlIHBhZ2VzPw0KDQo+ICsNCj4gKyAgICAg
ICBpZiAoc3Jnbl9vZmZzZXQgPT0gaHBiLT5lbnRyaWVzX3Blcl9zcmduKSB7DQo+ICsgICAgICAg
ICAgICAgICBzcmduX29mZnNldCA9IDA7DQo+ICsNCj4gKyAgICAgICAgICAgICAgIGlmICgrK3Ny
Z25faWR4ID09IGhwYi0+c3JnbnNfcGVyX3Jnbikgew0KPiArICAgICAgICAgICAgICAgICAgICAg
ICBzcmduX2lkeCA9IDA7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJnbl9pZHgrKzsNCj4g
KyAgICAgICAgICAgICAgIH0NCj4gKyAgICAgICB9DQo+ICsNCj4gKyAgICAgICBpZiAob2Zmc2V0
IDwgcHJlX3JlcS0+d2IubGVuKQ0KPiArICAgICAgICAgICAgICAgZ290byBuZXh0X29mZnNldDsN
CklmIHRoZSA1MTJrIHJlc2lkZXMgaW4gYSBzaW5nbGUgc3VicmVnaW9uLCBhbmQgc3BhbiBhY3Jv
c3MgcGFnZXMsIGZpbGxfcHBuIHNob3VsZCB0YWtlIGNhcmUgb2YgdGhhdC4NCklmIHRoZSA1MTJr
IHNwYW5zIGFjcm9zcyBzdWJyZWdpb24gcmVnaW9ucywgdGhhbiBpdCBzcGFucyBhY3Jvc3MgMiBz
dWJyZWdpb25zIGF0IG1vc3QsDQphbmQgbWF5YmUgeW91IGNhbiB1c2UgaXQuDQo=
