Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049C6C11D07
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 13:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2D6B208C4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 13:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="A6pnecmc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgBTNtB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 08:49:01 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:47267 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728274AbgBTNs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2020 08:48:59 -0500
X-UUID: 9beae6d5bf81424f9dcd559ed15d96f6-20200220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=KmAGgXrlCHQ77cMErepngIlOvfaHprPW+G8GQkksoF0=;
        b=A6pnecmcTdlSi1ZSgE1r/8Gm8+b1CfJzrHrXI21KMXpVQMUtbnR1ULeFJ5AMSoHys3Pjl7hI6Rxh8O7MCrqkIjRaulrYyqJRvk7CfJ/pcv2NsaswXNjIh4pGgufYFJR29yC54BJwHQ0axPehVdk1nLjddVq+ODX8qB2IzFd0tuE=;
X-UUID: 9beae6d5bf81424f9dcd559ed15d96f6-20200220
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1777121287; Thu, 20 Feb 2020 21:48:51 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 20 Feb 2020 21:46:20 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 20 Feb 2020 21:46:45 +0800
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
Subject: [PATCH v2 0/1] scsi: ufs: fix waiting time for reference clock
Date:   Thu, 20 Feb 2020 21:48:47 +0800
Message-ID: <20200220134848.8807-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: A530EFBDC78C0C129A69103C87BA3A3A8647BB6446C1DE1CFF13CD807CE25A6D2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgYWRkcyB3YWl0aW5nIHRpbWUgZm9yIHJlZmVyZW5jZSBjbG9j
ayBwcm92aWRlZCB0byBVRlMgZGV2aWNlIGluIE1lZGlhVGVrIFVGUyBpbXBsZW1lbnRhdGlvbi4N
Cg0KdjEgLT4gdjI6DQogIC0gRHJvcCBwYXRjaCAjMSAic2NzaTogdWZzOiBhZGQgcmVxdWlyZWQg
ZGVsYXkgYWZ0ZXIgZ2F0aW5nIHJlZmVyZW5jZSBjbG9jayIgc2luY2UgaXQgd2lsbCBpbXBhY3Qg
dWZzLXFjb20gZmxvdyB3aXRob3V0IHNvbGlkIGNvbmNsdXNpb24geWV0Lg0KDQpTdGFubGV5IENo
dSAoMSk6DQogIHNjc2k6IHVmczogdWZzLW1lZGlhdGVrOiBhZGQgd2FpdGluZyB0aW1lIGZvciBy
ZWZlcmVuY2UgY2xvY2sNCg0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCA0NiAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1t
ZWRpYXRlay5oIHwgIDIgKysNCiAyIGZpbGVzIGNoYW5nZWQsIDQ2IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

