Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD9EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 05:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96E8561178
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 05:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhIOFxh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 01:53:37 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:27454 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhIOFxh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 01:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631685138; x=1663221138;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5WV5fi6Y0K0XHGOsFlbm2TQjdIgdCSe2rk2nlX64fH0=;
  b=MoAk/6fo45T+mLjU5zd5o3L4n7fyqFXcNzto0qX4P3OVg4IiZ4BoDaR0
   xGnjTC+HHRFPVkQkZz97zW0wQW0QYRLq+VyxTHk5P/Zfn5wpvVq9V1Eqp
   dYsk5KUGnAGlk9fpM8GXA2T1LUBH72/o+/93lGm/Y+88HkQLiLJBa0goI
   qk8ewiphGxl0KUQmzuegJKaUZmvts+q1sH47A/bI9skmW6BZGlEXT7P6l
   cc5Si+kL9RitL/ObJyod/6kXvdG0zCH36QTwcb9rJGXYUrvY6X3sQdFEb
   vuEFJ2IzoCEX+faqEtLyix34tI02W4m5E9wglhni4KXUTJKPrcwjAog8x
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,294,1624291200"; 
   d="scan'208";a="184828147"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2021 13:52:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlNS3tIMcD42CYItnpCUQhPjasoggNscZr+nSCGCWooiF7UnG35ib/Ik91gw7xHeTcxzUXJbYjM50xHSBH6iNd4mduz7GOJd/x9MSCaym67XddcCczXT7oda0jDnlMHlPbo57c2+oYD4dPVhA24E2SUoegBHmBxJydKIx/EI91aIcIIk6E6QAzVSOqT9kK/mtSjTnAWIIsVgrQGMcE4HdPI+nk0QmB5rpiI7geBTgd9wOTr0EJTWwhRtDZCvg2BGXS/l79jr1g1ff/VxqQK/AmP++Z3w5ob7qT7aPSqaA04iL04lOwDDonKKOAdlxOduwy5Lt4nncd2rZ6MRVR6mow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5WV5fi6Y0K0XHGOsFlbm2TQjdIgdCSe2rk2nlX64fH0=;
 b=VJTiYqO6rlpV7WQzd0U+G+IlhYXhBDWYDj38ckKRdLQmoL0vF1G74T7/iMiiV6vQ9wyxYSQm/hPtC2FlTz0jRTNvP3086LXqHQQzxt1FPOwBQa2FIY4I70OzQ4Tj0CStBSN2KqlaSeo5180oS5ytvtj9+mmY//T7XCrRtz73pbQOwsENdSSXrwTi1Cakm1d0B4QJNAsMAcjJZtPJ9CFNBASf8cMFSZs86YVafIleiALAsxQGXpJUmaK8oh+cYlKNSsJhWyXSHuIw5coqd2ioejEnYC4p5wAO01ub6ggS4wL6P19d6VH8kG+u9VYPYvWa8Q0AKg4A6HUGuBhlCcKvWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WV5fi6Y0K0XHGOsFlbm2TQjdIgdCSe2rk2nlX64fH0=;
 b=ygMyFdCV0P4YvjU0YX2y9+u/5Uf6cB6t02tH4wDgeePg7OeEATHsdQaN0qkEvrHli/VBO8RNRvsLy7gswbRADBuVYD6DPDC+FAZWNCw7JvlPDLXkojY6bseskmg+PjqaKvL0kYln/6cmBp5aTW6MxPLUsAeLFgeeYjqzgsAhIww=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5628.namprd04.prod.outlook.com (2603:10b6:5:163::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.14; Wed, 15 Sep 2021 05:52:17 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 05:52:16 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v6 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Topic: [PATCH v6 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Index: AQHXqacHZNIKcVZeE0uU8+EwfkSWnqukAhGAgACVcIA=
Date:   Wed, 15 Sep 2021 05:52:16 +0000
Message-ID: <DM6PR04MB6575D4234BAE8E0537F5E400FCDB9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210914202731.5242-1-avri.altman@wdc.com>
 <20210914202731.5242-2-avri.altman@wdc.com>
 <9b294067-a671-ba43-4c49-cbe130ef0190@roeck-us.net>
In-Reply-To: <9b294067-a671-ba43-4c49-cbe130ef0190@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adf5aec3-b9b0-4447-4dee-08d9780cf96b
x-ms-traffictypediagnostic: DM6PR04MB5628:
x-microsoft-antispam-prvs: <DM6PR04MB5628C2DA3A897ED95291C1A3FCDB9@DM6PR04MB5628.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 14K15ji7cKV1kUc4CQ3HIGBsm8lkx51W7kwNRHidGvdUrEhLwBZXdFYXDbEpVLL5GF/AMYhjFaCof1JutRoHQ3QPypVvV0z8+a41DatsgnTsTJsMZOVAC27VMNtFzzJSmSJuu7W6bwMC9mel3TLl24X94mKw1OLKjWBhn1kKYTjcLuues8i/IAHNlCoTimnB2A5TnTG+f0W0aBREduOTS67W+MqoVAwv7A+EihBrPe3y1RWVQFdhZpoRWh4gNqNKSXGt8j4qvkAT8H23vndBji1LpvquEpYU8vvVU2u2juIoTX8wT6zSkyfmZ0tEi/Crpi+qg9yfXYaVAJXx13RQtQOEepB0zhvTxjiBwX8oE2lU5rELacG75pIQvCrSqSpmDXO64P5Az5JhuJiaW3lq/PTaoqVb3gXKsvZaiqlPPhhv1o1Ldaj2hEpFofUi5CZuBRMKRGfQbj8tH2w51JyHWzeGYEKxerWunM9JcPdZSEdVbxYUgGmhkq5Hx3U3gKRT6OHB3KnFNdmn5tjRj4IAXb7ooDzgiYTIKaR3uZXvj/uHaInz+AyVu1Jy/GYjDc+4hqg0NxZb1a/H9V6kfFp+oPKMvIY0IeiR5DtcFWav6Ccxm5zr4TfW7ZnIR05mT4XrQmbgx88bcCvzlP7GvlbTar2Qb94iF5DCVQfVSzynq7GTNFPZN19BPICGmiBXMOuwBik5LYtdcpmTXmDdiMGXAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(478600001)(86362001)(4326008)(15650500001)(316002)(54906003)(110136005)(52536014)(8676002)(5660300002)(55016002)(76116006)(9686003)(66946007)(66446008)(6506007)(66476007)(64756008)(66556008)(83380400001)(7696005)(8936002)(71200400001)(2906002)(4744005)(186003)(26005)(122000001)(38070700005)(38100700002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkdyWEhablh2ZlM1WDlMeDFGRldyREV0SDVjV2V5NzU4WUxMclBmYW9LRlJv?=
 =?utf-8?B?aDNYcng5NGZzc281TDBMQ2JjdURnUDVYOVdZUi9zcjJaYm5ieVYzSmF2N3Rk?=
 =?utf-8?B?T3FERTYvWWczWlFxQVk0d2Y3alFjamVDZC9mVGh3NGUyODZ1YmJuYnVhVlAz?=
 =?utf-8?B?Z0l1TG8yOEpGVFhTeHdRamhyTExZMXNUeWJTUzNXaExEbzMvRE9wbzRFbGtS?=
 =?utf-8?B?dkpaSE5XQ3NISVVIRGcwUklYSlpIbmI5b00rWG5ad0YwaEQxLzYrZ3VnQ1ox?=
 =?utf-8?B?UjNIVjlQZnpzSitDdlBWcEppZkFjNTN5UGVBZ0pXMjd4OXZMZmIrMnI4bERR?=
 =?utf-8?B?YUE3RENjd2NqOERZWVE1aGdNdW5sQk1acmVxakVnVlFRS1pLUVFBNTN6c2RG?=
 =?utf-8?B?Tk9XMW8rQ0t4N2xWaWlJRCtvb3Z6WUlkODduQ3B1ODNmWE5Jb3ZHNjk2NmNN?=
 =?utf-8?B?MTRvcm1jdW1aTUpBd2Rva2VzbVRMZzVEZ3NhWE9WOExxWHFCa21LT1k2d21x?=
 =?utf-8?B?N3ZWRlhjOFJqbzhrd0g4aDBJVEd3VzdWbE9id2RTQjZZOUs4T0dOM3JPenVt?=
 =?utf-8?B?citMWlRsdlpBdmVBQndLdERMTkNUaUdCQU1IaUNFL3VNZGJwcFZwekxldVkv?=
 =?utf-8?B?NVpyanpEdTg5SEFpR2lMUkRFSXJZSHV1ZFh0dm1NamEyOGdEVnRCeGlSTDRr?=
 =?utf-8?B?Zm1aaFpscWkvbjRsd2Zmc3FIQ2FZeVlULzJuK0J6Q2hLdndTSzJ5dW5GMVFh?=
 =?utf-8?B?eGFpa1NGSkJCSjM5cHBaOHdpdzVpYVQ1d2NZRkd4eDFaTVRuall2N3VnNG43?=
 =?utf-8?B?SEVjYTZaWWQ0dW5tRGwvREtJWGtweVc2aUJESWdQV25MWmw5VThFOCtjQU1L?=
 =?utf-8?B?WU1URUF6Z1Q4S1pRVnVac0dnY3kzeDJaUXd0Y3BwZjA0RHd0WGw3eit2eXFJ?=
 =?utf-8?B?c2VaVU11RUNMOFJFd2toc0hRTWhwd2lEb2Q2VGNnV2NnNFZPakVyOVdmeDR3?=
 =?utf-8?B?SVhpV3pVSXZ6cHl1LzZsc2J2QlhRSU5jSDFMaDhWRGZoR0RmRVdlQWZEc3dW?=
 =?utf-8?B?c1JzSDFOYlJQRVMxQTh3bXdGVVBpdGlna1pDV3FRcHdCZWJEaFNYSUMwQ0Vv?=
 =?utf-8?B?NUxRU0hnRlZuanYwZjQ3NU44bmJIaG50NTRMNG5rN3R2U1l4dmFEbTlmbG5M?=
 =?utf-8?B?MmVVMUozNTBmeEpTNjJBMVduOFZQa1M3R3c4a3c1RldRSnNQaXJFR01YVGt1?=
 =?utf-8?B?OHZVUkpiYUFFK0oxcGxkc29SSTJjWFBrNnhQNkVmOTczcU1lUkIzRXZtN0RL?=
 =?utf-8?B?UHdXUDNQeWNpeGtyMEhId1p4RFBPMDlFZnZXTXdNbHhOZjJkZkh2akpKWm5t?=
 =?utf-8?B?djRNMk5vNFZ6aTNYeTMwMTBNbDdKb3kyNHR2d2ErMHBwM0RpdEFMS1cyTWFr?=
 =?utf-8?B?ZEs1a0V4T3JWQTdBMnVVRWFnV3RRRlZTMUQrbDE3dHAwdXg4TllNWGhxMHY4?=
 =?utf-8?B?N0lQTnIrS04zejQwNDRzZDZjK1hnaDFRUjVrMHQxcjQzWStuaUtZUUVDYnF2?=
 =?utf-8?B?OHlpN1QwcDNUNjEwTTQ3TC9VQk50S0lvTDdVZXhhTTZMOE5yNFR0MVIvTXNC?=
 =?utf-8?B?cUFoZEtIZXVJZldaalNodHFERmpBM2hNVTJRZnBlelV1VTlTaVJ6UGltaGZ4?=
 =?utf-8?B?b1VmZGV1MWJ6b1hCcGd4RnQwVU41dnFSak1kZWFmbmZrNTZtdFNZRkhvOGtH?=
 =?utf-8?Q?O11pI5mGRy5Duo+aEUTdu/g6TwDVYMyPnmnxz00?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adf5aec3-b9b0-4447-4dee-08d9780cf96b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 05:52:16.7522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uL7pJ+JfY+TOnMcEUp0tTj3XrG1+OvMi40g8dClzO1Sd/0qA5rsL4c8IX18zR39CDsUx8zm3c8XftHvHKDaTqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5628
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ICtzdGF0aWMgaW50IHVmc19od21vbl9yZWFkKHN0cnVjdCBkZXZpY2UgKmRldiwgZW51bQ0K
PiBod21vbl9zZW5zb3JfdHlwZXMgdHlwZSwgdTMyIGF0dHIsIGludCBjaGFubmVsLA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGxvbmcgKnZhbCkNCj4gPiArew0KPiA+ICsgICAgIHN0cnVj
dCB1ZnNfaHdtb25fZGF0YSAqZGF0YSA9IGRldl9nZXRfZHJ2ZGF0YShkZXYpOw0KPiA+ICsgICAg
IHN0cnVjdCB1ZnNfaGJhICpoYmEgPSBkYXRhLT5oYmE7DQo+ID4gKyAgICAgaW50IGVycjsNCj4g
PiArDQo+ID4gKyAgICAgaWYgKHR5cGUgIT0gaHdtb25fdGVtcCkNCj4gPiArICAgICAgICAgICAg
IHJldHVybiAwOw0KPiA+ICsNCj4gDQo+IFdhcyB0aGF0IHRoZXJlIGJlZm9yZSA/IERvcnJ5LCBJ
IGRpZG4ndCBub3RpY2UuDQo+IEZpcnN0IG9mIGFsbCwgc3RyaWN0bHkgc3BlYWtpbmcgaXQgaXMg
dW5uZWNlc3NhcnksIGJ1dCBpZiBpdCBpcyB0aGVyZQ0KPiBpdCBzaG91bGQgcmV0dXJuIGFuIGVy
cm9yLiBQbHVzLCBjaGVja2luZyB0aGUgdHlwZSBoZXJlIGJ1dCBub3QgaW4NCj4gdGhlIHdyaXRl
IGZ1bmN0aW9uIGlzIGEgYml0IGluY29uc2lzdGVudC4NCldpbGwgcmVtb3ZlLiAgRG9uZS4NCg0K
PiA+ICtzdGF0aWMgaW50IHVmc19od21vbl93cml0ZShzdHJ1Y3QgZGV2aWNlICpkZXYsIGVudW0N
Cj4gaHdtb25fc2Vuc29yX3R5cGVzIHR5cGUsIHUzMiBhdHRyLCBpbnQgY2hhbm5lbCwNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgbG9uZyB2YWwpDQo+ID4gK3sNCj4gPiArICAgICBzdHJ1
Y3QgdWZzX2h3bW9uX2RhdGEgKmRhdGEgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gPiArICAg
ICBzdHJ1Y3QgdWZzX2hiYSAqaGJhID0gZGF0YS0+aGJhOw0KPiA+ICsgICAgIGludCBlcnIgPSAw
Ow0KPiANCj4gU3RpbGwgdW5uZWNlc3NhcnkuDQpEb25lLg0KDQo=
