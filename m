Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A68C2BBD0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D478E218AC
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="tzjS+Klg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgIHGp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:45:27 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:2238 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728625AbgIHGpT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:45:19 -0400
X-UUID: f643ba82369d428ea25f684f86921498-20200908
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=vkAchY3C2WddVlo+HHoOzkA8z5hp05WmN9gYTWWqPaI=;
        b=tzjS+KlgCtKvL3faXFbkAS2GHYlMteLeI9tGWYxOF3Ht2By59bTEqreKQSp3vjPbLgHMZgVZU3zz16rdZOgkEPfyIZyRdGhdYa/kRFeQ0u3LVmDatHnAeU3KTq8ZnEwjHNhj0dq0IRztp5yScCllvXza3ugdVroXM9Ne9fXEOA8=;
X-UUID: f643ba82369d428ea25f684f86921498-20200908
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 301193689; Tue, 08 Sep 2020 14:45:12 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 8 Sep 2020 14:45:10 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Sep 2020 14:45:10 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 4/4] scsi: ufs-mediatek: Add host reset mechanism
Date:   Tue, 8 Sep 2020 14:45:07 +0800
Message-ID: <20200908064507.30774-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200908064507.30774-1-stanley.chu@mediatek.com>
References: <20200908064507.30774-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGhvc3QgcmVzZXQgbWVjaGFuaXNtIHRvIHRyeSB0byByZWNvdmVyIGhvc3Qtc2lkZSBlcnJv
cnMNCmR1cmluZyByZWNvdmVyeSBmbG93Lg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8
c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVk
aWF0ZWsuYyB8IDQ4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KIGRyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggfCAgMyArKysNCiAyIGZpbGVzIGNoYW5nZWQsIDQ5IGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5k
ZXggZmViYTc0YTcyMzA5Li4xYTkxMzNhYzZlZmIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5j
DQpAQCAtMTMsNiArMTMsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9waHkvcGh5Lmg+DQogI2luY2x1
ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPg0KICNpbmNsdWRlIDxsaW51eC9yZWd1bGF0b3Iv
Y29uc3VtZXIuaD4NCisjaW5jbHVkZSA8bGludXgvcmVzZXQuaD4NCiAjaW5jbHVkZSA8bGludXgv
c29jL21lZGlhdGVrL210a19zaXBfc3ZjLmg+DQogDQogI2luY2x1ZGUgInVmc2hjZC5oIg0KQEAg
LTkxLDE2ICs5Miw1NyBAQCBzdGF0aWMgdm9pZCB1ZnNfbXRrX2NyeXB0b19lbmFibGUoc3RydWN0
IHVmc19oYmEgKmhiYSkNCiAJfQ0KIH0NCiANCitzdGF0aWMgdm9pZCB1ZnNfbXRrX2hvc3RfcmVz
ZXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCit7DQorCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3Qg
PSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCisNCisJcmVzZXRfY29udHJvbF9hc3NlcnQoaG9z
dC0+aGNpX3Jlc2V0KTsNCisJcmVzZXRfY29udHJvbF9hc3NlcnQoaG9zdC0+Y3J5cHRvX3Jlc2V0
KTsNCisJcmVzZXRfY29udHJvbF9hc3NlcnQoaG9zdC0+dW5pcHJvX3Jlc2V0KTsNCisNCisJdXNs
ZWVwX3JhbmdlKDEwMCwgMTEwKTsNCisNCisJcmVzZXRfY29udHJvbF9kZWFzc2VydChob3N0LT51
bmlwcm9fcmVzZXQpOw0KKwlyZXNldF9jb250cm9sX2RlYXNzZXJ0KGhvc3QtPmNyeXB0b19yZXNl
dCk7DQorCXJlc2V0X2NvbnRyb2xfZGVhc3NlcnQoaG9zdC0+aGNpX3Jlc2V0KTsNCit9DQorDQor
c3RhdGljIHZvaWQgdWZzX210a19pbml0X3Jlc2V0X2NvbnRyb2woc3RydWN0IHVmc19oYmEgKmhi
YSwNCisJCQkJICAgICAgIHN0cnVjdCByZXNldF9jb250cm9sICoqcmMsDQorCQkJCSAgICAgICBj
aGFyICpzdHIpDQorew0KKwkqcmMgPSBkZXZtX3Jlc2V0X2NvbnRyb2xfZ2V0KGhiYS0+ZGV2LCBz
dHIpOw0KKwlpZiAoSVNfRVJSKCpyYykpIHsNCisJCWRldl9pbmZvKGhiYS0+ZGV2LCAiRmFpbGVk
IHRvIGdldCByZXNldCBjb250cm9sICVzOiAlZFxuIiwNCisJCQkgc3RyLCBQVFJfRVJSKCpyYykp
Ow0KKwkJKnJjID0gTlVMTDsNCisJfQ0KK30NCisNCitzdGF0aWMgdm9pZCB1ZnNfbXRrX2luaXRf
cmVzZXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCit7DQorCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhv
c3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCisNCisJdWZzX210a19pbml0X3Jlc2V0X2Nv
bnRyb2woaGJhLCAmaG9zdC0+aGNpX3Jlc2V0LA0KKwkJCQkgICAiaGNpX3JzdCIpOw0KKwl1ZnNf
bXRrX2luaXRfcmVzZXRfY29udHJvbChoYmEsICZob3N0LT51bmlwcm9fcmVzZXQsDQorCQkJCSAg
ICJ1bmlwcm9fcnN0Iik7DQorCXVmc19tdGtfaW5pdF9yZXNldF9jb250cm9sKGhiYSwgJmhvc3Qt
PmNyeXB0b19yZXNldCwNCisJCQkJICAgImNyeXB0b19yc3QiKTsNCit9DQorDQogc3RhdGljIGlu
dCB1ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5KHN0cnVjdCB1ZnNfaGJhICpoYmEsDQogCQkJCSAg
ICAgZW51bSB1ZnNfbm90aWZ5X2NoYW5nZV9zdGF0dXMgc3RhdHVzKQ0KIHsNCiAJc3RydWN0IHVm
c19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KIA0KIAlpZiAoc3Rh
dHVzID09IFBSRV9DSEFOR0UpIHsNCi0JCWlmIChob3N0LT51bmlwcm9fbHBtKQ0KKwkJaWYgKGhv
c3QtPnVuaXByb19scG0pIHsNCiAJCQloYmEtPnZwcy0+aGJhX2VuYWJsZV9kZWxheV91cyA9IDA7
DQotCQllbHNlDQorCQl9IGVsc2Ugew0KIAkJCWhiYS0+dnBzLT5oYmFfZW5hYmxlX2RlbGF5X3Vz
ID0gNjAwOw0KKwkJCXVmc19tdGtfaG9zdF9yZXNldChoYmEpOw0KKwkJfQ0KIA0KIAkJaWYgKGhi
YS0+Y2FwcyAmIFVGU0hDRF9DQVBfQ1JZUFRPKQ0KIAkJCXVmc19tdGtfY3J5cHRvX2VuYWJsZSho
YmEpOw0KQEAgLTMzNSw2ICszNzcsOCBAQCBzdGF0aWMgaW50IHVmc19tdGtfaW5pdChzdHJ1Y3Qg
dWZzX2hiYSAqaGJhKQ0KIAlpZiAoZXJyKQ0KIAkJZ290byBvdXRfdmFyaWFudF9jbGVhcjsNCiAN
CisJdWZzX210a19pbml0X3Jlc2V0KGhiYSk7DQorDQogCS8qIEVuYWJsZSBydW50aW1lIGF1dG9z
dXNwZW5kICovDQogCWhiYS0+Y2FwcyB8PSBVRlNIQ0RfQ0FQX1JQTV9BVVRPU1VTUEVORDsNCiAN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KaW5kZXggODc2NTczNzZkMjdhLi41YzMyZDVmNTI3NTkg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQorKysgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oDQpAQCAtOTIsNiArOTIsOSBAQCBlbnVtIHsNCiBz
dHJ1Y3QgdWZzX210a19ob3N0IHsNCiAJc3RydWN0IHVmc19oYmEgKmhiYTsNCiAJc3RydWN0IHBo
eSAqbXBoeTsNCisJc3RydWN0IHJlc2V0X2NvbnRyb2wgKmhjaV9yZXNldDsNCisJc3RydWN0IHJl
c2V0X2NvbnRyb2wgKnVuaXByb19yZXNldDsNCisJc3RydWN0IHJlc2V0X2NvbnRyb2wgKmNyeXB0
b19yZXNldDsNCiAJYm9vbCBtcGh5X3Bvd2VyZWRfb247DQogCWJvb2wgdW5pcHJvX2xwbTsNCiAJ
Ym9vbCByZWZfY2xrX2VuYWJsZWQ7DQotLSANCjIuMTguMA0K

