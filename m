Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7206AC83006
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 13:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51D9021707
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 13:56:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uexSR17L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgD2N4R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 09:56:17 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:8034 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726968AbgD2N4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2020 09:56:17 -0400
X-UUID: cbccd272d3ed4c52955c8055ca546c58-20200429
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=uOKiKTYYqQLiuxh1KEUt52dRf/z8h0HlHCLgLAeY+fU=;
        b=uexSR17LdXRVO1V/8Fle/i3ZWIbUAdl96AIE9KwcAL3Cn/inTrMTFicvvuZsXH80QZa3FEBkXN7cuSwjMPlWCaroIfnQ8mNtaWvnAHwt5nfz/mZmgDIfFpKepuv16LMop3f37JS9DAhEi4IPz7/FzqtXJl1RE6nHIplHGbvez14=;
X-UUID: cbccd272d3ed4c52955c8055ca546c58-20200429
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 820985321; Wed, 29 Apr 2020 21:56:13 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Apr 2020 21:56:11 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Apr 2020 21:56:10 +0800
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
Subject: [PATCH v2 5/5] scsi: ufs: cleanup WriteBooster feature
Date:   Wed, 29 Apr 2020 21:56:10 +0800
Message-ID: <20200429135610.23750-6-stanley.chu@mediatek.com>
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

