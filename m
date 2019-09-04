Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81668C3A5A9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5781A22DBF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="G1Fb3Ao9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ySObhuZC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfIDImd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:42:33 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:8329 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfIDImd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 04:42:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567586553; x=1599122553;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OTlYXWWsleCoQrjt02+nV/J0yDqSGguOoIafDxeDGFQ=;
  b=G1Fb3Ao9KWRB6v7yQZUSzfYYSZc7eKGtbosyBJPTul0af7QWFYgJ3VmD
   MqRR5/leEanEk9FGnQib+syRDtabE6r/g0daDPtWMsO21h7dnZcJ8uCMi
   m8FLJzavvi3slZz9HTV1RCtUbY0G+Se4rE8ftpLlj2IKnIQLlHX/6icss
   iuI4igGVewJRlPYmj29aWSc2FAGOlSTzZPmPD7/qNAgIqm4GfyaQaAfeh
   NXjFk1d2M7EMqoVA8osQV7wTr++2Q5LqEAPPVfACNCWLjMrkJ7UdTTcKX
   PUZtj8/N0y9wvhuzrTpvo7x9ktbLFEVDQrrsaU/I0G/fAu9NMKb/EKqQz
   Q==;
IronPort-SDR: 9hUv2oWj8pCdLhvz3w/U8LfrOYuWwUFHgzhdHYHJd9536AXeAv/iMVLmqwLjj9Buon1EEIhEM/
 F/WoXl2LPB8e8syAcSI/zchbjry0X1S+JHp2RDKwgbUy1PpAHUEfjQ5MGVRgRU0gTQqZuqKUTY
 T+2eNKE/zdN+LNAIs9R4/gFKJ+jilC/kDW/wzXiPnOFf1ozp6VNh7IetHtlA8fAQC6PW48WC88
 LtK3c9Tgd74wHKKoHlejve9Q/+gDQ45eXdPP0c2xaINkBMZr+DT5IQHtGKZS+QTbx+L6L2ehqD
 62c=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="121945965"
Received: from mail-sn1nam04lp2050.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.50])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 16:42:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVh7ozstXwPIouPuBLZtS81lj+oCHHbFgk6AsjOAD9y7g4jbPDeTO3WNEsi53LY52H82spczkMnBCTIeZu1wgPMnbr7MwJ53aiJqAnkbCI3VuNkCRlY2D94reTaqmNrRy2Vz7F5ZZa7RtrcMM9z5kQFLOxzPA6rp6ly+ntpadsXvfACr18KGM7UjFihwcMwEwoRtQRqJBlVQa8ZzhWzxUTu9HvOhlmZIT7zrRKYhhswfNdd3p4KXSMwEWUcbODdK3P6lOWaXy3jk8jrkO5e5DH/PtuURFp2nSkE/1/p1FP/nnHI2JQ/eFZipyc9laI7vdzaQQuJBCbT/t4sP37XZ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTlYXWWsleCoQrjt02+nV/J0yDqSGguOoIafDxeDGFQ=;
 b=hJJeoaMMfjATQnXg/7YlSvKeIYXU7+FVkgI6JdECKy9pCYw76btb/oR+G8WxluIdOE7zXX8TCeg2YEJUrmmktyekLlrO56/PVQWNaORmdD170hMU0ln1wTvZpxCAjzSJeH8ZVrXKiKvhs3NMZ2FHsW2h7t27qK23jSkPxcnjilgQnuQNzTZ3vgTFb9C1KtsbSRGdsgE0hUc3Pr3M61qQdNj4eR1xsHqgjrm1W9+oLpZZ5iXGprEfePNvJ2rOzlfWoRCK2UvTv5NJ/c5AN3XOi8rFlDv0mtuVmq7WSs4yuoMl4TsY8invAH40hTJ8Cp9XApx2wX8Q19mdpYZBOwxnUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTlYXWWsleCoQrjt02+nV/J0yDqSGguOoIafDxeDGFQ=;
 b=ySObhuZCbZGZYhEiFzUojEzXk68W3JTalTjT5qZXTs1ZXELmdwhGymweruIQkpYeO61IPwVbfYkjg8xfbQrWmI2v3gja8KyDTvctjxdwYzhM03waQcJqVGOSHLlk7peixics2/pGJlV9h2ZVjDeqKiR90vK7YtI8lxkiAuqe2Mo=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB5335.namprd04.prod.outlook.com (20.178.50.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Wed, 4 Sep 2019 08:42:31 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::50cc:80d2:5c1b:3a10]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::50cc:80d2:5c1b:3a10%5]) with mapi id 15.20.2241.014; Wed, 4 Sep 2019
 08:42:31 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 4/7] block: Improve default elevator selection
Thread-Topic: [PATCH v2 4/7] block: Improve default elevator selection
Thread-Index: AQHVXUh93Bmt9Uwsr02RhmqSqJsyNqcZsJUAgAGONwA=
Date:   Wed, 4 Sep 2019 08:42:30 +0000
Message-ID: <28b3f81d0c781b2375c7e601c8772e99fbe54663.camel@wdc.com>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
         <20190828022947.23364-5-damien.lemoal@wdc.com>
         <20190903085712.GD23783@infradead.org>
