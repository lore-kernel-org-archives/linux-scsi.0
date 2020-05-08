Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8C8C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD2324958
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="B0rhEwco"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgEHRPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:15:30 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:42130 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727938AbgEHRPY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:15:24 -0400
X-UUID: 39c7f4dc5fae48e5af928e2fa1a74158-20200509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=63Ha8H1vD2DgULJ74Wxv3WLmceNjswpQ6smXNM7kEpI=;
        b=B0rhEwcoHnH9DLOGvX73rxz6/0NorLjMbRA6Kerw3jSGgJMDVyDcqALXL4W/YPLVkc5IZxUc7C/XhUYuFBjPsST4jBsvE22meY53ZJTBQKhMypK5tE6QzjUIlonqghoYSwmfRlbcmKA1T+jG67mPtvwF6o4ycGe0VedY0ma3Fy8=;
X-UUID: 39c7f4dc5fae48e5af928e2fa1a74158-20200509
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 220287682; Sat, 09 May 2020 01:15:18 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 9 May 2020 01:15:10 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 9 May 2020 01:15:11 +0800
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
Subject: [PATCH v1 1/5] scsi: ufs: introduce ufs_hba_variant_params to collect customizable parameters
Date:   Sat, 9 May 2020 01:15:09 +0800
Message-ID: <20200508171513.14665-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200508171513.14665-1-stanley.chu@mediatek.com>
References: <20200508171513.14665-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 739650311132C533E0239377C792F065F22E93209043B0A347B74DED9CE26FAE2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhlcmUgYXJlIG1vcmUgYW5kIG1vcmUgY3VzdG9taXphYmxlIHBhcmFtZXRlcnMgc2hvd2VkIHVw
DQppbiBVRlMgZHJpdmVyLiBMZXQncyBjb2xsZWN0IHRoZW0gaW50byBhbiB1bmlmaWVkIHBsYWNl
IHRvIG1ha2UNCnRoZSBkcml2ZXIgbW9yZSBjbGVhbi4NCg0KU2lnbmVkLW9mZi1ieTogU3Rhbmxl
eSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMgfCAzOCArKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIGRy
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCAgOCArKysrKysrLQ0KIDIgZmlsZXMgY2hhbmdlZCwg
MjIgaW5zZXJ0aW9ucygrKSwgMjQgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggNDI2
MDczYTUxOGVmLi5jZGFjYmU2Mzc4YTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtMTM1MywyMyArMTM1
Myw2IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2RldmZyZXFfZ2V0X2Rldl9zdGF0dXMoc3RydWN0IGRl
dmljZSAqZGV2LA0KIAlyZXR1cm4gMDsNCiB9DQogDQotc3RhdGljIHN0cnVjdCBkZXZmcmVxX2Rl
dl9wcm9maWxlIHVmc19kZXZmcmVxX3Byb2ZpbGUgPSB7DQotCS5wb2xsaW5nX21zCT0gMTAwLA0K
LQkudGFyZ2V0CQk9IHVmc2hjZF9kZXZmcmVxX3RhcmdldCwNCi0JLmdldF9kZXZfc3RhdHVzCT0g
dWZzaGNkX2RldmZyZXFfZ2V0X2Rldl9zdGF0dXMsDQotfTsNCi0NCi0jaWYgSVNfRU5BQkxFRChD
T05GSUdfREVWRlJFUV9HT1ZfU0lNUExFX09OREVNQU5EKQ0KLXN0YXRpYyBzdHJ1Y3QgZGV2ZnJl
cV9zaW1wbGVfb25kZW1hbmRfZGF0YSB1ZnNfb25kZW1hbmRfZGF0YSA9IHsNCi0JLnVwdGhyZXNo
b2xkID0gNzAsDQotCS5kb3duZGlmZmVyZW50aWFsID0gNSwNCi19Ow0KLQ0KLXN0YXRpYyB2b2lk
ICpnb3ZfZGF0YSA9ICZ1ZnNfb25kZW1hbmRfZGF0YTsNCi0jZWxzZQ0KLXN0YXRpYyB2b2lkICpn
b3ZfZGF0YTsgLyogTlVMTCAqLw0KLSNlbmRpZg0KLQ0KIHN0YXRpYyBpbnQgdWZzaGNkX2RldmZy
ZXFfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJc3RydWN0IGxpc3RfaGVhZCAqY2xr
X2xpc3QgPSAmaGJhLT5jbGtfbGlzdF9oZWFkOw0KQEAgLTEzODUsMTIgKzEzNjgsMTIgQEAgc3Rh
dGljIGludCB1ZnNoY2RfZGV2ZnJlcV9pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCWRldl9w
bV9vcHBfYWRkKGhiYS0+ZGV2LCBjbGtpLT5taW5fZnJlcSwgMCk7DQogCWRldl9wbV9vcHBfYWRk
KGhiYS0+ZGV2LCBjbGtpLT5tYXhfZnJlcSwgMCk7DQogDQotCXVmc2hjZF92b3BzX2NvbmZpZ19z
Y2FsaW5nX3BhcmFtKGhiYSwgJnVmc19kZXZmcmVxX3Byb2ZpbGUsDQotCQkJCQkgZ292X2RhdGEp
Ow0KKwl1ZnNoY2Rfdm9wc19jb25maWdfc2NhbGluZ19wYXJhbShoYmEsICZoYmEtPnZwcy0+ZGV2
ZnJlcV9wcm9maWxlLA0KKwkJCQkJICZoYmEtPnZwcy0+b25kZW1hbmRfZGF0YSk7DQogCWRldmZy
ZXEgPSBkZXZmcmVxX2FkZF9kZXZpY2UoaGJhLT5kZXYsDQotCQkJJnVmc19kZXZmcmVxX3Byb2Zp
bGUsDQorCQkJJmhiYS0+dnBzLT5kZXZmcmVxX3Byb2ZpbGUsDQogCQkJREVWRlJFUV9HT1ZfU0lN
UExFX09OREVNQU5ELA0KLQkJCWdvdl9kYXRhKTsNCisJCQkmaGJhLT52cHMtPm9uZGVtYW5kX2Rh
dGEpOw0KIAlpZiAoSVNfRVJSKGRldmZyZXEpKSB7DQogCQlyZXQgPSBQVFJfRVJSKGRldmZyZXEp
Ow0KIAkJZGV2X2VycihoYmEtPmRldiwgIlVuYWJsZSB0byByZWdpc3RlciB3aXRoIGRldmZyZXEg
JWRcbiIsIHJldCk7DQpAQCAtNDMxNCw3ICs0Mjk3LDcgQEAgaW50IHVmc2hjZF9oYmFfZW5hYmxl
KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCSAqIGluc3RydWN0aW9uIG1pZ2h0IGJlIHJlYWQgYmFj
ay4NCiAJICogVGhpcyBkZWxheSBjYW4gYmUgY2hhbmdlZCBiYXNlZCBvbiB0aGUgY29udHJvbGxl
ci4NCiAJICovDQotCXVmc2hjZF9kZWxheV91cyhoYmEtPmhiYV9lbmFibGVfZGVsYXlfdXMsIDEw
MCk7DQorCXVmc2hjZF9kZWxheV91cyhoYmEtPnZwcy0+aGJhX2VuYWJsZV9kZWxheV91cywgMTAw
KTsNCiANCiAJLyogd2FpdCBmb3IgdGhlIGhvc3QgY29udHJvbGxlciB0byBjb21wbGV0ZSBpbml0
aWFsaXphdGlvbiAqLw0KIAlyZXRyeSA9IDUwOw0KQEAgLTc0NzcsNiArNzQ2MCwxNSBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IGF0dHJpYnV0ZV9ncm91cCAqdWZzaGNkX2RyaXZlcl9ncm91cHNbXSA9
IHsNCiAJTlVMTCwNCiB9Ow0KIA0KK3N0YXRpYyBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X3BhcmFt
cyB1ZnNfaGJhX3ZwcyA9IHsNCisJLmhiYV9lbmFibGVfZGVsYXlfdXMJCT0gMTAwMCwNCisJLmRl
dmZyZXFfcHJvZmlsZS5wb2xsaW5nX21zCT0gMTAwLA0KKwkuZGV2ZnJlcV9wcm9maWxlLnRhcmdl
dAkJPSB1ZnNoY2RfZGV2ZnJlcV90YXJnZXQsDQorCS5kZXZmcmVxX3Byb2ZpbGUuZ2V0X2Rldl9z
dGF0dXMJPSB1ZnNoY2RfZGV2ZnJlcV9nZXRfZGV2X3N0YXR1cywNCisJLm9uZGVtYW5kX2RhdGEu
dXB0aHJlc2hvbGQJPSA3MCwNCisJLm9uZGVtYW5kX2RhdGEuZG93bmRpZmZlcmVudGlhbAk9IDUs
DQorfTsNCisNCiBzdGF0aWMgc3RydWN0IHNjc2lfaG9zdF90ZW1wbGF0ZSB1ZnNoY2RfZHJpdmVy
X3RlbXBsYXRlID0gew0KIAkubW9kdWxlCQkJPSBUSElTX01PRFVMRSwNCiAJLm5hbWUJCQk9IFVG
U0hDRCwNCkBAIC04NzI0LDcgKzg3MTYsNyBAQCBpbnQgdWZzaGNkX2luaXQoc3RydWN0IHVmc19o
YmEgKmhiYSwgdm9pZCBfX2lvbWVtICptbWlvX2Jhc2UsIHVuc2lnbmVkIGludCBpcnEpDQogDQog
CWhiYS0+bW1pb19iYXNlID0gbW1pb19iYXNlOw0KIAloYmEtPmlycSA9IGlycTsNCi0JaGJhLT5o
YmFfZW5hYmxlX2RlbGF5X3VzID0gMTAwMDsNCisJaGJhLT52cHMgPSAmdWZzX2hiYV92cHM7DQog
DQogCWVyciA9IHVmc2hjZF9oYmFfaW5pdChoYmEpOw0KIAlpZiAoZXJyKQ0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpp
bmRleCAyM2E0MzRjMDNjMmEuLmY3YmRmNTJiYThiMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCkBAIC01NjYs
NiArNTY2LDEyIEBAIGVudW0gdWZzaGNkX2NhcHMgew0KIAlVRlNIQ0RfQ0FQX1dCX0VOCQkJCT0g
MSA8PCA3LA0KIH07DQogDQorc3RydWN0IHVmc19oYmFfdmFyaWFudF9wYXJhbXMgew0KKwlzdHJ1
Y3QgZGV2ZnJlcV9kZXZfcHJvZmlsZSBkZXZmcmVxX3Byb2ZpbGU7DQorCXN0cnVjdCBkZXZmcmVx
X3NpbXBsZV9vbmRlbWFuZF9kYXRhIG9uZGVtYW5kX2RhdGE7DQorCXUxNiBoYmFfZW5hYmxlX2Rl
bGF5X3VzOw0KK307DQorDQogLyoqDQogICogc3RydWN0IHVmc19oYmEgLSBwZXIgYWRhcHRlciBw
cml2YXRlIHN0cnVjdHVyZQ0KICAqIEBtbWlvX2Jhc2U6IFVGU0hDSSBiYXNlIHJlZ2lzdGVyIGFk
ZHJlc3MNCkBAIC02NjMsNiArNjY5LDcgQEAgc3RydWN0IHVmc19oYmEgew0KIAlpbnQgbnV0bXJz
Ow0KIAl1MzIgdWZzX3ZlcnNpb247DQogCWNvbnN0IHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3Bz
ICp2b3BzOw0KKwlzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X3BhcmFtcyAqdnBzOw0KIAl2b2lkICpw
cml2Ow0KIAl1bnNpZ25lZCBpbnQgaXJxOw0KIAlib29sIGlzX2lycV9lbmFibGVkOw0KQEAgLTY4
NCw3ICs2OTEsNiBAQCBzdHJ1Y3QgdWZzX2hiYSB7DQogCXUzMiBlaF9mbGFnczsNCiAJdTMyIGlu
dHJfbWFzazsNCiAJdTE2IGVlX2N0cmxfbWFzazsNCi0JdTE2IGhiYV9lbmFibGVfZGVsYXlfdXM7
DQogCWJvb2wgaXNfcG93ZXJlZDsNCiANCiAJLyogV29yayBRdWV1ZXMgKi8NCi0tIA0KMi4xOC4w
DQo=

