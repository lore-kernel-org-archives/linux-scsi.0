Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F613C32771
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14BFC2077C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AW0Qss1y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390302AbgAXPIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 10:08:05 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:63559 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388706AbgAXPIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 10:08:02 -0500
X-UUID: cecd3ee0748c4d8ab41df03b0fd0cd5a-20200124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=vcvvxpJscKwYB9oZ8PPJi+Oq/SniD4zBAROoyiH/1Ms=;
        b=AW0Qss1yC0tReCyneavSr12AKSXo1WrSgHU5KMnJZJClpmDqy0OfQkkTYfSQABj47GKoY0XKgwrRE9m/qJJ5VnaKmS21vvhOzsqamMGUEEm6hdy/KXxIiYHBR5c/+Mx903VhMgNHDaJ/COTBgAsBqkHDDsYvxTnQzO5xKNkak2U=;
X-UUID: cecd3ee0748c4d8ab41df03b0fd0cd5a-20200124
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 910914258; Fri, 24 Jan 2020 23:07:47 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 23:07:05 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 Jan 2020 23:07:16 +0800
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
Subject: [PATCH v2 5/5] scsi: ufs-mediatek: gate ref-clk during Auto-Hibern8
Date:   Fri, 24 Jan 2020 23:07:43 +0800
Message-ID: <20200124150743.15110-6-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200124150743.15110-1-stanley.chu@mediatek.com>
References: <20200124150743.15110-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW4gY3VycmVudCBVRlMgZHJpdmVyIGRlc2lnbiwgaGJhLT51aWNfbGlua19zdGF0ZSB3aWxsIG5v
dA0KYmUgY2hhbmdlZCBhZnRlciBsaW5rIGVudGVycyBIaWJlcm44IHN0YXRlIGJ5IEF1dG8tSGli
ZXJuOCBtZWNoYW5pc20uDQpJbiB0aGlzIGNhc2UsIHJlZmVyZW5jZSBjbG9jayBnYXRpbmcgd2ls
bCBiZSBza2lwcGVkIHVubGVzcyBzcGVjaWFsDQpoYW5kbGluZyBpcyBpbXBsZW1lbnRlZCBpbiB2
ZW5kb3IncyBjYWxsYmFja3MuDQoNClN1cHBvcnQgcmVmZXJlbmNlIGNsb2NrIGdhdGluZyBkdXJp
bmcgQXV0by1IaWJlcm44IHBlcmlvZCBpbg0KTWVkaWFUZWsgQ2hpcHNldHM6IElmIGxpbmsgc3Rh
dGUgaXMgYWxyZWFkeSBpbiBIaWJlcm44IHdoaWxlDQpBdXRvLUhpYmVybjggZmVhdHVyZSBpcyBl
bmFibGVkLCBnYXRlIHJlZmVyZW5jZSBjbG9jayBpbg0Kc2V0dXBfY2xvY2tzIGNhbGxiYWNrLg0K
DQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0K
LS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDM4ICsrKysrKysrKysrKysr
KysrKysrKysrLS0tLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggfCAx
MiArKysrKysrKysrKw0KIDIgZmlsZXMgY2hhbmdlZCwgMzkgaW5zZXJ0aW9ucygrKSwgMTEgZGVs
ZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5j
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggZDc4ODk3YTE0OTA1Li5h
YmY5ZGQ3NWM0MmUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5j
DQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAtMTQzLDYgKzE0Mywx
NyBAQCBzdGF0aWMgaW50IHVmc19tdGtfc2V0dXBfcmVmX2NsayhzdHJ1Y3QgdWZzX2hiYSAqaGJh
LCBib29sIG9uKQ0KIAlyZXR1cm4gMDsNCiB9DQogDQorc3RhdGljIHUzMiB1ZnNfbXRrX2xpbmtf
Z2V0X3N0YXRlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQorew0KKwl1MzIgdmFsOw0KKw0KKwl1ZnNo
Y2Rfd3JpdGVsKGhiYSwgMHgyMCwgUkVHX1VGU19ERUJVR19TRUwpOw0KKwl2YWwgPSB1ZnNoY2Rf
cmVhZGwoaGJhLCBSRUdfVUZTX1BST0JFKTsNCisJdmFsID0gdmFsID4+IDI4Ow0KKw0KKwlyZXR1
cm4gdmFsOw0KK30NCisNCiAvKioNCiAgKiB1ZnNfbXRrX3NldHVwX2Nsb2NrcyAtIGVuYWJsZXMv
ZGlzYWJsZSBjbG9ja3MNCiAgKiBAaGJhOiBob3N0IGNvbnRyb2xsZXIgaW5zdGFuY2UNCkBAIC0x
NTUsNyArMTY2LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX3NldHVwX2Nsb2NrcyhzdHJ1Y3QgdWZz
X2hiYSAqaGJhLCBib29sIG9uLA0KIAkJCQllbnVtIHVmc19ub3RpZnlfY2hhbmdlX3N0YXR1cyBz
dGF0dXMpDQogew0KIAlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJp
YW50KGhiYSk7DQotCWludCByZXQgPSAtRUlOVkFMOw0KKwlpbnQgcmV0ID0gMDsNCiANCiAJLyoN
CiAJICogSW4gY2FzZSB1ZnNfbXRrX2luaXQoKSBpcyBub3QgeWV0IGRvbmUsIHNpbXBseSBpZ25v
cmUuDQpAQCAtMTY1LDE5ICsxNzYsMjQgQEAgc3RhdGljIGludCB1ZnNfbXRrX3NldHVwX2Nsb2Nr
cyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uLA0KIAlpZiAoIWhvc3QpDQogCQlyZXR1cm4g
MDsNCiANCi0Jc3dpdGNoIChzdGF0dXMpIHsNCi0JY2FzZSBQUkVfQ0hBTkdFOg0KLQkJaWYgKCFv
biAmJiAhdWZzaGNkX2lzX2xpbmtfYWN0aXZlKGhiYSkpIHsNCisJaWYgKCFvbiAmJiBzdGF0dXMg
PT0gUFJFX0NIQU5HRSkgew0KKwkJaWYgKCF1ZnNoY2RfaXNfbGlua19hY3RpdmUoaGJhKSkgew0K
IAkJCXVmc19tdGtfc2V0dXBfcmVmX2NsayhoYmEsIG9uKTsNCiAJCQlyZXQgPSBwaHlfcG93ZXJf
b2ZmKGhvc3QtPm1waHkpOw0KKwkJfSBlbHNlIHsNCisJCQkvKg0KKwkJCSAqIEdhdGUgcmVmLWNs
ayBpZiBsaW5rIHN0YXRlIGlzIGluIEhpYmVybjgNCisJCQkgKiB0cmlnZ2VyZWQgYnkgQXV0by1I
aWJlcm44Lg0KKwkJCSAqLw0KKwkJCWlmICghdWZzaGNkX2Nhbl9oaWJlcm44X2R1cmluZ19nYXRp
bmcoaGJhKSAmJg0KKwkJCSAgICB1ZnNoY2RfaXNfYXV0b19oaWJlcm44X2VuYWJsZWQoaGJhKSAm
Jg0KKwkJCSAgICB1ZnNfbXRrX2xpbmtfZ2V0X3N0YXRlKGhiYSkgPT0NCisJCQkgICAgVlNfTElO
S19ISUJFUjgpDQorCQkJCXVmc19tdGtfc2V0dXBfcmVmX2NsayhoYmEsIG9uKTsNCiAJCX0NCi0J
CWJyZWFrOw0KLQljYXNlIFBPU1RfQ0hBTkdFOg0KLQkJaWYgKG9uKSB7DQotCQkJcmV0ID0gcGh5
X3Bvd2VyX29uKGhvc3QtPm1waHkpOw0KLQkJCXVmc19tdGtfc2V0dXBfcmVmX2NsayhoYmEsIG9u
KTsNCi0JCX0NCi0JCWJyZWFrOw0KKwl9IGVsc2UgaWYgKG9uICYmIHN0YXR1cyA9PSBQT1NUX0NI
QU5HRSkgew0KKwkJcmV0ID0gcGh5X3Bvd2VyX29uKGhvc3QtPm1waHkpOw0KKwkJdWZzX210a19z
ZXR1cF9yZWZfY2xrKGhiYSwgb24pOw0KIAl9DQogDQogCXJldHVybiByZXQ7DQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
LW1lZGlhdGVrLmgNCmluZGV4IGZjY2RkOTc5ZDZmYi4uYzMyY2I0MmM4OTQyIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnMtbWVkaWF0ZWsuaA0KQEAgLTUzLDYgKzUzLDE4IEBADQogI2RlZmluZSBWU19TQVZFUE9X
RVJDT05UUk9MICAgICAgICAgMHhEMEE2DQogI2RlZmluZSBWU19VTklQUk9QT1dFUkRPV05DT05U
Uk9MICAgMHhEMEE4DQogDQorLyoNCisgKiBWZW5kb3Igc3BlY2lmaWMgbGluayBzdGF0ZQ0KKyAq
Lw0KK2VudW0gew0KKwlWU19MSU5LX0RJU0FCTEVEICAgICAgICAgICAgPSAwLA0KKwlWU19MSU5L
X0RPV04gICAgICAgICAgICAgICAgPSAxLA0KKwlWU19MSU5LX1VQICAgICAgICAgICAgICAgICAg
PSAyLA0KKwlWU19MSU5LX0hJQkVSOCAgICAgICAgICAgICAgPSAzLA0KKwlWU19MSU5LX0xPU1Qg
ICAgICAgICAgICAgICAgPSA0LA0KKwlWU19MSU5LX0NGRyAgICAgICAgICAgICAgICAgPSA1LA0K
K307DQorDQogLyoNCiAgKiBTaVAgY29tbWFuZHMNCiAgKi8NCi0tIA0KMi4xOC4wDQo=

