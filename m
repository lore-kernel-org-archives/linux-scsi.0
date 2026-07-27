Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2492045AD;
	Mon, 27 Jul 2026 02:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785119366; cv=none; b=rZXdeNktGHzecy9aRJerNA0IQ22dTodVVtscn1eunk9c5VUgmvBa8pDq0ti66BHdocHmiy2ZluEw//f4h1gcDDCnX6vfJKULecTx6lUN8KpnA0V12Uw3Zkt8ZVG7atuj8+C/INLc+uQXdnFSLgeBofqMAfHMBL2TZexD60PJUx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785119366; c=relaxed/simple;
	bh=Yco4+b4Ze7gQHnz5efaD+TnEyHC0E3bK8O+6HoMelrM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MdxDHEnQB0urEIplJ+1XT9ULgLtFJ6yJmYox80Sto5I+pcnnk9Jqtm1DbotP8gif7DoMauaEGqMwpVo0eZ2/FcboqVMvHTMHEzcoTCqJdf8EGaQzec2hkiJ7WwO4MzLzHOyd5etnyLg/mT3ynsM9yzb9li6eZ5diKl3MxV0pe5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from spam.asrmicro.com (localhost [127.0.0.2] (may be forged))
	by spam.asrmicro.com with ESMTP id 66R28cWQ038879;
	Mon, 27 Jul 2026 10:08:38 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch03.asrmicro.com (exch03.asrmicro.com [10.1.24.118])
	by spam.asrmicro.com with ESMTPS id 66R27am8038585
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 10:07:36 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch03.asrmicro.com
 (10.1.24.118) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 27 Jul
 2026 10:07:38 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.1497.048; Mon, 27 Jul 2026 10:07:37 +0800
From: =?utf-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= <hongjiefang@asrmicro.com>
To: Bart Van Assche <bvanassche@acm.org>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "jgarzik@redhat.com" <jgarzik@redhat.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] scsi: core: pair EH runtime PM get and put
Thread-Topic: [PATCH v1] scsi: core: pair EH runtime PM get and put
Thread-Index: AQHdG7HzKcW1bjCzP0+DGU4Mn6/df7aAoT0w
Date: Mon, 27 Jul 2026 02:07:37 +0000
Message-ID: <3dab88746c6a445e9b134a71fb93b418@exch02.asrmicro.com>
References: <20260623074408.1639663-1-hongjiefang@asrmicro.com>
 <90a7222e-6779-485c-80d1-e4b814a9ac23@acm.org>
In-Reply-To: <90a7222e-6779-485c-80d1-e4b814a9ac23@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 66R28cWQ038879

DQoNCj4gPiBAQCAtMjM4MywxMiArMjM4NCwxNiBAQCBpbnQgc2NzaV9lcnJvcl9oYW5kbGVyKHZv
aWQgKmRhdGEpDQo+ID4gICAJCSAqIHdoYXQgd2UgbmVlZCB0byBkbyB0byBnZXQgaXQgdXAgYW5k
IG9ubGluZSBhZ2FpbiAoaWYgd2UNCj4gY2FuKS4NCj4gPiAgIAkJICogSWYgd2UgZmFpbCwgd2Ug
ZW5kIHVwIHRha2luZyB0aGUgdGhpbmcgb2ZmbGluZS4NCj4gPiAgIAkJICovDQo+ID4gLQkJaWYg
KCFzaG9zdC0+ZWhfbm9yZXN1bWUgJiYNCj4gc2NzaV9hdXRvcG1fZ2V0X2hvc3Qoc2hvc3QpICE9
IDApIHsNCj4gPiAtCQkJU0NTSV9MT0dfRVJST1JfUkVDT1ZFUlkoMSwNCj4gPiAtCQkJCXNob3N0
X3ByaW50ayhLRVJOX0VSUiwgc2hvc3QsDQo+ID4gLQkJCQkJICAgICAic2NzaV9laF8lZDogdW5h
YmxlIHRvDQo+IGF1dG9yZXN1bWVcbiIsDQo+ID4gLQkJCQkJICAgICBzaG9zdC0+aG9zdF9ubykp
Ow0KPiA+IC0JCQljb250aW51ZTsNCj4gPiArCQlhdXRvcG1fcHV0ID0gZmFsc2U7DQo+ID4gKwkJ
aWYgKCFzaG9zdC0+ZWhfbm9yZXN1bWUpIHsNCj4gPiArCQkJaWYgKHNjc2lfYXV0b3BtX2dldF9o
b3N0KHNob3N0KSAhPSAwKSB7DQo+ID4gKwkJCQlTQ1NJX0xPR19FUlJPUl9SRUNPVkVSWSgxLA0K
PiA+ICsJCQkJCXNob3N0X3ByaW50ayhLRVJOX0VSUiwgc2hvc3QsDQo+ID4gKwkJCQkJCSAgICAg
InNjc2lfZWhfJWQ6IHVuYWJsZSB0bw0KPiBhdXRvcmVzdW1lXG4iLA0KPiA+ICsJCQkJCQkgICAg
IHNob3N0LT5ob3N0X25vKSk7DQo+ID4gKwkJCQljb250aW51ZTsNCj4gPiArCQkJfQ0KPiA+ICsJ
CQlhdXRvcG1fcHV0ID0gdHJ1ZTsNCj4gPiAgIAkJfQ0KPiA+DQo+ID4gICAJCWlmIChzaG9zdC0+
dHJhbnNwb3J0dC0+ZWhfc3RyYXRlZ3lfaGFuZGxlcikNCj4gPiBAQCAtMjQwNyw3ICsyNDEyLDcg
QEAgaW50IHNjc2lfZXJyb3JfaGFuZGxlcih2b2lkICpkYXRhKQ0KPiA+ICAgCQkgKiB3aGljaCBh
cmUgc3RpbGwgb25saW5lLg0KPiA+ICAgCQkgKi8NCj4gPiAgIAkJc2NzaV9yZXN0YXJ0X29wZXJh
dGlvbnMoc2hvc3QpOw0KPiA+IC0JCWlmICghc2hvc3QtPmVoX25vcmVzdW1lKQ0KPiA+ICsJCWlm
IChhdXRvcG1fcHV0KQ0KPiA+ICAgCQkJc2NzaV9hdXRvcG1fcHV0X2hvc3Qoc2hvc3QpOw0KPiA+
ICAgCX0NCj4gPiAgIAlfX3NldF9jdXJyZW50X3N0YXRlKFRBU0tfUlVOTklORyk7DQo+IA0KPiBQ
bGVhc2UgY2FwdHVyZSB0aGUgdmFsdWUgb2Ygc2hvc3QtPmVoX25vcmVzdW1lIGluIGEgbG9jYWwg
dmFyaWFibGUgc3VjaA0KPiB0aGF0IGNvbmN1cnJlbnQgY2hhbmdlcyBvZiBzaG9zdC0+ZWhfbm9y
ZXN1bWUgY2FuJ3QgYnJlYWsgdGhlIGFib3ZlDQo+IGNvZGUuDQoNCg0KVGhhbmtzIEJhcnQuIEkg
d2lsbCB1cGRhdGUgdGhlIHBhdGNoIHRvIHNuYXBzaG90IHNob3N0LT5laF9ub3Jlc3VtZSBvbmNl
DQpwZXIgRUggaXRlcmF0aW9uIGFuZCB1c2UgdGhhdCB2YWx1ZSBmb3IgYm90aCB0aGUgZ2V0IGFu
ZCBwdXQgZGVjaXNpb25zLg0KDQoNCj4NCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
