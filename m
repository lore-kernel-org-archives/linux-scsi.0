Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B35C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DC5F207BC
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:58:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uI3j8bH2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgJ2L6O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:58:14 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57201 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725300AbgJ2L6C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 07:58:02 -0400
X-UUID: 06a5844566ed4a7fab69ca98c3b4be9a-20201029
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=gfnnUMTukPN9nXUoJsTAgUclVQL2iOIkqnu56wZwVGs=;
        b=uI3j8bH2+1Ucb/B2utCgrTp7X4vcQHa8IVYtwExoWdHzTWYwma/Ci1zEpeMI5/SwUKWNCxrlsCMhnkqRx6i3Vy6lwqmcmJu6x57BQvISbBjelUflWUfbgYYr3kway44GEudyrZ31+LyXAVAaNQGjAjLy2jGvsWfHXoDW4uNYNXg=;
X-UUID: 06a5844566ed4a7fab69ca98c3b4be9a-20201029
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 366030498; Thu, 29 Oct 2020 19:57:53 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Oct 2020 19:57:51 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Oct 2020 19:57:51 +0800
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
Subject: [PATCH v1 6/6] scsi: ufs-mediatek: Add HS-G4 support
Date:   Thu, 29 Oct 2020 19:57:50 +0800
Message-ID: <20201029115750.24391-7-stanley.chu@mediatek.com>
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

