Return-Path: <SRS0=J5Rw=3S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B2A6C33CB2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 07:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24DE420708
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 07:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OyQtnys1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgA2HjK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jan 2020 02:39:10 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:40771 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726043AbgA2HjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2020 02:39:10 -0500
X-UUID: 926de0fe0e604bbbbac8d22a474ad6c1-20200129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=nmiAzrKgD/bdvC/COaVLhsa4iiJmtILGj/E1/yJKpsg=;
        b=OyQtnys1ls0nL2l41osZ0vV6T01F1Sz8CrfcLpdd+RT7xXXIOnB1shygncGD1yRKi8UXIfx1zgtcRI3eFv15WaVZzBd1mmv9/bgPj3aNDK+T4RAk4f4kskCESc2kJOs8VQ7CJjtvt1tBXgDZi6jTsMqJJIMWzg6dmsAYYcAZsNk=;
X-UUID: 926de0fe0e604bbbbac8d22a474ad6c1-20200129
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1114575024; Wed, 29 Jan 2020 15:39:05 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 29 Jan 2020 15:38:25 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 29 Jan 2020 15:39:12 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>
CC:     <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 1/4] scsi: ufs-mediatek: ensure UniPro is not powered down before linkup
Date:   Wed, 29 Jan 2020 15:38:59 +0800
Message-ID: <20200129073902.5786-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200129073902.5786-1-stanley.chu@mediatek.com>
References: <20200129073902.5786-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWVkaWFUZWsgQ2hpcHNldHMgY2FuIGVudGVyIHByb3ByaWV0YXJ5IFVuaVBybyBsb3ctcG93ZXIg
bW9kZSBkdXJpbmcNCnN1c3BlbmQgd2hpbGUgbGluayBpcyBpbiBoaWJlcm44IHN0YXRlLiBNYWtl
IHN1cmUgbGVhdmluZyBsb3ctcG93ZXINCm1vZGUgYmVmb3JlIGV2ZXJ5IGxpbmsgc3RhcnR1cCB0
byBwcmV2ZW50IGxvY2t1cCBpbiBhbnkgcG9zc2libGUgZXJyb3IgcmVjb3ZlcnkNCnBhdGguDQoN
CkluIHRoZSBzYW1lIHRpbWUsIHJlLWZhY3RvciByZWxhdGVkIGZ1bmNpdG9ucyB0byBpbXByb3Zl
IGNvZGUgcmVhZGFiaWxpdHkuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5
LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5j
IHwgMTkgKysrKysrKysrKy0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25z
KCspLCA5IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMt
bWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCmluZGV4IDUzZWFl
NWZlMmFkZS4uN2FjODM4Y2MxNWQxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMt
bWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTMw
LDYgKzMwLDExIEBADQogI2RlZmluZSB1ZnNfbXRrX2RldmljZV9yZXNldF9jdHJsKGhpZ2gsIHJl
cykgXA0KIAl1ZnNfbXRrX3NtYyhVRlNfTVRLX1NJUF9ERVZJQ0VfUkVTRVQsIGhpZ2gsIHJlcykN
CiANCisjZGVmaW5lIHVmc19tdGtfdW5pcHJvX3Bvd2VyZG93bihoYmEsIHBvd2VyZG93bikgXA0K
Kwl1ZnNoY2RfZG1lX3NldChoYmEsIFwNCisJCSAgICAgICBVSUNfQVJHX01JQl9TRUwoVlNfVU5J
UFJPUE9XRVJET1dOQ09OVFJPTCwgMCksIFwNCisJCSAgICAgICBwb3dlcmRvd24pDQorDQogc3Rh
dGljIHZvaWQgdWZzX210a19jZmdfdW5pcHJvX2NnKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wg
ZW5hYmxlKQ0KIHsNCiAJdTMyIHRtcDsNCkBAIC0yOTAsNiArMjk1LDggQEAgc3RhdGljIGludCB1
ZnNfbXRrX3ByZV9saW5rKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCWludCByZXQ7DQogCXUzMiB0
bXA7DQogDQorCXVmc19tdGtfdW5pcHJvX3Bvd2VyZG93bihoYmEsIDApOw0KKw0KIAkvKiBkaXNh
YmxlIGRlZXAgc3RhbGwgKi8NCiAJcmV0ID0gdWZzaGNkX2RtZV9nZXQoaGJhLCBVSUNfQVJHX01J
QihWU19TQVZFUE9XRVJDT05UUk9MKSwgJnRtcCk7DQogCWlmIChyZXQpDQpAQCAtMzkwLDkgKzM5
Nyw3IEBAIHN0YXRpYyBpbnQgdWZzX210a19saW5rX3NldF9ocG0oc3RydWN0IHVmc19oYmEgKmhi
YSkNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7DQogDQotCWVyciA9IHVmc2hjZF9kbWVfc2V0
KGhiYSwNCi0JCQkgICAgIFVJQ19BUkdfTUlCX1NFTChWU19VTklQUk9QT1dFUkRPV05DT05UUk9M
LCAwKSwNCi0JCQkgICAgIDApOw0KKwllcnIgPSB1ZnNfbXRrX3VuaXByb19wb3dlcmRvd24oaGJh
LCAwKTsNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7DQogDQpAQCAtNDEzLDE0ICs0MTgsMTAg
QEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc2V0X2xwbShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0K
IHsNCiAJaW50IGVycjsNCiANCi0JZXJyID0gdWZzaGNkX2RtZV9zZXQoaGJhLA0KLQkJCSAgICAg
VUlDX0FSR19NSUJfU0VMKFZTX1VOSVBST1BPV0VSRE9XTkNPTlRST0wsIDApLA0KLQkJCSAgICAg
MSk7DQorCWVyciA9IHVmc19tdGtfdW5pcHJvX3Bvd2VyZG93bihoYmEsIDEpOw0KIAlpZiAoZXJy
KSB7DQogCQkvKiBSZXN1bWUgVW5pUHJvIHN0YXRlIGZvciBmb2xsb3dpbmcgZXJyb3IgcmVjb3Zl
cnkgKi8NCi0JCXVmc2hjZF9kbWVfc2V0KGhiYSwNCi0JCQkgICAgICAgVUlDX0FSR19NSUJfU0VM
KFZTX1VOSVBST1BPV0VSRE9XTkNPTlRST0wsIDApLA0KLQkJCSAgICAgICAwKTsNCisJCXVmc19t
dGtfdW5pcHJvX3Bvd2VyZG93bihoYmEsIDApOw0KIAkJcmV0dXJuIGVycjsNCiAJfQ0KIA0KLS0g
DQoyLjE4LjANCg==

