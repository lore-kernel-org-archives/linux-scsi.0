Return-Path: <SRS0=TiDh=47=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A3BC10DCE
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Mar 2020 03:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B2D92076B
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Mar 2020 03:16:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rYS25dAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgCNDQL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 23:16:11 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:51114 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726530AbgCNDQK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 23:16:10 -0400
X-UUID: bd1b57b6588349d08c3d5522e605bd8b-20200314
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=YAtFprbEne3aSZz7JwyfciYW/D36KWtz75LLZ+igOYI=;
        b=rYS25dAToOayfxUq0sLY2CN0nKiha5fkPu8HSgbMA2H7NMO4Rra0pKQxYveFC+LKbEVusJ/fmp7OOV8niL0zwKjrxowm9dQycBVqrcNTPb6YqfDEvqxpl4dyqBwbH5WCdCpjCK8bvYMqEad9y6NJ8gkoa3zLly5bwCFBXawvD0Y=;
X-UUID: bd1b57b6588349d08c3d5522e605bd8b-20200314
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 745921413; Sat, 14 Mar 2020 11:16:03 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 14 Mar 2020 11:13:49 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 14 Mar 2020 11:15:58 +0800
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
Subject: [PATCH v1 1/2] scsi: ufs: export ufshcd_link_recovery for vendor's error recovery
Date:   Sat, 14 Mar 2020 11:15:59 +0800
Message-ID: <20200314031600.10616-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200314031600.10616-1-stanley.chu@mediatek.com>
References: <20200314031600.10616-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ZXhwb3J0IHVmc2hjZF9saW5rX3JlY292ZXJ5IHRvIGFsbG93IHZlbmRvcnMgdG8gcmVjb3ZlciBm
YWlsZWQgbGluaw0KaW4gdmVuZG9yJ3MgY2FsbGJhY2tzLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFu
bGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYyB8IDMgKystDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8IDEgKw0KIDIg
ZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
Yw0KaW5kZXggY2QzM2QwN2M1NmNmLi5jYTliNjg5ODY0OGEgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAt
MzgxMiw3ICszODEyLDcgQEAgc3RhdGljIGludCB1ZnNoY2RfdWljX2NoYW5nZV9wd3JfbW9kZShz
dHJ1Y3QgdWZzX2hiYSAqaGJhLCB1OCBtb2RlKQ0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCi1zdGF0
aWMgaW50IHVmc2hjZF9saW5rX3JlY292ZXJ5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQoraW50IHVm
c2hjZF9saW5rX3JlY292ZXJ5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAlpbnQgcmV0Ow0K
IAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KQEAgLTM4MzksNiArMzgzOSw3IEBAIHN0YXRpYyBpbnQg
dWZzaGNkX2xpbmtfcmVjb3Zlcnkoc3RydWN0IHVmc19oYmEgKmhiYSkNCiANCiAJcmV0dXJuIHJl
dDsNCiB9DQorRVhQT1JUX1NZTUJPTF9HUEwodWZzaGNkX2xpbmtfcmVjb3ZlcnkpOw0KIA0KIHN0
YXRpYyBpbnQgX191ZnNoY2RfdWljX2hpYmVybjhfZW50ZXIoc3RydWN0IHVmc19oYmEgKmhiYSkN
CiB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmgNCmluZGV4IDI2OWRkYjkyYmI1NS4uZTcwMTk2MGY4NjY5IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuaA0KQEAgLTc3OSw2ICs3NzksNyBAQCBpbnQgdWZzaGNkX2FsbG9jX2hvc3Qoc3RydWN0
IGRldmljZSAqLCBzdHJ1Y3QgdWZzX2hiYSAqKik7DQogdm9pZCB1ZnNoY2RfZGVhbGxvY19ob3N0
KHN0cnVjdCB1ZnNfaGJhICopOw0KIGludCB1ZnNoY2RfaGJhX2VuYWJsZShzdHJ1Y3QgdWZzX2hi
YSAqaGJhKTsNCiBpbnQgdWZzaGNkX2luaXQoc3RydWN0IHVmc19oYmEgKiAsIHZvaWQgX19pb21l
bSAqICwgdW5zaWduZWQgaW50KTsNCitpbnQgdWZzaGNkX2xpbmtfcmVjb3Zlcnkoc3RydWN0IHVm
c19oYmEgKmhiYSk7DQogaW50IHVmc2hjZF9tYWtlX2hiYV9vcGVyYXRpb25hbChzdHJ1Y3QgdWZz
X2hiYSAqaGJhKTsNCiB2b2lkIHVmc2hjZF9yZW1vdmUoc3RydWN0IHVmc19oYmEgKik7DQogaW50
IHVmc2hjZF91aWNfaGliZXJuOF9leGl0KHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KLS0gDQoyLjE4
LjANCg==

