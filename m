Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8769AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 02:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66D242078E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 02:40:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="b8+a7zcp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgG2Ckn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 22:40:43 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:53663 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730407AbgG2Ckn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 22:40:43 -0400
X-UUID: d0e9ccca0dd34c9398f8429e711107a5-20200729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=bsmSl6GhvNafW+/QxrJVytLlWNDF54Z01VPoq2J5LuA=;
        b=b8+a7zcpU/1y3tgBJKc203MtEZGFdOe7ADIeUvjKRASg9p5lbb8SRMfSP7rEukGyFjhNnN1fdgpCwXhnHA5v7DO0Bs1o+zi9y5mDhQtzlkH5IJa49waHaGUv6+SKG+9LPR8ga+xZoDIOr3nm5LSozKbgofO9dcj/GYxVbCZ0XTg=;
X-UUID: d0e9ccca0dd34c9398f8429e711107a5-20200729
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1933251817; Wed, 29 Jul 2020 10:40:40 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Jul 2020 10:40:37 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 10:40:38 +0800
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
Subject: [PATCH v2] scsi: ufs: Fix possible infinite loop in ufshcd_hold
Date:   Wed, 29 Jul 2020 10:40:37 +0800
Message-ID: <20200729024037.23105-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 6DB1F27E1A9D8E1C51B5FB23D8BB069EFE1E31E88C79BDBB30C332B2C85C741A2000:8
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
YmVjYXVzZSB0aGVyZSBpcyBubw0KY2xrLXVuZ2F0aW5nIHdvcmsgc2NoZWR1bGVkIG9yIHBlbmRp
bmcuIEluIHRoaXMgY2FzZSwgdWZzaGNkX2hvbGQoKQ0Kc2hhbGwganVzdCBieXBhc3MsIGFuZCBr
ZWVwIHRoZSBsaW5rIGFzIEhpYmVybjggc3RhdGUuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkg
Q2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpTaWduZWQtb2ZmLWJ5OiBBbmR5IFRlbmcg
PGFuZHkudGVuZ0BtZWRpYXRlay5jb20+DQoNCi0tLQ0KDQpDaGFuZ2VzIHNpbmNlIHYxOg0KLSBG
aXggcmV0dXJuIHZhbHVlOiBVc2UgdW5pcXVlIGJvb2wgdmFyaWFibGUgdG8gZ2V0IHRoZSByZXN1
bHQgb2YgZmx1c2hfd29yaygpLiBUaGNhbiBwcmV2ZW50IGluY29ycmVjdCByZXR1cm5lZCB2YWx1
ZSwgaS5lLiwgcmMsIGlmIGZsdXNoX3dvcmsoKSByZXR1cm5zIHRydWUNCi0gRml4IGNvbW1pdCBt
ZXNzYWdlDQoNCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA1ICsrKystDQogMSBm
aWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMN
CmluZGV4IDU3N2NjMGQ3NDg3Zi4uYWNiYTIyNzFjNWQzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTE1
NjEsNiArMTU2MSw3IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF91bmdhdGVfd29yayhzdHJ1Y3Qgd29y
a19zdHJ1Y3QgKndvcmspDQogaW50IHVmc2hjZF9ob2xkKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJv
b2wgYXN5bmMpDQogew0KIAlpbnQgcmMgPSAwOw0KKwlib29sIGZsdXNoX3Jlc3VsdDsNCiAJdW5z
aWduZWQgbG9uZyBmbGFnczsNCiANCiAJaWYgKCF1ZnNoY2RfaXNfY2xrZ2F0aW5nX2FsbG93ZWQo
aGJhKSkNCkBAIC0xNTkyLDcgKzE1OTMsOSBAQCBpbnQgdWZzaGNkX2hvbGQoc3RydWN0IHVmc19o
YmEgKmhiYSwgYm9vbCBhc3luYykNCiAJCQkJYnJlYWs7DQogCQkJfQ0KIAkJCXNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCi0JCQlmbHVzaF93b3Jr
KCZoYmEtPmNsa19nYXRpbmcudW5nYXRlX3dvcmspOw0KKwkJCWZsdXNoX3Jlc3VsdCA9IGZsdXNo
X3dvcmsoJmhiYS0+Y2xrX2dhdGluZy51bmdhdGVfd29yayk7DQorCQkJaWYgKGhiYS0+Y2xrX2dh
dGluZy5pc19zdXNwZW5kZWQgJiYgIWZsdXNoX3Jlc3VsdCkNCisJCQkJZ290byBvdXQ7DQogCQkJ
c3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCiAJCQlnb3Rv
IHN0YXJ0Ow0KIAkJfQ0KLS0gDQoyLjE4LjANCg==

