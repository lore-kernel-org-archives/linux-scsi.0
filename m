Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3478C1B0D8
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 01:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F99B23405
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 01:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgLQB2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 20:28:43 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:42541 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbgLQB2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 20:28:43 -0500
X-UUID: e64650355f984528820cc7eb8ecea633-20201217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=6zUO/pFL9ZBaYYczz1xolU5TEIyS65c1XFta+4Buk+k=;
        b=aDCe0PQ5HhntOGOlYT82oQnpVljXDRdhntA1jtleUrzrt+fRBh3DuwWnKWzkG4Ry2bFRlW1VRwOgzKN4/9AZz7KcGoOjm3+8Y4BDgYMZLeG0iAZMzROKZ1XL7uFu9hiZwsnZRwsNLbgTVIKgX002gbzCul/HfJVxkGX7OXj/GUk=;
X-UUID: e64650355f984528820cc7eb8ecea633-20201217
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 516339937; Thu, 17 Dec 2020 09:27:56 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 17 Dec 2020 09:27:54 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 09:27:51 +0800
Message-ID: <1608168474.10163.37.camel@mtkswgap22>
Subject: Re: [PATCH] scsi: ufs: fix livelock on ufshcd_clear_ua_wlun
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <cang@codeaurora.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <bvanassche@acm.org>, <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@google.com>
Date:   Thu, 17 Dec 2020 09:27:54 +0800
In-Reply-To: <20201216190225.2769012-1-jaegeuk@kernel.org>
References: <20201216190225.2769012-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSmFlZ2V1aywNCg0KT24gV2VkLCAyMDIwLTEyLTE2IGF0IDExOjAyIC0wODAwLCBKYWVnZXVr
IEtpbSB3cm90ZToNCj4gRnJvbTogSmFlZ2V1ayBLaW0gPGphZWdldWtAZ29vZ2xlLmNvbT4NCj4g
DQo+IFRoaXMgZml4ZXMgdGhlIGJlbG93IGxpdmVsb2NrIHdoaWNoIGlzIGNhdXNlZCBieSBjYWxs
aW5nIGEgc2NzaSBjb21tYW5kIGJlZm9yZQ0KPiB1ZnNoY2Rfc2NzaV91bmJsb2NrX3JlcXVlc3Rz
KCkgaW4gdWZzaGNkX3VuZ2F0ZV93b3JrKCkuDQo+IA0KPiBXb3JrcXVldWU6IHVmc19jbGtfZ2F0
aW5nXzAgdWZzaGNkX3VuZ2F0ZV93b3JrDQo+IENhbGwgdHJhY2U6DQo+ICBfX3N3aXRjaF90bysw
eDI5OC8weDJiYw0KPiAgX19zY2hlZHVsZSsweDU5Yy8weDc2MA0KPiAgc2NoZWR1bGUrMHhhYy8w
eGYwDQo+ICBzY2hlZHVsZV90aW1lb3V0KzB4NDQvMHgxYjQNCj4gIGlvX3NjaGVkdWxlX3RpbWVv
dXQrMHg0NC8weDY4DQo+ICB3YWl0X2Zvcl9jb21tb25faW8rMHg3Yy8weDEwMA0KPiAgd2FpdF9m
b3JfY29tcGxldGlvbl9pbysweDE0LzB4MjANCj4gIGJsa19leGVjdXRlX3JxKzB4OTQvMHhkMA0K
PiAgX19zY3NpX2V4ZWN1dGUrMHgxMDAvMHgxYzANCj4gIHVmc2hjZF9jbGVhcl91YV93bHVuKzB4
MTI0LzB4MWM4DQo+ICB1ZnNoY2RfaG9zdF9yZXNldF9hbmRfcmVzdG9yZSsweDFkMC8weDJjYw0K
PiAgdWZzaGNkX2xpbmtfcmVjb3ZlcnkrMHhhYy8weDEzNA0KPiAgdWZzaGNkX3VpY19oaWJlcm44
X2V4aXQrMHgxZTgvMHgxZjANCj4gIHVmc2hjZF91bmdhdGVfd29yaysweGFjLzB4MTMwDQoNCkFj
Y29yZGluZyB0byB0aGUgbGF0ZXN0IG1haW5zdHJlYW0ga2VybmVsLCBvbmNlDQp1ZnNoY2RfdWlj
X2hpYmVybjhfZXhpdCgpIGVuY291bnRlcnMgZXJyb3IsIGluc3RlYWQsIGVycm9yIGhhbmRsZXIg
d29yaw0Kd2lsbCBiZSBzY2hlZHVsZWQgd2l0aG91dCBibG9ja2luZyB1ZnNoY2RfdWljX2hpYmVy
bjhfZXhpdCgpLiBJbg0KYWRkaXRpb24sIHVmc2hjZF9zY3NpX3VuYmxvY2tfcmVxdWVzdHMoKSB3
b3VsZCBiZSBpbnZva2VkIGJlZm9yZSBsZWF2aW5nDQp1ZnNoY2RfdWljX2hpYmVybjhfZXhpdCgp
LiBTbyB0aGlzIHN0YWNrIGlzIG5vIGxvbmdlciBleGlzdGVkLg0KDQpUaGFua3MsDQpTdGFubGV5
IENodQ0KDQo+ICBwcm9jZXNzX29uZV93b3JrKzB4MjcwLzB4NDdjDQo+ICB3b3JrZXJfdGhyZWFk
KzB4MjdjLzB4NGQ4DQo+ICBrdGhyZWFkKzB4MTNjLzB4MzIwDQo+ICByZXRfZnJvbV9mb3JrKzB4
MTAvMHgxOA0KPiANCj4gRml4ZXM6IDE5MTg2NTFmMmQ3ZSAoInNjc2k6IHVmczogQ2xlYXIgVUFD
IGZvciBSUE1CIGFmdGVyIHVmc2hjZCByZXNldHMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBKYWVnZXVr
IEtpbSA8amFlZ2V1a0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMgfCA2ICsrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IGluZGV4IGUyMjFhZGQyNWE3ZS4uYjA5OThk
YjFiNzgxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gQEAgLTE2MDMsNiArMTYwMyw3IEBAIHN0YXRp
YyB2b2lkIHVmc2hjZF91bmdhdGVfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+ICAJ
fQ0KPiAgdW5ibG9ja19yZXFzOg0KPiAgCXVmc2hjZF9zY3NpX3VuYmxvY2tfcmVxdWVzdHMoaGJh
KTsNCj4gKwl1ZnNoY2RfY2xlYXJfdWFfd2x1bnMoaGJhKTsNCj4gIH0NCj4gIA0KPiAgLyoqDQo+
IEBAIC02OTEzLDcgKzY5MTQsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9ob3N0X3Jlc2V0X2FuZF9y
ZXN0b3JlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICANCj4gIAkvKiBFc3RhYmxpc2ggdGhlIGxp
bmsgYWdhaW4gYW5kIHJlc3RvcmUgdGhlIGRldmljZSAqLw0KPiAgCWVyciA9IHVmc2hjZF9wcm9i
ZV9oYmEoaGJhLCBmYWxzZSk7DQo+IC0JaWYgKCFlcnIpDQo+ICsJaWYgKCFlcnIgJiYgIWhiYS0+
Y2xrX2dhdGluZy5pc19zdXNwZW5kZWQpDQo+ICAJCXVmc2hjZF9jbGVhcl91YV93bHVucyhoYmEp
Ow0KPiAgb3V0Og0KPiAgCWlmIChlcnIpDQo+IEBAIC04NzQ1LDYgKzg3NDYsNyBAQCBzdGF0aWMg
aW50IHVmc2hjZF9zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBt
X29wKQ0KPiAgCQl1ZnNoY2RfcmVzdW1lX2Nsa3NjYWxpbmcoaGJhKTsNCj4gIAloYmEtPmNsa19n
YXRpbmcuaXNfc3VzcGVuZGVkID0gZmFsc2U7DQo+ICAJaGJhLT5kZXZfaW5mby5iX3JwbV9kZXZf
Zmx1c2hfY2FwYWJsZSA9IGZhbHNlOw0KPiArCXVmc2hjZF9jbGVhcl91YV93bHVucyhoYmEpOw0K
PiAgCXVmc2hjZF9yZWxlYXNlKGhiYSk7DQo+ICBvdXQ6DQo+ICAJaWYgKGhiYS0+ZGV2X2luZm8u
Yl9ycG1fZGV2X2ZsdXNoX2NhcGFibGUpIHsNCj4gQEAgLTg4NTUsNiArODg1Nyw4IEBAIHN0YXRp
YyBpbnQgdWZzaGNkX3Jlc3VtZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBlbnVtIHVmc19wbV9vcCBw
bV9vcCkNCj4gIAkJY2FuY2VsX2RlbGF5ZWRfd29yaygmaGJhLT5ycG1fZGV2X2ZsdXNoX3JlY2hl
Y2tfd29yayk7DQo+ICAJfQ0KPiAgDQo+ICsJdWZzaGNkX2NsZWFyX3VhX3dsdW5zKGhiYSk7DQo+
ICsNCj4gIAkvKiBTY2hlZHVsZSBjbG9jayBnYXRpbmcgaW4gY2FzZSBvZiBubyBhY2Nlc3MgdG8g
VUZTIGRldmljZSB5ZXQgKi8NCj4gIAl1ZnNoY2RfcmVsZWFzZShoYmEpOw0KPiAgDQoNCg==

