Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6488C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6DEA2145D
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dDPeR2Bv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgGFGHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 02:07:15 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:35226 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728804AbgGFGHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 02:07:14 -0400
X-UUID: f9c7543e3cfb4eea8d38537abd01cead-20200706
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=K3vnY4vJ20RrpHZtSxjh1pS6uvuzwjSGdbDQC5YzlTA=;
        b=dDPeR2BvQbtjE/+YK0FSLimrPno8x7S5Jf1ZGUc2W5G6KLxFk50rGl15/Ir2nuE34E4MsYF/l0oa087yGm8qI4/kHGnrkiftOChWILMLy2bhKyLpbcv8yON/j03OkM59MkG7dZufY9XZpS1fzVEFQa8xjO4b9+u+WwOKn43mVEQ=;
X-UUID: f9c7543e3cfb4eea8d38537abd01cead-20200706
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 214281005; Mon, 06 Jul 2020 14:07:09 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 6 Jul 2020 14:07:05 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 14:07:05 +0800
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
Subject: [PATCH v1 2/2] scsi: ufs: Fix and simplify setup_xfer_req variant operation
Date:   Mon, 6 Jul 2020 14:07:07 +0800
Message-ID: <20200706060707.32608-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200706060707.32608-1-stanley.chu@mediatek.com>
References: <20200706060707.32608-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 3B79C800335062181EE35A37B171FE0DD4A7E7E504399B0E527962A6C9E7EB602000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIG1pc3NpbmcgInNldHVwX3hmZXJfcmVxIiBjYWxsIGluIHVmc2hjZF9pc3N1ZV9kZXZtYW5f
dXBpdV9jbWQoKQ0KYnkgdWZzLWJzZyBwYXRoLCBhbmQgY29sbGVjdCBhbGwgInNldHVwX3hmZXJf
cmVxIiBjYWxscyB0byBhbiB1bmlmaWVkDQpwbGFjZSwgaS5lLiwgdWZzaGNkX3NlbmRfY29tbWFu
ZCgpLCB0byBzaW1wbGlmeSB0aGUgZHJpdmVyLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENo
dSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYyB8IDkgKysrKystLS0tDQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCA3MWU4ZDdjNzgyYmQuLjg2MDNiMDcwNDVh
NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMNCkBAIC0xOTI1LDggKzE5MjUsMTEgQEAgc3RhdGljIHZvaWQgdWZz
aGNkX2Nsa19zY2FsaW5nX3VwZGF0ZV9idXN5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogc3RhdGlj
IGlubGluZQ0KIHZvaWQgdWZzaGNkX3NlbmRfY29tbWFuZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1
bnNpZ25lZCBpbnQgdGFza190YWcpDQogew0KLQloYmEtPmxyYlt0YXNrX3RhZ10uaXNzdWVfdGlt
ZV9zdGFtcCA9IGt0aW1lX2dldCgpOw0KLQloYmEtPmxyYlt0YXNrX3RhZ10uY29tcGxfdGltZV9z
dGFtcCA9IGt0aW1lX3NldCgwLCAwKTsNCisJc3RydWN0IHVmc2hjZF9scmIgKmxyYnAgPSAmaGJh
LT5scmJbdGFza190YWddOw0KKw0KKwlscmJwLT5pc3N1ZV90aW1lX3N0YW1wID0ga3RpbWVfZ2V0
KCk7DQorCWxyYnAtPmNvbXBsX3RpbWVfc3RhbXAgPSBrdGltZV9zZXQoMCwgMCk7DQorCXVmc2hj
ZF92b3BzX3NldHVwX3hmZXJfcmVxKGhiYSwgdGFza190YWcsIChscmJwLT5jbWQgPyB0cnVlIDog
ZmFsc2UpKTsNCiAJdWZzaGNkX2FkZF9jb21tYW5kX3RyYWNlKGhiYSwgdGFza190YWcsICJzZW5k
Iik7DQogCXVmc2hjZF9jbGtfc2NhbGluZ19zdGFydF9idXN5KGhiYSk7DQogCV9fc2V0X2JpdCh0
YXNrX3RhZywgJmhiYS0+b3V0c3RhbmRpbmdfcmVxcyk7DQpAQCAtMjU0NCw3ICsyNTQ3LDYgQEAg
c3RhdGljIGludCB1ZnNoY2RfcXVldWVjb21tYW5kKHN0cnVjdCBTY3NpX0hvc3QgKmhvc3QsIHN0
cnVjdCBzY3NpX2NtbmQgKmNtZCkNCiANCiAJLyogaXNzdWUgY29tbWFuZCB0byB0aGUgY29udHJv
bGxlciAqLw0KIAlzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3Mp
Ow0KLQl1ZnNoY2Rfdm9wc19zZXR1cF94ZmVyX3JlcShoYmEsIHRhZywgdHJ1ZSk7DQogCXVmc2hj
ZF9zZW5kX2NvbW1hbmQoaGJhLCB0YWcpOw0KIG91dF91bmxvY2s6DQogCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCkBAIC0yNzMxLDcgKzI3MzMs
NiBAQCBzdGF0aWMgaW50IHVmc2hjZF9leGVjX2Rldl9jbWQoc3RydWN0IHVmc19oYmEgKmhiYSwN
CiAJLyogTWFrZSBzdXJlIGRlc2NyaXB0b3JzIGFyZSByZWFkeSBiZWZvcmUgcmluZ2luZyB0aGUg
ZG9vcmJlbGwgKi8NCiAJd21iKCk7DQogCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+aG9z
dF9sb2NrLCBmbGFncyk7DQotCXVmc2hjZF92b3BzX3NldHVwX3hmZXJfcmVxKGhiYSwgdGFnLCBm
YWxzZSk7DQogCXVmc2hjZF9zZW5kX2NvbW1hbmQoaGJhLCB0YWcpOw0KIAlzcGluX3VubG9ja19p
cnFyZXN0b3JlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQogDQotLSANCjIuMTguMA0K

