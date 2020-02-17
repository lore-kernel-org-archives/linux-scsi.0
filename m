Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E73C761A0
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 09:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D1F220801
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 09:36:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="egQkMmyo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgBQJgI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 04:36:08 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:19842 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728911AbgBQJgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2020 04:36:07 -0500
X-UUID: 53c0cfbd5d8a428db8be9821ede531bf-20200217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=r7AqXWWI2XOKb8o72epYunSOyZikfu2WAV4cdgSvlQU=;
        b=egQkMmyoh7DXNkcULir9MSrkozqejp1Ig+OmZqS1QYBPCtHqw1dPfD7mpdbwk7eHTQYV1boUsu987vL78e33iFsAmp5rHckPYHgp4rn7vbFPrjOm9DXMZEufyufhv5Iv0UgfIP0ihsork6Nx3E6Kb3ImTuY/YkaX9u/llTaYD9Y=;
X-UUID: 53c0cfbd5d8a428db8be9821ede531bf-20200217
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 774111493; Mon, 17 Feb 2020 17:36:01 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 17 Feb 2020 17:33:33 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 17 Feb 2020 17:35:36 +0800
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
Subject: [PATCH v1 1/2] scsi: ufs: add required delay after gating reference clock
Date:   Mon, 17 Feb 2020 17:35:58 +0800
Message-ID: <20200217093559.16830-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200217093559.16830-1-stanley.chu@mediatek.com>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 6F93E073A79775700A46518EB217FC1397C16A2E0DDEF6E3FF63E042F98D71FF2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW4gVUZTIHZlcnNpb24gMy4wLCBhIG5ld2x5IGFkZGVkIGF0dHJpYnV0ZSBiUmVmQ2xrR2F0aW5n
V2FpdFRpbWUgZGVmaW5lcw0KdGhlIG1pbmltdW0gdGltZSBmb3Igd2hpY2ggdGhlIHJlZmVyZW5j
ZSBjbG9jayBpcyByZXF1aXJlZCBieSBkZXZpY2UgZHVyaW5nDQp0cmFuc2l0aW9uIHRvIExTLU1P
REUgb3IgSElCRVJOOCBzdGF0ZS4NCg0KQ3VycmVudGx5IHRoaXMgdGltZSBpcyBkZXRlY3RlZCBh
bmQgc3RvcmVkIGluDQpoYmEtPmRldl9pbmZvLmNsa19nYXRpbmdfd2FpdF91cyBidXQgYXBwbGll
ZCB0byB2ZW5kb3IgaW1wbGVtZW50YXRpb3Mgb25seS4NCk1ha2UgaXQgYXBwbGllZCB0byByZWZl
cmVuY2UgY2xvY2sgbmFtZWQgYXMgInJlZl9jbGsiIGluIGRldmljZSB0cmVlIGluDQpjb21tb24g
cGF0aC4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVr
LmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA4ICsrKysrKystDQogMSBm
aWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMN
CmluZGV4IDc0NGI4MjU0MjIwYy4uN2Y2MDcyMWY1NGQxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTc0
MTcsOCArNzQxNywxMCBAQCBzdGF0aWMgaW50IF9fdWZzaGNkX3NldHVwX2Nsb2NrcyhzdHJ1Y3Qg
dWZzX2hiYSAqaGJhLCBib29sIG9uLA0KIAlzdHJ1Y3QgdWZzX2Nsa19pbmZvICpjbGtpOw0KIAlz
dHJ1Y3QgbGlzdF9oZWFkICpoZWFkID0gJmhiYS0+Y2xrX2xpc3RfaGVhZDsNCiAJdW5zaWduZWQg
bG9uZyBmbGFnczsNCisJdW5zaWduZWQgbG9uZyB3YWl0X3VzOw0KIAlrdGltZV90IHN0YXJ0ID0g
a3RpbWVfZ2V0KCk7DQogCWJvb2wgY2xrX3N0YXRlX2NoYW5nZWQgPSBmYWxzZTsNCisJYm9vbCBy
ZWZfY2xrOw0KIA0KIAlpZiAobGlzdF9lbXB0eShoZWFkKSkNCiAJCWdvdG8gb3V0Ow0KQEAgLTc0
MzYsNyArNzQzOCw4IEBAIHN0YXRpYyBpbnQgX191ZnNoY2Rfc2V0dXBfY2xvY2tzKHN0cnVjdCB1
ZnNfaGJhICpoYmEsIGJvb2wgb24sDQogDQogCWxpc3RfZm9yX2VhY2hfZW50cnkoY2xraSwgaGVh
ZCwgbGlzdCkgew0KIAkJaWYgKCFJU19FUlJfT1JfTlVMTChjbGtpLT5jbGspKSB7DQotCQkJaWYg
KHNraXBfcmVmX2NsayAmJiAhc3RyY21wKGNsa2ktPm5hbWUsICJyZWZfY2xrIikpDQorCQkJcmVm
X2NsayA9ICFzdHJjbXAoY2xraS0+bmFtZSwgInJlZl9jbGsiKSA/IHRydWUgOiBmYWxzZTsNCisJ
CQlpZiAoc2tpcF9yZWZfY2xrICYmIHJlZl9jbGspDQogCQkJCWNvbnRpbnVlOw0KIA0KIAkJCWNs
a19zdGF0ZV9jaGFuZ2VkID0gb24gXiBjbGtpLT5lbmFibGVkOw0KQEAgLTc0NDksNiArNzQ1Miw5
IEBAIHN0YXRpYyBpbnQgX191ZnNoY2Rfc2V0dXBfY2xvY2tzKHN0cnVjdCB1ZnNfaGJhICpoYmEs
IGJvb2wgb24sDQogCQkJCX0NCiAJCQl9IGVsc2UgaWYgKCFvbiAmJiBjbGtpLT5lbmFibGVkKSB7
DQogCQkJCWNsa19kaXNhYmxlX3VucHJlcGFyZShjbGtpLT5jbGspOw0KKwkJCQl3YWl0X3VzID0g
aGJhLT5kZXZfaW5mby5jbGtfZ2F0aW5nX3dhaXRfdXM7DQorCQkJCWlmIChyZWZfY2xrICYmIHdh
aXRfdXMpDQorCQkJCQl1c2xlZXBfcmFuZ2Uod2FpdF91cywgd2FpdF91cyArIDEwKTsNCiAJCQl9
DQogCQkJY2xraS0+ZW5hYmxlZCA9IG9uOw0KIAkJCWRldl9kYmcoaGJhLT5kZXYsICIlczogY2xr
OiAlcyAlc2FibGVkXG4iLCBfX2Z1bmNfXywNCi0tIA0KMi4xOC4wDQo=

