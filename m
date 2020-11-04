Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03C5C388F2
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 02:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B634223C6
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 02:55:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="tE5VNKSJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgKDCzk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 21:55:40 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:37927 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728972AbgKDCzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 21:55:40 -0500
X-UUID: a72b7571c8cc40ff83dfeb60b4dd9d95-20201104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=MP5e0QhgKIA+MvW5wSngQc0UfzfVuo9vvk7lQqjo+p0=;
        b=tE5VNKSJ0yUzn3Nj9XvCv/jPM8rG6QGwzj2rEpuqa25B1w45fObTTsdGLsBSaCsBkP+NWEJFjm9VWKc2AsoEcVqAA4JV0799HmrVZMRpnbyG/0PpMPScaAHLcoo0HQWizj3HYEri7Yw+ACWg5rIFHTObqKKOLz0FDapfMh1AlUA=;
X-UUID: a72b7571c8cc40ff83dfeb60b4dd9d95-20201104
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 847137746; Wed, 04 Nov 2020 10:55:34 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 4 Nov 2020 10:55:27 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 4 Nov 2020 10:55:27 +0800
Message-ID: <1604458527.13152.15.camel@mtkswgap22>
Subject: Re: [PATCH V4 2/2] scsi: ufs: Allow an error return value from
 ->device_reset()
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>, Bean Huo <huobean@gmail.com>,
        Can Guo <cang@codeaurora.org>
Date:   Wed, 4 Nov 2020 10:55:27 +0800
In-Reply-To: <20201103141403.2142-3-adrian.hunter@intel.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
         <20201103141403.2142-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: EF6601121EECEF1499E3C4156E8C9E57BAE39532E39BFBA5EE15079F53CCD5282000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQWRyaWFuLA0KDQpPbiBUdWUsIDIwMjAtMTEtMDMgYXQgMTY6MTQgKzAyMDAsIEFkcmlhbiBI
