Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6A6C5ACD6
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 10:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4162E2076D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 10:40:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AxibO5Yf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbgCRKk1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 06:40:27 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:42689 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727683AbgCRKk1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 06:40:27 -0400
X-UUID: 058cf9674cca40828d93faa8573bf62e-20200318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=O++pLXuj0DX/kTHP26oFWY1EQqKvdFA9wne654JlhgA=;
        b=AxibO5Yfa8I9VFxjXdWY6CyufjZdlPs9mMWGjQ4NGa04SE1IJghvUTitkt7P6mDo91zlQ+Xed68iqBi1tiI1GpY+Lru7RvzX38IXd07jXDGCl1pmyfv4ri9HVsxqEO2Uioac1bkxJQ8XshD9ttSEBRR7PbZ/9qJ8RzUTi1JPkq0=;
X-UUID: 058cf9674cca40828d93faa8573bf62e-20200318
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2021600826; Wed, 18 Mar 2020 18:40:20 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 18 Mar 2020 18:37:25 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 18 Mar 2020 18:40:30 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.peter~sen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v7 0/7] scsi: ufs: some cleanups and make the delay for host enabling customizable
Date:   Wed, 18 Mar 2020 18:40:09 +0800
Message-ID: <20200318104016.28049-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: C898DCF254560EA0341542683F3E0BFC4414FA2D8198C3B73AF12E8E0B47139F2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

