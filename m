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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387ECC64E69
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 05:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7C8020857
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 05:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="biD76Btr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgKXFUa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 00:20:30 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:36488 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725616AbgKXFU3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 00:20:29 -0500
X-UUID: da9cc1d353b84cfbb1e81dfa1e6757be-20201124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=NfQmMM/orParexRB8Noa+Zaucw5CP6uPRmy+w7iAsCw=;
        b=biD76BtrMYUqyq4IdM6pOcjvw0veuu7gH3QfXOzEKScJEw5OUkEDq7Yh+GpvKsc1om3vsnMAnA3w/FjnmdKvxPGRAEG+sWHE2X2DD14SFHsBCOPUzyR2fBXiInDyyo45LUA87E2dJ1e41NmIW+gYKuv9Mq4h+nYmTk9bxcvRlvA=;
X-UUID: da9cc1d353b84cfbb1e81dfa1e6757be-20201124
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 745394357; Tue, 24 Nov 2020 13:20:23 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 24 Nov 2020 13:20:21 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Nov 2020 13:20:21 +0800
Message-ID: <1606195221.17338.6.camel@mtkswgap22>
Subject: Re: [PATCH] scsi: ufs: Don't disable core_clk_unipro if the link is
 active
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <ziqichen@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        <kuohong.wang@mediatek.com>
Date:   Tue, 24 Nov 2020 13:20:21 +0800
In-Reply-To: <1606194312-25378-1-git-send-email-cang@codeaurora.org>
References: <1606194312-25378-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBNb24sIDIwMjAtMTEtMjMgYXQgMjE6MDUgLTA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IElmIHdlIHdhbnQgdG8gZGlzYWJsZSBjbG9ja3MgYnV0IHN0aWxsIGtlZXAgdGhlIGxp
bmsgYWN0aXZlLCBib3RoIHJlZl9jbGsNCj4gYW5kIGNvcmVfY2xrX3VuaXBybyBzaG91bGQgYmUg
c2tpcHBlZC4NCj4gDQoNCiJjb3JlX2Nsa191bmlwcm8iIHNlZW1zIHVzZWQgYnkgdWZzLXFjb20g
b25seSBhbmQgbm90IGRlZmluZWQgaW4gdGhlIFVGUw0KcGxhdGZvcm0gYmluZGluZyBkb2N1bWVu
dDogdWZzaGNkX3BsdGZybS50eHQuDQoNCkNvdWxkIHlvdSBwbGVhc2UgYWRkIHRoZSBkZWZpbml0
aW9uIGZpcnN0IGFuZCB0aGVuIGl0IHdvdWxkIGJlDQpyZWFzb25hYmxlIHRvIGJlIHVzZWQgaW4g
Y29tbW9uIGRyaXZlcj8NCg0KT3IsIGhvdyBhYm91dCBhZGQgYSBmbGFnIGluIHN0cnVjdCB1ZnNf
Y2xrX2luZm8gaW5kaWNhdGluZyBpZiB0aGlzIGNsb2NrDQpuZWVkcyBiZSBPTiB0byBrZWVwIHRo
ZSBsaW5rIGFjdGl2ZT8gVGhlIGZsYWcgY291bGQgYmUgc2V0IHByb3Blcmx5IGJ5DQp2ZW5kb3Ig
aW5pdGlhbGl6YXRpb24gZnVuY3Rpb25zLiBJbiB0aGlzIHdheSwgd2UgY2FuIGFsc28gcmVtb3Zl
IHRoZQ0KaGFyZC1jb2RlZCAicmVmX2NsayIgaW4gX191ZnNoY2Rfc2V0dXBfY2xvY2tzKCkuDQoN
ClRoYW5rcy4NClN0YW5sZXkgQ2h1DQoNCj4gU2lnbmVkLW9mZi1ieTogQ2FuIEd1byA8Y2FuZ0Bj
b2RlYXVyb3JhLm9yZz4NCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBpbmRleCBhNzg1N2Y2Li42OWMyZTkx
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gQEAgLTIyMiw3ICsyMjIsNyBAQCBzdGF0aWMgaW50IHVm
c2hjZF9jbGVhcl90bV9jbWQoc3RydWN0IHVmc19oYmEgKmhiYSwgaW50IHRhZyk7DQo+ICBzdGF0
aWMgdm9pZCB1ZnNoY2RfaGJhX2V4aXQoc3RydWN0IHVmc19oYmEgKmhiYSk7DQo+ICBzdGF0aWMg
aW50IHVmc2hjZF9wcm9iZV9oYmEoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBhc3luYyk7DQo+
ICBzdGF0aWMgaW50IF9fdWZzaGNkX3NldHVwX2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBi
b29sIG9uLA0KPiAtCQkJCSBib29sIHNraXBfcmVmX2Nsayk7DQo+ICsJCQkJIGJvb2wga2VlcF9s
aW5rX2FjdGl2ZSk7DQo+ICBzdGF0aWMgaW50IHVmc2hjZF9zZXR1cF9jbG9ja3Moc3RydWN0IHVm
c19oYmEgKmhiYSwgYm9vbCBvbik7DQo+ICBzdGF0aWMgaW50IHVmc2hjZF91aWNfaGliZXJuOF9l
bnRlcihzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCB1ZnNoY2Rf
YWRkX2RlbGF5X2JlZm9yZV9kbWVfY21kKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KPiBAQCAtMTcx
MCw3ICsxNzEwLDYgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2dhdGVfd29yayhzdHJ1Y3Qgd29ya19z
dHJ1Y3QgKndvcmspDQo+ICAJaWYgKCF1ZnNoY2RfaXNfbGlua19hY3RpdmUoaGJhKSkNCj4gIAkJ
dWZzaGNkX3NldHVwX2Nsb2NrcyhoYmEsIGZhbHNlKTsNCj4gIAllbHNlDQo+IC0JCS8qIElmIGxp
bmsgaXMgYWN0aXZlLCBkZXZpY2UgcmVmX2NsayBjYW4ndCBiZSBzd2l0Y2hlZCBvZmYgKi8NCj4g
IAkJX191ZnNoY2Rfc2V0dXBfY2xvY2tzKGhiYSwgZmFsc2UsIHRydWUpOw0KPiAgDQo+ICAJLyoN
Cj4gQEAgLTc5OTEsNyArNzk5MCw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2luaXRfaGJhX3ZyZWco
c3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIH0NCj4gIA0KPiAgc3RhdGljIGludCBfX3Vmc2hjZF9z
ZXR1cF9jbG9ja3Moc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBvbiwNCj4gLQkJCQkJYm9vbCBz
a2lwX3JlZl9jbGspDQo+ICsJCQkJCWJvb2wga2VlcF9saW5rX2FjdGl2ZSkNCj4gIHsNCj4gIAlp
bnQgcmV0ID0gMDsNCj4gIAlzdHJ1Y3QgdWZzX2Nsa19pbmZvICpjbGtpOw0KPiBAQCAtODAwOSw3
ICs4MDA4LDEzIEBAIHN0YXRpYyBpbnQgX191ZnNoY2Rfc2V0dXBfY2xvY2tzKHN0cnVjdCB1ZnNf
aGJhICpoYmEsIGJvb2wgb24sDQo+ICANCj4gIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNsa2ksIGhl
YWQsIGxpc3QpIHsNCj4gIAkJaWYgKCFJU19FUlJfT1JfTlVMTChjbGtpLT5jbGspKSB7DQo+IC0J
CQlpZiAoc2tpcF9yZWZfY2xrICYmICFzdHJjbXAoY2xraS0+bmFtZSwgInJlZl9jbGsiKSkNCj4g
KwkJCS8qDQo+ICsJCQkgKiBUbyBrZWVwIGxpbmsgYWN0aXZlLCByZWZfY2xrIGFuZCBjb3JlX2Ns
a191bmlwcm8NCj4gKwkJCSAqIHNob3VsZCBiZSBrZXB0IE9OLg0KPiArCQkJICovDQo+ICsJCQlp
ZiAoa2VlcF9saW5rX2FjdGl2ZSAmJg0KPiArCQkJICAgICghc3RyY21wKGNsa2ktPm5hbWUsICJy
ZWZfY2xrIikgfHwNCj4gKwkJCSAgICAgIXN0cmNtcChjbGtpLT5uYW1lLCAiY29yZV9jbGtfdW5p
cHJvIikpKQ0KPiAgCQkJCWNvbnRpbnVlOw0KPiAgDQo+ICAJCQljbGtfc3RhdGVfY2hhbmdlZCA9
IG9uIF4gY2xraS0+ZW5hYmxlZDsNCj4gQEAgLTg1ODAsNyArODU4NSw2IEBAIHN0YXRpYyBpbnQg
dWZzaGNkX3N1c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3Ap
DQo+ICAJaWYgKCF1ZnNoY2RfaXNfbGlua19hY3RpdmUoaGJhKSkNCj4gIAkJdWZzaGNkX3NldHVw
X2Nsb2NrcyhoYmEsIGZhbHNlKTsNCj4gIAllbHNlDQo+IC0JCS8qIElmIGxpbmsgaXMgYWN0aXZl
LCBkZXZpY2UgcmVmX2NsayBjYW4ndCBiZSBzd2l0Y2hlZCBvZmYgKi8NCj4gIAkJX191ZnNoY2Rf
c2V0dXBfY2xvY2tzKGhiYSwgZmFsc2UsIHRydWUpOw0KPiAgDQo+ICAJaWYgKHVmc2hjZF9pc19j
bGtnYXRpbmdfYWxsb3dlZChoYmEpKSB7DQoNCg==

