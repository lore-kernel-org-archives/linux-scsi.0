Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF57BC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF4FE20739
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:22:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Mh7jYGd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgFOHWs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 03:22:48 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:42698 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728528AbgFOHWs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 03:22:48 -0400
X-UUID: 98853a236838499bb5811a01b059dffb-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=1p/mBZcy6sHsnC7cHVAVgHT2d4KvBg+27AI/6Uhvh9c=;
        b=Mh7jYGd8dRFc7G+VM8E7+VRttKfXrKHKnoE9gHhDR2wjKbJ3dNxE2xvJMdYoAmtuWvf1iXr5XunULifKwzGd6ocFwGWehfqBsqy70aAaUtS0zFwCZ9BrA8IV4olCw4FzawMqcjzCx2lxzLDQMhTYdqlDa+PZvbCku37Z+Pkcj7E=;
X-UUID: 98853a236838499bb5811a01b059dffb-20200615
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 870495025; Mon, 15 Jun 2020 15:22:38 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 15:22:36 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 15:22:36 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <asutoshd@codeaurora.org>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 2/2] scsi: ufs: Add trace event for UIC commands
Date:   Mon, 15 Jun 2020 15:22:35 +0800
Message-ID: <20200615072235.23042-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200615072235.23042-1-stanley.chu@mediatek.com>
References: <20200615072235.23042-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: E480AC581F2CCFBAB70C1410BBF35B768838CBDFF7362722302DE912D2F9049B2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VXNlIHRoZSBmdHJhY2UgaW5mcmFzdHJ1Y3R1cmUgdG8gY29uZGl0aW9uYWxseSB0cmFjZSBVRlMg
VUlDIGNvbW1hbmQNCmV2ZW50cy4NCg0KTmV3IHRyYWNlIGV2ZW50ICJ1ZnNoY2RfdWljX2NvbW1h
bmQiIGlzIGNyZWF0ZWQsIHdoaWNoIHNhbXBsZXMgdGhlDQpmb2xsb3dpbmcgVUZTIFVJQyBjb21t
YW5kIGRhdGE6DQotIERldmljZSBuYW1lDQotIE9wdGlvbmFsIGlkZW50aWZpY2F0aW9uIHN0cmlu
Zw0KLSBVSUMgY29tbWFuZCBvcGNvZGUNCi0gVUlDIGNvbW1hbmQgYXJndW1lbnQxDQotIFVJQyBj
b21tYW5kIGFyZ3VtZW50Mg0KLSBVSUMgY29tbWFuZCBhcmdlbWVudDMNCg0KVXNhZ2U6DQoJZWNo
byAxID4gL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9ldmVudHMvdWZzL2VuYWJsZQ0KCWNhdCAv
c3lzL2tlcm5lbC9kZWJ1Zy90cmFjaW5nL3RyYWNlX3BpcGUNCg0KU2lnbmVkLW9mZi1ieTogU3Rh
bmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCkFja2VkLWJ5OiBBdnJpIEFsdG1h
biA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMg
IHwgMjYgKysrKysrKysrKysrKysrKysrKysrKysrKysNCiBpbmNsdWRlL3RyYWNlL2V2ZW50cy91
ZnMuaCB8IDMxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCiAyIGZpbGVzIGNoYW5n
ZWQsIDU3IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBhZDRmYzgyOWNiYjIuLjFl
MTMxNmJhNzA4MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC0zNDAsNiArMzQwLDI2IEBAIHN0YXRpYyB2
b2lkIHVmc2hjZF9hZGRfdG1fdXBpdV90cmFjZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1bnNpZ25l
ZCBpbnQgdGFnLA0KIAkJCSZkZXNjcC0+aW5wdXRfcGFyYW0xKTsNCiB9DQogDQorc3RhdGljIHZv
aWQgdWZzaGNkX2FkZF91aWNfY29tbWFuZF90cmFjZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KKwkJ
CQkJIHN0cnVjdCB1aWNfY29tbWFuZCAqdWNtZCwNCisJCQkJCSBjb25zdCBjaGFyICpzdHIpDQor
ew0KKwl1MzIgY21kOw0KKw0KKwlpZiAoIXRyYWNlX3Vmc2hjZF91aWNfY29tbWFuZF9lbmFibGVk
KCkpDQorCQlyZXR1cm47DQorDQorCWlmICghc3RyY21wKHN0ciwgInNlbmQiKSkNCisJCWNtZCA9
IHVjbWQtPmNvbW1hbmQ7DQorCWVsc2UNCisJCWNtZCA9IHVmc2hjZF9yZWFkbChoYmEsIFJFR19V
SUNfQ09NTUFORCk7DQorDQorCXRyYWNlX3Vmc2hjZF91aWNfY29tbWFuZChkZXZfbmFtZShoYmEt
PmRldiksIHN0ciwgY21kLA0KKwkJCQkgdWZzaGNkX3JlYWRsKGhiYSwgUkVHX1VJQ19DT01NQU5E
X0FSR18xKSwNCisJCQkJIHVmc2hjZF9yZWFkbChoYmEsIFJFR19VSUNfQ09NTUFORF9BUkdfMiks
DQorCQkJCSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUlDX0NPTU1BTkRfQVJHXzMpKTsNCit9DQor
DQogc3RhdGljIHZvaWQgdWZzaGNkX2FkZF9jb21tYW5kX3RyYWNlKHN0cnVjdCB1ZnNfaGJhICpo
YmEsDQogCQl1bnNpZ25lZCBpbnQgdGFnLCBjb25zdCBjaGFyICpzdHIpDQogew0KQEAgLTIwNTIs
NiArMjA3Miw4IEBAIHVmc2hjZF9kaXNwYXRjaF91aWNfY21kKHN0cnVjdCB1ZnNfaGJhICpoYmEs
IHN0cnVjdCB1aWNfY29tbWFuZCAqdWljX2NtZCkNCiAJdWZzaGNkX3dyaXRlbChoYmEsIHVpY19j
bWQtPmFyZ3VtZW50MiwgUkVHX1VJQ19DT01NQU5EX0FSR18yKTsNCiAJdWZzaGNkX3dyaXRlbCho
YmEsIHVpY19jbWQtPmFyZ3VtZW50MywgUkVHX1VJQ19DT01NQU5EX0FSR18zKTsNCiANCisJdWZz
aGNkX2FkZF91aWNfY29tbWFuZF90cmFjZShoYmEsIHVpY19jbWQsICJzZW5kIik7DQorDQogCS8q
IFdyaXRlIFVJQyBDbWQgKi8NCiAJdWZzaGNkX3dyaXRlbChoYmEsIHVpY19jbWQtPmNvbW1hbmQg
JiBDT01NQU5EX09QQ09ERV9NQVNLLA0KIAkJICAgICAgUkVHX1VJQ19DT01NQU5EKTsNCkBAIC00
ODMzLDYgKzQ4NTUsMTAgQEAgc3RhdGljIGlycXJldHVybl90IHVmc2hjZF91aWNfY21kX2NvbXBs
KHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBpbnRyX3N0YXR1cykNCiAJCWNvbXBsZXRlKGhiYS0+
dWljX2FzeW5jX2RvbmUpOw0KIAkJcmV0dmFsID0gSVJRX0hBTkRMRUQ7DQogCX0NCisNCisJaWYg
KHJldHZhbCA9PSBJUlFfSEFORExFRCkNCisJCXVmc2hjZF9hZGRfdWljX2NvbW1hbmRfdHJhY2Uo
aGJhLCBoYmEtPmFjdGl2ZV91aWNfY21kLA0KKwkJCQkJICAgICAiY29tcGxldGUiKTsNCiAJcmV0
dXJuIHJldHZhbDsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS90cmFjZS9ldmVudHMvdWZz
LmggYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy91ZnMuaA0KaW5kZXggNWYzMDA3MzkyNDBkLi44NDg0
MWIzYTdmZmQgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL3RyYWNlL2V2ZW50cy91ZnMuaA0KKysrIGIv
aW5jbHVkZS90cmFjZS9ldmVudHMvdWZzLmgNCkBAIC0yNDksNiArMjQ5LDM3IEBAIFRSQUNFX0VW
RU5UKHVmc2hjZF9jb21tYW5kLA0KIAkpDQogKTsNCiANCitUUkFDRV9FVkVOVCh1ZnNoY2RfdWlj
X2NvbW1hbmQsDQorCVRQX1BST1RPKGNvbnN0IGNoYXIgKmRldl9uYW1lLCBjb25zdCBjaGFyICpz
dHIsIHUzMiBjbWQsDQorCQkgdTMyIGFyZzEsIHUzMiBhcmcyLCB1MzIgYXJnMyksDQorDQorCVRQ
X0FSR1MoZGV2X25hbWUsIHN0ciwgY21kLCBhcmcxLCBhcmcyLCBhcmczKSwNCisNCisJVFBfU1RS
VUNUX19lbnRyeSgNCisJCV9fc3RyaW5nKGRldl9uYW1lLCBkZXZfbmFtZSkNCisJCV9fc3RyaW5n
KHN0ciwgc3RyKQ0KKwkJX19maWVsZCh1MzIsIGNtZCkNCisJCV9fZmllbGQodTMyLCBhcmcxKQ0K
KwkJX19maWVsZCh1MzIsIGFyZzIpDQorCQlfX2ZpZWxkKHUzMiwgYXJnMykNCisJKSwNCisNCisJ
VFBfZmFzdF9hc3NpZ24oDQorCQlfX2Fzc2lnbl9zdHIoZGV2X25hbWUsIGRldl9uYW1lKTsNCisJ
CV9fYXNzaWduX3N0cihzdHIsIHN0cik7DQorCQlfX2VudHJ5LT5jbWQgPSBjbWQ7DQorCQlfX2Vu
dHJ5LT5hcmcxID0gYXJnMTsNCisJCV9fZW50cnktPmFyZzIgPSBhcmcyOw0KKwkJX19lbnRyeS0+
YXJnMyA9IGFyZzM7DQorCSksDQorDQorCVRQX3ByaW50aygNCisJCSIlczogJXM6IGNtZDogMHgl
eCwgYXJnMTogMHgleCwgYXJnMjogMHgleCwgYXJnMzogMHgleCIsDQorCQlfX2dldF9zdHIoc3Ry
KSwgX19nZXRfc3RyKGRldl9uYW1lKSwgX19lbnRyeS0+Y21kLA0KKwkJX19lbnRyeS0+YXJnMSwg
X19lbnRyeS0+YXJnMiwgX19lbnRyeS0+YXJnMw0KKwkpDQorKTsNCisNCiBUUkFDRV9FVkVOVCh1
ZnNoY2RfdXBpdSwNCiAJVFBfUFJPVE8oY29uc3QgY2hhciAqZGV2X25hbWUsIGNvbnN0IGNoYXIg
KnN0ciwgdm9pZCAqaGRyLCB2b2lkICp0c2YpLA0KIA0KLS0gDQoyLjE4LjANCg==

