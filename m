Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D907DC2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC68A2077C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:08:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Asg5uidi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390333AbgAXPIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 10:08:10 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:1537 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390222AbgAXPIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 10:08:01 -0500
X-UUID: 0b5789e018684a3e996afe6e10b09d57-20200124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=nmiAzrKgD/bdvC/COaVLhsa4iiJmtILGj/E1/yJKpsg=;
        b=Asg5uidiy5Y0Rf+3o1xMmCsU2p6lr4tGw9jt0PcGdwklZlXpkmHHepMv2nrlSTciyIi8xexhO6ZiW6bD2dBlI9FRxTQbcW4kmJOH+5dsjvemZf4hU5Tm6/A7RwRoTN0rQqYWN4BEofkELVVMa7X7xC1wqoTdQI6K+lpmIgp+13Q=;
X-UUID: 0b5789e018684a3e996afe6e10b09d57-20200124
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1168101450; Fri, 24 Jan 2020 23:07:47 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 23:06:39 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 Jan 2020 23:07:16 +0800
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
Subject: [PATCH v2 1/5] scsi: ufs-mediatek: ensure UniPro is not powered down before linkup
Date:   Fri, 24 Jan 2020 23:07:39 +0800
Message-ID: <20200124150743.15110-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200124150743.15110-1-stanley.chu@mediatek.com>
References: <20200124150743.15110-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 1F59915D745A3D88C912CB29D712BF7BB3D21E6AD68062AA4C20CE86CEA718A92000:8
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

