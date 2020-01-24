Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F00C32771
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 06:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 242C920709
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 06:49:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JBwBcLgj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730891AbgAXGto (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 01:49:44 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:1275 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730795AbgAXGtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 01:49:43 -0500
X-UUID: ea5f98ebb0ea42c080939a46b0e28426-20200124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=M4aLG1u5om4evGkmKFBHNNwLCDYqri4fDoY+xM2E/LE=;
        b=JBwBcLgjsUKfyFz5vPGsHakGNW1Yir1llZAu8XOtDka2dDVPrFGxDQU7tHaYDvT3Ekh49UofIoHK7X8RAD3BvvGeigdPHvEvxFnPj4j2mT2t3y7b1F28MpizeDXPNK00aiMloFZzh21/B73RhJVclxcxrW+hXs8IXPQHXcQpxmQ=;
X-UUID: ea5f98ebb0ea42c080939a46b0e28426-20200124
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2070296771; Fri, 24 Jan 2020 14:49:31 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 14:50:11 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 Jan 2020 14:48:58 +0800
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
Subject: [PATCH v1 4/5] scsi: ufs: fix auto-hibern8 error detection
Date:   Fri, 24 Jan 2020 14:49:25 +0800
Message-ID: <20200124064926.29472-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200124064926.29472-1-stanley.chu@mediatek.com>
References: <20200124064926.29472-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SWYgQXV0by1IaWJlcm44IGNhcGFiaWxpdHkgaXMgc3VwcG9ydGVkIGJ5IGhvc3QgYnV0IG5vdCBh
Y3R1YWxseQ0KZW5hYmxlZCwgQXV0by1IaWJlcm44IGVycm9yIHNoYWxsIG5vdCBoYXBwZW4sIHRo
dXMgYnlwYXNzDQpkaXNhYmxpbmcgY2FzZSBpbiB1ZnNoY2RfaXNfYXV0b19oaWJlcm44X2Vycm9y
KCkuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5j
b20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMyArKy0NCiAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXgg
YWJkMGU2YjA1Zjc5Li4yMTRhM2YzNzNkZDggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtNTQ3OSw3ICs1
NDc5LDggQEAgc3RhdGljIGlycXJldHVybl90IHVmc2hjZF91cGRhdGVfdWljX2Vycm9yKHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQogc3RhdGljIGJvb2wgdWZzaGNkX2lzX2F1dG9faGliZXJuOF9lcnJv
cihzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KIAkJCQkJIHUzMiBpbnRyX21hc2spDQogew0KLQlpZiAo
IXVmc2hjZF9pc19hdXRvX2hpYmVybjhfc3VwcG9ydGVkKGhiYSkpDQorCWlmICghdWZzaGNkX2lz
X2F1dG9faGliZXJuOF9zdXBwb3J0ZWQoaGJhKSB8fA0KKwkgICAgIXVmc2hjZF9pc19hdXRvX2hp
YmVybjhfZW5hYmxlZChoYmEpKQ0KIAkJcmV0dXJuIGZhbHNlOw0KIA0KIAlpZiAoIShpbnRyX21h
c2sgJiBVRlNIQ0RfVUlDX0hJQkVSTjhfTUFTSykpDQotLSANCjIuMTguMA0K

