Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UPPERCASE_50_75,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400C6C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 01:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 201D320878
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 01:26:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Wvc8xVa7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgFLB0m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 21:26:42 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:37219 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726321AbgFLB0e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 21:26:34 -0400
X-UUID: bd827e69ddfd41cf8895fdbe7b10d691-20200612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=TyNotqRzhDuLovK50I1nRQ2Gr24GvWjdCq+YG5zKk4w=;
        b=Wvc8xVa7xhd0QL4FONMSFmBabbAcIpl5uWTuS/wAtvXb6MyglwlkGs5jFTKbIB1HuCGLMEEJDiIHKTRJ7VkoNSiqIUyecZ41Zr4aZZjFRscy/9mq/U7uLb4MLImhGADGMyB2FgbokhDVNDGz2KK0Ez/PkNbmZ9RMQDmiimLs1KQ=;
X-UUID: bd827e69ddfd41cf8895fdbe7b10d691-20200612
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1242253306; Fri, 12 Jun 2020 09:26:29 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 12 Jun 2020 09:26:22 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Jun 2020 09:26:22 +0800
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
Subject: [PATCH v2 2/2] scsi: ufs: Cleanup device vendor name and device quirk table
Date:   Fri, 12 Jun 2020 09:26:25 +0800
Message-ID: <20200612012625.6615-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200612012625.6615-1-stanley.chu@mediatek.com>
References: <20200612012625.6615-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q2xlYW51cCBiZWxvdyBpdGVtcywNCi0gU29ydCB2ZW5kb3IgbmFtZSBpbiBhbHBoYWJldGljYWwg
b3JkZXINCi0gU3F1YXNoIGRldmljZSBxdWlya3MgYXMgY29tcGFjdCBhcyBwb3NzaWJsZSBpbiBk
ZXZpY2UgcXVpcmsgdGFibGUNCiAgdG8gZW5oYW5jZSBwZXJmb3JtYW5jZSBvZiB0aGUgbG9va3Vw
DQotIFNvcnQgZGV2aWNlIHF1aXJrcyBpbiBhbHBoYWJldGljYWwgb3JkZXINCg0KU2lnbmVkLW9m
Zi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZl
cnMvc2NzaS91ZnMvdWZzX3F1aXJrcy5oIHwgIDIgKy0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jICAgICB8IDE1ICsrKysrKy0tLS0tLS0tLQ0KIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRp
b25zKCspLCAxMCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzX3F1aXJrcy5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmgNCmluZGV4IGU4MGQ1
ZjI2YTQ0Mi4uMmEwMDQxNDkzZTMwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNf
cXVpcmtzLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzX3F1aXJrcy5oDQpAQCAtMTMsOSAr
MTMsOSBAQA0KICNkZWZpbmUgVUZTX0FOWV9NT0RFTCAgIkFOWV9NT0RFTCINCiANCiAjZGVmaW5l
IFVGU19WRU5ET1JfTUlDUk9OICAgICAgMHgxMkMNCi0jZGVmaW5lIFVGU19WRU5ET1JfVE9TSElC
QSAgICAgMHgxOTgNCiAjZGVmaW5lIFVGU19WRU5ET1JfU0FNU1VORyAgICAgMHgxQ0UNCiAjZGVm
aW5lIFVGU19WRU5ET1JfU0tIWU5JWCAgICAgMHgxQUQNCisjZGVmaW5lIFVGU19WRU5ET1JfVE9T
SElCQSAgICAgMHgxOTgNCiAjZGVmaW5lIFVGU19WRU5ET1JfV0RDICAgICAgICAgMHgxNDUNCiAN
CiAvKioNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggMWRhMWRmNmVhNDdlLi5jMTk3YTMzMTVkMjEgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jDQpAQCAtMjE5LDIyICsyMTksMTkgQEAgc3RhdGljIHN0cnVjdCB1ZnNfZGV2X2Zp
eCB1ZnNfZml4dXBzW10gPSB7DQogCVVGU19GSVgoVUZTX1ZFTkRPUl9NSUNST04sIFVGU19BTllf
TU9ERUwsDQogCQlVRlNfREVWSUNFX1FVSVJLX0RFTEFZX0JFRk9SRV9MUE0pLA0KIAlVRlNfRklY
KFVGU19WRU5ET1JfU0FNU1VORywgVUZTX0FOWV9NT0RFTCwNCi0JCVVGU19ERVZJQ0VfUVVJUktf
REVMQVlfQkVGT1JFX0xQTSksDQotCVVGU19GSVgoVUZTX1ZFTkRPUl9TQU1TVU5HLCBVRlNfQU5Z
X01PREVMLA0KKwkJVUZTX0RFVklDRV9RVUlSS19ERUxBWV9CRUZPUkVfTFBNIHwNCisJCVVGU19E
RVZJQ0VfUVVJUktfSE9TVF9QQV9UQUNUSVZBVEUgfA0KIAkJVUZTX0RFVklDRV9RVUlSS19SRUNP
VkVSWV9GUk9NX0RMX05BQ19FUlJPUlMpLA0KLQlVRlNfRklYKFVGU19WRU5ET1JfU0FNU1VORywg
VUZTX0FOWV9NT0RFTCwNCi0JCVVGU19ERVZJQ0VfUVVJUktfSE9TVF9QQV9UQUNUSVZBVEUpLA0K
KwlVRlNfRklYKFVGU19WRU5ET1JfU0tIWU5JWCwgVUZTX0FOWV9NT0RFTCwNCisJCVVGU19ERVZJ
Q0VfUVVJUktfSE9TVF9QQV9TQVZFQ09ORklHVElNRSksDQorCVVGU19GSVgoVUZTX1ZFTkRPUl9T
S0hZTklYLCAiaEI4YUwxIiAvKkgyOFU2MjMwMUFNUiovLA0KKwkJVUZTX0RFVklDRV9RVUlSS19I
T1NUX1ZTX0RFQlVHU0FWRUNPTkZJR1RJTUUpLA0KIAlVRlNfRklYKFVGU19WRU5ET1JfVE9TSElC
QSwgVUZTX0FOWV9NT0RFTCwNCiAJCVVGU19ERVZJQ0VfUVVJUktfREVMQVlfQkVGT1JFX0xQTSks
DQogCVVGU19GSVgoVUZTX1ZFTkRPUl9UT1NISUJBLCAiVEhHTEYyRzlDOEtCQURHIiwNCiAJCVVG
U19ERVZJQ0VfUVVJUktfUEFfVEFDVElWQVRFKSwNCiAJVUZTX0ZJWChVRlNfVkVORE9SX1RPU0hJ
QkEsICJUSEdMRjJHOUQ4S0JBREciLA0KIAkJVUZTX0RFVklDRV9RVUlSS19QQV9UQUNUSVZBVEUp
LA0KLQlVRlNfRklYKFVGU19WRU5ET1JfU0tIWU5JWCwgVUZTX0FOWV9NT0RFTCwNCi0JCVVGU19E
RVZJQ0VfUVVJUktfSE9TVF9QQV9TQVZFQ09ORklHVElNRSksDQotCVVGU19GSVgoVUZTX1ZFTkRP
Ul9TS0hZTklYLCAiaEI4YUwxIiAvKkgyOFU2MjMwMUFNUiovLA0KLQkJVUZTX0RFVklDRV9RVUlS
S19IT1NUX1ZTX0RFQlVHU0FWRUNPTkZJR1RJTUUpLA0KLQ0KIAlFTkRfRklYDQogfTsNCiANCi0t
IA0KMi4xOC4wDQo=

