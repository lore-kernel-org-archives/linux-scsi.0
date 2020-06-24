Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E393C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 07:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EF0E20768
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 07:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="lV6vSWqz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389948AbgFXHlS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 03:41:18 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:29398 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388375AbgFXHlS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 03:41:18 -0400
X-UUID: 5cf62a969b1341c1b72ce22c6faff6d8-20200624
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=M1lXlZEsofHnM4YP6dSvdFgmILznueI0uqT9VKT/klI=;
        b=lV6vSWqzZAnGgTC1ayCD36KacD71F8a+3JQKtaK8FZDczz9y+9lWPm8pls3A7hGtCIDwRGPtDqMLAs/1rSNo7ypdO2nSul9dae93ULAnLY1PCjG+sP7ct0uOEqR1e8W3usMIBaIdnppb80dUnPEJvUiupU8Qcs4QKfToeQHJP3k=;
X-UUID: 5cf62a969b1341c1b72ce22c6faff6d8-20200624
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 206632329; Wed, 24 Jun 2020 15:41:14 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 24 Jun 2020 15:41:09 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 24 Jun 2020 15:41:09 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2] scsi: ufs: Disable WriteBooster capability in non-supported UFS device
Date:   Wed, 24 Jun 2020 15:41:10 +0800
Message-ID: <20200624074110.21919-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 111037EFB6A6EB6B73CD987E5A9257C4C76DD7E8731A4CB5E12BEB870DCCB8762000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SWYgVUZTIGRldmljZSBpcyBub3QgcXVhbGlmaWVkIHRvIGVudGVyIHRoZSBkZXRlY3Rpb24gb2Yg
V3JpdGVCb29zdGVyDQpwcm9iaW5nIGJ5IGRpc2FsbG93ZWQgVUZTIHZlcnNpb24gb3IgZGV2aWNl
IHF1aXJrcywgdGhlbiBXcml0ZUJvb3N0ZXINCmNhcGFiaWxpdHkgaW4gaG9zdCBzaGFsbCBiZSBk
aXNhYmxlZCB0byBwcmV2ZW50IGFueSBXcml0ZUJvb3N0ZXINCm9wZXJhdGlvbnMgaW4gdGhlIGZ1
dHVyZS4NCg0KRml4ZXM6IDNkMTdiOWI1YWIxMSAoInNjc2k6IHVmczogQWRkIHdyaXRlIGJvb3N0
ZXIgZmVhdHVyZSBzdXBwb3J0IikNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5
LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMzUg
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTkg
aW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggZjE3M2Fk
MWJkNzlmLi5jNjJiZDQ3YmVlYWEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtNjg0NywyMSArNjg0Nywz
MSBAQCBzdGF0aWMgaW50IHVmc2hjZF9zY3NpX2FkZF93bHVzKHN0cnVjdCB1ZnNfaGJhICpoYmEp
DQogDQogc3RhdGljIHZvaWQgdWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4
ICpkZXNjX2J1ZikNCiB7DQorCXN0cnVjdCB1ZnNfZGV2X2luZm8gKmRldl9pbmZvID0gJmhiYS0+
ZGV2X2luZm87DQogCXU4IGx1bjsNCiAJdTMyIGRfbHVfd2JfYnVmX2FsbG9jOw0KIA0KIAlpZiAo
IXVmc2hjZF9pc193Yl9hbGxvd2VkKGhiYSkpDQogCQlyZXR1cm47DQorCS8qDQorCSAqIFByb2Jl
IFdCIG9ubHkgZm9yIFVGUy0yLjIgYW5kIFVGUy0zLjEgKGFuZCBsYXRlcikgZGV2aWNlcyBvcg0K
KwkgKiBVRlMgZGV2aWNlcyB3aXRoIHF1aXJrIFVGU19ERVZJQ0VfUVVJUktfU1VQUE9SVF9FWFRF
TkRFRF9GRUFUVVJFUw0KKwkgKiBlbmFibGVkDQorCSAqLw0KKwlpZiAoIShkZXZfaW5mby0+d3Nw
ZWN2ZXJzaW9uID49IDB4MzEwIHx8DQorCSAgICAgIGRldl9pbmZvLT53c3BlY3ZlcnNpb24gPT0g
MHgyMjAgfHwNCisJICAgICAoaGJhLT5kZXZfcXVpcmtzICYgVUZTX0RFVklDRV9RVUlSS19TVVBQ
T1JUX0VYVEVOREVEX0ZFQVRVUkVTKSkpDQorCQlnb3RvIHdiX2Rpc2FibGVkOw0KIA0KIAlpZiAo
aGJhLT5kZXNjX3NpemVbUVVFUllfREVTQ19JRE5fREVWSUNFXSA8DQogCSAgICBERVZJQ0VfREVT
Q19QQVJBTV9FWFRfVUZTX0ZFQVRVUkVfU1VQICsgNCkNCiAJCWdvdG8gd2JfZGlzYWJsZWQ7DQog
DQotCWhiYS0+ZGV2X2luZm8uZF9leHRfdWZzX2ZlYXR1cmVfc3VwID0NCisJZGV2X2luZm8tPmRf
ZXh0X3Vmc19mZWF0dXJlX3N1cCA9DQogCQlnZXRfdW5hbGlnbmVkX2JlMzIoZGVzY19idWYgKw0K
IAkJCQkgICBERVZJQ0VfREVTQ19QQVJBTV9FWFRfVUZTX0ZFQVRVUkVfU1VQKTsNCiANCi0JaWYg
KCEoaGJhLT5kZXZfaW5mby5kX2V4dF91ZnNfZmVhdHVyZV9zdXAgJiBVRlNfREVWX1dSSVRFX0JP
T1NURVJfU1VQKSkNCisJaWYgKCEoZGV2X2luZm8tPmRfZXh0X3Vmc19mZWF0dXJlX3N1cCAmIFVG
U19ERVZfV1JJVEVfQk9PU1RFUl9TVVApKQ0KIAkJZ290byB3Yl9kaXNhYmxlZDsNCiANCiAJLyoN
CkBAIC02ODcwLDE3ICs2ODgwLDE3IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF93Yl9wcm9iZShzdHJ1
Y3QgdWZzX2hiYSAqaGJhLCB1OCAqZGVzY19idWYpDQogCSAqIGEgbWF4IG9mIDEgbHVuIHdvdWxk
IGhhdmUgd2IgYnVmZmVyIGNvbmZpZ3VyZWQuDQogCSAqIE5vdyBvbmx5IHNoYXJlZCBidWZmZXIg
bW9kZSBpcyBzdXBwb3J0ZWQuDQogCSAqLw0KLQloYmEtPmRldl9pbmZvLmJfd2JfYnVmZmVyX3R5
cGUgPQ0KKwlkZXZfaW5mby0+Yl93Yl9idWZmZXJfdHlwZSA9DQogCQlkZXNjX2J1ZltERVZJQ0Vf
REVTQ19QQVJBTV9XQl9UWVBFXTsNCiANCi0JaGJhLT5kZXZfaW5mby5iX3ByZXNydl91c3BjX2Vu
ID0NCisJZGV2X2luZm8tPmJfcHJlc3J2X3VzcGNfZW4gPQ0KIAkJZGVzY19idWZbREVWSUNFX0RF
U0NfUEFSQU1fV0JfUFJFU1JWX1VTUlNQQ19FTl07DQogDQotCWlmIChoYmEtPmRldl9pbmZvLmJf
d2JfYnVmZmVyX3R5cGUgPT0gV0JfQlVGX01PREVfU0hBUkVEKSB7DQotCQloYmEtPmRldl9pbmZv
LmRfd2JfYWxsb2NfdW5pdHMgPQ0KKwlpZiAoZGV2X2luZm8tPmJfd2JfYnVmZmVyX3R5cGUgPT0g
V0JfQlVGX01PREVfU0hBUkVEKSB7DQorCQlkZXZfaW5mby0+ZF93Yl9hbGxvY191bml0cyA9DQog
CQlnZXRfdW5hbGlnbmVkX2JlMzIoZGVzY19idWYgKw0KIAkJCQkgICBERVZJQ0VfREVTQ19QQVJB
TV9XQl9TSEFSRURfQUxMT0NfVU5JVFMpOw0KLQkJaWYgKCFoYmEtPmRldl9pbmZvLmRfd2JfYWxs
b2NfdW5pdHMpDQorCQlpZiAoIWRldl9pbmZvLT5kX3diX2FsbG9jX3VuaXRzKQ0KIAkJCWdvdG8g
d2JfZGlzYWJsZWQ7DQogCX0gZWxzZSB7DQogCQlmb3IgKGx1biA9IDA7IGx1biA8IFVGU19VUElV
X01BWF9XQl9MVU5fSUQ7IGx1bisrKSB7DQpAQCAtNjg5MSw3ICs2OTAxLDcgQEAgc3RhdGljIHZv
aWQgdWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4ICpkZXNjX2J1ZikNCiAJ
CQkJCSh1OCAqKSZkX2x1X3diX2J1Zl9hbGxvYywNCiAJCQkJCXNpemVvZihkX2x1X3diX2J1Zl9h
bGxvYykpOw0KIAkJCWlmIChkX2x1X3diX2J1Zl9hbGxvYykgew0KLQkJCQloYmEtPmRldl9pbmZv
LndiX2RlZGljYXRlZF9sdSA9IGx1bjsNCisJCQkJZGV2X2luZm8tPndiX2RlZGljYXRlZF9sdSA9
IGx1bjsNCiAJCQkJYnJlYWs7DQogCQkJfQ0KIAkJfQ0KQEAgLTY5NzcsMTQgKzY5ODcsNyBAQCBz
dGF0aWMgaW50IHVmc19nZXRfZGV2aWNlX2Rlc2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCiANCiAJ
dWZzX2ZpeHVwX2RldmljZV9zZXR1cChoYmEpOw0KIA0KLQkvKg0KLQkgKiBQcm9iZSBXQiBvbmx5
IGZvciBVRlMtMy4xIGRldmljZXMgb3IgVUZTIGRldmljZXMgd2l0aCBxdWlyaw0KLQkgKiBVRlNf
REVWSUNFX1FVSVJLX1NVUFBPUlRfRVhURU5ERURfRkVBVFVSRVMgZW5hYmxlZA0KLQkgKi8NCi0J
aWYgKGRldl9pbmZvLT53c3BlY3ZlcnNpb24gPj0gMHgzMTAgfHwNCi0JICAgIGRldl9pbmZvLT53
c3BlY3ZlcnNpb24gPT0gMHgyMjAgfHwNCi0JICAgIChoYmEtPmRldl9xdWlya3MgJiBVRlNfREVW
SUNFX1FVSVJLX1NVUFBPUlRfRVhURU5ERURfRkVBVFVSRVMpKQ0KLQkJdWZzaGNkX3diX3Byb2Jl
KGhiYSwgZGVzY19idWYpOw0KKwl1ZnNoY2Rfd2JfcHJvYmUoaGJhLCBkZXNjX2J1Zik7DQogDQog
CS8qDQogCSAqIHVmc2hjZF9yZWFkX3N0cmluZ19kZXNjIHJldHVybnMgc2l6ZSBvZiB0aGUgc3Ry
aW5nDQotLSANCjIuMTguMA0K

