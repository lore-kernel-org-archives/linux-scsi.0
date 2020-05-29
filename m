Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED64FC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 09:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5B74207D4
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 09:23:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GQgGtA2y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgE2JXV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 05:23:21 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:37427 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726644AbgE2JXS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 05:23:18 -0400
X-UUID: bb431eba164c4b839de1b208f8d91198-20200529
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=NOKlv7zM4LRTruut6jgdhOjKQWFJHmbjuA06RuI5wcQ=;
        b=GQgGtA2y+2a6srv8ldiq1g47YvQxUB5fqMKbjAE7fE7jc9Z0A920YW63wNAiBq7cCJQzGepW/zyhJbtxkTSsv8m5AIXVBa7mPrrbfENcr+XFVx28dNov42ThCTdi16+lo+cXr6V9XKbqZx5nh9euHX0i8iLYMZ7OnhaLiXzyZDQ=;
X-UUID: bb431eba164c4b839de1b208f8d91198-20200529
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 47945482; Fri, 29 May 2020 17:23:14 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 29 May 2020 17:23:11 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 29 May 2020 17:23:10 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <pengshun.zhao@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 4/5] scsi: ufs-mediatek: Fix unbalanced clock on/off
Date:   Fri, 29 May 2020 17:23:09 +0800
Message-ID: <20200529092310.1106-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200529092310.1106-1-stanley.chu@mediatek.com>
References: <20200529092310.1106-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 83DAA400323415FEC60197EA0FAEFFA75DFAD431B49159932AD28C3CD9C819842000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWVkaWFUZWsgVUZTIGNsb2NrcyBhcmUgc2VwYXJhdGVkIHRvIHR3byBwYXJ0cyBhbmQgY29udHJv
bGxlZA0KYnkgZGlmZmVyZW50IG1vZHVsZXM6IHVmcy1tZWRpYXRlayBhbmQgcGh5LXVmcy1tZWRp
YXRlay4NCg0KSWYgYm90aCBBdXRvLUhpYmVybjggYW5kIGNsay1nYXRpbmcgZmVhdHVyZSBhcmUg
ZW5hYmxlZCwgbXBoeQ0KcG93ZXIgY29udHJvbCBpcyBub3QgYmFsYW5jZWQgdGh1cyB1bmJhbGFu
Y2VkIGNvbnRyb2wgYWxzbw0KaGFwcGVucyB0byB0aGUgY2xvY2tzIHByb2JlZCBieSBwaHktdWZz
LW1lZGlhdGVrIG1vZHVsZS4NCg0KRml4IHRoaXMgaXNzdWUgYnkNCg0KLSBQcm9taXNlIHVzYWdl
IG9mIHBoeV9wb3dlcl9vbi9vZmYgYmFsYW5jZWQNCg0KLSBSZW1vdmUgcGh5X3Bvd2VyX29uL29m
ZiBjb250cm9sIGluIHN1c3BlbmQvcmVzdW1lIHZvcHMgc2luY2UNCiAgYm90aCBjYW4gYmUgaGFu
ZGxlZCBpbiBzZXR1cF9jbG9jayB2b3BzIG9ubHkNCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBD
aHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxw
ZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlh
dGVrLmMgfCA1NiArKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hh
bmdlZCwgMzIgaW5zZXJ0aW9ucygrKSwgMjQgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVk
aWF0ZWsuYw0KaW5kZXggNWY0MWI3YjdkYjhmLi5kZTllNjQzZmI4ZGQgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5jDQpAQCAtMjA1LDYgKzIwNSwyMyBAQCBpbnQgdWZzX210a193YWl0X2xpbmtf
c3RhdGUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTMyIHN0YXRlLA0KIAlyZXR1cm4gLUVUSU1FRE9V
VDsNCiB9DQogDQorc3RhdGljIHZvaWQgdWZzX210a19tcGh5X3Bvd2VyX29uKHN0cnVjdCB1ZnNf
aGJhICpoYmEsIGJvb2wgb24pDQorew0KKwlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZz
aGNkX2dldF92YXJpYW50KGhiYSk7DQorCXN0cnVjdCBwaHkgKm1waHkgPSBob3N0LT5tcGh5Ow0K
Kw0KKwlpZiAoIW1waHkpDQorCQlyZXR1cm47DQorDQorCWlmIChvbiAmJiAhaG9zdC0+bXBoeV9w
b3dlcmVkX29uKQ0KKwkJcGh5X3Bvd2VyX29uKG1waHkpOw0KKwllbHNlIGlmICghb24gJiYgaG9z
dC0+bXBoeV9wb3dlcmVkX29uKQ0KKwkJcGh5X3Bvd2VyX29mZihtcGh5KTsNCisJZWxzZQ0KKwkJ
cmV0dXJuOw0KKwlob3N0LT5tcGh5X3Bvd2VyZWRfb24gPSBvbjsNCit9DQorDQogLyoqDQogICog
dWZzX210a19zZXR1cF9jbG9ja3MgLSBlbmFibGVzL2Rpc2FibGUgY2xvY2tzDQogICogQGhiYTog
aG9zdCBjb250cm9sbGVyIGluc3RhbmNlDQpAQCAtMjI4LDI1ICsyNDUsMjQgQEAgc3RhdGljIGlu
dCB1ZnNfbXRrX3NldHVwX2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uLA0KIAkJ
cmV0dXJuIDA7DQogDQogCWlmICghb24gJiYgc3RhdHVzID09IFBSRV9DSEFOR0UpIHsNCi0JCWlm
ICghdWZzaGNkX2lzX2xpbmtfYWN0aXZlKGhiYSkpIHsNCi0JCQl1ZnNfbXRrX3NldHVwX3JlZl9j
bGsoaGJhLCBvbik7DQotCQkJcmV0ID0gcGh5X3Bvd2VyX29mZihob3N0LT5tcGh5KTsNCi0JCX0g
ZWxzZSB7DQotCQkJLyoNCi0JCQkgKiBHYXRlIHJlZi1jbGsgaWYgbGluayBzdGF0ZSBpcyBpbiBI
aWJlcm44DQotCQkJICogdHJpZ2dlcmVkIGJ5IEF1dG8tSGliZXJuOC4NCi0JCQkgKi8NCi0JCQlp
ZiAoIXVmc2hjZF9jYW5faGliZXJuOF9kdXJpbmdfZ2F0aW5nKGhiYSkgJiYNCi0JCQkgICAgdWZz
aGNkX2lzX2F1dG9faGliZXJuOF9lbmFibGVkKGhiYSkpIHsNCi0JCQkJcmV0ID0gdWZzX210a193
YWl0X2xpbmtfc3RhdGUoaGJhLA0KLQkJCQkJCQkgICAgICBWU19MSU5LX0hJQkVSTjgsDQotCQkJ
CQkJCSAgICAgIDE1KTsNCi0JCQkJaWYgKCFyZXQpDQotCQkJCQl1ZnNfbXRrX3NldHVwX3JlZl9j
bGsoaGJhLCBvbik7DQorCQkvKg0KKwkJICogR2F0ZSByZWYtY2xrIGFuZCBwb3dlcm9mZiBtcGh5
IGlmIGxpbmsgc3RhdGUgaXMgaW4gT0ZGDQorCQkgKiBvciBIaWJlcm44IGJ5IGVpdGhlciB1ZnNo
Y2RfbGlua19zdGF0ZV90cmFuc2l0aW9uKCkgb3INCisJCSAqIEF1dG8tSGliZXJuOC4NCisJCSAq
Lw0KKwkJaWYgKCF1ZnNoY2RfaXNfbGlua19hY3RpdmUoaGJhKSB8fA0KKwkJCSghdWZzaGNkX2Nh
bl9oaWJlcm44X2R1cmluZ19nYXRpbmcoaGJhKSAmJg0KKwkJCXVmc2hjZF9pc19hdXRvX2hpYmVy
bjhfZW5hYmxlZChoYmEpKSkgew0KKwkJCXJldCA9IHVmc19tdGtfd2FpdF9saW5rX3N0YXRlKGhi
YSwNCisJCQkJCQkgICAgICBWU19MSU5LX0hJQkVSTjgsDQorCQkJCQkJICAgICAgMTUpOw0KKwkJ
CWlmICghcmV0KSB7DQorCQkJCXVmc19tdGtfc2V0dXBfcmVmX2NsayhoYmEsIG9uKTsNCisJCQkJ
dWZzX210a19tcGh5X3Bvd2VyX29uKGhiYSwgb24pOw0KIAkJCX0NCiAJCX0NCiAJfSBlbHNlIGlm
IChvbiAmJiBzdGF0dXMgPT0gUE9TVF9DSEFOR0UpIHsNCi0JCXJldCA9IHBoeV9wb3dlcl9vbiho
b3N0LT5tcGh5KTsNCisJCXVmc19tdGtfbXBoeV9wb3dlcl9vbihoYmEsIG9uKTsNCiAJCXVmc19t
dGtfc2V0dXBfcmVmX2NsayhoYmEsIG9uKTsNCiAJfQ0KIA0KQEAgLTUzOCw3ICs1NTQsNiBAQCBz
dGF0aWMgdm9pZCB1ZnNfbXRrX3ZyZWdfc2V0X2xwbShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29s
IGxwbSkNCiBzdGF0aWMgaW50IHVmc19tdGtfc3VzcGVuZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBl
bnVtIHVmc19wbV9vcCBwbV9vcCkNCiB7DQogCWludCBlcnI7DQotCXN0cnVjdCB1ZnNfbXRrX2hv
c3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCiANCiAJaWYgKHVmc2hjZF9pc19s
aW5rX2hpYmVybjgoaGJhKSkgew0KIAkJZXJyID0gdWZzX210a19saW5rX3NldF9scG0oaGJhKTsN
CkBAIC01NTksMjAgKzU3NCwxMyBAQCBzdGF0aWMgaW50IHVmc19tdGtfc3VzcGVuZChzdHJ1Y3Qg
dWZzX2hiYSAqaGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCiAJCXVmc19tdGtfdnJlZ19zZXRf
bHBtKGhiYSwgdHJ1ZSk7DQogCX0NCiANCi0JaWYgKCF1ZnNoY2RfaXNfbGlua19hY3RpdmUoaGJh
KSkNCi0JCXBoeV9wb3dlcl9vZmYoaG9zdC0+bXBoeSk7DQotDQogCXJldHVybiAwOw0KIH0NCiAN
CiBzdGF0aWMgaW50IHVmc19tdGtfcmVzdW1lKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZz
X3BtX29wIHBtX29wKQ0KIHsNCi0Jc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9n
ZXRfdmFyaWFudChoYmEpOw0KIAlpbnQgZXJyOw0KIA0KLQlpZiAoIXVmc2hjZF9pc19saW5rX2Fj
dGl2ZShoYmEpKQ0KLQkJcGh5X3Bvd2VyX29uKGhvc3QtPm1waHkpOw0KLQ0KIAlpZiAodWZzaGNk
X2lzX2xpbmtfaGliZXJuOChoYmEpKSB7DQogCQl1ZnNfbXRrX3ZyZWdfc2V0X2xwbShoYmEsIGZh
bHNlKTsNCiAJCWVyciA9IHVmc19tdGtfbGlua19zZXRfaHBtKGhiYSk7DQotLSANCjIuMTguMA0K

