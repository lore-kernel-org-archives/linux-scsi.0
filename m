Return-Path: <SRS0=SQ1Y=2D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5FBC2D0BF
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 08:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD6A22527
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 08:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Db5yipWK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfLMIxN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Dec 2019 03:53:13 -0500
Received: from mailgw01.mediatek.com ([216.200.240.184]:35114 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfLMIxM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2019 03:53:12 -0500
X-UUID: 7c70b67605c5458687a7e11bafcdddd5-20191213
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=XhTCXQMz9W16QzlMSFeAKscL9UN80OVD7nIAnDiOOmE=;
        b=Db5yipWKuqgNE3knz/yBjVKvN05hRBb7UotvnXqeLVIz8v8oPmH7ZAPsAtgDaJlkiHPR3Boz4O8iilY8dJBIU7WTNswFzt847Bz6Jyc8iE4qVezUQcgTUclzK1xWs8yEEMRHueqe1rgOQcHp94Wi6Oqb38TF28nZ6IJLmMYtc5s=;
X-UUID: 7c70b67605c5458687a7e11bafcdddd5-20191213
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 932931311; Fri, 13 Dec 2019 00:53:11 -0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 13 Dec 2019 16:11:18 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 13 Dec 2019 16:11:05 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/4] scsi: ufs-mediatek: introduce reference clock control
Date:   Fri, 13 Dec 2019 16:11:32 +0800
Message-ID: <1576224695-22657-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW50cm9kdWNlIHJlZmVyZW5jZSBjbG9jayBjb250cm9sIGluIE1lZGlhVGVrIENoaXBzZXQgaW4g
b3JkZXINCnRvIGRpc2FibGUgaXQgaWYgaXQgaXMgbm90IG5lY2Vzc2FyeSBieSBVRlMgZGV2aWNl
IHRvIHNhdmUgc3lzdGVtIHBvd2VyLg0KDQpDdXJyZW50bHkgcmVmZXJlbmNlIGNsb2NrIGNhbiBi
ZSBkaXNhYmxlZCBkdXJpbmcgc3lzdGVtIHN1c3BlbmQsIHJ1bnRpbWUNCnN1c3BlbmQgYW5kIGNs
b2NrLWdhdGluZyBhZnRlciBsaW5rIGVudGVycyBoaWJlcm5hdGUgc3RhdGUuDQoNClNpZ25lZC1v
ZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgNjQgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCB8IDIwICsrKysrKysr
Ky0tDQogMiBmaWxlcyBjaGFuZ2VkLCA3OCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0K
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCmluZGV4IDZhM2VjMTFiMTZkYi4uNjkwNDgzYzc4MjEy
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTE4LDYgKzE4LDExIEBADQogI2luY2x1
ZGUgInVuaXByby5oIg0KICNpbmNsdWRlICJ1ZnMtbWVkaWF0ZWsuaCINCiANCisjZGVmaW5lIHVm
c19tdGtfcmVmX2Nsa19ub3RpZnkob24sIHJlcykgXA0KKwlhcm1fc21jY2Nfc21jKE1US19TSVBf
VUZTX0NPTlRST0wsIFwNCisJCSAgICAgIFVGU19NVEtfU0lQX1JFRl9DTEtfTk9USUZJQ0FUSU9O
LCBcDQorCQkgICAgICBvbiwgMCwgMCwgMCwgMCwgMCwgJihyZXMpKQ0KKw0KIHN0YXRpYyB2b2lk
IHVmc19tdGtfY2ZnX3VuaXByb19jZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIGVuYWJsZSkN
CiB7DQogCXUzMiB0bXA7DQpAQCAtODMsNiArODgsNDkgQEAgc3RhdGljIGludCB1ZnNfbXRrX2Jp
bmRfbXBoeShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlyZXR1cm4gZXJyOw0KIH0NCiANCitzdGF0
aWMgaW50IHVmc19tdGtfc2V0dXBfcmVmX2NsayhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9u
KQ0KK3sNCisJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudCho
YmEpOw0KKwlzdHJ1Y3QgYXJtX3NtY2NjX3JlcyByZXM7DQorCXVuc2lnbmVkIGxvbmcgdGltZW91
dDsNCisJdTMyIHZhbHVlOw0KKw0KKwlpZiAoaG9zdC0+cmVmX2Nsa19lbmFibGVkID09IG9uKQ0K
KwkJcmV0dXJuIDA7DQorDQorCWlmIChvbikgew0KKwkJdWZzX210a19yZWZfY2xrX25vdGlmeShv
biwgcmVzKTsNCisJCXVmc2hjZF93cml0ZWwoaGJhLCBSRUZDTEtfUkVRVUVTVCwgUkVHX1VGU19S
RUZDTEtfQ1RSTCk7DQorCX0gZWxzZSB7DQorCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgUkVGQ0xLX1JF
TEVBU0UsIFJFR19VRlNfUkVGQ0xLX0NUUkwpOw0KKwl9DQorDQorCS8qIFdhaXQgZm9yIGFjayAq
Lw0KKwl0aW1lb3V0ID0gamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoUkVGQ0xLX1JFUV9USU1F
T1VUX01TKTsNCisJZG8gew0KKwkJdmFsdWUgPSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUZTX1JF
RkNMS19DVFJMKTsNCisNCisJCS8qIFdhaXQgdW50aWwgYWNrIGJpdCBlcXVhbHMgdG8gcmVxIGJp
dCAqLw0KKwkJaWYgKCgodmFsdWUgJiBSRUZDTEtfQUNLKSA+PiAxKSA9PSAodmFsdWUgJiBSRUZD
TEtfUkVRVUVTVCkpDQorCQkJZ290byBvdXQ7DQorDQorCQl1c2xlZXBfcmFuZ2UoMTAwLCAyMDAp
Ow0KKwl9IHdoaWxlICh0aW1lX2JlZm9yZShqaWZmaWVzLCB0aW1lb3V0KSk7DQorDQorCWRldl9l
cnIoaGJhLT5kZXYsICJtaXNzaW5nIGFjayBvZiByZWZjbGsgcmVxLCByZWc6IDB4JXhcbiIsIHZh
bHVlKTsNCisNCisJdWZzX210a19yZWZfY2xrX25vdGlmeShob3N0LT5yZWZfY2xrX2VuYWJsZWQs
IHJlcyk7DQorDQorCXJldHVybiAtRVRJTUVET1VUOw0KKw0KK291dDoNCisJaG9zdC0+cmVmX2Ns
a19lbmFibGVkID0gb247DQorCWlmICghb24pDQorCQl1ZnNfbXRrX3JlZl9jbGtfbm90aWZ5KG9u
LCByZXMpOw0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQogLyoqDQogICogdWZzX210a19zZXR1cF9j
bG9ja3MgLSBlbmFibGVzL2Rpc2FibGUgY2xvY2tzDQogICogQGhiYTogaG9zdCBjb250cm9sbGVy
IGluc3RhbmNlDQpAQCAtMTA3LDEyICsxNTUsMTYgQEAgc3RhdGljIGludCB1ZnNfbXRrX3NldHVw
X2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uLA0KIA0KIAlzd2l0Y2ggKHN0YXR1
cykgew0KIAljYXNlIFBSRV9DSEFOR0U6DQotCQlpZiAoIW9uKQ0KKwkJaWYgKCFvbikgew0KKwkJ
CXVmc19tdGtfc2V0dXBfcmVmX2NsayhoYmEsIG9uKTsNCiAJCQlyZXQgPSBwaHlfcG93ZXJfb2Zm
KGhvc3QtPm1waHkpOw0KKwkJfQ0KIAkJYnJlYWs7DQogCWNhc2UgUE9TVF9DSEFOR0U6DQotCQlp
ZiAob24pDQorCQlpZiAob24pIHsNCiAJCQlyZXQgPSBwaHlfcG93ZXJfb24oaG9zdC0+bXBoeSk7
DQorCQkJdWZzX210a19zZXR1cF9yZWZfY2xrKGhiYSwgb24pOw0KKwkJfQ0KIAkJYnJlYWs7DQog
CX0NCiANCkBAIC0yOTksOCArMzUxLDEwIEBAIHN0YXRpYyBpbnQgdWZzX210a19zdXNwZW5kKHN0
cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KIHsNCiAJc3RydWN0IHVm
c19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KIA0KLQlpZiAodWZz
aGNkX2lzX2xpbmtfaGliZXJuOChoYmEpKQ0KKwlpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJuOCho
YmEpKSB7DQogCQlwaHlfcG93ZXJfb2ZmKGhvc3QtPm1waHkpOw0KKwkJdWZzX210a19zZXR1cF9y
ZWZfY2xrKGhiYSwgZmFsc2UpOw0KKwl9DQogDQogCXJldHVybiAwOw0KIH0NCkBAIC0zMDksOCAr
MzYzLDEwIEBAIHN0YXRpYyBpbnQgdWZzX210a19yZXN1bWUoc3RydWN0IHVmc19oYmEgKmhiYSwg
ZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQogew0KIAlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0g
dWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQogDQotCWlmICh1ZnNoY2RfaXNfbGlua19oaWJlcm44
KGhiYSkpDQorCWlmICh1ZnNoY2RfaXNfbGlua19oaWJlcm44KGhiYSkpIHsNCisJCXVmc19tdGtf
c2V0dXBfcmVmX2NsayhoYmEsIHRydWUpOw0KIAkJcGh5X3Bvd2VyX29uKGhvc3QtPm1waHkpOw0K
Kwl9DQogDQogCXJldHVybiAwOw0KIH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KaW5kZXggYjAz
ZjYwMWQzYTllLi4xNGY4YTgzNTdjMDkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1tZWRpYXRlay5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQpAQCAt
Niw3ICs2LDIxIEBADQogI2lmbmRlZiBfVUZTX01FRElBVEVLX0gNCiAjZGVmaW5lIF9VRlNfTUVE
SUFURUtfSA0KIA0KLSNpbmNsdWRlIDxsaW51eC9iaXRvcHMuaD4NCisvKg0KKyAqIFZlbmRvciBz
cGVjaWZpYyBVRlNIQ0kgUmVnaXN0ZXJzDQorICovDQorI2RlZmluZSBSRUdfVUZTX1JFRkNMS19D
VFJMICAgICAgICAgMHgxNDQNCisNCisvKg0KKyAqIFJlZi1jbGsgY29udHJvbA0KKyAqDQorICog
VmFsdWVzIGZvciByZWdpc3RlciBSRUdfVUZTX1JFRkNMS19DVFJMDQorICovDQorI2RlZmluZSBS
RUZDTEtfUkVMRUFTRSAgICAgICAgICAgICAgMHgwDQorI2RlZmluZSBSRUZDTEtfUkVRVUVTVCAg
ICAgICAgICAgICAgQklUKDApDQorI2RlZmluZSBSRUZDTEtfQUNLICAgICAgICAgICAgICAgICAg
QklUKDEpDQorDQorI2RlZmluZSBSRUZDTEtfUkVRX1RJTUVPVVRfTVMgICAgICAgMw0KIA0KIC8q
DQogICogVmVuZG9yIHNwZWNpZmljIHByZS1kZWZpbmVkIHBhcmFtZXRlcnMNCkBAIC0zNCw3ICs0
OCw4IEBADQogLyoNCiAgKiBTaVAgY29tbWFuZHMNCiAgKi8NCi0jZGVmaW5lIFVGU19NVEtfU0lQ
X0RFVklDRV9SRVNFVCAgICBCSVQoMSkNCisjZGVmaW5lIFVGU19NVEtfU0lQX0RFVklDRV9SRVNF
VCAgICAgICAgICBCSVQoMSkNCisjZGVmaW5lIFVGU19NVEtfU0lQX1JFRl9DTEtfTk9USUZJQ0FU
SU9OICBCSVQoMykNCiANCiAvKg0KICAqIFZTX0RFQlVHQ0xPQ0tFTkFCTEUNCkBAIC01NSw2ICs3
MCw3IEBAIGVudW0gew0KIHN0cnVjdCB1ZnNfbXRrX2hvc3Qgew0KIAlzdHJ1Y3QgdWZzX2hiYSAq
aGJhOw0KIAlzdHJ1Y3QgcGh5ICptcGh5Ow0KKwlib29sIHJlZl9jbGtfZW5hYmxlZDsNCiB9Ow0K
IA0KICNlbmRpZiAvKiAhX1VGU19NRURJQVRFS19IICovDQotLSANCjIuMTguMA0K

