Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A172AC3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BDB42078E
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:56:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Olq7VTI+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgEDO4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:56:40 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:13574 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728670AbgEDO4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:56:38 -0400
X-UUID: b2b2bcd21f0745f7864b1191a0b9b06f-20200504
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=oYb9PFqjqE/KoCvHkIntKx9i9T96QnuZz4NrEZU/ixU=;
        b=Olq7VTI+t8kOsMWOz/70dIKF2zKvmep7kRjBGcYeGEyRvgTbH/XInI3S2qtkDozoHfV3Y5InIQtx+AR4ChYrEoOgC5vz50WEopeRhggsXN1scWp9q9F2acpZ+JKfgoq5E5v6DbfQqB4sb68seY+jahSz4hvOuMyeRGzwTDO2pVs=;
X-UUID: b2b2bcd21f0745f7864b1191a0b9b06f-20200504
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 342181820; Mon, 04 May 2020 22:56:31 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 4 May 2020 22:56:26 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 4 May 2020 22:56:26 +0800
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
Subject: [PATCH v6 1/8] scsi: ufs: enable WriteBooster on some pre-3.1 UFS devices
Date:   Mon, 4 May 2020 22:56:15 +0800
Message-ID: <20200504145622.13895-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200504145622.13895-1-stanley.chu@mediatek.com>
References: <20200504145622.13895-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 6206C090CA6B8FC9CD187CD627966DEA89DBA878830285252801B2B13B7A3ECB2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

