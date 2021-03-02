Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A7BC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 670C060201
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581395AbhCBSvJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:51:09 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:61714 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237836AbhCBJUc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 04:20:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614676832; x=1646212832;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FX8JLe2aNXsfHa4TSgcBafrmdBgNeU3ZCx2Va9sQW1M=;
  b=IF3fTxhRCORAGaKNe61pwti/8ecB3YRs0yJXhmJBZmAhesKbcET+zewk
   af7raDk4uxc0bIHZgaohaiWhc31lHMQpEyraG7CkQmVoz9noupZa2psi3
   e11EyGaxWxlLLJJrF80Vg2yIPrXTwSkWA3phg7Uq70t3wPBkfY9rgft37
   NuyeOloN69qxqDsrUkFlGqxktOXWygKzNHu294Jh1JULj7iLk9b0twfLS
   CDci4cRM65spcA5GTcrIY7bLK5Q2NYUnOxarNma1eT6xd8llZGlQo2Ktu
   UgFC/YrHrD1syPBcx83X7T8dLTZvEjEFJpSfw55OzEl/ocGyGh3rSEyJP
   A==;
IronPort-SDR: Uzdt0suSv4Veh5lKcuQM7i9tZryZCJimjrIw6VGhYxOhDZP7HVYMwe5h6R40xQe97aTAClUM6z
 hy8Hb8Nto5MQpCDtW+no3k/2R2aIQMx8NdZbTdZLUPJL66GbyQVA2aV5QaeT/ysQ/dkAUjwAs4
 f9dS41Qy2Rcu8JEEPq+7orPGkrZWWU9OqczCfu4n/3kRqW5n0izXmEEabGE7oCq0j9zKoZWac7
 oqqkzvqimi4R6OdUmx0CAk1l/26pYOE0OMwlobcXqdIvOzf4+PCfrO71midKUyrYHIVm88pL/d
 Sds=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="165623890"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 17:19:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxQt9ksnDJeS/4Dq0MHw/MGpOoPWEYAUMSmuqiStToS02RVwQvIOpqtBjWtetWypBweepmoL9a+G/Oz4mbZgRQxuSQ6fPWyTW0ZKoAE8w6Aw1FbZM554YkiW807EHxh8XVVCBfBk1SvqvScFZ5u8XBbVRgIZidBxH/O0nZd4HKYmoAe4fuUeJHpfqxlDJD3SV2BQc6hKSLP9ot0w0fghzC8a2l9SYw56CUM797cmngVOf52dsEKm6s7fpCq1C0fITv/jmOW5BMPtCbHX11dKbt0q9wb8CDQLT1uBXZXrptqFuKYjAsrrMMx0XX5dRSC6hPZizCnZQG4iks6jvwzjYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FX8JLe2aNXsfHa4TSgcBafrmdBgNeU3ZCx2Va9sQW1M=;
 b=Zcc5dCJW4gidyCzeXt57+3KmjJa41Y9qWYsAEZrMHXCykjYKDfw9qK6kOfVi0nSXj3iwNZJoSYB+OXdkncTjD+QMn7L0ffWmnmqMMgv/iHCWrBZazRe2NCasGrrJ69gscHcnunsvu+SVzxdsn/yXojeqYPbekyIvMXg28qPxsSLGhrj8BrXyDfYVyBv69HyeebuEYRtGFYnfbdtYLHxLt6eRIC6aO1bIR4CvalIyaJzBVQK36KtheA8lp6kr+IrNeqoYs96YHuXF2YCgVzA+0w2lmGglwiNSuO0DRR+/7gkUmAFGp9GjaMRI/m64TXmFR5vNGdzbwumppP0/XIH3Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FX8JLe2aNXsfHa4TSgcBafrmdBgNeU3ZCx2Va9sQW1M=;
 b=HVI84VkuxvEz+iCpyBAf0shAqY68oZUR9f/GWh1owxRq5ySZZ5wohyszS0Sx3vMTAhvD3dVWfPlZObgVax7uO8CTs21aS1vhz5Gm2ulx3QFOS7qo3GVWHFXvQo8dRiugjv3QgNU8kKon9pxEvkrqHyeBD+WiZEpJ+WrmAUUuC28=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5083.namprd04.prod.outlook.com (2603:10b6:5:12::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.28; Tue, 2 Mar 2021 09:19:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.030; Tue, 2 Mar 2021
 09:19:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v4 3/9] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH v4 3/9] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHXDBov0TbDu5nGu0uD5PRlnlBXaqpwZJcAgAANSnA=
