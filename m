Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DFBC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 05:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8F242074B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 05:21:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OigtWWGO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgFKFVT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 01:21:19 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:59778 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725300AbgFKFVT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 01:21:19 -0400
X-UUID: 68ba96c5a4ca469db000851d4e9734a8-20200611
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=1ILMwubnJQNPNAjEKJe3Og6tiFfzI6Q6shWaNu3nPh8=;
        b=OigtWWGO4cCp1tK5BSPHrT/5XYGMOAJlqXwLjX4JX68TjxpOAtkRWyITFcjuSPaGgniR/cM62wNPz3VMa8sIUvc37/W1J6f2e+jLCAKrpuXy5ejfsxIUNarNEYuBzaRS6brb4g0kQGgjVNFvuMTW7K0pcmpMfk5MzFZbO2OBszI=;
X-UUID: 68ba96c5a4ca469db000851d4e9734a8-20200611
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1465615967; Thu, 11 Jun 2020 13:21:12 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 11 Jun 2020 13:21:11 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Jun 2020 13:21:09 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4] scsi: ufs: Fix imprecise load calculation in devfreq window
Date:   Thu, 11 Jun 2020 13:21:09 +0800
Message-ID: <20200611052109.22700-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 15808926AE20E5473D36ADD8ADA4232D6CE1F132A283B18C20BE289C9826830A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhlIFVGUyBsb2FkIGNhbGN1bGF0aW9uIGlzIGJhc2VkIG9uICJ0b3RhbF90aW1lIiBhbmQgImJ1
c3lfdGltZSIgaW4gYQ0KZGV2ZnJlcSB3aW5kb3cuIEhvd2V2ZXIsIHRoZSBzb3VyY2Ugb2YgdGlt
ZSBpcyBkaWZmZXJlbnQgZm9yIGJvdGgNCnBhcmFtZXRlcnM6ICJidXN5X3RpbWUiIGlzIGFzc2ln
bmVkIGZyb20gImppZmZpZXMiIHRodXMgaGFzIGRpZmZlcmVudA0KYWNjdXJhY3kgZnJvbSAidG90
YWxfdGltZSIgd2hpY2ggaXMgYXNzaWduZWQgZnJvbSBrdGltZV9nZXQoKS4NCg0KQmVzaWRlcywg
dGhlIHRpbWUgb2Ygd2luZG93IGJvdW5kYXJ5IGlzIG5vdCBleGFjdGx5IHRoZSBzYW1lIGFzDQp0
aGUgc3RhcnRpbmcgYnVzeSB0aW1lIGluIHRoaXMgd2luZG93IGlmIFVGUyBpcyBhY3R1YWxseSBi
dXN5DQppbiB0aGUgYmVnaW5uaW5nIG9mIHRoZSB3aW5kb3cuIEEgc2ltaWxhciBhY2N1cmFjeSBl
cnJvciBtYXkgYWxzbw0KaGFwcGVuIGZvciB0aGUgZW5kIG9mIGJ1c3kgdGltZSBpbiBjdXJyZW50
IHdpbmRvdy4NCg0KVG8gZ3VhcmFudGVlIHRoZSBwcmVjaXNpb24gb2YgbG9hZCBjYWxjdWxhdGlv
biwgd2UgbmVlZCB0bw0KDQoxLiBBbGlnbiB0aW1lIGFjY3VyYWN5IG9mIGJvdGggZGV2ZnJlcV9k
ZXZfc3RhdHVzLnRvdGFsX3RpbWUgYW5kDQogICBkZXZmcmVxX2Rldl9zdGF0dXMuYnVzeV90aW1l
LiBGb3IgZXhhbXBsZSwgdXNlICJrdGltZV9nZXQoKSINCiAgIGRpcmVjdGx5Lg0KDQoyLiBBbGln
biBiZWxvdyB0aW1lbGluZXMsDQogICAtIFRoZSBiZWdpbm5pbmcgdGltZSBvZiBkZXZmcmVxIHdp
bmRvd3MNCiAgIC0gVGhlIGJlZ2lubmluZyBvZiBidXN5IHRpbWUgaW4gYSBuZXcgd2luZG93DQog
ICAtIFRoZSBlbmQgb2YgYnVzeSB0aW1lIGluIHRoZSBjdXJyZW50IHdpbmRvdw0KDQpGaXhlczog
YTNjZDVlYzU1ZjZjICgic2NzaTogdWZzOiBhZGQgbG9hZCBiYXNlZCBzY2FsaW5nIG9mIFVGUyBn
ZWFyIikNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5j
b20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMTYgKysrKysrKysrLS0tLS0t
LQ0KIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYw0KaW5kZXggYWQ0ZmM4MjljYmIyLi5iZjVhYWYzMzRjY2QgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
DQpAQCAtMTMxNCw2ICsxMzE0LDcgQEAgc3RhdGljIGludCB1ZnNoY2RfZGV2ZnJlcV9nZXRfZGV2
X3N0YXR1cyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogCXN0
cnVjdCBsaXN0X2hlYWQgKmNsa19saXN0ID0gJmhiYS0+Y2xrX2xpc3RfaGVhZDsNCiAJc3RydWN0
IHVmc19jbGtfaW5mbyAqY2xraTsNCisJa3RpbWVfdCBjdXJyX3Q7DQogDQogCWlmICghdWZzaGNk
X2lzX2Nsa3NjYWxpbmdfc3VwcG9ydGVkKGhiYSkpDQogCQlyZXR1cm4gLUVJTlZBTDsNCkBAIC0x
MzIxLDYgKzEzMjIsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9kZXZmcmVxX2dldF9kZXZfc3RhdHVz
KHN0cnVjdCBkZXZpY2UgKmRldiwNCiAJbWVtc2V0KHN0YXQsIDAsIHNpemVvZigqc3RhdCkpOw0K
IA0KIAlzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KKwlj
dXJyX3QgPSBrdGltZV9nZXQoKTsNCiAJaWYgKCFzY2FsaW5nLT53aW5kb3dfc3RhcnRfdCkNCiAJ
CWdvdG8gc3RhcnRfd2luZG93Ow0KIA0KQEAgLTEzMzIsMTggKzEzMzQsMTcgQEAgc3RhdGljIGlu
dCB1ZnNoY2RfZGV2ZnJlcV9nZXRfZGV2X3N0YXR1cyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQogCSAq
Lw0KIAlzdGF0LT5jdXJyZW50X2ZyZXF1ZW5jeSA9IGNsa2ktPmN1cnJfZnJlcTsNCiAJaWYgKHNj
YWxpbmctPmlzX2J1c3lfc3RhcnRlZCkNCi0JCXNjYWxpbmctPnRvdF9idXN5X3QgKz0ga3RpbWVf
dG9fdXMoa3RpbWVfc3ViKGt0aW1lX2dldCgpLA0KKwkJc2NhbGluZy0+dG90X2J1c3lfdCArPSBr
dGltZV90b191cyhrdGltZV9zdWIoY3Vycl90LA0KIAkJCQkJc2NhbGluZy0+YnVzeV9zdGFydF90
KSk7DQogDQotCXN0YXQtPnRvdGFsX3RpbWUgPSBqaWZmaWVzX3RvX3VzZWNzKChsb25nKWppZmZp
ZXMgLQ0KLQkJCQkobG9uZylzY2FsaW5nLT53aW5kb3dfc3RhcnRfdCk7DQorCXN0YXQtPnRvdGFs
X3RpbWUgPSBrdGltZV90b191cyhjdXJyX3QpIC0gc2NhbGluZy0+d2luZG93X3N0YXJ0X3Q7DQog
CXN0YXQtPmJ1c3lfdGltZSA9IHNjYWxpbmctPnRvdF9idXN5X3Q7DQogc3RhcnRfd2luZG93Og0K
LQlzY2FsaW5nLT53aW5kb3dfc3RhcnRfdCA9IGppZmZpZXM7DQorCXNjYWxpbmctPndpbmRvd19z
dGFydF90ID0ga3RpbWVfdG9fdXMoY3Vycl90KTsNCiAJc2NhbGluZy0+dG90X2J1c3lfdCA9IDA7
DQogDQogCWlmIChoYmEtPm91dHN0YW5kaW5nX3JlcXMpIHsNCi0JCXNjYWxpbmctPmJ1c3lfc3Rh
cnRfdCA9IGt0aW1lX2dldCgpOw0KKwkJc2NhbGluZy0+YnVzeV9zdGFydF90ID0gY3Vycl90Ow0K
IAkJc2NhbGluZy0+aXNfYnVzeV9zdGFydGVkID0gdHJ1ZTsNCiAJfSBlbHNlIHsNCiAJCXNjYWxp
bmctPmJ1c3lfc3RhcnRfdCA9IDA7DQpAQCAtMTg3Nyw2ICsxODc4LDcgQEAgc3RhdGljIHZvaWQg
dWZzaGNkX2V4aXRfY2xrX2dhdGluZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHN0YXRpYyB2b2lk
IHVmc2hjZF9jbGtfc2NhbGluZ19zdGFydF9idXN5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0K
IAlib29sIHF1ZXVlX3Jlc3VtZV93b3JrID0gZmFsc2U7DQorCWt0aW1lX3QgY3Vycl90ID0ga3Rp
bWVfZ2V0KCk7DQogDQogCWlmICghdWZzaGNkX2lzX2Nsa3NjYWxpbmdfc3VwcG9ydGVkKGhiYSkp
DQogCQlyZXR1cm47DQpAQCAtMTg5MiwxMyArMTg5NCwxMyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2Rf
Y2xrX3NjYWxpbmdfc3RhcnRfYnVzeShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAkJCSAgICZoYmEt
PmNsa19zY2FsaW5nLnJlc3VtZV93b3JrKTsNCiANCiAJaWYgKCFoYmEtPmNsa19zY2FsaW5nLndp
bmRvd19zdGFydF90KSB7DQotCQloYmEtPmNsa19zY2FsaW5nLndpbmRvd19zdGFydF90ID0gamlm
ZmllczsNCisJCWhiYS0+Y2xrX3NjYWxpbmcud2luZG93X3N0YXJ0X3QgPSBrdGltZV90b191cyhj
dXJyX3QpOw0KIAkJaGJhLT5jbGtfc2NhbGluZy50b3RfYnVzeV90ID0gMDsNCiAJCWhiYS0+Y2xr
X3NjYWxpbmcuaXNfYnVzeV9zdGFydGVkID0gZmFsc2U7DQogCX0NCiANCiAJaWYgKCFoYmEtPmNs
a19zY2FsaW5nLmlzX2J1c3lfc3RhcnRlZCkgew0KLQkJaGJhLT5jbGtfc2NhbGluZy5idXN5X3N0
YXJ0X3QgPSBrdGltZV9nZXQoKTsNCisJCWhiYS0+Y2xrX3NjYWxpbmcuYnVzeV9zdGFydF90ID0g
Y3Vycl90Ow0KIAkJaGJhLT5jbGtfc2NhbGluZy5pc19idXN5X3N0YXJ0ZWQgPSB0cnVlOw0KIAl9
DQogfQ0KLS0gDQoyLjE4LjANCg==

