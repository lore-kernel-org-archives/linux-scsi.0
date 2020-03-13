Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D2AC2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 512502074C
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ty2H8F+2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCMJBr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 05:01:47 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:50531 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbgCMJBc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 05:01:32 -0400
X-UUID: df688978c2904f0db6979843b930e034-20200313
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=I8phTj8vSF1fe+J716x8hj/ZioJ6jrLjTdm6bhX9zHs=;
        b=Ty2H8F+2rogx+NE+I2bKD19DQK/GCxhnO0RWBV6Wzh2V5EFix6vCOLRVDLHvmORA0YjWkifbnPJiESwxLHotU7T67+q2ArbNR67oYrO9Ub3Dxk5wJEeVrSkyrOYALDz3RI7akiqbpN2tw0WeSdJ6beIBCHbRsUosI27RXEi0P9A=;
X-UUID: df688978c2904f0db6979843b930e034-20200313
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 658710697; Fri, 13 Mar 2020 17:01:22 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 13 Mar 2020 16:59:51 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 13 Mar 2020 17:00:32 +0800
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
Subject: [PATCH v4 2/8] scsi: ufs: remove init_prefetch_data in struct ufs_hba
Date:   Fri, 13 Mar 2020 17:00:57 +0800
Message-ID: <20200313090103.15390-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200313090103.15390-1-stanley.chu@mediatek.com>
References: <20200313090103.15390-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 5C00A21E5443A66BB293CDCB1977EABB39E0836C01EAB006CF04BE5D27D6568C2000:8
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
b3JhLm9yZz4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAxNSArKysrKystLS0t
LS0tLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIHwgMTEgLS0tLS0tLS0tLS0NCiAyIGZp
bGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
Yw0KaW5kZXggMzE0ZTgwOGIwZDRlLi5iNDk4OGI5ZWUzNmMgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAt
NjUwMSw2ICs2NTAxLDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2luaXRfaWNjX2xldmVscyhzdHJ1
Y3QgdWZzX2hiYSAqaGJhKQ0KIHsNCiAJaW50IHJldDsNCiAJaW50IGJ1ZmZfbGVuID0gaGJhLT5k
ZXNjX3NpemUucHdyX2Rlc2M7DQorCXUzMiBpY2NfbGV2ZWw7DQogCXU4ICpkZXNjX2J1ZjsNCiAN
CiAJZGVzY19idWYgPSBrbWFsbG9jKGJ1ZmZfbGVuLCBHRlBfS0VSTkVMKTsNCkBAIC02NTE2LDIx
ICs2NTE3LDE3IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9pbml0X2ljY19sZXZlbHMoc3RydWN0IHVm
c19oYmEgKmhiYSkNCiAJCWdvdG8gb3V0Ow0KIAl9DQogDQotCWhiYS0+aW5pdF9wcmVmZXRjaF9k
YXRhLmljY19sZXZlbCA9DQotCQkJdWZzaGNkX2ZpbmRfbWF4X3N1cF9hY3RpdmVfaWNjX2xldmVs
KGhiYSwNCi0JCQlkZXNjX2J1ZiwgYnVmZl9sZW4pOw0KLQlkZXZfZGJnKGhiYS0+ZGV2LCAiJXM6
IHNldHRpbmcgaWNjX2xldmVsIDB4JXgiLA0KLQkJCV9fZnVuY19fLCBoYmEtPmluaXRfcHJlZmV0
Y2hfZGF0YS5pY2NfbGV2ZWwpOw0KKwlpY2NfbGV2ZWwgPQ0KKwkJdWZzaGNkX2ZpbmRfbWF4X3N1
cF9hY3RpdmVfaWNjX2xldmVsKGhiYSwgZGVzY19idWYsIGJ1ZmZfbGVuKTsNCisJZGV2X2RiZyho
YmEtPmRldiwgIiVzOiBzZXR0aW5nIGljY19sZXZlbCAweCV4IiwJX19mdW5jX18sIGljY19sZXZl
bCk7DQogDQogCXJldCA9IHVmc2hjZF9xdWVyeV9hdHRyX3JldHJ5KGhiYSwgVVBJVV9RVUVSWV9P
UENPREVfV1JJVEVfQVRUUiwNCi0JCVFVRVJZX0FUVFJfSUROX0FDVElWRV9JQ0NfTFZMLCAwLCAw
LA0KLQkJJmhiYS0+aW5pdF9wcmVmZXRjaF9kYXRhLmljY19sZXZlbCk7DQorCQlRVUVSWV9BVFRS
X0lETl9BQ1RJVkVfSUNDX0xWTCwgMCwgMCwgJmljY19sZXZlbCk7DQogDQogCWlmIChyZXQpDQog
CQlkZXZfZXJyKGhiYS0+ZGV2LA0KIAkJCSIlczogRmFpbGVkIGNvbmZpZ3VyaW5nIGJBY3RpdmVJ
Q0NMZXZlbCA9ICVkIHJldCA9ICVkIiwNCi0JCQlfX2Z1bmNfXywgaGJhLT5pbml0X3ByZWZldGNo
X2RhdGEuaWNjX2xldmVsICwgcmV0KTsNCi0NCisJCQlfX2Z1bmNfXywgaWNjX2xldmVsLCByZXQp
Ow0KIG91dDoNCiAJa2ZyZWUoZGVzY19idWYpOw0KIH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggNWMxMDc3
NzE1NGZjLi41Y2Y3OWQyMzE5YTYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtNDAyLDE1ICs0MDIsNiBA
QCBzdHJ1Y3QgdWZzX2Nsa19zY2FsaW5nIHsNCiAJYm9vbCBpc19zdXNwZW5kZWQ7DQogfTsNCiAN
Ci0vKioNCi0gKiBzdHJ1Y3QgdWZzX2luaXRfcHJlZmV0Y2ggLSBjb250YWlucyBkYXRhIHRoYXQg
aXMgcHJlLWZldGNoZWQgb25jZSBkdXJpbmcNCi0gKiBpbml0aWFsaXphdGlvbg0KLSAqIEBpY2Nf
bGV2ZWw6IGljYyBsZXZlbCB3aGljaCB3YXMgcmVhZCBkdXJpbmcgaW5pdGlhbGl6YXRpb24NCi0g
Ki8NCi1zdHJ1Y3QgdWZzX2luaXRfcHJlZmV0Y2ggew0KLQl1MzIgaWNjX2xldmVsOw0KLX07DQot
DQogI2RlZmluZSBVRlNfRVJSX1JFR19ISVNUX0xFTkdUSCA4DQogLyoqDQogICogc3RydWN0IHVm
c19lcnJfcmVnX2hpc3QgLSBrZWVwcyBoaXN0b3J5IG9mIGVycm9ycw0KQEAgLTU0MSw3ICs1MzIs
NiBAQCBlbnVtIHVmc2hjZF9xdWlya3Mgew0KICAqIEBpbnRyX21hc2s6IEludGVycnVwdCBNYXNr
IEJpdHMNCiAgKiBAZWVfY3RybF9tYXNrOiBFeGNlcHRpb24gZXZlbnQgY29udHJvbCBtYXNrDQog
ICogQGlzX3Bvd2VyZWQ6IGZsYWcgdG8gY2hlY2sgaWYgSEJBIGlzIHBvd2VyZWQNCi0gKiBAaW5p
dF9wcmVmZXRjaF9kYXRhOiBkYXRhIHByZS1mZXRjaGVkIGR1cmluZyBpbml0aWFsaXphdGlvbg0K
ICAqIEBlaF93b3JrOiBXb3JrZXIgdG8gaGFuZGxlIFVGUyBlcnJvcnMgdGhhdCByZXF1aXJlIHMv
dyBhdHRlbnRpb24NCiAgKiBAZWVoX3dvcms6IFdvcmtlciB0byBoYW5kbGUgZXhjZXB0aW9uIGV2
ZW50cw0KICAqIEBlcnJvcnM6IEhCQSBlcnJvcnMNCkBAIC02MjcsNyArNjE3LDYgQEAgc3RydWN0
IHVmc19oYmEgew0KIAl1MzIgaW50cl9tYXNrOw0KIAl1MTYgZWVfY3RybF9tYXNrOw0KIAlib29s
IGlzX3Bvd2VyZWQ7DQotCXN0cnVjdCB1ZnNfaW5pdF9wcmVmZXRjaCBpbml0X3ByZWZldGNoX2Rh
dGE7DQogDQogCS8qIFdvcmsgUXVldWVzICovDQogCXN0cnVjdCB3b3JrX3N0cnVjdCBlaF93b3Jr
Ow0KLS0gDQoyLjE4LjANCg==

