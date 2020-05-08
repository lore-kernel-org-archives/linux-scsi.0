Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995D4C54E49
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 771D0218AC
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:15:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Y1qhyoVE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgEHRPX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:15:23 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:60272 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726767AbgEHRPV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:15:21 -0400
X-UUID: 397b0eb00bb74c089db15ed5db229c38-20200509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=0ORkRYecHIDtUF3MhVdta5cgJ+2Y5vlSsyDAf2BQW40=;
        b=Y1qhyoVEz/VSfnYZJQwI1EyMLo9iGjCYtCa7Oo4eaZk886ImFUMnH6kJolCf5vQknmc5GeSelLTaZrc3PtsOT7OUFMxqcYes9T2N386vehKZ0KQnY2UXnfZh5aJPrC0/cWlECIQPDk9+IJMg0l5ii4mPCl0+K11OcbklR0l4ecY=;
X-UUID: 397b0eb00bb74c089db15ed5db229c38-20200509
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1700407730; Sat, 09 May 2020 01:15:18 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 9 May 2020 01:15:10 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 9 May 2020 01:15:12 +0800
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
Subject: [PATCH v1 3/5] scsi: ufs: customize flush threshold for WriteBooster
Date:   Sat, 9 May 2020 01:15:11 +0800
Message-ID: <20200508171513.14665-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200508171513.14665-1-stanley.chu@mediatek.com>
References: <20200508171513.14665-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: D97692ED15460159C4AFB5BA8F463C69AA861F79961DE9ADFD1E9F8C1A6BF2862000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWxsb3cgZmx1c2ggdGhyZXNob2xkIGZvciBXcml0ZUJvb3N0ZXIgdG8gYmUgY3VzdG9taXphYmxl
IGJ5DQp2ZW5kb3JzLiBUbyBhY2hpZXZlIHRoaXMsIG1ha2UgdGhlIHZhbHVlIGFzIGEgdmFyaWFi
bGUgaW4gc3RydWN0DQp1ZnNfaGJhIGZpcnN0Lg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENo
dSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYyB8IDYgKysrKy0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8IDEgKw0KIDIgZmls
ZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMN
CmluZGV4IGNkYWNiZTYzNzhhMS4uOWEwY2U2NTUwYzJmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTUz
MDEsOCArNTMwMSw4IEBAIHN0YXRpYyBib29sIHVmc2hjZF93Yl9wcmVzcnZfdXNyc3BjX2tlZXBf
dmNjX29uKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQogCQkJIGN1cl9idWYpOw0KIAkJcmV0dXJuIGZh
bHNlOw0KIAl9DQotCS8qIExldCBpdCBjb250aW51ZSB0byBmbHVzaCB3aGVuID42MCUgZnVsbCAq
Lw0KLQlpZiAoYXZhaWxfYnVmIDwgVUZTX1dCXzQwX1BFUkNFTlRfQlVGX1JFTUFJTikNCisJLyog
TGV0IGl0IGNvbnRpbnVlIHRvIGZsdXNoIHdoZW4gYXZhaWxhYmxlIGJ1ZmZlciBleGNlZWRzIHRo
cmVzaG9sZCAqLw0KKwlpZiAoYXZhaWxfYnVmIDwgaGJhLT52cHMtPndiX2ZsdXNoX3RocmVzaG9s
ZCkNCiAJCXJldHVybiB0cnVlOw0KIA0KIAlyZXR1cm4gZmFsc2U7DQpAQCAtNjgzOSw2ICs2ODM5
LDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4
ICpkZXNjX2J1ZikNCiAJCWlmICghZF9sdV93Yl9idWZfYWxsb2MpDQogCQkJZ290byB3Yl9kaXNh
YmxlZDsNCiAJfQ0KKw0KIAlyZXR1cm47DQogDQogd2JfZGlzYWJsZWQ6DQpAQCAtNzQ2Miw2ICs3
NDYzLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgKnVmc2hjZF9kcml2
ZXJfZ3JvdXBzW10gPSB7DQogDQogc3RhdGljIHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfcGFyYW1z
IHVmc19oYmFfdnBzID0gew0KIAkuaGJhX2VuYWJsZV9kZWxheV91cwkJPSAxMDAwLA0KKwkud2Jf
Zmx1c2hfdGhyZXNob2xkCQk9IFVGU19XQl80MF9QRVJDRU5UX0JVRl9SRU1BSU4sDQogCS5kZXZm
cmVxX3Byb2ZpbGUucG9sbGluZ19tcwk9IDEwMCwNCiAJLmRldmZyZXFfcHJvZmlsZS50YXJnZXQJ
CT0gdWZzaGNkX2RldmZyZXFfdGFyZ2V0LA0KIAkuZGV2ZnJlcV9wcm9maWxlLmdldF9kZXZfc3Rh
dHVzCT0gdWZzaGNkX2RldmZyZXFfZ2V0X2Rldl9zdGF0dXMsDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCmluZGV4IGY3
YmRmNTJiYThiMC4uZTNkZmI0OGU2NjllIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KQEAgLTU3MCw2ICs1NzAs
NyBAQCBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X3BhcmFtcyB7DQogCXN0cnVjdCBkZXZmcmVxX2Rl
dl9wcm9maWxlIGRldmZyZXFfcHJvZmlsZTsNCiAJc3RydWN0IGRldmZyZXFfc2ltcGxlX29uZGVt
YW5kX2RhdGEgb25kZW1hbmRfZGF0YTsNCiAJdTE2IGhiYV9lbmFibGVfZGVsYXlfdXM7DQorCXUz
MiB3Yl9mbHVzaF90aHJlc2hvbGQ7DQogfTsNCiANCiAvKioNCi0tIA0KMi4xOC4wDQo=

