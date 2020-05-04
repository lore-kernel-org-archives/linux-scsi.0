Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5499AC47257
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 352A3206D9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:57:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HbrD1ihm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgEDO5E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:57:04 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:10830 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728689AbgEDO4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:56:38 -0400
X-UUID: 9fdaca3a1bae4332aa301141592e3c6b-20200504
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=i0FzsfpTNA3ISziIiPIG4aqyoIUmD6rlIQ3hBf2gOAA=;
        b=HbrD1ihmC/AQzYhm7vai7aGvqi7Z1uK9YCKuwwAGzxS8RBWw2ouePKZh4CIl1jYQCU6t7XvD6QKhltcSGIKjnP4bUs3TN9RAB68dDqEcqHki2qZ7NVbRGf0LnF75wASTuSQQxVih8w0PWm80ILyd1gFWVwtrrKQSi/oiobDtIaw=;
X-UUID: 9fdaca3a1bae4332aa301141592e3c6b-20200504
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1936321619; Mon, 04 May 2020 22:56:31 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 4 May 2020 22:56:26 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 4 May 2020 22:56:26 +0800
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
Subject: [PATCH v6 3/8] scsi: ufs: export ufs_fixup_device_setup() function
Date:   Mon, 4 May 2020 22:56:17 +0800
Message-ID: <20200504145622.13895-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200504145622.13895-1-stanley.chu@mediatek.com>
References: <20200504145622.13895-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 2B33CF8D6FE1F84FDDCC74114279B75D92A1088D4717E2F1AC1615FB2A26F5722000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RXhwb3J0IHVmc19maXh1cF9kZXZpY2Vfc2V0dXAoKSB0byBhbGxvdyB2ZW5kb3JzIHRvIHJlLXVz
ZSBpdCBmb3INCmZpeGluZyBkZXZpY2UgcXVyaWtzIG9uIHNwZWNpZmllZCBVRlMgaG9zdHMuDQoN
ClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpS
ZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQotLS0NCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgNyArKysrLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuaCB8IDQgKysrLQ0KIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA0IGRlbGV0
aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IGZjMTU0OWY4MjljYy4uYmE4MTg1NjI1MTA5IDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KQEAgLTY4MzUsMTIgKzY4MzUsMTIgQEAgc3RhdGljIHZvaWQgdWZzaGNk
X3diX3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4ICpkZXNjX2J1ZikNCiAJaGJhLT5jYXBz
ICY9IH5VRlNIQ0RfQ0FQX1dCX0VOOw0KIH0NCiANCi1zdGF0aWMgdm9pZCB1ZnNfZml4dXBfZGV2
aWNlX3NldHVwKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQordm9pZCB1ZnNoY2RfZml4dXBfZGV2aWNl
X3NldHVwKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHN0cnVjdCB1ZnNfZGV2X2ZpeCAqZml4dXBzKQ0K
IHsNCiAJc3RydWN0IHVmc19kZXZfZml4ICpmOw0KIAlzdHJ1Y3QgdWZzX2Rldl9pbmZvICpkZXZf
aW5mbyA9ICZoYmEtPmRldl9pbmZvOw0KIA0KLQlmb3IgKGYgPSB1ZnNfZml4dXBzOyBmLT5xdWly
azsgZisrKSB7DQorCWZvciAoZiA9IGZpeHVwczsgZi0+cXVpcms7IGYrKykgew0KIAkJaWYgKChm
LT53bWFudWZhY3R1cmVyaWQgPT0gZGV2X2luZm8tPndtYW51ZmFjdHVyZXJpZCB8fA0KIAkJICAg
ICBmLT53bWFudWZhY3R1cmVyaWQgPT0gVUZTX0FOWV9WRU5ET1IpICYmDQogCQkgICAgICgoZGV2
X2luZm8tPm1vZGVsICYmDQpAQCAtNjg0OSw2ICs2ODQ5LDcgQEAgc3RhdGljIHZvaWQgdWZzX2Zp
eHVwX2RldmljZV9zZXR1cChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAkJCWhiYS0+ZGV2X3F1aXJr
cyB8PSBmLT5xdWlyazsNCiAJfQ0KIH0NCitFWFBPUlRfU1lNQk9MX0dQTCh1ZnNoY2RfZml4dXBf
ZGV2aWNlX3NldHVwKTsNCiANCiBzdGF0aWMgaW50IHVmc19nZXRfZGV2aWNlX2Rlc2Moc3RydWN0
IHVmc19oYmEgKmhiYSkNCiB7DQpAQCAtNjg5NSw3ICs2ODk2LDcgQEAgc3RhdGljIGludCB1ZnNf
Z2V0X2RldmljZV9kZXNjKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCQlnb3RvIG91dDsNCiAJfQ0K
IA0KLQl1ZnNfZml4dXBfZGV2aWNlX3NldHVwKGhiYSk7DQorCXVmc2hjZF9maXh1cF9kZXZpY2Vf
c2V0dXAoaGJhLCB1ZnNfZml4dXBzKTsNCiAJdWZzaGNkX3ZvcHNfZml4dXBfZGV2X3F1aXJrcyho
YmEpOw0KIA0KIAkvKg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQppbmRleCA1ZmEwM2UwZjNiZDEuLmYzNDYwMTEyMTg4
MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCisrKyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmgNCkBAIC02OSw2ICs2OSw3IEBADQogI2luY2x1ZGUgPHNjc2kvc2Nz
aV9laC5oPg0KIA0KICNpbmNsdWRlICJ1ZnMuaCINCisjaW5jbHVkZSAidWZzX3F1aXJrcy5oIg0K
ICNpbmNsdWRlICJ1ZnNoY2kuaCINCiANCiAjZGVmaW5lIFVGU0hDRCAidWZzaGNkIg0KQEAgLTk1
MSw3ICs5NTIsOCBAQCBpbnQgdWZzaGNkX3F1ZXJ5X2ZsYWcoc3RydWN0IHVmc19oYmEgKmhiYSwg
ZW51bSBxdWVyeV9vcGNvZGUgb3Bjb2RlLA0KIA0KIHZvaWQgdWZzaGNkX2F1dG9faGliZXJuOF9l
bmFibGUoc3RydWN0IHVmc19oYmEgKmhiYSk7DQogdm9pZCB1ZnNoY2RfYXV0b19oaWJlcm44X3Vw
ZGF0ZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgYWhpdCk7DQotDQordm9pZCB1ZnNoY2RfZml4
dXBfZGV2aWNlX3NldHVwKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQorCQkJICAgICAgIHN0cnVjdCB1
ZnNfZGV2X2ZpeCAqZml4dXBzKTsNCiAjZGVmaW5lIFNEX0FTQ0lJX1NURCB0cnVlDQogI2RlZmlu
ZSBTRF9SQVcgZmFsc2UNCiBpbnQgdWZzaGNkX3JlYWRfc3RyaW5nX2Rlc2Moc3RydWN0IHVmc19o
YmEgKmhiYSwgdTggZGVzY19pbmRleCwNCi0tIA0KMi4xOC4wDQo=

