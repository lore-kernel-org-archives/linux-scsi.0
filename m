Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD54C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 17:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F096420671
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 17:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BFDYrOCU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgEPRqV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 May 2020 13:46:21 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:44139 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726253AbgEPRqU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2020 13:46:20 -0400
X-UUID: d0a03bc71ba14caabee318dc19c9ed27-20200517
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=z1TTuCg3NJvkHg8KJNycdBi8f0LcMeAbQUA/KfdMrMY=;
        b=BFDYrOCUDya+qX+kEU+EE1Ep32hApoZAKZubhDOS1LTDAl1OQev70zQSJYqIf82iFJbnGPMSLEHxP4i42mV/l+Cm/qCiwTDHmOmkz4ZPy7TxHXBKzsfvboNZH1x8rCJMwniUyhqfTdtOjwk4FDV5rdOb57dtfsufRtKVn7/d0uY=;
X-UUID: d0a03bc71ba14caabee318dc19c9ed27-20200517
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1040094759; Sun, 17 May 2020 01:46:18 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 17 May 2020 01:46:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 17 May 2020 01:46:13 +0800
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
Subject: [PATCH v3 1/5] scsi: ufs: Remove unnecessary memset for dev_info
Date:   Sun, 17 May 2020 01:46:11 +0800
Message-ID: <20200516174615.15445-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200516174615.15445-1-stanley.chu@mediatek.com>
References: <20200516174615.15445-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhlIHdob2xlIFVGUyBob3N0IGluc3RhbmNlIGhhcyBiZWVuIHplcm8taW5pdGlhbGl6ZWQgYnkN
CnNjc2lfaG9zdF9hbGxvYygpLCB0aHVzIFVGUyBkcml2ZXIgZG9lcyBub3QgbmVlZCB0byBjbGVh
cg0KImRldl9pbmZvIiBtZW1iZXIgc3BlY2lmaWNhbGx5IGluIHVmc2hjZF9kZXZpY2VfcGFyYW1z
X2luaXQoKS4NCg0KU2ltcGx5IHJlbW92ZSB0aGUgdW5uZWNlc3NhcnkgY29kZS4NCg0KU2lnbmVk
LW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRy
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAzIC0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAzIGRlbGV0
aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IGFjYTUwZWQzOTg0NC4uNGEzZjM2NDhjNjRmIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KQEAgLTcyNjIsOSArNzI2Miw2IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Rl
dmljZV9wYXJhbXNfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlib29sIGZsYWc7DQogCWlu
dCByZXQ7DQogDQotCS8qIENsZWFyIGFueSBwcmV2aW91cyBVRlMgZGV2aWNlIGluZm9ybWF0aW9u
ICovDQotCW1lbXNldCgmaGJhLT5kZXZfaW5mbywgMCwgc2l6ZW9mKGhiYS0+ZGV2X2luZm8pKTsN
Ci0NCiAJLyogSW5pdCBjaGVjayBmb3IgZGV2aWNlIGRlc2NyaXB0b3Igc2l6ZXMgKi8NCiAJdWZz
aGNkX2luaXRfZGVzY19zaXplcyhoYmEpOw0KIA0KLS0gDQoyLjE4LjANCg==

