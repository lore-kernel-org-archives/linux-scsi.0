Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076D9C388F2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 07:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BCEB20870
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 07:20:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="l1EW4HR2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgKCHUd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 02:20:33 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:39126 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725958AbgKCHUd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 02:20:33 -0500
X-UUID: 96c071cbbcdd4140a365f2f15d76e184-20201103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=0HiuX72A5+naga0hM0w9UJh608t4BeLqxJLiQScTmkA=;
        b=l1EW4HR2xeaEpzxY/ZsLYfhAh71ejkWfU9vMAJUNpk/Gil2rbv7CCxsebbeNETLAx0RpSoBSOv96N+cgJ9HkTPOeeFnEkRBQJEtxmu5MAhZWWELAN9ML8INEubKhqiJLFRQjlC5XoYOdWO0JdJm3U+g0awH2PHanBmM2vQAf5Xw=;
X-UUID: 96c071cbbcdd4140a365f2f15d76e184-20201103
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 490589687; Tue, 03 Nov 2020 15:20:26 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 3 Nov 2020 15:20:23 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Nov 2020 15:20:23 +0800
Message-ID: <1604388023.13152.4.camel@mtkswgap22>
Subject: Re: [PATCH v1 2/2] scsi: ufs: Try to save power mode change and UIC
 cmd completion timeout
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
        "Bart Van Assche" <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 3 Nov 2020 15:20:23 +0800
In-Reply-To: <1604384682-15837-3-git-send-email-cang@codeaurora.org>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
         <1604384682-15837-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 8A9DC330F4C6F4935391C02EBF470A1CB124EA8405DA8D9DDCE34028D1CA38E02000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpFeGNlcHQgZm9yIGJlbG93IG5pdCwgb3RoZXJ3aXNlIGxvb2tzIGdvb2QgdG8g
bWUuDQoNClJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29t
Pg0KDQpPbiBNb24sIDIwMjAtMTEtMDIgYXQgMjI6MjQgLTA4MDAsIENhbiBHdW8gd3JvdGU6DQo+
IFVzZSB0aGUgdWljX2NtZC0+Y21kX2FjdGl2ZSBhcyBhIGZsYWcgdG8gdHJhY2sgdGhlIGxpZmVj
eWNsZSBvZiBhbiBVSUMgY21kLg0KPiBUaGUgZmxhZyBpcyBzZXQgYmVmb3JlIHNlbmQgdGhlIFVJ
QyBjbWQgYW5kIGNsZWFyZWQgaW4gSVJRIGhhbmRsZXIuIFdoZW4gYQ0KPiBQTUMgb3IgVUlDIGNt
ZCBjb21wbGV0aW9uIHRpbWVvdXQgaGFwcGVucywgaWYgdGhlIGZsYWcgaXMgbm90IHNldCwgaW5z
dGVhZA0KPiBvZiByZXR1cm5pbmcgdGltZW91dCBlcnJvciwgd2Ugc3RpbGwgdHJlYXQgaXQgYXMg
YSBzdWNjZXNzZnVsIG9wZXJhdGlvbi4NCj4gVGhpcyBpcyB0byBkZWFsIHdpdGggdGhlIHNjZW5h
cmlvIGluIHdoaWNoIGNvbXBsZXRpb24gaGFzIGJlZW4gcmFpc2VkIGJ1dA0KPiB0aGUgb25lIHdh
aXRpbmcgZm9yIHRoZSBjb21wbGV0aW9uIGNhbm5vdCBiZSBhd2FrZW4gaW4gdGltZSBkdWUgdG8g
a2VybmVsDQo+IHNjaGVkdWxpbmcgcHJvYmxlbS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENhbiBH
dW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYyB8IDI2ICsrKysrKysrKysrKysrKysrKysrKysrKy0tDQo+ICBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5oIHwgIDIgKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBpbmRleCBlZmE3ZDg2Li43ZjMzMzEw
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gQEAgLTIxMjIsMTAgKzIxMjIsMjAgQEAgdWZzaGNkX3dh
aXRfZm9yX3VpY19jbWQoc3RydWN0IHVmc19oYmEgKmhiYSwgc3RydWN0IHVpY19jb21tYW5kICp1
aWNfY21kKQ0KPiAgCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ICANCj4gIAlpZiAod2FpdF9mb3Jf
Y29tcGxldGlvbl90aW1lb3V0KCZ1aWNfY21kLT5kb25lLA0KPiAtCQkJCQltc2Vjc190b19qaWZm
aWVzKFVJQ19DTURfVElNRU9VVCkpKQ0KPiArCQkJCQltc2Vjc190b19qaWZmaWVzKFVJQ19DTURf
VElNRU9VVCkpKSB7DQo+ICAJCXJldCA9IHVpY19jbWQtPmFyZ3VtZW50MiAmIE1BU0tfVUlDX0NP
TU1BTkRfUkVTVUxUOw0KPiAtCWVsc2UNCj4gKwl9IGVsc2Ugew0KPiAgCQlyZXQgPSAtRVRJTUVE
T1VUOw0KPiArCQlkZXZfZXJyKGhiYS0+ZGV2LA0KPiArCQkJInVpYyBjbWQgMHgleCB3aXRoIGFy
ZzMgMHgleCBjb21wbGV0aW9uIHRpbWVvdXRcbiIsDQo+ICsJCQl1aWNfY21kLT5jb21tYW5kLCB1
aWNfY21kLT5hcmd1bWVudDMpOw0KPiArDQo+ICsJCWlmICghdWljX2NtZC0+Y21kX2FjdGl2ZSkg
ew0KPiArCQkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBVSUMgY21kIGhhcyBiZWVuIGNvbXBsZXRl
ZCwgcmV0dXJuIHRoZSByZXN1bHRcbiIsDQo+ICsJCQkJX19mdW5jX18pOw0KPiArCQkJcmV0ID0g
dWljX2NtZC0+YXJndW1lbnQyICYgTUFTS19VSUNfQ09NTUFORF9SRVNVTFQ7DQo+ICsJCX0NCj4g
Kwl9DQo+ICANCj4gIAlzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxh
Z3MpOw0KPiAgCWhiYS0+YWN0aXZlX3VpY19jbWQgPSBOVUxMOw0KPiBAQCAtMjE1Nyw2ICsyMTY3
LDcgQEAgX191ZnNoY2Rfc2VuZF91aWNfY21kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHN0cnVjdCB1
aWNfY29tbWFuZCAqdWljX2NtZCwNCj4gIAlpZiAoY29tcGxldGlvbikNCj4gIAkJaW5pdF9jb21w
bGV0aW9uKCZ1aWNfY21kLT5kb25lKTsNCj4gIA0KPiArCXVpY19jbWQtPmNtZF9hY3RpdmUgPSAx
Ow0KPiAgCXVmc2hjZF9kaXNwYXRjaF91aWNfY21kKGhiYSwgdWljX2NtZCk7DQo+ICANCj4gIAly
ZXR1cm4gMDsNCj4gQEAgLTM4MjgsMTAgKzM4MzksMTggQEAgc3RhdGljIGludCB1ZnNoY2RfdWlj
X3B3cl9jdHJsKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHN0cnVjdCB1aWNfY29tbWFuZCAqY21kKQ0K
PiAgCQlkZXZfZXJyKGhiYS0+ZGV2LA0KPiAgCQkJInB3ciBjdHJsIGNtZCAweCV4IHdpdGggbW9k
ZSAweCV4IGNvbXBsZXRpb24gdGltZW91dFxuIiwNCj4gIAkJCWNtZC0+Y29tbWFuZCwgY21kLT5h
cmd1bWVudDMpOw0KPiArDQo+ICsJCWlmICghY21kLT5jbWRfYWN0aXZlKSB7DQo+ICsJCQlkZXZf
ZXJyKGhiYS0+ZGV2LCAiJXM6IFBvd2VyIE1vZGUgQ2hhbmdlIG9wZXJhdGlvbiBoYXMgYmVlbiBj
b21wbGV0ZWQsIGdvIGNoZWNrIFVQTUNSU1xuIiwNCj4gKwkJCQlfX2Z1bmNfXyk7DQo+ICsJCQln
b3RvIGNoZWNrX3VwbWNyczsNCj4gKwkJfQ0KPiArDQo+ICAJCXJldCA9IC1FVElNRURPVVQ7DQo+
ICAJCWdvdG8gb3V0Ow0KPiAgCX0NCj4gIA0KPiArY2hlY2tfdXBtY3JzOg0KPiAgCXN0YXR1cyA9
IHVmc2hjZF9nZXRfdXBtY3JzKGhiYSk7DQo+ICAJaWYgKHN0YXR1cyAhPSBQV1JfTE9DQUwpIHsN
Cj4gIAkJZGV2X2VycihoYmEtPmRldiwNCj4gQEAgLTQ5MjMsMTEgKzQ5NDIsMTQgQEAgc3RhdGlj
IGlycXJldHVybl90IHVmc2hjZF91aWNfY21kX2NvbXBsKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUz
MiBpbnRyX3N0YXR1cykNCj4gIAkJCXVmc2hjZF9nZXRfdWljX2NtZF9yZXN1bHQoaGJhKTsNCj4g
IAkJaGJhLT5hY3RpdmVfdWljX2NtZC0+YXJndW1lbnQzID0NCj4gIAkJCXVmc2hjZF9nZXRfZG1l
X2F0dHJfdmFsKGhiYSk7DQo+ICsJCWlmICghaGJhLT51aWNfYXN5bmNfZG9uZSkNCg0KSXMgdGhp
cyBjaGVjayBuZWNlc3Nhcnk/DQoNCj4gKwkJCWhiYS0+YWN0aXZlX3VpY19jbWQtPmNtZF9hY3Rp
dmUgPSAwOw0KPiAgCQljb21wbGV0ZSgmaGJhLT5hY3RpdmVfdWljX2NtZC0+ZG9uZSk7DQo+ICAJ
CXJldHZhbCA9IElSUV9IQU5ETEVEOw0KPiAgCX0NCj4gIA0KPiAgCWlmICgoaW50cl9zdGF0dXMg
JiBVRlNIQ0RfVUlDX1BXUl9NQVNLKSAmJiBoYmEtPnVpY19hc3luY19kb25lKSB7DQo+ICsJCWhi
YS0+YWN0aXZlX3VpY19jbWQtPmNtZF9hY3RpdmUgPSAwOw0KPiAgCQljb21wbGV0ZShoYmEtPnVp
Y19hc3luY19kb25lKTsNCj4gIAkJcmV0dmFsID0gSVJRX0hBTkRMRUQ7DQo+ICAJfQ0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmgNCj4gaW5kZXggNjZlNTMzOC4uYmU5ODJlZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuaA0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQo+IEBA
IC02NCw2ICs2NCw3IEBAIGVudW0gZGV2X2NtZF90eXBlIHsNCj4gICAqIEBhcmd1bWVudDE6IFVJ
QyBjb21tYW5kIGFyZ3VtZW50IDENCj4gICAqIEBhcmd1bWVudDI6IFVJQyBjb21tYW5kIGFyZ3Vt
ZW50IDINCj4gICAqIEBhcmd1bWVudDM6IFVJQyBjb21tYW5kIGFyZ3VtZW50IDMNCj4gKyAqIEBj
bWRfYWN0aXZlOiBJbmRpY2F0ZSBpZiBVSUMgY29tbWFuZCBpcyBvdXRzdGFuZGluZw0KPiAgICog
QGRvbmU6IFVJQyBjb21tYW5kIGNvbXBsZXRpb24NCj4gICAqLw0KPiAgc3RydWN0IHVpY19jb21t
YW5kIHsNCj4gQEAgLTcxLDYgKzcyLDcgQEAgc3RydWN0IHVpY19jb21tYW5kIHsNCj4gIAl1MzIg
YXJndW1lbnQxOw0KPiAgCXUzMiBhcmd1bWVudDI7DQo+ICAJdTMyIGFyZ3VtZW50MzsNCj4gKwlp
bnQgY21kX2FjdGl2ZTsNCj4gIAlzdHJ1Y3QgY29tcGxldGlvbiBkb25lOw0KPiAgfTsNCj4gIA0K
DQoNCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0K

