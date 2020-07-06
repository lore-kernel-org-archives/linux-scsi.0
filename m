Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED74C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B628020774
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="V1g6nGNH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgGFGHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 02:07:13 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:56214 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728794AbgGFGHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 02:07:13 -0400
X-UUID: 75a23e65dc0a434ab1152f8bc8cf7d96-20200706
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=10V6OZvPGw+EU6EjKCj8JSWdQJi/LF2dghOjGFtO6Nc=;
        b=V1g6nGNHeTUn934t4KNzuvI4t1tW5gn73J8zAboUZjgx7GvlGnmqGBABWVoqyzymsVlJeuJA78qW5XiGft7CXFAAbpBD5EP4/7Ek7ME05m9UDxh4GOE5w+7bz+6UM4yUHv+FBUWeCpAfH3oT/HUtVgMG6M+tqm/XgduVP595498=;
X-UUID: 75a23e65dc0a434ab1152f8bc8cf7d96-20200706
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1937128836; Mon, 06 Jul 2020 14:07:09 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 6 Jul 2020 14:07:05 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 14:07:05 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] scsi: ufs: Fix and simplify setup_xfer_req vop and request's completion timestamp
Date:   Mon, 6 Jul 2020 14:07:05 +0800
Message-ID: <20200706060707.32608-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 395A691655FC77A3D96133384BF5BD9B22F22366F969AF146C71BEA70F7985E52000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpUaGlzIHNtYWxsIHNlcmllcyBmaXhlcyBhbmQgc2ltcGxpZmllcyBzZXR1cF94ZmVyX3Jl
cSB2b3AgYW5kIHJlcXVlc3QncyBjb21wbGV0aW9uIHRpbWVzdGFtcC4NCg0KU3RhbmxleSBDaHUg
KDIpOg0KICBzY3NpOiB1ZnM6IFNpbXBsaWZ5IGNvbXBsZXRpb24gdGltZXN0YW1wIGZvciBTQ1NJ
IGFuZCBxdWVyeSBjb21tYW5kcw0KICBzY3NpOiB1ZnM6IEZpeCBhbmQgc2ltcGxpZnkgc2V0dXBf
eGZlcl9yZXEgdmFyaWFudCBvcGVyYXRpb24NCg0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMg
fCAxMiArKysrKystLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA2IGRl
bGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

