Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED054C47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBACC20CC7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Vm9xp1Gj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgEHCVy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:21:54 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:11211 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727030AbgEHCVx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:21:53 -0400
X-UUID: 728fadcf0b0b46718b07019e2d786935-20200508
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=zX9LXOY/O270hUPX2+GL3UKkBmewuNRKxd0VGBvTLxQ=;
        b=Vm9xp1GjBhjDi07XYe6cw+Uh/S+5P7c2KsRg+w/A9eY7WBB5IRTSkn1A4YhyzR954w7fxNOQNS/X7IYAqeP8xyFhWRtQ/fQMGIUn7SZ9PCsUy+XJc2h81mNi9NEVgbP4hPTbyPi2/l61Cmjwz7FpkV/qehOFdgj/AQZwqRG2Ijg=;
X-UUID: 728fadcf0b0b46718b07019e2d786935-20200508
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1588600704; Fri, 08 May 2020 10:21:49 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 8 May 2020 10:21:41 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 10:21:42 +0800
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
Subject: [PATCH v7 4/8] scsi: ufs-mediatek: add fixup_dev_quirks vops
Date:   Fri, 8 May 2020 10:21:37 +0800
Message-ID: <20200508022141.10783-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200508022141.10783-1-stanley.chu@mediatek.com>
References: <20200508022141.10783-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 543113DA99EBE97E4204572D429B3314DD54CD3592D334F077A5E5D085514FE02000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGZpeHVwX2Rldl9xdWlyayB2b3BzIGluIE1lZGlhVGVrIFVGUyBwbGF0Zm9ybXMgYW5kIHBy
b3ZpZGUNCmFuIGluaXRpYWwgdmVuZG9yLXNwZWNpZmljIGRldmljZSBxdWlyayB0YWJsZS4NCg0K
U2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJl
dmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCi0tLQ0KIGRyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAyMiArKysrKysrKysrKysrKysrKysrLS0tDQog
MSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggNjczYzE2NTk2ZmIyLi4xODk4ZjEyNjlhYzUgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQorKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAtMzAsNiArMzAsMTIgQEANCiAjZGVmaW5lIHVmc19t
dGtfZGV2aWNlX3Jlc2V0X2N0cmwoaGlnaCwgcmVzKSBcDQogCXVmc19tdGtfc21jKFVGU19NVEtf
U0lQX0RFVklDRV9SRVNFVCwgaGlnaCwgcmVzKQ0KIA0KK3N0YXRpYyBzdHJ1Y3QgdWZzX2Rldl9m
aXggdWZzX210a19kZXZfZml4dXBzW10gPSB7DQorCVVGU19GSVgoVUZTX1ZFTkRPUl9TS0hZTklY
LCAiSDlIUTIxQUZBTVpEQVIiLA0KKwkJVUZTX0RFVklDRV9RVUlSS19TVVBQT1JUX0VYVEVOREVE
X0ZFQVRVUkVTKSwNCisJRU5EX0ZJWA0KK307DQorDQogc3RhdGljIHZvaWQgdWZzX210a19jZmdf
dW5pcHJvX2NnKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgZW5hYmxlKQ0KIHsNCiAJdTMyIHRt
cDsNCkBAIC01NTUsMTAgKzU2MSw4IEBAIHN0YXRpYyBpbnQgdWZzX210a19hcHBseV9kZXZfcXVp
cmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCXN0cnVjdCB1ZnNfZGV2X2luZm8gKmRldl9pbmZv
ID0gJmhiYS0+ZGV2X2luZm87DQogCXUxNiBtaWQgPSBkZXZfaW5mby0+d21hbnVmYWN0dXJlcmlk
Ow0KIA0KLQlpZiAobWlkID09IFVGU19WRU5ET1JfU0FNU1VORykgew0KLQkJaGJhLT5kZXZfcXVp
cmtzICY9IH5VRlNfREVWSUNFX1FVSVJLX0hPU1RfUEFfVEFDVElWQVRFOw0KKwlpZiAobWlkID09
IFVGU19WRU5ET1JfU0FNU1VORykNCiAJCXVmc2hjZF9kbWVfc2V0KGhiYSwgVUlDX0FSR19NSUIo
UEFfVEFDVElWQVRFKSwgNik7DQotCX0NCiANCiAJLyoNCiAJICogRGVjaWRlIHdhaXRpbmcgdGlt
ZSBiZWZvcmUgZ2F0aW5nIHJlZmVyZW5jZSBjbG9jayBhbmQNCkBAIC01NzUsNiArNTc5LDE3IEBA
IHN0YXRpYyBpbnQgdWZzX210a19hcHBseV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEp
DQogCXJldHVybiAwOw0KIH0NCiANCit2b2lkIHVmc19tdGtfZml4dXBfZGV2X3F1aXJrcyhzdHJ1
Y3QgdWZzX2hiYSAqaGJhKQ0KK3sNCisJc3RydWN0IHVmc19kZXZfaW5mbyAqZGV2X2luZm8gPSAm
aGJhLT5kZXZfaW5mbzsNCisJdTE2IG1pZCA9IGRldl9pbmZvLT53bWFudWZhY3R1cmVyaWQ7DQor
DQorCXVmc2hjZF9maXh1cF9kZXZfcXVpcmtzKGhiYSwgdWZzX210a19kZXZfZml4dXBzKTsNCisN
CisJaWYgKG1pZCA9PSBVRlNfVkVORE9SX1NBTVNVTkcpDQorCQloYmEtPmRldl9xdWlya3MgJj0g
flVGU19ERVZJQ0VfUVVJUktfSE9TVF9QQV9UQUNUSVZBVEU7DQorfQ0KKw0KIC8qKg0KICAqIHN0
cnVjdCB1ZnNfaGJhX210a192b3BzIC0gVUZTIE1USyBzcGVjaWZpYyB2YXJpYW50IG9wZXJhdGlv
bnMNCiAgKg0KQEAgLTU4OSw2ICs2MDQsNyBAQCBzdGF0aWMgc3RydWN0IHVmc19oYmFfdmFyaWFu
dF9vcHMgdWZzX2hiYV9tdGtfdm9wcyA9IHsNCiAJLmxpbmtfc3RhcnR1cF9ub3RpZnkgPSB1ZnNf
bXRrX2xpbmtfc3RhcnR1cF9ub3RpZnksDQogCS5wd3JfY2hhbmdlX25vdGlmeSAgID0gdWZzX210
a19wd3JfY2hhbmdlX25vdGlmeSwNCiAJLmFwcGx5X2Rldl9xdWlya3MgICAgPSB1ZnNfbXRrX2Fw
cGx5X2Rldl9xdWlya3MsDQorCS5maXh1cF9kZXZfcXVpcmtzICAgID0gdWZzX210a19maXh1cF9k
ZXZfcXVpcmtzLA0KIAkuc3VzcGVuZCAgICAgICAgICAgICA9IHVmc19tdGtfc3VzcGVuZCwNCiAJ
LnJlc3VtZSAgICAgICAgICAgICAgPSB1ZnNfbXRrX3Jlc3VtZSwNCiAJLmRiZ19yZWdpc3Rlcl9k
dW1wICAgPSB1ZnNfbXRrX2RiZ19yZWdpc3Rlcl9kdW1wLA0KLS0gDQoyLjE4LjANCg==

