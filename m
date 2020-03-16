Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECDFC1975A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 03:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20E4F20737
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 03:42:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TDw1Gam3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgCPDms (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 23:42:48 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:32774 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729748AbgCPDmb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2020 23:42:31 -0400
X-UUID: 1807d8a27bc54aaba5cca9e5308764a6-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=vi8sUp7wfNGzry+oc6hx+6Yugm6avGTPSPtWm++c2Ic=;
        b=TDw1Gam3EYLq+TB+byGWj26q52Sk2NuFxGEfWbvrn6XJTkfFbMoQ6fmxhHpn3kP77Aca9sRlAUoN2J0cRBi+gT6Ue45OSB38jN1RdZE8f2rxLSOsqYYnZiKvhPbBW8+LjnywPS3bpjBM5s0G4u0zfw4OKqXyX22RU0yt7A0e7uc=;
X-UUID: 1807d8a27bc54aaba5cca9e5308764a6-20200316
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1358447519; Mon, 16 Mar 2020 11:42:21 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 11:39:27 +0800
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
Subject: [PATCH v5 0/8] scsi: ufs: some cleanups and make the delay for host enabling customizable
Date:   Mon, 16 Mar 2020 11:42:10 +0800
Message-ID: <20200316034218.11914-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 2894A1BF0F52B2EA31AD88934CEC3761E565330CEFDA4095AACD5209D52A5C982000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgYXBwbGllcyBzb21lIGRyaXZlciBjbGVhbnVwcyBhbmQgcGVy
Zm9ybWFuY2UgaW1wcm92ZW1lbnQNCmluIHVmcyBob3N0IGRyaXZlcnMgYnkgbWFraW5nIHRoZSBk
ZWxheSBmb3IgaG9zdCBlbmFibGluZyBjdXN0b21pemFibGUNCmFjY29yZGluZyB0byB2ZW5kb3Jz
JyByZXF1aXJlbWVudHMuDQoNCnY0IC0+IHY1DQoJLSBDb2xsZWN0IHJldmlldyB0YWdzIGluIHY0
DQoJLSBGaXggcGF0Y2ggIzc6IEZpeCB0eXBvICJpbml0aWFsaXphdG9pbiIgaW4gdGl0bGUNCg0K
djMgLT4gdjQNCgktIENvbGxlY3QgcmV2aWV3IHRhZ3MgaW4gdjINCgktIEluIHBhdGNoICM4LCBm
aXggaW5jb3JyZWN0IGNvbmRpdGlvbiBvZiBjdXN0b21pemVkIGRlbGF5IGZvciBob3N0IGVuYWJs
aW5nDQoNCnYyIC0+IHYzDQoJLSBSZW1vdmUgL2FyY2gvYXJtNjQvY29uZmlncy9kZWZjb25maWcg
Y2huYWdlIGJlY2F1c2UgaXQgaXMgZm9yIGxvY2FsIHRlc3Qgb25seQ0KDQp2MSAtPiB2Mg0KCS0g
QWRkIHBhdGNoICMxICJzY3NpOiB1ZnM6IGZpeCB1bmluaXRpYWxpemVkIHR4X2xhbmVzIGluIHVm
c2hjZF9kaXNhYmxlX3R4X2xjYyINCgktIFJlbW92ZSBzdHJ1Y3QgdWZzX2luaXRfcHJlZmV0Y2gg
aW4gcGF0Y2ggIzIgInNjc2k6IHVmczogcmVtb3ZlIGluaXRfcHJlZmV0Y2hfZGF0YSBpbiBzdHJ1
Y3QgdWZzX2hiYSINCgktIEludHJvZHVjZSBjb21tb24gZGVsYXkgZnVuY3Rpb24gaW4gcGF0Y2gg
IzQNCgktIFJlcGxhY2UgYWxsIGRlbGF5IHBsYWNlcyBieSBjb21tb24gZGVsYXkgZnVuY3Rpb24g
aW4gdWZzLW1lZGlhdGVrIGluIHBhdGNoICM1DQoJLSBVc2UgY29tbW9uIGRlbGF5IGZ1bmN0aW9u
IGluc3RlYWQgZm9yIGhvc3QgZW5hYmxpbmcgZGVsYXkgaW4gcGF0Y2ggIzYNCgktIEFkZCBwYXRj
aCAjNyAic2NzaTogdWZzOiBtYWtlIEhDRSBwb2xsaW5nIG1vcmUgY29tcGFjdCB0byBpbXByb3Zl
IGluaXRpYWxpemF0b2luIGxhdGVuY3kiDQoJLSBJbiBwYXRjaCAjOCwgY3VzdG9taXplIHRoZSBk
ZWxheSBpbiB1ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5IGNhbGxiYWNrIGluc3RlYWQgb2YgdWZz
X210a19pbml0IChBdnJpKQ0KDQpTdGFubGV5IENodSAoOCk6DQogIHNjc2k6IHVmczogZml4IHVu
aW5pdGlhbGl6ZWQgdHhfbGFuZXMgaW4gdWZzaGNkX2Rpc2FibGVfdHhfbGNjKCkNCiAgc2NzaTog
dWZzOiByZW1vdmUgaW5pdF9wcmVmZXRjaF9kYXRhIGluIHN0cnVjdCB1ZnNfaGJhDQogIHNjc2k6
IHVmczogdXNlIGFuIGVudW0gZm9yIGhvc3QgY2FwYWJpbGl0aWVzDQogIHNjc2k6IHVmczogaW50
cm9kdWNlIGNvbW1vbiBkZWxheSBmdW5jdGlvbg0KICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IHJlcGxh
Y2UgYWxsIGRlbGF5IHBsYWNlcyBieSBjb21tb24gZGVsYXkgZnVuY3Rpb24NCiAgc2NzaTogdWZz
OiBhbGxvdyBjdXN0b21pemVkIGRlbGF5IGZvciBob3N0IGVuYWJsaW5nDQogIHNjc2k6IHVmczog
bWFrZSBIQ0UgcG9sbGluZyBtb3JlIGNvbXBhY3QgdG8gaW1wcm92ZSBpbml0aWFsaXphdGlvbg0K
ICAgIGxhdGVuY3kNCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBjdXN0b21pemUgdGhlIGRlbGF5IGZv
ciBob3N0IGVuYWJsaW5nDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgNjQg
KysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0
ZWsuaCB8ICAxICsNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICAgIHwgNDcgKysrKysr
KysrKystLS0tLS0tLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oICAgICAgIHwgNzggKysr
KysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tDQogNCBmaWxlcyBjaGFuZ2VkLCAxMDYgaW5z
ZXJ0aW9ucygrKSwgODQgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4wDQo=

