Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435F7C55179
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7FA120825
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:58:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="n408Xbl4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgJ2L6Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:58:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57414 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725730AbgJ2L6M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 07:58:12 -0400
X-UUID: 400c7866d4b14ec2b4333b905bfe8d0f-20201029
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=2FzU62fRjwCs/KkG2WvyHpAvZ/TJYD3zMGaS2CVuTCk=;
        b=n408Xbl4Etl3WB+IiHajCCub/y/CDBqr44BIX9VCOcPRtQexXNv66mOq6vobIqF8yFtkeIZ7jAxl4J+42aE8P5bP0/N0Gd3CeKRwb8ENynXhOtaPxz6jG7K1bvQ5Khp3qYuEnPabX2TgsJscwz0cmfZTO6P0eCoDJi44n1U2GvA=;
X-UUID: 400c7866d4b14ec2b4333b905bfe8d0f-20201029
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1759044456; Thu, 29 Oct 2020 19:58:06 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Oct 2020 19:57:51 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Oct 2020 19:57:51 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 5/6] scsi: ufs: Add enums for UniPro version higher than 1.6
Date:   Thu, 29 Oct 2020 19:57:49 +0800
Message-ID: <20201029115750.24391-6-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201029115750.24391-1-stanley.chu@mediatek.com>
References: <20201029115750.24391-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: F023B1AB7780F37F1C657FD9D5F3F5C0639BA911D2E0B7AF094F2D751CCF322B2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U29tZSB2ZW5kb3JzIG5lZWQgbmV3ZXIgVW5pUHJvIHZlcnNpb24gdG8gZGVjaWRlIGlmIHNvbWUg
ZmVhdHVyZXMNCmNhbiBiZSBlbmFibGVkIG9yIG5vdC4NCg0KU2ltcGx5IGFkZCBtaXNzaW5nIGVu
dW1zIGZvciB0aGUgbGF0ZXN0IFVuaVBybyB2ZXJzaW9ucy4NCg0KU2lnbmVkLW9mZi1ieTogU3Rh
bmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91
ZnMvdW5pcHJvLmggfCA2ICsrKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3VuaXByby5o
IGIvZHJpdmVycy9zY3NpL3Vmcy91bmlwcm8uaA0KaW5kZXggZjZiNTJjZTM2ZGU2Li44ZTllNDg2
YTRmN2IgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3VuaXByby5oDQorKysgYi9kcml2
ZXJzL3Njc2kvdWZzL3VuaXByby5oDQpAQCAtMjM3LDggKzIzNywxMCBAQCBlbnVtIHVmc191bmlw
cm9fdmVyIHsNCiAJVUZTX1VOSVBST19WRVJfUkVTRVJWRUQgPSAwLA0KIAlVRlNfVU5JUFJPX1ZF
Ul8xXzQwID0gMSwgLyogVW5pUHJvIHZlcnNpb24gMS40MCAqLw0KIAlVRlNfVU5JUFJPX1ZFUl8x
XzQxID0gMiwgLyogVW5pUHJvIHZlcnNpb24gMS40MSAqLw0KLQlVRlNfVU5JUFJPX1ZFUl8xXzYg
PSAzLCAgLyogVW5pUHJvIHZlcnNpb24gMS42ICovDQotCVVGU19VTklQUk9fVkVSX01BWCA9IDQs
ICAvKiBVbmlQcm8gdW5zdXBwb3J0ZWQgdmVyc2lvbiAqLw0KKwlVRlNfVU5JUFJPX1ZFUl8xXzYg
ID0gMywgLyogVW5pUHJvIHZlcnNpb24gMS42ICovDQorCVVGU19VTklQUk9fVkVSXzFfNjEgPSA0
LCAvKiBVbmlQcm8gdmVyc2lvbiAxLjYxICovDQorCVVGU19VTklQUk9fVkVSXzFfOCAgPSA1LCAv
KiBVbmlQcm8gdmVyc2lvbiAxLjggKi8NCisJVUZTX1VOSVBST19WRVJfTUFYICA9IDYsIC8qIFVu
aVBybyB1bnN1cHBvcnRlZCB2ZXJzaW9uICovDQogCS8qIFVuaVBybyB2ZXJzaW9uIGZpZWxkIG1h
c2sgaW4gUEFfTE9DQUxWRVJJTkZPICovDQogCVVGU19VTklQUk9fVkVSX01BU0sgPSAweEYsDQog
fTsNCi0tIA0KMi4xOC4wDQo=

