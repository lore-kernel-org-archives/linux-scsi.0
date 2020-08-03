Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B485C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 09:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB71820678
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 09:58:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mMfwffbQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgHCJ6V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 05:58:21 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:60947 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726167AbgHCJ6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 05:58:21 -0400
X-UUID: 42f8340be52d4328b6773bc5b6381607-20200803
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=rk95z43C2aNrN15eIkcdc/c36r6GmjdjgaMR2GV/CrU=;
        b=mMfwffbQJYONWWbMqmx4076dHiGMTs1t95utf/cDchpXubEtsGkJQKjRoi6Pwe3uA9B/uY/HBgTQu5E+CEskPdr0BEqVhjFW0+vTEaKcwFRM8Fa05mO9M/O6yVZKWmHc30QO3qkyK3wz2IE6BFDkCcE8p1tdAHYunSNIjW2kcas=;
X-UUID: 42f8340be52d4328b6773bc5b6381607-20200803
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 300893131; Mon, 03 Aug 2020 17:58:17 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 3 Aug 2020 17:58:02 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 3 Aug 2020 17:58:02 +0800
Message-ID: <1596448684.32283.25.camel@mtkswgap22>
Subject: Re: [PATCH v6] scsi: ufs: Quiesce all scsi devices before shutdown
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>
Date:   Mon, 3 Aug 2020 17:58:04 +0800
In-Reply-To: <d85cdb877bced2d6b0a8ba67670271f2@codeaurora.org>
References: <20200803042514.7111-1-stanley.chu@mediatek.com>
         <d85cdb877bced2d6b0a8ba67670271f2@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBNb24sIDIwMjAtMDgtMDMgYXQgMTM6MDMgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEhpIFN0YW5sZXksDQo+IA0KPiBPbiAyMDIwLTA4LTAzIDEyOjI1LCBTdGFubGV5IENo
