Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F14C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 15:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D871E2081A
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 15:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EfHKkzwA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgFLPKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 11:10:12 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:29623 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726089AbgFLPKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 11:10:12 -0400
X-UUID: 5bfd24611ca24a82923c311a8f0d040c-20200612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=spni8HOr7ciue/sjPRzTXGWn3zfeepDjbItdYZ02g70=;
        b=EfHKkzwA7p3SdFUgMPU35rfC1x3DGKlnx2fFGGT7hwni/KGTNS5qUrn1tgQa049//Aq782lMBTfCmCKSqht8rMvVECCcJ/wxNSyZwoRwOQrjUd22xzvL4g/I6I3ITT+16otjB5FvmImkt0MyvqTN7aQHA5ctgKezVw8q8f2mNbw=;
X-UUID: 5bfd24611ca24a82923c311a8f0d040c-20200612
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1315467522; Fri, 12 Jun 2020 23:10:05 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 12 Jun 2020 23:10:02 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Jun 2020 23:10:01 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] scsi: ufs: Add trace event for UIC commands
Date:   Fri, 12 Jun 2020 23:09:58 +0800
Message-ID: <20200612151000.27639-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpUaGlzIHNlcmllcyBhZGRzIHRyYWNlIGV2ZW50IGZvciBVSUMgY29tbWFuZHMgYW5kIGRv
IGEgc21hbGwgY2xlYW51cCBpbiBzdHJ1Y3QgdWljX2NvbW1hbmQuDQoNClN0YW5sZXkgQ2h1ICgy
KToNCiAgc2NzaTogdWZzOiBSZW1vdmUgdW51c2VkIGZpZWxkIGluIHN0cnVjdCB1aWNfY29tbWFu
ZA0KICBzY3NpOiB1ZnM6IEFkZCB0cmFjZSBldmVudCBmb3IgVUlDIGNvbW1hbmRzDQoNCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICB8IDI5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
DQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgfCAgMiAtLQ0KIGluY2x1ZGUvdHJhY2UvZXZl
bnRzL3Vmcy5oIHwgMzMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQogMyBmaWxl
cyBjaGFuZ2VkLCA2MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTgu
MA0K

