Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2581BC33C9E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7DA320684
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:51:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="iLTSp5hc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgAQDvR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 22:51:17 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:54558 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726653AbgAQDvR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 22:51:17 -0500
X-UUID: de7f84fd25ff49c59451f00af0b6c8b4-20200117
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=VjZO8NXrEdygh8unLaMlK+CBj4HVc+zbQuqJLK0MpHk=;
        b=iLTSp5hcnEEBPvLkOeoDxXrjyGkAzjUoajAoqkCX0J9Sfye+1631IoZtlpcvHpXMziPlNeArWMr0VmuD5za4aHLAwtp8zRu8W+Eg5RXDxkwuvbU6sQ+QrnWYChmcYzk45+GqQMcjR1aS2+SbRC5w+8kkqgyrCaWFURCMYtqufUw=;
X-UUID: de7f84fd25ff49c59451f00af0b6c8b4-20200117
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1230769150; Fri, 17 Jan 2020 11:51:10 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 17 Jan 2020 11:50:32 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 17 Jan 2020 11:51:08 +0800
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
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/3] scsi: ufs-mediatek: add MediaTek vendor implementation part II
Date:   Fri, 17 Jan 2020 11:51:05 +0800
Message-ID: <20200117035108.19699-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgc2VyaWVzIGFkZHMgc29tZSBNZWRpYVRlayB2ZW5kb3IgaW1wbGVtZW50YXRp
b25zIGluIFVGUyBkcml2ZXI6DQogIC0gQ2FsbGJhY2sgZGJnX3JlZ2lzdGVyX2R1bXANCiAgLSBM
b3ctcG93ZXIgbW9kZSBmb3IgaGliZXJuOCBzdGF0ZQ0KDQpTdGFubGV5IENodSAoMyk6DQogIHNj
c2k6IHVmcy1tZWRpYXRlazogYWRkIGRiZ19yZWdpc3Rlcl9kdW1wIGltcGxlbWVudGF0aW9uDQog
IHNjc2k6IHVmczogZXhwb3J0IHNvbWUgZnVuY3Rpb25zIGZvciB2ZW5kb3IgdXNhZ2UNCiAgc2Nz
aTogdWZzLW1lZGlhdGVrOiBlbmFibGUgbG93LXBvd2VyIG1vZGUgZm9yIGhpYmVybjggc3RhdGUN
Cg0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCA3MCArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIHwgIDUg
KysrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgICB8IDExICsrKystLQ0KIGRyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmggICAgICAgfCAgMyArKw0KIDQgZmlsZXMgY2hhbmdlZCwgODUg
aW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

