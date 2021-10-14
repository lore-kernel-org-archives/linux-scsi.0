Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777B8C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 10:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A05D61029
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 10:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhJNKuq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 06:50:46 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:12871 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhJNKup (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 06:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634208520; x=1665744520;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y/3tSxnX40q+fxa6LMJg6bKjZLU0+4ShWnbdARQrz1g=;
  b=LK4XiUNIAjmeHrnI2EyDQXr8J3rZRTBsR0wWp6CECX4/EqzICtDmFqmY
   sGNV+CVHuzO1SKsT5TZFXQ94gUYudU+cmYjZwOu2O7RLXEmD+ZyxZSCg+
   viVRiYdI9ZOpcK99z+zT2g40d7al15XcJXaS+95SsqQBRNeQvE5EqODvR
   nzYOTOC13Fdp+YjxXBqLuwVkFa+MSp+exm1GRK+FPOmXJ4owzJKe2yX/2
   xxPHyUwZKKeYVA/64OAPg1UvdU2j/rD8wK0aG1I8nq4uezFnieaOIc4kJ
   b5xPRlVihBGO8Nd4KavcC77E+gwjVFT9g0/ULxalmZI7Ma5+iaKZy1BD5
   g==;
X-IronPort-AV: E=Sophos;i="5.85,372,1624291200"; 
   d="scan'208";a="286692160"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 14 Oct 2021 18:48:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAIoo2gZpLfjZ55mKErjqVKDVwNrL+Kn1BTGgcD3G8Lyl0KhxMsgQeyV9QaBXrtSSjg/9rL++W/od+YEzb6qSUzsmFwDKJsQncusI4KZNN2rXWWoGGJ24a9k/08sofkwhqY2hNKuUKPfPyucqNYM+vrY7kn4Q8A+vlgI//y1NXVlBbcA4z/Eo6bum4NZjgHUHdyoHMt8/q4nrhf9P4PB7UUn6m6mTIO+F956UXzHyldYZgAepOSqFAWMgTBzAbFVGkwLUNxoPIJ0JXQwAcgiu5xtaltNrMlVQ1eZsa2DrPKIlLK+suloGrEKBvf3sVhzZJhL/brUhok/WP0emFnRSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/3tSxnX40q+fxa6LMJg6bKjZLU0+4ShWnbdARQrz1g=;
 b=dbJsUa6Syv5oCEkEe1spK/bDkFD4TMESLmtIFCYR9mUCa/B8OFvkV7IRmwv3LvthDOEk/l6oo7C88OiopqJ7e/vQCRXCGPy7Rr+Rg24SIvy5+QSkahBWP+7xvX317zPwlZYRYlw6iTvPUaYDdZIgzlYft4x2ezmvFY38I+Ci35u94RR/v1TmYaZcDtKWSq3IYoPddQ7hcXymTLirYiaqr97/GZBeIIC2Sn0WlnDYLz18swUrRUfG+WjyiPnIWobnWLwvtMKQyy7DkmbgZhrGlx35zRs4uxdw686Rx8qyyUeVPgn8KSJ9jHMfrdK5Yt3DhT+uX94HBbd5x9PleuKQwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/3tSxnX40q+fxa6LMJg6bKjZLU0+4ShWnbdARQrz1g=;
 b=XbirMv/Vh9M6AE/NIaXvGrJyg6okDBXASqRcYR6rNx8ah1bcaHWiCptKo1bkvnCF54FYl6CHGmbUgfGySLppL78oZaM4tHwP6Jhcr/Tit1Sn4BH5EEsUEL6l7XFcw6a8XUcren1PwhfooGM9PdJz3TTGFYIKejtoEt3YmFrL188=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6249.namprd04.prod.outlook.com (2603:10b6:5:127::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Thu, 14 Oct 2021 10:48:35 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 10:48:35 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
CC:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        jongmin jeong <jjmin.jeong@samsung.com>
Subject: RE: [PATCH v4 01/16] scsi: ufs: add quirk to handle broken UIC
 command
Thread-Topic: [PATCH v4 01/16] scsi: ufs: add quirk to handle broken UIC
 command
Thread-Index: AQHXu1MIGrHZKOUUzkeaWI/wLukhc6vSWxGg
Date:   Thu, 14 Oct 2021 10:48:35 +0000
Message-ID: <DM6PR04MB6575EF14B8F32CC844C83810FCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081133epcas2p3ca173361432aabe2ce9b923465a08570@epcas2p3.samsung.com>
 <20211007080934.108804-2-chanho61.park@samsung.com>
In-Reply-To: <20211007080934.108804-2-chanho61.park@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19e61cb1-bfe3-4f5d-7edd-08d98f002c67
x-ms-traffictypediagnostic: DM6PR04MB6249:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM6PR04MB62495871B1EFD77EAB05EC79FCB89@DM6PR04MB6249.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q5DfXOWESxWxcBbR2FQajPmhahei/x9lfDz/P0pXVxTu21xQScHyYhsYpKZ8omd+nB1SkRZ3eDu5SxZaHpEmNukaU4sDxCkjwMtz+uH7C0JlrTRq47gOIuX5s98hUZxZrv4R9Z/a+E3zQ87ddsSI0Z3Bm4eUKwx/DZHkSj9fqWT6DvkX92XpEy15d1U6gUvcEApV+zhiDp2vcazMz4bQXYf4oFFSWjdxXTbI7U5Kf/N3mOUqQXgp9XNkxfXTXAClqQclvYeNng1umUm8LHHyUT26FzwmyEOoOAj8G6jV9V9qHQ4dw97znpRiXZslRQoO7z3vmwpFWEGEG64NoGwNq/alBu3PvO9DbM6/UusqD3lG3/d9UvNnF9x443IiagbGKM1D3EbpPkaAyocnvvSryCxTASX9ImJ3mgoIM5zbhBK3nGrPDJgFPGpWtb8FZiFnFvslF92MLZ09A7r6G4LulaTLzp80Up6uVv1HMjCOpjDx3vtwPP/43oNt8uQ0ji225HS8BVCkszUJQcisynJ2mceKpPFPZlt7/undrX+ieOf3lnDXGhYLNd2xSqeqo8UTr2RzrmaKd1OfADK/QJjY1z8Nao6xXTaduPhIUu8YBWggfCIINWdR9byaPIbCWzYeRAeMfCr1sLOO4VSo7NmlVOZNMu0IhF45v7dOjTKru38QG7Gn82nld5hhqgdOFSRYVUX1+PeufyMt0JGa9dBqrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82960400001)(86362001)(33656002)(186003)(8936002)(8676002)(110136005)(71200400001)(54906003)(5660300002)(2906002)(6506007)(508600001)(122000001)(52536014)(38100700002)(66446008)(76116006)(4326008)(26005)(7416002)(38070700005)(9686003)(66946007)(55016002)(83380400001)(7696005)(66476007)(66556008)(316002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFJOT1NNa0poeGx1ZnJYZFNhT1R2eTJ4QVhtdXBqTDhVaythMGRENE0xRjVG?=
 =?utf-8?B?NGVWb1ExTURGamJYb2lkQzlNelZUYjV5Y2ZsSU1qK2xxeDFUUENpYjJNUXl3?=
 =?utf-8?B?dmhrUXRMT3hFam5LY0JGaUxCNVFEZnlpTjJEb1MwcnlDZmplZUp1dHFST1V2?=
 =?utf-8?B?TDJMWTJzUmdwZ0IvWEN5SnVYN3hVTHM5T3ZuTzlrWmJ0ZlBIeGIxWGh3YTdY?=
 =?utf-8?B?MXJkWFR5cnFPVUtEQlllT0JDN0dFOVRCblk1KzFDS1BSdU1wWUhsUkZZNkdU?=
 =?utf-8?B?UVRPK2gyeHhYc2pMYmhnazVGR1BQNFNXeUUzY3pZR2dsY1QxODl5Y2U5VlNj?=
 =?utf-8?B?dHhCdU9SMUVueWNDaTZqQmxLNng5NlBWdlNqTnNRQTJobjZMTDBiQnRGZ3NV?=
 =?utf-8?B?UHBwdFlHVVUyNHROQ0NweTlWd3RlOC9NdDJOcmRUVXVaZ2tLcUFIeXZCb1ZQ?=
 =?utf-8?B?Sm1obkxpSUNpOHhEL084b015NlRPSTJkTVM3bkxCZ2Y2QmlUWXpLM2pJK2F1?=
 =?utf-8?B?MjRsdFJERzhrMjVPWXFWVlI0elMyWHdIN0M2WHV5aEFIdFkzaDBlT0lVNi9m?=
 =?utf-8?B?NGxzVEh6WmJSUmVlN1U5SjNkMjA3QmsvMlp3Q3lyOW5lVVBmUXp5a2dWWklq?=
 =?utf-8?B?dE42TUNyK2JrdGNsdURWQkxvam9jMFQ3cFVxV2IzSysvR1JnQXZsT0ZpNUhY?=
 =?utf-8?B?cTNUUEc4OUh4S3VqUVFFV1ZkQWNYdkVwaURFL0ZwYWdNM2Z2MzY5K2w4OVBN?=
 =?utf-8?B?dmJCRVplNEhTNFpTZ01TN09kZkNzQnpQM2J1ZGdYTmpvaXovaXdMTC8wWXVX?=
 =?utf-8?B?MkdNR1BvbWNYMWRBY1V3aFJta2J0UmpzQkN4OEdraWM1amNoVEdneEcyWDVE?=
 =?utf-8?B?ZHRFT0JXV0tNY3I5TldrUnFQbTRDbmw1dWxWRVF1ZkFzclJJZkdLRlhNQjBZ?=
 =?utf-8?B?Q0haSlZqeEQxS09MMkpLNWxsa3dJSmZNWDFQaDZYSlFMaHVZU2JkY0tZSlJV?=
 =?utf-8?B?MmpuQmF0NEFXTXpWTlpBZ21keG1Ocm9CM2ZPSVZyWUVEaXJYV2luSE9ieE5p?=
 =?utf-8?B?NTdxbll0ZDBsbXpNZ1pCY3RLWHpLVitBeHdiaEZpY1VSdFBNV2pEVGlpTGJC?=
 =?utf-8?B?VmZyZmFvZGNEdmJlSTRBYWhPWmZURWNsZ1d0T1lWR0xJUDAwRUszYWlDYkE4?=
 =?utf-8?B?cnIrM1Q1eGZiMytLYU1CN2g4ZkxYOUtXYU10UE1ZMW1XczRhMHBBR1QxUHBF?=
 =?utf-8?B?T09HWm9SSWVCT0Vzd2pnVUpWb1NNbDFxYW5xYitEQVhYc1lyaVZJMHR2VEFB?=
 =?utf-8?B?UHgrSnREdWpVNFJ0TFRqaWlvSDA5Qkd5bnlrdFRCZ0c0d2NRbWRxTUlSQWti?=
 =?utf-8?B?bmFNaERIdmNwRkdOQUdJcWV1b0VNYWNhcHN4NmNLV2tNMGFrZ0ovbDdMbjk2?=
 =?utf-8?B?UEpyTDdzUzRTNmhGQlZodmJzVGxOZmJyUUtoVGhpN3JEYWR2bjZHVnJHRGIy?=
 =?utf-8?B?MGZxQUlLRWRNMk9iV09vMUN1L0hGZGwvL2pLOS9nanNObTVKbUNvVXUvdWZW?=
 =?utf-8?B?NUJHenpyWVI5QVhVZHprYzNuOS9RbjYrYnNuaTRKVDk4bysvR1Z3VjdEZ25z?=
 =?utf-8?B?aUtneVZUUWFSVVd1dzVSRDhZQnNQOHIwVi8rRUpXNExjbERGU2ZDS2ExVWtn?=
 =?utf-8?B?VmdiOFgwTm9SbmZIMENLSS9QbFlpTzJXNTAxQnNLTHhNaC9GYTd2N2trdk1i?=
 =?utf-8?Q?xqvGI7kJJXshcdLG0GV5qMa4GUpehnGel6IuDOC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e61cb1-bfe3-4f5d-7edd-08d98f002c67
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 10:48:35.6596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sUyiKv4AQny7k2k9tKrimy/EqSETJqHjPXemoAsRpTyFR4dAvhqdpMKjTZJz7ymTHsyPm4Gtn2q7wTf/1Q6fyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6249
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gRnJvbTogam9uZ21pbiBqZW9uZyA8amptaW4uamVvbmdAc2Ftc3VuZy5jb20+DQo+IA0K
PiBzYW1zdW5nIEV4eW5vc0F1dG85IFNvQyBoYXMgdHdvIHR5cGVzIG9mIGhvc3QgY29udHJvbGxl
ciBpbnRlcmZhY2UgdG8gc3VwcG9ydA0KPiB0aGUgdmlydHVhbGl6YXRpb24gb2YgVUZTIERldmlj
ZS4NCj4gT25lIGlzIHRoZSBwaHlzaWNhbCBob3N0KFBIKSB0aGF0IHRoZSBzYW1lIGFzIGNvbnZl
bnRhaW9uYWwgVUZTSENJLCBhbmQgdGhlDQo+IG90aGVyIGlzIHRoZSB2aXJ0dWFsIGhvc3QoVkgp
IHRoYXQgc3VwcG9ydCBkYXRhIHRyYW5zZmVyIGZ1bmN0aW9uIG9ubHkuDQo+IA0KPiBJbiB0aGlz
IHN0cnVjdHVyZSwgdGhlIHZpcnR1YWwgaG9zdCBkb2VzIG5vdCBzdXBwb3J0IFVJQyBjb21tYW5k
Lg0KPiBUbyBzdXBwb3J0IHRoaXMsIHdlIGFkZCB0aGUgcXVpcmsgYW5kIHJldHVybiAwIHdoZW4g
dGhlIFVJQyBjb21tYW5kIHNlbmQNCj4gZnVuY3Rpb24gaXMgY2FsbGVkLg0KPiANCj4gQ2M6IEFs
aW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT4NCj4gQ2M6IEphbWVzIEUuSi4gQm90
dG9tbGV5IDxqZWpiQGxpbnV4LmlibS5jb20+DQo+IENjOiBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1h
cnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPg0KPiBDYzogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNz
Y2hlQGFjbS5vcmc+DQo+IFJldmlld2VkLWJ5OiBBbGltIEFraHRhciA8YWxpbS5ha2h0YXJAc2Ft
c3VuZy5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IGpvbmdtaW4gamVvbmcgPGpqbWluLmplb25nQHNh
bXN1bmcuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaGFuaG8gUGFyayA8Y2hhbmhvNjEucGFya0Bz
YW1zdW5nLmNvbT4NCllvdSBmb3Jnb3QgdG8gc2V0IHRoaXMgcXVpcmsgLyBvcHQgZm9yIHVmcy1z
YW1zdW5nLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jIHwgMyArKysNCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCA2ICsrKysrKw0K
PiAgMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBpbmRl
eA0KPiAxODhkZTZmOTEwNTAuLjdjZjhlNjg4YWVjOCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IEBA
IC0yMzIyLDYgKzIzMjIsOSBAQCBpbnQgdWZzaGNkX3NlbmRfdWljX2NtZChzdHJ1Y3QgdWZzX2hi
YSAqaGJhLA0KPiBzdHJ1Y3QgdWljX2NvbW1hbmQgKnVpY19jbWQpDQo+ICAgICAgICAgaW50IHJl
dDsNCj4gICAgICAgICB1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiANCj4gKyAgICAgICBpZiAoaGJh
LT5xdWlya3MgJiBVRlNIQ0RfUVVJUktfQlJPS0VOX1VJQ19DTUQpDQo+ICsgICAgICAgICAgICAg
ICByZXR1cm4gMDsNCj4gKw0KPiAgICAgICAgIHVmc2hjZF9ob2xkKGhiYSwgZmFsc2UpOw0KPiAg
ICAgICAgIG11dGV4X2xvY2soJmhiYS0+dWljX2NtZF9tdXRleCk7DQo+ICAgICAgICAgdWZzaGNk
X2FkZF9kZWxheV9iZWZvcmVfZG1lX2NtZChoYmEpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggaW5kZXgNCj4gZjBk
YTVkM2RiMWZhLi41ZDQ4NWQ2NTU5MWYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmgNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KPiBAQCAtNTg4LDYg
KzU4OCwxMiBAQCBlbnVtIHVmc2hjZF9xdWlya3Mgew0KPiAgICAgICAgICAqIFRoaXMgcXVpcmsg
YWxsb3dzIG9ubHkgc2cgZW50cmllcyBhbGlnbmVkIHdpdGggcGFnZSBzaXplLg0KPiAgICAgICAg
ICAqLw0KPiAgICAgICAgIFVGU0hDRF9RVUlSS19BTElHTl9TR19XSVRIX1BBR0VfU0laRSAgICAg
ICAgICAgID0gMSA8PCAxNCwNCj4gKw0KPiArICAgICAgIC8qDQo+ICsgICAgICAgICogVGhpcyBx
dWlyayBuZWVkcyB0byBiZSBlbmFibGVkIGlmIHRoZSBob3N0IGNvbnRyb2xsZXIgZG9lcyBub3QN
Cj4gKyAgICAgICAgKiBzdXBwb3J0IFVJQyBjb21tYW5kDQo+ICsgICAgICAgICovDQo+ICsgICAg
ICAgVUZTSENEX1FVSVJLX0JST0tFTl9VSUNfQ01EICAgICAgICAgICAgICAgICAgICAgPSAxIDw8
IDE1LA0KPiAgfTsNCj4gDQo+ICBlbnVtIHVmc2hjZF9jYXBzIHsNCj4gLS0NCj4gMi4zMy4wDQoN
Cg==
