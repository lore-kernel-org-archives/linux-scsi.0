Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B686BC2D0E2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 03:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7511B21D81
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 03:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FY0/q0hf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgIKDZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 23:25:05 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:31211 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725812AbgIKDY5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 23:24:57 -0400
X-UUID: 5c87b4bd350445b7bd4bf279273356d0-20200911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=QmwsEWaxnOAFLlTyKo3ep0gcRa5p3BgYqpCcV32oTwI=;
        b=FY0/q0hfYGHPVT+qxJj3J8+82uDg1QSHCnbojPftesPvPJxU/rrp2i9kSeCRge2esHJMUMzM+nnkHiz9MID0CyZC80HnRMKZM7Gy/QlEKZ1mtUWJTU6ObUoJ3BrJseJMbJ5xn3JTq5exUXNkERX5u0wD9mg318ZCG3oANfnAoLA=;
X-UUID: 5c87b4bd350445b7bd4bf279273356d0-20200911
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 954541614; Fri, 11 Sep 2020 11:24:52 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 11 Sep 2020 11:24:49 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Sep 2020 11:24:49 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <robh@kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <arvin.wang@mediatek.com>,
        <HenryC.Chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 0/2] scsi: ufs-mediatek: Support performance mode for inline encryption engine
Date:   Fri, 11 Sep 2020 11:24:47 +0800
Message-ID: <20200911032449.21577-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
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
IGluIGtlcm5lbCB2NS4xMC4NCg0KVGhhbmtzLg0KDQpTdGFubGV5IENodSAoMik6DQogIHNjc2k6
IHVmcy1tZWRpYXRlazogU3VwcG9ydCBwZXJmb3JtYW5jZSBtb2RlIGZvciBpbmxpbmUgZW5jcnlw
dGlvbg0KICAgIGVuZ2luZQ0KICBkdC1iaW5kaW5nczogdWZzLW1lZGlhdGVrOiBBZGQgbXQ4MTky
LXVmc2hjaSBjb21wYXRpYmxlIHN0cmluZw0KDQogLi4uL2RldmljZXRyZWUvYmluZGluZ3MvdWZz
L3Vmcy1tZWRpYXRlay50eHQgIHwgICA0ICstDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0
ZWsuYyAgICAgICAgICAgICAgIHwgMTc4ICsrKysrKysrKysrKysrKysrLQ0KIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmggICAgICAgICAgICAgICB8ICAyMiArKysNCiAzIGZpbGVzIGNo
YW5nZWQsIDE5NyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

