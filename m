Return-Path: <SRS0=TzWF=Z5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E943C43603
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 12:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAD51206DB
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 12:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jcjtTcYr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfLGMWS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Dec 2019 07:22:18 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:15567 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726106AbfLGMWS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Dec 2019 07:22:18 -0500
X-UUID: e7f22d9dfd6547968422ff262e478e5f-20191207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=K3/4d8dMyg2wXRwQFcJk/UGgrlNk/bp2Ig4rf75mjwY=;
        b=jcjtTcYreCCa7qvYkNxwiogWhSRZakJ2Ofzmcw4ltFgZQtAs5uT3BAn7s2frPFyDpcixZ2AOZo2xFVGUAEEsDUvq4pKitpOAaWw1UNo30C9TdzOi4C0z2j/5tJsw13+ANCVilq8mbRDy11wKLZit6n+/HCsIe/++r539c063t5Q=;
X-UUID: e7f22d9dfd6547968422ff262e478e5f-20191207
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1826427876; Sat, 07 Dec 2019 20:22:07 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 7 Dec 2019 20:21:46 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 7 Dec 2019 20:21:55 +0800
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
Subject: [PATCH v1 0/2] scsi: ufs: fixup active period of ufshcd interrupt
Date:   Sat, 7 Dec 2019 20:21:59 +0800
Message-ID: <1575721321-8071-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhpcyBwYXRjaHNldCBmaXhlcyB1cCBhY3RpdmUgZHVyYXRpb24gb2YgdWZzaGNkIGludGVycnVw
dCB0byBhdm9pZCBwb3RlbnRpYWwgc3lzdGVtIGhhbmcgaXNzdWVzLg0KDQpTdGFubGV5IENodSAo
Mik6DQogIHNjc2k6IHVmczogZGlzYWJsZSBpcnEgYmVmb3JlIGRpc2FibGluZyBjbG9ja3MNCiAg
c2NzaTogdWZzOiBkaXNhYmxlIGludGVycnVwdCBkdXJpbmcgY2xvY2stZ2F0aW5nDQoNCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMTUgKysrKysrKysrKy0tLS0tDQogMSBmaWxlIGNoYW5n
ZWQsIDEwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

