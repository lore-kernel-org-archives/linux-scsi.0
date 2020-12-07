Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CC2C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 15:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2357623730
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 15:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgLGPUH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 10:20:07 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:53451 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725774AbgLGPUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 10:20:07 -0500
X-UUID: 6394617866c64fdc98819fc37491bc20-20201207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=aoaUozPZYFeh+DdVsOxBemjKcHvZByKxlHNwVcy5zL8=;
        b=k8I9G05Cq6urz2ZYORowNzNchs0ZYd8Nmnu+6c7NdAkH13yKfPk3H5w8F5c6E0NtOQThH7gaBUqQlha+h77oYGffXBqLjNf/UQFT/8Fa5stT9sMK4/0UFOxmeEa+TSKg/rDa1bXxRsvIyVBUQjAFzeXswJKzx+HKRV/OvRQH4Aw=;
X-UUID: 6394617866c64fdc98819fc37491bc20-20201207
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1320254551; Mon, 07 Dec 2020 23:19:23 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 7 Dec 2020 23:19:19 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Dec 2020 23:19:19 +0800
Message-ID: <1607354362.3580.22.camel@mtkswgap22>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Mon, 7 Dec 2020 23:19:22 +0800
In-Reply-To: <1607319370.3580.8.camel@mtkswgap22>
References: <20201206101335.3418-1-huobean@gmail.com>
         <20201206101335.3418-3-huobean@gmail.com>
         <1607319370.3580.8.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIwLTEyLTA3IGF0IDEzOjM2ICswODAwLCBTdGFubGV5IENodSB3cm90ZToNCj4g
