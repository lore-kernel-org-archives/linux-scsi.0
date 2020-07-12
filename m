Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E485C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 00:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9289207BB
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 00:32:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VXspkkWV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGLAcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 20:32:39 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:52939 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727063AbgGLAcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 20:32:39 -0400
X-UUID: 118926be064b4de9ae4b29d484b4e5e9-20200712
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Z1SuMVtx7OA9n2jgiMCXVQ8y0m5FxirhJO+d41akUHw=;
        b=VXspkkWVh+oPvp4y2s+TqUobjolG2QZ23C9mGeuk2KwW9/wJbl0RrDl2ZqFMD+YbrXcmEqhYKlUsfRTp4aTRvPoJtPRZSMbeKaaKUg3MA0NwymTsxr+zGyHOTKCthuZBeTY/F1TbqpbbFmY+BqkRPVjT0/u6lOwWaehbCbvfivA=;
X-UUID: 118926be064b4de9ae4b29d484b4e5e9-20200712
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 434282081; Sun, 12 Jul 2020 08:32:30 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 12 Jul 2020 08:32:27 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 12 Jul 2020 08:32:27 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <ebiggers@kernel.org>, <satyat@google.com>
CC:     <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3] scsi: ufs-mediatek: Add inline encryption support
Date:   Sun, 12 Jul 2020 08:32:26 +0800
Message-ID: <20200712003226.7593-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 9CC95F33B94D9D190BA186BDF462498E3A2DC36E666D567D6896CF24781C8EFC2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGlubGluZSBlbmNyeXB0aW9uIHN1cHBvcnQgdG8gdWZzLW1lZGlhdGVrLg0KDQpUaGUgc3Rh
bmRhcmRzLWNvbXBsaWFudCBwYXJ0cywgc3VjaCBhcyBxdWVyeWluZyB0aGUgY3J5cHRvIGNhcGFi
aWxpdGllcw0KYW5kIGVuYWJsaW5nIGNyeXB0byBmb3IgaW5kaXZpZHVhbCBVRlMgcmVxdWVzdHMs
IGFyZSBhbHJlYWR5IGhhbmRsZWQgYnkNCnVmc2hjZC1jcnlwdG8uYywgd2hpY2ggaXRzZWxmIGlz
IHdpcmVkIGludG8gdGhlIGJsay1jcnlwdG8gZnJhbWV3b3JrLg0KDQpIb3dldmVyIE1lZGlhVGVr
IFVGUyBob3N0IHJlcXVpcmVzIGEgdmVuZG9yLXNwZWNpZmljIGhjZV9lbmFibGUgb3BlcmF0aW9u
DQp0byBhbGxvdyBjcnlwdG8tcmVsYXRlZCByZWdpc3RlcnMgYmVpbmcgYWNjZXNzZWQgbm9ybWFs
bHkgaW4ga2VybmVsLg0KQWZ0ZXIgdGhpcyBzdGVwLCBNZWRpYVRlayBVRlMgaG9zdCBjYW4gd29y
ayBhcyBzdGFuZGFyZC1jb21wbGlhbnQgaG9zdA0KZm9yIGlubGluZS1lbmNyeXB0aW9uIHJlbGF0
ZWQgZnVuY3Rpb25zLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVA
bWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDIy
ICsrKysrKysrKysrKysrKysrKysrKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5o
IHwgIDEgKw0KIDIgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
LW1lZGlhdGVrLmMNCmluZGV4IGFkOTI5MjM1YzE5My4uMzFhZjhiM2QyYjUzIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTE2LDYgKzE2LDcgQEANCiAjaW5jbHVkZSA8bGludXgvc29j
L21lZGlhdGVrL210a19zaXBfc3ZjLmg+DQogDQogI2luY2x1ZGUgInVmc2hjZC5oIg0KKyNpbmNs
dWRlICJ1ZnNoY2QtY3J5cHRvLmgiDQogI2luY2x1ZGUgInVmc2hjZC1wbHRmcm0uaCINCiAjaW5j
bHVkZSAidWZzX3F1aXJrcy5oIg0KICNpbmNsdWRlICJ1bmlwcm8uaCINCkBAIC0yNSw2ICsyNiw5
IEBADQogCWFybV9zbWNjY19zbWMoTVRLX1NJUF9VRlNfQ09OVFJPTCwgXA0KIAkJICAgICAgY21k
LCB2YWwsIDAsIDAsIDAsIDAsIDAsICYocmVzKSkNCiANCisjZGVmaW5lIHVmc19tdGtfY3J5cHRv
X2N0cmwocmVzLCBlbmFibGUpIFwNCisJdWZzX210a19zbWMoVUZTX01US19TSVBfQ1JZUFRPX0NU
UkwsIGVuYWJsZSwgcmVzKQ0KKw0KICNkZWZpbmUgdWZzX210a19yZWZfY2xrX25vdGlmeShvbiwg
cmVzKSBcDQogCXVmc19tdGtfc21jKFVGU19NVEtfU0lQX1JFRl9DTEtfTk9USUZJQ0FUSU9OLCBv
biwgcmVzKQ0KIA0KQEAgLTczLDYgKzc3LDE4IEBAIHN0YXRpYyB2b2lkIHVmc19tdGtfY2ZnX3Vu
aXByb19jZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIGVuYWJsZSkNCiAJfQ0KIH0NCiANCitz
dGF0aWMgdm9pZCB1ZnNfbXRrX2NyeXB0b19lbmFibGUoc3RydWN0IHVmc19oYmEgKmhiYSkNCit7
DQorCXN0cnVjdCBhcm1fc21jY2NfcmVzIHJlczsNCisNCisJdWZzX210a19jcnlwdG9fY3RybChy
ZXMsIDEpOw0KKwlpZiAocmVzLmEwKSB7DQorCQlkZXZfaW5mbyhoYmEtPmRldiwgIiVzOiBjcnlw
dG8gZW5hYmxlIGZhaWxlZCwgZXJyOiAlbHVcbiIsDQorCQkJIF9fZnVuY19fLCByZXMuYTApOw0K
KwkJaGJhLT5jYXBzICY9IH5VRlNIQ0RfQ0FQX0NSWVBUTzsNCisJfQ0KK30NCisNCiBzdGF0aWMg
aW50IHVmc19tdGtfaGNlX2VuYWJsZV9ub3RpZnkoc3RydWN0IHVmc19oYmEgKmhiYSwNCiAJCQkJ
ICAgICBlbnVtIHVmc19ub3RpZnlfY2hhbmdlX3N0YXR1cyBzdGF0dXMpDQogew0KQEAgLTgzLDYg
Kzk5LDkgQEAgc3RhdGljIGludCB1ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5KHN0cnVjdCB1ZnNf
aGJhICpoYmEsDQogCQkJaGJhLT52cHMtPmhiYV9lbmFibGVfZGVsYXlfdXMgPSAwOw0KIAkJZWxz
ZQ0KIAkJCWhiYS0+dnBzLT5oYmFfZW5hYmxlX2RlbGF5X3VzID0gNjAwOw0KKw0KKwkJaWYgKGhi
YS0+Y2FwcyAmIFVGU0hDRF9DQVBfQ1JZUFRPKQ0KKwkJCXVmc19tdGtfY3J5cHRvX2VuYWJsZSho
YmEpOw0KIAl9DQogDQogCXJldHVybiAwOw0KQEAgLTMxNyw2ICszMzYsOSBAQCBzdGF0aWMgaW50
IHVmc19tdGtfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAkvKiBFbmFibGUgY2xvY2stZ2F0
aW5nICovDQogCWhiYS0+Y2FwcyB8PSBVRlNIQ0RfQ0FQX0NMS19HQVRJTkc7DQogDQorCS8qIEVu
YWJsZSBpbmxpbmUgZW5jcnlwdGlvbiAqLw0KKwloYmEtPmNhcHMgfD0gVUZTSENEX0NBUF9DUllQ
VE87DQorDQogCS8qIEVuYWJsZSBXcml0ZUJvb3N0ZXIgKi8NCiAJaGJhLT5jYXBzIHw9IFVGU0hD
RF9DQVBfV0JfRU47DQogCWhiYS0+dnBzLT53Yl9mbHVzaF90aHJlc2hvbGQgPSBVRlNfV0JfQlVG
X1JFTUFJTl9QRVJDRU5UKDgwKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1t
ZWRpYXRlay5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KaW5kZXggNjA1MmVj
MTA1YWJhLi44ZWQyNGQ1ZmNmZjkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1t
ZWRpYXRlay5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQpAQCAtNzAs
NiArNzAsNyBAQCBlbnVtIHsNCiAgKi8NCiAjZGVmaW5lIE1US19TSVBfVUZTX0NPTlRST0wgICAg
ICAgICAgICAgICBNVEtfU0lQX1NNQ19DTUQoMHgyNzYpDQogI2RlZmluZSBVRlNfTVRLX1NJUF9E
RVZJQ0VfUkVTRVQgICAgICAgICAgQklUKDEpDQorI2RlZmluZSBVRlNfTVRLX1NJUF9DUllQVE9f
Q1RSTCAgICAgICAgICAgQklUKDIpDQogI2RlZmluZSBVRlNfTVRLX1NJUF9SRUZfQ0xLX05PVElG
SUNBVElPTiAgQklUKDMpDQogDQogLyoNCi0tIA0KMi4xOC4wDQo=

