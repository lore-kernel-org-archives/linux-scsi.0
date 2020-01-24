Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8960FC2D0CE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 06:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56A552075D
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 06:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HDlh49id"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbgAXGtq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 01:49:46 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:31589 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725821AbgAXGtm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 01:49:42 -0500
X-UUID: 53f51b347ad8400786d414e6f6f433ba-20200124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=sanORfjg6NPucKVeaKYtBr+xECUEpDbW1uS8loVUxZA=;
        b=HDlh49idUKB0E6MxjoMM60wIF0q3fsUur5QTrYt+S+LTfU6Zqau/bFC1SGJwbNcNDCVX6dtHEc9d0Uawpzf6+35XTLrc6ta3dMKkKRMPWlHlo1X4tsF8J6KK+V89d9Q8z4zw4MAlXM+LFpTPCjfVYSUxzk37GEK2b4sIpH9NHlY=;
X-UUID: 53f51b347ad8400786d414e6f6f433ba-20200124
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 248668337; Fri, 24 Jan 2020 14:49:31 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 14:48:49 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 Jan 2020 14:48:58 +0800
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
Subject: [PATCH v1 5/5] scsi: ufs-mediatek: gate ref-clk during Auto-Hibern8
Date:   Fri, 24 Jan 2020 14:49:26 +0800
Message-ID: <20200124064926.29472-6-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200124064926.29472-1-stanley.chu@mediatek.com>
References: <20200124064926.29472-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW4gY3VycmVudCBVRlMgZHJpdmVyIGRlc2lnbiwgaGJhLT51aWNfbGlua19zdGF0ZSB3aWxsIG5v
dA0KYmUgY2hhbmdlZCwgZm9yIGV4YW1wbGUsIGtlcHQgYXMgVUlDX0xJTktfQUNUSVZFX1NUQVRF
LCBhZnRlcg0KbGluayBlbnRlcnMgSGliZXJuOCBzdGF0ZSBieSBBdXRvLUhpYmVybjggZmVhdHVy
ZS4gSW4gdGhpcyBjYXNlLA0KcmVmZXJlbmNlIGNsb2NrIGdhdGluZyB3aWxsIGJlIHNraXBwZWQg
dW5sZXNzIHNwZWNpYWwgaGFuZGxpbmcNCmlzIGltcGxlbWVudGVkIGluIHZlbmRvcidzIGNhbGxi
YWNrcy4NCg0KU3VwcG9ydCByZWZlcmVuY2UgY2xvY2sgZ2F0aW5nIGR1cmluZyBBdXRvLUhpYmVy
bjggcGVyaW9kIGluDQpNZWRpYVRlayBDaGlwc2V0czogSWYgbGluayBzdGF0ZSBpcyBhbHJlYWR5
IGluIEhpYmVybjggd2hpbGUNCkF1dG8tSGliZXJuOCBmZWF0dXJlIGlzIGVuYWJsZWQsIGdhdGUg
cmVmZXJlbmN0IGNsb2NrIGluDQpzZXR1cF9jbG9ja3MgY2FsbGJhY2suDQoNClNpZ25lZC1vZmYt
Ynk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMzggKysrKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCB8IDEyICsrKysrKysrKysr
DQogMiBmaWxlcyBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkNCg0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCBkNzg4OTdhMTQ5MDUuLmFiZjlkZDc1YzQyZSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0xNDMsNiArMTQzLDE3IEBAIHN0YXRpYyBp
bnQgdWZzX210a19zZXR1cF9yZWZfY2xrKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgb24pDQog
CXJldHVybiAwOw0KIH0NCiANCitzdGF0aWMgdTMyIHVmc19tdGtfbGlua19nZXRfc3RhdGUoc3Ry
dWN0IHVmc19oYmEgKmhiYSkNCit7DQorCXUzMiB2YWw7DQorDQorCXVmc2hjZF93cml0ZWwoaGJh
LCAweDIwLCBSRUdfVUZTX0RFQlVHX1NFTCk7DQorCXZhbCA9IHVmc2hjZF9yZWFkbChoYmEsIFJF
R19VRlNfUFJPQkUpOw0KKwl2YWwgPSB2YWwgPj4gMjg7DQorDQorCXJldHVybiB2YWw7DQorfQ0K
Kw0KIC8qKg0KICAqIHVmc19tdGtfc2V0dXBfY2xvY2tzIC0gZW5hYmxlcy9kaXNhYmxlIGNsb2Nr
cw0KICAqIEBoYmE6IGhvc3QgY29udHJvbGxlciBpbnN0YW5jZQ0KQEAgLTE1NSw3ICsxNjYsNyBA
QCBzdGF0aWMgaW50IHVmc19tdGtfc2V0dXBfY2xvY2tzKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJv
b2wgb24sDQogCQkJCWVudW0gdWZzX25vdGlmeV9jaGFuZ2Vfc3RhdHVzIHN0YXR1cykNCiB7DQog
CXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCi0J
aW50IHJldCA9IC1FSU5WQUw7DQorCWludCByZXQgPSAwOw0KIA0KIAkvKg0KIAkgKiBJbiBjYXNl
IHVmc19tdGtfaW5pdCgpIGlzIG5vdCB5ZXQgZG9uZSwgc2ltcGx5IGlnbm9yZS4NCkBAIC0xNjUs
MTkgKzE3NiwyNCBAQCBzdGF0aWMgaW50IHVmc19tdGtfc2V0dXBfY2xvY2tzKHN0cnVjdCB1ZnNf
aGJhICpoYmEsIGJvb2wgb24sDQogCWlmICghaG9zdCkNCiAJCXJldHVybiAwOw0KIA0KLQlzd2l0
Y2ggKHN0YXR1cykgew0KLQljYXNlIFBSRV9DSEFOR0U6DQotCQlpZiAoIW9uICYmICF1ZnNoY2Rf
aXNfbGlua19hY3RpdmUoaGJhKSkgew0KKwlpZiAoIW9uICYmIHN0YXR1cyA9PSBQUkVfQ0hBTkdF
KSB7DQorCQlpZiAoIXVmc2hjZF9pc19saW5rX2FjdGl2ZShoYmEpKSB7DQogCQkJdWZzX210a19z
ZXR1cF9yZWZfY2xrKGhiYSwgb24pOw0KIAkJCXJldCA9IHBoeV9wb3dlcl9vZmYoaG9zdC0+bXBo
eSk7DQorCQl9IGVsc2Ugew0KKwkJCS8qDQorCQkJICogR2F0ZSByZWYtY2xrIGlmIGxpbmsgc3Rh
dGUgaXMgaW4gSGliZXJuOA0KKwkJCSAqIHRyaWdnZXJlZCBieSBBdXRvLUhpYmVybjguDQorCQkJ
ICovDQorCQkJaWYgKCF1ZnNoY2RfY2FuX2hpYmVybjhfZHVyaW5nX2dhdGluZyhoYmEpICYmDQor
CQkJICAgIHVmc2hjZF9pc19hdXRvX2hpYmVybjhfZW5hYmxlZChoYmEpICYmDQorCQkJICAgIHVm
c19tdGtfbGlua19nZXRfc3RhdGUoaGJhKSA9PQ0KKwkJCSAgICBWU19MSU5LX0hJQkVSOCkNCisJ
CQkJdWZzX210a19zZXR1cF9yZWZfY2xrKGhiYSwgb24pOw0KIAkJfQ0KLQkJYnJlYWs7DQotCWNh
c2UgUE9TVF9DSEFOR0U6DQotCQlpZiAob24pIHsNCi0JCQlyZXQgPSBwaHlfcG93ZXJfb24oaG9z
dC0+bXBoeSk7DQotCQkJdWZzX210a19zZXR1cF9yZWZfY2xrKGhiYSwgb24pOw0KLQkJfQ0KLQkJ
YnJlYWs7DQorCX0gZWxzZSBpZiAob24gJiYgc3RhdHVzID09IFBPU1RfQ0hBTkdFKSB7DQorCQly
ZXQgPSBwaHlfcG93ZXJfb24oaG9zdC0+bXBoeSk7DQorCQl1ZnNfbXRrX3NldHVwX3JlZl9jbGso
aGJhLCBvbik7DQogCX0NCiANCiAJcmV0dXJuIHJldDsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0K
aW5kZXggZmNjZGQ5NzlkNmZiLi5jMzJjYjQyYzg5NDIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5oDQpAQCAtNTMsNiArNTMsMTggQEANCiAjZGVmaW5lIFZTX1NBVkVQT1dFUkNPTlRST0wgICAg
ICAgICAweEQwQTYNCiAjZGVmaW5lIFZTX1VOSVBST1BPV0VSRE9XTkNPTlRST0wgICAweEQwQTgN
CiANCisvKg0KKyAqIFZlbmRvciBzcGVjaWZpYyBsaW5rIHN0YXRlDQorICovDQorZW51bSB7DQor
CVZTX0xJTktfRElTQUJMRUQgICAgICAgICAgICA9IDAsDQorCVZTX0xJTktfRE9XTiAgICAgICAg
ICAgICAgICA9IDEsDQorCVZTX0xJTktfVVAgICAgICAgICAgICAgICAgICA9IDIsDQorCVZTX0xJ
TktfSElCRVI4ICAgICAgICAgICAgICA9IDMsDQorCVZTX0xJTktfTE9TVCAgICAgICAgICAgICAg
ICA9IDQsDQorCVZTX0xJTktfQ0ZHICAgICAgICAgICAgICAgICA9IDUsDQorfTsNCisNCiAvKg0K
ICAqIFNpUCBjb21tYW5kcw0KICAqLw0KLS0gDQoyLjE4LjANCg==

