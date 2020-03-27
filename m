Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5C3C2D0E8
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 638E020717
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QBzBkwQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgC0Jxl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 05:53:41 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:59386 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726193AbgC0Jxj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 05:53:39 -0400
X-UUID: 70eaafd801424d35bd9649492b8e195f-20200327
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=w7oxstLD2GuzbIKhk9bnNyPTXe7NJEzoA3j++6T3ySo=;
        b=QBzBkwQXBm+f4vWbHIUUJNPHiM0p45Rf3xbEmIWcq/q5qROZnBPQEEW6wwhI2OtSln95CMXADkIoMFuKW/0LE+enzWxMPDZ7Y44H9V2jjECgPsaMmFPKtxBwqmhACoVc9ryqQ9WWl9+QjmFp0g+H+RUlYP217Ui31S/fGgTfEfY=;
X-UUID: 70eaafd801424d35bd9649492b8e195f-20200327
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 304698118; Fri, 27 Mar 2020 17:53:33 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 27 Mar 2020 17:53:30 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 27 Mar 2020 17:53:30 +0800
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
Subject: [PATCH v3 1/2] scsi: ufs: export ufshcd_link_recovery for vendor's error recovery
Date:   Fri, 27 Mar 2020 17:53:28 +0800
Message-ID: <20200327095329.10083-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200327095329.10083-1-stanley.chu@mediatek.com>
References: <20200327095329.10083-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: E08D348CC037095C24DB8AD27AA26EF5FAEBA49D95044037708CACD30FC09F102000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ZXhwb3J0IHVmc2hjZF9saW5rX3JlY292ZXJ5IHRvIGFsbG93IHZlbmRvcnMgdG8gcmVjb3ZlciBm
YWlsZWQgbGluaw0KaW4gdmVuZG9yJ3MgY2FsbGJhY2tzLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFu
bGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQtYnk6IEF2cmkgQWx0
bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
YyB8IDMgKystDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8IDEgKw0KIDIgZmlsZXMgY2hh
bmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXgg
YjQyOTRiMmM2ZjRhLi4yMjc2NjBhMWE0NDYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtMzc1Niw3ICsz
NzU2LDcgQEAgc3RhdGljIGludCB1ZnNoY2RfdWljX2NoYW5nZV9wd3JfbW9kZShzdHJ1Y3QgdWZz
X2hiYSAqaGJhLCB1OCBtb2RlKQ0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCi1zdGF0aWMgaW50IHVm
c2hjZF9saW5rX3JlY292ZXJ5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQoraW50IHVmc2hjZF9saW5r
X3JlY292ZXJ5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAlpbnQgcmV0Ow0KIAl1bnNpZ25l
ZCBsb25nIGZsYWdzOw0KQEAgLTM3ODMsNiArMzc4Myw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2xp
bmtfcmVjb3Zlcnkoc3RydWN0IHVmc19oYmEgKmhiYSkNCiANCiAJcmV0dXJuIHJldDsNCiB9DQor
RVhQT1JUX1NZTUJPTF9HUEwodWZzaGNkX2xpbmtfcmVjb3ZlcnkpOw0KIA0KIHN0YXRpYyBpbnQg
X191ZnNoY2RfdWljX2hpYmVybjhfZW50ZXIoc3RydWN0IHVmc19oYmEgKmhiYSkNCiB7DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmgNCmluZGV4IDlmMTU3NmJiZmM1MC4uYjdiZDgxNzk1YzI0IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0K
QEAgLTc5NSw2ICs3OTUsNyBAQCBpbnQgdWZzaGNkX2FsbG9jX2hvc3Qoc3RydWN0IGRldmljZSAq
LCBzdHJ1Y3QgdWZzX2hiYSAqKik7DQogdm9pZCB1ZnNoY2RfZGVhbGxvY19ob3N0KHN0cnVjdCB1
ZnNfaGJhICopOw0KIGludCB1ZnNoY2RfaGJhX2VuYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsN
CiBpbnQgdWZzaGNkX2luaXQoc3RydWN0IHVmc19oYmEgKiAsIHZvaWQgX19pb21lbSAqICwgdW5z
aWduZWQgaW50KTsNCitpbnQgdWZzaGNkX2xpbmtfcmVjb3Zlcnkoc3RydWN0IHVmc19oYmEgKmhi
YSk7DQogaW50IHVmc2hjZF9tYWtlX2hiYV9vcGVyYXRpb25hbChzdHJ1Y3QgdWZzX2hiYSAqaGJh
KTsNCiB2b2lkIHVmc2hjZF9yZW1vdmUoc3RydWN0IHVmc19oYmEgKik7DQogaW50IHVmc2hjZF91
aWNfaGliZXJuOF9leGl0KHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KLS0gDQoyLjE4LjANCg==