dW50ZXIgd3JvdGU6DQo+IEl0IGlzIHNpbXBsZXIgZm9yIGRyaXZlcnMgdG8gcHJvdmlkZSBhIC0+
ZGV2aWNlX3Jlc2V0KCkgY2FsbGJhY2sNCj4gaXJyZXNwZWN0aXZlIG9mIHdoZXRoZXIgdGhlIEdQ
SU8sIG9yIGZpcm13YXJlIGludGVyZmFjZSBuZWNlc3NhcnkgdG8gZG8gdGhlDQo+IHJlc2V0LCBp
cyBkaXNjb3ZlcmVkIGR1cmluZyBwcm9iZS4NCj4gDQo+IENoYW5nZSAtPmRldmljZV9yZXNldCgp
IHRvIHJldHVybiBhbiBlcnJvciBjb2RlLiAgRHJpdmVycyB0aGF0IHByb3ZpZGUNCj4gdGhlIGNh
bGxiYWNrLCBidXQgZG8gbm90IGRvIHRoZSByZXNldCBvcGVyYXRpb24gc2hvdWxkIHJldHVybiAt
RU9QTk9UU1VQUC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFkcmlhbiBIdW50ZXIgPGFkcmlhbi5o
dW50ZXJAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgfCAgNCArKystDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1xY29tLmMgICAgIHwgIDYgKysr
Ky0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oICAgICAgIHwgMTEgKysrKysrKy0tLS0N
Cj4gIDMgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiBpbmRleCA4ZGY3M2JjMmY4Y2IuLjkxNGE4Mjdh
OTNlZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiAr
KysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQo+IEBAIC03NDMsNyArNzQzLDcg
QEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc3RhcnR1cF9ub3RpZnkoc3RydWN0IHVmc19oYmEg
KmhiYSwNCj4gIAlyZXR1cm4gcmV0Ow0KPiAgfQ0KPiAgDQo+IC1zdGF0aWMgdm9pZCB1ZnNfbXRr
X2RldmljZV9yZXNldChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiArc3RhdGljIGludCB1ZnNfbXRr
X2RldmljZV9yZXNldChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgew0KPiAgCXN0cnVjdCBhcm1f
c21jY2NfcmVzIHJlczsNCj4gIA0KPiBAQCAtNzY0LDYgKzc2NCw4IEBAIHN0YXRpYyB2b2lkIHVm
c19tdGtfZGV2aWNlX3Jlc2V0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICAJdXNsZWVwX3Jhbmdl
KDEwMDAwLCAxNTAwMCk7DQo+ICANCj4gIAlkZXZfaW5mbyhoYmEtPmRldiwgImRldmljZSByZXNl
dCBkb25lXG4iKTsNCj4gKw0KPiArCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgaW50
IHVmc19tdGtfbGlua19zZXRfaHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1xY29tLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1xY29t
LmMNCj4gaW5kZXggOWExOWM2ZDE1ZDNiLi4zNTdjM2I0OTMyMWQgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzLXFjb20uYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1x
Y29tLmMNCj4gQEAgLTE0MjIsMTMgKzE0MjIsMTMgQEAgc3RhdGljIHZvaWQgdWZzX3Fjb21fZHVt
cF9kYmdfcmVncyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgICoNCj4gICAqIFRvZ2dsZXMgdGhl
IChvcHRpb25hbCkgcmVzZXQgbGluZSB0byByZXNldCB0aGUgYXR0YWNoZWQgZGV2aWNlLg0KPiAg
ICovDQo+IC1zdGF0aWMgdm9pZCB1ZnNfcWNvbV9kZXZpY2VfcmVzZXQoc3RydWN0IHVmc19oYmEg
KmhiYSkNCj4gK3N0YXRpYyBpbnQgdWZzX3Fjb21fZGV2aWNlX3Jlc2V0KHN0cnVjdCB1ZnNfaGJh
ICpoYmEpDQo+ICB7DQo+ICAJc3RydWN0IHVmc19xY29tX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0
X3ZhcmlhbnQoaGJhKTsNCj4gIA0KPiAgCS8qIHJlc2V0IGdwaW8gaXMgb3B0aW9uYWwgKi8NCj4g
IAlpZiAoIWhvc3QtPmRldmljZV9yZXNldCkNCj4gLQkJcmV0dXJuOw0KPiArCQlyZXR1cm4gLUVP
UE5PVFNVUFA7DQo+ICANCj4gIAkvKg0KPiAgCSAqIFRoZSBVRlMgZGV2aWNlIHNoYWxsIGRldGVj
dCByZXNldCBwdWxzZXMgb2YgMXVzLCBzbGVlcCBmb3IgMTB1cyB0bw0KPiBAQCAtMTQzOSw2ICsx
NDM5LDggQEAgc3RhdGljIHZvaWQgdWZzX3Fjb21fZGV2aWNlX3Jlc2V0KHN0cnVjdCB1ZnNfaGJh
ICpoYmEpDQo+ICANCj4gIAlncGlvZF9zZXRfdmFsdWVfY2Fuc2xlZXAoaG9zdC0+ZGV2aWNlX3Jl
c2V0LCAwKTsNCj4gIAl1c2xlZXBfcmFuZ2UoMTAsIDE1KTsNCj4gKw0KPiArCXJldHVybiAwOw0K
PiAgfQ0KPiAgDQo+ICAjaWYgSVNfRU5BQkxFRChDT05GSUdfREVWRlJFUV9HT1ZfU0lNUExFX09O
REVNQU5EKQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gaW5kZXggMjEzYmUwNjY3YjU5Li41MTkxZDg3ZjYyNjMg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gKysrIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuaA0KPiBAQCAtMzIzLDcgKzMyMyw3IEBAIHN0cnVjdCB1ZnNfaGJh
X3ZhcmlhbnRfb3BzIHsNCj4gIAlpbnQgICAgICgqcmVzdW1lKShzdHJ1Y3QgdWZzX2hiYSAqLCBl
bnVtIHVmc19wbV9vcCk7DQo+ICAJdm9pZAkoKmRiZ19yZWdpc3Rlcl9kdW1wKShzdHJ1Y3QgdWZz
X2hiYSAqaGJhKTsNCj4gIAlpbnQJKCpwaHlfaW5pdGlhbGl6YXRpb24pKHN0cnVjdCB1ZnNfaGJh
ICopOw0KPiAtCXZvaWQJKCpkZXZpY2VfcmVzZXQpKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KPiAr
CWludAkoKmRldmljZV9yZXNldCkoc3RydWN0IHVmc19oYmEgKmhiYSk7DQo+ICAJdm9pZAkoKmNv
bmZpZ19zY2FsaW5nX3BhcmFtKShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiAgCQkJCQlzdHJ1Y3Qg
ZGV2ZnJlcV9kZXZfcHJvZmlsZSAqcHJvZmlsZSwNCj4gIAkJCQkJdm9pZCAqZGF0YSk7DQo+IEBA
IC0xMjA3LDkgKzEyMDcsMTIgQEAgc3RhdGljIGlubGluZSB2b2lkIHVmc2hjZF92b3BzX2RiZ19y
ZWdpc3Rlcl9kdW1wKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICBzdGF0aWMgaW5saW5lIHZvaWQg
dWZzaGNkX3ZvcHNfZGV2aWNlX3Jlc2V0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICB7DQo+ICAJ
aWYgKGhiYS0+dm9wcyAmJiBoYmEtPnZvcHMtPmRldmljZV9yZXNldCkgew0KPiAtCQloYmEtPnZv
cHMtPmRldmljZV9yZXNldChoYmEpOw0KPiAtCQl1ZnNoY2Rfc2V0X3Vmc19kZXZfYWN0aXZlKGhi
YSk7DQo+IC0JCXVmc2hjZF91cGRhdGVfcmVnX2hpc3QoJmhiYS0+dWZzX3N0YXRzLmRldl9yZXNl
dCwgMCk7DQo+ICsJCWludCBlcnIgPSBoYmEtPnZvcHMtPmRldmljZV9yZXNldChoYmEpOw0KPiAr
DQo+ICsJCWlmICghZXJyKQ0KPiArCQkJdWZzaGNkX3NldF91ZnNfZGV2X2FjdGl2ZShoYmEpOw0K
PiArCQlpZiAoZXJyICE9IC1FT1BOT1RTVVBQKQ0KPiArCQkJdWZzaGNkX3VwZGF0ZV9yZWdfaGlz
dCgmaGJhLT51ZnNfc3RhdHMuZGV2X3Jlc2V0LCBlcnIpOw0KPiAgCX0NCj4gIH0NCg0KRm9yIHVm
cy1tZWRpYXRlayBwYXJ0IGFuZCByZWxhdGVkIGZsb3csDQoNClJldmlld2VkLWJ5OiBTdGFubGV5
IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQo=

