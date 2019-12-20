Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54397C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 208A124680
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uQwfVO/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfLTIgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 03:36:45 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:19551 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727279AbfLTIgo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 03:36:44 -0500
X-UUID: e809115f14cc43d3ae7ee384d7a2f3e6-20191220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=FQ9iJGiHG3tZx1pkXd4zqWoMs5/8XtOFzIai6fL+Jjs=;
        b=uQwfVO/ghclJh1xap9nNHFy0FEPrnt7hhpewz4BoQODRk0bxxRDVW/V1WErS/blS+c+hjOGCIHp4ZLaFPbHeeS36xPt6VKSEi2kDxbh+APLeLDUM/qWj63b3akI5tWQWhVwpbPyvKnPaPvDS4Vh353GbVplEY9aJSEXfdY05aVM=;
X-UUID: e809115f14cc43d3ae7ee384d7a2f3e6-20191220
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1238035670; Fri, 20 Dec 2019 16:36:33 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 20 Dec 2019 16:35:58 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 20 Dec 2019 16:35:38 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <f.fainelli@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <leon.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 3/6] scsi: ufs-mediatek: introduce reference clock control
Date:   Fri, 20 Dec 2019 16:36:25 +0800
Message-ID: <1576830988-22435-4-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
References: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
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
ZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpSZXZpZXdlZC1i
eTogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPg0KLS0tDQogZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDY0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmggfCAyMCArKysrKysrKystLQ0K
IDIgZmlsZXMgY2hhbmdlZCwgNzggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5jDQppbmRleCA2YTNlYzExYjE2ZGIuLjY5MDQ4M2M3ODIxMiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCisrKyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCkBAIC0xOCw2ICsxOCwxMSBAQA0KICNpbmNsdWRlICJ1
bmlwcm8uaCINCiAjaW5jbHVkZSAidWZzLW1lZGlhdGVrLmgiDQogDQorI2RlZmluZSB1ZnNfbXRr
X3JlZl9jbGtfbm90aWZ5KG9uLCByZXMpIFwNCisJYXJtX3NtY2NjX3NtYyhNVEtfU0lQX1VGU19D
T05UUk9MLCBcDQorCQkgICAgICBVRlNfTVRLX1NJUF9SRUZfQ0xLX05PVElGSUNBVElPTiwgXA0K
KwkJICAgICAgb24sIDAsIDAsIDAsIDAsIDAsICYocmVzKSkNCisNCiBzdGF0aWMgdm9pZCB1ZnNf
bXRrX2NmZ191bmlwcm9fY2coc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpDQogew0K
IAl1MzIgdG1wOw0KQEAgLTgzLDYgKzg4LDQ5IEBAIHN0YXRpYyBpbnQgdWZzX210a19iaW5kX21w
aHkoc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJcmV0dXJuIGVycjsNCiB9DQogDQorc3RhdGljIGlu
dCB1ZnNfbXRrX3NldHVwX3JlZl9jbGsoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBvbikNCit7
DQorCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsN
CisJc3RydWN0IGFybV9zbWNjY19yZXMgcmVzOw0KKwl1bnNpZ25lZCBsb25nIHRpbWVvdXQ7DQor
CXUzMiB2YWx1ZTsNCisNCisJaWYgKGhvc3QtPnJlZl9jbGtfZW5hYmxlZCA9PSBvbikNCisJCXJl
dHVybiAwOw0KKw0KKwlpZiAob24pIHsNCisJCXVmc19tdGtfcmVmX2Nsa19ub3RpZnkob24sIHJl
cyk7DQorCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgUkVGQ0xLX1JFUVVFU1QsIFJFR19VRlNfUkVGQ0xL
X0NUUkwpOw0KKwl9IGVsc2Ugew0KKwkJdWZzaGNkX3dyaXRlbChoYmEsIFJFRkNMS19SRUxFQVNF
LCBSRUdfVUZTX1JFRkNMS19DVFJMKTsNCisJfQ0KKw0KKwkvKiBXYWl0IGZvciBhY2sgKi8NCisJ
dGltZW91dCA9IGppZmZpZXMgKyBtc2Vjc190b19qaWZmaWVzKFJFRkNMS19SRVFfVElNRU9VVF9N
Uyk7DQorCWRvIHsNCisJCXZhbHVlID0gdWZzaGNkX3JlYWRsKGhiYSwgUkVHX1VGU19SRUZDTEtf
Q1RSTCk7DQorDQorCQkvKiBXYWl0IHVudGlsIGFjayBiaXQgZXF1YWxzIHRvIHJlcSBiaXQgKi8N
CisJCWlmICgoKHZhbHVlICYgUkVGQ0xLX0FDSykgPj4gMSkgPT0gKHZhbHVlICYgUkVGQ0xLX1JF
UVVFU1QpKQ0KKwkJCWdvdG8gb3V0Ow0KKw0KKwkJdXNsZWVwX3JhbmdlKDEwMCwgMjAwKTsNCisJ
fSB3aGlsZSAodGltZV9iZWZvcmUoamlmZmllcywgdGltZW91dCkpOw0KKw0KKwlkZXZfZXJyKGhi
YS0+ZGV2LCAibWlzc2luZyBhY2sgb2YgcmVmY2xrIHJlcSwgcmVnOiAweCV4XG4iLCB2YWx1ZSk7
DQorDQorCXVmc19tdGtfcmVmX2Nsa19ub3RpZnkoaG9zdC0+cmVmX2Nsa19lbmFibGVkLCByZXMp
Ow0KKw0KKwlyZXR1cm4gLUVUSU1FRE9VVDsNCisNCitvdXQ6DQorCWhvc3QtPnJlZl9jbGtfZW5h
YmxlZCA9IG9uOw0KKwlpZiAoIW9uKQ0KKwkJdWZzX210a19yZWZfY2xrX25vdGlmeShvbiwgcmVz
KTsNCisNCisJcmV0dXJuIDA7DQorfQ0KKw0KIC8qKg0KICAqIHVmc19tdGtfc2V0dXBfY2xvY2tz
IC0gZW5hYmxlcy9kaXNhYmxlIGNsb2Nrcw0KICAqIEBoYmE6IGhvc3QgY29udHJvbGxlciBpbnN0
YW5jZQ0KQEAgLTEwNywxMiArMTU1LDE2IEBAIHN0YXRpYyBpbnQgdWZzX210a19zZXR1cF9jbG9j
a3Moc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBvbiwNCiANCiAJc3dpdGNoIChzdGF0dXMpIHsN
CiAJY2FzZSBQUkVfQ0hBTkdFOg0KLQkJaWYgKCFvbikNCisJCWlmICghb24pIHsNCisJCQl1ZnNf
bXRrX3NldHVwX3JlZl9jbGsoaGJhLCBvbik7DQogCQkJcmV0ID0gcGh5X3Bvd2VyX29mZihob3N0
LT5tcGh5KTsNCisJCX0NCiAJCWJyZWFrOw0KIAljYXNlIFBPU1RfQ0hBTkdFOg0KLQkJaWYgKG9u
KQ0KKwkJaWYgKG9uKSB7DQogCQkJcmV0ID0gcGh5X3Bvd2VyX29uKGhvc3QtPm1waHkpOw0KKwkJ
CXVmc19tdGtfc2V0dXBfcmVmX2NsayhoYmEsIG9uKTsNCisJCX0NCiAJCWJyZWFrOw0KIAl9DQog
DQpAQCAtMjk5LDggKzM1MSwxMCBAQCBzdGF0aWMgaW50IHVmc19tdGtfc3VzcGVuZChzdHJ1Y3Qg
dWZzX2hiYSAqaGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCiB7DQogCXN0cnVjdCB1ZnNfbXRr
X2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCiANCi0JaWYgKHVmc2hjZF9p
c19saW5rX2hpYmVybjgoaGJhKSkNCisJaWYgKHVmc2hjZF9pc19saW5rX2hpYmVybjgoaGJhKSkg
ew0KIAkJcGh5X3Bvd2VyX29mZihob3N0LT5tcGh5KTsNCisJCXVmc19tdGtfc2V0dXBfcmVmX2Ns
ayhoYmEsIGZhbHNlKTsNCisJfQ0KIA0KIAlyZXR1cm4gMDsNCiB9DQpAQCAtMzA5LDggKzM2Mywx
MCBAQCBzdGF0aWMgaW50IHVmc19tdGtfcmVzdW1lKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0g
dWZzX3BtX29wIHBtX29wKQ0KIHsNCiAJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hj
ZF9nZXRfdmFyaWFudChoYmEpOw0KIA0KLQlpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJuOChoYmEp
KQ0KKwlpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJuOChoYmEpKSB7DQorCQl1ZnNfbXRrX3NldHVw
X3JlZl9jbGsoaGJhLCB0cnVlKTsNCiAJCXBoeV9wb3dlcl9vbihob3N0LT5tcGh5KTsNCisJfQ0K
IA0KIAlyZXR1cm4gMDsNCiB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVk
aWF0ZWsuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmgNCmluZGV4IGIwM2Y2MDFk
M2E5ZS4uMTRmOGE4MzU3YzA5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVk
aWF0ZWsuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KQEAgLTYsNyAr
NiwyMSBAQA0KICNpZm5kZWYgX1VGU19NRURJQVRFS19IDQogI2RlZmluZSBfVUZTX01FRElBVEVL
X0gNCiANCi0jaW5jbHVkZSA8bGludXgvYml0b3BzLmg+DQorLyoNCisgKiBWZW5kb3Igc3BlY2lm
aWMgVUZTSENJIFJlZ2lzdGVycw0KKyAqLw0KKyNkZWZpbmUgUkVHX1VGU19SRUZDTEtfQ1RSTCAg
ICAgICAgIDB4MTQ0DQorDQorLyoNCisgKiBSZWYtY2xrIGNvbnRyb2wNCisgKg0KKyAqIFZhbHVl
cyBmb3IgcmVnaXN0ZXIgUkVHX1VGU19SRUZDTEtfQ1RSTA0KKyAqLw0KKyNkZWZpbmUgUkVGQ0xL
X1JFTEVBU0UgICAgICAgICAgICAgIDB4MA0KKyNkZWZpbmUgUkVGQ0xLX1JFUVVFU1QgICAgICAg
ICAgICAgIEJJVCgwKQ0KKyNkZWZpbmUgUkVGQ0xLX0FDSyAgICAgICAgICAgICAgICAgIEJJVCgx
KQ0KKw0KKyNkZWZpbmUgUkVGQ0xLX1JFUV9USU1FT1VUX01TICAgICAgIDMNCiANCiAvKg0KICAq
IFZlbmRvciBzcGVjaWZpYyBwcmUtZGVmaW5lZCBwYXJhbWV0ZXJzDQpAQCAtMzQsNyArNDgsOCBA
QA0KIC8qDQogICogU2lQIGNvbW1hbmRzDQogICovDQotI2RlZmluZSBVRlNfTVRLX1NJUF9ERVZJ
Q0VfUkVTRVQgICAgQklUKDEpDQorI2RlZmluZSBVRlNfTVRLX1NJUF9ERVZJQ0VfUkVTRVQgICAg
ICAgICAgQklUKDEpDQorI2RlZmluZSBVRlNfTVRLX1NJUF9SRUZfQ0xLX05PVElGSUNBVElPTiAg
QklUKDMpDQogDQogLyoNCiAgKiBWU19ERUJVR0NMT0NLRU5BQkxFDQpAQCAtNTUsNiArNzAsNyBA
QCBlbnVtIHsNCiBzdHJ1Y3QgdWZzX210a19ob3N0IHsNCiAJc3RydWN0IHVmc19oYmEgKmhiYTsN
CiAJc3RydWN0IHBoeSAqbXBoeTsNCisJYm9vbCByZWZfY2xrX2VuYWJsZWQ7DQogfTsNCiANCiAj
ZW5kaWYgLyogIV9VRlNfTUVESUFURUtfSCAqLw0KLS0gDQoyLjE4LjANCg==