In-Reply-To: <20190903085712.GD23783@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3224974-acb2-442d-d641-08d73113d304
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5335;
x-ms-traffictypediagnostic: BYAPR04MB5335:
x-microsoft-antispam-prvs: <BYAPR04MB533538EC3B5C91055DBF565DE7B80@BYAPR04MB5335.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(199004)(189003)(25786009)(305945005)(26005)(6246003)(76176011)(66946007)(7736002)(66476007)(76116006)(66556008)(4326008)(2906002)(5640700003)(6506007)(64756008)(66446008)(118296001)(256004)(81156014)(66066001)(71200400001)(8936002)(53936002)(71190400001)(6436002)(14454004)(1730700003)(102836004)(8676002)(6512007)(186003)(2351001)(81166006)(3846002)(11346002)(58126008)(476003)(2616005)(316002)(6486002)(446003)(6116002)(5660300002)(54906003)(229853002)(91956017)(486006)(6916009)(478600001)(86362001)(99286004)(36756003)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5335;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: s3QVIxMHiCSoen2npmSGxNf9x/1Mw6edflrCLYpVx5MfE/jiS7c2LQhKh+7VJGV+FDCCmgjo0gJpcF5cCr539K2qiXHSB5gUptP+FcEgUXQnRZzyC/iqzQHxM7zsYTyKQo/int3zoRXrCGoCjzKqfPuOg5l51JVFJNAW+ECEeWQXEmc9+tkmlhD9ietg3szzhZUnDLww6qz8sm7a3RFu9xzj43+X8oi9ctiXTzI4z5ugcJhRrxcBHKg+ia/EGEUoFbfXsRWOpjckU4AOJLd7Jnvs2WRMTSbDxaFPEUid9kYkf30Mk+3OvMiGN1q5m3UkO1Jmwo8B0vFsiNHyXPP2jrr0uNf2d1JgUAL13aF3SudiNEx8h+j40Gk6TmygKtJcQIBpcP++n3dEoPMGKD+EpE6y6EXL7z/1cTImooKBhm0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5047B52CF7E45F409F8B733B57E8386A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3224974-acb2-442d-d641-08d73113d304
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 08:42:30.8624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pdXdraeQIu86Nzpat5gFtUoGGeM9jOfZpYCYx85Zp1cOmD4WTQczCe9sjtU8D9RlEqkHkdU2rJ31hZ45JA3Rqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5335
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE5LTA5LTAzIGF0IDAxOjU3IC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gT24gV2VkLCBBdWcgMjgsIDIwMTkgYXQgMTE6Mjk6NDRBTSArMDkwMCwgRGFtaWVuIExl
IE1vYWwgd3JvdGU6DQo+ID4gRm9yIGJsb2NrIGRldmljZXMgdGhhdCBkbyBub3Qgc3BlY2lmeSBy
ZXF1aXJlZCBmZWF0dXJlcywgcHJlc2VydmUgdGhlDQo+ID4gY3VycmVudCBkZWZhdWx0IGVsZXZh
dG9yIHNlbGVjdGlvbiAobXEtZGVhZGxpbmUgZm9yIHNpbmdsZSBxdWV1ZQ0KPiA+IGRldmljZXMs
IG5vbmUgZm9yIG11bHRpLXF1ZXVlIGRldmljZXMpLiBIb3dldmVyLCBmb3IgZGV2aWNlcyBzcGVj
aWZ5aW5nDQo+ID4gcmVxdWlyZWQgZmVhdHVyZXMgKGUuZy4gem9uZWQgYmxvY2sgZGV2aWNlcyBF
TEVWQVRPUl9GX1pCRF9TRVFfV1JJVEUNCj4gPiBmZWF0dXJlKSwgc2VsZWN0IHRoZSBmaXJzdCBh
dmFpbGFibGUgZWxldmF0b3IgcHJvdmlkaW5nIHRoZSByZXF1aXJlZA0KPiA+IGZlYXR1cmVzLg0K
PiA+IA0KPiA+IEluIGFsbCBjYXNlcywgZGVmYXVsdCB0byAibm9uZSIgaWYgbm8gZWxldmF0b3Ig
aXMgYXZhaWxhYmxlIG9yIGlmIHRoZQ0KPiA+IGluaXRpYWxpemF0aW9uIG9mIHRoZSBkZWZhdWx0
IGVsZXZhdG9yIGZhaWxzLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IERhbWllbiBMZSBNb2Fs
IDxkYW1pZW4ubGVtb2FsQHdkYy5jb20+DQo+IA0KPiBMb29rcyBnb29kLA0KPiANCj4gUmV2aWV3
ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KDQpUaGFua3MsIGJ1dCBJIG5l
ZWQgdG8gZml4IHRoaXMgcGF0Y2ggdG9vLg0KVGhlICJpZiAocS0+bnJfaHdfcXVldWVzICE9IDEp
IiBhdCB0aGUgYmVnaW5uaW5nIG9mIGVsZXZhdG9yX2luaXRfbXEoKQ0KbXVzdCBiZSByZW1vdmVk
Lg0KDQpJIGFtIHNlbmRpbmcgYSB2MyB3aXRoIHRoaXMgZml4IGFuZCBhIG1vZGlmaWVkIHBhdGNo
IDUgdG8gY2FsbA0KZWxldmF0b3JfaW5pdF9tcSgpIGVhcmxpZXIgaW4gZGV2aWNlX2FkZF9kaXNr
KCkuDQoNCi0tIA0KRGFtaWVuIExlIE1vYWwNCldlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaA0K
