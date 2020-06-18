Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D5EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 10:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C71B42193E
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 10:22:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aMp7molH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="C4IKPIV5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgFRKWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 06:22:51 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:50366 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgFRKWr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 06:22:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592475767; x=1624011767;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g52g/h8WIgYUC4RwVjymGTrl0sbADB0rD3EBI39XG+c=;
  b=aMp7molHKI75DBAPntPh1W3CXkVqZRSXFmMnKG4a1eUuRVWMh7/EBQ68
   RhP76f+u4jhaurY3BSC8xZkg30VGDRoRlhgcYHahPGMnuWPN7rOeHEbrO
   j2Rf24x8J9bFG80+NMrtVzrl2T0ozyeoimMtMRmeitHH/D4nrS6zy5o1Y
   rf393OuPqbP8F0Al6zmCzqxK2d8GOl2TFnM9Svrbi/kC4fYkw/lVOKe1g
   35lvKwaciSncVZi6+W0Lr7v3Np6Gf+shMIf+B3rxznBjMm6XWbj0ds7sf
   BAQOzFHSkCrBzFG7X5pBvFy1at94FJgDVc7xJ1wKIBBFIfHmZZmkBmly4
   w==;
IronPort-SDR: mbNJWiZe4aQ6D3LKWn5+VtqJR7HKVPRRY+5e4bmAzjwcT72kMvN50oHXeow4K1Fy8Zwmj9i0xd
 L7vDXwt9wNEmJBbUd0fudE1UxLtsOqCgP5A9bTP4QyFz93qY7hJkogbN7voCm3C6yaEbpkPQd6
 IQqZm8ZJfFTkgFgYCGigjkdCPf56DPieunxJzLMAixgsteCevrsYXMi7IH2cdfp7CnprASkD0H
 FVeP3m7EQRrdbuaYfrD9aaAjA4v7e+LFRK3NtThHm3KcsBZSVwzOOH+uoxu44JI8qd4uV44ZwE
 ks0=
X-IronPort-AV: E=Sophos;i="5.73,526,1583164800"; 
   d="scan'208";a="243266673"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2020 18:22:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBkIk80QE0EQGFMhnADIl9B85Z94T0Orqh2Zb1Z1aQWKxPXhvzSHSp8XFuqf4AJ9IzXz2Jw3copFYdSCC6ujY/ldryi4J7sGNSCLXKlbTx/XCQwg6MAS8cwLaay2gJOcn0ZHXrdMee6TB33AXBKA5rpmTCknTbJPWeZ4zZgkw9Hzz/u/U1KNHhcuAde/IAuprS4dVg6h65G1N61b9XUsBGHFzlVfaMGvKlkQW87b8C++Xkzez2urFiHFO/R73ti1a41JvkWaYP4QZ08OVUNllq4BpJjQYs8wO1jll8DA4SU/lcm3+lmG4CO0xQT6HLsKSxALFOScr892jfQ+NxmH+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g52g/h8WIgYUC4RwVjymGTrl0sbADB0rD3EBI39XG+c=;
 b=kRkJwxgP9yZzq7wmEzEASXOEKhipUefPR68ZZ1WdZ3PZqQBiY+09ht6ECokzRP79iM0/CP4nJ8I3yIx2+k+R5nbcizP7l6cyd5runs30rLG83fb7N3pmR94Mp9Nfo/nQRJolZdV2ffnD/L7H0wsXPU9uwJ0oWUwVLK2VfyGWVzQaITNAHh3wimgJ/kPELGynQ0Ha8PREGLd/iwrVZNXHA24nSgl4AHua3f/fDsrQWPCw6LCVYUhNmyjKeCaabNQFlfV3QcnkxFExleAHGpbGXIQKnyM3mq3mtluQ+CRFB569ns9QjzmXG7Ad69iIMO0ZeIODPpr3hlv2uErAZsAsBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g52g/h8WIgYUC4RwVjymGTrl0sbADB0rD3EBI39XG+c=;
 b=C4IKPIV5yqGGgLdqV2yS4nlvLwp5cllMsl7Rp8sEh7uIhHD7JRLaKHKH3edif+RNCUr14bfRlZuVMStCwmhTgcdzgFuRcrayUQEV46dBN4pHZujxx9KjHvUGO/fHNy+lw95FnnibPZmhoYGbUv3N8RF+MSb/3I1Y8h2HOtcEUK8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4717.namprd04.prod.outlook.com (2603:10b6:805:a8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 10:22:41 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 10:22:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH v2 4/5] scsi: ufs: L2P map management for HPB read
