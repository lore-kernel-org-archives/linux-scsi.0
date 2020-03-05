Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3701C3F2D1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AFE9208CD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YTBinTgg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgCEEHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 23:07:11 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:23443 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725880AbgCEEHL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 23:07:11 -0500
X-UUID: 85ae94fad45d46888b1972582f147618-20200305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=GviJRMcOaJl/gYdiZFpBqNHJakGWJUdloIyo32jmEI0=;
        b=YTBinTggvMZ0JZ6e98U6bbeT1dn9NQImVyczQS4ja3blnVjkcGJia5/oyL3Q0uUGWBIRQBsXwCbITgUXf7MX/h14l9W1ZSmltPCK84cwKWHYZ8DoLX7QC90UiY9AAAflBpzRhDPU1X/fj1WQyay32lF/w1+8D986YryE+hAJpa0=;
X-UUID: 85ae94fad45d46888b1972582f147618-20200305
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2027095148; Thu, 05 Mar 2020 12:07:07 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 5 Mar 2020 12:04:23 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 5 Mar 2020 12:06:20 +0800
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
Subject: [PATCH v1 1/4] scsi: ufs: remove init_prefetch_data in struct ufs_hba
Date:   Thu, 5 Mar 2020 12:07:01 +0800
Message-ID: <20200305040704.10645-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200305040704.10645-1-stanley.chu@mediatek.com>
References: <20200305040704.10645-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 1BA22F773C9DEB48C50105DEBB776B0A9E3AD8977A4E010EFA5FEDB97C01BB6F2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3RydWN0IGluaXRfcHJlZmV0Y2hfZGF0YSBjdXJyZW50bHkgaXMgdXNlZCBwcml2YXRlbHkgaW4N
CnVmc2hjZF9pbml0X2ljY19sZXZlbHMoKSwgdGh1cyBpdCBjYW4gYmUgcmVtb3ZlZCBmcm9tIHN0
cnVjdCB1ZnNfaGJhLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVA
bWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDE1ICsrKysr
Ky0tLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCAgMiAtLQ0KIDIgZmlsZXMg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpp
bmRleCBlOTg3ZmEzYTc3YzcuLmVkNjFlY2I5OGIyZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC02NDk0
LDYgKzY0OTQsNyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2RfaW5pdF9pY2NfbGV2ZWxzKHN0cnVjdCB1
ZnNfaGJhICpoYmEpDQogew0KIAlpbnQgcmV0Ow0KIAlpbnQgYnVmZl9sZW4gPSBoYmEtPmRlc2Nf
c2l6ZS5wd3JfZGVzYzsNCisJdTMyIGljY19sZXZlbDsNCiAJdTggKmRlc2NfYnVmOw0KIA0KIAlk
ZXNjX2J1ZiA9IGttYWxsb2MoYnVmZl9sZW4sIEdGUF9LRVJORUwpOw0KQEAgLTY1MDksMjEgKzY1
MTAsMTcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2luaXRfaWNjX2xldmVscyhzdHJ1Y3QgdWZzX2hi
YSAqaGJhKQ0KIAkJZ290byBvdXQ7DQogCX0NCiANCi0JaGJhLT5pbml0X3ByZWZldGNoX2RhdGEu
aWNjX2xldmVsID0NCi0JCQl1ZnNoY2RfZmluZF9tYXhfc3VwX2FjdGl2ZV9pY2NfbGV2ZWwoaGJh
LA0KLQkJCWRlc2NfYnVmLCBidWZmX2xlbik7DQotCWRldl9kYmcoaGJhLT5kZXYsICIlczogc2V0
dGluZyBpY2NfbGV2ZWwgMHgleCIsDQotCQkJX19mdW5jX18sIGhiYS0+aW5pdF9wcmVmZXRjaF9k
YXRhLmljY19sZXZlbCk7DQorCWljY19sZXZlbCA9DQorCQl1ZnNoY2RfZmluZF9tYXhfc3VwX2Fj
dGl2ZV9pY2NfbGV2ZWwoaGJhLCBkZXNjX2J1ZiwgYnVmZl9sZW4pOw0KKwlkZXZfZGJnKGhiYS0+
ZGV2LCAiJXM6IHNldHRpbmcgaWNjX2xldmVsIDB4JXgiLAlfX2Z1bmNfXywgaWNjX2xldmVsKTsN
CiANCiAJcmV0ID0gdWZzaGNkX3F1ZXJ5X2F0dHJfcmV0cnkoaGJhLCBVUElVX1FVRVJZX09QQ09E
RV9XUklURV9BVFRSLA0KLQkJUVVFUllfQVRUUl9JRE5fQUNUSVZFX0lDQ19MVkwsIDAsIDAsDQot
CQkmaGJhLT5pbml0X3ByZWZldGNoX2RhdGEuaWNjX2xldmVsKTsNCisJCVFVRVJZX0FUVFJfSURO
X0FDVElWRV9JQ0NfTFZMLCAwLCAwLCAmaWNjX2xldmVsKTsNCiANCiAJaWYgKHJldCkNCiAJCWRl
dl9lcnIoaGJhLT5kZXYsDQogCQkJIiVzOiBGYWlsZWQgY29uZmlndXJpbmcgYkFjdGl2ZUlDQ0xl
dmVsID0gJWQgcmV0ID0gJWQiLA0KLQkJCV9fZnVuY19fLCBoYmEtPmluaXRfcHJlZmV0Y2hfZGF0
YS5pY2NfbGV2ZWwgLCByZXQpOw0KLQ0KKwkJCV9fZnVuY19fLCBpY2NfbGV2ZWwsIHJldCk7DQog
b3V0Og0KIAlrZnJlZShkZXNjX2J1Zik7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQppbmRleCA1YzEwNzc3MTU0
ZmMuLjRlMjM1Y2VmOTliYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgN
CisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCkBAIC01NDEsNyArNTQxLDYgQEAgZW51
bSB1ZnNoY2RfcXVpcmtzIHsNCiAgKiBAaW50cl9tYXNrOiBJbnRlcnJ1cHQgTWFzayBCaXRzDQog
ICogQGVlX2N0cmxfbWFzazogRXhjZXB0aW9uIGV2ZW50IGNvbnRyb2wgbWFzaw0KICAqIEBpc19w
b3dlcmVkOiBmbGFnIHRvIGNoZWNrIGlmIEhCQSBpcyBwb3dlcmVkDQotICogQGluaXRfcHJlZmV0
Y2hfZGF0YTogZGF0YSBwcmUtZmV0Y2hlZCBkdXJpbmcgaW5pdGlhbGl6YXRpb24NCiAgKiBAZWhf
d29yazogV29ya2VyIHRvIGhhbmRsZSBVRlMgZXJyb3JzIHRoYXQgcmVxdWlyZSBzL3cgYXR0ZW50
aW9uDQogICogQGVlaF93b3JrOiBXb3JrZXIgdG8gaGFuZGxlIGV4Y2VwdGlvbiBldmVudHMNCiAg
KiBAZXJyb3JzOiBIQkEgZXJyb3JzDQpAQCAtNjI3LDcgKzYyNiw2IEBAIHN0cnVjdCB1ZnNfaGJh
IHsNCiAJdTMyIGludHJfbWFzazsNCiAJdTE2IGVlX2N0cmxfbWFzazsNCiAJYm9vbCBpc19wb3dl
cmVkOw0KLQlzdHJ1Y3QgdWZzX2luaXRfcHJlZmV0Y2ggaW5pdF9wcmVmZXRjaF9kYXRhOw0KIA0K
IAkvKiBXb3JrIFF1ZXVlcyAqLw0KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QgZWhfd29yazsNCi0tIA0K
Mi4xOC4wDQo=

