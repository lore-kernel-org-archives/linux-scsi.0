Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CD8C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 19:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2112364F59
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 19:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhCQTGW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 15:06:22 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:56513 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbhCQTGM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 15:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616007973; x=1647543973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OUzJ9YCvDM8flQ8OCal77A1B9OuBVlhrQ4fUW+iO+Rg=;
  b=DgEqD0ZICwswC5MXVeef0H3Iwn6Eeqh48QZW3XrJmelDypM47Jky+0TS
   f98SXdKXBqGcpFfjCTMrIAtSmReug32XKD/OXOeXWaHO0mw12xFdPyCos
   5ev7yKZsT+AgWHkgoKLGAhJTyJypZhWmaTb/ZBPpBZXveIdiWa6m0hJW4
   8j1iSVoZRHEzJOho7826nqn479VQeM6z+ZBk8anP3Lwcqxn/DiYg+gdL8
   vUEADVqohauQehOF6oOtQO2sPJqdbK9gEQNsyM8HDnQpA0w/pGj8cK+KA
   +vCG3pese7dqEsISkOQV6JekZhenwDJDSJFiAJ9Hec6zRcRGS8j4qQZ0T
   Q==;
IronPort-SDR: /CrjpDld86lwceixdOobX6+5d4aX/q7/5qrPffK23E6mFeA/EacUzemkmygs4NMVsl3PP56LTb
 cmkv93bxg7qHsaGfMOIxBLGwbuAX8SXxbDX65QL5Y8/eblpBYacKQYCRdKVGoig1sSiPCVdVEz
 gMCk/+g/Juz9wA21fewmLYS7gghHxfHBnb2Zb+3gF+h7BreEv/7GSIES98t59eo0HFSSKUz1oe
 8PjN0+CoYHWYbNl/5JLnETkGevzXXABDsx1I7XhD64dn3Od/mFsDS+yIFzxHsg//dOOZ5niI+m
 oMs=
X-IronPort-AV: E=Sophos;i="5.81,257,1610434800"; 
   d="scan'208";a="113140007"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2021 12:06:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 17 Mar 2021 12:06:11 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Wed, 17 Mar 2021 12:06:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Evw7RIstx31AJ6jRjsvahWcs2v3H7V2KxmsAgLfjGncGIDk/mNIDPJwISDdXcKlLdKiRMlZXVHkwWbs8zeoiJhPteQ5Lhj78ob+AgiS2skc+vwZB/9KUVYStzGdwOdQW+qCcMuIsAYhkO804t8dxmV6l3tuUgUJ8jJaBNjLsxoqyUc3brevLUnGtEPjxgbP17/aaiXdw8deXiBIwXFvPPa34d6bGacr4+a3sj5So1EnVo/Mw3d51e/JxuYe83/RMIt5c8QHcix5ubUKkUxyEdMFnIkpScrBPp4Ku71i5wnEcL7B1m6t7A+d3UCZqzDUWlGBcNdytuNHZqxNeE9HEtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUzJ9YCvDM8flQ8OCal77A1B9OuBVlhrQ4fUW+iO+Rg=;
 b=nH9HMt5i2sSZsDjguo6Q2VjpVReY0vVCT+ENKxOXFfc2ABWcHM3eXibZlXsdr2r/9bwssYmUvQY+FnG3HHU2m3lxs6p/PBi1hvxiOQkuw0PHnTsxCrlNioqgHg6Miperb07iJ/JLus0Ol99oAiV9iBj4Hn/uP61p292uMi6aATIEYMZIeY6+06+TlCFYq6P8d+xNZWprXtiYDdJlGXakEAYHixHfwMxSm5aXWRnozbeXf/qnPyqPWEMg5ZyYDd+/EPSS7FDUSb9MDx1klBlFKN6T+iV4gRR/LDvehqGhZNwY9+ZHAaNDC5eM3pPjRJ9OwPsnUivoDDKoxJ1seGzM2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUzJ9YCvDM8flQ8OCal77A1B9OuBVlhrQ4fUW+iO+Rg=;
 b=aE6rREX+hWarf9z6wLFzum+ZGTMXY5wRUbRllsOmdrRd8BXAwPHlyTo8O82OD+If53KOKSsiFVS2KUWWCDsGVEZcMhPw+FfLneFZG6UV4wirmKzBF57c8t18uNitFEDtchpbFZMpHytvy2Xmz+GPE62mdIaLNsA1nDr1i2TSIkA=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3376.namprd11.prod.outlook.com (2603:10b6:805:c7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 19:06:10 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::a002:6253:12fe:2d2e]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::a002:6253:12fe:2d2e%5]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 19:06:10 +0000
From:   <Don.Brace@microchip.com>
To:     <David.Laight@ACULAB.COM>, <martin.petersen@oracle.com>,
        <arnd@kernel.org>
