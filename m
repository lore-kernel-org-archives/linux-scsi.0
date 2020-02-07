Return-Path: <SRS0=jGTy=33=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68D5C2D0B1
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 07:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73A8622314
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 07:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IDDf/v7q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgBGHEH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 02:04:07 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:56362 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726573AbgBGHEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 02:04:06 -0500
X-UUID: 68390ea84fc14b07aa96cce384b45442-20200207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=6jM/oR06razYnFBu9+gewGY3eZHYhaG1HA0jqsKM5V0=;
        b=IDDf/v7qRZ49wRCyJyBLD3I7xIp+7uXiIecE3zVt8vnkCZwYZILvjE8S/1gqiUr1V3kKHCpfNTDY4+wbwY2PvtiCEi5xcs0uENPZRlOm6rl2PVW3IL5aYR8Wn4FLNjr7aOy0hIeCE4tDrzMMHu97XEU9uJrZ36aUBRZqmv1HNfc=;
X-UUID: 68390ea84fc14b07aa96cce384b45442-20200207
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1088173936; Fri, 07 Feb 2020 15:03:59 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 7 Feb 2020 15:02:27 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 7 Feb 2020 15:04:28 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>
CC:     <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 2/2] scsi: ufs: introduce common function to disable host TX LCC
Date:   Fri, 7 Feb 2020 15:03:57 +0800
Message-ID: <20200207070357.17169-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200207070357.17169-1-stanley.chu@mediatek.com>
References: <20200207070357.17169-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWFueSB2ZW5kb3JzIHdvdWxkIGxpa2UgdG8gZGlzYWJsZSBob3N0IFRYIExDQyBkdXJpbmcgaW5p
dGlhbGl6YXRpb24NCmZsb3cuIEludHJvZHVjZSBhIGNvbW1vbiBmdW5jdGlvbiBmb3IgYWxsIHVz
ZXJzIHRvIG1ha2UgZHJpdmVycyBlYXNpZXIgdG8NCnJlYWQgYW5kIG1haW50YWluZWQuIFRoaXMg
cGF0Y2ggZG9lcyBub3QgY2hhbmdlIGFueSBmdW5jdGlvbmFsaXR5Lg0KDQpTaWduZWQtb2ZmLWJ5
OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9z
Y3NpL3Vmcy9jZG5zLXBsdGZybS5jICB8IDIgKy0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1oaXNp
LmMgICAgIHwgMiArLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAyICstDQog
ZHJpdmVycy9zY3NpL3Vmcy91ZnMtcWNvbS5jICAgICB8IDQgKy0tLQ0KIGRyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLXBjaS5jICAgfCAyICstDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICAg
ICB8IDUgKysrKysNCiA2IGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDcgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL2NkbnMtcGx0ZnJtLmMgYi9k
cml2ZXJzL3Njc2kvdWZzL2NkbnMtcGx0ZnJtLmMNCmluZGV4IDU2YTZhMWVkNWVjMi4uZGEwNjVh
MjU5ZjZlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy9jZG5zLXBsdGZybS5jDQorKysg
Yi9kcml2ZXJzL3Njc2kvdWZzL2NkbnMtcGx0ZnJtLmMNCkBAIC0xOTIsNyArMTkyLDcgQEAgc3Rh
dGljIGludCBjZG5zX3Vmc19saW5rX3N0YXJ0dXBfbm90aWZ5KHN0cnVjdCB1ZnNfaGJhICpoYmEs
DQogCSAqIGFuZCBkZXZpY2UgVFggTENDIGFyZSBkaXNhYmxlZCBvbmNlIGxpbmsgc3RhcnR1cCBp
cw0KIAkgKiBjb21wbGV0ZWQuDQogCSAqLw0KLQl1ZnNoY2RfZG1lX3NldChoYmEsIFVJQ19BUkdf
TUlCKFBBX0xPQ0FMX1RYX0xDQ19FTkFCTEUpLCAwKTsNCisJdWZzaGNkX2Rpc2FibGVfaG9zdF90
eF9sY2MoaGJhKTsNCiANCiAJLyoNCiAJICogRGlzYWJsaW5nIEF1dG9oaWJlcm44IGZlYXR1cmUg
aW4gY2FkZW5jZSBVRlMNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1oaXNpLmMg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1oaXNpLmMNCmluZGV4IDVkNjQ4NzM1MGE2Yy4uMDc0YTZh
MDU1YTRjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtaGlzaS5jDQorKysgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmcy1oaXNpLmMNCkBAIC0yMzUsNyArMjM1LDcgQEAgc3RhdGljIGlu
dCB1ZnNfaGlzaV9saW5rX3N0YXJ0dXBfcHJlX2NoYW5nZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0K
IAl1ZnNoY2Rfd3JpdGVsKGhiYSwgcmVnLCBSRUdfQVVUT19ISUJFUk5BVEVfSURMRV9USU1FUik7
DQogDQogCS8qIFVuaXBybyBQQV9Mb2NhbF9UWF9MQ0NfRW5hYmxlICovDQotCXVmc2hjZF9kbWVf
c2V0KGhiYSwgVUlDX0FSR19NSUJfU0VMKDB4MTU1RSwgMHgwKSwgMHgwKTsNCisJdWZzaGNkX2Rp
c2FibGVfaG9zdF90eF9sY2MoaGJhKTsNCiAJLyogY2xvc2UgVW5pcHJvIFZTX01rMkV4dG5TdXBw
b3J0ICovDQogCXVmc2hjZF9kbWVfc2V0KGhiYSwgVUlDX0FSR19NSUJfU0VMKDB4RDBBQiwgMHgw
KSwgMHgwKTsNCiAJdWZzaGNkX2RtZV9nZXQoaGJhLCBVSUNfQVJHX01JQl9TRUwoMHhEMEFCLCAw
eDApLCAmdmFsdWUpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCA4ZjczYzg2MGY0MjMu
LjlkMDU5NjJmZWIxNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0zMTgsNyArMzE4
LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX3ByZV9saW5rKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQog
CSAqIHRvIG1ha2Ugc3VyZSB0aGF0IGJvdGggaG9zdCBhbmQgZGV2aWNlIFRYIExDQyBhcmUgZGlz
YWJsZWQNCiAJICogb25jZSBsaW5rIHN0YXJ0dXAgaXMgY29tcGxldGVkLg0KIAkgKi8NCi0JcmV0
ID0gdWZzaGNkX2RtZV9zZXQoaGJhLCBVSUNfQVJHX01JQihQQV9MT0NBTF9UWF9MQ0NfRU5BQkxF
KSwgMCk7DQorCXJldCA9IHVmc2hjZF9kaXNhYmxlX2hvc3RfdHhfbGNjKGhiYSk7DQogCWlmIChy
ZXQpDQogCQlyZXR1cm4gcmV0Ow0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
LXFjb20uYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXFjb20uYw0KaW5kZXggYzY5YzI5YTFjZWI5
Li5jMmU3MDNkNThmNjMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1xY29tLmMN
CisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXFjb20uYw0KQEAgLTU1NCw5ICs1NTQsNyBAQCBz
dGF0aWMgaW50IHVmc19xY29tX2xpbmtfc3RhcnR1cF9ub3RpZnkoc3RydWN0IHVmc19oYmEgKmhi
YSwNCiAJCSAqIGNvbXBsZXRlZC4NCiAJCSAqLw0KIAkJaWYgKHVmc2hjZF9nZXRfbG9jYWxfdW5p
cHJvX3ZlcihoYmEpICE9IFVGU19VTklQUk9fVkVSXzFfNDEpDQotCQkJZXJyID0gdWZzaGNkX2Rt
ZV9zZXQoaGJhLA0KLQkJCQkJVUlDX0FSR19NSUIoUEFfTE9DQUxfVFhfTENDX0VOQUJMRSksDQot
CQkJCQkwKTsNCisJCQllcnIgPSB1ZnNoY2RfZGlzYWJsZV9ob3N0X3R4X2xjYyhoYmEpOw0KIA0K
IAkJYnJlYWs7DQogCWNhc2UgUE9TVF9DSEFOR0U6DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QtcGNpLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC1wY2kuYw0KaW5kZXgg
M2IxOWRlM2FlOWEzLi44Zjc4YTgxNTE0OTkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC1wY2kuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QtcGNpLmMNCkBAIC00
NCw3ICs0NCw3IEBAIHN0YXRpYyBpbnQgdWZzX2ludGVsX2Rpc2FibGVfbGNjKHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQogDQogCXVmc2hjZF9kbWVfZ2V0KGhiYSwgYXR0ciwgJmxjY19lbmFibGUpOw0K
IAlpZiAobGNjX2VuYWJsZSkNCi0JCXVmc2hjZF9kbWVfc2V0KGhiYSwgYXR0ciwgMCk7DQorCQl1
ZnNoY2RfZGlzYWJsZV9ob3N0X3R4X2xjYyhoYmEpOw0KIA0KIAlyZXR1cm4gMDsNCiB9DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmgNCmluZGV4IDgxYzcxYTNlMzQ3NC4uOGY1MTZiMjA1YzMyIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0K
QEAgLTkxNCw2ICs5MTQsMTEgQEAgc3RhdGljIGlubGluZSBib29sIHVmc2hjZF9pc19oc19tb2Rl
KHN0cnVjdCB1ZnNfcGFfbGF5ZXJfYXR0ciAqcHdyX2luZm8pDQogCQlwd3JfaW5mby0+cHdyX3R4
ID09IEZBU1RBVVRPX01PREUpOw0KIH0NCiANCitzdGF0aWMgaW5saW5lIGludCB1ZnNoY2RfZGlz
YWJsZV9ob3N0X3R4X2xjYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KK3sNCisJcmV0dXJuIHVmc2hj
ZF9kbWVfc2V0KGhiYSwgVUlDX0FSR19NSUIoUEFfTE9DQUxfVFhfTENDX0VOQUJMRSksIDApOw0K
K30NCisNCiAvKiBFeHBvc2UgUXVlcnktUmVxdWVzdCBBUEkgKi8NCiBpbnQgdWZzaGNkX3F1ZXJ5
X2Rlc2NyaXB0b3JfcmV0cnkoc3RydWN0IHVmc19oYmEgKmhiYSwNCiAJCQkJICBlbnVtIHF1ZXJ5
X29wY29kZSBvcGNvZGUsDQotLSANCjIuMTguMA0K

