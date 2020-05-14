Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B93C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 15:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C21C20643
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 15:01:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LM79fXQp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgENPBh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 11:01:37 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:9793 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728315AbgENPBf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 11:01:35 -0400
X-UUID: f8ede2745fee42fc9e8de19730aa31cc-20200514
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=shvkj9A9bwueIh1LMlmBnCkpSglW983N02ZzRfmxG8k=;
        b=LM79fXQpLxg9nVaRgeO6D1J9tdaAudN+SvyYWVGzBObBZRo6wB4h3RQdI5JXq/B4pDa3vcUTGuTZkl/vZRS9tMQpgdL1Sfh6I5NOuxiKkZ5c4rD6h747FhsMusKWfeqcNRlKT5SbGd4GYmrQn/9K7Zk3eDQzK1m4IoF6H1iDr4U=;
X-UUID: f8ede2745fee42fc9e8de19730aa31cc-20200514
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 610882712; Thu, 14 May 2020 23:01:31 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 14 May 2020 23:01:21 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 23:01:20 +0800
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
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 2/4] scsi: ufs: Allow WriteBooster on UFS 2.2 devices
Date:   Thu, 14 May 2020 23:01:20 +0800
Message-ID: <20200514150122.32110-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200514150122.32110-1-stanley.chu@mediatek.com>
References: <20200514150122.32110-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWNjb3JkaW5nIHRvIHRoZSBVRlMgc3BlY2lmaWNhdGlvbiwgV3JpdGVCb29zdGVyIGlzIG9mZmlj
aWFsbHkNCnN1cHBvcnRlZCBieSBVRlMgMi4yLg0KDQpTaW5jZSBVRlMgMi4yIHNwZWNpZmljYXRp
b24gaGFzIGJlZW4gZmluYWxpemVkIGluIEpFREVDIGFuZA0Kc3VjaCBkZXZpY2VzIGhhdmUgYWxz
byBzaG93ZWQgdXAgaW4gdGhlIG1hcmtldCwgbW9kaWZ5IHRoZQ0KY2hlY2tpbmcgcnVsZSBmb3Ig
dWZzaGNkX3diX3Byb2JlKCkgdG8gYWxsb3cgdGhlc2UgZGV2aWNlcyB0byBlbmFibGUNCldyaXRl
Qm9vc3Rlci4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlh
dGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAxICsNCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCA0MWFkNDUwMWIwZDAu
LmIyOThiZGQzZTY5NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisr
KyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC02OTQyLDYgKzY5NDIsNyBAQCBzdGF0
aWMgaW50IHVmc19nZXRfZGV2aWNlX2Rlc2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJICogVUZT
X0RFVklDRV9RVUlSS19TVVBQT1JUX0VYVEVOREVEX0ZFQVRVUkVTIGVuYWJsZWQNCiAJICovDQog
CWlmIChkZXZfaW5mby0+d3NwZWN2ZXJzaW9uID49IDB4MzEwIHx8DQorCSAgICBkZXZfaW5mby0+
d3NwZWN2ZXJzaW9uID09IDB4MjIwIHx8DQogCSAgICAoaGJhLT5kZXZfcXVpcmtzICYgVUZTX0RF
VklDRV9RVUlSS19TVVBQT1JUX0VYVEVOREVEX0ZFQVRVUkVTKSkNCiAJCXVmc2hjZF93Yl9wcm9i
ZShoYmEsIGRlc2NfYnVmKTsNCiANCi0tIA0KMi4xOC4wDQo=

