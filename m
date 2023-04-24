Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D82BC77B61
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Apr 2023 06:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjDXGr3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Apr 2023 02:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjDXGr2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2023 02:47:28 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCF52684
        for <linux-scsi@vger.kernel.org>; Sun, 23 Apr 2023 23:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1682318833; x=1713854833;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=6Cu/8D4exTtk7x14kRr5CFKGKchZBCUSYvs1ClSKEPc=;
  b=fea6zYhhVBuPWuEm2b64hi5YLp0VOS5s27rBBnA7ifjrr8RR5HxZijzK
   AxdYXyKNFB9AkqePLIuobcWrecJd6cXk5MQFzFl9XvRYwPhzXiRyqrTEF
   M2K/BFAXwpKJ4Z9NDo6CNUS9S/dRaqHPQUQxyEGhTTKXBjgZgfHtVVImL
   hD+SWCLsW8298TdjhrMWfKH0XBfzIztoxwlUEsSaU+HiDMLWkdAi4XRi9
   dpHftojdWOK1dmmDvRTUPH/GtOkQVBHB9j2EaHFofmWqSKnUMwbHEVlkI
   SPi/PZFhf9SpMJESn5jgoie7YTOhyU7AvUKM6gXRLfbN3WMA5ho7pFxhL
   g==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677513600"; 
   d="scan'208";a="229183405"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2023 14:47:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1HlCEeC5Z56niRHDVTqs8oxGWIxYM7HxZcMaQMbFVEiq4qYz8tTKNFnPU1z3G12wajmN7Tdodu4N2AZy3C3Vf4wwugMADH/pir50mbtnwz2hXgivtnB4noXQyDZqnDGhsqZ9hq59lUA4kWvtD6PtNOPZDH3ku5r+adE7tK+66LWFplggNRl6hvKICQ65m+3bqJG15tUUOfRLV7sqIvbKJO6I/3XdkBaNYjjZ2Lns3FIosbbOneyeKMws/HNZce/19J4HW12XoqVrHvQ3+QYt1jGvnkvaPU6OpNB/pJ6g2FMrFrqyF/fUKE9XCPyj5AiuY99qK/aVTu3fPs0oVuL8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Cu/8D4exTtk7x14kRr5CFKGKchZBCUSYvs1ClSKEPc=;
 b=IpgFPnc4Z1fuxcHlDILT9hkzTvYpIvalrWvFLDECOr+ixcGdzlIWGcujDWx/McIK8RkUI1ZxqBbTAs4V1p4u40+VS8WF7a97dNgq3IiDObJ0PLWOLB/RuTtewVUmlJv1tNqibYq5tjSUvdwAChd2fCyAgzPIHwhXsORaKaC/iakrlFTWvcn5JxqD0J+PB7v9jqkQfrsZzBIsRYxjFkhPSa8NqIzmiA1Rue7qJJt8yQWKOZYBWX7ixmDN46CRvO883+qW59NP4/yBkQLv96CBATw4VunY9c1+6oxFlH38u2e8R8xEBWaDoSF9PG9VP79qJOStPfIO5CPGaAHsbfc+Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Cu/8D4exTtk7x14kRr5CFKGKchZBCUSYvs1ClSKEPc=;
 b=z7Td7pr7PCqeETyf80ootR+iAvIIsOSgHhtdeA24dRpi24NDjvc2jnThiwGfdaBmnYyUWGl9Tbd4s9zIxyPaOoZklgtFq4GDc0IhE6mr8oOOlublwh81O1pLkEhBxf4gRiaOrQV3Hin4NDYts35Ge52LpE65W2DGPjL8WoPCeW4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BY5PR04MB6947.namprd04.prod.outlook.com (2603:10b6:a03:22e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 06:47:10 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::188b:9005:b09b:81e2]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::188b:9005:b09b:81e2%7]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 06:47:10 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [RFC PATCH v1] ufs: poll pmc until another pa request is
 completed
