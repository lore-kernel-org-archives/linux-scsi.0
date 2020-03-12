Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250D0C2BB1D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 11:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F231520674
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 11:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RpGAdqme"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgCLLJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 07:09:46 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:40447 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726299AbgCLLJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 07:09:16 -0400
X-UUID: 28adbd7bdaa64367ba9b5bf5007533e4-20200312
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Ag02VivGUhvR9buIvQPvnrb0s1QzSL8oyAFe0L72x6E=;
        b=RpGAdqmeNh/wlhNCdwR/1hpP1qSDDdZPybV/xdTXInpcigF65KiW2Z8R3RdzcnXZCH/dMqGeH2v2wNGsVuNF0N7ry6XOmnrjTg5gq61orfrs6et3g5MIA6hcQ4F1r7nsmpNUS1ANW1ieNxVMiLA7WhMWKVE7fm9RBf23IS1LkYA=;
X-UUID: 28adbd7bdaa64367ba9b5bf5007533e4-20200312
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1540572367; Thu, 12 Mar 2020 19:09:10 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Mar 2020 19:07:55 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Mar 2020 19:08:49 +0800
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
Subject: [PATCH v2 0/8] scsi: ufs: some cleanups and make the delay for host enabling customizable
Date:   Thu, 12 Mar 2020 19:09:00 +0800
Message-ID: <20200312110908.14895-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgYXBwbGllcyBzb21lIGRyaXZlciBjbGVhbnVwcyBhbmQgcGVy
Zm9ybWFuY2UgaW1wcm92ZW1lbnQNCmluIHVmcyBob3N0IGRyaXZlcnMgYnkgbWFraW5nIHRoZSBk
ZWxheSBmb3IgaG9zdCBlbmFibGluZyBjdXN0b21pemFibGUNCmFjY29yZGluZyB0byB2ZW5kb3Jz
JyByZXF1aXJlbWVudHMuDQoNCnYxIC0+IHYyDQoJLSBBZGQgcGF0Y2ggIzEgInNjc2k6IHVmczog
Zml4IHVuaW5pdGlhbGl6ZWQgdHhfbGFuZXMgaW4gdWZzaGNkX2Rpc2FibGVfdHhfbGNjIg0KCS0g
UmVtb3ZlIHN0cnVjdCB1ZnNfaW5pdF9wcmVmZXRjaCBpbiBwYXRjaCAjMiAic2NzaTogdWZzOiBy
ZW1vdmUgaW5pdF9wcmVmZXRjaF9kYXRhIGluIHN0cnVjdCB1ZnNfaGJhIg0KCS0gSW50cm9kdWNl
IGNvbW1vbiBkZWxheSBmdW5jdGlvbiBpbiBwYXRjaCAjNA0KCS0gUmVwbGFjZSBhbGwgZGVsYXkg
cGxhY2VzIGJ5IGNvbW1vbiBkZWxheSBmdW5jdGlvbiBpbiB1ZnMtbWVkaWF0ZWsgaW4gcGF0Y2gg
IzUNCgktIFVzZSBjb21tb24gZGVsYXkgZnVuY3Rpb24gaW5zdGVhZCBmb3IgaG9zdCBlbmFibGlu
ZyBkZWxheSBpbiBwYXRjaCAjNg0KCS0gQWRkIHBhdGNoICM3ICJzY3NpOiB1ZnM6IG1ha2UgSENF
IHBvbGxpbmcgbW9yZSBjb21wYWN0IHRvIGltcHJvdmUgaW5pdGlhbGl6YXRvaW4gbGF0ZW5jeSIN
CgktIEluIHBhdGNoICM4LCBjdXN0b21pemUgdGhlIGRlbGF5IGluIHVmc19tdGtfaGNlX2VuYWJs
ZV9ub3RpZnkgY2FsbGJhY2sgaW5zdGVhZCBvZiB1ZnNfbXRrX2luaXQgKEF2cmkpDQoNClN0YW5s
ZXkgQ2h1ICg4KToNCiAgc2NzaTogdWZzOiBmaXggdW5pbml0aWFsaXplZCB0eF9sYW5lcyBpbiB1
ZnNoY2RfZGlzYWJsZV90eF9sY2MoKQ0KICBzY3NpOiB1ZnM6IHJlbW92ZSBpbml0X3ByZWZldGNo
X2RhdGEgaW4gc3RydWN0IHVmc19oYmENCiAgc2NzaTogdWZzOiB1c2UgYW4gZW51bSBmb3IgaG9z
dCBjYXBhYmlsaXRpZXMNCiAgc2NzaTogdWZzOiBpbnRyb2R1Y2UgY29tbW9uIGRlbGF5IGZ1bmN0
aW9uDQogIHNjc2k6IHVmcy1tZWRpYXRlazogcmVwbGFjZSBhbGwgZGVsYXkgcGxhY2VzIGJ5IGNv
bW1vbiBkZWxheSBmdW5jdGlvbg0KICBzY3NpOiB1ZnM6IGFsbG93IGN1c3RvbWl6ZWQgZGVsYXkg
Zm9yIGhvc3QgZW5hYmxpbmcNCiAgc2NzaTogdWZzOiBtYWtlIEhDRSBwb2xsaW5nIG1vcmUgY29t
cGFjdCB0byBpbXByb3ZlIGluaXRpYWxpemF0b2luDQogICAgbGF0ZW5jeQ0KICBzY3NpOiB1ZnMt
bWVkaWF0ZWs6IGN1c3RvbWl6ZSB0aGUgZGVsYXkgZm9yIGhvc3QgZW5hYmxpbmcNCg0KIGFyY2gv
YXJtNjQvY29uZmlncy9kZWZjb25maWcgICAgfCAgMSArDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMt
bWVkaWF0ZWsuYyB8IDM1ICsrKysrKysrLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMgICAgICAgfCA0NyArKysrKysrKysrKy0tLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmggICAgICAgfCA3OCArKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0NCiA0IGZp
bGVzIGNoYW5nZWQsIDg2IGluc2VydGlvbnMoKyksIDc1IGRlbGV0aW9ucygtKQ0KDQotLSANCjIu
MTguMA0K

