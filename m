Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6096BC433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 13:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B9622070C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 13:21:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Z7mlhbDj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgGFNVZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 09:21:25 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:39178 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729115AbgGFNVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 09:21:25 -0400
X-UUID: b13fd27570944096b1cf0dedc847be4b-20200706
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=JEKKXzqAAcN0UvZo8mMJzoVz8sWVLl6w/CEmyd3ob10=;
        b=Z7mlhbDj7PETj/GJWWRzSgi0r12CgWLpcAsE1nDMfqydOA/CezKOq+YsV2A6SMjjcrfu5ob/vGcHgwn1JVG7qjCOVSfbO27EnB1fzNSP/r0E12ZzbDMlwHt3ZjqII9CZB0yMA3AKH7kk31CKUXEGvCwxsf39fHYiWJrJ5RQTmks=;
X-UUID: b13fd27570944096b1cf0dedc847be4b-20200706
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1590028650; Mon, 06 Jul 2020 21:21:22 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 6 Jul 2020 21:21:16 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 21:21:10 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3] scsi: ufs: Cleanup completed request without interrupt notification
Date:   Mon, 6 Jul 2020 21:21:13 +0800
Message-ID: <20200706132113.21096-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: ACCDC8000567A9642C17428D46DC7631AE2F5179EBF4FB271AB3B227D089DFBA2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SWYgc29tZWhvdyBubyBpbnRlcnJ1cHQgbm90aWZpY2F0aW9uIGlzIHJhaXNlZCBmb3IgYSBjb21w
bGV0ZWQgcmVxdWVzdA0KYW5kIGl0cyBkb29yYmVsbCBiaXQgaXMgY2xlYXJlZCBieSBob3N0LCBV
RlMgZHJpdmVyIG5lZWRzIHRvIGNsZWFudXANCml0cyBvdXRzdGFuZGluZyBiaXQgaW4gdWZzaGNk
X2Fib3J0KCkuDQoNCk90aGVyd2lzZSwgc3lzdGVtIG1heSBjcmFzaCBieSBiZWxvdyBhYm5vcm1h
bCBmbG93Og0KDQpBZnRlciB0aGlzIHJlcXVlc3QgaXMgcmVxdWV1ZWQgYnkgU0NTSSBsYXllciB3
aXRoIGl0cw0Kb3V0c3RhbmRpbmcgYml0IHNldCwgdGhlIG5leHQgY29tcGxldGVkIHJlcXVlc3Qg
d2lsbCB0cmlnZ2VyDQp1ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkgdG8gaGFuZGxlIGFsbCAi
Y29tcGxldGVkIG91dHN0YW5kaW5nDQpiaXRzIi4gSW4gdGhpcyB0aW1lLCB0aGUgImFibm9ybWFs
IG91dHN0YW5kaW5nIGJpdCIgd2lsbCBiZSBkZXRlY3RlZA0KYW5kIHRoZSAicmVxdWV1ZWQgcmVx
dWVzdCIgd2lsbCBiZSBjaG9zZW4gdG8gZXhlY3V0ZSByZXF1ZXN0DQpwb3N0LXByb2Nlc3Npbmcg
Zmxvdy4gVGhpcyBpcyB3cm9uZyBhbmQgYmxrX2ZpbmlzaF9yZXF1ZXN0KCkgd2lsbA0KQlVHX09O
IGJlY2F1c2UgdGhpcyByZXF1ZXN0IGlzIHN0aWxsICJhbGl2ZSIuDQoNCkl0IGlzIHdvcnRoIG1l
bnRpb25pbmcgdGhhdCBiZWZvcmUgdWZzaGNkX2Fib3J0KCkgY2xlYW5zIHRoZSB0aW1lZC1vdXQN
CnJlcXVlc3QsIGRyaXZlciBuZWVkIHRvIGNoZWNrIGFnYWluIGlmIHRoaXMgcmVxdWVzdCBpcyBy
ZWFsbHkgbm90DQpoYW5kbGVkIGJ5IF9fdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbCgpIHlldCBi
ZWNhdXNlIGl0IG1heSBiZQ0KcG9zc2libGUgdGhhdCB0aGUgaW50ZXJydXB0IGNvbWVzIHZlcnkg
bGF0ZWx5IGJlZm9yZSB0aGUgY2xlYW5pbmcuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1
IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jIHwgOSArKysrKysrLS0NCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IDg2MDNiMDcwNDVhNi4uZjIzZmIxNGRmOWY2
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTY0NjIsNyArNjQ2Miw3IEBAIHN0YXRpYyBpbnQgdWZzaGNk
X2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCiAJCQkvKiBjb21tYW5kIGNvbXBsZXRlZCBh
bHJlYWR5ICovDQogCQkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBjbWQgYXQgdGFnICVkIHN1Y2Nl
c3NmdWxseSBjbGVhcmVkIGZyb20gREIuXG4iLA0KIAkJCQlfX2Z1bmNfXywgdGFnKTsNCi0JCQln
b3RvIG91dDsNCisJCQlnb3RvIGNsZWFudXA7DQogCQl9IGVsc2Ugew0KIAkJCWRldl9lcnIoaGJh
LT5kZXYsDQogCQkJCSIlczogbm8gcmVzcG9uc2UgZnJvbSBkZXZpY2UuIHRhZyA9ICVkLCBlcnIg
JWRcbiIsDQpAQCAtNjQ5Niw5ICs2NDk2LDE0IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Fib3J0KHN0
cnVjdCBzY3NpX2NtbmQgKmNtZCkNCiAJCWdvdG8gb3V0Ow0KIAl9DQogDQorY2xlYW51cDoNCisJ
c3Bpbl9sb2NrX2lycXNhdmUoaG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQorCWlmICghdGVzdF9i
aXQodGFnLCAmaGJhLT5vdXRzdGFuZGluZ19yZXFzKSkgew0KKwkJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZShob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCisJCWdvdG8gb3V0Ow0KKwl9DQogCXNjc2lf
ZG1hX3VubWFwKGNtZCk7DQogDQotCXNwaW5fbG9ja19pcnFzYXZlKGhvc3QtPmhvc3RfbG9jaywg
ZmxhZ3MpOw0KIAl1ZnNoY2Rfb3V0c3RhbmRpbmdfcmVxX2NsZWFyKGhiYSwgdGFnKTsNCiAJaGJh
LT5scmJbdGFnXS5jbWQgPSBOVUxMOw0KIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKGhvc3QtPmhv
c3RfbG9jaywgZmxhZ3MpOw0KLS0gDQoyLjE4LjANCg==

