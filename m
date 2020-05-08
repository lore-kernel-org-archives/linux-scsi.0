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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087C2C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB7DF206B8
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:01:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jG06Ubx1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgEHIBv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:01:51 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:40573 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726974AbgEHIBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:01:25 -0400
X-UUID: 04acfb5e13e2489b90f1a8beafcf019b-20200508
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=vEN1vovOBm7CE8IUBRV0WJtnR6QWXPmyg5EWPiTMLuA=;
        b=jG06Ubx1DgVLKlbiLoSA/7CQz9KBRlCA3baPx9szcJq5XP4Ks6joKAlCcFnk85lEVDhR+CO6zl1sv7YNYf1qCdmiGqIyZW9ZiToZJzlKw69C9TB3StpOxTduWshCUbsIAbW13toIZpcgiv3jRtjHvXWEZzzRWs8RhR98TNfotRI=;
X-UUID: 04acfb5e13e2489b90f1a8beafcf019b-20200508
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1949148095; Fri, 08 May 2020 16:01:19 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 8 May 2020 16:01:17 +0800
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
Subject: [PATCH v8 2/8] scsi: ufs: introduce fixup_dev_quirks vops
Date:   Fri, 8 May 2020 16:01:09 +0800
Message-ID: <20200508080115.24233-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200508080115.24233-1-stanley.chu@mediatek.com>
References: <20200508080115.24233-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U29tZSBVRlMgZGVpdmNlcyBtYXkgaGF2ZSByZXF1aXJlZCBkZXZpY2UgcXVpcmtzIG9yIGhhdmUg
bm9uLXN0YW5kYXJkDQpmZWF0dXJlcyB3aGljaCBhcmUgZW5hYmxlZCBvbmx5IG9uIHNwZWNpZmll
ZCBVRlMgaG9zdHMgb3IgZm9yIHNwZWNpYWwNCmN1c3RvbWVycy4NCg0KVG8gbm90ICJwb2xsdXRl
IiBjb21tb24gZGV2aWNlIHF1aXJrIGxpc3QsIGkuZS4sIHVmc19maXh1cHMgdGFibGUgZm9yDQp0
aG9zZSBkZXZpY2VzIG1lbnRpb25lZCBhYm92ZSwgaW50cm9kdWNlICJmaXh1cF9kZXZfcXVpcmtz
IiB2b3BzIHRvDQphbGxvdyB2ZW5kb3JzIHRvIGZpeCBvciBtb2RpZnkgZGV2aWNlIHF1aXJrcyBh
Y2NvcmRpbmdseS4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1l
ZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNv
bT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAxMSArKysrKysrKysrLQ0KIGRy
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCAgOSArKysrKysrKy0NCiAyIGZpbGVzIGNoYW5nZWQs
IDE4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggYTgw
MmM1ZjVlYzdjLi44ZDg2ZDlhNmE2MjIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtNjgzOCw3ICs2ODM4
LDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4
ICpkZXNjX2J1ZikNCiAJaGJhLT5jYXBzICY9IH5VRlNIQ0RfQ0FQX1dCX0VOOw0KIH0NCiANCi1z
dGF0aWMgdm9pZCB1ZnNfZml4dXBfZGV2aWNlX3NldHVwKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQor
c3RhdGljIHZvaWQgdWZzaGNkX2ZpeHVwX2Rldl9xdWlya3Moc3RydWN0IHVmc19oYmEgKmhiYSkN
CiB7DQogCXN0cnVjdCB1ZnNfZGV2X2ZpeCAqZjsNCiAJc3RydWN0IHVmc19kZXZfaW5mbyAqZGV2
X2luZm8gPSAmaGJhLT5kZXZfaW5mbzsNCkBAIC02ODUzLDYgKzY4NTMsMTUgQEAgc3RhdGljIHZv
aWQgdWZzX2ZpeHVwX2RldmljZV9zZXR1cChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAl9DQogfQ0K
IA0KK3N0YXRpYyB2b2lkIHVmc19maXh1cF9kZXZpY2Vfc2V0dXAoc3RydWN0IHVmc19oYmEgKmhi
YSkNCit7DQorCS8qIGZpeCBieSBnZW5lcmFsIHF1aXJrIHRhYmxlICovDQorCXVmc2hjZF9maXh1
cF9kZXZfcXVpcmtzKGhiYSk7DQorDQorCS8qIGFsbG93IHZlbmRvcnMgdG8gZml4IHF1aXJrcyAq
Lw0KKwl1ZnNoY2Rfdm9wc19maXh1cF9kZXZfcXVpcmtzKGhiYSk7DQorfQ0KKw0KIHN0YXRpYyBp
bnQgdWZzX2dldF9kZXZpY2VfZGVzYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJaW50IGVy
cjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuaA0KaW5kZXggMDU2NTM3ZTUyYzE5Li44OTczMzhiYTY3YWEgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5oDQpAQCAtNjksNiArNjksNyBAQA0KICNpbmNsdWRlIDxzY3NpL3Njc2lfZWguaD4NCiAN
CiAjaW5jbHVkZSAidWZzLmgiDQorI2luY2x1ZGUgInVmc19xdWlya3MuaCINCiAjaW5jbHVkZSAi
dWZzaGNpLmgiDQogDQogI2RlZmluZSBVRlNIQ0QgInVmc2hjZCINCkBAIC0zMzYsNiArMzM3LDcg
QEAgc3RydWN0IHVmc19oYmFfdmFyaWFudF9vcHMgew0KIAl2b2lkICAgICgqaGliZXJuOF9ub3Rp
ZnkpKHN0cnVjdCB1ZnNfaGJhICosIGVudW0gdWljX2NtZF9kbWUsDQogCQkJCQllbnVtIHVmc19u
b3RpZnlfY2hhbmdlX3N0YXR1cyk7DQogCWludAkoKmFwcGx5X2Rldl9xdWlya3MpKHN0cnVjdCB1
ZnNfaGJhICpoYmEpOw0KKwl2b2lkCSgqZml4dXBfZGV2X3F1aXJrcykoc3RydWN0IHVmc19oYmEg
KmhiYSk7DQogCWludCAgICAgKCpzdXNwZW5kKShzdHJ1Y3QgdWZzX2hiYSAqLCBlbnVtIHVmc19w
bV9vcCk7DQogCWludCAgICAgKCpyZXN1bWUpKHN0cnVjdCB1ZnNfaGJhICosIGVudW0gdWZzX3Bt
X29wKTsNCiAJdm9pZAkoKmRiZ19yZWdpc3Rlcl9kdW1wKShzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsN
CkBAIC05NTAsNyArOTUyLDYgQEAgaW50IHVmc2hjZF9xdWVyeV9mbGFnKHN0cnVjdCB1ZnNfaGJh
ICpoYmEsIGVudW0gcXVlcnlfb3Bjb2RlIG9wY29kZSwNCiANCiB2b2lkIHVmc2hjZF9hdXRvX2hp
YmVybjhfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KIHZvaWQgdWZzaGNkX2F1dG9faGli
ZXJuOF91cGRhdGUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTMyIGFoaXQpOw0KLQ0KICNkZWZpbmUg
U0RfQVNDSUlfU1REIHRydWUNCiAjZGVmaW5lIFNEX1JBVyBmYWxzZQ0KIGludCB1ZnNoY2RfcmVh
ZF9zdHJpbmdfZGVzYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1OCBkZXNjX2luZGV4LA0KQEAgLTEw
ODUsNiArMTA4NiwxMiBAQCBzdGF0aWMgaW5saW5lIGludCB1ZnNoY2Rfdm9wc19hcHBseV9kZXZf
cXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCXJldHVybiAwOw0KIH0NCiANCitzdGF0aWMg
aW5saW5lIHZvaWQgdWZzaGNkX3ZvcHNfZml4dXBfZGV2X3F1aXJrcyhzdHJ1Y3QgdWZzX2hiYSAq
aGJhKQ0KK3sNCisJaWYgKGhiYS0+dm9wcyAmJiBoYmEtPnZvcHMtPmZpeHVwX2Rldl9xdWlya3Mp
DQorCQloYmEtPnZvcHMtPmZpeHVwX2Rldl9xdWlya3MoaGJhKTsNCit9DQorDQogc3RhdGljIGlu
bGluZSBpbnQgdWZzaGNkX3ZvcHNfc3VzcGVuZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBlbnVtIHVm
c19wbV9vcCBvcCkNCiB7DQogCWlmIChoYmEtPnZvcHMgJiYgaGJhLT52b3BzLT5zdXNwZW5kKQ0K
LS0gDQoyLjE4LjANCg==

