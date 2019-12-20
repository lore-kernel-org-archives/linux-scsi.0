Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934E3C2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A3D124680
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dClNCxXh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfLTIg4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 03:36:56 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:24362 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727110AbfLTIgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 03:36:43 -0500
X-UUID: 6c24fab80c6e472fbeb1bf0d8a61d88b-20191220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=1dTM/x2XgEndTdXRTGoeD0Ozp3L9tzAYcN6PciDyt3c=;
        b=dClNCxXhNVqDx8r6BXkfQwB5V9UU2+rjpa+fKc1h9T+wAcDpIniTtvT4Iu6Q4VJNu5U0OBOYuQRUwXR3NhoGyY1cqEpQIF/SZpwoZhaoZCpSZL7rw31YuPNY6kN1af9odjvCNWb9jS6eJDrLC7EyST4u1/eUQ0bLzMQp6xk5w20=;
X-UUID: 6c24fab80c6e472fbeb1bf0d8a61d88b-20191220
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 452913011; Fri, 20 Dec 2019 16:36:36 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 20 Dec 2019 16:35:59 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 20 Dec 2019 16:35:39 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <f.fainelli@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <leon.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 6/6] scsi: ufs-mediatek: configure and enable clk-gating
Date:   Fri, 20 Dec 2019 16:36:28 +0800
Message-ID: <1576830988-22435-7-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
References: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 367E02E7C7D61D709754BA5D29E13B252DAD17ECDB3D2FE27103CD478EB3C1812000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RW5hYmxlIGNsay1nYXRpbmcgd2l0aCBjdXN0b21pemVkIGRlbGF5ZWQgdGltZXIgdmFsdWUgaW4N
Ck1lZGlhVGVrIENoaXBzZXRzLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rhbmxl
eS5jaHVAbWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQtYnk6IEFsaW0gQWtodGFyIDxhbGltLmFraHRh
ckBzYW1zdW5nLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAy
MiArKysrKysrKysrKysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDIyIGluc2VydGlvbnMo
KykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCA3MWUyZTBlNGVhMTEuLjI4MmFkMDZl
Yzg0NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0yMDUsNiArMjA1LDkgQEAgc3Rh
dGljIGludCB1ZnNfbXRrX2luaXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJLyogRW5hYmxlIHJ1
bnRpbWUgYXV0b3N1c3BlbmQgKi8NCiAJaGJhLT5jYXBzIHw9IFVGU0hDRF9DQVBfUlBNX0FVVE9T
VVNQRU5EOw0KIA0KKwkvKiBFbmFibGUgY2xvY2stZ2F0aW5nICovDQorCWhiYS0+Y2FwcyB8PSBV
RlNIQ0RfQ0FQX0NMS19HQVRJTkc7DQorDQogCS8qDQogCSAqIHVmc2hjZF92b3BzX2luaXQoKSBp
cyBpbnZva2VkIGFmdGVyDQogCSAqIHVmc2hjZF9zZXR1cF9jbG9jayh0cnVlKSBpbiB1ZnNoY2Rf
aGJhX2luaXQoKSB0aHVzDQpAQCAtMjkzLDYgKzI5NiwyMyBAQCBzdGF0aWMgaW50IHVmc19tdGtf
cHJlX2xpbmsoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJcmV0dXJuIHJldDsNCiB9DQogDQorc3Rh
dGljIHZvaWQgdWZzX210a19zZXR1cF9jbGtfZ2F0aW5nKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQor
ew0KKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KKwl1MzIgYWhfbXM7DQorDQorCWlmICh1ZnNoY2Rf
aXNfY2xrZ2F0aW5nX2FsbG93ZWQoaGJhKSkgew0KKwkJaWYgKHVmc2hjZF9pc19hdXRvX2hpYmVy
bjhfc3VwcG9ydGVkKGhiYSkgJiYgaGJhLT5haGl0KQ0KKwkJCWFoX21zID0gRklFTERfR0VUKFVG
U0hDSV9BSElCRVJOOF9USU1FUl9NQVNLLA0KKwkJCQkJICBoYmEtPmFoaXQpOw0KKwkJZWxzZQ0K
KwkJCWFoX21zID0gMTA7DQorCQlzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9j
aywgZmxhZ3MpOw0KKwkJaGJhLT5jbGtfZ2F0aW5nLmRlbGF5X21zID0gYWhfbXMgKyA1Ow0KKwkJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KKwl9
DQorfQ0KKw0KIHN0YXRpYyBpbnQgdWZzX210a19wb3N0X2xpbmsoc3RydWN0IHVmc19oYmEgKmhi
YSkNCiB7DQogCS8qIGRpc2FibGUgZGV2aWNlIExDQyAqLw0KQEAgLTMwOCw2ICszMjgsOCBAQCBz
dGF0aWMgaW50IHVmc19tdGtfcG9zdF9saW5rKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCQkJRklF
TERfUFJFUChVRlNIQ0lfQUhJQkVSTjhfU0NBTEVfTUFTSywgMykpOw0KIAl9DQogDQorCXVmc19t
dGtfc2V0dXBfY2xrX2dhdGluZyhoYmEpOw0KKw0KIAlyZXR1cm4gMDsNCiB9DQogDQotLSANCjIu
MTguMA0K

