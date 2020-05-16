Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E236C433E3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 17:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF5B207E8
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 17:46:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="d6+wbIvo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgEPRq3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 May 2020 13:46:29 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:17158 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726414AbgEPRqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2020 13:46:24 -0400
X-UUID: d16d24d53932432892e565b389e20361-20200517
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=5P/GwSlNrq5PAZrytzRd4P4S4nturapsNoUmppSNqBc=;
        b=d6+wbIvoYN4XoIp0jYcnkyMsvFD/I+0nafJ5awL3ajrg1as8aUvmmjEegIHB0Kkr+NY8bBykIWC5/ASsMFtuBGaK1vVYAhzIcbvYqwJQ+Kej5//DgQN7KgkVRozuIjva3W/ZwULoaIRa8ZT3e3emkh5IlieofebBnUIqMB+ysGI=;
X-UUID: d16d24d53932432892e565b389e20361-20200517
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1083562162; Sun, 17 May 2020 01:46:19 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 17 May 2020 01:46:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 17 May 2020 01:46:14 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <asutoshd@codeaurora.org>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 4/5] scsi: ufs: Fix WriteBooster flush during runtime suspend
Date:   Sun, 17 May 2020 01:46:14 +0800
Message-ID: <20200516174615.15445-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200516174615.15445-1-stanley.chu@mediatek.com>
References: <20200516174615.15445-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q3VycmVudGx5IFVGUyBob3N0IGRyaXZlciBwcm9taXNlcyBWQ0Mgc3VwcGx5IGlmIFVGUyBkZXZp
Y2UNCm5lZWRzIHRvIGRvIFdyaXRlQm9vc3RlciBmbHVzaCBkdXJpbmcgcnVudGltZSBzdXNwZW5k
Lg0KDQpIb3dldmVyIHRoZSBVRlMgc3BlY2lmaWNhdGlvbiBtZW50aW9ucywNCg0KIldoaWxlIHRo
ZSBmbHVzaGluZyBvcGVyYXRpb24gaXMgaW4gcHJvZ3Jlc3MsIHRoZSBkZXZpY2UgaXMNCmluIEFj
dGl2ZSBwb3dlciBtb2RlLiINCg0KVGhlcmVmb3JlIFVGUyBob3N0IGRyaXZlciBuZWVkcyB0byBw
cm9taXNlIG1vcmU6IEtlZXAgVUZTDQpkZXZpY2UgYXMgIkFjdGl2ZSBwb3dlciBtb2RlIiwgb3Ro
ZXJ3aXNlIFVGUyBkZXZpY2Ugc2hhbGwgbm90DQpkbyBhbnkgZmx1c2ggaWYgZGV2aWNlIGVudGVy
cyBTbGVlcCBvciBQb3dlckRvd24gcG93ZXIgbW9kZS4NCg0KRml4IHRoaXMgYnkgbm90IGNoYW5n
aW5nIGRldmljZSBwb3dlciBtb2RlIGlmIFdyaXRlQm9vc3Rlcg0KZmx1c2ggaXMgcmVxdWlyZWQg
aW4gdWZzaGNkX3N1c3BlbmQoKS4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLmggICAgfCAg
MSAtDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDQyICsrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KIDIgZmlsZXMgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwg
MjEgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnMuaA0KaW5kZXggZmFkYmEzYTNiYmNkLi5kYjA3ZWVkZmVkOTYg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oDQorKysgYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy5oDQpAQCAtNTc0LDcgKzU3NCw2IEBAIHN0cnVjdCB1ZnNfZGV2X2luZm8gew0KIAl1
MzIgZF9leHRfdWZzX2ZlYXR1cmVfc3VwOw0KIAl1OCBiX3diX2J1ZmZlcl90eXBlOw0KIAl1MzIg
ZF93Yl9hbGxvY191bml0czsNCi0JYm9vbCBrZWVwX3ZjY19vbjsNCiAJdTggYl9wcmVzcnZfdXNw
Y19lbjsNCiB9Ow0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBjN2MyYmQ3ODYwYjguLmY0ZjJjN2I1YWIw
YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMNCkBAIC04MDk0LDggKzgwOTQsNyBAQCBzdGF0aWMgdm9pZCB1ZnNo
Y2RfdnJlZ19zZXRfbHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCSAgICAhaGJhLT5kZXZfaW5m
by5pc19sdV9wb3dlcl9vbl93cCkgew0KIAkJdWZzaGNkX3NldHVwX3ZyZWcoaGJhLCBmYWxzZSk7
DQogCX0gZWxzZSBpZiAoIXVmc2hjZF9pc191ZnNfZGV2X2FjdGl2ZShoYmEpKSB7DQotCQlpZiAo
IWhiYS0+ZGV2X2luZm8ua2VlcF92Y2Nfb24pDQotCQkJdWZzaGNkX3RvZ2dsZV92cmVnKGhiYS0+
ZGV2LCBoYmEtPnZyZWdfaW5mby52Y2MsIGZhbHNlKTsNCisJCXVmc2hjZF90b2dnbGVfdnJlZyho
YmEtPmRldiwgaGJhLT52cmVnX2luZm8udmNjLCBmYWxzZSk7DQogCQlpZiAoIXVmc2hjZF9pc19s
aW5rX2FjdGl2ZShoYmEpKSB7DQogCQkJdWZzaGNkX2NvbmZpZ192cmVnX2xwbShoYmEsIGhiYS0+
dnJlZ19pbmZvLnZjY3EpOw0KIAkJCXVmc2hjZF9jb25maWdfdnJlZ19scG0oaGJhLCBoYmEtPnZy
ZWdfaW5mby52Y2NxMik7DQpAQCAtODE2NSw2ICs4MTY0LDcgQEAgc3RhdGljIGludCB1ZnNoY2Rf
c3VzcGVuZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCiAJZW51
bSB1ZnNfcG1fbGV2ZWwgcG1fbHZsOw0KIAllbnVtIHVmc19kZXZfcHdyX21vZGUgcmVxX2Rldl9w
d3JfbW9kZTsNCiAJZW51bSB1aWNfbGlua19zdGF0ZSByZXFfbGlua19zdGF0ZTsNCisJYm9vbCBr
ZWVwX2N1cnJfZGV2X3B3cl9tb2RlID0gZmFsc2U7DQogDQogCWhiYS0+cG1fb3BfaW5fcHJvZ3Jl
c3MgPSAxOw0KIAlpZiAoIXVmc2hjZF9pc19zaHV0ZG93bl9wbShwbV9vcCkpIHsNCkBAIC04MjIw
LDI3ICs4MjIwLDI5IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3N1c3BlbmQoc3RydWN0IHVmc19oYmEg
KmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQogCQkJdWZzaGNkX2Rpc2FibGVfYXV0b19ia29w
cyhoYmEpOw0KIAkJfQ0KIAkJLyoNCi0JCSAqIFdpdGggd2IgZW5hYmxlZCwgaWYgdGhlIGJrb3Bz
IGlzIGVuYWJsZWQgb3IgaWYgdGhlDQotCQkgKiBjb25maWd1cmVkIFdCIHR5cGUgaXMgNzAlIGZ1
bGwsIGtlZXAgdmNjIE9ODQotCQkgKiBmb3IgdGhlIGRldmljZSB0byBmbHVzaCB0aGUgd2IgYnVm
ZmVyDQorCQkgKiBJZiBkZXZpY2UgbmVlZHMgdG8gZG8gQktPUCBvciBXQiBidWZmZXIgZmx1c2gg
ZHVyaW5nDQorCQkgKiBIaWJlcm44LCBrZWVwIGRldmljZSBwb3dlciBtb2RlIGFzICJhY3RpdmUg
cG93ZXIgbW9kZSINCisJCSAqIGFuZCBWQ0Mgc3VwcGx5Lg0KIAkJICovDQotCQlpZiAoKGhiYS0+
YXV0b19ia29wc19lbmFibGVkICYmIHVmc2hjZF9pc193Yl9hbGxvd2VkKGhiYSkpIHx8DQotCQkg
ICAgdWZzaGNkX3diX2tlZXBfdmNjX29uKGhiYSkpDQotCQkJaGJhLT5kZXZfaW5mby5rZWVwX3Zj
Y19vbiA9IHRydWU7DQotCQllbHNlDQotCQkJaGJhLT5kZXZfaW5mby5rZWVwX3ZjY19vbiA9IGZh
bHNlOw0KLQl9IGVsc2Ugew0KLQkJaGJhLT5kZXZfaW5mby5rZWVwX3ZjY19vbiA9IGZhbHNlOw0K
KwkJa2VlcF9jdXJyX2Rldl9wd3JfbW9kZSA9IGhiYS0+YXV0b19ia29wc19lbmFibGVkIHx8DQor
CQkJKCgocmVxX2xpbmtfc3RhdGUgPT0gVUlDX0xJTktfSElCRVJOOF9TVEFURSkgfHwNCisJCQko
KHJlcV9saW5rX3N0YXRlID09IFVJQ19MSU5LX0FDVElWRV9TVEFURSkgJiYNCisJCQl1ZnNoY2Rf
aXNfYXV0b19oaWJlcm44X2VuYWJsZWQoaGJhKSkpICYmDQorCQkJdWZzaGNkX3diX2tlZXBfdmNj
X29uKGhiYSkpOw0KIAl9DQogDQotCWlmICgocmVxX2Rldl9wd3JfbW9kZSAhPSBoYmEtPmN1cnJf
ZGV2X3B3cl9tb2RlKSAmJg0KLQkgICAgKCh1ZnNoY2RfaXNfcnVudGltZV9wbShwbV9vcCkgJiYg
IWhiYS0+YXV0b19ia29wc19lbmFibGVkKSB8fA0KLQkgICAgIXVmc2hjZF9pc19ydW50aW1lX3Bt
KHBtX29wKSkpIHsNCi0JCS8qIGVuc3VyZSB0aGF0IGJrb3BzIGlzIGRpc2FibGVkICovDQotCQl1
ZnNoY2RfZGlzYWJsZV9hdXRvX2Jrb3BzKGhiYSk7DQotCQlyZXQgPSB1ZnNoY2Rfc2V0X2Rldl9w
d3JfbW9kZShoYmEsIHJlcV9kZXZfcHdyX21vZGUpOw0KLQkJaWYgKHJldCkNCi0JCQlnb3RvIGVu
YWJsZV9nYXRpbmc7DQorCWlmIChyZXFfZGV2X3B3cl9tb2RlICE9IGhiYS0+Y3Vycl9kZXZfcHdy
X21vZGUpIHsNCisJCWlmICgodWZzaGNkX2lzX3J1bnRpbWVfcG0ocG1fb3ApICYmICFoYmEtPmF1
dG9fYmtvcHNfZW5hYmxlZCkgfHwNCisJCSAgICAhdWZzaGNkX2lzX3J1bnRpbWVfcG0ocG1fb3Ap
KSB7DQorCQkJLyogZW5zdXJlIHRoYXQgYmtvcHMgaXMgZGlzYWJsZWQgKi8NCisJCQl1ZnNoY2Rf
ZGlzYWJsZV9hdXRvX2Jrb3BzKGhiYSk7DQorCQl9DQorDQorCQlpZiAoIWtlZXBfY3Vycl9kZXZf
cHdyX21vZGUpIHsNCisJCQlyZXQgPSB1ZnNoY2Rfc2V0X2Rldl9wd3JfbW9kZShoYmEsIHJlcV9k
ZXZfcHdyX21vZGUpOw0KKwkJCWlmIChyZXQpDQorCQkJCWdvdG8gZW5hYmxlX2dhdGluZzsNCisJ
CX0NCiAJfQ0KIA0KIAlmbHVzaF93b3JrKCZoYmEtPmVlaF93b3JrKTsNCi0tIA0KMi4xOC4wDQo=

