Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EE2C1975A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDB9D2071C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eBkps+0g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgCPIxR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:53:17 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:32442 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730075AbgCPIxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 04:53:16 -0400
X-UUID: ac3a7e8d9aae4aeebe03de1bc0b503e0-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=pHsjntWLbUDnwpKOVMCMm9upcEKd4TT7DMldt126T54=;
        b=eBkps+0gAmDEbAmDd9gCwRPYPog+2HVPIWL/269NZCRoNsPh/A0OZ07VtUuWJd6I/6wu2nodDEI8KZLWmH7mahlfMrXCDNZFVXWosfDt7WLjGuAKRY0+ltLd/MfFZ3cKr8j8JG2XA5up+mMu7XPqUq9R1zdRIFOGj3WhK+2SA9s=;
X-UUID: ac3a7e8d9aae4aeebe03de1bc0b503e0-20200316
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 760657247; Mon, 16 Mar 2020 16:53:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 16:52:43 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 16:53:52 +0800
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
Subject: [PATCH v6 3/7] scsi: ufs: introduce common delay function
Date:   Mon, 16 Mar 2020 16:52:59 +0800
Message-ID: <20200316085303.20350-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200316085303.20350-1-stanley.chu@mediatek.com>
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW50cm9kdWNlIGNvbW1vbiBkZWxheSBmdW5jdGlvbiB0byBjb2xsZWN0IGFsbCBkZWxheSByZXF1
aXJlbWVudHMNCnRvIHNpbXBsaWZ5IGRyaXZlciBhbmQgdGFrZSBjaG9pY2VzIG9mIHVkZWxheSBh
bmQgdXNsZWVwX3JhbmdlIGludG8NCmNvbnNpZGVyYXRpb24uDQoNClNpZ25lZC1vZmYtYnk6IFN0
YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpSZXZpZXdlZC1ieTogQXZyaSBB
bHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jIHwgMjcgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuaCB8ICAxICsNCiAyIGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDkgZGVs
ZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggMzE0ZTgwOGIwZDRlLi45ZmVhMzQ2ZjdkMjIg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQpAQCAtNTk3LDYgKzU5NywxOCBAQCBzdGF0aWMgdm9pZCB1ZnNoY2Rf
cHJpbnRfcHdyX2luZm8oc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJCSBoYmEtPnB3cl9pbmZvLmhz
X3JhdGUpOw0KIH0NCiANCit2b2lkIHVmc2hjZF93YWl0X3VzKHVuc2lnbmVkIGxvbmcgdXMsIHVu
c2lnbmVkIGxvbmcgdG9sZXJhbmNlLCBib29sIGNhbl9zbGVlcCkNCit7DQorCWlmICghdXMpDQor
CQlyZXR1cm47DQorDQorCWlmICh1cyA8IDEwIHx8ICFjYW5fc2xlZXApDQorCQl1ZGVsYXkodXMp
Ow0KKwllbHNlDQorCQl1c2xlZXBfcmFuZ2UodXMsIHVzICsgdG9sZXJhbmNlKTsNCit9DQorRVhQ
T1JUX1NZTUJPTF9HUEwodWZzaGNkX3dhaXRfdXMpOw0KKw0KIC8qDQogICogdWZzaGNkX3dhaXRf
Zm9yX3JlZ2lzdGVyIC0gd2FpdCBmb3IgcmVnaXN0ZXIgdmFsdWUgdG8gY2hhbmdlDQogICogQGhi
YSAtIHBlci1hZGFwdGVyIGludGVyZmFjZQ0KQEAgLTYyMCwxMCArNjMyLDcgQEAgaW50IHVmc2hj
ZF93YWl0X2Zvcl9yZWdpc3RlcihzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgcmVnLCB1MzIgbWFz
aywNCiAJdmFsID0gdmFsICYgbWFzazsNCiANCiAJd2hpbGUgKCh1ZnNoY2RfcmVhZGwoaGJhLCBy
ZWcpICYgbWFzaykgIT0gdmFsKSB7DQotCQlpZiAoY2FuX3NsZWVwKQ0KLQkJCXVzbGVlcF9yYW5n
ZShpbnRlcnZhbF91cywgaW50ZXJ2YWxfdXMgKyA1MCk7DQotCQllbHNlDQotCQkJdWRlbGF5KGlu
dGVydmFsX3VzKTsNCisJCXVmc2hjZF93YWl0X3VzKGludGVydmFsX3VzLCA1MCwgY2FuX3NsZWVw
KTsNCiAJCWlmICh0aW1lX2FmdGVyKGppZmZpZXMsIHRpbWVvdXQpKSB7DQogCQkJaWYgKCh1ZnNo
Y2RfcmVhZGwoaGJhLCByZWcpICYgbWFzaykgIT0gdmFsKQ0KIAkJCQllcnIgPSAtRVRJTUVET1VU
Ow0KQEAgLTM1NjUsNyArMzU3NCw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB1ZnNoY2RfYWRkX2Rl
bGF5X2JlZm9yZV9kbWVfY21kKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCX0NCiANCiAJLyogYWxs
b3cgc2xlZXAgZm9yIGV4dHJhIDUwdXMgaWYgbmVlZGVkICovDQotCXVzbGVlcF9yYW5nZShtaW5f
c2xlZXBfdGltZV91cywgbWluX3NsZWVwX3RpbWVfdXMgKyA1MCk7DQorCXVmc2hjZF93YWl0X3Vz
KG1pbl9zbGVlcF90aW1lX3VzLCA1MCwgdHJ1ZSk7DQogfQ0KIA0KIC8qKg0KQEAgLTQyODksNyAr
NDI5OCw3IEBAIGludCB1ZnNoY2RfaGJhX2VuYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAkg
KiBpbnN0cnVjdGlvbiBtaWdodCBiZSByZWFkIGJhY2suDQogCSAqIFRoaXMgZGVsYXkgY2FuIGJl
IGNoYW5nZWQgYmFzZWQgb24gdGhlIGNvbnRyb2xsZXIuDQogCSAqLw0KLQl1c2xlZXBfcmFuZ2Uo
MTAwMCwgMTEwMCk7DQorCXVmc2hjZF93YWl0X3VzKDEwMDAsIDEwMCwgdHJ1ZSk7DQogDQogCS8q
IHdhaXQgZm9yIHRoZSBob3N0IGNvbnRyb2xsZXIgdG8gY29tcGxldGUgaW5pdGlhbGl6YXRpb24g
Ki8NCiAJcmV0cnkgPSAxMDsNCkBAIC00MzAxLDcgKzQzMTAsNyBAQCBpbnQgdWZzaGNkX2hiYV9l
bmFibGUoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJCQkJIkNvbnRyb2xsZXIgZW5hYmxlIGZhaWxl
ZFxuIik7DQogCQkJcmV0dXJuIC1FSU87DQogCQl9DQotCQl1c2xlZXBfcmFuZ2UoNTAwMCwgNTEw
MCk7DQorCQl1ZnNoY2Rfd2FpdF91cyg1MDAwLCAxMDAsIHRydWUpOw0KIAl9DQogDQogCS8qIGVu
YWJsZSBVSUMgcmVsYXRlZCBpbnRlcnJ1cHRzICovDQpAQCAtNjIyNCw3ICs2MjMzLDcgQEAgc3Rh
dGljIGludCB1ZnNoY2RfYWJvcnQoc3RydWN0IHNjc2lfY21uZCAqY21kKQ0KIAkJCXJlZyA9IHVm
c2hjZF9yZWFkbChoYmEsIFJFR19VVFBfVFJBTlNGRVJfUkVRX0RPT1JfQkVMTCk7DQogCQkJaWYg
KHJlZyAmICgxIDw8IHRhZykpIHsNCiAJCQkJLyogc2xlZXAgZm9yIG1heC4gMjAwdXMgdG8gc3Rh
YmlsaXplICovDQotCQkJCXVzbGVlcF9yYW5nZSgxMDAsIDIwMCk7DQorCQkJCXVmc2hjZF93YWl0
X3VzKDEwMCwgMTAwLCB0cnVlKTsNCiAJCQkJY29udGludWU7DQogCQkJfQ0KIAkJCS8qIGNvbW1h
bmQgY29tcGxldGVkIGFscmVhZHkgKi8NCkBAIC03Nzg2LDcgKzc3OTUsNyBAQCBzdGF0aWMgdm9p
ZCB1ZnNoY2RfdnJlZ19zZXRfbHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCSAqLw0KIAlpZiAo
IXVmc2hjZF9pc19saW5rX2FjdGl2ZShoYmEpICYmDQogCSAgICBoYmEtPmRldl9xdWlya3MgJiBV
RlNfREVWSUNFX1FVSVJLX0RFTEFZX0JFRk9SRV9MUE0pDQotCQl1c2xlZXBfcmFuZ2UoMjAwMCwg
MjEwMCk7DQorCQl1ZnNoY2Rfd2FpdF91cygyMDAwLCAxMDAsIHRydWUpOw0KIA0KIAkvKg0KIAkg
KiBJZiBVRlMgZGV2aWNlIGlzIGVpdGhlciBpbiBVRlNfU2xlZXAgdHVybiBvZmYgVkNDIHJhaWwg
dG8gc2F2ZSBzb21lDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCmluZGV4IDUyNDI1MzcxMDgyYS4uODQyZjAyMjNmNWU1
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KKysrIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuaA0KQEAgLTc5Miw2ICs3OTIsNyBAQCBpbnQgdWZzaGNkX2luaXQoc3Ry
dWN0IHVmc19oYmEgKiAsIHZvaWQgX19pb21lbSAqICwgdW5zaWduZWQgaW50KTsNCiBpbnQgdWZz
aGNkX21ha2VfaGJhX29wZXJhdGlvbmFsKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KIHZvaWQgdWZz
aGNkX3JlbW92ZShzdHJ1Y3QgdWZzX2hiYSAqKTsNCiBpbnQgdWZzaGNkX3VpY19oaWJlcm44X2V4
aXQoc3RydWN0IHVmc19oYmEgKmhiYSk7DQordm9pZCB1ZnNoY2Rfd2FpdF91cyh1bnNpZ25lZCBs
b25nIHVzLCB1bnNpZ25lZCBsb25nIHRvbGVyYW5jZSwgYm9vbCBjYW5fc2xlZXApOw0KIGludCB1
ZnNoY2Rfd2FpdF9mb3JfcmVnaXN0ZXIoc3RydWN0IHVmc19oYmEgKmhiYSwgdTMyIHJlZywgdTMy
IG1hc2ssDQogCQkJCXUzMiB2YWwsIHVuc2lnbmVkIGxvbmcgaW50ZXJ2YWxfdXMsDQogCQkJCXVu
c2lnbmVkIGxvbmcgdGltZW91dF9tcywgYm9vbCBjYW5fc2xlZXApOw0KLS0gDQoyLjE4LjANCg==

