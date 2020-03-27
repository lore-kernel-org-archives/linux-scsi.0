Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E217C2D0E8
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 762952071B
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:58:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OssNNdmi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgC0J6l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 05:58:41 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:43254 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726027AbgC0J6l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 05:58:41 -0400
X-UUID: 091052a00bfc42ea9dfa18bfe1e6dcd1-20200327
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=XvMgTRarhYjvy31eOrL8qWKvV+LoDQUZ6Y/LzdVLi0s=;
        b=OssNNdmi8gzqWtSJCr29WTyaehWsUt2Pp6mP0ELQYndd1QNc/guloHxn2s/z8GQEhBnrZF9TVSOylIGO2ibCLvNF7vaCCWsllJwP9da3Sf0mExtlHU28Wrkfpnm9ukrGzDeIe9tay5g0TsslKz4PC5L3mi7mbM+TxcpvN7U39eo=;
X-UUID: 091052a00bfc42ea9dfa18bfe1e6dcd1-20200327
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1146572928; Fri, 27 Mar 2020 17:58:38 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 27 Mar 2020 17:58:35 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 27 Mar 2020 17:58:35 +0800
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
Subject: [PATCH v1 1/1] scsi: ufs: set device as active power mode after resetting device
Date:   Fri, 27 Mar 2020 17:58:35 +0800
Message-ID: <20200327095835.10293-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 51B629C57321E8224197746DE299EA04D736E0A923D7FF8BAF8247DCEF92CBA82000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q3VycmVudGx5IHVmc2hjZCBkcml2ZXIgYXNzdW1lcyB0aGF0IGJJbml0UG93ZXJNb2RlIHBhcmFt
ZXRlcg0KaXMgbm90IGNoYW5nZWQgYnkgYW55IHZlbmRvcnMgdGh1cyBkZXZpY2UgcG93ZXIgbW9k
ZSBjYW4gYmUgc2V0IGFzDQoiQWN0aXZlIiBkdXJpbmcgaW5pdGlhbGl6YXRpb24uDQoNCkFjY29y
ZGluZyB0byBVRlMgSkVERUMgc3BlY2lmaWNhdGlvbiwgZGV2aWNlIHBvd2VyIG1vZGUgc2hhbGwg
YmUNCiJBY3RpdmUiIGFmdGVyIEhXIFJlc2V0IGlzIHRyaWdnZXJlZCBpZiB0aGUgYkluaXRQb3dl
ck1vZGUgcGFyYW1ldGVyDQppbiBEZXZpY2UgRGVzY3JpcHRvciBpcyBkZWZhdWx0IHZhbHVlLg0K
DQpCeSBhYm92ZSBkZXNjcmlwdGlvbiwgd2UgY2FuIHNldCBkZXZpY2UgcG93ZXIgbW9kZSBhcyAi
QWN0aXZlIiBhZnRlcg0KZGV2aWNlIHJlc2V0IGlzIHRyaWdnZXJlZCBieSB2ZW5kb3IncyBjYWxs
YmFjay4gV2l0aCB0aGlzIGNoYW5nZSwNCnRoZSBsaW5rIHN0YXJ0dXAgcGVyZm9ybWFuY2UgY2Fu
IGJlIGltcHJvdmVkIGluIHNvbWUgY2FzZXMNCmJ5IG5vdCBzZXR0aW5nIGxpbmtfc3RhcnR1cF9h
Z2FpbiBhcyB0cnVlIGluIHVmc2hjZF9saW5rX3N0YXJ0dXAoKS4NCg0KU2lnbmVkLW9mZi1ieTog
U3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMgfCAxMyAtLS0tLS0tLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuaCB8IDE0ICsrKysrKysrKysrKysrDQogMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25z
KCspLCAxMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCAyMjc2NjBhMWE0NDYuLmYw
YTM1YjI4OWI3YyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC0xNzEsMTkgKzE3MSw2IEBAIGVudW0gew0K
ICNkZWZpbmUgdWZzaGNkX2NsZWFyX2VoX2luX3Byb2dyZXNzKGgpIFwNCiAJKChoKS0+ZWhfZmxh
Z3MgJj0gflVGU0hDRF9FSF9JTl9QUk9HUkVTUykNCiANCi0jZGVmaW5lIHVmc2hjZF9zZXRfdWZz
X2Rldl9hY3RpdmUoaCkgXA0KLQkoKGgpLT5jdXJyX2Rldl9wd3JfbW9kZSA9IFVGU19BQ1RJVkVf
UFdSX01PREUpDQotI2RlZmluZSB1ZnNoY2Rfc2V0X3Vmc19kZXZfc2xlZXAoaCkgXA0KLQkoKGgp
LT5jdXJyX2Rldl9wd3JfbW9kZSA9IFVGU19TTEVFUF9QV1JfTU9ERSkNCi0jZGVmaW5lIHVmc2hj
ZF9zZXRfdWZzX2Rldl9wb3dlcm9mZihoKSBcDQotCSgoaCktPmN1cnJfZGV2X3B3cl9tb2RlID0g
VUZTX1BPV0VSRE9XTl9QV1JfTU9ERSkNCi0jZGVmaW5lIHVmc2hjZF9pc191ZnNfZGV2X2FjdGl2
ZShoKSBcDQotCSgoaCktPmN1cnJfZGV2X3B3cl9tb2RlID09IFVGU19BQ1RJVkVfUFdSX01PREUp
DQotI2RlZmluZSB1ZnNoY2RfaXNfdWZzX2Rldl9zbGVlcChoKSBcDQotCSgoaCktPmN1cnJfZGV2
X3B3cl9tb2RlID09IFVGU19TTEVFUF9QV1JfTU9ERSkNCi0jZGVmaW5lIHVmc2hjZF9pc191ZnNf
ZGV2X3Bvd2Vyb2ZmKGgpIFwNCi0JKChoKS0+Y3Vycl9kZXZfcHdyX21vZGUgPT0gVUZTX1BPV0VS
RE9XTl9QV1JfTU9ERSkNCi0NCiBzdHJ1Y3QgdWZzX3BtX2x2bF9zdGF0ZXMgdWZzX3BtX2x2bF9z
dGF0ZXNbXSA9IHsNCiAJe1VGU19BQ1RJVkVfUFdSX01PREUsIFVJQ19MSU5LX0FDVElWRV9TVEFU
RX0sDQogCXtVRlNfQUNUSVZFX1BXUl9NT0RFLCBVSUNfTElOS19ISUJFUk44X1NUQVRFfSwNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuaA0KaW5kZXggYjdiZDgxNzk1YzI0Li43YTlkMWQxNzA3MTkgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5o
DQpAQCAtMTI5LDYgKzEyOSwxOSBAQCBlbnVtIHVpY19saW5rX3N0YXRlIHsNCiAjZGVmaW5lIHVm
c2hjZF9zZXRfbGlua19oaWJlcm44KGhiYSkgKChoYmEpLT51aWNfbGlua19zdGF0ZSA9IFwNCiAJ
CQkJICAgIFVJQ19MSU5LX0hJQkVSTjhfU1RBVEUpDQogDQorI2RlZmluZSB1ZnNoY2Rfc2V0X3Vm
c19kZXZfYWN0aXZlKGgpIFwNCisJKChoKS0+Y3Vycl9kZXZfcHdyX21vZGUgPSBVRlNfQUNUSVZF
X1BXUl9NT0RFKQ0KKyNkZWZpbmUgdWZzaGNkX3NldF91ZnNfZGV2X3NsZWVwKGgpIFwNCisJKCho
KS0+Y3Vycl9kZXZfcHdyX21vZGUgPSBVRlNfU0xFRVBfUFdSX01PREUpDQorI2RlZmluZSB1ZnNo
Y2Rfc2V0X3Vmc19kZXZfcG93ZXJvZmYoaCkgXA0KKwkoKGgpLT5jdXJyX2Rldl9wd3JfbW9kZSA9
IFVGU19QT1dFUkRPV05fUFdSX01PREUpDQorI2RlZmluZSB1ZnNoY2RfaXNfdWZzX2Rldl9hY3Rp
dmUoaCkgXA0KKwkoKGgpLT5jdXJyX2Rldl9wd3JfbW9kZSA9PSBVRlNfQUNUSVZFX1BXUl9NT0RF
KQ0KKyNkZWZpbmUgdWZzaGNkX2lzX3Vmc19kZXZfc2xlZXAoaCkgXA0KKwkoKGgpLT5jdXJyX2Rl
dl9wd3JfbW9kZSA9PSBVRlNfU0xFRVBfUFdSX01PREUpDQorI2RlZmluZSB1ZnNoY2RfaXNfdWZz
X2Rldl9wb3dlcm9mZihoKSBcDQorCSgoaCktPmN1cnJfZGV2X3B3cl9tb2RlID09IFVGU19QT1dF
UkRPV05fUFdSX01PREUpDQorDQogLyoNCiAgKiBVRlMgUG93ZXIgbWFuYWdlbWVudCBsZXZlbHMu
DQogICogRWFjaCBsZXZlbCBpcyBpbiBpbmNyZWFzaW5nIG9yZGVyIG9mIHBvd2VyIHNhdmluZ3Mu
DQpAQCAtMTA5MSw2ICsxMTA0LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIHVmc2hjZF92b3BzX2Rl
dmljZV9yZXNldChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJaWYgKGhiYS0+dm9wcyAmJiBo
YmEtPnZvcHMtPmRldmljZV9yZXNldCkgew0KIAkJaGJhLT52b3BzLT5kZXZpY2VfcmVzZXQoaGJh
KTsNCisJCXVmc2hjZF9zZXRfdWZzX2Rldl9hY3RpdmUoaGJhKTsNCiAJCXVmc2hjZF91cGRhdGVf
cmVnX2hpc3QoJmhiYS0+dWZzX3N0YXRzLmRldl9yZXNldCwgMCk7DQogCX0NCiB9DQotLSANCjIu
MTguMA0K

