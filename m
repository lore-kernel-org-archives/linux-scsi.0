Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA320C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BEC221D43
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IVsOyrvR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgIHGpn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:45:43 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:2238 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728163AbgIHGpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:45:17 -0400
X-UUID: 1a02e19484c34048bb7d3441f45121d7-20200908
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=gpE1ctEiw5a0F49dlYTrRDICddTGz2kby8/WkqyE3fU=;
        b=IVsOyrvR1xoP9HQU2vpQd0/hs1fQmA+JYN94Ekmwakrvat1li8+OfIBmghT466vCjLy/Gxr6ycrg0gKa1bQO2443/gdjrCOzXVZ1NCbuhwBaxtugrRhboTc71njJlVkttkCX59Hf4dqCbEwUoSnlDRM9Mpc/mETKi0JqXmnlBYs=;
X-UUID: 1a02e19484c34048bb7d3441f45121d7-20200908
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 79854291; Tue, 08 Sep 2020 14:45:11 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 8 Sep 2020 14:45:09 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Sep 2020 14:45:09 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 0/4] scsi: ufs-mediatek: Fixes for kernel v5.10
Date:   Tue, 8 Sep 2020 14:45:03 +0800
Message-ID: <20200908064507.30774-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluLCBBdnJpLA0KDQpUaGlzIHNlcmllcyBmaXggc29tZSBkZWZlY3RzIGFuZCBpbnRy
b2R1Y2UgaG9zdCByZXNldCBtZWNoYW5pc20gaW4gTWVkaWFUZWsgVUZTIHBsYXRmb3Jtcy4NClBs
ZWFzZSBjb25zaWRlciB0aGlzIHBhdGNoIHNlcmllcyBmb3Iga2VybmVsIHY1LjEwLg0KDQpUaGFu
a3MsDQoNClN0YW5sZXkgQ2h1DQoNClN0YW5sZXkgQ2h1ICg0KToNCiAgc2NzaTogdWZzLW1lZGlh
dGVrOiBFbGltaW5hdGUgZXJyb3IgbWVzc2FnZSBmb3IgdW5ib3VuZCBtcGh5DQogIHNjc2k6IHVm
cy1tZWRpYXRlazogRml4IEhPU1RfUEFfVEFDVElWQVRFIHF1aXJrDQogIHNjc2k6IHVmcy1tZWRp
YXRlazogRml4IGZsYWcgb2YgdW5pcHJvIGxvdy1wb3dlciBtb2RlDQogIHNjc2k6IHVmcy1tZWRp
YXRlazogQWRkIGhvc3QgcmVzZXQgbWVjaGFuaXNtDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1t
ZWRpYXRlay5jIHwgNzkgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tDQogZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCB8ICAzICsrDQogMiBmaWxlcyBjaGFuZ2VkLCA2NyBp
bnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

