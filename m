Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8332CC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 01:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5877020823
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 01:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="b6P2p5g4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgFLB0f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 21:26:35 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:19638 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726327AbgFLB0f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 21:26:35 -0400
X-UUID: 63a286d6d0a64f7a9b2a98bd162a626c-20200612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=mW39zfEbSzCeS9LVeu/0bwZR50QhQsI3o/dC6sfyMJQ=;
        b=b6P2p5g41rMRVs+ND6EoPHHbghp7o3mNp/Hhy5ABTEoX0fweCzQ57qkPIWPr7so5YGLaGdDbE1ByaSsGJ3cDIkyKTrSkBMehT4A8yS/0RsnCCR36UEK7hst3oK7Cy98OkRfGNCMm1bMCHp5xmU80jjgpoV7QhmhERLychgDi4so=;
X-UUID: 63a286d6d0a64f7a9b2a98bd162a626c-20200612
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 410470933; Fri, 12 Jun 2020 09:26:28 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 12 Jun 2020 09:26:27 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Jun 2020 09:26:21 +0800
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
Subject: [PATCH v2 0/2] scsi: ufs: Fix and cleanup device quirks
Date:   Fri, 12 Jun 2020 09:26:23 +0800
Message-ID: <20200612012625.6615-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQp0aGlzIHNlcmllcyBwcm92aWRlcyBzb21lIGRldmljZSBxdWlyayBmaXhlcyBhbmQgY2xl
YW51cHMuDQoNCnYxIC0+IHYyOg0KICAtIFNvcnQgZGV2aWNlIHF1aXJrcyBpbiBhbHBoYWJldGlj
YWwgb3JkZXIgKEFsaW0gQWtodGFyKQ0KDQpTdGFubGV5IENodSAoMik6DQogIHNjc2k6IHVmczog
QWRkIERFTEFZX0JFRk9SRV9MUE0gcXVpcmsgZm9yIE1pY3JvbiBkZXZpY2VzDQogIHNjc2k6IHVm
czogQ2xlYW51cCBkZXZpY2UgdmVuZG9yIG5hbWUgYW5kIGRldmljZSBxdWlyayB0YWJsZQ0KDQog
ZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmggfCAgMyArKy0NCiBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jICAgICB8IDE1ICsrKysrKystLS0tLS0tLQ0KIDIgZmlsZXMgY2hhbmdlZCwgOSBp
bnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

