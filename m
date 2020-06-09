Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDFFC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 15:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57BC720801
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 15:33:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="M/rd/FAn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgFIPdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 11:33:39 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:50822 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728944AbgFIPdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 11:33:39 -0400
X-UUID: 982edc5ca0a245fe8100f34a5de104ea-20200609
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=bK5ZQDdXKnK3u8bH5NkJFh8Qb4nGzQp7amtH8nUC9XA=;
        b=M/rd/FAn3gmP3AX8kEOswxjksdOE4l5EPpaGA4+o648neLkwcssifmFAMtSsO1DxgJUq5eRXDK8TC0hDcJLzK11yuYjVFb3/F6xnioDQK7vNkS32PIsUYANy9I3kKROYRFjSegysCn3TMo/rZs0UD8Q/AJGbre8wXeK4h6rHZNY=;
X-UUID: 982edc5ca0a245fe8100f34a5de104ea-20200609
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 458564585; Tue, 09 Jun 2020 23:33:32 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 9 Jun 2020 23:33:28 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Jun 2020 23:33:28 +0800
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
Subject: [PATCH v1] scsi: ufs: Fix imprecise time in devfreq window
Date:   Tue, 9 Jun 2020 23:33:29 +0800
Message-ID: <20200609153329.1883-1-stanley.chu@mediatek.com>
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
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBhZDRmYzgyOWNiYjIuLjk0MGJk
NWRlNWFkZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2Ry
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
czsNCisJc2NhbGluZy0+d2luZG93X3N0YXJ0X3QgPSBjdXJyX3Q7DQogCXNjYWxpbmctPnRvdF9i
dXN5X3QgPSAwOw0KIA0KIAlpZiAoaGJhLT5vdXRzdGFuZGluZ19yZXFzKSB7DQotCQlzY2FsaW5n
LT5idXN5X3N0YXJ0X3QgPSBrdGltZV9nZXQoKTsNCisJCXNjYWxpbmctPmJ1c3lfc3RhcnRfdCA9
IGN1cnJfdDsNCiAJCXNjYWxpbmctPmlzX2J1c3lfc3RhcnRlZCA9IHRydWU7DQogCX0gZWxzZSB7
DQogCQlzY2FsaW5nLT5idXN5X3N0YXJ0X3QgPSAwOw0KLS0gDQoyLjE4LjANCg==

