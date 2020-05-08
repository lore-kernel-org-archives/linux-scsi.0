Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B19C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7686A207DD
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jXappDhh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgEHIBY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:01:24 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:40573 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726974AbgEHIBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:01:23 -0400
X-UUID: 5451aae3a1dd42bea1cd4bed645b84f6-20200508
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=uGT7hSTUzH9ZKoRQUM/Tvp8FCrc2dsU2C85wx6zrn7c=;
        b=jXappDhhT6v7+89hWqkMKS6/jweiyhR/macCNpBydYfSeFGDa5UkOJ7BDDO27f6M76jlElqkwtijSABhNScf78ey3im8UYPeZIHS4SAhr2uzFAQRS4kNciPwFEd1BKMFxigjO8wuQsxwaIpZFXCyVdRQdy7fnrAf79fMooDd26U=;
X-UUID: 5451aae3a1dd42bea1cd4bed645b84f6-20200508
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 431706336; Fri, 08 May 2020 16:01:20 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 8 May 2020 16:01:16 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 16:01:18 +0800
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
Subject: [PATCH v8 3/8] scsi: ufs: export ufs_fixup_device_setup() function
Date:   Fri, 8 May 2020 16:01:10 +0800
Message-ID: <20200508080115.24233-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200508080115.24233-1-stanley.chu@mediatek.com>
References: <20200508080115.24233-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 47C1EFE60891844C887843C26736B395BD6B73E41061F5077EBA054EDA9897692000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RXhwb3J0IHVmc19maXh1cF9kZXZpY2Vfc2V0dXAoKSB0byBhbGxvdyB2ZW5kb3JzIHRvIHJlLXVz
ZSBpdCBmb3INCmZpeGluZyBkZXZpY2UgcXVyaWtzIG9uIHNwZWNpZmllZCBVRlMgaG9zdHMuDQoN
ClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpS
ZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQotLS0NCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMTAgKysrKysrKy0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmggfCAgMSArDQogMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDMgZGVs
ZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggOGQ4NmQ5YTZhNjIyLi5jMGIyY2VjNWRjZDgg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQpAQCAtNjgzOCwxMiArNjgzOCwxNSBAQCBzdGF0aWMgdm9pZCB1ZnNo
Y2Rfd2JfcHJvYmUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTggKmRlc2NfYnVmKQ0KIAloYmEtPmNh
cHMgJj0gflVGU0hDRF9DQVBfV0JfRU47DQogfQ0KIA0KLXN0YXRpYyB2b2lkIHVmc2hjZF9maXh1
cF9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQordm9pZCB1ZnNoY2RfZml4dXBfZGV2
X3F1aXJrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QgdWZzX2Rldl9maXggKmZpeHVwcykN
CiB7DQogCXN0cnVjdCB1ZnNfZGV2X2ZpeCAqZjsNCiAJc3RydWN0IHVmc19kZXZfaW5mbyAqZGV2
X2luZm8gPSAmaGJhLT5kZXZfaW5mbzsNCiANCi0JZm9yIChmID0gdWZzX2ZpeHVwczsgZi0+cXVp
cms7IGYrKykgew0KKwlpZiAoIWZpeHVwcykNCisJCXJldHVybjsNCisNCisJZm9yIChmID0gZml4
dXBzOyBmLT5xdWlyazsgZisrKSB7DQogCQlpZiAoKGYtPndtYW51ZmFjdHVyZXJpZCA9PSBkZXZf
aW5mby0+d21hbnVmYWN0dXJlcmlkIHx8DQogCQkgICAgIGYtPndtYW51ZmFjdHVyZXJpZCA9PSBV
RlNfQU5ZX1ZFTkRPUikgJiYNCiAJCSAgICAgKChkZXZfaW5mby0+bW9kZWwgJiYNCkBAIC02ODUy
LDExICs2ODU1LDEyIEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9maXh1cF9kZXZfcXVpcmtzKHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQogCQkJaGJhLT5kZXZfcXVpcmtzIHw9IGYtPnF1aXJrOw0KIAl9DQog
fQ0KK0VYUE9SVF9TWU1CT0xfR1BMKHVmc2hjZF9maXh1cF9kZXZfcXVpcmtzKTsNCiANCiBzdGF0
aWMgdm9pZCB1ZnNfZml4dXBfZGV2aWNlX3NldHVwKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0K
IAkvKiBmaXggYnkgZ2VuZXJhbCBxdWlyayB0YWJsZSAqLw0KLQl1ZnNoY2RfZml4dXBfZGV2X3F1
aXJrcyhoYmEpOw0KKwl1ZnNoY2RfZml4dXBfZGV2X3F1aXJrcyhoYmEsIHVmc19maXh1cHMpOw0K
IA0KIAkvKiBhbGxvdyB2ZW5kb3JzIHRvIGZpeCBxdWlya3MgKi8NCiAJdWZzaGNkX3ZvcHNfZml4
dXBfZGV2X3F1aXJrcyhoYmEpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQppbmRleCA4OTczMzhiYTY3YWEuLjRkMjk2
YWNhZGQ2ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCisrKyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCkBAIC05NTIsNiArOTUyLDcgQEAgaW50IHVmc2hjZF9x
dWVyeV9mbGFnKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gcXVlcnlfb3Bjb2RlIG9wY29kZSwN
CiANCiB2b2lkIHVmc2hjZF9hdXRvX2hpYmVybjhfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEp
Ow0KIHZvaWQgdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUoc3RydWN0IHVmc19oYmEgKmhiYSwg
dTMyIGFoaXQpOw0KK3ZvaWQgdWZzaGNkX2ZpeHVwX2Rldl9xdWlya3Moc3RydWN0IHVmc19oYmEg
KmhiYSwgc3RydWN0IHVmc19kZXZfZml4ICpmaXh1cHMpOw0KICNkZWZpbmUgU0RfQVNDSUlfU1RE
IHRydWUNCiAjZGVmaW5lIFNEX1JBVyBmYWxzZQ0KIGludCB1ZnNoY2RfcmVhZF9zdHJpbmdfZGVz
YyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1OCBkZXNjX2luZGV4LA0KLS0gDQoyLjE4LjANCg==

