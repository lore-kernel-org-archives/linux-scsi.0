Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1355C55178
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F341207BC
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:58:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="G3J5aB+R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgJ2L6C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:58:02 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57201 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725832AbgJ2L6A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 07:58:00 -0400
X-UUID: 9964eaea5bdd41298466a7dbc16c86c7-20201029
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=w81tqkNi8KcOCSO6o9TBab5iqr6LPY1HHHGmMqfxeO8=;
        b=G3J5aB+RGC+u4v9nbdL7YFjWk5X8tUNypVJIXeECWfr0arEBSnEjKgjXMxcyCVWhHPk9kSdlBl/PFKCXQHbQ3ZwmIluJjaKT7S5q9NR6c1r6h18/uioxXb+F6rdw6QfDzQNtac7BUo7qFBoitqppnDjKdPCe6RsphL6zRzgjsWg=;
X-UUID: 9964eaea5bdd41298466a7dbc16c86c7-20201029
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 739349024; Thu, 29 Oct 2020 19:57:53 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Oct 2020 19:57:51 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Oct 2020 19:57:51 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 4/6] scsi: ufs-mediatek: Support option to disable auto-hibern8
Date:   Thu, 29 Oct 2020 19:57:48 +0800
Message-ID: <20201029115750.24391-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201029115750.24391-1-stanley.chu@mediatek.com>
References: <20201029115750.24391-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3VwcG9ydCBhbiBvcHRpb24gdG8gYWxsb3cgdXNlcnMgdG8gZGlzYWJsZSBhdXRvLWhpYmVybjgg
ZmVhdHVyZS4NCg0KSW5zdGVhZCwgZW5hYmxlIGhpYmVybjgtZHVyaW5nLWNsay1nYXRpbmcgZmVh
dHVyZSB0byBrZWVwIHNpbWlsYXINCnBvd2VyIGNvbnN1bXB0aW9uLg0KDQpTaWduZWQtb2ZmLWJ5
OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDE4ICsrKysrKysrKysrKysrKysrKw0KIGRyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggfCAgMSArDQogMiBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNl
cnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5j
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXggZmE3ZDBlNGVlYjBkLi5k
ZGEwMjhlYzMwZGMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5j
DQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpAQCAtMTU4LDYgKzE1OCw3
IEBAIHN0YXRpYyBpbnQgdWZzX210a19oY2VfZW5hYmxlX25vdGlmeShzdHJ1Y3QgdWZzX2hiYSAq
aGJhLA0KIAkJCQkgICAgIGVudW0gdWZzX25vdGlmeV9jaGFuZ2Vfc3RhdHVzIHN0YXR1cykNCiB7
DQogCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsN
CisJdW5zaWduZWQgbG9uZyBmbGFnczsNCiANCiAJaWYgKHN0YXR1cyA9PSBQUkVfQ0hBTkdFKSB7
DQogCQlpZiAoaG9zdC0+dW5pcHJvX2xwbSkgew0KQEAgLTE2OSw2ICsxNzAsMTcgQEAgc3RhdGlj
IGludCB1ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5KHN0cnVjdCB1ZnNfaGJhICpoYmEsDQogDQog
CQlpZiAoaGJhLT5jYXBzICYgVUZTSENEX0NBUF9DUllQVE8pDQogCQkJdWZzX210a19jcnlwdG9f
ZW5hYmxlKGhiYSk7DQorDQorCQlpZiAoaG9zdC0+Y2FwcyAmIFVGU19NVEtfQ0FQX0RJU0FCTEVf
QUg4KSB7DQorCQkJc3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdz
KTsNCisJCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgMCwNCisJCQkJICAgICAgUkVHX0FVVE9fSElCRVJO
QVRFX0lETEVfVElNRVIpOw0KKwkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5o
b3N0X2xvY2ssDQorCQkJCQkgICAgICAgZmxhZ3MpOw0KKw0KKwkJCWhiYS0+Y2FwYWJpbGl0aWVz
ICY9IH5NQVNLX0FVVE9fSElCRVJOOF9TVVBQT1JUOw0KKwkJCWhiYS0+YWhpdCA9IDA7DQorCQl9
DQogCX0NCiANCiAJcmV0dXJuIDA7DQpAQCAtNDk2LDYgKzUwOCw5IEBAIHN0YXRpYyB2b2lkIHVm
c19tdGtfaW5pdF9ob3N0X2NhcHMoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJaWYgKG9mX3Byb3Bl
cnR5X3JlYWRfYm9vbChucCwgIm1lZGlhdGVrLHVmcy1zdXBwb3J0LXZhMDkiKSkNCiAJCXVmc19t
dGtfaW5pdF92YTA5X3B3cl9jdHJsKGhiYSk7DQogDQorCWlmIChvZl9wcm9wZXJ0eV9yZWFkX2Jv
b2wobnAsICJtZWRpYXRlayx1ZnMtZGlzYWJsZS1haDgiKSkNCisJCWhvc3QtPmNhcHMgfD0gVUZT
X01US19DQVBfRElTQUJMRV9BSDg7DQorDQogCWRldl9pbmZvKGhiYS0+ZGV2LCAiY2FwczogMHgl
eCIsIGhvc3QtPmNhcHMpOw0KIH0NCiANCkBAIC02MDksNiArNjI0LDkgQEAgc3RhdGljIGludCB1
ZnNfbXRrX2luaXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJaGJhLT5jYXBzIHw9IFVGU0hDRF9D
QVBfV0JfRU47DQogCWhiYS0+dnBzLT53Yl9mbHVzaF90aHJlc2hvbGQgPSBVRlNfV0JfQlVGX1JF
TUFJTl9QRVJDRU5UKDgwKTsNCiANCisJaWYgKGhvc3QtPmNhcHMgJiBVRlNfTVRLX0NBUF9ESVNB
QkxFX0FIOCkNCisJCWhiYS0+Y2FwcyB8PSBVRlNIQ0RfQ0FQX0hJQkVSTjhfV0lUSF9DTEtfR0FU
SU5HOw0KKw0KIAkvKg0KIAkgKiB1ZnNoY2Rfdm9wc19pbml0KCkgaXMgaW52b2tlZCBhZnRlcg0K
IAkgKiB1ZnNoY2Rfc2V0dXBfY2xvY2sodHJ1ZSkgaW4gdWZzaGNkX2hiYV9pbml0KCkgdGh1cw0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5oDQppbmRleCAwZTc2NDI5ZjY5ZDYuLjMwZjQ1ZGZjZTA0YyAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCisrKyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCkBAIC05Niw2ICs5Niw3IEBAIGVudW0gew0KIGVu
dW0gdWZzX210a19ob3N0X2NhcHMgew0KIAlVRlNfTVRLX0NBUF9CT09TVF9DUllQVF9FTkdJTkUg
ICAgICAgICA9IDEgPDwgMCwNCiAJVUZTX01US19DQVBfVkEwOV9QV1JfQ1RSTCAgICAgICAgICAg
ICAgPSAxIDw8IDEsDQorCVVGU19NVEtfQ0FQX0RJU0FCTEVfQUg4ICAgICAgICAgICAgICAgID0g
MSA8PCAyLA0KIH07DQogDQogc3RydWN0IHVmc19tdGtfY3J5cHRfY2ZnIHsNCi0tIA0KMi4xOC4w
DQo=

