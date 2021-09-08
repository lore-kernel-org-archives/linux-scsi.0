Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D851C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 07:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68DED61165
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 07:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347553AbhIHIAk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 04:00:40 -0400
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:2017
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347857AbhIHH6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Sep 2021 03:58:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0rFNIyADbdeQ9LjaqBlD7YySQ2c8O5f2GqE3A2HLRfdqh0Ja/xh9ZZgbc04fUTYXfznP9jdKvdXB3UPdr2p0J6MvY6Cftmtf7vnnYulBOlbLopW6udpK7YGK7tErInW3wtlfi1ZN5dI87RlFozO30xU/4fOaMNIhMkHZsgkPUZ822qxe7sLYZFeuQ5PYzjurpwKGdFoQ9EGCwN3Tmz/8sYPcia8yUcmfyYaztlu9PCCfdwGgrusJ90zA6ND+pgR0MdCcChP3Lut7OIYyJRHkAxDPE95FLyn8vrjyCSbJ9Ur8DbY69ewxiJ2ObecFmcxmBEVom7kCJ9v4qidOxh91w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dK4GUuZ0heijtQuZAR4nwrWpclVg/AyeWvM4lJqGzGk=;
 b=cs65k7QgHgYvYURCylsqn/UibNgSqidGUHwjabeQfy+dq6pleaCKm3CO9IOg/8OWsvVbMbhZ/ryBXK7euJcJaM/oQL9TZQgECnBtW5oq8Ih+N6eqC5nKW3uTWn7KTL23FqPzwX4ycoiCn9RaVLnuiH3mVWGrfDF+B8N9ha1ctZPKHKlTN9HZqL4q/cFKthN/03d1Vr9p5geOkxRI0awMDXri827mbipfuCD6TXkxU1Nbdmd/1hkIK81UWGNGzafiaDY8yGypy4aR3Y5ZArXr6tNepl9tuyRqxk+bTYEV2wS9WtUtW0F8aJIe//ImRyR13iBUhOXRna2S0DAUdnaM/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dK4GUuZ0heijtQuZAR4nwrWpclVg/AyeWvM4lJqGzGk=;
 b=AE34NZtqxMurEQX0WWJ05TBKQPOUHAMDBFKdtTXNdRyOBDNXqctCl8iCeMrMXYzlaW5I2HR2vjC9Scl4NLJX6rbPjMvLQ0Owsgt8Uv3o0moCeZGgrT/cTcKwqviJ4iMA/EYAlu+zDV58FFNh4GaG1qwg+VjB730tU+ZhnEq2KGrnA9VoiswuDOfy8hH8Fe+wjvks56yOXEGea/bewepRcI9hqwevp+Hbr5qiVqVcPBfkXNrWveWuj2NWTFzG2wrSj6HbpFeIKGrCqZr9tzzBaJjfkIkMzWe91AA8SeSDcUQYphK7ydEFlfYmLV8u/WLSY9YcxumAO1mb5ObMtlveug==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR1201MB0158.namprd12.prod.outlook.com (2603:10b6:301:56::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Wed, 8 Sep
 2021 07:57:38 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::498a:4620:df52:2e9f]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::498a:4620:df52:2e9f%5]) with mapi id 15.20.4478.025; Wed, 8 Sep 2021
 07:57:38 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 00/10] qla2xxx driver bug fixes
