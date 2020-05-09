Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72EBC47247
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 09:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96B1024955
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 09:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XWDBzPGF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgEIJh3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 May 2020 05:37:29 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:6471 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728083AbgEIJh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2020 05:37:26 -0400
X-UUID: 4662f4d07bb64bd5beef6bcd7e7fbbde-20200509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=QgdzxC6jifc5v5xz33NQoqMjvZUvNoNRAMd7vcGrEFo=;
        b=XWDBzPGF/cKZ2yU9Y9utKXuI7W3qTO3YXhqdsFQXEvKFl94RkqU5wzfcsKeQAhrm3RhJ9fck7DaoKrH/Kr2y4R3TYgYSH93IQlqhhZEIyWy2RPObaI4XwPBb99xcX1WOtgSwtqbhfRtVVezrgXTI+Tj1hTsy3G5bokqB5HCAkSY=;
X-UUID: 4662f4d07bb64bd5beef6bcd7e7fbbde-20200509
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1460833602; Sat, 09 May 2020 17:37:19 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 9 May 2020 17:37:15 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 9 May 2020 17:37:16 +0800
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
Subject: [PATCH v2 1/4] scsi: ufs: introduce ufs_hba_variant_params to collect customizable parameters
Date:   Sat, 9 May 2020 17:37:13 +0800
Message-ID: <20200509093716.21010-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200509093716.21010-1-stanley.chu@mediatek.com>
References: <20200509093716.21010-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 3B04A6CD840250C5C51DB8CDC63535667407E28B0E3B84D1DDE349A5BF36E3642000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhlcmUgYXJlIG1vcmUgYW5kIG1vcmUgY3VzdG9taXphYmxlIHBhcmFtZXRlcnMgc2hvd2VkIHVw
DQppbiBVRlMgZHJpdmVyLiBMZXQncyBjb2xsZWN0IHRoZW0gaW50byBhIHVuaWZpZWQgcGxhY2Ug
dG8gbWFrZQ0KdGhlIGRyaXZlciBtb3JlIGNsZWFuLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5
IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYyB8IDM4ICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8ICA4ICsrKysrKystDQogMiBmaWxlcyBjaGFuZ2VkLCAy
MiBpbnNlcnRpb25zKCspLCAyNCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCA0MjYw
NzNhNTE4ZWYuLmNkYWNiZTYzNzhhMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC0xMzUzLDIzICsxMzUz
LDYgQEAgc3RhdGljIGludCB1ZnNoY2RfZGV2ZnJlcV9nZXRfZGV2X3N0YXR1cyhzdHJ1Y3QgZGV2
aWNlICpkZXYsDQogCXJldHVybiAwOw0KIH0NCiANCi1zdGF0aWMgc3RydWN0IGRldmZyZXFfZGV2
X3Byb2ZpbGUgdWZzX2RldmZyZXFfcHJvZmlsZSA9IHsNCi0JLnBvbGxpbmdfbXMJPSAxMDAsDQot
CS50YXJnZXQJCT0gdWZzaGNkX2RldmZyZXFfdGFyZ2V0LA0KLQkuZ2V0X2Rldl9zdGF0dXMJPSB1
ZnNoY2RfZGV2ZnJlcV9nZXRfZGV2X3N0YXR1cywNCi19Ow0KLQ0KLSNpZiBJU19FTkFCTEVEKENP
TkZJR19ERVZGUkVRX0dPVl9TSU1QTEVfT05ERU1BTkQpDQotc3RhdGljIHN0cnVjdCBkZXZmcmVx
X3NpbXBsZV9vbmRlbWFuZF9kYXRhIHVmc19vbmRlbWFuZF9kYXRhID0gew0KLQkudXB0aHJlc2hv
bGQgPSA3MCwNCi0JLmRvd25kaWZmZXJlbnRpYWwgPSA1LA0KLX07DQotDQotc3RhdGljIHZvaWQg
Kmdvdl9kYXRhID0gJnVmc19vbmRlbWFuZF9kYXRhOw0KLSNlbHNlDQotc3RhdGljIHZvaWQgKmdv
dl9kYXRhOyAvKiBOVUxMICovDQotI2VuZGlmDQotDQogc3RhdGljIGludCB1ZnNoY2RfZGV2ZnJl
cV9pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAlzdHJ1Y3QgbGlzdF9oZWFkICpjbGtf
bGlzdCA9ICZoYmEtPmNsa19saXN0X2hlYWQ7DQpAQCAtMTM4NSwxMiArMTM2OCwxMiBAQCBzdGF0
aWMgaW50IHVmc2hjZF9kZXZmcmVxX2luaXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJZGV2X3Bt
X29wcF9hZGQoaGJhLT5kZXYsIGNsa2ktPm1pbl9mcmVxLCAwKTsNCiAJZGV2X3BtX29wcF9hZGQo
aGJhLT5kZXYsIGNsa2ktPm1heF9mcmVxLCAwKTsNCiANCi0JdWZzaGNkX3ZvcHNfY29uZmlnX3Nj
YWxpbmdfcGFyYW0oaGJhLCAmdWZzX2RldmZyZXFfcHJvZmlsZSwNCi0JCQkJCSBnb3ZfZGF0YSk7
DQorCXVmc2hjZF92b3BzX2NvbmZpZ19zY2FsaW5nX3BhcmFtKGhiYSwgJmhiYS0+dnBzLT5kZXZm
cmVxX3Byb2ZpbGUsDQorCQkJCQkgJmhiYS0+dnBzLT5vbmRlbWFuZF9kYXRhKTsNCiAJZGV2ZnJl
cSA9IGRldmZyZXFfYWRkX2RldmljZShoYmEtPmRldiwNCi0JCQkmdWZzX2RldmZyZXFfcHJvZmls
ZSwNCisJCQkmaGJhLT52cHMtPmRldmZyZXFfcHJvZmlsZSwNCiAJCQlERVZGUkVRX0dPVl9TSU1Q
TEVfT05ERU1BTkQsDQotCQkJZ292X2RhdGEpOw0KKwkJCSZoYmEtPnZwcy0+b25kZW1hbmRfZGF0
YSk7DQogCWlmIChJU19FUlIoZGV2ZnJlcSkpIHsNCiAJCXJldCA9IFBUUl9FUlIoZGV2ZnJlcSk7
DQogCQlkZXZfZXJyKGhiYS0+ZGV2LCAiVW5hYmxlIHRvIHJlZ2lzdGVyIHdpdGggZGV2ZnJlcSAl
ZFxuIiwgcmV0KTsNCkBAIC00MzE0LDcgKzQyOTcsNyBAQCBpbnQgdWZzaGNkX2hiYV9lbmFibGUo
c3RydWN0IHVmc19oYmEgKmhiYSkNCiAJICogaW5zdHJ1Y3Rpb24gbWlnaHQgYmUgcmVhZCBiYWNr
Lg0KIAkgKiBUaGlzIGRlbGF5IGNhbiBiZSBjaGFuZ2VkIGJhc2VkIG9uIHRoZSBjb250cm9sbGVy
Lg0KIAkgKi8NCi0JdWZzaGNkX2RlbGF5X3VzKGhiYS0+aGJhX2VuYWJsZV9kZWxheV91cywgMTAw
KTsNCisJdWZzaGNkX2RlbGF5X3VzKGhiYS0+dnBzLT5oYmFfZW5hYmxlX2RlbGF5X3VzLCAxMDAp
Ow0KIA0KIAkvKiB3YWl0IGZvciB0aGUgaG9zdCBjb250cm9sbGVyIHRvIGNvbXBsZXRlIGluaXRp
YWxpemF0aW9uICovDQogCXJldHJ5ID0gNTA7DQpAQCAtNzQ3Nyw2ICs3NDYwLDE1IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgYXR0cmlidXRlX2dyb3VwICp1ZnNoY2RfZHJpdmVyX2dyb3Vwc1tdID0g
ew0KIAlOVUxMLA0KIH07DQogDQorc3RhdGljIHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfcGFyYW1z
IHVmc19oYmFfdnBzID0gew0KKwkuaGJhX2VuYWJsZV9kZWxheV91cwkJPSAxMDAwLA0KKwkuZGV2
ZnJlcV9wcm9maWxlLnBvbGxpbmdfbXMJPSAxMDAsDQorCS5kZXZmcmVxX3Byb2ZpbGUudGFyZ2V0
CQk9IHVmc2hjZF9kZXZmcmVxX3RhcmdldCwNCisJLmRldmZyZXFfcHJvZmlsZS5nZXRfZGV2X3N0
YXR1cwk9IHVmc2hjZF9kZXZmcmVxX2dldF9kZXZfc3RhdHVzLA0KKwkub25kZW1hbmRfZGF0YS51
cHRocmVzaG9sZAk9IDcwLA0KKwkub25kZW1hbmRfZGF0YS5kb3duZGlmZmVyZW50aWFsCT0gNSwN
Cit9Ow0KKw0KIHN0YXRpYyBzdHJ1Y3Qgc2NzaV9ob3N0X3RlbXBsYXRlIHVmc2hjZF9kcml2ZXJf
dGVtcGxhdGUgPSB7DQogCS5tb2R1bGUJCQk9IFRISVNfTU9EVUxFLA0KIAkubmFtZQkJCT0gVUZT
SENELA0KQEAgLTg3MjQsNyArODcxNiw3IEBAIGludCB1ZnNoY2RfaW5pdChzdHJ1Y3QgdWZzX2hi
YSAqaGJhLCB2b2lkIF9faW9tZW0gKm1taW9fYmFzZSwgdW5zaWduZWQgaW50IGlycSkNCiANCiAJ
aGJhLT5tbWlvX2Jhc2UgPSBtbWlvX2Jhc2U7DQogCWhiYS0+aXJxID0gaXJxOw0KLQloYmEtPmhi
YV9lbmFibGVfZGVsYXlfdXMgPSAxMDAwOw0KKwloYmEtPnZwcyA9ICZ1ZnNfaGJhX3ZwczsNCiAN
CiAJZXJyID0gdWZzaGNkX2hiYV9pbml0KGhiYSk7DQogCWlmIChlcnIpDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCmlu
ZGV4IDIzYTQzNGMwM2MyYS4uZjdiZGY1MmJhOGIwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KQEAgLTU2Niw2
ICs1NjYsMTIgQEAgZW51bSB1ZnNoY2RfY2FwcyB7DQogCVVGU0hDRF9DQVBfV0JfRU4JCQkJPSAx
IDw8IDcsDQogfTsNCiANCitzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X3BhcmFtcyB7DQorCXN0cnVj
dCBkZXZmcmVxX2Rldl9wcm9maWxlIGRldmZyZXFfcHJvZmlsZTsNCisJc3RydWN0IGRldmZyZXFf
c2ltcGxlX29uZGVtYW5kX2RhdGEgb25kZW1hbmRfZGF0YTsNCisJdTE2IGhiYV9lbmFibGVfZGVs
YXlfdXM7DQorfTsNCisNCiAvKioNCiAgKiBzdHJ1Y3QgdWZzX2hiYSAtIHBlciBhZGFwdGVyIHBy
aXZhdGUgc3RydWN0dXJlDQogICogQG1taW9fYmFzZTogVUZTSENJIGJhc2UgcmVnaXN0ZXIgYWRk
cmVzcw0KQEAgLTY2Myw2ICs2NjksNyBAQCBzdHJ1Y3QgdWZzX2hiYSB7DQogCWludCBudXRtcnM7
DQogCXUzMiB1ZnNfdmVyc2lvbjsNCiAJY29uc3Qgc3RydWN0IHVmc19oYmFfdmFyaWFudF9vcHMg
KnZvcHM7DQorCXN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfcGFyYW1zICp2cHM7DQogCXZvaWQgKnBy
aXY7DQogCXVuc2lnbmVkIGludCBpcnE7DQogCWJvb2wgaXNfaXJxX2VuYWJsZWQ7DQpAQCAtNjg0
LDcgKzY5MSw2IEBAIHN0cnVjdCB1ZnNfaGJhIHsNCiAJdTMyIGVoX2ZsYWdzOw0KIAl1MzIgaW50
cl9tYXNrOw0KIAl1MTYgZWVfY3RybF9tYXNrOw0KLQl1MTYgaGJhX2VuYWJsZV9kZWxheV91czsN
CiAJYm9vbCBpc19wb3dlcmVkOw0KIA0KIAkvKiBXb3JrIFF1ZXVlcyAqLw0KLS0gDQoyLjE4LjAN
Cg==

