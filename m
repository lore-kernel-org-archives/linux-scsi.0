Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5923DC2D0DA
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2039E20CC7
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:33:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oNPS4xmp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfL3FdG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 00:33:06 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:9238 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727213AbfL3FdA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2019 00:33:00 -0500
X-UUID: fa325d3261484dad856316724e1efeda-20191230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=CT6J6Mos8F012MHJEi2dQQCWX4KKKCdgeXYgBRHOS3k=;
        b=oNPS4xmpH1QbfA/e8MS3EK28wTDCCkRqJxxug7ZWJq/zPG8nSgCOASSfCEFz7Ofdaywx56/0quWdpRJtG3wuG0QiRX7fmXgnNDfPlR1PtGSYhIkjcNV+1Y0DdY2iOm1B1eXMkdIEJktoip0KkHB+1mjaF+TOPVe9B+ERV3K7MlI=;
X-UUID: fa325d3261484dad856316724e1efeda-20191230
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1529864162; Mon, 30 Dec 2019 13:32:52 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Dec 2019 13:32:05 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 30 Dec 2019 13:31:37 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <f.fainelli@gmail.com>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <leon.chen@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 3/6] scsi: ufs-mediatek: introduce reference clock control
Date:   Mon, 30 Dec 2019 13:32:27 +0800
Message-ID: <1577683950-1702-4-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
References: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
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
b2NrLWdhdGluZyBhZnRlciBsaW5rIGVudGVycyBoaWJlcm5hdGUgc3RhdGUuDQoNCkNjOiBBbGlt
IEFraHRhciA8YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+DQpDYzogQXZyaSBBbHRtYW4gPGF2cmku
YWx0bWFuQHdkYy5jb20+DQpDYzogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+
DQpDYzogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCkNjOiBDYW4gR3VvIDxjYW5nQGNv
ZGVhdXJvcmEub3JnPg0KQ2M6IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29t
Pg0KQ2M6IE1hdHRoaWFzIEJydWdnZXIgPG1hdHRoaWFzLmJnZ0BnbWFpbC5jb20+DQpTaWduZWQt
b2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQt
Ynk6IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT4NCi0tLQ0KIGRyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCA2MiArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIHwgMjIgKysrKysrKysrKy0t
DQogMiBmaWxlcyBjaGFuZ2VkLCA3OCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMNCmluZGV4IDM3ZTJjOTFmYzQ1Mi4uZmM1YmEyMWVjMDJhIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KKysrIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KQEAgLTIyLDYgKzIyLDkgQEANCiAJYXJtX3NtY2Nj
X3NtYyhNVEtfU0lQX1VGU19DT05UUk9MLCBcDQogCQkgICAgICBjbWQsIHZhbCwgMCwgMCwgMCwg
MCwgMCwgJihyZXMpKQ0KIA0KKyNkZWZpbmUgdWZzX210a19yZWZfY2xrX25vdGlmeShvbiwgcmVz
KSBcDQorCXVmc19tdGtfc21jKFVGU19NVEtfU0lQX1JFRl9DTEtfTk9USUZJQ0FUSU9OLCBvbiwg
cmVzKQ0KKw0KICNkZWZpbmUgdWZzX210a19kZXZpY2VfcmVzZXRfY3RybChoaWdoLCByZXMpIFwN
CiAJdWZzX210a19zbWMoVUZTX01US19TSVBfREVWSUNFX1JFU0VULCBoaWdoLCByZXMpDQogDQpA
QCAtOTAsNiArOTMsNDkgQEAgc3RhdGljIGludCB1ZnNfbXRrX2JpbmRfbXBoeShzdHJ1Y3QgdWZz
X2hiYSAqaGJhKQ0KIAlyZXR1cm4gZXJyOw0KIH0NCiANCitzdGF0aWMgaW50IHVmc19tdGtfc2V0
dXBfcmVmX2NsayhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uKQ0KK3sNCisJc3RydWN0IHVm
c19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KKwlzdHJ1Y3QgYXJt
X3NtY2NjX3JlcyByZXM7DQorCXVuc2lnbmVkIGxvbmcgdGltZW91dDsNCisJdTMyIHZhbHVlOw0K
Kw0KKwlpZiAoaG9zdC0+cmVmX2Nsa19lbmFibGVkID09IG9uKQ0KKwkJcmV0dXJuIDA7DQorDQor
CWlmIChvbikgew0KKwkJdWZzX210a19yZWZfY2xrX25vdGlmeShvbiwgcmVzKTsNCisJCXVmc2hj
ZF93cml0ZWwoaGJhLCBSRUZDTEtfUkVRVUVTVCwgUkVHX1VGU19SRUZDTEtfQ1RSTCk7DQorCX0g
ZWxzZSB7DQorCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgUkVGQ0xLX1JFTEVBU0UsIFJFR19VRlNfUkVG
Q0xLX0NUUkwpOw0KKwl9DQorDQorCS8qIFdhaXQgZm9yIGFjayAqLw0KKwl0aW1lb3V0ID0gamlm
ZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoUkVGQ0xLX1JFUV9USU1FT1VUX01TKTsNCisJZG8gew0K
KwkJdmFsdWUgPSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUZTX1JFRkNMS19DVFJMKTsNCisNCisJ
CS8qIFdhaXQgdW50aWwgYWNrIGJpdCBlcXVhbHMgdG8gcmVxIGJpdCAqLw0KKwkJaWYgKCgodmFs
dWUgJiBSRUZDTEtfQUNLKSA+PiAxKSA9PSAodmFsdWUgJiBSRUZDTEtfUkVRVUVTVCkpDQorCQkJ
Z290byBvdXQ7DQorDQorCQl1c2xlZXBfcmFuZ2UoMTAwLCAyMDApOw0KKwl9IHdoaWxlICh0aW1l
X2JlZm9yZShqaWZmaWVzLCB0aW1lb3V0KSk7DQorDQorCWRldl9lcnIoaGJhLT5kZXYsICJtaXNz
aW5nIGFjayBvZiByZWZjbGsgcmVxLCByZWc6IDB4JXhcbiIsIHZhbHVlKTsNCisNCisJdWZzX210
a19yZWZfY2xrX25vdGlmeShob3N0LT5yZWZfY2xrX2VuYWJsZWQsIHJlcyk7DQorDQorCXJldHVy
biAtRVRJTUVET1VUOw0KKw0KK291dDoNCisJaG9zdC0+cmVmX2Nsa19lbmFibGVkID0gb247DQor
CWlmICghb24pDQorCQl1ZnNfbXRrX3JlZl9jbGtfbm90aWZ5KG9uLCByZXMpOw0KKw0KKwlyZXR1
cm4gMDsNCit9DQorDQogLyoqDQogICogdWZzX210a19zZXR1cF9jbG9ja3MgLSBlbmFibGVzL2Rp
c2FibGUgY2xvY2tzDQogICogQGhiYTogaG9zdCBjb250cm9sbGVyIGluc3RhbmNlDQpAQCAtMTE0
LDEyICsxNjAsMTYgQEAgc3RhdGljIGludCB1ZnNfbXRrX3NldHVwX2Nsb2NrcyhzdHJ1Y3QgdWZz
X2hiYSAqaGJhLCBib29sIG9uLA0KIA0KIAlzd2l0Y2ggKHN0YXR1cykgew0KIAljYXNlIFBSRV9D
SEFOR0U6DQotCQlpZiAoIW9uKQ0KKwkJaWYgKCFvbikgew0KKwkJCXVmc19tdGtfc2V0dXBfcmVm
X2NsayhoYmEsIG9uKTsNCiAJCQlyZXQgPSBwaHlfcG93ZXJfb2ZmKGhvc3QtPm1waHkpOw0KKwkJ
fQ0KIAkJYnJlYWs7DQogCWNhc2UgUE9TVF9DSEFOR0U6DQotCQlpZiAob24pDQorCQlpZiAob24p
IHsNCiAJCQlyZXQgPSBwaHlfcG93ZXJfb24oaG9zdC0+bXBoeSk7DQorCQkJdWZzX210a19zZXR1
cF9yZWZfY2xrKGhiYSwgb24pOw0KKwkJfQ0KIAkJYnJlYWs7DQogCX0NCiANCkBAIC0zMDUsOCAr
MzU1LDEwIEBAIHN0YXRpYyBpbnQgdWZzX210a19zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEs
IGVudW0gdWZzX3BtX29wIHBtX29wKQ0KIHsNCiAJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9
IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KIA0KLQlpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJu
OChoYmEpKQ0KKwlpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJuOChoYmEpKSB7DQogCQlwaHlfcG93
ZXJfb2ZmKGhvc3QtPm1waHkpOw0KKwkJdWZzX210a19zZXR1cF9yZWZfY2xrKGhiYSwgZmFsc2Up
Ow0KKwl9DQogDQogCXJldHVybiAwOw0KIH0NCkBAIC0zMTUsOCArMzY3LDEwIEBAIHN0YXRpYyBp
bnQgdWZzX210a19yZXN1bWUoc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1f
b3ApDQogew0KIAlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50
KGhiYSk7DQogDQotCWlmICh1ZnNoY2RfaXNfbGlua19oaWJlcm44KGhiYSkpDQorCWlmICh1ZnNo
Y2RfaXNfbGlua19oaWJlcm44KGhiYSkpIHsNCisJCXVmc19tdGtfc2V0dXBfcmVmX2NsayhoYmEs
IHRydWUpOw0KIAkJcGh5X3Bvd2VyX29uKGhvc3QtPm1waHkpOw0KKwl9DQogDQogCXJldHVybiAw
Ow0KIH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KaW5kZXggY2U2OGNlMjVmZGQ3Li4zMWI3ZmVh
ZDE5ZWIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQorKysg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQpAQCAtOSw2ICs5LDIyIEBADQogI2lu
Y2x1ZGUgPGxpbnV4L2JpdG9wcy5oPg0KICNpbmNsdWRlIDxsaW51eC9zb2MvbWVkaWF0ZWsvbXRr
X3NpcF9zdmMuaD4NCiANCisvKg0KKyAqIFZlbmRvciBzcGVjaWZpYyBVRlNIQ0kgUmVnaXN0ZXJz
DQorICovDQorI2RlZmluZSBSRUdfVUZTX1JFRkNMS19DVFJMICAgICAgICAgMHgxNDQNCisNCisv
Kg0KKyAqIFJlZi1jbGsgY29udHJvbA0KKyAqDQorICogVmFsdWVzIGZvciByZWdpc3RlciBSRUdf
VUZTX1JFRkNMS19DVFJMDQorICovDQorI2RlZmluZSBSRUZDTEtfUkVMRUFTRSAgICAgICAgICAg
ICAgMHgwDQorI2RlZmluZSBSRUZDTEtfUkVRVUVTVCAgICAgICAgICAgICAgQklUKDApDQorI2Rl
ZmluZSBSRUZDTEtfQUNLICAgICAgICAgICAgICAgICAgQklUKDEpDQorDQorI2RlZmluZSBSRUZD
TEtfUkVRX1RJTUVPVVRfTVMgICAgICAgMw0KKw0KIC8qDQogICogVmVuZG9yIHNwZWNpZmljIHBy
ZS1kZWZpbmVkIHBhcmFtZXRlcnMNCiAgKi8NCkBAIC0zNSw4ICs1MSw5IEBADQogLyoNCiAgKiBT
aVAgY29tbWFuZHMNCiAgKi8NCi0jZGVmaW5lIE1US19TSVBfVUZTX0NPTlRST0wgICAgICAgICBN
VEtfU0lQX1NNQ19DTUQoMHgyNzYpDQotI2RlZmluZSBVRlNfTVRLX1NJUF9ERVZJQ0VfUkVTRVQg
ICAgQklUKDEpDQorI2RlZmluZSBNVEtfU0lQX1VGU19DT05UUk9MICAgICAgICAgICAgICAgTVRL
X1NJUF9TTUNfQ01EKDB4Mjc2KQ0KKyNkZWZpbmUgVUZTX01US19TSVBfREVWSUNFX1JFU0VUICAg
ICAgICAgIEJJVCgxKQ0KKyNkZWZpbmUgVUZTX01US19TSVBfUkVGX0NMS19OT1RJRklDQVRJT04g
IEJJVCgzKQ0KIA0KIC8qDQogICogVlNfREVCVUdDTE9DS0VOQUJMRQ0KQEAgLTU3LDYgKzc0LDcg
QEAgZW51bSB7DQogc3RydWN0IHVmc19tdGtfaG9zdCB7DQogCXN0cnVjdCB1ZnNfaGJhICpoYmE7
DQogCXN0cnVjdCBwaHkgKm1waHk7DQorCWJvb2wgcmVmX2Nsa19lbmFibGVkOw0KIH07DQogDQog
I2VuZGlmIC8qICFfVUZTX01FRElBVEVLX0ggKi8NCi0tIA0KMi4xOC4wDQo=

