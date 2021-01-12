Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0676C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 07:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABE5422CB2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 07:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388900AbhALH04 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:26:56 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:60949 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731300AbhALH0z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 02:26:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610436415; x=1641972415;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=vj0B6LimeapUH+Mj/itL2H/ppRYbtOBWTG1IPkv1AYA=;
  b=o103XqErOAiAwXNFfQG1CGj85XFXIVDZlHksdhU/sXLsRelKLxep09I4
   sM7+VXPd4MIL8BC1VS2T19UUUL+vnonLfRM3dSwiDmHoAXZHiP3z1/jy0
   D0HvXvdrdJAg8NHH3mdGtI4v4gZJJq5/oKTTsNBwWmxrkK8/20J2HJgJ2
   Mn0fvYX522NIyAI1KM2wpT3Y35px/umSSpLBqbkT6eg/VhaBz0h4Jcq8S
   e4n+SJ8J2qEdCd9HMvasV7Z76uW7JYK/FWBBR9mMs3SvHVxOCNBBHuAjv
   m3m5eIB1mHVoIMzf3wQzNIoCqUtGWPa8oXaLcq0d6lsSP1ouz1B7vTmNk
   A==;
IronPort-SDR: i+wstc8YWMLEFzPU7JozNraKAicdnVckJzAh9/tksLkuSD0C7lWK04cL6UxMUZnVR1tW/6YPqc
 fyISz2LjohrCL90DWzatdySCMms2ylhSb8X621W4I15gfRvz1Fnn89Yd6EmUumQE4yuADkjCRO
 ug61RbuewPvYvXWm128DiIgrjDtfmCp6v2T/mmDTq0TWfRcVWWUPFJ3BWQfnIXc0tYz1nP0Is2
 ouXUnrhZGT3aOwLnNJZTp2a3SRM/xfseSoMdfycYfWYy5Zdee89An3Yy+sBj97Na7GhyGlV+XT
 i2A=
