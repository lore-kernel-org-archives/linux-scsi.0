Return-Path: <SRS0=cGsx=6R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451A4C4724C
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 11:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 203D324958
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 11:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="p8d5mAuZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgECLer (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 May 2020 07:34:47 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:26994 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728250AbgECLef (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2020 07:34:35 -0400
X-UUID: d02627f33e2e48d6afb1057e4835c8bb-20200503
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=yiBt59pGPa5af3Xa1ETUCF0N23dyPxrRMpkQTA3FRn4=;
        b=p8d5mAuZGqRWsj8eL88U2oprcwtj7JoYw0Ly657R0GrIa3g08fursi+jehQW66+dTUjz1NQHpHXfjH2s7jgyyhGMwAQp90vlSQT84eulHyyDqNSkETMLaTRjs9QgMzPNz+D2zG5+rU24uCZKBIhyu9MvCuESVjV4rlMn01cRwQo=;
X-UUID: d02627f33e2e48d6afb1057e4835c8bb-20200503
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 318592110; Sun, 03 May 2020 19:34:32 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 3 May 2020 19:34:15 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 3 May 2020 19:34:15 +0800
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
Subject: [PATCH v5 0/8] scsi: ufs: support LU Dedicated buffer mode for WriteBooster
Date:   Sun, 3 May 2020 19:34:07 +0800
Message-ID: <20200503113415.21034-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 58E8FF7771C70D45612BE3D87281D2BCB3D15FDC75473F9B5857D265733F98992000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpUaGlzIHBhdGNoc2V0IGFkZHMgTFUgZGVkaWNhdGVkIGJ1ZmZlciBtb2RlIHN1cHBvcnQg
Zm9yIFdyaXRlQm9vc3Rlci4NCkluIHRoZSBtZWFud2hpbGUsIGVuYWJsZSBXcml0ZUJvb3N0ZXIg
Y2FwYWJpbGl0eSBvbiBNZWRpYVRlayBVRlMgcGxhdGZvcm1zLg0KDQp2NCAtPiB2NToNCiAgLSBD
aGVjayBMVU4gSUQgZm9yIGF2YWlsYWJsZSBXcml0ZUJvb3N0ZXIgYnVmZmVyIG9ubHkgZnJvbSAw
IHRvIDcgYWNjb3JkaW5nIHRvIHNwZWMgKEF2cmkgQWx0bWFuKQ0KICAtIFNraXAgY2hlY2tpbmcg
YW55IHBvc3NpYmxlIGVycm9ycyBmcm9tIHVmc2hjZF9yZWFkX3VuaXRfZGVzY19wYXJhbShoYmEs
IGx1biwgVU5JVF9ERVNDX1BBUkFNX1dCX0JVRl9BTExPQ19VTklUUykgaW4gdWZzaGNkX3diX3By
b2JlKCkgYW5kIGNoZWNrIHJldHVybmVkIGRfbHVfd2JfYnVmX2FsbG9jIChzaGFsbCBiZSB6ZXJv
IGlmIGVycm9yIGhhcHBlbnMpIChBdnJpIEFsdG1hbikNCg0KdjMgLT4gdjQ6DQogIC0gSW50cm9k
dWNlICJmaXh1cF9kZXZfcXVpcmtzIiB2b3BzIHRvIGFsbG93IHZlbmRvcnMgdG8gZml4IGFuZCBt
b2RpZnkgZGV2aWNlIHF1aXJrcywgYW5kIHByb3ZpZGUgYW4gaW5pdGlhbCB2ZW5kb3Itc3BlY2lm
aWMgZGV2aWNlIHF1aXJrIHRhYmxlIG9uIE1lZGlhVGVrIFVGUyBwbGF0Zm9ybXMNCiAgLSBBdm9p
ZCByZWx5aW5nIG9uIGNvbW1vbiBkZXZpY2UgcXVpcmsgdGFibGUgZm9yIHByZS0zLjEgVUZTIGRl
dmljZSB3aXRoIG5vbi1zdGFuZGFyZCBXcml0ZUJvb3N0ZXIgc3VwcG9ydCAoQ2FuIEd1bykNCiAg
LSBGaXggY29tbWVudHMgZm9yIHVmc2hjZF93Yl9wcm9iZSgpIChDYW4gR3VvKQ0KICAtIE1ha2Ug
dWZzaGNkX3diX2dldF9mbGFnX2luZGV4KCkgaW5saW5lIGFuZCBmaXggdWZzaGNkX2lzX3diX2Zs
YWdzKCkgKEF2cmkgQWx0bWFuKQ0KDQp2MiAtPiB2MzoNCiAgLSBJbnRyb2R1Y2UgYSBkZXZpY2Ug
cXVpcmsgdG8gc3VwcG9ydCBXcml0ZUJvb3N0ZXIgaW4gcHJlLTMuMSBVRlMgZGV2aWNlcyAoQXZy
aSBBbHRtYW4pDQogIC0gRml4IFdyaXRlQm9vc3RlciByZWxhdGVkIHN5c2ZzIG5vZGVzLiBOb3cg
YWxsIFdyaXRlQm9vc3RlciByZWxhdGVkIHN5c2ZzIG5vZGVzIGFyZSBzcGVjaWZpY2FsbHkgbWFw
cGVkIHRvIHRoZSBMVU4gd2l0aCBXcml0ZUJvb3N0ZXIgZW5hYmxlZCBpbiBMVSBEZWRpY2F0ZWQg
YnVmZmVyIG1vZGUgKEF2cmkgQWx0bWFuKQ0KDQp2MSAtPiB2MjoNCiAgLSBDaGFuZ2UgdGhlIGRl
ZmluaXRpb24gbmFtZSBvZiBXcml0ZUJvb3N0ZXIgYnVmZmVyIG1vZGUgdG8gY29ycmVzcG9uZCB0
byBzcGVjaWZpY2F0aW9uIChCZWFuIEh1bykNCiAgLSBBZGQgcGF0Y2ggIzU6ICJzY3NpOiB1ZnM6
IGNsZWFudXAgV3JpdGVCb29zdGVyIGZlYXR1cmUiDQoNClN0YW5sZXkgQ2h1ICg4KToNCiAgc2Nz
aTogdWZzOiBlbmFibGUgV3JpdGVCb29zdGVyIG9uIHNvbWUgcHJlLTMuMSBVRlMgZGV2aWNlcw0K
ICBzY3NpOiB1ZnM6IGludHJvZHVjZSBmaXh1cF9kZXZfcXVpcmtzIHZvcHMNCiAgc2NzaTogdWZz
OiBleHBvcnQgdWZzX2ZpeHVwX2RldmljZV9zZXR1cCgpIGZ1bmN0aW9uDQogIHNjc2k6IHVmcy1t
ZWRpYXRlazogYWRkIGZpeHVwX2Rldl9xdWlya3Mgdm9wcw0KICBzY3NpOiB1ZnM6IGFkZCAiaW5k
ZXgiIGluIHBhcmFtZXRlciBsaXN0IG9mIHVmc2hjZF9xdWVyeV9mbGFnKCkNCiAgc2NzaTogdWZz
OiBhZGQgTFUgRGVkaWNhdGVkIGJ1ZmZlciBtb2RlIHN1cHBvcnQgZm9yIFdyaXRlQm9vc3Rlcg0K
ICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGVuYWJsZSBXcml0ZUJvb3N0ZXIgY2FwYWJpbGl0eQ0KICBz
Y3NpOiB1ZnM6IGNsZWFudXAgV3JpdGVCb29zdGVyIGZlYXR1cmUNCg0KIGRyaXZlcnMvc2NzaS91
ZnMvdWZzLW1lZGlhdGVrLmMgfCAgMjUgKysrKy0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNm
cy5jICAgIHwgIDExICsrLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLmggICAgICAgICAgfCAgMTAg
KysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaCAgIHwgICA3ICsrDQogZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYyAgICAgICB8IDE1NiArKysrKysrKysrKysrKysrKysrKy0tLS0tLS0t
LS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAgICAgfCAgMjAgKysrLQ0KIDYgZmls
ZXMgY2hhbmdlZCwgMTY3IGluc2VydGlvbnMoKyksIDYyIGRlbGV0aW9ucygtKQ0KDQotLSANCjIu
MTguMA0K