dSB3cm90ZToNCj4gPiBDdXJyZW50bHkgSS9PIHJlcXVlc3QgY291bGQgYmUgc3RpbGwgc3VibWl0
dGVkIHRvIFVGUyBkZXZpY2Ugd2hpbGUNCj4gPiBVRlMgaXMgd29ya2luZyBvbiBzaHV0ZG93biBm
bG93LiBUaGlzIG1heSBsZWFkIHRvIHJhY2luZyBhcyBiZWxvdw0KPiA+IHNjZW5hcmlvcyBhbmQg
ZmluYWxseSBzeXN0ZW0gbWF5IGNyYXNoIGR1ZSB0byB1bmNsb2NrZWQgcmVnaXN0ZXINCj4gPiBh
Y2Nlc3Nlcy4NCj4gPiANCj4gPiBUbyBmaXggdGhpcyBraW5kIG9mIGlzc3VlcywgaW4gdWZzaGNk
X3NodXRkb3duKCksDQo+ID4gDQo+ID4gMS4gVXNlIHBtX3J1bnRpbWVfZ2V0X3N5bmMoKSBpbnN0
ZWFkIG9mIHJlc3VtaW5nIFVGUyBkZXZpY2UgYnkNCj4gPiAgICB1ZnNoY2RfcnVudGltZV9yZXN1
bWUoKSAiaW50ZXJuYWxseSIgdG8gbGV0IHJ1bnRpbWUgUE0gZnJhbWV3b3JrDQo+ID4gICAgbWFu
YWdlIGFuZCBwcmV2ZW50IGNvbmN1cnJlbnQgcnVudGltZSBvcGVyYXRpb25zIGJ5IGluY29taW5n
IEkvTw0KPiA+ICAgIHJlcXVlc3RzLg0KPiA+IA0KPiA+IDIuIFNwZWNpZmljYWxseSBxdWllc2Nl
IGFsbCBTQ1NJIGRldmljZXMgdG8gYmxvY2sgYWxsIEkvTyByZXF1ZXN0cw0KPiA+ICAgIGFmdGVy
IGRldmljZSBpcyByZXN1bWVkLg0KPiA+IA0KPiA+IEV4YW1wbGUgb2YgcmFjaW5nIHNjZW5hcmlv
OiBXaGlsZSBVRlMgZGV2aWNlIGlzIHJ1bnRpbWUtc3VzcGVuZGVkDQo+ID4gDQo+ID4gVGhyZWFk
ICMxOiBFeGVjdXRpbmcgVUZTIHNodXRkb3duIGZsb3csIGUuZy4sDQo+ID4gICAgICAgICAgICB1
ZnNoY2Rfc3VzcGVuZChVRlNfU0hVVERPV05fUE0pDQo+ID4gDQo+ID4gVGhyZWFkICMyOiBFeGVj
dXRpbmcgcnVudGltZSByZXN1bWUgZmxvdyB0cmlnZ2VyZWQgYnkgSS9PIHJlcXVlc3QsDQo+ID4g
ICAgICAgICAgICBlLmcuLCB1ZnNoY2RfcmVzdW1lKFVGU19SVU5USU1FX1BNKQ0KPiA+IA0KPiA+
IFRoaXMgYnJlYWtzIHRoZSBhc3N1bXB0aW9uIHRoYXQgVUZTIFBNIGZsb3dzIGNhbiBub3QgYmUg
cnVubmluZw0KPiA+IGNvbmN1cnJlbnRseSBhbmQgc29tZSB1bmV4cGVjdGVkIHJhY2luZyBiZWhh
dmlvciBtYXkgaGFwcGVuLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxz
dGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gQ2hhbmdlczoNCj4gPiAgIC0g
U2luY2UgdjQ6IFVzZSBwbV9ydW50aW1lX2dldF9zeW5jKCkgaW5zdGVhZCBvZiByZXN1bWluZyBV
RlMgZGV2aWNlDQo+ID4gYnkgdWZzaGNkX3J1bnRpbWVfcmVzdW1lKCkgImludGVybmFsbHkiLg0K
PiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMzkgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKy0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzNCBpbnNl
cnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+IGluZGV4
IDMwNzYyMjI4NDIzOS4uZmMwMTE3MWQxM2IxIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4g
QEAgLTE1OSw2ICsxNTksMTIgQEAgc3RydWN0IHVmc19wbV9sdmxfc3RhdGVzIHVmc19wbV9sdmxf
c3RhdGVzW10gPSB7DQo+ID4gIAl7VUZTX1BPV0VSRE9XTl9QV1JfTU9ERSwgVUlDX0xJTktfT0ZG
X1NUQVRFfSwNCj4gPiAgfTsNCj4gPiANCj4gPiArI2RlZmluZSB1ZnNoY2Rfc2NzaV9mb3JfZWFj
aF9zZGV2KGZuKSBcDQo+ID4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KHN0YXJnZXQsICZoYmEtPmhv
c3QtPl9fdGFyZ2V0cywgc2libGluZ3MpIHsgXA0KPiA+ICsJCV9fc3RhcmdldF9mb3JfZWFjaF9k
ZXZpY2Uoc3RhcmdldCwgTlVMTCwgXA0KPiA+ICsJCQkJCSAgZm4pOyBcDQo+ID4gKwl9DQo+ID4g
Kw0KPiA+ICBzdGF0aWMgaW5saW5lIGVudW0gdWZzX2Rldl9wd3JfbW9kZQ0KPiA+ICB1ZnNfZ2V0
X3BtX2x2bF90b19kZXZfcHdyX21vZGUoZW51bSB1ZnNfcG1fbGV2ZWwgbHZsKQ0KPiA+ICB7DQo+
ID4gQEAgLTg2MjksNiArODYzNSwxMyBAQCBpbnQgdWZzaGNkX3J1bnRpbWVfaWRsZShzdHJ1Y3Qg
dWZzX2hiYSAqaGJhKQ0KPiA+ICB9DQo+ID4gIEVYUE9SVF9TWU1CT0wodWZzaGNkX3J1bnRpbWVf
aWRsZSk7DQo+ID4gDQo+ID4gK3N0YXRpYyB2b2lkIHVmc2hjZF9xdWllc2NlX3NkZXYoc3RydWN0
IHNjc2lfZGV2aWNlICpzZGV2LCB2b2lkICpkYXRhKQ0KPiA+ICt7DQo+ID4gKwkvKiBTdXNwZW5k
ZWQgZGV2aWNlcyBhcmUgYWxyZWFkeSBxdWllc2NlZCBzbyBjYW4gYmUgc2tpcHBlZCAqLw0KPiAN
Cj4gV2h5IGNhbiBydW50aW1lIHN1c3BlbmRlZCBzZGV2cyBiZSBza2lwcGVkPyBCbG9jayBsYXll
ciBjYW4gc3RpbGwgcmVzdW1lDQo+IHRoZW0gYXQgYW55IHRpbWUsIG5vPw0KDQpUaGFua3MgZm9y
IHJlbWluZGluZy4NClllcywgdGhpcyBjaGVjayBpcyB3cm9uZy4gQWxsIFNDU0kgZGV2aWNlcyBz
aGFsbCBiZSBhcHBsaWVkDQpzY3NpX2RldmljZV9xdWllc2NlKCkgaGVyZSBzbyBJIHdpbGwgZml4
IGl0IGluIG5leHQgdmVyc2lvbi4NCg0KPiANCj4gPiArCWlmICghcG1fcnVudGltZV9zdXNwZW5k
ZWQoJnNkZXYtPnNkZXZfZ2VuZGV2KSkNCj4gPiArCQlzY3NpX2RldmljZV9xdWllc2NlKHNkZXYp
Ow0KPiA+ICt9DQo+ID4gKw0KPiA+ICAvKioNCj4gPiAgICogdWZzaGNkX3NodXRkb3duIC0gc2h1
dGRvd24gcm91dGluZQ0KPiA+ICAgKiBAaGJhOiBwZXIgYWRhcHRlciBpbnN0YW5jZQ0KPiA+IEBA
IC04NjQwLDYgKzg2NTMsNyBAQCBFWFBPUlRfU1lNQk9MKHVmc2hjZF9ydW50aW1lX2lkbGUpOw0K
PiA+ICBpbnQgdWZzaGNkX3NodXRkb3duKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ID4gIHsNCj4g
PiAgCWludCByZXQgPSAwOw0KPiA+ICsJc3RydWN0IHNjc2lfdGFyZ2V0ICpzdGFyZ2V0Ow0KPiA+
IA0KPiA+ICAJaWYgKCFoYmEtPmlzX3Bvd2VyZWQpDQo+ID4gIAkJZ290byBvdXQ7DQo+ID4gQEAg
LTg2NDcsMTEgKzg2NjEsMjYgQEAgaW50IHVmc2hjZF9zaHV0ZG93bihzdHJ1Y3QgdWZzX2hiYSAq
aGJhKQ0KPiA+ICAJaWYgKHVmc2hjZF9pc191ZnNfZGV2X3Bvd2Vyb2ZmKGhiYSkgJiYgdWZzaGNk
X2lzX2xpbmtfb2ZmKGhiYSkpDQo+ID4gIAkJZ290byBvdXQ7DQo+ID4gDQo+ID4gLQlpZiAocG1f
cnVudGltZV9zdXNwZW5kZWQoaGJhLT5kZXYpKSB7DQo+ID4gLQkJcmV0ID0gdWZzaGNkX3J1bnRp
bWVfcmVzdW1lKGhiYSk7DQo+ID4gLQkJaWYgKHJldCkNCj4gPiAtCQkJZ290byBvdXQ7DQo+ID4g
LQl9DQo+ID4gKwkvKg0KPiA+ICsJICogTGV0IHJ1bnRpbWUgUE0gZnJhbWV3b3JrIG1hbmFnZSBh
bmQgcHJldmVudCBjb25jdXJyZW50IHJ1bnRpbWUNCj4gPiArCSAqIG9wZXJhdGlvbnMgd2l0aCBz
aHV0ZG93biBmbG93Lg0KPiA+ICsJICovDQo+ID4gKwlwbV9ydW50aW1lX2dldF9zeW5jKGhiYS0+
ZGV2KTsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogUXVpZXNjZSBhbGwgU0NTSSBkZXZpY2Vz
IHRvIHByZXZlbnQgYW55IG5vbi1QTSByZXF1ZXN0cyBzZW5kaW5nDQo+ID4gKwkgKiBmcm9tIGJs
b2NrIGxheWVyIGR1cmluZyBhbmQgYWZ0ZXIgc2h1dGRvd24uDQo+ID4gKwkgKg0KPiA+ICsJICog
SGVyZSB3ZSBjYW4gbm90IHVzZSBibGtfY2xlYW51cF9xdWV1ZSgpIHNpbmNlIFBNIHJlcXVlc3Rz
DQo+ID4gKwkgKiAod2l0aCBCTEtfTVFfUkVRX1BSRUVNUFQgZmxhZykgYXJlIHN0aWxsIHJlcXVp
cmVkIHRvIGJlIHNlbnQNCj4gPiArCSAqIHRocm91Z2ggYmxvY2sgbGF5ZXIuIFRoZXJlZm9yZSBT
Q1NJIGNvbW1hbmQgcXVldWVkIGFmdGVyIHRoZQ0KPiA+ICsJICogc2NzaV90YXJnZXRfcXVpZXNj
ZSgpIGNhbGwgcmV0dXJuZWQgd2lsbCBibG9jayB1bnRpbA0KPiA+ICsJICogYmxrX2NsZWFudXBf
cXVldWUoKSBpcyBjYWxsZWQuDQo+ID4gKwkgKg0KPiA+ICsJICogQmVzaWRlcywgc2NzaV90YXJn
ZXRfInVuInF1aWVzY2UgKGUuZy4sIHNjc2lfdGFyZ2V0X3Jlc3VtZSkgY2FuDQo+ID4gKwkgKiBi
ZSBpZ25vcmVkIHNpbmNlIHNodXRkb3duIGlzIG9uZS13YXkgZmxvdy4NCj4gPiArCSAqLw0KPiA+
ICsJdWZzaGNkX3Njc2lfZm9yX2VhY2hfc2Rldih1ZnNoY2RfcXVpZXNjZV9zZGV2KTsNCj4gDQo+
IEFueSByZWFzb25zIHdoeSBkb24ndCB1c2Ugc2NzaV90YXJnZXRfcXVpZXNjZSgpIGhlcmU/DQoN
CkFzIGFib3ZlLCBub3cgYWxsIFNDU0kgZGV2aWNlcyBzaGFsbCBiZSBxdWllc2NlZCBoZXJlLCBz
byBJIGNvdWxkIHVzZQ0KdGhlIHdheSBpbiB2MjogdXNpbmcgc2NzaV90YXJnZXRfcXVpZXNjZSgp
IGRpcmVjdGx5IGhlcmUuDQoNClRoYW5rcywNCg0KU3RhbmxleSBDaHUgDQoNCj4gDQo+IFRoYW5r
cywNCj4gDQo+IENhbiBHdW8uDQo+IA0KPiA+IA0KPiA+ICAJcmV0ID0gdWZzaGNkX3N1c3BlbmQo
aGJhLCBVRlNfU0hVVERPV05fUE0pOw0KPiA+ICBvdXQ6DQoNCg==

