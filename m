Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9D3C5ACD8
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 10:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 910E520771
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 10:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="k09ThN1C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgCRKk1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 06:40:27 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:9266 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727594AbgCRKk1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 06:40:27 -0400
X-UUID: 73f1d53a91be44aba7e3f3c92256d060-20200318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=l43Y70kKFAGzTa2uG8nek85a7oOhGxZciCH5vTIHDnc=;
        b=k09ThN1CtOphyopAWLDJV+rPnRSJNOh5E9mOuqTJ7s75Q0dj2yF09KdbFWi0ODeCDSmx21LNBhxFn3D7RDoMuqGoSkSw9WsQNB2035yfoymFmVcCJs9Gse2S0tkl5XUR/Ggyn31OSudoU/qhmBq5VIpIXOJEFv0bfEwPZSvDY3w=;
X-UUID: 73f1d53a91be44aba7e3f3c92256d060-20200318
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 473040055; Wed, 18 Mar 2020 18:40:22 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 18 Mar 2020 18:37:26 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 18 Mar 2020 18:40:31 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.peter~sen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v7 6/7] scsi: ufs: make HCE polling more compact to improve initialization latency
Date:   Wed, 18 Mar 2020 18:40:15 +0800
Message-ID: <20200318104016.28049-7-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200318104016.28049-1-stanley.chu@mediatek.com>
References: <20200318104016.28049-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: D8C3168073D3976E2DBE66C8C4D3BE939EBB80A91E0D434189AC87BE58D182902000:8
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
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IGM1ZWU3N2E1YmZjNy4uOGVkYjkxYjE5YzMz
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTQzMDQsNyArNDMwNCw3IEBAIGludCB1ZnNoY2RfaGJhX2Vu
YWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAl1ZnNoY2RfZGVsYXlfdXMoaGJhLT5oYmFfZW5h
YmxlX2RlbGF5X3VzLCAxMDApOw0KIA0KIAkvKiB3YWl0IGZvciB0aGUgaG9zdCBjb250cm9sbGVy
IHRvIGNvbXBsZXRlIGluaXRpYWxpemF0aW9uICovDQotCXJldHJ5ID0gMTA7DQorCXJldHJ5ID0g
NTA7DQogCXdoaWxlICh1ZnNoY2RfaXNfaGJhX2FjdGl2ZShoYmEpKSB7DQogCQlpZiAocmV0cnkp
IHsNCiAJCQlyZXRyeS0tOw0KQEAgLTQzMTMsNyArNDMxMyw3IEBAIGludCB1ZnNoY2RfaGJhX2Vu
YWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAkJCQkiQ29udHJvbGxlciBlbmFibGUgZmFpbGVk
XG4iKTsNCiAJCQlyZXR1cm4gLUVJTzsNCiAJCX0NCi0JCXVzbGVlcF9yYW5nZSg1MDAwLCA1MTAw
KTsNCisJCXVzbGVlcF9yYW5nZSgxMDAwLCAxMTAwKTsNCiAJfQ0KIA0KIAkvKiBlbmFibGUgVUlD
IHJlbGF0ZWQgaW50ZXJydXB0cyAqLw0KLS0gDQoyLjE4LjANCg==