djYgLT4gdjcNCgktIEZpeCBwYXRjaCAjMyAic2NzaTogdWZzOiBpbnRyb2R1Y2UgY29tbW9uIGRl
bGF5IGZ1bmN0aW9uIiAoQmFydCBWYW4gQXNzY2hlKQ0KCQktIFJlbW92ZSAiY2FuX3NsZWVwIiBy
ZWxhdGVkIGNoYW5nZXMuDQoJCS0gTGltaXQgdGhlIHVzYWdlIG9mIGNvbW1vbiBkZWxheSBmdW5j
dGlvbiwgZm9yIGV4YW1wbGUsIGlmIGRlbGF5IHRpbWUNCgkJaXMgZml4ZWQgYW5kIGxhcmdlciB0
aGFuIDEwIHVzLCB1c2luZyBpbnRyb2R1Y2VkIGNvbW1vbiBkZWxheSBmdW5jdGlvbiBpcyBub3Qg
cmVxdWlyZWQuDQoJLSBPdGhlciByZWxhdGVkIGNoYW5nZXMgYWNjb3JkaW5nIHRvIHBhdGNoICMz
IGNoYW5nZXMNCg0KdjUgLT4gdjYNCgktIERyb3AgcGF0Y2ggIzIgInNjc2k6IHVmczogcmVtb3Zl
IGluaXRfcHJlZmV0Y2hfZGF0YSBpbiBzdHJ1Y3QgdWZzX2hiYSIgaW4gdjUNCgliZWNhdXNlIENh
biBHdW8gaGFzIHNpbWlsYXIgY2xlYW51cCBlYXJsaWVyIGluIHBhdGNoICJzY3NpOiB1ZnM6IERv
IG5vdCByZWx5IG9uIHByZWZldGNoZWQgZGF0YSINCg0KdjQgLT4gdjUNCgktIEZpeCBwYXRjaCAj
NzogRml4IHR5cG8gImluaXRpYWxpemF0b2luIiBpbiB0aXRsZQ0KDQp2MyAtPiB2NA0KCS0gSW4g
cGF0Y2ggIzgsIGZpeCBpbmNvcnJlY3QgY29uZGl0aW9uIG9mIGN1c3RvbWl6ZWQgZGVsYXkgZm9y
IGhvc3QgZW5hYmxpbmcNCg0KdjIgLT4gdjMNCgktIFJlbW92ZSAvYXJjaC9hcm02NC9jb25maWdz
L2RlZmNvbmZpZyBjaG5hZ2UgYmVjYXVzZSBpdCBpcyBmb3IgbG9jYWwgdGVzdCBvbmx5DQoNCnYx
IC0+IHYyDQoJLSBBZGQgcGF0Y2ggIzEgInNjc2k6IHVmczogZml4IHVuaW5pdGlhbGl6ZWQgdHhf
bGFuZXMgaW4gdWZzaGNkX2Rpc2FibGVfdHhfbGNjIg0KCS0gUmVtb3ZlIHN0cnVjdCB1ZnNfaW5p
dF9wcmVmZXRjaCBpbiBwYXRjaCAjMiAic2NzaTogdWZzOiByZW1vdmUgaW5pdF9wcmVmZXRjaF9k
YXRhIGluIHN0cnVjdCB1ZnNfaGJhIg0KCS0gSW50cm9kdWNlIGNvbW1vbiBkZWxheSBmdW5jdGlv
biBpbiBwYXRjaCAjNA0KCS0gUmVwbGFjZSBhbGwgZGVsYXkgcGxhY2VzIGJ5IGNvbW1vbiBkZWxh
eSBmdW5jdGlvbiBpbiB1ZnMtbWVkaWF0ZWsgaW4gcGF0Y2ggIzUNCgktIFVzZSBjb21tb24gZGVs
YXkgZnVuY3Rpb24gaW5zdGVhZCBmb3IgaG9zdCBlbmFibGluZyBkZWxheSBpbiBwYXRjaCAjNg0K
CS0gQWRkIHBhdGNoICM3ICJzY3NpOiB1ZnM6IG1ha2UgSENFIHBvbGxpbmcgbW9yZSBjb21wYWN0
IHRvIGltcHJvdmUgaW5pdGlhbGl6YXRvaW4gbGF0ZW5jeSINCgktIEluIHBhdGNoICM4LCBjdXN0
b21pemUgdGhlIGRlbGF5IGluIHVmc19tdGtfaGNlX2VuYWJsZV9ub3RpZnkgY2FsbGJhY2sgaW5z
dGVhZCBvZiB1ZnNfbXRrX2luaXQgKEF2cmkgQWx0bWFuKQ0KDQpTdGFubGV5IENodSAoNyk6DQog
IHNjc2k6IHVmczogZml4IHVuaW5pdGlhbGl6ZWQgdHhfbGFuZXMgaW4gdWZzaGNkX2Rpc2FibGVf
dHhfbGNjKCkNCiAgc2NzaTogdWZzOiB1c2UgYW4gZW51bSBmb3IgaG9zdCBjYXBhYmlsaXRpZXMN
CiAgc2NzaTogdWZzOiBpbnRyb2R1Y2UgY29tbW9uIGFuZCBmbGV4aWJsZSBkZWxheSBmdW5jdGlv
bg0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IHVzZSBjb21tb24gZGVsYXkgZnVuY3Rpb24gZm9yIHJl
cXVpcmVkIHBsYWNlcw0KICBzY3NpOiB1ZnM6IGFsbG93IGN1c3RvbWl6ZWQgZGVsYXkgZm9yIGhv
c3QgZW5hYmxpbmcNCiAgc2NzaTogdWZzOiBtYWtlIEhDRSBwb2xsaW5nIG1vcmUgY29tcGFjdCB0
byBpbXByb3ZlIGluaXRpYWxpemF0aW9uDQogICAgbGF0ZW5jeQ0KICBzY3NpOiB1ZnMtbWVkaWF0
ZWs6IGN1c3RvbWl6ZSB0aGUgZGVsYXkgZm9yIGhvc3QgZW5hYmxpbmcNCg0KIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMgfCA1OCArKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tDQog
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCB8ICAxICsNCiBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jICAgICAgIHwgMjEgKysrKysrKysrLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5oICAgICAgIHwgNjcgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tDQogNCBmaWxl
cyBjaGFuZ2VkLCA5MyBpbnNlcnRpb25zKCspLCA1NCBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4
LjANCg==

