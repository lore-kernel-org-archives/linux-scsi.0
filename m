Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC59C3F68F
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 02:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3036B21744
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 02:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jwgYgx7D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgBECuq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 21:50:46 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:35399 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727796AbgBECuq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 21:50:46 -0500
X-UUID: 6ac2d375c3aa4ef7b3ac8b7f70286ff6-20200205
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=bbDYs9ZTXuzhLMo2u22hyWHcIsTbuzxFDPN8bwDnwbA=;
        b=jwgYgx7D2vQB0p3A59Wd/0XoiHHdJAn6xnx/8iDqkn14hjgPlu3YVSEVyKN9yqwjMJVgl2BCcQr+7qRjmppS4zdxQfcfsPPW/O2p2IhRhqW1n46oyzJso5GAFSoEG5gqdQiSUnXVRRSUHz46cpCDXRtPK80V04qZ+1vksIm/j54=;
X-UUID: 6ac2d375c3aa4ef7b3ac8b7f70286ff6-20200205
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1358086162; Wed, 05 Feb 2020 10:50:41 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 5 Feb 2020 10:49:55 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 5 Feb 2020 10:50:18 +0800
Message-ID: <1580871040.21785.7.camel@mtksdccf07>
Subject: Re: [PATCH v5 6/8] scsi: ufs: Add dev ref clock gating wait time
 support
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 5 Feb 2020 10:50:40 +0800
In-Reply-To: <1580721472-10784-7-git-send-email-cang@codeaurora.org>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
         <1580721472-10784-7-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBNb24sIDIwMjAtMDItMDMgYXQgMDE6MTcgLTA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEluIFVGUyB2ZXJzaW9uIDMuMCwgYSBuZXdseSBhZGRlZCBhdHRyaWJ1dGUgYlJlZkNs
