Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10970C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 23:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE4EC64EB8
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 23:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhBTXgd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 18:36:33 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:2435 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhBTXgZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 18:36:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613864184; x=1645400184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=clIzT4gjd3qdlUMgbOGHMYxt9KV1CBNaXaPBZFWUeXg=;
  b=f8DdctGWReF7j0UsePK8Xg7p35xwiovmezCIIGBKMHViVhj+U8OJ5fhm
   2Vw8pgNzU+Eut08gf20eZB+WmvSMf6F8igJQNVj4vnrMg/VrHcv45L1td
   HB1VGFvLf1i48RCAfFWcTiIHJpFLA7i/QmMD0UTKcZYoHbQ0LLmkmGcvS
   Mmz4uGToVdejjmNQV2iRnlpjZ1VDfa20uBl3JFX8uQGRRPJaBAnoxZOxD
   rbppvCkq4IGxdgRgTQi9ikiMTs3+9e1bSg6yM6FnRXnUimhbcKwD0+XND
   RtdRSSCh9hZzbxRaYhYAQNXdEMHYOmQKa8+mRVOP4TY6smJc0HOL7WdbG
   Q==;
IronPort-SDR: dBIxWRjociMFe0pTjfGnOMCZqZI0v/zfTu6gbudx1m7QF+3lkaNMAhUAnJUIhLjqATt52I0QiA
 J1F177H1qHHPYEGU+bn0AC/98opIr8yYOUXIZCrclgSTjV9GWkcbgIe7ATDfYeL7z4Xu19WV3z
 MusK+LS9Zglj9r7l+0q5DEHAnIzjeSRqPv0YUFpZZAi/fHh/ZO4zSvC/+PrOC6TyMVjLgq8qyN
 hhQD/WNccdeuJeRgEKGXlAiO2Hd5fCxWEuxL8g4wKsI6cGDyOOmb4t+iWF9rO5r5c3ZsT564+m
 bBE=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="164903693"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 07:35:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUFKACS+4fKhi6ZEuIj4nqII40UDoE0De82tC/TCxw0flFWt4EvFkDzYhoh+Z8rk0UM+JxHHZo0sBhszIDJZRH/4cs8Yh5a888pKMgP45t1DvkXFpvPOXn6We2APAzkwhBloHTXf0c3yEZfOoMPnlb7exbNlKdsKHhuyWgebrJYvL3pfhzxbxukI+hw6WIUw+2EdA0IaeuGTZKNGZt4X4T8ICJQysv6ECrg98dVUL539E36drXpqKJiSRgHIpG47XHi4i9lbx7Ooamt6ZeMTF2642MnB7QlojZ5AoZiqJ2HG7MsT0Kgtx+JLfWRHjRuZBfJjkk/+6VuqMOfwI57FQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clIzT4gjd3qdlUMgbOGHMYxt9KV1CBNaXaPBZFWUeXg=;
 b=Gs4Mc3u+2JZnw+r5x21PkJutnW4EtC0cmGEkPlE96oWi2vE+LEuIXYk7WpSjUQU4l4gPJt7fcR8pP74hdOI2whzCHgz5oGOqzzGG1rM4Fs88EZB78AfNtb4eq5vMNVZC/PVbBRdVYD11v+1yv1ek4YbO/Tm15w1OrTIPSqlPLyTyCr/il+4dY1ZaewJvGGb9Jlvgh/JmVVe/rHb78HXCd5lNWR2jZyOq9RPZgAtmyXaxToTUwnv+4lq9OQR/ijcBtZNxpvpuBV+w/IZKnhnES4lA04ydEwVzreEu2bXPcKhe4kN5tZK2Z9gFHr5U40fuQbC22ljbnaLWyULQArHzrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clIzT4gjd3qdlUMgbOGHMYxt9KV1CBNaXaPBZFWUeXg=;
 b=cmPVcgdJMoKjNeBExhx7eGK2NWoGpUN2G6Mgxqhim5nT927J1P51WNYovPUtApv1npe+BY6JnqGodfwR8Gg3CsihpvauSLsO8EVaH2uM204+ax52z/EZ8j7mV0jZXuGeadoR4inyZb123BsiUvo2yvc5ANHaGqraUowhMOAX7MA=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (52.135.233.89) by
 BY5PR04MB6898.namprd04.prod.outlook.com (10.186.134.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.30; Sat, 20 Feb 2021 23:35:13 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3846.041; Sat, 20 Feb 2021
 23:35:13 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [RFC PATCH 24/24] target: mark __rcu to avoid warning
Thread-Topic: [RFC PATCH 24/24] target: mark __rcu to avoid warning
Thread-Index: AQHXB9EeEiCuDQIf3UGzLrxVngbJxaphp5wAgAAK1AU=
Date:   Sat, 20 Feb 2021 23:35:13 +0000
Message-ID: <D4DD9882-25CF-4FCA-9F0D-7B9F11FD0448@wdc.com>
References: <20210220214112.7469-1-chaitanya.kulkarni@wdc.com>,<1bd73abb-2c02-8aa5-b583-f711fcae2c0c@acm.org>
In-Reply-To: <1bd73abb-2c02-8aa5-b583-f711fcae2c0c@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2600:8802:2702:d500:895a:f91c:fb3f:b5c2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 08d25bb5-6fcd-4f8e-e72b-08d8d5f82bd8
x-ms-traffictypediagnostic: BY5PR04MB6898:
x-microsoft-antispam-prvs: <BY5PR04MB6898D6DB5FAE402AD2E4580E86839@BY5PR04MB6898.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q+1EOqtn23CecpfKhYymhxsscTpDNJ1HHjNWAwUHC6JMQK6nrz/AskfKqjzf6IaQimKKt/VAhcbpYp2y5QzfLTqGOZhHAonqWVr0GQWDlkOIOf25l1U2dczPve8Yrjjeh2DC23J9VYz/FFaT2MnmSkp3zm1WSL7QvQQm3l7SUaEqdS3d8LnkaFu+Gcw65t857czNegxWJkVk/0+sbYvpg0EAjBiVSyVW1axQxEv4T7VH+ozVgEinfBJTqXBeSWW4phqsof4udVDeMlkB8UdT4+pi9NWA11WZGo31EfPfv6Ij2y7ZUwLikBe+vsNbuAkisELQ6Xs6DJRO7qLQxFIu4OfRlziiP0EqoEtiuiqzBi4gLoB8RDA1pOh3rb4tEgqtUBKxKuSSxhQm2s+ZYNKBcFqJ6DVzqNJDwhrRumLoiTlLpDZyDBrlqXdF5hIRImi8d1Thb2W8wIXcpdrcKmuQgPgh5MTR6zbVFeaDGEa1VodvLsJAePVd4W21brcv/RjUaUbE/s2TZyS3MxJ6GwJtukWQDo7kuAnkN+3GYBeuQuSNgfyI2z/AY6+loVGxiDyfUu68qr25liozpqFZjjGuBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(4326008)(186003)(36756003)(6506007)(478600001)(6486002)(5660300002)(71200400001)(6512007)(53546011)(66476007)(33656002)(66556008)(86362001)(8936002)(66446008)(316002)(64756008)(8676002)(66946007)(6916009)(2906002)(83380400001)(54906003)(2616005)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NWVZQXYxalpFTHlRTFhDenVWWDhJbEVUZm1ReGhYSXhHLzQ4b25RY0lEbHNG?=
 =?utf-8?B?YUlpc3JvZTl5b3R0KzlqeEpYMXVKcTRMU2UyZTFhOGdsSTNtb0MwajZ1WHlO?=
 =?utf-8?B?ODlsREFSeEhZQlFXVDgwRGwyUXo3Ukk2Qks1ZTlrbnBHWFM0RWZhN0VUaWI5?=
 =?utf-8?B?RzhtZGo1eStYT0NDcEpaOXpaQm5GVGh3eGxLT1ViZU10Q0hja3lrNmJFWWsy?=
 =?utf-8?B?L2xkbURycW4yZThWcUtTMW5RRFk4ZVV6VG14b1ZwWkhNUkRndHpJdVJ2QUp1?=
 =?utf-8?B?UkFtbXpKOTJPblV2a1JMdWcxZWNtL1l4Wi8rWlh3ejRydlpLc1RUVXNiRFFT?=
 =?utf-8?B?VWpEcDZuMWd1dFVpWGdYdzg0d1k3VVhOMWJJcUxMbkMwbUNSdUdheXVNeXh5?=
 =?utf-8?B?NUZVb3hLZWlnVjBPTFlFc1pXai9rYVlpcGNzOWxjZFY4c0xNbEdqc2pSU2dN?=
 =?utf-8?B?SU9WQTlMNGEwMk9KdzFaNUhDYTd4dGVldHQ4WTM1WHlPaFc5T0VLQnVkeVNv?=
 =?utf-8?B?S2pwYTA0NVAreGtOTlpScHBvRXRUSXR5cUlwZS9MV3NsY2ZjUHBLRWNYNWZ4?=
 =?utf-8?B?Q3RlVklWZzA4R01nMHJDYXZtQTZtU0R5RHh6WU0zWFRGQ2Y1dW1MeWI2eFow?=
 =?utf-8?B?dHprWHEvc2t3ZkYyZDU0Z1NpbFRna2FJZmhxTHhrcThsSVJ5b1gzRXhhMDEy?=
 =?utf-8?B?ZkZPdWt5VEhXNVNwRUErbVIrbE5iT2FiWldUMUVwWHh5Rm95S0Y4M3NsOHlQ?=
 =?utf-8?B?MnltdVpGM3hrYzhDdk45T3BsQ1VMeVBJREQzU09HRWJtVkYxWklNNWZiTllv?=
 =?utf-8?B?ckR4K0NCdlpQMjVZZnQ3NnBvSFZxOVBWQ3dWZ1l5Q0ZXcXhnN3RIMWFtbUdO?=
 =?utf-8?B?d09BN2RQS2J4bEtNZUluTC80WFc3ZFQ2RkZmcTFsMUh5Z0Vvb2xOZXFsQlZE?=
 =?utf-8?B?ZCtZTC8rYVhJM1hhOWloNGxwM1ZTY2FxeGpPZ3VDYkpxZVBqdHZWdWc0dzlT?=
 =?utf-8?B?ZytMY3N5L0krN2R4elJKOE5WcCsyeWpHNzY0azkxeFh0YlA3ZE0zQ092dlU3?=
 =?utf-8?B?VzdDUXN0Zk5LcUhtaHF5dU85cVhxRmhpNFY5QlgvbFpZc3hLRjFYR0JZMDha?=
 =?utf-8?B?WHJtaEp4N09xZmREenZ0cEltNDdybm5oUXNpa1FIcDYxZ2V6VkZxbWhYOFRn?=
 =?utf-8?B?THErdW5xZTVZRGU5SXZXTStZWTlOOGxucEt6dnF0VEx1UndXMlJiQWZ1WDlN?=
 =?utf-8?B?WS94dmI2SEY3dy9UZmF0UDJwT3pDWHl0NXo0cE5lazVRQXJpSE9HTncyd3Fl?=
 =?utf-8?B?ZVZaRWxPZzVJMS9yZUEydms2Nkkyc0JxZElsNkljazA0bWxNUFJNYmgyR2VX?=
 =?utf-8?B?WnR2RnAwZ2s1MHRWRFF1OEVLUXhUblZPVEh5YVd0TG1MSTNWNjJ0V2NYalJj?=
 =?utf-8?B?ajN2ZEhaN2h6SnpYUXNNR092SmZFakUyU1FkUjZjbGM1TXFmTStsNzlyNTJ0?=
 =?utf-8?B?aml1WEVka1B6bDd6c0JDZmJIUTJ1MzUvTm1zT2MraDFndUlIdTQrdnVJeURP?=
 =?utf-8?B?UXBLVENoTnFVcU93cmZFbjZKNXBzSFJSL0IwSGd5UEFTZkdCOUpZNk0vdGJj?=
 =?utf-8?B?UlhwTVBrS3RWY295Tk03dU5ONkFqa09zdTBib0NpOVBRZnJiMUhLYUtOM1Fa?=
 =?utf-8?B?VlRzdHRCN0kxbkN4TmJZcjhkQXNIN0QvTVZiSW5QV2VLTWJteWw0amw5OXV3?=
 =?utf-8?B?TTJjaHU0R2ZUTVJqV2JVZ3ZIbTlMTGFSbGErQ3IzL1RidXkrVm9CTFc0MWNS?=
 =?utf-8?B?NzQ3aGtDc1E4ckZLUmVaN0Z3SlJ1bncrQXFybEltRXhNVTB4R3d1bFFLZ2s5?=
 =?utf-8?Q?nzduJzIxkuUS1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d25bb5-6fcd-4f8e-e72b-08d8d5f82bd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2021 23:35:13.6616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NI6JGEu36fM4smjkeJIBZoVhIezPU3I7+dCl6JCHqVzv8oNpmzB2lE9ktNWmIoDwdfoqd9Hquo7QUE2ublrnR6eETyzCYor1MBZAwtoFapg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6898
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+IE9uIEZlYiAyMCwgMjAyMSwgYXQgMjo1NiBQTSwgQmFydCBWYW4gQXNzY2hlIDxidmFuYXNz
Y2hlQGFjbS5vcmc+IHdyb3RlOg0KPiANCj4g77u/T24gMi8yMC8yMSAxOjQxIFBNLCBDaGFpdGFu
eWEgS3Vsa2Fybmkgd3JvdGU6DQo+PiBNYXJrIHN0cnVjdCBmY19scG9ydCBtZW1iZXIgcHJvdiB3
aXRoIF9fcmN1IHRoYXQgZml4ZXMgZm9sbG93aW5nDQo+PiB3YXJuaW5nIDotDQo+PiANCj4+IGRy
aXZlcnMvdGFyZ2V0L3RjbV9mYy90ZmNfc2Vzcy5jOjQ3OjE3OiBlcnJvcjogaW5jb21wYXRpYmxl
IHR5cGVzIGluIGNvbXBhcmlzb24gZXhwcmVzc2lvbiAoZGlmZmVyZW50IGFkZHJlc3Mgc3BhY2Vz
KToNCj4+IGRyaXZlcnMvdGFyZ2V0L3RjbV9mYy90ZmNfc2Vzcy5jOjQ3OjE3OiAgICB2b2lkIFtu
b2RlcmVmXSBfX3JjdSAqDQo+PiBkcml2ZXJzL3RhcmdldC90Y21fZmMvdGZjX3Nlc3MuYzo0Nzox
NzogICAgdm9pZCAqDQo+PiBkcml2ZXJzL3RhcmdldC90Y21fZmMvdGZjX3Nlc3MuYzo3Mjo5OiBl
cnJvcjogaW5jb21wYXRpYmxlIHR5cGVzIGluIGNvbXBhcmlzb24gZXhwcmVzc2lvbiAoZGlmZmVy
ZW50IGFkZHJlc3Mgc3BhY2VzKToNCj4+IGRyaXZlcnMvdGFyZ2V0L3RjbV9mYy90ZmNfc2Vzcy5j
OjcyOjk6ICAgIHZvaWQgW25vZGVyZWZdIF9fcmN1ICoNCj4+IGRyaXZlcnMvdGFyZ2V0L3RjbV9m
Yy90ZmNfc2Vzcy5jOjcyOjk6ICAgIHZvaWQgKg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBDaGFp
dGFueWEgS3Vsa2FybmkgPGNoYWl0YW55YS5rdWxrYXJuaUB3ZGMuY29tPg0KPj4gLS0tDQo+PiBp
bmNsdWRlL3Njc2kvbGliZmMuaCB8IDIgKy0NCj4+IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9zY3NpL2xp
YmZjLmggYi9pbmNsdWRlL3Njc2kvbGliZmMuaA0KPj4gaW5kZXggOWI4N2UxYTFjNjQ2Li4wNDQ2
NTEzZTQ2ZDggMTAwNjQ0DQo+PiAtLS0gYS9pbmNsdWRlL3Njc2kvbGliZmMuaA0KPj4gKysrIGIv
aW5jbHVkZS9zY3NpL2xpYmZjLmgNCj4+IEBAIC03NDYsNyArNzQ2LDcgQEAgc3RydWN0IGZjX2xw
b3J0IHsNCj4+ICAgIHN0cnVjdCBtdXRleCAgICAgICAgICAgICAgIGxwX211dGV4Ow0KPj4gICAg
c3RydWN0IGxpc3RfaGVhZCAgICAgICAgICAgbGlzdDsNCj4+ICAgIHN0cnVjdCBkZWxheWVkX3dv
cmsgICAgICAgICAgIHJldHJ5X3dvcms7DQo+PiAtICAgIHZvaWQgICAgICAgICAgICAgICAgICAg
KnByb3ZbRkNfRkM0X1BST1ZfU0laRV07DQo+PiArICAgIHZvaWQgICAgICAgICAgICAgICAgICAg
X19yY3UgKnByb3ZbRkNfRkM0X1BST1ZfU0laRV07DQo+PiAgICBzdHJ1Y3QgbGlzdF9oZWFkICAg
ICAgICAgICBscG9ydF9saXN0Ow0KPj4gfTsNCj4gDQo+IFRoaXMgcGF0Y2ggbG9va3Mgc3VzcGlj
aW91cyB0byBtZS4gQWx0aG91Z2ggdGhlIHRjbV9mYyBkcml2ZXIgdXNlcyBSQ1UNCj4gdG8gbW9k
aWZ5ICdwcm92JywgdGhpcyBpcyBhIGNob2ljZSB0aGF0IGhhcyBiZWVuIG1hZGUgaW4gdGhlIHRj
bV9mYw0KPiBkcml2ZXIgYW5kIG5vdCBzb21ldGhpbmcgdGhhdCBvdGhlciBsaWJmYyB1c2VycyBh
cmUgcmVxdWlyZWQgdG8gZG8uIEluDQo+IG90aGVyIHdvcmRzLCBJIHRoaW5rIHRoaXMgc2hvdWxk
IGJlIGZpeGVkIGluIHRoZSB0Y21fZmMgZHJpdmVyIGluc3RlYWQNCj4gb2YgaW4gdGhlIGxpYmZj
IGhlYWRlci4NCg0KVGhhbmtzIGZvciB0aGUgcmVwbHkgQmFydC4gSSdsbCBtYWtlIHRoZSBuZWNl
c3NhcnkgY2hhbmdlIGFuZCBzZWUgaWYgd2FybmluZyBzdGlsbCBwZXJzaXN0cy4gIA0KDQo+IEJh
cnQuDQo=
