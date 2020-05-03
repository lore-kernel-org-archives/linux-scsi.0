Return-Path: <SRS0=cGsx=6R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366B9C47247
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 11:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 114F824959
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 11:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EnlSjnNF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgECLeg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 May 2020 07:34:36 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:32267 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727783AbgECLee (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2020 07:34:34 -0400
X-UUID: a79de085e4334628891a3345623c995c-20200503
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=lvTox59cW7leiqB4qAxOe8+RTfYQVWs09Dx8wQB1BQk=;
        b=EnlSjnNFisDMSo82oi133VKAtKuxnoV38CFHrcYnRHSfFwapboDlFiwgEDuuBdWtHSpSiAgecRv3wBJZGXhl0pxFZqH17ts5SLcg68T8UdE3y70Kv1CkKQKxPJl+iS+mPw82C78VxpjUeegl3gq9MS8hQaqhDuZulfWRws+/Pe0=;
X-UUID: a79de085e4334628891a3345623c995c-20200503
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 609733876; Sun, 03 May 2020 19:34:32 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 3 May 2020 19:34:16 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 3 May 2020 19:34:16 +0800
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
Subject: [PATCH v5 4/8] scsi: ufs-mediatek: add fixup_dev_quirks vops
Date:   Sun, 3 May 2020 19:34:11 +0800
Message-ID: <20200503113415.21034-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200503113415.21034-1-stanley.chu@mediatek.com>
References: <20200503113415.21034-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: FFEAD343D53ED04525D50E8B1637D155DD4EA6DB4DD6180A6B376781C8640E182000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGZpeHVwX2Rldl9xdWlyayB2b3BzIGluIE1lZGlhVGVrIFVGUyBwbGF0Zm9ybXMgYW5kIHBy
b3ZpZGUNCmFuIGluaXRpYWwgdmVuZG9yLXNwZWNpZmljIGRldmljZSBxdWlyayB0YWJsZS4NCg0K
U2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0t
LQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAyMiArKysrKysrKysrKysrKysr
KysrLS0tDQogMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0p
DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggNjczYzE2NTk2ZmIyLi5jZTdiYTUyOWU2
MTMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQorKysgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAtMzAsNiArMzAsMTIgQEANCiAjZGVm
aW5lIHVmc19tdGtfZGV2aWNlX3Jlc2V0X2N0cmwoaGlnaCwgcmVzKSBcDQogCXVmc19tdGtfc21j
KFVGU19NVEtfU0lQX0RFVklDRV9SRVNFVCwgaGlnaCwgcmVzKQ0KIA0KK3N0YXRpYyBzdHJ1Y3Qg
dWZzX2Rldl9maXggdWZzX210a19kZXZfZml4dXBzW10gPSB7DQorCVVGU19GSVgoVUZTX1ZFTkRP
Ul9TS0hZTklYLCAiSDlIUTIxQUZBTVpEQVIiLA0KKwkJVUZTX0RFVklDRV9RVUlSS19TVVBQT1JU
X0VYVEVOREVEX0ZFQVRVUkVTKSwNCisJRU5EX0ZJWA0KK307DQorDQogc3RhdGljIHZvaWQgdWZz
X210a19jZmdfdW5pcHJvX2NnKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgZW5hYmxlKQ0KIHsN
CiAJdTMyIHRtcDsNCkBAIC01NTUsMTAgKzU2MSw4IEBAIHN0YXRpYyBpbnQgdWZzX210a19hcHBs
eV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCXN0cnVjdCB1ZnNfZGV2X2luZm8g
KmRldl9pbmZvID0gJmhiYS0+ZGV2X2luZm87DQogCXUxNiBtaWQgPSBkZXZfaW5mby0+d21hbnVm
YWN0dXJlcmlkOw0KIA0KLQlpZiAobWlkID09IFVGU19WRU5ET1JfU0FNU1VORykgew0KLQkJaGJh
LT5kZXZfcXVpcmtzICY9IH5VRlNfREVWSUNFX1FVSVJLX0hPU1RfUEFfVEFDVElWQVRFOw0KKwlp
ZiAobWlkID09IFVGU19WRU5ET1JfU0FNU1VORykNCiAJCXVmc2hjZF9kbWVfc2V0KGhiYSwgVUlD
X0FSR19NSUIoUEFfVEFDVElWQVRFKSwgNik7DQotCX0NCiANCiAJLyoNCiAJICogRGVjaWRlIHdh
aXRpbmcgdGltZSBiZWZvcmUgZ2F0aW5nIHJlZmVyZW5jZSBjbG9jayBhbmQNCkBAIC01NzUsNiAr
NTc5LDE3IEBAIHN0YXRpYyBpbnQgdWZzX210a19hcHBseV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQogCXJldHVybiAwOw0KIH0NCiANCit2b2lkIHVmc19tdGtfZml4dXBfZGV2X3F1
aXJrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KK3sNCisJc3RydWN0IHVmc19kZXZfaW5mbyAqZGV2
X2luZm8gPSAmaGJhLT5kZXZfaW5mbzsNCisJdTE2IG1pZCA9IGRldl9pbmZvLT53bWFudWZhY3R1
cmVyaWQ7DQorDQorCXVmc2hjZF9maXh1cF9kZXZpY2Vfc2V0dXAoaGJhLCB1ZnNfbXRrX2Rldl9m
aXh1cHMpOw0KKw0KKwlpZiAobWlkID09IFVGU19WRU5ET1JfU0FNU1VORykNCisJCWhiYS0+ZGV2
X3F1aXJrcyAmPSB+VUZTX0RFVklDRV9RVUlSS19IT1NUX1BBX1RBQ1RJVkFURTsNCit9DQorDQog
LyoqDQogICogc3RydWN0IHVmc19oYmFfbXRrX3ZvcHMgLSBVRlMgTVRLIHNwZWNpZmljIHZhcmlh
bnQgb3BlcmF0aW9ucw0KICAqDQpAQCAtNTg5LDYgKzYwNCw3IEBAIHN0YXRpYyBzdHJ1Y3QgdWZz
X2hiYV92YXJpYW50X29wcyB1ZnNfaGJhX210a192b3BzID0gew0KIAkubGlua19zdGFydHVwX25v
dGlmeSA9IHVmc19tdGtfbGlua19zdGFydHVwX25vdGlmeSwNCiAJLnB3cl9jaGFuZ2Vfbm90aWZ5
ICAgPSB1ZnNfbXRrX3B3cl9jaGFuZ2Vfbm90aWZ5LA0KIAkuYXBwbHlfZGV2X3F1aXJrcyAgICA9
IHVmc19tdGtfYXBwbHlfZGV2X3F1aXJrcywNCisJLmZpeHVwX2Rldl9xdWlya3MgICAgPSB1ZnNf
bXRrX2ZpeHVwX2Rldl9xdWlya3MsDQogCS5zdXNwZW5kICAgICAgICAgICAgID0gdWZzX210a19z
dXNwZW5kLA0KIAkucmVzdW1lICAgICAgICAgICAgICA9IHVmc19tdGtfcmVzdW1lLA0KIAkuZGJn
X3JlZ2lzdGVyX2R1bXAgICA9IHVmc19tdGtfZGJnX3JlZ2lzdGVyX2R1bXAsDQotLSANCjIuMTgu
MA0K

