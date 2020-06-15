Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7C2C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 14:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 652B420739
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 14:31:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UFyGNRZG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgFOObd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 10:31:33 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:55258 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729243AbgFOObc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 10:31:32 -0400
X-UUID: 67dc2c9a0411459788ab164f56c38f6d-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=kr2jM3RF3TtcKfmiwQa78Z5GzGFPEkqB/QqVcBMG3TY=;
        b=UFyGNRZGPWnOhHUMVcxkDzOBNOvjTOmWdC2yqHnkqjzo7aoy/Xwyt16jObOfYMqVIr6pdd6DLM5ET2X0QCZLYfA/rLVXAiuW6RsjkZUJXISYMcQMOUPnz1guSQ12yMK+X1Vf0HI1pytWpnG/mlHw+Q1johWc2lpKoy7pVjl4TR0=;
X-UUID: 67dc2c9a0411459788ab164f56c38f6d-20200615
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 517540321; Mon, 15 Jun 2020 22:31:28 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 22:31:22 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 22:31:22 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 3/3] scsi: ufs-mediatek: Print host information for failed supsend and resume
Date:   Mon, 15 Jun 2020 22:31:23 +0800
Message-ID: <20200615143123.6627-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200615143123.6627-1-stanley.chu@mediatek.com>
References: <20200615143123.6627-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 8EC26055AF32B427709C81554C49B22046A151F1F85C4188A4CE82C53D9714202000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UHJpbnQgaG9zdCBzdGF0ZSBhbmQgcmVnaXN0ZXIgZHVtcHMgd2hpbGUgc3VzcGVuZCBvciByZXN1
bWUgZmxvdw0KaXMgZmFpbGVkLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rhbmxl
eS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsu
YyB8IDE2ICsrKysrKysrKysrLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygr
KSwgNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1l
ZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCBkNTZjZThk
OTdkNGUuLmIwZjYyNmY2ZjlmZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1l
ZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC00Njks
MjIgKzQ2OSwyNSBAQCBzdGF0aWMgaW50IHVmc19tdGtfbGlua19zZXRfaHBtKHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQogDQogCWVyciA9IHVmc2hjZF9oYmFfZW5hYmxlKGhiYSk7DQogCWlmIChlcnIp
DQotCQlyZXR1cm4gZXJyOw0KKwkJZ290byBvdXQ7DQogDQogCWVyciA9IHVmc19tdGtfdW5pcHJv
X3NldF9wbShoYmEsIDApOw0KIAlpZiAoZXJyKQ0KLQkJcmV0dXJuIGVycjsNCisJCWdvdG8gb3V0
Ow0KIA0KIAllcnIgPSB1ZnNoY2RfdWljX2hpYmVybjhfZXhpdChoYmEpOw0KIAlpZiAoIWVycikN
CiAJCXVmc2hjZF9zZXRfbGlua19hY3RpdmUoaGJhKTsNCiAJZWxzZQ0KLQkJcmV0dXJuIGVycjsN
CisJCWdvdG8gb3V0Ow0KIA0KIAllcnIgPSB1ZnNoY2RfbWFrZV9oYmFfb3BlcmF0aW9uYWwoaGJh
KTsNCiAJaWYgKGVycikNCi0JCXJldHVybiBlcnI7DQotDQorCQlnb3RvIG91dDsNCitvdXQ6DQor
CWlmIChlcnIpDQorCQl1ZnNoY2RfcHJpbnRfaW5mbyhoYmEsIFVGU19JTkZPX0hPU1RfU1RBVEUg
fA0KKwkJCQkgIFVGU19JTkZPX0hPU1RfUkVHUyB8IFVGU19JTkZPX1BXUik7DQogCXJldHVybiAw
Ow0KIH0NCiANCkBAIC00OTQsNiArNDk3LDkgQEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc2V0
X2xwbShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIA0KIAllcnIgPSB1ZnNfbXRrX3VuaXByb19zZXRf
cG0oaGJhLCAxKTsNCiAJaWYgKGVycikgew0KKwkJdWZzaGNkX3ByaW50X2luZm8oaGJhLCBVRlNf
SU5GT19IT1NUX1NUQVRFIHwNCisJCQkJICBVRlNfSU5GT19IT1NUX1JFR1MgfCBVRlNfSU5GT19Q
V1IpOw0KKw0KIAkJLyogUmVzdW1lIFVuaVBybyBzdGF0ZSBmb3IgZm9sbG93aW5nIGVycm9yIHJl
Y292ZXJ5ICovDQogCQl1ZnNfbXRrX3VuaXByb19zZXRfcG0oaGJhLCAwKTsNCiAJCXJldHVybiBl
cnI7DQotLSANCjIuMTguMA0K

