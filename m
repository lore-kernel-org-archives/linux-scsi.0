Return-Path: <SRS0=J5Rw=3S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A5AC35240
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 10:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67B372064C
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 10:53:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IrdZ5iDQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgA2KxJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jan 2020 05:53:09 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:27873 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726683AbgA2KxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2020 05:53:07 -0500
X-UUID: f0e10c9328f744daa266bd6a74101238-20200129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=YOeqNnQON0pZMvJ2TpcgdJrhCqwz0qDgTvW6jd4cUGg=;
        b=IrdZ5iDQeikJVk8a/7kLN/r3KvkibPQpsew7fsi1CCLv3mNOdjS5Q5a+eWdaacAnG9mNMt2aLi9XqAY4//N7eqmGJzcLt8PxVLCL3CbK5aQKpcl4ihaDTq54GqVXLUvnd8dy0JHRlsjdgZH5N2i2bS8E6Qk/r7gzXvd1/R7L/KU=;
X-UUID: f0e10c9328f744daa266bd6a74101238-20200129
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1409447737; Wed, 29 Jan 2020 18:53:00 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 29 Jan 2020 18:52:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 29 Jan 2020 18:52:59 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>
CC:     <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH RESEND v3 2/4] scsi: ufs-mediatek: support linkoff state during suspend
Date:   Wed, 29 Jan 2020 18:52:49 +0800
Message-ID: <20200129105251.12466-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200129105251.12466-1-stanley.chu@mediatek.com>
References: <20200129105251.12466-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: DC123E8965DA74E2D8BA28955FEE042764F383F49095A75C11AD3EBB4E6441692000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SWYgc3lzdGVtIHN1c3BlbmQgb3IgcnVudGltZSBzdXNwZW5kIG1vZGUgaXMgY29uZmlndXJlZCBh
cw0KbGlua29mZiBzdGF0ZSwgcGh5IGNhbiBiZSBwb3dlcmVkIG9mZiBhbmQgcmVmZXJlbmNlIGNs
b2NrDQpjYW4gYmUgZ2F0ZWQgaW4gTWVkaWFUZWsgQ2hpcHNldHMuDQoNCkluIHRoZSBzYW1lIHRp
bWUsIHJlbW92ZSByZWR1bmRhbnQgcmVmZXJlbmNlIGNsb2NrIGNvbnRyb2wNCmluIHN1c3BlbmQg
YW5kIHJlc3VtZSBjYWxsYmFja3MgYmVjYXVzZSBzdWNoIGNvbnRyb2wgY2FuIGJlDQp3ZWxsLWhh
bmRsZWQgaW4gc2V0dXBfY2xvY2tzIGNhbGxiYWNrLi4NCg0KU2lnbmVkLW9mZi1ieTogU3Rhbmxl
eSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLmMgfCAxMiArKysrKysrLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNl
cnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vm
cy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCmluZGV4
IDdhYzgzOGNjMTVkMS4uZDc4ODk3YTE0OTA1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vm
cy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0K
QEAgLTE2Nyw3ICsxNjcsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfc2V0dXBfY2xvY2tzKHN0cnVj
dCB1ZnNfaGJhICpoYmEsIGJvb2wgb24sDQogDQogCXN3aXRjaCAoc3RhdHVzKSB7DQogCWNhc2Ug
UFJFX0NIQU5HRToNCi0JCWlmICghb24pIHsNCisJCWlmICghb24gJiYgIXVmc2hjZF9pc19saW5r
X2FjdGl2ZShoYmEpKSB7DQogCQkJdWZzX210a19zZXR1cF9yZWZfY2xrKGhiYSwgb24pOw0KIAkJ
CXJldCA9IHBoeV9wb3dlcl9vZmYoaG9zdC0+bXBoeSk7DQogCQl9DQpAQCAtNDM3LDEwICs0Mzcs
MTEgQEAgc3RhdGljIGludCB1ZnNfbXRrX3N1c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51
bSB1ZnNfcG1fb3AgcG1fb3ApDQogCQllcnIgPSB1ZnNfbXRrX2xpbmtfc2V0X2xwbShoYmEpOw0K
IAkJaWYgKGVycikNCiAJCQlyZXR1cm4gLUVBR0FJTjsNCi0JCXBoeV9wb3dlcl9vZmYoaG9zdC0+
bXBoeSk7DQotCQl1ZnNfbXRrX3NldHVwX3JlZl9jbGsoaGJhLCBmYWxzZSk7DQogCX0NCiANCisJ
aWYgKCF1ZnNoY2RfaXNfbGlua19hY3RpdmUoaGJhKSkNCisJCXBoeV9wb3dlcl9vZmYoaG9zdC0+
bXBoeSk7DQorDQogCXJldHVybiAwOw0KIH0NCiANCkBAIC00NDksOSArNDUwLDEwIEBAIHN0YXRp
YyBpbnQgdWZzX210a19yZXN1bWUoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3Ag
cG1fb3ApDQogCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQo
aGJhKTsNCiAJaW50IGVycjsNCiANCi0JaWYgKHVmc2hjZF9pc19saW5rX2hpYmVybjgoaGJhKSkg
ew0KLQkJdWZzX210a19zZXR1cF9yZWZfY2xrKGhiYSwgdHJ1ZSk7DQorCWlmICghdWZzaGNkX2lz
X2xpbmtfYWN0aXZlKGhiYSkpDQogCQlwaHlfcG93ZXJfb24oaG9zdC0+bXBoeSk7DQorDQorCWlm
ICh1ZnNoY2RfaXNfbGlua19oaWJlcm44KGhiYSkpIHsNCiAJCWVyciA9IHVmc19tdGtfbGlua19z
ZXRfaHBtKGhiYSk7DQogCQlpZiAoZXJyKQ0KIAkJCXJldHVybiBlcnI7DQotLSANCjIuMTguMA0K

