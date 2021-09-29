Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF6FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FBA36139D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243768AbhI2Cz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 22:55:28 -0400
Received: from mx22.baidu.com ([220.181.50.185]:49642 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229771AbhI2Cz2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 22:55:28 -0400
Received: from BC-Mail-Ex27.internal.baidu.com (unknown [172.31.51.21])
        by Forcepoint Email with ESMTPS id 9DF2C9BF6664175EF01D;
        Wed, 29 Sep 2021 10:53:43 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex27.internal.baidu.com (172.31.51.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 29 Sep 2021 10:53:43 +0800
Received: from BJHW-MAIL-EX27.internal.baidu.com ([169.254.58.247]) by
 BJHW-MAIL-EX27.internal.baidu.com ([169.254.58.247]) with mapi id
 15.01.2308.014; Wed, 29 Sep 2021 10:53:43 +0800
From:   "Cai,Huoqing" <caihuoqing@baidu.com>
To:     "Cai,Huoqing" <caihuoqing@baidu.com>
CC:     John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: hisi_sas: Make use of the helper function
 devm_platform_ioremap_resource()
Thread-Topic: [PATCH] scsi: hisi_sas: Make use of the helper function
 devm_platform_ioremap_resource()
Thread-Index: AQHXnw6o1mQ0bS2gs0il5KsnH1dEZ6u6e2VA
Date:   Wed, 29 Sep 2021 02:53:43 +0000
Message-ID: <88820f7dabff4561be5bfe0362f70c14@baidu.com>
References: <20210901085207.31254-1-caihuoqing@baidu.com>
In-Reply-To: <20210901085207.31254-1-caihuoqing@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.127.83.206]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGVsbG8sDQoNCkRyb3AgdGhpcyBwYXRjaC4NCkJlY2F1c2Ugc2dwaW9fcmVncyBpcyBvcHRpb25h
bCB3aGljaCBpcyB1c2VkIGxpa2UgdGhpcw0KCWlmICghaGlzaV9oYmEtPnNncGlvX3JlZ3MpDQoJ
CXJldHVybiAtRU9QTk9UU1VQUDsNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBG
cm9tOiBDYWksSHVvcWluZyA8Y2FpaHVvcWluZ0BiYWlkdS5jb20+DQo+IFNlbnQ6IDIwMjHE6jnU
wjHI1SAxNjo1Mg0KPiBUbzogQ2FpLEh1b3FpbmcNCj4gQ2M6IEpvaG4gR2Fycnk7IEphbWVzIEUu
Si4gQm90dG9tbGV5OyBNYXJ0aW4gSy4gUGV0ZXJzZW47IGxpbnV4LQ0KPiBzY3NpQHZnZXIua2Vy
bmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0hd
IHNjc2k6IGhpc2lfc2FzOiBNYWtlIHVzZSBvZiB0aGUgaGVscGVyIGZ1bmN0aW9uDQo+IGRldm1f
cGxhdGZvcm1faW9yZW1hcF9yZXNvdXJjZSgpDQo+IA0KPiBVc2UgdGhlIGRldm1fcGxhdGZvcm1f
aW9yZW1hcF9yZXNvdXJjZSgpIGhlbHBlciBpbnN0ZWFkIG9mDQo+IGNhbGxpbmcgcGxhdGZvcm1f
Z2V0X3Jlc291cmNlKCkgYW5kIGRldm1faW9yZW1hcF9yZXNvdXJjZSgpDQo+IHNlcGFyYXRlbHkN
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IENhaSBIdW9xaW5nIDxjYWlodW9xaW5nQGJhaWR1LmNvbT4N
Cj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvaGlzaV9zYXMvaGlzaV9zYXNfbWFpbi5jIHwgOSArKyst
LS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2hpc2lfc2FzL2hpc2lfc2FzX21haW4u
Yw0KPiBiL2RyaXZlcnMvc2NzaS9oaXNpX3Nhcy9oaXNpX3Nhc19tYWluLmMNCj4gaW5kZXggOTUx
NWM0NWFmZmE1Li4wYzIzMDljOTUxYWIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9oaXNp
X3Nhcy9oaXNpX3Nhc19tYWluLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL2hpc2lfc2FzL2hpc2lf
c2FzX21haW4uYw0KPiBAQCAtMjY0OSwxMiArMjY0OSw5IEBAIHN0YXRpYyBzdHJ1Y3QgU2NzaV9I
b3N0ICpoaXNpX3Nhc19zaG9zdF9hbGxvYyhzdHJ1Y3QNCj4gcGxhdGZvcm1fZGV2aWNlICpwZGV2
LA0KPiAgCWlmIChJU19FUlIoaGlzaV9oYmEtPnJlZ3MpKQ0KPiAgCQlnb3RvIGVycl9vdXQ7DQo+
IA0KPiAtCXJlcyA9IHBsYXRmb3JtX2dldF9yZXNvdXJjZShwZGV2LCBJT1JFU09VUkNFX01FTSwg
MSk7DQo+IC0JaWYgKHJlcykgew0KPiAtCQloaXNpX2hiYS0+c2dwaW9fcmVncyA9IGRldm1faW9y
ZW1hcF9yZXNvdXJjZShkZXYsIHJlcyk7DQo+IC0JCWlmIChJU19FUlIoaGlzaV9oYmEtPnNncGlv
X3JlZ3MpKQ0KPiAtCQkJZ290byBlcnJfb3V0Ow0KPiAtCX0NCj4gKwloaXNpX2hiYS0+c2dwaW9f
cmVncyA9IGRldm1fcGxhdGZvcm1faW9yZW1hcF9yZXNvdXJjZShwZGV2LCAxKTsNCj4gKwlpZiAo
SVNfRVJSKGhpc2lfaGJhLT5zZ3Bpb19yZWdzKSkNCj4gKwkJZ290byBlcnJfb3V0Ow0KPiANCj4g
IAlpZiAoaGlzaV9zYXNfYWxsb2MoaGlzaV9oYmEpKSB7DQo+ICAJCWhpc2lfc2FzX2ZyZWUoaGlz
aV9oYmEpOw0KPiAtLQ0KPiAyLjI1LjENCg0K
