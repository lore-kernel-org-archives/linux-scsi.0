Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5B1C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 13:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239266AbiAFNMV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jan 2022 08:12:21 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:15316 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238990AbiAFNMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2022 08:12:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641474738; x=1673010738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iqXjMK4ljwovemeIv0rtfsWznW1QzIlgWzUMrwAym6g=;
  b=1UTe/S+JgrVvsp9lYHf8b1flwwjOCZX3rimnanMiVdlHvkIfW71tUlg2
   xYb9fyH/+CUyMEtpxMZvKvFZUoobTau8PJIypM5Nemwm38eSywSP1qqKw
   Ti8dbTCPix6zKUfbp0lrpboqxUzxmrIthlwYiol7XMivpsbH8fTSwQoK0
   mo6RnUFTwsNOMoAvxNLVKu+4REfWSinjka9SVCBDAuCPQCPhSzHecZSFt
   451bmMHoUUiKvhSR3RIn6G6EsF7ha15kFpQzeUxEVmoUtoyjQMmExW3F4
   9Gk0RO+/jg1wJiyLSDLttDxXoFH3zAYWtZdjscjo3I3ECfCHqxGzTHgXR
   w==;
IronPort-SDR: eBcggemMhM2MFj5WHk/kzAzKd4VTKhzVCw0ExbVVFBa5LYHQsYneEtBrYfHUFJqig+G6olfSD3
 EoT+avGeoa8Ky8XcmlvFG8dS2aZrimIwHhWKkX81yprcS0GUl9DecdDLwdCuyX3UsOVmbz6Hyi
 ON7TMb0xVbqV+qlQiccdFc4vk4GS4/skjW7qK3SGLj2KQvRJ1Xzf3S4Dt2E5i9S5wIQt52nBh9
 2mU9psLW7nFkEjogmo+1a/JaG6yFA9xkeA2PZId97T/bFQVTxZy9XxE2GnpEPmyRPE6wLKQmeA
 gIj1DTs+tJFEajwbGf2Y4Fu2
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="141855410"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jan 2022 06:12:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 06:12:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 6 Jan 2022 06:12:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJuT0Yr3eoSmoVZ5C4YwcY342arE4wgi9PtdRqfKu64QNslPlJ3vbq7yLZeQHZITWsh9InB8e/Km4bhvmJgA1l+nbSRt80+3d3TdARygIAoIUmQtoGvqJIKqGi8vid/HUC2jFv7YLKHmqvaDTOvYTB+f/O+UYE7C3Gvg9Xsqn6AjGhYd0oDqqC8zf2FUV3Q1bw305KE2rhM24dR3tow31uDJuvtGpZIX1HOX4+OTcBwNl8TOH4N18exkXSi1mboQSfIERymNw2c/rF1eGN183A9nkYTRzmdMEi3VMAn1Fas8/3AT7/tWNTByxW2HSDuQSsjS537oU0Hld4AOrOhmbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqXjMK4ljwovemeIv0rtfsWznW1QzIlgWzUMrwAym6g=;
 b=iNG3KKvUxVCkpxRd8eIfqEJ6NTtbqlvrLVfB3kYW5+aDDJmp56MV8GoQzzedDNJFvzgxSyzFbVF/Tpfqt3B2SJ6S+IKj+weo2qe+0QOQBVBCFidyHYdQPC2seTCk6/ZZ5V8H8f6QoFRM34uhce50avOeN2pFzoH0rJzSBDRLeJv0LeYtIbxEv7/iZfCnLaL78CQbvANgl4jWw5UbuP+CStjD/QATi9Wv9gqAjWGwBnZ3vdGy6oNQWkTOVOZ/Xfu70/RjEMkDYjtfU+GsvJDY2LBKfE0NxTUzx07pKy4wHekFMKm1usMCAJuh0LnwC6T7m8/RI5zKlyiev/QFoCtsNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqXjMK4ljwovemeIv0rtfsWznW1QzIlgWzUMrwAym6g=;
 b=iEQTN1dFKQ0gy0Yo6u7AO8iETBXpdm3uFEUNlzIq5cNzrujytGutplgcZl+/8DgJiHaVy2dLf9vG7A8x4V7agh0gXr9+A4jhkmphEblgBleq4E1QZntnyvonI/Wj8ocqsRrz43/EHeSaIrblR7eThlujl2N5kGx9JCKQIGNBlFM=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by PH7PR11MB5943.namprd11.prod.outlook.com (2603:10b6:510:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Thu, 6 Jan
 2022 13:12:11 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::ec81:740d:c5cf:5ad0]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::ec81:740d:c5cf:5ad0%5]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 13:12:11 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <jinpu.wang@ionos.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>
