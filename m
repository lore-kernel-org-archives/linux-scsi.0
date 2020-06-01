Return-Path: <SRS0=+zlT=7O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688ADC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 10:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B52520772
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 10:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MS6FVG0C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgFAKrA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Jun 2020 06:47:00 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:54511 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726128AbgFAKq4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2020 06:46:56 -0400
X-UUID: a26c1c69594c403b9d93289ecddb8002-20200601
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=HC7R/RfYWhRRX5sUAj43TCGykJv8IzBjx5dQ0drVC1Y=;
        b=MS6FVG0CJMlklXSkKrq2E05G3ez5TpsEAyO679RfNqQGsAwokG/E82vZhBK3xwx0aKapkgVKvmXcU6SENIRmCKz+eM7RPg7sCapjhLlQJAb1ZI2Lk7DvoqGwonUEc+czAQyd3Xj4/BcWIV4qsQkiftTrIsjPtOd0dpVzQnG5qLs=;
X-UUID: a26c1c69594c403b9d93289ecddb8002-20200601
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 68702291; Mon, 01 Jun 2020 18:46:48 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 1 Jun 2020 18:46:46 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 1 Jun 2020 18:46:46 +0800
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
Subject: [PATCH v3 5/5] scsi: ufs-mediatek: Allow unbound mphy
Date:   Mon, 1 Jun 2020 18:46:46 +0800
Message-ID: <20200601104646.15436-6-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200601104646.15436-1-stanley.chu@mediatek.com>
References: <20200601104646.15436-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWxsb3cgdW5ib3VuZCBNUEhZIG1vZHVsZSBzaW5jZSBub3QgZXZlcnkgTWVkaWFUZWsgVUZTIHBs
YXRmb3JtDQpuZWVkcyBzcGVjaWZpYyBNUEhZIGNvbnRyb2wuDQoNClNpZ25lZC1vZmYtYnk6IFN0
YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpSZXZpZXdlZC1ieTogUGV0ZXIg
V2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5jIHwgNiArKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCsp
DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggMWNjN2JlYTE0NjhiLi45YTQ0MzJjOWY3
ZGMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQorKysgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAtMTEzLDYgKzExMywxMiBAQCBzdGF0
aWMgaW50IHVmc19tdGtfYmluZF9tcGh5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogDQogCWlmIChl
cnIpDQogCQlob3N0LT5tcGh5ID0gTlVMTDsNCisJLyoNCisJICogQWxsb3cgdW5ib3VuZCBtcGh5
IGJlY2F1c2Ugbm90IGV2ZXJ5IHBsYXRmb3JtIG5lZWRzIHNwZWNpZmljDQorCSAqIG1waHkgY29u
dHJvbC4NCisJICovDQorCWlmIChlcnIgPT0gLUVOT0RFVikNCisJCWVyciA9IDA7DQogDQogCXJl
dHVybiBlcnI7DQogfQ0KLS0gDQoyLjE4LjANCg==

