Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71E7C32771
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 06:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8E642077C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 06:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="V5Vm7bIk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbgAXGt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 01:49:58 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:1275 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730733AbgAXGtj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 01:49:39 -0500
X-UUID: 4cbe7cd87c4e49a98719101d13caea04-20200124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=r4uFNCZlrJfbAJ6zHc5lh0WBsNxu96UHiQ4PJMYHYz8=;
        b=V5Vm7bIkKPgkjZPA86djf7vhc3N01MAGvA5lFFUmR3BwIK17VzRzPC64K9t/jjk36K+bQP/i5Wg0xeKAV7EBgVJmjbBVpgh/31RqGRL0R+jAsQKNzVH3VPHwn4alSaQsOWNEYIyzUz4G7XYX7OEqTxUUNFGy+UAtGeM+c5N08OA=;
X-UUID: 4cbe7cd87c4e49a98719101d13caea04-20200124
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1671562585; Fri, 24 Jan 2020 14:49:31 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 14:48:24 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 Jan 2020 14:48:57 +0800
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
Subject: [PATCH v1 1/5] scsi: ufs-mediatek: ensure UniPro is not powered down before linkup
Date:   Fri, 24 Jan 2020 14:49:22 +0800
Message-ID: <20200124064926.29472-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200124064926.29472-1-stanley.chu@mediatek.com>
References: <20200124064926.29472-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: EE6B3AAFE2976FDE2B0D0A4B718E0322C10E6D114694D9985155B9BB79974CB92000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWVkaWF0ZWsgQ2hpcHNldHMgd2lsbCBlbnRlciBwcm9wcmlldGFyeSBVbmlQcm8gbG93LXBvd2Vy
IG1vZGUgZHVyaW5nDQpzdXNwZW5kIHdpdGggbGluayBzdGF0dXMgYXMgaGliZXJuOC4gTWFrZSBz
dXJlIGxlYXZpbmcgc3VjaCBsb3ctcG93ZXINCm1vZGUgYmVmb3JlIGxpbmt1cCB0byBhdm9pZCBh
bnkgcG9zc2libGUgcmVjb3ZlcnkgcGF0aC4NCg0KSW4gdGhlIHNhbWUgdGltZSwgcmUtZmFjdG9y
IHJlbGF0ZWQgZnVuY2l0b24gdG8gaW1wcm92ZSBjb2RlIHJlYWRhYmlsaXR5Lg0KDQpTaWduZWQt
b2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJp
dmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDE5ICsrKysrKysrKystLS0tLS0tLS0NCiAx
IGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jDQppbmRleCA1M2VhZTVmZTJhZGUuLjdhYzgzOGNjMTVkMSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0zMCw2ICszMCwxMSBAQA0KICNkZWZpbmUgdWZzX210
a19kZXZpY2VfcmVzZXRfY3RybChoaWdoLCByZXMpIFwNCiAJdWZzX210a19zbWMoVUZTX01US19T
SVBfREVWSUNFX1JFU0VULCBoaWdoLCByZXMpDQogDQorI2RlZmluZSB1ZnNfbXRrX3VuaXByb19w
b3dlcmRvd24oaGJhLCBwb3dlcmRvd24pIFwNCisJdWZzaGNkX2RtZV9zZXQoaGJhLCBcDQorCQkg
ICAgICAgVUlDX0FSR19NSUJfU0VMKFZTX1VOSVBST1BPV0VSRE9XTkNPTlRST0wsIDApLCBcDQor
CQkgICAgICAgcG93ZXJkb3duKQ0KKw0KIHN0YXRpYyB2b2lkIHVmc19tdGtfY2ZnX3VuaXByb19j
ZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIGVuYWJsZSkNCiB7DQogCXUzMiB0bXA7DQpAQCAt
MjkwLDYgKzI5NSw4IEBAIHN0YXRpYyBpbnQgdWZzX210a19wcmVfbGluayhzdHJ1Y3QgdWZzX2hi
YSAqaGJhKQ0KIAlpbnQgcmV0Ow0KIAl1MzIgdG1wOw0KIA0KKwl1ZnNfbXRrX3VuaXByb19wb3dl
cmRvd24oaGJhLCAwKTsNCisNCiAJLyogZGlzYWJsZSBkZWVwIHN0YWxsICovDQogCXJldCA9IHVm
c2hjZF9kbWVfZ2V0KGhiYSwgVUlDX0FSR19NSUIoVlNfU0FWRVBPV0VSQ09OVFJPTCksICZ0bXAp
Ow0KIAlpZiAocmV0KQ0KQEAgLTM5MCw5ICszOTcsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfbGlu
a19zZXRfaHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCWlmIChlcnIpDQogCQlyZXR1cm4gZXJy
Ow0KIA0KLQllcnIgPSB1ZnNoY2RfZG1lX3NldChoYmEsDQotCQkJICAgICBVSUNfQVJHX01JQl9T
RUwoVlNfVU5JUFJPUE9XRVJET1dOQ09OVFJPTCwgMCksDQotCQkJICAgICAwKTsNCisJZXJyID0g
dWZzX210a191bmlwcm9fcG93ZXJkb3duKGhiYSwgMCk7DQogCWlmIChlcnIpDQogCQlyZXR1cm4g
ZXJyOw0KIA0KQEAgLTQxMywxNCArNDE4LDEwIEBAIHN0YXRpYyBpbnQgdWZzX210a19saW5rX3Nl
dF9scG0oc3RydWN0IHVmc19oYmEgKmhiYSkNCiB7DQogCWludCBlcnI7DQogDQotCWVyciA9IHVm
c2hjZF9kbWVfc2V0KGhiYSwNCi0JCQkgICAgIFVJQ19BUkdfTUlCX1NFTChWU19VTklQUk9QT1dF
UkRPV05DT05UUk9MLCAwKSwNCi0JCQkgICAgIDEpOw0KKwllcnIgPSB1ZnNfbXRrX3VuaXByb19w
b3dlcmRvd24oaGJhLCAxKTsNCiAJaWYgKGVycikgew0KIAkJLyogUmVzdW1lIFVuaVBybyBzdGF0
ZSBmb3IgZm9sbG93aW5nIGVycm9yIHJlY292ZXJ5ICovDQotCQl1ZnNoY2RfZG1lX3NldChoYmEs
DQotCQkJICAgICAgIFVJQ19BUkdfTUlCX1NFTChWU19VTklQUk9QT1dFUkRPV05DT05UUk9MLCAw
KSwNCi0JCQkgICAgICAgMCk7DQorCQl1ZnNfbXRrX3VuaXByb19wb3dlcmRvd24oaGJhLCAwKTsN
CiAJCXJldHVybiBlcnI7DQogCX0NCiANCi0tIA0KMi4xOC4wDQo=

