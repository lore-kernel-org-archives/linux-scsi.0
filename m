Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827A0C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 14:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5594E206B7
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 14:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YhwpgXWR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgFOObf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 10:31:35 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:64311 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730461AbgFOObd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 10:31:33 -0400
X-UUID: 4adfd82a1a334302bce02da5e31a43b3-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=K9jHs+9H91saKQrMUULPDpgsjmfGksPsDZmJk9xUKNo=;
        b=YhwpgXWRNRFDaboZWLR2duUBpeu5FfW9+6O7uWNQlUs2YkuFNc+b7gcGTvfpbmJJzhLIfYXYijn091dfsd6QEIVXwxwyq1zfVaBCrNDqfO/hIGH/RRMuJlmhxDO/sfQT1COP5wPEP8fvDvQAAIBbLyG4+PWkcyTJTs54hY/0UiE=;
X-UUID: 4adfd82a1a334302bce02da5e31a43b3-20200615
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 159620200; Mon, 15 Jun 2020 22:31:28 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 22:31:22 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 22:31:22 +0800
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
Subject: [PATCH v1 1/3] scsi: ufs: Remove redundant label "out" in ufshcd_make_hba_operational()
Date:   Mon, 15 Jun 2020 22:31:21 +0800
Message-ID: <20200615143123.6627-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200615143123.6627-1-stanley.chu@mediatek.com>
References: <20200615143123.6627-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 84D1AD48027F382151A1FBAE985BF390C48AC140E1C9879E8ADBEAC8E9BBD40C2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TGFiZWwgIm91dCIgaXMgcmVkdW5kYW50IGluIHVmc2hjZF9tYWtlX2hiYV9vcGVyYXRpb25hbCgp
IGFuZA0KY2FuIGJlIHJlbW92ZWQuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFu
bGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwg
MiAtLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4
IDFlMTMxNmJhNzA4Mi4uMTUyYWU3ZjVhZTg2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTQyNTgsMTAg
KzQyNTgsOCBAQCBpbnQgdWZzaGNkX21ha2VfaGJhX29wZXJhdGlvbmFsKHN0cnVjdCB1ZnNfaGJh
ICpoYmEpDQogCQlkZXZfZXJyKGhiYS0+ZGV2LA0KIAkJCSJIb3N0IGNvbnRyb2xsZXIgbm90IHJl
YWR5IHRvIHByb2Nlc3MgcmVxdWVzdHMiKTsNCiAJCWVyciA9IC1FSU87DQotCQlnb3RvIG91dDsN
CiAJfQ0KIA0KLW91dDoNCiAJcmV0dXJuIGVycjsNCiB9DQogRVhQT1JUX1NZTUJPTF9HUEwodWZz
aGNkX21ha2VfaGJhX29wZXJhdGlvbmFsKTsNCi0tIA0KMi4xOC4wDQo=

