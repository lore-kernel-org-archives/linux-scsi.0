Return-Path: <SRS0=nD9h=2Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFC7C32770
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 14:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01EDE24653
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 14:26:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Z1lhBqcg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgADO0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jan 2020 09:26:16 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56511 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725943AbgADO0Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2020 09:26:16 -0500
X-UUID: dacf1503b5e746aa9c0433ffe543e4a1-20200104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Lcy3+KlfMb7jLpiBkhLUoc+fZ0Xd/X066UNWWwKFUng=;
        b=Z1lhBqcgEO/h+MWEeifc2Pkj+Ix4L8mD/gm333vaE/5EVABiB9qqN3HJQEE7vbZS8y+jpApuEOTdudiLUPpKwJDnD9Tlm8j8i37VNGNpyjzYH56A3TUY2xsrurpJa5DYr1GFmb/6I0kbWRpKbaG4xU+6J6zss7LgnJI4mfvqntY=;
X-UUID: dacf1503b5e746aa9c0433ffe543e4a1-20200104
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1918082156; Sat, 04 Jan 2020 22:26:11 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 4 Jan 2020 22:25:38 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 4 Jan 2020 22:26:40 +0800
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
Subject: [PATCH v1 2/3] scsi: ufs: add device reset history for vendor implementations
Date:   Sat, 4 Jan 2020 22:26:07 +0800
Message-ID: <1578147968-30938-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
References: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RGV2aWNlIHJlc2V0IGhpc3Rvcnkgc2hhbGwgYmUgYWxzbyBhZGRlZCBmb3IgdmVuZG9yJ3MgZGV2
aWNlDQpyZXNldCB2YXJpYW50IG9wZXJhdGlvbiBpbXBsZW1lbnRhdGlvbi4NCg0KQ2M6IEFsaW0g
QWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT4NCkNjOiBBc3V0b3NoIERhcyA8YXN1dG9z
aGRAY29kZWF1cm9yYS5vcmc+DQpDYzogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+
DQpDYzogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQpDYzogQmVhbiBIdW8g
PGJlYW5odW9AbWljcm9uLmNvbT4NCkNjOiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0K
Q2M6IE1hdHRoaWFzIEJydWdnZXIgPG1hdHRoaWFzLmJnZ0BnbWFpbC5jb20+DQpTaWduZWQtb2Zm
LWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDUgKysrLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5o
IHwgNiArKysrKy0NCiAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlv
bnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBiYWU0M2RhMDBiYjYuLjI5ZTNkNTBhYWJmYiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmMNCkBAIC00MzQ2LDEzICs0MzQ2LDE0IEBAIHN0YXRpYyBpbmxpbmUgaW50IHVm
c2hjZF9kaXNhYmxlX2RldmljZV90eF9sY2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJcmV0dXJu
IHVmc2hjZF9kaXNhYmxlX3R4X2xjYyhoYmEsIHRydWUpOw0KIH0NCiANCi1zdGF0aWMgdm9pZCB1
ZnNoY2RfdXBkYXRlX3JlZ19oaXN0KHN0cnVjdCB1ZnNfZXJyX3JlZ19oaXN0ICpyZWdfaGlzdCwN
Ci0JCQkJICAgdTMyIHJlZykNCit2b2lkIHVmc2hjZF91cGRhdGVfcmVnX2hpc3Qoc3RydWN0IHVm
c19lcnJfcmVnX2hpc3QgKnJlZ19oaXN0LA0KKwkJCSAgICB1MzIgcmVnKQ0KIHsNCiAJcmVnX2hp
c3QtPnJlZ1tyZWdfaGlzdC0+cG9zXSA9IHJlZzsNCiAJcmVnX2hpc3QtPnRzdGFtcFtyZWdfaGlz
dC0+cG9zXSA9IGt0aW1lX2dldCgpOw0KIAlyZWdfaGlzdC0+cG9zID0gKHJlZ19oaXN0LT5wb3Mg
KyAxKSAlIFVGU19FUlJfUkVHX0hJU1RfTEVOR1RIOw0KIH0NCitFWFBPUlRfU1lNQk9MX0dQTCh1
ZnNoY2RfdXBkYXRlX3JlZ19oaXN0KTsNCiANCiAvKioNCiAgKiB1ZnNoY2RfbGlua19zdGFydHVw
IC0gSW5pdGlhbGl6ZSB1bmlwcm8gbGluayBzdGFydHVwDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCmluZGV4IGUwNWNh
ZmRkYzg3Yi4uZGUxYmU2YTg2MmIwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KQEAgLTgwNSw2ICs4MDUsOCBA
QCBpbnQgdWZzaGNkX3dhaXRfZm9yX3JlZ2lzdGVyKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBy
ZWcsIHUzMiBtYXNrLA0KIAkJCQl1MzIgdmFsLCB1bnNpZ25lZCBsb25nIGludGVydmFsX3VzLA0K
IAkJCQl1bnNpZ25lZCBsb25nIHRpbWVvdXRfbXMsIGJvb2wgY2FuX3NsZWVwKTsNCiB2b2lkIHVm
c2hjZF9wYXJzZV9kZXZfcmVmX2Nsa19mcmVxKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHN0cnVjdCBj
bGsgKnJlZmNsayk7DQordm9pZCB1ZnNoY2RfdXBkYXRlX3JlZ19oaXN0KHN0cnVjdCB1ZnNfZXJy
X3JlZ19oaXN0ICpyZWdfaGlzdCwNCisJCQkgICAgdTMyIHJlZyk7DQogDQogc3RhdGljIGlubGlu
ZSB2b2lkIGNoZWNrX3VwaXVfc2l6ZSh2b2lkKQ0KIHsNCkBAIC0xMDgzLDggKzEwODUsMTAgQEAg
c3RhdGljIGlubGluZSB2b2lkIHVmc2hjZF92b3BzX2RiZ19yZWdpc3Rlcl9kdW1wKHN0cnVjdCB1
ZnNfaGJhICpoYmEpDQogDQogc3RhdGljIGlubGluZSB2b2lkIHVmc2hjZF92b3BzX2RldmljZV9y
ZXNldChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCi0JaWYgKGhiYS0+dm9wcyAmJiBoYmEtPnZv
cHMtPmRldmljZV9yZXNldCkNCisJaWYgKGhiYS0+dm9wcyAmJiBoYmEtPnZvcHMtPmRldmljZV9y
ZXNldCkgew0KIAkJaGJhLT52b3BzLT5kZXZpY2VfcmVzZXQoaGJhKTsNCisJCXVmc2hjZF91cGRh
dGVfcmVnX2hpc3QoJmhiYS0+dWZzX3N0YXRzLmRldl9yZXNldCwgMCk7DQorCX0NCiB9DQogDQog
ZXh0ZXJuIHN0cnVjdCB1ZnNfcG1fbHZsX3N0YXRlcyB1ZnNfcG1fbHZsX3N0YXRlc1tdOw0KLS0g
DQoyLjE4LjANCg==

