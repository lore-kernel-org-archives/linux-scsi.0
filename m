Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503EEC47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C87021582
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:22:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pEp8gPDu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgEHCVs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:21:48 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:13439 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727029AbgEHCVs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:21:48 -0400
X-UUID: a506af475e3845449dabb6eb9572eee1-20200508
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=TR6ze+l1mfObKm1SdxCDQckW//z6/tKC6CTs29QI2bQ=;
        b=pEp8gPDuKul6gWPyLDCRhgeNlq+HDWKcuQwDOuA1JyxssOYEIzAcG4EFQCQ1Wi8iZ9SUNoPjc1e8OnKAJ75BSDsOWAC6emexRgmmpUG0O7ruTKgETaGLjBWvR0Zn3Qwhu27/8uh7s6R78AzgjgXR61oDt1n+v/GES+UzgcUQgj8=;
X-UUID: a506af475e3845449dabb6eb9572eee1-20200508
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1038069575; Fri, 08 May 2020 10:21:43 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 8 May 2020 10:21:41 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 10:21:41 +0800
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
Subject: [PATCH v7 0/8] scsi: ufs: support LU Dedicated buffer mode for WriteBooster
Date:   Fri, 8 May 2020 10:21:33 +0800
Message-ID: <20200508022141.10783-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpUaGlzIHBhdGNoc2V0IGFkZHMgTFUgZGVkaWNhdGVkIGJ1ZmZlciBtb2RlIHN1cHBvcnQg
Zm9yIFdyaXRlQm9vc3Rlci4NCkluIHRoZSBtZWFud2hpbGUsIGVuYWJsZSBXcml0ZUJvb3N0ZXIg
Y2FwYWJpbGl0eSBvbiBNZWRpYVRlayBVRlMgcGxhdGZvcm1zLg0KDQp2NiAtPiB2NzoNCiAgLSBB
ZGQgZGV2aWNlIGRlc2NyaXB0b3IgbGVuZ3RoIGNoZWNrIGluIHVmc2hjZF93Yl9wcm9iZSgpIGJh
Y2sgdG8gcHJldmVudCBvdXQtb2YtYm91bmRhcnkgYWNjZXNzIGluIHVmc2hjZF93Yl9wcm9iZSgp
DQogIC0gRml4IHRoZSBjaGVjayBvZiBkZXZpY2UgZGVzY3JpcHRvciBsZW5ndGggKEF2cmkgQWx0
bWFuKQ0KICAtIFByb3ZpZGUgYSBuZXcgdWZzX2ZpeHVwX2RldmljZV9zZXR1cCgpIGZ1bmN0aW9u
IHRvIHBhY2sgYm90aCBkZXZpY2UgZml4dXAgbWV0aG9kcyBieSBnZW5lcmFsIHF1aXJrIHRhYmxl
IGFuZCB2ZW5kb3Itc3BlY2lmaWMgd2F5IChBdnJpIEFsdG1hbikNCg0KdjUgLT4gdjY6DQogIC0g
UmVtb3ZlIGRldmljZSBkZXNjcmlwdG9yIGxlbmd0aCBjaGVjayBpbiB1ZnNoY2Rfd2JfcHJvYmUo
KQ0KDQp2NCAtPiB2NToNCiAgLSBDaGVjayBMVU4gSUQgZm9yIGF2YWlsYWJsZSBXcml0ZUJvb3N0
ZXIgYnVmZmVyIG9ubHkgZnJvbSAwIHRvIDcgYWNjb3JkaW5nIHRvIHNwZWMgKEF2cmkgQWx0bWFu
KQ0KICAtIFNraXAgY2hlY2tpbmcgYW55IHBvc3NpYmxlIGVycm9ycyBmcm9tIHVmc2hjZF9yZWFk
X3VuaXRfZGVzY19wYXJhbShoYmEsIGx1biwgVU5JVF9ERVNDX1BBUkFNX1dCX0JVRl9BTExPQ19V
TklUUykgaW4gdWZzaGNkX3diX3Byb2JlKCkgYW5kIGNoZWNrIHJldHVybmVkIGRfbHVfd2JfYnVm
X2FsbG9jIChzaGFsbCBiZSB6ZXJvIGlmIGVycm9yIGhhcHBlbnMpIChBdnJpIEFsdG1hbikNCg0K
djMgLT4gdjQ6DQogIC0gSW50cm9kdWNlICJmaXh1cF9kZXZfcXVpcmtzIiB2b3BzIHRvIGFsbG93
IHZlbmRvcnMgdG8gZml4IGFuZCBtb2RpZnkgZGV2aWNlIHF1aXJrcywgYW5kIHByb3ZpZGUgYW4g
aW5pdGlhbCB2ZW5kb3Itc3BlY2lmaWMgZGV2aWNlIHF1aXJrIHRhYmxlIG9uIE1lZGlhVGVrIFVG
UyBwbGF0Zm9ybXMNCiAgLSBBdm9pZCByZWx5aW5nIG9uIGNvbW1vbiBkZXZpY2UgcXVpcmsgdGFi
bGUgZm9yIHByZS0zLjEgVUZTIGRldmljZSB3aXRoIG5vbi1zdGFuZGFyZCBXcml0ZUJvb3N0ZXIg
c3VwcG9ydCAoQ2FuIEd1bykNCiAgLSBGaXggY29tbWVudHMgZm9yIHVmc2hjZF93Yl9wcm9iZSgp
IChDYW4gR3VvKQ0KICAtIE1ha2UgdWZzaGNkX3diX2dldF9mbGFnX2luZGV4KCkgaW5saW5lIGFu
ZCBmaXggdWZzaGNkX2lzX3diX2ZsYWdzKCkgKEF2cmkgQWx0bWFuKQ0KDQp2MiAtPiB2MzoNCiAg
LSBJbnRyb2R1Y2UgYSBkZXZpY2UgcXVpcmsgdG8gc3VwcG9ydCBXcml0ZUJvb3N0ZXIgaW4gcHJl
LTMuMSBVRlMgZGV2aWNlcyAoQXZyaSBBbHRtYW4pDQogIC0gRml4IFdyaXRlQm9vc3RlciByZWxh
dGVkIHN5c2ZzIG5vZGVzLiBOb3cgYWxsIFdyaXRlQm9vc3RlciByZWxhdGVkIHN5c2ZzIG5vZGVz
IGFyZSBzcGVjaWZpY2FsbHkgbWFwcGVkIHRvIHRoZSBMVU4gd2l0aCBXcml0ZUJvb3N0ZXIgZW5h
YmxlZCBpbiBMVSBEZWRpY2F0ZWQgYnVmZmVyIG1vZGUgKEF2cmkgQWx0bWFuKQ0KDQp2MSAtPiB2
MjoNCiAgLSBDaGFuZ2UgdGhlIGRlZmluaXRpb24gbmFtZSBvZiBXcml0ZUJvb3N0ZXIgYnVmZmVy
IG1vZGUgdG8gY29ycmVzcG9uZCB0byBzcGVjaWZpY2F0aW9uIChCZWFuIEh1bykNCiAgLSBBZGQg
cGF0Y2ggIzU6ICJzY3NpOiB1ZnM6IGNsZWFudXAgV3JpdGVCb29zdGVyIGZlYXR1cmUiDQoNClN0
YW5sZXkgQ2h1ICg4KToNCiAgc2NzaTogdWZzOiBlbmFibGUgV3JpdGVCb29zdGVyIG9uIHNvbWUg
cHJlLTMuMSBVRlMgZGV2aWNlcw0KICBzY3NpOiB1ZnM6IGludHJvZHVjZSBmaXh1cF9kZXZfcXVp
cmtzIHZvcHMNCiAgc2NzaTogdWZzOiBleHBvcnQgdWZzX2ZpeHVwX2RldmljZV9zZXR1cCgpIGZ1
bmN0aW9uDQogIHNjc2k6IHVmcy1tZWRpYXRlazogYWRkIGZpeHVwX2Rldl9xdWlya3Mgdm9wcw0K
ICBzY3NpOiB1ZnM6IGFkZCAiaW5kZXgiIGluIHBhcmFtZXRlciBsaXN0IG9mIHVmc2hjZF9xdWVy
eV9mbGFnKCkNCiAgc2NzaTogdWZzOiBhZGQgTFUgRGVkaWNhdGVkIGJ1ZmZlciBtb2RlIHN1cHBv
cnQgZm9yIFdyaXRlQm9vc3Rlcg0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGVuYWJsZSBXcml0ZUJv
b3N0ZXIgY2FwYWJpbGl0eQ0KICBzY3NpOiB1ZnM6IGNsZWFudXAgV3JpdGVCb29zdGVyIGZlYXR1
cmUNCg0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAgMjUgKysrKy0NCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jICAgIHwgIDExICsrLQ0KIGRyaXZlcnMvc2NzaS91ZnMv
dWZzLmggICAgICAgICAgfCAgMTAgKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaCAg
IHwgICA3ICsrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgICB8IDE2MyArKysrKysr
KysrKysrKysrKysrKystLS0tLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAg
ICAgfCAgMTkgKysrLQ0KIDYgZmlsZXMgY2hhbmdlZCwgMTczIGluc2VydGlvbnMoKyksIDYyIGRl
bGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

