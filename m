Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078B2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 10:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbiCBKpu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 05:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiCBKps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 05:45:48 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424F3B54E4
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 02:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646217903; x=1677753903;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=A/Wijo2ctIkmbWcFXPf/Kn67c6T+gg2oJiNr0isZK6E=;
  b=rJQjDUFTzgTOU3HKsff4wDF8sPHcpkuyAuVKOpCS5Vg7Ej3lPgk2xHNr
   aigtbRuxLG5LIul9Oy1whK/D5oyPCCfms9xu/J3qQStxL03s7Gwh4zedD
   lxtkZhobQmtovSyd8kHCKtYLfFLZ28o9w9QU3erhwdsdc0Jb0L2dy+uaG
   a5olOzecZze4GCKerJGbkSJg6OTZ7LB0Jqx3giT6pLGCRAqmsCdKIqA4f
   pmfvvZzNabbTpzujkpVPrYbUE4BHghtICEYFIvBVHinjZGJtZDTYDazP4
   Rpxc5DF64ysmJXAF5uhBxmyD+dRCR+r0Zd+xKobcrg++fQBzOJ+2PRcbk
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,148,1643644800"; 
   d="scan'208";a="306187515"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2022 18:45:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzfuIu/vRAJaeGY/aeBiHWslgpeobUee3TF22sOgU3ZU1+ZXSJgqZA6Jj+wizBGHe7WUJL8Me+qx+UWWpUZbWUojwEDwNY69syakEUMabxIXFf8RRMYg0/9+h+25Ady+FgjGQW01iaWrl8fDhjx8DNR3hrJD8A0hhApgiQ+2awK4MqWyeEBne7uB8sz0zhFlIOu5JqNldzQ5I8P3+wwP+KdoES9mcSWrQgu2MldGz0IHLXFj86VnWfA4viaBewLoUTcDNm7a6aU77fbPtvvQVetKfnhPpO2D2QJU+DkDomRabVgUguJIfErHYQWJhOAABqfat2dktCAWjw/fXZdjGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A/Wijo2ctIkmbWcFXPf/Kn67c6T+gg2oJiNr0isZK6E=;
 b=ZHmnUKCsC0QfftZsxY5JVUt0iSGZx2BzzCOZtp+5kcYIzmBUieaKhy3auOh12QDY5z0qsioHdNoelyZ+S9za0sYejpvQuqDfJwZPcyESnIX1zoNlsgs79rXMZOr0/hsG6jbS2B88TShMpCOWeoZj+Hlj5k63hAs7Hh20RD/ZI4D9igDRLkY6CiLinp2FbidYRcFwUcpE403/1wZwWkGgf7alUxu/mRtbDIYxL8f19tvTNNNo3kFOPU/70bXPdiOQo66SvkT0L1FaAWCrC7LYVR43TrHq9Z4BGE7PrsPV/qdKLRRVDfRi6KztZLk4ZJPDBBtY7quQcqISig4gzo4kmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/Wijo2ctIkmbWcFXPf/Kn67c6T+gg2oJiNr0isZK6E=;
 b=rjeD6jmb6k+WwX+hr3WTOWi7r2gvjXHsKfLI0P25Gb4WaMZx2fbxvAfXTHOmfgSzHzYMYgX3lvMeskZJDgnfEh2I0/xSHld9ZSqXZlNk+CQBulIxjm5FVClwb6IJRO3l3/WeGOkp0I3pWVNQFdnSBjG1UEyYF4O4cX+mOYIFiKo=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by SA0PR04MB7419.namprd04.prod.outlook.com (2603:10b6:806:e3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 10:45:01 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::c8f4:8499:a5fc:1835]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::c8f4:8499:a5fc:1835%3]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 10:45:01 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
