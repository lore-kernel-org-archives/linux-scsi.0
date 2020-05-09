Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FC5C28CBC
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 09:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E7D924955
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 09:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GSPBgeb/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgEIJhZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 May 2020 05:37:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:8597 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728152AbgEIJhY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2020 05:37:24 -0400
X-UUID: 6b3e02ffd363465eb15b10662ae32451-20200509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=9vLJufccMQirOO3fRMdyvDSO0idv15wihf8x27nLpCU=;
        b=GSPBgeb/Nmk/aAHRVy0tsl+qOYB+p0hcL1/iUW9UnQQR5dUNfoHxC7EAcMic5fvHQlcRxGmR02n7WzLZoVkH5f/eV9CDCvP93PAsuB38joVxrPflMHhFk2JkUUbNvTy9799QyF1iZgs7detWAtnn6+hRcizyRVVkN391VgMVy84=;
X-UUID: 6b3e02ffd363465eb15b10662ae32451-20200509
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 294229266; Sat, 09 May 2020 17:37:22 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 9 May 2020 17:37:17 +0800
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
Subject: [PATCH v2 3/4] scsi: ufs: customize flush threshold for WriteBooster
Date:   Sat, 9 May 2020 17:37:15 +0800
Message-ID: <20200509093716.21010-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200509093716.21010-1-stanley.chu@mediatek.com>
References: <20200509093716.21010-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: A1C6ED970B30FA952A189F7D64977EEEC0A73EE51969F02DCF84178B2B2A59822000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWxsb3cgZmx1c2ggdGhyZXNob2xkIGZvciBXcml0ZUJvb3N0ZXIgdG8gYmUgY3VzdG9taXphYmxl
IGJ5DQp2ZW5kb3JzLiBUbyBhY2hpZXZlIHRoaXMsIG1ha2UgdGhlIHZhbHVlIGFzIGEgdmFyaWFi
bGUgaW4gc3RydWN0DQp1ZnNfaGJhX3ZhcmlhbnRfcGFyYW1zLg0KDQpCZXNpZGVzLCB1c2UgbWFj
cm8gVUZTX1dCX0JVRl9SRU1BSU5fUEVSQ0VOVCgpIGluc3RlYWQgdG8gcHJvdmlkZQ0KbW9yZSBm
bGV4aWJsZSB1c2FnZSBvZiBXcml0ZUJvb3N0ZXIgYXZhaWxhYmxlIGJ1ZmZlciB2YWx1ZXMuDQoN
ClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQot
LS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy5oICAgIHwgNSArLS0tLQ0KIGRyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmMgfCA3ICsrKystLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIHwgMSAr
DQogMyBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMu
aA0KaW5kZXggYjMxMzUzNDRhYjNmLi5mYWRiYTNhM2JiY2QgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmcy5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oDQpAQCAtNDc4LDEw
ICs0NzgsNyBAQCBlbnVtIHVmc19kZXZfcHdyX21vZGUgew0KIAlVRlNfUE9XRVJET1dOX1BXUl9N
T0RFCT0gMywNCiB9Ow0KIA0KLWVudW0gdWZzX2Rldl93Yl9idWZfYXZhaWxfc2l6ZSB7DQotCVVG
U19XQl8xMF9QRVJDRU5UX0JVRl9SRU1BSU4gPSAweDEsDQotCVVGU19XQl80MF9QRVJDRU5UX0JV
Rl9SRU1BSU4gPSAweDQsDQotfTsNCisjZGVmaW5lIFVGU19XQl9CVUZfUkVNQUlOX1BFUkNFTlQo
dmFsKSAoKHZhbCkgLyAxMCkNCiANCiAvKioNCiAgKiBzdHJ1Y3QgdXRwX2NtZF9yc3AgLSBSZXNw
b25zZSBVUElVIHN0cnVjdHVyZQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBjZGFjYmU2Mzc4YTEuLmFjYTUw
ZWQzOTg0NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC01MzAxLDggKzUzMDEsOCBAQCBzdGF0aWMgYm9v
bCB1ZnNoY2Rfd2JfcHJlc3J2X3VzcnNwY19rZWVwX3ZjY19vbihzdHJ1Y3QgdWZzX2hiYSAqaGJh
LA0KIAkJCSBjdXJfYnVmKTsNCiAJCXJldHVybiBmYWxzZTsNCiAJfQ0KLQkvKiBMZXQgaXQgY29u
dGludWUgdG8gZmx1c2ggd2hlbiA+NjAlIGZ1bGwgKi8NCi0JaWYgKGF2YWlsX2J1ZiA8IFVGU19X
Ql80MF9QRVJDRU5UX0JVRl9SRU1BSU4pDQorCS8qIExldCBpdCBjb250aW51ZSB0byBmbHVzaCB3
aGVuIGF2YWlsYWJsZSBidWZmZXIgZXhjZWVkcyB0aHJlc2hvbGQgKi8NCisJaWYgKGF2YWlsX2J1
ZiA8IGhiYS0+dnBzLT53Yl9mbHVzaF90aHJlc2hvbGQpDQogCQlyZXR1cm4gdHJ1ZTsNCiANCiAJ
cmV0dXJuIGZhbHNlOw0KQEAgLTUzMzYsNyArNTMzNiw3IEBAIHN0YXRpYyBib29sIHVmc2hjZF93
Yl9rZWVwX3ZjY19vbihzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAl9DQogDQogCWlmICghaGJhLT5k
ZXZfaW5mby5iX3ByZXNydl91c3BjX2VuKSB7DQotCQlpZiAoYXZhaWxfYnVmIDw9IFVGU19XQl8x
MF9QRVJDRU5UX0JVRl9SRU1BSU4pDQorCQlpZiAoYXZhaWxfYnVmIDw9IFVGU19XQl9CVUZfUkVN
QUlOX1BFUkNFTlQoMTApKQ0KIAkJCXJldHVybiB0cnVlOw0KIAkJcmV0dXJuIGZhbHNlOw0KIAl9
DQpAQCAtNzQ2Miw2ICs3NDYyLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBhdHRyaWJ1dGVfZ3Jv
dXAgKnVmc2hjZF9kcml2ZXJfZ3JvdXBzW10gPSB7DQogDQogc3RhdGljIHN0cnVjdCB1ZnNfaGJh
X3ZhcmlhbnRfcGFyYW1zIHVmc19oYmFfdnBzID0gew0KIAkuaGJhX2VuYWJsZV9kZWxheV91cwkJ
PSAxMDAwLA0KKwkud2JfZmx1c2hfdGhyZXNob2xkCQk9IFVGU19XQl9CVUZfUkVNQUlOX1BFUkNF
TlQoNDApLA0KIAkuZGV2ZnJlcV9wcm9maWxlLnBvbGxpbmdfbXMJPSAxMDAsDQogCS5kZXZmcmVx
X3Byb2ZpbGUudGFyZ2V0CQk9IHVmc2hjZF9kZXZmcmVxX3RhcmdldCwNCiAJLmRldmZyZXFfcHJv
ZmlsZS5nZXRfZGV2X3N0YXR1cwk9IHVmc2hjZF9kZXZmcmVxX2dldF9kZXZfc3RhdHVzLA0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5oDQppbmRleCBmN2JkZjUyYmE4YjAuLmUzZGZiNDhlNjY5ZSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgN
CkBAIC01NzAsNiArNTcwLDcgQEAgc3RydWN0IHVmc19oYmFfdmFyaWFudF9wYXJhbXMgew0KIAlz
dHJ1Y3QgZGV2ZnJlcV9kZXZfcHJvZmlsZSBkZXZmcmVxX3Byb2ZpbGU7DQogCXN0cnVjdCBkZXZm
cmVxX3NpbXBsZV9vbmRlbWFuZF9kYXRhIG9uZGVtYW5kX2RhdGE7DQogCXUxNiBoYmFfZW5hYmxl
X2RlbGF5X3VzOw0KKwl1MzIgd2JfZmx1c2hfdGhyZXNob2xkOw0KIH07DQogDQogLyoqDQotLSAN
CjIuMTguMA0K

