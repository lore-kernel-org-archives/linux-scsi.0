Return-Path: <SRS0=+zlT=7O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F227C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 10:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A47B2077D
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 10:47:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FMgPkk0N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgFAKq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Jun 2020 06:46:58 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:39213 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726110AbgFAKqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2020 06:46:52 -0400
X-UUID: 06b4e07e9ac94e858c24ff9c73383e81-20200601
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=dAJ6kQkuED5Us38miQWm8ZMdm7uCNWRKUju7pfkDY6k=;
        b=FMgPkk0NMETlIKu/y74w5lJrmsBNW2eGz6UFPhfaiRACdIgMRpFxDlDYDPGvUogtjRwgtN9eRnzCRR+QyZzbM8/oggrP85oYj84R9gNhK9bdYPcbhREICGrqju6cPBHUas/wqJjzCXaONNkWLYJAPa10NOTPas3sfDlQsC2+AtY=;
X-UUID: 06b4e07e9ac94e858c24ff9c73383e81-20200601
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 147685464; Mon, 01 Jun 2020 18:46:48 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 1 Jun 2020 18:46:46 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 1 Jun 2020 18:46:45 +0800
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
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 1/5] scsi: ufs-mediatek: Fix imprecise waiting time for ref-clk control
Date:   Mon, 1 Jun 2020 18:46:42 +0800
Message-ID: <20200601104646.15436-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200601104646.15436-1-stanley.chu@mediatek.com>
References: <20200601104646.15436-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q3VycmVudGx5IHJlZi1jbGsgY29udHJvbCB0aW1lb3V0IGlzIGltcGxlbWVudGVkIGJ5IEppZmZp
ZXMuIEhvd2V2ZXINCmppZmZpZXMgaXMgbm90IGFjY3VyYXRlIGVub3VnaCB0aHVzICJmYWxzZSB0
aW1lb3V0IiBtYXkgaGFwcGVuLg0KDQpVc2UgbW9yZSBhY2N1cmF0ZSBkZWxheSBtZWNoYW5pc20g
aW5zdGVhZCwgZm9yIGV4YW1wbGUsIGt0aW1lLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENo
dSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQtYnk6IEFuZHkgVGVuZyA8YW5k
eS50ZW5nQG1lZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRt
YW5Ad2RjLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCA3ICsr
KystLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIHwgMiArLQ0KIDIgZmlsZXMg
Y2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1l
ZGlhdGVrLmMNCmluZGV4IGQ1NmNlOGQ5N2Q0ZS4uNTIzZWU1NTczOTIxIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnMtbWVkaWF0ZWsuYw0KQEAgLTEyMCw3ICsxMjAsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfc2V0
dXBfcmVmX2NsayhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uKQ0KIHsNCiAJc3RydWN0IHVm
c19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KIAlzdHJ1Y3QgYXJt
X3NtY2NjX3JlcyByZXM7DQotCXVuc2lnbmVkIGxvbmcgdGltZW91dDsNCisJa3RpbWVfdCB0aW1l
b3V0LCB0aW1lX2NoZWNrZWQ7DQogCXUzMiB2YWx1ZTsNCiANCiAJaWYgKGhvc3QtPnJlZl9jbGtf
ZW5hYmxlZCA9PSBvbikNCkBAIC0xMzUsOCArMTM1LDkgQEAgc3RhdGljIGludCB1ZnNfbXRrX3Nl
dHVwX3JlZl9jbGsoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBvbikNCiAJfQ0KIA0KIAkvKiBX
YWl0IGZvciBhY2sgKi8NCi0JdGltZW91dCA9IGppZmZpZXMgKyBtc2Vjc190b19qaWZmaWVzKFJF
RkNMS19SRVFfVElNRU9VVF9NUyk7DQorCXRpbWVvdXQgPSBrdGltZV9hZGRfdXMoa3RpbWVfZ2V0
KCksIFJFRkNMS19SRVFfVElNRU9VVF9VUyk7DQogCWRvIHsNCisJCXRpbWVfY2hlY2tlZCA9IGt0
aW1lX2dldCgpOw0KIAkJdmFsdWUgPSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUZTX1JFRkNMS19D
VFJMKTsNCiANCiAJCS8qIFdhaXQgdW50aWwgYWNrIGJpdCBlcXVhbHMgdG8gcmVxIGJpdCAqLw0K
QEAgLTE0NCw3ICsxNDUsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfc2V0dXBfcmVmX2NsayhzdHJ1
Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uKQ0KIAkJCWdvdG8gb3V0Ow0KIA0KIAkJdXNsZWVwX3Jh
bmdlKDEwMCwgMjAwKTsNCi0JfSB3aGlsZSAodGltZV9iZWZvcmUoamlmZmllcywgdGltZW91dCkp
Ow0KKwl9IHdoaWxlIChrdGltZV9iZWZvcmUodGltZV9jaGVja2VkLCB0aW1lb3V0KSk7DQogDQog
CWRldl9lcnIoaGJhLT5kZXYsICJtaXNzaW5nIGFjayBvZiByZWZjbGsgcmVxLCByZWc6IDB4JXhc
biIsIHZhbHVlKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KaW5kZXggNWJiZDNlOWNiYWUy
Li5mYzQyZGNiZmQ4MDAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQpAQCAtMjgsNyArMjgs
NyBAQA0KICNkZWZpbmUgUkVGQ0xLX1JFUVVFU1QgICAgICAgICAgICAgIEJJVCgwKQ0KICNkZWZp
bmUgUkVGQ0xLX0FDSyAgICAgICAgICAgICAgICAgIEJJVCgxKQ0KIA0KLSNkZWZpbmUgUkVGQ0xL
X1JFUV9USU1FT1VUX01TICAgICAgIDMNCisjZGVmaW5lIFJFRkNMS19SRVFfVElNRU9VVF9VUyAg
ICAgICAzMDAwDQogDQogLyoNCiAgKiBWZW5kb3Igc3BlY2lmaWMgcHJlLWRlZmluZWQgcGFyYW1l
dGVycw0KLS0gDQoyLjE4LjANCg==

