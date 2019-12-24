Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B7FC2D0CF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 13:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 981B5206B7
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 13:01:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gibLG20V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLXNBU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 08:01:20 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:14063 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726261AbfLXNBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 08:01:20 -0500
X-UUID: cdcd61322efe4b6fbf88309e0e278fe5-20191224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=FeNUMJ8s8x/C/Z04IhD8459YxUbM45a3DYN6mu1093s=;
        b=gibLG20VPQWOe1ZAQKhWn7ODuwwrPIsuG9Z4ptmsElzAVfmTwBqIdMlOjzwblwsoogk141flQYxfv151RNuog86XPrc06Fv34kEXIui4wGhvFO9aqFroQqRW6umiFGH0JZjc6UI7jtXo7nOHEjXn4kXEEMKhhWGxz5wi2cbxefA=;
X-UUID: cdcd61322efe4b6fbf88309e0e278fe5-20191224
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1783735769; Tue, 24 Dec 2019 21:01:15 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 24 Dec 2019 21:00:36 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 24 Dec 2019 21:00:06 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/2] scsi: ufs: unify scsi_block_requests usage
Date:   Tue, 24 Dec 2019 21:01:05 +0800
Message-ID: <1577192466-20762-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
References: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 672D92876DE5E1799BB940708AAC8AC0F29380FDFB330A264E2A27CA6C0D31B82000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q3VycmVudGx5IFVGUyBkcml2ZXIgaGFzIHVmc2hjZF9zY3NpX2Jsb2NrX3JlcXVlc3RzKCkgd2l0
aA0KcmVmZXJlbmNlIGNvdW50ZXIgbWVjaGFuaXNtIHRvIGF2b2lkIHBvc3NpYmxlIHJhY2luZyBv
ZiBibG9ja2luZyBhbmQNCnVuYmxvY2tpbmcgcmVxdWVzdHMgZmxvdy4gVW5pZnkgYWxsIHVzZXJz
IGluIFVGUyBkcml2ZXIgdG8gdXNlIHRoZQ0Kc2FtZSBmdW5jdGlvbi4NCg0KU2lnbmVkLW9mZi1i
eTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMgfCAgICA0ICsrLS0NCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IGVkMDJhNzAuLmI2Yjk2
NjUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtNTE3Nyw3ICs1MTc3LDcgQEAgc3RhdGljIHZvaWQgdWZz
aGNkX2V4Y2VwdGlvbl9ldmVudF9oYW5kbGVyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAJ
aGJhID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCB1ZnNfaGJhLCBlZWhfd29yayk7DQogDQog
CXBtX3J1bnRpbWVfZ2V0X3N5bmMoaGJhLT5kZXYpOw0KLQlzY3NpX2Jsb2NrX3JlcXVlc3RzKGhi
YS0+aG9zdCk7DQorCXVmc2hjZF9zY3NpX2Jsb2NrX3JlcXVlc3RzKGhiYSk7DQogCWVyciA9IHVm
c2hjZF9nZXRfZWVfc3RhdHVzKGhiYSwgJnN0YXR1cyk7DQogCWlmIChlcnIpIHsNCiAJCWRldl9l
cnIoaGJhLT5kZXYsICIlczogZmFpbGVkIHRvIGdldCBleGNlcHRpb24gc3RhdHVzICVkXG4iLA0K
QEAgLTUxOTEsNyArNTE5MSw3IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9leGNlcHRpb25fZXZlbnRf
aGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQogCQl1ZnNoY2RfYmtvcHNfZXhjZXB0
aW9uX2V2ZW50X2hhbmRsZXIoaGJhKTsNCiANCiBvdXQ6DQotCXNjc2lfdW5ibG9ja19yZXF1ZXN0
cyhoYmEtPmhvc3QpOw0KKwl1ZnNoY2Rfc2NzaV91bmJsb2NrX3JlcXVlc3RzKGhiYSk7DQogCXBt
X3J1bnRpbWVfcHV0X3N5bmMoaGJhLT5kZXYpOw0KIAlyZXR1cm47DQogfQ0KLS0gDQoxLjcuOS41
DQo=

