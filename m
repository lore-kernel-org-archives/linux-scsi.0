Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C543EC35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3A342085B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:21:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fjBQFkGz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgEHCVs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:21:48 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:50954 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726509AbgEHCVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:21:47 -0400
X-UUID: 000c8440082948ee9808af89e4e1892e-20200508
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=zRDV+nMJZju2Nz0GD4xrSA5VNChTtoX/HXJwFCo41GE=;
        b=fjBQFkGzvIu0HQaMIVsnW/iKoKBI6uKL3r7jfEDq0tg1eBs50RIApFU8S3JNW4wKMehmBwxA7HYlyoyMf0Omc95Z6B2NznXJU3dCGkPavoca+YmXey6kJrNFujHyNGbnd4zw6748nBQo6aBKulFJ9tEg04Vcfxbv4ZyC1i1N8Zs=;
X-UUID: 000c8440082948ee9808af89e4e1892e-20200508
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1733821216; Fri, 08 May 2020 10:21:44 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 8 May 2020 10:21:42 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 10:21:42 +0800
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
Subject: [PATCH v7 3/8] scsi: ufs: export ufs_fixup_device_setup() function
Date:   Fri, 8 May 2020 10:21:36 +0800
Message-ID: <20200508022141.10783-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200508022141.10783-1-stanley.chu@mediatek.com>
References: <20200508022141.10783-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: B919A3F5E5184E2B74E419CEC572B781576F3993398EA0C2CC1F1FB7CE8406842000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RXhwb3J0IHVmc19maXh1cF9kZXZpY2Vfc2V0dXAoKSB0byBhbGxvdyB2ZW5kb3JzIHRvIHJlLXVz
ZSBpdCBmb3INCmZpeGluZyBkZXZpY2UgcXVyaWtzIG9uIHNwZWNpZmllZCBVRlMgaG9zdHMuDQoN
ClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpS
ZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQotLS0NCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgNyArKysrLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuaCB8IDEgKw0KIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IDhkODZkOWE2YTYyMi4uNjYzYWU4NDJlYTlhIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYw0KQEAgLTY4MzgsMTIgKzY4MzgsMTIgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3di
X3Byb2JlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHU4ICpkZXNjX2J1ZikNCiAJaGJhLT5jYXBzICY9
IH5VRlNIQ0RfQ0FQX1dCX0VOOw0KIH0NCiANCi1zdGF0aWMgdm9pZCB1ZnNoY2RfZml4dXBfZGV2
X3F1aXJrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KK3ZvaWQgdWZzaGNkX2ZpeHVwX2Rldl9xdWly
a3Moc3RydWN0IHVmc19oYmEgKmhiYSwgc3RydWN0IHVmc19kZXZfZml4ICpmaXh1cHMpDQogew0K
IAlzdHJ1Y3QgdWZzX2Rldl9maXggKmY7DQogCXN0cnVjdCB1ZnNfZGV2X2luZm8gKmRldl9pbmZv
ID0gJmhiYS0+ZGV2X2luZm87DQogDQotCWZvciAoZiA9IHVmc19maXh1cHM7IGYtPnF1aXJrOyBm
KyspIHsNCisJZm9yIChmID0gZml4dXBzOyBmLT5xdWlyazsgZisrKSB7DQogCQlpZiAoKGYtPndt
YW51ZmFjdHVyZXJpZCA9PSBkZXZfaW5mby0+d21hbnVmYWN0dXJlcmlkIHx8DQogCQkgICAgIGYt
PndtYW51ZmFjdHVyZXJpZCA9PSBVRlNfQU5ZX1ZFTkRPUikgJiYNCiAJCSAgICAgKChkZXZfaW5m
by0+bW9kZWwgJiYNCkBAIC02ODUyLDExICs2ODUyLDEyIEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9m
aXh1cF9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCQkJaGJhLT5kZXZfcXVpcmtz
IHw9IGYtPnF1aXJrOw0KIAl9DQogfQ0KK0VYUE9SVF9TWU1CT0xfR1BMKHVmc2hjZF9maXh1cF9k
ZXZfcXVpcmtzKTsNCiANCiBzdGF0aWMgdm9pZCB1ZnNfZml4dXBfZGV2aWNlX3NldHVwKHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQogew0KIAkvKiBmaXggYnkgZ2VuZXJhbCBxdWlyayB0YWJsZSAqLw0K
LQl1ZnNoY2RfZml4dXBfZGV2X3F1aXJrcyhoYmEpOw0KKwl1ZnNoY2RfZml4dXBfZGV2X3F1aXJr
cyhoYmEsIHVmc19maXh1cHMpOw0KIA0KIAkvKiBhbGxvdyB2ZW5kb3JzIHRvIGZpeCBxdWlya3Mg
Ki8NCiAJdWZzaGNkX3ZvcHNfZml4dXBfZGV2X3F1aXJrcyhoYmEpOw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQppbmRl
eCA4OTczMzhiYTY3YWEuLjRkMjk2YWNhZGQ2ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCkBAIC05NTIsNiAr
OTUyLDcgQEAgaW50IHVmc2hjZF9xdWVyeV9mbGFnKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0g
cXVlcnlfb3Bjb2RlIG9wY29kZSwNCiANCiB2b2lkIHVmc2hjZF9hdXRvX2hpYmVybjhfZW5hYmxl
KHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KIHZvaWQgdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUo
c3RydWN0IHVmc19oYmEgKmhiYSwgdTMyIGFoaXQpOw0KK3ZvaWQgdWZzaGNkX2ZpeHVwX2Rldl9x
dWlya3Moc3RydWN0IHVmc19oYmEgKmhiYSwgc3RydWN0IHVmc19kZXZfZml4ICpmaXh1cHMpOw0K
ICNkZWZpbmUgU0RfQVNDSUlfU1REIHRydWUNCiAjZGVmaW5lIFNEX1JBVyBmYWxzZQ0KIGludCB1
ZnNoY2RfcmVhZF9zdHJpbmdfZGVzYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1OCBkZXNjX2luZGV4
LA0KLS0gDQoyLjE4LjANCg==

