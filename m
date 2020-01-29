Return-Path: <SRS0=J5Rw=3S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F821C35240
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 07:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DADF7207FD
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 07:39:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SCBPwcpc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgA2HjS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jan 2020 02:39:18 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:15399 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726245AbgA2HjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2020 02:39:15 -0500
X-UUID: 10b6da7c35194dc5835daaa543df793e-20200129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ihJg6nDDfiwxmrOIMOxnedl2OexPLbIqUMUcg8QFLQA=;
        b=SCBPwcpcolSaFPCrFKTMHaZ7FCb3H6BfW2x1QLm2jwZrEvbQpnlb8zmQgwbVelZSqA2QZE/5kMVdWdFsOV4/Y2jNGHW9nIk+viZ8l/nVevhRvMOx1w1d5wdC4B5PdUztwhs/itRbg2JOu5QTK/pYCbYnu+fDo0RZ7A5VnX/NpnY=;
X-UUID: 10b6da7c35194dc5835daaa543df793e-20200129
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1642458441; Wed, 29 Jan 2020 15:39:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 29 Jan 2020 15:37:55 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 29 Jan 2020 15:39:12 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>
CC:     <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 4/4] scsi: ufs-mediatek: gate ref-clk during Auto-Hibern8
Date:   Wed, 29 Jan 2020 15:39:02 +0800
Message-ID: <20200129073902.5786-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200129073902.5786-1-stanley.chu@mediatek.com>
References: <20200129073902.5786-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 93F3D5635F3DD161DD5DA950D7204A42ABF40BAE1E4F29319C737A0899891C622000:8
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
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggZDc4ODk3YTE0OTA1Li4w
Y2UwODg3MmQ2NzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5j
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
S19ISUJFUk44KQ0KKwkJCQl1ZnNfbXRrX3NldHVwX3JlZl9jbGsoaGJhLCBvbik7DQogCQl9DQot
CQlicmVhazsNCi0JY2FzZSBQT1NUX0NIQU5HRToNCi0JCWlmIChvbikgew0KLQkJCXJldCA9IHBo
eV9wb3dlcl9vbihob3N0LT5tcGh5KTsNCi0JCQl1ZnNfbXRrX3NldHVwX3JlZl9jbGsoaGJhLCBv
bik7DQotCQl9DQotCQlicmVhazsNCisJfSBlbHNlIGlmIChvbiAmJiBzdGF0dXMgPT0gUE9TVF9D
SEFOR0UpIHsNCisJCXJldCA9IHBoeV9wb3dlcl9vbihob3N0LT5tcGh5KTsNCisJCXVmc19tdGtf
c2V0dXBfcmVmX2NsayhoYmEsIG9uKTsNCiAJfQ0KIA0KIAlyZXR1cm4gcmV0Ow0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5oDQppbmRleCBmY2NkZDk3OWQ2ZmIuLjQ5MjQxNGU1ZjQ4MSAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmgNCkBAIC01Myw2ICs1MywxOCBAQA0KICNkZWZpbmUgVlNfU0FWRVBP
V0VSQ09OVFJPTCAgICAgICAgIDB4RDBBNg0KICNkZWZpbmUgVlNfVU5JUFJPUE9XRVJET1dOQ09O
VFJPTCAgIDB4RDBBOA0KIA0KKy8qDQorICogVmVuZG9yIHNwZWNpZmljIGxpbmsgc3RhdGUNCisg
Ki8NCitlbnVtIHsNCisJVlNfTElOS19ESVNBQkxFRCAgICAgICAgICAgID0gMCwNCisJVlNfTElO
S19ET1dOICAgICAgICAgICAgICAgID0gMSwNCisJVlNfTElOS19VUCAgICAgICAgICAgICAgICAg
ID0gMiwNCisJVlNfTElOS19ISUJFUk44ICAgICAgICAgICAgID0gMywNCisJVlNfTElOS19MT1NU
ICAgICAgICAgICAgICAgID0gNCwNCisJVlNfTElOS19DRkcgICAgICAgICAgICAgICAgID0gNSwN
Cit9Ow0KKw0KIC8qDQogICogU2lQIGNvbW1hbmRzDQogICovDQotLSANCjIuMTguMA0K