a0dhdGluZ1dhaXRUaW1lIGRlZmluZXMNCj4gdGhlIG1pbmltdW0gdGltZSBmb3Igd2hpY2ggdGhl
IHJlZmVyZW5jZSBjbG9jayBpcyByZXF1aXJlZCBieSBkZXZpY2UgZHVyaW5nDQo+IHRyYW5zaXRp
b24gdG8gTFMtTU9ERSBvciBISUJFUk44IHN0YXRlLiBNYWtlIHRoaXMgY2hhbmdlIHRvIHJlZmxl
Y3QgdGhlIG5ldw0KPiByZXF1aXJlbWVudCBieSBhZGRpbmcgZGVsYXlzIGJlZm9yZSB0dXJuaW5n
IG9mZiB0aGUgY2xvY2suDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVh
dXJvcmEub3JnPg0KPiBSZXZpZXdlZC1ieTogQXN1dG9zaCBEYXMgPGFzdXRvc2hkQGNvZGVhdXJv
cmEub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLmggICAgfCAgMyArKysNCj4g
IGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA0MCArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDQzIGluc2VydGlvbnMoKykNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnMuaA0KPiBpbmRleCBjZmUzODAzLi4zMDQwNzZlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy5oDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLmgNCj4gQEAgLTE2
Nyw2ICsxNjcsNyBAQCBlbnVtIGF0dHJfaWRuIHsNCj4gIAlRVUVSWV9BVFRSX0lETl9GRlVfU1RB
VFVTCQk9IDB4MTQsDQo+ICAJUVVFUllfQVRUUl9JRE5fUFNBX1NUQVRFCQk9IDB4MTUsDQo+ICAJ
UVVFUllfQVRUUl9JRE5fUFNBX0RBVEFfU0laRQkJPSAweDE2LA0KPiArCVFVRVJZX0FUVFJfSURO
X1JFRl9DTEtfR0FUSU5HX1dBSVRfVElNRQk9IDB4MTcsDQo+ICB9Ow0KPiAgDQo+ICAvKiBEZXNj
cmlwdG9yIGlkbiBmb3IgUXVlcnkgcmVxdWVzdHMgKi8NCj4gQEAgLTUzNCw2ICs1MzUsOCBAQCBz
dHJ1Y3QgdWZzX2Rldl9pbmZvIHsNCj4gIAl1MTYgd21hbnVmYWN0dXJlcmlkOw0KPiAgCS8qVUZT
IGRldmljZSBQcm9kdWN0IE5hbWUgKi8NCj4gIAl1OCAqbW9kZWw7DQo+ICsJdTE2IHNwZWNfdmVy
c2lvbjsNCj4gKwl1MzIgY2xrX2dhdGluZ193YWl0X3VzOw0KPiAgfTsNCj4gIA0KPiAgLyoqDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYw0KPiBpbmRleCBlOGY3ZjlkLi5kNWM1NDdiIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMN
Cj4gQEAgLTkxLDYgKzkxLDkgQEANCj4gIC8qIGRlZmF1bHQgZGVsYXkgb2YgYXV0b3N1c3BlbmQ6
IDIwMDAgbXMgKi8NCj4gICNkZWZpbmUgUlBNX0FVVE9TVVNQRU5EX0RFTEFZX01TIDIwMDANCj4g
IA0KPiArLyogRGVmYXVsdCB2YWx1ZSBvZiB3YWl0IHRpbWUgYmVmb3JlIGdhdGluZyBkZXZpY2Ug
cmVmIGNsb2NrICovDQo+ICsjZGVmaW5lIFVGU0hDRF9SRUZfQ0xLX0dBVElOR19XQUlUX1VTIDB4
RkYgLyogbWljcm9zZWNzICovDQo+ICsNCj4gICNkZWZpbmUgdWZzaGNkX3RvZ2dsZV92cmVnKF9k
ZXYsIF92cmVnLCBfb24pCQkJCVwNCj4gIAkoeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiAgCQlpbnQgX3JldDsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gQEAgLTMyODEsNiAr
MzI4NCwzNyBAQCBzdGF0aWMgaW5saW5lIGludCB1ZnNoY2RfcmVhZF91bml0X2Rlc2NfcGFyYW0o
c3RydWN0IHVmc19oYmEgKmhiYSwNCj4gIAkJCQkgICAgICBwYXJhbV9vZmZzZXQsIHBhcmFtX3Jl
YWRfYnVmLCBwYXJhbV9zaXplKTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGludCB1ZnNoY2RfZ2V0
X3JlZl9jbGtfZ2F0aW5nX3dhaXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gK3sNCj4gKwlpbnQg
ZXJyID0gMDsNCj4gKwl1MzIgZ2F0aW5nX3dhaXQgPSBVRlNIQ0RfUkVGX0NMS19HQVRJTkdfV0FJ
VF9VUzsNCj4gKw0KPiArCWlmIChoYmEtPmRldl9pbmZvLnNwZWNfdmVyc2lvbiA+PSAweDMwMCkg
ew0KPiArCQllcnIgPSB1ZnNoY2RfcXVlcnlfYXR0cl9yZXRyeShoYmEsIFVQSVVfUVVFUllfT1BD
T0RFX1JFQURfQVRUUiwNCj4gKwkJCQlRVUVSWV9BVFRSX0lETl9SRUZfQ0xLX0dBVElOR19XQUlU
X1RJTUUsIDAsIDAsDQo+ICsJCQkJJmdhdGluZ193YWl0KTsNCj4gKwkJaWYgKGVycikNCj4gKwkJ
CWRldl9lcnIoaGJhLT5kZXYsICJGYWlsZWQgcmVhZGluZyBiUmVmQ2xrR2F0aW5nV2FpdC4gZXJy
ID0gJWQsIHVzZSBkZWZhdWx0ICV1dXNcbiIsDQo+ICsJCQkJCSBlcnIsIGdhdGluZ193YWl0KTsN
Cj4gKw0KPiArCQlpZiAoZ2F0aW5nX3dhaXQgPT0gMCkgew0KPiArCQkJZ2F0aW5nX3dhaXQgPSBV
RlNIQ0RfUkVGX0NMS19HQVRJTkdfV0FJVF9VUzsNCj4gKwkJCWRldl9lcnIoaGJhLT5kZXYsICJV
bmRlZmluZWQgcmVmIGNsayBnYXRpbmcgd2FpdCB0aW1lLCB1c2UgZGVmYXVsdCAldXVzXG4iLA0K
PiArCQkJCQkgZ2F0aW5nX3dhaXQpOw0KPiArCQl9DQo+ICsNCj4gKwkJLyoNCj4gKwkJICogYlJl
ZkNsa0dhdGluZ1dhaXRUaW1lIGRlZmluZXMgdGhlIG1pbmltdW0gdGltZSBmb3Igd2hpY2ggdGhl
DQo+ICsJCSAqIHJlZmVyZW5jZSBjbG9jayBpcyByZXF1aXJlZCBieSBkZXZpY2UgZHVyaW5nIHRy
YW5zaXRpb24gZnJvbQ0KPiArCQkgKiBIUy1NT0RFIHRvIExTLU1PREUgb3IgSElCRVJOOCBzdGF0
ZS4gR2l2ZSBpdCBtb3JlIHRpbWUgdG8gYmUNCj4gKwkJICogb24gdGhlIHNhZmUgc2lkZS4NCj4g
KwkJICovDQo+ICsJCWhiYS0+ZGV2X2luZm8uY2xrX2dhdGluZ193YWl0X3VzID0gZ2F0aW5nX3dh
aXQgKyA1MDsNCg0KDQpOb3Qgc3VyZSBpZiB0aGUgYWRkaXRpb25hbCA1MHVzIHdhaXQgdGltZSBo
ZXJlIGlzIHRvbyBsYXJnZS4NCg0KSXMgdGhlcmUgYW55IHNwZWNpYWwgcmVhc29uIHRvIGZpeCBp
dCBhcyAiNTAiPw0KDQoNClRoYW5rcywNClN0YW5sZXkNCg0KPiAgCQkJCSAgICAgICZkZXZfaW5m
by0+bW9kZWwsIFNEX0FTQ0lJX1NURCk7DQo+IEBAIC03MDAzLDYgKzcwNDEsOCBAQCBzdGF0aWMg
aW50IHVmc2hjZF9kZXZpY2VfcGFyYW1zX2luaXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIAkJ
Z290byBvdXQ7DQo+ICAJfQ0KPiAgDQo+ICsJdWZzaGNkX2dldF9yZWZfY2xrX2dhdGluZ193YWl0
KGhiYSk7DQo+ICsNCj4gIAl1ZnNfZml4dXBfZGV2aWNlX3NldHVwKGhiYSk7DQo+ICANCj4gIAlp
ZiAoIXVmc2hjZF9xdWVyeV9mbGFnX3JldHJ5KGhiYSwgVVBJVV9RVUVSWV9PUENPREVfUkVBRF9G
TEFHLA0KDQo=

