Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F4DC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 14:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 303CA2075D
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 14:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="apE8fI/q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgG1OLC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 10:11:02 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:7961 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730057AbgG1OLC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 10:11:02 -0400
X-UUID: c254afc30da74d48aec926f2773c279e-20200728
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=suEMosAXJcsVRBqEPCC9fdQP59XGs0hD3Jn+cHeYz6A=;
        b=apE8fI/qTpyi8svFmT4raknEZ4iQy/Wg/7sBZGW3hjb99/aLJwdS/ev7cadKXgbVgmbfEu2MyH1/UyK3R4eq2HYi9DWEoDAPYkx9U5uPTvvyzikmHgN3MkYdz1SPPPtkWIQwYlG0KqA3jqduKJsOovY5jL+RSIL/DpaI8mWbQQk=;
X-UUID: c254afc30da74d48aec926f2773c279e-20200728
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 37312028; Tue, 28 Jul 2020 22:10:57 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 28 Jul 2020 22:10:53 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Jul 2020 22:10:55 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1] scsi: ufs: Fix possible infinite loop in ufshcd_hold
Date:   Tue, 28 Jul 2020 22:10:55 +0800
Message-ID: <20200728141055.22160-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW4gdWZzaGNkX3N1c3BlbmQoKSwgYWZ0ZXIgY2xrLWdhdGluZyBpcyBzdXNwZW5kZWQgYW5kIGxp
bmsgaXMgc2V0DQphcyBIaWJlcm44IHN0YXRlLCB1ZnNoY2RfaG9sZCgpIGlzIHN0aWxsIHBvc3Np
Ymx5IGludm9rZWQgYmVmb3JlDQp1ZnNoY2Rfc3VzcGVuZCgpIHJldHVybnMuIEZvciBleGFtcGxl
LCBNZWRpYVRlaydzIHN1c3BlbmQgdm9wcyBtYXkNCmlzc3VlIFVJQyBjb21tYW5kcyB3aGljaCB3
b3VsZCBjYWxsIHVmc2hjZF9ob2xkKCkgZHVyaW5nIHRoZSBjb21tYW5kDQppc3N1aW5nIGZsb3cu
DQoNCk5vdyBpZiBVRlNIQ0RfQ0FQX0hJQkVSTjhfV0lUSF9DTEtfR0FUSU5HIGNhcGFiaWxpdHkg
aXMgZW5hYmxlZCwNCnRoZW4gdWZzaGNkX2hvbGQoKSBtYXkgZW50ZXIgaW5maW5pdGUgbG9vcHMg
YmVjYXVzZSB0aGVyZSBpcyBubw0KY2xrLXVuZ2F0aW5nIHdvcmsgaXMgc2NoZWR1bGVkIG9yIHBl
bmRpbmcuIEluIHRoaXMgY2FzZSwgdWZzaGNkX2hvbGQoKQ0Kc2hhbGwganVzdCBieXBhc3MsIGFu
ZCBrZWVwIHRoZSBsaW5rIGFzIEhpYmVybjggc3RhdGUuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5s
ZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpTaWduZWQtb2ZmLWJ5OiBBbmR5IFRl
bmcgPGFuZHkudGVuZ0BtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jIHwgNiArKysrKy0NCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggNTc3Y2MwZDc0ODdmLi4yNjdiMDJlMWFmZDYgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jDQpAQCAtMTU5Miw3ICsxNTkyLDExIEBAIGludCB1ZnNoY2RfaG9sZChzdHJ1
Y3QgdWZzX2hiYSAqaGJhLCBib29sIGFzeW5jKQ0KIAkJCQlicmVhazsNCiAJCQl9DQogCQkJc3Bp
bl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KLQkJCWZs
dXNoX3dvcmsoJmhiYS0+Y2xrX2dhdGluZy51bmdhdGVfd29yayk7DQorCQkJcmMgPSBmbHVzaF93
b3JrKCZoYmEtPmNsa19nYXRpbmcudW5nYXRlX3dvcmspOw0KKwkJCWlmIChoYmEtPmNsa19nYXRp
bmcuaXNfc3VzcGVuZGVkICYmICFyYykgew0KKwkJCQlyYyA9IDA7DQorCQkJCWdvdG8gb3V0Ow0K
KwkJCX0NCiAJCQlzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3Mp
Ow0KIAkJCWdvdG8gc3RhcnQ7DQogCQl9DQotLSANCjIuMTguMA0K

