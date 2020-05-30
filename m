Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEB1C433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 15:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE351208E4
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 15:13:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Kza9OG7A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgE3PN6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 11:13:58 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:57381 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728927AbgE3PNz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 11:13:55 -0400
X-UUID: 3f1c7e5bf82a4482ac02fdac71eec81b-20200530
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=SPJ40cDjqiU6ZOCt6LvTtGZM/kEwgPDknQLr1x5cZfY=;
        b=Kza9OG7AGv27NbJbLE9OIiD+PFPwgDGluPkAC3Im8IQv9jDqOzohNkWZM/9L7oJPBaYnu85pfTndcy0E82Xb0Q0veNl8YsScOl/UtHcbGDESH1//7koFAAJ2gvtsCibjdetxPwVEZBVL7p0KrpyLjuRFDgF8LuLuYFQvDf+XMFI=;
X-UUID: 3f1c7e5bf82a4482ac02fdac71eec81b-20200530
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1014182968; Sat, 30 May 2020 23:13:51 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 30 May 2020 23:13:37 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 30 May 2020 23:13:37 +0800
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
Subject: [PATCH v1 2/2] scsi: ufs-mediatek: Support WriteBooster on Samsung UFS devices
Date:   Sat, 30 May 2020 23:13:37 +0800
Message-ID: <20200530151337.6182-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200530151337.6182-1-stanley.chu@mediatek.com>
References: <20200530151337.6182-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: D9C1B2FE1DB9811E2C52585261D356E405E346685F5B7B75511E572B46C88C132000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGRldmljZSBxdWlyayAiVUZTX0RFVklDRV9RVUlSS19XQl9VU0lOR19TUEVDSUFMX1NFTEVD
VE9SIg0Kb24gYWxsIFNhbXN1bmcgVUZTIGRldmljZXMgdG8gZW5hYmxlIFdyaXRlQm9vc3RlciBv
biB0aG9zZQ0KZGV2aWNlcy4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXku
Y2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMg
fCAzICsrKw0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1t
ZWRpYXRlay5jDQppbmRleCBkNTg3YjMyNzZhYTguLjA3OGExZTNkMDVkMyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLmMNCkBAIC0zMiw2ICszMiw5IEBADQogCXVmc19tdGtfc21jKFVGU19NVEtf
U0lQX0RFVklDRV9SRVNFVCwgaGlnaCwgcmVzKQ0KIA0KIHN0YXRpYyBzdHJ1Y3QgdWZzX2Rldl9m
aXggdWZzX210a19kZXZfZml4dXBzW10gPSB7DQorCVVGU19GSVgoVUZTX1ZFTkRPUl9TQU1TVU5H
LCBVRlNfQU5ZX01PREVMLA0KKwkJVUZTX0RFVklDRV9RVUlSS19TVVBQT1JUX0VYVEVOREVEX0ZF
QVRVUkVTIHwNCisJCVVGU19ERVZJQ0VfUVVJUktfV0JfU1BFQ0lBTF9TRUxFQ1RPUiksDQogCVVG
U19GSVgoVUZTX1ZFTkRPUl9TS0hZTklYLCAiSDlIUTIxQUZBTVpEQVIiLA0KIAkJVUZTX0RFVklD
RV9RVUlSS19TVVBQT1JUX0VYVEVOREVEX0ZFQVRVUkVTKSwNCiAJRU5EX0ZJWA0KLS0gDQoyLjE4
LjANCg==

