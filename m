Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163C8C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E00B8206F2
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:53:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KUG0oKg0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgC0Jxg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 05:53:36 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:59386 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726096AbgC0Jxg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 05:53:36 -0400
X-UUID: 29238de83294437fb1d0234feff4fc27-20200327
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=X65KhStxBXm6tC9CI8ImCK/G24gu+sDu1lPtIdSpMxY=;
        b=KUG0oKg0QJqdYbm1dzR5NyuVycOTFoTvook9jaL7ZMTNzbr53I1f44sYBD5b2j50Tp2MbpG5TtYYzgou5UiCXcK99WZwvaDhSTG5L09jwFm/nek6dV6vNcOijW5j1KPYx4sKVsHueu28pEjNgAzuT+jsKSEvGx7lf0mV3DcbvXg=;
X-UUID: 29238de83294437fb1d0234feff4fc27-20200327
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1354243963; Fri, 27 Mar 2020 17:53:32 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 27 Mar 2020 17:53:30 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 27 Mar 2020 17:53:30 +0800
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
Subject: [PATCH v3 2/2] scsi: ufs-mediatek: add error recovery for suspend and resume
Date:   Fri, 27 Mar 2020 17:53:29 +0800
Message-ID: <20200327095329.10083-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200327095329.10083-1-stanley.chu@mediatek.com>
References: <20200327095329.10083-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T25jZSBmYWlsIGhhcHBlbnMgZHVyaW5nIHN1c3BlbmQgYW5kIHJlc3VtZSBmbG93IGlmIHRoZSBk
ZXNpcmVkIGxvdw0KcG93ZXIgbGluayBzdGF0ZSBpcyBIOCwgbGluayByZWNvdmVyeSBpcyByZXF1
aXJlZCBmb3IgTWVkaWFUZWsgVUZTDQpjb250cm9sbGVyLg0KDQpGb3IgcmVzdW1lIGZsb3csIHNp
bmNlIHBvd2VyIGFuZCBjbG9ja3MgYXJlIGFscmVhZHkgZW5hYmxlZCBiZWZvcmUNCmludm9raW5n
IHZlbmRvcidzIHJlc3VtZSBjYWxsYmFjaywgc2ltcGx5IHVzaW5nIHVmc2hjZF9saW5rX3JlY292
ZXJ5KCkNCmluc2lkZSBjYWxsYmFjayBpcyBmaW5lLg0KDQpGb3Igc3VzcGVuZCBmbG93LCB0aGUg
ZGV2aWNlIHBvd2VyIGVudGVycyBsb3cgcG93ZXIgbW9kZSBvciBpcyBkaXNhYmxlZA0KYmVmb3Jl
IHN1c3BlbmQgY2FsbGJhY2ssIHRodXMgdWZzaGNkX2xpbmtfcmVjb3ZlcnkoKSBjYW4gbm90IGJl
IGRpcmVjdGx5DQp1c2VkIGluIHZlbmRvciBjYWxsYmFjay4gT25lIHNvbHV0aW9uIGlzIHRvIHNl
dCB0aGUgbGluayB0byBvZmYgc3RhdGUNCmFuZCB0aGVuIHVmc2hjZF9ob3N0X3Jlc2V0X2FuZF9y
ZXN0b3JlKCkgd2lsbCBiZSBleGVjdXRlZCBieSB1ZnNoY2Rfc3VzcGVuZCgpLg0KDQpTaWduZWQt
b2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQt
Ynk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KLS0tDQogZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDEzICsrKysrKysrKysrLS0NCiAxIGZpbGUgY2hhbmdlZCwg
MTEgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5j
DQppbmRleCA0MGE2NmIzMWIzMWYuLjY3M2MxNjU5NmZiMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlh
dGVrLmMNCkBAIC00OTksOCArNDk5LDE1IEBAIHN0YXRpYyBpbnQgdWZzX210a19zdXNwZW5kKHN0
cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KIA0KIAlpZiAodWZzaGNk
X2lzX2xpbmtfaGliZXJuOChoYmEpKSB7DQogCQllcnIgPSB1ZnNfbXRrX2xpbmtfc2V0X2xwbSho
YmEpOw0KLQkJaWYgKGVycikNCisJCWlmIChlcnIpIHsNCisJCQkvKg0KKwkJCSAqIFNldCBsaW5r
IGFzIG9mZiBzdGF0ZSBlbmZvcmNlZGx5IHRvIHRyaWdnZXINCisJCQkgKiB1ZnNoY2RfaG9zdF9y
ZXNldF9hbmRfcmVzdG9yZSgpIGluIHVmc2hjZF9zdXNwZW5kKCkNCisJCQkgKiBmb3IgY29tcGxl
dGVkIGhvc3QgcmVzZXQuDQorCQkJICovDQorCQkJdWZzaGNkX3NldF9saW5rX29mZihoYmEpOw0K
IAkJCXJldHVybiAtRUFHQUlOOw0KKwkJfQ0KIAl9DQogDQogCWlmICghdWZzaGNkX2lzX2xpbmtf
YWN0aXZlKGhiYSkpDQpAQCAtNTE5LDggKzUyNiwxMCBAQCBzdGF0aWMgaW50IHVmc19tdGtfcmVz
dW1lKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KIA0KIAlpZiAo
dWZzaGNkX2lzX2xpbmtfaGliZXJuOChoYmEpKSB7DQogCQllcnIgPSB1ZnNfbXRrX2xpbmtfc2V0
X2hwbShoYmEpOw0KLQkJaWYgKGVycikNCisJCWlmIChlcnIpIHsNCisJCQllcnIgPSB1ZnNoY2Rf
bGlua19yZWNvdmVyeShoYmEpOw0KIAkJCXJldHVybiBlcnI7DQorCQl9DQogCX0NCiANCiAJcmV0
dXJuIDA7DQotLSANCjIuMTguMA0K

