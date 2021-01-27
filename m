Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35AAC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 07:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7627720734
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 07:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhA0HTv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 02:19:51 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:13190 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbhA0HLq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 02:11:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611732462; x=1643268462;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=kdBjmaxjZgwTOU4adNy+u4h/kZpxHmb+z8Y/mX27FKo=;
  b=h6W8GKSoTLhOJOaxRtBK4OAYYtfGXh1Y12hUTIaOH2jBNsfKqobT5mL8
   8BFm1IUi86ouRO44GBqBBp7YUqseB5siIpE4bftvq4iEOSTtZ3nh7uLEC
   vLVuiavqAXxzxXftPycsjBTC9IutJ03hx8dwkMmtI1gKCgHjLZGG4+PjH
   9bjanRoTGARft6OhmxbE+aPPSBORhFZs9V5j7RJz5GuyBzkeVJigkVZAe
   dbHnmqlTeueg+w57nc1nplhlE7xhX4b4Zx64BLArJxwN8FPso2Ag5Xkh3
   UYYazT3bapdzbzEKHCggeHoDm+17EIf343mywCo2WUcM+Wg/z59krTLgp
   g==;
IronPort-SDR: QjQ9IfgjymhaTCXevvNObfZukMEBFwwUkhocwtOmwQxRrcQQfHVuG8duFAWRbgIcyT34jZFgO8
 LnBHnzh1/9FE3XEdxANrukeaYOYkIg3aJsRLKSlNLl2Nz48BIwOTQrSzz68fhqrH8iRKeVtKWt
 v9PI5H7tN6AX4KNy6cdBn4TMxSzoOB9VaeUN+iImrYxWVgnxmASo7GKB2xoBabQfP/jRtFVSe+
 nogihI7rpU7KTmmHL9oBXl8hQJUeqoy4aiQhV1nIoWTlcpNZ7XYhBs4CP87F1b9GC5WXw8/VhN
 w9E=
