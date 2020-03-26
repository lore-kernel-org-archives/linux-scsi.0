Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D7BC2D0E8
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 15:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DD9F2076A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 15:08:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="smdJJXAy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgCZPH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 11:07:58 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:51191 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726401AbgCZPH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 11:07:57 -0400
X-UUID: 3f24429633f84f74b4de37103c927553-20200326
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=yQugDcuRyb957RsLnPG3IKLpweXB8rZN0SNQlnD0C1s=;
        b=smdJJXAy/w6mJDa9/kUHZJKAtzyfbBB4WcPniaADCleOLrHoLXqif3xBJU5NNCnqepxM0Sqya/uvSMS15eD1sSIkBI4IFRnMZSCJiQYJq7mdyPcAjN4HHZLIDi3i+tUBmTzRLYJyFMWpX3nKdbMe0Ujm7OM6yElTUKHH+NNClBE=;
X-UUID: 3f24429633f84f74b4de37103c927553-20200326
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 100789054; Thu, 26 Mar 2020 23:07:51 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 26 Mar 2020 23:07:48 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 26 Mar 2020 23:07:48 +0800
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
Subject: [PATCH v2 2/2] scsi: ufs-mediatek: add error recovery for suspend and resume
Date:   Thu, 26 Mar 2020 23:07:47 +0800
Message-ID: <20200326150747.11426-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200326150747.11426-1-stanley.chu@mediatek.com>
References: <20200326150747.11426-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T25jZSBmYWlsIGhhcHBlbnMgZHVyaW5nIHN1c3BlbmQgYW5kIHJlc3VtZSBmbG93IGlmIHRoZSBk
ZXNpcmVkIGxvdw0KcG93ZXIgbGluayBzdGF0ZSBpcyBIOCwgbGluayByZWNvdmVyeSBpcyByZXF1
aXJlZCBmb3IgTWVkaWFUZWsgVUZTDQpjb250cm9sbGVyLg0KDQpGb3IgcmVzdW1lIGZsb3csIHNp
bmNlIHBvd2VyIGFuZCBjbG9ja3MgYXJlIGFscmVhZHkgZW5hYmxlZCBiZWZvcmUNCmludm9raW5n
IHZlbmRvcidzIHJlc3VtZSBjYWxsYmFjaywgc2ltcGx5IHVzaW5nIHVmc2hjZF9saW5rX3JlY292
ZXJ5KCkNCmluc2lkZSBjYWxsYmFjayBpcyBmaW5lLg0KDQpGb3Igc3VzcGVuZCBmbG93LCB0aGUg
ZGV2aWNlIHBvd2VyIGVudGVycyBsb3cgcG93ZXIgbW9kZSBvciBpcyBkaXNhYmxlZA0KYmVmb3Jl
IHN1c3BlbmQgY2FsbGJhY2ssIHRodXMgdWZzaGNkX2xpbmtfcmVjb3ZlcnkoKSBjYW4gbm90IGJl
IGRpcmVjdGx5DQp1c2VkIGluIGNhbGxiYWNrLiBUbyBsZXZlcmFnZSBob3N0IHJlc2V0IGZsb3cg
ZHVyaW5nIHVmc2hjZF9zdXNwZW5kKCksDQpzZXQgbGluayBhcyBvZmYgc3RhdGUgZW5mb3JjZWRs
eSB0byBsZXQgdWZzaGNkX2hvc3RfcmVzZXRfYW5kX3Jlc3RvcmUoKQ0KYmUgZXhlY3V0ZWQgYnkg
dWZzaGNkX3N1c3BlbmQoKS4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXku
Y2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMg
fCAxMyArKysrKysrKysrKy0tDQogMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggM2IwZTU3NWQ3NDYw
Li4yMzg0ZTM1YWM4NWYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRl
ay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAtNDg2LDggKzQ4
NiwxNSBAQCBzdGF0aWMgaW50IHVmc19tdGtfc3VzcGVuZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBl
bnVtIHVmc19wbV9vcCBwbV9vcCkNCiANCiAJaWYgKHVmc2hjZF9pc19saW5rX2hpYmVybjgoaGJh
KSkgew0KIAkJZXJyID0gdWZzX210a19saW5rX3NldF9scG0oaGJhKTsNCi0JCWlmIChlcnIpDQor
CQlpZiAoZXJyKSB7DQorCQkJLyoNCisJCQkgKiBTZXQgbGluayBhcyBvZmYgc3RhdGUgZW5mb3Jj
ZWRseSB0byB0cmlnZ2VyDQorCQkJICogdWZzaGNkX2hvc3RfcmVzZXRfYW5kX3Jlc3RvcmUoKSBp
biB1ZnNoY2Rfc3VzcGVuZCgpDQorCQkJICogZm9yIGNvbXBsZXRlZCBob3N0IHJlc2V0Lg0KKwkJ
CSAqLw0KKwkJCXVmc2hjZF9zZXRfbGlua19vZmYoaGJhKTsNCiAJCQlyZXR1cm4gLUVBR0FJTjsN
CisJCX0NCiAJfQ0KIA0KIAlpZiAoIXVmc2hjZF9pc19saW5rX2FjdGl2ZShoYmEpKQ0KQEAgLTUw
Niw4ICs1MTMsMTAgQEAgc3RhdGljIGludCB1ZnNfbXRrX3Jlc3VtZShzdHJ1Y3QgdWZzX2hiYSAq
aGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCiANCiAJaWYgKHVmc2hjZF9pc19saW5rX2hpYmVy
bjgoaGJhKSkgew0KIAkJZXJyID0gdWZzX210a19saW5rX3NldF9ocG0oaGJhKTsNCi0JCWlmIChl
cnIpDQorCQlpZiAoZXJyKSB7DQorCQkJZXJyID0gdWZzaGNkX2xpbmtfcmVjb3ZlcnkoaGJhKTsN
CiAJCQlyZXR1cm4gZXJyOw0KKwkJfQ0KIAl9DQogDQogCXJldHVybiAwOw0KLS0gDQoyLjE4LjAN
Cg==