Subject: RE: [PATCH] scsi: pm80xx: port reset timeout error handling
 correction.
Thread-Topic: [PATCH] scsi: pm80xx: port reset timeout error handling
 correction.
Thread-Index: AQHX+9xLRROqj0JlV0qUV3z5cpBLyqxUAMiAgAIDqlA=
Date:   Thu, 6 Jan 2022 13:12:11 +0000
Message-ID: <PH0PR11MB511212DDDA9FE8F980888AFBEC4C9@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <20211228111753.10802-1-Ajish.Koshy@microchip.com>
 <CAMGffEnufGurL0FYetFKGe+ZpuEuwf69z1Hccn9Ppb+tQyT7Zg@mail.gmail.com>
In-Reply-To: <CAMGffEnufGurL0FYetFKGe+ZpuEuwf69z1Hccn9Ppb+tQyT7Zg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c3b54df-aefa-438e-13b2-08d9d116269e
x-ms-traffictypediagnostic: PH7PR11MB5943:EE_
x-microsoft-antispam-prvs: <PH7PR11MB594308D77A9DAAFDD274F726EC4C9@PH7PR11MB5943.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w9RutyphnFcl1sjNw2gVMydk0sv8ZuzwMmd8o6DfB/YpVebYJ3VRYh6uW+6qNfZh/Cdm3GGFxhZozybWjLPvyCRUDhqD+rW6inlF/QzvXO/j8qK6xhdSyLeqLpeYkZlxu0JJ6cxCGDmV/W9rlN2p5bMEJtyZ/zgOrVrp0K6czzwEouYVh9PDX+Gh0wHXc2FVHHg27zsTQY4VHotYxjCj3yKJIF+ouljdsvYAhppx1KuyqhpwOYSn+5pTom56VYX1r76h/1t9o8uzhZwQLeBuSn1MDg7WXQ5q68RY/7O6LOaF0EotT1wv6XRSGERTKFFPdCt2A79QDVUSvQ1AvGDgneEmqHTYycEAbHX2ZniSYWRAY6OpoBtg7wr9gM9A5A5odgMq0sA84/MD5mr/IUHtoRvgPDy+2U4Kz9NdABNJFlMvREC0EloixiCK/TynZ2018OyD1bHTG1bmiOveZRac6LjZxFopHRM7pOs7vtxw/7CmKRF9c6drnA7c7OcysgMgirH7W0jtZSY4ISeIvfiNb5sxGzPncUhkOfqDFPqeBoCitJZPNV+u3fcyfn/s1QeeJHh0MNdZ1AuIjhxowVZytMHdR0+rq5NmFyCxdRNylkpKyElwRd8Uh+g6BlGzQklHnaRQ8yM2iTrJ16b8FdE165dUZ+JjbcCU05hMzme9gEgU/0MTTNdiTRslILeTwQgo23YWsBI4aI6JAXSKN24CHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(53546011)(55236004)(71200400001)(122000001)(86362001)(38100700002)(316002)(5660300002)(186003)(38070700005)(26005)(66946007)(66446008)(66556008)(64756008)(6916009)(107886003)(55016003)(52536014)(54906003)(8936002)(508600001)(83380400001)(8676002)(76116006)(66476007)(7696005)(9686003)(33656002)(2906002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aEJ6L1g0d1d1T3NQSjdqL3JWQUZmNkpLSmltOHovVEwrb0xSNWVaNThxalVV?=
 =?utf-8?B?Uk1IcG16V0szYStPTG9RL2FIRi9DMC9Za0tJUldHMWZ0dXkvMThyNmNSTDZU?=
 =?utf-8?B?U0hkMDhWcnpMMkpseWwvUVhXcmVNQUVGNWJpTjFHNG1rNDdWdW80MVJWanE2?=
 =?utf-8?B?ZU1ObmRsbk9ucTJ3c0Rjb2M5YUpESE1VeUJLZFBLMVpzTVlsZDl3c2JJckU3?=
 =?utf-8?B?VXRpZTRDREpobkE1OXNPaER1L2RBZlMxWm1Va3crM1dKOXdveGNZcG8wSk9L?=
 =?utf-8?B?UnBrYlBHMHhhQjN2d1hJczFHNHBnT045OFBOMEhTSW51dzVMN0xEeDRJdmd0?=
 =?utf-8?B?cnVmU1EzSmlRcGVJK20xRis0WEtDazVmbDFBSHNuMThzVkczNU92dFdDVWRY?=
 =?utf-8?B?d3lSNENhOUZYcTg1alZRbFlCV1NmRC8vMlNMOVduMDZIVzY4N2l1QmhkWG93?=
 =?utf-8?B?WG0wR3VwcmdqY3h1ZTFxL3V0VW9NUDBrR0pEVHllVEQ0cXdSTVBxM3JVT1Z2?=
 =?utf-8?B?TGkxNFFjK0dLcjdxbXpsZ29jTEZvOVJyK2xoMkFmL01RT1VGNFFxSjBvRFB2?=
 =?utf-8?B?KzRlRDluYU4wWnRrNFNHWllWbGswcFpWZXpKZGhMcUs4V21GZVNzU3gvR2I3?=
 =?utf-8?B?QnlWTHVKUmlVV2tHK1BPWUYzT0ZRVTVzREMzT3lIbEZuSU5ZTFBubm5TMWwr?=
 =?utf-8?B?dmc1dkZaOGQzS1dpaGhCZDBDMy9rL00xYWl1RUd6M1R5dTNrVCs2L3JUZjg2?=
 =?utf-8?B?YTdsc0UyVWF2U2NpVldkOVVHMFlFMVI0L1o2a3JSRkJoSFdnQ053OHErenNo?=
 =?utf-8?B?TExWdjZkeXYxOEJZUERMOVFrSUFTVWY1K2pUQzExaGp5QjZQNUljc1hvdkxw?=
 =?utf-8?B?b0MxeUJiNzFBUzhlR0d1Rk1VK1pXL2FoalZBdTV3UWxLTCtFZDRidzhrVkFL?=
 =?utf-8?B?V1BEU2FmVkFiYnpNaDQ0TGFHY09ZU2lWSEcvMHVYODdZRGF1bDRjdC8yejFL?=
 =?utf-8?B?c2ltcXg1aXRmbVZXTzVXTjJPRXYrYjRxVzNGck16MU9PTGRqclFUS2hXd2xu?=
 =?utf-8?B?d3oxMCtxbVNKR0RXaWtGZ21YVlJMOG9yblRKQUVHTVZ5MitscHl0c0VIUWp1?=
 =?utf-8?B?SzRLKzRoa08zcEZzVU1qby9HSElpTzlYZmgwRWtudFlUb1ZNaUFkZ2RjY3Zx?=
 =?utf-8?B?MThZVUIrWE1nblNvakFFU0N1QldRejJMUjhQRGw2K2V2VUtBMDRVbHROV2hO?=
 =?utf-8?B?SW1KZDBMbXA5UmVJZnRIUEo1OTJiS3lVN3hoMzlFeFRMWitXRlE3QjZKUkds?=
 =?utf-8?B?QmQ2R1VrbEUzSkdjMlRtRXdnb2s0bXd6anNDMUdOWmc1UERYbG5IdDRqczcr?=
 =?utf-8?B?ZENNNkEvRmZhWFU5eDZ5K0paY3NCVFF6eVNiczFWamJFamJSL1UzbGdEVUR3?=
 =?utf-8?B?bUxHSHg3OWdyUytoclJ5K1ZDSElDdHRNUVdWY0xLVkVIOFlCZXBsWmFWdCtp?=
 =?utf-8?B?dXRZKytJMTNtc3d5bUJnRGZscFp0NkJPWDNMQnd2WlBJYkJkRFNIZTJqTEcx?=
 =?utf-8?B?Z3huS0p0QzRGWnR6VHNxOWR0bnVaVjZoQVZ2WGNXMXlZazVxTkdQdDhnNXpL?=
 =?utf-8?B?QTVybkRZZDAzaWRnVThvVE5jQkpXVHdSQVBMZnptN0ZReG1adUo1WjlGeE1W?=
 =?utf-8?B?ejBESFc5ME9KaWJXZ2RrYVNLejI0U1N4WllINks0ZXR3OUZRREZ0Mm9meFV3?=
 =?utf-8?B?L0pHT1cyMEd5VTBWcUpucVQzbzlvREZ6cnJjRG1FeGRkNlNrRHc0NVpFMFpV?=
 =?utf-8?B?Q0RJa0lmdmYvay9rTWExSWxKTHUyOTlWVjk1a3ZlQmphbXNxMDVJbW9GcFRY?=
 =?utf-8?B?UkVqUDRxRG12cmdFUkdZSW9qZnM4Um4reVlZa1I4V1JoOFl3bEwra3hYVWY1?=
 =?utf-8?B?VDNhTWlYcEE1Y3hmWnNkUFhUTGZQVk1xaUl5L3NTdkFnNVNrbFkrdERYTy9B?=
 =?utf-8?B?TFU4aithMUszMm4vcGh3ZDZGVjVTWkNQVmJNT2VWRjZ4b3YxN0lmaFpXVVVr?=
 =?utf-8?B?SUFoMnJVelFoT3RtaVRrOG5GZDJiNDdrZjA1Vll5N3RMQUZ6TWlwRWVkZDYy?=
 =?utf-8?B?SCttcit0UmxyNDlFbFNLNWNXMVhHNE50MmNHczBvTkxwcThhSXF5T2dVUjRI?=
 =?utf-8?B?Z1BJT1lGRlU1RFVTN2VneEoxeEE0UDc3U2p1ZG9mellvNWVRNlFweGFBcytC?=
 =?utf-8?B?Z2VNdjNrNklTNS9lRWJDbDJaYUJBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c3b54df-aefa-438e-13b2-08d9d116269e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 13:12:11.6009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oTuyBuwHb6M3cDTLYSCffwD6i/Qqww/mMjdRLUYqJqn/TH5zqzjEsKzRdvDVaDSCGOuXG6R2Hdh3Znls+CuVrXelO5obYbdVU4No+VNb9hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5943
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSmlucHUsDQoNCj4gSGkgQWppc2gsDQo+IA0KPiANCj4gT24gVHVlLCBEZWMgMjgsIDIwMjEg
YXQgMTI6MTUgUE0gQWppc2ggS29zaHkgPEFqaXNoLktvc2h5QG1pY3JvY2hpcC5jb20+DQo+IHdy
b3RlOg0KPiA+DQo+ID4gRXJyb3IgaGFuZGxpbmcgc3RlcHMgd2VyZSBub3QgaW4gc2VxdWVuY2Ug
YXMgcGVyIHRoZSBwcm9ncmFtbWVycw0KPiA+IG1hbnVhbC4gRXhwZWN0ZWQgc2VxdWVuY2U6DQo+
ID4gIC1QSFlfRE9XTiAoUE9SVF9JTl9SRVNFVCkNCj4gPiAgLVBPUlRfUkVTRVRfVElNRVJfVE1P
DQo+ID4gIC1Ib3N0IGFib3J0cyBwZW5kaW5nIEkvT3MNCj4gPiAgLUhvc3QgZGVyZWdpc3RlciB0
aGUgZGV2aWNlDQo+ID4gIC1Ib3N0IHNlbmRzIEhXX0VWRU5UX1BIWV9ET1dOIGFjaw0KPiANCj4g
SnVzdCB0byBtYWtlIHN1cmUsIGRvZXMgdGhlIHNhbWUgc2VxdWVuY2Ugd29yayBmb3Igb2xkIHBt
ODAwMSBjaGlwPw0KDQpDdXJyZW50bHkgdGhpcyBjb2RlIGlzIG1vZGlmaWVkIGFuZCBleGVjdXRl
ZCBiYXNlZCBvbiA4MDA2IGNvbnRyb2xsZXIuDQpJIG5lZWQgdG8gY2hlY2sgd2l0aCB0ZWFtIG1l
bWJlcnMgYWJvdXQgdGhlIHRoaXMgc2VxdWVuY2Ugb24gb2xkDQpjb250cm9sbGVyIHBtODAwMSBj
aGlwLg0KDQo+ID4NCj4gPiBFYXJsaWVyLCB3ZSB3ZXJlIHNlbmRpbmcgSFdfRVZFTlRfUEhZX0RP
V04gYWNrIGZpcnN0IGFuZCB0aGVuDQo+ID4gZGVyZWdpc3RlciB0aGUgZGV2aWNlLg0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogQWppc2ggS29zaHkgPEFqaXNoLktvc2h5QG1pY3JvY2hpcC5jb20+
DQo+ID4gU2lnbmVkLW9mZi1ieTogVmlzd2FzIEcgPFZpc3dhcy5HQG1pY3JvY2hpcC5jb20+DQo+
ID4gLS0tDQo+ID4gIGRyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX3Nhcy5jIHwgNyArKysrKyst
DQo+ID4gZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfc2FzLmggfCAzICsrKw0KPiA+IGRyaXZl
cnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3aS5jIHwgNyArKysrKy0tDQo+ID4gIDMgZmlsZXMgY2hh
bmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9zYXMuYw0KPiA+IGIvZHJpdmVycy9zY3Np
L3BtODAwMS9wbTgwMDFfc2FzLmMNCj4gPiBpbmRleCBjOWExNmVlZjM4YzEuLjE2MGVlOGIyMjhj
OSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9zYXMuYw0KPiA+
ICsrKyBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX3Nhcy5jDQo+ID4gQEAgLTExOTksNyAr
MTE5OSw3IEBAIGludCBwbTgwMDFfYWJvcnRfdGFzayhzdHJ1Y3Qgc2FzX3Rhc2sgKnRhc2spDQo+
ID4gICAgICAgICBzdHJ1Y3QgcG04MDAxX2RldmljZSAqcG04MDAxX2RldjsNCj4gPiAgICAgICAg
IHN0cnVjdCBwbTgwMDFfdG1mX3Rhc2sgdG1mX3Rhc2s7DQo+ID4gICAgICAgICBpbnQgcmMgPSBU
TUZfUkVTUF9GVU5DX0ZBSUxFRCwgcmV0Ow0KPiA+IC0gICAgICAgdTMyIHBoeV9pZDsNCj4gPiAr
ICAgICAgIHUzMiBwaHlfaWQsIHBvcnRfaWQ7DQo+ID4gICAgICAgICBzdHJ1Y3Qgc2FzX3Rhc2tf
c2xvdyBzbG93X3Rhc2s7DQo+ID4NCj4gPiAgICAgICAgIGlmICh1bmxpa2VseSghdGFzayB8fCAh
dGFzay0+bGxkZF90YXNrIHx8ICF0YXNrLT5kZXYpKSBAQA0KPiA+IC0xMjQ2LDYgKzEyNDYsNyBA
QCBpbnQgcG04MDAxX2Fib3J0X3Rhc2soc3RydWN0IHNhc190YXNrICp0YXNrKQ0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgIERFQ0xBUkVfQ09NUExFVElPTl9PTlNUQUNLKGNvbXBsZXRpb25f
cmVzZXQpOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIERFQ0xBUkVfQ09NUExFVElPTl9P
TlNUQUNLKGNvbXBsZXRpb24pOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBw
bTgwMDFfcGh5ICpwaHkgPSBwbTgwMDFfaGEtPnBoeSArDQo+ID4gcGh5X2lkOw0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgIHBvcnRfaWQgPSBwaHktPnBvcnQtPnBvcnRfaWQ7DQo+ID4NCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAvKiAxLiBTZXQgRGV2aWNlIHN0YXRlIGFzIFJlY292
ZXJ5ICovDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgcG04MDAxX2Rldi0+c2V0ZHNfY29t
cGxldGlvbiA9ICZjb21wbGV0aW9uOyBAQA0KPiA+IC0xMjk3LDYgKzEyOTgsMTAgQEAgaW50IHBt
ODAwMV9hYm9ydF90YXNrKHN0cnVjdCBzYXNfdGFzayAqdGFzaykNCj4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBQT1JUX1JFU0VUX1RNTyk7DQo+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAocGh5LT5wb3J0X3Jlc2V0X3N0YXR1
cyA9PSBQT1JUX1JFU0VUX1RNTykgew0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBwbTgwMDFfZGV2X2dvbmVfbm90aWZ5KGRldik7DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBNODAwMV9DSElQX0RJU1AtPmh3X2V2ZW50X2Fj
a19yZXEoDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgcG04MDAxX2hhLCAwLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIDB4MDcsIC8qSFdfRVZFTlRfUEhZX0RPV04gYWNrKi8NCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwb3J0X2lkLCBwaHlfaWQs
IDAsDQo+ID4gKyAwKTsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgZ290byBvdXQ7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9DQo+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
cG04MDAxL3BtODAwMV9zYXMuaA0KPiA+IGIvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfc2Fz
LmgNCj4gPiBpbmRleCA4M2VlYzE2ZDAyMWQuLmExN2RhMWNlYmNlMSAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9zYXMuaA0KPiA+ICsrKyBiL2RyaXZlcnMvc2Nz
aS9wbTgwMDEvcG04MDAxX3Nhcy5oDQo+ID4gQEAgLTIxNiw2ICsyMTYsOSBAQCBzdHJ1Y3QgcG04
MDAxX2Rpc3BhdGNoIHsNCj4gPiAgICAgICAgICAgICAgICAgdTMyIHN0YXRlKTsNCj4gPiAgICAg
ICAgIGludCAoKnNhc19yZV9pbml0X3JlcSkoc3RydWN0IHBtODAwMV9oYmFfaW5mbyAqcG04MDAx
X2hhKTsNCj4gPiAgICAgICAgIGludCAoKmZhdGFsX2Vycm9ycykoc3RydWN0IHBtODAwMV9oYmFf
aW5mbyAqcG04MDAxX2hhKTsNCj4gPiArICAgICAgIHZvaWQgKCpod19ldmVudF9hY2tfcmVxKShz
dHJ1Y3QgcG04MDAxX2hiYV9pbmZvICpwbTgwMDFfaGEsDQo+ID4gKyAgICAgICAgICAgICAgIHUz
MiBRbnVtLCB1MzIgU0VBLCB1MzIgcG9ydF9pZCwgdTMyIHBoeUlkLCB1MzIgcGFyYW0wLA0KPiA+
ICsgICAgICAgICAgICAgICB1MzIgcGFyYW0xKTsNCj4gPiAgfTsNCj4gPg0KPiA+ICBzdHJ1Y3Qg
cG04MDAxX2NoaXBfaW5mbyB7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9wbTgwMDEv
cG04MHh4X2h3aS5jDQo+ID4gYi9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODB4eF9od2kuYw0KPiA+
IGluZGV4IDA4NDllY2M5MTNjNy4uOTc3NTBkMGViZWU5IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3aS5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3BtODAw
MS9wbTgweHhfaHdpLmMNCj4gPiBAQCAtMzcwOSw4ICszNzA5LDEwIEBAIHN0YXRpYyBpbnQgbXBp
X2h3X2V2ZW50KHN0cnVjdA0KPiBwbTgwMDFfaGJhX2luZm8gKnBtODAwMV9oYSwgdm9pZCAqcGlv
bWIpDQo+ID4gICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAgY2FzZSBIV19FVkVO
VF9QT1JUX1JFU0VUX1RJTUVSX1RNTzoNCj4gPiAgICAgICAgICAgICAgICAgcG04MDAxX2RiZyhw
bTgwMDFfaGEsIE1TRywNCj4gIkhXX0VWRU5UX1BPUlRfUkVTRVRfVElNRVJfVE1PXG4iKTsNCj4g
PiAtICAgICAgICAgICAgICAgcG04MHh4X2h3X2V2ZW50X2Fja19yZXEocG04MDAxX2hhLCAwLA0K
PiBIV19FVkVOVF9QSFlfRE9XTiwNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICBwb3J0X2lk
LCBwaHlfaWQsIDAsIDApOw0KPiA+ICsgICAgICAgICAgICAgICBpZiAoIXBtODAwMV9oYS0+cGh5
W3BoeV9pZF0ucmVzZXRfY29tcGxldGlvbikgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
IHBtODB4eF9od19ldmVudF9hY2tfcmVxKHBtODAwMV9oYSwgMCwNCj4gSFdfRVZFTlRfUEhZX0RP
V04sDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwb3J0X2lkLCBwaHlfaWQs
IDAsIDApOw0KPiA+ICsgICAgICAgICAgICAgICB9DQo+ID4gICAgICAgICAgICAgICAgIHNhc19w
aHlfZGlzY29ubmVjdGVkKHNhc19waHkpOw0KPiA+ICAgICAgICAgICAgICAgICBwaHktPnBoeV9h
dHRhY2hlZCA9IDA7DQo+ID4gICAgICAgICAgICAgICAgIHNhc19ub3RpZnlfcG9ydF9ldmVudChz
YXNfcGh5LCBQT1JURV9MSU5LX1JFU0VUX0VSUiwNCj4gPiBAQCAtNTA1MSw0ICs1MDUzLDUgQEAg
Y29uc3Qgc3RydWN0IHBtODAwMV9kaXNwYXRjaA0KPiBwbTgwMDFfODB4eF9kaXNwYXRjaCA9IHsN
Cj4gPiAgICAgICAgIC5md19mbGFzaF91cGRhdGVfcmVxICAgID0gcG04MDAxX2NoaXBfZndfZmxh
c2hfdXBkYXRlX3JlcSwNCj4gPiAgICAgICAgIC5zZXRfZGV2X3N0YXRlX3JlcSAgICAgID0gcG04
MDAxX2NoaXBfc2V0X2Rldl9zdGF0ZV9yZXEsDQo+ID4gICAgICAgICAuZmF0YWxfZXJyb3JzICAg
ICAgICAgICA9IHBtODB4eF9mYXRhbF9lcnJvcnMsDQo+ID4gKyAgICAgICAuaHdfZXZlbnRfYWNr
X3JlcSAgICAgICA9IHBtODB4eF9od19ldmVudF9hY2tfcmVxLA0KPiA+ICB9Ow0KPiA+IC0tDQo+
ID4gMi4yNy4wDQo+ID4NCg0KVGhhbmtzLA0KQWppc2gNCg==
