Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B095EC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8542B20776
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:48:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="n22tBQ8J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgFOGsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 02:48:09 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:43839 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728602AbgFOGsA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 02:48:00 -0400
X-UUID: 02b6cfc15c9a4d1b8224e6cd4fd73f5c-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=NX2+h82NMuVzjAxKBumSAQWD3ozofhPE4z0/RVmqYDE=;
        b=n22tBQ8JucIlMt+hec5sT9QgpLKWnCYCCavG+/4iV7DxLtlKEU/xun6o0f2CLxyiYgX+o45uFNRJUuzf5x14M35x6KJ3O+OpNET//TCwYD+VKZSBJA0a+Q2xWolNivMRTf0NyvcAadPm1Ct8XIoo4xs07/C9rdhAixi0Y7G3Oj0=;
X-UUID: 02b6cfc15c9a4d1b8224e6cd4fd73f5c-20200615
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1042032853; Mon, 15 Jun 2020 14:47:56 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 14:47:53 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 14:47:53 +0800
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
Subject: [PATCH v2 1/2] scsi: ufs: Remove unused field in struct uic_command
Date:   Mon, 15 Jun 2020 14:47:52 +0800
Message-ID: <20200615064753.20935-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200615064753.20935-1-stanley.chu@mediatek.com>
References: <20200615064753.20935-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UmVtb3ZlIHVudXNlZCBmaWVsZCAiY21kX2FjdGl2ZSIgYW5kICJyZXN1bHQiIGluIHN0cnVjdCB1
ZnNfY29tbWFuZC4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1l
ZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBBbGltIEFraHRhciA8YWxpbS5ha2h0YXJAc2Ftc3Vu
Zy5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIHwgNCAtLS0tDQogMSBmaWxl
IGNoYW5nZWQsIDQgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggYmY5N2Q2MTZlNTk3
Li43ZmEzNWM3ODM0MmIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQor
KysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtODgsOCArODgsNiBAQCBlbnVtIGRl
dl9jbWRfdHlwZSB7DQogICogQGFyZ3VtZW50MTogVUlDIGNvbW1hbmQgYXJndW1lbnQgMQ0KICAq
IEBhcmd1bWVudDI6IFVJQyBjb21tYW5kIGFyZ3VtZW50IDINCiAgKiBAYXJndW1lbnQzOiBVSUMg
Y29tbWFuZCBhcmd1bWVudCAzDQotICogQGNtZF9hY3RpdmU6IEluZGljYXRlIGlmIFVJQyBjb21t
YW5kIGlzIG91dHN0YW5kaW5nDQotICogQHJlc3VsdDogVUlDIGNvbW1hbmQgcmVzdWx0DQogICog
QGRvbmU6IFVJQyBjb21tYW5kIGNvbXBsZXRpb24NCiAgKi8NCiBzdHJ1Y3QgdWljX2NvbW1hbmQg
ew0KQEAgLTk3LDggKzk1LDYgQEAgc3RydWN0IHVpY19jb21tYW5kIHsNCiAJdTMyIGFyZ3VtZW50
MTsNCiAJdTMyIGFyZ3VtZW50MjsNCiAJdTMyIGFyZ3VtZW50MzsNCi0JaW50IGNtZF9hY3RpdmU7
DQotCWludCByZXN1bHQ7DQogCXN0cnVjdCBjb21wbGV0aW9uIGRvbmU7DQogfTsNCiANCi0tIA0K
Mi4xOC4wDQo=

