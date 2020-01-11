Return-Path: <SRS0=vbb9=3A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D1F4C33C9E
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 07:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB21220842
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 07:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KVTS/lUN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgAKHME (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 02:12:04 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:31866 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728530AbgAKHMD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 02:12:03 -0500
X-UUID: 873c94ab8a5544c4a25cb21797dea6f0-20200111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=em9nzz50IukwOwj7HIQQvdNwwvlDjKEtqMCz2bjE7bg=;
        b=KVTS/lUNGb59sN7zDhciA1+1FB+shxFEy6TZ0L1pMfp8yjagDQu2Xow3tNksuf8OBhg4CojlcTfDqr1kTdKgMmV0MMEvnINIyLtte8vatDKANQRBD2AA00c2iCxh2XAgIZ3aKNBSR26sm5P6Ob0DwT+A+72HLUMXAL5VFAUEvFI=;
X-UUID: 873c94ab8a5544c4a25cb21797dea6f0-20200111
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1611755889; Sat, 11 Jan 2020 15:11:58 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 11 Jan 2020 15:10:58 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 11 Jan 2020 15:12:37 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 1/2] scsi: ufs: pass device information to apply_dev_quirks
Date:   Sat, 11 Jan 2020 15:11:46 +0800
Message-ID: <1578726707-6596-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1578726707-6596-1-git-send-email-stanley.chu@mediatek.com>
References: <1578726707-6596-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UGFzcyBVRlMgZGV2aWNlIGluZm9ybWF0aW9uIHRvIHZlbmRvci1zcGVjaWZpYyB2YXJpYW50IGNh
bGxiYWNrDQoiYXBwbHlfZGV2X3F1aXJrcyIgYmVjYXVzZSBzb21lIHBsYXRmb3JtIHZlbmRvcnMg
bmVlZCB0byBrbm93IHN1Y2gNCmluZm9ybWF0aW9uIHRvIGFwcGx5IHNwZWNpYWwgaGFuZGxpbmdz
IG9yIHF1aXJrcyBpbiBzcGVjaWZpYyBkZXZpY2VzLg0KDQpJbiB0aGUgc2FtZSB0aW1lLCBtb2Rp
ZnkgZXhpc3RlZCB2ZW5kb3IgaW1wbGVtZW50YXRpb25zIGFjY29yZGluZyB0bw0KdGhlIG5ldyBp
bnRlcmZhY2UgZm9yIHRob3NlIHZlbmRvciBkcml2ZXJzIHdoaWNoIHdpbGwgYmUgYnVpbHQtaW4N
Cm9yIGJ1aWx0IGFzIGEgbW9kdWxlIGFsb25lIHdpdGggVUZTIGNvcmUgZHJpdmVyLg0KDQpDYzog
QWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPg0KQ2M6IEFzdXRvc2ggRGFzIDxh
c3V0b3NoZEBjb2RlYXVyb3JhLm9yZz4NCkNjOiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2Rj
LmNvbT4NCkNjOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCkNjOiBCZWFu
IEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KQ2M6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5v
cmc+DQpDYzogTWF0dGhpYXMgQnJ1Z2dlciA8bWF0dGhpYXMuYmdnQGdtYWlsLmNvbT4NClJldmll
d2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NClJldmlld2VkLWJ5OiBC
ZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUg
PHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLXFj
b20uYyB8IDMgKystDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgIHwgOCArKysrLS0tLQ0K
IGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICB8IDcgKysrKy0tLQ0KIDMgZmlsZXMgY2hhbmdl
ZCwgMTAgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLXFjb20uYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXFjb20uYw0KaW5k
ZXggYzY5YzI5YTFjZWI5Li5lYmI1YzY2ZTA2OWYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy1xY29tLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXFjb20uYw0KQEAgLTk0
OSw3ICs5NDksOCBAQCBzdGF0aWMgaW50IHVmc19xY29tX3F1aXJrX2hvc3RfcGFfc2F2ZWNvbmZp
Z3RpbWUoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJcmV0dXJuIGVycjsNCiB9DQogDQotc3RhdGlj
IGludCB1ZnNfcWNvbV9hcHBseV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQorc3Rh
dGljIGludCB1ZnNfcWNvbV9hcHBseV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQor
CQkJCSAgICAgc3RydWN0IHVmc19kZXZfZGVzYyAqY2FyZCkNCiB7DQogCWludCBlcnIgPSAwOw0K
IA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jDQppbmRleCAxYjk3ZjJkYzBiNjMuLjdjODVjODkwNTk0YyAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMNCkBAIC02ODAzLDcgKzY4MDMsOCBAQCBzdGF0aWMgaW50IHVmc2hjZF9xdWlya190dW5l
X2hvc3RfcGFfdGFjdGl2YXRlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCXJldHVybiByZXQ7DQog
fQ0KIA0KLXN0YXRpYyB2b2lkIHVmc2hjZF90dW5lX3VuaXByb19wYXJhbXMoc3RydWN0IHVmc19o
YmEgKmhiYSkNCitzdGF0aWMgdm9pZCB1ZnNoY2RfdHVuZV91bmlwcm9fcGFyYW1zKHN0cnVjdCB1
ZnNfaGJhICpoYmEsDQorCQkJCSAgICAgIHN0cnVjdCB1ZnNfZGV2X2Rlc2MgKmNhcmQpDQogew0K
IAlpZiAodWZzaGNkX2lzX3VuaXByb19wYV9wYXJhbXNfdHVuaW5nX3JlcShoYmEpKSB7DQogCQl1
ZnNoY2RfdHVuZV9wYV90YWN0aXZhdGUoaGJhKTsNCkBAIC02ODE3LDcgKzY4MTgsNyBAQCBzdGF0
aWMgdm9pZCB1ZnNoY2RfdHVuZV91bmlwcm9fcGFyYW1zKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQog
CWlmIChoYmEtPmRldl9xdWlya3MgJiBVRlNfREVWSUNFX1FVSVJLX0hPU1RfUEFfVEFDVElWQVRF
KQ0KIAkJdWZzaGNkX3F1aXJrX3R1bmVfaG9zdF9wYV90YWN0aXZhdGUoaGJhKTsNCiANCi0JdWZz
aGNkX3ZvcHNfYXBwbHlfZGV2X3F1aXJrcyhoYmEpOw0KKwl1ZnNoY2Rfdm9wc19hcHBseV9kZXZf
cXVpcmtzKGhiYSwgY2FyZCk7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIHVmc2hjZF9jbGVhcl9kYmdf
dWZzX3N0YXRzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQpAQCAtNjk4MCwxMCArNjk4MSw5IEBAIHN0
YXRpYyBpbnQgdWZzaGNkX3Byb2JlX2hiYShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAl9DQogDQog
CXVmc19maXh1cF9kZXZpY2Vfc2V0dXAoaGJhLCAmY2FyZCk7DQorCXVmc2hjZF90dW5lX3VuaXBy
b19wYXJhbXMoaGJhLCAmY2FyZCk7DQogCXVmc19wdXRfZGV2aWNlX2Rlc2MoJmNhcmQpOw0KIA0K
LQl1ZnNoY2RfdHVuZV91bmlwcm9fcGFyYW1zKGhiYSk7DQotDQogCS8qIFVGUyBkZXZpY2UgaXMg
YWxzbyBhY3RpdmUgbm93ICovDQogCXVmc2hjZF9zZXRfdWZzX2Rldl9hY3RpdmUoaGJhKTsNCiAJ
dWZzaGNkX2ZvcmNlX3Jlc2V0X2F1dG9fYmtvcHMoaGJhKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggZTA1
Y2FmZGRjODdiLi40ZjNmYTcxMzAzZGEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtMzIwLDcgKzMyMCw3
IEBAIHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzIHsNCiAJdm9pZAkoKnNldHVwX3Rhc2tfbWdt
dCkoc3RydWN0IHVmc19oYmEgKiwgaW50LCB1OCk7DQogCXZvaWQgICAgKCpoaWJlcm44X25vdGlm
eSkoc3RydWN0IHVmc19oYmEgKiwgZW51bSB1aWNfY21kX2RtZSwNCiAJCQkJCWVudW0gdWZzX25v
dGlmeV9jaGFuZ2Vfc3RhdHVzKTsNCi0JaW50CSgqYXBwbHlfZGV2X3F1aXJrcykoc3RydWN0IHVm
c19oYmEgKik7DQorCWludAkoKmFwcGx5X2Rldl9xdWlya3MpKHN0cnVjdCB1ZnNfaGJhICosIHN0
cnVjdCB1ZnNfZGV2X2Rlc2MgKik7DQogCWludCAgICAgKCpzdXNwZW5kKShzdHJ1Y3QgdWZzX2hi
YSAqLCBlbnVtIHVmc19wbV9vcCk7DQogCWludCAgICAgKCpyZXN1bWUpKHN0cnVjdCB1ZnNfaGJh
ICosIGVudW0gdWZzX3BtX29wKTsNCiAJdm9pZAkoKmRiZ19yZWdpc3Rlcl9kdW1wKShzdHJ1Y3Qg
dWZzX2hiYSAqaGJhKTsNCkBAIC0xMDUyLDEwICsxMDUyLDExIEBAIHN0YXRpYyBpbmxpbmUgdm9p
ZCB1ZnNoY2Rfdm9wc19oaWJlcm44X25vdGlmeShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KIAkJcmV0
dXJuIGhiYS0+dm9wcy0+aGliZXJuOF9ub3RpZnkoaGJhLCBjbWQsIHN0YXR1cyk7DQogfQ0KIA0K
LXN0YXRpYyBpbmxpbmUgaW50IHVmc2hjZF92b3BzX2FwcGx5X2Rldl9xdWlya3Moc3RydWN0IHVm
c19oYmEgKmhiYSkNCitzdGF0aWMgaW5saW5lIGludCB1ZnNoY2Rfdm9wc19hcHBseV9kZXZfcXVp
cmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQorCQkJCQkgICAgICAgc3RydWN0IHVmc19kZXZfZGVz
YyAqY2FyZCkNCiB7DQogCWlmIChoYmEtPnZvcHMgJiYgaGJhLT52b3BzLT5hcHBseV9kZXZfcXVp
cmtzKQ0KLQkJcmV0dXJuIGhiYS0+dm9wcy0+YXBwbHlfZGV2X3F1aXJrcyhoYmEpOw0KKwkJcmV0
dXJuIGhiYS0+dm9wcy0+YXBwbHlfZGV2X3F1aXJrcyhoYmEsIGNhcmQpOw0KIAlyZXR1cm4gMDsN
CiB9DQogDQotLSANCjIuMTguMA0K