Thread-Topic: [PATCH 00/10] qla2xxx driver bug fixes
Thread-Index: AQHXpISAD0D1xmfxFk6S/bXnlodKkauZxVeA
Date:   Wed, 8 Sep 2021 07:57:38 +0000
Message-ID: <d2022256-52b0-1ab4-82cb-83fac3c49cd4@nvidia.com>
References: <20210908072846.10011-1-njavali@marvell.com>
In-Reply-To: <20210908072846.10011-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 454922ef-c8f3-47b8-8f5b-08d9729e53a5
x-ms-traffictypediagnostic: MWHPR1201MB0158:
x-microsoft-antispam-prvs: <MWHPR1201MB01580DA71356570D5CCE7B6AA3D49@MWHPR1201MB0158.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:403;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3T6TtWPLODihaX41rFs8LEmF+oA5si2xCtm7QFiKSjvJ4EX5NKBB6iFnHQivzwBYJM3oQVUiJHVkKtRFiYNKO7ao9ocCTUZJht9iEdsT1Wh0RR/JQMUwZRDcttwWJU9krNt/Ruqc+KZBG2y80Ufi+xIhwHjSHHO9yoNi/jku64sMCwyv9V7eAgtIg1KIQMLZcEHV9djZSbt6eULOpQdDAosDokVCG4aOhHm8LTNIrX/M9ZKxcM0QX48GJAJeydNqgTi28gTT9jnYoAIeLrjp1dGAcAWra8bzhLM2W8HCPR/6iXzsgsrDQ+jDXgGnFlhoNq9a/gDosDgNacNM98ShsxOPJXrFK1XM1eubAxR29zm7Bp+HR0DncweoQ3M3lyUS4nub5yXebBkaYBNma4I+X60eygecMyRlPfGLVixRCq+P50YpKYvCiDxOx4CwVwjJbjj38d5O9keud/KUtxWklmQs8QEiPbdDKCobnAz8Zmw/tBUQx6Rr98CRDtIycIFrKDDIe+DieAZLYPz/KpE7rrc2u2jDwIRStJ9c4d10Zzgnterg5ZzZJT+jhq946hE2+IuNDLl8maRWRt40Pl6MHjekdygCS1A2nRIECE0/q+KssRweyFDzvnZ3ttt86PV05NrEdDl4rsi+/vvYCObHi+ou3xJpr6zspHDNi/K9gthltXuprtX1X/0GPDdIVr/KrwDzsX9rf2fd2ForPTcoRBMvw/zIg07I1LCdd8CaZwxFwrg5Jk2AGWB9tXI/CCh7LKkKdn/QI8UTzZsy5EoqXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(36756003)(76116006)(186003)(91956017)(31696002)(38070700005)(8936002)(8676002)(66446008)(5660300002)(66556008)(64756008)(83380400001)(66476007)(54906003)(66946007)(38100700002)(122000001)(6512007)(4326008)(2906002)(4744005)(478600001)(110136005)(6486002)(2616005)(31686004)(71200400001)(86362001)(316002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUhSWlhSVlBKUzdoeDUzRlhQZnVUS3hQSVRUeVNJNGZMZ1VjK2xuc0lnSEwr?=
 =?utf-8?B?aHdxMU0vbzNBWUltN0g0OWRwcXFNY3pySm1vcnErVjJlZyt1WFovOXNER1B4?=
 =?utf-8?B?WW1nMVdIRUMxaGcybUJCVldlTFRuWGN0VWJzOVNSZ3RVL1AvVWRUaHFIc0kw?=
 =?utf-8?B?RVBLQm9Memh3VEJtSFFmSW81YjY2Z0ZvdE1aQk9SY0hXNlNNVXVZK2VNTnov?=
 =?utf-8?B?RFhOYW9ZNUwzQm9ueERDRHJBYjdqa2tiQXBJeGxvZzY2cGZhQVIwYWprdTZr?=
 =?utf-8?B?cTF6bEFITjVOdEsyeUNXR1N3R1lRRzB0eXVtcXFZY01XTkQ1RXk0RzFsdmZV?=
 =?utf-8?B?VXkrYkVCRFRrczBzRVNHNThjMDdXdEpEY29jUzZhS0R6K1JaeUM5VlQxdXNN?=
 =?utf-8?B?SlNwRDYvMHFkY2E5VURWSjBrNi9oQlhPb0cwSW9EVnhXVFNnSStGOTkvMVRw?=
 =?utf-8?B?anZKMjBqcmlTaW9rcTJFeTVzcGduYVF0d2ZWSkVKREF0M2lIQmlyTjZpUGU1?=
 =?utf-8?B?UDhsS3BxenFNRlpnb0pxQ1RwWVlNem9EcjViTEorY0pGVS9DeS94NStHKzk3?=
 =?utf-8?B?ZjkxVkRCWFlSQ2hwaFRmb3JFV2NtNTdQSmZKbGkvK3BiNWx1cjRucnlqVlBL?=
 =?utf-8?B?VWJ4YVZzNzArSUs1YVlVSFNHZGZKMTdIemh5Mzh6cmRBdXMrNzJvcXl5TGtu?=
 =?utf-8?B?UWtFa0UvNW9ua3J0djNGcFYrKzJmbGJNUEYybHFiNHp3ZUxmVXFCK2d2dFhp?=
 =?utf-8?B?S0ZSUzdrdG92bkdtZ3laaXdJV3JFVW96dHBER3pURlFwenVZanBvcElxQkhr?=
 =?utf-8?B?RUtwREdmSDlONkxqcXh2YTVDNWdtS0txdWkxaFJweFN3NktoS2x6T2JxSG5O?=
 =?utf-8?B?cXB6b2Mxa01pc0o5VkZmMXlFOU85WFF2YTY3M3FiZ2hwQmRyV2JoQWo4U05p?=
 =?utf-8?B?TWNJTzdBWWUxSVNiaUgyRlNFeGFIUFFENzM3K2V6SGg1bkJsQ0pId2daaW1F?=
 =?utf-8?B?YVlWblAySkZPaFlqTmUwbmVoTVVycEl1V0VaNnU3R0dPaGZiR1ZKNXZ0Szd2?=
 =?utf-8?B?NEZRc1I1bllldkhjL1lBWXhVdURyampLMVNwY3ZIbTFsN1M1MXlqREdORm1t?=
 =?utf-8?B?eFl3S1JzdFhQaTEyRmlzcVd6Vmw2d0o0bnFsZGg0eVNnbVZHTmpKVXozamQ0?=
 =?utf-8?B?TTNyczBDRmVzcTlNZmNtSUtKZUlYTVFNRmVodWVWTkx5ZE1JVmxGa29hR1Fu?=
 =?utf-8?B?V1pvdDhERUpFL2tnOFhLWU1IWjFCUUZieWk4TDk2a2hKTXhDREJob01Xelo4?=
 =?utf-8?B?cEJLU251cXNqMVA0M0c4cGF2ZUpUd2lMNTd1b1Vad3RMRVRFYTUwNWlWemtt?=
 =?utf-8?B?OTN0UmxBYlNNei93MnlpTElTOFRiNjdZT3ByMlNEZHdiN1dqNFB6MjZtcEEw?=
 =?utf-8?B?eExoVG5mbjlmUkxQcEEzeUkyT1dHb0ZvWlNCU1B2MjBuaUQzcUgzbWl1cTRO?=
 =?utf-8?B?NHRrb3JPL28yenhNOExBNTQxb2pSQ1FKY3N4b0p0WUNiZ29kS2RiZm12c3k1?=
 =?utf-8?B?TE8rN1cxN2dFYXhKaFBtY05pS3dsOWdkM2JNVWlIZFVVb2ZtSUNWUzBZak1r?=
 =?utf-8?B?L0NLWU9ka1ljS25hZmQ3U1hTaVRrVnRFTGRHMjR6QUduMUtRc1dWTjV5c2ZT?=
 =?utf-8?B?OUZmek9WTCs0ZWZWb2RBRmVaZTdnUXJOc0sxdXpWdkI5L2wzTGh5cEROYkR3?=
 =?utf-8?B?eWNHSzIzWWF3K1Y3TGlxeG5ROTNqUmpmWVB6c1Z5aUQxSVFkVHFWd3htd2dO?=
 =?utf-8?B?OWEwWWRVWnE5R3I4R2RsZ1Rld2g4MXM0ZnNRMjNuNWJNYUVuM2tCSitZVXNi?=
 =?utf-8?Q?mgcPyLnhDbR3r?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <48F856092DEC794DAD981FCFAECF5299@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454922ef-c8f3-47b8-8f5b-08d9729e53a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 07:57:38.2404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CWSx+Xue7TEv8uJm65Xnttwl52YxTQh7IUA7LbDFRuKU7tgFC6EFKGB7rygwp/zLnBviQOwt0KAXSjARpiQgGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOS84LzIxIDEyOjI4IEFNLCBOaWxlc2ggSmF2YWxpIHdyb3RlOj4gTWFydGluLA0KID4NCiA+
IFBsZWFzZSBhcHBseSB0aGUgcWxhMnh4eCBkcml2ZXIgYnVnIGZpeGVzIHRvIHRoZSBzY3NpIHRy
ZWUgYXQgeW91cg0KID4gZWFybGllc3QgY29udmVuaWVuY2UuDQogPg0KID4gVGhhbmtzLA0KID4g
TmlsZXNoDQogPg0KDQp3aHkgbGludXgtbnZtZSA/DQoNCiA+ICAgZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX2F0dHIuYyAgICB8IDI0ICsrKysrKysrLQ0KID4gICBkcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfYnNnLmMgICAgIHwgNDggKysrKysrKysrKysrKysrKysNCiA+ICAgZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX2JzZy5oICAgICB8ICA3ICsrKw0KID4gICBkcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfZGVmLmggICAgIHwgIDQgKy0NCiA+ICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2di
bC5oICAgICB8ICA0ICsrDQogPiAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9ncy5jICAgICAg
fCAgMyArLQ0KID4gICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jICAgIHwgMTcgKysr
LS0tDQogPiAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9tYnguYyAgICAgfCAzMyArKysrKysr
KysrKysNCiA+ICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX252bWUuYyAgICB8IDIwICsrKysr
Ky0NCiA+ICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMgICAgICB8IDg2ICsrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KID4gICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdmVy
c2lvbi5oIHwgIDYgKy0tDQoNCm5vIGRyaXZlcnMvbnZtZS8gaW4gdGhlIGFib3ZlIGNoYW5nZSBs
b2cuDQoNCiA+ICAgMTEgZmlsZXMgY2hhbmdlZCwgMTkxIGluc2VydGlvbnMoKyksIDYxIGRlbGV0
aW9ucygtKQ0KID4NCiA+DQogPiBiYXNlLWNvbW1pdDogOWI1YWM4YWI0ZThiZjU2MzZkMWQ0MjVh
ZWU2OGRkZjQ1YWYxMjA1Nw0KID4NCg==
