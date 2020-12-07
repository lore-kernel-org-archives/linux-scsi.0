Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411E4C4167B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 06:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A7A229EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 06:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgLGGzq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 01:55:46 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:55245 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725850AbgLGGzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 01:55:46 -0500
X-UUID: b8984c2ca2db482e8d14fa9d8a8b4769-20201207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=tCM7HDi7ctlJbsuslTTZAB1IgoEd9op1EUTLyOivdzg=;
        b=tBA2Z+Y0R3cYgG6YJhddmo+TaZpz42VFjYbFxPbBHctFnbxNd6453Z3EpYIqx2yTBGxFw9A0cTffDcn+acBROlWMca91EHS/l+QqvMrTiJLqY76OOIT1eDLyHil/0wrihozAqcU3GzappS47CPnnGCS83LICP/NfinhVxaNU0yk=;
X-UUID: b8984c2ca2db482e8d14fa9d8a8b4769-20201207
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1989961055; Mon, 07 Dec 2020 14:55:01 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 7 Dec 2020 14:54:59 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Dec 2020 14:54:58 +0800
Message-ID: <1607324100.3580.10.camel@mtkswgap22>
Subject: Re: [PATCH v2 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Mon, 7 Dec 2020 14:55:00 +0800
In-Reply-To: <20201206101335.3418-2-huobean@gmail.com>
References: <20201206101335.3418-1-huobean@gmail.com>
         <20201206101335.3418-2-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gU3VuLCAyMDIwLTEyLTA2IGF0IDExOjEzICswMTAwLCBCZWFuIEh1byB3cm90ZToNCj4gRnJv
bTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IEN1cnJlbnRseSBVRlMgV3Jp
dGVCb29zdGVyIGRyaXZlciB1c2VzIGNsb2NrIHNjYWxpbmcgdXAvZG93biB0byBzZXQNCj4gV0Ig
b24vb2ZmLCBmb3IgdGhlIHBsYXRmb3JtIHdoaWNoIGRvZXNuJ3Qgc3VwcG9ydCBVRlNIQ0RfQ0FQ
X0NMS19TQ0FMSU5HLA0KPiBXQiB3aWxsIGJlIGFsd2F5cyBvbi4gUHJvdmlkZSBhIHN5c2ZzIGF0
dHJpYnV0ZSB0byBlbmFibGUvZGlzYWJsZSBXQg0KPiBkdXJpbmcgcnVudGltZS4gV3JpdGUgMS8w
IHRvICJ3Yl9vbiIgc3lzZnMgbm9kZSB0byBlbmFibGUvZGlzYWJsZSBVRlMgV0IuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KPiAtLS0NCj4gIGRy
aXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMgfCA0MCArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgfCAgMyArLS0NCj4g
IGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAgfCAgMiArKw0KPiAgMyBmaWxlcyBjaGFuZ2Vk
LCA0MyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5j
DQo+IGluZGV4IDA4ZTcyYjdlZWY2YS4uYjNiZjdmY2EwMGU1IDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXN5
c2ZzLmMNCj4gQEAgLTE4OSw2ICsxODksNDQgQEAgc3RhdGljIHNzaXplX3QgYXV0b19oaWJlcm44
X3N0b3JlKHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gIAlyZXR1cm4gY291bnQ7DQo+ICB9DQo+ICAN
Cj4gK3N0YXRpYyBzc2l6ZV90IHdiX29uX3Nob3coc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3Qg
ZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwNCj4gKwkJCSAgY2hhciAqYnVmKQ0KPiArew0KPiArCXN0
cnVjdCB1ZnNfaGJhICpoYmEgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gKw0KPiArCXJldHVy
biBzY25wcmludGYoYnVmLCBQQUdFX1NJWkUsICIlZFxuIiwgaGJhLT53Yl9lbmFibGVkKTsNCj4g
K30NCj4gKw0KPiArc3RhdGljIHNzaXplX3Qgd2Jfb25fc3RvcmUoc3RydWN0IGRldmljZSAqZGV2
LCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwNCj4gKwkJCSAgIGNvbnN0IGNoYXIgKmJ1
Ziwgc2l6ZV90IGNvdW50KQ0KPiArew0KPiArCXN0cnVjdCB1ZnNfaGJhICpoYmEgPSBkZXZfZ2V0
X2RydmRhdGEoZGV2KTsNCj4gKwl1bnNpZ25lZCBpbnQgd2JfZW5hYmxlOw0KPiArCXNzaXplX3Qg
cmVzOw0KPiArDQo+ICsJaWYgKHVmc2hjZF9pc19jbGtzY2FsaW5nX3N1cHBvcnRlZChoYmEpKSB7
DQo+ICsJCS8qIElmIHRoZSBwbGF0Zm9ybSBzdXBwb3J0cyBVRlNIQ0RfQ0FQX0FVVE9fQktPUFNf
U1VTUEVORCwgdHVybg0KPiArCQkgKiBXQiBvbi9vZmYgd2lsbCBiZSBkb25lIHdoaWxlIGNsb2Nr
IHNjYWxpbmcgdXAvZG93bi4NCj4gKwkJICovDQo+ICsJCWRldl93YXJuKGRldiwgIlRvIGNvbnRy
b2wgV0IgdGhyb3VnaCB3Yl9vbiBpcyBub3QgYWxsb3dlZCFcbiIpOw0KPiArCQlyZXR1cm4gLUVP
UE5PVFNVUFA7DQo+ICsJfQ0KDQpQZXJoYXBzIHdiX29uIHNoYWxsIG92ZXJyaWRlIGNsa3NjYWxp
bmcgY29udHJvbC4gQnV0IHRoaXMgY291bGQgYmUNCmZ1dHVyZSB3b3JrLg0KDQpSZXZpZXdlZC1i
eTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0KPiArCWlmICghdWZz
aGNkX2lzX3diX2FsbG93ZWQoaGJhKSkNCj4gKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiArDQo+
ICsJaWYgKGtzdHJ0b3VpbnQoYnVmLCAwLCAmd2JfZW5hYmxlKSkNCj4gKwkJcmV0dXJuIC1FSU5W
QUw7DQo+ICsNCj4gKwlpZiAod2JfZW5hYmxlICE9IDAgJiYgd2JfZW5hYmxlICE9IDEpDQo+ICsJ
CXJldHVybiAtRUlOVkFMOw0KPiArDQo+ICsJcG1fcnVudGltZV9nZXRfc3luYyhoYmEtPmRldik7
DQo+ICsJcmVzID0gdWZzaGNkX3diX2N0cmwoaGJhLCB3Yl9lbmFibGUpOw0KPiArCXBtX3J1bnRp
bWVfcHV0X3N5bmMoaGJhLT5kZXYpOw0KPiArDQo+ICsJcmV0dXJuIHJlcyA8IDAgPyByZXMgOiBj
b3VudDsNCj4gK30NCj4gKw0KPiAgc3RhdGljIERFVklDRV9BVFRSX1JXKHJwbV9sdmwpOw0KPiAg
c3RhdGljIERFVklDRV9BVFRSX1JPKHJwbV90YXJnZXRfZGV2X3N0YXRlKTsNCj4gIHN0YXRpYyBE
RVZJQ0VfQVRUUl9STyhycG1fdGFyZ2V0X2xpbmtfc3RhdGUpOw0KPiBAQCAtMTk2LDYgKzIzNCw3
IEBAIHN0YXRpYyBERVZJQ0VfQVRUUl9SVyhzcG1fbHZsKTsNCj4gIHN0YXRpYyBERVZJQ0VfQVRU
Ul9STyhzcG1fdGFyZ2V0X2Rldl9zdGF0ZSk7DQo+ICBzdGF0aWMgREVWSUNFX0FUVFJfUk8oc3Bt
X3RhcmdldF9saW5rX3N0YXRlKTsNCj4gIHN0YXRpYyBERVZJQ0VfQVRUUl9SVyhhdXRvX2hpYmVy
bjgpOw0KPiArc3RhdGljIERFVklDRV9BVFRSX1JXKHdiX29uKTsNCj4gIA0KPiAgc3RhdGljIHN0
cnVjdCBhdHRyaWJ1dGUgKnVmc19zeXNmc191ZnNoY2RfYXR0cnNbXSA9IHsNCj4gIAkmZGV2X2F0
dHJfcnBtX2x2bC5hdHRyLA0KPiBAQCAtMjA1LDYgKzI0NCw3IEBAIHN0YXRpYyBzdHJ1Y3QgYXR0
cmlidXRlICp1ZnNfc3lzZnNfdWZzaGNkX2F0dHJzW10gPSB7DQo+ICAJJmRldl9hdHRyX3NwbV90
YXJnZXRfZGV2X3N0YXRlLmF0dHIsDQo+ICAJJmRldl9hdHRyX3NwbV90YXJnZXRfbGlua19zdGF0
ZS5hdHRyLA0KPiAgCSZkZXZfYXR0cl9hdXRvX2hpYmVybjguYXR0ciwNCj4gKwkmZGV2X2F0dHJf
d2Jfb24uYXR0ciwNCj4gIAlOVUxMDQo+ICB9Ow0KPiAgDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBpbmRleCA5
MmQ0MzNkNWYzY2EuLjMwMzMyNTkyZTYyNCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IEBAIC0yNDcs
NyArMjQ3LDYgQEAgc3RhdGljIGlubGluZSBpbnQgdWZzaGNkX2NvbmZpZ192cmVnX2hwbShzdHJ1
Y3QgdWZzX2hiYSAqaGJhLA0KPiAgc3RhdGljIGludCB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2so
c3RydWN0IHVmc19oYmEgKmhiYSwgaW50IHRhZyk7DQo+ICBzdGF0aWMgaW50IHVmc2hjZF93Yl9i
dWZfZmx1c2hfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KPiAgc3RhdGljIGludCB1ZnNo
Y2Rfd2JfYnVmX2ZsdXNoX2Rpc2FibGUoc3RydWN0IHVmc19oYmEgKmhiYSk7DQo+IC1zdGF0aWMg
aW50IHVmc2hjZF93Yl9jdHJsKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgZW5hYmxlKTsNCj4g
IHN0YXRpYyBpbnQgdWZzaGNkX3diX3RvZ2dsZV9mbHVzaF9kdXJpbmdfaDgoc3RydWN0IHVmc19o
YmEgKmhiYSwgYm9vbCBzZXQpOw0KPiAgc3RhdGljIGlubGluZSB2b2lkIHVmc2hjZF93Yl90b2dn
bGVfZmx1c2goc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpOw0KPiAgc3RhdGljIHZv
aWQgdWZzaGNkX2hiYV92cmVnX3NldF9scG0oc3RydWN0IHVmc19oYmEgKmhiYSk7DQo+IEBAIC01
MzA3LDcgKzUzMDYsNyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2RfYmtvcHNfZXhjZXB0aW9uX2V2ZW50
X2hhbmRsZXIoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIAkJCQlfX2Z1bmNfXywgZXJyKTsNCj4g
IH0NCj4gIA0KPiAtc3RhdGljIGludCB1ZnNoY2Rfd2JfY3RybChzdHJ1Y3QgdWZzX2hiYSAqaGJh
LCBib29sIGVuYWJsZSkNCj4gK2ludCB1ZnNoY2Rfd2JfY3RybChzdHJ1Y3QgdWZzX2hiYSAqaGJh
LCBib29sIGVuYWJsZSkNCj4gIHsNCj4gIAlpbnQgcmV0Ow0KPiAgCXU4IGluZGV4Ow0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmgNCj4gaW5kZXggNjEzNDRjNDljMmNjLi5jNjE1ODRkZmY3NGEgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuaA0KPiBAQCAtMTA2OCw2ICsxMDY4LDggQEAgaW50IHVmc2hjZF9leGVjX3Jhd191cGl1X2Nt
ZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiAgCQkJICAgICB1OCAqZGVzY19idWZmLCBpbnQgKmJ1
ZmZfbGVuLA0KPiAgCQkJICAgICBlbnVtIHF1ZXJ5X29wY29kZSBkZXNjX29wKTsNCj4gIA0KPiAr
aW50IHVmc2hjZF93Yl9jdHJsKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgZW5hYmxlKTsNCj4g
Kw0KPiAgLyogV3JhcHBlciBmdW5jdGlvbnMgZm9yIHNhZmVseSBjYWxsaW5nIHZhcmlhbnQgb3Bl
cmF0aW9ucyAqLw0KPiAgc3RhdGljIGlubGluZSBjb25zdCBjaGFyICp1ZnNoY2RfZ2V0X3Zhcl9u
YW1lKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICB7DQoNCg==

