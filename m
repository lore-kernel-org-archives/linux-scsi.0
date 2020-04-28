Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFC0C83004
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 11:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63ED92073C
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 11:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XvUpf2Wm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD1LOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 07:14:04 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:44652 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726360AbgD1LOD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 07:14:03 -0400
X-UUID: 38b8192a9f1c43a2996b86c23eea37c3-20200428
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=gOI57n0NCChF2mdMfypGPNHt6U2F7UjicizaaWMiXU8=;
        b=XvUpf2WmYG5L8b/CX0IBLmFky2Yb92ymAhYSSV2AVf+QN7iD5KC0ugzRB1Fgf8vyHGpasw56eIHwB31HVrdS/IydKe9zqftEYj7i3IlA7Gyy+P4AzdJWyXDbpEUnCW9naBEOBHWAOeo2E1D7EkxVVXmh+sAw7gcjia8YYOb8k20=;
X-UUID: 38b8192a9f1c43a2996b86c23eea37c3-20200428
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 841158562; Tue, 28 Apr 2020 19:13:58 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 28 Apr 2020 19:13:55 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Apr 2020 19:13:53 +0800
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
Subject: [PATCH v1 1/4] scsi: ufs: allow legacy UFS devices to enable WriteBooster
Date:   Tue, 28 Apr 2020 19:13:52 +0800
Message-ID: <20200428111355.1776-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200428111355.1776-1-stanley.chu@mediatek.com>
References: <20200428111355.1776-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: AC2CEAEB40CCCB9E644C7A17A45E30E1A5213F587BCD3BC5704A675A73F2016B2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

