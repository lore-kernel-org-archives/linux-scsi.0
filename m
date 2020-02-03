Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FD4C35247
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 21:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07DA920658
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 21:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aVn9RNE1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DvArOm4Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgBCVaA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 16:30:00 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:48200 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgBCVaA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 16:30:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580765399; x=1612301399;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T5JeN45QnDNMVLmG/LU3J8n+j03nYs/4xr2EGmeydy4=;
  b=aVn9RNE1OFdLESUCQFqmju+nOEU7F1SHLlDNZrCnM/SIrWRrQDk/UjfM
   RELm6wBOfhtx/QVWmoQ4V8osqJEHY0PTCI3Ktmf916lkz+msqY/g4UbeG
   FMiwNNT0nUPMKA8PboJyVggcpCM7hCpaZuU+xWRS+qBGH0rBCPxCzfgyl
   +GoUz3b5X6oe80v+v07jxceTzsSPmYT/Jg7nvMwvObCuElZcdL2ASQIq+
   MqX1m9wlzabqYnCW0Aapaz0NvUYc4b3Veh2tAAHIM5UV0W0fOOUc5WfC7
   K+M4pKMqquQBmJ+j3lFA4Swo8aehyMs8rKtmnsa3leQIydfkTSrBlkahb
   A==;
IronPort-SDR: HLSzfg1CdScC+fNNSLbigt/BhAmUxhhGT8NSSfD8Bnyo0rwKZPlFFO11daM4CYzzr2OQOHEMsc
 S3dozOoovrfHcqe1YvvWIiZzGUjnCxenSbw/hAxp0plSFDr18xGDLHj/kEJoDmlXTEOU8fXoPq
 /wVjWrSfhvWy6aAarIQLROl7sIu2z/9gAA94OujQdsnAYworNiGJGo4OFrcKg0vW41g2Tv9ifL
 Brx+7PaxkyalH2yR6kCIFbEDIvT00foHspZIZ4xRpG/l+s8UtnNSwgKKDvedTMLQLwngMTkEwD
 x44=
X-IronPort-AV: E=Sophos;i="5.70,398,1574092800"; 
   d="scan'208";a="236969350"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2020 05:29:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/tYH+nY5ibwM/JPWa00gmTJWXt1EVx3laNTUTfZ98h9xZLWXBKDRsv1vYKU0XnNN8/f9f/aLeMjfteHQ9x+G9G6CPljDbPH2sb/czrs7igY8ADxZGxfYx8SfuNrHMYxf6ceuxBucrLjDOnn6ha6aFjbCLCKjodt9jhebV85OfXjBxfaZkdHn+2aE8o6D5ANxiaK1rGCBI8yo2kS5PUBlaLbkppMFA9HMq+nYPHw5+kav2kWgqOFOGwEuE5QVZBRcuaUUNG6CMegLaXj562SBcZHnS7l7v0mUNkhM6F23p5XXTQ8XDV6bcBDs+0K5uJO1IGFuj+PGtTZ/8xx0frRWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5JeN45QnDNMVLmG/LU3J8n+j03nYs/4xr2EGmeydy4=;
 b=Eq6KhgDsQ80C8UdDU7OOdAOBXCKVavMmljHUXEUQznOveu93ORr3dJhmVubjKxDf6ze9jX5e27fcYdmh8CeJSf0wCGtPaGhihiGw8S6JHxbTiZadZ2qc6gu2U+wae+hUwnkOeP/BM/bO4KZMkoaIZL5ab7LDREl83Acxh5KutqpWBd54peWDb2hYIFB9rbDp71Sqsrl/rqkYZ1VqjEcx7bFuM7ln8SxMnNs79BIgMLOMLpFBnZ/KYnP+C/xF0LlYWfeKlMKikzO7IuHGjCXIpE6GgSiOtyixNPsU8CRgP6PjmguQFeV/+5Tipx1KxAHbsIOycenkqVcnnNYTKoD46A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5JeN45QnDNMVLmG/LU3J8n+j03nYs/4xr2EGmeydy4=;
 b=DvArOm4Q0+ALMOhisBgigch4ufloYPREQzlAmMp8xX+JWGPHvAhXHH6TaMDeNMXr66ddu5upoQNKvNUWtVToI5MyL6X1gfteUu3+ZZfeZawb9JsxyTF5z+B2av5VZdob85m8UMq9t9hmlUN0ngUCowVbDTf++UhC4PjMVR2QpR4=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6415.namprd04.prod.outlook.com (52.132.168.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Mon, 3 Feb 2020 21:29:58 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::b870:3f25:f3be:535d]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::b870:3f25:f3be:535d%2]) with mapi id 15.20.2686.025; Mon, 3 Feb 2020
 21:29:58 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Topic: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Index: AQHV2bYgyCYLCd8TvkGCDJX1L0irp6gISGeAgAEWVwCAAC+qAIAAZ98A
Date:   Mon, 3 Feb 2020 21:29:57 +0000
Message-ID: <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net>
 <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net>
