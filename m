Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36234C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 15:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE75D20774
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 15:40:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cma5uxGU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730831AbgFIPkm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 11:40:42 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:29017 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728162AbgFIPkl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 11:40:41 -0400
X-UUID: e7a9c9055d104c92b80cb848ccbde569-20200609
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=gz9jHrd19tMvfltELFNEZu5vfsrGH8nrJcXFS/mzO2E=;
        b=cma5uxGUd077/+2UxsRe+VmTuJtu1JMw9k9F9JvC13QIKHJffg3bQO0YjHioBxHmLoV2Bij9SjwQQBwiF6WZgjyMPnFviS3t95HLVS1SFKBqdmfKd+rAQxC8qezonM0yYdgCiF4rCzD6bcm3EnOayaE4PgfuYGMKDAG+pOJlYX4=;
X-UUID: e7a9c9055d104c92b80cb848ccbde569-20200609
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1718300528; Tue, 09 Jun 2020 23:40:37 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 9 Jun 2020 23:40:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Jun 2020 23:40:33 +0800
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
Subject: [PATCH v2] scsi: ufs: Fix imprecise time in devfreq window
Date:   Tue, 9 Jun 2020 23:40:35 +0800
Message-ID: <20200609154035.1950-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UHJvbWlzZSBwcmVjaXNpb24gb2YgZGV2ZnJlcSB3aW5kb3dzIGJ5DQoNCjEuIEFsaWduIHRpbWUg
YmFzZSBvZiBib3RoIGRldmZyZXFfZGV2X3N0YXR1cy50b3RhbF90aW1lIGFuZA0KICAgZGV2ZnJl
cV9kZXZfc3RhdHVzLmJ1c3lfdGltZSB0byBrdGltZS1iYXNlZCB0aW1lLg0KDQoyLiBBbGlnbiBi
ZWxvdyB0aW1lbGluZXMsDQogICAtIFRoZSBiZWdpbm5pbmcgb2YgZGV2ZnJlcSB3aW5kb3cNCiAg
IC0gVGhlIGJlZ2lubmluZyBvZiBidXN5IHRpbWUgaW4gbmV3IHdpbmRvdw0KICAgLSBUaGUgZW5k
IG9mIGJ1c3kgdGltZSBpbiBjdXJyZW50IHdpbmRvdw0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5
IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYyB8IDExICsrKysrKy0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygr
KSwgNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBhZDRmYzgyOWNiYjIuLjA0Yjc5
Y2E2NmZkZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC0xMzE0LDYgKzEzMTQsNyBAQCBzdGF0aWMgaW50
IHVmc2hjZF9kZXZmcmVxX2dldF9kZXZfc3RhdHVzKHN0cnVjdCBkZXZpY2UgKmRldiwNCiAJdW5z
aWduZWQgbG9uZyBmbGFnczsNCiAJc3RydWN0IGxpc3RfaGVhZCAqY2xrX2xpc3QgPSAmaGJhLT5j
bGtfbGlzdF9oZWFkOw0KIAlzdHJ1Y3QgdWZzX2Nsa19pbmZvICpjbGtpOw0KKwlrdGltZV90IGN1
cnJfdDsNCiANCiAJaWYgKCF1ZnNoY2RfaXNfY2xrc2NhbGluZ19zdXBwb3J0ZWQoaGJhKSkNCiAJ
CXJldHVybiAtRUlOVkFMOw0KQEAgLTEzMjEsNiArMTMyMiw3IEBAIHN0YXRpYyBpbnQgdWZzaGNk
X2RldmZyZXFfZ2V0X2Rldl9zdGF0dXMoc3RydWN0IGRldmljZSAqZGV2LA0KIAltZW1zZXQoc3Rh
dCwgMCwgc2l6ZW9mKCpzdGF0KSk7DQogDQogCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+
aG9zdF9sb2NrLCBmbGFncyk7DQorCWN1cnJfdCA9IGt0aW1lX2dldCgpOw0KIAlpZiAoIXNjYWxp
bmctPndpbmRvd19zdGFydF90KQ0KIAkJZ290byBzdGFydF93aW5kb3c7DQogDQpAQCAtMTMzMiwx
OCArMTMzNCwxNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9kZXZmcmVxX2dldF9kZXZfc3RhdHVzKHN0
cnVjdCBkZXZpY2UgKmRldiwNCiAJICovDQogCXN0YXQtPmN1cnJlbnRfZnJlcXVlbmN5ID0gY2xr
aS0+Y3Vycl9mcmVxOw0KIAlpZiAoc2NhbGluZy0+aXNfYnVzeV9zdGFydGVkKQ0KLQkJc2NhbGlu
Zy0+dG90X2J1c3lfdCArPSBrdGltZV90b191cyhrdGltZV9zdWIoa3RpbWVfZ2V0KCksDQorCQlz
Y2FsaW5nLT50b3RfYnVzeV90ICs9IGt0aW1lX3RvX3VzKGt0aW1lX3N1YihjdXJyX3QsDQogCQkJ
CQlzY2FsaW5nLT5idXN5X3N0YXJ0X3QpKTsNCiANCi0Jc3RhdC0+dG90YWxfdGltZSA9IGppZmZp
ZXNfdG9fdXNlY3MoKGxvbmcpamlmZmllcyAtDQotCQkJCShsb25nKXNjYWxpbmctPndpbmRvd19z
dGFydF90KTsNCisJc3RhdC0+dG90YWxfdGltZSA9IGt0aW1lX3RvX3VzKGN1cnJfdCkgLSBzY2Fs
aW5nLT53aW5kb3dfc3RhcnRfdDsNCiAJc3RhdC0+YnVzeV90aW1lID0gc2NhbGluZy0+dG90X2J1
c3lfdDsNCiBzdGFydF93aW5kb3c6DQotCXNjYWxpbmctPndpbmRvd19zdGFydF90ID0gamlmZmll
czsNCisJc2NhbGluZy0+d2luZG93X3N0YXJ0X3QgPSBrdGltZV90b191cyhjdXJyX3QpOw0KIAlz
Y2FsaW5nLT50b3RfYnVzeV90ID0gMDsNCiANCiAJaWYgKGhiYS0+b3V0c3RhbmRpbmdfcmVxcykg
ew0KLQkJc2NhbGluZy0+YnVzeV9zdGFydF90ID0ga3RpbWVfZ2V0KCk7DQorCQlzY2FsaW5nLT5i
dXN5X3N0YXJ0X3QgPSBjdXJyX3Q7DQogCQlzY2FsaW5nLT5pc19idXN5X3N0YXJ0ZWQgPSB0cnVl
Ow0KIAl9IGVsc2Ugew0KIAkJc2NhbGluZy0+YnVzeV9zdGFydF90ID0gMDsNCi0tIA0KMi4xOC4w
DQo=

