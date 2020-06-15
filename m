Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0002AC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9331207D4
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:48:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pfynxBDm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgFOGsI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 02:48:08 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:48941 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728603AbgFOGsA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 02:48:00 -0400
X-UUID: 9ad64165efe149da81586e718ebcd412-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=6sskvS9E8A91kA1DIsgQnE7Mcroj4DNNwvI11p317Kg=;
        b=pfynxBDm5eu4j6Km9k3s09pLNgy4vcncQBh+ce9dnMaTBNmJWGGfsOgrPmIeZSh3vS7I5+uhWmPlaMG6tekSFJLffFZ6jaTTTV5WfmZQee0FoVP7Zl97FkZdZ5zxnCbUgp2WD3fF5AkJcr7ycZrUvU0bYCt5NunEP0xookaDEg4=;
X-UUID: 9ad64165efe149da81586e718ebcd412-20200615
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1057754218; Mon, 15 Jun 2020 14:47:56 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 14:47:54 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 14:47:53 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 0/2] scsi: ufs: Add trace event for UIC commands and cleanup UIC struct
Date:   Mon, 15 Jun 2020 14:47:51 +0800
Message-ID: <20200615064753.20935-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 8D5C5DFC44D1CCFA7C459F1F145365925C51A8DB378C958FCB620F0E9436551A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpUaGlzIHNlcmllcyBhZGRzIHRyYWNlIGV2ZW50IGZvciBVSUMgY29tbWFuZHMgYW5kIGRv
IGEgc21hbGwgY2xlYW51cCBpbiBzdHJ1Y3QgdWljX2NvbW1hbmQuDQoNCnYxIC0+IHYyOg0KICAt
IFJlbmFtZSAidWljX3NlbmQiIHRvICJzZW5kIiBhbmQgInVpY19jb21wbGV0ZSIgdG8gImNvbXBs
ZXRlIg0KICAtIE1vdmUgInNlbmQiIHRyYWNlIGJlZm9yZSBVSUMgY29tbWFuZCBpcyBzZW50IG90
aGVyd2lzZSAic2VuZCIgdHJhY2UgbWF5IGxvZyBpbmNvcnJlY3QgYXJndW1lbnRzDQogIC0gTW92
ZSAiY29tcGxldGUiIHRyYWNlIHRvIFVJQyBpbnRlcnJ1cHQgaGFuZGxlciB0byBtYWtlIGxvZ2dp
bmcgdGltZSBwcmVjaXNlDQoNClN0YW5sZXkgQ2h1ICgyKToNCiAgc2NzaTogdWZzOiBSZW1vdmUg
dW51c2VkIGZpZWxkIGluIHN0cnVjdCB1aWNfY29tbWFuZA0KICBzY3NpOiB1ZnM6IEFkZCB0cmFj
ZSBldmVudCBmb3IgVUlDIGNvbW1hbmRzDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICB8
IDI2ICsrKysrKysrKysrKysrKysrKysrKysrKysrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
aCAgfCAgNCAtLS0tDQogaW5jbHVkZS90cmFjZS9ldmVudHMvdWZzLmggfCAzMSArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrDQogMyBmaWxlcyBjaGFuZ2VkLCA1NyBpbnNlcnRpb25zKCsp
LCA0IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

