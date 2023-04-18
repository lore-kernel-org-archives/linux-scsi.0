Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B11EC6FD18
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 20:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjDRUTr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 16:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjDRUTo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 16:19:44 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0E5A266;
        Tue, 18 Apr 2023 13:19:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3Oq6HdfUPXOZ5cQmzzc5TBnPSi859+8e0JCN2mpBUe0A0in90Cq53cjvYrVlKtsTsFVYwnGH/9piuI7tzew1cGrai4DDHR4oT4ZZsHBPbBUmn+Q7k6PR+3Loh3XpF6yBK6yq+vGOGYKoOAwjYl44to/wMDDkR0ZfHnXKxoOCViFnLo7JsRosg3BLZ1Jd68wrVtIOgMH596KMX0IELaNMPJrQ4NYC2RSt03SxQqGYFYygzfFEb5ftJgo/QKObQzlgGG8Rs/aZHSsVBiDr592IyRhfdmvnFrIhyXGd89t4x+MTAUmcvDGgwlaJrHucjlSrJRA9KUPa5AS2Cr6bkTl1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8ELNlJNx2+xyk4P65/UdD5ddVPNT1watsyuaQiY4DA=;
 b=J2bqj+3gjvMzF5o3bh1gxUVbTgCXHu5U1aUw3TDlm+TYWn8stMGG+Nawup+b5a074i1228DK0wxUrcGyDV6oK/nP4YyqqodO8lkLVCGOtyni2OsWo5VO1XdV6a7/vmte+YReegQpsiVUo3hlh71fBbC0DExrp+qcZd9RSn84epHx96jzfNT/dPNUT7QbKKb6pNB8eNTDjyy/PBSFZBI4QgUOTxszfA/B42bPlXprGWOhcl1n5MKkm6RiKKSqs24XMhVbDkCsuvEfV/8DYPx4/FvgSJy56DqHhakU0ok99/BlSBe9jpw7hc+fCC9ih0URqrjyj1awgKla/lzA8u5+hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8ELNlJNx2+xyk4P65/UdD5ddVPNT1watsyuaQiY4DA=;
 b=JPB1/kHUCEbEpWLay7z2UNhRGMOLKRpUmAoe4n9n3z6N3IWv0TTQqhmyIb8A4XGwGTjbu0RdrYzDFAIIJatv9VSDwEEBAmIXtLHa5WhNnkukU5oCnhmpLmGBNj3nhKkzNn9Z8qz3woI5zVTi6LO+ud7cgT3GVm3RZoChrFTtO1dj3uj4UZSSndUoJNKZUTkU1smZTLmQpe3UvAYcWdn6Pd2RACDv3x7DC29L+iU02LOi4p+9dY3cyxJB9VS5Sq5ZnQNlx55P0/gEPy3kEGXT43tITreMmjrj+jtddvejGYhlFdTJjaGnv6YZ2QRzZS6afHDuzqd5QH6/el+pvJ7G+Q==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH7PR12MB7380.namprd12.prod.outlook.com (2603:10b6:510:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 18 Apr
 2023 20:19:41 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 20:19:41 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests 6/9] scsi/005: allow to run with built-in
 scsi_debug
Thread-Topic: [PATCH blktests 6/9] scsi/005: allow to run with built-in
 scsi_debug
Thread-Index: AQHZcS0la+XrcXaQdkeARUMszTBSoK8xg9yA
Date:   Tue, 18 Apr 2023 20:19:41 +0000
Message-ID: <cd0c1e7b-abe3-9f86-655a-25cabae1ee86@nvidia.com>
References: <20230417125913.458726-1-shinichiro@fastmail.com>
 <20230417125913.458726-2-shinichiro@fastmail.com>
