Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE5AC3F2D1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 136EB208C3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:07:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hV2wIZhI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgCEEHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 23:07:11 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:24214 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725776AbgCEEHL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 23:07:11 -0500
X-UUID: 9b99dde4be7741c5a66ce387d4d5668d-20200305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Rj5iYKNwFcesfwwy5zTGLm6uozn0z7qv/GaBAu+slyw=;
        b=hV2wIZhImQwCLHgcX+CryUNtGPTHf2kzq0yy6ki+l9Gf/XZ7CHAzPsqhxfDA40RPXl/kwRwmz34tEH41aIweBk5WkjyGXpkkuy5iK/UC6QB6WSSgdHmrBo0/wzQih7tAkFhnQ96rM1fhgiGABYufltAffOxkyFgOm9pzyz6X0Ik=;
X-UUID: 9b99dde4be7741c5a66ce387d4d5668d-20200305
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1201515843; Thu, 05 Mar 2020 12:07:07 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 5 Mar 2020 12:04:24 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 5 Mar 2020 12:06:20 +0800
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
Subject: [PATCH v1 3/4] scsi: ufs: allow customized delay for host enabling
Date:   Thu, 5 Mar 2020 12:07:03 +0800
Message-ID: <20200305040704.10645-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200305040704.10645-1-stanley.chu@mediatek.com>
References: <20200305040704.10645-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: BA07B504F3F26FF626B890E43A8DA3B6510C5A53DA0DDB0E5AC4B1F78667188A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q3VycmVudGx5IGEgMSBtcyBkZWxheSBpcyBhcHBsaWVkIGJlZm9yZSBwb2xsaW5nIENPTlRST0xM
RVJfRU5BQkxFDQpiaXQuIFRoaXMgZGVsYXkgbWF5IG5vdCBiZSByZXF1aXJlZCBvciBjYW4gYmUg
Y2hhbmdlZCBpbiBkaWZmZXJlbnQNCmNvbnRyb2xsZXJzLiBNYWtlIHRoZSBkZWxheSBhcyBhIGNo
YW5nZWFibGUgdmFsdWUgaW4gc3RydWN0IHVmc19oYmEgdG8NCmFsbG93IGl0IGN1c3RvbWl6ZWQg
YnkgdmVuZG9ycy4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1l
ZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA2ICsrKysrLQ0K
IGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCAxICsNCiAyIGZpbGVzIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCmluZGV4IGVkNjFlY2I5OGIy
ZC4uMzljYWU5MDdhYmQwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
KysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KQEAgLTQyODIsNyArNDI4MiwxMCBAQCBp
bnQgdWZzaGNkX2hiYV9lbmFibGUoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJICogaW5zdHJ1Y3Rp
b24gbWlnaHQgYmUgcmVhZCBiYWNrLg0KIAkgKiBUaGlzIGRlbGF5IGNhbiBiZSBjaGFuZ2VkIGJh
c2VkIG9uIHRoZSBjb250cm9sbGVyLg0KIAkgKi8NCi0JdXNsZWVwX3JhbmdlKDEwMDAsIDExMDAp
Ow0KKwlpZiAoaGJhLT5oYmFfZW5hYmxlX2RlbGF5X3VzKSB7DQorCQl1c2xlZXBfcmFuZ2UoaGJh
LT5oYmFfZW5hYmxlX2RlbGF5X3VzLA0KKwkJCSAgICAgaGJhLT5oYmFfZW5hYmxlX2RlbGF5X3Vz
ICsgMTAwKTsNCisJfQ0KIA0KIAkvKiB3YWl0IGZvciB0aGUgaG9zdCBjb250cm9sbGVyIHRvIGNv
bXBsZXRlIGluaXRpYWxpemF0aW9uICovDQogCXJldHJ5ID0gMTA7DQpAQCAtODQwMiw2ICs4NDA1
LDcgQEAgaW50IHVmc2hjZF9pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEsIHZvaWQgX19pb21lbSAq
bW1pb19iYXNlLCB1bnNpZ25lZCBpbnQgaXJxKQ0KIA0KIAloYmEtPm1taW9fYmFzZSA9IG1taW9f
YmFzZTsNCiAJaGJhLT5pcnEgPSBpcnE7DQorCWhiYS0+aGJhX2VuYWJsZV9kZWxheV91cyA9IDEw
MDA7DQogDQogCWVyciA9IHVmc2hjZF9oYmFfaW5pdChoYmEpOw0KIAlpZiAoZXJyKQ0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5oDQppbmRleCA0OWFkZTFiZmQwODUuLmJhZjExNDNkNDgzOSAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCkBA
IC02NjIsNiArNjYyLDcgQEAgc3RydWN0IHVmc19oYmEgew0KIAl1MzIgZWhfZmxhZ3M7DQogCXUz
MiBpbnRyX21hc2s7DQogCXUxNiBlZV9jdHJsX21hc2s7DQorCXUxNiBoYmFfZW5hYmxlX2RlbGF5
X3VzOw0KIAlib29sIGlzX3Bvd2VyZWQ7DQogDQogCS8qIFdvcmsgUXVldWVzICovDQotLSANCjIu
MTguMA0K

