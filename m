Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDB9C18E5B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1699220726
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rhYfu5f3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgCPIxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:53:32 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:1469 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730260AbgCPIxP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 04:53:15 -0400
X-UUID: b279d866dc614c0f86c305ea8196a192-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=i5xKHRSLe6EH/Hd0CHHZQLx7IJZBnYtRiQkeI0EGKSo=;
        b=rhYfu5f3xb4/NSOfm1XbmjZTidf64yPqgZ6SAx0/N4foCycCo9vGCgeRhkiZoeAw4mpJgSQDOLFWm8AAaGGRfynaD9k+X0dTQPk4NEE8eFCpR4c8dD3kkJo1++YEEwaj5wMOQSKANIKDRWX8IHCg8vYX39hhHm2uafFsfQedjP4=;
X-UUID: b279d866dc614c0f86c305ea8196a192-20200316
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1261189850; Mon, 16 Mar 2020 16:53:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 16:51:58 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 16:53:52 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.peter~sen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v6 4/7] scsi: ufs-mediatek: replace all delay places by common delay function
Date:   Mon, 16 Mar 2020 16:53:00 +0800
Message-ID: <20200316085303.20350-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200316085303.20350-1-stanley.chu@mediatek.com>
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QSBjb21tb24gZGVsYXkgZnVuY3Rpb24gaXMgaW50cm9kdWNlZCBpbiBVRlMgY29yZSBkcml2ZXIs
IHRodXMNCnVmcy1tZWRpYXRlayBjYW4gdXNlIGl0IHRvIHJlcGxhY2UgYWxsIGRlbGF5IGNvZGVz
Lg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29t
Pg0KUmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KLS0tDQog
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDIxICsrKysrLS0tLS0tLS0tLS0tLS0t
LQ0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMNCmluZGV4IDNiMGU1NzVkNzQ2MC4uMGZmNjc4MTY1NGZkIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTEwMCwxNyArMTAwLDYgQEAgc3RhdGljIGlu
dCB1ZnNfbXRrX2JpbmRfbXBoeShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlyZXR1cm4gZXJyOw0K
IH0NCiANCi1zdGF0aWMgdm9pZCB1ZnNfbXRrX3VkZWxheSh1bnNpZ25lZCBsb25nIHVzKQ0KLXsN
Ci0JaWYgKCF1cykNCi0JCXJldHVybjsNCi0NCi0JaWYgKHVzIDwgMTApDQotCQl1ZGVsYXkodXMp
Ow0KLQllbHNlDQotCQl1c2xlZXBfcmFuZ2UodXMsIHVzICsgMTApOw0KLX0NCi0NCiBzdGF0aWMg
aW50IHVmc19tdGtfc2V0dXBfcmVmX2NsayhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uKQ0K
IHsNCiAJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEp
Ow0KQEAgLTEyMyw3ICsxMTIsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfc2V0dXBfcmVmX2Nsayhz
dHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uKQ0KIA0KIAlpZiAob24pIHsNCiAJCXVmc19tdGtf
cmVmX2Nsa19ub3RpZnkob24sIHJlcyk7DQotCQl1ZnNfbXRrX3VkZWxheShob3N0LT5yZWZfY2xr
X3VuZ2F0aW5nX3dhaXRfdXMpOw0KKwkJdWZzaGNkX3dhaXRfdXMoaG9zdC0+cmVmX2Nsa191bmdh
dGluZ193YWl0X3VzLCAxMCwgdHJ1ZSk7DQogCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgUkVGQ0xLX1JF
UVVFU1QsIFJFR19VRlNfUkVGQ0xLX0NUUkwpOw0KIAl9IGVsc2Ugew0KIAkJdWZzaGNkX3dyaXRl
bChoYmEsIFJFRkNMS19SRUxFQVNFLCBSRUdfVUZTX1JFRkNMS19DVFJMKTsNCkBAIC0xMzgsNyAr
MTI3LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX3NldHVwX3JlZl9jbGsoc3RydWN0IHVmc19oYmEg
KmhiYSwgYm9vbCBvbikNCiAJCWlmICgoKHZhbHVlICYgUkVGQ0xLX0FDSykgPj4gMSkgPT0gKHZh
bHVlICYgUkVGQ0xLX1JFUVVFU1QpKQ0KIAkJCWdvdG8gb3V0Ow0KIA0KLQkJdXNsZWVwX3Jhbmdl
KDEwMCwgMjAwKTsNCisJCXVmc2hjZF93YWl0X3VzKDEwMCwgMTAwLCB0cnVlKTsNCiAJfSB3aGls
ZSAodGltZV9iZWZvcmUoamlmZmllcywgdGltZW91dCkpOw0KIA0KIAlkZXZfZXJyKGhiYS0+ZGV2
LCAibWlzc2luZyBhY2sgb2YgcmVmY2xrIHJlcSwgcmVnOiAweCV4XG4iLCB2YWx1ZSk7DQpAQCAt
MTUwLDcgKzEzOSw3IEBAIHN0YXRpYyBpbnQgdWZzX210a19zZXR1cF9yZWZfY2xrKHN0cnVjdCB1
ZnNfaGJhICpoYmEsIGJvb2wgb24pDQogb3V0Og0KIAlob3N0LT5yZWZfY2xrX2VuYWJsZWQgPSBv
bjsNCiAJaWYgKCFvbikgew0KLQkJdWZzX210a191ZGVsYXkoaG9zdC0+cmVmX2Nsa19nYXRpbmdf
d2FpdF91cyk7DQorCQl1ZnNoY2Rfd2FpdF91cyhob3N0LT5yZWZfY2xrX2dhdGluZ193YWl0X3Vz
LCAxMCwgdHJ1ZSk7DQogCQl1ZnNfbXRrX3JlZl9jbGtfbm90aWZ5KG9uLCByZXMpOw0KIAl9DQog
DQpAQCAtNDMwLDEyICs0MTksMTIgQEAgc3RhdGljIHZvaWQgdWZzX210a19kZXZpY2VfcmVzZXQo
c3RydWN0IHVmc19oYmEgKmhiYSkNCiAJICoNCiAJICogVG8gYmUgb24gc2FmZSBzaWRlLCBrZWVw
IHRoZSByZXNldCBsb3cgZm9yIGF0IGxlYXN0IDEwdXMuDQogCSAqLw0KLQl1c2xlZXBfcmFuZ2Uo
MTAsIDE1KTsNCisJdWZzaGNkX3dhaXRfdXMoMTAsIDUsIHRydWUpOw0KIA0KIAl1ZnNfbXRrX2Rl
dmljZV9yZXNldF9jdHJsKDEsIHJlcyk7DQogDQogCS8qIFNvbWUgZGV2aWNlcyBtYXkgbmVlZCB0
aW1lIHRvIHJlc3BvbmQgdG8gcnN0X24gKi8NCi0JdXNsZWVwX3JhbmdlKDEwMDAwLCAxNTAwMCk7
DQorCXVmc2hjZF93YWl0X3VzKDEwMDAwLCA1MDAwLCB0cnVlKTsNCiANCiAJZGV2X2luZm8oaGJh
LT5kZXYsICJkZXZpY2UgcmVzZXQgZG9uZVxuIik7DQogfQ0KLS0gDQoyLjE4LjANCg==

