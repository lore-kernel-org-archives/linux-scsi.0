Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300DBC432C1
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 00:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4C7A214DA
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 00:57:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Bla5le0H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503349AbfIXA5o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 20:57:44 -0400
Received: from mail-eopbgr700127.outbound.protection.outlook.com ([40.107.70.127]:4705
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2503074AbfIXA5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Sep 2019 20:57:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHdcWkrh4VxjMoyzO1iOn5VLHgpWOjelqG0aHLFRpAM54IImNxxKPFYjHwxe/iKJ+quIiiqJJyd5H+lhktQEGXbSvLFVqIXDtMSO5rJDTXQ2qrRtHxNq76FfcZe6wX8l1MDzkTEnlyOpgPfmpBRNx3ozvqcR8huy0IC3+jCuH4k8AJj8J+BVr/18U90PgR1YZtPopt1rku4qd+CDwzumxEfsXSgXohyEhuMvaDp0miSLiUSTmSNm1r8pQ6QYC8F+3IkyOS6GsqlgkS2b43TxRKvzrfXxr5MzyN98Hc5RAEa6UcibceH3Z0JvZxA3BtUY/dM6b5dtR641gVuSR70E7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnycEY/HLyGt415GKKJFSZrGA9g2n+L74MwJD3ERXU8=;
 b=d5J11PukYrPdCAS3hSKQc+rhLPLAw7pYn+oWcVWXutaCoe8N4KAobrJi5wuiFG9cbudM8kLKX1+DLTxNju93AEN+qEVH7O5+LNZvhRvS5Jk1LFqvYJcpnoRdr6Ct0pIvwEdKpLtQN0vtdF8MIxj8PoMimhg9FxE6EAfj8uZJLis7390jrXxODVd9ZKQJUysxosZxTAswxmq/CRsuVe2IXBkm7QKhEyUec0dqybJKyr8dT/9d+wwn/Y4uxrw0W+0++TzIRfwvJEq+nEjCXefgqKwVSQ0fegL8SEJ95Pio5q4ElkwXHSteQ7ijSEgMKT1SVrGBrYppsJA2yHFG7MsaQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnycEY/HLyGt415GKKJFSZrGA9g2n+L74MwJD3ERXU8=;
 b=Bla5le0HVzgjvaNacfzjJGIYDSFkXWPq5DvJeOmL3i2JhV+IlPdgzBlsLgeNMc3VP4pea0u5dO0feBPBdrMeSWXEzHZy0Uyn9Pn0L9vimMZTEJf5PQ7VhUmPMBPzYUw1ltngd/RayNxuVd9ImoDq5YMXNEUqB/v/7tIwUeEWdw4=
Received: from CY4PR21MB0741.namprd21.prod.outlook.com (10.173.189.7) by
 CY4PR21MB0840.namprd21.prod.outlook.com (10.173.192.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.5; Tue, 24 Sep 2019 00:57:39 +0000
Received: from CY4PR21MB0741.namprd21.prod.outlook.com
 ([fe80::c8f4:597b:9f3a:9fd]) by CY4PR21MB0741.namprd21.prod.outlook.com
 ([fe80::c8f4:597b:9f3a:9fd%2]) with mapi id 15.20.2327.004; Tue, 24 Sep 2019
 00:57:39 +0000
From:   Long Li <longli@microsoft.com>
To:     Sagi Grimberg <sagi@grimberg.me>, Ming Lei <ming.lei@redhat.com>
CC:     Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <keith.busch@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Thread-Topic: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Thread-Index: AQHVXLUAoNqN0R8TLUadmsLcmKb6xacPEcMAgACKtgCAAAMjAIAAyEgAgAAEnwCAAClMgIAABJWAgAi79gCAACnHgIAACOEAgAACjoCAAA16gIAABfMAgAIuJgCAAAa1AIABBRqAgAAZZYCAAP6SgIAAOYeAgADemICAAFw4gIAE69SAgAxPKbCABFQsgIAAHz9ggAAbnACABN7PcA==
Date:   Tue, 24 Sep 2019 00:57:39 +0000
Message-ID: <CY4PR21MB0741BC9992A7A945A0D4A62CCE840@CY4PR21MB0741.namprd21.prod.outlook.com>
References: <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <20190906014819.GB27116@ming.t460p>
 <ffefcfa0-09b6-9af5-f94e-8e7ddd2eef16@linaro.org>
 <6eb2a745-7b92-73ce-46f5-cc6a5ef08abc@grimberg.me>
 <20190907000100.GC12290@ming.t460p>
 <f5685543-8cd5-6c6a-5b80-c77ef09c6b3b@grimberg.me>
 <CY4PR21MB0741838CE0C9D52556AA4558CE8E0@CY4PR21MB0741.namprd21.prod.outlook.com>
 <30dc6fa9-ea5e-50d6-56f9-fbc9627d8c29@grimberg.me>
 <CY4PR21MB074168DE7729C131CE4394CCCE880@CY4PR21MB0741.namprd21.prod.outlook.com>
 <100d001a-1dda-32ff-fa5e-c18b121444d9@grimberg.me>
In-Reply-To: <100d001a-1dda-32ff-fa5e-c18b121444d9@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-originating-ip: [2001:4898:80e8:a:ede4:db5c:c6fe:798]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a3a52af-902b-406b-c7ed-08d7408a32ab
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR21MB0840;
x-ms-traffictypediagnostic: CY4PR21MB0840:
x-microsoft-antispam-prvs: <CY4PR21MB084093C08DA217D6BFDA5FBCCE840@CY4PR21MB0840.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(199004)(189003)(51914003)(55016002)(6116002)(74316002)(316002)(10290500003)(305945005)(66446008)(7696005)(71200400001)(76176011)(8990500004)(7416002)(446003)(76116006)(66476007)(86362001)(25786009)(6246003)(186003)(11346002)(52536014)(229853002)(10090500001)(486006)(66556008)(9686003)(71190400001)(81156014)(7736002)(14454004)(66946007)(46003)(8676002)(33656002)(2906002)(4326008)(110136005)(476003)(22452003)(5660300002)(8936002)(14444005)(99286004)(6506007)(81166006)(102836004)(256004)(54906003)(478600001)(64756008)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0840;H:CY4PR21MB0741.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zBRd6msD0toPulnkONop2wDzFjlolbDkBY3N1XZENOAFir+SYpGYDxfVVRpsqLqg6C+5d02tUXRKHkkQC0Z60x2i9P3KMbJN5co8qAqRAGRuewR418aNoIE1NGpp0ZONDUHDenU6peQxTu94rwdDaUT7ETAd8HyImErYhcvxit1iEdR3pmjskgVDW1smCVml5fq7T3NL7Hiq2KGv1mXSVUqeDaCQWyGNEbU09hF/7jVY3PhVvSiOSypTiaC2I4OhCv1V19FOU8WW2SZoCEPF0HUf6EKc+wLq7BSvyLXLeKrt9LiPN14JX3wa0CiBjrHqx421qimT7e8ABXvAZrlugbMDZbAdN4z1NIIxvH9A+g2Ou0tUcqpcue9De8wL1h7aAx34WxVuDLaxe3UwsK2S/qGgDBgyJh/fTnIKyE9evWI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3a52af-902b-406b-c7ed-08d7408a32ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 00:57:39.4980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IbzsxctKFkAuJSTeNsET9d3i+5LmAMjzWCHKN/Bnj60+X2PCyvgdxEpxAX0fTuTzXeu/+3MSyaN59s7Pod9kSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0840
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PlRoYW5rcyBmb3IgdGhlIGNsYXJpZmljYXRpb24uDQo+DQo+VGhlIHByb2JsZW0gd2l0aCB3aGF0
IE1pbmcgaXMgcHJvcG9zaW5nIGluIG15IG1pbmQgKGFuZCBpdHMgYW4gZXhpc3RpbmcNCj5wcm9i
bGVtIHRoYXQgZXhpc3RzIHRvZGF5KSwgaXMgdGhhdCBudm1lIGlzIHRha2luZyBwcmVjZWRlbmNl
IG92ZXIgYW55dGhpbmcNCj5lbHNlIHVudGlsIGl0IGFic29sdXRlbHkgY2Fubm90IGhvZyB0aGUg
Y3B1IGluIGhhcmRpcnEuDQo+DQo+SW4gdGhlIHRocmVhZCBNaW5nIHJlZmVyZW5jZWQgYSBjYXNl
IHdoZXJlIHRvZGF5IGlmIHRoZSBjcHUgY29yZSBoYXMgYSBuZXQNCj5zb2Z0aXJxIGFjdGl2aXR5
IGl0IGNhbm5vdCBtYWtlIGZvcndhcmQgcHJvZ3Jlc3MuIFNvIHdpdGggTWluZydzIHN1Z2dlc3Rp
b24sDQo+bmV0IHNvZnRpcnEgd2lsbCBldmVudHVhbGx5IG1ha2UgcHJvZ3Jlc3MsIGJ1dCBpdCBj
cmVhdGVzIGFuIGluaGVyZW50IGZhaXJuZXNzDQo+aXNzdWUuIFdobyBzYWlkIHRoYXQgbnZtZSBj
b21wbGV0aW9ucyBzaG91bGQgY29tZSBmYXN0ZXIgdGhlbiB0aGUgbmV0IHJ4L3R4DQo+b3IgYW5v
dGhlciBJL08gZGV2aWNlIChvciBocnRpbWVycyBvciBzY2hlZCBldmVudHMuLi4pPw0KPg0KPkFz
IG11Y2ggYXMgSSdkIGxpa2UgbnZtZSB0byBjb21wbGV0ZSBhcyBzb29uIGFzIHBvc3NpYmxlLCBJ
IG1pZ2h0IGhhdmUgb3RoZXINCj5hY3Rpdml0aWVzIGluIHRoZSBzeXN0ZW0gdGhhdCBhcmUgYXMg
aW1wb3J0YW50IGlmIG5vdCBtb3JlLiBTbyBJIGRvbid0IHRoaW5rIHdlDQo+Y2FuIHNvbHZlIHRo
aXMgd2l0aCBzb21ldGhpbmcgdGhhdCBpcyBub3QgY29vcGVyYXRpdmUgb3IgZmFpciB3aXRoIHRo
ZSByZXN0IG9mDQo+dGhlIHN5c3RlbS4NCj4NCj4+PiBJZiB3ZSBhcmUgY29udGV4dCBzd2l0Y2hp
bmcgdG9vIG11Y2gsIGl0IG1lYW5zIHRoZSBzb2Z0LWlycSBvcGVyYXRpb24NCj4+PiBpcyBub3Qg
ZWZmaWNpZW50LCBub3QgbmVjZXNzYXJpbHkgdGhlIGZhY3QgdGhhdCB0aGUgY29tcGxldGlvbiBw
YXRoDQo+Pj4gaXMgcnVubmluZyBpbiBzb2Z0LSBpcnEuLg0KPj4+DQo+Pj4gSXMgeW91ciBrZXJu
ZWwgY29tcGlsZWQgd2l0aCBmdWxsIHByZWVtcHRpb24gb3Igdm9sdW50YXJ5IHByZWVtcHRpb24/
DQo+Pg0KPj4gVGhlIHRlc3RzIGFyZSBiYXNlZCBvbiBVYnVudHUgMTguMDQga2VybmVsIGNvbmZp
Z3VyYXRpb24uIEhlcmUgYXJlIHRoZQ0KPnBhcmFtZXRlcnM6DQo+Pg0KPj4gIyBDT05GSUdfUFJF
RU1QVF9OT05FIGlzIG5vdCBzZXQNCj4+IENPTkZJR19QUkVFTVBUX1ZPTFVOVEFSWT15DQo+PiAj
IENPTkZJR19QUkVFTVBUIGlzIG5vdCBzZXQNCj4NCj5JIHNlZSwgc28gaXQgc3RpbGwgc2VlbXMg
dGhhdCBpcnFfcG9sbF9zb2Z0aXJxIGlzIHN0aWxsIG5vdCBlZmZpY2llbnQgaW4gcmVhcGluZw0K
PmNvbXBsZXRpb25zLiByZWFwaW5nIHRoZSBjb21wbGV0aW9ucyBvbiBpdHMgb3duIGlzIHByZXR0
eSBtdWNoIHRoZSBzYW1lIGluDQo+aGFyZCBhbmQgc29mdCBpcnEsIHNvIGl0cyByZWFsbHkgdGhl
IHNjaGVkdWxpbmcgcGFydCB0aGF0IGlzIGNyZWF0aW5nIHRoZSBvdmVyaGVhZA0KPih3aGljaCBk
b2VzIG5vdCBleGlzdCBpbiBoYXJkIGlycSkuDQo+DQo+UXVlc3Rpb246DQo+d2hlbiB5b3UgdGVz
dCB3aXRoIHdpdGhvdXQgdGhlIHBhdGNoIChjb21wbGV0aW9ucyBhcmUgY29taW5nIGluIGhhcmQt
aXJxKSwNCj5kbyB0aGUgZmlvIHRocmVhZHMgdGhhdCBydW4gb24gdGhlIGNwdSBjb3JlcyB0aGF0
IGFyZSBhc3NpZ25lZCB0byB0aGUgY29yZXMgdGhhdA0KPmFyZSBoYW5kbGluZyBpbnRlcnJ1cHRz
IGdldCBzdWJzdGFudGlhbGx5IGxvd2VyIHRocm91Z2hwdXQgdGhhbiB0aGUgcmVzdCBvZiB0aGUN
Cj5maW8gdGhyZWFkcz8gSSB3b3VsZCBleHBlY3QgdGhhdCB0aGUgZmlvIHRocmVhZHMgdGhhdCBh
cmUgcnVubmluZyBvbiB0aGUgZmlyc3QgMzINCj5jb3JlcyB0byBnZXQgdmVyeSBsb3cgaW9wcyAo
b3ZlcnBvd2VyZWQgYnkgdGhlIG52bWUgaW50ZXJydXB0cykgYW5kIHRoZSByZXN0DQo+ZG9pbmcg
bXVjaCBtb3JlIGdpdmVuIHRoYXQgbnZtZSBoYXMgYWxtb3N0IG5vIGxpbWl0cyB0byBob3cgbXVj
aCB0aW1lIGl0DQo+Y2FuIHNwZW5kIG9uIHByb2Nlc3NpbmcgY29tcGxldGlvbnMuDQo+DQo+SWYg
bmVlZF9yZXNjaGVkKCkgaXMgY2F1c2luZyB1cyB0byBjb250ZXh0IHN3aXRjaCB0b28gYWdncmVz
c2l2ZWx5LCBkb2VzDQo+Y2hhbmdpbmcgdGhhdCB0byBsb2NhbF9zb2Z0aXJxX3BlbmRpbmcoKSBt
YWtlIHRoaW5ncyBiZXR0ZXI/DQo+LS0NCj5kaWZmIC0tZ2l0IGEvbGliL2lycV9wb2xsLmMgYi9s
aWIvaXJxX3BvbGwuYyBpbmRleCBkOGVhYjU2M2ZhNzcuLjA1ZDUyNGZjYWYwNA0KPjEwMDY0NA0K
Pi0tLSBhL2xpYi9pcnFfcG9sbC5jDQo+KysrIGIvbGliL2lycV9wb2xsLmMNCj5AQCAtMTE2LDcg
KzExNiw3IEBAIHN0YXRpYyB2b2lkIF9fbGF0ZW50X2VudHJvcHkgaXJxX3BvbGxfc29mdGlycShz
dHJ1Y3QNCj5zb2Z0aXJxX2FjdGlvbiAqaCkNCj4gICAgICAgICAgICAgICAgIC8qDQo+ICAgICAg
ICAgICAgICAgICAgKiBJZiBzb2Z0aXJxIHdpbmRvdyBpcyBleGhhdXN0ZWQgdGhlbiBwdW50Lg0K
PiAgICAgICAgICAgICAgICAgICovDQo+LSAgICAgICAgICAgICAgIGlmIChuZWVkX3Jlc2NoZWQo
KSkNCj4rICAgICAgICAgICAgICAgaWYgKGxvY2FsX3NvZnRpcnFfcGVuZGluZygpKQ0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4gICAgICAgICB9DQo+LS0NCj4NCj5BbHRob3Vn
aCwgdGhpcyBjYW4gcG90ZW50aWFsbHkgY2F1c2Ugb3RoZXIgdGhyZWFkcyBmcm9tIG1ha2luZyBm
b3J3YXJkDQo+cHJvZ3Jlc3MuLiBJZiBpdCBpcyBiZXR0ZXIsIHBlcmhhcHMgd2UgYWxzbyBuZWVk
IGEgdGltZSBsaW1pdCBhcyB3ZWxsLg0KDQpUaGFua3MgZm9yIHRoaXMgcGF0Y2guIFRoZSBJT1BT
IHdhcyBhYm91dCB0aGUgc2FtZS4gKGl0IHRlbmRzIHRvIGZsdWN0dWF0ZSBtb3JlIGJ1dCB3aXRo
aW4gMyUgdmFyaWF0aW9uKQ0KDQpJIGNhcHR1cmVkIHRoZSBmb2xsb3dpbmcgZnJvbSBvbmUgb2Yg
dGhlIENQVXMuIEFsbCBDUFVzIHRlbmQgdG8gaGF2ZSBzaW1pbGFyIG51bWJlcnMuIFRoZSBmb2xs
b3dpbmcgbnVtYmVycyBhcmUgY2FwdHVyZWQgZHVyaW5nIDUgc2Vjb25kcyBhbmQgYXZlcmFnZWQ6
DQoNCkNvbnRleHQgc3dpdGNoZXMvczoNCldpdGhvdXQgYW55IHBhdGNoOiA1DQpXaXRoIHRoZSBw
cmV2aW91cyBwYXRjaDogNjQwDQpXaXRoIHRoaXMgcGF0Y2g6IDUyMg0KDQpQcm9jZXNzIG1pZ3Jh
dGVkL3M6DQpXaXRob3V0IGFueSBwYXRjaDogMC42DQpXaXRoIHRoZSBwcmV2aW91cyBwYXRjaDog
MTA0DQpXaXRoIHRoaXMgcGF0Y2g6IDEyMQ0KDQo+DQo+UGVyaGFwcyB3ZSBzaG91bGQgYWRkIHN0
YXRpc3RpY3MvdHJhY2luZyBvbiBob3cgbWFueSBjb21wbGV0aW9ucyB3ZSBhcmUNCj5yZWFwaW5n
IHBlciBpbnZvY2F0aW9uLi4uDQoNCkknbGwgbG9vayBpbnRvIGEgYml0IG1vcmUgb24gY29tcGxl
dGlvbi4gRnJvbSB0aGUgbnVtYmVycyBJIHRoaW5rIHRoZSBpbmNyZWFzZWQgbnVtYmVyIG9mIGNv
bnRleHQgc3dpdGNoZXMvbWlncmF0aW9ucyBhcmUgaHVydGluZyBtb3N0IG9uIHBlcmZvcm1hbmNl
Lg0KDQpUaGFua3MNCg0KTG9uZw0K