In-Reply-To: <20230417125913.458726-2-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH7PR12MB7380:EE_
x-ms-office365-filtering-correlation-id: 08f35d22-be5c-4b04-ac06-08db404a3e18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KRNU2ytAZJeZD/JOzI3d6k/6aaE1GBnOsGbuB6lkcXzsfliSKdlHd1XTTI3Vpl+JsO9zLPdssuz1ArvXHIyUrWdNv5baftff04Gr6RSQHqGrBzh3tCTHacr6qaZuG1pFB6yYGFxxUhDe00t8rI4XFuIMgZrVB/l3PucdQL/ZVbuFQWtfp1Emtxq+AwDsbAfw7zlaC6v+WiPWXqeXaKdFVgBfO1EmghB1Z+Myi15QK+VFDGNiVBbE6HuL4pgJwFolp/o2HAQsUVGVhxQZSiLxslZDm4khmcsBDuYOaZta3KN294ZoK3WLiTgOyNeSTTkPQmO9iOkVlWSbF377QfnYN0vFFKK15Ch/ayNjDZeQ9Ln4GfDYjSExGrnvkIboUxl6E2MApmuF7GZxLkPFGCSb6hEt3JJwv8ZeshYsnqM2omQKLbri9URbCmLU6mI9V9EVUQh3h/g2YWuPpzPKD/TFB/Hbp85Yyn0XPZ7haeBcmDC5diovyUgbkGMSxZrStrHmz6Wx2rhq0Kv9pCnEbL4rhCW/5KzxntjMgEru24ZejQg1YejGGyfgyHKImCfkspUHN9+xto8Ovsje7jBT42xYEYzrvwZvnBKdiOwy61LAlzfK9FSuzhdT2/ukUMlH2hubRUFYSnPlJ0r5aRMmdP17kuA5JI4v9f4Eu46PMqH4eeWnH9NLOgS6cC9f+BRVEBy3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199021)(8936002)(38100700002)(8676002)(122000001)(41300700001)(64756008)(5660300002)(31686004)(4326008)(316002)(91956017)(110136005)(66476007)(66446008)(76116006)(66556008)(66946007)(4744005)(2616005)(2906002)(36756003)(186003)(38070700005)(6486002)(71200400001)(478600001)(31696002)(86362001)(6506007)(53546011)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0d6enRsbE01ZCtBQXQwRmRhY2VYaC81VEd1MUtMaE1LZ0pJU2NCZEIwYWRX?=
 =?utf-8?B?c3k5amdkMVZFYkQ2Nk9Pb0pqNmd0VlFqMlkyVk5xajNRSUJjS1R2VWQzbi9Z?=
 =?utf-8?B?MDJtbktxUnJuSFlvVTVoWEpkRjdjUnFCRnNYd2gxUEFJa1JxajhTaWdXdStW?=
 =?utf-8?B?WWJleWxvTGx1b2JSaFBPZjR6NGQ4eUIxSWtTbnRhSVRXbnUwQjgzTGRONEVZ?=
 =?utf-8?B?R1dyTDJXOTh6OStUc2FjQWxRNUpObkxGSDVpbVVya3J3NEFnbjg1THhSYkdo?=
 =?utf-8?B?WDhiNnVvYmRyKzFUMHcxRlgrU0pFZEFLWGQwWm1sd2JnUS9MNmVERkp6N2NF?=
 =?utf-8?B?enYxSysvNWJtcG1INkx2SXFwVkRMaUZYR295aUhRQ0dNL0pJam1UVjdkdGVu?=
 =?utf-8?B?dk1MOGZpQ05mbVQxbEZ0RFVpcWd2VVVPOGdvYk9RaXBmRVFQTXFRbUI4SjVY?=
 =?utf-8?B?V1JqbU9nVHpSaWhMYjZuTlV1QVZjNWZUN3lIK2hXSDdyYnovYU9IemFuYTFx?=
 =?utf-8?B?YUMwSHJpT1V5ckk0SklQcEtneXM5Vkh5UEdEdm16alhZNzMxSVBBRGFiYWRN?=
 =?utf-8?B?dGJsWm4zWDh0Z0x5ZURrZ0xhSmpJcERIOXFNcy8rRUpIZ2c1U0Z5UDBEajND?=
 =?utf-8?B?SUpycWs0UGdWd0VWT29uaFNiTC8zcm9ZK08rODVrd1oyZDdBSk5wYXZiZHZZ?=
 =?utf-8?B?a2UvWXBvMHI0bHFaOThMeTJYbHJ0Rm5xQXEvNjc0OU5ncVhacUtMYmt3cWxu?=
 =?utf-8?B?dlphaWYycGdYb3V6Q2E1NXBUdmx3UEJZSkdBL0NRVk9oOGlaMjVTMjdxa3ZP?=
 =?utf-8?B?M1pxcDZCQ2RUU1g2VHh2Q2xJZDN6eWxmQUQwSFZ4ZGpRR0YxaTZzTU1xejRM?=
 =?utf-8?B?azNFb21mUms1UG0vVmVBSVdib0ZhQWJuTmRqQ0tjREJDUm1wc0NOTDRjbElJ?=
 =?utf-8?B?bHNZRys0a1RJd1hSSTZOQXk0aksvazIwUFE1emlwNUxaLzJRMG96SEMvNy9J?=
 =?utf-8?B?NzYrYlFSUnVjVytkV3FMUEVBckJ6NlJxV2VMM3NjQWFvSTAxQnYvYUZRTjEy?=
 =?utf-8?B?N0FyaXByaG1SajN3VE5vanBDeWt0SDZUWStCOHZ6a1NJVGNsdGtmTHdyUkdR?=
 =?utf-8?B?L3hJSFZpZ1AvZTd3MjdRRWRrazhwbEtyOGh6V3dEenVBcUNDUFVzeXFQSzRy?=
 =?utf-8?B?aXJoZWo4czRWbWphZXpyaFlqMXhlUXJTK3lva2RJNFJRejlwa3E0R29xT0FU?=
 =?utf-8?B?TXpMZkh3bVR6WlVIL08xanhVbjgrbkJwdGw5eGhpVFlXc2dCVnM4KzhjNlNC?=
 =?utf-8?B?b0VPUkdVMjgvT2RTdURGUlBCNmdRVEZyWVd2OW8wVGp6QmlodDhUazQ2ZHdt?=
 =?utf-8?B?OEMvK2hlWmhJWWJJYU9zK1AwZkkvRm4zcWt1ODdCUGhrTFR1WXZYb3JEbWRM?=
 =?utf-8?B?OFZzbUFqRllDTlVFclAyakxwcVB5OVRzZE5pR210QnlML2Y2dHVSM2pHSWph?=
 =?utf-8?B?dExjVkY3RjRmT1ZUNElLRjY3dFgwdGs1VGxXVzV5NzZuRjRPa2FzSWpvTmli?=
 =?utf-8?B?SFh0dkxqY3FDVHAwUEJYMWZ6R0hCZWlEaWN4KzZidU9zTWVUanBQWEdvYk1N?=
 =?utf-8?B?RktLN2p3dS9HeVdxaFloOVJ4UEljWGQzMGRvaXYrQlFQUGZRMFVtR3ZBRUxC?=
 =?utf-8?B?MFFUZWVnTk41aGIra1IrdEI1eFNiVlVLZ1FpbFBxR1QwVzRBNGszWG1JRWsx?=
 =?utf-8?B?WmV0dzUrM2lOMlFsNStJRnNFdytCMVZiRjNhWk1vYVRWRzMvUkh4ck5JRUxE?=
 =?utf-8?B?S2NaWTI5QVRaR00yZ2JiUjhCU25yWmZDcTZjSVN2MlFtaXhhNmhBOFcxUGxz?=
 =?utf-8?B?MjlXWXFWSmkzcU9XRWhBUTBUTERCa1ROM084WHNmSWNXN2pOWlBhbnpEa1NX?=
 =?utf-8?B?bC81NmExMkdBb3JwSUdXUjZ1Qk5adWl3REdpckVlVmttKzIyTjJhTXIvT25G?=
 =?utf-8?B?Q2dmR2xNS3llZUpQRlpkNzhrWXg3WDVuTmFLUS9JVDhXWDBPbGI5RVNmNFNV?=
 =?utf-8?B?UU1Ob09tVk0vOTR5azNXQ003NUVob1VvN2hpUlVHMXkzaXpXblVBSzk4ZnBD?=
 =?utf-8?B?K1M2a1RvWnhBb2NJWUwzSEtoRWFSVlQ1WVB0Z1JDeGx1djdGZE9oZ1NZVlg1?=
 =?utf-8?Q?XiK2IJk5p9pNTXGKCmehU9C1qeBFR7aPB97K0hEF0iZJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62F860E3449F6F4594A9A2214B5F5D6B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f35d22-be5c-4b04-ac06-08db404a3e18
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 20:19:41.6200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HufKOvWBRc7K1py/pmgTQSCn1rkp4TVx7T645SKCQTwKxljxe71uBEgaFGpNVC4tVpUVRda9/FVyT8M+8FJ12Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7380
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC8xNy8yMyAwNTo1OSwgU2hpbidpY2hpcm8gS2F3YXNha2kgd3JvdGU6DQo+IEZyb206IFNo
aW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+DQo+DQo+IFRv
IGFsbG93IHRoZSB0ZXN0IGNhc2UgcnVuIHdpdGggYnVpbGQtaW4gc2NzaV9kZWJ1ZywgcmVwbGFj
ZQ0KPiAnX2hhdmVfbW9kdWxlIHNjc2lfZGVidWcnIHdpdGggX2hhdmVfc2NzaV9kZWJ1ZywgYW5k
IHJlcGxhY2UNCj4gX2luaXRfc2NzaV9kZWJ1ZyB3aXRoIF9jb25maWd1cmVfc2NzaV9kZWJ1Zy4N
Cj4NCj4gU2lnbmVkLW9mZi1ieTogU2hpbidpY2hpcm8gS2F3YXNha2kgPHNoaW5pY2hpcm8ua2F3
YXNha2lAd2RjLmNvbT4NCj4gLS0tDQo+DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBD
aGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
