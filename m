Return-Path: <SRS0=nD9h=2Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3873C3276F
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 14:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FAEC2465E
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 14:26:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UUkxHU4L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgADO0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jan 2020 09:26:17 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:37327 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725924AbgADO0Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2020 09:26:16 -0500
X-UUID: 46450077ffe143ea9228d5997c563ab3-20200104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=SW1ng1B4N9Uj3rz0yt1c6Qc8LA9cWa+omxEpLReC8d8=;
        b=UUkxHU4LWdgCqGe0/xCUtGeCmxTGwiBsBIyDEFdDgjpNWNM7evvIY02oDFMSP9zbTWLzQtZFsKoYdx9T17YaC+ABtOM1iK1j7f1kgwQwwaj+V1S32H2O1yErzD0pN6RWnt4YGPyui/9rd71Ub5AkUUU+HAKJPB3/4pWf9vHkj+w=;
X-UUID: 46450077ffe143ea9228d5997c563ab3-20200104
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 72482906; Sat, 04 Jan 2020 22:26:11 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 4 Jan 2020 22:25:16 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 4 Jan 2020 22:26:39 +0800
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
Subject: [PATCH v1 0/3] scsi: ufs: fix error history and complete device reset history
Date:   Sat, 4 Jan 2020 22:26:05 +0800
Message-ID: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: B3B9B6EB5DB4CEFAF1AC2165BB001FC8EDE9F53FF6594DACC0221E1470DD5E432000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgc2VyaWVzIHRhcmdldHMgb24gVUZTIGVycm9yIGhpc3RvcnkgZml4ZXMgYW5k
IGZlYXR1cmUgYWRkLW9uLA0KDQoxLiBGaXggZW1wdHkgY2hlY2sgbG9naWMgd2hpbGUgb3V0cHV0
aW5nIGVycm9yIGhpc3RvcnkuDQoyLiBBZGQgZGV2aWNlIHJlc2V0IGhpc3RvcnkgZXZlbnRzIGZv
ciB2ZW5kb3IncyBpbXBsZW1lbnRhdGlvbnMuDQozLiBSZW1vdmUgZHVtbXkgd29yZCBpbiBvdXRw
dXQgZm9ybWF0Lg0KDQpTdGFubGV5IENodSAoMyk6DQogIHNjc2k6IHVmczogZml4IGVtcHR5IGNo
ZWNrIG9mIGVycm9yIGhpc3RvcnkNCiAgc2NzaTogdWZzOiBhZGQgZGV2aWNlIHJlc2V0IGhpc3Rv
cnkgZm9yIHZlbmRvciBpbXBsZW1lbnRhdGlvbnMNCiAgc2NzaTogdWZzOiByZW1vdmUgImVycm9y
cyIgd29yZCBpbiB1ZnNoY2RfcHJpbnRfZXJyX2hpc3QoKQ0KDQogZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYyB8IDkgKysrKystLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8IDYgKysr
KystDQogMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0K
DQotLSANCjIuMTguMA0K

