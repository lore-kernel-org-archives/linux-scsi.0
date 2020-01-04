Return-Path: <SRS0=nD9h=2Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC4AC2D0C2
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 14:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 860762465D
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 14:26:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JuSCF7/Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgADO0S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jan 2020 09:26:18 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56511 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726004AbgADO0R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2020 09:26:17 -0500
X-UUID: 463bd583c46f44a592eda2840baed79b-20200104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=6Ow9gLDlz0YaDc5rObbYGuAgpDVGXNzexRoce87poYU=;
        b=JuSCF7/QNA6eWBZYlJ0ZP7mI/nX0L+RBMHTtjxwhqF0XMZifzTigMI2Y6nun1uw13ERB5J4HXwwG9hkpX8gehTDEF/kRVSEFoDfHehbIZBzXzsgXD9kIhruEaOSVjBMCSlrsdwEqXLrCND0zwXzoryKHW01QtqyGPXIiY1/7Fqs=;
X-UUID: 463bd583c46f44a592eda2840baed79b-20200104
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 437806638; Sat, 04 Jan 2020 22:26:11 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 4 Jan 2020 22:25:17 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 4 Jan 2020 22:26:39 +0800
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
Subject: [PATCH v1 1/3] scsi: ufs: fix empty check of error history
Date:   Sat, 4 Jan 2020 22:26:06 +0800
Message-ID: <1578147968-30938-2-git-send-email-stanley.chu@mediatek.com>
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

Q3VycmVudGx5IGNoZWNraW5nIGlmIGFuIGVycm9yIGhpc3RvcnkgZWxlbWVudCBpcyBlbXB0eSBv
cg0Kbm90IGlzIGJ5IGl0cyAidmFsdWUiLiBJbiBtb3N0IGNhc2VzLCB2YWx1ZSBpcyBlcnJvciBj
b2RlLg0KDQpIb3dldmVyIHRoaXMgY2hlY2tpbmcgaXMgbm90IGNvcnJlY3QgYmVjYXVzZSBzb21l
IGVycm9ycyBvcg0KZXZlbnRzIGRvIG5vdCBzcGVjaWZ5IGFueSB2YWx1ZXMgaW4gZXJyb3IgaGlz
dG9yeSBzbyB2YWx1ZXMNCnJlbWFpbiBhcyAwLCBhbmQgdGhpcyB3aWxsIGxlYWQgdG8gaW5jb3Jy
ZWN0IGVtcHR5IGNoZWNraW5nLg0KDQpGaXggaXQgYnkgY2hlY2tpbmcgInRpbWVzdGFtcCIgaW5z
dGVhZCBvZiAidmFsdWUiIGJlY2F1c2UNCnRpbWVzdGFtcCB3aWxsIGJlIGFsd2F5cyBhc3NpZ25l
ZCBmb3IgYWxsIGhpc3RvcnkgZWxlbWVudHMNCg0KQ2M6IEFsaW0gQWtodGFyIDxhbGltLmFraHRh
ckBzYW1zdW5nLmNvbT4NCkNjOiBBc3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc+
DQpDYzogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQpDYzogQmFydCBWYW4gQXNz
Y2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQpDYzogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNv
bT4NCkNjOiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KQ2M6IE1hdHRoaWFzIEJydWdn
ZXIgPG1hdHRoaWFzLmJnZ0BnbWFpbC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8
c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
YyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jDQppbmRleCAxYjk3ZjJkYzBiNjMuLmJhZTQzZGEwMGJiNiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMNCkBAIC0zODUsNyArMzg1LDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3ByaW50X2Vycl9o
aXN0KHN0cnVjdCB1ZnNfaGJhICpoYmEsDQogCWZvciAoaSA9IDA7IGkgPCBVRlNfRVJSX1JFR19I
SVNUX0xFTkdUSDsgaSsrKSB7DQogCQlpbnQgcCA9IChpICsgZXJyX2hpc3QtPnBvcykgJSBVRlNf
RVJSX1JFR19ISVNUX0xFTkdUSDsNCiANCi0JCWlmIChlcnJfaGlzdC0+cmVnW3BdID09IDApDQor
CQlpZiAoZXJyX2hpc3QtPnRzdGFtcFtwXSA9PSAwKQ0KIAkJCWNvbnRpbnVlOw0KIAkJZGV2X2Vy
cihoYmEtPmRldiwgIiVzWyVkXSA9IDB4JXggYXQgJWxsZCB1c1xuIiwgZXJyX25hbWUsIHAsDQog
CQkJZXJyX2hpc3QtPnJlZ1twXSwga3RpbWVfdG9fdXMoZXJyX2hpc3QtPnRzdGFtcFtwXSkpOw0K
LS0gDQoyLjE4LjANCg==

