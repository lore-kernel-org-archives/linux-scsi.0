Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8BFC4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF27F22225
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgLOJIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 04:08:10 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:39400 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728025AbgLOJIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 04:08:00 -0500
X-UUID: 3aab9b74a18b41ca9c509e553360c48a-20201215
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=6+6qWJDCVaZdwd7LAQOA4ZmsvGIVsQDay04mR778FEQ=;
        b=KjkxxdVjwhYTX1g+1KYyZlJq6dSHYg0wT851Ln9QMZqUcj+CbZSA6jEuU60AsM8UHWqwcCNgvbORQtjMFR619wuFp5rduGbKwE9RahuIsg7AIgoGZWBOONxUVsN7fHB5qGFBpJMuzKcEnqiDTsFhn4uiv4g5w3WdVRQUz4hDCWk=;
X-UUID: 3aab9b74a18b41ca9c509e553360c48a-20201215
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1538017907; Tue, 15 Dec 2020 17:07:16 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 15 Dec 2020 17:07:15 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 17:07:15 +0800
Message-ID: <1608023234.10163.19.camel@mtkswgap22>
Subject: Re: [PATCH v4 5/6] scsi: ufs: Cleanup WB buffer flush toggle
 implementation
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Tue, 15 Dec 2020 17:07:14 +0800
In-Reply-To: <20201211140035.20016-6-huobean@gmail.com>
References: <20201211140035.20016-1-huobean@gmail.com>
         <20201211140035.20016-6-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCg0KT24gRnJpLCAyMDIwLTEyLTExIGF0IDE1OjAwICswMTAwLCBCZWFuIEh1byB3
