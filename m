Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A085C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4005220716
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="l/ipJZ+7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfLTIgu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 03:36:50 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:31170 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727285AbfLTIgo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 03:36:44 -0500
X-UUID: 6349252e6b76407d81156a30e3c606c3-20191220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=l08SFBEtiS5XwcTagngkFHiv7bDYBCW7NMaM25KwiwI=;
        b=l/ipJZ+7YBS8CVylfnJretVa3f9B+6yvI82aE2+A2tEhMktoFNUWkv7MjZVm2dGMUxhLy1MGpGHPNierXHXPHRdHXDOIOFsmxSzIr2Jc7ZQEbAqyf1yXsFUsm2FP06A6o6dTsBziZ03n59xUsYTB2qj/nJJNKL+uHcV5Mwizi6E=;
X-UUID: 6349252e6b76407d81156a30e3c606c3-20191220
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1641469952; Fri, 20 Dec 2019 16:36:33 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 20 Dec 2019 16:36:12 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 20 Dec 2019 16:35:38 +0800
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
Subject: [PATCH v1 2/6] scsi: ufs-mediatek: add device reset implementation
Date:   Fri, 20 Dec 2019 16:36:24 +0800
Message-ID: <1576830988-22435-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
References: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
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
b20+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQotLS0N
CiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMjcgKysrKysrKysrKysrKysrKysr
KysrKysrKysrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCB8ICA3ICsrKysrKysN
CiAyIGZpbGVzIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jDQppbmRleCA4M2UyOGVkYzNhYzUuLjZhM2VjMTFiMTZkYiAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1l
ZGlhdGVrLmMNCkBAIC02LDEwICs2LDEyIEBADQogICoJUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0Bt
ZWRpYXRlay5jb20+DQogICovDQogDQorI2luY2x1ZGUgPGxpbnV4L2FybS1zbWNjYy5oPg0KICNp
bmNsdWRlIDxsaW51eC9vZi5oPg0KICNpbmNsdWRlIDxsaW51eC9vZl9hZGRyZXNzLmg+DQogI2lu
Y2x1ZGUgPGxpbnV4L3BoeS9waHkuaD4NCiAjaW5jbHVkZSA8bGludXgvcGxhdGZvcm1fZGV2aWNl
Lmg+DQorI2luY2x1ZGUgPGxpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oPg0KIA0KICNp
bmNsdWRlICJ1ZnNoY2QuaCINCiAjaW5jbHVkZSAidWZzaGNkLXBsdGZybS5oIg0KQEAgLTI2OSw2
ICsyNzEsMzAgQEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc3RhcnR1cF9ub3RpZnkoc3RydWN0
IHVmc19oYmEgKmhiYSwNCiAJcmV0dXJuIHJldDsNCiB9DQogDQorc3RhdGljIHZvaWQgdWZzX210
a19kZXZpY2VfcmVzZXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCit7DQorCXN0cnVjdCBhcm1fc21j
Y2NfcmVzIHJlczsNCisNCisJYXJtX3NtY2NjX3NtYyhNVEtfU0lQX1VGU19DT05UUk9MLCBVRlNf
TVRLX1NJUF9ERVZJQ0VfUkVTRVQsDQorCQkgICAgICAwLCAwLCAwLCAwLCAwLCAwLCAmcmVzKTsN
CisJLyoNCisJICogVGhlIHJlc2V0IHNpZ25hbCBpcyBhY3RpdmUgbG93LiBVRlMgZGV2aWNlcyBz
aGFsbCBkZXRlY3QNCisJICogbW9yZSB0aGFuIG9yIGVxdWFsIHRvIDF1cyBvZiBwb3NpdGl2ZSBv
ciBuZWdhdGl2ZSBSU1Rfbg0KKwkgKiBwdWxzZSB3aWR0aC4NCisJICoNCisJICogVG8gYmUgb24g
c2FmZSBzaWRlLCBrZWVwIHRoZSByZXNldCBsb3cgZm9yIGF0IGxlYXN0IDEwdXMuDQorCSAqLw0K
Kwl1c2xlZXBfcmFuZ2UoMTAsIDE1KTsNCisNCisJYXJtX3NtY2NjX3NtYyhNVEtfU0lQX1VGU19D
T05UUk9MLCBVRlNfTVRLX1NJUF9ERVZJQ0VfUkVTRVQsDQorCQkgICAgICAxLCAwLCAwLCAwLCAw
LCAwLCAmcmVzKTsNCisNCisJLyogU29tZSBkZXZpY2VzIG1heSBuZWVkIHRpbWUgdG8gcmVzcG9u
ZCB0byByc3RfbiAqLw0KKwl1c2xlZXBfcmFuZ2UoMTAwMDAsIDE1MDAwKTsNCisNCisJZGV2X2lu
Zm8oaGJhLT5kZXYsICJkZXZpY2UgcmVzZXQgZG9uZVxuIik7DQorfQ0KKw0KIHN0YXRpYyBpbnQg
dWZzX210a19zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29w
KQ0KIHsNCiAJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudCho
YmEpOw0KQEAgLTMwMyw2ICszMjksNyBAQCBzdGF0aWMgc3RydWN0IHVmc19oYmFfdmFyaWFudF9v
cHMgdWZzX2hiYV9tdGtfdm9wcyA9IHsNCiAJLnB3cl9jaGFuZ2Vfbm90aWZ5ICAgPSB1ZnNfbXRr
X3B3cl9jaGFuZ2Vfbm90aWZ5LA0KIAkuc3VzcGVuZCAgICAgICAgICAgICA9IHVmc19tdGtfc3Vz
cGVuZCwNCiAJLnJlc3VtZSAgICAgICAgICAgICAgPSB1ZnNfbXRrX3Jlc3VtZSwNCisJLmRldmlj
ZV9yZXNldCAgICAgICAgPSB1ZnNfbXRrX2RldmljZV9yZXNldCwNCiB9Ow0KIA0KIC8qKg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5oDQppbmRleCAxOWY4YzQyZmUwNmYuLmIwM2Y2MDFkM2E5ZSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCisrKyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCkBAIC02LDYgKzYsOCBAQA0KICNpZm5kZWYgX1VGU19N
RURJQVRFS19IDQogI2RlZmluZSBfVUZTX01FRElBVEVLX0gNCiANCisjaW5jbHVkZSA8bGludXgv
Yml0b3BzLmg+DQorDQogLyoNCiAgKiBWZW5kb3Igc3BlY2lmaWMgcHJlLWRlZmluZWQgcGFyYW1l
dGVycw0KICAqLw0KQEAgLTI5LDYgKzMxLDExIEBADQogI2RlZmluZSBWU19TQVZFUE9XRVJDT05U
Uk9MICAgICAgICAgMHhEMEE2DQogI2RlZmluZSBWU19VTklQUk9QT1dFUkRPV05DT05UUk9MICAg
MHhEMEE4DQogDQorLyoNCisgKiBTaVAgY29tbWFuZHMNCisgKi8NCisjZGVmaW5lIFVGU19NVEtf
U0lQX0RFVklDRV9SRVNFVCAgICBCSVQoMSkNCisNCiAvKg0KICAqIFZTX0RFQlVHQ0xPQ0tFTkFC
TEUNCiAgKi8NCi0tIA0KMi4xOC4wDQo=

