Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90451C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 05:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237713AbiDCGBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 02:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiDCGBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 02:01:17 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE8E25E90
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 22:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648965564; x=1680501564;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qXFJbXcQYkkKEm2EJ8GHJe9KOlhkIy2dRV/LSkvi1jw=;
  b=haQOdGYeL9ePU80L9N4n5dutKc6KXFfLf3bjoKFjwo/jmYFoQNKMotTE
   ljAhJbR1p5fweIisx1mELIZizdgq0ODVc79DO85AHBREkU//Rp8IyytlF
   3SGOKpv5OwJraSG9S3QsalWzAJIPaY849m8W+gxiy3hP9FVPZqFZXl9Ae
   koS/cK+s5OQo6K4XnTo2tQtweHZjHiGdFBxc0Bur0qkbxqUmI0k5jIoYp
   OotDCdvV9rItS7u40/H6L0s6NCzMiXkSI5gqrme/Fq9otqn3nfCvqjXJ5
   xniu9I3YMw0paEJwV8TfpmzxqOHOWo8/1NM4MjJe/8Y20ApzpC4nyVPNr
   g==;
X-IronPort-AV: E=Sophos;i="5.90,231,1643644800"; 
   d="scan'208";a="308903001"
Received: from mail-bn8nam08lp2047.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.47])
  by ob1.hgst.iphmx.com with ESMTP; 03 Apr 2022 13:59:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eq6sBeXYD4/59PSDnfY1gP7aEl3TcZk9sodVMVz8s5Rb1ULqNQ8TB+4TSVcSVQ3+ZVcjZp2WsF+xuW23eMqz8An99QagrG2p1BUgSUDg6nYE5/V2DaYRhOzGlK+AUnls+C4Dr7WisjFrmKmm3NyWZeeVwLOZGVLBjqYqjxB89lNteLywrlGyi5DmsV2hzdlOhRcAmZpcX79Wtum4fACGjOCwYzZx1tFmWyhyPnNQRLavk+9romvGZRfn1JtSWhteIXfhOVm1yMi3i0MLyYfAUV0O4Pt77Z8Ksed1zSqys8Ni53SN26kQr8IgdKqsxMtfK+xneXuo+zzXLLNGiHLl6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXFJbXcQYkkKEm2EJ8GHJe9KOlhkIy2dRV/LSkvi1jw=;
 b=RllCypSE45zc8Gbl8wOHmhe9ftMRS4hHmvW3PK2jIvAjUneXBJbLwgEjmrobQ2eo1qSF1ojmqZYIKWNnbBTLy6nAvzcmhcgkXDgiSH06MIycRm8bataSuOfVR3cfE6GpqN5Fkv07wpUh9IFLG84HdrMrmZC8CQVDuFhpykXerCzIVNyFXWMOBWRfE64FYUloUTPi0umKRXSGmvOhH3zEGoz+kOpD8b4FCuG/qMp8ApvTKzUDCW0nDz38CDKXf+Bg1RW3+FczOTOpe61swjFXXz5CTIh4x1+XjB4E9XRjkNpZSl8PsbCMp8YBTtKhGE3jx1Y9SKyS1wJtTkDlQKtHQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXFJbXcQYkkKEm2EJ8GHJe9KOlhkIy2dRV/LSkvi1jw=;
 b=yvWXZF1EpxfxfCqlwGGSrIesKep5jNdNCXjOnd07l/ovtnQpjqdvIRRf1omBpupy2twFPyjiacb1lbQ8Ioh6lNkMpoGsKZVdsvtIMG0yRUF+CKXdcwImErstG2GhqGZ4u5YpNT6fDBQHzu9qu3Ei5LEGcIKYVdp4HpIQvjsx6uc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BYAPR04MB5767.namprd04.prod.outlook.com (2603:10b6:a03:10e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.30; Sun, 3 Apr
 2022 05:59:19 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Sun, 3 Apr 2022
 05:59:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>, Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 00/29] UFS patches for kernel v5.19
Thread-Topic: [PATCH 00/29] UFS patches for kernel v5.19
Thread-Index: AQHYRU+H41//UYnc20Oyf3i/tnvMPazazDEAgABOSICAApkHwA==
Date:   Sun, 3 Apr 2022 05:59:19 +0000
Message-ID: <DM6PR04MB6575DBC3CFAD57F5AA19DCF8FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <60dc8a92c7eda8f190a8a6123bc927e8403bdbb1.camel@gmail.com>
 <eee8d304-aacd-9116-9e2d-92e2e3682b5b@acm.org>
