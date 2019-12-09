Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E98C2BD09
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 08:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2F592077B
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 08:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HSvv/NbE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfLII3b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 03:29:31 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:64731 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727221AbfLII3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 03:29:31 -0500
X-UUID: 00a880a1b6b8474b8a098fe67069acb2-20191209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=SKHFGNVcj1YeLG7m4C4Dpi+bv0S2tUzFl3AhI7+421E=;
        b=HSvv/NbE3pLGEXvSy7IIBS2cQj70svZD0U+RsGdCDzAvo1qOak1vw49jz21bbP2QBVhB4YAhznwFT+nAYXKdRVm6v1uoPQdO8Znz8KBC/BO0Dybk1voaBACUCCo1+045sE3i58SJ3lHrEvLC//u4JBggGFhczEJ5q4Mg3KWJ0XQ=;
X-UUID: 00a880a1b6b8474b8a098fe67069acb2-20191209
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1147897168; Mon, 09 Dec 2019 16:29:23 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 9 Dec 2019 16:28:54 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 9 Dec 2019 16:29:00 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <f.fainelli@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <leon.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 0/2] scsi: ufs-mediatek: add device reset implementation
Date:   Mon, 9 Dec 2019 16:29:12 +0800
Message-ID: <1575880154-6099-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhpcyBwYXRjaHNldCBhZGRzIGltcGxlbWVudGF0aW9uIG9mIFVGUyBkZXZpY2UgcmVzZXQgdm9w
cyBpbiBNZWRpYVRlayBVRlMgZHJpdmVyLg0KDQpTdGFubGV5IENodSAoMik6DQogIHNvYzogbWVk
aWF0ZWs6IGFkZCBoZWFkZXIgZm9yIFNpUCBzZXJ2aWNlIGludGVyZmFjZQ0KICBzY3NpOiB1ZnMt
bWVkaWF0ZWs6IGFkZCBkZXZpY2UgcmVzZXQgaW1wbGVtZW50YXRpb24NCg0KIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMgICAgICAgICAgfCAyNyArKysrKysrKysrKysrKysrKysrKysN
CiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oICAgICAgICAgIHwgIDcgKysrKysrDQog
aW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9zdmMuaCB8IDMwICsrKysrKysrKysr
KysrKysrKysrKysrKw0KIDMgZmlsZXMgY2hhbmdlZCwgNjQgaW5zZXJ0aW9ucygrKQ0KIGNyZWF0
ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oDQoN
Ci0tIA0KMi4xOC4wDQo=

