Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA66C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 02:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7474620DD4
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 02:51:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="sntOimsZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbgFXCv0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 22:51:26 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:41042 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388565AbgFXCvZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 22:51:25 -0400
X-UUID: bba5b1b4afc6470e9b672281e3b5b2e9-20200624
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=nmBWhNWVW28atJNu3hD30DB04FycNq3CbGhifj2PNUM=;
        b=sntOimsZs6Z8MWONa8lblO0kx5VZsgFe/sHozNiR/vvEgqEG8/m8oQCHlu65eVeKDf3mNFG4tQUUbY94IjW0oCLHlyvJnFfXxMh/T62oB0eHgUWeL0YDDPC/Kyu0IfM/wWVrUGfOgwt/x7oVt4iAQOwaP3gz7ZbD7EH7ZCRtOAM=;
X-UUID: bba5b1b4afc6470e9b672281e3b5b2e9-20200624
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1358642867; Wed, 24 Jun 2020 10:51:22 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 24 Jun 2020 10:51:19 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 24 Jun 2020 10:51:19 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1] scsi: ufs: Disable WriteBooster capability in non-supported UFS device
Date:   Wed, 24 Jun 2020 10:51:19 +0800
Message-ID: <20200624025119.6509-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 7B2E197A1814C3A1321B9BF57C653697187545A33AF642CD635F385EF2542AB02000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SWYgVUZTIGRldmljZSBpcyBub3QgcXVhbGlmaWVkIHRvIGVudGVyIHRoZSBkZXRlY3Rpb24gb2Yg
V3JpdGVCb29zdGVyDQpwcm9iaW5nIGJ5IGRpc2FsbG93ZWQgVUZTIHZlcnNpb24gb3IgZGV2aWNl
IHF1aXJrcywgdGhlbiBXcml0ZUJvb3N0ZXINCmNhcGFiaWxpdHkgaW4gaG9zdCBzaGFsbCBiZSBk
aXNhYmxlZCB0byBwcmV2ZW50IGFueSBXcml0ZUJvb3N0ZXINCm9wZXJhdGlvbnMgaW4gdGhlIGZ1
dHVyZS4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVr
LmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAzNSArKysrKysrKysrKysr
KysrKysrLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCsp
LCAxNiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBmMTczYWQxYmQ3OWYuLmM2MmJk
NDdiZWVhYSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC02ODQ3LDIxICs2ODQ3LDMxIEBAIHN0YXRpYyBp
bnQgdWZzaGNkX3Njc2lfYWRkX3dsdXMoc3RydWN0IHVmc19oYmEgKmhiYSkNCiANCiBzdGF0aWMg
dm9pZCB1ZnNoY2Rfd2JfcHJvYmUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTggKmRlc2NfYnVmKQ0K
IHsNCisJc3RydWN0IHVmc19kZXZfaW5mbyAqZGV2X2luZm8gPSAmaGJhLT5kZXZfaW5mbzsNCiAJ
dTggbHVuOw0KIAl1MzIgZF9sdV93Yl9idWZfYWxsb2M7DQogDQogCWlmICghdWZzaGNkX2lzX3di
X2FsbG93ZWQoaGJhKSkNCiAJCXJldHVybjsNCisJLyoNCisJICogUHJvYmUgV0Igb25seSBmb3Ig
VUZTLTIuMiBhbmQgVUZTLTMuMSAoYW5kIGxhdGVyKSBkZXZpY2VzIG9yDQorCSAqIFVGUyBkZXZp
Y2VzIHdpdGggcXVpcmsgVUZTX0RFVklDRV9RVUlSS19TVVBQT1JUX0VYVEVOREVEX0ZFQVRVUkVT
DQorCSAqIGVuYWJsZWQNCisJICovDQorCWlmICghKGRldl9pbmZvLT53c3BlY3ZlcnNpb24gPj0g
MHgzMTAgfHwNCisJICAgICAgZGV2X2luZm8tPndzcGVjdmVyc2lvbiA9PSAweDIyMCB8fA0KKwkg
ICAgIChoYmEtPmRldl9xdWlya3MgJiBVRlNfREVWSUNFX1FVSVJLX1NVUFBPUlRfRVhURU5ERURf
RkVBVFVSRVMpKSkNCisJCWdvdG8gd2JfZGlzYWJsZWQ7DQogDQogCWlmIChoYmEtPmRlc2Nfc2l6
ZVtRVUVSWV9ERVNDX0lETl9ERVZJQ0VdIDwNCiAJICAgIERFVklDRV9ERVNDX1BBUkFNX0VYVF9V
RlNfRkVBVFVSRV9TVVAgKyA0KQ0KIAkJZ290byB3Yl9kaXNhYmxlZDsNCiANCi0JaGJhLT5kZXZf
aW5mby5kX2V4dF91ZnNfZmVhdHVyZV9zdXAgPQ0KKwlkZXZfaW5mby0+ZF9leHRfdWZzX2ZlYXR1
cmVfc3VwID0NCiAJCWdldF91bmFsaWduZWRfYmUzMihkZXNjX2J1ZiArDQogCQkJCSAgIERFVklD
RV9ERVNDX1BBUkFNX0VYVF9VRlNfRkVBVFVSRV9TVVApOw0KIA0KLQlpZiAoIShoYmEtPmRldl9p
bmZvLmRfZXh0X3Vmc19mZWF0dXJlX3N1cCAmIFVGU19ERVZfV1JJVEVfQk9PU1RFUl9TVVApKQ0K
KwlpZiAoIShkZXZfaW5mby0+ZF9leHRfdWZzX2ZlYXR1cmVfc3VwICYgVUZTX0RFVl9XUklURV9C
T09TVEVSX1NVUCkpDQogCQlnb3RvIHdiX2Rpc2FibGVkOw0KIA0KIAkvKg0KQEAgLTY4NzAsMTcg
KzY4ODAsMTcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpo
YmEsIHU4ICpkZXNjX2J1ZikNCiAJICogYSBtYXggb2YgMSBsdW4gd291bGQgaGF2ZSB3YiBidWZm
ZXIgY29uZmlndXJlZC4NCiAJICogTm93IG9ubHkgc2hhcmVkIGJ1ZmZlciBtb2RlIGlzIHN1cHBv
cnRlZC4NCiAJICovDQotCWhiYS0+ZGV2X2luZm8uYl93Yl9idWZmZXJfdHlwZSA9DQorCWRldl9p
bmZvLT5iX3diX2J1ZmZlcl90eXBlID0NCiAJCWRlc2NfYnVmW0RFVklDRV9ERVNDX1BBUkFNX1dC
X1RZUEVdOw0KIA0KLQloYmEtPmRldl9pbmZvLmJfcHJlc3J2X3VzcGNfZW4gPQ0KKwlkZXZfaW5m
by0+Yl9wcmVzcnZfdXNwY19lbiA9DQogCQlkZXNjX2J1ZltERVZJQ0VfREVTQ19QQVJBTV9XQl9Q
UkVTUlZfVVNSU1BDX0VOXTsNCiANCi0JaWYgKGhiYS0+ZGV2X2luZm8uYl93Yl9idWZmZXJfdHlw
ZSA9PSBXQl9CVUZfTU9ERV9TSEFSRUQpIHsNCi0JCWhiYS0+ZGV2X2luZm8uZF93Yl9hbGxvY191
bml0cyA9DQorCWlmIChkZXZfaW5mby0+Yl93Yl9idWZmZXJfdHlwZSA9PSBXQl9CVUZfTU9ERV9T
SEFSRUQpIHsNCisJCWRldl9pbmZvLT5kX3diX2FsbG9jX3VuaXRzID0NCiAJCWdldF91bmFsaWdu
ZWRfYmUzMihkZXNjX2J1ZiArDQogCQkJCSAgIERFVklDRV9ERVNDX1BBUkFNX1dCX1NIQVJFRF9B
TExPQ19VTklUUyk7DQotCQlpZiAoIWhiYS0+ZGV2X2luZm8uZF93Yl9hbGxvY191bml0cykNCisJ
CWlmICghZGV2X2luZm8tPmRfd2JfYWxsb2NfdW5pdHMpDQogCQkJZ290byB3Yl9kaXNhYmxlZDsN
CiAJfSBlbHNlIHsNCiAJCWZvciAobHVuID0gMDsgbHVuIDwgVUZTX1VQSVVfTUFYX1dCX0xVTl9J
RDsgbHVuKyspIHsNCkBAIC02ODkxLDcgKzY5MDEsNyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2Rfd2Jf
cHJvYmUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTggKmRlc2NfYnVmKQ0KIAkJCQkJKHU4ICopJmRf
bHVfd2JfYnVmX2FsbG9jLA0KIAkJCQkJc2l6ZW9mKGRfbHVfd2JfYnVmX2FsbG9jKSk7DQogCQkJ
aWYgKGRfbHVfd2JfYnVmX2FsbG9jKSB7DQotCQkJCWhiYS0+ZGV2X2luZm8ud2JfZGVkaWNhdGVk
X2x1ID0gbHVuOw0KKwkJCQlkZXZfaW5mby0+d2JfZGVkaWNhdGVkX2x1ID0gbHVuOw0KIAkJCQli
cmVhazsNCiAJCQl9DQogCQl9DQpAQCAtNjk3NywxNCArNjk4Nyw3IEBAIHN0YXRpYyBpbnQgdWZz
X2dldF9kZXZpY2VfZGVzYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIA0KIAl1ZnNfZml4dXBfZGV2
aWNlX3NldHVwKGhiYSk7DQogDQotCS8qDQotCSAqIFByb2JlIFdCIG9ubHkgZm9yIFVGUy0zLjEg
ZGV2aWNlcyBvciBVRlMgZGV2aWNlcyB3aXRoIHF1aXJrDQotCSAqIFVGU19ERVZJQ0VfUVVJUktf
U1VQUE9SVF9FWFRFTkRFRF9GRUFUVVJFUyBlbmFibGVkDQotCSAqLw0KLQlpZiAoZGV2X2luZm8t
PndzcGVjdmVyc2lvbiA+PSAweDMxMCB8fA0KLQkgICAgZGV2X2luZm8tPndzcGVjdmVyc2lvbiA9
PSAweDIyMCB8fA0KLQkgICAgKGhiYS0+ZGV2X3F1aXJrcyAmIFVGU19ERVZJQ0VfUVVJUktfU1VQ
UE9SVF9FWFRFTkRFRF9GRUFUVVJFUykpDQotCQl1ZnNoY2Rfd2JfcHJvYmUoaGJhLCBkZXNjX2J1
Zik7DQorCXVmc2hjZF93Yl9wcm9iZShoYmEsIGRlc2NfYnVmKTsNCiANCiAJLyoNCiAJICogdWZz
aGNkX3JlYWRfc3RyaW5nX2Rlc2MgcmV0dXJucyBzaXplIG9mIHRoZSBzdHJpbmcNCi0tIA0KMi4x
OC4wDQo=

