Return-Path: <SRS0=NWCA=WH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68A3C433FF
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Aug 2019 17:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D7022087B
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Aug 2019 17:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mYHQuGVh";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OA09VyM5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfHKRtQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Aug 2019 13:49:16 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:14699 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHKRtQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Aug 2019 13:49:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565545755; x=1597081755;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JvD10yepdaeTCPjDH82sOnyPBDyxoUcenH4xTriDB/w=;
  b=mYHQuGVhHz/EkifJob/5iCirZn/5W/IAOKGm4CGTly1ASutQ2APViDLn
   C9Y8l8zLgGPGQOz0cIFACRoNHKCBZZbxXh84zB522ZnQ05Msf5izMuGIs
   Ny2YywnPlpxgLNIeFaahWnrLzhkCPO6qDqaZAuMFyfGJZCgXTYRaiG2ws
   0MCy0TMpbuFSMI4VEecxmzpnyPjJGDPb5QEdHc0W9jA07RsJ7VJcBC8Ag
   oqOQkXAsRes4Z9Mu9DfRih3wzKNttIXaVrgGgNvh49nNghpD2t1k9ZSvL
   sSbQCOwBueBII/6QWbKn9c3IqfuaJH7Q0SVfFFl9NF8qB6vLvrBGxqjfB
   w==;
IronPort-SDR: nvkPrSnSC+/GFglFhzuOTNaKFMSwRI/KL2+VqjRTU0gq20eubaxyymBlkewEB0LWP+jIIAvdKo
 QGKyhLYivKjOoUV3OzhKW0igCD+daTlN/cyGqTxyjSIHkUU29Jw7IhkxfMGZw2ORYrmUeni3c2
 vkopVgyFH/TGDgfXWBsI4GDSEbWiZLK2nlnMZSNYsc+sNkIR93wm4rjqMEDGYl2r465pTFRaCe
 L87yplcZ9aesJl7lEWiX4AsVHAALsjC3+xHOIsEVGfwTihOQxcVyJrnvwpvwkcoUsHd8mdqB+8
 o9s=
X-IronPort-AV: E=Sophos;i="5.64,374,1559491200"; 
   d="scan'208";a="117194545"
Received: from mail-by2nam01lp2052.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.52])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2019 01:49:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xhf5Q2jppe9nvCR/8wSKzCPzaQANgEehaqekcQXV8j+TLzd7YS+UIsi4dUeyX0wNCJMW6G2C1CXMQ0MttPfY9F89mgDwgmLIpjkRdszEypJcXFMeVeRDXOl/dTwoITJeg5AHOlbMNx4uOB7Wlle23tBu+kpJi05P63qYUEP5De8O4JjEBN0+PF0T5tOZb76uC9yKtuGOiAWQT1I07Gb8jOwA4RZHHT8UVF9a1aV9mrw0BmWfi01BsVzHtniW/r9G3HqO7Sxv7UZluOrcgrXP948Q/IgKqfh9hFefu/TB3rNzzr8CH+i2+K6582+4NETB+TSV/H6JFKPi431xYmWaow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvD10yepdaeTCPjDH82sOnyPBDyxoUcenH4xTriDB/w=;
 b=Z+s/Ui4Cih7ewcroXvbBOLnAXlS+fdELylgvgKwvWCG8cr6+hyEiP67pqIZ0iLFtasYjiCNc76+U2ybBE7JHFHnAOW38GBrYi6Br+KguslqNSxN9scBHjMXaVhHruMN7ieLtwy/XROmR+x4rkusfFx1iAyhu4RQNFsSx2bOwRg7Kq/0E9wdo2ZiPmTSJKCqtOfXT4TFE4kj+RbaC361hr7P8vI/IwZXBDNQcexQib2SpkCnvYFhtyUCOeWQbSRbcqQAqq8lrXQaNOBlJ0njdORwq4o7JwunhQSqQE3ovWDSeG6frg4OXI8RegaNK76aHm9iILM/ld5ScMcnl21Wj6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvD10yepdaeTCPjDH82sOnyPBDyxoUcenH4xTriDB/w=;
 b=OA09VyM5Oj3mMuXveCFuCdwbYiKlNxVWZyASU1Pa23lTL93EoiaMGN1Xtu75h+ORAEEUjb3+dS+6YQT+p1Mm5ZTEW2GGhfIRRgkBmNSOsqYkThuOxPzomYR4yXC+cMLCHNW9ggoNZ3DWMkYUYGF0l3ZwBi2JPp7199uTTl7WoQI=
Received: from CO2PR04MB2328.namprd04.prod.outlook.com (10.166.95.11) by
 CO2PR04MB2375.namprd04.prod.outlook.com (10.166.95.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Sun, 11 Aug 2019 17:49:12 +0000
Received: from CO2PR04MB2328.namprd04.prod.outlook.com
 ([fe80::71b9:3203:b291:c971]) by CO2PR04MB2328.namprd04.prod.outlook.com
 ([fe80::71b9:3203:b291:c971%5]) with mapi id 15.20.2157.022; Sun, 11 Aug 2019
 17:49:12 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "mchristi@redhat.com" <mchristi@redhat.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] tcmu: avoid use-after-free after command timeout
