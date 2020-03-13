Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF975C2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 921F820749
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:02:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IZEYXpsj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgCMJCA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 05:02:00 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:50531 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726300AbgCMJB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 05:01:28 -0400
X-UUID: 116210520f954c7cbf0ae092256945d6-20200313
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=S3uWyJk73+UEOL/b0WFIj4yNQ34uAFbalJrd4+RQrbo=;
        b=IZEYXpsjY9a9Y1Cx6sLs42qrXQ/9vZHvWGSryVEtKHJStBVi3Lw4Q0IklBaeKZ+a36cCUTVO9Tpc6rOaN7a7//FWfg43tyEIzCpbBNfXQaO9VMFoW721CFZDMNNVKiPNhVKvAUtpWENLZLD56HdhKBe6BnusEj/XKCYud23ggbg=;
X-UUID: 116210520f954c7cbf0ae092256945d6-20200313
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1045666946; Fri, 13 Mar 2020 17:01:22 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 13 Mar 2020 16:58:31 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 13 Mar 2020 17:00:32 +0800
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
Subject: [PATCH v4 0/8] scsi: ufs: some cleanups and make the delay for host enabling customizable
Date:   Fri, 13 Mar 2020 17:00:55 +0800
Message-ID: <20200313090103.15390-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 943201575853E0C8EA28F1CD4D879308EFE06E0429203F278F2E643C67DFDB422000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2hzZXQgYXBwbGllcyBzb21lIGRyaXZlciBjbGVhbnVwcyBhbmQgcGVy
Zm9ybWFuY2UgaW1wcm92ZW1lbnQNCmluIHVmcyBob3N0IGRyaXZlcnMgYnkgbWFraW5nIHRoZSBk
ZWxheSBmb3IgaG9zdCBlbmFibGluZyBjdXN0b21pemFibGUNCmFjY29yZGluZyB0byB2ZW5kb3Jz
JyByZXF1aXJlbWVudHMuDQoNCnYzIC0+IHY0DQoJLSBDb2xsZWN0IHJldmlldyB0YWdzIGluIHYy
DQoJLSBJbiBwYXRjaCAjOCwgZml4IGluY29ycmVjdCBjb25kaXRpb24gb2YgY3VzdG9taXplZCBk
ZWxheSBmb3IgaG9zdCBlbmFibGluZw0KDQp2MiAtPiB2Mw0KCS0gUmVtb3ZlIC9hcmNoL2FybTY0
L2NvbmZpZ3MvZGVmY29uZmlnIGNobmFnZSBiZWNhdXNlIGl0IGlzIGZvciBsb2NhbCB0ZXN0IG9u
bHkNCg0KdjEgLT4gdjINCgktIEFkZCBwYXRjaCAjMSAic2NzaTogdWZzOiBmaXggdW5pbml0aWFs
aXplZCB0eF9sYW5lcyBpbiB1ZnNoY2RfZGlzYWJsZV90eF9sY2MiDQoJLSBSZW1vdmUgc3RydWN0
IHVmc19pbml0X3ByZWZldGNoIGluIHBhdGNoICMyICJzY3NpOiB1ZnM6IHJlbW92ZSBpbml0X3By
ZWZldGNoX2RhdGEgaW4gc3RydWN0IHVmc19oYmEiDQoJLSBJbnRyb2R1Y2UgY29tbW9uIGRlbGF5
IGZ1bmN0aW9uIGluIHBhdGNoICM0DQoJLSBSZXBsYWNlIGFsbCBkZWxheSBwbGFjZXMgYnkgY29t
bW9uIGRlbGF5IGZ1bmN0aW9uIGluIHVmcy1tZWRpYXRlayBpbiBwYXRjaCAjNQ0KCS0gVXNlIGNv
bW1vbiBkZWxheSBmdW5jdGlvbiBpbnN0ZWFkIGZvciBob3N0IGVuYWJsaW5nIGRlbGF5IGluIHBh
dGNoICM2DQoJLSBBZGQgcGF0Y2ggIzcgInNjc2k6IHVmczogbWFrZSBIQ0UgcG9sbGluZyBtb3Jl
IGNvbXBhY3QgdG8gaW1wcm92ZSBpbml0aWFsaXphdG9pbiBsYXRlbmN5Ig0KCS0gSW4gcGF0Y2gg
IzgsIGN1c3RvbWl6ZSB0aGUgZGVsYXkgaW4gdWZzX210a19oY2VfZW5hYmxlX25vdGlmeSBjYWxs
YmFjayBpbnN0ZWFkIG9mIHVmc19tdGtfaW5pdCAoQXZyaSkNCg0KIGRyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLmMgfCA2NCArKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0NCiBkcml2ZXJz
L3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIHwgIDEgKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMgICAgICAgfCA0NyArKysrKysrKysrKy0tLS0tLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmggICAgICAgfCA3OCArKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0NCiA0IGZp
bGVzIGNoYW5nZWQsIDEwNiBpbnNlcnRpb25zKCspLCA4NCBkZWxldGlvbnMoLSkNCg0KLS0gDQoy
LjE4LjANCg==

