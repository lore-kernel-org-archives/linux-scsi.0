Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01773C47257
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 14:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D45B220708
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 14:38:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IZU8/YvO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgEAOin (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 10:38:43 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:2235 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728898AbgEAOin (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 10:38:43 -0400
X-UUID: d1914d0961214355a183b758f3134b1d-20200501
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=8VIPLSkqrglgjQeSr66OR8BmnSuUsZPHpl18x7zMDIc=;
        b=IZU8/YvOIE9a4e01gZpZ8v+vYpYTDojkZ9miupSb6dyc+8Ax0NLRdOw6khuHppd98ALoToetflJkAEaB5Udib70P5K5bpcRfw4ETIPYEb9L5HqD1xsQIumRgA/LO664kg+PYFlB0A2eJ08UVTN2ALYBBJLDRx8T0I8ebm6uJHnE=;
X-UUID: d1914d0961214355a183b758f3134b1d-20200501
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 918446; Fri, 01 May 2020 22:38:38 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 1 May 2020 22:38:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 1 May 2020 22:38:34 +0800
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
Subject: [PATCH v3 5/5] scsi: ufs: cleanup WriteBooster feature
Date:   Fri, 1 May 2020 22:38:35 +0800
Message-ID: <20200501143835.26032-6-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200501143835.26032-1-stanley.chu@mediatek.com>
References: <20200501143835.26032-1-stanley.chu@mediatek.com>
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
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggOGMyNTZmNmY0YTY1Li40MjBkMTQ3
NmIzZTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtMjU1LDcgKzI1NSw2IEBAIHN0YXRpYyBpbnQgdWZz
aGNkX3NjYWxlX2Nsa3Moc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBzY2FsZV91cCk7DQogc3Rh
dGljIGlycXJldHVybl90IHVmc2hjZF9pbnRyKGludCBpcnEsIHZvaWQgKl9faGJhKTsNCiBzdGF0
aWMgaW50IHVmc2hjZF9jaGFuZ2VfcG93ZXJfbW9kZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KIAkJ
CSAgICAgc3RydWN0IHVmc19wYV9sYXllcl9hdHRyICpwd3JfbW9kZSk7DQotc3RhdGljIGJvb2wg
dWZzaGNkX3diX3N1cChzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCiBzdGF0aWMgaW50IHVmc2hjZF93
Yl9idWZfZmx1c2hfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KIHN0YXRpYyBpbnQgdWZz
aGNkX3diX2J1Zl9mbHVzaF9kaXNhYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KIHN0YXRpYyBp
bnQgdWZzaGNkX3diX2N0cmwoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpOw0KQEAg
LTI4Nyw3ICsyODYsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgdWZzaGNkX3diX2NvbmZpZyhzdHJ1
Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJaW50IHJldDsNCiANCi0JaWYgKCF1ZnNoY2Rfd2Jfc3Vw
KGhiYSkpDQorCWlmICghdWZzaGNkX2lzX3diX2FsbG93ZWQoaGJhKSkNCiAJCXJldHVybjsNCiAN
CiAJcmV0ID0gdWZzaGNkX3diX2N0cmwoaGJhLCB0cnVlKTsNCkBAIC01MTk5LDExICs1MTk4LDYg
QEAgc3RhdGljIHZvaWQgdWZzaGNkX2Jrb3BzX2V4Y2VwdGlvbl9ldmVudF9oYW5kbGVyKHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQogCQkJCV9fZnVuY19fLCBlcnIpOw0KIH0NCiANCi1zdGF0aWMgYm9v
bCB1ZnNoY2Rfd2Jfc3VwKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQotew0KLQlyZXR1cm4gdWZzaGNk
X2lzX3diX2FsbG93ZWQoaGJhKTsNCi19DQotDQogaW50IHVmc2hjZF93Yl9nZXRfZmxhZ19pbmRl
eChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJaWYgKGhiYS0+ZGV2X2luZm8uYl93Yl9idWZm
ZXJfdHlwZSA9PSBXQl9CVUZfTU9ERV9MVV9ERURJQ0FURUQpDQpAQCAtNTIxOCw3ICs1MjEyLDcg
QEAgc3RhdGljIGludCB1ZnNoY2Rfd2JfY3RybChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIGVu
YWJsZSkNCiAJdTggaW5kZXg7DQogCWVudW0gcXVlcnlfb3Bjb2RlIG9wY29kZTsNCiANCi0JaWYg
KCF1ZnNoY2Rfd2Jfc3VwKGhiYSkpDQorCWlmICghdWZzaGNkX2lzX3diX2FsbG93ZWQoaGJhKSkN
CiAJCXJldHVybiAwOw0KIA0KIAlpZiAoIShlbmFibGUgXiBoYmEtPndiX2VuYWJsZWQpKQ0KQEAg
LTUyNzQsNyArNTI2OCw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3diX2J1Zl9mbHVzaF9lbmFibGUo
c3RydWN0IHVmc19oYmEgKmhiYSkNCiAJaW50IHJldDsNCiAJdTggaW5kZXg7DQogDQotCWlmICgh
dWZzaGNkX3diX3N1cChoYmEpIHx8IGhiYS0+d2JfYnVmX2ZsdXNoX2VuYWJsZWQpDQorCWlmICgh
dWZzaGNkX2lzX3diX2FsbG93ZWQoaGJhKSB8fCBoYmEtPndiX2J1Zl9mbHVzaF9lbmFibGVkKQ0K
IAkJcmV0dXJuIDA7DQogDQogCWluZGV4ID0gdWZzaGNkX3diX2dldF9mbGFnX2luZGV4KGhiYSk7
DQpAQCAtNTI5Niw3ICs1MjkwLDcgQEAgc3RhdGljIGludCB1ZnNoY2Rfd2JfYnVmX2ZsdXNoX2Rp
c2FibGUoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJaW50IHJldDsNCiAJdTggaW5kZXg7DQogDQot
CWlmICghdWZzaGNkX3diX3N1cChoYmEpIHx8ICFoYmEtPndiX2J1Zl9mbHVzaF9lbmFibGVkKQ0K
KwlpZiAoIXVmc2hjZF9pc193Yl9hbGxvd2VkKGhiYSkgfHwgIWhiYS0+d2JfYnVmX2ZsdXNoX2Vu
YWJsZWQpDQogCQlyZXR1cm4gMDsNCiANCiAJaW5kZXggPSB1ZnNoY2Rfd2JfZ2V0X2ZsYWdfaW5k
ZXgoaGJhKTsNCkBAIC01MzQ2LDcgKzUzNDAsNyBAQCBzdGF0aWMgYm9vbCB1ZnNoY2Rfd2Jfa2Vl
cF92Y2Nfb24oc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJaW50IHJldDsNCiAJdTMyIGF2YWlsX2J1
ZjsNCiANCi0JaWYgKCF1ZnNoY2Rfd2Jfc3VwKGhiYSkpDQorCWlmICghdWZzaGNkX2lzX3diX2Fs
bG93ZWQoaGJhKSkNCiAJCXJldHVybiBmYWxzZTsNCiAJLyoNCiAJICogVGhlIHVmcyBkZXZpY2Ug
bmVlZHMgdGhlIHZjYyB0byBiZSBPTiB0byBmbHVzaC4NCkBAIC04MjMxLDEyICs4MjI1LDEyIEBA
IHN0YXRpYyBpbnQgdWZzaGNkX3N1c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNf
cG1fb3AgcG1fb3ApDQogCQkgKiBjb25maWd1cmVkIFdCIHR5cGUgaXMgNzAlIGZ1bGwsIGtlZXAg
dmNjIE9ODQogCQkgKiBmb3IgdGhlIGRldmljZSB0byBmbHVzaCB0aGUgd2IgYnVmZmVyDQogCQkg
Ki8NCi0JCWlmICgoaGJhLT5hdXRvX2Jrb3BzX2VuYWJsZWQgJiYgdWZzaGNkX3diX3N1cChoYmEp
KSB8fA0KKwkJaWYgKChoYmEtPmF1dG9fYmtvcHNfZW5hYmxlZCAmJiB1ZnNoY2RfaXNfd2JfYWxs
b3dlZChoYmEpKSB8fA0KIAkJICAgIHVmc2hjZF93Yl9rZWVwX3ZjY19vbihoYmEpKQ0KIAkJCWhi
YS0+ZGV2X2luZm8ua2VlcF92Y2Nfb24gPSB0cnVlOw0KIAkJZWxzZQ0KIAkJCWhiYS0+ZGV2X2lu
Zm8ua2VlcF92Y2Nfb24gPSBmYWxzZTsNCi0JfSBlbHNlIGlmICghdWZzaGNkX2lzX3J1bnRpbWVf
cG0ocG1fb3ApKSB7DQorCX0gZWxzZSB7DQogCQloYmEtPmRldl9pbmZvLmtlZXBfdmNjX29uID0g
ZmFsc2U7DQogCX0NCiANCi0tIA0KMi4xOC4wDQo=

