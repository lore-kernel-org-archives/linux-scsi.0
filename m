Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC74C47257
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2DCA206B8
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QzDKXpbm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgEHIBZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:01:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:40573 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727105AbgEHIBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:01:24 -0400
X-UUID: 02ec54b3ad4841108a70f865eba87e39-20200508
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=q41jnBLZkm5OYDzNGhSl4Dj8ltKLKW6wmqZStHtz2CA=;
        b=QzDKXpbm3bkTCmkLMebgJgCfKKMZYA2t+VS2l7NzhWVBiFaczjvlhKJxVJri6zV3cfmg1gSY93jJmtp8eNGZMLK6GqZnlr3GM9Ei6aRF3rSK8wREafFtZLs8bt8oL7HqLlxqmy+Ag7DyC+V3en1fgzqzJS9qff3lp+Zx/kuEp3A=;
X-UUID: 02ec54b3ad4841108a70f865eba87e39-20200508
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1874186833; Fri, 08 May 2020 16:01:19 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 8 May 2020 16:01:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 16:01:17 +0800
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
Subject: [PATCH v8 0/8] scsi: ufs: support LU Dedicated buffer mode for WriteBooster
Date:   Fri, 8 May 2020 16:01:07 +0800
Message-ID: <20200508080115.24233-1-stanley.chu@mediatek.com>
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
Y2FwYWJpbGl0eSBvbiBNZWRpYVRlayBVRlMgcGxhdGZvcm1zLg0KDQp2NyAtPiB2ODoNCiAgLSBJ
biBleHBvcnRlZCBmdW50aW9uIHVmc2hjZF9maXh1cF9kZXZfcXVpcmtzKCksIGFkZCBudWxsIGNo
ZWNraW5nIGZvciBwYXJhbWV0ZXIgImZpeHVwcyIgKEF2cmkgQWx0bWFuKQ0KDQp2NiAtPiB2NzoN
CiAgLSBBZGQgZGV2aWNlIGRlc2NyaXB0b3IgbGVuZ3RoIGNoZWNrIGluIHVmc2hjZF93Yl9wcm9i
ZSgpIGJhY2sgdG8gcHJldmVudCBvdXQtb2YtYm91bmRhcnkgYWNjZXNzIGluIHVmc2hjZF93Yl9w
cm9iZSgpDQogIC0gRml4IHRoZSBjaGVjayBvZiBkZXZpY2UgZGVzY3JpcHRvciBsZW5ndGggKEF2
cmkgQWx0bWFuKQ0KICAtIFByb3ZpZGUgYSBuZXcgdWZzX2ZpeHVwX2RldmljZV9zZXR1cCgpIGZ1
bmN0aW9uIHRvIHBhY2sgYm90aCBkZXZpY2UgZml4dXAgbWV0aG9kcyBieSBnZW5lcmFsIHF1aXJr
IHRhYmxlIGFuZCB2ZW5kb3Itc3BlY2lmaWMgd2F5IChBdnJpIEFsdG1hbikNCg0KdjUgLT4gdjY6
DQogIC0gUmVtb3ZlIGRldmljZSBkZXNjcmlwdG9yIGxlbmd0aCBjaGVjayBpbiB1ZnNoY2Rfd2Jf
cHJvYmUoKQ0KDQp2NCAtPiB2NToNCiAgLSBDaGVjayBMVU4gSUQgZm9yIGF2YWlsYWJsZSBXcml0
ZUJvb3N0ZXIgYnVmZmVyIG9ubHkgZnJvbSAwIHRvIDcgYWNjb3JkaW5nIHRvIHNwZWMgKEF2cmkg
QWx0bWFuKQ0KICAtIFNraXAgY2hlY2tpbmcgYW55IHBvc3NpYmxlIGVycm9ycyBmcm9tIHVmc2hj
ZF9yZWFkX3VuaXRfZGVzY19wYXJhbShoYmEsIGx1biwgVU5JVF9ERVNDX1BBUkFNX1dCX0JVRl9B
TExPQ19VTklUUykgaW4gdWZzaGNkX3diX3Byb2JlKCkgYW5kIGNoZWNrIHJldHVybmVkIGRfbHVf
d2JfYnVmX2FsbG9jIChzaGFsbCBiZSB6ZXJvIGlmIGVycm9yIGhhcHBlbnMpIChBdnJpIEFsdG1h
bikNCg0KdjMgLT4gdjQ6DQogIC0gSW50cm9kdWNlICJmaXh1cF9kZXZfcXVpcmtzIiB2b3BzIHRv
IGFsbG93IHZlbmRvcnMgdG8gZml4IGFuZCBtb2RpZnkgZGV2aWNlIHF1aXJrcywgYW5kIHByb3Zp
ZGUgYW4gaW5pdGlhbCB2ZW5kb3Itc3BlY2lmaWMgZGV2aWNlIHF1aXJrIHRhYmxlIG9uIE1lZGlh
VGVrIFVGUyBwbGF0Zm9ybXMNCiAgLSBBdm9pZCByZWx5aW5nIG9uIGNvbW1vbiBkZXZpY2UgcXVp
cmsgdGFibGUgZm9yIHByZS0zLjEgVUZTIGRldmljZSB3aXRoIG5vbi1zdGFuZGFyZCBXcml0ZUJv
b3N0ZXIgc3VwcG9ydCAoQ2FuIEd1bykNCiAgLSBGaXggY29tbWVudHMgZm9yIHVmc2hjZF93Yl9w
cm9iZSgpIChDYW4gR3VvKQ0KICAtIE1ha2UgdWZzaGNkX3diX2dldF9mbGFnX2luZGV4KCkgaW5s
aW5lIGFuZCBmaXggdWZzaGNkX2lzX3diX2ZsYWdzKCkgKEF2cmkgQWx0bWFuKQ0KDQp2MiAtPiB2
MzoNCiAgLSBJbnRyb2R1Y2UgYSBkZXZpY2UgcXVpcmsgdG8gc3VwcG9ydCBXcml0ZUJvb3N0ZXIg
aW4gcHJlLTMuMSBVRlMgZGV2aWNlcyAoQXZyaSBBbHRtYW4pDQogIC0gRml4IFdyaXRlQm9vc3Rl
ciByZWxhdGVkIHN5c2ZzIG5vZGVzLiBOb3cgYWxsIFdyaXRlQm9vc3RlciByZWxhdGVkIHN5c2Zz
IG5vZGVzIGFyZSBzcGVjaWZpY2FsbHkgbWFwcGVkIHRvIHRoZSBMVU4gd2l0aCBXcml0ZUJvb3N0
ZXIgZW5hYmxlZCBpbiBMVSBEZWRpY2F0ZWQgYnVmZmVyIG1vZGUgKEF2cmkgQWx0bWFuKQ0KDQp2
MSAtPiB2MjoNCiAgLSBDaGFuZ2UgdGhlIGRlZmluaXRpb24gbmFtZSBvZiBXcml0ZUJvb3N0ZXIg
YnVmZmVyIG1vZGUgdG8gY29ycmVzcG9uZCB0byBzcGVjaWZpY2F0aW9uIChCZWFuIEh1bykNCiAg
LSBBZGQgcGF0Y2ggIzU6ICJzY3NpOiB1ZnM6IGNsZWFudXAgV3JpdGVCb29zdGVyIGZlYXR1cmUi
DQoNClN0YW5sZXkgQ2h1ICg4KToNCiAgc2NzaTogdWZzOiBlbmFibGUgV3JpdGVCb29zdGVyIG9u
IHNvbWUgcHJlLTMuMSBVRlMgZGV2aWNlcw0KICBzY3NpOiB1ZnM6IGludHJvZHVjZSBmaXh1cF9k
ZXZfcXVpcmtzIHZvcHMNCiAgc2NzaTogdWZzOiBleHBvcnQgdWZzX2ZpeHVwX2RldmljZV9zZXR1
cCgpIGZ1bmN0aW9uDQogIHNjc2k6IHVmcy1tZWRpYXRlazogYWRkIGZpeHVwX2Rldl9xdWlya3Mg
dm9wcw0KICBzY3NpOiB1ZnM6IGFkZCAiaW5kZXgiIGluIHBhcmFtZXRlciBsaXN0IG9mIHVmc2hj
ZF9xdWVyeV9mbGFnKCkNCiAgc2NzaTogdWZzOiBhZGQgTFUgRGVkaWNhdGVkIGJ1ZmZlciBtb2Rl
IHN1cHBvcnQgZm9yIFdyaXRlQm9vc3Rlcg0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IGVuYWJsZSBX
cml0ZUJvb3N0ZXIgY2FwYWJpbGl0eQ0KICBzY3NpOiB1ZnM6IGNsZWFudXAgV3JpdGVCb29zdGVy
IGZlYXR1cmUNCg0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAgMjUgKysrKy0N
CiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jICAgIHwgIDExICsrLQ0KIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzLmggICAgICAgICAgfCAgMTAgKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc19xdWly
a3MuaCAgIHwgICA3ICsrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAgICB8IDE2NiAr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmggICAgICAgfCAgMTkgKysrLQ0KIDYgZmlsZXMgY2hhbmdlZCwgMTc2IGluc2VydGlvbnMoKyks
IDYyIGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

