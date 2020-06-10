Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4912C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 05:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CBDA207F9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 05:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AjMqbccN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgFJFg7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 01:36:59 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:18501 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726040AbgFJFg6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 01:36:58 -0400
X-UUID: 5ace7ee9103c4bdfbecfc2424025e79d-20200610
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=zpPOwXJySmLsu0FQDgDIwWd9GLxAzFlyAq88sb7rQiY=;
        b=AjMqbccN73ofkKtgthu+bF7a2TB1Csg3Ysvb7aZjPjCDHkDJTw8l2SUAk92wszugG7kMF+3ilbz4EyEVBMU0F+OBMklJaN4kD0aJy9uB90fG+B8PexDw8X8SvDoa7eMj6rICGyR895phNy7f9WNEDQAWbpWoxC9yM8A15wWWtYk=;
X-UUID: 5ace7ee9103c4bdfbecfc2424025e79d-20200610
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 907488388; Wed, 10 Jun 2020 13:36:55 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 10 Jun 2020 13:36:54 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Jun 2020 13:36:52 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/2] scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices
Date:   Wed, 10 Jun 2020 13:36:44 +0800
Message-ID: <20200610053645.19975-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200610053645.19975-1-stanley.chu@mediatek.com>
References: <20200610053645.19975-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SXQgaXMgY29uZmlybWVkIHRoYXQgTWljcm9uIGRldmljZSBuZWVkcyBERUxBWV9CRUZPUkVfTFBN
DQpxdWlyayB0byBoYXZlIGEgZGVsYXkgYmVmb3JlIFZDQyBpcyBwb3dlcmVkIG9mZi4gU28gYWRk
IE1pY3Jvbg0KdmVuZG9yIElEIGFuZCB0aGlzIHF1aXJrIGZvciBNaWNyb24gZGV2aWNlcy4NCg0K
U2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0t
LQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzX3F1aXJrcy5oIHwgMSArDQogZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYyAgICAgfCAyICsrDQogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzX3F1aXJrcy5oIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNfcXVpcmtzLmgNCmluZGV4IGUzMTc1YTYzYzY3Ni4uZTgwZDVmMjZhNDQyIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmgNCisrKyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzX3F1aXJrcy5oDQpAQCAtMTIsNiArMTIsNyBAQA0KICNkZWZpbmUgVUZTX0FO
WV9WRU5ET1IgMHhGRkZGDQogI2RlZmluZSBVRlNfQU5ZX01PREVMICAiQU5ZX01PREVMIg0KIA0K
KyNkZWZpbmUgVUZTX1ZFTkRPUl9NSUNST04gICAgICAweDEyQw0KICNkZWZpbmUgVUZTX1ZFTkRP
Ul9UT1NISUJBICAgICAweDE5OA0KICNkZWZpbmUgVUZTX1ZFTkRPUl9TQU1TVU5HICAgICAweDFD
RQ0KICNkZWZpbmUgVUZTX1ZFTkRPUl9TS0hZTklYICAgICAweDFBRA0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRl
eCAwNGI3OWNhNjZmZGYuLmRlYTRmZGRmOTMzMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC0yMTYsNiAr
MjE2LDggQEAgdWZzX2dldF9kZXNpcmVkX3BtX2x2bF9mb3JfZGV2X2xpbmtfc3RhdGUoZW51bSB1
ZnNfZGV2X3B3cl9tb2RlIGRldl9zdGF0ZSwNCiANCiBzdGF0aWMgc3RydWN0IHVmc19kZXZfZml4
IHVmc19maXh1cHNbXSA9IHsNCiAJLyogVUZTIGNhcmRzIGRldmlhdGlvbnMgdGFibGUgKi8NCisJ
VUZTX0ZJWChVRlNfVkVORE9SX01JQ1JPTiwgVUZTX0FOWV9NT0RFTCwNCisJCVVGU19ERVZJQ0Vf
UVVJUktfREVMQVlfQkVGT1JFX0xQTSksDQogCVVGU19GSVgoVUZTX1ZFTkRPUl9TQU1TVU5HLCBV
RlNfQU5ZX01PREVMLA0KIAkJVUZTX0RFVklDRV9RVUlSS19ERUxBWV9CRUZPUkVfTFBNKSwNCiAJ
VUZTX0ZJWChVRlNfVkVORE9SX1NBTVNVTkcsIFVGU19BTllfTU9ERUwsDQotLSANCjIuMTguMA0K

