Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBC7C35254
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 09:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC7CC20679
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 09:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Qguyf5gw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgBQJgG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 04:36:06 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:64865 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728302AbgBQJgG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2020 04:36:06 -0500
X-UUID: 70bfc36711714ab68d6215de8a4a836d-20200217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=ljyj3t+P8mA3ctjT5z3KXMuu7eotiYxj4ZmDblGxdoI=;
        b=Qguyf5gw67dF/SHcQVRKUEqe7tcboBTZOYRFdeon+YPn05W7tenjDxCaTkIx7sgvpWEiMprqL4A0LojdueSgkxVJyswQwyQa7DsVYg6EiBACKJlabc+ydphIRCWTTfN1Zt0wW23R2A79LqoZAOp5qEprJmM9GigTVS6Jf/1LC7g=;
X-UUID: 70bfc36711714ab68d6215de8a4a836d-20200217
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1482416248; Mon, 17 Feb 2020 17:36:01 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 17 Feb 2020 17:34:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 17 Feb 2020 17:35:36 +0800
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
Subject: [PATCH v1 0/2] scsi: ufs: fix waiting time for reference clock
Date:   Mon, 17 Feb 2020 17:35:57 +0800
Message-ID: <20200217093559.16830-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgYWRkcyB3YWl0aW5nIHRpbWUgZm9yIHJlZmVyZW5jZSBjbG9j
ayBpbiBib3RoIGNvbW1vbiBwYXRoIGFuZCBNZWRpYVRlayBVRlMgaW1wbGVtZW50aW9ucy4NCg0K
U3RhbmxleSBDaHUgKDIpOg0KICBzY3NpOiB1ZnM6IGFkZCByZXF1aXJlZCBkZWxheSBhZnRlciBn
YXRpbmcgcmVmZXJlbmNlIGNsb2NrDQogIHNjc2k6IHVmczogdWZzLW1lZGlhdGVrOiBhZGQgd2Fp
dGluZyB0aW1lIGZvciByZWZlcmVuY2UgY2xvY2sNCg0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1l
ZGlhdGVrLmMgfCA0NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCiBkcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIHwgIDIgKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jICAgICAgIHwgIDggKysrKystDQogMyBmaWxlcyBjaGFuZ2VkLCA1MyBpbnNlcnRpb25zKCsp
LCAzIGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

