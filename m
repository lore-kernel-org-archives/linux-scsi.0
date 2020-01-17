Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11816C33C9E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4A6A2087E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WhxMeTKl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbgAQDvQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 22:51:16 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:18298 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729539AbgAQDvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 22:51:15 -0500
X-UUID: 848e23ad4c114462a3eadd3992b043d0-20200117
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=HDwpeK1tuxH/QoY+CMgh2LJu/tFB3YGoU1KNbePi49w=;
        b=WhxMeTKlj8Q/nyEL+rKgTO9ELrRoSW6HvW+x0EvbbTgqTKizoYTIfVrDptYYALLlEEbYQJJ9FiKj9YnvS86+531R6mpQwYwYUODB43hleQH52u90uZhzZFrwonFzpQK9uFIepoIsVHcGMvnMlw9W5l1XEPuYDYEwZO+k09O0zaE=;
X-UUID: 848e23ad4c114462a3eadd3992b043d0-20200117
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 969960592; Fri, 17 Jan 2020 11:51:10 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 17 Jan 2020 11:50:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 17 Jan 2020 11:51:09 +0800
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
Subject: [PATCH v1 2/3] scsi: ufs: export some functions for vendor usage
Date:   Fri, 17 Jan 2020 11:51:07 +0800
Message-ID: <20200117035108.19699-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200117035108.19699-1-stanley.chu@mediatek.com>
References: <20200117035108.19699-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RXhwb3J0IGJlbG93IGZ1bmN0aW9ucyBmb3IgdmVuZG9yIHVzYWdlLA0KDQppbnQgdWZzaGNkX2hi
YV9lbmFibGUoc3RydWN0IHVmc19oYmEgKmhiYSk7DQppbnQgdWZzaGNkX21ha2VfaGJhX29wZXJh
dGlvbmFsKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KaW50IHVmc2hjZF91aWNfaGliZXJuOF9leGl0
KHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3Rh
bmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8
IDExICsrKysrKystLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8ICAzICsrKw0KIDIg
ZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jDQppbmRleCBiZWEwMzZhYjE4OWEuLjExNjhiYWYzNThlYSAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBA
IC0yNTAsNyArMjUwLDYgQEAgc3RhdGljIGludCB1ZnNoY2RfcHJvYmVfaGJhKHN0cnVjdCB1ZnNf
aGJhICpoYmEpOw0KIHN0YXRpYyBpbnQgX191ZnNoY2Rfc2V0dXBfY2xvY2tzKHN0cnVjdCB1ZnNf
aGJhICpoYmEsIGJvb2wgb24sDQogCQkJCSBib29sIHNraXBfcmVmX2Nsayk7DQogc3RhdGljIGlu
dCB1ZnNoY2Rfc2V0dXBfY2xvY2tzKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgb24pOw0KLXN0
YXRpYyBpbnQgdWZzaGNkX3VpY19oaWJlcm44X2V4aXQoc3RydWN0IHVmc19oYmEgKmhiYSk7DQog
c3RhdGljIGludCB1ZnNoY2RfdWljX2hpYmVybjhfZW50ZXIoc3RydWN0IHVmc19oYmEgKmhiYSk7
DQogc3RhdGljIGlubGluZSB2b2lkIHVmc2hjZF9hZGRfZGVsYXlfYmVmb3JlX2RtZV9jbWQoc3Ry
dWN0IHVmc19oYmEgKmhiYSk7DQogc3RhdGljIGludCB1ZnNoY2RfaG9zdF9yZXNldF9hbmRfcmVz
dG9yZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCkBAIC0zODY1LDcgKzM4NjQsNyBAQCBzdGF0aWMg
aW50IHVmc2hjZF91aWNfaGliZXJuOF9lbnRlcihzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlyZXR1
cm4gcmV0Ow0KIH0NCiANCi1zdGF0aWMgaW50IHVmc2hjZF91aWNfaGliZXJuOF9leGl0KHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQoraW50IHVmc2hjZF91aWNfaGliZXJuOF9leGl0KHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQogew0KIAlzdHJ1Y3QgdWljX2NvbW1hbmQgdWljX2NtZCA9IHswfTsNCiAJaW50
IHJldDsNCkBAIC0zODkxLDYgKzM4OTAsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF91aWNfaGliZXJu
OF9leGl0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogDQogCXJldHVybiByZXQ7DQogfQ0KK0VYUE9S
VF9TWU1CT0xfR1BMKHVmc2hjZF91aWNfaGliZXJuOF9leGl0KTsNCiANCiB2b2lkIHVmc2hjZF9h
dXRvX2hpYmVybjhfdXBkYXRlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBhaGl0KQ0KIHsNCkBA
IC00MTYyLDcgKzQxNjIsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9jb21wbGV0ZV9kZXZfaW5pdChz
dHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KICAqDQogICogUmV0dXJucyAwIG9uIHN1Y2Nlc3MsIG5vbi16
ZXJvIHZhbHVlIG9uIGZhaWx1cmUNCiAgKi8NCi1zdGF0aWMgaW50IHVmc2hjZF9tYWtlX2hiYV9v
cGVyYXRpb25hbChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KK2ludCB1ZnNoY2RfbWFrZV9oYmFfb3Bl
cmF0aW9uYWwoc3RydWN0IHVmc19oYmEgKmhiYSkNCiB7DQogCWludCBlcnIgPSAwOw0KIAl1MzIg
cmVnOw0KQEAgLTQyMDgsNiArNDIwOCw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX21ha2VfaGJhX29w
ZXJhdGlvbmFsKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogb3V0Og0KIAlyZXR1cm4gZXJyOw0KIH0N
CitFWFBPUlRfU1lNQk9MX0dQTCh1ZnNoY2RfbWFrZV9oYmFfb3BlcmF0aW9uYWwpOw0KIA0KIC8q
Kg0KICAqIHVmc2hjZF9oYmFfc3RvcCAtIFNlbmQgY29udHJvbGxlciB0byByZXNldCBzdGF0ZQ0K
QEAgLTQyODUsNyArNDI4Niw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2hiYV9leGVjdXRlX2hjZShz
dHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlyZXR1cm4gMDsNCiB9DQogDQotc3RhdGljIGludCB1ZnNo
Y2RfaGJhX2VuYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KK2ludCB1ZnNoY2RfaGJhX2VuYWJs
ZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJaW50IHJldDsNCiANCkBAIC00MzEwLDYgKzQz
MTEsOCBAQCBzdGF0aWMgaW50IHVmc2hjZF9oYmFfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEp
DQogDQogCXJldHVybiByZXQ7DQogfQ0KK0VYUE9SVF9TWU1CT0xfR1BMKHVmc2hjZF9oYmFfZW5h
YmxlKTsNCisNCiBzdGF0aWMgaW50IHVmc2hjZF9kaXNhYmxlX3R4X2xjYyhzdHJ1Y3QgdWZzX2hi
YSAqaGJhLCBib29sIHBlZXIpDQogew0KIAlpbnQgdHhfbGFuZXMsIGksIGVyciA9IDA7DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmgNCmluZGV4IGIxYTFjNjViZThiMS4uZmNhMzcyZDk4NDk1IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0K
QEAgLTc5OSw4ICs3OTksMTEgQEAgc3RhdGljIGlubGluZSB2b2lkIHVmc2hjZF9ybXdsKHN0cnVj
dCB1ZnNfaGJhICpoYmEsIHUzMiBtYXNrLCB1MzIgdmFsLCB1MzIgcmVnKQ0KIA0KIGludCB1ZnNo
Y2RfYWxsb2NfaG9zdChzdHJ1Y3QgZGV2aWNlICosIHN0cnVjdCB1ZnNfaGJhICoqKTsNCiB2b2lk
IHVmc2hjZF9kZWFsbG9jX2hvc3Qoc3RydWN0IHVmc19oYmEgKik7DQoraW50IHVmc2hjZF9oYmFf
ZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KIGludCB1ZnNoY2RfaW5pdChzdHJ1Y3QgdWZz
X2hiYSAqICwgdm9pZCBfX2lvbWVtICogLCB1bnNpZ25lZCBpbnQpOw0KK2ludCB1ZnNoY2RfbWFr
ZV9oYmFfb3BlcmF0aW9uYWwoc3RydWN0IHVmc19oYmEgKmhiYSk7DQogdm9pZCB1ZnNoY2RfcmVt
b3ZlKHN0cnVjdCB1ZnNfaGJhICopOw0KK2ludCB1ZnNoY2RfdWljX2hpYmVybjhfZXhpdChzdHJ1
Y3QgdWZzX2hiYSAqaGJhKTsNCiBpbnQgdWZzaGNkX3dhaXRfZm9yX3JlZ2lzdGVyKHN0cnVjdCB1
ZnNfaGJhICpoYmEsIHUzMiByZWcsIHUzMiBtYXNrLA0KIAkJCQl1MzIgdmFsLCB1bnNpZ25lZCBs
b25nIGludGVydmFsX3VzLA0KIAkJCQl1bnNpZ25lZCBsb25nIHRpbWVvdXRfbXMsIGJvb2wgY2Fu
X3NsZWVwKTsNCi0tIA0KMi4xOC4wDQo=

