Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3549C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 05:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7BA1206C3
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 05:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jSKpklSB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgHIF5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Aug 2020 01:57:10 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:2383 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbgHIF5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2020 01:57:10 -0400
X-UUID: 5c0718d7277a4011b753b6266f129b94-20200809
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=wMv8UeanSIEI/rr6iehFW3l1uTFbMmp/Tsna9NnNFoA=;
        b=jSKpklSBxcXPey24gS82xbg1Zda34hQ72ao7pXmU55EpGcQeYF2/m35NjUtYqL+UTMYEUXEu/YabJaFbEVCA+YIeFBJNoRiJdiNSQDITTxT3Jbd4KJmeO4Epp0d8+VzHQAO/2UMZGAUKovkdY6fhYsz/vPPLbsPPtcYJOeG0B+o=;
X-UUID: 5c0718d7277a4011b753b6266f129b94-20200809
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1859326095; Sun, 09 Aug 2020 13:57:04 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 9 Aug 2020 13:57:01 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 9 Aug 2020 13:57:02 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1] scsi: ufs-mediatek: Fix incorrect time to wait link status
Date:   Sun, 9 Aug 2020 13:57:02 +0800
Message-ID: <20200809055702.20140-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rml4IGluY29ycmVjdCBjYWxjdWxhdGlvbiBvZiAibXMiIGJhc2VkIHdhaXRpbmcgdGltZSBpbg0K
ZnVuY3Rpb24gdWZzX210a19zZXR1cF9jbG9ja3MoKS4NCg0KRml4ZXM6IDkwMDZlMzk4NmY2NiAo
InNjc2k6IHVmcy1tZWRpYXRlazogRG8gbm90IGdhdGUgY2xvY2tzIGlmIGF1dG8taGliZXJuOCBp
cyBub3QgZW50ZXJlZCB5ZXQiKQ0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXku
Y2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMg
fCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggMjljZDAxN2MxYWEwLi4xNzU1ZGQ2YjA0YWUg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQorKysgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAtMjEyLDcgKzIxMiw3IEBAIHN0YXRpYyBp
bnQgdWZzX210a193YWl0X2xpbmtfc3RhdGUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTMyIHN0YXRl
LA0KIAlrdGltZV90IHRpbWVvdXQsIHRpbWVfY2hlY2tlZDsNCiAJdTMyIHZhbDsNCiANCi0JdGlt
ZW91dCA9IGt0aW1lX2FkZF91cyhrdGltZV9nZXQoKSwgbXNfdG9fa3RpbWUobWF4X3dhaXRfbXMp
KTsNCisJdGltZW91dCA9IGt0aW1lX2FkZF9tcyhrdGltZV9nZXQoKSwgbWF4X3dhaXRfbXMpOw0K
IAlkbyB7DQogCQl0aW1lX2NoZWNrZWQgPSBrdGltZV9nZXQoKTsNCiAJCXVmc2hjZF93cml0ZWwo
aGJhLCAweDIwLCBSRUdfVUZTX0RFQlVHX1NFTCk7DQotLSANCjIuMTguMA0K