Thread-Topic: [RFC PATCH v1] ufs: poll pmc until another pa request is
 completed
Thread-Index: AQHZcpB3WQVyd0N5Nk6XP0AldI1k/K84rxYAgAE++ICAABxnEA==
Date:   Mon, 24 Apr 2023 06:47:10 +0000
Message-ID: <DM6PR04MB6575372C3F82509E9AE69466FC679@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <cpgsproxy5@samsung.com; stanley.chu@mediatek.com>
        <CGME20230419072745epcas2p47b29940fe7e50d947a29546a8e79abb9@epcas2p4.samsung.com>
        <1681888769-36587-1-git-send-email-kwmad.kim@samsung.com>
        <DM6PR04MB65758403CC6D31654A98BB43FC669@DM6PR04MB6575.namprd04.prod.outlook.com>
 <004101d97669$97c787e0$c75697a0$@samsung.com>
In-Reply-To: <004101d97669$97c787e0$c75697a0$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BY5PR04MB6947:EE_
x-ms-office365-filtering-correlation-id: ba85a8f2-28c0-49b2-e9b4-08db448fba8f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GKBNU5vNMYH2MGObvC/YzcOJaSlqBBeARmJaVa2aAFCVubTZvjMKpYZ42p3VqztQE/o76KBj+tPK7IpVES85pt6ul/CHtHAAmeMN9oknJZPnpFpsjvj5kY0eHnPXwopKaNjWtbBk4QSecyznuBZ27DvD85soZCglEtGib5mg5T1jTgFLKv36thqrHi//RpiYavVfvdtJhZAeDkOTYb2SNib2bxUJJy2RfOQYPpxgmEWHIzFoQQ1CZL9AFR5gZJ4lv/2gCNbgGKpWbWs7fRh0fX30b1tJsUSb4lbe0B2nE6N1FqPhXtsCEzI5WSDBmO99FFwzjQWK5jVtxmlR4sG+YonHJcyu0aRhUqSCdOcwji7Y1ii4vTGwJNgB304WFtdK/9KxVh7hhlJYODPsG1R/LwEZqXEN5mx8rtjKewK7X6ywiA1MLsr8DhHhH57BtbfueJvUFFH6jv3McFD+/bJsO6qDIo9McioBhHHmNo6gY5JeP+oh7MH1SDfU5VAq/KJuq2ycNlLVw2KP14pLmkxti0gTeNFTsBfaScrVtA8ETAu9LbgT8St0dcNRUHCPZqYtp7L8mtGlgkKJesh5r5ZIQpflx1kP0yKIMF5SrI8mgGN6dPj71aOcG4S8/eAcuZub
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(9686003)(6506007)(26005)(38070700005)(55016003)(83380400001)(186003)(82960400001)(38100700002)(122000001)(66946007)(478600001)(76116006)(86362001)(64756008)(66556008)(66476007)(66446008)(8936002)(8676002)(110136005)(52536014)(5660300002)(71200400001)(7696005)(66899021)(41300700001)(2906002)(33656002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnBIOE9KRDRiV3FnU0hIMjFlNzlOQzAxa2p5NDFmL3NUbWVsUnF1bHdteW50?=
 =?utf-8?B?aFBSUmZSbFFRK0NreXlQLzk4Qi9RRlFHY1RscEtsa2pKdVduWHNaSFRMazVL?=
 =?utf-8?B?Umd1eFIwZVlNWU82djduV1d6OE9ZaEszeUo0WlBZMHB2aXpwcFJSSWY3bjNL?=
 =?utf-8?B?SmFnTVhzbHFhbnpnci9xRUNRUjBIWUthNHRSZ3lpOUFvMWdXdENMYWRTekFi?=
 =?utf-8?B?aHZpa1pTUkpWQjdub0tWVFhPejRhckVHeUFRWG1QcldPY3BVeklZMWNjQUxO?=
 =?utf-8?B?QWRPRVZZMXhwNVBOL2dCL1ZSZ0x2amNUVGM0UzFtWFkwSVZLbXB1TFB0MU9m?=
 =?utf-8?B?RXBrM1JrWWRSdUhkZmRkSDltN3BGVjlEdGZERkJLNzd4azFlYUcyRk93OERL?=
 =?utf-8?B?dmVuQWZQYnhxUW1NcXJ1Q2JiTk12Z0xPdGYxT3JZcTQ3WjdKNkprZFVDRysw?=
 =?utf-8?B?MlQxcHFIQW1rRFBta0ZyMEwzNUl2WlFKSGlqNnd6OVZ5VjdvNHZlWWlyY3Jt?=
 =?utf-8?B?SGxXS2s1L3pSVFY2czByOE9NOFZTOEtnbGtCTmpiTjBaYVA3MU5NN1FSNXd6?=
 =?utf-8?B?bmlGVU9vNDhZQkVIWWR2YWZ4MmRNZzJLbHNJS0F5MlFYVE14MjVBTWsxd1J0?=
 =?utf-8?B?U0ZIUzBJT3RCTVVPRTc0c2dlQk9hOEdEaGZCQmRrU09BUFl5Z21CNXJMS3Q5?=
 =?utf-8?B?TG82MmRhbWRpZ3ltOGxoNkEyQU16WGp0emtNWDdtTG1KMGIxMTN6c1YrTlFC?=
 =?utf-8?B?NWdER1hDV3ByWklxSGhSYThwQXR3UUxwUVpPcldSbzN0aTBLNG9SNWNJdFlY?=
 =?utf-8?B?RHlYR3FTZUpscVRMaGF4VjFyczRBbktNdHF3azFjQ1pBQi9tRFBSRmRSMmgw?=
 =?utf-8?B?VkdHVUJ0SDRUTUQvaUwrWFRJTUhwSzZIai9qK3BQV2wreVJ3bnlVQTBVSkcy?=
 =?utf-8?B?eGZUMU03L2lrRGh0T2RnZUs5RzF4RFdIMUUzam1hZVl0dGE4c09SS09FNmlS?=
 =?utf-8?B?LzBsZ1NNMFJPZWUxUkxUS1djc3Q1cEZabmR1c3JIdGlZdUdlQWdjTjJQQ1Fa?=
 =?utf-8?B?VkFNVnhVVU5MRmVmYWtRV2VWVlhvcUVoeUhQMlY3clpJQjdETGNxOUpyQ200?=
 =?utf-8?B?cjVTQ0xtWlcyendyWXBYRDdhREo5REhXellheks0SmRLYkZ0NStXUW4zVmkv?=
 =?utf-8?B?NFUvUTV3bTd0MGVvazJsWHJDZmZWRzFwS0hZYlhjTkl1cUtaa09IanRsV1hM?=
 =?utf-8?B?dmV3R0s4dWZZTDd4ejNCMFZYdjYxT1krbHdtODd3YXVBRk9EZWM3Yld5em1a?=
 =?utf-8?B?K2V2V3UwVThsY05VQU9LeGcrSEJaUER6a2RrcnpISWZWMWxHRkptL1F6TVl6?=
 =?utf-8?B?L281amVwMjZDS0lwN0w3YXJNMTB3VGlrY2ZiWWpTS0FWMkxIZDZWK01ZL3pz?=
 =?utf-8?B?VzQwYy9HbXcvdERPK2c2STNWZVdKMUhiUVNzeFowNExGVXFieFdJeXZRMWVo?=
 =?utf-8?B?QXRudHEwNjBqQklXcnY0L3hCRFhiS3FJbWlabjliVEhXWndqQ3VhZW82ZXhQ?=
 =?utf-8?B?NWd0UFRzYW9Ua0NZd1FiazYvUzZMRmM0OGwrTDRmbHNpcWdYZHA5WmIvM3BM?=
 =?utf-8?B?S3pBa05zeERMMlVRYjJUODkrZjBGR0p2Yy9GYUFpbXdrWGNhL2hvSWRLeHI1?=
 =?utf-8?B?K0ZQQjQ3L0ZTc3pzUDM0dWgzVFVTQmFwcytiRXlvdVVPRm5HS3krZUpEam45?=
 =?utf-8?B?dDBhZEZkKzBFckVQY2cxS2k4WGdxV1ZhVHBXOGExMkVPK3Fsc1o1dzB6TUFo?=
 =?utf-8?B?dk5Dd0JLLzdudWo0VWgwQzZBVkFBU24zSVAyelVXZUpiUDZIQmdzWXF6VWZH?=
 =?utf-8?B?VXRLYXNNR0xXRlQwWUoxUnphNE9qZzhzUFRXMUpXejBVL3Y2SE40TE5jTHVZ?=
 =?utf-8?B?YUNaNXpnN3RKeDE2VFkrQkk4ZEJjY0Fabm1iSVRJcGVyVHR5VzMwMm85Q2hs?=
 =?utf-8?B?Rkx6Znp6TEpLNmFITzc0cHV4V2lKTDZtckNEZ3BsaUpjM0JXa0wzeDUzRGMx?=
 =?utf-8?B?WEY4ZGdZd1NVaTFRRVpTdWJzdU9aQ2daWGdCSWhFaEFYUkZTWmE2MkRXTGNl?=
 =?utf-8?Q?B9qUG+k50UlzpjDMIuY6jKvbi?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RGM5k+8WVLNeVBUMaAHqEB/tZIfwcwSKcEWqVSk+JblKHDcsjOnubKthak+S8hsqDmOBNlZCFkFFuVmLQgsUxYNLk9mswteUSaSCZD/zvxO1srmjwFz+3zedqB6upJ4fpsqkzY3TuIhnQq2iBVkByrR/kbYGdBbn0Nvq6FOuDsuxmN3chvm+XneBdUpJWH0yRARFB8re2IDafDNXP/TObS1ybv/wmDAT7H5zjMIGuliUF4svfJ6w5Jy82iKP5RESM91pZtf9R/KpVApTyRTaFr4LhS+zprMTuUwQDj7G86fskrOaD8ondZVCb9PaA88EJDjn1O58142ooox+J+Os02M3ri0i0Kuhyo2m3dfhssmLO+rGe4TvjkHWvJtNzfJH6gJJFPUn6DNIEYfnGqdm1whwMlQ0W7PW7tbhJTv8Zf09mgcaICllvRTKHBQdiINYPnURy/XHMGW/jnV/Z7FNn62EJeX70dneRFXAOWHzjW/m7Yia/Xn6JlG6LgZzypwK17dj3wDIvn1uxJ762WM5/+VWEMk1pXrMJlGQSorQi3ayDiH2pRFAd+oxU49IyWB+301e5X+YWz5uBQO+GyWmhaHctZYE9lH57vPaMUnDKEDfEt35QZQ9zNOvZUfbOsIUJR8/1D3n/QKdUCpirK1D+t905rPSo/ajGyNgRmJbHaoQKLKaeftULe0MiZkr8r36BSdAAszsxEi9ebwDTWavmOVIWmJAkC5LQRJl9QLpEAkrkSAmwGDEeo9tsZWVsIap+1adSLfBp+KtQli6Yjef+G+sfaD9x4LJP/kmdlPrYSKclTPnF6MeUo0fMs+7s9tp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba85a8f2-28c0-49b2-e9b4-08db448fba8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 06:47:10.3725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5C3d14KTI6RP2zq3u0b8Noy3wjk81NqlZ5g051RkPB4jdehnIcp30smAepDhXGyI93XRcAE9z+Ev1LoVrP+Daw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6947
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gUmVnYXJkaW5nIDUuNy4xMi4xMSBpbiBVbmlwcm8gdjEuOCwgUEEgcmVqZWN0cyBzZWJz
ZXF1ZW50IHJlcXVlc3RzDQo+ID4gPiBmb2xsb3dpbmcgdGhlIGZpcnN0IHJlcXVlc3QgZnJvbSB1
cHBlciBsYXllciBvciByZW1vdGUuDQo+ID4gPiBJbiB0aGlzIHNpdHVhdGlvbiwgUEEgcmVzcG9u
ZHMgdy8gQlVTWSBpbiBjYXNlcyB3aGVuIHRoZXkgY29tZSBmcm9tDQo+ID4gPiB1cHBlciBsYXll
ciBhbmQgZG9lcyBub3RoaW5nIGZvciB0aGUgcmVxdWVzdHMuIFNvIEhDSSBkb2Vzbid0DQo+ID4g
PiByZWNlaXZlIGluZCwgYS5rLmEuIGluZGljYXRvciBmb3IgaXRzIHJlcXVlc3RzIGFuZCBhbiBp
bnRlcnJ1cHQsDQo+ID4gPiBJUy5VUE1TIGlzbid0IGdlbmVyYXRlZC4NCj4gPiA+DQo+ID4gPiBX
aGVuIExJTkVSRVNFVCBvY2N1cnMsIHRoZSBlcnJvciBoYW5kbGVyIGlzc3VlcyBQTUMgd2hpY2gg
aXMNCj4gPiA+IHJlY29nbml6ZWQgYXMgYSByZXF1ZXN0IGZvciBQQS4gSWYgYSBob3N0J3MgUEEg
Z2V0cyBvciByYWlzZXMNCj4gPiA+IExJTkVSRVNFVCwgYW5kIGEgcmVxdWVzdCBmb3IgUE1DLCB0
aGlzIGNvdWxkIGJlIGEgY29uY3VycmVudA0KPiA+ID4gc2l0dWF0aW9uIG1lbnRpb25lZCBhYm92
ZS4gQW5kIEkgZm91bmQgdGhhdCBzaXR1YXRpb24gdy8gbXkNCj4gZW52aXJvbm1lbnQuDQo+ID4g
Q2FuIHlvdSBwbGVhc2UgZWxhYm9yYXRlIG9uIGhvdyB0aGlzIGNvbmN1cnJlbmN5IGNhbiBoYXBw
ZW4/DQo+ID4gTXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IGJvdGggbGluZSByZXNldCBpbmRpY2F0
aW9uIGFuZCB1aWMgY29tbWFuZA0KPiA+IGFyZSBwcm90ZWN0ZWQgYnkgaG9zdF9sb2NrPw0KPiAN
Cj4gWWVzIGFuZCBvbmUgdGhpbmcgSSBoYXZlIHRvIGNvcnJlY3Qgb24gdGhlIGNsYXVzZTogNS43
LjEyLjExIC0+IDUuNy4xMi4xLjENCj4gDQo+IEFuZCBJ4oCZbSB0YWxraW5nIGFib3V0IHRoZSBz
aXR1YXRpb24gdy8gc29tZSByZXF1ZXN0cyB3LyBQQUNQLg0KT0suIFRoYW5rcy4NCg0KSG93ZXZl
ciwgUGxlYXNlIG5vdGUgdGhhdCBDbGF1c2UgNS43LjEyLjEuMSAiQ29uY3VycmVuY3kgUmVzb2x1
dGlvbiIgb2YgdGhlIHVuaXBybyBzcGVjLA0KaXMgZGVhbGluZyB3aXRoIGxvY2FsLXBlZXIgY29u
Y3VycmVuY3kuIE5vdCAyIGNvbmN1cnJlbnQgbG9jYWwgcmVxdWVzdHMuDQpBcyBzdWNoLCBJIHRo
aW5rIHlvdSBuZWVkIHRvIGV4cGxhaW4gdGhhdCB0aGlzIGlzIG5vdCBhIGhvc3QgaXNzdWUuDQoN
ClRoYW5rcywNCkF2cmkNCg==
