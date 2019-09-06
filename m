Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4C2C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 04:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F8462081B
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 04:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="EdSgw7GR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732011AbfIFEoF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 00:44:05 -0400
Received: from mail-eopbgr750129.outbound.protection.outlook.com ([40.107.75.129]:11175
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727514AbfIFEoF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 00:44:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5zfK/+UuGXbl2foJYVinuJ6furJ0zN6x4b+Kt/1LAnBVsUn2v+pGMyWz4fZSUrwXF/RBIxUQAQ4u7/3JIDOMLzAZuNj7bUO5abPA/6C1HpGUEqgmOsmpUx7M/QDByO4o5IQ+BW9xEmmljJt4BRZU/djIkbt9wN3thsq7MBMB/u+l/+vJbmsVz/UMmuJWCN/Zpc2qXqpqVgMhqusbw1biGCGTjD4V/sWKxXW6QgV03ElO0f6oI21DlwJ/oNeIT3DyANeZC6KeFql5cYZlpcwKEkUO4xC/t7KvXQd10M69xn//KK0aOVssPP8TROmFzNZ3tkjJN7bnHpGHmw3kLOWdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZh/vSEYqSmBnreVfxP93jNeR3p1cK0eO8jA0fBO/dw=;
 b=EQAQQkgrt2lggGvfCbC7zGeWAixZdOS7qp5othRoKXeT5XDJomD/KR9LRA8adO7cZQEdDZO/ODYVysWc5/Wgm8e+wFa58KhcUoR76rrnLl96kfynj3f9NhFxx36DGzUgAwwKK6k34cq4PaZ77YPScvZBVYVuq8TX4RBYotvy90jnzdoq8lt9V6mJenEnGBbX6hGIUAyIVs4oXCjNiO/qXl5qu8GkEvfLlb7rAvMwBLhefGvMirWCa7qLLueEdkJ74qxMlW8YeuNt7mcfbWNQegwlXKPvfYtZUIRKrLiqyNpE0L1ZlqjWgcL0ic6zWIrCgvFY9Fn5mICVnFh+DafeAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZh/vSEYqSmBnreVfxP93jNeR3p1cK0eO8jA0fBO/dw=;
 b=EdSgw7GRklNSz1uY5HaFDj8ZpO3lNvhyxacFgvnM71QnIcRix9pCHOcNsETqG9PVre6l9B7vKQAVSpjbXKB4+4tAV0OM6shfhbCLOtrzxUrfypqOsrkIWAxvYxVEuYufkg/rHYIW4x7X1Fh71W+1CmadCljKLjhD1gLI/T12qhw=
Received: from CY4PR21MB0741.namprd21.prod.outlook.com (10.173.189.7) by
 CY4PR21MB0838.namprd21.prod.outlook.com (10.173.192.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.10; Fri, 6 Sep 2019 04:44:00 +0000
Received: from CY4PR21MB0741.namprd21.prod.outlook.com
 ([fe80::5caa:ae40:7c3a:4b1d]) by CY4PR21MB0741.namprd21.prod.outlook.com
 ([fe80::5caa:ae40:7c3a:4b1d%5]) with mapi id 15.20.2263.005; Fri, 6 Sep 2019
 04:44:00 +0000
From:   Long Li <longli@microsoft.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ming Lei <ming.lei@redhat.com>
CC:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <keith.busch@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Thread-Topic: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Thread-Index: AQHVXLUAoNqN0R8TLUadmsLcmKb6xacPEcMAgACKtgCAAAMjAIAAyEgAgAAEnwCAAClMgIAABJWAgAi79gCAACnHgIAACOEAgAACjoCAAA16gIAABfMAgAIuJgCAAAa1AIABBRqAgAAZZYCAAOqzgIAAQtGAgAAB49A=
Date:   Fri, 6 Sep 2019 04:44:00 +0000
Message-ID: <CY4PR21MB0741E42161A4B3C6F3EC366ECEBA0@CY4PR21MB0741.namprd21.prod.outlook.com>
References: <20190828135054.GA23861@ming.t460p>
 <alpine.DEB.2.21.1908281605190.23149@nanos.tec.linutronix.de>
 <20190903033001.GB23861@ming.t460p>
 <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
 <20190903063125.GA21022@ming.t460p>
 <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <CY4PR21MB0741B78A465208A457E64457CEBA0@CY4PR21MB0741.namprd21.prod.outlook.com>
 <7cb33d0d-5d40-b77b-3522-317a107794d6@linaro.org>
In-Reply-To: <7cb33d0d-5d40-b77b-3522-317a107794d6@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-originating-ip: [2001:4898:80e8:f:edde:db5c:c6fe:798]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6d4699d-ab65-49f4-2fa6-08d73284d63e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CY4PR21MB0838;
x-ms-traffictypediagnostic: CY4PR21MB0838:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <CY4PR21MB083838AE6B230D188A328CFECEBA0@CY4PR21MB0838.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(189003)(199004)(76176011)(8936002)(8676002)(81156014)(81166006)(33656002)(6246003)(9686003)(53936002)(86362001)(256004)(486006)(71200400001)(71190400001)(476003)(11346002)(446003)(46003)(7696005)(22452003)(316002)(186003)(102836004)(110136005)(99286004)(54906003)(6506007)(2906002)(8990500004)(14454004)(76116006)(6116002)(10090500001)(6436002)(52536014)(478600001)(229853002)(10290500003)(305945005)(7736002)(74316002)(55016002)(7416002)(4326008)(6306002)(25786009)(66946007)(64756008)(66556008)(5660300002)(66476007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0838;H:CY4PR21MB0741.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8sD4iAaZKIlSCrev2P14eiTB7WGpMnYb1H4QFp6WIhGwSUrYFcuCf0MMj7kwD6manY/cAx3PEymo35A8SRp18Lb1W+amqXnEDvPgDs3mJBd6irKM0JUPG49Sf5xC7Ayqi0B2lkV7RkauBUJBoeTQ6iQCHO1YRSHzzdILOZNwQ7gm3ikGKPR/qSNyiKcKXsE1GgPK3fobjEf/whIsNqpTAWDnMiHHrNC5dCFLA6hIl3wSfcf8jsPxq8+9aBEDk3Cnaj6b3jIQw4tTzijUf14iK38ULIIgRLPnsEOCqJgNdXKsTMAFeBT13OWdgB2QZF9ErSZpEx15eBEwFqGADSQ1uk1szUxUMW4aks3OD8fLVMxAodTQIKCNzg4m9uX4GgG0qOid58/uiIPFH/CPw6LLWdrpYHUHkydyBFyF4sMJEik=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d4699d-ab65-49f4-2fa6-08d73284d63e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 04:44:00.6426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TcN+tJqiP8cjP5CvJ1NRVhRRQPDHBj5neEUdZHnAUTUOSTYJvCLzC+4nAIp06n4sgHVE4L1FRnRlIFjoebTUWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0838
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PlN1YmplY3Q6IFJlOiBbUEFUQ0ggMS80XSBzb2Z0aXJxOiBpbXBsZW1lbnQgSVJRIGZsb29kIGRl
dGVjdGlvbiBtZWNoYW5pc20NCj4NCj4NCj5PbiAwNi8wOS8yMDE5IDAzOjIyLCBMb25nIExpIHdy
b3RlOg0KPlsgLi4uIF0NCj4+DQo+DQo+PiBUcmFjaW5nIHNob3dzIHRoYXQgdGhlIENQVSB3YXMg
aW4gZWl0aGVyIGhhcmRpcnEgb3Igc29mdGlycSBhbGwgdGhlDQo+PiB0aW1lIGJlZm9yZSB3YXJu
aW5ncy4gRHVyaW5nIHRlc3RzLCB0aGUgc3lzdGVtIHdhcyB1bnJlc3BvbnNpdmUgYXQNCj4+IHRp
bWVzLg0KPj4NCj4+IE1pbmcncyBwYXRjaCBmaXhlZCB0aGlzIHByb2JsZW0uIFRoZSBzeXN0ZW0g
d2FzIHJlc3BvbnNpdmUgdGhyb3VnaG91dA0KPj4gdGVzdHMuDQo+Pg0KPj4gQXMgZm9yIHBlcmZv
cm1hbmNlIGhpdCwgYm90aCByZXN1bHRlZCBpbiBhIHNtYWxsIGRyb3AgaW4gcGVhayBJT1BTLg0K
Pj4gV2l0aCBJUlFfVElNRV9BQ0NPVU5USU5HIEkgc2VlIGEgMyUgZHJvcC4gV2l0aCBNaW5nJ3Mg
cGF0Y2ggaXQgaXMgMSUNCj4+IGRyb3AuDQo+DQo+RG8geW91IG1lYW4gSVJRX1RJTUVfQUNDT1VO
VElORyArIGlycSB0aHJlYWRlZCA/DQoNCkl0J3MganVzdCBJUlFfVElNRV9BQ0NPVU5USU5HLg0K
DQo+DQo+DQo+PiBGb3IgdGhlIHRlc3RzLCBJIHVzZWQgdGhlIGZvbGxvd2luZyBmaW8gY29tbWFu
ZCBvbiAxMCBOVk1lIGRpc2tzOiBmaW8NCj4+IC0tYnM9NGsgLS1pb2VuZ2luZT1saWJhaW8gLS1p
b2RlcHRoPTEyOA0KPj4gLS0NCj5maWxlbmFtZT0vZGV2L252bWUwbjE6L2Rldi9udm1lMW4xOi9k
ZXYvbnZtZTJuMTovZGV2L252bWUzbjE6L2Rldg0KPi9udg0KPj4NCj5tZTRuMTovZGV2L252bWU1
bjE6L2Rldi9udm1lNm4xOi9kZXYvbnZtZTduMTovZGV2L252bWU4bjE6L2Rldi9uDQo+dm1lOW4x
DQo+PiAtLWRpcmVjdD0xIC0tcnVudGltZT0xMjAwMCAtLW51bWpvYnM9ODAgLS1ydz1yYW5kcmVh
ZCAtLW5hbWU9dGVzdA0KPj4gLS1ncm91cF9yZXBvcnRpbmcgLS1ndG9kX3JlZHVjZT0xDQo+DQo+
LS0NCj4NCj48aHR0cHM6Ly9uYW0wNi5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/
dXJsPWh0dHAlM0ElMkYlMkZ3d3cNCj4ubGluYXJvLm9yZyUyRiZhbXA7ZGF0YT0wMiU3QzAxJTdD
bG9uZ2xpJTQwbWljcm9zb2Z0LmNvbSU3Q2YxNDJmOWY5ZQ0KPjE1MTQ1NDM0ZGQ2MDhkNzMyODNj
ODE3JTdDNzJmOTg4YmY4NmYxNDFhZjkxYWIyZDdjZDAxMWRiNDclN0MxJTdDMA0KPiU3QzYzNzAz
MzQxMzkwMzM0MzM0MCZhbXA7c2RhdGE9RlJDR2lLeXhwZHF5SVBvYjFuV0lUR3Z5bVJkSTNmU0cN
Cj52eUJKb3Zwd1Z3NCUzRCZhbXA7cmVzZXJ2ZWQ9MD4gTGluYXJvLm9yZyDilIIgT3BlbiBzb3Vy
Y2Ugc29mdHdhcmUgZm9yDQo+QVJNIFNvQ3MNCj4NCj5Gb2xsb3cgTGluYXJvOg0KPjxodHRwczov
L25hbTA2LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cCUzQSUyRiUy
Rnd3dw0KPi5mYWNlYm9vay5jb20lMkZwYWdlcyUyRkxpbmFybyZhbXA7ZGF0YT0wMiU3QzAxJTdD
bG9uZ2xpJTQwbWljcm9zbw0KPmZ0LmNvbSU3Q2YxNDJmOWY5ZTE1MTQ1NDM0ZGQ2MDhkNzMyODNj
ODE3JTdDNzJmOTg4YmY4NmYxNDFhZjkxYWIyZDdjDQo+ZDAxMWRiNDclN0MxJTdDMCU3QzYzNzAz
MzQxMzkwMzM0MzM0MCZhbXA7c2RhdGE9UDZ0N3dpR1VFU0pvRnVLaQ0KPnUzVnJqUk1HQllVV0FX
N1RFWWluVWlGcmxRcyUzRCZhbXA7cmVzZXJ2ZWQ9MD4gRmFjZWJvb2sgfA0KPjxodHRwczovL25h
bTA2LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cCUzQSUyRiUyRnR3
aXR0DQo+ZXIuY29tJTJGJTIzISUyRmxpbmFyb29yZyZhbXA7ZGF0YT0wMiU3QzAxJTdDbG9uZ2xp
JTQwbWljcm9zb2Z0LmNvDQo+bSU3Q2YxNDJmOWY5ZTE1MTQ1NDM0ZGQ2MDhkNzMyODNjODE3JTdD
NzJmOTg4YmY4NmYxNDFhZjkxYWIyZDdjZDAxMQ0KPmRiNDclN0MxJTdDMCU3QzYzNzAzMzQxMzkw
MzM0MzM0MCZhbXA7c2RhdGE9VUIlMkZPWloxTXozOFBRaURhDQo+QmlKT0hTNHFyJTJGV0Nlakkw
YUtYOUpSUE5aM3MlM0QmYW1wO3Jlc2VydmVkPTA+IFR3aXR0ZXIgfA0KPjxodHRwczovL25hbTA2
LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cCUzQSUyRiUyRnd3dw0K
Pi5saW5hcm8ub3JnJTJGbGluYXJvLQ0KPmJsb2clMkYmYW1wO2RhdGE9MDIlN0MwMSU3Q2xvbmds
aSU0MG1pY3Jvc29mdC5jb20lN0NmMTQyZjlmOWUxNTE0NQ0KPjQzNGRkNjA4ZDczMjgzYzgxNyU3
QzcyZjk4OGJmODZmMTQxYWY5MWFiMmQ3Y2QwMTFkYjQ3JTdDMSU3QzAlN0M2DQo+MzcwMzM0MTM5
MDMzNDMzNDAmYW1wO3NkYXRhPTclMkJyYXdvQVd1RnpvdTkwR1RnSVVKViUyRmFzdjJOMk9nDQo+
Y2llUHZZbWJsREZNJTNEJmFtcDtyZXNlcnZlZD0wPiBCbG9nDQoNCg==
