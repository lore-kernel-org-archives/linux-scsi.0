Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F07C1975A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E9AF206B1
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GG06d5W7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgCPIxN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:53:13 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:21951 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730075AbgCPIxN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 04:53:13 -0400
X-UUID: 24f7e6438b3c40b9a22e9962962e53f9-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=X+DFchOZe2OpAsUM0+Gq6vu0pCSrT1gOAXXOi+6KyiQ=;
        b=GG06d5W7kP/DOOu4Q1Ayy8OQzNsHunR+rMRV1ho4QSFGnA+a6ST3bhtNOfyGqgVzEYBuDEJPjSXuH+lVMdCT2pB/IhMRD/pQjGKkOoZtVdnMuXKbEE0+wva1lGO2XfdqgnlfYXmIPBqJTPWfactgSdu5pcf/5senNBMSwWHR8JU=;
X-UUID: 24f7e6438b3c40b9a22e9962962e53f9-20200316
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 121762611; Mon, 16 Mar 2020 16:53:07 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 16:50:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 16:53:53 +0800
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
Subject: [PATCH v6 6/7] scsi: ufs: make HCE polling more compact to improve initialization latency
Date:   Mon, 16 Mar 2020 16:53:02 +0800
Message-ID: <20200316085303.20350-7-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200316085303.20350-1-stanley.chu@mediatek.com>
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UmVkdWNlIHRoZSB3YWl0aW5nIHBlcmlvZCBiZXR3ZWVuIGVhY2ggSENFIChIb3N0IENvbnRyb2xs
ZXIgRW5hYmxlKQ0KcG9sbGluZyBmcm9tIDUgbXMgdG8gMSBtcy4gSW4gdGhlIHNhbWUgdGltZSwg
aW5jcmVhc2UgdGhlIG1heGltdW0gcG9sbGluZw0KdGltZXMgdG8gbWFrZSAidG90YWwgcG9sbGlu
ZyB0aW1lIiB1bmNoYW5nZWQgYXBwcm94aW1hdGVseS4NCg0KVGhpcyBjaGFuZ2UgY291bGQgbWFr
ZSBIQ0UgaW5pdGlhbGl6YXRvaW4gZmFzdGVyIHRvIGltcHJvdmUgbGF0ZW5jeSBvZg0KdWZzaGNk
IGluaXRpYWxpemF0aW9uLCBlcnJvciByZWNvdmVyeSwgYW5kIHJlc3VtZSBiZWhhdmlvcnMuDQoN
ClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpS
ZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQpSZXZpZXdlZC1i
eTogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMgfCA0ICsrLS0NCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IDc4YjZhYzZmY2M0ZS4uYzA2YTE1ZGYyZjQw
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTQzMDEsNyArNDMwMSw3IEBAIGludCB1ZnNoY2RfaGJhX2Vu
YWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAl1ZnNoY2Rfd2FpdF91cyhoYmEtPmhiYV9lbmFi
bGVfZGVsYXlfdXMsIDEwMCwgdHJ1ZSk7DQogDQogCS8qIHdhaXQgZm9yIHRoZSBob3N0IGNvbnRy
b2xsZXIgdG8gY29tcGxldGUgaW5pdGlhbGl6YXRpb24gKi8NCi0JcmV0cnkgPSAxMDsNCisJcmV0
cnkgPSA1MDsNCiAJd2hpbGUgKHVmc2hjZF9pc19oYmFfYWN0aXZlKGhiYSkpIHsNCiAJCWlmIChy
ZXRyeSkgew0KIAkJCXJldHJ5LS07DQpAQCAtNDMxMCw3ICs0MzEwLDcgQEAgaW50IHVmc2hjZF9o
YmFfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogCQkJCSJDb250cm9sbGVyIGVuYWJsZSBm
YWlsZWRcbiIpOw0KIAkJCXJldHVybiAtRUlPOw0KIAkJfQ0KLQkJdWZzaGNkX3dhaXRfdXMoNTAw
MCwgMTAwLCB0cnVlKTsNCisJCXVmc2hjZF93YWl0X3VzKDEwMDAsIDEwMCwgdHJ1ZSk7DQogCX0N
CiANCiAJLyogZW5hYmxlIFVJQyByZWxhdGVkIGludGVycnVwdHMgKi8NCi0tIA0KMi4xOC4wDQo=

