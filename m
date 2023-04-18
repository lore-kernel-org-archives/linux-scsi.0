Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A0CC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 20:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbjDRUSj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 16:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDRUSi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 16:18:38 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8417AB0;
        Tue, 18 Apr 2023 13:18:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJYoDjJOmcIJ1V00Sulvw2MQClSKIsb7IohOTtWsbJvucXDUf7SugO/+KIak7fv6SfuhE7nceEOTuKbdDzW7kY+brkwm7RvGypUotcSqsl4k46e4U+7yW/NKbCsrV+xI0Btfd2ei/+Y5xhzokq/3mHzKlxc6blwHwR3NxeRtpLT0do/U0difaZ8a0Of6twI5AUgX+LVn2Mtn3pzXVFXWp26dYIfGo327ydAkn4gRYvViLt55Axq8D88v0jOUF69O/93t2ALyT3173J/UqBFSkIMYHVztTGHXv0JRPH8D5IMiO21jFWK/X75GEjLyIOm6bLpDPdO3CzLZTCAbxFS2vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lL5Uimg2aTr2v7l44uswCEQISpahJnA5S8Vjp1v+fNA=;
 b=nmpWOJx868bXR07ZEZxQysphay6jXm/MtQt4HRSRZDIMVFc9IDl6RQRbkJLEIZ0WWkW9KO9QS5dIOKcakYtKigEI/dMf/4r7BheF6az/DqWNoOaxBZldOdgjsE1r+KX9HbbqAfwo7GywQLs2/D+rsa0GQOW3t9aKn5lEDh1dYTbdAUXuAn6ytOxx/Bk3Y9FaGzscD8HZVXFbHOhQL4spvpRxVZu7LVNKTWre3yRXIPezk+k2eGguP3yDhr/JD93X1KmBKBfC9p9AAOg8QzFtFXAXjHjQ6g31M2yoDULTSgS6j9CvxXVyzHihKqxGry+iWfXjD3PAYU5TBtLYX1KIVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lL5Uimg2aTr2v7l44uswCEQISpahJnA5S8Vjp1v+fNA=;
 b=RBqDq0VcmCVswF8lihLbdtNA/Tvm7B2YR+2bJK26fOTNLhVXKOp7TbNKKw17N5R0CKTIJGHMRT3i9rgHPEGPT59zMjOiFeWCE0QvH46F89pkuYjt+Mj80iqHwyUfs/Ff/ezbbqz0iKEJ5wC3eT46ZhE2tEsQii6hgjwvnLn3UvnVMIA7u0JRY0MGwFtYhtBadIJ9RWwGuAB3Na8kS8UkTMquKM2udKAg1S1hRLFUIiNX9Mz5Y+SDYc8hP99oTMe/hQs95VL60eFmgdiHpxBWOn1U43UySS343F7eLT7wWRqWNFyWfDJZ8hMzTQUyZEhfvzLI0tI3mppvYc9zMlVcDw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DS0PR12MB8561.namprd12.prod.outlook.com (2603:10b6:8:166::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 20:18:34 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 20:18:34 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests 5/9] scsi/004: allow to run with built-in
 scsi_debug
Thread-Topic: [PATCH blktests 5/9] scsi/004: allow to run with built-in
 scsi_debug
