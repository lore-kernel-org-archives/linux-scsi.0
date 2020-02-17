Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEBAC7619F
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 09:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB30420679
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 09:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TTf5/rFT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgBQJgI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 04:36:08 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:64865 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728933AbgBQJgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2020 04:36:07 -0500
X-UUID: b7f94c8d211b44cdbd02e2c4d1097126-20200217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=j1shUdhIMGXtvTw4SkKdC2CAhrzkCOkweoDSyilUUBo=;
        b=TTf5/rFTNAbBLj6+Uzfr7G0Gk3ywkP/lWKGHWyD4XZTWUwYRSUSFHv9bhSLZnpWYuogNvNnCzb5FuTo0/WgYe10wG7LW44WPWQGvsP3BY4hcywDWpH6/3SS1+AeFR3nw8h1WrmxV9sqnVZdX2JQs5/GQlXmBFo1zFQvYN0rqDiw=;
X-UUID: b7f94c8d211b44cdbd02e2c4d1097126-20200217
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 424605006; Mon, 17 Feb 2020 17:36:01 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 17 Feb 2020 17:34:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 17 Feb 2020 17:35:36 +0800
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
Subject: [PATCH v1 2/2] scsi: ufs: ufs-mediatek: add waiting time for reference clock
Date:   Mon, 17 Feb 2020 17:35:59 +0800
Message-ID: <20200217093559.16830-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200217093559.16830-1-stanley.chu@mediatek.com>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U29tZSBkZWxheXMgbWF5IGJlIHJlcXVpcmVkIGVpdGhlciBhZnRlciBnYXRpbmcgb3IgYmVmb3Jl
IHVuZ2F0aW5nDQpyZWZlcmVuY2UgY2xvY2sgZm9yIGRldmljZSBhY2NvcmRpbmcgdG8gdmVuZG9y
IHJlcXVpcmVtZW50cy4NCg0KTm90ZSB0aGF0IGluIFVGUyAzLjAsIHRoZSBkZWxheSB0aW1lIGFm
dGVyIGdhdGluZyByZWZlcmVuY2UNCmNsb2NrIGNhbiBiZSBkZWZpbmVkIGJ5IGF0dHJpYnV0ZSBi
UmVmQ2xrR2F0aW5nV2FpdFRpbWUuIFVzZSB0aGUNCmZvcm1hbCB2YWx1ZSBpbnN0ZWFkIGlmIGl0
IGNhbiBiZSBxdWVyaWVkIGZyb20gZGV2aWNlLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENo
dSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMt
bWVkaWF0ZWsuYyB8IDQ2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KIGRyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggfCAgMiArKw0KIDIgZmlsZXMgY2hhbmdlZCwgNDYg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpp
bmRleCA5ZDA1OTYyZmViMTUuLmRlNjUwODIyYzlkOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMNCkBAIC0xMDAsNiArMTAwLDE3IEBAIHN0YXRpYyBpbnQgdWZzX210a19iaW5kX21waHkoc3Ry
dWN0IHVmc19oYmEgKmhiYSkNCiAJcmV0dXJuIGVycjsNCiB9DQogDQorc3RhdGljIHZvaWQgdWZz
X210a191ZGVsYXkodW5zaWduZWQgbG9uZyB1cykNCit7DQorCWlmICghdXMpDQorCQlyZXR1cm47
DQorDQorCWlmICh1cyA8IDEwKQ0KKwkJdWRlbGF5KHVzKTsNCisJZWxzZQ0KKwkJdXNsZWVwX3Jh
bmdlKHVzLCB1cyArIDEwKTsNCit9DQorDQogc3RhdGljIGludCB1ZnNfbXRrX3NldHVwX3JlZl9j
bGsoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBvbikNCiB7DQogCXN0cnVjdCB1ZnNfbXRrX2hv
c3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCkBAIC0xMTIsNiArMTIzLDcgQEAg
c3RhdGljIGludCB1ZnNfbXRrX3NldHVwX3JlZl9jbGsoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9v
bCBvbikNCiANCiAJaWYgKG9uKSB7DQogCQl1ZnNfbXRrX3JlZl9jbGtfbm90aWZ5KG9uLCByZXMp
Ow0KKwkJdWZzX210a191ZGVsYXkoaG9zdC0+cmVmX2Nsa191bmdhdGluZ193YWl0X3VzKTsNCiAJ
CXVmc2hjZF93cml0ZWwoaGJhLCBSRUZDTEtfUkVRVUVTVCwgUkVHX1VGU19SRUZDTEtfQ1RSTCk7
DQogCX0gZWxzZSB7DQogCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgUkVGQ0xLX1JFTEVBU0UsIFJFR19V
RlNfUkVGQ0xLX0NUUkwpOw0KQEAgLTEzNywxMiArMTQ5LDI5IEBAIHN0YXRpYyBpbnQgdWZzX210
a19zZXR1cF9yZWZfY2xrKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgb24pDQogDQogb3V0Og0K
IAlob3N0LT5yZWZfY2xrX2VuYWJsZWQgPSBvbjsNCi0JaWYgKCFvbikNCisJaWYgKCFvbikgew0K
KwkJdWZzX210a191ZGVsYXkoaG9zdC0+cmVmX2Nsa19nYXRpbmdfd2FpdF91cyk7DQogCQl1ZnNf
bXRrX3JlZl9jbGtfbm90aWZ5KG9uLCByZXMpOw0KKwl9DQogDQogCXJldHVybiAwOw0KIH0NCiAN
CitzdGF0aWMgdm9pZCB1ZnNfbXRrX3NldHVwX3JlZl9jbGtfd2FpdF91cyhzdHJ1Y3QgdWZzX2hi
YSAqaGJhLA0KKwkJCQkJICB1MTYgZ2F0aW5nX3VzLCB1MTYgdW5nYXRpbmdfdXMpDQorew0KKwlz
dHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQorDQor
CWlmIChoYmEtPmRldl9pbmZvLmNsa19nYXRpbmdfd2FpdF91cykgew0KKwkJaG9zdC0+cmVmX2Ns
a19nYXRpbmdfd2FpdF91cyA9DQorCQkJaGJhLT5kZXZfaW5mby5jbGtfZ2F0aW5nX3dhaXRfdXM7
DQorCX0gZWxzZSB7DQorCQlob3N0LT5yZWZfY2xrX2dhdGluZ193YWl0X3VzID0gZ2F0aW5nX3Vz
Ow0KKwl9DQorDQorCWhvc3QtPnJlZl9jbGtfdW5nYXRpbmdfd2FpdF91cyA9IHVuZ2F0aW5nX3Vz
Ow0KK30NCisNCiBzdGF0aWMgdTMyIHVmc19tdGtfbGlua19nZXRfc3RhdGUoc3RydWN0IHVmc19o
YmEgKmhiYSkNCiB7DQogCXUzMiB2YWw7DQpAQCAtNTAyLDEwICs1MzEsMjMgQEAgc3RhdGljIHZv
aWQgdWZzX210a19kYmdfcmVnaXN0ZXJfZHVtcChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIHN0YXRp
YyBpbnQgdWZzX210a19hcHBseV9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0K
IAlzdHJ1Y3QgdWZzX2Rldl9pbmZvICpkZXZfaW5mbyA9ICZoYmEtPmRldl9pbmZvOw0KKwl1MTYg
bWlkID0gZGV2X2luZm8tPndtYW51ZmFjdHVyZXJpZDsNCiANCi0JaWYgKGRldl9pbmZvLT53bWFu
dWZhY3R1cmVyaWQgPT0gVUZTX1ZFTkRPUl9TQU1TVU5HKQ0KKwlpZiAobWlkID09IFVGU19WRU5E
T1JfU0FNU1VORykNCiAJCXVmc2hjZF9kbWVfc2V0KGhiYSwgVUlDX0FSR19NSUIoUEFfVEFDVElW
QVRFKSwgNik7DQogDQorCS8qDQorCSAqIERlY2lkZSB3YWl0aW5nIHRpbWUgYmVmb3JlIGdhdGlu
ZyByZWZlcmVuY2UgY2xvY2sgYW5kDQorCSAqIGFmdGVyIHVuZ2F0aW5nIHJlZmVyZW5jZSBjbG9j
ayBhY2NvcmRpbmcgdG8gdmVuZG9ycycNCisJICogcmVxdWlyZW1lbnRzLg0KKwkgKi8NCisJaWYg
KG1pZCA9PSBVRlNfVkVORE9SX1NBTVNVTkcpDQorCQl1ZnNfbXRrX3NldHVwX3JlZl9jbGtfd2Fp
dF91cyhoYmEsIDEsIDEpOw0KKwllbHNlIGlmIChtaWQgPT0gVUZTX1ZFTkRPUl9TS0hZTklYKQ0K
KwkJdWZzX210a19zZXR1cF9yZWZfY2xrX3dhaXRfdXMoaGJhLCAzMCwgMzApOw0KKwllbHNlIGlm
IChtaWQgPT0gVUZTX1ZFTkRPUl9UT1NISUJBKQ0KKwkJdWZzX210a19zZXR1cF9yZWZfY2xrX3dh
aXRfdXMoaGJhLCAxMDAsIDMyKTsNCisNCiAJcmV0dXJuIDA7DQogfQ0KIA0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1t
ZWRpYXRlay5oDQppbmRleCA0OTI0MTRlNWY0ODEuLjRjNzg3Yjk5ZmU0MSAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLmgNCkBAIC05Miw2ICs5Miw4IEBAIHN0cnVjdCB1ZnNfbXRrX2hvc3Qgew0K
IAlzdHJ1Y3QgdWZzX2hiYSAqaGJhOw0KIAlzdHJ1Y3QgcGh5ICptcGh5Ow0KIAlib29sIHJlZl9j
bGtfZW5hYmxlZDsNCisJdTE2IHJlZl9jbGtfdW5nYXRpbmdfd2FpdF91czsNCisJdTE2IHJlZl9j
bGtfZ2F0aW5nX3dhaXRfdXM7DQogfTsNCiANCiAjZW5kaWYgLyogIV9VRlNfTUVESUFURUtfSCAq
Lw0KLS0gDQoyLjE4LjANCg==

