Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B68C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C0526128E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhKKHx6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 02:53:58 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:37249 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhKKHx5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 02:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636617068; x=1668153068;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s/5xLIRB1OYofIdcg/fux+xH0RdEOfxKsahe0f9wfkE=;
  b=BQl31XaIPl+oVYZRH6nVoT0cmfiF66qvZKo+TnoRJCfrR/k6wGNPSQ0P
   7eNZ2fPJs9mXJHwNJom7Fx4ZU2SPHpYUBm2pXQLNltK8UkM1CdbWSWIXu
   Eglyi3v2q+glkoN3OfFDVhMzxVrOIOvz3vTmtEObMo/h3I8VTUxTLP/DE
   yC+14bd0yr4m7sQvEhfROMngVYMc280P7HnLpXoPBosV5hdOGWbdPzlQ0
   nbJu0T2RuoHx+J2y7lfYIz04DJnNHPlLPItCOlp0Do54ZPrOORO+QrQ9a
   wWck0fMLvL7yBgmXwimKUlIDtI8TudZjO4ARDIZbBwsHb1zG1I7gFbZXH
   g==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="289252204"
Received: from mail-bn1nam07lp2043.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.43])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 15:51:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ea7NbkM5euuEKdSPbxs+Sa9j+KuDm9gQcmgxPxM0UnynuZS/bgv2Zglw0F8imauJjnF+LfvvGGu8RAI3FjrzWDlGn0STCbLn7XdJBT8rxFLqZTynP2809kOd3gbJ7YlIM0tG2aNvqxV6fb0el22mSyBBrn4p4P2uXyV9VmEEXBdqpgwsE24lJhuTztjn5AnDQYfl+2AQc/ukhj66nhJ36wolEmf87B+fDlX9PPHTp7U4VHgF9KZgyktjGgV7nBhyPk9b3S/LdMewlNe1I+JQa4rqfwKKh1GEYlW6TTF91/uhsJKfuK07vZU+9fOU5jeIU5Jin4d9H/oSLQK7zCuyGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/5xLIRB1OYofIdcg/fux+xH0RdEOfxKsahe0f9wfkE=;
 b=cNIq4qQn/bVecNZNzNUemLz/wBCig44JC22p1xi5HB0Vtz3rt6NmgcHt4Dq7pN7piccMWBUy4WRnAUk1jl3m8uKmfr6UOhvz//Dole/q41uRhA9j+QuAtjrhgWRe2coG1ERWtM4UjZSte2OBOQwugB8JWIj/XxDpD720eg98GoaJQTFKvG2jaZY1IKSc5y1xGyf1ny2dvGe6hQ6RCHRVmonlx76zCz26QhrCW82bloT2BWlKt1HRxErBbmtMhtLaAQHduGfogdsriodLyl7RgKdcFSeJbZSvuyFejaPS1jn/yU/TNT0m1OVRmpJ+nIOOOaAAqMEXJyJbQJpiMameIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/5xLIRB1OYofIdcg/fux+xH0RdEOfxKsahe0f9wfkE=;
 b=xElyEQKdxDInpOm2zYUFWAvLXTjiLis86Kt+zRUUzQsKbgbqz2Olty3vzzFV82o5fmKwPtjCK2B7IMySC/ZNrCEfeiBNpjymA9vBYlS+vwl8+qa7g8YZdYpqfsqZFIYmhja8mfjOUo9JJlXj3UxHBWKw5fk0NV1SRvsEYEwG51s=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4025.namprd04.prod.outlook.com (2603:10b6:5:b0::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.13; Thu, 11 Nov 2021 07:51:05 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4690.019; Thu, 11 Nov 2021
 07:51:05 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
Subject: RE: [PATCH 10/11] scsi: ufs: Optimize the command queueing code
Thread-Topic: [PATCH 10/11] scsi: ufs: Optimize the command queueing code
Thread-Index: AQHX1cxS80yLRi1k/k67W7Jn0WpZ5av8Z4YAgAGOhTA=
Date:   Thu, 11 Nov 2021 07:51:05 +0000
Message-ID: <DM6PR04MB6575CCBC5DEB1946CBF0A9E5FC949@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-11-bvanassche@acm.org>
 <bd2cdc84-3776-a08c-dc41-272719097c83@intel.com>
In-Reply-To: <bd2cdc84-3776-a08c-dc41-272719097c83@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51c3e603-d010-4adc-09ea-08d9a4e80412
x-ms-traffictypediagnostic: DM6PR04MB4025:
x-microsoft-antispam-prvs: <DM6PR04MB4025FA9532B4ED23117D8CADFC949@DM6PR04MB4025.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OPtC+02tOWKgbNvqY6kC5KiJQ2ptSPNJ/xrBVg9zJprycodjmkLksVfYmRxxxLmCnHTp2DZHdKz9T44qDMvfhGtLDq71nHT6qHrY+pqF4QeKbQrFehoKFhR2HKfR57NeMQGMZ+exuwmdBrsmMKy6nKfrutnpMXP0dfmEdMiHilS64hG473U4BN1FlFEXmLZuMnD1TwoDV3T/8HIABdQsaIggCYzsRyubjcvu1LU/Hyy9WqeubnzyADrwqQKSDL+G3mdsGH2pxF5CEwAEResQqrYU3/wZws3Y3NehBO5PFWp15QQw/lOstYxOodUh9dBmO9E9PQ3GAv0wAbNwg1Lsh1xV4dwXN5AB5cRWYO5mnFHlCzXp/aLVLnhvc4AcS1ClqaxygYIW2FuL8h3W+2VuSABnHsF86N1I+D/9lMAPlWcp+TmnDoLqtCSjF+rnq3lnxpxHG/QtaqFgwYqhwi9n+/K3sKXLBJao6mf07BNZlhLm1j7MwaHhD9TT5hldFlh8TKtGFGiHcfP48m7LoyyaUgypVSvOMIV/Im0F60Pj1Zh/m2a5h650rAEbHM655rVt1MxLlm/O7L0bGXKATw6hqBHJ4U/strUVr47eRgjn10oLblD8fm70vfBo5L7Wf/QdLs6tNzuwHWdD3Ev88Zn2p6cZwPVrmbpDFSGE+O7/fvLVaiHP+9SdXRBqpRJXDCgOmKXg4Wc72hQinUqjpRO3DA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(83380400001)(64756008)(508600001)(6506007)(8676002)(38070700005)(26005)(53546011)(66446008)(71200400001)(110136005)(7416002)(66946007)(122000001)(38100700002)(316002)(52536014)(4326008)(7696005)(9686003)(66476007)(33656002)(54906003)(2906002)(66556008)(82960400001)(8936002)(186003)(76116006)(55016002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZURWZjN1R2lzbGNZeGNXejg1UElWZjlwVkdqVUdSVU95L3VwbVJJS2xWY2Rw?=
 =?utf-8?B?bS9rYWxCdXpySEN0VTFyR0JaME1DQVU0b01NK0dteWJvdzNRWEtjU3ZnalJ5?=
 =?utf-8?B?RklVemxuUjc2ek56aUNwL1ZWTTBpVWt0bTBxdTAyMklxbzF0QktZTFREbnpK?=
 =?utf-8?B?SHdQNi9QNy9ndTBZeG0zOWZzY3laZjYzaWNySEgyVHNKemVLalg3bk9tWk5G?=
 =?utf-8?B?YkF0cGdQNmFIbFdKT2JLMk1vZG9WS0IxL0w2ZWFJRGcrdzF1bEN4WDFWbmky?=
 =?utf-8?B?TktsYThxQ1l6enQ5QVoyYkVHcHdnMEFFY3NpbmhuQk5RU052S0tTVkU4eWhY?=
 =?utf-8?B?VzdQVk5Dd2NPWkVZUWRwbnJKYmtrZC9ybzlMOUIyWmg2ZUFBMzl6SnE0cHRI?=
 =?utf-8?B?NTczOHhadzU0enlsMkh5cVIySTlReEowVjVIYWFSNDdjRTF6RTc3bm5sc1I0?=
 =?utf-8?B?ZlVHUk0vMzJrZWs4cHE0ZHpaMjR0aXRRYVlRWnlENHBwdktkVUxWRFlkMWVR?=
 =?utf-8?B?cXE3d25mWnU0dE5ERnVETjFWdVJuaHF5b0NRSEhSNi9jbDh2cEp0SXZLd3cz?=
 =?utf-8?B?THZvT25mNlZzUjBmMU93YXUyd1B6Uk15Mk1EZFFQZ1NZdmRmdEVNN2Q1UElC?=
 =?utf-8?B?VXVXL3kxT05GVFM4SS9EcS92Uk10MWk1Q0twcElvVjFKYVFZR0hHVTl1NmND?=
 =?utf-8?B?NVZvM1JKZW5IZnduTXJJRmdPTXpPbHhLNTVwSVd1eTRydWVHUHVFTUFDbmFz?=
 =?utf-8?B?L3diVkxWZUU5clMvOGJxdVZrTUxDVFJzOXhuMU96MjZZMTFTWk1aa0ZreWds?=
 =?utf-8?B?WXk4VUpPd0hLY1djcEVvRll5KzgzMXNWdDJPbGZHdXhySi9NNS9MamZrcmNi?=
 =?utf-8?B?KzI0SjN5cHg0YjhJa1Z4WVFvR2l1TkY4S1cyQUhQVHl2VzZxeFBhZlRtcUtz?=
 =?utf-8?B?TjZ0ZFBxTXUyeUxSamFMUDF6L0lmbGhkV2M2VzljaWhwdVpnZnprWDJ0Uld4?=
 =?utf-8?B?T0lDUkpyU2xQT3g2KzVVVFJIVXBFM0c3dVdFR2NiNlRvQnFxT29wQm9rOTdO?=
 =?utf-8?B?UTlnazJmODI0czFockxjMFd2a3pHem9WTHVsSkNlZHM1Z2V5RmEzcTRvMWhU?=
 =?utf-8?B?c085bFJSWEdTREhjMXNxalprVHdhbTRpQ1E1UnpKT09Wb3BKWUpOR2I1dkFa?=
 =?utf-8?B?cUk1b282SmtqNDZDczVEWHB1cVVOQ0lSZ3huaEZ6Rjgwc2NtYVdFT1MyWWFj?=
 =?utf-8?B?TURaTW1IS24zSFVlV0VhY0p4WE9lRHI3ZXgwWjJSbU9LNTUrakQrMk51NXZo?=
 =?utf-8?B?QnkybXpWVWtGd2xrSnFRNHdEWU55TnZSTkgwRktvclpBVUhXVjBtNDl1WDBz?=
 =?utf-8?B?NS9BTWFFaFFsN2dxbUVKZFdhMU5iQUdLNCtmZnpOVGZPUDBCWC8zdTRNMkcw?=
 =?utf-8?B?NkRmSzQ3OVNqekZKeTBseW5UMVh0RWh2dkNyT2NMTEl3STFta3dsQ3hRT1Qy?=
 =?utf-8?B?N01zL0M4RkJBTzA1MTdLU1RtZGpZVWRpamFkK1lSbkFhRG1FaFhHU2d2NUps?=
 =?utf-8?B?aTRzVDhFbHUzR05Za2laQk5LUkZJTEU4NEJDb1cvMmtvV2lwMmVuWEtNR0s4?=
 =?utf-8?B?aklnb05QV3UyOTdFQlczTFd4NjJpVy9uMWlkNUlWWXM3QVU5NWt4NmZKK0RP?=
 =?utf-8?B?Y1JWWHBRRGZVVm1Wa1pIMUFUZmRYZVRhYmpldFI0QXZRTjB5RU9rS0Uwb3Uz?=
 =?utf-8?B?MEErWnl4SXdiSGFKeTJwY3BjaWhBdXBMMk53dGEralR2SUM2alJVZTlWSHU0?=
 =?utf-8?B?b1NtbGs3Nm5uTWhqOUlZU0Q4UFJNcFBncy9hZ3VhTXJtTDZ2amJjZ0YxRnBU?=
 =?utf-8?B?OEllVVluaDhnaW9RRUljM0VNMnNNbktmUWNRTTZvdXBTNm1BS1IrdlUwYXJX?=
 =?utf-8?B?NkRYUHp2a1lMMHdrUDl3TG1zcFNLSzlYZ25wM3dsYjdIZ0ljRGRuRFc0M1Az?=
 =?utf-8?B?UnFnWXA0ZlJRMXFjcVcvVVgveW1jaHVuaVdLd0FLaGh2Sk9mV2NBTVhwdmNM?=
 =?utf-8?B?Q083QkpnQXF2SHl5MityZU1jOVFoK3dqdmdjb1BTaUNVYmZObzk4c0FqTmlB?=
 =?utf-8?B?M2NIMXN4ZUo5NWpEWFhSdnJpVlo3S2sxbVA5OHFZZVZWMm5POVphNTd6R290?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c3e603-d010-4adc-09ea-08d9a4e80412
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 07:51:05.5881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VcnuZZX8hddrTeWEHVvqJeHG2QDdz4Hg8A2n8HkOSyLbVn4UlnWTEMCHlWJ1ZYUfBibOqMaJFIhPIhPTxscWPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiAxMC8xMS8yMDIxIDAyOjQ0LCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gUmVtb3Zl
IHRoZSBjbG9jayBzY2FsaW5nIGxvY2sgZnJvbSB1ZnNoY2RfcXVldWVjb21tYW5kKCkgc2luY2Ug
aXQgaXMgYQ0KPiA+IHBlcmZvcm1hbmNlIGJvdHRsZW5lY2suIEFzIHJlcXVlc3RlZCBieSBBc3V0
b3NoIERhcywgY2hhbmdlIHRoZQ0KPiA+IGJlaGF2aW9yIG9mIHVmc2hjZF9jbG9ja19zY2FsaW5n
X3ByZXBhcmUoKSBmcm9tIHdhaXRpbmcgdW50aWwgYWxsDQo+ID4gcGVuZGluZyBjb21tYW5kcyBo
YXZlIGZpbmlzaGVkIGludG8gcXVpZXNjaW5nIHJlcXVlc3QgcXVldWVzLiBJbnNlcnQgYQ0KPiA+
IHJjdV9yZWFkX2xvY2soKSAvIHJjdV9yZWFkX3VubG9jaygpIHBhaXIgaW4gdWZzaGNkX3F1ZXVl
Y29tbWFuZCgpIGFuZA0KPiA+IGFsc28gaW4gX191ZnNoY2RfaXNzdWVfdG1fY21kKCkuIFVzZSBz
eW5jaHJvbml6ZV9yY3VfZXhwZWRpdGVkKCkgdG8NCj4gPiB3YWl0IGZvciBvbmdvaW5nIGNvbW1h
bmQgYW5kIFRNRiBxdWV1ZWluZy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFz
c2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jIHwgMTIxICsrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+
ID4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCAgIDEgKw0KPiA+ICAyIGZpbGVzIGNoYW5n
ZWQsIDQyIGluc2VydGlvbnMoKyksIDgwIGRlbGV0aW9ucygtKQ0KPiA+DQo+IA0KPiA8U05JUD4N
Cj4gDQo+ID4gQEAgLTI2OTgsOCArMjY1MywxMSBAQCBzdGF0aWMgaW50IHVmc2hjZF9xdWV1ZWNv
bW1hbmQoc3RydWN0IFNjc2lfSG9zdA0KPiA+ICpob3N0LCBzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQp
DQo+ID4NCj4gPiAgICAgICBXQVJOX09OQ0UodGFnIDwgMCwgIkludmFsaWQgdGFnICVkXG4iLCB0
YWcpOw0KPiA+DQo+ID4gLSAgICAgaWYgKCFkb3duX3JlYWRfdHJ5bG9jaygmaGJhLT5jbGtfc2Nh
bGluZ19sb2NrKSkNCj4gPiAtICAgICAgICAgICAgIHJldHVybiBTQ1NJX01MUVVFVUVfSE9TVF9C
VVNZOw0KPiA+ICsgICAgIC8qDQo+ID4gKyAgICAgICogQWxsb3dzIHVmc2hjZF9jbG9ja19zY2Fs
aW5nX3ByZXBhcmUoKSBhbmQgYWxzbyB0aGUgVUZTIGVycm9yIGhhbmRsZXINCj4gPiArICAgICAg
KiB0byB3YWl0IGZvciBwcmlvciB1ZnNoY2RfcXVldWVjb21tYW5kKCkgY2FsbHMuDQo+ID4gKyAg
ICAgICovDQo+ID4gKyAgICAgcmN1X3JlYWRfbG9jaygpOw0KPiANCj4gVGhlIGltcHJvdmVtZW50
IHRvIGZsdXNoL2RyYWluIHVmc2hjZF9xdWV1ZWNvbW1hbmQoKSB2aWEgUkNVIHNob3VsZCBiZSBh
DQo+IHNlcGFyYXRlIHBhdGNoIGJlY2F1c2UgaXQgaXMgbm90IGRlcGVuZGVudCBvbiB0aGUgb3Ro
ZXIgY2hhbmdlcy4NCkFjayBvbiB0aGF0Lg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IDxTTklQ
Pg0K
