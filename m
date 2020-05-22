Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89653C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60108207FB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KM38vZCs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgEVIcV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 04:32:21 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:4907 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729055AbgEVIcU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2020 04:32:20 -0400
X-UUID: 37baac7ac2b04b75a9d8e9be32737cbf-20200522
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=CeRdUazTRZ6Q4UL/01a41bh8OpjiO6wKwUAXb2WuqdM=;
        b=KM38vZCs3L7nB88xu/BGflp6r00GI5kWsTrb31dLpxdGIcYnQr1KUryCugVG0EA2+k9g3gzYY5tjqLPu1nf6Bo4iP9MYAnJwzZbyH87L+Elgn3IxmPC6MDCEK++wIqc4JqTTxojSxaKN5Ur1bRZEOvhTLMyahduQOkQ/ckVNkVo=;
X-UUID: 37baac7ac2b04b75a9d8e9be32737cbf-20200522
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 262690937; Fri, 22 May 2020 16:32:15 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 22 May 2020 16:32:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 16:32:13 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <asutoshd@codeaurora.org>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <Virtual_Global_UFS_Upstream@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 0/4] scsi: ufs: Fix WriteBooster and cleanup UFS driver
Date:   Fri, 22 May 2020 16:32:08 +0800
Message-ID: <20200522083212.4008-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2ggc2V0IGZpeGVzIHNvbWUgV3JpdGVCb29zdGVyIGlzc3VlcyBhbmQg
ZG8gc21hbGwgY2xlYW51cCBpbiBVRlMgZHJpdmVyDQoNCnYzIC0+IHY0DQogIC0gU3F1YXNoIHBh
dGNoIFs0XSBhbmQgWzVdIChBc3V0b3NoKQ0KICAtIEZpeCBjb21taXQgbWVzc2FnZSBpbiBwYXRj
aCBbNF0NCg0KdjIgLT4gdjMNCiAgLSBJbnRyb2R1Y2UgcGF0Y2ggWzVdIHRvIGZpeCBwb3NzaWJs
ZSBWQ0MgcG93ZXIgZHJhaW4gZHVyaW5nIHJ1bnRpbWUgc3VzcGVuZCAoQXN1dG9zaCkNCg0KdjEg
LT4gdjINCiAgLSBSZW1vdmUgZHVtbXkgbmV3IGxpbmUgaW4gcGF0Y2ggWzRdIChBc3V0b3NoKQ0K
ICAtIEFkZCBtb3JlIGxpbWl0YXRpb24gdG8gYWxsb3cgV3JpdGVCb29zdGVyIGZsdXNoIGR1cmlu
ZyBIaWJlcm44IGluIHJ1bnRpbWUtc3VzcGVuZC4gTm93IHRoZSBkZXZpY2UgcG93ZXIgbW9kZSBp
cyBrZXB0IGFzIEFjdGl2ZSBwb3dlciBtb2RlIG9ubHkgaWYgbGluayBpcyBwdXQgaW4gSGliZXJu
OCBvciBBdXRvLUhpYmVybjggaXMgZW5hYmxlZCBkdXJpbmcgcnVudGltZS1zdXNwZW5kIChBc3V0
b3NoKQ0KDQpTdGFubGV5IENodSAoNCk6DQogIHNjc2k6IHVmczogUmVtb3ZlIHVubmVjZXNzYXJ5
IG1lbXNldCBmb3IgZGV2X2luZm8NCiAgc2NzaTogdWZzOiBBbGxvdyBXcml0ZUJvb3N0ZXIgb24g
VUZTIDIuMiBkZXZpY2VzDQogIHNjc2k6IHVmczogRml4IGluZGV4IG9mIGF0dHJpYnV0ZXMgcXVl
cnkgZm9yIFdyaXRlQm9vc3RlciBmZWF0dXJlDQogIHNjc2k6IHVmczogRml4IFdyaXRlQm9vc3Rl
ciBmbHVzaCBkdXJpbmcgcnVudGltZSBzdXNwZW5kDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1z
eXNmcy5jIHwgMTMgKysrKy0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy5oICAgICAgIHwgIDIgKy0N
CiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgIHwgOTkgKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICB8ICAzICstDQog
NCBmaWxlcyBjaGFuZ2VkLCA4MiBpbnNlcnRpb25zKCspLCAzNSBkZWxldGlvbnMoLSkNCg0KLS0g
DQoyLjE4LjANCg==

