Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E5AC3F2CE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19CB820719
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="owCX1E0+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgCPIxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:53:14 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:1469 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730131AbgCPIxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 04:53:14 -0400
X-UUID: 074085e7c02947b4a58726eba5f43dfe-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Pe2ICmxiDGZfXw8Ju8bu2oy7yN84cTxQ4OAqo9x25H8=;
        b=owCX1E0+QaZZ9JzzjJR0CXeiGkDPkdRE3+nX35TGNeJZsNhF7CjPp6g7fEwOoiWHt/qWS5dB+vuFfSs7NIBs3+NLA8plRQjNX3h6Y/67w4XFPGXwxkb+sz0NIbII1roZ9UP9U3i+2qwjPor6p/ZTTRLOTZ9+EtVDmAFbRNmVYpM=;
X-UUID: 074085e7c02947b4a58726eba5f43dfe-20200316
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1666673453; Mon, 16 Mar 2020 16:53:07 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 16:50:13 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 16:53:52 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.peter~sen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v6 1/7] scsi: ufs: fix uninitialized tx_lanes in ufshcd_disable_tx_lcc()
Date:   Mon, 16 Mar 2020 16:52:57 +0800
Message-ID: <20200316085303.20350-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200316085303.20350-1-stanley.chu@mediatek.com>
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: F3751F886D718EC3FA56A4ABBA8D56BA2D38AB9B8567EA112E77272E6AD0D5362000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW4gdWZzaGNkX2Rpc2FibGVfdHhfbGNjKCksIGlmIHVmc2hjZF9kbWVfZ2V0KCkgb3IgdWZzaGNk
X2RtZV9wZWVyX2dldCgpDQpnZXQgZmFpbCwgdW5pbml0aWFsaXplZCB2YXJpYWJsZSAidHhfbGFu
ZXMiIG1heSBiZSB1c2VkIGFzIHVuZXhwZWN0ZWQgbGFuZQ0KSUQgZm9yIERNRSBjb25maWd1cmF0
aW9uLg0KDQpGaXggdGhpcyBpc3N1ZSBieSBpbml0aWFsaXppbmcgInR4X2xhbmVzIi4NCg0KU2ln
bmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJldmll
d2VkLWJ5OiBBc3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc+DQpSZXZpZXdlZC1i
eTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQpSZXZpZXdlZC1ieTogQ2FuIEd1
byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMg
fCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYw0KaW5kZXggNTY5OGYxMTY0YTVlLi4zMTRlODA4YjBkNGUgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jDQpAQCAtNDMxNSw3ICs0MzE1LDcgQEAgRVhQT1JUX1NZTUJPTF9HUEwodWZzaGNkX2hiYV9l
bmFibGUpOw0KIA0KIHN0YXRpYyBpbnQgdWZzaGNkX2Rpc2FibGVfdHhfbGNjKHN0cnVjdCB1ZnNf
aGJhICpoYmEsIGJvb2wgcGVlcikNCiB7DQotCWludCB0eF9sYW5lcywgaSwgZXJyID0gMDsNCisJ
aW50IHR4X2xhbmVzID0gMCwgaSwgZXJyID0gMDsNCiANCiAJaWYgKCFwZWVyKQ0KIAkJdWZzaGNk
X2RtZV9nZXQoaGJhLCBVSUNfQVJHX01JQihQQV9DT05ORUNURURUWERBVEFMQU5FUyksDQotLSAN
CjIuMTguMA0K

