Return-Path: <SRS0=TiDh=47=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A9CC10DCE
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Mar 2020 03:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B63272067C
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Mar 2020 03:16:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="B3sbXdyo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgCNDQM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 23:16:12 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:1714 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726593AbgCNDQL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 23:16:11 -0400
X-UUID: f93f8aedbd494ea2b73b31f75a61258e-20200314
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=C2K4Cop7Wb0RFGven4yS2g1JnnYfQ0FnAQYy/7x6fJg=;
        b=B3sbXdyotBQj1L/y27wG3lh0Uksf7RPvHiB0QpCGs4q653rsbekwFx6g73ucZGZ2NLQojzCC4zqmcK4pZKKEFP1IxvAzXQOUy8LsSbKUOJH2rjNO+1/Da/+pvVKEN3fL65nAEdj++G6jMt7M5zXQWYtGP+XJItSkw3EvAH34OYc=;
X-UUID: f93f8aedbd494ea2b73b31f75a61258e-20200314
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1937859533; Sat, 14 Mar 2020 11:16:04 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 14 Mar 2020 11:13:12 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 14 Mar 2020 11:15:58 +0800
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
Subject: [PATCH v1 2/2] scsi: ufs-mediatek: add error recovery for suspend and resume
Date:   Sat, 14 Mar 2020 11:16:00 +0800
Message-ID: <20200314031600.10616-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200314031600.10616-1-stanley.chu@mediatek.com>
References: <20200314031600.10616-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 5F831230383B796E830BE403768E4242EE53CFA2BA907BF921702FA6DC027FB22000:8
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
IGRpcmVjdGx5DQp1c2VkIGluIGNhbGxiYWNrLiBUbyBsZXZlcmFnZSBob3N0IHJlc2V0IGZsb3cg
ZHVyaW5nIHVmc2hjZF9zdXNwZW5kKCksDQpzZXQgbGluayBhcyBvZmYgc3RhdGUgZW5mb3JjZWRs
eSB0byBsZXQgdWZzaGNkX2hvc3RfcmVzZXRfYW5kX3Jlc3RvcmUoKQ0KYmUgZXhlY3V0ZWQgYnkg
dWZzaGNkX3N1c3BlbmQoKS4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXku
Y2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMg
fCAxMiArKysrKysrKysrLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCBjMGZkN2QyZTRkMGQu
LmYxOWU5YTY0ZDQ5MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC00OTksOCArNDk5
LDE0IEBAIHN0YXRpYyBpbnQgdWZzX210a19zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVu
dW0gdWZzX3BtX29wIHBtX29wKQ0KIA0KIAlpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJuOChoYmEp
KSB7DQogCQllcnIgPSB1ZnNfbXRrX2xpbmtfc2V0X2xwbShoYmEpOw0KLQkJaWYgKGVycikNCisJ
CWlmIChlcnIpIHsNCisJCQkvKiBTZXQgbGluayBhcyBvZmYgc3RhdGUgZW5mb3JjZWRseSB0byB0
cmlnZ2VyDQorCQkJICogdWZzaGNkX2hvc3RfcmVzZXRfYW5kX3Jlc3RvcmUoKSBpbiB1ZnNoY2Rf
c3VzcGVuZCgpDQorCQkJICogZm9yIGNvbXBsZXRlZCBob3N0IHJlc2V0Lg0KKwkJCSAqLw0KKwkJ
CXVmc2hjZF9zZXRfbGlua19vZmYoaGJhKTsNCiAJCQlyZXR1cm4gLUVBR0FJTjsNCisJCX0NCiAJ
fQ0KIA0KIAlpZiAoIXVmc2hjZF9pc19saW5rX2FjdGl2ZShoYmEpKQ0KQEAgLTUxOSw4ICs1MjUs
MTAgQEAgc3RhdGljIGludCB1ZnNfbXRrX3Jlc3VtZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBlbnVt
IHVmc19wbV9vcCBwbV9vcCkNCiANCiAJaWYgKHVmc2hjZF9pc19saW5rX2hpYmVybjgoaGJhKSkg
ew0KIAkJZXJyID0gdWZzX210a19saW5rX3NldF9ocG0oaGJhKTsNCi0JCWlmIChlcnIpDQorCQlp
ZiAoZXJyKSB7DQorCQkJZXJyID0gdWZzaGNkX2xpbmtfcmVjb3ZlcnkoaGJhKTsNCiAJCQlyZXR1
cm4gZXJyOw0KKwkJfQ0KIAl9DQogDQogCXJldHVybiAwOw0KLS0gDQoyLjE4LjANCg==

