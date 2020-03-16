Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E60C1975A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 03:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10E152071B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 03:42:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="epgJHSxv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgCPDm2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 23:42:28 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:9457 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729464AbgCPDm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2020 23:42:28 -0400
X-UUID: eebad8e251bb4b9085beefba94b385aa-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ikeM6USnofcLzLgmKP7G/9OPNmeuuC9DZraNBhJ4krE=;
        b=epgJHSxv2b78m4xwA7dhThN/L9Vuii2BndRZnsaVw1HnUEFnxO6rm5IB6oAncTfAtBMXcycoSnCzseJzYymPjcv+9Pc0CbmKbOXi2nt96h2qP8NHTBPKEbcoOQwRb9Q8Cz1HXiJeCvl5VcdE20JhvaRSgHPPNz+/boGHjcvViBU=;
X-UUID: eebad8e251bb4b9085beefba94b385aa-20200316
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 146795679; Mon, 16 Mar 2020 11:42:20 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 11:41:13 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 11:39:22 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.peter~sen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v5 2/8] scsi: ufs: remove init_prefetch_data in struct ufs_hba
Date:   Mon, 16 Mar 2020 11:42:12 +0800
Message-ID: <20200316034218.11914-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200316034218.11914-1-stanley.chu@mediatek.com>
References: <20200316034218.11914-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3RydWN0IGluaXRfcHJlZmV0Y2hfZGF0YSBjdXJyZW50bHkgaXMgdXNlZCBwcml2YXRlbHkgaW4N
CnVmc2hjZF9pbml0X2ljY19sZXZlbHMoKSwgdGh1cyBpdCBjYW4gYmUgcmVtb3ZlZCBmcm9tIHN0
cnVjdCB1ZnNfaGJhLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVA
bWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQtYnk6IEFzdXRvc2ggRGFzIDxhc3V0b3NoZEBjb2RlYXVy
b3JhLm9yZz4NClJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4N
Ci0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAxNSArKysrKystLS0tLS0tLS0NCiBk
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIHwgMTEgLS0tLS0tLS0tLS0NCiAyIGZpbGVzIGNoYW5n
ZWQsIDYgaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXgg
MzE0ZTgwOGIwZDRlLi5iNDk4OGI5ZWUzNmMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtNjUwMSw2ICs2
NTAxLDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2luaXRfaWNjX2xldmVscyhzdHJ1Y3QgdWZzX2hi
YSAqaGJhKQ0KIHsNCiAJaW50IHJldDsNCiAJaW50IGJ1ZmZfbGVuID0gaGJhLT5kZXNjX3NpemUu
cHdyX2Rlc2M7DQorCXUzMiBpY2NfbGV2ZWw7DQogCXU4ICpkZXNjX2J1ZjsNCiANCiAJZGVzY19i
dWYgPSBrbWFsbG9jKGJ1ZmZfbGVuLCBHRlBfS0VSTkVMKTsNCkBAIC02NTE2LDIxICs2NTE3LDE3
IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9pbml0X2ljY19sZXZlbHMoc3RydWN0IHVmc19oYmEgKmhi
YSkNCiAJCWdvdG8gb3V0Ow0KIAl9DQogDQotCWhiYS0+aW5pdF9wcmVmZXRjaF9kYXRhLmljY19s
ZXZlbCA9DQotCQkJdWZzaGNkX2ZpbmRfbWF4X3N1cF9hY3RpdmVfaWNjX2xldmVsKGhiYSwNCi0J
CQlkZXNjX2J1ZiwgYnVmZl9sZW4pOw0KLQlkZXZfZGJnKGhiYS0+ZGV2LCAiJXM6IHNldHRpbmcg
aWNjX2xldmVsIDB4JXgiLA0KLQkJCV9fZnVuY19fLCBoYmEtPmluaXRfcHJlZmV0Y2hfZGF0YS5p
Y2NfbGV2ZWwpOw0KKwlpY2NfbGV2ZWwgPQ0KKwkJdWZzaGNkX2ZpbmRfbWF4X3N1cF9hY3RpdmVf
aWNjX2xldmVsKGhiYSwgZGVzY19idWYsIGJ1ZmZfbGVuKTsNCisJZGV2X2RiZyhoYmEtPmRldiwg
IiVzOiBzZXR0aW5nIGljY19sZXZlbCAweCV4IiwJX19mdW5jX18sIGljY19sZXZlbCk7DQogDQog
CXJldCA9IHVmc2hjZF9xdWVyeV9hdHRyX3JldHJ5KGhiYSwgVVBJVV9RVUVSWV9PUENPREVfV1JJ
VEVfQVRUUiwNCi0JCVFVRVJZX0FUVFJfSUROX0FDVElWRV9JQ0NfTFZMLCAwLCAwLA0KLQkJJmhi
YS0+aW5pdF9wcmVmZXRjaF9kYXRhLmljY19sZXZlbCk7DQorCQlRVUVSWV9BVFRSX0lETl9BQ1RJ
VkVfSUNDX0xWTCwgMCwgMCwgJmljY19sZXZlbCk7DQogDQogCWlmIChyZXQpDQogCQlkZXZfZXJy
KGhiYS0+ZGV2LA0KIAkJCSIlczogRmFpbGVkIGNvbmZpZ3VyaW5nIGJBY3RpdmVJQ0NMZXZlbCA9
ICVkIHJldCA9ICVkIiwNCi0JCQlfX2Z1bmNfXywgaGJhLT5pbml0X3ByZWZldGNoX2RhdGEuaWNj
X2xldmVsICwgcmV0KTsNCi0NCisJCQlfX2Z1bmNfXywgaWNjX2xldmVsLCByZXQpOw0KIG91dDoN
CiAJa2ZyZWUoZGVzY19idWYpOw0KIH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggNWMxMDc3NzE1NGZjLi41
Y2Y3OWQyMzE5YTYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtNDAyLDE1ICs0MDIsNiBAQCBzdHJ1Y3Qg
dWZzX2Nsa19zY2FsaW5nIHsNCiAJYm9vbCBpc19zdXNwZW5kZWQ7DQogfTsNCiANCi0vKioNCi0g
KiBzdHJ1Y3QgdWZzX2luaXRfcHJlZmV0Y2ggLSBjb250YWlucyBkYXRhIHRoYXQgaXMgcHJlLWZl
dGNoZWQgb25jZSBkdXJpbmcNCi0gKiBpbml0aWFsaXphdGlvbg0KLSAqIEBpY2NfbGV2ZWw6IGlj
YyBsZXZlbCB3aGljaCB3YXMgcmVhZCBkdXJpbmcgaW5pdGlhbGl6YXRpb24NCi0gKi8NCi1zdHJ1
Y3QgdWZzX2luaXRfcHJlZmV0Y2ggew0KLQl1MzIgaWNjX2xldmVsOw0KLX07DQotDQogI2RlZmlu
ZSBVRlNfRVJSX1JFR19ISVNUX0xFTkdUSCA4DQogLyoqDQogICogc3RydWN0IHVmc19lcnJfcmVn
X2hpc3QgLSBrZWVwcyBoaXN0b3J5IG9mIGVycm9ycw0KQEAgLTU0MSw3ICs1MzIsNiBAQCBlbnVt
IHVmc2hjZF9xdWlya3Mgew0KICAqIEBpbnRyX21hc2s6IEludGVycnVwdCBNYXNrIEJpdHMNCiAg
KiBAZWVfY3RybF9tYXNrOiBFeGNlcHRpb24gZXZlbnQgY29udHJvbCBtYXNrDQogICogQGlzX3Bv
d2VyZWQ6IGZsYWcgdG8gY2hlY2sgaWYgSEJBIGlzIHBvd2VyZWQNCi0gKiBAaW5pdF9wcmVmZXRj
aF9kYXRhOiBkYXRhIHByZS1mZXRjaGVkIGR1cmluZyBpbml0aWFsaXphdGlvbg0KICAqIEBlaF93
b3JrOiBXb3JrZXIgdG8gaGFuZGxlIFVGUyBlcnJvcnMgdGhhdCByZXF1aXJlIHMvdyBhdHRlbnRp
b24NCiAgKiBAZWVoX3dvcms6IFdvcmtlciB0byBoYW5kbGUgZXhjZXB0aW9uIGV2ZW50cw0KICAq
IEBlcnJvcnM6IEhCQSBlcnJvcnMNCkBAIC02MjcsNyArNjE3LDYgQEAgc3RydWN0IHVmc19oYmEg
ew0KIAl1MzIgaW50cl9tYXNrOw0KIAl1MTYgZWVfY3RybF9tYXNrOw0KIAlib29sIGlzX3Bvd2Vy
ZWQ7DQotCXN0cnVjdCB1ZnNfaW5pdF9wcmVmZXRjaCBpbml0X3ByZWZldGNoX2RhdGE7DQogDQog
CS8qIFdvcmsgUXVldWVzICovDQogCXN0cnVjdCB3b3JrX3N0cnVjdCBlaF93b3JrOw0KLS0gDQoy
LjE4LjANCg==

