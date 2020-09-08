Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559D9C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2193321973
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:45:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LQ89IYxK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgIHGpn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:45:43 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:59518 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727898AbgIHGpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:45:17 -0400
X-UUID: a965ba27aa94406e81943227f5c7e258-20200908
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Bjomsp98M5COQp7hU2i9F3nHqul1illrMLuipZ67MYo=;
        b=LQ89IYxKzSQVyLZ4NgSj+SZi5XEkCJPHTwrTZR27V5UoC2MDL8k4Vr06nvn8492Zele0qScmj4IcFU+lI2XlRvRQCXH/7IVwvSm7EAFtsjHpN6Vibdl1ed4pkr5MfFBpkkPw71tXg3ULA2C+oCa+56ZHRWYuwyL1OByJPLxe0hw=;
X-UUID: a965ba27aa94406e81943227f5c7e258-20200908
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 66601205; Tue, 08 Sep 2020 14:45:13 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 8 Sep 2020 14:45:09 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Sep 2020 14:45:10 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 3/4] scsi: ufs-mediatek: Fix flag of unipro low-power mode
Date:   Tue, 8 Sep 2020 14:45:06 +0800
Message-ID: <20200908064507.30774-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200908064507.30774-1-stanley.chu@mediatek.com>
References: <20200908064507.30774-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: A16BDD5A8366D066DA603CCA0A8A17BF6BFBBB21D4FA726657DD4C3FAA686DC52000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rm9yY2libHkgbGVhdmUgVW5pUHJvIGxvdy1wb3dlciBtb2RlIGlmIFVJQyBjb21tYW5kcyBpcyBm
YWlsZWQuDQpUaGlzIG1ha2VzIGhiYV9lbmFibGVfZGVsYXlfdXMgYXMgY29ycmVjdCAoZGVmYXVs
dCkgdmFsdWUgZm9yDQpyZS1lbmFibGluZyB0aGUgaG9zdC4NCg0KQXQgdGhlIHNhbWUgdGltZSwg
Y2hhbmdlIHR5cGUgb2YgcGFyYW1ldGVyICJscG0iIGluIGZ1bmN0aW9uDQp1ZnNfbXRrX3VuaXBy
b19zZXRfcG0oKSB0byAiYm9vbCIuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFu
bGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jIHwgMjAgKysrKysrKysrKysrKystLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTQgaW5zZXJ0
aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCA4
ODdjMDNlOGJjYzAuLmZlYmE3NGE3MjMwOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBA
IC00MTksNyArNDE5LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX3B3cl9jaGFuZ2Vfbm90aWZ5KHN0
cnVjdCB1ZnNfaGJhICpoYmEsDQogCXJldHVybiByZXQ7DQogfQ0KIA0KLXN0YXRpYyBpbnQgdWZz
X210a191bmlwcm9fc2V0X3BtKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBscG0pDQorc3RhdGlj
IGludCB1ZnNfbXRrX3VuaXByb19zZXRfcG0oc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBscG0p
DQogew0KIAlpbnQgcmV0Ow0KIAlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dl
dF92YXJpYW50KGhiYSk7DQpAQCAtNDI3LDggKzQyNywxNCBAQCBzdGF0aWMgaW50IHVmc19tdGtf
dW5pcHJvX3NldF9wbShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgbHBtKQ0KIAlyZXQgPSB1ZnNo
Y2RfZG1lX3NldChoYmEsDQogCQkJICAgICBVSUNfQVJHX01JQl9TRUwoVlNfVU5JUFJPUE9XRVJE
T1dOQ09OVFJPTCwgMCksDQogCQkJICAgICBscG0pOw0KLQlpZiAoIXJldCkNCisJaWYgKCFyZXQg
fHwgIWxwbSkgew0KKwkJLyoNCisJCSAqIEZvcmNpYmx5IHNldCBhcyBub24tTFBNIG1vZGUgaWYg
VUlDIGNvbW1hbmRzIGlzIGZhaWxlZA0KKwkJICogdG8gdXNlIGRlZmF1bHQgaGJhX2VuYWJsZV9k
ZWxheV91cyB2YWx1ZSBmb3IgcmUtZW5hYmxpbmcNCisJCSAqIHRoZSBob3N0Lg0KKwkJICovDQog
CQlob3N0LT51bmlwcm9fbHBtID0gbHBtOw0KKwl9DQogDQogCXJldHVybiByZXQ7DQogfQ0KQEAg
LTQzOCw3ICs0NDQsOSBAQCBzdGF0aWMgaW50IHVmc19tdGtfcHJlX2xpbmsoc3RydWN0IHVmc19o
YmEgKmhiYSkNCiAJaW50IHJldDsNCiAJdTMyIHRtcDsNCiANCi0JdWZzX210a191bmlwcm9fc2V0
X3BtKGhiYSwgMCk7DQorCXJldCA9IHVmc19tdGtfdW5pcHJvX3NldF9wbShoYmEsIGZhbHNlKTsN
CisJaWYgKHJldCkNCisJCXJldHVybiByZXQ7DQogDQogCS8qDQogCSAqIFNldHRpbmcgUEFfTG9j
YWxfVFhfTENDX0VuYWJsZSB0byAwIGJlZm9yZSBsaW5rIHN0YXJ0dXANCkBAIC01NDYsNyArNTU0
LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc2V0X2hwbShzdHJ1Y3QgdWZzX2hiYSAqaGJh
KQ0KIAlpZiAoZXJyKQ0KIAkJcmV0dXJuIGVycjsNCiANCi0JZXJyID0gdWZzX210a191bmlwcm9f
c2V0X3BtKGhiYSwgMCk7DQorCWVyciA9IHVmc19tdGtfdW5pcHJvX3NldF9wbShoYmEsIGZhbHNl
KTsNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7DQogDQpAQCAtNTY3LDEwICs1NzUsMTAgQEAg
c3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc2V0X2xwbShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsN
CiAJaW50IGVycjsNCiANCi0JZXJyID0gdWZzX210a191bmlwcm9fc2V0X3BtKGhiYSwgMSk7DQor
CWVyciA9IHVmc19tdGtfdW5pcHJvX3NldF9wbShoYmEsIHRydWUpOw0KIAlpZiAoZXJyKSB7DQog
CQkvKiBSZXN1bWUgVW5pUHJvIHN0YXRlIGZvciBmb2xsb3dpbmcgZXJyb3IgcmVjb3ZlcnkgKi8N
Ci0JCXVmc19tdGtfdW5pcHJvX3NldF9wbShoYmEsIDApOw0KKwkJdWZzX210a191bmlwcm9fc2V0
X3BtKGhiYSwgZmFsc2UpOw0KIAkJcmV0dXJuIGVycjsNCiAJfQ0KIA0KLS0gDQoyLjE4LjANCg==

