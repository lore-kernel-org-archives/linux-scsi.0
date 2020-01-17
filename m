Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D7EC33CB3
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1D720684
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QfqQN30y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgAQDvP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 22:51:15 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:19074 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729702AbgAQDvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 22:51:15 -0500
X-UUID: 293089afc62f468dab02df4adaa8fa7e-20200117
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=p2qxacDfCCVqjUwwOgx8vmOgcBiOvdFZh2JOvNF4dco=;
        b=QfqQN30yiN5NPwUOijX/BKDmh5xRxb0wtMVKh/cRHgS+vpkRmU15dd2elGQzcgLw7yYw3qYrfhRIhiNzlV44WWwX/xHnk1YO4dAtUFTgtvlA3bU6r4C4mhmeYYdbsyJDAU5FWJytmbYRS/aGdeSkzZ0aJDg9Tvw+crpRjld/yOQ=;
X-UUID: 293089afc62f468dab02df4adaa8fa7e-20200117
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 278267192; Fri, 17 Jan 2020 11:51:10 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 17 Jan 2020 11:50:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 17 Jan 2020 11:51:09 +0800
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
Subject: [PATCH v1 3/3] scsi: ufs-mediatek: enable low-power mode for hibern8 state
Date:   Fri, 17 Jan 2020 11:51:08 +0800
Message-ID: <20200117035108.19699-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200117035108.19699-1-stanley.chu@mediatek.com>
References: <20200117035108.19699-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW4gTWVkaWFUZWsgQ2hpcHNldHMsIFVuaVBybyBsaW5rIGFuZCB1ZnNoY2kgY2FuIGVudGVyIHBy
b3ByaWV0YXJ5DQpsb3ctcG93ZXIgbW9kZSB3aGlsZSBsaW5rIGlzIGluIGhpYmVybjggc3RhdGUu
DQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+
DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgNTMgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDUzIGluc2VydGlvbnMoKykN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCBkNTE5NGQwYzRlZjUuLmYzMmYzZjM0ZjZk
MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0zODIsMTEgKzM4Miw2MCBAQCBzdGF0
aWMgdm9pZCB1ZnNfbXRrX2RldmljZV9yZXNldChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlkZXZf
aW5mbyhoYmEtPmRldiwgImRldmljZSByZXNldCBkb25lXG4iKTsNCiB9DQogDQorc3RhdGljIGlu
dCB1ZnNfbXRrX2xpbmtfc2V0X2hwbShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KK3sNCisJaW50IGVy
cjsNCisNCisJZXJyID0gdWZzaGNkX2hiYV9lbmFibGUoaGJhKTsNCisJaWYgKGVycikNCisJCXJl
dHVybiBlcnI7DQorDQorCWVyciA9IHVmc2hjZF9kbWVfc2V0KGhiYSwNCisJCQkgICAgIFVJQ19B
UkdfTUlCX1NFTChWU19VTklQUk9QT1dFUkRPV05DT05UUk9MLCAwKSwNCisJCQkgICAgIDApOw0K
KwlpZiAoZXJyKQ0KKwkJcmV0dXJuIGVycjsNCisNCisJZXJyID0gdWZzaGNkX3VpY19oaWJlcm44
X2V4aXQoaGJhKTsNCisJaWYgKCFlcnIpDQorCQl1ZnNoY2Rfc2V0X2xpbmtfYWN0aXZlKGhiYSk7
DQorCWVsc2UNCisJCXJldHVybiBlcnI7DQorDQorCWVyciA9IHVmc2hjZF9tYWtlX2hiYV9vcGVy
YXRpb25hbChoYmEpOw0KKwlpZiAoZXJyKQ0KKwkJcmV0dXJuIGVycjsNCisNCisJcmV0dXJuIDA7
DQorfQ0KKw0KK3N0YXRpYyBpbnQgdWZzX210a19saW5rX3NldF9scG0oc3RydWN0IHVmc19oYmEg
KmhiYSkNCit7DQorCWludCBlcnI7DQorDQorCWVyciA9IHVmc2hjZF9kbWVfc2V0KGhiYSwNCisJ
CQkgICAgIFVJQ19BUkdfTUlCX1NFTChWU19VTklQUk9QT1dFUkRPV05DT05UUk9MLCAwKSwNCisJ
CQkgICAgIDEpOw0KKwlpZiAoZXJyKSB7DQorCQkvKiBSZXN1bWUgVW5pUHJvIHN0YXRlIGZvciBm
b2xsb3dpbmcgZXJyb3IgcmVjb3ZlcnkgKi8NCisJCXVmc2hjZF9kbWVfc2V0KGhiYSwNCisJCQkg
ICAgICAgVUlDX0FSR19NSUJfU0VMKFZTX1VOSVBST1BPV0VSRE9XTkNPTlRST0wsIDApLA0KKwkJ
CSAgICAgICAwKTsNCisJCXJldHVybiBlcnI7DQorCX0NCisNCisJcmV0dXJuIDA7DQorfQ0KKw0K
IHN0YXRpYyBpbnQgdWZzX210a19zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZz
X3BtX29wIHBtX29wKQ0KIHsNCisJaW50IGVycjsNCiAJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9z
dCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KIA0KIAlpZiAodWZzaGNkX2lzX2xpbmtfaGli
ZXJuOChoYmEpKSB7DQorCQllcnIgPSB1ZnNfbXRrX2xpbmtfc2V0X2xwbShoYmEpOw0KKwkJaWYg
KGVycikNCisJCQlyZXR1cm4gLUVBR0FJTjsNCiAJCXBoeV9wb3dlcl9vZmYoaG9zdC0+bXBoeSk7
DQogCQl1ZnNfbXRrX3NldHVwX3JlZl9jbGsoaGJhLCBmYWxzZSk7DQogCX0NCkBAIC0zOTcsMTAg
KzQ0NiwxNCBAQCBzdGF0aWMgaW50IHVmc19tdGtfc3VzcGVuZChzdHJ1Y3QgdWZzX2hiYSAqaGJh
LCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCiBzdGF0aWMgaW50IHVmc19tdGtfcmVzdW1lKHN0cnVj
dCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KIHsNCiAJc3RydWN0IHVmc19t
dGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KKwlpbnQgZXJyOw0KIA0K
IAlpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJuOChoYmEpKSB7DQogCQl1ZnNfbXRrX3NldHVwX3Jl
Zl9jbGsoaGJhLCB0cnVlKTsNCiAJCXBoeV9wb3dlcl9vbihob3N0LT5tcGh5KTsNCisJCWVyciA9
IHVmc19tdGtfbGlua19zZXRfaHBtKGhiYSk7DQorCQlpZiAoZXJyKQ0KKwkJCXJldHVybiBlcnI7
DQogCX0NCiANCiAJcmV0dXJuIDA7DQotLSANCjIuMTguMA0K

