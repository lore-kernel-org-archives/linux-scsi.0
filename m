Return-Path: <SRS0=+zlT=7O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2FDAC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 10:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D4EA20772
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 10:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qnN/SsqG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgFAKq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Jun 2020 06:46:58 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:19803 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725838AbgFAKqv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2020 06:46:51 -0400
X-UUID: 466e592f65ab4626a02a4b3263d9c3fe-20200601
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ckHEM7GVI4e4nimxXTABhbmcvCORVQbBj1jfInkgoAg=;
        b=qnN/SsqGEXsZ18dqu2xVroL2VBVeEEMEczfG/pDyYCVrhvUl8L5hQh06i+noZP9ZEkh1JUF2WeYH/p2ivFVDzCCNvuUlaxL25TfZj5jJB/T0pZf24humDsJroV31H/4gQeIEuJTkDeLzYTY0SEMkiffNvIbjPxqMuXuloKATZyo=;
X-UUID: 466e592f65ab4626a02a4b3263d9c3fe-20200601
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 571622865; Mon, 01 Jun 2020 18:46:48 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 1 Jun 2020 18:46:45 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 1 Jun 2020 18:46:46 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 3/5] scsi: ufs-mediatek: Introduce low-power mode for device power supply
Date:   Mon, 1 Jun 2020 18:46:44 +0800
Message-ID: <20200601104646.15436-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200601104646.15436-1-stanley.chu@mediatek.com>
References: <20200601104646.15436-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWxsb3cgZGV2aWNlIHBvd2VyIHN1cHBseSB0byBlbnRlciBsb3ctcG93ZXIgbW9kZSBpZiBkZXZp
Y2Ugd2lsbA0KZG8gbm90aGluZyB0byBzYXZlIG1vcmUgcG93ZXIuDQoNClNpZ25lZC1vZmYtYnk6
IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpSZXZpZXdlZC1ieTogUGVu
Z3NodW4gWmhhbyA8cGVuZ3NodW4uemhhb0BtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMjEgKysrKysrKysrKysrKysrKysrKysrDQogMSBmaWxl
IGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRl
eCAzYzg1ZjVlOTdkZWEuLjVmNDFiN2I3ZGI4ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMN
CkBAIC0xMiw2ICsxMiw3IEBADQogI2luY2x1ZGUgPGxpbnV4L29mX2FkZHJlc3MuaD4NCiAjaW5j
bHVkZSA8bGludXgvcGh5L3BoeS5oPg0KICNpbmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2Uu
aD4NCisjaW5jbHVkZSA8bGludXgvcmVndWxhdG9yL2NvbnN1bWVyLmg+DQogI2luY2x1ZGUgPGxp
bnV4L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oPg0KIA0KICNpbmNsdWRlICJ1ZnNoY2QuaCIN
CkBAIC01MjEsNiArNTIyLDE5IEBAIHN0YXRpYyBpbnQgdWZzX210a19saW5rX3NldF9scG0oc3Ry
dWN0IHVmc19oYmEgKmhiYSkNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK3N0YXRpYyB2b2lkIHVmc19t
dGtfdnJlZ19zZXRfbHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgbHBtKQ0KK3sNCisJaWYg
KCFoYmEtPnZyZWdfaW5mby52Y2NxMikNCisJCXJldHVybjsNCisNCisJaWYgKGxwbSAmICFoYmEt
PnZyZWdfaW5mby52Y2MtPmVuYWJsZWQpDQorCQlyZWd1bGF0b3Jfc2V0X21vZGUoaGJhLT52cmVn
X2luZm8udmNjcTItPnJlZywNCisJCQkJICAgUkVHVUxBVE9SX01PREVfSURMRSk7DQorCWVsc2Ug
aWYgKCFscG0pDQorCQlyZWd1bGF0b3Jfc2V0X21vZGUoaGJhLT52cmVnX2luZm8udmNjcTItPnJl
ZywNCisJCQkJICAgUkVHVUxBVE9SX01PREVfTk9STUFMKTsNCit9DQorDQogc3RhdGljIGludCB1
ZnNfbXRrX3N1c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3Ap
DQogew0KIAlpbnQgZXJyOw0KQEAgLTUzNyw2ICs1NTEsMTIgQEAgc3RhdGljIGludCB1ZnNfbXRr
X3N1c3BlbmQoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQogCQkJ
dWZzaGNkX3NldF9saW5rX29mZihoYmEpOw0KIAkJCXJldHVybiAtRUFHQUlOOw0KIAkJfQ0KKwkJ
LyoNCisJCSAqIE1ha2Ugc3VyZSBubyBlcnJvciB3aWxsIGJlIHJldHVybmVkIHRvIHByZXZlbnQN
CisJCSAqIHVmc2hjZF9zdXNwZW5kKCkgcmUtZW5hYmxpbmcgcmVndWxhdG9ycyB3aGlsZSB2cmVn
IGlzIHN0aWxsDQorCQkgKiBpbiBsb3ctcG93ZXIgbW9kZS4NCisJCSAqLw0KKwkJdWZzX210a192
cmVnX3NldF9scG0oaGJhLCB0cnVlKTsNCiAJfQ0KIA0KIAlpZiAoIXVmc2hjZF9pc19saW5rX2Fj
dGl2ZShoYmEpKQ0KQEAgLTU1NCw2ICs1NzQsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfcmVzdW1l
KHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KIAkJcGh5X3Bvd2Vy
X29uKGhvc3QtPm1waHkpOw0KIA0KIAlpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJuOChoYmEpKSB7
DQorCQl1ZnNfbXRrX3ZyZWdfc2V0X2xwbShoYmEsIGZhbHNlKTsNCiAJCWVyciA9IHVmc19tdGtf
bGlua19zZXRfaHBtKGhiYSk7DQogCQlpZiAoZXJyKSB7DQogCQkJZXJyID0gdWZzaGNkX2xpbmtf
cmVjb3ZlcnkoaGJhKTsNCi0tIA0KMi4xOC4wDQo=

