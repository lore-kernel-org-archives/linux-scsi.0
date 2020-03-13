Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4410CC4CECE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10B3320749
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:01:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KJBEab5i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCMJBd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 05:01:33 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:47666 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726477AbgCMJBa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 05:01:30 -0400
X-UUID: 595db0c9b32647f89175d7b12988628d-20200313
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=QqYl5LbBQOmFjlV2531kF8pt73Ft9iKLdEjT8hrrzj0=;
        b=KJBEab5id3u03qcVueQav1dvRvsp8vT2uH28Q/gQ1iMfcRD0j9LeM81YFGU4LTVbm7O6OILDES6Qv/ocRZIXJwXrDsBCn0ysDAgzXGgayv2Vd2778/zhgzgD9Ng5vJeSEEMQAQn1nSeCvNp5iVARkApc4YtGLNVTAeX48REmvdI=;
X-UUID: 595db0c9b32647f89175d7b12988628d-20200313
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 385964533; Fri, 13 Mar 2020 17:01:23 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 13 Mar 2020 16:59:10 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 13 Mar 2020 17:00:33 +0800
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
Subject: [PATCH v4 8/8] scsi: ufs-mediatek: customize the delay for host enabling
Date:   Fri, 13 Mar 2020 17:01:03 +0800
Message-ID: <20200313090103.15390-9-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200313090103.15390-1-stanley.chu@mediatek.com>
References: <20200313090103.15390-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
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
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgfCA0MyArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0NCiBkcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5oIHwgIDEgKw0KIDIgZmlsZXMgY2hhbmdlZCwgMzUgaW5zZXJ0aW9u
cygrKSwgOSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
LW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCAwZmY2
NzgxNjU0ZmQuLmMwZmQ3ZDJlNGQwZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
LW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0z
MCwxMSArMzAsNiBAQA0KICNkZWZpbmUgdWZzX210a19kZXZpY2VfcmVzZXRfY3RybChoaWdoLCBy
ZXMpIFwNCiAJdWZzX210a19zbWMoVUZTX01US19TSVBfREVWSUNFX1JFU0VULCBoaWdoLCByZXMp
DQogDQotI2RlZmluZSB1ZnNfbXRrX3VuaXByb19wb3dlcmRvd24oaGJhLCBwb3dlcmRvd24pIFwN
Ci0JdWZzaGNkX2RtZV9zZXQoaGJhLCBcDQotCQkgICAgICAgVUlDX0FSR19NSUJfU0VMKFZTX1VO
SVBST1BPV0VSRE9XTkNPTlRST0wsIDApLCBcDQotCQkgICAgICAgcG93ZXJkb3duKQ0KLQ0KIHN0
YXRpYyB2b2lkIHVmc19tdGtfY2ZnX3VuaXByb19jZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29s
IGVuYWJsZSkNCiB7DQogCXUzMiB0bXA7DQpAQCAtNzEsNiArNjYsMjEgQEAgc3RhdGljIHZvaWQg
dWZzX210a19jZmdfdW5pcHJvX2NnKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgZW5hYmxlKQ0K
IAl9DQogfQ0KIA0KK3N0YXRpYyBpbnQgdWZzX210a19oY2VfZW5hYmxlX25vdGlmeShzdHJ1Y3Qg
dWZzX2hiYSAqaGJhLA0KKwkJCQkgICAgIGVudW0gdWZzX25vdGlmeV9jaGFuZ2Vfc3RhdHVzIHN0
YXR1cykNCit7DQorCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3Zhcmlh
bnQoaGJhKTsNCisNCisJaWYgKHN0YXR1cyA9PSBQUkVfQ0hBTkdFKSB7DQorCQlpZiAoaG9zdC0+
dW5pcHJvX2xwbSkNCisJCQloYmEtPmhiYV9lbmFibGVfZGVsYXlfdXMgPSAwOw0KKwkJZWxzZQ0K
KwkJCWhiYS0+aGJhX2VuYWJsZV9kZWxheV91cyA9IDYwMDsNCisJfQ0KKw0KKwlyZXR1cm4gMDsN
Cit9DQorDQogc3RhdGljIGludCB1ZnNfbXRrX2JpbmRfbXBoeShzdHJ1Y3QgdWZzX2hiYSAqaGJh
KQ0KIHsNCiAJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudCho
YmEpOw0KQEAgLTMyNCwxMiArMzM0LDI2IEBAIHN0YXRpYyBpbnQgdWZzX210a19wd3JfY2hhbmdl
X25vdGlmeShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCitzdGF0
aWMgaW50IHVmc19tdGtfdW5pcHJvX3NldF9wbShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgbHBt
KQ0KK3sNCisJaW50IHJldDsNCisJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9n
ZXRfdmFyaWFudChoYmEpOw0KKw0KKwlyZXQgPSB1ZnNoY2RfZG1lX3NldChoYmEsDQorCQkJICAg
ICBVSUNfQVJHX01JQl9TRUwoVlNfVU5JUFJPUE9XRVJET1dOQ09OVFJPTCwgMCksDQorCQkJICAg
ICBscG0pOw0KKwlpZiAoIXJldCkNCisJCWhvc3QtPnVuaXByb19scG0gPSBscG07DQorDQorCXJl
dHVybiByZXQ7DQorfQ0KKw0KIHN0YXRpYyBpbnQgdWZzX210a19wcmVfbGluayhzdHJ1Y3QgdWZz
X2hiYSAqaGJhKQ0KIHsNCiAJaW50IHJldDsNCiAJdTMyIHRtcDsNCiANCi0JdWZzX210a191bmlw
cm9fcG93ZXJkb3duKGhiYSwgMCk7DQorCXVmc19tdGtfdW5pcHJvX3NldF9wbShoYmEsIDApOw0K
IA0KIAkvKg0KIAkgKiBTZXR0aW5nIFBBX0xvY2FsX1RYX0xDQ19FbmFibGUgdG8gMCBiZWZvcmUg
bGluayBzdGFydHVwDQpAQCAtNDM3LDcgKzQ2MSw3IEBAIHN0YXRpYyBpbnQgdWZzX210a19saW5r
X3NldF9ocG0oc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7
DQogDQotCWVyciA9IHVmc19tdGtfdW5pcHJvX3Bvd2VyZG93bihoYmEsIDApOw0KKwllcnIgPSB1
ZnNfbXRrX3VuaXByb19zZXRfcG0oaGJhLCAwKTsNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7
DQogDQpAQCAtNDU4LDEwICs0ODIsMTAgQEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc2V0X2xw
bShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJaW50IGVycjsNCiANCi0JZXJyID0gdWZzX210
a191bmlwcm9fcG93ZXJkb3duKGhiYSwgMSk7DQorCWVyciA9IHVmc19tdGtfdW5pcHJvX3NldF9w
bShoYmEsIDEpOw0KIAlpZiAoZXJyKSB7DQogCQkvKiBSZXN1bWUgVW5pUHJvIHN0YXRlIGZvciBm
b2xsb3dpbmcgZXJyb3IgcmVjb3ZlcnkgKi8NCi0JCXVmc19tdGtfdW5pcHJvX3Bvd2VyZG93biho
YmEsIDApOw0KKwkJdWZzX210a191bmlwcm9fc2V0X3BtKGhiYSwgMCk7DQogCQlyZXR1cm4gZXJy
Ow0KIAl9DQogDQpAQCAtNTUyLDYgKzU3Niw3IEBAIHN0YXRpYyBzdHJ1Y3QgdWZzX2hiYV92YXJp
YW50X29wcyB1ZnNfaGJhX210a192b3BzID0gew0KIAkubmFtZSAgICAgICAgICAgICAgICA9ICJt
ZWRpYXRlay51ZnNoY2kiLA0KIAkuaW5pdCAgICAgICAgICAgICAgICA9IHVmc19tdGtfaW5pdCwN
CiAJLnNldHVwX2Nsb2NrcyAgICAgICAgPSB1ZnNfbXRrX3NldHVwX2Nsb2NrcywNCisJLmhjZV9l
bmFibGVfbm90aWZ5ICAgPSB1ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5LA0KIAkubGlua19zdGFy
dHVwX25vdGlmeSA9IHVmc19tdGtfbGlua19zdGFydHVwX25vdGlmeSwNCiAJLnB3cl9jaGFuZ2Vf
bm90aWZ5ICAgPSB1ZnNfbXRrX3B3cl9jaGFuZ2Vfbm90aWZ5LA0KIAkuYXBwbHlfZGV2X3F1aXJr
cyAgICA9IHVmc19tdGtfYXBwbHlfZGV2X3F1aXJrcywNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0K
aW5kZXggNGM3ODdiOTlmZTQxLi41YmJkM2U5Y2JhZTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5oDQpAQCAtOTEsNiArOTEsNyBAQCBlbnVtIHsNCiBzdHJ1Y3QgdWZzX210a19ob3N0IHsNCiAJ
c3RydWN0IHVmc19oYmEgKmhiYTsNCiAJc3RydWN0IHBoeSAqbXBoeTsNCisJYm9vbCB1bmlwcm9f
bHBtOw0KIAlib29sIHJlZl9jbGtfZW5hYmxlZDsNCiAJdTE2IHJlZl9jbGtfdW5nYXRpbmdfd2Fp
dF91czsNCiAJdTE2IHJlZl9jbGtfZ2F0aW5nX3dhaXRfdXM7DQotLSANCjIuMTguMA0K

