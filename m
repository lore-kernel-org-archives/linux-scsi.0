Return-Path: <SRS0=xi/P=XP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFABC3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 19:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA219208C0
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 19:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="PTZMxBFh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391072AbfITTML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Sep 2019 15:12:11 -0400
Received: from mail-eopbgr700098.outbound.protection.outlook.com ([40.107.70.98]:28081
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390710AbfITTML (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Sep 2019 15:12:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BM1phx5/opLKSAeqxMCJMpzv8Pa5o+UVkU5v8y9uPr3kzmT+Lgzgvn0LHjjb4kZuO3eDE+cUV1P0YnAuNgfsbvL7XHykBlTcpMZc62YlwAGTMM0csDNnANxbxReGLGdT/snt9FyukFS1t0pPymidjf4Dem0vSUvaMBE4X3IywMYh34OnNNhD3Klv4FBxuA6fc4sq5Zl/icrLL+Zw9GqeeqE1PjgoItBo/xbJ8vpRVz3BcyuWLsSlxcQ1t+a7aOOwHDo2VNQE8xqqP0+FrmQo6oxWuBV0GFpiwTAJX9k7LAYF4z+p+dqGdBt3/mOgwwIKIgUxldTKzN1y8CB09B+P5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rp+5kjuFgsnddCwe6y+Luer8vIcmy8XeshkmhmQ8P5I=;
 b=DuQQSmleMoGd6gciGyf/3MPptMCoocUsjIwWMymZewG7t0jXt1nAUUxRYMIb7YrIHtiYt1LeS2pPalv3CCvCpW476iRxXvxc/9+OCnPkdxrsXFwr1fIw+FACHNoEQC0QPkEdYjMvKwiJTPle1qjqIzVLnL/c7apyLjL8kXHPd+0kYxVwPUjOCdpJcp2OixtyPGxtWS4UElzY1v3AinC5z3VwzOf9MME2Tb2Yk8aR+CvoZToUe6U+ySAS1oAUh86vwj3witOznYq2+SuxHdwqM+KLKjcSA3ZKu4r2rXXWA2wdBz+NgA5uUcxDjx6wUSFijMox2f/56MF+N8RD/9Md/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rp+5kjuFgsnddCwe6y+Luer8vIcmy8XeshkmhmQ8P5I=;
 b=PTZMxBFh2UqpjOhxrEQQGvvs0v3VDx5/YPWudERV5Zvfm2skB6IPzVAf4IKT/LfSEosnLYUWywjSpixctOE+yVaY+aZpBC2GGcXcBvKndAr7TRJ7AU56msRXI2xKeO4xJgb5/CJdjS3YVz/q3Li0gMZCdhanrTtIFFdoyM1him8=
Received: from CY4PR21MB0741.namprd21.prod.outlook.com (10.173.189.7) by
 CY4PR21MB0693.namprd21.prod.outlook.com (10.175.121.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.3; Fri, 20 Sep 2019 19:12:04 +0000
Received: from CY4PR21MB0741.namprd21.prod.outlook.com
 ([fe80::c8f4:597b:9f3a:9fd]) by CY4PR21MB0741.namprd21.prod.outlook.com
 ([fe80::c8f4:597b:9f3a:9fd%2]) with mapi id 15.20.2305.000; Fri, 20 Sep 2019
 19:12:04 +0000
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
Thread-Index: AQHVXLUAoNqN0R8TLUadmsLcmKb6xacPEcMAgACKtgCAAAMjAIAAyEgAgAAEnwCAAClMgIAABJWAgAi79gCAACnHgIAACOEAgAACjoCAAA16gIAABfMAgAIuJgCAAAa1AIABBRqAgAAZZYCAAP6SgIAAOYeAgADemICAAFw4gIAE69SAgAxPKbCABFQsgIAAHz9g
Date:   Fri, 20 Sep 2019 19:12:04 +0000
Message-ID: <CY4PR21MB074168DE7729C131CE4394CCCE880@CY4PR21MB0741.namprd21.prod.outlook.com>
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
In-Reply-To: <30dc6fa9-ea5e-50d6-56f9-fbc9627d8c29@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-originating-ip: [2001:4898:80e8:2:8d96:a5ff:fe5c:e22c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 088af608-2ccd-4ec3-a6f6-08d73dfe6c7d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: CY4PR21MB0693:
x-microsoft-antispam-prvs: <CY4PR21MB0693C51F428968EF7C069195CE880@CY4PR21MB0693.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(189003)(199004)(52536014)(99286004)(25786009)(2906002)(229853002)(478600001)(6436002)(55016002)(5660300002)(71190400001)(71200400001)(486006)(6116002)(9686003)(33656002)(7416002)(110136005)(11346002)(7736002)(6506007)(316002)(86362001)(446003)(14454004)(54906003)(4326008)(81156014)(74316002)(256004)(76176011)(10290500003)(476003)(46003)(66476007)(66556008)(66946007)(76116006)(8676002)(64756008)(10090500001)(81166006)(186003)(8990500004)(8936002)(102836004)(305945005)(7696005)(22452003)(66446008)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0693;H:CY4PR21MB0741.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v7xbnduRm8WsGjHQVb4ZvrWQyKn7hXGgmS+R9+/XjoOKJh4yBjI9RU/vz1PvA9G6cHZqPvMoOpKalLsI76zMnPZpcPXrBSbacExZvLO0l+sRg5JM+jTCnInEPhYZs4j06Io+5jrdXgQ1s0bpvi8lxnrKG7ShhwkqPDxUVi2gANAMKYzjLO0eleAmK5MZklrQmv2yGOiFC/1khFq8Kejr+wKyevjnZI0WSy3odJrRBvxAvcRIFvRU6wgYaKMjFtEGqdKSAZ8xvj5Fu/2fYDn7t+afBVUY3OC3Rb6CXeSeIyOZ70yjfg4Z+sMMxhu9OZMcG0fQZvpEQwVYP72dBlKiq2hBJlUX0ySHmAKiMqpqAyR/suPFv0JPNq3XL3GxFjIwm8xk8tS/R2oSrh0WT/0cHBrSSFe4a5XpOvMxrCSWoYs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 088af608-2ccd-4ec3-a6f6-08d73dfe6c7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 19:12:04.6566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w98tKGx8qf5jmZpGi33M9HEJZIpG0/sCpsGH6k1KaATWLec8B7Ydd9vE70WBGP+nonK6VPd5Z+59Kh6Nt0qXUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0693
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+PiBMb25nLCBkb2VzIHRoaXMgcGF0Y2ggbWFrZSBhbnkgZGlmZmVyZW5jZT8NCj4gPg0KPiA+
IFNhZ2ksDQo+ID4NCj4gPiBTb3JyeSBpdCB0b29rIGEgd2hpbGUgdG8gYnJpbmcgbXkgc3lzdGVt
IGJhY2sgb25saW5lLg0KPiA+DQo+ID4gV2l0aCB0aGUgcGF0Y2gsIHRoZSBJT1BTIGlzIGFib3V0
IHRoZSBzYW1lIGRyb3Agd2l0aCB0aGUgMXN0IHBhdGNoLiBJIHRoaW5rDQo+IHRoZSBleGNlc3Np
dmUgY29udGV4dCBzd2l0Y2hlcyBhcmUgY2F1c2luZyB0aGUgZHJvcCBpbiBJT1BTLg0KPiA+DQo+
ID4gVGhlIGZvbGxvd2luZyBhcmUgY2FwdHVyZWQgYnkgInBlcmYgc2NoZWQgcmVjb3JkIiBmb3Ig
MzAgc2Vjb25kcyBkdXJpbmcNCj4gdGVzdHMuDQo+ID4NCj4gPiAicGVyZiBzY2hlZCBsYXRlbmN5
Ig0KPiA+IFdpdGggcGF0Y2g6DQo+ID4gICAgZmlvOig4MikgICAgICAgICAgICAgIHwgOTM3NjMy
LjcwNiBtcyB8ICAxNzgyMjU1IHwgYXZnOiAgICAwLjIwOSBtcyB8IG1heDogICA2My4xMjMNCj4g
bXMgfCBtYXggYXQ6ICAgIDc2OC4yNzQwMjMgcw0KPiA+DQo+ID4gd2l0aG91dCBwYXRjaDoNCj4g
PiAgICBmaW86KDgyKSAgICAgICAgICAgICAgfDIzNDgzMjMuNDMyIG1zIHwgICAgMTg4NDggfCBh
dmc6ICAgIDAuMjk1IG1zIHwgbWF4OiAgIDI4LjQ0Ng0KPiBtcyB8IG1heCBhdDogICA2NDQ3LjMx
MDI1NSBzDQo+IA0KPiBXaXRob3V0IHBhdGNoIG1lYW5zIHRoZSBwcm9wb3NlZCBoYXJkLWlycSBw
YXRjaD8NCg0KSXQgbWVhbnMgdGhlIGN1cnJlbnQgdXBzdHJlYW0gY29kZSB3aXRob3V0IGFueSBw
YXRjaC4gQnV0IEl0J3MgcHJvbmUgdG8gc29mdCBsb2NrdXAuDQoNCk1pbmcncyBwcm9wb3NlZCBo
YXJkLWlycSBwYXRjaCBnZXRzIHNpbWlsYXIgcmVzdWx0cyB0byAid2l0aG91dCBwYXRjaCIsIGhv
d2V2ZXIgaXQgZml4ZXMgdGhlIHNvZnQgbG9ja3VwLg0KDQo+IA0KPiBJZiB3ZSBhcmUgY29udGV4
dCBzd2l0Y2hpbmcgdG9vIG11Y2gsIGl0IG1lYW5zIHRoZSBzb2Z0LWlycSBvcGVyYXRpb24gaXMg
bm90DQo+IGVmZmljaWVudCwgbm90IG5lY2Vzc2FyaWx5IHRoZSBmYWN0IHRoYXQgdGhlIGNvbXBs
ZXRpb24gcGF0aCBpcyBydW5uaW5nIGluIHNvZnQtDQo+IGlycS4uDQo+IA0KPiBJcyB5b3VyIGtl
cm5lbCBjb21waWxlZCB3aXRoIGZ1bGwgcHJlZW1wdGlvbiBvciB2b2x1bnRhcnkgcHJlZW1wdGlv
bj8NCg0KVGhlIHRlc3RzIGFyZSBiYXNlZCBvbiBVYnVudHUgMTguMDQga2VybmVsIGNvbmZpZ3Vy
YXRpb24uIEhlcmUgYXJlIHRoZSBwYXJhbWV0ZXJzOg0KDQojIENPTkZJR19QUkVFTVBUX05PTkUg
aXMgbm90IHNldA0KQ09ORklHX1BSRUVNUFRfVk9MVU5UQVJZPXkNCiMgQ09ORklHX1BSRUVNUFQg
aXMgbm90IHNldA0KDQo+IA0KPiA+IExvb2sgY2xvc2VyIGF0IGVhY2ggQ1BVLCB3ZSBjYW4gc2Vl
IGtzb2Z0aXJxZCBpcyBjb21wZXRpbmcgQ1BVIHdpdGgNCj4gPiBmaW8gKGFuZCBlZmZlY3RpdmVs
eSB0aHJvdHRsZSBvdGhlciBmaW8gcHJvY2Vzc2VzKSAoY2FwdHVyZWQgaW4NCj4gPiAvc3lzL2tl
cm5lbC9kZWJ1Zy90cmFjaW5nLCBlY2hvIHNjaGVkOiogPnNldF9ldmVudCkNCj4gPg0KPiA+IE9u
IENQVTEgd2l0aCBwYXRjaDogKG5vdGUgdGhhdCB0aGUgcHJldl9zdGF0ZSBmb3IgZmlvIGlzICJS
IiwgaXQncw0KPiBwcmVlbXB0aXZlbHkgc2NoZWR1bGVkKQ0KPiA+ICAgICAgICAgICAgIDwuLi4+
LTQwNzcgIFswMDFdIGQuLi4gNjY0NTYuODA1MDYyOiBzY2hlZF9zd2l0Y2g6IHByZXZfY29tbT1m
aW8NCj4gcHJldl9waWQ9NDA3NyBwcmV2X3ByaW89MTIwIHByZXZfc3RhdGU9UiA9PT4gbmV4dF9j
b21tPWtzb2Z0aXJxZC8xDQo+IG5leHRfcGlkPTE3IG5leHRfcHJpbz0xMjANCj4gPiAgICAgICAg
ICAgICA8Li4uPi0xNyAgICBbMDAxXSBkLi4uIDY2NDU2LjgwNTg1OTogc2NoZWRfc3dpdGNoOg0K
PiBwcmV2X2NvbW09a3NvZnRpcnFkLzEgcHJldl9waWQ9MTcgcHJldl9wcmlvPTEyMCBwcmV2X3N0
YXRlPVMgPT0+DQo+IG5leHRfY29tbT1maW8gbmV4dF9waWQ9NDA3NyBuZXh0X3ByaW89MTIwDQo+
ID4gICAgICAgICAgICAgPC4uLj4tNDA3NyAgWzAwMV0gZC4uLiA2NjQ1Ni44NDQwNDk6IHNjaGVk
X3N3aXRjaDogcHJldl9jb21tPWZpbw0KPiBwcmV2X3BpZD00MDc3IHByZXZfcHJpbz0xMjAgcHJl
dl9zdGF0ZT1SID09PiBuZXh0X2NvbW09a3NvZnRpcnFkLzENCj4gbmV4dF9waWQ9MTcgbmV4dF9w
cmlvPTEyMA0KPiA+ICAgICAgICAgICAgIDwuLi4+LTE3ICAgIFswMDFdIGQuLi4gNjY0NTYuODQ0
NjA3OiBzY2hlZF9zd2l0Y2g6DQo+IHByZXZfY29tbT1rc29mdGlycWQvMSBwcmV2X3BpZD0xNyBw
cmV2X3ByaW89MTIwIHByZXZfc3RhdGU9UyA9PT4NCj4gbmV4dF9jb21tPWZpbyBuZXh0X3BpZD00
MDc3IG5leHRfcHJpbz0xMjANCj4gPg0KPiA+IE9uIENQVTEgd2l0aG91dCBwYXRjaDogKHRoZSBw
cmV2X3N0YXRlIGZvciBmaW8gaXMgIlMiLCBpdCdzIHZvbHVudGFyaWx5DQo+IHNjaGVkdWxlZCkN
Cj4gPiAgICAgICAgICAgIDxpZGxlPi0wICAgICBbMDAxXSBkLi4uICA2NzI1LjM5MjMwODogc2No
ZWRfc3dpdGNoOg0KPiBwcmV2X2NvbW09c3dhcHBlci8xIHByZXZfcGlkPTAgcHJldl9wcmlvPTEy
MCBwcmV2X3N0YXRlPVIgPT0+DQo+IG5leHRfY29tbT1maW8gbmV4dF9waWQ9MTQzNDIgbmV4dF9w
cmlvPTEyMA0KPiA+ICAgICAgICAgICAgICAgZmlvLTE0MzQyIFswMDFdIGQuLi4gIDY3MjUuMzky
MzMyOiBzY2hlZF9zd2l0Y2g6IHByZXZfY29tbT1maW8NCj4gcHJldl9waWQ9MTQzNDIgcHJldl9w
cmlvPTEyMCBwcmV2X3N0YXRlPVMgPT0+IG5leHRfY29tbT1zd2FwcGVyLzENCj4gbmV4dF9waWQ9
MCBuZXh0X3ByaW89MTIwDQo+ID4gICAgICAgICAgICA8aWRsZT4tMCAgICAgWzAwMV0gZC4uLiAg
NjcyNS4zOTIzNTY6IHNjaGVkX3N3aXRjaDoNCj4gcHJldl9jb21tPXN3YXBwZXIvMSBwcmV2X3Bp
ZD0wIHByZXZfcHJpbz0xMjAgcHJldl9zdGF0ZT1SID09Pg0KPiBuZXh0X2NvbW09ZmlvIG5leHRf
cGlkPTE0MzQyIG5leHRfcHJpbz0xMjANCj4gPiAgICAgICAgICAgICAgIGZpby0xNDM0MiBbMDAx
XSBkLi4uICA2NzI1LjM5MjQyNTogc2NoZWRfc3dpdGNoOg0KPiA+IHByZXZfY29tbT1maW8gcHJl
dl9waWQ9MTQzNDIgcHJldl9wcmlvPTEyMCBwcmV2X3N0YXRlPVMgPT0+DQo+ID4gbmV4dF9jb21t
PXN3YXBwZXIvMSBuZXh0X3BpZD0wIG5leHRfcHJpbz0xMg0K