In-Reply-To: <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [2a00:a040:19b:4327:f9eb:12cc:8585:ceaa]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 948c1c0a-439a-495f-c7c7-08d7a8f037ed
x-ms-traffictypediagnostic: MN2PR04MB6415:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB64157893F03BAE53B1271FC0FC000@MN2PR04MB6415.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(199004)(189003)(71200400001)(33656002)(55016002)(76116006)(86362001)(4326008)(81166006)(81156014)(8936002)(66946007)(8676002)(316002)(9686003)(54906003)(6506007)(110136005)(186003)(7696005)(6636002)(478600001)(5660300002)(4744005)(2906002)(52536014)(64756008)(66446008)(66476007)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6415;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m17UDNxdWvgUYdk7wI4CsCGyPw5EuqzETAaJRx6m1LTIjtvl4OhVH/Qq9jDQrTqHzs/9cJQhWfnSc84c2/2sYwXgoBEcwsP0CFABfXHsYv54LWo3vpOnQOzOpZ5cp0qARF3A0fj76KLlrAKOxN6zC0ZYyNOEcWuIOVsICFzdbevhvJibIGRF4INGXHM3nxZMPqtgXF/gd6G3WMGMqI/ZTfIKTJ07EfdNkGrC93AYD6LzU7WYrRCNH1l7CdH1j+xSlo4QpxAl+78FEY4cw3VFhIQXvZGLHJWcE8OO+aQK8iU3ZI8G4zQHf5+JSdcYvfU121CDGlv3zs85eITkdGouNP3EhqwNfMHZikw8aue+zTd72WPMYW77U8WKspYsJzZ8+NBw+oi0U8Sq7NcEZmawNTfABJXoicstQMpmWbBpW2C/4aGv/oLYmBtI3zJ/s8D4
x-ms-exchange-antispam-messagedata: 2IhrvTWUj9b8K7ktM8TlkQqpsHUF2rY2oiC6VyyxCyzxTAQoRLzAwQkrgrKi8Zs5DBHJrn2gl/pKeBBGUBrb9B+7RGtC5DNLrxflD678q1MuP77tFePkASB+d8+U488AQUXddg4FbENM8F7Tt59FFfDQmR4qhyvkvthOnoIsOVoCAeYXdQXeRTfmNLdikPEyCyCbHlu7N8oGPldKC3rJ9g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948c1c0a-439a-495f-c7c7-08d7a8f037ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2020 21:29:57.8250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hn1iAG+86LOIE5+lpz2LZJMIriTtb7fR7348X0Wxf6UgqPMewlX1cV96Snk+8rC9Fae0tm4ggql4BhkkzwOIOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6415
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+PiBDYW4geW91IGFkZCBhbiBleHBsYW5hdGlvbiB3aHkgdGhpcyBjYW4ndCBiZSBhZGRlZCB0
byB0aGUganVzdC0NCj4gaW50cm9kdWNlZA0KPiA+PiAnZHJpdmV0ZW1wJyBkcml2ZXIgaW4gdGhl
IGh3bW9uIHN1YnN5c3RlbSwgYW5kIHdoeSBpdCBtYWtlIHNlbnNlIHRvDQo+IGhhdmUNCj4gPj4g
cHJvcHJpZXRhcnkgYXR0cmlidXRlcyBmb3IgdGVtcGVyYXR1cmUgYW5kIHRlbXBlcmF0dXJlIGxp
bWl0cyA/DQoNCg0KR3VlbnRlciBoaSwNClllYWggLSBJIHNlZSB5b3VyIHBvaW50LiBCdXQgaGVy
ZSBpcyB0aGUgdGhpbmcgLSANClVGUyBkZXZpY2VzIHN1cHBvcnQgb25seSBhIHN1YnNldCBvZiBz
Y3NpIGNvbW1hbmRzLg0KSXQgZG9lcyBub3Qgc3VwcG9ydCBBVEFfMTYgbm9yIFNNQVJUIGF0dHJp
YnV0ZXMuDQpNb3Jlb3ZlciwgeW91IGNhbid0IHJlYWQgVUZTIGF0dHJpYnV0ZXMgdXNpbmcgYW55
IG90aGVyIHNjc2kvQVRBL1NBVEENCkNvbW1hbmRzLCBub3IgaXQgb2JleSB0aGUgQVRBIHRlbXBl
cmF0dXJlIHNlbnNpbmcgY29udmVudGlvbnMuDQpTbyB1bmxlc3MgeW91IHdhbnQgdG8gdG90YWxs
eSBicmVhayB0aGUgbmV3bHkgYm9ybiBkcml2ZXRlbXAgLSANCkJldHRlciB0byBsZWF2ZSB1ZnMg
ZGV2aWNlcyBvdXQgb2YgaXQuDQoNCkFub3RoZXIgb3B0aW9uIGlzIHRvIHB1dCBhIHVmcyBtb2R1
bGUgdW5kZXIgaHdtb24uDQpEbyB5b3Ugc2VlIHdoeSB3b3VsZCB0aGF0IGJlIG1vcmUgYWR2YW50
YWdlb3VzIHRvIHVzaW5nIHRoZSB0aGVybWFsIGNvcmU/DQpQcm92aWRlZCB0aGF0IHlvdSBhcmUg
bm90IGdvaW5nIHRvIGRlcHJlY2F0ZSBpdCAoSW50ZWwncyB3aWZpIGNhcmQgaXMgc3RpbGwgdXNp
bmcgaXQpLi4uDQoNCkFzIGZvciBhZGRpbmcgdGhvc2UgYXR0cmlidXRlcyB0byB1ZnMtc3lzZnMg
LSANCnRoaXMgaXMganVzdCBhIHN1cHBsZW1lbnRhcnkgYXMgYWxsIG90aGVyIGF0dHJpYnV0ZXMg
YXJlIGV4cG9zZWQgdGhpcyB3YXkuDQoNClRoYW5rcywNCkF2cmkgDQoNCg==
