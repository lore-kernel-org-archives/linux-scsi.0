Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBECC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DD44207DE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Gf0xcGIC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgJ2L56 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:57:58 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57201 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725300AbgJ2L56 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 07:57:58 -0400
X-UUID: 9391f1541e9346079bab0ef2fb2013ac-20201029
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=6kyqsGAFYyWgMWynHNq3rypwVy6bJxyAVIGT2lwY3Cc=;
        b=Gf0xcGIC+jIdVR/nkA3/szmlPWVW7g4+VQYP34vmGl7is/swno43HYuN70ez1IngDSO8QVd10ZeTv5AkLBrbT6uA6g28BAcggMxJLyELI9fcJ0QawYWJpX1MGfpFqt6wTb2jdyer/8V/0lev664SwDq9OdVhRvihcFiDtJneqcg=;
X-UUID: 9391f1541e9346079bab0ef2fb2013ac-20201029
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1018748586; Thu, 29 Oct 2020 19:57:53 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Oct 2020 19:57:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Oct 2020 19:57:50 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/6] scsi: ufs-mediatek: Assign arguments with correct type
Date:   Thu, 29 Oct 2020 19:57:45 +0800
Message-ID: <20201029115750.24391-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201029115750.24391-1-stanley.chu@mediatek.com>
References: <20201029115750.24391-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW4gdWZzX210a191bmlwcm9fc2V0X2xwbSgpLCB1c2Ugc3BlY2lmaWMgdW5zaWduZWQgdmFsdWVz
DQphcyB0aGUgYXJndW1lbnQgdG8gaW52b2tlIHVmc2hjZF9kbWVfc2V0KCkuDQoNCkluIHRoZSBz
YW1lIHRpbWUsIGNoYW5nZSB0aGUgbmFtZSBvZiB1ZnNfbXRrX3VuaXByb19zZXRfcG0oKQ0KdG8g
dWZzX210a191bmlwcm9fc2V0X2xwbSgpIHRvIGFsaWduIHRoZSBuYW1pbmcgY29udmVudGlvbg0K
aW4gTWVkaWFUZWsgVUZTIGRyaXZlci4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0
YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlh
dGVrLmMgfCAxMiArKysrKystLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCsp
LCA2IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVk
aWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCmluZGV4IDhkZjczYmMy
ZjhjYi4uMDE5NmE4OTA1NWI1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVk
aWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTYzOSwx
NCArNjM5LDE0IEBAIHN0YXRpYyBpbnQgdWZzX210a19wd3JfY2hhbmdlX25vdGlmeShzdHJ1Y3Qg
dWZzX2hiYSAqaGJhLA0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCi1zdGF0aWMgaW50IHVmc19tdGtf
dW5pcHJvX3NldF9wbShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIGxwbSkNCitzdGF0aWMgaW50
IHVmc19tdGtfdW5pcHJvX3NldF9scG0oc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBscG0pDQog
ew0KIAlpbnQgcmV0Ow0KIAlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92
YXJpYW50KGhiYSk7DQogDQogCXJldCA9IHVmc2hjZF9kbWVfc2V0KGhiYSwNCiAJCQkgICAgIFVJ
Q19BUkdfTUlCX1NFTChWU19VTklQUk9QT1dFUkRPV05DT05UUk9MLCAwKSwNCi0JCQkgICAgIGxw
bSk7DQorCQkJICAgICBscG0gPyAxIDogMCk7DQogCWlmICghcmV0IHx8ICFscG0pIHsNCiAJCS8q
DQogCQkgKiBGb3JjaWJseSBzZXQgYXMgbm9uLUxQTSBtb2RlIGlmIFVJQyBjb21tYW5kcyBpcyBm
YWlsZWQNCkBAIC02NjQsNyArNjY0LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX3ByZV9saW5rKHN0
cnVjdCB1ZnNfaGJhICpoYmEpDQogCWludCByZXQ7DQogCXUzMiB0bXA7DQogDQotCXJldCA9IHVm
c19tdGtfdW5pcHJvX3NldF9wbShoYmEsIGZhbHNlKTsNCisJcmV0ID0gdWZzX210a191bmlwcm9f
c2V0X2xwbShoYmEsIGZhbHNlKTsNCiAJaWYgKHJldCkNCiAJCXJldHVybiByZXQ7DQogDQpAQCAt
Nzc0LDcgKzc3NCw3IEBAIHN0YXRpYyBpbnQgdWZzX210a19saW5rX3NldF9ocG0oc3RydWN0IHVm
c19oYmEgKmhiYSkNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7DQogDQotCWVyciA9IHVmc19t
dGtfdW5pcHJvX3NldF9wbShoYmEsIGZhbHNlKTsNCisJZXJyID0gdWZzX210a191bmlwcm9fc2V0
X2xwbShoYmEsIGZhbHNlKTsNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7DQogDQpAQCAtNzk1
LDEwICs3OTUsMTAgQEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc2V0X2xwbShzdHJ1Y3QgdWZz
X2hiYSAqaGJhKQ0KIHsNCiAJaW50IGVycjsNCiANCi0JZXJyID0gdWZzX210a191bmlwcm9fc2V0
X3BtKGhiYSwgdHJ1ZSk7DQorCWVyciA9IHVmc19tdGtfdW5pcHJvX3NldF9scG0oaGJhLCB0cnVl
KTsNCiAJaWYgKGVycikgew0KIAkJLyogUmVzdW1lIFVuaVBybyBzdGF0ZSBmb3IgZm9sbG93aW5n
IGVycm9yIHJlY292ZXJ5ICovDQotCQl1ZnNfbXRrX3VuaXByb19zZXRfcG0oaGJhLCBmYWxzZSk7
DQorCQl1ZnNfbXRrX3VuaXByb19zZXRfbHBtKGhiYSwgZmFsc2UpOw0KIAkJcmV0dXJuIGVycjsN
CiAJfQ0KIA0KLS0gDQoyLjE4LjANCg==

