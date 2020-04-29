Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCDEC83006
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 13:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DC422083B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 13:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="X+YKqdQ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgD2N4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 09:56:18 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:3388 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726949AbgD2N4Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2020 09:56:16 -0400
X-UUID: afac153e3fc9441f813eae8bf8fb922b-20200429
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=oSE2OoXFjN34Iayd4h3+QPXE9+S+ncvnsRfCYGToq28=;
        b=X+YKqdQ85AB3isGEdVQ/7eDzrY6t+45i9QkTc92Q+w60c/64PiwUk676rni8kz4qwPHQBJvfGjJhoeWTkvM6+icZnJjTd8V+vqBtxU8Vo/fcjfCQtbgO5fvesMJxucp4uQ8roaQnU81AVejwEshvtOapU1XV1+79tpc8ALr5tpc=;
X-UUID: afac153e3fc9441f813eae8bf8fb922b-20200429
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 118533047; Wed, 29 Apr 2020 21:56:13 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Apr 2020 21:56:10 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Apr 2020 21:56:08 +0800
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
Subject: [PATCH v2 0/5] scsi: ufs: support LU Dedicated buffer type for WriteBooster
Date:   Wed, 29 Apr 2020 21:56:05 +0800
Message-ID: <20200429135610.23750-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgYWRkcyBMVSBkZWRpY2F0ZWQgYnVmZmVyIG1vZGUgc3VwcG9y
dCBmb3IgV3JpdGVCb29zdGVyLg0KDQpJbiB0aGUgbWVhbndoaWxlLCBlbmFibGUgV3JpdGVCb29z
dGVyIGNhcGFiaWxpdHkgb24gTWVkaWFUZWsgVUZTIHBsYXRmb3Jtcy4NCg0KdjEgLT4gdjI6DQog
IC0gQ2hhbmdlIHRoZSBkZWZpbml0aW9uIG5hbWUgb2YgV3JpdGVCb29zdGVyIGJ1ZmZlciBtb2Rl
IHRvIGNvcnJlc3BvbmQgdG8gc3BlY2lmaWNhdGlvbiAoQmVhbiBIdW8pDQogIC0gQWRkIHBhdGNo
ICM1OiAic2NzaTogdWZzOiBjbGVhbnVwIFdyaXRlQm9vc3RlciBmZWF0dXJlIg0KDQpTdGFubGV5
IENodSAoNSk6DQogIHNjc2k6IHVmczogYWxsb3cgbGVnYWN5IFVGUyBkZXZpY2VzIHRvIGVuYWJs
ZSBXcml0ZUJvb3N0ZXINCiAgc2NzaTogdWZzOiBhZGQgImluZGV4IiBpbiBwYXJhbWV0ZXIgbGlz
dCBvZiB1ZnNoY2RfcXVlcnlfZmxhZygpDQogIHNjc2k6IHVmczogYWRkIExVIERlZGljYXRlZCBi
dWZmZXIgbW9kZSBzdXBwb3J0IGZvciBXcml0ZUJvb3N0ZXINCiAgc2NzaTogdWZzLW1lZGlhdGVr
OiBlbmFibGUgV3JpdGVCb29zdGVyIGNhcGFiaWxpdHkNCiAgc2NzaTogdWZzOiBjbGVhbnVwIFdy
aXRlQm9vc3RlciBmZWF0dXJlDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwg
ICAzICsNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jICAgIHwgICAyICstDQogZHJpdmVy
cy9zY3NpL3Vmcy91ZnMuaCAgICAgICAgICB8ICAgNyArKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMgICAgICAgfCAxMTIgKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0NCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oICAgICAgIHwgICAyICstDQogNSBmaWxlcyBjaGFuZ2VkLCA5
MCBpbnNlcnRpb25zKCspLCAzNiBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

