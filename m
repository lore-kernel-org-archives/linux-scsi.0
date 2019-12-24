Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F03C2D0CF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 13:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EAAC206B7
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 13:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="p1RWa2OA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfLXNBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 08:01:18 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:15946 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726237AbfLXNBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 08:01:17 -0500
X-UUID: 7ccb7752c95e496eaf59cae2efb8cbd1-20191224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=ln+yfQ/ZBRXQ4iYsXUo9UdtHgaO9UZj0Crnusbw+dEg=;
        b=p1RWa2OA1tBuFIAGoRrucUQstKaB0fO1g2wjjuqcDyLTIhg28EXLvhHr0s9YekD4923D2JMV8d4SQ5GbiZbXwPEPMxlHbkr8GQpuxsCt2+bgdQi3S4IYAo9RHMtB2LVb2mkSjQ7HnPIFRo7Na4qNx7WAVePy4wIqCi3Z4ZqJTC4=;
X-UUID: 7ccb7752c95e496eaf59cae2efb8cbd1-20191224
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 302321835; Tue, 24 Dec 2019 21:01:09 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 24 Dec 2019 21:00:29 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 24 Dec 2019 21:00:05 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] scsi: ufs: use existed well-defined functions
Date:   Tue, 24 Dec 2019 21:01:04 +0800
Message-ID: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgZml4ZXMgdHdvIHNtYWxsIHBsYWNlIHRvIHVzZSBleGlzdGVk
IHdlbGwtZGVmaW5lZCBmdW5jdGlvbnMgdG8gcmVwbGFjZSBsZWdhY3kgc3RhdGVtZW50cy4NCg0K
U3RhbmxleSBDaHUgKDIpOg0KICBzY3NpOiB1ZnM6IHVuaWZ5IHNjc2lfYmxvY2tfcmVxdWVzdHMg
dXNhZ2UNCiAgc2NzaTogdWZzOiB1c2UgdWZzaGNkX3ZvcHNfZGJnX3JlZ2lzdGVyX2R1bXAgZm9y
IHZlbmRvciBzcGVjaWZpYw0KICAgIGR1bXBzDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
IHwgICAgNyArKystLS0tDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgNCBkZWxl
dGlvbnMoLSkNCg0KLS0gDQoxLjcuOS41DQo=