T24gU3VuLCAyMDIwLTEyLTA2IGF0IDExOjEzICswMTAwLCBCZWFuIEh1byB3cm90ZToNCj4gPiBG
cm9tOiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KPiA+IA0KPiA+IEFjY29yZGluZyB0
byB0aGUgSkVERUMgVUZTIDMuMSBTcGVjLCBJZiBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hEdXJp
bmdIaWJlcm5hdGUNCj4gPiBpcyBzZXQgdG8gb25lLCB0aGUgZGV2aWNlIGZsdXNoZXMgdGhlIFdy
aXRlQm9vc3RlciBCdWZmZXIgZGF0YSBhdXRvbWF0aWNhbGx5DQo+ID4gd2hlbmV2ZXIgdGhlIGxp
bmsgZW50ZXJzIHRoZSBoaWJlcm5hdGUgKEhJQkVSTjgpIHN0YXRlLiBXaGlsZSB0aGUgZmx1c2hp
bmcNCj4gPiBvcGVyYXRpb24gaXMgaW4gcHJvZ3Jlc3MsIHRoZSBkZXZpY2Ugc2hvdWxkIGJlIGtl
cHQgaW4gQWN0aXZlIHBvd2VyIG1vZGUuDQo+ID4gQ3VycmVudGx5LCB3ZSBzZXQgdGhpcyBmbGFn
IGR1cmluZyB0aGUgVUZTSENEIHByb2JlIHN0YWdlLCBidXQgd2UgZGlkbid0IGRlYWwNCj4gPiB3
aXRoIGl0cyBwcm9ncmFtbWluZyBmYWlsdXJlLiBFdmVuIHRoaXMgZmFpbHVyZSBpcyBsZXNzIGxp
a2VseSB0byBvY2N1ciwgYnV0DQo+ID4gc3RpbGwgaXQgaXMgcG9zc2libGUuDQo+ID4gVGhpcyBw
YXRjaCBpcyB0byBhZGQgY2hlY2t1cCBvZiBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hEdXJpbmdI
aWJlcm5hdGUgc2V0dGluZywNCj4gPiBrZWVwIHRoZSBkZXZpY2UgYXMgImFjdGl2ZSBwb3dlciBt
b2RlIiBvbmx5IHdoZW4gdGhpcyBmbGFnIGJlIHN1Y2Nlc3NmdWxseSBzZXQNCj4gPiB0byAxLg0K
PiA+IA0KPiA+IEZpeGVzOiA1MWRkOTA1YmQyZjYgKCJzY3NpOiB1ZnM6IEZpeCBXcml0ZUJvb3N0
ZXIgZmx1c2ggZHVyaW5nIHJ1bnRpbWUgc3VzcGVuZCIpDQo+ID4gU2lnbmVkLW9mZi1ieTogQmVh
biBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9zY3NpL3Vm
cy91ZnMuaCAgICB8ICAyICsrDQo+ID4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAyMCAr
KysrKysrKysrKysrKystLS0tLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDE3IGluc2VydGlvbnMo
KyksIDUgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91
ZnMvdWZzLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oDQo+ID4gaW5kZXggZDU5M2VkYjQ4NzY3
Li4zMTFkNWY3YTAyNGQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMuaA0K
PiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLmgNCj4gPiBAQCAtNTMwLDYgKzUzMCw4IEBA
IHN0cnVjdCB1ZnNfZGV2X2luZm8gew0KPiA+ICAJYm9vbCBmX3Bvd2VyX29uX3dwX2VuOw0KPiA+
ICAJLyogS2VlcHMgaW5mb3JtYXRpb24gaWYgYW55IG9mIHRoZSBMVSBpcyBwb3dlciBvbiB3cml0
ZSBwcm90ZWN0ZWQgKi8NCj4gPiAgCWJvb2wgaXNfbHVfcG93ZXJfb25fd3A7DQo+ID4gKwkvKiBJ
bmRpY2F0ZXMgaWYgZmx1c2ggV0IgYnVmZmVyIGR1cmluZyBoaWJlcm44IHN1Y2Nlc3NmdWxseSBl
bmFibGVkICovDQo+ID4gKwlib29sIGlzX2hpYmVybjhfd2JfZmx1c2g7DQo+IA0KPiBQZXJoYXBz
IGEgbW9yZSBjb21wcmVoZW5zaXZlIG5hbWU/DQo+IEZvciBleGFtcGxlLCB3Yl9mbHVzaF9kdXJp
bmdfaGliZXJuOD8NCj4gPiAgCS8qIE1heGltdW0gbnVtYmVyIG9mIGdlbmVyYWwgTFUgc3VwcG9y
dGVkIGJ5IHRoZSBVRlMgZGV2aWNlICovDQo+ID4gIAl1OCBtYXhfbHVfc3VwcG9ydGVkOw0KPiA+
ICAJdTggd2JfZGVkaWNhdGVkX2x1Ow0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+IGluZGV4IDMwMzMyNTky
ZTYyNC4uZGEzOGQ3NjA5NDRiIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gQEAgLTI4NSwx
MCArMjg1LDE2IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB1ZnNoY2Rfd2JfY29uZmlnKHN0cnVjdCB1
ZnNfaGJhICpoYmEpDQo+ID4gIAkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBFbmFibGUgV0IgZmFp
bGVkOiAlZFxuIiwgX19mdW5jX18sIHJldCk7DQo+ID4gIAllbHNlDQo+ID4gIAkJZGV2X2luZm8o
aGJhLT5kZXYsICIlczogV3JpdGUgQm9vc3RlciBDb25maWd1cmVkXG4iLCBfX2Z1bmNfXyk7DQo+
ID4gKw0KPiA+ICAJcmV0ID0gdWZzaGNkX3diX3RvZ2dsZV9mbHVzaF9kdXJpbmdfaDgoaGJhLCB0
cnVlKTsNCj4gPiAtCWlmIChyZXQpDQo+ID4gKwlpZiAocmV0KSB7DQo+ID4gIAkJZGV2X2Vyciho
YmEtPmRldiwgIiVzOiBFbiBXQiBmbHVzaCBkdXJpbmcgSDg6IGZhaWxlZDogJWRcbiIsDQo+ID4g
IAkJCV9fZnVuY19fLCByZXQpOw0KPiA+ICsJCWhiYS0+ZGV2X2luZm8uaXNfaGliZXJuOF93Yl9m
bHVzaCA9IGZhbHNlOw0KPiANCj4gUGVyaGFwcyB0aGlzIHN0YXRlbWVudCBjb3VsZCBiZSBkdW1t
eSBiZWNhdXNlDQo+IGhiYS0+ZGV2X2luZm8uaXNfaGliZXJuOF93Yl9mbHVzaCBpcyB6ZXJvLWlu
aXRpYWxpemVkIGFuZA0KPiB1ZnNoY2Rfd2JfY29uZmlnKCkgaXMgaW52b2tlZCBvbmx5IG9uY2Ug
ZHVyaW5nIHVmcyBpbml0aWFsaXphdGlvbi4NCg0KSGkgQmVhbiwNClNvcnJ5IHRvIG1pc2xlYWQg
eW91LiB1ZnNoY2Rfd2JfY29uZmlnKCkgbWF5IGJlIGNhbGxlZCBtdWx0aXBsZSB0aW1lcyBieQ0K
Ym90aCBpbml0aWFsaXphdGlvbiBhbmQgZXJyb3IgcmVjb3ZlcnkuIFBsZWFzZSBpZ25vcmUgYWJv
dmUgc3VnZ2VzdGlvbi4NCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0KPiANCj4gVGhhbmtzLA0K
PiBTdGFubGV5IENodQ0KPiANCj4gPiArCX0gZWxzZSB7DQo+ID4gKwkJaGJhLT5kZXZfaW5mby5p
c19oaWJlcm44X3diX2ZsdXNoID0gdHJ1ZTsNCj4gPiArCX0NCj4gPiArDQo+ID4gIAl1ZnNoY2Rf
d2JfdG9nZ2xlX2ZsdXNoKGhiYSwgdHJ1ZSk7DQo+ID4gIH0NCj4gPiAgDQo+ID4gQEAgLTU0NDgs
NiArNTQ1NCw3IEBAIHN0YXRpYyBib29sIHVmc2hjZF93Yl9uZWVkX2ZsdXNoKHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQo+ID4gIA0KPiA+ICAJaWYgKCF1ZnNoY2RfaXNfd2JfYWxsb3dlZChoYmEpKQ0K
PiA+ICAJCXJldHVybiBmYWxzZTsNCj4gPiArDQo+ID4gIAkvKg0KPiA+ICAJICogVGhlIHVmcyBk
ZXZpY2UgbmVlZHMgdGhlIHZjYyB0byBiZSBPTiB0byBmbHVzaC4NCj4gPiAgCSAqIFdpdGggdXNl
ci1zcGFjZSByZWR1Y3Rpb24gZW5hYmxlZCwgaXQncyBlbm91Z2ggdG8gZW5hYmxlIGZsdXNoDQo+
ID4gQEAgLTg1NDAsNiArODU0Nyw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3N1c3BlbmQoc3RydWN0
IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQo+ID4gIAllbnVtIHVmc19wbV9s
ZXZlbCBwbV9sdmw7DQo+ID4gIAllbnVtIHVmc19kZXZfcHdyX21vZGUgcmVxX2Rldl9wd3JfbW9k
ZTsNCj4gPiAgCWVudW0gdWljX2xpbmtfc3RhdGUgcmVxX2xpbmtfc3RhdGU7DQo+ID4gKwlib29s
IGhpYmVybjg7DQo+ID4gIA0KPiA+ICAJaGJhLT5wbV9vcF9pbl9wcm9ncmVzcyA9IDE7DQo+ID4g
IAlpZiAoIXVmc2hjZF9pc19zaHV0ZG93bl9wbShwbV9vcCkpIHsNCj4gPiBAQCAtODU5OSwxMSAr
ODYwNywxMyBAQCBzdGF0aWMgaW50IHVmc2hjZF9zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEs
IGVudW0gdWZzX3BtX29wIHBtX29wKQ0KPiA+ICAJCSAqIEhpYmVybjgsIGtlZXAgZGV2aWNlIHBv
d2VyIG1vZGUgYXMgImFjdGl2ZSBwb3dlciBtb2RlIg0KPiA+ICAJCSAqIGFuZCBWQ0Mgc3VwcGx5
Lg0KPiA+ICAJCSAqLw0KPiA+ICsJCWhpYmVybjggPSByZXFfbGlua19zdGF0ZSA9PSBVSUNfTElO
S19ISUJFUk44X1NUQVRFIHx8DQo+ID4gKwkJCShyZXFfbGlua19zdGF0ZSA9PSBVSUNfTElOS19B
Q1RJVkVfU1RBVEUgJiYNCj4gPiArCQkJIHVmc2hjZF9pc19hdXRvX2hpYmVybjhfZW5hYmxlZCho
YmEpKTsNCj4gPiArDQo+ID4gIAkJaGJhLT5kZXZfaW5mby5iX3JwbV9kZXZfZmx1c2hfY2FwYWJs
ZSA9DQo+ID4gLQkJCWhiYS0+YXV0b19ia29wc19lbmFibGVkIHx8DQo+ID4gLQkJCSgoKHJlcV9s
aW5rX3N0YXRlID09IFVJQ19MSU5LX0hJQkVSTjhfU1RBVEUpIHx8DQo+ID4gLQkJCSgocmVxX2xp
bmtfc3RhdGUgPT0gVUlDX0xJTktfQUNUSVZFX1NUQVRFKSAmJg0KPiA+IC0JCQl1ZnNoY2RfaXNf
YXV0b19oaWJlcm44X2VuYWJsZWQoaGJhKSkpICYmDQo+ID4gKwkJCWhiYS0+YXV0b19ia29wc19l
bmFibGVkIHx8IChoaWJlcm44ICYmDQo+ID4gKwkJCWhiYS0+ZGV2X2luZm8uaXNfaGliZXJuOF93
Yl9mbHVzaCAmJg0KPiA+ICAJCQl1ZnNoY2Rfd2JfbmVlZF9mbHVzaChoYmEpKTsNCj4gPiAgCX0N
Cj4gPiAgDQo+IA0KDQo=