cm90ZToNCj4gRnJvbTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IERlbGV0
ZSB1ZnNoY2Rfd2JfYnVmX2ZsdXNoX2VuYWJsZSgpIGFuZCB1ZnNoY2Rfd2JfYnVmX2ZsdXNoX2Rp
c2FibGUoKSwNCj4gbW92ZSB0aGUgaW1wbGVtZW50YXRpb24gaW50byB1ZnNoY2Rfd2JfdG9nZ2xl
X2ZsdXNoKCkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24u
Y29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA2OSArKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNl
cnRpb25zKCspLCA0NSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBpbmRleCAwOTk4
ZTYxMDNjZDcuLmZiM2M5ODcyNDAwNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IEBAIC0yNDQsMTAg
KzI0NCw4IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3NldHVwX3ZyZWcoc3RydWN0IHVmc19oYmEgKmhi
YSwgYm9vbCBvbik7DQo+ICBzdGF0aWMgaW5saW5lIGludCB1ZnNoY2RfY29uZmlnX3ZyZWdfaHBt
KHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+ICAJCQkJCSBzdHJ1Y3QgdWZzX3ZyZWcgKnZyZWcpOw0K
PiAgc3RhdGljIGludCB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soc3RydWN0IHVmc19oYmEgKmhi
YSwgaW50IHRhZyk7DQo+IC1zdGF0aWMgaW50IHVmc2hjZF93Yl9idWZfZmx1c2hfZW5hYmxlKHN0
cnVjdCB1ZnNfaGJhICpoYmEpOw0KPiAtc3RhdGljIGludCB1ZnNoY2Rfd2JfYnVmX2ZsdXNoX2Rp
c2FibGUoc3RydWN0IHVmc19oYmEgKmhiYSk7DQo+ICBzdGF0aWMgaW50IHVmc2hjZF93Yl90b2dn
bGVfZmx1c2hfZHVyaW5nX2g4KHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgc2V0KTsNCj4gLXN0
YXRpYyBpbmxpbmUgdm9pZCB1ZnNoY2Rfd2JfdG9nZ2xlX2ZsdXNoKHN0cnVjdCB1ZnNfaGJhICpo
YmEsIGJvb2wgZW5hYmxlKTsNCj4gK3N0YXRpYyBpbmxpbmUgaW50IHVmc2hjZF93Yl90b2dnbGVf
Zmx1c2goc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpOw0KPiAgc3RhdGljIHZvaWQg
dWZzaGNkX2hiYV92cmVnX3NldF9scG0oc3RydWN0IHVmc19oYmEgKmhiYSk7DQo+ICBzdGF0aWMg
dm9pZCB1ZnNoY2RfaGJhX3ZyZWdfc2V0X2hwbShzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCj4gIA0K
PiBAQCAtNTM5OCw2MCArNTM5Niw0MSBAQCBzdGF0aWMgaW50IHVmc2hjZF93Yl90b2dnbGVfZmx1
c2hfZHVyaW5nX2g4KHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgc2V0KQ0KPiAgCQkJCWluZGV4
LCBOVUxMKTsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIGlubGluZSB2b2lkIHVmc2hjZF93Yl90b2dn
bGVfZmx1c2goc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpDQo+IC17DQo+IC0JaWYg
KGhiYS0+cXVpcmtzICYgVUZTSENJX1FVSVJLX1NLSVBfTUFOVUFMX1dCX0ZMVVNIX0NUUkwpDQo+
IC0JCXJldHVybjsNCj4gLQ0KPiAtCWlmIChlbmFibGUpDQo+IC0JCXVmc2hjZF93Yl9idWZfZmx1
c2hfZW5hYmxlKGhiYSk7DQo+IC0JZWxzZQ0KPiAtCQl1ZnNoY2Rfd2JfYnVmX2ZsdXNoX2Rpc2Fi
bGUoaGJhKTsNCj4gLQ0KPiAtfQ0KPiAtDQo+IC1zdGF0aWMgaW50IHVmc2hjZF93Yl9idWZfZmx1
c2hfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICtzdGF0aWMgaW5saW5lIGludCB1ZnNo
Y2Rfd2JfdG9nZ2xlX2ZsdXNoKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgZW5hYmxlKQ0KPiAg
ew0KPiAgCWludCByZXQ7DQo+ICAJdTggaW5kZXg7DQo+ICsJZW51bSBxdWVyeV9vcGNvZGUgb3Bj
b2RlOw0KPiAgDQo+IC0JaWYgKCF1ZnNoY2RfaXNfd2JfYWxsb3dlZChoYmEpIHx8IGhiYS0+ZGV2
X2luZm8ud2JfYnVmX2ZsdXNoX2VuYWJsZWQpDQo+ICsJaWYgKGhiYS0+cXVpcmtzICYgVUZTSENJ
X1FVSVJLX1NLSVBfTUFOVUFMX1dCX0ZMVVNIX0NUUkwpDQo+ICAJCXJldHVybiAwOw0KPiAgDQo+
IC0JaW5kZXggPSB1ZnNoY2Rfd2JfZ2V0X3F1ZXJ5X2luZGV4KGhiYSk7DQo+IC0JcmV0ID0gdWZz
aGNkX3F1ZXJ5X2ZsYWdfcmV0cnkoaGJhLCBVUElVX1FVRVJZX09QQ09ERV9TRVRfRkxBRywNCj4g
LQkJCQkgICAgICBRVUVSWV9GTEFHX0lETl9XQl9CVUZGX0ZMVVNIX0VOLA0KPiAtCQkJCSAgICAg
IGluZGV4LCBOVUxMKTsNCj4gLQlpZiAocmV0KQ0KPiAtCQlkZXZfZXJyKGhiYS0+ZGV2LCAiJXMg
V0IgLSBidWYgZmx1c2ggZW5hYmxlIGZhaWxlZCAlZFxuIiwNCj4gLQkJCV9fZnVuY19fLCByZXQp
Ow0KPiAtCWVsc2UNCj4gLQkJaGJhLT5kZXZfaW5mby53Yl9idWZfZmx1c2hfZW5hYmxlZCA9IHRy
dWU7DQo+IC0NCj4gLQlkZXZfZGJnKGhiYS0+ZGV2LCAiV0IgLSBGbHVzaCBlbmFibGVkOiAlZFxu
IiwgcmV0KTsNCj4gLQlyZXR1cm4gcmV0Ow0KPiAtfQ0KPiAtDQo+IC1zdGF0aWMgaW50IHVmc2hj
ZF93Yl9idWZfZmx1c2hfZGlzYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAtew0KPiAtCWlu
dCByZXQ7DQo+IC0JdTggaW5kZXg7DQo+IC0NCj4gLQlpZiAoIXVmc2hjZF9pc193Yl9hbGxvd2Vk
KGhiYSkgfHwgIWhiYS0+ZGV2X2luZm8ud2JfYnVmX2ZsdXNoX2VuYWJsZWQpDQo+ICsJaWYgKCF1
ZnNoY2RfaXNfd2JfYWxsb3dlZChoYmEpIHx8DQo+ICsJICAgIGhiYS0+ZGV2X2luZm8ud2JfYnVm
X2ZsdXNoX2VuYWJsZWQgPT0gZW5hYmxlKQ0KPiAgCQlyZXR1cm4gMDsNCj4gIA0KPiArCWlmIChl
bmFibGUpDQo+ICsJCW9wY29kZSA9IFVQSVVfUVVFUllfT1BDT0RFX1NFVF9GTEFHOw0KPiArCWVs
c2UNCj4gKwkJb3Bjb2RlID0gVVBJVV9RVUVSWV9PUENPREVfQ0xFQVJfRkxBRzsNCj4gKw0KPiAg
CWluZGV4ID0gdWZzaGNkX3diX2dldF9xdWVyeV9pbmRleChoYmEpOw0KPiAtCXJldCA9IHVmc2hj
ZF9xdWVyeV9mbGFnX3JldHJ5KGhiYSwgVVBJVV9RVUVSWV9PUENPREVfQ0xFQVJfRkxBRywNCj4g
LQkJCQkgICAgICBRVUVSWV9GTEFHX0lETl9XQl9CVUZGX0ZMVVNIX0VOLA0KPiAtCQkJCSAgICAg
IGluZGV4LCBOVUxMKTsNCj4gKwlyZXQgPSB1ZnNoY2RfcXVlcnlfZmxhZ19yZXRyeShoYmEsIG9w
Y29kZSwNCj4gKwkJCQkgICAgICBRVUVSWV9GTEFHX0lETl9XQl9CVUZGX0ZMVVNIX0VOLCBpbmRl
eCwNCj4gKwkJCQkgICAgICBOVUxMKTsNCj4gIAlpZiAocmV0KSB7DQo+IC0JCWRldl93YXJuKGhi
YS0+ZGV2LCAiJXM6IFdCIC0gYnVmIGZsdXNoIGRpc2FibGUgZmFpbGVkICVkXG4iLA0KPiAtCQkJ
IF9fZnVuY19fLCByZXQpOw0KPiAtCX0gZWxzZSB7DQo+IC0JCWhiYS0+ZGV2X2luZm8ud2JfYnVm
X2ZsdXNoX2VuYWJsZWQgPSBmYWxzZTsNCj4gLQkJZGV2X2RiZyhoYmEtPmRldiwgIldCIC0gRmx1
c2ggZGlzYWJsZWQ6ICVkXG4iLCByZXQpOw0KPiArCQlkZXZfZXJyKGhiYS0+ZGV2LCAiJXMgV0It
QnVmIEZsdXNoICVzIGZhaWxlZCAlZFxuIiwgX19mdW5jX18sDQo+ICsJCQllbmFibGUgPyAiZW5h
YmxlIiA6ICJkaXNhYmxlIiwgcmV0KTsNCj4gKwkJZ290byBvdXQ7DQo+ICAJfQ0KPiAgDQo+ICsJ
aWYgKGVuYWJsZSkNCj4gKwkJaGJhLT5kZXZfaW5mby53Yl9idWZfZmx1c2hfZW5hYmxlZCA9IHRy
dWU7DQo+ICsJZWxzZQ0KPiArCQloYmEtPmRldl9pbmZvLndiX2J1Zl9mbHVzaF9lbmFibGVkID0g
ZmFsc2U7DQoNClBlcmhhcHMgdGhpcyBjb3VsZCBiZSBzaW1wbGVyIGFzIGJlbG93Pw0KDQpoYmEt
PmRldl9pbmZvLndiX2J1Zl9mbHVzaF9lbmFibGVkID0gZW5hYmxlOw0KDQpUaGFua3MsDQpTdGFu
bGV5IENodQ0KDQo+ICsNCj4gKwlkZXZfZGJnKGhiYS0+ZGV2LCAiV0ItQnVmIEZsdXNoICVzXG4i
LCBlbmFibGUgPyAiZW5hYmxlZCIgOiAiZGlzYWJsZWQiKTsNCj4gK291dDoNCj4gIAlyZXR1cm4g
cmV0Ow0KPiAgfQ0KPiAgDQoNCg==

