Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E8EC0044D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EBA720719
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="okxbpSCf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgCPIxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:53:14 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:32442 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730179AbgCPIxN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 04:53:13 -0400
X-UUID: 8df65d9a86254f7fb909957e1a92eb17-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=gp+miboBva3gmpY9AwDXQhfWdq6yO74UoFEFEIC5fwA=;
        b=okxbpSCfQ77cDzQBfHEQOlcZkqRx0Ph7F0Bu2T/MTeqDP8ifLmPQSDUmsoja6J65D/qXKQdKlra4+HkdzCuHhExjog/JDDeKZXbq3VjW3pBCEqwhtG25lQXtNnkksmRCqeNZDz5kDlOq3x8EWRJgA+8tXo+DRiNruuqu/1LmBUU=;
X-UUID: 8df65d9a86254f7fb909957e1a92eb17-20200316
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1910460404; Mon, 16 Mar 2020 16:53:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 16:50:49 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 16:53:51 +0800
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
Subject: [PATCH v6 0/7] scsi: ufs: some cleanups and make the delay for host enabling customizable
Date:   Mon, 16 Mar 2020 16:52:56 +0800
Message-ID: <20200316085303.20350-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

djUgLT4gdjYNCgktIERyb3AgcGF0Y2ggIzIgInNjc2k6IHVmczogcmVtb3ZlIGluaXRfcHJlZmV0
Y2hfZGF0YSBpbiBzdHJ1Y3QgdWZzX2hiYSIgaW4gdjUNCgliZWNhdXNlIENhbiBHdW8gaGFzIHNp
bWlsYXIgY2xlYW51cCBlYXJsaWVyIGluIHBhdGNoICJzY3NpOiB1ZnM6IERvIG5vdCByZWx5IG9u
IHByZWZldGNoZWQgZGF0YSINCg0KdjQgLT4gdjUNCgktIEZpeCBwYXRjaCAjNzogRml4IHR5cG8g
ImluaXRpYWxpemF0b2luIiBpbiB0aXRsZQ0KDQp2MyAtPiB2NA0KCS0gSW4gcGF0Y2ggIzgsIGZp
eCBpbmNvcnJlY3QgY29uZGl0aW9uIG9mIGN1c3RvbWl6ZWQgZGVsYXkgZm9yIGhvc3QgZW5hYmxp
bmcNCg0KdjIgLT4gdjMNCgktIFJlbW92ZSAvYXJjaC9hcm02NC9jb25maWdzL2RlZmNvbmZpZyBj
aG5hZ2UgYmVjYXVzZSBpdCBpcyBmb3IgbG9jYWwgdGVzdCBvbmx5DQoNCnYxIC0+IHYyDQoJLSBB
ZGQgcGF0Y2ggIzEgInNjc2k6IHVmczogZml4IHVuaW5pdGlhbGl6ZWQgdHhfbGFuZXMgaW4gdWZz
aGNkX2Rpc2FibGVfdHhfbGNjIg0KCS0gUmVtb3ZlIHN0cnVjdCB1ZnNfaW5pdF9wcmVmZXRjaCBp
biBwYXRjaCAjMiAic2NzaTogdWZzOiByZW1vdmUgaW5pdF9wcmVmZXRjaF9kYXRhIGluIHN0cnVj
dCB1ZnNfaGJhIg0KCS0gSW50cm9kdWNlIGNvbW1vbiBkZWxheSBmdW5jdGlvbiBpbiBwYXRjaCAj
NA0KCS0gUmVwbGFjZSBhbGwgZGVsYXkgcGxhY2VzIGJ5IGNvbW1vbiBkZWxheSBmdW5jdGlvbiBp
biB1ZnMtbWVkaWF0ZWsgaW4gcGF0Y2ggIzUNCgktIFVzZSBjb21tb24gZGVsYXkgZnVuY3Rpb24g
aW5zdGVhZCBmb3IgaG9zdCBlbmFibGluZyBkZWxheSBpbiBwYXRjaCAjNg0KCS0gQWRkIHBhdGNo
ICM3ICJzY3NpOiB1ZnM6IG1ha2UgSENFIHBvbGxpbmcgbW9yZSBjb21wYWN0IHRvIGltcHJvdmUg
aW5pdGlhbGl6YXRvaW4gbGF0ZW5jeSINCgktIEluIHBhdGNoICM4LCBjdXN0b21pemUgdGhlIGRl
bGF5IGluIHVmc19tdGtfaGNlX2VuYWJsZV9ub3RpZnkgY2FsbGJhY2sgaW5zdGVhZCBvZiB1ZnNf
bXRrX2luaXQgKEF2cmkpDQoNClN0YW5sZXkgQ2h1ICg3KToNCiAgc2NzaTogdWZzOiBmaXggdW5p
bml0aWFsaXplZCB0eF9sYW5lcyBpbiB1ZnNoY2RfZGlzYWJsZV90eF9sY2MoKQ0KICBzY3NpOiB1
ZnM6IHVzZSBhbiBlbnVtIGZvciBob3N0IGNhcGFiaWxpdGllcw0KICBzY3NpOiB1ZnM6IGludHJv
ZHVjZSBjb21tb24gZGVsYXkgZnVuY3Rpb24NCiAgc2NzaTogdWZzLW1lZGlhdGVrOiByZXBsYWNl
IGFsbCBkZWxheSBwbGFjZXMgYnkgY29tbW9uIGRlbGF5IGZ1bmN0aW9uDQogIHNjc2k6IHVmczog
YWxsb3cgY3VzdG9taXplZCBkZWxheSBmb3IgaG9zdCBlbmFibGluZw0KICBzY3NpOiB1ZnM6IG1h
a2UgSENFIHBvbGxpbmcgbW9yZSBjb21wYWN0IHRvIGltcHJvdmUgaW5pdGlhbGl6YXRpb24NCiAg
ICBsYXRlbmN5DQogIHNjc2k6IHVmcy1tZWRpYXRlazogY3VzdG9taXplIHRoZSBkZWxheSBmb3Ig
aG9zdCBlbmFibGluZw0KDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDY0ICsr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRp
YXRlay5oIHwgIDEgKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgICAgfCAzMiArKysr
KysrKysrLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICAgICB8IDY3ICsrKysr
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQ0KIDQgZmlsZXMgY2hhbmdlZCwgMTAwIGluc2Vy
dGlvbnMoKyksIDY0IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTguMA0K

