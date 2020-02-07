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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0545DC352A2
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 07:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF0DF22314
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 07:04:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="X6N5ujWE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgBGHEG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 02:04:06 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:52391 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbgBGHEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 02:04:06 -0500
X-UUID: de04c1f7046b4281ab8515025981eabc-20200207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=5HvzdlfZTx72XjylW/wDM1/cgbzDal8HbcC73gtLS5I=;
        b=X6N5ujWEQJWf8eWPMF//rRdl4bdWz1lRYuIW3PjErtA21bDWt0ztIzIj7Wmq1tWClRmEjyQxn+1agU8mQuAHPF5+yxYc05/D/8QuCz8cfxsMp1TobP+laKszf+aNdygbBUUlAmYWK5MersZ+7ALuQYLKtrAEREA5Cz5caTZ4JP4=;
X-UUID: de04c1f7046b4281ab8515025981eabc-20200207
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 219011743; Fri, 07 Feb 2020 15:04:00 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 7 Feb 2020 15:02:41 +0800
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
Subject: [PATCH v1 1/2] scsi: ufs: ufs-mediatek: fix TX LCC disabling timing
Date:   Fri, 7 Feb 2020 15:03:56 +0800
Message-ID: <20200207070357.17169-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200207070357.17169-1-stanley.chu@mediatek.com>
References: <20200207070357.17169-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: CCF22BD2D5023F448DCF45E9C134A9B5F693F4DF05BCEC3FF893F596DE7ED9352000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWVkaWFUZWsgVUZTIGhvc3QgcmVxdWlyZXMgVFggTENDIHRvIGJlIGRpc2FibGVkIGluIGJvdGgg
aG9zdA0KYW5kIGRldmljZSBzaWRlcy4gVGhpcyBjYW4gYmUgZG9uZSBieSBkaXNhYmxpbmcgaG9z
dCdzIGxvY2FsIFRYIExDQw0KYmVmb3JlIGxpbmsgc3RhcnR1cC4gQ29ycmVjdCBUWCBMQ0MgZGlz
YWJsaW5nIHRpbWluZyBpbiBNZWRpYVRlaw0KVUZTIGRyaXZlci4NCg0KU2lnbmVkLW9mZi1ieTog
U3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAxMiArKysrKysrKystLS0NCiAxIGZpbGUgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMN
CmluZGV4IDBjZTA4ODcyZDY3MS4uOGY3M2M4NjBmNDIzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0
ZWsuYw0KQEAgLTMxMyw2ICszMTMsMTUgQEAgc3RhdGljIGludCB1ZnNfbXRrX3ByZV9saW5rKHN0
cnVjdCB1ZnNfaGJhICpoYmEpDQogDQogCXVmc19tdGtfdW5pcHJvX3Bvd2VyZG93bihoYmEsIDAp
Ow0KIA0KKwkvKg0KKwkgKiBTZXR0aW5nIFBBX0xvY2FsX1RYX0xDQ19FbmFibGUgdG8gMCBiZWZv
cmUgbGluayBzdGFydHVwDQorCSAqIHRvIG1ha2Ugc3VyZSB0aGF0IGJvdGggaG9zdCBhbmQgZGV2
aWNlIFRYIExDQyBhcmUgZGlzYWJsZWQNCisJICogb25jZSBsaW5rIHN0YXJ0dXAgaXMgY29tcGxl
dGVkLg0KKwkgKi8NCisJcmV0ID0gdWZzaGNkX2RtZV9zZXQoaGJhLCBVSUNfQVJHX01JQihQQV9M
T0NBTF9UWF9MQ0NfRU5BQkxFKSwgMCk7DQorCWlmIChyZXQpDQorCQlyZXR1cm4gcmV0Ow0KKw0K
IAkvKiBkaXNhYmxlIGRlZXAgc3RhbGwgKi8NCiAJcmV0ID0gdWZzaGNkX2RtZV9nZXQoaGJhLCBV
SUNfQVJHX01JQihWU19TQVZFUE9XRVJDT05UUk9MKSwgJnRtcCk7DQogCWlmIChyZXQpDQpAQCAt
MzQ0LDkgKzM1Myw2IEBAIHN0YXRpYyB2b2lkIHVmc19tdGtfc2V0dXBfY2xrX2dhdGluZyhzdHJ1
Y3QgdWZzX2hiYSAqaGJhKQ0KIA0KIHN0YXRpYyBpbnQgdWZzX210a19wb3N0X2xpbmsoc3RydWN0
IHVmc19oYmEgKmhiYSkNCiB7DQotCS8qIGRpc2FibGUgZGV2aWNlIExDQyAqLw0KLQl1ZnNoY2Rf
ZG1lX3NldChoYmEsIFVJQ19BUkdfTUlCKFBBX0xPQ0FMX1RYX0xDQ19FTkFCTEUpLCAwKTsNCi0N
CiAJLyogZW5hYmxlIHVuaXBybyBjbG9jayBnYXRpbmcgZmVhdHVyZSAqLw0KIAl1ZnNfbXRrX2Nm
Z191bmlwcm9fY2coaGJhLCB0cnVlKTsNCiANCi0tIA0KMi4xOC4wDQo=

