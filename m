Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26738C2D0C3
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED52B20718
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="p0BakxZe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfL3Fc7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 00:32:59 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:60253 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727178AbfL3Fc7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2019 00:32:59 -0500
X-UUID: 73e27eb881a6497898f52cac3ef29c55-20191230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=lASBnsWC43Rfu6UB24oYUGd0P99a4d4L+O1D0Rkd/kg=;
        b=p0BakxZeyUmy4+OrwLlFFIwnpTpmvnZoVDazX1F0Qg56PJUrh4Igyn+7zc/wiknx5mQ0oteUBYquY5u82KvZrWyON6GOpYkVhDMZPYlyze4V3+rt/a1TO5V9Ut/QFQFIF9JyFsfjsIwm3Xrq2ig3b4fqUYxE9YosmZj8SUyTaPE=;
X-UUID: 73e27eb881a6497898f52cac3ef29c55-20191230
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 854484596; Mon, 30 Dec 2019 13:32:52 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Dec 2019 13:32:05 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 30 Dec 2019 13:31:31 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <f.fainelli@gmail.com>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <leon.chen@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 2/6] scsi: ufs-mediatek: add device reset implementation
Date:   Mon, 30 Dec 2019 13:32:26 +0800
Message-ID: <1577683950-1702-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
References: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGRldmljZSByZXNldCB2b3BzIGltcGxlbWVudGF0aW9uIGluIE1lZGlhVGVrIFVGUyBkcml2
ZXIuDQoNCkNjOiBBbGltIEFraHRhciA8YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+DQpDYzogQXZy
aSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQpDYzogQmFydCBWYW4gQXNzY2hlIDxidmFu
YXNzY2hlQGFjbS5vcmc+DQpDYzogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCkNjOiBD
YW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KQ2M6IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFp
bmVsbGlAZ21haWwuY29tPg0KQ2M6IE1hdHRoaWFzIEJydWdnZXIgPG1hdHRoaWFzLmJnZ0BnbWFp
bC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsu
Y29tPg0KUmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KLS0t
DQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDMzICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggfCAgOSAr
KysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDQyIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5jDQppbmRleCA4M2UyOGVkYzNhYzUuLjM3ZTJjOTFmYzQ1MiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC02LDE2ICs2LDI1IEBADQogICoJUGV0ZXIgV2FuZyA8cGV0
ZXIud2FuZ0BtZWRpYXRlay5jb20+DQogICovDQogDQorI2luY2x1ZGUgPGxpbnV4L2FybS1zbWNj
Yy5oPg0KICNpbmNsdWRlIDxsaW51eC9vZi5oPg0KICNpbmNsdWRlIDxsaW51eC9vZl9hZGRyZXNz
Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3BoeS9waHkuaD4NCiAjaW5jbHVkZSA8bGludXgvcGxhdGZv
cm1fZGV2aWNlLmg+DQorI2luY2x1ZGUgPGxpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5o
Pg0KIA0KICNpbmNsdWRlICJ1ZnNoY2QuaCINCiAjaW5jbHVkZSAidWZzaGNkLXBsdGZybS5oIg0K
ICNpbmNsdWRlICJ1bmlwcm8uaCINCiAjaW5jbHVkZSAidWZzLW1lZGlhdGVrLmgiDQogDQorI2Rl
ZmluZSB1ZnNfbXRrX3NtYyhjbWQsIHZhbCwgcmVzKSBcDQorCWFybV9zbWNjY19zbWMoTVRLX1NJ
UF9VRlNfQ09OVFJPTCwgXA0KKwkJICAgICAgY21kLCB2YWwsIDAsIDAsIDAsIDAsIDAsICYocmVz
KSkNCisNCisjZGVmaW5lIHVmc19tdGtfZGV2aWNlX3Jlc2V0X2N0cmwoaGlnaCwgcmVzKSBcDQor
CXVmc19tdGtfc21jKFVGU19NVEtfU0lQX0RFVklDRV9SRVNFVCwgaGlnaCwgcmVzKQ0KKw0KIHN0
YXRpYyB2b2lkIHVmc19tdGtfY2ZnX3VuaXByb19jZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29s
IGVuYWJsZSkNCiB7DQogCXUzMiB0bXA7DQpAQCAtMjY5LDYgKzI3OCwyOSBAQCBzdGF0aWMgaW50
IHVmc19tdGtfbGlua19zdGFydHVwX25vdGlmeShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KIAlyZXR1
cm4gcmV0Ow0KIH0NCiANCitzdGF0aWMgdm9pZCB1ZnNfbXRrX2RldmljZV9yZXNldChzdHJ1Y3Qg
dWZzX2hiYSAqaGJhKQ0KK3sNCisJc3RydWN0IGFybV9zbWNjY19yZXMgcmVzOw0KKw0KKwl1ZnNf
bXRrX2RldmljZV9yZXNldF9jdHJsKDAsIHJlcyk7DQorDQorCS8qDQorCSAqIFRoZSByZXNldCBz
aWduYWwgaXMgYWN0aXZlIGxvdy4gVUZTIGRldmljZXMgc2hhbGwgZGV0ZWN0DQorCSAqIG1vcmUg
dGhhbiBvciBlcXVhbCB0byAxdXMgb2YgcG9zaXRpdmUgb3IgbmVnYXRpdmUgUlNUX24NCisJICog
cHVsc2Ugd2lkdGguDQorCSAqDQorCSAqIFRvIGJlIG9uIHNhZmUgc2lkZSwga2VlcCB0aGUgcmVz
ZXQgbG93IGZvciBhdCBsZWFzdCAxMHVzLg0KKwkgKi8NCisJdXNsZWVwX3JhbmdlKDEwLCAxNSk7
DQorDQorCXVmc19tdGtfZGV2aWNlX3Jlc2V0X2N0cmwoMSwgcmVzKTsNCisNCisJLyogU29tZSBk
ZXZpY2VzIG1heSBuZWVkIHRpbWUgdG8gcmVzcG9uZCB0byByc3RfbiAqLw0KKwl1c2xlZXBfcmFu
Z2UoMTAwMDAsIDE1MDAwKTsNCisNCisJZGV2X2luZm8oaGJhLT5kZXYsICJkZXZpY2UgcmVzZXQg
ZG9uZVxuIik7DQorfQ0KKw0KIHN0YXRpYyBpbnQgdWZzX210a19zdXNwZW5kKHN0cnVjdCB1ZnNf
aGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KIHsNCiAJc3RydWN0IHVmc19tdGtfaG9z
dCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KQEAgLTMwMyw2ICszMzUsNyBAQCBz
dGF0aWMgc3RydWN0IHVmc19oYmFfdmFyaWFudF9vcHMgdWZzX2hiYV9tdGtfdm9wcyA9IHsNCiAJ
LnB3cl9jaGFuZ2Vfbm90aWZ5ICAgPSB1ZnNfbXRrX3B3cl9jaGFuZ2Vfbm90aWZ5LA0KIAkuc3Vz
cGVuZCAgICAgICAgICAgICA9IHVmc19tdGtfc3VzcGVuZCwNCiAJLnJlc3VtZSAgICAgICAgICAg
ICAgPSB1ZnNfbXRrX3Jlc3VtZSwNCisJLmRldmljZV9yZXNldCAgICAgICAgPSB1ZnNfbXRrX2Rl
dmljZV9yZXNldCwNCiB9Ow0KIA0KIC8qKg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQppbmRleCAx
OWY4YzQyZmUwNmYuLmNlNjhjZTI1ZmRkNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCkBA
IC02LDYgKzYsOSBAQA0KICNpZm5kZWYgX1VGU19NRURJQVRFS19IDQogI2RlZmluZSBfVUZTX01F
RElBVEVLX0gNCiANCisjaW5jbHVkZSA8bGludXgvYml0b3BzLmg+DQorI2luY2x1ZGUgPGxpbnV4
L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oPg0KKw0KIC8qDQogICogVmVuZG9yIHNwZWNpZmlj
IHByZS1kZWZpbmVkIHBhcmFtZXRlcnMNCiAgKi8NCkBAIC0yOSw2ICszMiwxMiBAQA0KICNkZWZp
bmUgVlNfU0FWRVBPV0VSQ09OVFJPTCAgICAgICAgIDB4RDBBNg0KICNkZWZpbmUgVlNfVU5JUFJP
UE9XRVJET1dOQ09OVFJPTCAgIDB4RDBBOA0KIA0KKy8qDQorICogU2lQIGNvbW1hbmRzDQorICov
DQorI2RlZmluZSBNVEtfU0lQX1VGU19DT05UUk9MICAgICAgICAgTVRLX1NJUF9TTUNfQ01EKDB4
Mjc2KQ0KKyNkZWZpbmUgVUZTX01US19TSVBfREVWSUNFX1JFU0VUICAgIEJJVCgxKQ0KKw0KIC8q
DQogICogVlNfREVCVUdDTE9DS0VOQUJMRQ0KICAqLw0KLS0gDQoyLjE4LjANCg==

