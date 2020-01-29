Return-Path: <SRS0=J5Rw=3S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72567C35240
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 07:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A1842070E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 07:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="M7uGF+zW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgA2HjO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jan 2020 02:39:14 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:32602 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726043AbgA2HjO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2020 02:39:14 -0500
X-UUID: 5921f73c80dd484f872685c1ebedf13a-20200129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=7gNPecS1EJzqmeFhY3wJ8BbZtF2s1Gokz2MxXu14+jM=;
        b=M7uGF+zWpVLXSEVO75MVbg52A7zcr0RlbEJQaRbW5tKSaLx8noZWaCseDWfttHNCeouhNnVRhkbouHhzU9EgeJeTSuwfzqygAWwz348darDQqUCGlrbZl/HbrBJk+3ibmCD3w+6RyAZB8hgexZ4q+7/PEhmev0rCG4HQWieX68s=;
X-UUID: 5921f73c80dd484f872685c1ebedf13a-20200129
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 126285517; Wed, 29 Jan 2020 15:39:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 29 Jan 2020 15:37:54 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 29 Jan 2020 15:39:11 +0800
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
Subject: [PATCH v3 0/4] MediaTek UFS vendor implemenation part III and Auto-Hibern8 fix
Date:   Wed, 29 Jan 2020 15:38:58 +0800
Message-ID: <20200129073902.5786-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 3DECD09A3C884DAB6A535DB35BC0270C3BA4EBCFB82570349D130702622213F42000:8
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
cmVmZXJlbmNlIGNsb2NrIGZvciBBdXRvLUhpYmVybjggY2FzZQ0KDQp2MiAtPiB2Mw0KCS0gU3F1
YXNoIGJlbG93IHBhdGNoZXMgdG8gYSBzaW5nbGUgcGF0Y2ggKEJlYW4pDQoJCS0gc2NzaTogdWZz
OiBhZGQgdWZzaGNkX2lzX2F1dG9faGliZXJuOF9lbmFibGVkIGZhY2lsaXR5DQoJCS0gc2NzaTog
dWZzOiBmaXggYXV0by1oaWJlcm44IGVycm9yIGRldGVjdGlvbg0KCS0gQWRkIEZpeGVzIHRhZyBp
biBwYXRjaCAic2NzaTogdWZzOiBmaXggQXV0by1IaWJlcm44IGVycm9yIGRldGVjdGlvbiIgKEJl
YW4pDQoJLSBSZW5hbWUgVlNfTElOS19ISUJFUjggdG8gVlNfTElOS19ISUJFUk44IGluIHBhdGNo
ICJzY3NpOiB1ZnMtbWVkaWF0ZWs6IGdhdGUgcmVmLWNsayBkdXJpbmcgQXV0by1IaWJlcm44Ig0K
DQp2MSAtPiB2Mg0KCS0gRml4IGFuZCByZWZpbmUgY29tbWl0IG1lc3NhZ2VzLg0KDQpTdGFubGV5
IENodSAoNCk6DQogIHNjc2k6IHVmcy1tZWRpYXRlazogZW5zdXJlIFVuaVBybyBpcyBub3QgcG93
ZXJlZCBkb3duIGJlZm9yZSBsaW5rdXANCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBzdXBwb3J0IGxp
bmtvZmYgc3RhdGUgZHVyaW5nIHN1c3BlbmQNCiAgc2NzaTogdWZzOiBmaXggQXV0by1IaWJlcm44
IGVycm9yIGRldGVjdGlvbg0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGdhdGUgcmVmLWNsayBkdXJp
bmcgQXV0by1IaWJlcm44DQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgNjcg
KysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMt
bWVkaWF0ZWsuaCB8IDEyICsrKysrKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgICAg
fCAgMyArLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAgICAgfCAgNiArKysNCiA0IGZp
bGVzIGNoYW5nZWQsIDYzIGluc2VydGlvbnMoKyksIDI1IGRlbGV0aW9ucygtKQ0KDQotLSANCjIu
MTguMA0K

