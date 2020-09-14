Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAA9C43461
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 05:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28C64208DB
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 05:01:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KjZaVnVw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgINFBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 01:01:12 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:54703 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726008AbgINFBJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 01:01:09 -0400
X-UUID: 31209588bed34387929f948530af15da-20200914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=y7J9twpVOC+9aQM50zQCULERXtYLnva5jEAZbeuXflc=;
        b=KjZaVnVwv19PLTf3JI9AxWP/Em7ojvwRcpUwofpCsxpXMItASRws+s3rIOPsTL3u1WqB1F7ELjgVCaYLkjA+g36Y5Aoesw5pwp9FD3gUSt14jL3x1xDQl6bgzE+hHGxXCa+GIa2H4JgFk2NsbkeIlxkX9sYVsw9AY5WdRVTxIi8=;
X-UUID: 31209588bed34387929f948530af15da-20200914
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 134998813; Mon, 14 Sep 2020 13:00:56 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 14 Sep 2020 13:00:54 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Sep 2020 13:00:53 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <chunfeng.yun@mediatek.com>, <yingjoe.chen@mediatek.com>,
        <kishon@ti.com>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>
CC:     <vivek.gautam@codeaurora.org>, <liwei213@huawei.com>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <chaotian.jing@mediatek.com>, <cc.chou@mediatek.com>,
        <jiajie.hao@mediatek.com>, <arvin.wang@mediatek.com>,
        <henryc.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 0/2] scsi: ufs-mediatek: Support performance mode for inline encryption engine
Date:   Mon, 14 Sep 2020 13:00:50 +0800
Message-ID: <20200914050052.3974-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: B50865B5C0F509377B995F4AA3A5CBB12A52DFF2A2433CB0F43AFAD9473E04A12000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluLCBSb2IsIEF2cmksDQoNClRoaXMgc2VyaWVzIGFkZHMgaGlnaC1wZXJmb3JtYW5j
ZSBtb2RlIHN1cHBvcnQgZm9yIE1lZGlhVGVrIFVGUyBpbmxpbmUgZW5jcnlwdGlvbiBlbmdpbmUu
DQpUaGlzIGZlYXR1cmUgaXMgb25seSByZXF1aXJlZCBpbiBzcGVjaWZpYyBwbGF0Zm9ybXMsIGku
ZS4sIE1UODE5MiBzZXJpZXMuDQoNClBsZWFzZSBoZWxwIGNvbnNpZGVyIHRoaXMgcGF0Y2ggc2V0
IGluIGtlcm5lbCB2NS4xMC4NCg0KVGhhbmtzLg0KDQpDaGFuZ2VzIHNpbmNlIHYyOg0KCS0gU3Bl
Y2lmeSByZXF1aXJlZCBtaW5pbXVtIHZjb3JlIHZvbHRhZ2UgaW4gZGV2aWNlIHRyZWUgaW5zdGVh
ZCBvZiBoYXJkLWNvZGVkLg0KDQpDaGFuZ2VzIHNpbmNlIHYxOg0KCS0gUmVtb3ZlIHVubmVjZXNz
YXJ5IHByaW50Zi4NCg0KU3RhbmxleSBDaHUgKDIpOg0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IFN1
cHBvcnQgcGVyZm9ybWFuY2UgbW9kZSBmb3IgaW5saW5lIGVuY3J5cHRpb24NCiAgICBlbmdpbmUN
CiAgZHQtYmluZGluZ3M6IHVmcy1tZWRpYXRlazogQWRkIG10ODE5Mi11ZnNoY2kgY29tcGF0aWJs
ZSBzdHJpbmcNCg0KIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy91ZnMtbWVkaWF0ZWsudHh0
ICB8ICAgNCArLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgICAgICAgICAgICAg
ICB8IDE3NiArKysrKysrKysrKysrKysrKy0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5oICAgICAgICAgICAgICAgfCAgMjIgKysrDQogMyBmaWxlcyBjaGFuZ2VkLCAxOTUgaW5zZXJ0
aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

