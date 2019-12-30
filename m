Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DFA3C2D0DA
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E71B12071E
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:33:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="q3KhXjkQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfL3FdA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 00:33:00 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:9238 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727104AbfL3Fc6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2019 00:32:58 -0500
X-UUID: cf8a587317974d21862eb32da5015dd4-20191230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=t1x7DVC5KFTbvU5W0kCoABviHjsDt86RYQluEsX3mLY=;
        b=q3KhXjkQo49+avXjwl8BxgY9YYi/E124YMerkAg19pvKLCyAkapZQGCU6TFq29OMa/C+rwMPP8sUlZxO98fy+fQ5ZykC0wUZiRjIhCYoKQw4xjU+4DSW9bpcYxsUs+0FynbsP+iX5sIqj+9zra8j081kyRm1KiIUi78c95gISO8=;
X-UUID: cf8a587317974d21862eb32da5015dd4-20191230
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 983551164; Mon, 30 Dec 2019 13:32:52 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Dec 2019 13:32:05 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 30 Dec 2019 13:31:37 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <f.fainelli@gmail.com>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <leon.chen@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 5/6] scsi: ufs-mediatek: configure customized auto-hibern8 timer
Date:   Mon, 30 Dec 2019 13:32:29 +0800
Message-ID: <1577683950-1702-6-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
References: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q29uZmlndXJlIGN1c3RvbWl6ZWQgYXV0by1oaWJlcm44IHRpbWVyIGluIE1lZGlhVGVrIENoaXBz
ZXRzLg0KDQpDYzogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPg0KQ2M6IEF2
cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KQ2M6IEJhcnQgVmFuIEFzc2NoZSA8YnZh
bmFzc2NoZUBhY20ub3JnPg0KQ2M6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQpDYzog
Q2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCkNjOiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZh
aW5lbGxpQGdtYWlsLmNvbT4NCkNjOiBNYXR0aGlhcyBCcnVnZ2VyIDxtYXR0aGlhcy5iZ2dAZ21h
aWwuY29tPg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVr
LmNvbT4NClJldmlld2VkLWJ5OiBBbGltIEFraHRhciA8YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+
DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgOCArKysrKysrKw0KIDEg
ZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpp
bmRleCBmYzViYTIxZWMwMmEuLjFmMDI1NzIzYjYxYiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMNCkBAIC03LDYgKzcsNyBAQA0KICAqLw0KIA0KICNpbmNsdWRlIDxsaW51eC9hcm0tc21jY2Mu
aD4NCisjaW5jbHVkZSA8bGludXgvYml0ZmllbGQuaD4NCiAjaW5jbHVkZSA8bGludXgvb2YuaD4N
CiAjaW5jbHVkZSA8bGludXgvb2ZfYWRkcmVzcy5oPg0KICNpbmNsdWRlIDxsaW51eC9waHkvcGh5
Lmg+DQpAQCAtMzA1LDYgKzMwNiwxMyBAQCBzdGF0aWMgaW50IHVmc19tdGtfcG9zdF9saW5rKHN0
cnVjdCB1ZnNfaGJhICpoYmEpDQogCS8qIGVuYWJsZSB1bmlwcm8gY2xvY2sgZ2F0aW5nIGZlYXR1
cmUgKi8NCiAJdWZzX210a19jZmdfdW5pcHJvX2NnKGhiYSwgdHJ1ZSk7DQogDQorCS8qIGNvbmZp
Z3VyZSBhdXRvLWhpYmVybjggdGltZXIgdG8gMTBtcyAqLw0KKwlpZiAodWZzaGNkX2lzX2F1dG9f
aGliZXJuOF9zdXBwb3J0ZWQoaGJhKSkgew0KKwkJdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUo
aGJhLA0KKwkJCUZJRUxEX1BSRVAoVUZTSENJX0FISUJFUk44X1RJTUVSX01BU0ssIDEwKSB8DQor
CQkJRklFTERfUFJFUChVRlNIQ0lfQUhJQkVSTjhfU0NBTEVfTUFTSywgMykpOw0KKwl9DQorDQog
CXJldHVybiAwOw0KIH0NCiANCi0tIA0KMi4xOC4wDQo=

