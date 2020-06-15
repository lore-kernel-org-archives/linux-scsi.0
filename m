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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB712C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A3EC2067B
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IxtW4/gO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgFOGsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 02:48:01 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:56022 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728481AbgFOGr7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 02:47:59 -0400
X-UUID: 8c0a850e63794cb1b6cd3ce60b21e96e-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=aIi/Cvo5z+NELDxxEWG3ffiIsJ6CjwE2XAnl7RAvFVQ=;
        b=IxtW4/gOFeGN11XY2j81ASvLROsflJAMbKF4w7cAtzmUUvQiBEPxt1c1jDB/JSP8wBtjgzfxUi8Zo/ZrMDRAMiA6xP3xzsL/lZ1OdmmdAPcQ6terWlCSJWkPeTMOs1LIF/iV2Y6q0AE0itubT9o6yakTt4QzelHbv49zZbxUYvo=;
X-UUID: 8c0a850e63794cb1b6cd3ce60b21e96e-20200615
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1647051466; Mon, 15 Jun 2020 14:47:56 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 14:47:54 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 14:47:53 +0800
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
Subject: [PATCH v2 2/2] scsi: ufs: Add trace event for UIC commands
Date:   Mon, 15 Jun 2020 14:47:53 +0800
Message-ID: <20200615064753.20935-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200615064753.20935-1-stanley.chu@mediatek.com>
References: <20200615064753.20935-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
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
aGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBhZDRmYzgyOWNiYjIuLjFm
ZDJmZDUyNmM2OCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBi
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
ODI1LDExICs0ODQ3LDE1IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCB1ZnNoY2RfdWljX2NtZF9jb21w
bChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgaW50cl9zdGF0dXMpDQogCQkJdWZzaGNkX2dldF91
aWNfY21kX3Jlc3VsdChoYmEpOw0KIAkJaGJhLT5hY3RpdmVfdWljX2NtZC0+YXJndW1lbnQzID0N
CiAJCQl1ZnNoY2RfZ2V0X2RtZV9hdHRyX3ZhbChoYmEpOw0KKwkJdWZzaGNkX2FkZF91aWNfY29t
bWFuZF90cmFjZShoYmEsIGhiYS0+YWN0aXZlX3VpY19jbWQsDQorCQkJCQkgICAgICJjb21wbGV0
ZSIpOw0KIAkJY29tcGxldGUoJmhiYS0+YWN0aXZlX3VpY19jbWQtPmRvbmUpOw0KIAkJcmV0dmFs
ID0gSVJRX0hBTkRMRUQ7DQogCX0NCiANCiAJaWYgKChpbnRyX3N0YXR1cyAmIFVGU0hDRF9VSUNf
UFdSX01BU0spICYmIGhiYS0+dWljX2FzeW5jX2RvbmUpIHsNCisJCXVmc2hjZF9hZGRfdWljX2Nv
bW1hbmRfdHJhY2UoaGJhLCBoYmEtPmFjdGl2ZV91aWNfY21kLA0KKwkJCQkJICAgICAiY29tcGxl
dGUiKTsNCiAJCWNvbXBsZXRlKGhiYS0+dWljX2FzeW5jX2RvbmUpOw0KIAkJcmV0dmFsID0gSVJR
X0hBTkRMRUQ7DQogCX0NCmRpZmYgLS1naXQgYS9pbmNsdWRlL3RyYWNlL2V2ZW50cy91ZnMuaCBi
L2luY2x1ZGUvdHJhY2UvZXZlbnRzL3Vmcy5oDQppbmRleCA1ZjMwMDczOTI0MGQuLjg0ODQxYjNh
N2ZmZCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvdHJhY2UvZXZlbnRzL3Vmcy5oDQorKysgYi9pbmNs
dWRlL3RyYWNlL2V2ZW50cy91ZnMuaA0KQEAgLTI0OSw2ICsyNDksMzcgQEAgVFJBQ0VfRVZFTlQo
dWZzaGNkX2NvbW1hbmQsDQogCSkNCiApOw0KIA0KK1RSQUNFX0VWRU5UKHVmc2hjZF91aWNfY29t
bWFuZCwNCisJVFBfUFJPVE8oY29uc3QgY2hhciAqZGV2X25hbWUsIGNvbnN0IGNoYXIgKnN0ciwg
dTMyIGNtZCwNCisJCSB1MzIgYXJnMSwgdTMyIGFyZzIsIHUzMiBhcmczKSwNCisNCisJVFBfQVJH
UyhkZXZfbmFtZSwgc3RyLCBjbWQsIGFyZzEsIGFyZzIsIGFyZzMpLA0KKw0KKwlUUF9TVFJVQ1Rf
X2VudHJ5KA0KKwkJX19zdHJpbmcoZGV2X25hbWUsIGRldl9uYW1lKQ0KKwkJX19zdHJpbmcoc3Ry
LCBzdHIpDQorCQlfX2ZpZWxkKHUzMiwgY21kKQ0KKwkJX19maWVsZCh1MzIsIGFyZzEpDQorCQlf
X2ZpZWxkKHUzMiwgYXJnMikNCisJCV9fZmllbGQodTMyLCBhcmczKQ0KKwkpLA0KKw0KKwlUUF9m
YXN0X2Fzc2lnbigNCisJCV9fYXNzaWduX3N0cihkZXZfbmFtZSwgZGV2X25hbWUpOw0KKwkJX19h
c3NpZ25fc3RyKHN0ciwgc3RyKTsNCisJCV9fZW50cnktPmNtZCA9IGNtZDsNCisJCV9fZW50cnkt
PmFyZzEgPSBhcmcxOw0KKwkJX19lbnRyeS0+YXJnMiA9IGFyZzI7DQorCQlfX2VudHJ5LT5hcmcz
ID0gYXJnMzsNCisJKSwNCisNCisJVFBfcHJpbnRrKA0KKwkJIiVzOiAlczogY21kOiAweCV4LCBh
cmcxOiAweCV4LCBhcmcyOiAweCV4LCBhcmczOiAweCV4IiwNCisJCV9fZ2V0X3N0cihzdHIpLCBf
X2dldF9zdHIoZGV2X25hbWUpLCBfX2VudHJ5LT5jbWQsDQorCQlfX2VudHJ5LT5hcmcxLCBfX2Vu
dHJ5LT5hcmcyLCBfX2VudHJ5LT5hcmczDQorCSkNCispOw0KKw0KIFRSQUNFX0VWRU5UKHVmc2hj
ZF91cGl1LA0KIAlUUF9QUk9UTyhjb25zdCBjaGFyICpkZXZfbmFtZSwgY29uc3QgY2hhciAqc3Ry
LCB2b2lkICpoZHIsIHZvaWQgKnRzZiksDQogDQotLSANCjIuMTguMA0K

