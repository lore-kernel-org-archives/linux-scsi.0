Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416F0C18E5B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 03:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 150A520663
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 03:42:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Sfoq77Gz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgCPDm1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 23:42:27 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:40904 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729412AbgCPDm1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2020 23:42:27 -0400
X-UUID: 79b4cfe8462b4f05a5c81c73e20df238-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=BRn9NnqZ3MzE/akuLUo0HDeyKdjugwz7nkNYDj/5mmw=;
        b=Sfoq77GzGA90VNjhb7lWXK/iPwbctW/hselRh+FxTUuj8tA6bHsEfsVevuS0Ll/AIaLGASNMOrIWBDHhKudFLFQQkvi1Xm3XQob53QdBpORStKENt7Z6Yv+vAPnhTteq41dddX8+ukUu0kS/dMV8tvwrQOlLz3TehBt95FZf9vA=;
X-UUID: 79b4cfe8462b4f05a5c81c73e20df238-20200316
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1573393322; Mon, 16 Mar 2020 11:42:21 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 11:41:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 11:39:23 +0800
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
Subject: [PATCH v5 6/8] scsi: ufs: allow customized delay for host enabling
Date:   Mon, 16 Mar 2020 11:42:16 +0800
Message-ID: <20200316034218.11914-7-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200316034218.11914-1-stanley.chu@mediatek.com>
References: <20200316034218.11914-1-stanley.chu@mediatek.com>
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
L3Vmcy91ZnNoY2QuYw0KaW5kZXggY2U2NWQzMjFhNzNmLi5kY2JmNDVkNTQ3ZDggMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQpAQCAtNDI5OCw3ICs0Mjk4LDcgQEAgaW50IHVmc2hjZF9oYmFfZW5hYmxlKHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQogCSAqIGluc3RydWN0aW9uIG1pZ2h0IGJlIHJlYWQgYmFjay4NCiAJ
ICogVGhpcyBkZWxheSBjYW4gYmUgY2hhbmdlZCBiYXNlZCBvbiB0aGUgY29udHJvbGxlci4NCiAJ
ICovDQotCXVmc2hjZF93YWl0X3VzKDEwMDAsIDEwMCwgdHJ1ZSk7DQorCXVmc2hjZF93YWl0X3Vz
KGhiYS0+aGJhX2VuYWJsZV9kZWxheV91cywgMTAwLCB0cnVlKTsNCiANCiAJLyogd2FpdCBmb3Ig
dGhlIGhvc3QgY29udHJvbGxlciB0byBjb21wbGV0ZSBpbml0aWFsaXphdGlvbiAqLw0KIAlyZXRy
eSA9IDEwOw0KQEAgLTg0MTgsNiArODQxOCw3IEBAIGludCB1ZnNoY2RfaW5pdChzdHJ1Y3QgdWZz
X2hiYSAqaGJhLCB2b2lkIF9faW9tZW0gKm1taW9fYmFzZSwgdW5zaWduZWQgaW50IGlycSkNCiAN
CiAJaGJhLT5tbWlvX2Jhc2UgPSBtbWlvX2Jhc2U7DQogCWhiYS0+aXJxID0gaXJxOw0KKwloYmEt
PmhiYV9lbmFibGVfZGVsYXlfdXMgPSAxMDAwOw0KIA0KIAllcnIgPSB1ZnNoY2RfaGJhX2luaXQo
aGJhKTsNCiAJaWYgKGVycikNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5o
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggNDY4M2U3YmY2NjQwLi4yNjlkZGI5
MmJiNTUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtNjUzLDYgKzY1Myw3IEBAIHN0cnVjdCB1ZnNfaGJh
IHsNCiAJdTMyIGVoX2ZsYWdzOw0KIAl1MzIgaW50cl9tYXNrOw0KIAl1MTYgZWVfY3RybF9tYXNr
Ow0KKwl1MTYgaGJhX2VuYWJsZV9kZWxheV91czsNCiAJYm9vbCBpc19wb3dlcmVkOw0KIA0KIAkv
KiBXb3JrIFF1ZXVlcyAqLw0KLS0gDQoyLjE4LjANCg==

