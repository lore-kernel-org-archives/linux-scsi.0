Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3800CA9EC4
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 08:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D400D2086A
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 08:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfJ2IIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 04:08:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2442 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727331AbfJ2IIC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Oct 2019 04:08:02 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 25E316BDF6AE21D87397;
        Tue, 29 Oct 2019 16:07:59 +0800 (CST)
Received: from DGGEML421-HUB.china.huawei.com (10.1.199.38) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 29 Oct 2019 16:07:57 +0800
Received: from DGGEML505-MBS.china.huawei.com ([169.254.11.138]) by
 dggeml421-hub.china.huawei.com ([10.1.199.38]) with mapi id 14.03.0439.000;
 Tue, 29 Oct 2019 16:07:51 +0800
From:   "wubo (T)" <wubo40@huawei.com>
To:     Lee Duncan <LDuncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Mingfangsen <mingfangsen@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIHNjc2k6IGF2b2lkIHBvdGVudGlhbCBkZWFkbG9v?=
 =?utf-8?B?cCBpbiBpc2NzaV9pZl9yeCBmdW5j?=
Thread-Topic: [PATCH] scsi: avoid potential deadloop in iscsi_if_rx func
Thread-Index: AdWL2reJ1uh470cQT+idNsWy+95OAQB3236AAByqm6A=
Date:   Tue, 29 Oct 2019 08:07:49 +0000
Message-ID: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DF66B3@dggeml505-mbs.china.huawei.com>
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DE9E71@DGGEML525-MBS.china.huawei.com>
 <92b221da-18a8-8b7b-0436-ca59088fd45b@suse.com>
