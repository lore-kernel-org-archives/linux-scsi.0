Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9A5C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 09:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CE8220702
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 09:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eUntoQE4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbgFWJFT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 05:05:19 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:12525 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731894AbgFWJFS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 05:05:18 -0400
X-UUID: 476d30af18d14cd08b988024d5536bd0-20200623
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=KrSrGuuWaYdD1xn1WyvfP2hN+0NoJYvJhqKj27QkdiE=;
        b=eUntoQE4VjF28P8VH9xdZRub0VHzYTYEd5Huq8Mm34YtPmJTH5JE0H015DJnqJQr9/nKeqlCmhmdA9VZXZU0W6BBMogD+QAQRNZX+OtxPDdH8SJ72AnLRJaQ+J984rzcfBSjqRk/7HSv3sUHn0owh6rhmA7S/guFGZ+LM1sSPAA=;
X-UUID: 476d30af18d14cd08b988024d5536bd0-20200623
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1576730067; Tue, 23 Jun 2020 17:05:14 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 23 Jun 2020 17:05:06 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Jun 2020 17:05:06 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1] scsi: ufs: Cleanup completed request without interrupt notification
Date:   Tue, 23 Jun 2020 17:05:11 +0800
Message-ID: <20200623090511.20085-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
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
IGJlY2F1c2UgdGhpcyByZXF1ZXN0IGlzIHN0aWxsIGluIHRoZSByZXF1ZXN0IHF1ZXVlLg0KDQpT
aWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0t
DQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDMgKystDQogMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IDUyYWJlODJh
MTE2Ni4uZjE3M2FkMWJkNzlmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
Yw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTY0NjIsNyArNjQ2Miw3IEBA
IHN0YXRpYyBpbnQgdWZzaGNkX2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCiAJCQkvKiBj
b21tYW5kIGNvbXBsZXRlZCBhbHJlYWR5ICovDQogCQkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBj
bWQgYXQgdGFnICVkIHN1Y2Nlc3NmdWxseSBjbGVhcmVkIGZyb20gREIuXG4iLA0KIAkJCQlfX2Z1
bmNfXywgdGFnKTsNCi0JCQlnb3RvIG91dDsNCisJCQlnb3RvIGNsZWFudXA7DQogCQl9IGVsc2Ug
ew0KIAkJCWRldl9lcnIoaGJhLT5kZXYsDQogCQkJCSIlczogbm8gcmVzcG9uc2UgZnJvbSBkZXZp
Y2UuIHRhZyA9ICVkLCBlcnIgJWRcbiIsDQpAQCAtNjQ5Niw2ICs2NDk2LDcgQEAgc3RhdGljIGlu
dCB1ZnNoY2RfYWJvcnQoc3RydWN0IHNjc2lfY21uZCAqY21kKQ0KIAkJZ290byBvdXQ7DQogCX0N
CiANCitjbGVhbnVwOg0KIAlzY3NpX2RtYV91bm1hcChjbWQpOw0KIA0KIAlzcGluX2xvY2tfaXJx
c2F2ZShob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCi0tIA0KMi4xOC4wDQo=

