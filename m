Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11675C28CBC
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 09:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D26F424954
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 09:37:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="F682NrjV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgEIJhW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 May 2020 05:37:22 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:14299 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726885AbgEIJhV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2020 05:37:21 -0400
X-UUID: af4c143c0417438c98634c562919f6fc-20200509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=+7J/Ls/qZVPDQuRiUUjEeGW9nmJ58u2HwRnHyuO/vGQ=;
        b=F682NrjVCiA6DkCOVjnfoy8CWlR7fchyfIbvkY1zxY2C1WDZJYIjaNKNxRUtVxmcVEh7SvbOu87ZwZ1h0GeH0pT3z7t6ZDvtkwgKEuJeBWOyln2UwD0nCLFHnS1IINyt4LMt1aKqvsI2ApouD1H/peNM7I+RYGIrAYUj136/MAQ=;
X-UUID: af4c143c0417438c98634c562919f6fc-20200509
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 455811775; Sat, 09 May 2020 17:37:19 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 9 May 2020 17:37:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 9 May 2020 17:37:17 +0800
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
Subject: [PATCH v2 4/4] scsi: ufs-mediatek: customize WriteBooster flush policy
Date:   Sat, 9 May 2020 17:37:16 +0800
Message-ID: <20200509093716.21010-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200509093716.21010-1-stanley.chu@mediatek.com>
References: <20200509093716.21010-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q2hhbmdlIHRoZSBXcml0ZUJvb3N0ZXIgcG9saWN5IHRvIGtlZXAgVkNDIG9uIGR1cmluZw0KcnVu
dGltZSBzdXNwZW5kIGlmIGF2YWlsYWJsZSBXcml0ZUJvb3N0ZXIgYnVmZmVyIGlzIGxlc3MNCnRo
YW4gODAlLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0
ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDEgKw0KIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCmlu
ZGV4IDU2NjIwZjdkODhjZS4uOTRlOTc3MDFmNDU2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsu
Yw0KQEAgLTI3MSw2ICsyNzEsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfaW5pdChzdHJ1Y3QgdWZz
X2hiYSAqaGJhKQ0KIA0KIAkvKiBFbmFibGUgV3JpdGVCb29zdGVyICovDQogCWhiYS0+Y2FwcyB8
PSBVRlNIQ0RfQ0FQX1dCX0VOOw0KKwloYmEtPnZwcy0+d2JfZmx1c2hfdGhyZXNob2xkID0gVUZT
X1dCX0JVRl9SRU1BSU5fUEVSQ0VOVCg4MCk7DQogDQogCS8qDQogCSAqIHVmc2hjZF92b3BzX2lu
aXQoKSBpcyBpbnZva2VkIGFmdGVyDQotLSANCjIuMTguMA0K

