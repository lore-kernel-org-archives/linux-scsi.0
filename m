Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3FDC2D0CE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 08:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79BE32071E
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 08:12:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Tiokwoks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfL3IMi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 03:12:38 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:63473 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727158AbfL3IMi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2019 03:12:38 -0500
X-UUID: 80ecf541e5184d9385c641f7fabbf22f-20191230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=/YZexolleNxYdLH94VTF+1Nzdu/S0YyPkZtHTfyc+dQ=;
        b=TiokwoksPadoLE5VKDI52uCdSK6yF7KBGiedCnGXvcBk6xdf+v//lFx/PQHHRzZ3rN7Zm+3iQZu0N3Kri88OlSoQujiFuPed0gDZr+51sZKC7xasJG/8gmDuD37QbYOIB1olO3VQOKocu5roSoViRVJWMeuePTEcYdedoM0gPlI=;
X-UUID: 80ecf541e5184d9385c641f7fabbf22f-20191230
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 311894709; Mon, 30 Dec 2019 16:12:29 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Dec 2019 16:11:44 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 30 Dec 2019 16:12:01 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <subhashj@codeaurora.org>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] scsi: ufs: fix device power mode during PM flow
Date:   Mon, 30 Dec 2019 16:12:24 +0800
Message-ID: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 89A27EB953EE34CD40C8ACDDBFE67EEEE8EF9490F2E37448EE8116C824FD8D7E2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgc2VyaWVzIGZpeGVzIGEgZGV2aWNlIHBvd2VyIG1vZGUgaXNzdWUgaW4gc3Vz
cGVuZCBhbmQgcmVzdW1lIGZsb3cuDQoNClN0YW5sZXkgQ2h1ICgyKToNCiAgc2NzaTogdWZzOiBz
ZXQgZGV2aWNlIGFzIGRlZmF1bHQgYWN0aXZlIHBvd2VyIG1vZGUgZHVyaW5nDQogICAgaW5pdGlh
bGl6YXRpb24gb25seQ0KICBzY3NpOiB1ZnM6IHJlbW92ZSBsaW5rX3N0YXJ0dXBfYWdhaW4gZmxv
dyBpbiB1ZnNoY2RfbGlua19zdGFydHVwDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwg
MTggKystLS0tLS0tLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MTYgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

