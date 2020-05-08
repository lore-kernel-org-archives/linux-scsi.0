Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA06DC38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B58BF24955
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jb1ZHoTb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgEHRPT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:15:19 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:60326 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726750AbgEHRPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:15:19 -0400
X-UUID: 1f01ab1311104151be2a63af2e428813-20200509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=0knH9HNnIx9SRZudXymGnZJ0S7xeMFAxCHgdkhMyXYU=;
        b=jb1ZHoTbS6RmvKKyVnkkYGuNz4QeH4brKBU9QKshK9Ucv8FXhWVonTeyRElPwWz6fGDFBVoIyedng4IzfI6De7MHje+8LBccoNlzRjddd3/ne/U6CdQkF4li5vmEBO2k2D2yCEStfUzjQCPD/n9vZNwkqWXMY0EQQFSR+CZXVhw=;
X-UUID: 1f01ab1311104151be2a63af2e428813-20200509
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 917442801; Sat, 09 May 2020 01:15:15 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 9 May 2020 01:15:11 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 9 May 2020 01:15:11 +0800
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
Subject: [PATCH v1 0/5] scsi: ufs: allow customizable WriteBooster flush policy
Date:   Sat, 9 May 2020 01:15:08 +0800
Message-ID: <20200508171513.14665-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: F7A3837055F0D783E3D514AAFE929BFFDF806506BD535D7E485499953F07CA592000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2ggc2V0IHRyaWVzIHRvIGFsbG93IHZlbmRvcnMgdG8gbW9kaWZ5IHRo
ZSBXcml0ZUJvb3N0ZXIgZmx1c2ggcG9saWN5Lg0KDQpJbiB0aGUgc2FtZSB0aW1lLCBjb2xsZWN0
IGFsbCBjdXN0b21pemFibGUgcGFyYW1ldGVycyB0byBhbiB1bmlmaWVkIHN0cnVjdHVyZSB0byBt
YWtlIFVGUyBkcml2ZXIgbW9yZSBjbGVhbi4NCg0KU3RhbmxleSBDaHUgKDUpOg0KICBzY3NpOiB1
ZnM6IGludHJvZHVjZSB1ZnNfaGJhX3ZhcmlhbnRfcGFyYW1zIHRvIGNvbGxlY3QgY3VzdG9taXph
YmxlDQogICAgcGFyYW1ldGVycw0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGNoYW5nZSB0aGUgd2F5
IHRvIHVzZSBjdXN0b21pemFibGUgcGFyYW1ldGVycw0KICBzY3NpOiB1ZnM6IGN1c3RvbWl6ZSBm
bHVzaCB0aHJlc2hvbGQgZm9yIFdyaXRlQm9vc3Rlcg0KICBzY3NpOiB1ZnM6IHVzZSBmbGV4aWJs
ZSBkZWZpbml0aW9uIGZvciBVRlNfV0JfQlVGX1JFTUFJTl9QRVJDRU5UDQogIHNjc2k6IHVmcy1t
ZWRpYXRlazogY3VzdG9taXplIFdyaXRlQm9vc3RlciBmbHVzaCBwb2xpY3kNCg0KIGRyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAgNSArKy0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMu
aCAgICAgICAgICB8ICA1ICstLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICAgIHwg
NDYgKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuaCAgICAgICB8ICA5ICsrKysrKy0NCiA0IGZpbGVzIGNoYW5nZWQsIDMyIGluc2VydGlv
bnMoKyksIDMzIGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