Date:   Tue, 2 Mar 2021 09:19:17 +0000
Message-ID: <DM6PR04MB657517682B016E9879267556FC999@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210226083300.30934-4-avri.altman@wdc.com>
        <20210226083300.30934-1-avri.altman@wdc.com>
        <CGME20210226083422epcas2p2d39acff666e2cb9ed97bc2d5c7a8df6f@epcms2p5>
 <1891546521.01614675601803.JavaMail.epsvc@epcpadp3>
In-Reply-To: <1891546521.01614675601803.JavaMail.epsvc@epcpadp3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6876196d-4a76-4238-4e96-08d8dd5c412d
x-ms-traffictypediagnostic: DM6PR04MB5083:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB508337F109BF50B3FF9B7310FC999@DM6PR04MB5083.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jGsZDhi0shvViFJM4noWPC4Rmp5ac9IzcqVl0OfTZImC2MhOejZhaa4cdLYYP4IbJ3KIWDlbpXGhHn24F6T7D/L9OvoWNQZRkBUvky0h3ZEeuoy+/WcKlsK8CONi5v0rxJBuQgr3h/KqcEmBspW8SzvpiCNEvKo/8WxfWGPacvQVP9oULHYjlIgytCC7oeEutBLFbOEQBbpxI4Ug9mhYXF/ZKXi9lu4WkGkHsOi78FHY0WVxeXnBp2VvITrAoOCusq5+fR9MO4DjyX337wkhsT9xwaoqnnF/kfZAgWGbbWtFMYB3R4/HWPytTeTbYUESpenW2P2r2y2/75S4+Me5zy/vD2bNPdmuQ4RvTWfiw4tI5E4hBBwRNbOM/XMdsHbGI3gmsRdqkGyufDW2fx7DgylhAvlmbF8s8aopWKhYs2gf/v43MrUKXk2kwx82jQ2l7KdNrREAYZLHNq0WKBhiwQ7v2N7DxJdGd08hXoInkYOvt579Y9AnMiC77+50Q9SuUVvZsy8+IvmciDJ9ZEzz5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(316002)(478600001)(52536014)(186003)(66946007)(76116006)(83380400001)(26005)(2906002)(33656002)(66476007)(71200400001)(7696005)(66446008)(54906003)(64756008)(8936002)(9686003)(55016002)(86362001)(66556008)(110136005)(6506007)(7416002)(8676002)(4326008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NzR2Q2xnbXhZWlJ0UzlNY3A0Zm1KMlh6L0UwVlFWaGkrSUZjSUlIaG9JU3Rp?=
 =?utf-8?B?L1BQb1FwNHJyZU5kd0kyY0l3S24xYWdVUzFacHpZZG1CRTVlZU40OEN2aDVt?=
 =?utf-8?B?Znoreis2RjZ6cDZ1L2VYRS8zWkVUQnBoT0NObzhkeXg3bkxhSUVvQjlpRFNn?=
 =?utf-8?B?NnppeDR2Ujdzd2I2YVMwbVRIWFhmWGwrenZ3cmtMZVRpVW1JOVBUb05FNHBp?=
 =?utf-8?B?YVl3dXVPcnlUMU9yeXlnQmZnOVFPVTVzNkNDUmI2b1RZdVVnMW5vQ3pWRzQr?=
 =?utf-8?B?RHc0UTlKWFFWR3ZKSDQ2NVpyR3NjdkJja0hlNjI2azFBVjdvTnJyR0s3b2hy?=
 =?utf-8?B?ekxGbk5TVUtEU1M2ekY5QXRTNUhjeDdEL2JGenFaRmxMdjh5MVp3bzZRdVJr?=
 =?utf-8?B?eG5FMUpudktqVHZ5TzRwMEkvYUV0YXVpdzR0MmtqUWFoU0pyYkUvaDhGWGF1?=
 =?utf-8?B?R1VVQVRLL1c5VVBhSlVxa1JhMlFEaXlYbk5obisxODNvWFhWWjVva2grQ2dx?=
 =?utf-8?B?b0F4YXZCZmtza2pqajdZcTBzcS9xejdpcThsN01wR2xMbGVOR3pCcTVVQUl1?=
 =?utf-8?B?OW1NbE9QQlpDMG1mMm9IRWIva3FCdTh6T0E4Zno3TjFERE5Rd1ZVNmpGMUtV?=
 =?utf-8?B?V1IrWER0Wk9qRmRSaDRkbE8vT2VTYkhNeUpmMVJvWDMvM3RHbXN2UlYzRXUv?=
 =?utf-8?B?MzdESW1uOTlLRVJHTnhMTmV6KzRlUndRMW1NNk1XNnFCWmtjdUlBYVVsZEpu?=
 =?utf-8?B?eXU4aUdocHJCQVA5V21OSVlQbFVPME9GZWJ5dDdLNURjWnZQY1N2TWxTTTJB?=
 =?utf-8?B?WFowa2wxOVhjTy9WeHdJVzFoa1dpOEl2L2hEd01HYkJpL3g2cEphLzNHSlNL?=
 =?utf-8?B?RFdCeWRYMEJUbTJRQ2RrUmxHbEN4UnM4U1QzdUNGVUlWcGhHSVRxb1J2UVl2?=
 =?utf-8?B?WTAxK3JpREQvVlFOck1mYy9SNWpCc1dPYlNIaVRZL0F3R0p4dUx1NS9oN3ZK?=
 =?utf-8?B?dVNBQzNpMXQ5V01TNWRuNVRiZHRSV0tUdE1ydE1EUXAzcDFJMVcxYVBiQ1Fi?=
 =?utf-8?B?c2VueGEzc1FrbzZpT29yRFVxT1FvU2ljRzdrY3Nta3ZnQUYyOHJZVThoVXJp?=
 =?utf-8?B?djlKVis4bFNKUGh4R0c3UmhiMGczYVJ3dVpSbE1yTDlPekxPYjVkSi9aSTYw?=
 =?utf-8?B?SkpJWnBxQnFBTjZHRGZJR0w2SmJwWUhrSm1QRDloVG1ldWt2ZTFBeFZySGlv?=
 =?utf-8?B?WURldTBwMWE1VU9hZWtuZXI5UktOOFRHS0ExOE9pbzZQblBCdFJJK2xTNW9r?=
 =?utf-8?B?VEVlZTF6SXlnRU00clFrMXhXL2hRa3IrUUI4TU5uZnJTVUwvS0RTZXFRWUl2?=
 =?utf-8?B?cTZQSUFFVlp5OG91MXRWSG5hWi9YNzVMZG9TUm84V21xV093TzIwZ3lobmhJ?=
 =?utf-8?B?Q21hM1VwcEtYeDE3Z0NiS0Q3ZkxselB1c0toM2JMK2JKeXNNcTd2RFNzU203?=
 =?utf-8?B?c1R3VEtGMTFNcGZsTy9WbzRWZGYyNHNLWmNrNFRXTzFpSGQwT3VzVzNGY2N3?=
 =?utf-8?B?VlV0eXBveVNsVitRbXE2Y3pjQWVYVExEV21acXA3NmxraEllVzRmQ2ZMbnh2?=
 =?utf-8?B?Qk02aWEzSnN5UmFBK2ZhY0lLNkRua2t0TVV1bWJ4b0JaajR3a3NoMzVKb2Nh?=
 =?utf-8?B?eXFjTnczckxORDNtdFhnVW9KZUp1YzZ6OGkrT0YxTVZCei95bnc3MDZqUW9k?=
 =?utf-8?Q?/S/TyjQuHJ3CyGp85Bdnr8FhrxM76f2d2aVQopD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6876196d-4a76-4238-4e96-08d8dd5c412d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 09:19:17.2406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZNKRwRwpm+oGw277NCpSzSeqxfIQBi0GSttXy5AZT/2qpgkkXwH1n9I48/wGVghFScVrAH4qsqi/EHY6vgt5KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5083
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gSGkgQXZyaSwNCj4gDQo+ID4gK3N0YXRpYyB2b2lkIHVmc2hwYl9ub3JtYWxpemF0aW9u
X3dvcmtfaGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+ID4gK3sNCj4gPiArICAg
ICAgICBzdHJ1Y3QgdWZzaHBiX2x1ICpocGI7DQo+ID4gKyAgICAgICAgaW50IHJnbl9pZHg7DQo+
ID4gKw0KPiA+ICsgICAgICAgIGhwYiA9IGNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3QgdWZzaHBi
X2x1LA0KPiB1ZnNocGJfbm9ybWFsaXphdGlvbl93b3JrKTsNCj4gPiArDQo+ID4gKyAgICAgICAg
Zm9yIChyZ25faWR4ID0gMDsgcmduX2lkeCA8IGhwYi0+cmduc19wZXJfbHU7IHJnbl9pZHgrKykg
ew0KPiA+ICsgICAgICAgICAgICAgICAgc3RydWN0IHVmc2hwYl9yZWdpb24gKnJnbiA9IGhwYi0+
cmduX3RibCArIHJnbl9pZHg7DQo+IA0KPiAqSEVSRSoNCj4gPiArICAgICAgICAgICAgICAgIGlm
IChyZ24tPnJlYWRzKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxv
bmcgZmxhZ3M7DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICBzcGluX2xvY2tf
aXJxc2F2ZSgmcmduLT5yZ25fbG9jaywgZmxhZ3MpOw0KPiANCj4gSSB0aGlua3MgdGhpcyBsb2Nr
IHNob3VsZCBwcm90ZWN0IHJnbi0+cmVhZHMgd2hlbiBpdCBpcyBhY2Nlc3NlZC4NCj4gDQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgIHJnbi0+cmVhZHMgPSAocmduLT5yZWFkcyA+PiAxKTsN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcmdu
LT5yZ25fbG9jaywgZmxhZ3MpOw0KPiA+ICsgICAgICAgICAgICAgICAgfQ0KPiAqSEVSRSoNCkRv
bmUuDQoNCj4gDQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgICAgaWYgKHJnbi0+cmduX3N0YXRl
ICE9IEhQQl9SR05fQUNUSVZFIHx8IHJnbi0+cmVhZHMpDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgIGNvbnRpbnVlOw0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgIC8qIGlmIHJlZ2lv
biBpcyBhY3RpdmUgYnV0IGhhcyBubyByZWFkcyAtIGluYWN0aXZhdGUgaXQgKi8NCj4gPiArICAg
ICAgICAgICAgICAgIHNwaW5fbG9jaygmaHBiLT5yc3BfbGlzdF9sb2NrKTsNCj4gPiArICAgICAg
ICAgICAgICAgIHVmc2hwYl91cGRhdGVfaW5hY3RpdmVfaW5mbyhocGIsIHJnbi0+cmduX2lkeCk7
DQo+ID4gKyAgICAgICAgICAgICAgICBzcGluX3VubG9jaygmaHBiLT5yc3BfbGlzdF9sb2NrKTsN
Cj4gPiArICAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgIGNsZWFyX2JpdChXT1JLX1BFTkRJ
TkcsICZocGItPndvcmtfZGF0YV9iaXRzKTsNCj4gDQo+IFdoeSB3ZSB1c2Ugd29ya19kYXRhX2Jp
dHM/IEl0IG1heSBiZSBjaGVja2VkIGJ5IHdvcmtlciBBUEkuDQpEb25lLg0KDQo+IA0KPiBUaGFu
a3MsDQo+IERhZWp1bg0K