V3JpdGVCb29zdGVyIGZlYXR1cmUgbWF5IGJlIHN1cHBvcnRlZCBieSBzb21lIGxlZ2FjeSBVRlMg
ZGV2aWNlcw0KKGkuZS4sIDwgMy4xKSBieSB1cGdyYWRpbmcgZmlybXdhcmUuDQoNClRvIGVuYWJs
ZSBXcml0ZUJvb3N0ZXIgZmVhdHVyZSBpbiBzdWNoIGRldmljZXMsIHJlbGF4IHRoZSBlbnRyYW5j
ZQ0KY29uZGl0aW9uIG9mIHVmc2hjZF93Yl9wcm9iZSgpIHRvIGFsbG93IGhvc3QgZHJpdmVyIHRv
IGNoZWNrIHRob3NlDQpkZXZpY2VzJyBXcml0ZUJvb3N0ZXIgY2FwYWJpbGl0eS4NCg0KV3JpdGVC
b29zdGVyIGZlYXR1cmUgY2FuIGJlIGF2YWlsYWJsZSBpZiBiZWxvdyBib3RoIGNvbmRpdGlvbnMg
YXJlDQpzYXRpc2ZpZWQsDQoNCjEuIERldmljZSBkZXNjcmlwdG9yIGhhcyBkRXh0ZW5kZWRVRlNG
ZWF0dXJlc1N1cHBvcnQgZmllbGQuDQoyLiBXcml0ZUJvb3N0ZXIgc3VwcG9ydCBpcyBzcGVjaWZp
ZWQgaW4gYWJvdmUgZmllbGQuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5
LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMTkg
KysrKysrKysrKysrKy0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCA2
IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IDkxNWU5NjMzOThjNC4uMTExODEyYzUz
MDRhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTY4MDAsOSArNjgwMCwxNiBAQCBzdGF0aWMgaW50IHVm
c2hjZF9zY3NpX2FkZF93bHVzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogDQogc3RhdGljIHZvaWQg
dWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4ICpkZXNjX2J1ZikNCiB7DQor
CWlmIChoYmEtPmRlc2Nfc2l6ZS5kZXZfZGVzYyA8PSBERVZJQ0VfREVTQ19QQVJBTV9FWFRfVUZT
X0ZFQVRVUkVfU1VQKQ0KKwkJZ290byB3Yl9kaXNhYmxlZDsNCisNCiAJaGJhLT5kZXZfaW5mby5k
X2V4dF91ZnNfZmVhdHVyZV9zdXAgPQ0KIAkJZ2V0X3VuYWxpZ25lZF9iZTMyKGRlc2NfYnVmICsN
CiAJCQkJICAgREVWSUNFX0RFU0NfUEFSQU1fRVhUX1VGU19GRUFUVVJFX1NVUCk7DQorDQorCWlm
ICghKGhiYS0+ZGV2X2luZm8uZF9leHRfdWZzX2ZlYXR1cmVfc3VwICYgVUZTX0RFVl9XUklURV9C
T09TVEVSX1NVUCkpDQorCQlnb3RvIHdiX2Rpc2FibGVkOw0KKw0KIAkvKg0KIAkgKiBXQiBtYXkg
YmUgc3VwcG9ydGVkIGJ1dCBub3QgY29uZmlndXJlZCB3aGlsZSBwcm92aXNpb25pbmcuDQogCSAq
IFRoZSBzcGVjIHNheXMsIGluIGRlZGljYXRlZCB3YiBidWZmZXIgbW9kZSwNCkBAIC02ODE4LDEx
ICs2ODI1LDEyIEBAIHN0YXRpYyB2b2lkIHVmc2hjZF93Yl9wcm9iZShzdHJ1Y3QgdWZzX2hiYSAq
aGJhLCB1OCAqZGVzY19idWYpDQogCWhiYS0+ZGV2X2luZm8uYl9wcmVzcnZfdXNwY19lbiA9DQog
CQlkZXNjX2J1ZltERVZJQ0VfREVTQ19QQVJBTV9XQl9QUkVTUlZfVVNSU1BDX0VOXTsNCiANCi0J
aWYgKCEoKGhiYS0+ZGV2X2luZm8uZF9leHRfdWZzX2ZlYXR1cmVfc3VwICYNCi0JCSBVRlNfREVW
X1dSSVRFX0JPT1NURVJfU1VQKSAmJg0KLQkJaGJhLT5kZXZfaW5mby5iX3diX2J1ZmZlcl90eXBl
ICYmDQorCWlmICghKGhiYS0+ZGV2X2luZm8uYl93Yl9idWZmZXJfdHlwZSAmJg0KIAkgICAgICBo
YmEtPmRldl9pbmZvLmRfd2JfYWxsb2NfdW5pdHMpKQ0KLQkJaGJhLT5jYXBzICY9IH5VRlNIQ0Rf
Q0FQX1dCX0VOOw0KKwkJZ290byB3Yl9kaXNhYmxlZDsNCisNCit3Yl9kaXNhYmxlZDoNCisJaGJh
LT5jYXBzICY9IH5VRlNIQ0RfQ0FQX1dCX0VOOw0KIH0NCiANCiBzdGF0aWMgaW50IHVmc19nZXRf
ZGV2aWNlX2Rlc2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCkBAIC02ODYyLDggKzY4NzAsNyBAQCBz
dGF0aWMgaW50IHVmc19nZXRfZGV2aWNlX2Rlc2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCiANCiAJ
bW9kZWxfaW5kZXggPSBkZXNjX2J1ZltERVZJQ0VfREVTQ19QQVJBTV9QUkRDVF9OQU1FXTsNCiAN
Ci0JLyogRW5hYmxlIFdCIG9ubHkgZm9yIFVGUy0zLjEgKi8NCi0JaWYgKGRldl9pbmZvLT53c3Bl
Y3ZlcnNpb24gPj0gMHgzMTApDQorCWlmICh1ZnNoY2RfaXNfd2JfYWxsb3dlZChoYmEpKQ0KIAkJ
dWZzaGNkX3diX3Byb2JlKGhiYSwgZGVzY19idWYpOw0KIA0KIAllcnIgPSB1ZnNoY2RfcmVhZF9z
dHJpbmdfZGVzYyhoYmEsIG1vZGVsX2luZGV4LA0KLS0gDQoyLjE4LjANCg==

