Return-Path: <SRS0=U1jj=22=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80627C00523
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 04:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42E6921775
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 04:55:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="J74ZfEA+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgAEEzj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jan 2020 23:55:39 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:59206 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726260AbgAEEzj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2020 23:55:39 -0500
X-UUID: 7a43dab9e028473e980875afc3f4d1ba-20200105
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=pkKLqLcIP1xYhUAQZUZ/7pc95t5mntq5V0tWGUrWILY=;
        b=J74ZfEA+dy6Gd8ZzWzuOLBUHRS/3S7/pOp3F0ZDl1Dab1hsN487mnvtuqYFFDDvafi1SfefMJhe5hvEU+ROJpb6m6fiscSr5wNjYzUUDfLpc3R4j66g7t6hgsituzDRFqO1a8Gea6FN1r3iauovj24RYYQ5tU/yzyXu0TQ//Qqs=;
X-UUID: 7a43dab9e028473e980875afc3f4d1ba-20200105
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1406105658; Sun, 05 Jan 2020 12:55:28 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 5 Jan 2020 12:54:38 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 5 Jan 2020 12:53:59 +0800
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
Subject: [PATCH v1 1/3] scsi: ufs: pass device information to apply_dev_quirks
Date:   Sun, 5 Jan 2020 12:55:16 +0800
Message-ID: <1578200118-29547-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
References: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: B99D8E4619264F3AEE6741D3C4D22B64365177FB7C9FF383ABFFF4BB1014256E2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UGFzcyBVRlMgZGV2aWNlIGluZm9ybWF0aW9uIHRvIHZlbmRvci1zcGVjaWZpYyB2YXJpYW50IGNh
bGxiYWNrDQoiYXBwbHlfZGV2X3F1aXJrcyIgYmVjYXVzZSBzb21lIHBsYXRmb3JtIHZlbmRvcnMg
bmVlZCB0byBrbm93IHN1Y2gNCmluZm9ybWF0aW9uIHRvIGFwcGx5IHNwZWNpYWwgaGFuZGxpbmdz
IG9yIHF1aXJrcyBpbiBzcGVjaWZpYyBkZXZpY2VzLg0KDQpDYzogQWxpbSBBa2h0YXIgPGFsaW0u
YWtodGFyQHNhbXN1bmcuY29tPg0KQ2M6IEFzdXRvc2ggRGFzIDxhc3V0b3NoZEBjb2RlYXVyb3Jh
Lm9yZz4NCkNjOiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCkNjOiBCYXJ0IFZh
biBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCkNjOiBCZWFuIEh1byA8YmVhbmh1b0BtaWNy
b24uY29tPg0KQ2M6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQpDYzogTWF0dGhpYXMg
QnJ1Z2dlciA8bWF0dGhpYXMuYmdnQGdtYWlsLmNvbT4NClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkg
Q2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jIHwgNSArKystLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCA3ICsrKystLS0N
CiAyIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQppbmRleCAxYjk3ZjJkYzBiNjMuLjlhYmYwZWE4YzMwOCAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMN
CkBAIC02ODAzLDcgKzY4MDMsOCBAQCBzdGF0aWMgaW50IHVmc2hjZF9xdWlya190dW5lX2hvc3Rf
cGFfdGFjdGl2YXRlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCXJldHVybiByZXQ7DQogfQ0KIA0K
LXN0YXRpYyB2b2lkIHVmc2hjZF90dW5lX3VuaXByb19wYXJhbXMoc3RydWN0IHVmc19oYmEgKmhi
YSkNCitzdGF0aWMgdm9pZCB1ZnNoY2RfdHVuZV91bmlwcm9fcGFyYW1zKHN0cnVjdCB1ZnNfaGJh
ICpoYmEsDQorCQkJCSAgICAgIHN0cnVjdCB1ZnNfZGV2X2Rlc2MgKmNhcmQpDQogew0KIAlpZiAo
dWZzaGNkX2lzX3VuaXByb19wYV9wYXJhbXNfdHVuaW5nX3JlcShoYmEpKSB7DQogCQl1ZnNoY2Rf
dHVuZV9wYV90YWN0aXZhdGUoaGJhKTsNCkBAIC02ODE3LDcgKzY4MTgsNyBAQCBzdGF0aWMgdm9p
ZCB1ZnNoY2RfdHVuZV91bmlwcm9fcGFyYW1zKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCWlmICho
YmEtPmRldl9xdWlya3MgJiBVRlNfREVWSUNFX1FVSVJLX0hPU1RfUEFfVEFDVElWQVRFKQ0KIAkJ
dWZzaGNkX3F1aXJrX3R1bmVfaG9zdF9wYV90YWN0aXZhdGUoaGJhKTsNCiANCi0JdWZzaGNkX3Zv
cHNfYXBwbHlfZGV2X3F1aXJrcyhoYmEpOw0KKwl1ZnNoY2Rfdm9wc19hcHBseV9kZXZfcXVpcmtz
KGhiYSwgY2FyZCk7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIHVmc2hjZF9jbGVhcl9kYmdfdWZzX3N0
YXRzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCmluZGV4IGUwNWNhZmRkYzg3Yi4u
NGYzZmE3MTMwM2RhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KKysr
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KQEAgLTMyMCw3ICszMjAsNyBAQCBzdHJ1Y3Qg
dWZzX2hiYV92YXJpYW50X29wcyB7DQogCXZvaWQJKCpzZXR1cF90YXNrX21nbXQpKHN0cnVjdCB1
ZnNfaGJhICosIGludCwgdTgpOw0KIAl2b2lkICAgICgqaGliZXJuOF9ub3RpZnkpKHN0cnVjdCB1
ZnNfaGJhICosIGVudW0gdWljX2NtZF9kbWUsDQogCQkJCQllbnVtIHVmc19ub3RpZnlfY2hhbmdl
X3N0YXR1cyk7DQotCWludAkoKmFwcGx5X2Rldl9xdWlya3MpKHN0cnVjdCB1ZnNfaGJhICopOw0K
KwlpbnQJKCphcHBseV9kZXZfcXVpcmtzKShzdHJ1Y3QgdWZzX2hiYSAqLCBzdHJ1Y3QgdWZzX2Rl
dl9kZXNjICopOw0KIAlpbnQgICAgICgqc3VzcGVuZCkoc3RydWN0IHVmc19oYmEgKiwgZW51bSB1
ZnNfcG1fb3ApOw0KIAlpbnQgICAgICgqcmVzdW1lKShzdHJ1Y3QgdWZzX2hiYSAqLCBlbnVtIHVm
c19wbV9vcCk7DQogCXZvaWQJKCpkYmdfcmVnaXN0ZXJfZHVtcCkoc3RydWN0IHVmc19oYmEgKmhi
YSk7DQpAQCAtMTA1MiwxMCArMTA1MiwxMSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgdWZzaGNkX3Zv
cHNfaGliZXJuOF9ub3RpZnkoc3RydWN0IHVmc19oYmEgKmhiYSwNCiAJCXJldHVybiBoYmEtPnZv
cHMtPmhpYmVybjhfbm90aWZ5KGhiYSwgY21kLCBzdGF0dXMpOw0KIH0NCiANCi1zdGF0aWMgaW5s
aW5lIGludCB1ZnNoY2Rfdm9wc19hcHBseV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEp
DQorc3RhdGljIGlubGluZSBpbnQgdWZzaGNkX3ZvcHNfYXBwbHlfZGV2X3F1aXJrcyhzdHJ1Y3Qg
dWZzX2hiYSAqaGJhLA0KKwkJCQkJICAgICAgIHN0cnVjdCB1ZnNfZGV2X2Rlc2MgKmNhcmQpDQog
ew0KIAlpZiAoaGJhLT52b3BzICYmIGhiYS0+dm9wcy0+YXBwbHlfZGV2X3F1aXJrcykNCi0JCXJl
dHVybiBoYmEtPnZvcHMtPmFwcGx5X2Rldl9xdWlya3MoaGJhKTsNCisJCXJldHVybiBoYmEtPnZv
cHMtPmFwcGx5X2Rldl9xdWlya3MoaGJhLCBjYXJkKTsNCiAJcmV0dXJuIDA7DQogfQ0KIA0KLS0g
DQoyLjE4LjANCg==