V3JpdGVCb29zdGVyIGZlYXR1cmUgY2FuIGJlIHN1cHBvcnRlZCBieSBzb21lIHByZS0zLjEgVUZT
IGRldmljZXMNCmJ5IHVwZ3JhZGluZyBmaXJtd2FyZS4NCg0KVG8gZW5hYmxlIFdyaXRlQm9vc3Rl
ciBmZWF0dXJlIGluIHN1Y2ggZGV2aWNlcywgaW50cm9kdWNlIGEgZGV2aWNlDQpxdWlyayB0byBy
ZWxheCB0aGUgZW50cmFuY2UgY29uZGl0aW9uIG9mIHVmc2hjZF93Yl9wcm9iZSgpIHRvIGFsbG93
DQpob3N0IGRyaXZlciB0byBjaGVjayB0aG9zZSBkZXZpY2VzJyBXcml0ZUJvb3N0ZXIgY2FwYWJp
bGl0eS4NCg0KV3JpdGVCb29zdGVyIGZlYXR1cmUgY2FuIGJlIGF2YWlsYWJsZSBpZiBiZWxvdyBh
bGwgY29uZGl0aW9ucyBhcmUNCnNhdGlzZmllZCwNCg0KMS4gSG9zdCBlbmFibGVzIFdyaXRlQm9v
c3RlciBjYXBhYmlsaXR5DQoyLiBVRlMgMy4xIGRldmljZSBvciBVRlMgcHJlLTMuMSBkZXZpY2Ug
d2l0aCBxdWlyaw0KICAgVUZTX0RFVklDRV9RVUlSS19TVVBQT1JUX0VYVEVOREVEX0ZFQVRVUkVT
IGVuYWJsZWQNCjMuIFdyaXRlQm9vc3RlciBzdXBwb3J0IGlzIHNwZWNpZmllZCBpbiBhYm92ZSBm
aWVsZA0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsu
Y29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmggfCAgNyArKysrDQogZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgfCA2NCArKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLS0tLS0tLQ0KIDIgZmlsZXMgY2hhbmdlZCwgNDYgaW5zZXJ0aW9ucygrKSwgMjUgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaCBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzX3F1aXJrcy5oDQppbmRleCBkZjdhMWU2ODA1YTMuLmUzMTc1YTYz
YzY3NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzX3F1aXJrcy5oDQorKysgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaA0KQEAgLTEwMSw0ICsxMDEsMTEgQEAgc3RydWN0
IHVmc19kZXZfZml4IHsNCiAgKi8NCiAjZGVmaW5lIFVGU19ERVZJQ0VfUVVJUktfSE9TVF9WU19E
RUJVR1NBVkVDT05GSUdUSU1FCSgxIDw8IDkpDQogDQorLyoNCisgKiBTb21lIHByZS0zLjEgVUZT
IGRldmljZXMgY2FuIHN1cHBvcnQgZXh0ZW5kZWQgZmVhdHVyZXMgYnkgdXBncmFkaW5nDQorICog
dGhlIGZpcm13YXJlLiBFbmFibGUgdGhpcyBxdWlyayB0byBtYWtlIFVGUyBjb3JlIGRyaXZlciBw
cm9iZSBhbmQgZW5hYmxlDQorICogc3VwcG9ydGVkIGZlYXR1cmVzIG9uIHN1Y2ggZGV2aWNlcy4N
CisgKi8NCisjZGVmaW5lIFVGU19ERVZJQ0VfUVVJUktfU1VQUE9SVF9FWFRFTkRFRF9GRUFUVVJF
UyAoMSA8PCAxMCkNCisNCiAjZW5kaWYgLyogVUZTX1FVSVJLU19IXyAqLw0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpp
bmRleCA5MTVlOTYzMzk4YzQuLjMxNDExZmQ4Nzc5NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC02ODAw
LDkgKzY4MDAsMTYgQEAgc3RhdGljIGludCB1ZnNoY2Rfc2NzaV9hZGRfd2x1cyhzdHJ1Y3QgdWZz
X2hiYSAqaGJhKQ0KIA0KIHN0YXRpYyB2b2lkIHVmc2hjZF93Yl9wcm9iZShzdHJ1Y3QgdWZzX2hi
YSAqaGJhLCB1OCAqZGVzY19idWYpDQogew0KKwlpZiAoIXVmc2hjZF9pc193Yl9hbGxvd2VkKGhi
YSkpDQorCQlyZXR1cm47DQorDQogCWhiYS0+ZGV2X2luZm8uZF9leHRfdWZzX2ZlYXR1cmVfc3Vw
ID0NCiAJCWdldF91bmFsaWduZWRfYmUzMihkZXNjX2J1ZiArDQogCQkJCSAgIERFVklDRV9ERVND
X1BBUkFNX0VYVF9VRlNfRkVBVFVSRV9TVVApOw0KKw0KKwlpZiAoIShoYmEtPmRldl9pbmZvLmRf
ZXh0X3Vmc19mZWF0dXJlX3N1cCAmIFVGU19ERVZfV1JJVEVfQk9PU1RFUl9TVVApKQ0KKwkJZ290
byB3Yl9kaXNhYmxlZDsNCisNCiAJLyoNCiAJICogV0IgbWF5IGJlIHN1cHBvcnRlZCBidXQgbm90
IGNvbmZpZ3VyZWQgd2hpbGUgcHJvdmlzaW9uaW5nLg0KIAkgKiBUaGUgc3BlYyBzYXlzLCBpbiBk
ZWRpY2F0ZWQgd2IgYnVmZmVyIG1vZGUsDQpAQCAtNjgxOCwxMSArNjgyNSwyOSBAQCBzdGF0aWMg
dm9pZCB1ZnNoY2Rfd2JfcHJvYmUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTggKmRlc2NfYnVmKQ0K
IAloYmEtPmRldl9pbmZvLmJfcHJlc3J2X3VzcGNfZW4gPQ0KIAkJZGVzY19idWZbREVWSUNFX0RF
U0NfUEFSQU1fV0JfUFJFU1JWX1VTUlNQQ19FTl07DQogDQotCWlmICghKChoYmEtPmRldl9pbmZv
LmRfZXh0X3Vmc19mZWF0dXJlX3N1cCAmDQotCQkgVUZTX0RFVl9XUklURV9CT09TVEVSX1NVUCkg
JiYNCi0JCWhiYS0+ZGV2X2luZm8uYl93Yl9idWZmZXJfdHlwZSAmJg0KKwlpZiAoIShoYmEtPmRl
dl9pbmZvLmJfd2JfYnVmZmVyX3R5cGUgJiYNCiAJICAgICAgaGJhLT5kZXZfaW5mby5kX3diX2Fs
bG9jX3VuaXRzKSkNCi0JCWhiYS0+Y2FwcyAmPSB+VUZTSENEX0NBUF9XQl9FTjsNCisJCWdvdG8g
d2JfZGlzYWJsZWQ7DQorDQorCXJldHVybjsNCisNCit3Yl9kaXNhYmxlZDoNCisJaGJhLT5jYXBz
ICY9IH5VRlNIQ0RfQ0FQX1dCX0VOOw0KK30NCisNCitzdGF0aWMgdm9pZCB1ZnNfZml4dXBfZGV2
aWNlX3NldHVwKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQorew0KKwlzdHJ1Y3QgdWZzX2Rldl9maXgg
KmY7DQorCXN0cnVjdCB1ZnNfZGV2X2luZm8gKmRldl9pbmZvID0gJmhiYS0+ZGV2X2luZm87DQor
DQorCWZvciAoZiA9IHVmc19maXh1cHM7IGYtPnF1aXJrOyBmKyspIHsNCisJCWlmICgoZi0+d21h
bnVmYWN0dXJlcmlkID09IGRldl9pbmZvLT53bWFudWZhY3R1cmVyaWQgfHwNCisJCSAgICAgZi0+
d21hbnVmYWN0dXJlcmlkID09IFVGU19BTllfVkVORE9SKSAmJg0KKwkJICAgICAoKGRldl9pbmZv
LT5tb2RlbCAmJg0KKwkJICAgICAgIFNUUl9QUkZYX0VRVUFMKGYtPm1vZGVsLCBkZXZfaW5mby0+
bW9kZWwpKSB8fA0KKwkJICAgICAgIXN0cmNtcChmLT5tb2RlbCwgVUZTX0FOWV9NT0RFTCkpKQ0K
KwkJCWhiYS0+ZGV2X3F1aXJrcyB8PSBmLT5xdWlyazsNCisJfQ0KIH0NCiANCiBzdGF0aWMgaW50
IHVmc19nZXRfZGV2aWNlX2Rlc2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCkBAIC02ODYyLDEwICs2
ODg3LDYgQEAgc3RhdGljIGludCB1ZnNfZ2V0X2RldmljZV9kZXNjKHN0cnVjdCB1ZnNfaGJhICpo
YmEpDQogDQogCW1vZGVsX2luZGV4ID0gZGVzY19idWZbREVWSUNFX0RFU0NfUEFSQU1fUFJEQ1Rf
TkFNRV07DQogDQotCS8qIEVuYWJsZSBXQiBvbmx5IGZvciBVRlMtMy4xICovDQotCWlmIChkZXZf
aW5mby0+d3NwZWN2ZXJzaW9uID49IDB4MzEwKQ0KLQkJdWZzaGNkX3diX3Byb2JlKGhiYSwgZGVz
Y19idWYpOw0KLQ0KIAllcnIgPSB1ZnNoY2RfcmVhZF9zdHJpbmdfZGVzYyhoYmEsIG1vZGVsX2lu
ZGV4LA0KIAkJCQkgICAgICAmZGV2X2luZm8tPm1vZGVsLCBTRF9BU0NJSV9TVEQpOw0KIAlpZiAo
ZXJyIDwgMCkgew0KQEAgLTY4NzQsNiArNjg5NSwxNiBAQCBzdGF0aWMgaW50IHVmc19nZXRfZGV2
aWNlX2Rlc2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJCWdvdG8gb3V0Ow0KIAl9DQogDQorCXVm
c19maXh1cF9kZXZpY2Vfc2V0dXAoaGJhKTsNCisNCisJLyoNCisJICogUHJvYmUgV0Igb25seSBm
b3IgVUZTLTMuMSBkZXZpY2VzIG9yIFVGUyBkZXZpY2VzIHdpdGggcXVpcmsNCisJICogVUZTX0RF
VklDRV9RVUlSS19TVVBQT1JUX0VYVEVOREVEX0ZFQVRVUkVTIGVuYWJsZWQNCisJICovDQorCWlm
IChkZXZfaW5mby0+d3NwZWN2ZXJzaW9uID49IDB4MzEwIHx8DQorCSAgICAoaGJhLT5kZXZfcXVp
cmtzICYgVUZTX0RFVklDRV9RVUlSS19TVVBQT1JUX0VYVEVOREVEX0ZFQVRVUkVTKSkNCisJCXVm
c2hjZF93Yl9wcm9iZShoYmEsIGRlc2NfYnVmKTsNCisNCiAJLyoNCiAJICogdWZzaGNkX3JlYWRf
c3RyaW5nX2Rlc2MgcmV0dXJucyBzaXplIG9mIHRoZSBzdHJpbmcNCiAJICogcmVzZXQgdGhlIGVy
cm9yIHZhbHVlDQpAQCAtNjg5MywyMSArNjkyNCw2IEBAIHN0YXRpYyB2b2lkIHVmc19wdXRfZGV2
aWNlX2Rlc2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJZGV2X2luZm8tPm1vZGVsID0gTlVMTDsN
CiB9DQogDQotc3RhdGljIHZvaWQgdWZzX2ZpeHVwX2RldmljZV9zZXR1cChzdHJ1Y3QgdWZzX2hi
YSAqaGJhKQ0KLXsNCi0Jc3RydWN0IHVmc19kZXZfZml4ICpmOw0KLQlzdHJ1Y3QgdWZzX2Rldl9p
bmZvICpkZXZfaW5mbyA9ICZoYmEtPmRldl9pbmZvOw0KLQ0KLQlmb3IgKGYgPSB1ZnNfZml4dXBz
OyBmLT5xdWlyazsgZisrKSB7DQotCQlpZiAoKGYtPndtYW51ZmFjdHVyZXJpZCA9PSBkZXZfaW5m
by0+d21hbnVmYWN0dXJlcmlkIHx8DQotCQkgICAgIGYtPndtYW51ZmFjdHVyZXJpZCA9PSBVRlNf
QU5ZX1ZFTkRPUikgJiYNCi0JCSAgICAgKChkZXZfaW5mby0+bW9kZWwgJiYNCi0JCSAgICAgICBT
VFJfUFJGWF9FUVVBTChmLT5tb2RlbCwgZGV2X2luZm8tPm1vZGVsKSkgfHwNCi0JCSAgICAgICFz
dHJjbXAoZi0+bW9kZWwsIFVGU19BTllfTU9ERUwpKSkNCi0JCQloYmEtPmRldl9xdWlya3MgfD0g
Zi0+cXVpcms7DQotCX0NCi19DQotDQogLyoqDQogICogdWZzaGNkX3R1bmVfcGFfdGFjdGl2YXRl
IC0gVHVuZXMgUEFfVEFjdGl2YXRlIG9mIGxvY2FsIFVuaVBybw0KICAqIEBoYmE6IHBlci1hZGFw
dGVyIGluc3RhbmNlDQpAQCAtNzI0NCw4ICs3MjYwLDYgQEAgc3RhdGljIGludCB1ZnNoY2RfZGV2
aWNlX3BhcmFtc19pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogDQogCXVmc2hjZF9nZXRfcmVm
X2Nsa19nYXRpbmdfd2FpdChoYmEpOw0KIA0KLQl1ZnNfZml4dXBfZGV2aWNlX3NldHVwKGhiYSk7
DQotDQogCWlmICghdWZzaGNkX3F1ZXJ5X2ZsYWdfcmV0cnkoaGJhLCBVUElVX1FVRVJZX09QQ09E
RV9SRUFEX0ZMQUcsDQogCQkJUVVFUllfRkxBR19JRE5fUFdSX09OX1dQRSwgJmZsYWcpKQ0KIAkJ
aGJhLT5kZXZfaW5mby5mX3Bvd2VyX29uX3dwX2VuID0gZmxhZzsNCi0tIA0KMi4xOC4wDQo=