UHJvdmlkZSBIUy1HNCBzdXBwb3J0IGluIE1lZGlhVGVrIFVGUyBwbGF0Zm9ybXMuDQoNClRvIHN1
cHBvcnQgSFMtRzQsIGludHJvZHVjZSBtZWNoYW5pc20gdG8gZ2V0IHRoZQ0KTWVkaWFUZWsgVUZT
IGNvbnRyb2xsZXIgdmVyc2lvbi4gV2l0aCBzdWNoIGluZm9ybWF0aW9uLA0KZHJpdmVyIGNhbiBt
YWtlIHJpZ2h0IGRlY2lzaW9uIHRvIGFwcGx5IGRpZmZlcmVudA0KY29uZmlndXJhdGlvbnMgaW4g
ZGlmZmVyZW50IGNvbnRyb2xsZXJzLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rh
bmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0
ZWsuYyB8IDMyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQogZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuaCB8IDExICsrKysrKysrKy0tDQogMiBmaWxlcyBjaGFuZ2VkLCA0
MSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMN
CmluZGV4IGRkYTAyOGVjMzBkYy4uMWEzNTVmNTE5NTU2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0
ZWsuYw0KQEAgLTU2OSw2ICs1NjksMjQgQEAgc3RhdGljIGludCB1ZnNfbXRrX3NldHVwX2Nsb2Nr
cyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uLA0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCitz
dGF0aWMgdm9pZCB1ZnNfbXRrX2dldF9jb250cm9sbGVyX3ZlcnNpb24oc3RydWN0IHVmc19oYmEg
KmhiYSkNCit7DQorCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3Zhcmlh
bnQoaGJhKTsNCisJaW50IHJldCwgdmVyID0gMDsNCisNCisJaWYgKGhvc3QtPmh3X3Zlci5tYWpv
cikNCisJCXJldHVybjsNCisNCisJLyogU2V0IGRlZmF1bHQgKG1pbmltdW0pIHZlcnNpb24gYW55
d2F5ICovDQorCWhvc3QtPmh3X3Zlci5tYWpvciA9IDI7DQorDQorCXJldCA9IHVmc2hjZF9kbWVf
Z2V0KGhiYSwgVUlDX0FSR19NSUIoUEFfTE9DQUxWRVJJTkZPKSwgJnZlcik7DQorCWlmICghcmV0
KSB7DQorCQlpZiAodmVyID49IFVGU19VTklQUk9fVkVSXzFfOCkNCisJCQlob3N0LT5od192ZXIu
bWFqb3IgPSAzOw0KKwl9DQorfQ0KKw0KIC8qKg0KICAqIHVmc19tdGtfaW5pdCAtIGZpbmQgb3Ro
ZXIgZXNzZW50aWFsIG1taW8gYmFzZXMNCiAgKiBAaGJhOiBob3N0IGNvbnRyb2xsZXIgaW5zdGFu
Y2UNCkBAIC02NDksNyArNjY3LDkgQEAgc3RhdGljIGludCB1ZnNfbXRrX3ByZV9wd3JfY2hhbmdl
KHN0cnVjdCB1ZnNfaGJhICpoYmEsDQogCQkJCSAgc3RydWN0IHVmc19wYV9sYXllcl9hdHRyICpk
ZXZfbWF4X3BhcmFtcywNCiAJCQkJICBzdHJ1Y3QgdWZzX3BhX2xheWVyX2F0dHIgKmRldl9yZXFf
cGFyYW1zKQ0KIHsNCisJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFy
aWFudChoYmEpOw0KIAlzdHJ1Y3QgdWZzX2Rldl9wYXJhbXMgaG9zdF9jYXA7DQorCXUzMiBhZGFw
dF92YWw7DQogCWludCByZXQ7DQogDQogCWhvc3RfY2FwLnR4X2xhbmVzID0gVUZTX01US19MSU1J
VF9OVU1fTEFORVNfVFg7DQpAQCAtNjc0LDYgKzY5NCwxNiBAQCBzdGF0aWMgaW50IHVmc19tdGtf
cHJlX3B3cl9jaGFuZ2Uoc3RydWN0IHVmc19oYmEgKmhiYSwNCiAJCQlfX2Z1bmNfXyk7DQogCX0N
CiANCisJaWYgKGhvc3QtPmh3X3Zlci5tYWpvciA+PSAzKSB7DQorCQlpZiAoZGV2X3JlcV9wYXJh
bXMtPmdlYXJfdHggPT0gVUZTX0hTX0c0KQ0KKwkJCWFkYXB0X3ZhbCA9IFBBX0lOSVRJQUxfQURB
UFQ7DQorCQllbHNlDQorCQkJYWRhcHRfdmFsID0gUEFfTk9fQURBUFQ7DQorCQl1ZnNoY2RfZG1l
X3NldChoYmEsDQorCQkJICAgICAgIFVJQ19BUkdfTUlCKFBBX1RYSFNBREFQVFRZUEUpLA0KKwkJ
CSAgICAgICBhZGFwdF92YWwpOw0KKwl9DQorDQogCXJldHVybiByZXQ7DQogfQ0KIA0KQEAgLTcy
NCw2ICs3NTQsOCBAQCBzdGF0aWMgaW50IHVmc19tdGtfcHJlX2xpbmsoc3RydWN0IHVmc19oYmEg
KmhiYSkNCiAJaW50IHJldDsNCiAJdTMyIHRtcDsNCiANCisJdWZzX210a19nZXRfY29udHJvbGxl
cl92ZXJzaW9uKGhiYSk7DQorDQogCXJldCA9IHVmc19tdGtfdW5pcHJvX3NldF9scG0oaGJhLCBm
YWxzZSk7DQogCWlmIChyZXQpDQogCQlyZXR1cm4gcmV0Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5o
DQppbmRleCAzMGY0NWRmY2UwNGMuLmFjMzdiMTE4MDNmYiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlh
dGVrLmgNCkBAIC0zNSw4ICszNSw4IEBADQogICovDQogI2RlZmluZSBVRlNfTVRLX0xJTUlUX05V
TV9MQU5FU19SWCAgMg0KICNkZWZpbmUgVUZTX01US19MSU1JVF9OVU1fTEFORVNfVFggIDINCi0j
ZGVmaW5lIFVGU19NVEtfTElNSVRfSFNHRUFSX1JYICAgICBVRlNfSFNfRzMNCi0jZGVmaW5lIFVG
U19NVEtfTElNSVRfSFNHRUFSX1RYICAgICBVRlNfSFNfRzMNCisjZGVmaW5lIFVGU19NVEtfTElN
SVRfSFNHRUFSX1JYICAgICBVRlNfSFNfRzQNCisjZGVmaW5lIFVGU19NVEtfTElNSVRfSFNHRUFS
X1RYICAgICBVRlNfSFNfRzQNCiAjZGVmaW5lIFVGU19NVEtfTElNSVRfUFdNR0VBUl9SWCAgICBV
RlNfUFdNX0c0DQogI2RlZmluZSBVRlNfTVRLX0xJTUlUX1BXTUdFQVJfVFggICAgVUZTX1BXTV9H
NA0KICNkZWZpbmUgVUZTX01US19MSU1JVF9SWF9QV1JfUFdNICAgIFNMT1dfTU9ERQ0KQEAgLTEw
Nyw2ICsxMDcsMTIgQEAgc3RydWN0IHVmc19tdGtfY3J5cHRfY2ZnIHsNCiAJaW50IHZjb3JlX3Zv
bHQ7DQogfTsNCiANCitzdHJ1Y3QgdWZzX210a19od192ZXIgew0KKwl1OCBzdGVwOw0KKwl1OCBt
aW5vcjsNCisJdTggbWFqb3I7DQorfTsNCisNCiBzdHJ1Y3QgdWZzX210a19ob3N0IHsNCiAJc3Ry
dWN0IHBoeSAqbXBoeTsNCiAJc3RydWN0IHJlZ3VsYXRvciAqcmVnX3ZhMDk7DQpAQCAtMTE1LDYg
KzEyMSw3IEBAIHN0cnVjdCB1ZnNfbXRrX2hvc3Qgew0KIAlzdHJ1Y3QgcmVzZXRfY29udHJvbCAq
Y3J5cHRvX3Jlc2V0Ow0KIAlzdHJ1Y3QgdWZzX2hiYSAqaGJhOw0KIAlzdHJ1Y3QgdWZzX210a19j
cnlwdF9jZmcgKmNyeXB0Ow0KKwlzdHJ1Y3QgdWZzX210a19od192ZXIgaHdfdmVyOw0KIAllbnVt
IHVmc19tdGtfaG9zdF9jYXBzIGNhcHM7DQogCWJvb2wgbXBoeV9wb3dlcmVkX29uOw0KIAlib29s
IHVuaXByb19scG07DQotLSANCjIuMTguMA0K