In-Reply-To: <eee8d304-aacd-9116-9e2d-92e2e3682b5b@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07b54ad8-4184-4c58-dbdd-08da15371820
x-ms-traffictypediagnostic: BYAPR04MB5767:EE_
x-microsoft-antispam-prvs: <BYAPR04MB576770D5E42D74428B5C381DFCE29@BYAPR04MB5767.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EFHRL07J+wjuvz2Fe8kHVx7hh9lFitvKITCGf4JuIi/qqjI8r5X0SyuAc31d29C451GkKLsG0QfzKmFaeOmX75yisRr7qR8asNQlwZjP7sT8Msc0kZQ5VoZ/2OkulZlSbFkM/YfVJrLS5JDBdHbPH3FpJ7MG0u4/Oah7hYBdkq24B5Kt+SUZyDgrcaN8QHhaO5PbcZC4mAVRp4dtPtl544VZQeo0RebH/NYxZe9A5//sQbiHM81jgp4IYjHUU+cDZW3FYP8mi5Zu6wqyJnKEx5aCaQ3iK2wtOed++TYgD55rE5BLmUcW8eIOVOkrtJDLiQqnwQPxv+OMSmke3HQ+UuUh0s0aftqbC36olNItcc/9iLTZEW1Ka+iy+m6V5VJYAcbzAdC1jbcEq+EzZbgiWdkIRfHj8fr62IqBh7YlntoE4ugF9d8y6FFefMKXAlBvVQxNbfOjphH9HbWP8Lu9W4/2lVmRoj9NEcsEA4o7lxS8Kv25hAUcpnpk0f4g9+K1jWtcMTlplTif7evBQl7EhrXAYLhUy/f/qTnQ2GGdoNzX7lsJ9u3qwzKVglfieWkOA2o0tycjMbPCvyqntukHrl3DG/nLEP/C6+rNt14lpzHBzp6yCpxeza6x/foXR+kzIxZfOHDbUxuEcRD2OxhVC0T04dTGeVTB10Rt3LbVWWj5xutu5//Ks2+H930BSXfyRzfhjbzodvUWMq+Gyw3hYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(83380400001)(2906002)(9686003)(186003)(26005)(122000001)(38100700002)(82960400001)(38070700005)(86362001)(71200400001)(5660300002)(76116006)(55016003)(33656002)(4326008)(8676002)(316002)(52536014)(8936002)(64756008)(4744005)(6506007)(7696005)(54906003)(66476007)(110136005)(66946007)(508600001)(66556008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjFYYWtFMlBpdWtmL0FPR0pBdzFxblFGdHYxOWhMZ1lQQ3NMUGxSNm9tMVp5?=
 =?utf-8?B?N1F1S0l2eWw3VVpqbEJZeUFCZ21IeUh2cERab3JjTFlWZkNydi9QMWdIQWRC?=
 =?utf-8?B?L0c0eHlpNnQ2TEcvRFp2a1ZFam0xRlhmeUxEb1pZaG5Sei95V1VmY3Z2MktK?=
 =?utf-8?B?aDVMZWIxZHp5cEhGdkZOTUtGZ2E0RzVIVVdwcUhycGtyaGdlY0duRTNRVXV0?=
 =?utf-8?B?MXdHRWxoREFJVC9MN1hxb2ZoY1dIdkdxNE45WE1LMmtCSEdVZFNFbGVzcS9N?=
 =?utf-8?B?d0V6WVMzRGxWOUpjN29VSTArNTFNOTJRckNOYWwxZFVzRzRSSWxVL2NrNWYr?=
 =?utf-8?B?NTZpdjR2Q1FJRTZSbERqcE1LRFVINGJ2ZTBuRW9wSzQyc0FIUGdKK2ZWSHNh?=
 =?utf-8?B?bCtJUHJ6QmF0MXBQdWxkM2tpd0pEaVJiK3JUVXlDa3d6Y3FLODhJVUJtakhi?=
 =?utf-8?B?OVFBRHJwQ3lNZXhEYm1hQW5MRHZBMFZpdTI3bnN6Z1FuYnhRT1RqbUZhYUE0?=
 =?utf-8?B?NXZDbUdQdCsxVysyU084bStoMXg3cDJEL29MckF2VnFiQWFFUkhTekVpbEtQ?=
 =?utf-8?B?MkdxOUEvYUlTOTk5VUsxRi9LQmxMeldrSlkxd0F2d2VQa3dnR1J2OC9xK1h2?=
 =?utf-8?B?bHFtUXp1ME53OXI3aVpsNXBSWjRKemJLbHQwbi9JbzNMQU9wTnd6Qmg0TnB0?=
 =?utf-8?B?MklIbCt2dUNXTkVzV0lVSDgzcmdsVmpZdGhJK2hocnFHZC9BMnZVQ01QeEJN?=
 =?utf-8?B?ekx0Q2NOUUdHbzRDMDhHTkVLT0pKM2VQOWpsSmlYS1NZck1udGZLSHVQMlAv?=
 =?utf-8?B?ZVRmc29vUGtDbHRJM1hrS285RHltUnhzT1VYam8rcHpJMmdyUWxFRUU1ckFv?=
 =?utf-8?B?eWtUWGpGWlRIbmd4TjJTUFRwQUFyVlg2UUxIYmg5M3hDNUlKSW9UMlpsYzY2?=
 =?utf-8?B?azY5OE85VEF6eVcrOUlnQlQ3Z3hBRnYrVUZNUEpCNjNsRC9jaXI2T3dOWU5r?=
 =?utf-8?B?bFFaY28rRHdJMXNvZ0ZzM1dYVlZaeU5GY2s4K2wvRnZMUlFCMUt0aEE3SHR6?=
 =?utf-8?B?T2c3dkZIdHVydFJObTBGa1VrZ1pKNFhCRlZVY3ZRMWlSck9JeHA5OGZUSFd5?=
 =?utf-8?B?eERkQkFveS9TR05neHBPUTc5ZlJacVlIOTRBNU1UQjE1VHBNS3J4MTRaUXcz?=
 =?utf-8?B?UHVlQkJzQ3Rsa3dRbTM4MWRPWjBtOEdjTVVDVzduZEl0b2xNdUFpc3VSVUh1?=
 =?utf-8?B?eW9uZm5wNGRzUnZCRktEMjUzVW9ubFF3RFY3YWhMdllPL1BXYjFqK3h5UlRh?=
 =?utf-8?B?K0c1Rk1HY2UxZFd5TURGU0hJcllsTzBaNTJrbUhqMVBIanpvUnhmZXJ3aERM?=
 =?utf-8?B?SUpMRTZMVDBIOE1na0hyZFAxZEZoeXZubjNhZ2kzVGxUaE1vS0NUa3FENHQ3?=
 =?utf-8?B?U2d3VDkrWUhmY2JiTVJIQ1hmcnF3Rm5SUjZVRXp1SVJpVGN0Y0pPdHN4MzRQ?=
 =?utf-8?B?TWdvUVRWclhhSGw5clY3dUNkK0JxL3FzNlhWODcxYmFaOHNsSkFqak96cTUx?=
 =?utf-8?B?akFnMGZtMW5ENmQ3eWlrMDdML002aWN3Lzl5bUE0TFdlQmp5ekhyTXd6UURz?=
 =?utf-8?B?cVh2dFg3Y2Y3andmOW1jcGtPM1k2OUFVWEU3ZDFXZDdOd09yN1VLekNNck8v?=
 =?utf-8?B?NkFhV0U1VkRMZ0ZEV25WVWxvZEwzMjA3cDRlZzFRQnBEaldHWkpuOW9PSVdi?=
 =?utf-8?B?WGlvSm1JZE9zNGJMTkhiOFlWQjZXcUhBUk5IY3gwWldlTmExMGJ4K3hrOGhZ?=
 =?utf-8?B?R0RZTTJDWFpCT1B6ZlJ2NGhsdWVtbm15aG92WG03eHR3MjVXYjJHdlk1dENh?=
 =?utf-8?B?dTBWMkNtdUY4TWQzSlFHR3p5dUlmV2l0dGJEVTRVMXRINGFUZEFxMGE4VzlG?=
 =?utf-8?B?dUJUSGFNSHd5QkpndkhVMS9GcjZGbUo1SWpMcksyb0pSaGZZS3QxNm9mSEpQ?=
 =?utf-8?B?NzhKNkREMk1MVm9NV2EzUDFiTW9GNXVCaktGWHlWUjhMOStDajNzdnVEamwy?=
 =?utf-8?B?enVnaXFlc09Hbng0R09zQXRUaXZNb1F1ME1IejFXNlJUS3ZHSW14N3JJcWM4?=
 =?utf-8?B?ZHNteFF2NmNXTjI2T0ZFVTkzaUMyaDc4dTVINVRkMGlWY1AxTE16L2ZkSjNB?=
 =?utf-8?B?L3huWlJKWFE3ZmdqRHhxQmU4YSt0WlJQVHVZY0pnUjdZQ3BueXVBZzhWSEEx?=
 =?utf-8?B?WGIrYnVEaUxGZVpTcm4xbGNUZHRqS1A5UHJxUFdxYUdxdHFmMks1SW55dFdO?=
 =?utf-8?B?Um5KWDlEWm03eG1wMUtscGpqQVQ1Q3lEMHdVeWpkUk5oZHJIaXF3QT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b54ad8-4184-4c58-dbdd-08da15371820
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2022 05:59:19.7756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: orQDvkjupLTzeJ9NRii8kqZSF0pDqgplkEDXswUP4SY1bVy4A/4xERI0XNyPtguuZCIiX2DmA5NdMlLgupF76g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5767
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiA0LzEvMjIgMDI6MzIsIEJlYW4gSHVvIHdyb3RlOg0KPiA+IEFncmVlIHRoYXQgdGhlIGN1
cnJlbnQgVUZTIGRyaXZlciBpcyBtZXNzeSwgYnV0IEkgZG9uJ3QgdGhpbmsgdGhlcmUNCj4gPiB3
YXMgc3VjaCBhIGJpZyBzdHJ1Y3R1cmFsIGNoYW5nZSBiZWZvcmUgVUZTIDQuMCB3YXMgcmVsZWFz
ZWQsDQo+ID4gZXNwZWNpYWxseSB0aGUgZGVzaWduIG9mIHRoZSBVRlMgQ1FFIGRyaXZlci4gSWYg
eW91IGFscmVhZHkgaGF2ZSBhDQo+ID4gcGxhbiBmb3IgQ1FFLCBpdCdzIGJlc3QgdG8gc3RhdGUg
aXQgaW4gdGhlIHBhdGNoLiBJZiB5b3UgaGF2ZSBtYWRlDQo+ID4gc3VjaCBhIGJpZyBjaGFuZ2Ug
aW4gYW4gZW52aXJvbm1lbnQgdGhhdCBpcyBub3cgdmVyeSBzdGFibGUsIGRvIHdlDQo+ID4gaGF2
ZSB0byBtYWtlIGNoYW5nZXMgYWZ0ZXIgVUZTIDQuMD8gPw0KPiANCj4gSGkgQmVhbiwNCj4gDQo+
IEFsdGhvdWdoIHRoaXMgcGF0Y2ggc2VyaWVzIHdpbGwgbWFrZSBpdCBlYXNpZXIgdG8gYWRkIFVG
U0hDSSA0LjAgc3VwcG9ydCwgSSB0aGluaw0KPiB0aGF0IFVGU0hDSSA0LjAgc3VwcG9ydCBjYW4g
YWxzbyBiZSBhZGRlZCB3aXRob3V0IHRoaXMgcGF0Y2ggc2VyaWVzLg0KQWxzbywgVUZTNC4wIGFu
ZCBpdHMgVUZTSENJNC4wIGNvbXBhbmlvbiBhcmUgZXhwZWN0ZWQgdG8gYmUgcHVibGlzaGVkIGFy
b3VuZCBlbmQgb2YgTWF5LCByaWdodD8NCkkgZG91YnQgaWYgd2UnbGwgaGF2ZSBwbGF0Zm9ybXMg
dG8gdGVzdCB0aG9zZSBjaGFuZ2VzIHdpdGhpbiB0aGUgVjUuMTksIG9yIGV2ZW4gVjUuMjAgdGlt
ZWZyYW1lLg0KU28gTUNRIHNob3VsZCBub3QgY29uZmxpY3Qgd2l0aCB0aG9zZSwgbW9zdGx5IHN0
cnVjdHVyYWwsIGNsZWFudXBzLg0KDQpUaGFua3MsDQpBdnJpIA0K
