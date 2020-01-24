Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF260C32771
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5031214DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:08:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WA7OgJqo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390232AbgAXPH7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 10:07:59 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:1537 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388706AbgAXPH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 10:07:58 -0500
X-UUID: f25c122a38604cd2af8fd5ae6a5af6d5-20200124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=4y9eiBw5IAfEzm5r7ldiQUyvda3M0QLb1AsObdV4hDc=;
        b=WA7OgJqoT6Jwb40V11zwpJQ1m/EQbeUsNTMezeB4V2TdNzrrK8EDfSnmPmRP6RSiZgN5EeJQSl4Bxx1StKn/V4lgbGZpxyRzHdGR1bA0Ygvh7niisq3bzomofbwi28cATOgi2XGPFlXXWwNO1AFsZC7tyTWcQXL4kJzMEhhQqCI=;
X-UUID: f25c122a38604cd2af8fd5ae6a5af6d5-20200124
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 478476682; Fri, 24 Jan 2020 23:07:46 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 23:06:30 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 Jan 2020 23:07:15 +0800
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
Subject: [PATCH v2 0/5] MediaTek UFS vendor implemenation part III and Auto-Hibern8 fix
Date:   Fri, 24 Jan 2020 23:07:38 +0800
Message-ID: <20200124150743.15110-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgc2VyaWVzIHByb3ZpZGVzIE1lZGlhVGVrIHZlbmRvciBpbXBsZW1lbnRhdGlv
bnMgYW5kIHNvbWUgZ2VuZXJhbCBmaXhlcy4NCg0KLSBHZW5lcmFsIGZpeGVzDQoJLSBGaXggQXV0
by1IaWJlcm44IGVycm9yIGRldGVjdGlvbg0KDQotIE1lZGlhVGVrIHZlbmRvciBpbXBsZW1lbnRh
dGlvbnMNCgktIEVuc3VyZSBVbmlQcm8gaXMgcG93ZXJlZCBvbiBiZWZvcmUgZXZlcnkgbGluayBz
dGFydHVwDQoJLSBTdXBwb3J0IGxpbmtvZmYgc3RhdGUgZHVyaW5nIHN1c3BlbmQNCgktIEdhdGUg
cmVmZXJlbmNlIGNsb2NrIGZvciBBdXRvLUhpYmVybjggY2FzZQ0KDQp2MSAtPiB2Mg0KCS0gRml4
IGFuZCByZWZpbmUgY29tbWl0IG1lc3NhZ2VzLg0KDQpTdGFubGV5IENodSAoNSk6DQogIHNjc2k6
IHVmcy1tZWRpYXRlazogZW5zdXJlIFVuaVBybyBpcyBub3QgcG93ZXJlZCBkb3duIGJlZm9yZSBs
aW5rdXANCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBzdXBwb3J0IGxpbmtvZmYgc3RhdGUgZHVyaW5n
IHN1c3BlbmQNCiAgc2NzaTogdWZzOiBhZGQgdWZzaGNkX2lzX2F1dG9faGliZXJuOF9lbmFibGVk
IGZhY2lsaXR5DQogIHNjc2k6IHVmczogZml4IGF1dG8taGliZXJuOCBlcnJvciBkZXRlY3Rpb24N
CiAgc2NzaTogdWZzLW1lZGlhdGVrOiBnYXRlIHJlZi1jbGsgZHVyaW5nIEF1dG8tSGliZXJuOA0K
DQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDY1ICsrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggfCAxMiAr
KysrKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICAgIHwgIDMgKy0NCiBkcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5oICAgICAgIHwgIDYgKysrDQogNCBmaWxlcyBjaGFuZ2VkLCA2MiBp
bnNlcnRpb25zKCspLCAyNCBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

