Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9ABBC3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFEEC206D9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XV+e2blE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgEDO4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:56:40 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:10830 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729055AbgEDO4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:56:38 -0400
X-UUID: 319e47e61493433096617aa3175af16b-20200504
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=zpFKB2Uc7jEMy8WtM/sFkIT9+qoLxQ1hm5JaUjzoW8Q=;
        b=XV+e2blEPEvB8SGE0AK2bGz6YQdZrhdCdIFISV6V8jTR4mCrzwY3CO+UV6h896EI1jCyqJukcXsEdEs7FVVGwo+6kTweRxOyvX1r1N4jQlCLtXcKpquEcgJ2kNHfnp9KEia6a9+3YF2lz4Vccrw3LWiOQ6mQfMwvZevab4hbQBY=;
X-UUID: 319e47e61493433096617aa3175af16b-20200504
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 691611578; Mon, 04 May 2020 22:56:31 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 4 May 2020 22:56:27 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 4 May 2020 22:56:26 +0800
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
Subject: [PATCH v6 4/8] scsi: ufs-mediatek: add fixup_dev_quirks vops
Date:   Mon, 4 May 2020 22:56:18 +0800
Message-ID: <20200504145622.13895-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200504145622.13895-1-stanley.chu@mediatek.com>
References: <20200504145622.13895-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
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
cy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggNjczYzE2NTk2ZmIyLi5jZTdiYTUyOWU2MTMgMTAwNjQ0
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
DQorCXVmc2hjZF9maXh1cF9kZXZpY2Vfc2V0dXAoaGJhLCB1ZnNfbXRrX2Rldl9maXh1cHMpOw0K
Kw0KKwlpZiAobWlkID09IFVGU19WRU5ET1JfU0FNU1VORykNCisJCWhiYS0+ZGV2X3F1aXJrcyAm
PSB+VUZTX0RFVklDRV9RVUlSS19IT1NUX1BBX1RBQ1RJVkFURTsNCit9DQorDQogLyoqDQogICog
c3RydWN0IHVmc19oYmFfbXRrX3ZvcHMgLSBVRlMgTVRLIHNwZWNpZmljIHZhcmlhbnQgb3BlcmF0
aW9ucw0KICAqDQpAQCAtNTg5LDYgKzYwNCw3IEBAIHN0YXRpYyBzdHJ1Y3QgdWZzX2hiYV92YXJp
YW50X29wcyB1ZnNfaGJhX210a192b3BzID0gew0KIAkubGlua19zdGFydHVwX25vdGlmeSA9IHVm
c19tdGtfbGlua19zdGFydHVwX25vdGlmeSwNCiAJLnB3cl9jaGFuZ2Vfbm90aWZ5ICAgPSB1ZnNf
bXRrX3B3cl9jaGFuZ2Vfbm90aWZ5LA0KIAkuYXBwbHlfZGV2X3F1aXJrcyAgICA9IHVmc19tdGtf
YXBwbHlfZGV2X3F1aXJrcywNCisJLmZpeHVwX2Rldl9xdWlya3MgICAgPSB1ZnNfbXRrX2ZpeHVw
X2Rldl9xdWlya3MsDQogCS5zdXNwZW5kICAgICAgICAgICAgID0gdWZzX210a19zdXNwZW5kLA0K
IAkucmVzdW1lICAgICAgICAgICAgICA9IHVmc19tdGtfcmVzdW1lLA0KIAkuZGJnX3JlZ2lzdGVy
X2R1bXAgICA9IHVmc19tdGtfZGJnX3JlZ2lzdGVyX2R1bXAsDQotLSANCjIuMTguMA0K

