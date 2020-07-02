Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1C0C433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 04:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 250F520737
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 04:19:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aV2nyORk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgGBES7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 00:18:59 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:4351 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725805AbgGBES7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 00:18:59 -0400
X-UUID: 85ef42937a6b4e188dd4301f889dcbda-20200702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=/qeQiCFhQmAtM64O6dojVLSgPjBT9w/q1FMAsMB08+A=;
        b=aV2nyORkzJYYiT6Gs1BsnJsWPTb2nM169cI40FCjrhWNY7q7VUcQqNxIplVbcPhfOKgzI54TCWo79ZxZpsXeQRRmpvjtwMAvcBI9dRoHJOplsTyRV50akMpQ/uFqvazZwa5jptrsmtUh0RfUC3Sy/UdBecZB6Dsnie8d8wm6z30=;
X-UUID: 85ef42937a6b4e188dd4301f889dcbda-20200702
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2103082871; Thu, 02 Jul 2020 12:18:54 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 2 Jul 2020 12:18:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Jul 2020 12:18:50 +0800
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
Subject: [PATCH v2] scsi: ufs: Cleanup completed request without interrupt notification
Date:   Thu, 2 Jul 2020 12:18:50 +0800
Message-ID: <20200702041850.28028-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: C1DD82904CC95CD3D55608FC5688E3E24E6DF85F9CF1A10FBA16024867C278752000:8
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
CnJlcXVlc3QsIGRyaXZlciBuZWVkcyB0byBjaGVjayBhZ2FpbiBpZiB0aGlzIHJlcXVlc3QgaXMg
cmVhbGx5IG5vdA0KaGFuZGxlZCBieSBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKSB5ZXQg
YmVjYXVzZSBpdCBpcyBwb3NzaWJsZQ0KdGhhdCBpdHMgaW50ZXJydXB0IGNvbWVzIHZlcnkgbGF0
ZWx5IGJlZm9yZSB0aGUgY2xlYW5pbmcuDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxz
dGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
IHwgOSArKysrKysrLS0NCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IGNhZGZhOTAwNjk3Mi4uMGY0ZjMyNTVlNDAzIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KQEAgLTY0NjIsNyArNjQ2Miw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Fi
b3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCiAJCQkvKiBjb21tYW5kIGNvbXBsZXRlZCBhbHJl
YWR5ICovDQogCQkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBjbWQgYXQgdGFnICVkIHN1Y2Nlc3Nm
dWxseSBjbGVhcmVkIGZyb20gREIuXG4iLA0KIAkJCQlfX2Z1bmNfXywgdGFnKTsNCi0JCQlnb3Rv
IG91dDsNCisJCQlnb3RvIGNsZWFudXA7DQogCQl9IGVsc2Ugew0KIAkJCWRldl9lcnIoaGJhLT5k
ZXYsDQogCQkJCSIlczogbm8gcmVzcG9uc2UgZnJvbSBkZXZpY2UuIHRhZyA9ICVkLCBlcnIgJWRc
biIsDQpAQCAtNjQ5Niw5ICs2NDk2LDE0IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Fib3J0KHN0cnVj
dCBzY3NpX2NtbmQgKmNtZCkNCiAJCWdvdG8gb3V0Ow0KIAl9DQogDQorY2xlYW51cDoNCisJc3Bp
bl9sb2NrX2lycXNhdmUoaG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQorCWlmICghdGVzdF9iaXQo
dGFnLCBoYmEtPm91dHN0YW5kaW5nX3JlcXMpKSB7DQorCQlzcGluX3VubG9ja19pcnFyZXN0b3Jl
KGhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KKwkJZ290byBvdXQ7DQorCX0NCiAJc2NzaV9kbWFf
dW5tYXAoY21kKTsNCiANCi0Jc3Bpbl9sb2NrX2lycXNhdmUoaG9zdC0+aG9zdF9sb2NrLCBmbGFn
cyk7DQogCXVmc2hjZF9vdXRzdGFuZGluZ19yZXFfY2xlYXIoaGJhLCB0YWcpOw0KIAloYmEtPmxy
Ylt0YWddLmNtZCA9IE5VTEw7DQogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaG9zdC0+aG9zdF9s
b2NrLCBmbGFncyk7DQotLSANCjIuMTguMA0K

