Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F17C1975A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 11:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9601920674
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 11:09:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="raoRhFSh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgCLLJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 07:09:17 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:9062 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726725AbgCLLJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 07:09:16 -0400
X-UUID: 42ed6ee42ad44e1aaa72c5a7344fd513-20200312
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=4SVFDx1dUwhWROvYtY0dTPYSsP2l15nHohTxw716oJc=;
        b=raoRhFShaI3fvFgqXGZ9zcADKs3YbDzar/bElNspPbib4UnS74pyakDo02ezSP7/ibi7pflz+/mErovvfzzHEQEsr/517N5QXjo1HbgDp6uH93UkzYAEB8CsddiLhol8i+mz5bodM9VRcj3sNpih556IY+cqN6FuQtQg5yJJ6tM=;
X-UUID: 42ed6ee42ad44e1aaa72c5a7344fd513-20200312
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 119174148; Thu, 12 Mar 2020 19:09:12 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Mar 2020 19:06:22 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Mar 2020 19:08:51 +0800
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
Subject: [PATCH v2 6/8] scsi: ufs: allow customized delay for host enabling
Date:   Thu, 12 Mar 2020 19:09:06 +0800
Message-ID: <20200312110908.14895-7-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200312110908.14895-1-stanley.chu@mediatek.com>
References: <20200312110908.14895-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 3DF717522B25820C5912D4A86210E1EA0937932E319A8C75A401C2BEAEDD37B12000:8
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
ZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0K
LS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDMgKystDQogZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuaCB8IDEgKw0KIDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggY2U2NWQzMjFhNzNmLi5kY2JmNDVkNTQ3ZDgg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQpAQCAtNDI5OCw3ICs0Mjk4LDcgQEAgaW50IHVmc2hjZF9oYmFfZW5h
YmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCSAqIGluc3RydWN0aW9uIG1pZ2h0IGJlIHJlYWQg
YmFjay4NCiAJICogVGhpcyBkZWxheSBjYW4gYmUgY2hhbmdlZCBiYXNlZCBvbiB0aGUgY29udHJv
bGxlci4NCiAJICovDQotCXVmc2hjZF93YWl0X3VzKDEwMDAsIDEwMCwgdHJ1ZSk7DQorCXVmc2hj
ZF93YWl0X3VzKGhiYS0+aGJhX2VuYWJsZV9kZWxheV91cywgMTAwLCB0cnVlKTsNCiANCiAJLyog
d2FpdCBmb3IgdGhlIGhvc3QgY29udHJvbGxlciB0byBjb21wbGV0ZSBpbml0aWFsaXphdGlvbiAq
Lw0KIAlyZXRyeSA9IDEwOw0KQEAgLTg0MTgsNiArODQxOCw3IEBAIGludCB1ZnNoY2RfaW5pdChz
dHJ1Y3QgdWZzX2hiYSAqaGJhLCB2b2lkIF9faW9tZW0gKm1taW9fYmFzZSwgdW5zaWduZWQgaW50
IGlycSkNCiANCiAJaGJhLT5tbWlvX2Jhc2UgPSBtbWlvX2Jhc2U7DQogCWhiYS0+aXJxID0gaXJx
Ow0KKwloYmEtPmhiYV9lbmFibGVfZGVsYXlfdXMgPSAxMDAwOw0KIA0KIAllcnIgPSB1ZnNoY2Rf
aGJhX2luaXQoaGJhKTsNCiAJaWYgKGVycikNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggNDY4M2U3YmY2NjQw
Li4yNjlkZGI5MmJiNTUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQor
KysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtNjUzLDYgKzY1Myw3IEBAIHN0cnVj
dCB1ZnNfaGJhIHsNCiAJdTMyIGVoX2ZsYWdzOw0KIAl1MzIgaW50cl9tYXNrOw0KIAl1MTYgZWVf
Y3RybF9tYXNrOw0KKwl1MTYgaGJhX2VuYWJsZV9kZWxheV91czsNCiAJYm9vbCBpc19wb3dlcmVk
Ow0KIA0KIAkvKiBXb3JrIFF1ZXVlcyAqLw0KLS0gDQoyLjE4LjANCg==

