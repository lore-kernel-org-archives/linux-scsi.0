Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9DEC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 17:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6890206C0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 17:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JGZBlk/L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgEPRqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 May 2020 13:46:40 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:20465 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726407AbgEPRqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2020 13:46:24 -0400
X-UUID: be12eaa8158047eda95f7e0694b10794-20200517
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=smxDr4bDqkE0WeFbg5czyt0T5/ZlATJAURAS2eLOh2c=;
        b=JGZBlk/L4DzWpESEXgjO/WytXBz+AnfEYA5JcWagqa9pnKHruznaANIpIjeQM3M5ahkItJicvVlDY5o/NzgA68DSzriIwt9QHKodoosmCfSNL8+MZcpLzIPqQryuJGSwISMCD9k+ILsSjDbYYeyr/wfwDJC4uiF8QEWc3e9OILI=;
X-UUID: be12eaa8158047eda95f7e0694b10794-20200517
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 343474321; Sun, 17 May 2020 01:46:18 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 17 May 2020 01:46:13 +0800
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
Subject: [PATCH v3 0/5] scsi: ufs: Fix WriteBooster and cleanup UFS driver
Date:   Sun, 17 May 2020 01:46:10 +0800
Message-ID: <20200516174615.15445-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: D1FFA3E32EA32E77CA68C80B76F405815EBCEA9C03532CCC767E5BDCDA7D90CF2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2ggc2V0IGZpeGVzIHNvbWUgV3JpdGVCb29zdGVyIGlzc3VlcyBhbmQg
ZG8gc21hbGwgY2xlYW51cCBpbiBVRlMgZHJpdmVyDQoNCnYyIC0+IHYzDQogIC0gSW50cm9kdWNl
IHBhdGNoIFs1XSB0byBmaXggcG9zc2libGUgVkNDIHBvd2VyIGRyYWluIGR1cmluZyBydW50aW1l
IHN1c3BlbmQgKEFzdXRvc2gpDQoNCnYxIC0+IHYyDQogIC0gUmVtb3ZlIGR1bW15IG5ldyBsaW5l
IGluIHBhdGNoIFs0XSAoQXN1dG9zaCkNCiAgLSBBZGQgbW9yZSBsaW1pdGF0aW9uIHRvIGFsbG93
IFdyaXRlQm9vc3RlciBmbHVzaCBkdXJpbmcgSGliZXJuOCBpbiBydW50aW1lLXN1c3BlbmQuIE5v
dyB0aGUgZGV2aWNlIHBvd2VyIG1vZGUgaXMga2VwdCBhcyBBY3RpdmUgcG93ZXIgbW9kZSBvbmx5
IGlmIGxpbmsgaXMgcHV0IGluIEhpYmVybjggb3IgQXV0by1IaWJlcm44IGlzIGVuYWJsZWQgZHVy
aW5nIHJ1bnRpbWUtc3VzcGVuZCAoQXN1dG9zaCkNCg0KU3RhbmxleSBDaHUgKDUpOg0KICBzY3Np
OiB1ZnM6IFJlbW92ZSB1bm5lY2Vzc2FyeSBtZW1zZXQgZm9yIGRldl9pbmZvDQogIHNjc2k6IHVm
czogQWxsb3cgV3JpdGVCb29zdGVyIG9uIFVGUyAyLjIgZGV2aWNlcw0KICBzY3NpOiB1ZnM6IEZp
eCBpbmRleCBvZiBhdHRyaWJ1dGVzIHF1ZXJ5IGZvciBXcml0ZUJvb3N0ZXIgZmVhdHVyZQ0KICBz
Y3NpOiB1ZnM6IEZpeCBXcml0ZUJvb3N0ZXIgZmx1c2ggZHVyaW5nIHJ1bnRpbWUgc3VzcGVuZA0K
ICBzY3NpOiB1ZnM6IEZpeCBwb3NzaWJsZSBWQ0MgcG93ZXIgZHJhaW4gZHVyaW5nIHJ1bnRpbWUg
c3VzcGVuZA0KDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtc3lzZnMuYyB8IDEzICsrKystDQogZHJp
dmVycy9zY3NpL3Vmcy91ZnMuaCAgICAgICB8ICAyICstDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYyAgICB8IDk5ICsrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQ0KIGRyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmggICAgfCAgMyArLQ0KIDQgZmlsZXMgY2hhbmdlZCwgODIgaW5z
ZXJ0aW9ucygrKSwgMzUgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

