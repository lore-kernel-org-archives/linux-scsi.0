Return-Path: <SRS0=SQ1Y=2D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063BEC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 08:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C72D92253D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 08:46:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EpaJD7RW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfLMIqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Dec 2019 03:46:31 -0500
Received: from mailgw02.mediatek.com ([216.200.240.185]:51373 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfLMIqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2019 03:46:31 -0500
X-UUID: 0b3971594b4b4a4d850fe3ae6f916d4c-20191213
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=VlbmHzvmIOMrtNrr7bRhgkYfE8bVDzx/HFbQW2aC+F4=;
        b=EpaJD7RWjJdz4CLXUCVZjxA+W9/F4772lmY49vKdgckM9LGyPjOXNSJGDZiSvLCLDf8DYXoLwrtyc+gFxb/LfaH42TXXAi3byxkfjNpHQ1CNwTQiyltFS+salJuTRxW6Q7VZc7MWbAc8sWmZoeGBCkTb0LiiGd09+1R20c6bYO8=;
X-UUID: 0b3971594b4b4a4d850fe3ae6f916d4c-20191213
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 640992268; Fri, 13 Dec 2019 00:46:28 -0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 13 Dec 2019 16:11:16 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 13 Dec 2019 16:11:05 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/4] scsi: ufs-mediatek: provide power management
Date:   Fri, 13 Dec 2019 16:11:31 +0800
Message-ID: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: EADCA4A00BE1D93B32B7DFD36F29DF1E98405723AD033FCEF1A3219B7668779A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhlIHBhdGNoIHNldCBwcm92aWRlcyBwb3dlciBtYW5hZ2VtZW50IG9uIE1lZGlhVGVrIENoaXBz
ZXRzIGJ5DQoNCjEuIEludHJvZHVjZSByZWZlcmVuY2UgY2xvY2sgY29udHJvbA0KMi4gQ29uZmln
dXJlIGN1c3RvbWl6ZWQgYXV0by1oaWJlcm5hdGUgdGltZXINCjMuIEVuYWJsZSBjbGstZ2F0aW5n
IHdpdGggY3VzdG9taXplZCBkZWxheWVkIHRpbWVyIHZhbHVlDQoNClN0YW5sZXkgQ2h1ICg0KToN
CiAgc2NzaTogdWZzLW1lZGlhdGVrOiBpbnRyb2R1Y2UgcmVmZXJlbmNlIGNsb2NrIGNvbnRyb2wN
CiAgc2NzaTogdWZzOiBleHBvcnQgdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUgZm9yIHZlbmRv
ciB1c2FnZQ0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGNvbmZpZ3VyZSBjdXN0b21pemVkIGF1dG8t
aGliZXJuOCB0aW1lcg0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGNvbmZpZ3VyZSBhbmQgZW5hYmxl
IGNsay1nYXRpbmcNCg0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCA5MyArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRp
YXRlay5oIHwgMjAgKysrKysrLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMgICAgfCAy
MCAtLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgICB8IDE4ICsrKysrKysN
CiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oICAgICAgIHwgIDEgKw0KIDUgZmlsZXMgY2hhbmdl
ZCwgMTI2IGluc2VydGlvbnMoKyksIDI2IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

