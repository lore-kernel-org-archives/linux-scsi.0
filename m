Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33C4C2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8DEF24680
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WTB+2UrY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfLTIgn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 03:36:43 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:19551 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727169AbfLTIgm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 03:36:42 -0500
X-UUID: 8d6b074183d847f6adc06a64d4203b2e-20191220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Xw6bLLj+B2ZB/KL06SKr19CTTnISadQE3iBM5YdxwjU=;
        b=WTB+2UrYR6OuHDJeW/BXGr5nwmT6+Hd787+h2hZ2qTBMu1XokVMzpKwWJANpJhV3tWsKMU9+5/grxmIUdPDa6oWJETCe9JFg5BKrpzn8LsD4ynbn+TXMRksYMrEQiyNuLlUKdpqooIvBcjz9kDEOLf6UAfJFk7YIQjGwD5jKr1s=;
X-UUID: 8d6b074183d847f6adc06a64d4203b2e-20191220
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 750616761; Fri, 20 Dec 2019 16:36:34 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 20 Dec 2019 16:35:58 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 20 Dec 2019 16:35:39 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <f.fainelli@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <leon.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 4/6] scsi: ufs: export ufshcd_auto_hibern8_update for vendor usage
Date:   Fri, 20 Dec 2019 16:36:26 +0800
Message-ID: <1576830988-22435-5-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
References: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 4737E59BD6FF4B96899E40ACEF4F545CDA6611A17392CA37871ED1722009C94A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RXhwb3J0IHVmc2hjZF9hdXRvX2hpYmVybjhfdXBkYXRlIHRvIGFsbG93IHZlbmRvcnMgdG8gdXNl
IGNvbW1vbg0KaW50ZXJmYWNlIHRvIGN1c3RvbWl6ZSBhdXRvLWhpYmVybmF0ZSB0aW1lci4NCg0K
U2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJl
dmlld2VkLWJ5OiBBc3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc+DQpSZXZpZXdl
ZC1ieTogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPg0KLS0tDQogZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtc3lzZnMuYyB8IDIwIC0tLS0tLS0tLS0tLS0tLS0tLS0tDQogZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYyAgICB8IDE4ICsrKysrKysrKysrKysrKysrKw0KIGRyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmggICAgfCAgMSArDQogMyBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRp
b25zKCspLCAyMCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLXN5c2ZzLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jDQppbmRleCBhZDJhYmM5
NmMwZjEuLjcyMGJlM2Y2NGJlNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXN5
c2ZzLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMNCkBAIC0xMTgsMjYgKzEx
OCw2IEBAIHN0YXRpYyBzc2l6ZV90IHNwbV90YXJnZXRfbGlua19zdGF0ZV9zaG93KHN0cnVjdCBk
ZXZpY2UgKmRldiwNCiAJCQkJdWZzX3BtX2x2bF9zdGF0ZXNbaGJhLT5zcG1fbHZsXS5saW5rX3N0
YXRlKSk7DQogfQ0KIA0KLXN0YXRpYyB2b2lkIHVmc2hjZF9hdXRvX2hpYmVybjhfdXBkYXRlKHN0
cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBhaGl0KQ0KLXsNCi0JdW5zaWduZWQgbG9uZyBmbGFnczsN
Ci0NCi0JaWYgKCF1ZnNoY2RfaXNfYXV0b19oaWJlcm44X3N1cHBvcnRlZChoYmEpKQ0KLQkJcmV0
dXJuOw0KLQ0KLQlzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3Mp
Ow0KLQlpZiAoaGJhLT5haGl0ICE9IGFoaXQpDQotCQloYmEtPmFoaXQgPSBhaGl0Ow0KLQlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQotCWlmICgh
cG1fcnVudGltZV9zdXNwZW5kZWQoaGJhLT5kZXYpKSB7DQotCQlwbV9ydW50aW1lX2dldF9zeW5j
KGhiYS0+ZGV2KTsNCi0JCXVmc2hjZF9ob2xkKGhiYSwgZmFsc2UpOw0KLQkJdWZzaGNkX2F1dG9f
aGliZXJuOF9lbmFibGUoaGJhKTsNCi0JCXVmc2hjZF9yZWxlYXNlKGhiYSk7DQotCQlwbV9ydW50
aW1lX3B1dChoYmEtPmRldik7DQotCX0NCi19DQotDQogLyogQ29udmVydCBBdXRvLUhpYmVybmF0
ZSBJZGxlIFRpbWVyIHJlZ2lzdGVyIHZhbHVlIHRvIG1pY3Jvc2Vjb25kcyAqLw0KIHN0YXRpYyBp
bnQgdWZzaGNkX2FoaXRfdG9fdXModTMyIGFoaXQpDQogew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBhNjkz
NmJlYmI1MTMuLmVkMDJhNzA0YzFjMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC0zODkzLDYgKzM4OTMs
MjQgQEAgc3RhdGljIGludCB1ZnNoY2RfdWljX2hpYmVybjhfZXhpdChzdHJ1Y3QgdWZzX2hiYSAq
aGJhKQ0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCit2b2lkIHVmc2hjZF9hdXRvX2hpYmVybjhfdXBk
YXRlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBhaGl0KQ0KK3sNCisJdW5zaWduZWQgbG9uZyBm
bGFnczsNCisNCisJaWYgKCEoaGJhLT5jYXBhYmlsaXRpZXMgJiBNQVNLX0FVVE9fSElCRVJOOF9T
VVBQT1JUKSkNCisJCXJldHVybjsNCisNCisJc3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0LT5o
b3N0X2xvY2ssIGZsYWdzKTsNCisJaWYgKGhiYS0+YWhpdCA9PSBhaGl0KQ0KKwkJZ290byBvdXRf
dW5sb2NrOw0KKwloYmEtPmFoaXQgPSBhaGl0Ow0KKwlpZiAoIXBtX3J1bnRpbWVfc3VzcGVuZGVk
KGhiYS0+ZGV2KSkNCisJCXVmc2hjZF93cml0ZWwoaGJhLCBoYmEtPmFoaXQsIFJFR19BVVRPX0hJ
QkVSTkFURV9JRExFX1RJTUVSKTsNCitvdXRfdW5sb2NrOg0KKwlzcGluX3VubG9ja19pcnFyZXN0
b3JlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQorfQ0KK0VYUE9SVF9TWU1CT0xfR1BM
KHVmc2hjZF9hdXRvX2hpYmVybjhfdXBkYXRlKTsNCisNCiB2b2lkIHVmc2hjZF9hdXRvX2hpYmVy
bjhfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAl1bnNpZ25lZCBsb25nIGZsYWdz
Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5oDQppbmRleCBiNTM2YTI2ZDY2NWUuLmUwNWNhZmRkYzg3YiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmgNCkBAIC05MjMsNiArOTIzLDcgQEAgaW50IHVmc2hjZF9xdWVyeV9mbGFnKHN0cnVjdCB1
ZnNfaGJhICpoYmEsIGVudW0gcXVlcnlfb3Bjb2RlIG9wY29kZSwNCiAJZW51bSBmbGFnX2lkbiBp
ZG4sIGJvb2wgKmZsYWdfcmVzKTsNCiANCiB2b2lkIHVmc2hjZF9hdXRvX2hpYmVybjhfZW5hYmxl
KHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KK3ZvaWQgdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUo
c3RydWN0IHVmc19oYmEgKmhiYSwgdTMyIGFoaXQpOw0KIA0KICNkZWZpbmUgU0RfQVNDSUlfU1RE
IHRydWUNCiAjZGVmaW5lIFNEX1JBVyBmYWxzZQ0KLS0gDQoyLjE4LjANCg==