U21hbGwgY2xlYW51cCBhcyBiZWxvdyBpdGVtcywNCg0KMS4gVXNlIHVmc2hjZF9pc193Yl9hbGxv
d2VkKCkgZGlyZWN0bHkgaW5zdGVhZCBvZiB1ZnNoY2Rfd2Jfc3VwKCkNCiAgIHNpbmNlIHVmc2hj
ZF93Yl9zdXAoKSBqdXN0IHJldHVybnMgdGhlIHJlc3VsdCBvZg0KICAgdWZzaGNkX2lzX3diX2Fs
bG93ZWQoKS4NCg0KMi4gSW4gdWZzaGNkX3N1c3BlbmQoKSwgImVsc2UgaWYgKCF1ZnNoY2RfaXNf
cnVudGltZV9wbShwbV9vcCkpDQogICBjYW4gYmUgc2ltcGxpZmllZCB0byAiZWxzZSIgc2luY2Ug
Ym90aCBoYXZlIHRoZSBzYW1lIG1lYW5pbmcuDQoNClRoaXMgcGF0Y2ggZG9lcyBub3QgY2hhbmdl
IGFueSBmdW5jdGlvbmFsaXR5Lg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rhbmxl
eS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDIw
ICsrKysrKystLS0tLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwg
MTMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggYjk3MGE0MjJhNWVhLi44ODNhNDZm
N2ZjYzkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtMjUzLDcgKzI1Myw2IEBAIHN0YXRpYyBpbnQgdWZz
aGNkX3NjYWxlX2Nsa3Moc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBzY2FsZV91cCk7DQogc3Rh
dGljIGlycXJldHVybl90IHVmc2hjZF9pbnRyKGludCBpcnEsIHZvaWQgKl9faGJhKTsNCiBzdGF0
aWMgaW50IHVmc2hjZF9jaGFuZ2VfcG93ZXJfbW9kZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KIAkJ
CSAgICAgc3RydWN0IHVmc19wYV9sYXllcl9hdHRyICpwd3JfbW9kZSk7DQotc3RhdGljIGJvb2wg
dWZzaGNkX3diX3N1cChzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCiBzdGF0aWMgaW50IHVmc2hjZF93
Yl9idWZfZmx1c2hfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KIHN0YXRpYyBpbnQgdWZz
aGNkX3diX2J1Zl9mbHVzaF9kaXNhYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KIHN0YXRpYyBp
bnQgdWZzaGNkX3diX2N0cmwoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpOw0KQEAg
LTI4NSw3ICsyODQsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgdWZzaGNkX3diX2NvbmZpZyhzdHJ1
Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJaW50IHJldDsNCiANCi0JaWYgKCF1ZnNoY2Rfd2Jfc3Vw
KGhiYSkpDQorCWlmICghdWZzaGNkX2lzX3diX2FsbG93ZWQoaGJhKSkNCiAJCXJldHVybjsNCiAN
CiAJcmV0ID0gdWZzaGNkX3diX2N0cmwoaGJhLCB0cnVlKTsNCkBAIC01MTk3LDExICs1MTk2LDYg
QEAgc3RhdGljIHZvaWQgdWZzaGNkX2Jrb3BzX2V4Y2VwdGlvbl9ldmVudF9oYW5kbGVyKHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQogCQkJCV9fZnVuY19fLCBlcnIpOw0KIH0NCiANCi1zdGF0aWMgYm9v
bCB1ZnNoY2Rfd2Jfc3VwKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQotew0KLQlyZXR1cm4gdWZzaGNk
X2lzX3diX2FsbG93ZWQoaGJhKTsNCi19DQotDQogc3RhdGljIGludCB1ZnNoY2Rfd2JfZ2V0X2lu
ZGV4KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAlpZiAoaGJhLT5kZXZfaW5mby5iX3diX2J1
ZmZlcl90eXBlID09IFdCX0JVRl9NT0RFX0xVX0RFRElDQVRFRCkNCkBAIC01MjE2LDcgKzUyMTAs
NyBAQCBzdGF0aWMgaW50IHVmc2hjZF93Yl9jdHJsKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wg
ZW5hYmxlKQ0KIAl1OCBpbmRleDsNCiAJZW51bSBxdWVyeV9vcGNvZGUgb3Bjb2RlOw0KIA0KLQlp
ZiAoIXVmc2hjZF93Yl9zdXAoaGJhKSkNCisJaWYgKCF1ZnNoY2RfaXNfd2JfYWxsb3dlZChoYmEp
KQ0KIAkJcmV0dXJuIDA7DQogDQogCWlmICghKGVuYWJsZSBeIGhiYS0+d2JfZW5hYmxlZCkpDQpA
QCAtNTI3Miw3ICs1MjY2LDcgQEAgc3RhdGljIGludCB1ZnNoY2Rfd2JfYnVmX2ZsdXNoX2VuYWJs
ZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlpbnQgcmV0Ow0KIAl1OCBpbmRleDsNCiANCi0JaWYg
KCF1ZnNoY2Rfd2Jfc3VwKGhiYSkgfHwgaGJhLT53Yl9idWZfZmx1c2hfZW5hYmxlZCkNCisJaWYg
KCF1ZnNoY2RfaXNfd2JfYWxsb3dlZChoYmEpIHx8IGhiYS0+d2JfYnVmX2ZsdXNoX2VuYWJsZWQp
DQogCQlyZXR1cm4gMDsNCiANCiAJaW5kZXggPSB1ZnNoY2Rfd2JfZ2V0X2luZGV4KGhiYSk7DQpA
QCAtNTI5NCw3ICs1Mjg4LDcgQEAgc3RhdGljIGludCB1ZnNoY2Rfd2JfYnVmX2ZsdXNoX2Rpc2Fi
bGUoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJaW50IHJldDsNCiAJdTggaW5kZXg7DQogDQotCWlm
ICghdWZzaGNkX3diX3N1cChoYmEpIHx8ICFoYmEtPndiX2J1Zl9mbHVzaF9lbmFibGVkKQ0KKwlp
ZiAoIXVmc2hjZF9pc193Yl9hbGxvd2VkKGhiYSkgfHwgIWhiYS0+d2JfYnVmX2ZsdXNoX2VuYWJs
ZWQpDQogCQlyZXR1cm4gMDsNCiANCiAJaW5kZXggPSB1ZnNoY2Rfd2JfZ2V0X2luZGV4KGhiYSk7
DQpAQCAtNTM0NCw3ICs1MzM4LDcgQEAgc3RhdGljIGJvb2wgdWZzaGNkX3diX2tlZXBfdmNjX29u
KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCWludCByZXQ7DQogCXUzMiBhdmFpbF9idWY7DQogDQot
CWlmICghdWZzaGNkX3diX3N1cChoYmEpKQ0KKwlpZiAoIXVmc2hjZF9pc193Yl9hbGxvd2VkKGhi
YSkpDQogCQlyZXR1cm4gZmFsc2U7DQogCS8qDQogCSAqIFRoZSB1ZnMgZGV2aWNlIG5lZWRzIHRo
ZSB2Y2MgdG8gYmUgT04gdG8gZmx1c2guDQpAQCAtODIyNSwxMiArODIxOSwxMiBAQCBzdGF0aWMg
aW50IHVmc2hjZF9zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBt
X29wKQ0KIAkJICogY29uZmlndXJlZCBXQiB0eXBlIGlzIDcwJSBmdWxsLCBrZWVwIHZjYyBPTg0K
IAkJICogZm9yIHRoZSBkZXZpY2UgdG8gZmx1c2ggdGhlIHdiIGJ1ZmZlcg0KIAkJICovDQotCQlp
ZiAoKGhiYS0+YXV0b19ia29wc19lbmFibGVkICYmIHVmc2hjZF93Yl9zdXAoaGJhKSkgfHwNCisJ
CWlmICgoaGJhLT5hdXRvX2Jrb3BzX2VuYWJsZWQgJiYgdWZzaGNkX2lzX3diX2FsbG93ZWQoaGJh
KSkgfHwNCiAJCSAgICB1ZnNoY2Rfd2Jfa2VlcF92Y2Nfb24oaGJhKSkNCiAJCQloYmEtPmRldl9p
bmZvLmtlZXBfdmNjX29uID0gdHJ1ZTsNCiAJCWVsc2UNCiAJCQloYmEtPmRldl9pbmZvLmtlZXBf
dmNjX29uID0gZmFsc2U7DQotCX0gZWxzZSBpZiAoIXVmc2hjZF9pc19ydW50aW1lX3BtKHBtX29w
KSkgew0KKwl9IGVsc2Ugew0KIAkJaGJhLT5kZXZfaW5mby5rZWVwX3ZjY19vbiA9IGZhbHNlOw0K
IAl9DQogDQotLSANCjIuMTguMA0K

