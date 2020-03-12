Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497C1C1975A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 13:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B2B720737
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 13:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Jh6a//8x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgCLNYD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 09:24:03 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:10187 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727369AbgCLNYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 09:24:02 -0400
X-UUID: 8021217f0ff9463cb6d3ae243eccf7e7-20200312
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=TJOwfXCdxtKskhQqIq5Rx4gC5ikFILpJpMDFmmmJALg=;
        b=Jh6a//8x1NoJLq+RiSEgiUaLsW2tYqhl+a9nJbxkxYOdtGhA/MraDQOeFjVhK0c1m9hSLadxi8D3GCAdL+YumjTEZL5aN/jyuj2J+IBfEH+N2IxUa4ePQiicV4csxvftQYj1Uk8yv+IbjY3n0j6u9fU2RVA5zGctXegmMe5VV70=;
X-UUID: 8021217f0ff9463cb6d3ae243eccf7e7-20200312
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1415420077; Thu, 12 Mar 2020 21:23:53 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Mar 2020 21:21:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Mar 2020 21:21:02 +0800
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
Subject: [PATCH v3 2/8] scsi: ufs: remove init_prefetch_data in struct ufs_hba
Date:   Thu, 12 Mar 2020 21:23:44 +0800
Message-ID: <20200312132350.18061-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200312132350.18061-1-stanley.chu@mediatek.com>
References: <20200312132350.18061-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 5B748EC8B741F4CA0DA94897A506B5A45813883239713FCE4DF844E1C7F2E27E2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3RydWN0IGluaXRfcHJlZmV0Y2hfZGF0YSBjdXJyZW50bHkgaXMgdXNlZCBwcml2YXRlbHkgaW4N
CnVmc2hjZF9pbml0X2ljY19sZXZlbHMoKSwgdGh1cyBpdCBjYW4gYmUgcmVtb3ZlZCBmcm9tIHN0
cnVjdCB1ZnNfaGJhLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVA
bWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDE1ICsrKysr
Ky0tLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCAxMSAtLS0tLS0tLS0tLQ0K
IDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQppbmRleCAzMTRlODA4YjBkNGUuLmI0OTg4YjllZTM2YyAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMN
CkBAIC02NTAxLDYgKzY1MDEsNyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2RfaW5pdF9pY2NfbGV2ZWxz
KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAlpbnQgcmV0Ow0KIAlpbnQgYnVmZl9sZW4gPSBo
YmEtPmRlc2Nfc2l6ZS5wd3JfZGVzYzsNCisJdTMyIGljY19sZXZlbDsNCiAJdTggKmRlc2NfYnVm
Ow0KIA0KIAlkZXNjX2J1ZiA9IGttYWxsb2MoYnVmZl9sZW4sIEdGUF9LRVJORUwpOw0KQEAgLTY1
MTYsMjEgKzY1MTcsMTcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2luaXRfaWNjX2xldmVscyhzdHJ1
Y3QgdWZzX2hiYSAqaGJhKQ0KIAkJZ290byBvdXQ7DQogCX0NCiANCi0JaGJhLT5pbml0X3ByZWZl
dGNoX2RhdGEuaWNjX2xldmVsID0NCi0JCQl1ZnNoY2RfZmluZF9tYXhfc3VwX2FjdGl2ZV9pY2Nf
bGV2ZWwoaGJhLA0KLQkJCWRlc2NfYnVmLCBidWZmX2xlbik7DQotCWRldl9kYmcoaGJhLT5kZXYs
ICIlczogc2V0dGluZyBpY2NfbGV2ZWwgMHgleCIsDQotCQkJX19mdW5jX18sIGhiYS0+aW5pdF9w
cmVmZXRjaF9kYXRhLmljY19sZXZlbCk7DQorCWljY19sZXZlbCA9DQorCQl1ZnNoY2RfZmluZF9t
YXhfc3VwX2FjdGl2ZV9pY2NfbGV2ZWwoaGJhLCBkZXNjX2J1ZiwgYnVmZl9sZW4pOw0KKwlkZXZf
ZGJnKGhiYS0+ZGV2LCAiJXM6IHNldHRpbmcgaWNjX2xldmVsIDB4JXgiLAlfX2Z1bmNfXywgaWNj
X2xldmVsKTsNCiANCiAJcmV0ID0gdWZzaGNkX3F1ZXJ5X2F0dHJfcmV0cnkoaGJhLCBVUElVX1FV
RVJZX09QQ09ERV9XUklURV9BVFRSLA0KLQkJUVVFUllfQVRUUl9JRE5fQUNUSVZFX0lDQ19MVkws
IDAsIDAsDQotCQkmaGJhLT5pbml0X3ByZWZldGNoX2RhdGEuaWNjX2xldmVsKTsNCisJCVFVRVJZ
X0FUVFJfSUROX0FDVElWRV9JQ0NfTFZMLCAwLCAwLCAmaWNjX2xldmVsKTsNCiANCiAJaWYgKHJl
dCkNCiAJCWRldl9lcnIoaGJhLT5kZXYsDQogCQkJIiVzOiBGYWlsZWQgY29uZmlndXJpbmcgYkFj
dGl2ZUlDQ0xldmVsID0gJWQgcmV0ID0gJWQiLA0KLQkJCV9fZnVuY19fLCBoYmEtPmluaXRfcHJl
ZmV0Y2hfZGF0YS5pY2NfbGV2ZWwgLCByZXQpOw0KLQ0KKwkJCV9fZnVuY19fLCBpY2NfbGV2ZWws
IHJldCk7DQogb3V0Og0KIAlrZnJlZShkZXNjX2J1Zik7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQppbmRleCA1
YzEwNzc3MTU0ZmMuLjVjZjc5ZDIzMTlhNiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCkBAIC00MDIsMTUgKzQw
Miw2IEBAIHN0cnVjdCB1ZnNfY2xrX3NjYWxpbmcgew0KIAlib29sIGlzX3N1c3BlbmRlZDsNCiB9
Ow0KIA0KLS8qKg0KLSAqIHN0cnVjdCB1ZnNfaW5pdF9wcmVmZXRjaCAtIGNvbnRhaW5zIGRhdGEg
dGhhdCBpcyBwcmUtZmV0Y2hlZCBvbmNlIGR1cmluZw0KLSAqIGluaXRpYWxpemF0aW9uDQotICog
QGljY19sZXZlbDogaWNjIGxldmVsIHdoaWNoIHdhcyByZWFkIGR1cmluZyBpbml0aWFsaXphdGlv
bg0KLSAqLw0KLXN0cnVjdCB1ZnNfaW5pdF9wcmVmZXRjaCB7DQotCXUzMiBpY2NfbGV2ZWw7DQot
fTsNCi0NCiAjZGVmaW5lIFVGU19FUlJfUkVHX0hJU1RfTEVOR1RIIDgNCiAvKioNCiAgKiBzdHJ1
Y3QgdWZzX2Vycl9yZWdfaGlzdCAtIGtlZXBzIGhpc3Rvcnkgb2YgZXJyb3JzDQpAQCAtNTQxLDcg
KzUzMiw2IEBAIGVudW0gdWZzaGNkX3F1aXJrcyB7DQogICogQGludHJfbWFzazogSW50ZXJydXB0
IE1hc2sgQml0cw0KICAqIEBlZV9jdHJsX21hc2s6IEV4Y2VwdGlvbiBldmVudCBjb250cm9sIG1h
c2sNCiAgKiBAaXNfcG93ZXJlZDogZmxhZyB0byBjaGVjayBpZiBIQkEgaXMgcG93ZXJlZA0KLSAq
IEBpbml0X3ByZWZldGNoX2RhdGE6IGRhdGEgcHJlLWZldGNoZWQgZHVyaW5nIGluaXRpYWxpemF0
aW9uDQogICogQGVoX3dvcms6IFdvcmtlciB0byBoYW5kbGUgVUZTIGVycm9ycyB0aGF0IHJlcXVp
cmUgcy93IGF0dGVudGlvbg0KICAqIEBlZWhfd29yazogV29ya2VyIHRvIGhhbmRsZSBleGNlcHRp
b24gZXZlbnRzDQogICogQGVycm9yczogSEJBIGVycm9ycw0KQEAgLTYyNyw3ICs2MTcsNiBAQCBz
dHJ1Y3QgdWZzX2hiYSB7DQogCXUzMiBpbnRyX21hc2s7DQogCXUxNiBlZV9jdHJsX21hc2s7DQog
CWJvb2wgaXNfcG93ZXJlZDsNCi0Jc3RydWN0IHVmc19pbml0X3ByZWZldGNoIGluaXRfcHJlZmV0
Y2hfZGF0YTsNCiANCiAJLyogV29yayBRdWV1ZXMgKi8NCiAJc3RydWN0IHdvcmtfc3RydWN0IGVo
X3dvcms7DQotLSANCjIuMTguMA0K

