Return-Path: <SRS0=TzWF=Z5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F1DC2D0C4
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 06:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F0D524677
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 06:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fBX50hsn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfLGGjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Dec 2019 01:39:21 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:47499 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725869AbfLGGjV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Dec 2019 01:39:21 -0500
X-UUID: 5b9c889c68c34ae0902856daa7cedd21-20191207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=6pTSCSjrn28TvfGT/brokgQkzDrJ7jz09v0SGNUY0AI=;
        b=fBX50hsnMPczBvupi1NhxT48AhunHc2O6GhTyioaEmvB5LtGWVkfK2C6hBbs3snjqKWbirSe3AHtVXUlctFT1wlcOTA7p70/m421P1KgW4HW1Acwe3U13cDA/oHuw/ERj/pFPblHcDyH2OmDuHHVk/UBbgPJZ6Du74wnqVOOUzA=;
X-UUID: 5b9c889c68c34ae0902856daa7cedd21-20191207
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 819517392; Sat, 07 Dec 2019 14:39:12 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 7 Dec 2019 14:38:47 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 7 Dec 2019 14:38:43 +0800
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
        <leon.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] scsi: ufs-mediatek: add device reset implementation
Date:   Sat, 7 Dec 2019 14:39:06 +0800
Message-ID: <1575700748-28191-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 6A5321628A49D3B31F32B5F0218FA327838C542E2A65577B39D2A68EC24ADD6F2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhpcyBwYXRjaHNldCBhZGQgaW1wbGVtZW50YXRpb24gb2YgVUZTIGRldmljZSByZXNldCB2b3Bz
IGluIE1lZGlhVGVrIFVGUyBkcml2ZXIuDQoNClN0YW5sZXkgQ2h1ICgyKToNCiAgc29jOiBtZWRp
YXRlazogYWRkIGhlYWRlciBmb3IgU2lQIHNlcnZpY2UgaW50ZXJmYWNlDQogIHNjc2k6IHVmcy1t
ZWRpYXRlazogYWRkIGRldmljZSByZXNldCBpbXBsZW1lbnRhdGlvbg0KDQogZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuYyAgICAgICAgICB8IDI3ICsrKysrKysrKysrKysrKysrKysrKysr
Kw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggICAgICAgICAgfCAgNyArKysrKysN
CiBpbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oIHwgMjYgKysrKysrKysr
KysrKysrKysrKysrKysNCiAzIGZpbGVzIGNoYW5nZWQsIDYwIGluc2VydGlvbnMoKykNCiBjcmVh
dGUgbW9kZSAxMDA2NDQgaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9zdmMuaA0K
DQotLSANCjIuMTguMA0K