X-IronPort-AV: E=Sophos;i="5.79,378,1602518400"; 
   d="scan'208";a="262445704"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 15:25:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agCnBCRjoK87Vy/wDPufEaZ1wHj5He6yfTji3otDUPjA01uc0JBW/qAh8YI8uHsfq+fwKTfy/j6dmVzLiXVfAYXEUcIFmmd0NsKpOoF5+z9pSeMb3Vuf+FbryNCv/rmV3lYIn6UTuOeMxypXAGJcLyXiSqxIRemNCdhdEAokivqi0BZkbjsJJrA0m1zTKDZ9srW+ZNNPCZ2Pl/b3piuqiVIWs0koFygP+Z7AFEJTf2NjHLqYod3LGjXIsTwwMZQjSSLoVRE6HBaNSk3k8AOVoTIGJRCgPDxA3ALQunkjcNu3TzyhtX4dHYcIQcEGW5qKx7xlOX/huPQshAoLiSF2vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdBjmaxjZgwTOU4adNy+u4h/kZpxHmb+z8Y/mX27FKo=;
 b=lPYEZCXLaF1l9xY1pjhQTgvou3SA2r/5Cxyt/ljEXTqrwWVHKzB/NxnVUYoyuEZykM2JH0nwy01alW5U5VzVusqfDtZonY9+AgWDjHXDySUjdHUWd18E2z57SSQgUsQEEc6+kQAtW4uXkHs+vKGiijd43bYIQ7LlK0lt3Et8mxZO2IKhy/LJhGqeevqNFZtLb8WpaO6uxmlRiRYs+mtiJbHpkofjQOIDs6Ck6No0kCcAwKzRVgVPUvFegatuIJawZ2PeTT8CDTB53PVHTnivckJASGctkw+wqYn0D3jtpyIEO7atJ4WwImPzcom5yXTK3jnoQT4qXrygt9EI1HfuyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdBjmaxjZgwTOU4adNy+u4h/kZpxHmb+z8Y/mX27FKo=;
 b=LsEw5Fosez8HCVTYH/6FwcSmJir29W3jrJgIVI0t7nlsDU1iyqPPIOrVXCtocLNAoXTPFa9UpS+6dX9WAjyaJFx59SHFTXZGVO3pKhjeLHwl2DzQEy1PqQAUdJ9k0S1/ze6EhXywb6oyHlMYPqe1pJ7awZttHaA76iwBDtwgvwY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0410.namprd04.prod.outlook.com (2603:10b6:3:a9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.15; Wed, 27 Jan 2021 07:10:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 07:10:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
Subject: RE: [PATCH v9 2/2] ufs: exynos: introduce command history
Thread-Topic: [PATCH v9 2/2] ufs: exynos: introduce command history
Thread-Index: AQHW9F+EManj37UtOUW/+Yt6GN1Y06o7Dhcg
Date:   Wed, 27 Jan 2021 07:10:34 +0000
Message-ID: <DM6PR04MB657514A4F86D353163E50C86FCBB9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <cover.1611718633.git.kwmad.kim@samsung.com>
        <CGME20210127034959epcas2p418a2278db8441cab04bca42dde177fc7@epcas2p4.samsung.com>
 <dad0e24545595504bf075ab737256b7a41e3c1ec.1611718633.git.kwmad.kim@samsung.com>
In-Reply-To: <dad0e24545595504bf075ab737256b7a41e3c1ec.1611718633.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fcaa8e11-c9ea-4c58-0a64-08d8c292a40f
x-ms-traffictypediagnostic: DM5PR04MB0410:
x-microsoft-antispam-prvs: <DM5PR04MB04101438FCEFA0CF2C8C4FB5FCBB9@DM5PR04MB0410.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FIVEudo1rqYLRNmUjwv/f8mPcgJDDWQMOa6N+Rqt5Uwd5miJf1peEe/dWkt+VjBx6A2KyWFbq+VCe9HAU+NSP5zzPQsEwcRTrxVSuWafFOQ7GhqC15x+vYNE2rM9cQoLdCApng0xmAMduUv+uShcwHENv0iSSgUY8L4JyDPBYf9Z7gxc3yt813wqpA5ZyQ0rtutS8t9oFAYdwV+Oy860wYTFm/ql5kScNHau3uYZmfVA27uz6OEyXA25bD9jqADhwyAVryLKCBnfP/PlObN/m1KKvIZFnxHF2waw/ThpedSwvKE/Jp7Rt2+C6Qu6d5U9AgkIWptMEa/GYtaZ2PJan0hch0JgBWZ21eUtuoLlV1A1x9B3vGeC38Nn+9rLnKM4fY17ytRciMxdkMhDN2qvihx8ggkyyzfe70yR6tdCY/J8v0KkfwfCx6yKa5aG8OC4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(6506007)(316002)(86362001)(8936002)(66946007)(4744005)(64756008)(2906002)(478600001)(186003)(26005)(76116006)(66446008)(66476007)(66556008)(7416002)(8676002)(52536014)(9686003)(5660300002)(921005)(55016002)(71200400001)(7696005)(110136005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aGVSbDhTY2RURS9Da3A3Z0JYdkkrSFcwdytGRWtJVWZDZEpXamtOTlQ0ejhN?=
 =?utf-8?B?SHhNa1pRWmoySUx4VjVlYzVzbnkyWSs5ajhLRWVIRHpScW50dGZzaXZzTjh4?=
 =?utf-8?B?cDVjbU9mTXg4cy9RTTR4VGw2VVdRU0NpMm9ZTmdramZFSEMvSmY3WHRqVWJF?=
 =?utf-8?B?bDhTV1dwL0lFbUExNmYxVXRTVnozT1gvaTJkVUVvZzRCMEx4TWVYbFdOZWNz?=
 =?utf-8?B?NkpJWEJuczZIOTFqVnpQbEhLdnlNRWRLbHF6ZmJTOGhEczZvOSt3dTJKQWJL?=
 =?utf-8?B?VHc0RkdHVEhJL0F3eVpTV01kbUtqZjRKNll5a0JlOTE2S0ZEbGtFNnhVcThD?=
 =?utf-8?B?R2FkTzB5VTE4T0tJdmJva0NIZjJ4QUpLYzROcFo0b2Z6UmswUUZjRDZqWEhM?=
 =?utf-8?B?MGJFYmZJZG5CUEsrUlR2REZKeW85WjhoN0VMcFo1b09ScW9VeEVaL256Qzhn?=
 =?utf-8?B?UWUyaDZUWDhVcy8vY1A1SEYzajlsREp6ZHNPWWRIY08xbGxSbTRyL1RhZXpx?=
 =?utf-8?B?MTU4ajlVM2NWc1VaZC8xaDRMbmJNVngzZlpZZlp1K3FVVXRmWDhjVEFqRVpi?=
 =?utf-8?B?TTUwQWJMT0ZycUdkdXBvbUNTY3JMSkVqZ3R4dHdvemhQSEpORUpJVk1La2FI?=
 =?utf-8?B?aE9DK1huKzdaNFdJVytFbVd3SkdNcjhJWUc1RXBla2lpTXVwVUdLdVZRVVpk?=
 =?utf-8?B?T0lLOXh1SzFvRXJtNkh3aUpIakJEdFdHU1JxOGRHZ0JQRXVFdHd0cCt1MTBj?=
 =?utf-8?B?U2pjWUhoTTZONEVmTWY0VXdTbDZYTXZkOGhqU0ZXc0t0L0FqQlRoS2VtQ21s?=
 =?utf-8?B?b0V1WnlXRnBBZDYvV2tBOWRPSEd4bVJSa1F4N1BDZGVZVW9ub0g0MllBTXdw?=
 =?utf-8?B?cHQzNXhwZWYvTDlUbC9KTURIZ00vVlFwQ096NmszMVNvc0g3cUdkYUhXSjNY?=
 =?utf-8?B?ZEpPL20yYVNHSThFZS8zSStaejVxSTVWajNrVmg0VnlyRy9wdzIxamZ4MDFK?=
 =?utf-8?B?Y3lONC9aNCtOM3BCUEhzaS9xYUk5d0R1aXFRWEFURXNBVVVsYmMzWHQwbE5P?=
 =?utf-8?B?cDNSR1pWblhqMVhId1BQNVpsQUl3MmxoWjhISWE4YTJ4aThENHVzVHlaSm1T?=
 =?utf-8?B?aUZ6TlVmWjdGcjBqN3A4dDJDN3dYb2pYVzFWQ3A0dmdNR0JnaTlDdnVxd205?=
 =?utf-8?B?VSszN0YvTGNCUVcyejBsdnZ5REpQaWU0QzVqNVZ6OC9POVVsRzh0a2pXQU1F?=
 =?utf-8?B?RTJXbHM2a29lNkQvOElQMHRxTnhLeFdsVVRCNEdyUXIwczhqMjFRTW9oVWVx?=
 =?utf-8?B?LzdNTVQ5ZzNIemErUjZnRWFEeWpPaUtURnl4TDlsWGIyamR3NFBWWkc1Zzgx?=
 =?utf-8?B?T0dWS1E5L2tRK3dPSWFBOXV2VTUwbWRxSEFwOUM5cURXRVpFR0ZqbVA4dWZM?=
 =?utf-8?Q?PHj6nDYT?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcaa8e11-c9ea-4c58-0a64-08d8c292a40f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 07:10:34.5561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iIHCUojfpDD31oK0g37RGywg4grFgpdH+jCKhAEKwjhS1oQ3QCcsLG2K0p+cucI4+XjlX5JUO3mpZCZv70NgXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0410
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBUaGlzIHBhdGNoIGluY2x1ZGVzIGZ1bmN0aW9ucyB0byByZWNvcmQNCj4gY29udGV4dHMg
b2YgaW5jb21pbmcgY29tbWFuZHMgaW4gYSBjaXJjdWxhciBxdWV1ZS4NCj4gdWZzaGNkLmMgaGFz
IGFscmVhZHkgc29tZSBmdW5jdGlvbiB0cmFjZXIgY2FsbHMgdG8gZ2V0DQo+IGNvbW1hbmQgaGlz
dG9yeS4gSG93ZXZlciBmdHJhY2Ugd291bGQgYmUgcG9pbnRsZXNzDQo+IHdoZW4gc3lzdGVtIGRp
ZXMgYmVmb3JlIHlvdSBnZXQgdGhlIGluZm9ybWF0aW9uLA0KPiBzdWNoIGFzIHBhbmljIGNhc2Vz
LiBUaGlzIHBhdGNoIGltcGxlbWVudHMgY2FsbGJhY2tzDQo+IGNvbXBsX3hmZXJfcmVxIHRvIHN0
b3JlIElPIGNvbnRleHRzIGF0IGNvbXBsZXRpb24gdGltZXMuDQo+IA0KPiBXaGVuIHlvdSB0dXJu
IG9uIENPTkZJR19TQ1NJX1VGU19FWFlOT1NfREJHLA0KPiB0aGUgZHJpdmVyIGNvbGxlY3RzIHRo
ZSBpbmZvcm1hdGlvbiBmcm9tIGluY29taW5nIGNvbW1hbmRzDQo+IGluIHRoZSBjaXJjdWxhciBx
dWV1ZS4NCj4gDQo+IEkgYWxzbyBpbXBsZW1lbnRlZCBkYmdfcmVnaXN0ZXJfZHVtcCBjYWxsYmFj
ayB0byBwcmludA0KPiBjb21tYW5kIGhpc3RvcnkgZm9yIGFibm9ybWFsIGNhc2VzLiBDdXJyZW50
eSwgSSBqdXN0IGFkZA0KPiBjb21tYW5kIGhpc3RvcnkgcHJpbnQgYW5kIHlvdSBjYW4gYWRkIHZh
cmlvdXMgdmVuZG9yIHJlZ2lvbnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8
a3dtYWQua2ltQHNhbXN1bmcuY29tPg0KUmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFs
dG1hbkB3ZGMuY29tPg0K
