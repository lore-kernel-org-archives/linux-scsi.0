Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBEEC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 05:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 293C4207ED
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 05:37:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EpIkAqKG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgFJFhA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 01:37:00 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:18501 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726072AbgFJFg7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 01:36:59 -0400
X-UUID: f4fe1527b18242e59df5a25dc1234c7c-20200610
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=81MzMxuTxhJRJ2KSmMqjeuJ8g5ENbQ+Pctj6gUCRbTw=;
        b=EpIkAqKGkXRbR+Wjg+X8AO0SQwT8tBprI3L46Oj2S1JbL4CpiOJWE55tldqJ4DQjMX5iCRl64G0ea6Y1Jb4kadGCFKiEeldzqx+ra3hzWvn61iWXQt6IGq26gyYEvi9hLyIwr38TtSEfgIRJN+Z9o2ZX0b+jRTHfnT66O/ZHSLA=;
X-UUID: f4fe1527b18242e59df5a25dc1234c7c-20200610
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1094438614; Wed, 10 Jun 2020 13:36:55 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 10 Jun 2020 13:36:52 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Jun 2020 13:36:45 +0800
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
Subject: [PATCH v1 0/2] scsi: ufs: Fix and cleanup device quirk
Date:   Wed, 10 Jun 2020 13:36:43 +0800
Message-ID: <20200610053645.19975-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 985FC581C3A3FF4FA0367BAA3575C081C5D88FC46DFED05247EB138C7C673FB12000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQp0aGlzIHNlcmllcyBwcm92aWRlcyBzb21lIGRldmljZSBxdWlyayBmaXhlcyBhbmQgY2xl
YW51cHMuDQoNClN0YW5sZXkgQ2h1ICgyKToNCiAgc2NzaTogdWZzOiBBZGQgREVMQVlfQkVGT1JF
X0xQTSBxdWlyayBmb3IgTWljcm9uIGRldmljZXMNCiAgc2NzaTogdWZzOiBDbGVhbnVwIGRldmlj
ZSB2ZW5kb3IgYW5kIHF1aXJrIGRlZmluaXRpb24NCg0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzX3F1
aXJrcy5oIHwgMyArKy0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICB8IDYgKysrLS0t
DQogMiBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQoNCi0t
IA0KMi4xOC4wDQo=

