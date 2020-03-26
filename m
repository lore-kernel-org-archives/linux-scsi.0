Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A50AC43331
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 15:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBAB92077D
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 15:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uz4bbbE0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgCZPH4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 11:07:56 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:43951 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726270AbgCZPH4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 11:07:56 -0400
X-UUID: ce6c01eca6354890807c037db73de0ff-20200326
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=q4HfqE41fG8j1Z9fLijz7fOipfgRE/koqLpBPkPcNyU=;
        b=uz4bbbE0kcfZ0lHmnxI6H54f+nU5DyEwg1JYamK4dIo9lkM2qKJi1DGVxkb64gxKwOw33dEM9CSN/hWoZYFVNdS5jc0WxjnHZmsYIE0D74UCibCmFsW5mKXNylmO4Pmy+T03UWO2n6BkPQ4Mx4SkZmG1vOVpPZ+/jzGN+3M/LZw=;
X-UUID: ce6c01eca6354890807c037db73de0ff-20200326
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 38030757; Thu, 26 Mar 2020 23:07:51 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 26 Mar 2020 23:07:48 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 26 Mar 2020 23:07:47 +0800
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
Subject: [PATCH v2 0/2] scsi: ufs: add error recovery for suspend and resume in ufs-mediatek
Date:   Thu, 26 Mar 2020 23:07:45 +0800
Message-ID: <20200326150747.11426-1-stanley.chu@mediatek.com>
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
IGFuZCByZXN1bWUgaW4gdWZzLW1lZGlhdGVrIGRyaXZlci4NCg0KdjEgLT4gdjI6DQogIC0gRml4
IGZvcm1hdCBvZiBjb21tZW50cw0KDQpTdGFubGV5IENodSAoMik6DQogIHNjc2k6IHVmczogZXhw
b3J0IHVmc2hjZF9saW5rX3JlY292ZXJ5IGZvciB2ZW5kb3IncyBlcnJvciByZWNvdmVyeQ0KICBz
Y3NpOiB1ZnMtbWVkaWF0ZWs6IGFkZCBlcnJvciByZWNvdmVyeSBmb3Igc3VzcGVuZCBhbmQgcmVz
dW1lDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMTMgKysrKysrKysrKyst
LQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgICAgfCAgMyArKy0NCiBkcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5oICAgICAgIHwgIDEgKw0KIDMgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

