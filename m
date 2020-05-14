Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B955C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 15:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0847A20643
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 15:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="q926edJ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgENPB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 11:01:29 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:55643 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727123AbgENPB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 11:01:28 -0400
X-UUID: e273d58b384141508eda1342c3bed448-20200514
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=oQJZc3MeYI2g59uaOgNPF1yMp/cTZbERUuTkSYQyTrQ=;
        b=q926edJ2JqFC1RyS5iDL2Vl2ac5uA/AtJqQ8RYzBUSNILRtJLmlhnhqlSKalpgvx+yfsyghsj8QZ1eWStdlbqUlkWmAnkiAabUi6vi21GbJLH+DIukVVFcfrx09oNc+pNyFCERKzdEqGSzvil19CJvnEhwX/ASmtkOyvN71UWHE=;
X-UUID: e273d58b384141508eda1342c3bed448-20200514
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1019211806; Thu, 14 May 2020 23:01:25 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 14 May 2020 23:01:20 +0800
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
Subject: [PATCH v2 0/4] scsi: ufs: Fix WriteBooster and cleanup UFS driver
Date:   Thu, 14 May 2020 23:01:18 +0800
Message-ID: <20200514150122.32110-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 7A70CB63B83E9314C8CEA15F10C51D8DEFD06F744864204F25234DFCB60B92172000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2ggc2V0IGZpeGVzIHNvbWUgV3JpdGVCb29zdGVyIGlzc3VlcyBhbmQg
ZG8gc21hbGwgY2xlYW51cCBpbiBVRlMgZHJpdmVyDQoNCnYxIC0+IHYyDQogIC0gUmVtb3ZlIGR1
bW15IG5ldyBsaW5lIGluIHBhdGNoIFs0XSAoQXN1dG9zaCkNCiAgLSBBZGQgbW9yZSBsaW1pdGF0
aW9uIHRvIGFsbG93IFdyaXRlQm9vc3RlciBmbHVzaCBkdXJpbmcgSGliZXJuOCBpbiBydW50aW1l
LXN1c3BlbmQuIE5vdyB0aGUgZGV2aWNlIHBvd2VyIG1vZGUgaXMga2VwdCBhcyBBY3RpdmUgcG93
ZXIgbW9kZSBvbmx5IGlmIGxpbmsgaXMgcHV0IGluIEhpYmVybjggb3IgQXV0by1IaWJlcm44IGlz
IGVuYWJsZWQgZHVyaW5nIHJ1bnRpbWUtc3VzcGVuZCAoQXN1dG9zaCkNCg0KU3RhbmxleSBDaHUg
KDQpOg0KICBzY3NpOiB1ZnM6IFJlbW92ZSB1bm5lY2Vzc2FyeSBtZW1zZXQgZm9yIGRldl9pbmZv
DQogIHNjc2k6IHVmczogQWxsb3cgV3JpdGVCb29zdGVyIG9uIFVGUyAyLjIgZGV2aWNlcw0KICBz
Y3NpOiB1ZnM6IEZpeCBpbmRleCBvZiBhdHRyaWJ1dGVzIHF1ZXJ5IGZvciBXcml0ZUJvb3N0ZXIg
ZmVhdHVyZQ0KICBzY3NpOiB1ZnM6IEZpeCBXcml0ZUJvb3N0ZXIgZmx1c2ggZHVyaW5nIHJ1bnRp
bWUgc3VzcGVuZA0KDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtc3lzZnMuYyB8IDEzICsrKysrKy0t
DQogZHJpdmVycy9zY3NpL3Vmcy91ZnMuaCAgICAgICB8ICAxIC0NCiBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jICAgIHwgNjIgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tDQog
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICB8ICAyICstDQogNCBmaWxlcyBjaGFuZ2VkLCA0
NSBpbnNlcnRpb25zKCspLCAzMyBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

