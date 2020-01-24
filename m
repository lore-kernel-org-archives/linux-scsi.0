Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00CCC2D0CE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 06:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97B9E20709
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 06:49:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="D10F9DWF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgAXGtk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 01:49:40 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:31589 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725821AbgAXGtj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 01:49:39 -0500
X-UUID: de6d9fd5596a4800928f240ecbbb70be-20200124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=9ZQEtQSDH2l7X4gZYfdkXUBut/YYbTfvmWSTS2DhTxg=;
        b=D10F9DWFCdvj4U79P4WJKEhizwxu5CWKXi9GlCvouB108AP/tFyU+Z3j+umHGI1/9OAR/tzCQMk8ZFQNZ9X23jxCb0Ll0IVMfL9+bXrYIaKpsNdNx9HE1MlxgH+Nt62/C+rduZTOJpNZEb/7yH0YiYRHobB/n39qJO13Uj3hzT8=;
X-UUID: de6d9fd5596a4800928f240ecbbb70be-20200124
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 43464048; Fri, 24 Jan 2020 14:49:30 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 14:48:53 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 Jan 2020 14:48:57 +0800
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
Subject: [PATCH v1 0/5] MediaTek UFS vendor implemenation part III and Auto-Hibern8 fix
Date:   Fri, 24 Jan 2020 14:49:21 +0800
Message-ID: <20200124064926.29472-1-stanley.chu@mediatek.com>
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
cmVmZXJlbmNlIGNsb2NrIGZvciBBdXRvLUhpYmVybjggY2FzZQ0KDQpTdGFubGV5IENodSAoNSk6
DQogIHNjc2k6IHVmcy1tZWRpYXRlazogZW5zdXJlIFVuaVBybyBpcyBub3QgcG93ZXJlZCBkb3du
IGJlZm9yZSBsaW5rdXANCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBzdXBwb3J0IGxpbmtvZmYgc3Rh
dGUgZHVyaW5nIHN1c3BlbmQNCiAgc2NzaTogdWZzOiBhZGQgdWZzaGNkX2lzX2F1dG9faGliZXJu
OF9lbmFibGVkIGZhY2lsaXR5DQogIHNjc2k6IHVmczogZml4IGF1dG8taGliZXJuOCBlcnJvciBk
ZXRlY3Rpb24NCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBnYXRlIHJlZi1jbGsgZHVyaW5nIEF1dG8t
SGliZXJuOA0KDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDY1ICsrKysrKysr
KysrKysrKysrKysrKy0tLS0tLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmggfCAxMiArKysrKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICAgIHwgIDMgKy0N
CiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oICAgICAgIHwgIDYgKysrDQogNCBmaWxlcyBjaGFu
Z2VkLCA2MiBpbnNlcnRpb25zKCspLCAyNCBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

