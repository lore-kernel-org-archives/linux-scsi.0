Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AD8C5ACD6
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 10:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A22612076D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 10:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hnwE2MXA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgCRKko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 06:40:44 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:42689 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727702AbgCRKk3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 06:40:29 -0400
X-UUID: 902edc92533d4cdaa10ccfb312d2a90f-20200318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=SujIfavt6nl6SADi9CBMgGUh+AUKfIUyar7ayBhr5XY=;
        b=hnwE2MXA4UEfCRWY13D2cI0XA8YR/yu3/Qrec5wkIN5G/3maN7eCirSbCIcnWppA2VXR1z0c1j5CbIWddRXHhrh1Ca2s5uqOskeka0izJ93QFtcVebH3l6qdDtWHwNyYY5+mqwRvD7uXhXvFsMSpXSdXblKsREMcgmb3gfRsuBc=;
X-UUID: 902edc92533d4cdaa10ccfb312d2a90f-20200318
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1482939392; Wed, 18 Mar 2020 18:40:20 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 18 Mar 2020 18:39:00 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 18 Mar 2020 18:40:30 +0800
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
Subject: [PATCH v7 3/7] scsi: ufs: introduce common and flexible delay function
Date:   Wed, 18 Mar 2020 18:40:12 +0800
Message-ID: <20200318104016.28049-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200318104016.28049-1-stanley.chu@mediatek.com>
References: <20200318104016.28049-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW50cm9kdWNlIGEgY29tbW9uIGRlbGF5IGZ1bmN0aW9uIHRvIHByb3ZpZGUgZmxleGlibGUgd2F5
IGZvciB1c2Vycw0KdG8gdGFrZSBjaG9pY2VzIG9mIHVkZWxheSBhbmQgdXNsZWVwX3JhbmdlIGlu
dG8gY29uc2lkZXJhdGlvbiBhY2NvcmRpbmcNCnRvIHRoZSByZXF1aXJlZCBkZWxheSB0aW1lLg0K
DQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0K
UmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KUmV2aWV3ZWQt
Ynk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jIHwgMTIgKysrKysrKysrKysrDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8
ICAxICsNCiAyIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQpp
bmRleCAzMTRlODA4YjBkNGUuLmE0MmE4NDE2NGRlYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC01OTcs
NiArNTk3LDE4IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9wcmludF9wd3JfaW5mbyhzdHJ1Y3QgdWZz
X2hiYSAqaGJhKQ0KIAkJIGhiYS0+cHdyX2luZm8uaHNfcmF0ZSk7DQogfQ0KIA0KK3ZvaWQgdWZz
aGNkX2RlbGF5X3VzKHVuc2lnbmVkIGxvbmcgdXMsIHVuc2lnbmVkIGxvbmcgdG9sZXJhbmNlKQ0K
K3sNCisJaWYgKCF1cykNCisJCXJldHVybjsNCisNCisJaWYgKHVzIDwgMTApDQorCQl1ZGVsYXko
dXMpOw0KKwllbHNlDQorCQl1c2xlZXBfcmFuZ2UodXMsIHVzICsgdG9sZXJhbmNlKTsNCit9DQor
RVhQT1JUX1NZTUJPTF9HUEwodWZzaGNkX2RlbGF5X3VzKTsNCisNCiAvKg0KICAqIHVmc2hjZF93
YWl0X2Zvcl9yZWdpc3RlciAtIHdhaXQgZm9yIHJlZ2lzdGVyIHZhbHVlIHRvIGNoYW5nZQ0KICAq
IEBoYmEgLSBwZXItYWRhcHRlciBpbnRlcmZhY2UNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggNTI0MjUzNzEw
ODJhLi45YTE0ZmYzZDVmOGIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5o
DQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtNzkyLDYgKzc5Miw3IEBAIGlu
dCB1ZnNoY2RfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqICwgdm9pZCBfX2lvbWVtICogLCB1bnNpZ25l
ZCBpbnQpOw0KIGludCB1ZnNoY2RfbWFrZV9oYmFfb3BlcmF0aW9uYWwoc3RydWN0IHVmc19oYmEg
KmhiYSk7DQogdm9pZCB1ZnNoY2RfcmVtb3ZlKHN0cnVjdCB1ZnNfaGJhICopOw0KIGludCB1ZnNo
Y2RfdWljX2hpYmVybjhfZXhpdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCit2b2lkIHVmc2hjZF9k
ZWxheV91cyh1bnNpZ25lZCBsb25nIHVzLCB1bnNpZ25lZCBsb25nIHRvbGVyYW5jZSk7DQogaW50
IHVmc2hjZF93YWl0X2Zvcl9yZWdpc3RlcihzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgcmVnLCB1
MzIgbWFzaywNCiAJCQkJdTMyIHZhbCwgdW5zaWduZWQgbG9uZyBpbnRlcnZhbF91cywNCiAJCQkJ
dW5zaWduZWQgbG9uZyB0aW1lb3V0X21zLCBib29sIGNhbl9zbGVlcCk7DQotLSANCjIuMTguMA0K

