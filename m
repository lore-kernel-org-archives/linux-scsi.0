Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F58CC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 14:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E27782071A
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 14:48:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QaoxgXDr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgFOOsO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 10:48:14 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:24386 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730353AbgFOOsN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 10:48:13 -0400
X-UUID: 0c4e5100b1c744faa74deee3bcffb86d-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=9Jrxg+K/KEKim/cVYfaklTsm5g5BtXdZJCkdT9NVb7Y=;
        b=QaoxgXDrbPxiv114paz3+Qxoy8lZADTKf6A+w9sShjDSX8lGpPvZoTs6crJ8qhrrwygSRKBBHrs2pX01Q4Wxjt7bZJ/J1HPUvmBM6OfX1IB/6FxP/pCrgxZYswNkjOuvyNKiJ+2B7hkWKzjgryMQFznjORlroOBDSN5qXg+5XN4=;
X-UUID: 0c4e5100b1c744faa74deee3bcffb86d-20200615
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1823175320; Mon, 15 Jun 2020 22:48:08 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 22:48:04 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 22:48:03 +0800
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
Subject: [PATCH v2 3/3] scsi: ufs-mediatek: Print host information for failed supsend and resume
Date:   Mon, 15 Jun 2020 22:48:05 +0800
Message-ID: <20200615144805.6921-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200615144805.6921-1-stanley.chu@mediatek.com>
References: <20200615144805.6921-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UHJpbnQgaG9zdCBzdGF0ZSBhbmQgcmVnaXN0ZXIgZHVtcHMgd2hpbGUgc3VzcGVuZCBvciByZXN1
bWUgZmxvdw0KaXMgZmFpbGVkLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rhbmxl
eS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsu
YyB8IDE2ICsrKysrKysrKystLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygr
KSwgNiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1l
ZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCBkNTZjZThk
OTdkNGUuLjBiYjdlZDg0MTgwOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1l
ZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC00Njks
MjMgKzQ2OSwyNCBAQCBzdGF0aWMgaW50IHVmc19tdGtfbGlua19zZXRfaHBtKHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQogDQogCWVyciA9IHVmc2hjZF9oYmFfZW5hYmxlKGhiYSk7DQogCWlmIChlcnIp
DQotCQlyZXR1cm4gZXJyOw0KKwkJZ290byBvdXQ7DQogDQogCWVyciA9IHVmc19tdGtfdW5pcHJv
X3NldF9wbShoYmEsIDApOw0KIAlpZiAoZXJyKQ0KLQkJcmV0dXJuIGVycjsNCisJCWdvdG8gb3V0
Ow0KIA0KIAllcnIgPSB1ZnNoY2RfdWljX2hpYmVybjhfZXhpdChoYmEpOw0KIAlpZiAoIWVycikN
CiAJCXVmc2hjZF9zZXRfbGlua19hY3RpdmUoaGJhKTsNCiAJZWxzZQ0KLQkJcmV0dXJuIGVycjsN
CisJCWdvdG8gb3V0Ow0KIA0KIAllcnIgPSB1ZnNoY2RfbWFrZV9oYmFfb3BlcmF0aW9uYWwoaGJh
KTsNCitvdXQ6DQogCWlmIChlcnIpDQotCQlyZXR1cm4gZXJyOw0KLQ0KLQlyZXR1cm4gMDsNCisJ
CXVmc2hjZF9wcmludF9pbmZvKGhiYSwgVUZTX0lORk9fSE9TVF9TVEFURSB8DQorCQkJCSAgVUZT
X0lORk9fSE9TVF9SRUdTIHwgVUZTX0lORk9fUFdSKTsNCisJcmV0dXJuIGVycjsNCiB9DQogDQog
c3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc2V0X2xwbShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KQEAg
LTQ5NCw2ICs0OTUsOSBAQCBzdGF0aWMgaW50IHVmc19tdGtfbGlua19zZXRfbHBtKHN0cnVjdCB1
ZnNfaGJhICpoYmEpDQogDQogCWVyciA9IHVmc19tdGtfdW5pcHJvX3NldF9wbShoYmEsIDEpOw0K
IAlpZiAoZXJyKSB7DQorCQl1ZnNoY2RfcHJpbnRfaW5mbyhoYmEsIFVGU19JTkZPX0hPU1RfU1RB
VEUgfA0KKwkJCQkgIFVGU19JTkZPX0hPU1RfUkVHUyB8IFVGU19JTkZPX1BXUik7DQorDQogCQkv
KiBSZXN1bWUgVW5pUHJvIHN0YXRlIGZvciBmb2xsb3dpbmcgZXJyb3IgcmVjb3ZlcnkgKi8NCiAJ
CXVmc19tdGtfdW5pcHJvX3NldF9wbShoYmEsIDApOw0KIAkJcmV0dXJuIGVycjsNCi0tIA0KMi4x
OC4wDQo=

