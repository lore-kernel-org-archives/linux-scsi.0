Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB29C35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FACE20CC7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mtk7JQ1x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgEHCWK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:22:10 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:56627 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727051AbgEHCVu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:21:50 -0400
X-UUID: 0471662c2c7946fca4652a913ee60722-20200508
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=HKXRMOVB6rsaBq2Oez1TJDf4STU7gUVCgYM/5vfjbME=;
        b=mtk7JQ1xLnjbzeLezf+PbRNoUr6+TvrKcD9Kzg617G9ipRo7DtQBmbZj8W848vVjQJ8NVrFJ6WnJMuwsNMdM0tyKgXICtBBDgV5CjRfqpYlxIERGoJoMxpIoHms6gjfVPC6ijTbHOLFB9zvaAS7VhhYEGWk5ZLI1sOsSqe+c6nc=;
X-UUID: 0471662c2c7946fca4652a913ee60722-20200508
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2055276618; Fri, 08 May 2020 10:21:43 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 8 May 2020 10:21:41 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 10:21:41 +0800
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
Subject: [PATCH v7 2/8] scsi: ufs: introduce fixup_dev_quirks vops
Date:   Fri, 8 May 2020 10:21:35 +0800
Message-ID: <20200508022141.10783-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200508022141.10783-1-stanley.chu@mediatek.com>
References: <20200508022141.10783-1-stanley.chu@mediatek.com>
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
ZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAxMSArKysrKysr
KysrLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCAgOSArKysrKysrKy0NCiAyIGZpbGVz
IGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
aW5kZXggYTgwMmM1ZjVlYzdjLi44ZDg2ZDlhNmE2MjIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtNjgz
OCw3ICs2ODM4LDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1ZnNfaGJh
ICpoYmEsIHU4ICpkZXNjX2J1ZikNCiAJaGJhLT5jYXBzICY9IH5VRlNIQ0RfQ0FQX1dCX0VOOw0K
IH0NCiANCi1zdGF0aWMgdm9pZCB1ZnNfZml4dXBfZGV2aWNlX3NldHVwKHN0cnVjdCB1ZnNfaGJh
ICpoYmEpDQorc3RhdGljIHZvaWQgdWZzaGNkX2ZpeHVwX2Rldl9xdWlya3Moc3RydWN0IHVmc19o
YmEgKmhiYSkNCiB7DQogCXN0cnVjdCB1ZnNfZGV2X2ZpeCAqZjsNCiAJc3RydWN0IHVmc19kZXZf
aW5mbyAqZGV2X2luZm8gPSAmaGJhLT5kZXZfaW5mbzsNCkBAIC02ODUzLDYgKzY4NTMsMTUgQEAg
c3RhdGljIHZvaWQgdWZzX2ZpeHVwX2RldmljZV9zZXR1cChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0K
IAl9DQogfQ0KIA0KK3N0YXRpYyB2b2lkIHVmc19maXh1cF9kZXZpY2Vfc2V0dXAoc3RydWN0IHVm
c19oYmEgKmhiYSkNCit7DQorCS8qIGZpeCBieSBnZW5lcmFsIHF1aXJrIHRhYmxlICovDQorCXVm
c2hjZF9maXh1cF9kZXZfcXVpcmtzKGhiYSk7DQorDQorCS8qIGFsbG93IHZlbmRvcnMgdG8gZml4
IHF1aXJrcyAqLw0KKwl1ZnNoY2Rfdm9wc19maXh1cF9kZXZfcXVpcmtzKGhiYSk7DQorfQ0KKw0K
IHN0YXRpYyBpbnQgdWZzX2dldF9kZXZpY2VfZGVzYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsN
CiAJaW50IGVycjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggMDU2NTM3ZTUyYzE5Li44OTczMzhiYTY3YWEg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5oDQpAQCAtNjksNiArNjksNyBAQA0KICNpbmNsdWRlIDxzY3NpL3Njc2lf
ZWguaD4NCiANCiAjaW5jbHVkZSAidWZzLmgiDQorI2luY2x1ZGUgInVmc19xdWlya3MuaCINCiAj
aW5jbHVkZSAidWZzaGNpLmgiDQogDQogI2RlZmluZSBVRlNIQ0QgInVmc2hjZCINCkBAIC0zMzYs
NiArMzM3LDcgQEAgc3RydWN0IHVmc19oYmFfdmFyaWFudF9vcHMgew0KIAl2b2lkICAgICgqaGli
ZXJuOF9ub3RpZnkpKHN0cnVjdCB1ZnNfaGJhICosIGVudW0gdWljX2NtZF9kbWUsDQogCQkJCQll
bnVtIHVmc19ub3RpZnlfY2hhbmdlX3N0YXR1cyk7DQogCWludAkoKmFwcGx5X2Rldl9xdWlya3Mp
KHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KKwl2b2lkCSgqZml4dXBfZGV2X3F1aXJrcykoc3RydWN0
IHVmc19oYmEgKmhiYSk7DQogCWludCAgICAgKCpzdXNwZW5kKShzdHJ1Y3QgdWZzX2hiYSAqLCBl
bnVtIHVmc19wbV9vcCk7DQogCWludCAgICAgKCpyZXN1bWUpKHN0cnVjdCB1ZnNfaGJhICosIGVu
dW0gdWZzX3BtX29wKTsNCiAJdm9pZAkoKmRiZ19yZWdpc3Rlcl9kdW1wKShzdHJ1Y3QgdWZzX2hi
YSAqaGJhKTsNCkBAIC05NTAsNyArOTUyLDYgQEAgaW50IHVmc2hjZF9xdWVyeV9mbGFnKHN0cnVj
dCB1ZnNfaGJhICpoYmEsIGVudW0gcXVlcnlfb3Bjb2RlIG9wY29kZSwNCiANCiB2b2lkIHVmc2hj
ZF9hdXRvX2hpYmVybjhfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KIHZvaWQgdWZzaGNk
X2F1dG9faGliZXJuOF91cGRhdGUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTMyIGFoaXQpOw0KLQ0K
ICNkZWZpbmUgU0RfQVNDSUlfU1REIHRydWUNCiAjZGVmaW5lIFNEX1JBVyBmYWxzZQ0KIGludCB1
ZnNoY2RfcmVhZF9zdHJpbmdfZGVzYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1OCBkZXNjX2luZGV4
LA0KQEAgLTEwODUsNiArMTA4NiwxMiBAQCBzdGF0aWMgaW5saW5lIGludCB1ZnNoY2Rfdm9wc19h
cHBseV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCXJldHVybiAwOw0KIH0NCiAN
CitzdGF0aWMgaW5saW5lIHZvaWQgdWZzaGNkX3ZvcHNfZml4dXBfZGV2X3F1aXJrcyhzdHJ1Y3Qg
dWZzX2hiYSAqaGJhKQ0KK3sNCisJaWYgKGhiYS0+dm9wcyAmJiBoYmEtPnZvcHMtPmZpeHVwX2Rl
dl9xdWlya3MpDQorCQloYmEtPnZvcHMtPmZpeHVwX2Rldl9xdWlya3MoaGJhKTsNCit9DQorDQog
c3RhdGljIGlubGluZSBpbnQgdWZzaGNkX3ZvcHNfc3VzcGVuZChzdHJ1Y3QgdWZzX2hiYSAqaGJh
LCBlbnVtIHVmc19wbV9vcCBvcCkNCiB7DQogCWlmIChoYmEtPnZvcHMgJiYgaGJhLT52b3BzLT5z
dXNwZW5kKQ0KLS0gDQoyLjE4LjANCg==

