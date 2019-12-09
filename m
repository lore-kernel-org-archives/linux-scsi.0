Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFDEC43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 08:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B21402071E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 08:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JJ+JXQZh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfLII3Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 03:29:25 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:26427 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727044AbfLII3Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 03:29:25 -0500
X-UUID: ac42b9fa683e41efaf49f0db4b7012f4-20191209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=FsOPpGNcvyN3hqCpKWKad5Cxcn0GwUWSQI3FseIG2Rg=;
        b=JJ+JXQZhVK2zvQGAqUuXloTBIHvnoLksjCyLgRgouq0Uif5uTIfVV9NwyVSv4mjvLPGrrEvtygZHfCvrr1o3b1B8KnuFICqOSMO/RJLPZqXx7tUrgKgKuBEdWKHGQx8oVTmvfvvmm+wS/IvlUtRWYGO3a3Skhut3fq80GaFBnAI=;
X-UUID: ac42b9fa683e41efaf49f0db4b7012f4-20191209
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2035563348; Mon, 09 Dec 2019 16:29:17 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 9 Dec 2019 16:28:55 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 9 Dec 2019 16:29:01 +0800
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
Subject: [PATCH v2 2/2] scsi: ufs-mediatek: add device reset implementation
Date:   Mon, 9 Dec 2019 16:29:14 +0800
Message-ID: <1575880154-6099-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1575880154-6099-1-git-send-email-stanley.chu@mediatek.com>
References: <1575880154-6099-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGRldmljZSByZXNldCB2b3BzIGltcGxlbWVudGF0aW9uIGluIE1lZGlhVGVrIFVGUyBkcml2
ZXIuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5j
b20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMjcgKysrKysrKysr
KysrKysrKysrKysrKysrKysrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCB8ICA3
ICsrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5jDQppbmRleCA4M2UyOGVkYzNhYzUuLjZhM2VjMTFiMTZkYiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC02LDEwICs2LDEyIEBADQogICoJUGV0ZXIgV2FuZyA8cGV0
ZXIud2FuZ0BtZWRpYXRlay5jb20+DQogICovDQogDQorI2luY2x1ZGUgPGxpbnV4L2FybS1zbWNj
Yy5oPg0KICNpbmNsdWRlIDxsaW51eC9vZi5oPg0KICNpbmNsdWRlIDxsaW51eC9vZl9hZGRyZXNz
Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3BoeS9waHkuaD4NCiAjaW5jbHVkZSA8bGludXgvcGxhdGZv
cm1fZGV2aWNlLmg+DQorI2luY2x1ZGUgPGxpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5o
Pg0KIA0KICNpbmNsdWRlICJ1ZnNoY2QuaCINCiAjaW5jbHVkZSAidWZzaGNkLXBsdGZybS5oIg0K
QEAgLTI2OSw2ICsyNzEsMzAgQEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc3RhcnR1cF9ub3Rp
Znkoc3RydWN0IHVmc19oYmEgKmhiYSwNCiAJcmV0dXJuIHJldDsNCiB9DQogDQorc3RhdGljIHZv
aWQgdWZzX210a19kZXZpY2VfcmVzZXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCit7DQorCXN0cnVj
dCBhcm1fc21jY2NfcmVzIHJlczsNCisNCisJYXJtX3NtY2NjX3NtYyhNVEtfU0lQX1VGU19DT05U
Uk9MLCBVRlNfTVRLX1NJUF9ERVZJQ0VfUkVTRVQsDQorCQkgICAgICAwLCAwLCAwLCAwLCAwLCAw
LCAmcmVzKTsNCisJLyoNCisJICogVGhlIHJlc2V0IHNpZ25hbCBpcyBhY3RpdmUgbG93LiBVRlMg
ZGV2aWNlcyBzaGFsbCBkZXRlY3QNCisJICogbW9yZSB0aGFuIG9yIGVxdWFsIHRvIDF1cyBvZiBw
b3NpdGl2ZSBvciBuZWdhdGl2ZSBSU1Rfbg0KKwkgKiBwdWxzZSB3aWR0aC4NCisJICoNCisJICog
VG8gYmUgb24gc2FmZSBzaWRlLCBrZWVwIHRoZSByZXNldCBsb3cgZm9yIGF0IGxlYXN0IDEwdXMu
DQorCSAqLw0KKwl1c2xlZXBfcmFuZ2UoMTAsIDE1KTsNCisNCisJYXJtX3NtY2NjX3NtYyhNVEtf
U0lQX1VGU19DT05UUk9MLCBVRlNfTVRLX1NJUF9ERVZJQ0VfUkVTRVQsDQorCQkgICAgICAxLCAw
LCAwLCAwLCAwLCAwLCAmcmVzKTsNCisNCisJLyogU29tZSBkZXZpY2VzIG1heSBuZWVkIHRpbWUg
dG8gcmVzcG9uZCB0byByc3RfbiAqLw0KKwl1c2xlZXBfcmFuZ2UoMTAwMDAsIDE1MDAwKTsNCisN
CisJZGV2X2luZm8oaGJhLT5kZXYsICJkZXZpY2UgcmVzZXQgZG9uZVxuIik7DQorfQ0KKw0KIHN0
YXRpYyBpbnQgdWZzX210a19zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3Bt
X29wIHBtX29wKQ0KIHsNCiAJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRf
dmFyaWFudChoYmEpOw0KQEAgLTMwMyw2ICszMjksNyBAQCBzdGF0aWMgc3RydWN0IHVmc19oYmFf
dmFyaWFudF9vcHMgdWZzX2hiYV9tdGtfdm9wcyA9IHsNCiAJLnB3cl9jaGFuZ2Vfbm90aWZ5ICAg
PSB1ZnNfbXRrX3B3cl9jaGFuZ2Vfbm90aWZ5LA0KIAkuc3VzcGVuZCAgICAgICAgICAgICA9IHVm
c19tdGtfc3VzcGVuZCwNCiAJLnJlc3VtZSAgICAgICAgICAgICAgPSB1ZnNfbXRrX3Jlc3VtZSwN
CisJLmRldmljZV9yZXNldCAgICAgICAgPSB1ZnNfbXRrX2RldmljZV9yZXNldCwNCiB9Ow0KIA0K
IC8qKg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQppbmRleCAxOWY4YzQyZmUwNmYuLmIwM2Y2MDFk
M2E5ZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCisrKyBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCkBAIC02LDYgKzYsOCBAQA0KICNpZm5k
ZWYgX1VGU19NRURJQVRFS19IDQogI2RlZmluZSBfVUZTX01FRElBVEVLX0gNCiANCisjaW5jbHVk
ZSA8bGludXgvYml0b3BzLmg+DQorDQogLyoNCiAgKiBWZW5kb3Igc3BlY2lmaWMgcHJlLWRlZmlu
ZWQgcGFyYW1ldGVycw0KICAqLw0KQEAgLTI5LDYgKzMxLDExIEBADQogI2RlZmluZSBWU19TQVZF
UE9XRVJDT05UUk9MICAgICAgICAgMHhEMEE2DQogI2RlZmluZSBWU19VTklQUk9QT1dFUkRPV05D
T05UUk9MICAgMHhEMEE4DQogDQorLyoNCisgKiBTaVAgY29tbWFuZHMNCisgKi8NCisjZGVmaW5l
IFVGU19NVEtfU0lQX0RFVklDRV9SRVNFVCAgICBCSVQoMSkNCisNCiAvKg0KICAqIFZTX0RFQlVH
Q0xPQ0tFTkFCTEUNCiAgKi8NCi0tIA0KMi4xOC4wDQo=

