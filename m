Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910B8C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6546A2068E
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HTg6bLLh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgFOHWs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 03:22:48 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:35754 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728539AbgFOHWq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 03:22:46 -0400
X-UUID: 9ac8135d0b454283a9699f8891fa5f2f-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=KsPHsP0hYhfA7edmMoOs0ziWrUu4La3/8ekhuF/RrAI=;
        b=HTg6bLLhj1mM1icr2cokZE8n6tUa/5PACZhwfvKJbhqmGIuQ4MjVA1h6lF49SBKeTSRttbM40hHLymr4eJYozETOSE9gVoZWQzkDMlzR9XtVsMP6IFf609JWU6haGNthcGak+yBnOl8e5iHWYyGo2GRS3vzvvTWggj6oABOF0Ss=;
X-UUID: 9ac8135d0b454283a9699f8891fa5f2f-20200615
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1313003693; Mon, 15 Jun 2020 15:22:37 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 15:22:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 15:22:36 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 0/2] scsi: ufs: Add trace event for UIC commands and cleanup UIC struct
Date:   Mon, 15 Jun 2020 15:22:33 +0800
Message-ID: <20200615072235.23042-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpUaGlzIHNlcmllcyBhZGRzIHRyYWNlIGV2ZW50IGZvciBVSUMgY29tbWFuZHMgYW5kIGRv
IGEgc21hbGwgY2xlYW51cCBpbiBzdHJ1Y3QgdWljX2NvbW1hbmQuDQoNCnYyIC0+IHYzOg0KICAt
IFJlZmFjdG9yICJjb21wbGV0ZSIgZXZlbnQgaG9va3MgaW4gdWZzaGNkX3VpY19jbWRfY29tcGwo
KSAoQXZyaSBBbHRtYW4pDQoNCnYxIC0+IHYyOg0KICAtIFJlbmFtZSAidWljX3NlbmQiIHRvICJz
ZW5kIiBhbmQgInVpY19jb21wbGV0ZSIgdG8gImNvbXBsZXRlIg0KICAtIE1vdmUgInNlbmQiIHRy
YWNlIGJlZm9yZSBVSUMgY29tbWFuZCBpcyBzZW50IG90aGVyd2lzZSAic2VuZCIgdHJhY2UgbWF5
IGxvZyBpbmNvcnJlY3QgYXJndW1lbnRzDQogIC0gTW92ZSAiY29tcGxldGUiIHRyYWNlIHRvIFVJ
QyBpbnRlcnJ1cHQgaGFuZGxlciB0byBtYWtlIGxvZ2dpbmcgdGltZSBwcmVjaXNlDQoNClN0YW5s
ZXkgQ2h1ICgyKToNCiAgc2NzaTogdWZzOiBSZW1vdmUgdW51c2VkIGZpZWxkIGluIHN0cnVjdCB1
aWNfY29tbWFuZA0KICBzY3NpOiB1ZnM6IEFkZCB0cmFjZSBldmVudCBmb3IgVUlDIGNvbW1hbmRz
DQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICB8IDI2ICsrKysrKysrKysrKysrKysrKysr
KysrKysrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgfCAgNCAtLS0tDQogaW5jbHVkZS90
cmFjZS9ldmVudHMvdWZzLmggfCAzMSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQog
MyBmaWxlcyBjaGFuZ2VkLCA1NyBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQotLSAN
CjIuMTguMA0K