Thread-Topic: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
Thread-Index: AQHYLfd9I2WMHWchR0iihFVe5OI2Bqyr6QaA
Date:   Wed, 2 Mar 2022 10:45:01 +0000
Message-ID: <fa37071c-3e68-9435-5f8b-6f3920e59ae1@wdc.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-13-martin.petersen@oracle.com>
In-Reply-To: <20220302053559.32147-13-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f762349-0f90-4176-6bc5-08d9fc39b435
x-ms-traffictypediagnostic: SA0PR04MB7419:EE_
x-microsoft-antispam-prvs: <SA0PR04MB7419D272593AB0AD4E0452CCE7039@SA0PR04MB7419.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IT5VA+UenzRKfirUzJ9EPc6BCA6Ueh1h63PL/VcPI79b7+gjoCcj1hOuY/+HMz1lJ659vt9gfo2+HHVT4T955bwDg7JHHN5wiGDn6w9iMhqvmauY9SF+c4pAI7uIXrDwW6vnhwu87qT/L5Vr93wQkBWjds+K0FaHxDMgwMc6/MZg1/9QQFoGTM2o+ML8qsuony6w39er2qb00cimnMh2Bu5Jp5zk2MmQoDqmEWxRKq6Bi+pFL15DihXPKLcVZ9QmwomAhjLYkosuq356jmy19s2TPbZs1i+A7F0hni7K2Fwo4Qa6VHn9Xo/IfiGvRW3aiB4l/89/s2+QAD4eAyc6uyqD6T56gqOVTzXKzu/vm+YkEmpL0l5Z7UsV/z32koHzf/luC8piH+LIz12KOdI/HKNNQnSq7OiSmztrMtHgV9WmKQviZASLjIbV9VjAzMjYw+xI4Nrf6MvWMCgfJqM49/Ywsl12xMom8oG9zmBbrdwnndOvWZ1iSN/wjfhZ7dR7UBLWl0PvGErFLyWahNIj2wkWf+GTEsk4qYRIya4pebTtXL/sBDmALKZl13fJl6zLkHFhHpKMWELANVeDlhJe8QTvWbscxlGBL1lnWcuX32V+G/v91GlbWLb/GJjto4EohW5zhAg+LtEZtNh+CwBPo8qIY6AfDYwcFdeMobejiNldBdLWRVYlq849hLiwW8uI3XkTFrbYZpjKCLmJAf5NiU9IyqWv6Kp3zZA/vyhRgPK079ycOo5Czz62tayGQHfgB01yrIMAFL857WR6cSJS5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(6512007)(5660300002)(316002)(38070700005)(31696002)(8936002)(8676002)(66476007)(66556008)(76116006)(66946007)(64756008)(2616005)(91956017)(2906002)(186003)(26005)(66446008)(53546011)(36756003)(82960400001)(6506007)(6486002)(83380400001)(71200400001)(508600001)(122000001)(110136005)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVdZblpLMVFJRjAvbEJHSS8wNkhid2RHZk8rSkJzUi90b1pwM2c1cUUyTEpT?=
 =?utf-8?B?LzJ4dDhiclJhQ1Q1S3Uxdi9CRS8zOUFaMDBWcCs1MERRWlY4MTNONGtUTGs5?=
 =?utf-8?B?QnZlQkQ0anNpTXpMeWovWW95ZkVrTjJFOStob3EzYktMUDRsR2l3bDkzbkFY?=
 =?utf-8?B?NFQ3TzNVWmhnbHpsbFRoZ2JhUEZDNmhxYzFLM1JGVXhETmxIbitjL0grd2ds?=
 =?utf-8?B?VkYzZlVuV2NUOExDMmwwREM5UVBqQlR2bWJPdWtwTVRaRmFpd2RZRGdKb3dC?=
 =?utf-8?B?ZnFuUC85VnVBZ1JoUjd4WXhsem0wcjU1TzhUdHJkSEpiM29HVXZ3enBnYkRa?=
 =?utf-8?B?aDhqVnJCbHZJRWgrNWpIdzNPMWgrN2xxK2VtWUp3a0ljZXdvUFV5WDhzb3hj?=
 =?utf-8?B?akxsbmMvWFJJdEdPeFZHVTYwaHNFQ2VGL2dWNkR4eU56ZXVRSStONVVjd2lP?=
 =?utf-8?B?QmhRRXFFVlgrcUdQRldoK0phUkJEL3FxdHd4RDRPM3BUc3hnUFNEemU1WHB6?=
 =?utf-8?B?VUYxOHc1TVNrNGlucitkQ0hxZU5CRm0yNU93ajhjUDQrSmgzUlJhQ0FsQzAv?=
 =?utf-8?B?b2Q4ZXBWcnQyazA0TnpiNmhHMHc5Q2JXZlVtcHJZTkwxRmROaGd4eDZWSGdv?=
 =?utf-8?B?bXNnRWxGN09nV016VHc2cmppbW1NVHhJTlRJS0RHN0NUU2Vna0NLQmpBbm1t?=
 =?utf-8?B?bFA3VHE3TDVQTkRrV1I0emp1bVA0SWV6SGRTV3JVNXNReSs2dXdONVJ3VDVz?=
 =?utf-8?B?ai9XeEVHNkpqYW8xcTVNc3hsVDNJalUyNThPTWxHWExMYlorUi9PUVdyNVNj?=
 =?utf-8?B?dmdhVFd0NjZHcnV6eTBFQWl1OXdCNkFjbHpDZzdRYUdadDZXYlVKK0RObnRV?=
 =?utf-8?B?bGZJTE5oOWRFQVNCcjdyMEhKTzUvc1dieG9PZFF4YTloUUo1MnhXeHNuUXZq?=
 =?utf-8?B?Kzdoc1oxOCtDbTNGY1FvcVM4RTc4RDlOanlqYnFXcmF4SkljbVNmUXRSdmRU?=
 =?utf-8?B?UHllb1NMNENpb3NDbDQ2QjJVbjNEZFNRU0pQRlhoejR5MWE5NGp0Vy9vU0F2?=
 =?utf-8?B?WE0wb25CYWZrZ1o0MHZJRHlKdGlsdEo4MW96aHdQY2hUODc3dEVaV1UyRU5T?=
 =?utf-8?B?TmRaSi9ac1BOb3B0NHlPekk0MGZ4NkdVOVBtamcySXMyc0h1OVA0eVEwOUdD?=
 =?utf-8?B?Z25MSEpucjNoMkw3b3QvNis0VUU2UjhhblJkaEF3cWVoeWJkU0NhYXQydFlS?=
 =?utf-8?B?T0FhK0NUNnpHUVpRVUdqYXVqSHZXRGZZejkwdkMrOE0reTArcDl1eURqQ2VW?=
 =?utf-8?B?WDY1Q0JJYU10Z0VBb0paWGRCOU5KckY2RkMzRzlKM3ZOU3pvTHVkOUZ0UWpW?=
 =?utf-8?B?ZFRkblNCVEQ4bkR3cFpONUtDWiswa2l4RmJzUTBFdTAvTGM1enY4TUtlMUxB?=
 =?utf-8?B?Q2l6ZWdINDlZWlJKZFg0RUxwZW50Z0FTU21uL1djR29qQytQVFh4RklkTnN1?=
 =?utf-8?B?UlVtcmhYRHZ2NVZiaWFHUHBhUmJmWDhhWk81MnFENXA0SitFRzNYS0t1eGho?=
 =?utf-8?B?elJKYXJKR2pBZVp3L3RNZnlVbkVRcElUSUpiVmRtRis0OHMxUDFmNkhwTmE3?=
 =?utf-8?B?dHI1UkRVb2tqN2oxZGx5QmN1SDRBajMyclI4MVhjZFdFN2JPdFlnNXJJQkJX?=
 =?utf-8?B?ZWkyNUI5bWYwUlg3di9sS25ieDI5MjhHL0hHS3lmbThmazl5SnAvU3EySnJN?=
 =?utf-8?B?NVVTQjlEV0tjbVRtamtCRnhGVmtNdjJRanRHaVNmYW0yNncxbHovcVRqWmVO?=
 =?utf-8?B?SXFqU29JYitLZGp5S0tRS0xYenJwTmtNUVV5WG4zUGt1Y0c2OVlGWFZ3cDFw?=
 =?utf-8?B?SjN0NWpzZGV2dVg5VklCWUVvZkpjc09LbmRuUjhRaGtKUXpHRFRaTVJHcmUx?=
 =?utf-8?B?K0htdlYxd3RuRHhuM1dYSDdLSmthSmZqTTVGQmZLRzd2MFFjSXNYM3lkMHVv?=
 =?utf-8?B?eUhsdERKVXc1UGVkcm5pblE2SXdvSHQvWmdHWEdQNmFzWG1OcWdsVXFWYlZZ?=
 =?utf-8?B?Uzc1c3pyNVVHY0xvNXZpNmExbmhDTnF1dkpScEpsUG1wbG5OcGk5b2NlY2hm?=
 =?utf-8?B?VGw4UkU4Y2plWlcyek9ZMlY1THVjWlN3cjllNy9XUzQ5UmhLakxLbGVnUThM?=
 =?utf-8?Q?u1FYSmF2UG0zfg4+eTYlaZw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA182E242282CE4F87FA6506733BD943@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f762349-0f90-4176-6bc5-08d9fc39b435
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 10:45:01.3559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q1WL5hB2+o5zwjuLqesdZ1torPIWX2YQQpK3MFvBZm7N8LE7LgRGBN5C9CrUrZRM4f4FjeHNmsmDGhyptmw3eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7419
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMjAyMi8wMy8wMiA3OjM1LCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3JvdGU6DQo+IEFzIHN1Y2gg
aXQgc2hvdWxkIGJlIGNhbGxlZCBpbnNpZGUgdGhlIHNjc2lfZGV2aWNlX3N1cHBvcnRzX3ZwZCgp
DQo+IGNvbmRpdGlvbmFsLg0KPiANCj4gQ2M6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2Fs
QHdkYy5jb20+DQo+IEZpeGVzOiBlODE1ZDM2NTQ4ZjAgKCJzY3NpOiBzZDogYWRkIGNvbmN1cnJl
bnQgcG9zaXRpb25pbmcgcmFuZ2VzIHN1cHBvcnQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4g
Sy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPg0KDQpJIHRob3VnaHQgdGhp
cyB3YXMgYWxyZWFkeSBxdWV1ZWQgOikNCg0KUmV2aWV3ZWQtYnk6IERhbWllbiBMZSBNb2FsIDxk
YW1pZW4ubGVtb2FsQG9wZW5zb3VyY2Uud2RjLmNvbT4NCg0KPiAtLS0NCj4gIGRyaXZlcnMvc2Nz
aS9zZC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NkLmMgYi9kcml2ZXJzL3Nj
c2kvc2QuYw0KPiBpbmRleCAyYzJlODY3Mzg1NzguLjlkNmIyMjA1MzM5ZCAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9zY3NpL3NkLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3NkLmMNCj4gQEAgLTMz
OTYsNiArMzM5Niw3IEBAIHN0YXRpYyBpbnQgc2RfcmV2YWxpZGF0ZV9kaXNrKHN0cnVjdCBnZW5k
aXNrICpkaXNrKQ0KPiAgCQkJc2RfcmVhZF9ibG9ja19saW1pdHMoc2RrcCk7DQo+ICAJCQlzZF9y
ZWFkX2Jsb2NrX2NoYXJhY3RlcmlzdGljcyhzZGtwKTsNCj4gIAkJCXNkX3piY19yZWFkX3pvbmVz
KHNka3AsIGJ1ZmZlcik7DQo+ICsJCQlzZF9yZWFkX2NwcihzZGtwKTsNCj4gIAkJfQ0KPiAgDQo+
ICAJCXNkX3ByaW50X2NhcGFjaXR5KHNka3AsIG9sZF9jYXBhY2l0eSk7DQo+IEBAIC0zNDA1LDcg
KzM0MDYsNiBAQCBzdGF0aWMgaW50IHNkX3JldmFsaWRhdGVfZGlzayhzdHJ1Y3QgZ2VuZGlzayAq
ZGlzaykNCj4gIAkJc2RfcmVhZF9hcHBfdGFnX293bihzZGtwLCBidWZmZXIpOw0KPiAgCQlzZF9y
ZWFkX3dyaXRlX3NhbWUoc2RrcCwgYnVmZmVyKTsNCj4gIAkJc2RfcmVhZF9zZWN1cml0eShzZGtw
LCBidWZmZXIpOw0KPiAtCQlzZF9yZWFkX2NwcihzZGtwKTsNCj4gIAkJc2RfY29uZmlnX3dyaXRl
X3NhbWUoc2RrcCk7DQo+ICAJCXNkX2NvbmZpZ19kaXNjYXJkKHNka3AsIFNEX0xCUF9ERUZBVUxU
KTsNCj4gIAkJc2RfY29uZmlnX3dyaXRlX3plcm9lcyhzZGtwLCBTRF9aRVJPX0RFRkFVTFQpOw0K
DQoNCi0tIA0KRGFtaWVuIExlIE1vYWwNCldlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaA==
