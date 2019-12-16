Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A37EC2D0CF
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 03:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 586C524684
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 03:49:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="M6/3IUhk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfLPDtF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 22:49:05 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:61038 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726783AbfLPDtF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Dec 2019 22:49:05 -0500
X-UUID: f651b5b6c15647d3be346867cb716180-20191216
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=0oTM8ec49riGzkXqbh5sFdhXmjjCrTrpNmENYdE7F7s=;
        b=M6/3IUhkmECZ4Xvqmv88gWoAUjact28Lub1Z3ZJBDYZZaEKvj5rgW9rxFYTj+oPkv0AGVoJtv4s4m6U10FMtsATlU4dzgQ8dpUetHlnCmAdD3loID7HEAtjhKXmJbTT6KfdB62o6f8MNBskVQUDPdoYzZbYFTMVpq+aJC/BHgZQ=;
X-UUID: f651b5b6c15647d3be346867cb716180-20191216
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 461382696; Mon, 16 Dec 2019 11:49:00 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Dec 2019 11:48:28 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Dec 2019 11:48:58 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <f.fainelli@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <leon.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 0/2 RESEND] scsi: ufs-mediatek: add device reset implementation
Date:   Mon, 16 Dec 2019 11:48:55 +0800
Message-ID: <1576468137-17220-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 2C63DA52B94AD84F64F4F77477A7075DBF46997BA5D1D4C0C62BC6CC6F9402E72000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhpcyBwYXRjaHNldCBhZGQgaW1wbGVtZW50YXRpb24gb2YgVUZTIGRldmljZSByZXNldCB2b3Bz
IGluIE1lZGlhVGVrIFVGUyBkcml2ZXIuDQoNCnYyOg0KIC0gVXNlIGRlZmluaXRpb24gZGVmaW5l
ZCBpbiBpbmNsdWRlL2xpbnV4L2FybS1zbWNjYy5oIGluc3RlYWQgb2YgIm1hZ2ljIGRlZmluaXRp
b24iIChGbG9yaWFuIEZhaW5lbGxpKQ0KDQpTdGFubGV5IENodSAoMik6DQogIHNvYzogbWVkaWF0
ZWs6IGFkZCBoZWFkZXIgZm9yIFNpUCBzZXJ2aWNlIGludGVyZmFjZQ0KICBzY3NpOiB1ZnMtbWVk
aWF0ZWs6IGFkZCBkZXZpY2UgcmVzZXQgaW1wbGVtZW50YXRpb24NCg0KIGRyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMgICAgICAgICAgfCAyNyArKysrKysrKysrKysrKysrKysrKysNCiBk
cml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oICAgICAgICAgIHwgIDcgKysrKysrDQogaW5j
bHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9zdmMuaCB8IDMwICsrKysrKysrKysrKysr
KysrKysrKysrKw0KIDMgZmlsZXMgY2hhbmdlZCwgNjQgaW5zZXJ0aW9ucygrKQ0KIGNyZWF0ZSBt
b2RlIDEwMDY0NCBpbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oDQoNCi0t
IA0KMi4xOC4wDQo=

