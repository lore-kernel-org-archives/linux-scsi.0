Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0AFC10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 11:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6F352072F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 11:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OlTNiGFO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgCLLJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 07:09:32 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:9062 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726968AbgCLLJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 07:09:18 -0400
X-UUID: 57cc7a52173e4534b5bc7b82c147fe9b-20200312
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=4TIG4byHma4NOdZnY1tFZDNMEK8I4hnml0HdV5eY6KA=;
        b=OlTNiGFOOFTvmvLHVaCzbKDR2kwplWDqXztmi745OwdwJAOIkVKGib9PjfzmW3fLmWmxpzW+KKvnG+kKkSXdh85VTmj4rpV4WbvSjhiuMhDDz6dEJiBrmJtz6t8qhiv6ugpxmNFf4355OwfJ5m5dRUc4RImI6MjOiTgfOMPqMxE=;
X-UUID: 57cc7a52173e4534b5bc7b82c147fe9b-20200312
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 765829989; Thu, 12 Mar 2020 19:09:12 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Mar 2020 19:06:22 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Mar 2020 19:08:50 +0800
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
Subject: [PATCH v2 4/8] scsi: ufs: introduce common delay function
Date:   Thu, 12 Mar 2020 19:09:04 +0800
Message-ID: <20200312110908.14895-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200312110908.14895-1-stanley.chu@mediatek.com>
References: <20200312110908.14895-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 640FA8D674D04502A57F937DF8F04FAFA73D2CCC4DDAA72B2DC102A3490FAD1C2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW50cm9kdWNlIGNvbW1vbiBkZWxheSBmdW5jdGlvbiB0byBjb2xsZWN0IGFsbCBkZWxheSByZXF1
aXJlbWVudHMNCnRvIHNpbXBsaWZ5IGRyaXZlciBhbmQgdGFrZSBjaG9pY2VzIG9mIHVkZWxheSBh
bmQgdXNsZWVwX3JhbmdlIGludG8NCmNvbnNpZGVyYXRpb24uDQoNClNpZ25lZC1vZmYtYnk6IFN0
YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jIHwgMjcgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQogZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuaCB8ICAxICsNCiAyIGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMo
KyksIDkgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggYjQ5ODhiOWVlMzZjLi5jZTY1
ZDMyMWE3M2YgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtNTk3LDYgKzU5NywxOCBAQCBzdGF0aWMgdm9p
ZCB1ZnNoY2RfcHJpbnRfcHdyX2luZm8oc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJCSBoYmEtPnB3
cl9pbmZvLmhzX3JhdGUpOw0KIH0NCiANCit2b2lkIHVmc2hjZF93YWl0X3VzKHVuc2lnbmVkIGxv
bmcgdXMsIHVuc2lnbmVkIGxvbmcgdG9sZXJhbmNlLCBib29sIGNhbl9zbGVlcCkNCit7DQorCWlm
ICghdXMpDQorCQlyZXR1cm47DQorDQorCWlmICh1cyA8IDEwIHx8ICFjYW5fc2xlZXApDQorCQl1
ZGVsYXkodXMpOw0KKwllbHNlDQorCQl1c2xlZXBfcmFuZ2UodXMsIHVzICsgdG9sZXJhbmNlKTsN
Cit9DQorRVhQT1JUX1NZTUJPTF9HUEwodWZzaGNkX3dhaXRfdXMpOw0KKw0KIC8qDQogICogdWZz
aGNkX3dhaXRfZm9yX3JlZ2lzdGVyIC0gd2FpdCBmb3IgcmVnaXN0ZXIgdmFsdWUgdG8gY2hhbmdl
DQogICogQGhiYSAtIHBlci1hZGFwdGVyIGludGVyZmFjZQ0KQEAgLTYyMCwxMCArNjMyLDcgQEAg
aW50IHVmc2hjZF93YWl0X2Zvcl9yZWdpc3RlcihzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgcmVn
LCB1MzIgbWFzaywNCiAJdmFsID0gdmFsICYgbWFzazsNCiANCiAJd2hpbGUgKCh1ZnNoY2RfcmVh
ZGwoaGJhLCByZWcpICYgbWFzaykgIT0gdmFsKSB7DQotCQlpZiAoY2FuX3NsZWVwKQ0KLQkJCXVz
bGVlcF9yYW5nZShpbnRlcnZhbF91cywgaW50ZXJ2YWxfdXMgKyA1MCk7DQotCQllbHNlDQotCQkJ
dWRlbGF5KGludGVydmFsX3VzKTsNCisJCXVmc2hjZF93YWl0X3VzKGludGVydmFsX3VzLCA1MCwg
Y2FuX3NsZWVwKTsNCiAJCWlmICh0aW1lX2FmdGVyKGppZmZpZXMsIHRpbWVvdXQpKSB7DQogCQkJ
aWYgKCh1ZnNoY2RfcmVhZGwoaGJhLCByZWcpICYgbWFzaykgIT0gdmFsKQ0KIAkJCQllcnIgPSAt
RVRJTUVET1VUOw0KQEAgLTM1NjUsNyArMzU3NCw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB1ZnNo
Y2RfYWRkX2RlbGF5X2JlZm9yZV9kbWVfY21kKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCX0NCiAN
CiAJLyogYWxsb3cgc2xlZXAgZm9yIGV4dHJhIDUwdXMgaWYgbmVlZGVkICovDQotCXVzbGVlcF9y
YW5nZShtaW5fc2xlZXBfdGltZV91cywgbWluX3NsZWVwX3RpbWVfdXMgKyA1MCk7DQorCXVmc2hj
ZF93YWl0X3VzKG1pbl9zbGVlcF90aW1lX3VzLCA1MCwgdHJ1ZSk7DQogfQ0KIA0KIC8qKg0KQEAg
LTQyODksNyArNDI5OCw3IEBAIGludCB1ZnNoY2RfaGJhX2VuYWJsZShzdHJ1Y3QgdWZzX2hiYSAq
aGJhKQ0KIAkgKiBpbnN0cnVjdGlvbiBtaWdodCBiZSByZWFkIGJhY2suDQogCSAqIFRoaXMgZGVs
YXkgY2FuIGJlIGNoYW5nZWQgYmFzZWQgb24gdGhlIGNvbnRyb2xsZXIuDQogCSAqLw0KLQl1c2xl
ZXBfcmFuZ2UoMTAwMCwgMTEwMCk7DQorCXVmc2hjZF93YWl0X3VzKDEwMDAsIDEwMCwgdHJ1ZSk7
DQogDQogCS8qIHdhaXQgZm9yIHRoZSBob3N0IGNvbnRyb2xsZXIgdG8gY29tcGxldGUgaW5pdGlh
bGl6YXRpb24gKi8NCiAJcmV0cnkgPSAxMDsNCkBAIC00MzAxLDcgKzQzMTAsNyBAQCBpbnQgdWZz
aGNkX2hiYV9lbmFibGUoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJCQkJIkNvbnRyb2xsZXIgZW5h
YmxlIGZhaWxlZFxuIik7DQogCQkJcmV0dXJuIC1FSU87DQogCQl9DQotCQl1c2xlZXBfcmFuZ2Uo
NTAwMCwgNTEwMCk7DQorCQl1ZnNoY2Rfd2FpdF91cyg1MDAwLCAxMDAsIHRydWUpOw0KIAl9DQog
DQogCS8qIGVuYWJsZSBVSUMgcmVsYXRlZCBpbnRlcnJ1cHRzICovDQpAQCAtNjIyNCw3ICs2MjMz
LDcgQEAgc3RhdGljIGludCB1ZnNoY2RfYWJvcnQoc3RydWN0IHNjc2lfY21uZCAqY21kKQ0KIAkJ
CXJlZyA9IHVmc2hjZF9yZWFkbChoYmEsIFJFR19VVFBfVFJBTlNGRVJfUkVRX0RPT1JfQkVMTCk7
DQogCQkJaWYgKHJlZyAmICgxIDw8IHRhZykpIHsNCiAJCQkJLyogc2xlZXAgZm9yIG1heC4gMjAw
dXMgdG8gc3RhYmlsaXplICovDQotCQkJCXVzbGVlcF9yYW5nZSgxMDAsIDIwMCk7DQorCQkJCXVm
c2hjZF93YWl0X3VzKDEwMCwgMTAwLCB0cnVlKTsNCiAJCQkJY29udGludWU7DQogCQkJfQ0KIAkJ
CS8qIGNvbW1hbmQgY29tcGxldGVkIGFscmVhZHkgKi8NCkBAIC03NzgzLDcgKzc3OTIsNyBAQCBz
dGF0aWMgdm9pZCB1ZnNoY2RfdnJlZ19zZXRfbHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCSAq
Lw0KIAlpZiAoIXVmc2hjZF9pc19saW5rX2FjdGl2ZShoYmEpICYmDQogCSAgICBoYmEtPmRldl9x
dWlya3MgJiBVRlNfREVWSUNFX1FVSVJLX0RFTEFZX0JFRk9SRV9MUE0pDQotCQl1c2xlZXBfcmFu
Z2UoMjAwMCwgMjEwMCk7DQorCQl1ZnNoY2Rfd2FpdF91cygyMDAwLCAxMDAsIHRydWUpOw0KIA0K
IAkvKg0KIAkgKiBJZiBVRlMgZGV2aWNlIGlzIGVpdGhlciBpbiBVRlNfU2xlZXAgdHVybiBvZmYg
VkNDIHJhaWwgdG8gc2F2ZSBzb21lDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCmluZGV4IGZlYzAwNGNkODA1NC4uNDY4
M2U3YmY2NjQwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KKysrIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KQEAgLTc4MSw2ICs3ODEsNyBAQCBpbnQgdWZzaGNk
X2luaXQoc3RydWN0IHVmc19oYmEgKiAsIHZvaWQgX19pb21lbSAqICwgdW5zaWduZWQgaW50KTsN
CiBpbnQgdWZzaGNkX21ha2VfaGJhX29wZXJhdGlvbmFsKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0K
IHZvaWQgdWZzaGNkX3JlbW92ZShzdHJ1Y3QgdWZzX2hiYSAqKTsNCiBpbnQgdWZzaGNkX3VpY19o
aWJlcm44X2V4aXQoc3RydWN0IHVmc19oYmEgKmhiYSk7DQordm9pZCB1ZnNoY2Rfd2FpdF91cyh1
bnNpZ25lZCBsb25nIHVzLCB1bnNpZ25lZCBsb25nIHRvbGVyYW5jZSwgYm9vbCBjYW5fc2xlZXAp
Ow0KIGludCB1ZnNoY2Rfd2FpdF9mb3JfcmVnaXN0ZXIoc3RydWN0IHVmc19oYmEgKmhiYSwgdTMy
IHJlZywgdTMyIG1hc2ssDQogCQkJCXUzMiB2YWwsIHVuc2lnbmVkIGxvbmcgaW50ZXJ2YWxfdXMs
DQogCQkJCXVuc2lnbmVkIGxvbmcgdGltZW91dF9tcywgYm9vbCBjYW5fc2xlZXApOw0KLS0gDQoy
LjE4LjANCg==

