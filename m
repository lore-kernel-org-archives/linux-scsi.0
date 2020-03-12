Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDDEC10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 13:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D59B20737
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 13:24:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="J29DnIDj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgCLNYA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 09:24:00 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:3103 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726571AbgCLNX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 09:23:59 -0400
X-UUID: 2556dbb21a3641b4a4ce3fa79f1d3ae5-20200312
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=GAb0a+7kM9bfrtZJR62MQdr6XS0ZdbXUK5GgYwszV3c=;
        b=J29DnIDjRdt7jZoMClc2x//t9jYMWXrRg+M6kExI1yTvR5kq1jxrTeQcBdUjku9CqufmQuyLfeEjqdAjx1R+ZR1PVO8enn7EQbZ7DvGKbny7Xp/UeTUS0GQxD9tYSr4q71EhA/9YjlCPaC/SQHuDe8sf/SwrkeL6RU4zUKxO+pA=;
X-UUID: 2556dbb21a3641b4a4ce3fa79f1d3ae5-20200312
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 353618774; Thu, 12 Mar 2020 21:23:54 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Mar 2020 21:22:38 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Mar 2020 21:21:03 +0800
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
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 8/8] scsi: ufs-mediatek: customize the delay for host enabling
Date:   Thu, 12 Mar 2020 21:23:50 +0800
Message-ID: <20200312132350.18061-9-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200312132350.18061-1-stanley.chu@mediatek.com>
References: <20200312132350.18061-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWVkaWFUZWsgcGxhdGZvcm0gYW5kIFVGUyBjb250cm9sbGVyIGNhbiBkeW5hbWljYWxseSBjdXN0
b21pemUNCnRoZSBkZWxheSBmb3IgaG9zdCBlbmFibGluZyBhY2NvcmRpbmcgdG8gZGlmZmVyZW50
IHNjZW5hcmlvcy4NCg0KRm9yIGV4YW1wbGUsIGZvciBob3N0IGluaXRpYWxpemF0aW9uIHdpdGgg
bG93LWxldmVsIE1QSFkgY2FsaWJyYXRpb24NCnJlcXVpcmVkLCBsb25nZXIgZGVsYXkgc2hhbGwg
YmUgZXhwZWN0ZWQuIEJ1dCB0aGUgZGVsYXkgY291bGQgYmUgcmVtb3ZlZA0KaWYgc3VjaCBNUEhZ
IGNhbGlicmF0aW9uIGNhbiBiZSBza2lwcGVkLCBsaWtlIHJlc3VtZSBmbG93Lg0KDQpTaWduZWQt
b2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJp
dmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDE0ICsrKysrKysrKysrKysrDQogMSBmaWxl
IGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRl
eCAwZmY2NzgxNjU0ZmQuLjZmNDM3ZjAwOTFiZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMN
CkBAIC03MSw2ICs3MSwxOSBAQCBzdGF0aWMgdm9pZCB1ZnNfbXRrX2NmZ191bmlwcm9fY2coc3Ry
dWN0IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpDQogCX0NCiB9DQogDQorc3RhdGljIGludCB1
ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5KHN0cnVjdCB1ZnNfaGJhICpoYmEsDQorCQkJCSAgICAg
ZW51bSB1ZnNfbm90aWZ5X2NoYW5nZV9zdGF0dXMgc3RhdHVzKQ0KK3sNCisJaWYgKHN0YXR1cyA9
PSBQUkVfQ0hBTkdFKSB7DQorCQlpZiAoaGJhLT5wbV9vcF9pbl9wcm9ncmVzcykNCisJCQloYmEt
PmhiYV9lbmFibGVfZGVsYXlfdXMgPSAwOw0KKwkJZWxzZQ0KKwkJCWhiYS0+aGJhX2VuYWJsZV9k
ZWxheV91cyA9IDEwMDsNCisJfQ0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQogc3RhdGljIGludCB1
ZnNfbXRrX2JpbmRfbXBoeShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJc3RydWN0IHVmc19t
dGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KQEAgLTU1Miw2ICs1NjUs
NyBAQCBzdGF0aWMgc3RydWN0IHVmc19oYmFfdmFyaWFudF9vcHMgdWZzX2hiYV9tdGtfdm9wcyA9
IHsNCiAJLm5hbWUgICAgICAgICAgICAgICAgPSAibWVkaWF0ZWsudWZzaGNpIiwNCiAJLmluaXQg
ICAgICAgICAgICAgICAgPSB1ZnNfbXRrX2luaXQsDQogCS5zZXR1cF9jbG9ja3MgICAgICAgID0g
dWZzX210a19zZXR1cF9jbG9ja3MsDQorCS5oY2VfZW5hYmxlX25vdGlmeSAgID0gdWZzX210a19o
Y2VfZW5hYmxlX25vdGlmeSwNCiAJLmxpbmtfc3RhcnR1cF9ub3RpZnkgPSB1ZnNfbXRrX2xpbmtf
c3RhcnR1cF9ub3RpZnksDQogCS5wd3JfY2hhbmdlX25vdGlmeSAgID0gdWZzX210a19wd3JfY2hh
bmdlX25vdGlmeSwNCiAJLmFwcGx5X2Rldl9xdWlya3MgICAgPSB1ZnNfbXRrX2FwcGx5X2Rldl9x
dWlya3MsDQotLSANCjIuMTguMA0K

