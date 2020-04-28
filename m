Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C57C83004
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 11:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE3EC206D9
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 11:14:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AYudQjFw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgD1LOF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 07:14:05 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:16478 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726345AbgD1LOE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 07:14:04 -0400
X-UUID: 8ed06f8f38854ab3bd4f6051823893b8-20200428
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=QzA8ce3Zb+Cb5FxfMleVNOR9S7PdPbiRGLtF5i51lXI=;
        b=AYudQjFw9TXnD90EGOP+OamtJm++6VgOE/utM5rRaCMSE8x2dGoM2BObN87B6jf1Br6+MrAQ1VUEfpGrzcYY0s+v0q/O4CsB4xbnZjeTYYtfbVfyKzTwJhlPVsMaF6YxpCeLdNUy44685eBMNJDZHnGpfqE0GpV7TXDVy7x6SwY=;
X-UUID: 8ed06f8f38854ab3bd4f6051823893b8-20200428
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 969250715; Tue, 28 Apr 2020 19:14:02 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 28 Apr 2020 19:13:55 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Apr 2020 19:13:53 +0800
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
Subject: [PATCH v1 0/4] scsi: ufs: support LU Dedicated buffer type for WriteBooster
Date:   Tue, 28 Apr 2020 19:13:51 +0800
Message-ID: <20200428111355.1776-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 8D70ACAEADA4D6AFA83B01F72597E6A176F44B5E34CCE1D0C1C0C49672F72A882000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgYWRkcyBMVSBkZWRpY2F0ZWQgYnVmZmVyIHR5cGUgc3VwcG9y
dCBmb3IgV3JpdGVCb29zdGVyLg0KDQpJbiB0aGUgbWVhbndoaWxlLCBlbmFibGUgV3JpdGVCb29z
dGVyIGNhcGFiaWxpdHkgb24gTWVkaWFUZWsgVUZTIHBsYXRmb3Jtcy4NCg0KU3RhbmxleSBDaHUg
KDQpOg0KICBzY3NpOiB1ZnM6IGFsbG93IGxlZ2FjeSBVRlMgZGV2aWNlcyB0byBlbmFibGUgV3Jp
dGVCb29zdGVyDQogIHNjc2k6IHVmczogYWRkICJpbmRleCIgaW4gcGFyYW1ldGVyIGxpc3Qgb2Yg
dWZzaGNkX3F1ZXJ5X2ZsYWcoKQ0KICBzY3NpOiB1ZnM6IGFkZCBMVSBEZWRpY2F0ZWQgYnVmZmVy
IHR5cGUgc3VwcG9ydCBmb3IgV3JpdGVCb29zdGVyDQogIHNjc2k6IHVmcy1tZWRpYXRlazogZW5h
YmxlIFdyaXRlQm9vc3RlciBjYXBhYmlsaXR5DQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRp
YXRlay5jIHwgIDMgKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMgICAgfCAgMiArLQ0K
IGRyaXZlcnMvc2NzaS91ZnMvdWZzLmggICAgICAgICAgfCAgNyArKysNCiBkcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jICAgICAgIHwgOTggKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0t
DQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICAgICB8ICAyICstDQogNSBmaWxlcyBjaGFu
Z2VkLCA4NiBpbnNlcnRpb25zKCspLCAyNiBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