CC:     <slyfox@gentoo.org>, <linux-kernel@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <storagedev@microchip.com>,
        <linux-scsi@vger.kernel.org>, <jszczype@redhat.com>,
        <Scott.Benesh@microchip.com>, <Scott.Teel@microchip.com>,
        <thenzl@redhat.com>, <glaubitz@physik.fu-berlin.de>
Subject: RE: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
Thread-Topic: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
Thread-Index: AQHXF4722AqRbCqQukSHQNjL/VV846qGzRcggAAoFQCAAIVo44AAtpiAgAA5xRA=
Date:   Wed, 17 Mar 2021 19:06:10 +0000
Message-ID: <SN6PR11MB284874C2DA729D8896D78777E16A9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
        <20210312222718.4117508-1-slyfox@gentoo.org>
        <SN6PR11MB2848561E3D85A8F55EB86977E16B9@SN6PR11MB2848.namprd11.prod.outlook.com>
        <CAK8P3a3JYmhbN3TXB2cWGfXGKgsUa9Hg=ZvWckTaL_31OMgbtQ@mail.gmail.com>
 <yq1zgz21rkz.fsf@ca-mkp.ca.oracle.com>
 <4b2a64d91c4c478f881d9713cac5001b@AcuMS.aculab.com>
In-Reply-To: <4b2a64d91c4c478f881d9713cac5001b@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ACULAB.COM; dkim=none (message not signed)
 header.d=none;ACULAB.COM; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: febd1a5a-7b1e-455a-a004-08d8e977ba32
