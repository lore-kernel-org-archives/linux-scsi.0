Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F46C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 05:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69F0B20663
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 05:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BU5BF+Sr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgG2FSq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 01:18:46 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:24451 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726054AbgG2FSq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 01:18:46 -0400
X-UUID: 9c540533b7dd42d89f6968a9fddc5c63-20200729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=C1/39yJS2kPY+cDq8Oy9VmQnSWX/p2YOszDQXCN9WyY=;
        b=BU5BF+SrKGZQKcb86eHRjix8U93+3/X+2AfTZzjCZAhrscgyJQGDFha0RJ9hxV5oZKelMEdfHuin4LXvmJUN/dxXcmIdfU3/UzGE2ZnOhy+zomoVf0doxED3gR/PpWG5H02EwNOagUKmapA2r0lxJuRp96Tj3/1EA5tft7IGUAo=;
X-UUID: 9c540533b7dd42d89f6968a9fddc5c63-20200729
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1926770979; Wed, 29 Jul 2020 13:18:43 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Jul 2020 13:18:41 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 13:18:37 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>
CC:     <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] scsi: ufs: Introduce and apply DELAY_AFTER_LPM device quirk
Date:   Wed, 29 Jul 2020 13:18:38 +0800
Message-ID: <20200729051840.31318-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpUaGlzIHBhdGNoc2V0IGludHJvZHVjZXMgYW5kIGFwcGxpZXMgREVMQVlfQUZURVJfTFBN
IGRldmljZSBxdWlyayBpbiBNZWRpYVRlayBwbGF0Zm9ybXMuDQoNClN0YW5sZXkgQ2h1ICgyKToN
CiAgc2NzaTogdWZzOiBJbnRyb2R1Y2UgZGV2aWNlIHF1aXJrICJERUxBWV9BRlRFUl9MUE0iDQog
IHNjc2k6IHVmcy1tZWRpYXRlazogQXBwbHkgREVMQVlfQUZURVJfTFBNIHF1aXJrIHRvIE1pY3Jv
biBkZXZpY2VzDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgIDIgKysNCiBk
cml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaCAgIHwgIDcgKysrKysrKw0KIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMgICAgICAgfCAxMSArKysrKysrKysrKw0KIDMgZmlsZXMgY2hhbmdlZCwg
MjAgaW5zZXJ0aW9ucygrKQ0KDQotLSANCjIuMTguMA0K

