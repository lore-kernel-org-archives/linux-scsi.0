Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BCCC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 08:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 184D720639
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 08:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="sq2coitV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHSInq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 04:43:46 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:17227 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725903AbgHSInp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2020 04:43:45 -0400
X-UUID: 833d184e013544a493d81f99e5afc5a3-20200819
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=AECUkhYUHBHHNyZQuHsduJ7+PYMR4h3yA3w0YXFQIAA=;
        b=sq2coitVuMZkfuGBl2AkCsuFUClEws7szVGl4t20fw/WQnAPvH5I0ahgpRzzbAwB+1vo60ayt/D3J02vMd5saLV7IyebFm6LB7y4Ea3YOp18Ks7zQQGvvJuiTSnBMM34tmf07fcpWnBwOO/Ih4Eoi5YUODcZV8p6LeY9XLDKVwg=;
X-UUID: 833d184e013544a493d81f99e5afc5a3-20200819
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 975283013; Wed, 19 Aug 2020 16:43:42 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 19 Aug 2020 16:43:39 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Aug 2020 16:43:39 +0800
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
Subject: [PATCH] scsi: ufs-mediatek: Modify the minimum RX/TX lane count to 2
Date:   Wed, 19 Aug 2020 16:43:40 +0800
Message-ID: <20200819084340.7021-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbTogQW5keSBUZW5nIDxhbmR5LnRlbmdAbWVkaWF0ZWsuY29tPg0KDQpNZWRpYVRlayBVRlMg
aG9zdCBzdGFydHMgdG8gc3VwcG9ydCAyIGxhbmVzLCB0aHVzIG1vZGlmeSB0aGUNCm1pbmltdW0g
bGFuZSBjb3VudCB0byAyLg0KDQpUaGlzIG1vZGlmaWNhdGlvbiBzaGFsbCBub3QgaW1wYWN0IG9s
ZCAxLWxhbmUgaG9zdCBiZWNhdXNlDQpQQV9DT05ORUNURURSWERBVEFMQU5FUyBhbmQgUEFfQ09O
TkVDVEVEVFhEQVRBTEFORVMgd2lsbCBsaW1pdCB0aGUNCnRhcmdldCBsYW5lcyBwcm9wZXJseSBk
dXJpbmcgcG93ZXIgbW9kZSBjaGFuZ2UuIFNvIHdlIGNvdWxkIHJlbGF4DQp0aGUgbGltaXRhdGlv
biBpbiB1ZnNfZGV2X3BhcmFtcy4NCg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5
LmNodUBtZWRpYXRlay5jb20+DQpTaWduZWQtb2ZmLWJ5OiBBbmR5IFRlbmcgPGFuZHkudGVuZ0Bt
ZWRpYXRlay5jb20+DQpTaW5nZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVk
aWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCB8IDQgKyst
LQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuaA0KaW5kZXggOGVkMjRkNWZjZmY5Li44NzY1NzM3NmQyN2EgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQorKysgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQpAQCAtMzMsOCArMzMsOCBAQA0KIC8qDQogICogVmVu
ZG9yIHNwZWNpZmljIHByZS1kZWZpbmVkIHBhcmFtZXRlcnMNCiAgKi8NCi0jZGVmaW5lIFVGU19N
VEtfTElNSVRfTlVNX0xBTkVTX1JYICAxDQotI2RlZmluZSBVRlNfTVRLX0xJTUlUX05VTV9MQU5F
U19UWCAgMQ0KKyNkZWZpbmUgVUZTX01US19MSU1JVF9OVU1fTEFORVNfUlggIDINCisjZGVmaW5l
IFVGU19NVEtfTElNSVRfTlVNX0xBTkVTX1RYICAyDQogI2RlZmluZSBVRlNfTVRLX0xJTUlUX0hT
R0VBUl9SWCAgICAgVUZTX0hTX0czDQogI2RlZmluZSBVRlNfTVRLX0xJTUlUX0hTR0VBUl9UWCAg
ICAgVUZTX0hTX0czDQogI2RlZmluZSBVRlNfTVRLX0xJTUlUX1BXTUdFQVJfUlggICAgVUZTX1BX
TV9HNA0KLS0gDQoyLjE4LjANCg==