x-ms-traffictypediagnostic: SN6PR11MB3376:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB337684FC1476626F99E5BBE8E16A9@SN6PR11MB3376.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b9OeH7/8f9mg6Sw0QX3Sl7fs7nwgHFjmYYfZbKu75UMcXBjA2qZe8po6QteOcHZWad8tcRpmZd7IjPYBAA52WbUTd8D9obsYLKkypJWuR96TmC0iKoFU7dxdRsoVCS+cpsHOuOJAiLwh3Fr6uPNqwCgHjWwy9d59Io2fDu7QEcD3Rl66R8TvE14BTiMTYnhEpSd3tdvJR4bXGYlCfiH0KR0VfQautmR+WCUXVG6Hd9JMZKrskXjkmbw+M6HQacUdXWsI70sCPQcD6Q/O6sYsYpPD902oyckqZTNzN75AYU6v+qEjTN6gy18b9vcST/yOfVgvc05fijGfpg24vt4kFDnFIFIrrq5DpDlFU8K4hd8acnPKeNvcdAEFOUO2NYTymJH6+6SZ+I18aOGN3SdU4xBcpKvTyUw2TOs3+l8LUs0m5P7WCygSzyQvV7XJKxJxrkAHY7sT4fFopTIqHetWlYmuBFX7xLOgS00Lh1uX0Iz9W9/nv6rXWHOGLHiMlKy7dneinMKtBGaQ6h0Cf3wv/uSmiyAGArhMityw0WOruAtBykBBUf0YCR2xebpctUF3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(366004)(39860400002)(7416002)(2906002)(8676002)(110136005)(54906003)(33656002)(8936002)(83380400001)(66946007)(66476007)(478600001)(6506007)(64756008)(66556008)(66446008)(4326008)(71200400001)(52536014)(26005)(316002)(5660300002)(86362001)(55016002)(186003)(9686003)(76116006)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L1VJeWpiZ0w4Ukc5ZHY5WHJnTm1SdVYrOTh2ZGFZTjFZNVB0WVVLRU1aSzFZ?=
 =?utf-8?B?aEVpK2ZmQTZhaTRWaGg2TG43T1FqaHRQaDBxQ2YrVzFiWTNrSDBjMnFxNGpY?=
 =?utf-8?B?R2hZd0hLT2VYL1dEam84QXM2UDVwWklCNnZna3hCUnhIMzJTVHB2L3c0U2hM?=
 =?utf-8?B?WCsrcGtwYVAwdERJOHNZU0IwZ0NOWmc4Y25US1JlWVJTRTRLVndGSklrMGZz?=
 =?utf-8?B?VFUyTndvOXNEcVljM1NZSHJ1TEFMOGlpSmFYV3V2L3A3YzFSN0pKSXNGbjc2?=
 =?utf-8?B?R1ZTLzA0cis1U1NNTXJORk1mOEpYQUE2Z3k1UG44NnFFTGY3ZmZHWG1pdE54?=
 =?utf-8?B?TnFNaWNvVkk2TnBMcFFJS0lDOEExTzNVNVZnd3UwbGNjbEJMV1FtZkRVNUFp?=
 =?utf-8?B?ODZNUW9CdnZTZThrUXhoTmxZZEh6QU11Vk5odm9BOFp0WFd1cGhKWjN3WElj?=
 =?utf-8?B?dUJoeXFTQzJVb1d6algwMUo4WTlSOFFDdk1Nd2pzQXBZdTlTbUFXcEZpbXBU?=
 =?utf-8?B?V0xCRGxIc2hlbng0clZVeFU2QW5udTIvN21ZMmFLMVBVTHZvRWRLbFgrMUxa?=
 =?utf-8?B?bmlKLzFCZTRSYiszN0JwcjlxQldBMHVzQ1VBaXJSc28yeXpjWk52UGdFT1dH?=
 =?utf-8?B?Sk4wWmoyVEsvN0JZS0U0d2hsbnJVUmZNRnlFZXRVcjJ6eEVobiszbkk5ampU?=
 =?utf-8?B?aGRFcXJ5b1lsMDB3RFYxMVZrL1dVaG14eGd6b3pqa2dFRUxnWVh3ZGJxYmZP?=
 =?utf-8?B?WFhOcGtxSUllTCtjOUg2bXJOQkIrc1lUSTJnUk9BSzlJVFVwbWNwV2wxTmJJ?=
 =?utf-8?B?a3dwSEhOT1NMSFZXS2sxWFlCQjhyRVRDZkVHSmhNMTQzcGt4SmhaZlNvUm51?=
 =?utf-8?B?TExUYXAvQmxSZVBYeDRuakxKZjMwbUwxejBMbUhlcnA4cisxU3k3dk41ZkRG?=
 =?utf-8?B?NU1wUk1DdnpKQ3ZWVmVqUUxWZDA1YklpT0t1RE1qT3dHYStmWGZNcWU5VlBw?=
 =?utf-8?B?aGlvTXAzZyt0SC9haWk2UWlVeXovbTRIclR1a0ZhM3g4d25xKzd1M2t4Wjgw?=
 =?utf-8?B?Y2RiQ09CcVRSTW5WN1hUSHdHaHJVS3RyUm5FLzN3eVJyM1I2UU1RUjYrM3dk?=
 =?utf-8?B?RG9lRjBoWDRLcnV4NWdlQks3NUlzQzBXdnlQS1Z0NHN0NzlGU0s4WmpweldH?=
 =?utf-8?B?cWdWNzNvSExqYzFEVFdNaHNCNWZQd0dZN3grYXRNOGFjSXU3ZUlOY0kxdTUx?=
 =?utf-8?B?aUJyRDdaWjNlMDNreXdkWjhUeGl0cXVkZGFkSE5ZNHpqbnozMi9DS3ZPdk9a?=
 =?utf-8?B?d012MVZOU3duNWFoc29uT1ZaR3RMdFFhNzBNZHZOY2NNSDgxdjhrb0hqelo3?=
 =?utf-8?B?SEQvL3QzUTJITUN6ZWlnc0hvL2d5VWZ6KzF3WjluQkNoMTVQNDJsNFAwQThG?=
 =?utf-8?B?bVlPcGJGRkpMWHhrV1Y2a0VsUHFTanRhNktvWktSSHhyVGZPYzloL3VsWStY?=
 =?utf-8?B?NzBoYzQ5ejRkMEQ2TmpGL1VscjNQaFV6UVV1UlpEclEwdEwzNHNJZXBIdkRO?=
 =?utf-8?B?bVpnTklKeFVEOUVqbXp0TlBFaVFmTXlGNGllMTJjTmpLQnFqOHBLWkdFNjM4?=
 =?utf-8?B?MjI4SG9vUC9yY1Bmd3dmYmZQZkgwVzdNdEo5YkJFZVRwNExFTWxaa3N2ZENn?=
 =?utf-8?B?REIyOTU4enhCYUtzeFhmbHpZU1FieTh6OG91V3lFbVlYQzNvS0hsYjNyZnVz?=
 =?utf-8?Q?Llz5P0TjPQLrsmfavU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: febd1a5a-7b1e-455a-a004-08d8e977ba32
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 19:06:10.6395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r1nrcm//9FWXaetNbKE7NQBGGjAg4CMyX/uZzAf4KlJxinzZ4BgHMFCEgO1zUC2Eug27heHsT22mGx0uUL8JJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3376
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IERhdmlkIExhaWdodCBbbWFpbHRvOkRh
dmlkLkxhaWdodEBBQ1VMQUIuQ09NXSANClN1YmplY3Q6IFJFOiBbUEFUQ0hdIGhwc2E6IGZpeCBi
b290IG9uIGlhNjQgKGF0b21pY190IGFsaWdubWVudCkNCg0KRnJvbTogTWFydGluIEsuIFBldGVy
c2VuDQo+IFNlbnQ6IDE3IE1hcmNoIDIwMjEgMDI6MjYNCj4NCj4gQXJuZCwNCj4NCj4gPiBBY3R1
YWxseSB0aGF0IHN0aWxsIGZlZWxzIHdyb25nOiB0aGUgYW5ub3RhdGlvbiBvZiB0aGUgc3RydWN0
IGlzIHRvIA0KPiA+IHBhY2sgZXZlcnkgbWVtYmVyLCB3aGljaCBjYXVzZXMgdGhlIGFjY2VzcyB0
byBiZSBkb25lIGluIGJ5dGUgdW5pdHMgDQo+ID4gb24gYXJjaGl0ZWN0dXJlcyB0aGF0IGRvIG5v
dCBoYXZlIGhhcmR3YXJlIHVuYWxpZ25lZCBsb2FkL3N0b3JlIA0KPiA+IGluc3RydWN0aW9ucywg
YXQgbGVhc3QgZm9yIHRoaW5ncyBsaWtlIGF0b21pY19yZWFkKCkgdGhhdCBkb2VzIG5vdCANCj4g
PiBnbyB0aHJvdWdoIGEgY21weGNoZygpIG9yIGxsL3NjIGN5Y2xlLg0KPg0KPiA+IFRoaXMgY2hh
bmdlIG1heSBmaXggaXRhbml1bSwgYnV0IGl0J3Mgc3RpbGwgbm90IGNvcnJlY3QuIE90aGVyIA0K
PiA+IGFyY2hpdGVjdHVyZXMgd291bGQgaGF2ZSBhbHJlYWR5IGJlZW4gYnJva2VuIGJlZm9yZSB0
aGUgcmVjZW50IA0KPiA+IGNoYW5nZSwgYnV0IHRoYXQncyBub3QgYSByZWFzb24gYWdhaW5zdCBm
aXhpbmcgdGhlbSBub3cuDQo+DQo+IEkgYWdyZWUuIEkgdW5kZXJzdGFuZCB3aHkgdGhlcmUgYXJl
IHJlc3RyaWN0aW9ucyBvbiBmaWVsZHMgY29uc3VtZWQgYnkgDQo+IHRoZSBoYXJkd2FyZS4gQnV0
IGZvciBmaWVsZHMgaW50ZXJuYWwgdG8gdGhlIGRyaXZlciB0aGUgcGFja2luZyANCj4gZG9lc24n
dCBtYWtlIHNlbnNlIHRvIG1lLg0KDQpKZWVwZXJzIC0tIHRoYXQgZ2xvYmFsICNwcmFnbWEgcGFj
aygxKSBpcyBib2xsb2Nrcy4NCg0KSSB0aGluayB0aGVyZSBhcmUgYSBjb3VwbGUgb2YgX191NjQg
dGhhdCBhcmUgMzJiaXQgYWxpZ25lZC4NCkp1c3QgbWFya2luZyB0aG9zZSBmaWVsZCBfX3BhY2tl
ZCBfX2FsaWduZWQoNCkgc2hvdWxkIGhhdmUgdGhlIGRlc2lyZWQgZWZmZWN0Lg0KT3IgdXNlIGEg
dHlwZWRlZiBmb3IgJ19fdTY0IHdpdGggMzJiaXQgYWxpZ25tZW50Jy4NCihUaGVyZSBwcm9iYWJs
eSBvdWdodCB0byBiZSBvbmUgaW4gdHlwZXMuaCkNCg0KVGhlbiBhZGQgY29tcGlsZS10aW1lIGFz
c2VydHMgdGhhdCBhbnkgbm9uLXRyaXZpYWwgc3RydWN0dXJlcyB0aGUgaGFyZHdhcmUgYWNjZXNz
ZXMgYXJlIHRoZSByaWdodCBzaXplLg0KDQogICAgICAgIERhdmlkDQoNCkRvbjogTXkgZGlsZW1t
YSBpcyB0aGF0IGhwc2EgaXMgbm93IGEgbWFpbnRlbmFuY2UgZHJpdmVyIGFuZCBtYWtpbmcgbW9y
ZSBwYWNraW5nL2FsaWdubWVudCBjaGFuZ2VzIHdvdWxkIHRyaWdnZXIgYSBsb3Qgb2YgcmVncmVz
c2lvbiB0ZXN0aW5nLiBNeSBsYXN0IHBhdGNoIGFsaWducyB0aGUgc3RydWN0dXJlIHdpdGggd2hh
dCBoYXMgYmVlbiBpbiBwbGFjZSBmb3IgYSBsb25nIHRpbWUgbm93LiBBbGwgSSBkaWQgd2FzIHJl
bmFtZSBhbiB1bnVzZWQgdmFyaWFibGUuIFNvIG1ha2luZyBhbnkgbW9yZSBjaGFuZ2VzIGlzIG5v
dCBoaWdoIG9uIG15IHRvZG8gbGlzdC4uLg0KDQoNCg==
