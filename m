Return-Path: <SRS0=+zlT=7O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4121C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 10:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E15E2077D
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 10:47:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rsZ05fmH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgFAKq7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Jun 2020 06:46:59 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:54511 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726101AbgFAKqx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2020 06:46:53 -0400
X-UUID: 2e67097a6b7d4e9490bd6c6466c1ce67-20200601
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ffvmQC8t/hn3+jnrp17+5Ooh5VVEaAxae4PFdHA2xRE=;
        b=rsZ05fmHpOwcDjggbiz5R/eIbtWkvbp43DuOvfeO8r7e2TBpeVrUCvtlrAxyDDTEqmiBO6H26xHvQbGEJ+OhvayASzTC0OjVBMxOtrKGgtVZubFp3mta2HniCezqzu7sXXEF3pgtO9/EIQ4J1iC3mPlPwlwpaSsjzdrjUMtL5Hk=;
X-UUID: 2e67097a6b7d4e9490bd6c6466c1ce67-20200601
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 940390874; Mon, 01 Jun 2020 18:46:49 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 1 Jun 2020 18:46:46 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 1 Jun 2020 18:46:46 +0800
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
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 4/5] scsi: ufs-mediatek: Fix unbalanced clock on/off
Date:   Mon, 1 Jun 2020 18:46:45 +0800
Message-ID: <20200601104646.15436-5-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200601104646.15436-1-stanley.chu@mediatek.com>
References: <20200601104646.15436-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 3B690E7BA8B2E87E504F51C7332648DAE36C3531BDA6C53F261C0676475742F02000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWVkaWFUZWsgVUZTIGNsb2NrcyBhcmUgc2VwYXJhdGVkIHRvIHR3byBwYXJ0cyBhbmQgY29udHJv
bGxlZA0KYnkgZGlmZmVyZW50IG1vZHVsZXM6IHVmcy1tZWRpYXRlayBhbmQgcGh5LXVmcy1tZWRp
YXRlay4NCg0KSWYgYm90aCBBdXRvLUhpYmVybjggYW5kIGNsay1nYXRpbmcgZmVhdHVyZSBhcmUg
ZW5hYmxlZCwgbXBoeQ0KcG93ZXIgY29udHJvbCBpcyBub3QgYmFsYW5jZWQgdGh1cyB1bmJhbGFu
Y2VkIGNvbnRyb2wgYWxzbw0KaGFwcGVucyB0byB0aGUgY2xvY2tzIHByb2JlZCBieSBwaHktdWZz
LW1lZGlhdGVrIG1vZHVsZS4NCg0KRml4IHRoaXMgaXNzdWUgYnkNCg0KLSBQcm9taXNlIHVzYWdl
IG9mIHBoeV9wb3dlcl9vbi9vZmYgYmFsYW5jZWQNCg0KLSBSZW1vdmUgcGh5X3Bvd2VyX29uL29m
ZiBjb250cm9sIGluIHN1c3BlbmQvcmVzdW1lIHZvcHMgc2luY2UNCiAgYm90aCBjYW4gYmUgaGFu
ZGxlZCBpbiBzZXR1cF9jbG9jayB2b3BzIG9ubHkNCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBD
aHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxw
ZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlh
dGVrLmMgfCA2MCArKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0NCiBkcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5oIHwgIDEgKw0KIDIgZmlsZXMgY2hhbmdlZCwgMzggaW5zZXJ0
aW9ucygrKSwgMjMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KaW5kZXgg
NWY0MWI3YjdkYjhmLi4xY2M3YmVhMTQ2OGIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQpA
QCAtMjA1LDYgKzIwNSwyMyBAQCBpbnQgdWZzX210a193YWl0X2xpbmtfc3RhdGUoc3RydWN0IHVm
c19oYmEgKmhiYSwgdTMyIHN0YXRlLA0KIAlyZXR1cm4gLUVUSU1FRE9VVDsNCiB9DQogDQorc3Rh
dGljIHZvaWQgdWZzX210a19tcGh5X3Bvd2VyX29uKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wg
b24pDQorew0KKwlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50
KGhiYSk7DQorCXN0cnVjdCBwaHkgKm1waHkgPSBob3N0LT5tcGh5Ow0KKw0KKwlpZiAoIW1waHkp
DQorCQlyZXR1cm47DQorDQorCWlmIChvbiAmJiAhaG9zdC0+bXBoeV9wb3dlcmVkX29uKQ0KKwkJ
cGh5X3Bvd2VyX29uKG1waHkpOw0KKwllbHNlIGlmICghb24gJiYgaG9zdC0+bXBoeV9wb3dlcmVk
X29uKQ0KKwkJcGh5X3Bvd2VyX29mZihtcGh5KTsNCisJZWxzZQ0KKwkJcmV0dXJuOw0KKwlob3N0
LT5tcGh5X3Bvd2VyZWRfb24gPSBvbjsNCit9DQorDQogLyoqDQogICogdWZzX210a19zZXR1cF9j
bG9ja3MgLSBlbmFibGVzL2Rpc2FibGUgY2xvY2tzDQogICogQGhiYTogaG9zdCBjb250cm9sbGVy
IGluc3RhbmNlDQpAQCAtMjE4LDYgKzIzNSw3IEBAIHN0YXRpYyBpbnQgdWZzX210a19zZXR1cF9j
bG9ja3Moc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBvbiwNCiB7DQogCXN0cnVjdCB1ZnNfbXRr
X2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCiAJaW50IHJldCA9IDA7DQor
CWJvb2wgY2xrX3B3cl9vZmYgPSBmYWxzZTsNCiANCiAJLyoNCiAJICogSW4gY2FzZSB1ZnNfbXRr
X2luaXQoKSBpcyBub3QgeWV0IGRvbmUsIHNpbXBseSBpZ25vcmUuDQpAQCAtMjI4LDI1ICsyNDYs
MjkgQEAgc3RhdGljIGludCB1ZnNfbXRrX3NldHVwX2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJh
LCBib29sIG9uLA0KIAkJcmV0dXJuIDA7DQogDQogCWlmICghb24gJiYgc3RhdHVzID09IFBSRV9D
SEFOR0UpIHsNCi0JCWlmICghdWZzaGNkX2lzX2xpbmtfYWN0aXZlKGhiYSkpIHsNCi0JCQl1ZnNf
bXRrX3NldHVwX3JlZl9jbGsoaGJhLCBvbik7DQotCQkJcmV0ID0gcGh5X3Bvd2VyX29mZihob3N0
LT5tcGh5KTsNCi0JCX0gZWxzZSB7DQorCQlpZiAodWZzaGNkX2lzX2xpbmtfb2ZmKGhiYSkpIHsN
CisJCQljbGtfcHdyX29mZiA9IHRydWU7DQorCQl9IGVsc2UgaWYgKHVmc2hjZF9pc19saW5rX2hp
YmVybjgoaGJhKSB8fA0KKwkJCSAoIXVmc2hjZF9jYW5faGliZXJuOF9kdXJpbmdfZ2F0aW5nKGhi
YSkgJiYNCisJCQkgdWZzaGNkX2lzX2F1dG9faGliZXJuOF9lbmFibGVkKGhiYSkpKSB7DQogCQkJ
LyoNCi0JCQkgKiBHYXRlIHJlZi1jbGsgaWYgbGluayBzdGF0ZSBpcyBpbiBIaWJlcm44DQotCQkJ
ICogdHJpZ2dlcmVkIGJ5IEF1dG8tSGliZXJuOC4NCisJCQkgKiBHYXRlIHJlZi1jbGsgYW5kIHBv
d2Vyb2ZmIG1waHkgaWYgbGluayBzdGF0ZSBpcyBpbg0KKwkJCSAqIE9GRiBvciBIaWJlcm44IGJ5
IGVpdGhlciBBdXRvLUhpYmVybjggb3INCisJCQkgKiB1ZnNoY2RfbGlua19zdGF0ZV90cmFuc2l0
aW9uKCkuDQogCQkJICovDQotCQkJaWYgKCF1ZnNoY2RfY2FuX2hpYmVybjhfZHVyaW5nX2dhdGlu
ZyhoYmEpICYmDQotCQkJICAgIHVmc2hjZF9pc19hdXRvX2hpYmVybjhfZW5hYmxlZChoYmEpKSB7
DQotCQkJCXJldCA9IHVmc19tdGtfd2FpdF9saW5rX3N0YXRlKGhiYSwNCi0JCQkJCQkJICAgICAg
VlNfTElOS19ISUJFUk44LA0KLQkJCQkJCQkgICAgICAxNSk7DQotCQkJCWlmICghcmV0KQ0KLQkJ
CQkJdWZzX210a19zZXR1cF9yZWZfY2xrKGhiYSwgb24pOw0KLQkJCX0NCisJCQlyZXQgPSB1ZnNf
bXRrX3dhaXRfbGlua19zdGF0ZShoYmEsDQorCQkJCQkJICAgICAgVlNfTElOS19ISUJFUk44LA0K
KwkJCQkJCSAgICAgIDE1KTsNCisJCQlpZiAoIXJldCkNCisJCQkJY2xrX3B3cl9vZmYgPSB0cnVl
Ow0KKwkJfQ0KKw0KKwkJaWYgKGNsa19wd3Jfb2ZmKSB7DQorCQkJdWZzX210a19zZXR1cF9yZWZf
Y2xrKGhiYSwgb24pOw0KKwkJCXVmc19tdGtfbXBoeV9wb3dlcl9vbihoYmEsIG9uKTsNCiAJCX0N
CiAJfSBlbHNlIGlmIChvbiAmJiBzdGF0dXMgPT0gUE9TVF9DSEFOR0UpIHsNCi0JCXJldCA9IHBo
eV9wb3dlcl9vbihob3N0LT5tcGh5KTsNCisJCXVmc19tdGtfbXBoeV9wb3dlcl9vbihoYmEsIG9u
KTsNCiAJCXVmc19tdGtfc2V0dXBfcmVmX2NsayhoYmEsIG9uKTsNCiAJfQ0KIA0KQEAgLTUzOCw3
ICs1NjAsNiBAQCBzdGF0aWMgdm9pZCB1ZnNfbXRrX3ZyZWdfc2V0X2xwbShzdHJ1Y3QgdWZzX2hi
YSAqaGJhLCBib29sIGxwbSkNCiBzdGF0aWMgaW50IHVmc19tdGtfc3VzcGVuZChzdHJ1Y3QgdWZz
X2hiYSAqaGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCiB7DQogCWludCBlcnI7DQotCXN0cnVj
dCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCiANCiAJaWYg
KHVmc2hjZF9pc19saW5rX2hpYmVybjgoaGJhKSkgew0KIAkJZXJyID0gdWZzX210a19saW5rX3Nl
dF9scG0oaGJhKTsNCkBAIC01NTksMjAgKzU4MCwxMyBAQCBzdGF0aWMgaW50IHVmc19tdGtfc3Vz
cGVuZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCiAJCXVmc19t
dGtfdnJlZ19zZXRfbHBtKGhiYSwgdHJ1ZSk7DQogCX0NCiANCi0JaWYgKCF1ZnNoY2RfaXNfbGlu
a19hY3RpdmUoaGJhKSkNCi0JCXBoeV9wb3dlcl9vZmYoaG9zdC0+bXBoeSk7DQotDQogCXJldHVy
biAwOw0KIH0NCiANCiBzdGF0aWMgaW50IHVmc19tdGtfcmVzdW1lKHN0cnVjdCB1ZnNfaGJhICpo
YmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KIHsNCi0Jc3RydWN0IHVmc19tdGtfaG9zdCAqaG9z
dCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KIAlpbnQgZXJyOw0KIA0KLQlpZiAoIXVmc2hj
ZF9pc19saW5rX2FjdGl2ZShoYmEpKQ0KLQkJcGh5X3Bvd2VyX29uKGhvc3QtPm1waHkpOw0KLQ0K
IAlpZiAodWZzaGNkX2lzX2xpbmtfaGliZXJuOChoYmEpKSB7DQogCQl1ZnNfbXRrX3ZyZWdfc2V0
X2xwbShoYmEsIGZhbHNlKTsNCiAJCWVyciA9IHVmc19tdGtfbGlua19zZXRfaHBtKGhiYSk7DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaCBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmgNCmluZGV4IGZjNDJkY2JmZDgwMC4uNjA1MmVjMTA1YWJhIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KKysrIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuaA0KQEAgLTkxLDYgKzkxLDcgQEAgZW51bSB7DQogc3Ry
dWN0IHVmc19tdGtfaG9zdCB7DQogCXN0cnVjdCB1ZnNfaGJhICpoYmE7DQogCXN0cnVjdCBwaHkg
Km1waHk7DQorCWJvb2wgbXBoeV9wb3dlcmVkX29uOw0KIAlib29sIHVuaXByb19scG07DQogCWJv
b2wgcmVmX2Nsa19lbmFibGVkOw0KIAl1MTYgcmVmX2Nsa191bmdhdGluZ193YWl0X3VzOw0KLS0g
DQoyLjE4LjANCg==

