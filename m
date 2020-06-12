Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DA2C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 15:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADCCC2081A
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 15:10:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eaID3cTv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgFLPKO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 11:10:14 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:29623 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726366AbgFLPKN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 11:10:13 -0400
X-UUID: 969f7aa8454b4ddabc62278aaea843a9-20200612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=+0KA0dOhmw5UB0xe1wGnzSeL3/LIui1ay1wP2Ey5MGg=;
        b=eaID3cTvZCfa59n34eaUV9pwbbuVl/oZfmdU8lesH8Q0YYxMvpcppJJSc/FeyrVNCZXNyBVJKYgC2vxLXgG3y5P+17R08PXpdQ7u5OZM5bwCIp95xqptRHSXskb1WSy8cSaRsnqSRebpZieZIzZDvl7FX3nWHW/8tkEGa0MvruA=;
X-UUID: 969f7aa8454b4ddabc62278aaea843a9-20200612
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1554280324; Fri, 12 Jun 2020 23:10:08 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 12 Jun 2020 23:10:02 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Jun 2020 23:10:01 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 2/2] scsi: ufs: Add trace event for UIC commands
Date:   Fri, 12 Jun 2020 23:10:00 +0800
Message-ID: <20200612151000.27639-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200612151000.27639-1-stanley.chu@mediatek.com>
References: <20200612151000.27639-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 59D9D01AB4EC54D1F10C739C554AC979AC81CEAF602D64FA508FA0139328F5D72000:8
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
b21tYW5kIGFyZ3VtZW50Mg0KLSBVSUMgY29tbWFuZCBhcmdlbWVudDMNCi0gVUlDIGNvbW1hbmQg
ZXhlY3V0aW9uIHJlc3VsdA0KDQpVc2FnZToNCgllY2hvIDEgPiAvc3lzL2tlcm5lbC9kZWJ1Zy90
cmFjaW5nL2V2ZW50cy91ZnMvZW5hYmxlDQoJY2F0IC9zeXMva2VybmVsL2RlYnVnL3RyYWNpbmcv
dHJhY2VfcGlwZQ0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVk
aWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgfCAyOSArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKw0KIGluY2x1ZGUvdHJhY2UvZXZlbnRzL3Vmcy5oIHwgMzMg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQogMiBmaWxlcyBjaGFuZ2VkLCA2MiBp
bnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KaW5kZXggYzE5N2EzMzE1ZDIxLi4xODE2MTc5NjY2
NTggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQorKysgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jDQpAQCAtMzM5LDYgKzMzOSwyNyBAQCBzdGF0aWMgdm9pZCB1ZnNo
Y2RfYWRkX3RtX3VwaXVfdHJhY2Uoc3RydWN0IHVmc19oYmEgKmhiYSwgdW5zaWduZWQgaW50IHRh
ZywNCiAJCQkmZGVzY3AtPmlucHV0X3BhcmFtMSk7DQogfQ0KIA0KK3N0YXRpYyB2b2lkIHVmc2hj
ZF9hZGRfdWljX2NvbW1hbmRfdHJhY2Uoc3RydWN0IHVmc19oYmEgKmhiYSwNCisJCQkJCSBzdHJ1
Y3QgdWljX2NvbW1hbmQgKnVjbWQsDQorCQkJCQkgY29uc3QgY2hhciAqc3RyKQ0KK3sNCisJdTMy
IGNtZDsNCisNCisJaWYgKCF0cmFjZV91ZnNoY2RfdWljX2NvbW1hbmRfZW5hYmxlZCgpKQ0KKwkJ
cmV0dXJuOw0KKw0KKwlpZiAoIXN0cmNtcChzdHIsICJ1aWNfc2VuZCIpKQ0KKwkJY21kID0gdWNt
ZC0+Y29tbWFuZDsNCisJZWxzZQ0KKwkJY21kID0gdWZzaGNkX3JlYWRsKGhiYSwgUkVHX1VJQ19D
T01NQU5EKTsNCisNCisJdHJhY2VfdWZzaGNkX3VpY19jb21tYW5kKGRldl9uYW1lKGhiYS0+ZGV2
KSwgc3RyLCBjbWQsDQorCQkJCSB1Y21kLT5yZXN1bHQsDQorCQkJCSB1ZnNoY2RfcmVhZGwoaGJh
LCBSRUdfVUlDX0NPTU1BTkRfQVJHXzEpLA0KKwkJCQkgdWZzaGNkX3JlYWRsKGhiYSwgUkVHX1VJ
Q19DT01NQU5EX0FSR18yKSwNCisJCQkJIHVmc2hjZF9yZWFkbChoYmEsIFJFR19VSUNfQ09NTUFO
RF9BUkdfMykpOw0KK30NCisNCiBzdGF0aWMgdm9pZCB1ZnNoY2RfYWRkX2NvbW1hbmRfdHJhY2Uo
c3RydWN0IHVmc19oYmEgKmhiYSwNCiAJCXVuc2lnbmVkIGludCB0YWcsIGNvbnN0IGNoYXIgKnN0
cikNCiB7DQpAQCAtMjA1NCw2ICsyMDc1LDggQEAgdWZzaGNkX2Rpc3BhdGNoX3VpY19jbWQoc3Ry
dWN0IHVmc19oYmEgKmhiYSwgc3RydWN0IHVpY19jb21tYW5kICp1aWNfY21kKQ0KIAkvKiBXcml0
ZSBVSUMgQ21kICovDQogCXVmc2hjZF93cml0ZWwoaGJhLCB1aWNfY21kLT5jb21tYW5kICYgQ09N
TUFORF9PUENPREVfTUFTSywNCiAJCSAgICAgIFJFR19VSUNfQ09NTUFORCk7DQorDQorCXVmc2hj
ZF9hZGRfdWljX2NvbW1hbmRfdHJhY2UoaGJhLCB1aWNfY21kLCAidWljX3NlbmQiKTsNCiB9DQog
DQogLyoqDQpAQCAtMjA4MCw2ICsyMTAzLDkgQEAgdWZzaGNkX3dhaXRfZm9yX3VpY19jbWQoc3Ry
dWN0IHVmc19oYmEgKmhiYSwgc3RydWN0IHVpY19jb21tYW5kICp1aWNfY21kKQ0KIAloYmEtPmFj
dGl2ZV91aWNfY21kID0gTlVMTDsNCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3Qt
Pmhvc3RfbG9jaywgZmxhZ3MpOw0KIA0KKwl1aWNfY21kLT5yZXN1bHQgPSByZXQ7DQorCXVmc2hj
ZF9hZGRfdWljX2NvbW1hbmRfdHJhY2UoaGJhLCB1aWNfY21kLCAidWljX2NvbXBsZXRlIik7DQor
DQogCXJldHVybiByZXQ7DQogfQ0KIA0KQEAgLTM3NjAsNiArMzc4Niw5IEBAIHN0YXRpYyBpbnQg
dWZzaGNkX3VpY19wd3JfY3RybChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QgdWljX2NvbW1h
bmQgKmNtZCkNCiAJCXJldCA9IChzdGF0dXMgIT0gUFdSX09LKSA/IHN0YXR1cyA6IC0xOw0KIAl9
DQogb3V0Og0KKwljbWQtPnJlc3VsdCA9IHJldDsNCisJdWZzaGNkX2FkZF91aWNfY29tbWFuZF90
cmFjZShoYmEsIGNtZCwgInVpY19jb21wbGV0ZSIpOw0KKw0KIAlpZiAocmV0KSB7DQogCQl1ZnNo
Y2RfcHJpbnRfaG9zdF9zdGF0ZShoYmEpOw0KIAkJdWZzaGNkX3ByaW50X3B3cl9pbmZvKGhiYSk7
DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS90cmFjZS9ldmVudHMvdWZzLmggYi9pbmNsdWRlL3RyYWNl
L2V2ZW50cy91ZnMuaA0KaW5kZXggNWYzMDA3MzkyNDBkLi5jZjhkNTY4ZDVhMTMgMTAwNjQ0DQot
LS0gYS9pbmNsdWRlL3RyYWNlL2V2ZW50cy91ZnMuaA0KKysrIGIvaW5jbHVkZS90cmFjZS9ldmVu
dHMvdWZzLmgNCkBAIC0yNDksNiArMjQ5LDM5IEBAIFRSQUNFX0VWRU5UKHVmc2hjZF9jb21tYW5k
LA0KIAkpDQogKTsNCiANCitUUkFDRV9FVkVOVCh1ZnNoY2RfdWljX2NvbW1hbmQsDQorCVRQX1BS
T1RPKGNvbnN0IGNoYXIgKmRldl9uYW1lLCBjb25zdCBjaGFyICpzdHIsIHUzMiBjbWQsIGludCBy
ZXN1bHQsDQorCQkgdTMyIGFyZzEsIHUzMiBhcmcyLCB1MzIgYXJnMyksDQorDQorCVRQX0FSR1Mo
ZGV2X25hbWUsIHN0ciwgY21kLCByZXN1bHQsIGFyZzEsIGFyZzIsIGFyZzMpLA0KKw0KKwlUUF9T
VFJVQ1RfX2VudHJ5KA0KKwkJX19zdHJpbmcoZGV2X25hbWUsIGRldl9uYW1lKQ0KKwkJX19zdHJp
bmcoc3RyLCBzdHIpDQorCQlfX2ZpZWxkKHUzMiwgY21kKQ0KKwkJX19maWVsZChpbnQsIHJlc3Vs
dCkNCisJCV9fZmllbGQodTMyLCBhcmcxKQ0KKwkJX19maWVsZCh1MzIsIGFyZzIpDQorCQlfX2Zp
ZWxkKHUzMiwgYXJnMykNCisJKSwNCisNCisJVFBfZmFzdF9hc3NpZ24oDQorCQlfX2Fzc2lnbl9z
dHIoZGV2X25hbWUsIGRldl9uYW1lKTsNCisJCV9fYXNzaWduX3N0cihzdHIsIHN0cik7DQorCQlf
X2VudHJ5LT5jbWQgPSBjbWQ7DQorCQlfX2VudHJ5LT5yZXN1bHQgPSByZXN1bHQ7DQorCQlfX2Vu
dHJ5LT5hcmcxID0gYXJnMTsNCisJCV9fZW50cnktPmFyZzIgPSBhcmcyOw0KKwkJX19lbnRyeS0+
YXJnMyA9IGFyZzM7DQorCSksDQorDQorCVRQX3ByaW50aygNCisJCSIlczogJXM6IGNtZDogMHgl
eCwgYXJnMTogMHgleCwgYXJnMjogMHgleCwgYXJnMzogMHgleCwgcmVzdWx0OiAlZCIsDQorCQlf
X2dldF9zdHIoc3RyKSwgX19nZXRfc3RyKGRldl9uYW1lKSwgX19lbnRyeS0+Y21kLA0KKwkJX19l
bnRyeS0+YXJnMSwgX19lbnRyeS0+YXJnMiwgX19lbnRyeS0+YXJnMywgX19lbnRyeS0+cmVzdWx0
DQorCSkNCispOw0KKw0KIFRSQUNFX0VWRU5UKHVmc2hjZF91cGl1LA0KIAlUUF9QUk9UTyhjb25z
dCBjaGFyICpkZXZfbmFtZSwgY29uc3QgY2hhciAqc3RyLCB2b2lkICpoZHIsIHZvaWQgKnRzZiks
DQogDQotLSANCjIuMTguMA0K