In-Reply-To: <92b221da-18a8-8b7b-0436-ca59088fd45b@suse.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.252]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMjAxOS8xMC8yOSAyOjA0LCBMZWUgRHVuY2FuIHdyb3RlOg0KPiBPbiAxMC8yNi8xOSAxOjU1
IEFNLCB3dWJvIChUKSB3cm90ZToNCj4+IEZyb206IEJvIFd1IDx3dWJvNDBAaHVhd2VpLmNvbT4N
Cj4+DQo+PiBJbiBpc2NzaV9pZl9yeCBmdW5jLCBhZnRlciByZWNlaXZpbmcgb25lIHJlcXVlc3Qg
dGhyb3VnaCANCj4+IGlzY3NpX2lmX3JlY3ZfbXNnIGZ1bmMsaXNjc2lfaWZfc2VuZF9yZXBseSB3
aWxsIGJlIGNhbGxlZCB0byB0cnkgdG8gDQo+PiByZXBseSB0aGUgcmVxdWVzdCBpbiBkby1sb29w
LiBJZiB0aGUgcmV0dXJuIG9mIGlzY3NpX2lmX3NlbmRfcmVwbHkgDQo+PiBmdW5jIGZhaWxzIGFs
bCB0aGUgdGltZSwgb25lIGRlYWRsb29wIHdpbGwgb2NjdXIuDQo+Pg0KPj4gU2lnbmVkLW9mZi1i
eTogQm8gV3UgPHd1Ym80MEBodWF3ZWkuY29tPg0KPj4gUmV2aWV3ZWQtYnk6IFpoaXFpYW5nIExp
dSA8bGl1emhpcWlhbmcyNkBodWF3ZWkuY29tPg0KPj4gLS0tDQo+PiAgZHJpdmVycy9zY3NpL3Nj
c2lfdHJhbnNwb3J0X2lzY3NpLmMgfCA2ICsrKysrKw0KPj4gIDEgZmlsZSBjaGFuZ2VkLCA2IGlu
c2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNw
b3J0X2lzY3NpLmMgDQo+PiBiL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5jDQo+
PiBpbmRleCA0MTdiODY4ZDg3MzUuLmYzNzdiZmVkNmIwYyAxMDA2NDQNCj4+IC0tLSBhL2RyaXZl
cnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5jDQo+PiArKysgYi9kcml2ZXJzL3Njc2kvc2Nz
aV90cmFuc3BvcnRfaXNjc2kuYw0KPj4gQEAgLTI0LDYgKzI0LDggQEANCj4+ICANCj4+ICAjZGVm
aW5lIElTQ1NJX1RSQU5TUE9SVF9WRVJTSU9OICIyLjAtODcwIg0KPj4gIA0KPj4gKyNkZWZpbmUg
SVNDU0lfU0VORF9NQVhfQUxMT1dFRCAgICAgMTANCj4+ICsNCj4+ICAjZGVmaW5lIENSRUFURV9U
UkFDRV9QT0lOVFMNCj4+ICAjaW5jbHVkZSA8dHJhY2UvZXZlbnRzL2lzY3NpLmg+DQo+PiAgDQo+
PiBAQCAtMzY4Miw2ICszNjg0LDcgQEAgaXNjc2lfaWZfcngoc3RydWN0IHNrX2J1ZmYgKnNrYikN
Cj4+ICAJCXN0cnVjdCBubG1zZ2hkcgkqbmxoOw0KPj4gIAkJc3RydWN0IGlzY3NpX3VldmVudCAq
ZXY7DQo+PiAgCQl1aW50MzJfdCBncm91cDsNCj4+ICsJCWludCByZXRyaWVzID0gSVNDU0lfU0VO
RF9NQVhfQUxMT1dFRDsNCj4+ICANCj4+ICAJCW5saCA9IG5sbXNnX2hkcihza2IpOw0KPj4gIAkJ
aWYgKG5saC0+bmxtc2dfbGVuIDwgc2l6ZW9mKCpubGgpICsgc2l6ZW9mKCpldikgfHwgQEAgLTM3
MTAsOCANCj4+ICszNzEzLDExIEBAIGlzY3NpX2lmX3J4KHN0cnVjdCBza19idWZmICpza2IpDQo+
PiAgCQkJCWJyZWFrOw0KPj4gIAkJCWlmIChldi0+dHlwZSA9PSBJU0NTSV9VRVZFTlRfR0VUX0NI
QVAgJiYgIWVycikNCj4+ICAJCQkJYnJlYWs7DQo+PiArCQkJaWYgKHJldHJpZXMgPD0gMCkNCj4+
ICsJCQkJYnJlYWs7DQo+PiAgCQkJZXJyID0gaXNjc2lfaWZfc2VuZF9yZXBseShwb3J0aWQsIG5s
aC0+bmxtc2dfdHlwZSwNCj4+ICAJCQkJCQkgIGV2LCBzaXplb2YoKmV2KSk7DQo+PiArCQkJcmV0
cmllcy0tOw0KPj4gIAkJfSB3aGlsZSAoZXJyIDwgMCAmJiBlcnIgIT0gLUVDT05OUkVGVVNFRCAm
JiBlcnIgIT0gLUVTUkNIKTsNCj4+ICAJCXNrYl9wdWxsKHNrYiwgcmxlbik7DQo+PiAgCX0NCj4+
DQo+IA0KPiBZb3UgY291bGQgaGF2ZSB1c2VkICJpZiAoLS1yZXRyaWVzIDwgMCkiIChvciBzb21l
IHZhcmlhdGlvbiB0aGVyZW9mKSANCj4gYnV0IHRoYXQgbWF5IG5vdCBiZSBhcyBjbGVhciwgYW5k
IGNlcnRhaW5seSBpcyBvbmx5IGEgbml0LiBTbyBJJ20gZmluZSANCj4gd2l0aCB0aGF0Lg0KPiAN
Cg0KVGhhbmtzIGZvciB5b3VyIHN1Z2dlc3Rpb24sIEkgd2lsbCBtb2RpZnkgaXQgaW4gdjIgcGF0
Y2guDQoNCj4gQnV0IEkgd291bGQgbGlrZSB0byBzZWUgc29tZSBzb3J0IG9mIGVycm9yIG9yIGV2
ZW4gZGVidWcga2VybmVsIA0KPiBtZXNzYWdlIGlmIHdlIHRpbWUgb3V0IHdhaXRpbmcgdG8gcmVj
ZWl2ZSBhIHJlc3BvbnNlLiBPdGhlcndpc2UsIGhvdyANCj4gd2lsbCBzb21lIGh1bWFuIGRpYWdu
b3NlIHRoaXMgcHJvYmxlbT8NCj4NCg0KWW91IGFyZSByaWdodCwgSSB3aWxsIGFkZCBzb21lIHNv
cnQgb2YgZXJyb3Igb3IgZGVidWcga2VybmVsIG1lc3NhZ2UgaW4gdGhlIHYyIHBhdGNoLg0KDQpU
aGFua3MsDQpCbyBXdQ0K
