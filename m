Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0E8C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7C8D20716
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SDgIljdp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgC0Jxi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 05:53:38 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:28304 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbgC0Jxh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 05:53:37 -0400
X-UUID: 23d4ec23658a45fda9039854115d9945-20200327
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=UC7oHlWaYRbuhG1CU6ttQB0ttxFaJYCjrCK3+rWYMl0=;
        b=SDgIljdpplohuBA2YaBHQ9rGl/6oeoFQ/PGsOPGdx1T/BctUQ4Dywqko2bDKNaUxNn4ceCXT6SElPtr0xOLuyIJTYZaZslUexgX/345Tsa9kUF9r/2ZYnJJKeL2hK2AFadSN2eQ+rw7IWvlpUGOiCK5S3eIaxmM9/U51FNNcT2s=;
X-UUID: 23d4ec23658a45fda9039854115d9945-20200327
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 471604845; Fri, 27 Mar 2020 17:53:32 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 27 Mar 2020 17:53:30 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 27 Mar 2020 17:53:29 +0800
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
Subject: [PATCH v3 0/2] scsi: ufs: add error recovery for suspend and resume in ufs-mediatek
Date:   Fri, 27 Mar 2020 17:53:27 +0800
Message-ID: <20200327095329.10083-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgYWRkcyBlcnJvciByZWNvdmVyeSBmbG93IGZvciBzdXNwZW5k
IGFuZCByZXN1bWUgaW4gdWZzLW1lZGlhdGVrIGRyaXZlci4NCg0KdjIgLT4gdjM6DQogIC0gRml4
IGNvbW1pdCBtZXNzYWdlcyAoQXZyaSBBbHRtYW4pDQoNCnYxIC0+IHYyOg0KICAtIEZpeCBmb3Jt
YXQgb2YgY29tbWVudHMNCg0KU3RhbmxleSBDaHUgKDIpOg0KICBzY3NpOiB1ZnM6IGV4cG9ydCB1
ZnNoY2RfbGlua19yZWNvdmVyeSBmb3IgdmVuZG9yJ3MgZXJyb3IgcmVjb3ZlcnkNCiAgc2NzaTog
dWZzLW1lZGlhdGVrOiBhZGQgZXJyb3IgcmVjb3ZlcnkgZm9yIHN1c3BlbmQgYW5kIHJlc3VtZQ0K
DQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDEzICsrKysrKysrKysrLS0NCiBk
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICAgIHwgIDMgKystDQogZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuaCAgICAgICB8ICAxICsNCiAzIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMo
KyksIDMgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

