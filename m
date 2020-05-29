Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D35C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 09:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4DA82072D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 09:23:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kDCJTzk4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgE2JXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 05:23:17 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:4907 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726477AbgE2JXQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 05:23:16 -0400
X-UUID: d8ec2b1b71fc4adc99538fcfd922340c-20200529
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=C7jiqWJqQUQFX3wanPIiepBSjlj6iNhBD/xNOyaJx/o=;
        b=kDCJTzk4x9EtqMkosbm3DAGFx0pWXlTB7sW3ZcZqrgz+AXw6iJUOLZqazpKxcEMmA9jmKCICggLLMID5HMjyDYmJ1ig5CfhfcE04ZC+Rd7OOnM/EZ40UtPNZqaudmFALvmHyaPlPP22b6OjO2toRWq7109FZebZaPy1ayyuQRcM=;
X-UUID: d8ec2b1b71fc4adc99538fcfd922340c-20200529
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1832165055; Fri, 29 May 2020 17:23:14 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 29 May 2020 17:23:10 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 29 May 2020 17:23:09 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <pengshun.zhao@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 0/5] scsi: ufs-mediatek: Fix clk-gating and introduce low-power mode for vccq2
Date:   Fri, 29 May 2020 17:23:05 +0800
Message-ID: <20200529092310.1106-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: BC13AC5E0CEC9B039233AABE34122B89E422FCA98B5DA0A01FF13D32ED2EEF7E2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpUaGlzIHNlcmllcyBmaXhlcyBjbGstZ2F0aW5nIGlzc3VlcyBhbmQgaW50cm9kdWNlcyBs
b3ctcG93ZXIgbW9kZSBmb3IgdmNjcTIgaW4gTWVkaWFUZWsgcGxhdGZvcm1zLg0KDQp2MSAtPiB2
MjoNCiAgLSBBZGQgcGF0Y2ggWzRdIGFuZCBbNV0NCg0KU3RhbmxleSBDaHUgKDUpOg0KICBzY3Np
OiB1ZnMtbWVkaWF0ZWs6IEZpeCBpbXByZWNpc2Ugd2FpdGluZyB0aW1lIGZvciByZWYtY2xrIGNv
bnRyb2wNCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBEbyBub3QgZ2F0ZSBjbG9ja3MgaWYgYXV0by1o
aWJlcm44IGlzIG5vdCBlbnRlcmVkDQogICAgeWV0DQogIHNjc2k6IHVmcy1tZWRpYXRlazogSW50
cm9kdWNlIGxvdy1wb3dlciBtb2RlIGZvciBkZXZpY2UgcG93ZXIgc3VwcGx5DQogIHNjc2k6IHVm
cy1tZWRpYXRlazogRml4IHVuYmFsYW5jZWQgY2xvY2sgb24vb2ZmDQogIHNjc2k6IHVmcy1tZWRp
YXRlazogQWxsb3cgdW5ib3VuZCBtcGh5DQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jIHwgMTEyICsrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQogZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuaCB8ICAgMiArLQ0KIDIgZmlsZXMgY2hhbmdlZCwgODQgaW5zZXJ0
aW9ucygrKSwgMzAgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

