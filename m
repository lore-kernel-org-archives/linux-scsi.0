Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7501DC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 03:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5258E20656
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 03:04:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YKHlBVfM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389589AbgFYDEg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 23:04:36 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:60230 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389549AbgFYDEg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 23:04:36 -0400
X-UUID: 4fa10f95570d4e00a14a48fd32b8634f-20200625
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=PByjqIQUWUH6SDzkyUSmXg/til5Wci3J64umcljp9G4=;
        b=YKHlBVfMp282I4YEF+buL4teBNmT4BBeEx+8djAqhhNRlNdxwkRlihkUIl2OsK5So3JnUms1gr5kCiXQ7lDbJPGUgyI9NPuytuZBY8lTSqI5WBn2PCWysD0bGmtnypWF3/mFYwt3gKJlz0etU2lnWLMvl2snHF3mP3llByXsix8=;
X-UUID: 4fa10f95570d4e00a14a48fd32b8634f-20200625
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 205790264; Thu, 25 Jun 2020 11:04:32 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 25 Jun 2020 11:04:30 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Jun 2020 11:04:29 +0800
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
Date:   Thu, 25 Jun 2020 11:04:30 +0800
Message-ID: <20200625030430.25048-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
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
LmNodUBtZWRpYXRlay5jb20+DQpUZXN0ZWQtYnk6IFN0ZWV2IEtsaW1hc3pld3NraSA8c3RlZXZA
a2FsaS5vcmc+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+
DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMzUgKysrKysrKysrKysrKysrKysr
Ky0tLS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMTYg
ZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggZjE3M2FkMWJkNzlmLi5jNjJiZDQ3YmVl
YWEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtNjg0NywyMSArNjg0NywzMSBAQCBzdGF0aWMgaW50IHVm
c2hjZF9zY3NpX2FkZF93bHVzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogDQogc3RhdGljIHZvaWQg
dWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4ICpkZXNjX2J1ZikNCiB7DQor
CXN0cnVjdCB1ZnNfZGV2X2luZm8gKmRldl9pbmZvID0gJmhiYS0+ZGV2X2luZm87DQogCXU4IGx1
bjsNCiAJdTMyIGRfbHVfd2JfYnVmX2FsbG9jOw0KIA0KIAlpZiAoIXVmc2hjZF9pc193Yl9hbGxv
d2VkKGhiYSkpDQogCQlyZXR1cm47DQorCS8qDQorCSAqIFByb2JlIFdCIG9ubHkgZm9yIFVGUy0y
LjIgYW5kIFVGUy0zLjEgKGFuZCBsYXRlcikgZGV2aWNlcyBvcg0KKwkgKiBVRlMgZGV2aWNlcyB3
aXRoIHF1aXJrIFVGU19ERVZJQ0VfUVVJUktfU1VQUE9SVF9FWFRFTkRFRF9GRUFUVVJFUw0KKwkg
KiBlbmFibGVkDQorCSAqLw0KKwlpZiAoIShkZXZfaW5mby0+d3NwZWN2ZXJzaW9uID49IDB4MzEw
IHx8DQorCSAgICAgIGRldl9pbmZvLT53c3BlY3ZlcnNpb24gPT0gMHgyMjAgfHwNCisJICAgICAo
aGJhLT5kZXZfcXVpcmtzICYgVUZTX0RFVklDRV9RVUlSS19TVVBQT1JUX0VYVEVOREVEX0ZFQVRV
UkVTKSkpDQorCQlnb3RvIHdiX2Rpc2FibGVkOw0KIA0KIAlpZiAoaGJhLT5kZXNjX3NpemVbUVVF
UllfREVTQ19JRE5fREVWSUNFXSA8DQogCSAgICBERVZJQ0VfREVTQ19QQVJBTV9FWFRfVUZTX0ZF
QVRVUkVfU1VQICsgNCkNCiAJCWdvdG8gd2JfZGlzYWJsZWQ7DQogDQotCWhiYS0+ZGV2X2luZm8u
ZF9leHRfdWZzX2ZlYXR1cmVfc3VwID0NCisJZGV2X2luZm8tPmRfZXh0X3Vmc19mZWF0dXJlX3N1
cCA9DQogCQlnZXRfdW5hbGlnbmVkX2JlMzIoZGVzY19idWYgKw0KIAkJCQkgICBERVZJQ0VfREVT
Q19QQVJBTV9FWFRfVUZTX0ZFQVRVUkVfU1VQKTsNCiANCi0JaWYgKCEoaGJhLT5kZXZfaW5mby5k
X2V4dF91ZnNfZmVhdHVyZV9zdXAgJiBVRlNfREVWX1dSSVRFX0JPT1NURVJfU1VQKSkNCisJaWYg
KCEoZGV2X2luZm8tPmRfZXh0X3Vmc19mZWF0dXJlX3N1cCAmIFVGU19ERVZfV1JJVEVfQk9PU1RF
Ul9TVVApKQ0KIAkJZ290byB3Yl9kaXNhYmxlZDsNCiANCiAJLyoNCkBAIC02ODcwLDE3ICs2ODgw
LDE3IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF93Yl9wcm9iZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1
OCAqZGVzY19idWYpDQogCSAqIGEgbWF4IG9mIDEgbHVuIHdvdWxkIGhhdmUgd2IgYnVmZmVyIGNv
bmZpZ3VyZWQuDQogCSAqIE5vdyBvbmx5IHNoYXJlZCBidWZmZXIgbW9kZSBpcyBzdXBwb3J0ZWQu
DQogCSAqLw0KLQloYmEtPmRldl9pbmZvLmJfd2JfYnVmZmVyX3R5cGUgPQ0KKwlkZXZfaW5mby0+
Yl93Yl9idWZmZXJfdHlwZSA9DQogCQlkZXNjX2J1ZltERVZJQ0VfREVTQ19QQVJBTV9XQl9UWVBF
XTsNCiANCi0JaGJhLT5kZXZfaW5mby5iX3ByZXNydl91c3BjX2VuID0NCisJZGV2X2luZm8tPmJf
cHJlc3J2X3VzcGNfZW4gPQ0KIAkJZGVzY19idWZbREVWSUNFX0RFU0NfUEFSQU1fV0JfUFJFU1JW
X1VTUlNQQ19FTl07DQogDQotCWlmIChoYmEtPmRldl9pbmZvLmJfd2JfYnVmZmVyX3R5cGUgPT0g
V0JfQlVGX01PREVfU0hBUkVEKSB7DQotCQloYmEtPmRldl9pbmZvLmRfd2JfYWxsb2NfdW5pdHMg
PQ0KKwlpZiAoZGV2X2luZm8tPmJfd2JfYnVmZmVyX3R5cGUgPT0gV0JfQlVGX01PREVfU0hBUkVE
KSB7DQorCQlkZXZfaW5mby0+ZF93Yl9hbGxvY191bml0cyA9DQogCQlnZXRfdW5hbGlnbmVkX2Jl
MzIoZGVzY19idWYgKw0KIAkJCQkgICBERVZJQ0VfREVTQ19QQVJBTV9XQl9TSEFSRURfQUxMT0Nf
VU5JVFMpOw0KLQkJaWYgKCFoYmEtPmRldl9pbmZvLmRfd2JfYWxsb2NfdW5pdHMpDQorCQlpZiAo
IWRldl9pbmZvLT5kX3diX2FsbG9jX3VuaXRzKQ0KIAkJCWdvdG8gd2JfZGlzYWJsZWQ7DQogCX0g
ZWxzZSB7DQogCQlmb3IgKGx1biA9IDA7IGx1biA8IFVGU19VUElVX01BWF9XQl9MVU5fSUQ7IGx1
bisrKSB7DQpAQCAtNjg5MSw3ICs2OTAxLDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3diX3Byb2Jl
KHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4ICpkZXNjX2J1ZikNCiAJCQkJCSh1OCAqKSZkX2x1X3di
X2J1Zl9hbGxvYywNCiAJCQkJCXNpemVvZihkX2x1X3diX2J1Zl9hbGxvYykpOw0KIAkJCWlmIChk
X2x1X3diX2J1Zl9hbGxvYykgew0KLQkJCQloYmEtPmRldl9pbmZvLndiX2RlZGljYXRlZF9sdSA9
IGx1bjsNCisJCQkJZGV2X2luZm8tPndiX2RlZGljYXRlZF9sdSA9IGx1bjsNCiAJCQkJYnJlYWs7
DQogCQkJfQ0KIAkJfQ0KQEAgLTY5NzcsMTQgKzY5ODcsNyBAQCBzdGF0aWMgaW50IHVmc19nZXRf
ZGV2aWNlX2Rlc2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCiANCiAJdWZzX2ZpeHVwX2RldmljZV9z
ZXR1cChoYmEpOw0KIA0KLQkvKg0KLQkgKiBQcm9iZSBXQiBvbmx5IGZvciBVRlMtMy4xIGRldmlj
ZXMgb3IgVUZTIGRldmljZXMgd2l0aCBxdWlyaw0KLQkgKiBVRlNfREVWSUNFX1FVSVJLX1NVUFBP
UlRfRVhURU5ERURfRkVBVFVSRVMgZW5hYmxlZA0KLQkgKi8NCi0JaWYgKGRldl9pbmZvLT53c3Bl
Y3ZlcnNpb24gPj0gMHgzMTAgfHwNCi0JICAgIGRldl9pbmZvLT53c3BlY3ZlcnNpb24gPT0gMHgy
MjAgfHwNCi0JICAgIChoYmEtPmRldl9xdWlya3MgJiBVRlNfREVWSUNFX1FVSVJLX1NVUFBPUlRf
RVhURU5ERURfRkVBVFVSRVMpKQ0KLQkJdWZzaGNkX3diX3Byb2JlKGhiYSwgZGVzY19idWYpOw0K
Kwl1ZnNoY2Rfd2JfcHJvYmUoaGJhLCBkZXNjX2J1Zik7DQogDQogCS8qDQogCSAqIHVmc2hjZF9y
ZWFkX3N0cmluZ19kZXNjIHJldHVybnMgc2l6ZSBvZiB0aGUgc3RyaW5nDQotLSANCjIuMTguMA0K

