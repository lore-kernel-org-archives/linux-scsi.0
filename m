Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A99C83004
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 13:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13F42083B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 13:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="etqFUgvj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgD2N4Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 09:56:16 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:8034 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726853AbgD2N4Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2020 09:56:16 -0400
X-UUID: 24bcba6f1b9d441594b1253f2acb1697-20200429
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=TtiqXGvs1ddJ8sOI7BA0Q8oUmtYb84kP4m655wKXu4U=;
        b=etqFUgvjkSUTWyQDdXJG8eWHlZZ3IBUWG+sVmLd2rv3xZvx/VM88+jNk+UX9HtAq9LSXbP6KXMQhfiVErHBxv90jF8MXfYVmmtxpiQmmjowjpBDaWcLfhmvFo6ZGMa/PDN+qloTOCOfiJxg9EBPbFEyflwZhkJ9RRxoWbU1Uc4Q=;
X-UUID: 24bcba6f1b9d441594b1253f2acb1697-20200429
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2071290289; Wed, 29 Apr 2020 21:56:13 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Apr 2020 21:56:10 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Apr 2020 21:56:09 +0800
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
Subject: [PATCH v2 1/5] scsi: ufs: allow legacy UFS devices to enable WriteBooster
Date:   Wed, 29 Apr 2020 21:56:06 +0800
Message-ID: <20200429135610.23750-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200429135610.23750-1-stanley.chu@mediatek.com>
References: <20200429135610.23750-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
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
LmNodUBtZWRpYXRlay5jb20+DQpSZXZpZXdlZC1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9u
LmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAxOSArKysrKysrKysrKysr
LS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0p
DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KaW5kZXggOTE1ZTk2MzM5OGM0Li4xMTE4MTJjNTMwNGEgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQpAQCAtNjgwMCw5ICs2ODAwLDE2IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3Njc2lfYWRk
X3dsdXMoc3RydWN0IHVmc19oYmEgKmhiYSkNCiANCiBzdGF0aWMgdm9pZCB1ZnNoY2Rfd2JfcHJv
YmUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTggKmRlc2NfYnVmKQ0KIHsNCisJaWYgKGhiYS0+ZGVz
Y19zaXplLmRldl9kZXNjIDw9IERFVklDRV9ERVNDX1BBUkFNX0VYVF9VRlNfRkVBVFVSRV9TVVAp
DQorCQlnb3RvIHdiX2Rpc2FibGVkOw0KKw0KIAloYmEtPmRldl9pbmZvLmRfZXh0X3Vmc19mZWF0
dXJlX3N1cCA9DQogCQlnZXRfdW5hbGlnbmVkX2JlMzIoZGVzY19idWYgKw0KIAkJCQkgICBERVZJ
Q0VfREVTQ19QQVJBTV9FWFRfVUZTX0ZFQVRVUkVfU1VQKTsNCisNCisJaWYgKCEoaGJhLT5kZXZf
aW5mby5kX2V4dF91ZnNfZmVhdHVyZV9zdXAgJiBVRlNfREVWX1dSSVRFX0JPT1NURVJfU1VQKSkN
CisJCWdvdG8gd2JfZGlzYWJsZWQ7DQorDQogCS8qDQogCSAqIFdCIG1heSBiZSBzdXBwb3J0ZWQg
YnV0IG5vdCBjb25maWd1cmVkIHdoaWxlIHByb3Zpc2lvbmluZy4NCiAJICogVGhlIHNwZWMgc2F5
cywgaW4gZGVkaWNhdGVkIHdiIGJ1ZmZlciBtb2RlLA0KQEAgLTY4MTgsMTEgKzY4MjUsMTIgQEAg
c3RhdGljIHZvaWQgdWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4ICpkZXNj
X2J1ZikNCiAJaGJhLT5kZXZfaW5mby5iX3ByZXNydl91c3BjX2VuID0NCiAJCWRlc2NfYnVmW0RF
VklDRV9ERVNDX1BBUkFNX1dCX1BSRVNSVl9VU1JTUENfRU5dOw0KIA0KLQlpZiAoISgoaGJhLT5k
ZXZfaW5mby5kX2V4dF91ZnNfZmVhdHVyZV9zdXAgJg0KLQkJIFVGU19ERVZfV1JJVEVfQk9PU1RF
Ul9TVVApICYmDQotCQloYmEtPmRldl9pbmZvLmJfd2JfYnVmZmVyX3R5cGUgJiYNCisJaWYgKCEo
aGJhLT5kZXZfaW5mby5iX3diX2J1ZmZlcl90eXBlICYmDQogCSAgICAgIGhiYS0+ZGV2X2luZm8u
ZF93Yl9hbGxvY191bml0cykpDQotCQloYmEtPmNhcHMgJj0gflVGU0hDRF9DQVBfV0JfRU47DQor
CQlnb3RvIHdiX2Rpc2FibGVkOw0KKw0KK3diX2Rpc2FibGVkOg0KKwloYmEtPmNhcHMgJj0gflVG
U0hDRF9DQVBfV0JfRU47DQogfQ0KIA0KIHN0YXRpYyBpbnQgdWZzX2dldF9kZXZpY2VfZGVzYyhz
dHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KQEAgLTY4NjIsOCArNjg3MCw3IEBAIHN0YXRpYyBpbnQgdWZz
X2dldF9kZXZpY2VfZGVzYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIA0KIAltb2RlbF9pbmRleCA9
IGRlc2NfYnVmW0RFVklDRV9ERVNDX1BBUkFNX1BSRENUX05BTUVdOw0KIA0KLQkvKiBFbmFibGUg
V0Igb25seSBmb3IgVUZTLTMuMSAqLw0KLQlpZiAoZGV2X2luZm8tPndzcGVjdmVyc2lvbiA+PSAw
eDMxMCkNCisJaWYgKHVmc2hjZF9pc193Yl9hbGxvd2VkKGhiYSkpDQogCQl1ZnNoY2Rfd2JfcHJv
YmUoaGJhLCBkZXNjX2J1Zik7DQogDQogCWVyciA9IHVmc2hjZF9yZWFkX3N0cmluZ19kZXNjKGhi
YSwgbW9kZWxfaW5kZXgsDQotLSANCjIuMTguMA0K

