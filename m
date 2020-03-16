Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FCEC0044D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 03:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15B3C20737
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 03:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JJY8MxT4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbgCPDmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 23:42:36 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:32774 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729412AbgCPDmf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2020 23:42:35 -0400
X-UUID: 777eed79954348c9a8423145f806e79c-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=dj5KB99V4jIFByooAmxz5JbekKkRboIPOi1U6PTrprM=;
        b=JJY8MxT4JGltQjMChLOgY1HfCoPlJRkTbajYNSk0qIzXa00xtXJTrzQ0DexJ/08zxMC3Mc2YYZ2WzSwc+RZyY2RzXgY7goxgsMQo1qmZIzRXXnZPCCr+IKnUTj2BR2sEwrXPFJo2gBsNZrTqM6SaNmc2po3595YCVmOEd9BrAU4=;
X-UUID: 777eed79954348c9a8423145f806e79c-20200316
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 829949003; Mon, 16 Mar 2020 11:42:21 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 11:39:28 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 11:39:23 +0800
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
Subject: [PATCH v5 8/8] scsi: ufs-mediatek: customize the delay for host enabling
Date:   Mon, 16 Mar 2020 11:42:18 +0800
Message-ID: <20200316034218.11914-9-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200316034218.11914-1-stanley.chu@mediatek.com>
References: <20200316034218.11914-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 5ED2083DD05240E8677D8A90F8A69DF74B19B5E5DD5A4CCB8DF7B9520F7891482000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWVkaWFUZWsgcGxhdGZvcm0gYW5kIFVGUyBjb250cm9sbGVyIGNhbiBkeW5hbWljYWxseSBjdXN0
b21pemUNCnRoZSBkZWxheSBmb3IgaG9zdCBlbmFibGluZyBhY2NvcmRpbmcgdG8gZGlmZmVyZW50
IHNjZW5hcmlvcy4NCg0KRm9yIGV4YW1wbGUsIGlmIFVuaVBybyBlbnRlcnMgbG93ZXItcG93ZXIg
bW9kZSwgc3VjaCBkZWxheSBjYW4NCmJlIG1pbmltaXplZCwgb3RoZXJ3aXNlIGxvbmdlciBkZWxh
eSBzaGFsbCBiZSBleHBlY3RlZC4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRt
YW5Ad2RjLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCA0MyAr
KysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1t
ZWRpYXRlay5oIHwgIDEgKw0KIDIgZmlsZXMgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgOSBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCAwZmY2NzgxNjU0ZmQu
LmMwZmQ3ZDJlNGQwZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0zMCwxMSArMzAs
NiBAQA0KICNkZWZpbmUgdWZzX210a19kZXZpY2VfcmVzZXRfY3RybChoaWdoLCByZXMpIFwNCiAJ
dWZzX210a19zbWMoVUZTX01US19TSVBfREVWSUNFX1JFU0VULCBoaWdoLCByZXMpDQogDQotI2Rl
ZmluZSB1ZnNfbXRrX3VuaXByb19wb3dlcmRvd24oaGJhLCBwb3dlcmRvd24pIFwNCi0JdWZzaGNk
X2RtZV9zZXQoaGJhLCBcDQotCQkgICAgICAgVUlDX0FSR19NSUJfU0VMKFZTX1VOSVBST1BPV0VS
RE9XTkNPTlRST0wsIDApLCBcDQotCQkgICAgICAgcG93ZXJkb3duKQ0KLQ0KIHN0YXRpYyB2b2lk
IHVmc19tdGtfY2ZnX3VuaXByb19jZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIGVuYWJsZSkN
CiB7DQogCXUzMiB0bXA7DQpAQCAtNzEsNiArNjYsMjEgQEAgc3RhdGljIHZvaWQgdWZzX210a19j
ZmdfdW5pcHJvX2NnKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgZW5hYmxlKQ0KIAl9DQogfQ0K
IA0KK3N0YXRpYyBpbnQgdWZzX210a19oY2VfZW5hYmxlX25vdGlmeShzdHJ1Y3QgdWZzX2hiYSAq
aGJhLA0KKwkJCQkgICAgIGVudW0gdWZzX25vdGlmeV9jaGFuZ2Vfc3RhdHVzIHN0YXR1cykNCit7
DQorCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsN
CisNCisJaWYgKHN0YXR1cyA9PSBQUkVfQ0hBTkdFKSB7DQorCQlpZiAoaG9zdC0+dW5pcHJvX2xw
bSkNCisJCQloYmEtPmhiYV9lbmFibGVfZGVsYXlfdXMgPSAwOw0KKwkJZWxzZQ0KKwkJCWhiYS0+
aGJhX2VuYWJsZV9kZWxheV91cyA9IDYwMDsNCisJfQ0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQog
c3RhdGljIGludCB1ZnNfbXRrX2JpbmRfbXBoeShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJ
c3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KQEAg
LTMyNCwxMiArMzM0LDI2IEBAIHN0YXRpYyBpbnQgdWZzX210a19wd3JfY2hhbmdlX25vdGlmeShz
dHJ1Y3QgdWZzX2hiYSAqaGJhLA0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCitzdGF0aWMgaW50IHVm
c19tdGtfdW5pcHJvX3NldF9wbShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgbHBtKQ0KK3sNCisJ
aW50IHJldDsNCisJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFu
dChoYmEpOw0KKw0KKwlyZXQgPSB1ZnNoY2RfZG1lX3NldChoYmEsDQorCQkJICAgICBVSUNfQVJH
X01JQl9TRUwoVlNfVU5JUFJPUE9XRVJET1dOQ09OVFJPTCwgMCksDQorCQkJICAgICBscG0pOw0K
KwlpZiAoIXJldCkNCisJCWhvc3QtPnVuaXByb19scG0gPSBscG07DQorDQorCXJldHVybiByZXQ7
DQorfQ0KKw0KIHN0YXRpYyBpbnQgdWZzX210a19wcmVfbGluayhzdHJ1Y3QgdWZzX2hiYSAqaGJh
KQ0KIHsNCiAJaW50IHJldDsNCiAJdTMyIHRtcDsNCiANCi0JdWZzX210a191bmlwcm9fcG93ZXJk
b3duKGhiYSwgMCk7DQorCXVmc19tdGtfdW5pcHJvX3NldF9wbShoYmEsIDApOw0KIA0KIAkvKg0K
IAkgKiBTZXR0aW5nIFBBX0xvY2FsX1RYX0xDQ19FbmFibGUgdG8gMCBiZWZvcmUgbGluayBzdGFy
dHVwDQpAQCAtNDM3LDcgKzQ2MSw3IEBAIHN0YXRpYyBpbnQgdWZzX210a19saW5rX3NldF9ocG0o
c3RydWN0IHVmc19oYmEgKmhiYSkNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7DQogDQotCWVy
ciA9IHVmc19tdGtfdW5pcHJvX3Bvd2VyZG93bihoYmEsIDApOw0KKwllcnIgPSB1ZnNfbXRrX3Vu
aXByb19zZXRfcG0oaGJhLCAwKTsNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7DQogDQpAQCAt
NDU4LDEwICs0ODIsMTAgQEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc2V0X2xwbShzdHJ1Y3Qg
dWZzX2hiYSAqaGJhKQ0KIHsNCiAJaW50IGVycjsNCiANCi0JZXJyID0gdWZzX210a191bmlwcm9f
cG93ZXJkb3duKGhiYSwgMSk7DQorCWVyciA9IHVmc19tdGtfdW5pcHJvX3NldF9wbShoYmEsIDEp
Ow0KIAlpZiAoZXJyKSB7DQogCQkvKiBSZXN1bWUgVW5pUHJvIHN0YXRlIGZvciBmb2xsb3dpbmcg
ZXJyb3IgcmVjb3ZlcnkgKi8NCi0JCXVmc19tdGtfdW5pcHJvX3Bvd2VyZG93bihoYmEsIDApOw0K
KwkJdWZzX210a191bmlwcm9fc2V0X3BtKGhiYSwgMCk7DQogCQlyZXR1cm4gZXJyOw0KIAl9DQog
DQpAQCAtNTUyLDYgKzU3Niw3IEBAIHN0YXRpYyBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X29wcyB1
ZnNfaGJhX210a192b3BzID0gew0KIAkubmFtZSAgICAgICAgICAgICAgICA9ICJtZWRpYXRlay51
ZnNoY2kiLA0KIAkuaW5pdCAgICAgICAgICAgICAgICA9IHVmc19tdGtfaW5pdCwNCiAJLnNldHVw
X2Nsb2NrcyAgICAgICAgPSB1ZnNfbXRrX3NldHVwX2Nsb2NrcywNCisJLmhjZV9lbmFibGVfbm90
aWZ5ICAgPSB1ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5LA0KIAkubGlua19zdGFydHVwX25vdGlm
eSA9IHVmc19tdGtfbGlua19zdGFydHVwX25vdGlmeSwNCiAJLnB3cl9jaGFuZ2Vfbm90aWZ5ICAg
PSB1ZnNfbXRrX3B3cl9jaGFuZ2Vfbm90aWZ5LA0KIAkuYXBwbHlfZGV2X3F1aXJrcyAgICA9IHVm
c19tdGtfYXBwbHlfZGV2X3F1aXJrcywNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KaW5kZXggNGM3
ODdiOTlmZTQxLi41YmJkM2U5Y2JhZTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQpAQCAt
OTEsNiArOTEsNyBAQCBlbnVtIHsNCiBzdHJ1Y3QgdWZzX210a19ob3N0IHsNCiAJc3RydWN0IHVm
c19oYmEgKmhiYTsNCiAJc3RydWN0IHBoeSAqbXBoeTsNCisJYm9vbCB1bmlwcm9fbHBtOw0KIAli
b29sIHJlZl9jbGtfZW5hYmxlZDsNCiAJdTE2IHJlZl9jbGtfdW5nYXRpbmdfd2FpdF91czsNCiAJ
dTE2IHJlZl9jbGtfZ2F0aW5nX3dhaXRfdXM7DQotLSANCjIuMTguMA0K

