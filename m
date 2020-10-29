Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2326C55178
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B43020796
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:58:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VoR6k2bp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgJ2L6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:58:01 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57264 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725826AbgJ2L6A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 07:58:00 -0400
X-UUID: 559b5187c4174317bf3ac6acd01675e1-20201029
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=TLQL1F5nx2wwKalpLHC2wUfSew2UGwvEZg1kmpw5dJM=;
        b=VoR6k2bprBy2BJe6DSH62HZqQsfj/Ii20ViSwhqDK4NlWNA3Bx0sogyX7wWBw756r0hCX+W3f639mhmzv1IaRhQW20hzJCgR7Cc27aw5FRgFP2LrXy8pSPtEGUydJp57jpYyQJIMgSMB8Wd1uSgGmBswEVsvrmbaMTzgwn2oiWY=;
X-UUID: 559b5187c4174317bf3ac6acd01675e1-20201029
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2029360377; Thu, 29 Oct 2020 19:57:53 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Oct 2020 19:57:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Oct 2020 19:57:50 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/6] scsi: ufs: Add some proprietary features in MediaTek UFS platforms
Date:   Thu, 29 Oct 2020 19:57:44 +0800
Message-ID: <20201029115750.24391-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2ggc2VyaWVzIHByb3ZpZGVzIHNvbWUgZmVhdHVyZXMgYW5kIGZpeGVz
IGluIE1lZGlhVGVrIFVGUyBwbGF0Zm9ybXMsDQoNCjEuIFN1cHBvcnQgVkEwOSByZWd1bGF0b3Ig
b3BlcmF0aW9ucw0KMi4gU3VwcG9ydCBvcHRpb24gdG8gZGlzYWJsZSBhdXRvLWhpYmVybjgNCjMu
IFN1cHBvcnQgSFMtRzQNCjQuIERlY291cGxlIGZlYXR1cmVzIGZyb20gcGxhdGZvcm0gYmluZGlu
Z3MNCjUuIE1pc2MgZml4ZXMNCg0KU3RhbmxleSBDaHUgKDYpOg0KICBzY3NpOiB1ZnMtbWVkaWF0
ZWs6IEFzc2lnbiBhcmd1bWVudHMgd2l0aCBjb3JyZWN0IHR5cGUNCiAgc2NzaTogdWZzLW1lZGlh
dGVrOiBTdXBwb3J0IFZBMDkgcmVndWxhdG9yIG9wZXJhdGlvbnMNCiAgc2NzaTogdWZzLW1lZGlh
dGVrOiBEZWNvdXBsZSBmZWF0dXJlcyBmcm9tIHBsYXRmb3JtIGJpbmRpbmdzDQogIHNjc2k6IHVm
cy1tZWRpYXRlazogU3VwcG9ydCBvcHRpb24gdG8gZGlzYWJsZSBhdXRvLWhpYmVybjgNCiAgc2Nz
aTogdWZzOiBBZGQgZW51bXMgZm9yIFVuaVBybyB2ZXJzaW9uIGhpZ2hlciB0aGFuIDEuNg0KICBz
Y3NpOiB1ZnMtbWVkaWF0ZWs6IEFkZCBIUy1HNCBzdXBwb3J0DQoNCiBkcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jIHwgMjE4ICsrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQog
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCB8ICAyMiArKy0tDQogZHJpdmVycy9zY3Np
L3Vmcy91bmlwcm8uaCAgICAgICB8ICAgNiArLQ0KIDMgZmlsZXMgY2hhbmdlZCwgMTc5IGluc2Vy
dGlvbnMoKyksIDY3IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

