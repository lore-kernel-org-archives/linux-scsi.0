Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBD2C54E4A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 10:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B9CA205ED
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 10:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="h6l6wzrE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbgELKr4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 06:47:56 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:18219 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726187AbgELKr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2020 06:47:56 -0400
X-UUID: e6962d072b974179b1eee57e1f37eabe-20200512
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=SfDQhGdBasCQf6xPUtgVXlprnq+Pu6y0OxSgqJwkc34=;
        b=h6l6wzrEYPsUXWDlrS7KnHXj4kW5aiW17VLTM7bs/xZEJrUzvGKxdjjSeVyZSe0qik0y0JaeXWcfVbjE1Hp7p3wr3zgibNV8VaEm3EtS61C/96fefA9cy0O795zvRy12741VrthZmz6TepoxCFw++qoXAZfVZbMDRwhZ4hge8fw=;
X-UUID: e6962d072b974179b1eee57e1f37eabe-20200512
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1833854196; Tue, 12 May 2020 18:47:52 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 12 May 2020 18:47:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 May 2020 18:47:50 +0800
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
Subject: [PATCH v1 1/4] scsi: ufs: Remove unnecessary memset for dev_info
Date:   Tue, 12 May 2020 18:47:47 +0800
Message-ID: <20200512104750.8711-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200512104750.8711-1-stanley.chu@mediatek.com>
References: <20200512104750.8711-1-stanley.chu@mediatek.com>
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
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IDQyNjA3M2E1MThlZi4uNDFhZDQ1MDFiMGQwIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KQEAgLTcyNzksOSArNzI3OSw2IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Rl
dmljZV9wYXJhbXNfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlib29sIGZsYWc7DQogCWlu
dCByZXQ7DQogDQotCS8qIENsZWFyIGFueSBwcmV2aW91cyBVRlMgZGV2aWNlIGluZm9ybWF0aW9u
ICovDQotCW1lbXNldCgmaGJhLT5kZXZfaW5mbywgMCwgc2l6ZW9mKGhiYS0+ZGV2X2luZm8pKTsN
Ci0NCiAJLyogSW5pdCBjaGVjayBmb3IgZGV2aWNlIGRlc2NyaXB0b3Igc2l6ZXMgKi8NCiAJdWZz
aGNkX2luaXRfZGVzY19zaXplcyhoYmEpOw0KIA0KLS0gDQoyLjE4LjANCg==