X-IronPort-AV: E=Sophos;i="5.79,340,1602518400"; 
   d="scan'208";a="158391294"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2021 15:25:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjWUoynwZvDSjx80AXL2ppUR/gaYpRGvr21iXL9VVdR+U0F/lf86mky4OBTK/9WRTF1aEIeMaruh6S6oC9eW63tFD619qH3/mP69W5l65YCVtrP6TKBkGqx8RspgvBTvXYRuVcJmPIGA86xhkzcvvUrlkvxYTS9I84Z1+aGHZzC14n7J9Z4UzNps57pyo1YiOFjqHkRK96bGnJRdWV0Xbq+x2X7XByGXmhL+T68aY3W4ep9KkBDLD1f5j5fyibeYvVoZfDH40MFhdlNXv0aqAorefeJvMyDZ3LSJ4sEFAKLzkrETvquSi4zQJ0PG2p2ywjf7sG7j/GRupER/TcB3ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vj0B6LimeapUH+Mj/itL2H/ppRYbtOBWTG1IPkv1AYA=;
 b=KwYiHuNNcnRbf2uHQ4CqewAP4oWeSHnUY+2tO2sGgQr840nPO3i0LbsF22hCQBJ/bey8CpDZOftnz3ti8MabgqN9DEAVNt2Q9/ATmO34F9xlqX3hNJ3m3ddqmm/sC/XVhLtGNzGETdAFH8ydpYXzja3V16pHQ2zQVXhFYUG33jDBZQwXWHa/EQ65zswvPLkqaFXcPukCYpXSyWl3L/ZKvxsYL95Z0230Vx7shZrG9tfAjjnx7LBexm8SzprFACL+1pqNWT2S4SLJzjrvp3CCCld5f2MvQUEcURCWx0A/c6SZv1bYhYMDB0i8VzJfOedgIRcuIFaU8Lz6xMNXnFTWvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vj0B6LimeapUH+Mj/itL2H/ppRYbtOBWTG1IPkv1AYA=;
 b=dlbrF1+PysTPw7bhyGz7oa9rf0U5bV2vw/yznjCfuKza8RjuTWtje56Ul9L/9JrZ6C1zfwXCpZ/rlWGbi13cshju0ulaIeQ57LRud6O4cmIlSKZBPzp4J5PvhB+y2nbX3BIVn73ic23bwDvVE+FInzEMNmfyN/QYL0e7+01yLcQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4171.namprd04.prod.outlook.com (2603:10b6:5:95::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Tue, 12 Jan 2021 07:25:45 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 07:25:45 +0000
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
Subject: RE: [PATCH v5 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Thread-Topic: [PATCH v5 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Thread-Index: AQHW6I6mZwrEHYndck6lM7O84FjQf6ojlu/A
Date:   Tue, 12 Jan 2021 07:25:44 +0000
Message-ID: <DM6PR04MB6575F316200E1A4082BD91D0FCAA0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <cover.1610419491.git.kwmad.kim@samsung.com>
        <CGME20210112025712epcas2p4f92af7bd5781df2fcefecca47d55bf8e@epcas2p4.samsung.com>
 <689878ebbad3e63a96b431df8d843264f8fe57ba.1610419491.git.kwmad.kim@samsung.com>
In-Reply-To: <689878ebbad3e63a96b431df8d843264f8fe57ba.1610419491.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d069bd36-49a4-4d73-0aa3-08d8b6cb46d4
x-ms-traffictypediagnostic: DM6PR04MB4171:
x-microsoft-antispam-prvs: <DM6PR04MB4171F34F6C73F1F364542F1CFCAA0@DM6PR04MB4171.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v/0XIVpQWrxlGng+mT/792SBO2rOSW9GZ+PqAakAUbzWBF+zpVjwxxOFqp444Aa6ZeR00MkXT6yaAv/St6dKP+TQPyrif9OAWthdX963JPC+qOETe4qwwKnGFcQBSZQMJkrtXOPp4PbcqKrI9T74YRSj5rsgaNlzLS18XO4+VfvhX74O2BZCqfZjSfy4fw3F5iPyEVP6X1lXDHpCT6R/k/zPxW9JQApeFBMyyGdMCs4FJa1G4qtDjprQrI+NOJG/TPcEz+bZ8wfnFY+s2mXWAb0lRctH2GWhYXrPr7syk7reAnPe+F+we5tvagjYrGsC36Lah3ZNveaa7B8WfGklmbsgNlc32DW7k9x0gqIgPS4ZrQQWdt8puOD4Ie73aVw6CY8A+xmyzr9J1IUmspuCBAhAOz4Ycidsq0LHCKRPqQSelWM9vpex4tsS4e8Vhxat
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(86362001)(71200400001)(66446008)(64756008)(186003)(8676002)(4744005)(66476007)(7416002)(8936002)(921005)(7696005)(76116006)(9686003)(52536014)(2906002)(5660300002)(55016002)(6506007)(316002)(33656002)(66556008)(26005)(478600001)(110136005)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?K1hLWXZKRW9VTFNubWJEU2I5UnA3SGNpRGk4T1VNaEJWOHJDNGl3RGFNYUhT?=
 =?utf-8?B?YjMycmxKbjUvUVJKKzg5SWNpR05ZbzJTWC9rRXYrbDRna2hkUGlLTHRobFp1?=
 =?utf-8?B?d3BiWjU3aUlTMCtmQitjcnlsQ2k1S0R5TEdka2FoWmFZcllqU2NRNlJGV2RO?=
 =?utf-8?B?UWo0bnQ5b1FrUENCOWJ5N3FGQmNySWNGaGN3TEtNN0NXZWJTZmJzaU5kV1hN?=
 =?utf-8?B?Z25OajVjM01sRFQ3aGJtRUk5VUQ3S2Y4OEExUVhDUlp5bUFXcSs2ZkJ6RGJ4?=
 =?utf-8?B?MTYySzhieXZYQkhreGRzblJRamRBbFFkY1RnTmpsNVJMTzhkampScnRzRWd0?=
 =?utf-8?B?cEZSRTFQcGNhaDdxc2pkWGxXS2tFT3VVdVNHMHlXM1BhaU1BNEhVbUI3RldG?=
 =?utf-8?B?ZkZXWnNDNkVQZlJGV1N3ZVE1MEZ2bnBmRTB0aUFmM2ZSMkJPMFByQ1QxRjNk?=
 =?utf-8?B?NkFIVkRlMXhLbk8vVm5aSXRISHcwQ3pBcmdyTnpxaXRxMHpocit1c2o1M0hM?=
 =?utf-8?B?OUtxN21aMk1zOGdXWi9pcncyelNZcENEUE51ei9nRzQ5aFM4ZHFFZ0x6M3N3?=
 =?utf-8?B?OUpMSUdVTWpjL2tucjgyOVo5MVlxS3ZxOTVHYVZ4Z1F5dkZVMTBhenpnQ1RX?=
 =?utf-8?B?TXFpazdtNWkwM002WWxJa1haSS9lcDQ1eWI4eWJXWndueUVLSFVNbFRBenRR?=
 =?utf-8?B?SWhRTVdWWXh5UjJRZGsxUDc1aHloeUVwRnZ5WUNUL2tuZmlCYUpjbFZQTThu?=
 =?utf-8?B?YXhibzZHaVpzS21QQ010T0hCbmRRU0FsVjI0K0NEcTRzOGIxUGY1UjliYXc0?=
 =?utf-8?B?c3hibmNKMTJieFRMZ1ZSb0RET3lpY1NKYU9aUFRoMC9yaklzOGlUOWNlbGFR?=
 =?utf-8?B?RkdBS25HSm0rNW1lZlVLSXAvay8vUGF1Qko0MzFvVUZhWEhBSExFM2N4dXlq?=
 =?utf-8?B?L2EzdnlZaHovckNsRUF1YU5xSUVzZ1dkWEVOQnZPOSs0OHVlQk00TmxucjFV?=
 =?utf-8?B?MmN4ZnZMRGtiUExWb1BSZFB0MWFvVmdBTzREWW5JUlBmREFKU0xaUU5jNFlk?=
 =?utf-8?B?ci9weEszaytxUjZ4Q3ZNMzE1Z0dua212azZvRW5TcjVIOFZmWUU4bHd2TFRl?=
 =?utf-8?B?U2x3dzY2c0gydU9PZmNGU0tpd2tmYTA1UTNHYlNkek8xMi9ncndMZW5VcGN1?=
 =?utf-8?B?czlDdllqRlJxaWh2Vk1ha0JSTksvOWpqcHBnQWJXM2ljRlZYbkoweVNuQkQ1?=
 =?utf-8?B?b244VGZtUXZjQ1FJakxNdGNNbEIxb0tmUzVyRUVBb0VlQlZQek0vZnBhQXdW?=
 =?utf-8?Q?15KNPC3KUCKx8=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d069bd36-49a4-4d73-0aa3-08d8b6cb46d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 07:25:45.4618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5OhnR/CeQvPSsnIlkxrDbqdqz1iYQQMCRZqXEGvQ8TfXGEY4K1qbnmm20a2xk00GyJOi+9XEbwr/zKGqmblKBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4171
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gRXh5bm9zIHJlcXVpcmVzIG9uZSBzY2F0dGVybGlzdCBlbnRyeSBmb3Igc21hbGxlciB0
aGFuDQo+IHBhZ2Ugc2l6ZSwgaS5lLiA0S0IuIEZvciB0aGUgY2FzZXMgb2YgZGlzcGF0Y2hpbmcg
Y29tbWFuZHMNCj4gd2l0aCBtb3JlIHRoYW4gb25lIHNjYXR0ZXJsaXN0IGVudHJ5IGFuZCB1bmRl
ciA0S0Igc2l6ZSwNCj4gRXh5bm9zIGJlaGF2ZXMgYXMgZm9sbG93czoNCj4gDQo+IEdpdmVuIHRo
YXQgYSBjb21tYW5kIHRvIHJlYWQgc29tZXRoaW5nDQo+IGZyb20gZGV2aWNlIGlzIGRpc3BhdGNo
ZWQgd2l0aCB0d28gc2NhdHRlcmxpc3QgZW50cmllcyB0aGF0DQo+IGFyZSBuYW1lZCBBQUEgYW5k
IEJCQi4gQWZ0ZXIgZGlzcGF0Y2hpbmcsIGhvc3QgYnVpbGRzIHR3byBQUkRUDQo+IGVudHJpZXMg
YW5kIGR1cmluZyB0cmFuc21pc3Npb24sIGRldmljZSBzZW5kcyBqdXN0IG9uZSBEQVRBIElODQo+
IGJlY2F1c2UgZGV2aWNlIGRvZXNuJ3QgY2FyZSBvbiBob3N0IGRtYS4gVGhlIGhvc3QgdGhlbiB0
cmFuZmVycw0KPiB0aGUgd2hvbGUgZGF0YSBmcm9tIHN0YXJ0IGFkZHJlc3Mgb2YgdGhlIGFyZWEg
bmFtZWQgQUFBLg0KPiBJbiBjb25zZXF1ZW5jZSwgdGhlIGFyZWEgdGhhdCBmb2xsb3dzIEFBQSB3
b3VsZCBiZSBjb3JydXB0ZWQuDQo+IA0KPiAgICAgfDwtLS0tLS0tLS0tLS0tPnwNCj4gICAgICst
LS0tLS0tKy0tLS0tLS0tLS0tLSAgICAgICAgICstLS0tLS0tKw0KPiAgICAgKyAgQUFBICArIChj
b3JydXB0ZWQpICAgLi4uICAgKyAgQkJCICArDQo+ICAgICArLS0tLS0tLSstLS0tLS0tLS0tLS0g
ICAgICAgICArLS0tLS0tLSsNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtpd29vbmcgS2ltIDxrd21h
ZC5raW1Ac2Ftc3VuZy5jb20+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFu
QHdkYy5jb20+DQo=
