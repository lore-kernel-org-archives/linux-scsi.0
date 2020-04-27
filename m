Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C83C55199
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 06:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3901C2084D
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 06:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IpG24I6i";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dJuKZUlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgD0GNx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 02:13:53 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:28526 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgD0GNx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 02:13:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587968033; x=1619504033;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gCJucKLkE+kCqnzBLJLC7j0NdlXcGdgiTwWCcdwmFyM=;
  b=IpG24I6i6XsTNZ7yz9KrDg424fDyXOmrzK6rtAHnhcTF/WIH2qF12PiI
   3B1HHBmzsI9Q9Sbn7keaHaG8PMr5R6c2LqUPLvnz3oduK2G1j/KAq+rov
   cTil3Dx27wDvioIxA4VIjCFergYZ18gsYrgvo5n67mMxDORbIbB8bEQWf
   XUdRonEvEEmfWsZ0qWxcL1eyakb202+12JOkWjKTyQ1DtHIQzRxnNDPq2
   MhytraUW4smxxb0OmTWsAvNZs7OLngpVovxt0z10ZSeqjhpeg3Zj70FWA
   SrIlCYpDw5W6rZED1ZRqTMcpXvaiDH8e72TXS4poT1xtVHmwt8Z0QgPo6
   w==;
IronPort-SDR: /49SFahwS4Df5LHcS4JZrqdPtXSGlRVjikIvwc0gp+s9dYxY1g8cIQI/rajAXgwI1j8XJYveiH
 gXguV0elJf7YbjJwo42RPiximLZNBkOyAH5taC0YHR2OLYKjOl8qHXa1J2IcJR1MFzPx80VdZN
 Cg++op6II2O3jjX17Ng4HDqlmHJuIBTI+glWMXYoofPT5t+kjUEizePpD4DKa+WDRZZ42u0y/t
 +76nVAWb+c+MQUIznaaUKeciY1JD8HPZwZz3LzfKiRPiu3W7A7NFrVaSl3mck7xJBYWfwg5jd4
 ReE=
X-IronPort-AV: E=Sophos;i="5.73,323,1583164800"; 
   d="scan'208";a="136533221"
