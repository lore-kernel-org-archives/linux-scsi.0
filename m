Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B785C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 09:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7E920767
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 09:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UEtOfsuq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgFPJv0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 05:51:26 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:19722 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726261AbgFPJv0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 05:51:26 -0400
X-UUID: 093abb29ef2141c386ede716f4b65212-20200616
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=PUmd0x9RibPQtgq71WhoBPwcOlI5fEGWCsbX2zCT6VQ=;
        b=UEtOfsuq7DAjTXOjStRaimXdavQ70uYZhrfrMF/JC850yawuL0VNDaueBR8jq6YoQcClIGW1X4+7BnHLhI68YaERECB1gBD30a6PONW36gouybWqtqxxHnHmpC+csfIn3fIoA2QthvxmVKzmmMjF9J9sn1a3Bd62wiFCH+TvZSM=;
X-UUID: 093abb29ef2141c386ede716f4b65212-20200616
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1939617296; Tue, 16 Jun 2020 17:51:22 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Jun 2020 17:51:19 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Jun 2020 17:51:19 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH] scsi: ufs-mediatek: Make ufs_mtk_wait_link_state as static function
Date:   Tue, 16 Jun 2020 17:51:20 +0800
Message-ID: <20200616095120.14570-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rml4IGJ1aWxkIHdhcm5pbmcgcmVwb3J0ZWQgYnkga2VybmVsIHRlc3Qgcm9ib3Q6DQpNYWtlIHVm
c19tdGtfd2FpdF9saW5rX3N0YXRlKCkgYXMgc3RhdGljIGZ1bmN0b24uDQoNCldhcm5pbmc6DQo+
PiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jOjE4MTo1OiB3YXJuaW5nOiBubyBwcmV2
aW91cyBwcm90b3R5cGUNCj4+IGZvciAndWZzX210a193YWl0X2xpbmtfc3RhdGUnIFstV21pc3Np
bmctcHJvdG90eXBlc10NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1
QG1lZGlhdGVrLmNvbT4NClJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVs
LmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCA0ICsrLS0NCiAx
IGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLmMNCmluZGV4IDlhNDQzMmM5ZjdkYy4uYWQ5MjkyMzVjMTkzIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTE4NSw4ICsxODUsOCBAQCBzdGF0aWMgdm9pZCB1ZnNf
bXRrX3NldHVwX3JlZl9jbGtfd2FpdF91cyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KIAlob3N0LT5y
ZWZfY2xrX3VuZ2F0aW5nX3dhaXRfdXMgPSB1bmdhdGluZ191czsNCiB9DQogDQotaW50IHVmc19t
dGtfd2FpdF9saW5rX3N0YXRlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBzdGF0ZSwNCi0JCQkg
ICAgdW5zaWduZWQgbG9uZyBtYXhfd2FpdF9tcykNCitzdGF0aWMgaW50IHVmc19tdGtfd2FpdF9s
aW5rX3N0YXRlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBzdGF0ZSwNCisJCQkJICAgdW5zaWdu
ZWQgbG9uZyBtYXhfd2FpdF9tcykNCiB7DQogCWt0aW1lX3QgdGltZW91dCwgdGltZV9jaGVja2Vk
Ow0KIAl1MzIgdmFsOw0KLS0gDQoyLjE4LjANCg==

