Return-Path: <SRS0=TzWF=Z5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE04C2BBE2
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 12:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 532C12176D
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 12:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Id0VyHB4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfLGMW0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Dec 2019 07:22:26 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:49668 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726509AbfLGMWZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Dec 2019 07:22:25 -0500
X-UUID: 8c0becf7d94c4e7cab15a221e0e4a0d7-20191207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=x9J++tnSYtzHVx3/Z80sxjIENo1114b2ATMpoEVh/84=;
        b=Id0VyHB4ckC5PZpX2mlw7STOS4+Ll+bfD1EspH7J8Mqq62vgfTwoVMznnCTkbdiOn30vVBtFukTpxEHTDNT98FlvO0nqb0L+lLMFlPltpO4+7/6gCjbpEKxI4+lB6uKthtAgVdfa1arqNgNLVlVh7IjxqvJ1HqLAQmH6R2qjL5Q=;
X-UUID: 8c0becf7d94c4e7cab15a221e0e4a0d7-20191207
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1214669838; Sat, 07 Dec 2019 20:22:18 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 7 Dec 2019 20:21:58 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 7 Dec 2019 20:21:55 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 2/2] scsi: ufs: disable interrupt during clock-gating
Date:   Sat, 7 Dec 2019 20:22:01 +0800
Message-ID: <1575721321-8071-3-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1575721321-8071-1-git-send-email-stanley.chu@mediatek.com>
References: <1575721321-8071-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U2ltaWxhciB0byBzdXNwZW5kLCB1ZnNoY2QgaW50ZXJydXB0IGNhbiBiZSBkaXNhYmxlZCBzaW5j
ZQ0KdGhlcmUgd29uJ3QgYmUgYW55IGhvc3QgY29udHJvbGxlciB0cmFuc2FjdGlvbiBleHBlY3Rl
ZCB0aWxsDQpjbG9ja3MgdW5nYXRlZC4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0
YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMg
fCA0ICsrKysNCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
aW5kZXggZjgwYmQ0ZTgxMWNiLi41ZGUxMDVlODJjMzIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtMTQ5
MCw2ICsxNDkwLDggQEAgc3RhdGljIHZvaWQgdWZzaGNkX3VuZ2F0ZV93b3JrKHN0cnVjdCB3b3Jr
X3N0cnVjdCAqd29yaykNCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3Rf
bG9jaywgZmxhZ3MpOw0KIAl1ZnNoY2Rfc2V0dXBfY2xvY2tzKGhiYSwgdHJ1ZSk7DQogDQorCXVm
c2hjZF9lbmFibGVfaXJxKGhiYSk7DQorDQogCS8qIEV4aXQgZnJvbSBoaWJlcm44ICovDQogCWlm
ICh1ZnNoY2RfY2FuX2hpYmVybjhfZHVyaW5nX2dhdGluZyhoYmEpKSB7DQogCQkvKiBQcmV2ZW50
IGdhdGluZyBpbiB0aGlzIHBhdGggKi8NCkBAIC0xNjM2LDYgKzE2MzgsOCBAQCBzdGF0aWMgdm9p
ZCB1ZnNoY2RfZ2F0ZV93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAJCXVmc2hjZF9z
ZXRfbGlua19oaWJlcm44KGhiYSk7DQogCX0NCiANCisJdWZzaGNkX2Rpc2FibGVfaXJxKGhiYSk7
DQorDQogCWlmICghdWZzaGNkX2lzX2xpbmtfYWN0aXZlKGhiYSkpDQogCQl1ZnNoY2Rfc2V0dXBf
Y2xvY2tzKGhiYSwgZmFsc2UpOw0KIAllbHNlDQotLSANCjIuMTguMA0K