Received: from mail-sn1nam02lp2056.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.56])
  by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2020 14:13:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIy2tEoQL+XLmCb3JInvUzasfzKH2Y0nqHTouu+Aw1tTozMVc1+Ishmo4RI56NXM70mNHb1MDhX0Jnq36dq2wEtknJN42yzWN8feN2lVkZXzotj2tMgPO41Qxu7KJj78SGssk4ZWT9oss0VRPaYb2pvfb+B6g+YSd37+0l1ckBAzdNIxYKVIMsFu+Emilrvw0Pp3ydsEH9mtUKPISluYkPBL9K4cQPDTokxdQZhSkW84l3Z2hSmqe6VxCweiHdqJWpEuJ2TCw8yq6/UT2qAeGsFVDlbvTKighSkZwGH4r+tviAp4Wg8cwNegzkNVNPR8TuNRan2p3122WUnYIwOnkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCJucKLkE+kCqnzBLJLC7j0NdlXcGdgiTwWCcdwmFyM=;
 b=d8Zz7tc7zvT8wUXv11hD0ZWqWaW7+gvbZ74u8K+hwWU2OqMxjQ8dXeCfbnGtvkKX6M4PTCUvk0+fuNjgVhaLEsj30CF5sZKmsV0m8ab3LdXkY3YWL2BdIyNuj5zaVmFSYqFPyTrE8tlSMaYRK+5k0UyYBxi5pjEUaT23u4BLlYUj0chCJQ+I+3mC8SUUdZlmE631sExI6T1iV3rLut8nMq18RKHvI5ITexnl0eMXuBckQs5I4ZhfomRzNaETgZceOvYTUvdDZiCQ9bceFogr3s7lyooeiV1ZOHUbgKO9etY8Lh37m0EElzcIVvGawm9RtTVHKU/kd0aBdLcnHe2rFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCJucKLkE+kCqnzBLJLC7j0NdlXcGdgiTwWCcdwmFyM=;
 b=dJuKZUlx4M4Vyk/ijTj8rsy60ONUKBaGIoieEnWeD1MJaO4lvvDctN9R7FlFn0ePG9dKypo3KALK/9FYqjTuRuDVsr/c6CfXKFWqRCPdLITpGAuUeppi+DcEOw4uHfr6LC5SDwKMlESyvjlblKk3wanHs7G+Wn2axwIPQMMVBPI=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4192.namprd04.prod.outlook.com (2603:10b6:805:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 06:13:50 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2937.023; Mon, 27 Apr 2020
 06:13:50 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Topic: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Index: AQHWFC4dSn/DnOroKESaR41iHFfp4qiF2/SAgAK+MnCAAPi+kIAAmSYAgAJemjA=
Date:   Mon, 27 Apr 2020 06:13:50 +0000
Message-ID: <SN6PR04MB4640A33BBE0CD58107D7FC69FCAF0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
 <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
 <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
 <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
 <12e8ad61-caa4-3d28-c1d7-febe99a488fb@acm.org>
In-Reply-To: <12e8ad61-caa4-3d28-c1d7-febe99a488fb@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3fe3d171-3975-40e9-d218-08d7ea72274e
x-ms-traffictypediagnostic: SN6PR04MB4192:
x-microsoft-antispam-prvs: <SN6PR04MB4192CCD8510C05958BE0CEE5FCAF0@SN6PR04MB4192.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(9686003)(54906003)(66476007)(53546011)(8936002)(76116006)(6506007)(64756008)(66556008)(316002)(66446008)(7696005)(8676002)(110136005)(478600001)(55016002)(81156014)(33656002)(86362001)(5660300002)(26005)(2906002)(71200400001)(7416002)(66946007)(186003)(4326008)(52536014)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wx7uBC/2Qg65XA6v2PBe7c28ubm0CIqEEAVlwRMfHAApfch1SUy3laGXeCeGmajoObJPWbqvIz4zmGcXw6KDEb3ovmPnhGFNNu0tN94kGoVCrR5s7QtMyfB1z6MR9/53Jsa1zCO+P0/vPrcYjVhLKkzQdzMezns0AUNHQ/aXYVczKNjJrPS4r/bOpm/ya0Yd9Ca2fQQgtV6pLGXiqle/ye8ZCKHZRRFCYDBiIdjml2TJsov1QSoQ1KqZo2JXDau0dXxnNtUZwUCZr7MWQzIk6nFqZeHi4/QyH9QdWSdXCgQjaFmibufqRK8RRXdNQrx2VHjLFRr5b7kI3e7gzzAcptTVpjjhqjoBkFFREwexZGqXvvkR/3+lRmcFj7a4mcDvUfC/184RJMmALPHzJ8LGGpjsw3BXifdmK+B08EyYwaByWrz3jX+nCI86GN75FqyvRYZOhS9O6i6NQF7TEnggK8QItZ5+Qo5ISjBx5LT3zdo=
x-ms-exchange-antispam-messagedata: ab2P/OC/1CX1nUcerIMndMfKXTiKZa2faEkoofdByFDPYENHdwAbPHiRMXKlvRCg/LjPxw5e5Ilqq1YDW1/mOhoXZzHdjj3zNJD07n8izaz0jpGjVXNsZ0w7/cnnaMMzvRPLiy8wcICD/fd6lQ+tFm5OlhI2r/xNSrB5BkC94lLX0stpuUpr2oaPyTFq6rIxvEhlyzh5886BEycvkYqcZb6mts6QIsnbrBBm4euzhQBJbZdDLnG+ID/VZrHY9uZgbaj7zKRyWgMly3Q7+vKxJTULinfCiRbChqcRelM08elrhrb7WhtZ/7Xn6ejVRxdTNnzCzKaJFwPa6r6kY7mgbOgSqyHtkQNdc9hOMqOCQwGLWYx+qWyP+l44S7eUP5V8xHUdmJEH0dUZlLEZDzo/RAxalyqaHkD314hg8GDSSQxL9ws7bGpT0eJy29pMWPvh8xSaWOT9XfqlxHZBNeFGztK3V9z5VKLKYBjxkHop6bUIFM3kCLnhDNP4L6pnjHqCWysrLJs38HiSEGE3rRTEOUXm7oaEotEFUYf1nr9Pmpk3gSpytiU1EZCxloBZLrvsSTldnnfpDUJtzRXAaWzeWp2abNTj8H/DKK3tyj1qHgAN6B0STGz7L8fdY9oklm/krdc01i4kMAicAdaXN9LOVHro8PB21J+4FfTDR/B2k9fpk5xoHnv+m6RW/N5a4vgzTVO+Ngcm83kPeDpx8CqFLsTVyF257MRH9vP7+8ztddm1pidTwXbOI5VDNNepluOJ4Cur4Rd9h88VmiaX0bxVtmbCi+o+tqnE577o7lfisRE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe3d171-3975-40e9-d218-08d7ea72274e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 06:13:50.1393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D5xj3dKCUxZn9CdP1bHwvXRDDL6Igq+jp/kS23Za3wmagTGhMgquePNc5UHqPWbCMZbR5AWR8qOTsLZ8D0BaTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4192
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gMjAyMC0wNC0yNSAwMTo1OSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gT25lIGxh
c3Qgd29yZCBmb3IgdGhlIGNvbW11bml0eSBtZW1iZXJzIHRoYXQgYXJlIG5vdCBpbnRvIHVmcyBk
YXktdG8tDQo+IGRheToNCj4gPg0KPiA+IEhQQiBpbXBsZW1lbnRhdGlvbiBtYWRlIGl0cyBmaXJz
dCBwdWJsaWMgYXBwZWFyYW5jZSBhcm91bmQgMjAxOCBhcyBwYXJ0DQo+IG9mIEdvb2dsZSdzIFBp
eGVsMyBhbmQgc29tZSBWSVZPIG1vZGVscy4NCj4gPiBTaW5jZSB0aGVuLCBtb3JlIGFuZCBtb3Jl
IG1vYmlsZSBwbGF0Zm9ybXMgYXJlIHB1YmxpY2FsbHkgdXNpbmcgSFBCOg0KPiBHYWxheHkgTm90
ZTEwLA0KPiA+IEdhbGF4eSBTMjAgYW5kIFZJVk8gTkVYMyAodGhhdCBpcyBhbHJlYWR5IHVzaW5n
IEhQQjIuMCksIHNvbWUgWGlhb21pDQo+IG1vZGVscyBldGMuDQo+ID4NCj4gPiBPbiB0aGUgb3Ro
ZXIgaGFuZCwgSFBCMS4wIHNwZWMgd2FzIGp1c3QgcmVjZW50bHkgY2xvc2VkIC0gbm90IGV2ZW4g
YXMgcGFydA0KPiBvZiBVRlMzLjEsDQo+ID4gYnV0IG9ubHkgYWZ0ZXIgLSBhYm91dCAyIG1vbnRo
cyBhZ28uIFRoZSBpbmR1c3RyeSBpcyBydXNoaW5nIGZvcndhcmQsIHdlJ3ZlDQo+IHNlZW4gdGhp
cyBtYW55IHRpbWVzLg0KPiA+DQo+ID4gVGhlIGZhY3QgaXMgdGhhdCBIUEIgaXMgaGVyZSB0byBz
dGF5IC0gZWl0aGVyIGFzIGEgaG9yZGUgb2Ygb3V0LW9mLXRyZWUNCj4gaW1wbGVtZW50YXRpb25z
LA0KPiA+IG9yIGFzIGEgc3RhbmRhcmQgYWNjZXB0YWJsZSBtYWlubGluZSBkcml2ZXIuDQo+IA0K
PiBIaSBBdnJpLA0KPiANCj4gVGhhbmtzIGZvciB0aGUgYWRkaXRpb25hbCBjbGFyaWZpY2F0aW9u
LiBJIHRoaW5rIHdlIG5lZWQgSFBCIHN1cHBvcnQgaW4NCj4gdGhlIHVwc3RyZWFtIGtlcm5lbC4g
QSBwb3NzaWJsZSBhcHByb2FjaCBpcyB0byBzdGFydCBhIGRpc2N1c3Npb24gYWJvdXQNCj4gaG93
IHRvIGludGVncmF0ZSBIUEIgc3VwcG9ydCBpbiB0aGUgdXBzdHJlYW0ga2VybmVsIGFuZCB0byBk
ZWZlciBwb3N0aW5nDQo+IG5ldyBpbXBsZW1lbnRhdGlvbnMgdW50aWwgYWdyZWVtZW50IGFib3V0
IGFuIGFwcHJvYWNoIGhhcyBiZWVuIGFjaGlldmVkLg0KPiBJcyB0aGVyZSBlLmcuIGFuIGFsdGVy
bmF0aXZlIGZvciBhdm9pZGluZyBkZWFkbG9ja3Mgb3RoZXIgdGhhbiB1c2luZyB0aGUNCj4gYmxr
LW1xIHJlc2VydmVkIHRhZyBmZWF0dXJlIGZvciB0aGUgY29tbWFuZHMgdGhhdCBtYW5hZ2UgdGhl
IEwyUCB0YWJsZXM/DQoNCk9rIHRoZW4uDQpIUEIgc3VwcG9ydCBpcyBjb21wcmlzZWQgb2YgNCBt
YWluIGR1dGllczoNCjEpIFJlYWQgdGhlIGRldmljZSBIUEIgY29uZmlndXJhdGlvbg0KMikgQXR0
ZW5kIHRoZSBkZXZpY2UncyByZWNvbW1lbmRhdGlvbnMgdGhhdCBhcmUgZW1iZWRkZWQgaW4gdGhl
IHNlbnNlIGJ1ZmZlcg0KMykgTDJQIGNhY2hlIG1hbmFnZW1lbnQgLSBUaGlzIGVudGFpbHMgc2Vu
ZGluZyAyIG5ldyBzY3NpIGNvbW1hbmRzIChvcGNvZGVzIHdlcmUgdGFrZW4gZnJvbSB0aGUgdmVu
ZG9yIHBvb2wpOg0KCWEuIEhQQi1SRUFELUJVRkZFUiAtIHJlYWQgTDJQIHBoeXNpY2FsIGFkZHJl
c3NlcyBmb3IgYSBzdWJyZWdpb24NCgliLiBIUEItV1JJVEUtQlVGRkVSIC0gbm90aWZ5IHRoZSBk
ZXZpY2UgdGhhdCBhIHJlZ2lvbiBpcyBpbmFjdGl2ZSAoaW4gaG9zdC1tYW5hZ2VkIG1vZGUpDQo0
KSBVc2UgSFBCLVJFQUQ6IGEgM3JkIG5ldyBzY3NpIGNvbW1hbmQgKGFnYWluIC0gdXNlcyB0aGUg
dmVuZG9yIHBvb2wpIHRvIHBlcmZvcm0gcmVhZCBvcGVyYXRpb24gaW5zdGVhZCBvZiBSRUFEMTAu
ICBIUEItUkVBRCBjYXJyaWVzIGJvdGggdGhlIGxvZ2ljYWwgYW5kIHRoZSBwaHlzaWNhbCBhZGRy
ZXNzZXMuDQoNCkkgd2lsbCBsZXQgQmVhbiBkZWZlbmQgdGhlIFNhbXN1bmcgYXBwcm9hY2ggb2Yg
dXNpbmcgYSBzaW5nbGUgTExEIHRvIGF0dGVuZCBhbGwgNCBkdXRpZXMuDQoNCkFub3RoZXIgYXBw
cm9hY2ggbWlnaHQgYmUgdG8gc3BsaXQgdGhvc2UgZHV0aWVzIGJldHdlZW4gMiBtb2R1bGVzOg0K
IC0gQSBMTEQgdGhhdCB3aWxsIHBlcmZvcm0gdGhlIGZpcnN0IDIgLSB0aG9zZSBjYW4gYmUgZG9u
ZSBvbmx5IHVzaW5nIHVmcyBwcml2ZXQgc3R1ZmYsIGFuZCANCiAtIGFub3RoZXIgbW9kdWxlIGlu
IHNjc2kgbWlkLWxheWVyIHRoYXQgd2lsbCBiZSByZXNwb25zaWJsZSBvZiBMMlAgY2FjaGUgbWFu
YWdlbWVudCwNCiAgYW5kIEhQQi1SRUFEIGNvbW1hbmQgc2V0dXAuDQpBIGZyYW1ld29yayB0byBo
b3N0IHRoZSBzY3NpIG1pZC1sYXllciBtb2R1bGUgY2FuIGJlIHRoZSBzY3NpIGRldmljZSBoYW5k
bGVyLg0KDQpUaGUgc2NzaS1kZXZpY2UtaGFuZGxlciBpbmZyYXN0cnVjdHVyZSB3YXMgYWRkZWQg
dG8gdGhlIGtlcm5lbCBtYWlubHkgdG8gZmFjaWxpdGF0ZSBtdWx0aXBsZSBwYXRocyBmb3Igc3Rv
cmFnZSBkZXZpY2VzLg0KVGhlIEhQQiBmcmFtZXdvcmssIGFsdGhvdWdoIGZhciBmcm9tIHRoZSBv
cmlnaW5hbCBpbnRlbnRpb24gb2YgdGhlIGF1dGhvcnMsIG1pZ2h0IGFzIHdlbGwgZml0IGluLg0K
SW4gdGhhdCBzZW5zZSwgdXNpbmcgUkVBRHMgYW5kIEhQQl9SRUFEcyBpbnRlcm1pdHRlbnRseSwg
Y2FuIGJlIHBlcmNlaXZlZCBhcyBhIG11bHRpLXBhdGguDQoNClNjc2kgZGV2aWNlIGhhbmRsZXJz
IGFyZSBhbHNvIGF0dGFjaGVkIHRvIGEgc3BlY2lmaWMgc2NzaV9kZXZpY2UgKGx1bikuDQpUaGlz
IGNhbiBzZXJ2ZSBhcyB0aGUgZ2x1ZSBsaW5raW5nIGJldHdlZW4gdGhlIHVmcyBMTEQgYW5kIHRo
ZSBkZXZpY2UgaGFuZGxlciB3aGljaCByZXNpZGVzIGluIHRoZSBzY3NpIGxldmVsLg0KDQpEZXZp
Y2UgaGFuZGxlcnMgY29tZXMgd2l0aCBhIHJpY2ggYW5kIGhhbmR5IHNldCBvZiBBUElzICYgb3Bz
LCB3aGljaCB3ZSBjYW4gdXNlIHRvIHN1cHBvcnQgSFBCLg0KU3BlY2lmaWNhbGx5IHdlIGNhbiB1
c2UgaXQgdG8gYXR0YWNoICYgYWN0aXZhdGUgdGhlIGRldmljZSBoYW5kbGVyLA0Kb25seSBhZnRl
ciB0aGUgdWZzIGRyaXZlciB2ZXJpZmllZCB0aGF0IEhQQiBpcyBzdXBwb3J0ZWQgYnkgYm90aCB0
aGUgcGxhdGZvcm0gYW5kIHRoZSBkZXZpY2UuIA0KDQpUaGUgMiBtb2R1bGVzIGNhbiBjb21tdW5p
Y2F0ZSB1c2luZyB0aGUgaGFuZGxlcl9kYXRhIG9wYXF1ZSBwb2ludGVyLA0KYW5kIHRoZSBoYW5k
bGVy4oCZcyBzZXRfcGFyYW1zIG9wLW1vZGU6IHdoaWNoIGlzIGFuIG9wZW4gcHJvdG9jb2wgZXNz
ZW50aWFsbHksDQphbmQgd2UgY2FuIHVzZSBpdCB0byBwYXNzIHRoZSBzZW5zZSBidWZmZXIgaW4g
aXRzIGZ1bGwgb3IganVzdCBhIHBhcnNlZCB2ZXJzaW9uLg0KDQpCZWluZyBhIHNjc2kgbWlkLWxh
eWVyIG1vZHVsZSwgaXQgd2lsbCBub3QgYnJlYWsgYW55dGhpbmcgd2hpbGUgc2VuZGluZw0KSFBC
LVJFQUQtQlVGRkVSIGFuZCBIUEItV1JJVEUtQlVGRkVSIGFzIHBhcnQgb2YgdGhlIEwyUCBjYWNo
ZSBtYW5hZ2VtZW50IGR1dGllcy4NCg0KTGFzdCBidXQgbm90IGxlYXN0LCB0aGUgZGV2aWNlIGhh
bmRsZXIgaXMgYWxyZWFkeSBob29rZWQgaW4gdGhlIHNjc2kgY29tbWFuZCBzZXR1cCBmbG93IC0g
c2NzaV9zZXR1cF9mc19jbW5kKCksDQpTbyB3ZSBnZXQgdGhlIGhvb2sgaW50byBIUEItUkVBRCBw
cmVwX2ZuIGZvciBmcmVlLiAgIA0KIA0KTGF0ZXIgb24sIHdlIG1pZ2h0IHdhbnQgdG8gZXhwb3J0
IHRoZSBMMlAgY2FjaGUgbWFuYWdlbWVudCBsb2dpYyB0byB1c2VyLXNwYWNlLg0KTG9jYXRpbmcg
dGhlIEwyUCBjYWNoZSBtYW5hZ2VtZW50IGluIHNjc2kgbWlkLWxheWVyIHdpbGwgZW5hYmxlIHVz
IHRvIGRvIHNvLCB1c2luZyB0aGUgc2NzaS1uZXRsaW5rIG9yIHNvbWUgb3RoZXIgbWVhbnMuDQoN
ClRoYW5rcywNCkF2cmkNCg==
