Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2B4C0044D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E963206B1
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Cv9LabzZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbgCPIxM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:53:12 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:32442 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730110AbgCPIxM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 04:53:12 -0400
X-UUID: 9202aece267745d998591c9f583d8d99-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=99iqgru7wZylBry8uZxukF5QSaJ1870BxVD1/bjGF28=;
        b=Cv9LabzZm8NqemFFmnDUjAzRgnMa6npXqCeiiFdOGl3zgxvwwPIsLXUP6UWWas03TRpK1BKefvO4i9FYGRBkyJPrEsyflYKCgajNqkMRhoMUnufJ11Ju6Y75Xq/Xdk2tMbvq/3PFZM2mBbeEKqVubly7eS2lVc/fOEq31sRaJhw=;
X-UUID: 9202aece267745d998591c9f583d8d99-20200316
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 66661293; Mon, 16 Mar 2020 16:53:07 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 16:52:30 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 16:53:52 +0800
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
Subject: [PATCH v6 5/7] scsi: ufs: allow customized delay for host enabling
Date:   Mon, 16 Mar 2020 16:53:01 +0800
Message-ID: <20200316085303.20350-6-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200316085303.20350-1-stanley.chu@mediatek.com>
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 94691A3A41D10FC11804F686BBA71B46EEB3B616F15602C2520FE49EE5CB67D32000:8
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
L3Vmcy91ZnNoY2QuYw0KaW5kZXggOWZlYTM0NmY3ZDIyLi43OGI2YWM2ZmNjNGUgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQpAQCAtNDI5OCw3ICs0Mjk4LDcgQEAgaW50IHVmc2hjZF9oYmFfZW5hYmxlKHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQogCSAqIGluc3RydWN0aW9uIG1pZ2h0IGJlIHJlYWQgYmFjay4NCiAJ
ICogVGhpcyBkZWxheSBjYW4gYmUgY2hhbmdlZCBiYXNlZCBvbiB0aGUgY29udHJvbGxlci4NCiAJ
ICovDQotCXVmc2hjZF93YWl0X3VzKDEwMDAsIDEwMCwgdHJ1ZSk7DQorCXVmc2hjZF93YWl0X3Vz
KGhiYS0+aGJhX2VuYWJsZV9kZWxheV91cywgMTAwLCB0cnVlKTsNCiANCiAJLyogd2FpdCBmb3Ig
dGhlIGhvc3QgY29udHJvbGxlciB0byBjb21wbGV0ZSBpbml0aWFsaXphdGlvbiAqLw0KIAlyZXRy
eSA9IDEwOw0KQEAgLTg0MjEsNiArODQyMSw3IEBAIGludCB1ZnNoY2RfaW5pdChzdHJ1Y3QgdWZz
X2hiYSAqaGJhLCB2b2lkIF9faW9tZW0gKm1taW9fYmFzZSwgdW5zaWduZWQgaW50IGlycSkNCiAN
CiAJaGJhLT5tbWlvX2Jhc2UgPSBtbWlvX2Jhc2U7DQogCWhiYS0+aXJxID0gaXJxOw0KKwloYmEt
PmhiYV9lbmFibGVfZGVsYXlfdXMgPSAxMDAwOw0KIA0KIAllcnIgPSB1ZnNoY2RfaGJhX2luaXQo
aGJhKTsNCiAJaWYgKGVycikNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5o
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggODQyZjAyMjNmNWU1Li5iNzExMTky
NWQ4OTkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtNjYzLDYgKzY2Myw3IEBAIHN0cnVjdCB1ZnNfaGJh
IHsNCiAJdTMyIGVoX2ZsYWdzOw0KIAl1MzIgaW50cl9tYXNrOw0KIAl1MTYgZWVfY3RybF9tYXNr
Ow0KKwl1MTYgaGJhX2VuYWJsZV9kZWxheV91czsNCiAJYm9vbCBpc19wb3dlcmVkOw0KIAlzdHJ1
Y3QgdWZzX2luaXRfcHJlZmV0Y2ggaW5pdF9wcmVmZXRjaF9kYXRhOw0KIA0KLS0gDQoyLjE4LjAN
Cg==

