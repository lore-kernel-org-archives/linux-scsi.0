Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D43C47084
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 04:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 311D961249
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 04:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhEYER1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 00:17:27 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:50891 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229446AbhEYER1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 00:17:27 -0400
X-UUID: 7a2a5cf4466748ffb3bda70ffd5b3780-20210525
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=/xiWf/FwDwfPCNEmpkZcRjDImK9Xd2GJHsb9gmpPJA8=;
        b=YwTcHZ84cDmXTChP/S6Ta9D4HgMHgQa2RB38ycRSN9RROZ4cA2oGxZw1CkDtSlbroW1HA573RuagL0XFZzTsxrmFl89YATPJS80x313wlp5RG4m2tHnaiYM6gW05/zowHDqzRMjN90SzK8lGi7B2g4etvZydkHK9DrTkg2jExzk=;
X-UUID: 7a2a5cf4466748ffb3bda70ffd5b3780-20210525
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 97996577; Tue, 25 May 2021 12:15:55 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 12:15:53 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 12:15:52 +0800
Message-ID: <1621916153.7096.0.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/3] scsi: ufs: Remove a redundant command completion
 logic in error handler
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 25 May 2021 12:15:53 +0800
In-Reply-To: <1621845419-14194-2-git-send-email-cang@codeaurora.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
         <1621845419-14194-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIxLTA1LTI0IGF0IDAxOjM2IC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiB1ZnNo
Y2RfaG9zdF9yZXNldF9hbmRfcmVzdG9yZSgpIGFueXdheXMgY29tcGxldGVzIGFsbCBwZW5kaW5n
IHJlcXVlc3RzDQo+IGJlZm9yZSBzdGFydHMgcmUtcHJvYmluZywgc28gdGhlcmUgaXMgbm8gbmVl
ZCB0byBjb21wbGV0ZSB0aGUgY29tbWFuZCBvbg0KPiB0aGUgaGlnaGVzdCBiaXQgaW4gdHJfZG9v
cmJlbGwgaW4gYWR2YW5jZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbmdAY29k
ZWF1cm9yYS5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDEzIC0t
LS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYw0KPiBpbmRleCBkNTQzODY0Li5jNGIzN2QyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4g
QEAgLTYxMjMsMTkgKzYxMjMsNiBAQCBzdGF0aWMgdm9pZCB1ZnNoY2RfZXJyX2hhbmRsZXIoc3Ry
dWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiAgZG9fcmVzZXQ6DQo+ICAJLyogRmF0YWwgZXJyb3Jz
IG5lZWQgcmVzZXQgKi8NCj4gIAlpZiAobmVlZHNfcmVzZXQpIHsNCj4gLQkJdW5zaWduZWQgbG9u
ZyBtYXhfZG9vcmJlbGxzID0gKDFVTCA8PCBoYmEtPm51dHJzKSAtIDE7DQo+IC0NCj4gLQkJLyoN
Cj4gLQkJICogdWZzaGNkX3Jlc2V0X2FuZF9yZXN0b3JlKCkgZG9lcyB0aGUgbGluayByZWluaXRp
YWxpemF0aW9uDQo+IC0JCSAqIHdoaWNoIHdpbGwgbmVlZCBhdGxlYXN0IG9uZSBlbXB0eSBkb29y
YmVsbCBzbG90IHRvIHNlbmQgdGhlDQo+IC0JCSAqIGRldmljZSBtYW5hZ2VtZW50IGNvbW1hbmRz
IChOT1AgYW5kIHF1ZXJ5IGNvbW1hbmRzKS4NCj4gLQkJICogSWYgdGhlcmUgaXMgbm8gc2xvdCBl
bXB0eSBhdCB0aGlzIG1vbWVudCB0aGVuIGZyZWUgdXAgbGFzdA0KPiAtCQkgKiBzbG90IGZvcmNl
ZnVsbHkuDQo+IC0JCSAqLw0KPiAtCQlpZiAoaGJhLT5vdXRzdGFuZGluZ19yZXFzID09IG1heF9k
b29yYmVsbHMpDQo+IC0JCQlfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoaGJhLA0KPiAtCQkJ
CQkJICAgICgxVUwgPDwgKGhiYS0+bnV0cnMgLSAxKSkpOw0KPiAtDQo+ICAJCWhiYS0+Zm9yY2Vf
cmVzZXQgPSBmYWxzZTsNCj4gIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhv
c3RfbG9jaywgZmxhZ3MpOw0KPiAgCQllcnIgPSB1ZnNoY2RfcmVzZXRfYW5kX3Jlc3RvcmUoaGJh
KTsNCg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+
DQoNCg0K

