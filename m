Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC1BC47254
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 09:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CCD524954
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 09:37:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Kc6siXQc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgEIJhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 May 2020 05:37:23 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:25354 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727998AbgEIJhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2020 05:37:22 -0400
X-UUID: 5173371fb2014fe8a61663f46645abc2-20200509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=F8cqGTFPa4dEjB85G+SFRDrbwr/BV4Ro5sIuH3SpCf4=;
        b=Kc6siXQcAhmoe5vzzz6CtuO+H2p6N97g2KRyrWe/wixONXkOLwRR82ksRNqXiho7/yF+DxpiRTBwcDYI/RfDmUBV4jPXRBjC5m5HnNGIzzhGgIM23CEmGukiv0XLnD1h4AKDfIloNzzoe168VwQvE3a6rUWV9B4jvuWDxbog3WQ=;
X-UUID: 5173371fb2014fe8a61663f46645abc2-20200509
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 56762708; Sat, 09 May 2020 17:37:18 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 9 May 2020 17:37:15 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 9 May 2020 17:37:16 +0800
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
Subject: [PATCH v2 0/4] scsi: ufs: allow customizable WriteBooster flush policy
Date:   Sat, 9 May 2020 17:37:12 +0800
Message-ID: <20200509093716.21010-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2ggc2V0IHRyaWVzIHRvIGFsbG93IHZlbmRvcnMgdG8gbW9kaWZ5IHRo
ZSBXcml0ZUJvb3N0ZXIgZmx1c2ggcG9saWN5Lg0KDQpJbiB0aGUgc2FtZSB0aW1lLCBjb2xsZWN0
IGFsbCBjdXN0b21pemFibGUgcGFyYW1ldGVycyB0byBhbiB1bmlmaWVkIHN0cnVjdHVyZSB0byBt
YWtlIFVGUyBkcml2ZXIgbW9yZSBjbGVhbi4NCg0KdjEgLT4gdjI6DQogIC0gU3F1YXNoIHBhdGNo
IFszXSBhbmQgWzRdDQogIC0gUmVtb3ZlIGEgZHVtbXkgIm5ldyBsaW5lIiBpbiBwYXRjaCBbM10N
CiAgLSBGaXggY29tbWl0IG1lc3NhZ2UgaW4gcGF0Y2ggWzNdDQoNClN0YW5sZXkgQ2h1ICg0KToN
CiAgc2NzaTogdWZzOiBpbnRyb2R1Y2UgdWZzX2hiYV92YXJpYW50X3BhcmFtcyB0byBjb2xsZWN0
IGN1c3RvbWl6YWJsZQ0KICAgIHBhcmFtZXRlcnMNCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBjaGFu
Z2UgdGhlIHdheSB0byB1c2UgY3VzdG9taXphYmxlIHBhcmFtZXRlcnMNCiAgc2NzaTogdWZzOiBj
dXN0b21pemUgZmx1c2ggdGhyZXNob2xkIGZvciBXcml0ZUJvb3N0ZXINCiAgc2NzaTogdWZzLW1l
ZGlhdGVrOiBjdXN0b21pemUgV3JpdGVCb29zdGVyIGZsdXNoIHBvbGljeQ0KDQogZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8ICA1ICsrLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy5o
ICAgICAgICAgIHwgIDUgKy0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgICAgfCA0
NSArKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5oICAgICAgIHwgIDkgKysrKysrLQ0KIDQgZmlsZXMgY2hhbmdlZCwgMzEgaW5zZXJ0aW9u
cygrKSwgMzMgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