Thread-Topic: [RFC PATCH v2 4/5] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHWQvj3YPr08JZ2QEy1VbmJ7tAyW6jeLfhg
Date:   Thu, 18 Jun 2020 10:22:41 +0000
Message-ID: <SN6PR04MB4640B1D4FBDF68A59D993F21FC9B0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p7>
 <231786897.01592214002170.JavaMail.epsvc@epcpadp1>
In-Reply-To: <231786897.01592214002170.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b96efa8-7d09-41ba-ad58-08d81371885c
x-ms-traffictypediagnostic: SN6PR04MB4717:
x-microsoft-antispam-prvs: <SN6PR04MB4717719AFDA54F4445714622FC9B0@SN6PR04MB4717.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Maw1dHGzGNonrs0vGZ/B8nDt0aN19qokrulegxtSP6hUfPkwk9Hh7iLAJg8BLCW9e3ChI+XFrFZdDdzVK05sbyZNalzXUlo6kGKKhYXdoPTqR2WR+Sq1rMeDMst+kUzAboQa6Lc9qOBeslEnpzYPTJTLfjH/AQmVYCt+wInQhHEH+Uo0S+pt6Wfjvezy7fFZBS3iKY9dA9LRam6j661BczWJ/d7fhpz5R57n847j9yL3De/v2RWj+R034z2KCzC9yRfTlEkDHg6MwyQfkZVQiW73iC+NRQ8UTSy2EdTnv1RLJMfBZCSAAtaJc5Eb+zWto0Z3txx6d8P7ujCJrjUsx1UPp20Rp+hOIB1z2vPO4ZWiNhmHaVUjcXycSg9I/lYS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(33656002)(5660300002)(52536014)(7696005)(2906002)(8936002)(7416002)(64756008)(66476007)(26005)(8676002)(66946007)(316002)(76116006)(478600001)(66446008)(66556008)(4326008)(54906003)(6506007)(110136005)(9686003)(55016002)(71200400001)(86362001)(83380400001)(186003)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: lbObWt8CbaN2ive0Na/WShHvr/D0LAvCbUzsc5krbtHdEgi8yAvIb5R9zUNqt7xqL96GMmv3DbALe7g1c52IvJXzoX9z89sYXJQdrYSj9UVaIvCuTTafsXjfnoEh6D04WmHeAefEGVJfxSKl6tqLSzg6R/GgjYsMtf0wxYPaM+NsxwbRLOlWagcUX+cNqKQ+HHJ8unZK86lDEiCJlEIYIszw2/cy/cL1ECIFhZ3AR7n3mgqHJTHRO8ouSzFzEOnIkTQ3bR9S2ztJGSyQzEKVVp7/sNgp/b12C1sPa+mUCPM+uZhraVm7t55sm+SPCFUWJd7wNM5UyeiiD0XeoDEGwLTxpu6xykrfubrIRPcTUDrbzc1gOrFCiegjT39uvdFLwe2+BbzmBknLCNF+kSbmmfyvUY8Xy9ghrZZQoaPZUg30PPTIyAgFpvM2kdkFTYtrq7WY00i0toBb3LX0ZF377lh1lzXN1wPZZgBcebsAVBqkSXhw3pcCLj39ZB1V+eRj
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b96efa8-7d09-41ba-ad58-08d81371885c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 10:22:41.0563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UV8IcBjvYacpBrf7ig3LmmtQd4hvtSEzUnzA6xkiTKfva/2RRYXib8tQblWS3f2kDJY1VV90cDaFEeZKHaIOng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4717
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICtzdGF0aWMgdm9pZCB1ZnNocGJfcnVuX2FjdGl2ZV9zdWJyZWdpb25fbGlzdChzdHJ1Y3Qg
dWZzaHBiX2x1ICpocGIpDQo+ICt7DQo+ICsgICAgICAgc3RydWN0IHVmc2hwYl9yZWdpb24gKnJn
bjsNCj4gKyAgICAgICBzdHJ1Y3QgdWZzaHBiX3N1YnJlZ2lvbiAqc3JnbjsNCj4gKyAgICAgICBz
dHJ1Y3QgdWZzaHBiX21hcF9jdHggKm1jdHg7DQptY3R4ICBkb2Vzbid0IHJlYWxseSBkbyBhbnl0
aGluZyBoZXJlDQoNCj4gKyAgICAgICB1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiArICAgICAgIGlu
dCByZXQgPSAwOw0KPiArDQo+ICsgICAgICAgc3Bpbl9sb2NrX2lycXNhdmUoJmhwYi0+cnNwX2xp
c3RfbG9jaywgZmxhZ3MpOw0KPiArICAgICAgIHdoaWxlICgoc3JnbiA9IGxpc3RfZmlyc3RfZW50
cnlfb3JfbnVsbCgmaHBiLT5saF9hY3Rfc3JnbiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHVmc2hwYl9zdWJyZWdpb24sDQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxpc3RfYWN0X3NyZ24p
KSkgew0KPiArICAgICAgICAgICAgICAgbGlzdF9kZWxfaW5pdCgmc3Jnbi0+bGlzdF9hY3Rfc3Jn
bik7DQo+ICsgICAgICAgICAgICAgICBzcGluX3VubG9ja19pcnFyZXN0b3JlKCZocGItPnJzcF9s
aXN0X2xvY2ssIGZsYWdzKTsNCj4gKw0KPiArICAgICAgICAgICAgICAgcmduID0gaHBiLT5yZ25f
dGJsICsgc3Jnbi0+cmduX2lkeDsNCj4gKyAgICAgICAgICAgICAgIG1jdHggPSBOVUxMOw0KPiAr
ICAgICAgICAgICAgICAgcmV0ID0gdWZzaHBiX2FkZF9yZWdpb24oaHBiLCByZ24pOw0KPiArICAg
ICAgICAgICAgICAgaWYgKHJldCkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+
ICsNCj4gKyAgICAgICAgICAgICAgIHJldCA9IHVmc2hwYl9pc3N1ZV9tYXBfcmVxKGhwYiwgcmdu
LCBzcmduKTsNCj4gKyAgICAgICAgICAgICAgIGlmIChyZXQpIHsNCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgZGV2X25vdGljZSgmaHBiLT5ocGJfbHVfZGV2LA0KPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgImlzc3VlIG1hcF9yZXEgZmFpbGVkLiByZXQgJWQsIHJlZ2lvbiAlZCAtICVk
XG4iLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgcmV0LCByZ24tPnJnbl9pZHgsIHNy
Z24tPnNyZ25faWR4KTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ICsgICAg
ICAgICAgICAgICB9DQo+ICsgICAgICAgICAgICAgICBzcGluX2xvY2tfaXJxc2F2ZSgmaHBiLT5y
c3BfbGlzdF9sb2NrLCBmbGFncyk7DQo+ICsgICAgICAgfQ0KPiArDQo+ICsgICAgICAgaWYgKHJl
dCkgew0KPiArICAgICAgICAgICAgICAgZGV2X25vdGljZSgmaHBiLT5ocGJfbHVfZGV2LCAicmVn
aW9uICVkIC0gJWQsIHdpbGwgcmV0cnlcbiIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
IHJnbi0+cmduX2lkeCwgc3Jnbi0+c3Jnbl9pZHgpOw0KPiArICAgICAgICAgICAgICAgc3Bpbl9s
b2NrX2lycXNhdmUoJmhwYi0+cnNwX2xpc3RfbG9jaywgZmxhZ3MpOw0KPiArICAgICAgICAgICAg
ICAgdWZzaHBiX2FkZF9hY3RpdmVfbGlzdChocGIsIHJnbiwgc3Jnbik7DQo+ICsgICAgICAgfQ0K
PiArICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhwYi0+cnNwX2xpc3RfbG9jaywgZmxh
Z3MpOw0KPiArfQ0K
