Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE84C47420
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 16:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E75E2360D
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 16:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="lsw2BZl1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfKMQDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 11:03:17 -0500
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:35200
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726074AbfKMQDR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 11:03:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5Mlx09zs4huDh9ndwwtNOUa4mN34DXKt0dqB+rLwZMTZIfjzmVREWj5V/qt6PlOWJO7ZeG7va9rmb0a9w8LxJAfRhNbuYdKCDe0dkvWpLwpBz4fTFqVD3NAdpPSUdC1yMTxxW2mNVsyu2caWYcPTwBWIhNwnmK/0u1we2wdYSZ+8tqbWl9ca/pDLVIiPRv07t7Bvb5tXpnG7p55UhL0YxZB/ZhWCP8X8EnsNKlNIo2WkRsPj+jM9PAO6LZjSf8ghQqF8r/5zcGf+z/Iy0u+a5merRAoZQ1KBj4VBUswFICq4ZAMUXeUaeLwRNreP2nJrvvmHTMq8resW5xm0EFSUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6csCuIyWvmebRlAySy4NLHUw3M+IlJ3vy+40zbRbm8=;
 b=CLNEBVU2zHwBKiPpudRy7R9LBWZ/n1lH+9e2fL/2rqavCKd6fhw+uT33kXTxgYMCorf1qxfwGdVFmjmuY3WtR25swG77hYgwuiAnK2Qyy2x5hyym8DhXXmHd4gHez66PJ/uWobex5CWozkh+IekA4QDXv3vDd07Uq3e5kndtC2FDrzzmmNZxTn5lod3pHBXYvG05lKysT4vdDUpiGwft78YX5x4q1vzIurtWUxNCoeFMRkBpCYV14TA+huws3GSKJs25IwUdFnHFMExeW8VTnQYlZzsOoAa+7EZl0aGVCFavXnK1Ts6yRitz+sQ/zA7u2qrwanEckkUlXgHON80h/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6csCuIyWvmebRlAySy4NLHUw3M+IlJ3vy+40zbRbm8=;
 b=lsw2BZl1tBfUILvvzUibDPZtmPBzEfWC21xM+fSwK2dhqq6qJ9sNLEa4r+gZSygs0dhrqWKFTMpGsWySIQ4CqrnZNqNYQJotlJ4PhvSfUbANGjIPya5AOLYjXZQIccsw4G/7p6gAHdDU028yAcR5aqW3jRxiyu/oyyfQNGmRe6Y=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4370.namprd08.prod.outlook.com (52.133.222.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Wed, 13 Nov 2019 16:03:14 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 16:03:14 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
Thread-Topic: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
Thread-Index: AQHVmbbq0caA6FeHLU2T21+Cm3JzCqeIRsoAgADnnbA=
Date:   Wed, 13 Nov 2019 16:03:14 +0000
Message-ID: <BN7PR08MB56843E1941F42BEF8239B895DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
 <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
 <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
In-Reply-To: <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTE2YmNhZTRlLTA2MmYtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwxNmJjYWU0Zi0wNjJmLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjIwMzkiIHQ9IjEzMjE4MTM0NTkxMzY0NTQzMyIgaD0iMHNXVWhmN2d1eThESG1FaDZzcVhuL1hCYTdrPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4964514-1f6c-431f-413b-08d76852fd59
x-ms-traffictypediagnostic: BN7PR08MB4370:|BN7PR08MB4370:|BN7PR08MB4370:
x-microsoft-antispam-prvs: <BN7PR08MB43709689BA7CF8A7A66C2413DB760@BN7PR08MB4370.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(13464003)(199004)(189003)(110136005)(5660300002)(2501003)(71200400001)(5024004)(486006)(2906002)(14444005)(6506007)(102836004)(26005)(53546011)(446003)(256004)(7416002)(71190400001)(6116002)(476003)(76176011)(74316002)(25786009)(11346002)(3846002)(7696005)(229853002)(54906003)(7736002)(305945005)(8936002)(316002)(81156014)(81166006)(76116006)(8676002)(33656002)(86362001)(66476007)(66556008)(478600001)(14454004)(99286004)(55016002)(66946007)(66446008)(64756008)(4001150100001)(9686003)(66066001)(6436002)(52536014)(6246003)(4326008)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4370;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WgxBz+AYQ4HKLnDmL8txHazZyctPmHsOUbKHRXQHodRC4vz8/BE8xG3Bl1Kz1SNqHsQfQWDeZ2Bk/RisGsj5xGnqMPOmNuEug8nqHNSSAc/xju0XOUqCVXmFMDto9m+2bg9/WkuZemsl2v3j+yaOhgO2IQQPTzKwImxm5hv9HkBegOiLuPaYq1OPmoGDQm2KaEDkPjXhv6jlp+jsK8cbDPIJpzcluYQ1+9aVy3eFeod29tqoRYMixkk5xbxJXuYhaPL43drzWSh9a5dRZYFjcH4ZXmi8/mDPGNy1zTgQv60eFpMrZn6hwAGh0wyndsQF6202apW+POSJuO+5gFZpJG01gj6L0JdKECgTfcxH5wqc4Bk2HGEO3FbUXh5jqpsSflilmQ6lrwauHG6OuSbd1x9idbdYlk4PUlggXEQiL6BlUMmu89EBA+0eCxOpD6FL
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4964514-1f6c-431f-413b-08d76852fd59
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 16:03:14.0796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x7H5kfuVKUeXwBiJVXSlLTx35UYXu9gXpSNyhWSGRmlb4WAEWgyAiD3/rkdDhGAq7ORaWzs9vHOEjPk7Dh66jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4370
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJhcnQNCg0KSSB0aGluaywgeW91IGFyZSBhc2tpbmcgZm9yIGNvbW1lbnQgZnJvbSBDYW4u
ICBBcyBmb3IgbWUsIGF0dGFjaGVkIHBhdGNoIGlzIGJldHRlci4gDQpSZW1vdmluZyB1ZnNoY2Rf
d2FpdF9mb3JfZG9vcmJlbGxfY2xyKCksIGluc3RlYWQgb2YgcmVhZGluZyBkb29yYmVsbCByZWdp
c3RlciwgTm93DQp1c2luZyBibG9jayBsYXllciBibGtfbXFfe3VuLH1mcmVlemVfcXVldWUoKSwg
bG9va3MgZ29vZC4gSSB0ZXN0ZWQgeW91ciBWNSBwYXRjaGVzLA0KZGlkbid0IGZpbmQgcHJvYmxl
bSB5ZXQuDQoNClNpbmNlIG15IGF2YWlsYWJsZSBwbGF0Zm9ybSBkb2Vzbid0IHN1cHBvcnQgZHlu
YW1pYyBjbGsgc2NhbGluZywgSSB0aGluaywgbm93IHNlZW1zIG9ubHkNClFjb20gVUZTIGNvbnRy
b2xsZXJzIHN1cHBvcnQgdGhpcyBmZWF0dXJlLiBTbyB3ZSBuZWVkIENhbiBHdW8gdG8gZmluYWxs
eSBjb25maXJtIGl0Lg0KDQpUaGFua3MsDQoNCi8vQmVhbg0KDQogICAgDQoNCj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFj
bS5vcmc+DQo+IFNlbnQ6IFdlZG5lc2RheSwgTm92ZW1iZXIgMTMsIDIwMTkgMTo1NiBBTQ0KPiBU
bzogY2FuZ0Bjb2RlYXVyb3JhLm9yZw0KPiBDYzogTWFydGluIEsgLiBQZXRlcnNlbiA8bWFydGlu
LnBldGVyc2VuQG9yYWNsZS5jb20+OyBKYW1lcyBFIC4gSiAuIEJvdHRvbWxleQ0KPiA8amVqYkBs
aW51eC52bmV0LmlibS5jb20+OyBCZWFuIEh1byAoYmVhbmh1bykgPGJlYW5odW9AbWljcm9uLmNv
bT47IEF2cmkNCj4gQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPjsgQXN1dG9zaCBEYXMgPGFz
dXRvc2hkQGNvZGVhdXJvcmEub3JnPjsNCj4gVmlnbmVzaCBSYWdoYXZlbmRyYSA8dmlnbmVzaHJA
dGkuY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IFN0YW5sZXkNCj4gQ2h1IDxzdGFu
bGV5LmNodUBtZWRpYXRlay5jb20+OyBUb21hcyBXaW5rbGVyIDx0b21hcy53aW5rbGVyQGludGVs
LmNvbT4NCj4gU3ViamVjdDogW0VYVF0gUmU6IFtQQVRDSCB2NSA0LzRdIHVmczogU2ltcGxpZnkg
dGhlIGNsb2NrIHNjYWxpbmcgbWVjaGFuaXNtDQo+IGltcGxlbWVudGF0aW9uDQo+IA0KPiBPbiAx
MS8xMi8xOSA0OjExIFBNLCBjYW5nQGNvZGVhdXJvcmEub3JnIHdyb3RlOg0KPiA+IE9uIDIwMTkt
MTEtMTMgMDE6MzcsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPj4gQEAgLTE1MjgsNyArMTQ5
Miw3IEBAIGludCB1ZnNoY2RfaG9sZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sDQo+ID4+IGFz
eW5jKQ0KPiA+PiDCoMKgwqDCoMKgwqDCoMKgwqAgKi8NCj4gPj4gwqDCoMKgwqDCoMKgwqDCoCAv
KiBmYWxsdGhyb3VnaCAqLw0KPiA+PiDCoMKgwqDCoCBjYXNlIENMS1NfT0ZGOg0KPiA+PiAtwqDC
oMKgwqDCoMKgwqAgdWZzaGNkX3Njc2lfYmxvY2tfcmVxdWVzdHMoaGJhKTsNCj4gPj4gK8KgwqDC
oMKgwqDCoMKgIHVmc2hjZF9ibG9ja19yZXF1ZXN0cyhoYmEsIFVMT05HX01BWCk7DQo+ID4NCj4g
PiB1ZnNoY2RfaG9sZChhc3luYyA9PSB0cnVlKSBpcyB1c2VkIGluIHVmc2hjZF9xdWV1ZWNvbW1h
bmQoKSBwYXRoDQo+ID4gYmVjYXVzZQ0KPiA+IHVmc2hjZF9xdWV1ZWNvbW1hbmQoKSBjYW4gYmUg
ZW50ZXJlZCB1bmRlciBhdG9taWMgY29udGV4dHMuDQo+ID4gVGh1cyB1ZnNoY2RfYmxvY2tfcmVx
dWVzdHMoKSBoZXJlIGhhcyB0aGUgc2FtZSByaXNrIGNhdXNpbmcgc2NoZWR1bGluZw0KPiA+IHdo
aWxlIGF0b21pYy4NCj4gPiBGWUksIGl0IGlzIG5vdCBlYXN5IHRvIGhpdCBhYm92ZSBzY2VuYXJp
byBpbiBzbWFsbCBzY2FsZSBvZiB0ZXN0Lg0KPiANCj4gSGkgQmVhbiwNCj4gDQo+IEhvdyBhYm91
dCByZXBsYWNpbmcgcGF0Y2ggNC80IHdpdGggdGhlIGF0dGFjaGVkIHBhdGNoPw0KPiANCj4gVGhh
bmtzLA0KPiANCj4gQmFydC4NCg0K
