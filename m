Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C18C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 14:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54A6320734
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 14:42:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="g21/jog5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgFJOmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 10:42:37 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:53680 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726801AbgFJOmh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 10:42:37 -0400
X-UUID: db64a88643a847d3b4e0e0ff68bdddd9-20200610
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=/c9s5OLYVVzYQ8sW2aYaeuJSHMIjCn4QsKe7OyNjLOU=;
        b=g21/jog5z1t8ni2TIzrQMWIlUDSB0ESuO2JYjt31PzcwekhZGfki3pfwWFwQdvzp5mg7fJL0gozrMX7Bg9HXwL8mvlIlQVMfKK7XX3q0w8pKvxcLGymLSPFoRrX+T3548bFvbTt+/yJ0NdEkBiksJ1E5DLT+YxWkvAKo43bxmTc=;
X-UUID: db64a88643a847d3b4e0e0ff68bdddd9-20200610
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1123999127; Wed, 10 Jun 2020 22:42:33 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 10 Jun 2020 22:42:29 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Jun 2020 22:42:29 +0800
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
Subject: [PATCH v3] scsi: ufs: Fix imprecise load calculation in devfreq window
Date:   Wed, 10 Jun 2020 22:42:30 +0800
Message-ID: <20200610144230.2127-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhlIFVGUyBsb2FkIGNhbGN1bGF0aW9uIGlzIGJhc2VkIG9uIHRvdGFsX3RpbWUgYW5kIGJ1c3lf
dGltZSBpbiBhDQpkZXZmcmVxIHdpbmRvdy4gSG93ZXZlciwgdGhlIHByZWNpc2lvbiBvZiBib3Ro
IHRpbWUgYXJlIGRpZmZlcmVudC4NCmJ1c3lfdGltZSBpcyBhc3NpZ25lZCBmcm9tICJqaWZmaWVz
IiB0aHVzIGhhcyBkaWZmZXJlbnQgYWNjdXJhY3kNCmZyb20gdG90YWxfdGltZSB3aGljaCBpcyBh
c3NpZ25lZCBmcm9tIGt0aW1lX2dldCgpLg0KDQpUbyBndWFyYW50ZWUgdGhlIHByZWNpc2lvbiBv
ZiBsb2FkIGNhbGN1bGF0aW9uLCB3ZSBuZWVkIHRvDQoNCjEuIEFsaWduIHRpbWUgYWNjdXJhY3kg
b2YgYm90aCBkZXZmcmVxX2Rldl9zdGF0dXMudG90YWxfdGltZSBhbmQNCiAgIGRldmZyZXFfZGV2
X3N0YXR1cy5idXN5X3RpbWUuIEZvciBleGFtcGxlLCB1c2UgImt0aW1lX2dldCgpIg0KICAgZGly
ZWN0bHkuDQoNCjIuIEFsaWduIGJlbG93IHRpbWVsaW5lcywNCiAgIC0gVGhlIGJlZ2lubmluZyB0
aW1lIG9mIGRldmZyZXEgd2luZG93cw0KICAgLSBUaGUgYmVnaW5uaW5nIG9mIGJ1c3kgdGltZSBp
biBhIG5ldyB3aW5kb3cNCiAgIC0gVGhlIGVuZCBvZiBidXN5IHRpbWUgaW4gdGhlIGN1cnJlbnQg
d2luZG93DQoNCkZpeGVzOiBhM2NkNWVjNTVmNmMgKCJzY3NpOiB1ZnM6IGFkZCBsb2FkIGJhc2Vk
IHNjYWxpbmcgb2YgVUZTIGdlYXIiKQ0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAx
MSArKysrKystLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDUgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggYWQ0ZmM4MjljYmIyLi4wNGI3OWNhNjZmZGYgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jDQpAQCAtMTMxNCw2ICsxMzE0LDcgQEAgc3RhdGljIGludCB1ZnNoY2RfZGV2
ZnJlcV9nZXRfZGV2X3N0YXR1cyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQogCXVuc2lnbmVkIGxvbmcg
ZmxhZ3M7DQogCXN0cnVjdCBsaXN0X2hlYWQgKmNsa19saXN0ID0gJmhiYS0+Y2xrX2xpc3RfaGVh
ZDsNCiAJc3RydWN0IHVmc19jbGtfaW5mbyAqY2xraTsNCisJa3RpbWVfdCBjdXJyX3Q7DQogDQog
CWlmICghdWZzaGNkX2lzX2Nsa3NjYWxpbmdfc3VwcG9ydGVkKGhiYSkpDQogCQlyZXR1cm4gLUVJ
TlZBTDsNCkBAIC0xMzIxLDYgKzEzMjIsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9kZXZmcmVxX2dl
dF9kZXZfc3RhdHVzKHN0cnVjdCBkZXZpY2UgKmRldiwNCiAJbWVtc2V0KHN0YXQsIDAsIHNpemVv
Zigqc3RhdCkpOw0KIA0KIAlzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywg
ZmxhZ3MpOw0KKwljdXJyX3QgPSBrdGltZV9nZXQoKTsNCiAJaWYgKCFzY2FsaW5nLT53aW5kb3df
c3RhcnRfdCkNCiAJCWdvdG8gc3RhcnRfd2luZG93Ow0KIA0KQEAgLTEzMzIsMTggKzEzMzQsMTcg
QEAgc3RhdGljIGludCB1ZnNoY2RfZGV2ZnJlcV9nZXRfZGV2X3N0YXR1cyhzdHJ1Y3QgZGV2aWNl
ICpkZXYsDQogCSAqLw0KIAlzdGF0LT5jdXJyZW50X2ZyZXF1ZW5jeSA9IGNsa2ktPmN1cnJfZnJl
cTsNCiAJaWYgKHNjYWxpbmctPmlzX2J1c3lfc3RhcnRlZCkNCi0JCXNjYWxpbmctPnRvdF9idXN5
X3QgKz0ga3RpbWVfdG9fdXMoa3RpbWVfc3ViKGt0aW1lX2dldCgpLA0KKwkJc2NhbGluZy0+dG90
X2J1c3lfdCArPSBrdGltZV90b191cyhrdGltZV9zdWIoY3Vycl90LA0KIAkJCQkJc2NhbGluZy0+
YnVzeV9zdGFydF90KSk7DQogDQotCXN0YXQtPnRvdGFsX3RpbWUgPSBqaWZmaWVzX3RvX3VzZWNz
KChsb25nKWppZmZpZXMgLQ0KLQkJCQkobG9uZylzY2FsaW5nLT53aW5kb3dfc3RhcnRfdCk7DQor
CXN0YXQtPnRvdGFsX3RpbWUgPSBrdGltZV90b191cyhjdXJyX3QpIC0gc2NhbGluZy0+d2luZG93
X3N0YXJ0X3Q7DQogCXN0YXQtPmJ1c3lfdGltZSA9IHNjYWxpbmctPnRvdF9idXN5X3Q7DQogc3Rh
cnRfd2luZG93Og0KLQlzY2FsaW5nLT53aW5kb3dfc3RhcnRfdCA9IGppZmZpZXM7DQorCXNjYWxp
bmctPndpbmRvd19zdGFydF90ID0ga3RpbWVfdG9fdXMoY3Vycl90KTsNCiAJc2NhbGluZy0+dG90
X2J1c3lfdCA9IDA7DQogDQogCWlmIChoYmEtPm91dHN0YW5kaW5nX3JlcXMpIHsNCi0JCXNjYWxp
bmctPmJ1c3lfc3RhcnRfdCA9IGt0aW1lX2dldCgpOw0KKwkJc2NhbGluZy0+YnVzeV9zdGFydF90
ID0gY3Vycl90Ow0KIAkJc2NhbGluZy0+aXNfYnVzeV9zdGFydGVkID0gdHJ1ZTsNCiAJfSBlbHNl
IHsNCiAJCXNjYWxpbmctPmJ1c3lfc3RhcnRfdCA9IDA7DQotLSANCjIuMTguMA0K