Thread-Index: AQHZcS0nDPcIzJT9GkGkW8zd9jw9OK8xg4wA
Date:   Tue, 18 Apr 2023 20:18:34 +0000
Message-ID: <f4997765-6ea5-52ad-e329-73b9e5eedde5@nvidia.com>
References: <20230417125913.458726-1-shinichiro@fastmail.com>
In-Reply-To: <20230417125913.458726-1-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DS0PR12MB8561:EE_
x-ms-office365-filtering-correlation-id: d767491e-7333-4b00-6ee2-08db404a1614
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IXhEnhiZbwxHAGGfqDrKQfm0MIkmHVPZcqPILxH45nwpfqAaf7Kl7BvI7cd8XOcvS9m4dXD8tUOsPUnKSgTxrHMfglVns+ym8kp6I4HFPQpzcmFgs6zl9t3P+PE646fQi7yFAHGosnDC6sYub4ZH+iY4xsuWw7a09KtrijFe5lKp0ngEIcY/my67BDxvJtrWYtZI4fuD6fJDgYnpY+ijvRVOXoMQmofsfPO/mABTbUMJPsKdtQ45qRa7Lu8HvlcICJ+1/9cla3ZUyzuUdS6uXn/8/n3ATzpYXUDHFFm45z2zd8JgOw7O4WNiHbySilrz8f73az0IVtSCNwZhhXODO6VIq/tGDa3C+K1n8kBySd+GqHaV0ceQpdue1d+iuJ/E5mvexveDKMHb6HK9WYRrrRNPLVZcW/feBVv76V77EcllpsaFvoUK8R8LPrsu5V+D2sVs33cn3S4Q7VNdGcd8h6mcjUQmf0zVUnNYksiszZl1X7z1V7hdsrjgD3SWwcD6lmKJU7TxBuU0u6kJ1s7S5Ug36ngLG7HAw/Gb6PskJrVLk7AYfErzkQdUpMYVv129qOIZlKOFFfNCEWjv1eeXvGF3myhxjQ3hqYAm5O0DOX3SZ52jpM53QLVxbGOJOYMtT8X3e/ic3LjY+rgqrwEnFRLcxNJ2hQF5IckAe3IjRaI1fBx+WLW5UUuox+2EL85p
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(451199021)(31686004)(316002)(110136005)(64756008)(66946007)(66556008)(66476007)(66446008)(76116006)(91956017)(4326008)(36756003)(186003)(53546011)(6506007)(6512007)(122000001)(38100700002)(2616005)(83380400001)(31696002)(41300700001)(8676002)(5660300002)(8936002)(478600001)(6486002)(71200400001)(2906002)(86362001)(38070700005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWZ3M3g2bzB4bWdhZjlPdENjZGZoYXpqN2lOTTcvbVVrRVZhRk8rS1M5M3du?=
 =?utf-8?B?VjdTZm42NWgxanM4MXY0bEdjUnJjWDF1bVBjTU5CYmZuK3hjTStrWUx0M1N1?=
 =?utf-8?B?eTlkRm9sSGdqMlZBZnpaazZHaU9OZC9DZFRRbkduRmU2c0pvMVJpa2o3OGJh?=
 =?utf-8?B?ZGRTdFhYOHllZXk2WmxsR1NVL21OeExBRkl0THRzSDBjdmNERTJ3dTlWUDB3?=
 =?utf-8?B?a1BsSTBxQW9hN2VvRnFhRW9TMTZWdDhFclNRaEtXVVoxLytac3VZanp6RlUr?=
 =?utf-8?B?L1hCQkx1WStPMDVsNGlPZW1Ld25ldSs4RWZVeEhXRTlBaFg3OFErWHpxUVdX?=
 =?utf-8?B?VXlSNDRlazI4WmsvWVdUQjUySm01VERidHJUdkVPWFdLMVdvUnFFRFhXRDhH?=
 =?utf-8?B?TnNaSVd5Yk5wVWYzMllGbWZ6cXZjOVdvZC9wM25sZU5LYzhBazMzemNLdlYv?=
 =?utf-8?B?cCt5eTk0SWRkVkt5dlZPM2hreUg3ajNLY1E2em5VdFc4eGNQM29WTUxVTm1k?=
 =?utf-8?B?SG5aWDFCdGluZHV0VW0yNG1paytCT3ArTjEvREJUTDcrUDlMS3IwYkduSUpD?=
 =?utf-8?B?ZGpnNnpPZ1ZHU1JwdUt5djhzQmFSN09lVWl0NlhwZGJCSURYbkp6UGVYZGdS?=
 =?utf-8?B?enFlb0M5QmRQeUJsZElGNmFyT2NuMW1RZGZwUE10OUYvSUQ3WURxZ2FRZGhX?=
 =?utf-8?B?ZUNac1NBM21DOEtYYmVYK2tiN0JleGRFUHZUTEZEWVJUbkVNOGFGWVdjcW9t?=
 =?utf-8?B?RkhKTUR2Y3I3RHg0akZOaExJMUtsMno0KzBFV2szc2MzSEZ6eXlaVHZvNkZn?=
 =?utf-8?B?SjgzM0FVT0dYbFYvUGVzdklZMnZ1L3FsVWFKQ3JGUVhJL1JqcmRKZlY5K0tC?=
 =?utf-8?B?M2lkSXQveU92b1oyMDFPZ2N2WkFoOHVxRHJpWi9ZaVdzRE5ETHU3L1N3b3hK?=
 =?utf-8?B?TUZOeU43L1V0MFpFK1A3R0pBV095UEYwdzNwK0lSOHFxL2FYZzZtNmxYV0ty?=
 =?utf-8?B?WEpIN3diVm05NzRGUlFUeHRsY1lmZlIwZklUZVUxdVhjL2pVQlVhblo5R3BC?=
 =?utf-8?B?SVZDNXM3NVNPUG1VdWR3Z012bkZmU1VKSzdnSnpCazRMK0hhbTdIOHh6V05u?=
 =?utf-8?B?bFlhSGhiY1BJRURFN0NBSDkvVnlGWjd5d290cms4UnhzWm5Rb21TMGFqek4x?=
 =?utf-8?B?dDZUcDRJaVc5aG1jL2tFd0tvWmxkK0JlcXZ2YndqY24xcUhnRGpmaHRDOVVx?=
 =?utf-8?B?QjAvc0hoc3hNZFhsekxFS3J5L0ovQlJlMGZoeGFzRThxcG1EeExHVWtnQldI?=
 =?utf-8?B?Q2VJNk41TTM0c3R6OE52aHM3bE9jN2V5d2ZrOTBVNXhyTm5zRFZuT0dOSkhX?=
 =?utf-8?B?dmwwZmx1ZTFoZ0hTdzczTjJYRzF5azlMZm9nNWhDZ1BUNmM4cWZERVdXNzBW?=
 =?utf-8?B?bUZObjhRNFR5bDUwZC9hTHAxV3YyWmtsaW53TlQ5eGtsdmZ6elhUbjhFNUNw?=
 =?utf-8?B?VnhzNWl1Vks2ZGJ4b1ZxY2FWN1RrcU0zM3ZBYkZpUjVwbW1ncWVZUGdJTWc4?=
 =?utf-8?B?TmJ2eWVsUzFBNGludTVEdjBMNDdoenAvbGt6eDdyVzJwVEs5TmV6SUx4clNX?=
 =?utf-8?B?THZTc3VjTEhUa2FURDhPOXh3WitlaEF2VGh2bWNFWUxKQk9FRmFkTDBXTW1Z?=
 =?utf-8?B?K2Z0bnMyYXZVWDR1bEtDek1RR2dDaTQ3WnJLN0poM3lld2FXWGZ5R1J3VEs4?=
 =?utf-8?B?SDI0RjRSWjVNYWhQMTJUSDd2dUVtZmlBeDNxSHQ1YXlwM0dVdVhUYjVYUzFK?=
 =?utf-8?B?RjlHcC8wbGFMRkFJM0QxZ0w0N0JiWDVQMndBY3dMVGRmVTA2VkZwODFGYjI2?=
 =?utf-8?B?MWdkRVpQU1IzeEJpN1UzTXVQaEVkVzdtU2tyQ1ZGZmpuR2lwZHl2S2h3WWVK?=
 =?utf-8?B?NjBURndJbndIclRWa0hzeVpIeFVDbzR0T201dFQreEZNOG1Cajg0eTRnemtq?=
 =?utf-8?B?RUFKMHR6eCs1aUk3R3BxdzVkNjlqQi9FcjlqeTZaa3lVaVUzaEp5TjBBazdq?=
 =?utf-8?B?MGh4SDRFK0JYM05uVmFwdGVaWlkydEdPS0xrUjB2eFJKeXBGRCtMQzRZcDNx?=
 =?utf-8?B?d2xkYm55eXVldklHeHFPVmlvUVVXamc4KzdCbVBQUzhJNVR6NWdqRDRhUnJD?=
 =?utf-8?Q?P5J4iKuxR7k9XmHQd3LRLBFdwEj5kdrbhXCK1bneNIOP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6EBEF91BBC1F784882AA904E0B93D37E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d767491e-7333-4b00-6ee2-08db404a1614
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 20:18:34.5158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +VSyVvw0ovEC1pqbLNeIN1EONCnbWa3z9DiWTJ33No6BnC3T+MH4fyCqIMuUXstBvTL2UDNhacKI6dvNa4lLsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8561
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC8xNy8yMyAwNTo1OSwgU2hpbidpY2hpcm8gS2F3YXNha2kgd3JvdGU6DQo+IEZyb206IFNo
aW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+DQo+DQo+IFRv
IGFsbG93IHRoZSB0ZXN0IGNhc2UgcnVuIHdpdGggYnVpbGQtaW4gc2NzaV9kZWJ1ZywgcmVwbGFj
ZQ0KPiAnX2hhdmVfbW9kdWxlIHNjc2lfZGVidWcnIHdpdGggX2hhdmVfc2NzaV9kZWJ1ZywgYW5k
IHJlcGxhY2UNCj4gX2luaXRfc2NzaV9kZWJ1ZyB3aXRoIF9jb25maWd1cmVfc2NzaV9kZWJ1Zy4N
Cj4NCj4gQWxzbywgc2F2ZSBhbmQgcmVzdG9yZSB0aGUgdmFsdWVzIG9mIHNjc2lfZGVidWcgcGFy
YW1ldGVycyAnb3B0cycgYW5kDQo+ICduZGVsYXknLiBUaGUgdGVzdCBjYXNlIG1vZGlmaWVzIHRo
ZSBwYXJhbWV0ZXJzIGFuZCBkbyBub3QgcmVzdG9yZSB0aGVpcg0KPiBvcmlnaW5hbCB2YWx1ZXMu
IEl0IGlzIGZpbmUgd2hlbiBzY3NpX2RlYnVnIGlzIGxvYWRhYmxlIHNpbmNlIHNjc2lfZGVidWcN
Cj4gaXMgdW5sb2FkZWQgYWZ0ZXIgdGhlIHRlc3QgY2FzZSBydW4uIEhvd2V2ZXIsIHdoZW4gc2Nz
aV9kZWJ1ZyBpcyBidWlsdC0NCj4gaW4sIHRoZSBtb2RpZmllZCBwYXJhbWV0ZXJzIG1heSBhZmZl
Y3QgZm9sbG93aW5nIHRlc3QgY2FzZXMuIFRvIGF2b2lkDQo+IHBvdGVudGlhbCBpbXBhY3Qgb24g
Zm9sbG93aW5nIHRlc3QgY2FzZXMsIHNhdmUgb3JpZ2luYWwgdmFsdWVzIG9mIHRoZQ0KPiBwYXJh
bWV0ZXJzIGFuZCByZXN0b3JlIHRoZW0gYXQgdGhlIGVuZCBvZiB0aGUgdGVzdCBjYXNlLg0KPg0K
PiBTaWduZWQtb2ZmLWJ5OiBTaGluJ2ljaGlybyBLYXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2Fr
aUB3ZGMuY29tPg0KPiAtLS0NCj4NCg0KUGVyaGFwcyB3ZSBzaG91bGQgbG9vayBpbnRvIGEgaGVs
cGVyIHRvIHJlY29yZCBvdGhlciBkZWZhdWx0DQpwYXJhbWV0ZXJzIGJlZm9yZSB0aGUgdGVzdGNh
c2UgYW5kIHJlc3RvcmUgaXQgYWZ0ZXIgd2hlbg0KaXQgaXMgYnVpbHQgaW4gPw0KDQpJcnJlc3Bl
Y3RpdmUgb2YgdGhhdCwgbG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxr
YXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
