Return-Path: <SRS0=TzWF=Z5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AC2C2BBE2
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 12:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD3BA2253D
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 12:22:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Y8K7+Qrm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfLGMWV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Dec 2019 07:22:21 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:65245 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726263AbfLGMWS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Dec 2019 07:22:18 -0500
X-UUID: f91f0e1067b141f890e90dde86fa0d88-20191207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=WdphAW/gpXCO6Np9LJ/wLt5JaiJqP2sTAAv7fAToZng=;
        b=Y8K7+QrmVgzX5jprRcO+UT47F5AN5tPrAoMs+BIBGbdy8cBL3/r1EX1tM23AAq7lo5w4F+k4N6jE7gwQGRO2ljyZ1l9CFgJKShZdlCD83hVIzyvJC4UzNhLI1eRprvBpG6MMG0zgzcdEj/0TuU3EP3/wrwqoLMgYWHf943EGI+0=;
X-UUID: f91f0e1067b141f890e90dde86fa0d88-20191207
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 785131563; Sat, 07 Dec 2019 20:22:08 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 7 Dec 2019 20:21:44 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 7 Dec 2019 20:21:55 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/2] scsi: ufs: disable irq before disabling clocks
Date:   Sat, 7 Dec 2019 20:22:00 +0800
Message-ID: <1575721321-8071-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1575721321-8071-1-git-send-email-stanley.chu@mediatek.com>
References: <1575721321-8071-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 2AF96748D5321DF6AB154895A2E1C9E3DE4982FA9A1F03C07B3D57554AB449A02000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RHVyaW5nIHN1c3BlbmQgZmxvdywgaW50ZXJydXB0IHNoYWxsIGJlIGRpc2FibGVkIGJlZm9yZSBk
aXNhYmxpbmcNCmNsb2NrcyB0byBhdm9pZCBwb3RlbnRpYWwgc3lzdGVtIGhhbmcgZHVlIHRvIGFj
Y2Vzc2luZyBob3N0IHJlZ2lzdGVycw0KYWZ0ZXIgaG9zdCBjbG9ja3MgYXJlIGRpc2FibGVkLg0K
DQpGb3IgZXhhbXBsZSwgaWYgYW4gaW50ZXJydXB0IGNvbWVzIHdpdGggSVJRRl9JUlFQT0xMIGZs
YWcgY29uZmlndXJlZA0Kd2l0aCB0aGUgbWlzcm91dGVkIGludGVycnVwdCByZWNvdmVyeSBmZWF0
dXJlIGVuYWJsZWQsIHVmc2hjZCBJU1IgbWF5DQpiZSB0cmlnZ2VyZWQgZXZlbiBpZiBub3RoaW5n
IHNoYWxsIGJlIGRvbmUgZm9yIFVGUy4gSW4gdGhpcyBjYXNlLCBzeXN0ZW0NCmhhbmcgbWF5IGhh
cHBlbiBpZiBVRlMgaW50ZXJydXB0IHN0YXR1cyByZWdpc3RlciBpcyBhY2Nlc3NlZCB3aXRoIGhv
c3QNCmNsb2NrcyBkaXNhYmxlZC4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAx
MSArKysrKystLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDUgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggYjU5NjZmYWYzZTk4Li5mODBiZDRlODExY2IgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jDQpAQCAtNzkwOCw2ICs3OTA4LDExIEBAIHN0YXRpYyBpbnQgdWZzaGNkX3N1
c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQogCXJldCA9
IHVmc2hjZF92b3BzX3N1c3BlbmQoaGJhLCBwbV9vcCk7DQogCWlmIChyZXQpDQogCQlnb3RvIHNl
dF9saW5rX2FjdGl2ZTsNCisJLyoNCisJICogRGlzYWJsZSB0aGUgaG9zdCBpcnEgYXMgaG9zdCBj
b250cm9sbGVyIGFzIHRoZXJlIHdvbid0IGJlIGFueQ0KKwkgKiBob3N0IGNvbnRyb2xsZXIgdHJh
bnNhY3Rpb24gZXhwZWN0ZWQgdGlsbCByZXN1bWUuDQorCSAqLw0KKwl1ZnNoY2RfZGlzYWJsZV9p
cnEoaGJhKTsNCiANCiAJaWYgKCF1ZnNoY2RfaXNfbGlua19hY3RpdmUoaGJhKSkNCiAJCXVmc2hj
ZF9zZXR1cF9jbG9ja3MoaGJhLCBmYWxzZSk7DQpAQCAtNzkxNywxMSArNzkyMiw3IEBAIHN0YXRp
YyBpbnQgdWZzaGNkX3N1c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3Ag
cG1fb3ApDQogDQogCWhiYS0+Y2xrX2dhdGluZy5zdGF0ZSA9IENMS1NfT0ZGOw0KIAl0cmFjZV91
ZnNoY2RfY2xrX2dhdGluZyhkZXZfbmFtZShoYmEtPmRldiksIGhiYS0+Y2xrX2dhdGluZy5zdGF0
ZSk7DQotCS8qDQotCSAqIERpc2FibGUgdGhlIGhvc3QgaXJxIGFzIGhvc3QgY29udHJvbGxlciBh
cyB0aGVyZSB3b24ndCBiZSBhbnkNCi0JICogaG9zdCBjb250cm9sbGVyIHRyYW5zYWN0aW9uIGV4
cGVjdGVkIHRpbGwgcmVzdW1lLg0KLQkgKi8NCi0JdWZzaGNkX2Rpc2FibGVfaXJxKGhiYSk7DQor
DQogCS8qIFB1dCB0aGUgaG9zdCBjb250cm9sbGVyIGluIGxvdyBwb3dlciBtb2RlIGlmIHBvc3Np
YmxlICovDQogCXVmc2hjZF9oYmFfdnJlZ19zZXRfbHBtKGhiYSk7DQogCWdvdG8gb3V0Ow0KLS0g
DQoyLjE4LjANCg==

