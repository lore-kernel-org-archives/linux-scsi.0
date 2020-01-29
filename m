Return-Path: <SRS0=J5Rw=3S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787A8C33CB2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 10:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C8E42064C
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 10:53:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IW2n/kgw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgA2KxD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jan 2020 05:53:03 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:41405 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726482AbgA2KxA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2020 05:53:00 -0500
X-UUID: 701460852888419bb8d6ffe0091206ba-20200129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=cd/VOrYjGH0YmH+BbFRhEcBqK0KEg8sXy7kQAm0xrQs=;
        b=IW2n/kgwIQE/UAKfin4cnVwSaCw4w0/Qey8xiVYpOKH+4cXdS0lAV/t6T1635ZfT8Zl31yRWPJ4N1DxaMLP3MnJegM6ZYSbaKxfgPm7M57v3IZiyGL3AdapRI+BPAhLUkYaDi69WmZP17eh85NRmPnbRw32PF/G7lIcNLWrtJL8=;
X-UUID: 701460852888419bb8d6ffe0091206ba-20200129
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1081263181; Wed, 29 Jan 2020 18:52:53 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 29 Jan 2020 18:52:13 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 29 Jan 2020 18:52:59 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>
CC:     <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH RESEND v3 0/4] MediaTek UFS vendor implemenation part III and Auto-Hibern8 fix
Date:   Wed, 29 Jan 2020 18:52:47 +0800
Message-ID: <20200129105251.12466-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgc2VyaWVzIHByb3ZpZGVzIE1lZGlhVGVrIHZlbmRvciBpbXBsZW1lbnRhdGlv
bnMgYW5kIHNvbWUgZ2VuZXJhbCBmaXhlcy4NCg0KLSBHZW5lcmFsIGZpeGVzDQoJLSBGaXggQXV0
by1IaWJlcm44IGVycm9yIGRldGVjdGlvbg0KDQotIE1lZGlhVGVrIHZlbmRvciBpbXBsZW1lbnRh
dGlvbnMNCgktIEVuc3VyZSBVbmlQcm8gaXMgcG93ZXJlZCBvbiBiZWZvcmUgZXZlcnkgbGluayBz
dGFydHVwDQoJLSBTdXBwb3J0IGxpbmtvZmYgc3RhdGUgZHVyaW5nIHN1c3BlbmQNCgktIEdhdGUg
cmVmZXJlbmNlIGNsb2NrIGZvciBBdXRvLUhpYmVybjggY2FzZQ0KDQp2MyAoUmVzZW5kKQ0KCS0g
Rml4ICJGaXhlcyIgdGFnIGluIHBhdGNoICJzY3NpOiB1ZnM6IGZpeCBBdXRvLUhpYmVybjggZXJy
b3IgZGV0ZWN0aW9uIiAoR3JlZyBLSCkNCg0KdjIgLT4gdjMNCgktIFNxdWFzaCBiZWxvdyBwYXRj
aGVzIHRvIGEgc2luZ2xlIHBhdGNoIChCZWFuIEh1bykNCgkJLSBzY3NpOiB1ZnM6IGFkZCB1ZnNo
Y2RfaXNfYXV0b19oaWJlcm44X2VuYWJsZWQgZmFjaWxpdHkNCgkJLSBzY3NpOiB1ZnM6IGZpeCBh
dXRvLWhpYmVybjggZXJyb3IgZGV0ZWN0aW9uDQoJLSBBZGQgRml4ZXMgdGFnIGluIHBhdGNoICJz
Y3NpOiB1ZnM6IGZpeCBBdXRvLUhpYmVybjggZXJyb3IgZGV0ZWN0aW9uIiAoQmVhbiBIdW8pDQoJ
LSBSZW5hbWUgVlNfTElOS19ISUJFUjggdG8gVlNfTElOS19ISUJFUk44IGluIHBhdGNoICJzY3Np
OiB1ZnMtbWVkaWF0ZWs6IGdhdGUgcmVmLWNsayBkdXJpbmcgQXV0by1IaWJlcm44Ig0KDQp2MSAt
PiB2Mg0KCS0gRml4IGFuZCByZWZpbmUgY29tbWl0IG1lc3NhZ2VzLg0KDQpTdGFubGV5IENodSAo
NCk6DQogIHNjc2k6IHVmcy1tZWRpYXRlazogZW5zdXJlIFVuaVBybyBpcyBub3QgcG93ZXJlZCBk
b3duIGJlZm9yZSBsaW5rdXANCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBzdXBwb3J0IGxpbmtvZmYg
c3RhdGUgZHVyaW5nIHN1c3BlbmQNCiAgc2NzaTogdWZzOiBmaXggQXV0by1IaWJlcm44IGVycm9y
IGRldGVjdGlvbg0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGdhdGUgcmVmLWNsayBkdXJpbmcgQXV0
by1IaWJlcm44DQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgNjcgKysrKysr
KysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0
ZWsuaCB8IDEyICsrKysrKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgICAgfCAgMyAr
LQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAgICAgfCAgNiArKysNCiA0IGZpbGVzIGNo
YW5nZWQsIDYzIGluc2VydGlvbnMoKyksIDI1IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

