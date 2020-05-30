Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15355C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 14:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4A8820723
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 14:12:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ex6dMNgx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgE3OMQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 10:12:16 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:35429 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727851AbgE3OMP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 10:12:15 -0400
X-UUID: bc985702018f46eab8c0b9337d50acf1-20200530
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=TRzfygmbM6NOVfxuTVlVW0qLZCaDk7UZJHKfhhCZMfw=;
        b=ex6dMNgxPYq09qpGuR9BDb8y2mJoJFeWUB/6CmSgFdp3HOknvoRzVUG0rVnzp89T+0B2rXks8f0nbLqY1d9+r6BmmlLDsnDH5sTlpC6SiIY3fIMFWjJSyF7ipLeRmEWkMrHdvNUbC35vyyxGu/kxORGvMzz3Zg3WO6vXP4NPT7M=;
X-UUID: bc985702018f46eab8c0b9337d50acf1-20200530
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1778315157; Sat, 30 May 2020 22:12:11 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 30 May 2020 22:12:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 30 May 2020 22:12:02 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH] scsi: ufs: Remove redundant urgent_bkop_lvl initialization
Date:   Sat, 30 May 2020 22:12:00 +0800
Message-ID: <20200530141200.4616-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: A7F479A583566983861BC99DC4B0FA8CC3DA554407449841405341448573BA832000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW4gdWZzaGNkX3Byb2JlX2hiYSgpLCBhbGwgQktPUCBTVyB0cmFja2luZyB2YXJpYWJsZXMgY2Fu
IGJlIHJlc2V0DQp0b2dldGhlciBpbiB1ZnNoY2RfZm9yY2VfcmVzZXRfYXV0b19ia29wcygpLCB0
aHVzIHVyZ2VudF9ia29wX2x2bA0KaW5pdGlhbGl6YXRpb24gaW4gdGhlIGJlZ2lubmluZyBvZiB1
ZnNoY2RfcHJvYmVfaGJhKCkgY2FuIGJlIG1lcmdlZA0KaW50byB1ZnNoY2RfZm9yY2VfcmVzZXRf
YXV0b19ia29wcygpLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVA
bWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDUgKy0tLS0N
CiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYw0KaW5kZXggNWRiMThmNDQ0ZWE5Li5mMTFiZTY5ZTUwZTkgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpA
QCAtNTA3Niw2ICs1MDc2LDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2ZvcmNlX3Jlc2V0X2F1dG9f
YmtvcHMoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJCWhiYS0+ZWVfY3RybF9tYXNrICY9IH5NQVNL
X0VFX1VSR0VOVF9CS09QUzsNCiAJCXVmc2hjZF9kaXNhYmxlX2F1dG9fYmtvcHMoaGJhKTsNCiAJ
fQ0KKwloYmEtPnVyZ2VudF9ia29wc19sdmwgPSBCS09QU19TVEFUVVNfUEVSRl9JTVBBQ1Q7DQog
CWhiYS0+aXNfdXJnZW50X2Jrb3BzX2x2bF9jaGVja2VkID0gZmFsc2U7DQogfQ0KIA0KQEAgLTcz
NzMsMTAgKzczNzQsNiBAQCBzdGF0aWMgaW50IHVmc2hjZF9wcm9iZV9oYmEoc3RydWN0IHVmc19o
YmEgKmhiYSwgYm9vbCBhc3luYykNCiAJaWYgKHJldCkNCiAJCWdvdG8gb3V0Ow0KIA0KLQkvKiBz
ZXQgdGhlIGRlZmF1bHQgbGV2ZWwgZm9yIHVyZ2VudCBia29wcyAqLw0KLQloYmEtPnVyZ2VudF9i
a29wc19sdmwgPSBCS09QU19TVEFUVVNfUEVSRl9JTVBBQ1Q7DQotCWhiYS0+aXNfdXJnZW50X2Jr
b3BzX2x2bF9jaGVja2VkID0gZmFsc2U7DQotDQogCS8qIERlYnVnIGNvdW50ZXJzIGluaXRpYWxp
emF0aW9uICovDQogCXVmc2hjZF9jbGVhcl9kYmdfdWZzX3N0YXRzKGhiYSk7DQogDQotLSANCjIu
MTguMA0K

