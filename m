Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C96C54E4A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00AB218AC
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RKxRCN01"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgEHRPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:15:31 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:29670 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728120AbgEHRPY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:15:24 -0400
X-UUID: 0d1c8243d6b2428aa051329f716b07ca-20200509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=mjIcA+2IIoXiUk01qKsxbOPhyEFIakxOw9WipJ7pnUo=;
        b=RKxRCN01l/VOBVhynOsMg9W2BZLihyvERqz6AriqBM8+jmMcrBbCguFgB95ntXOR6YUS+A8CzqCY/4niXyeGQ5U7NC9Ay7LiQiysSKe3tJT9PtPM/I1IeuhIdeHBk5IdX5bAJ57gK7VsNxSgMTYuCo1YsR7m2zUL6tHGnyhijqo=;
X-UUID: 0d1c8243d6b2428aa051329f716b07ca-20200509
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1087627434; Sat, 09 May 2020 01:15:20 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 9 May 2020 01:15:11 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 9 May 2020 01:15:12 +0800
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
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 4/5] scsi: ufs: use flexible definition for UFS_WB_BUF_REMAIN_PERCENT
Date:   Sat, 9 May 2020 01:15:12 +0800
Message-ID: <20200508171513.14665-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200508171513.14665-1-stanley.chu@mediatek.com>
References: <20200508171513.14665-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VXNlIG1hY3JvIFVGU19XQl9CVUZfUkVNQUlOX1BFUkNFTlQoKSBpbnN0ZWFkIHRvIHByb3ZpZGUN
Cm1vcmUgZmxleGlibGUgdXNhZ2Ugb2YgV3JpdGVCb29zdGVyIGF2YWlsYWJsZSBidWZmZXIgdmFs
dWVzLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsu
Y29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMuaCAgICB8IDUgKy0tLS0NCiBkcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jIHwgNCArKy0tDQogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlv
bnMoKyksIDYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMuaA0KaW5kZXggYjMxMzUzNDRhYjNmLi5mYWRiYTNh
M2JiY2QgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oDQorKysgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy5oDQpAQCAtNDc4LDEwICs0NzgsNyBAQCBlbnVtIHVmc19kZXZfcHdyX21v
ZGUgew0KIAlVRlNfUE9XRVJET1dOX1BXUl9NT0RFCT0gMywNCiB9Ow0KIA0KLWVudW0gdWZzX2Rl
dl93Yl9idWZfYXZhaWxfc2l6ZSB7DQotCVVGU19XQl8xMF9QRVJDRU5UX0JVRl9SRU1BSU4gPSAw
eDEsDQotCVVGU19XQl80MF9QRVJDRU5UX0JVRl9SRU1BSU4gPSAweDQsDQotfTsNCisjZGVmaW5l
IFVGU19XQl9CVUZfUkVNQUlOX1BFUkNFTlQodmFsKSAoKHZhbCkgLyAxMCkNCiANCiAvKioNCiAg
KiBzdHJ1Y3QgdXRwX2NtZF9yc3AgLSBSZXNwb25zZSBVUElVIHN0cnVjdHVyZQ0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
DQppbmRleCA5YTBjZTY1NTBjMmYuLmJjYzdhOWVhOGQyYiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC01
MzM2LDcgKzUzMzYsNyBAQCBzdGF0aWMgYm9vbCB1ZnNoY2Rfd2Jfa2VlcF92Y2Nfb24oc3RydWN0
IHVmc19oYmEgKmhiYSkNCiAJfQ0KIA0KIAlpZiAoIWhiYS0+ZGV2X2luZm8uYl9wcmVzcnZfdXNw
Y19lbikgew0KLQkJaWYgKGF2YWlsX2J1ZiA8PSBVRlNfV0JfMTBfUEVSQ0VOVF9CVUZfUkVNQUlO
KQ0KKwkJaWYgKGF2YWlsX2J1ZiA8PSBVRlNfV0JfQlVGX1JFTUFJTl9QRVJDRU5UKDEwKSkNCiAJ
CQlyZXR1cm4gdHJ1ZTsNCiAJCXJldHVybiBmYWxzZTsNCiAJfQ0KQEAgLTc0NjMsNyArNzQ2Myw3
IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYXR0cmlidXRlX2dyb3VwICp1ZnNoY2RfZHJpdmVyX2dy
b3Vwc1tdID0gew0KIA0KIHN0YXRpYyBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X3BhcmFtcyB1ZnNf
aGJhX3ZwcyA9IHsNCiAJLmhiYV9lbmFibGVfZGVsYXlfdXMJCT0gMTAwMCwNCi0JLndiX2ZsdXNo
X3RocmVzaG9sZAkJPSBVRlNfV0JfNDBfUEVSQ0VOVF9CVUZfUkVNQUlOLA0KKwkud2JfZmx1c2hf
dGhyZXNob2xkCQk9IFVGU19XQl9CVUZfUkVNQUlOX1BFUkNFTlQoNDApLA0KIAkuZGV2ZnJlcV9w
cm9maWxlLnBvbGxpbmdfbXMJPSAxMDAsDQogCS5kZXZmcmVxX3Byb2ZpbGUudGFyZ2V0CQk9IHVm
c2hjZF9kZXZmcmVxX3RhcmdldCwNCiAJLmRldmZyZXFfcHJvZmlsZS5nZXRfZGV2X3N0YXR1cwk9
IHVmc2hjZF9kZXZmcmVxX2dldF9kZXZfc3RhdHVzLA0KLS0gDQoyLjE4LjANCg==