Thread-Topic: [PATCH] tcmu: avoid use-after-free after command timeout
Thread-Index: AQHVT8FBZT16wlmaNEKtmwwhbbU0zab1DsoAgAEr3YA=
Date:   Sun, 11 Aug 2019 17:49:12 +0000
Message-ID: <6e48f48fceea45e4649cc5cbeb7e59151748cc23.camel@wdc.com>
References: <20190810211903.6572-1-dmitry.fomichev@wdc.com>
         <5D4F598C.9000207@redhat.com>
In-Reply-To: <5D4F598C.9000207@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Dmitry.Fomichev@wdc.com; 
x-originating-ip: [199.255.45.64]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71ae6fb9-e1e4-48fc-2dba-08d71e843888
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CO2PR04MB2375;
x-ms-traffictypediagnostic: CO2PR04MB2375:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO2PR04MB2375DE6A74E14793785AD62DE1D00@CO2PR04MB2375.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(189003)(199004)(66556008)(53936002)(256004)(66476007)(8936002)(8676002)(81156014)(81166006)(14444005)(6116002)(66446008)(64756008)(4326008)(478600001)(76116006)(3846002)(6246003)(66946007)(25786009)(91956017)(99286004)(110136005)(118296001)(36756003)(66066001)(316002)(486006)(476003)(2616005)(446003)(2501003)(305945005)(11346002)(14454004)(26005)(2201001)(7736002)(186003)(76176011)(53546011)(102836004)(6506007)(86362001)(5660300002)(229853002)(6486002)(2906002)(6512007)(6436002)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO2PR04MB2375;H:CO2PR04MB2328.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xBzpoy6DnegAVrVcgcXj37Dua2X+L0S4pmmJNE9Ipl372d2UbN8oXbXSvlu0hPLTYpMW/xCTeud5ZB5ZR03CXgOXBOWE43Ij2vpFuIBf5nZClc8Mr/i+cc1Q8DcigChrYRUtPBhIyp3wHAhjS6Rd8ASXof3lqHnXqPasWAVxVDfPSYCrIWRBkXU4HCygeh0fLJTF1aXpsi1QR8FvyrEVr34VMY6lB5Z7pZWdk464tJadDEYq4KODyQcDvaaBJ+AWa74jCPtZ+2FICmxHVQcE1knPDahhI9i8JBYno93uN9W3vS/kL+wzZI/hrsNAtxm/3wbDG89WHETrh01L/oAV7/Gw4X0eRGQADIykRoyzUH07haWmwWCT786/qw1VOtoQFcGSEVnnmDZFmoYSnOkCZuMM94EDCUdafjMivRQYSNo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CEACD340F6FCA468300640612775BD4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ae6fb9-e1e4-48fc-2dba-08d71e843888
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 17:49:12.7190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 62zan3T4j1pzWhveCFz+vTBwOsffZwhX3RIfNXYzEh9E40vqg6QzypVwJlYjeb4/11XPFtMfMCUHiOxPPthV/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2375
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gU2F0LCAyMDE5LTA4LTEwIGF0IDE4OjU1IC0wNTAwLCBNaWtlIENocmlzdGllIHdyb3RlOg0K
PiBPbiAwOC8xMC8yMDE5IDA0OjE5IFBNLCBEbWl0cnkgRm9taWNoZXYgd3JvdGU6DQo+ID4gSW4g
dGNtdV9oYW5kbGVfY29tcGxldGlvbigpIGZ1bmN0aW9uLCB0aGUgdmFyaWFibGUgY2FsbGVkIHJl
YWRfbGVuIGlzDQo+ID4gYWx3YXlzIGluaXRpYWxpemVkIHdpdGggYSB2YWx1ZSB0YWtlbiBmcm9t
IHNlX2NtZCBzdHJ1Y3R1cmUuIElmIHRoaXMNCj4gPiBmdW5jdGlvbiBpcyBjYWxsZWQgdG8gY29t
cGxldGUgYW4gZXhwaXJlZCAodGltZWQgb3V0KSBvdXQgY29tbWFuZCwgdGhlDQo+ID4gc2Vzc2lv
biBjb21tYW5kIHBvaW50ZWQgYnkgc2VfY21kIGlzIGxpa2VseSB0byBiZSBhbHJlYWR5IGRlYWxs
b2NhdGVkIGJ5DQo+ID4gdGhlIHRhcmdldCBjb3JlIGF0IHRoYXQgbW9tZW50LiBBcyB0aGUgcmVz
dWx0LCB0aGlzIGFjY2VzcyB0cmlnZ2VycyBhDQo+ID4gdXNlLWFmdGVyLWZyZWUgd2FybmluZyBm
cm9tIEtBU0FOLg0KPiA+IA0KPiA+IFRoaXMgcGF0Y2ggZml4ZXMgdGhlIGNvZGUgbm90IHRvIHRv
dWNoIHNlX2NtZCB3aGVuIGNvbXBsZXRpbmcgdGltZWQgb3V0DQo+ID4gVENNVSBjb21tYW5kcy4g
SXQgYWxzbyByZXNldHMgdGhlIHBvaW50ZXIgdG8gc2VfY21kIGF0IHRoZSB0aW1lIHdoZW4gdGhl
DQo+ID4gVENNVV9DTURfQklUX0VYUElSRUQgZmxhZyBpcyBzZXQgYmVjYXVzZSBpdCBpcyBnb2lu
ZyB0byBiZWNvbWUgaW52YWxpZA0KPiA+IGFmdGVyIGNhbGxpbmcgdGFyZ2V0X2NvbXBsZXRlX2Nt
ZCgpIGxhdGVyIGluIHRoZSBzYW1lIGZ1bmN0aW9uLA0KPiA+IHRjbXVfY2hlY2tfZXhwaXJlZF9j
bWQoKS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBEbWl0cnkgRm9taWNoZXYgPGRtaXRyeS5m
b21pY2hldkB3ZGMuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3RhcmdldC90YXJnZXRfY29y
ZV91c2VyLmMgfCA4ICsrKysrKy0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0
L3RhcmdldF9jb3JlX3VzZXIuYyBiL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3VzZXIuYw0K
PiA+IGluZGV4IDA0ZWRhMTExOTIwZS4uYTAyMzE0OTFmYTM2IDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3VzZXIuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdGFyZ2V0
L3RhcmdldF9jb3JlX3VzZXIuYw0KPiA+IEBAIC0xMTMyLDE0ICsxMTMyLDE2IEBAIHN0YXRpYyB2
b2lkIHRjbXVfaGFuZGxlX2NvbXBsZXRpb24oc3RydWN0IHRjbXVfY21kICpjbWQsIHN0cnVjdCB0
Y211X2NtZF9lbnRyeSAqDQo+ID4gIAlzdHJ1Y3Qgc2VfY21kICpzZV9jbWQgPSBjbWQtPnNlX2Nt
ZDsNCj4gPiAgCXN0cnVjdCB0Y211X2RldiAqdWRldiA9IGNtZC0+dGNtdV9kZXY7DQo+ID4gIAli
b29sIHJlYWRfbGVuX3ZhbGlkID0gZmFsc2U7DQo+ID4gLQl1aW50MzJfdCByZWFkX2xlbiA9IHNl
X2NtZC0+ZGF0YV9sZW5ndGg7DQo+ID4gKwl1aW50MzJfdCByZWFkX2xlbjsNCj4gPiAgDQo+ID4g
IAkvKg0KPiA+ICAJICogY21kIGhhcyBiZWVuIGNvbXBsZXRlZCBhbHJlYWR5IGZyb20gdGltZW91
dCwganVzdCByZWNsYWltDQo+ID4gIAkgKiBkYXRhIGFyZWEgc3BhY2UgYW5kIGZyZWUgY21kDQo+
ID4gIAkgKi8NCj4gPiAtCWlmICh0ZXN0X2JpdChUQ01VX0NNRF9CSVRfRVhQSVJFRCwgJmNtZC0+
ZmxhZ3MpKQ0KPiA+ICsJaWYgKHRlc3RfYml0KFRDTVVfQ01EX0JJVF9FWFBJUkVELCAmY21kLT5m
bGFncykpIHsNCj4gPiArCQlXQVJOX09OX09OQ0Uoc2VfY21kKTsNCj4gDQo+IElmIHlvdSBhcmUg
YWRkaW5nIGEgd2FybiBoZXJlLCBJIHRoaW5rIHlvdSB3YW50IHRvIGFsc28gYWRkIGEgd2FybiBp
bg0KPiB0Y211X3Jlc2V0X3Jpbmcgd2hlcmUgdGhlcmUgaXMgYW5vdGhlciBjb2RlIHBhdGggd2Ug
ZG8gdGhlIHNhbWUgc2VxdWVuY2UNCj4gb2Ygb3BlcmF0aW9ucyB3aGVyZSB3ZSBjaGVjayB0aGUg
Yml0IHRoZW4gYWNjZXNzIHRoZSBzZV9jbWQgYWZ0ZXIgaWYgbm90DQo+IHNldC4NCj4gDQpNaWtl
LA0KR29vZCBwb2ludCwgdGhhbmtzLiBJIGFtIGdvaW5nIHRvIHNlbmQgb3V0IHRoZSB1cGRhdGVk
IHZlcnNpb24gb2YgdGhlIHBhdGNoLg0KDQpEbWl0cnkNCg==
