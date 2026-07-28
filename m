Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4392175A7B;
	Tue, 28 Jul 2026 02:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785205417; cv=none; b=EpnQpONb3DJUYH1NI2r/ifKDFfQ5yFnLjHarMMl/LSyMkQhtiSjHVZ/HQDHZu7kGL/KJX8hjNk9s4uUsscbKEK9mbm5cJt1sUiSNQ3q8S+XKjbDNUaKmyVIg39IeWa/KgKNf0P05bJRv+Xx78nxoXATM0RIaSMBF4jan/ZsiOuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785205417; c=relaxed/simple;
	bh=xK/gYuK34dzIUzLTFuvib/gDIK0cV46Frd+w8t03zSU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YaldL4CZUX3GyRkTqVsmbdk6NPEM66lqCdRMWh/qJUdEvDo3uhWCJBbWRp//NxX2ORBlmYt92eicRqOv1Y3qjyE8tsS2Tp0HCajN89vHO2FHU1dt0YxWNKkIayjo4gonHIrPku8XLvxN1O5B5yOQ7XczsT+w4OEZByEfK4pf+jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from mail2012.asrmicro.com (mail2012.asrmicro.com [10.1.24.123])
	by spam.asrmicro.com with ESMTPS id 66S2MQpr004540
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=FAIL);
	Tue, 28 Jul 2026 10:22:36 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by mail2012.asrmicro.com
 (10.1.24.123) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 28 Jul
 2026 10:22:30 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.1497.048; Tue, 28 Jul 2026 10:22:30 +0800
From: =?gb2312?B?RmFuZyBIb25namllKLe9uum93Ck=?= <hongjiefang@asrmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "jgarzik@redhat.com" <jgarzik@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: core: pair EH runtime PM get and put
Thread-Topic: [PATCH v2] scsi: core: pair EH runtime PM get and put
Thread-Index: AQHdHdHLYPr4wHszakOb4onzbjUOYraCMo3w
Date: Tue, 28 Jul 2026 02:22:29 +0000
Message-ID: <f66bc8e5bf88459083e36fa508a7f4f7@exch02.asrmicro.com>
References: <20260727055615.2287217-1-hongjiefang@asrmicro.com>
 <a432da46-7b3e-46a8-8c6d-1269d51b44b8@rowland.harvard.edu>
In-Reply-To: <a432da46-7b3e-46a8-8c6d-1269d51b44b8@rowland.harvard.edu>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 66S2MQpr004540

PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2NzaV9lcnJvci5jIGIvZHJpdmVycy9zY3Np
L3Njc2lfZXJyb3IuYw0KPiA+IGluZGV4IDE0NzEyN2ZiNGRiOS4uYTIxNmY1NjA0NGQ5IDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX2Vycm9yLmMNCj4gPiArKysgYi9kcml2ZXJz
L3Njc2kvc2NzaV9lcnJvci5jDQo+ID4gQEAgLTIzNDIsNiArMjM0Miw3IEBAIHN0YXRpYyB2b2lk
IHNjc2lfdW5qYW1faG9zdChzdHJ1Y3QgU2NzaV9Ib3N0DQo+ICpzaG9zdCkNCj4gPiAgaW50IHNj
c2lfZXJyb3JfaGFuZGxlcih2b2lkICpkYXRhKQ0KPiA+ICB7DQo+ID4gIAlzdHJ1Y3QgU2NzaV9I
b3N0ICpzaG9zdCA9IGRhdGE7DQo+ID4gKwlib29sIGVoX25vcmVzdW1lOw0KPiA+DQo+ID4gIAkv
Kg0KPiA+ICAJICogV2UgdXNlIFRBU0tfSU5URVJSVVBUSUJMRSBzbyB0aGF0IHRoZSB0aHJlYWQg
aXMgbm90DQo+ID4gQEAgLTIzODMsNyArMjM4NCw4IEBAIGludCBzY3NpX2Vycm9yX2hhbmRsZXIo
dm9pZCAqZGF0YSkNCj4gPiAgCQkgKiB3aGF0IHdlIG5lZWQgdG8gZG8gdG8gZ2V0IGl0IHVwIGFu
ZCBvbmxpbmUgYWdhaW4gKGlmIHdlDQo+IGNhbikuDQo+ID4gIAkJICogSWYgd2UgZmFpbCwgd2Ug
ZW5kIHVwIHRha2luZyB0aGUgdGhpbmcgb2ZmbGluZS4NCj4gPiAgCQkgKi8NCj4gPiAtCQlpZiAo
IXNob3N0LT5laF9ub3Jlc3VtZSAmJg0KPiBzY3NpX2F1dG9wbV9nZXRfaG9zdChzaG9zdCkgIT0g
MCkgew0KPiA+ICsJCWVoX25vcmVzdW1lID0gc2hvc3QtPmVoX25vcmVzdW1lOw0KPiANCj4gWW91
IHNob3VsZCBiZSBhd2FyZSB0aGF0IHNpbXBseSByZWFkaW5nIGEgdmFyaWFibGUgZG9lcyBub3Qg
c25hcHNob3QgaXRzDQo+IHZhbHVlIHVubGVzcyB0aGUgcmVhZCBpcyBwcm90ZWN0ZWQgYnkgYSBs
b2NrIG9yIHNvbWV0aGluZyBlbHNlLiAgSW4gdGhpcw0KPiBjYXNlLCB0aGUgY29tcGlsZXIgaXMg
YWxsb3dlZCB0byBlbGltaW5hdGUgdGhlIGVoX25vcmVzdW1lIHZhcmlhYmxlIGFuZA0KPiB1c2Ug
c2hvc3QtPmVoX25vcmVzdW1lIGluc3RlYWQsIGJvdGggaGVyZSBhbmQgYmVsb3csIHVuZGVyIHRo
ZQ0KPiBhc3N1bXB0aW9uIHRoYXQgc2hvc3QtPmVoX25vcmVzdW1lIGRvZXNuJ3QgY2hhbmdlIGlu
IHRoZSBtZWFudGltZS4NCj4gDQo+IFRvIHRydWx5IHNuYXBzaG90IHRoZSB0aGUgdmFsdWUgaW4g
YSB3YXkgdGhhdCdzIGltbXVuZSB0byBjaGFuZ2VzIGZyb20NCj4gb3RoZXIgdGhyZWFkcywgeW91
IGhhdmUgdG8gdXNlIFJFQURfT05DRSgpOg0KPiANCj4gCQllaF9ub3Jlc3VtZSA9IFJFQURfT05D
RShzaG9zdC0+ZWhfbm9yZXN1bWUpOw0KPiANCj4gVGhlIGNvbXBpbGVyIGlzIHRoZW4gbm90IGFs
bG93ZWQgdG8gYXNzdW1lIHRoYXQgc2hvc3QtPmVoX25vcmVzdW1lDQo+IHJlbWFpbnMgdW5jaGFu
Z2VkIGxhdGVyIG9uLiAgVGhpcyBpcyBhbGwgZXhwbGFpbmVkIChhbG9uZyB3aXRoIGEgX2xvdF8N
Cj4gb2Ygb3RoZXIgbWF0ZXJpYWwgLS0gc2VhcmNoIGZvciAiUkVBRF9PTkNFIikgaW4NCj4gRG9j
dW1lbnRhdGlvbi9tZW1vcnktYmFycmllcnMudHh0Lg0KPg0KDQpUaGFua3MgQWxhbi4NCkkgYWdy
ZWUgdGhhdCBhIHBsYWluIGxvY2FsIHZhcmlhYmxlIGlzIG5vdCBlbm91Z2ggZm9yIGEgY29tcGls
ZXItbGV2ZWwNCnNuYXBzaG90Lg0KVGhlcmUgaXMgb25lIGV4dHJhIGRldGFpbCBoZXJlOiBzaG9z
dC0+ZWhfbm9yZXN1bWUgaXMgY3VycmVudGx5IGENCmJpdGZpZWxkOg0KICAgICAgICB1bnNpZ25l
ZCBlaF9ub3Jlc3VtZToxOw0Kc28gUkVBRF9PTkNFKHNob3N0LT5laF9ub3Jlc3VtZSkgY2Fubm90
IGJlIHVzZWQgZGlyZWN0bHkgYmVjYXVzZQ0KUkVBRF9PTkNFKCkgdGFrZXMgdGhlIGFkZHJlc3Mg
b2YgaXRzIGFyZ3VtZW50Lg0KDQpNeSBwbGFuIGZvciB2MyBpcyB0byBmaXJzdCBtYWtlIGVoX25v
cmVzdW1lIGEgcmVndWxhciBib29sLCB0aGVuIHVzZQ0KUkVBRF9PTkNFKCkgaW4gc2NzaV9lcnJv
cl9oYW5kbGVyKCkgdG8gc25hcHNob3QgaXQgb25jZSBwZXIgRUggaXRlcmF0aW9uLg0KSSB3aWxs
IGFsc28gdXNlIFdSSVRFX09OQ0UoKSBmb3IgdGhlIHdyaXRlciB0aGF0IGNoYW5nZXMgZWhfbm9y
ZXN1bWUgd2hpbGUNClNDU0kgRUggbWF5IG9ic2VydmUgaXQuDQoNCkRvZXMgdGhpcyBhcHByb2Fj
aCBsb29rIHJlYXNvbmFibGUgdG8geW91Pw0KDQoNCkJlc3QuDQo=
