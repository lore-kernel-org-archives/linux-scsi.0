Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8718C5ACBF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 13:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EC6D206B1
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 13:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="q3LRGMRZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgCLNYA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 09:24:00 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:10187 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727265AbgCLNX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 09:23:59 -0400
X-UUID: 2621844fb62f432a80e24fde63098402-20200312
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=xm/G1sO3I7PlDO358ySrPxlME2LXeXXiVUP6BCRqWHY=;
        b=q3LRGMRZNttz4bHsILjWOhiv3NrBp0OFYacdYFpCeKXJw1Ghn+0EFMj6OO0eEHoK9Cq+08f7xig/jaLLU2/xwrnq2hhGoF5i5DcVnjBk3j+qh6cRYwMz8nn1Os2tb0w5JEngKHXP5zKNW66Rv0hdeqm7fAe4bP4VT7CWn8WkjHc=;
X-UUID: 2621844fb62f432a80e24fde63098402-20200312
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2042295203; Thu, 12 Mar 2020 21:23:52 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Mar 2020 21:22:37 +0800
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
Subject: [PATCH v3 0/8] scsi: ufs: some cleanups and make the delay for host enabling customizable
Date:   Thu, 12 Mar 2020 21:23:42 +0800
Message-ID: <20200312132350.18061-1-stanley.chu@mediatek.com>
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
JyByZXF1aXJlbWVudHMuDQoNCnYyIC0+IHYzDQoJLSBSZW1vdmUgL2FyY2gvYXJtNjQvY29uZmln
cy9kZWZjb25maWcgY2huYWdlIGJlY2F1c2UgaXQgaXMgZm9yIGxvY2FsIHRlc3Qgb25seQ0KDQp2
MSAtPiB2Mg0KCS0gQWRkIHBhdGNoICMxICJzY3NpOiB1ZnM6IGZpeCB1bmluaXRpYWxpemVkIHR4
X2xhbmVzIGluIHVmc2hjZF9kaXNhYmxlX3R4X2xjYyINCgktIFJlbW92ZSBzdHJ1Y3QgdWZzX2lu
aXRfcHJlZmV0Y2ggaW4gcGF0Y2ggIzINCgktIEludHJvZHVjZSBjb21tb24gZGVsYXkgZnVuY3Rp
b24gaW4gcGF0Y2ggIzQNCgktIFJlcGxhY2UgYWxsIGRlbGF5IHBsYWNlcyBieSBjb21tb24gZGVs
YXkgZnVuY3Rpb24gaW4gdWZzLW1lZGlhdGVrIGluIHBhdGNoICM1DQoJLSBVc2UgY29tbW9uIGRl
bGF5IGZ1bmN0aW9uIGluc3RlYWQgZm9yIGhvc3QgZW5hYmxpbmcgZGVsYXkgaW4gcGF0Y2ggIzYN
CgktIEFkZCBwYXRjaCAjNyAic2NzaTogdWZzOiBtYWtlIEhDRSBwb2xsaW5nIG1vcmUgY29tcGFj
dCB0byBpbXByb3ZlIGluaXRpYWxpemF0b2luIGxhdGVuY3kiDQoJLSBJbiBwYXRjaCAjOCwgY3Vz
dG9taXplIHRoZSBkZWxheSBpbiB1ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5IGNhbGxiYWNrIGlu
c3RlYWQgb2YgdWZzX210a19pbml0IChBdnJpKQ0KDQpTdGFubGV5IENodSAoOCk6DQogIHNjc2k6
IHVmczogZml4IHVuaW5pdGlhbGl6ZWQgdHhfbGFuZXMgaW4gdWZzaGNkX2Rpc2FibGVfdHhfbGNj
KCkNCiAgc2NzaTogdWZzOiByZW1vdmUgaW5pdF9wcmVmZXRjaF9kYXRhIGluIHN0cnVjdCB1ZnNf
aGJhDQogIHNjc2k6IHVmczogdXNlIGFuIGVudW0gZm9yIGhvc3QgY2FwYWJpbGl0aWVzDQogIHNj
c2k6IHVmczogaW50cm9kdWNlIGNvbW1vbiBkZWxheSBmdW5jdGlvbg0KICBzY3NpOiB1ZnMtbWVk
aWF0ZWs6IHJlcGxhY2UgYWxsIGRlbGF5IHBsYWNlcyBieSBjb21tb24gZGVsYXkgZnVuY3Rpb24N
CiAgc2NzaTogdWZzOiBhbGxvdyBjdXN0b21pemVkIGRlbGF5IGZvciBob3N0IGVuYWJsaW5nDQog
IHNjc2k6IHVmczogbWFrZSBIQ0UgcG9sbGluZyBtb3JlIGNvbXBhY3QgdG8gaW1wcm92ZSBpbml0
aWFsaXphdG9pbg0KICAgIGxhdGVuY3kNCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBjdXN0b21pemUg
dGhlIGRlbGF5IGZvciBob3N0IGVuYWJsaW5nDQoNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRp
YXRlay5jIHwgMzUgKysrKysrKystLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAg
ICAgICB8IDQ3ICsrKysrKysrKysrLS0tLS0tLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
aCAgICAgICB8IDc4ICsrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLQ0KIDMgZmlsZXMg
Y2hhbmdlZCwgODUgaW5zZXJ0aW9ucygrKSwgNzUgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xOC4w
DQo=

