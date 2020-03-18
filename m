Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A29C5ACD6
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 10:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C892076D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 10:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UETJou+u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgCRKk6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 06:40:58 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:26755 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727041AbgCRKkZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 06:40:25 -0400
X-UUID: 144ed3a2e99943cea7df75856fb379ab-20200318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=6CR+BpbbxcrWvJuUIoPEHgkb6Ulk4lyekUc8d6UiinI=;
        b=UETJou+uMeWp+FRI1wXr4nEq/XZdiDcGwvQs3c2dqk04hEC6QoFSHH9UPORF8WPmGFkBUVHXMvb/3PCj9HEX0vzhanU4NXX2L1ZTmp43xXgrqPPFxzpG4HmyReZZkg6qvLcvH3E79tO612PeLGFw5wgdvm1Ka7b00OS0BN1DJNc=;
X-UUID: 144ed3a2e99943cea7df75856fb379ab-20200318
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 575688551; Wed, 18 Mar 2020 18:40:21 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 18 Mar 2020 18:39:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 18 Mar 2020 18:40:31 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.peter~sen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v7 5/7] scsi: ufs: allow customized delay for host enabling
Date:   Wed, 18 Mar 2020 18:40:14 +0800
Message-ID: <20200318104016.28049-6-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200318104016.28049-1-stanley.chu@mediatek.com>
References: <20200318104016.28049-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q3VycmVudGx5IGEgMSBtcyBkZWxheSBpcyBhcHBsaWVkIGJlZm9yZSBwb2xsaW5nIENPTlRST0xM
RVJfRU5BQkxFDQpiaXQuIFRoaXMgZGVsYXkgbWF5IG5vdCBiZSByZXF1aXJlZCBvciBjYW4gYmUg
Y2hhbmdlZCBpbiBkaWZmZXJlbnQNCmNvbnRyb2xsZXJzLiBNYWtlIHRoZSBkZWxheSBhcyBhIGNo
YW5nZWFibGUgdmFsdWUgaW4gc3RydWN0IHVmc19oYmEgdG8NCmFsbG93IGl0IGN1c3RvbWl6ZWQg
YnkgdmVuZG9ycy4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1l
ZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNv
bT4NClJldmlld2VkLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KLS0tDQogZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDMgKystDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
aCB8IDEgKw0KIDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KaW5kZXggYTQyYTg0MTY0ZGVjLi5jNWVlNzdhNWJmYzcgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQpAQCAtNDMwMSw3ICs0MzAxLDcgQEAgaW50IHVmc2hjZF9oYmFfZW5hYmxlKHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQogCSAqIGluc3RydWN0aW9uIG1pZ2h0IGJlIHJlYWQgYmFjay4NCiAJ
ICogVGhpcyBkZWxheSBjYW4gYmUgY2hhbmdlZCBiYXNlZCBvbiB0aGUgY29udHJvbGxlci4NCiAJ
ICovDQotCXVzbGVlcF9yYW5nZSgxMDAwLCAxMTAwKTsNCisJdWZzaGNkX2RlbGF5X3VzKGhiYS0+
aGJhX2VuYWJsZV9kZWxheV91cywgMTAwKTsNCiANCiAJLyogd2FpdCBmb3IgdGhlIGhvc3QgY29u
dHJvbGxlciB0byBjb21wbGV0ZSBpbml0aWFsaXphdGlvbiAqLw0KIAlyZXRyeSA9IDEwOw0KQEAg
LTg0MjQsNiArODQyNCw3IEBAIGludCB1ZnNoY2RfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB2
b2lkIF9faW9tZW0gKm1taW9fYmFzZSwgdW5zaWduZWQgaW50IGlycSkNCiANCiAJaGJhLT5tbWlv
X2Jhc2UgPSBtbWlvX2Jhc2U7DQogCWhiYS0+aXJxID0gaXJxOw0KKwloYmEtPmhiYV9lbmFibGVf
ZGVsYXlfdXMgPSAxMDAwOw0KIA0KIAllcnIgPSB1ZnNoY2RfaGJhX2luaXQoaGJhKTsNCiAJaWYg
KGVycikNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggOWExNGZmM2Q1ZjhiLi5mYTgxZGFjOWFlNWEgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5oDQpAQCAtNjYzLDYgKzY2Myw3IEBAIHN0cnVjdCB1ZnNfaGJhIHsNCiAJdTMyIGVo
X2ZsYWdzOw0KIAl1MzIgaW50cl9tYXNrOw0KIAl1MTYgZWVfY3RybF9tYXNrOw0KKwl1MTYgaGJh
X2VuYWJsZV9kZWxheV91czsNCiAJYm9vbCBpc19wb3dlcmVkOw0KIAlzdHJ1Y3QgdWZzX2luaXRf
cHJlZmV0Y2ggaW5pdF9wcmVmZXRjaF9kYXRhOw0KIA0KLS0gDQoyLjE4LjANCg==

