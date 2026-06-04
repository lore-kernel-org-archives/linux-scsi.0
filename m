Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C8F21FF23;
	Thu,  4 Jun 2026 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780586751; cv=none; b=HU1v+HLUpZfnXnR9fnN6j4bPWLRjiDdOPe2efON5vdVFBBR7fj8beS8mYdU4fb5sTHEviIpc1/eBzm1nDsX50DToEGdY6jh9U5+Ms2FHCmRi5w+ZXKpRx7HUipIuznLk2Fhls1tKA17V8E48oBwRf76jootCKm38JMn4i3PSMrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780586751; c=relaxed/simple;
	bh=ts7kuAkVk+gEKOQycO9ZatNeu6NiW1ZvdBBSOs0KGTk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Kma4OyE6uQFspjDLpHwFAO44w+Raagv8ABR4EUkbenOHTd/PoxDbU0Z3jsZcGC8+1fUeJwrdGMjsWtEKDMbRPv5GDk8oJio4k3F0GicjE6kTN+2hYJ6lykHvr7a5y8lRQp9AcOxMJYNwRiji7qIcDJnghJcQUMF8nWfo1b/zEK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 654FOicC005489
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Thu, 4 Jun 2026 23:24:44 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch02.asrmicro.com
 (10.1.24.122) with Microsoft SMTP Server (TLS) id 15.0.847.32; Thu, 4 Jun
 2026 23:24:50 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Thu, 4 Jun 2026 23:24:50 +0800
From: =?utf-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= <hongjiefang@asrmicro.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org"
	<bvanassche@acm.org>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Topic: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Index: AQHc8o1Awukd7b9NBk+4vV9CGfadLrYsZsGAgABEegCAAABAsIAAsmoAgAD1IECAACNLoA==
Date: Thu, 4 Jun 2026 15:24:50 +0000
Message-ID: <b1f26cb67e2249fb83982c58e2e528ac@exch02.asrmicro.com>
References: <20260602124103.1581617-1-hongjiefang@asrmicro.com>
	 <7404d3067b87d33bb446a1b7f4432b5ae9d98486.camel@mediatek.com>
	 <5c2f95f00b484bca9c5df97219230acc@exch02.asrmicro.com>
	 <27ad241130a34ece8d2645b687f6ffc7@exch02.asrmicro.com>
 <9b00734a666a2b68a3a6dfb31ce78ffccc5c3686.camel@mediatek.com>
 <f2a49399526f44a2a3f94c90229330ea@exch02.asrmicro.com>
In-Reply-To: <f2a49399526f44a2a3f94c90229330ea@exch02.asrmicro.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
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
X-MAIL:spam.asrmicro.com 654FOicC005489

DQo+IA0KPiBJIGtub3csIGJ1dCB3aGF0IEkgbWVhbiBpcywgaWYgdGhpcyBjaGVjayAoIWhiYS0+
bWNxX2VuYWJsZWQpDQo+IGFsd2F5cyBldmFsdWF0ZXMgdG8gdHJ1ZSwgdGhlbiBpdCBpcyBhIHJl
ZHVuZGFudCBjaGVjaywgcmlnaHQ/DQo+IEkgZG9uJ3Qgc2VlIGFueSBzY2VuYXJpbyB3aGVyZSBp
dCB3b3VsZCByZXR1cm4gZmFsc2UuDQo+IA0KDQohaGJhLT5tY3FfZW5hYmxlZCBpcyBub3QgYWx3
YXlzIHRydWUgb25jZSBQTSBpbnRlcm5hbA0KZGV2aWNlLW1hbmFnZW1lbnQgY29tbWFuZHMgYXJl
IGluY2x1ZGVkLiBJbiBNQ1EgbW9kZSwNCnVmc2hjZF9tY3FfZm9yY2VfY29tcGxfb25lKCkgc2tp
cHMgcmVzZXJ2ZWQgcmVxdWVzdHMsIHNvIGFmdGVyDQp1ZnNoY2RfbGlua19yZWNvdmVyeSgpIGEg
dGltZWQtb3V0IHJlc2VydmVkIGludGVybmFsIGNvbW1hbmQgY2FuIHN0aWxsDQpyZWFjaCB0aGlz
IHBhdGggd2l0aCBoYmEtPm1jcV9lbmFibGVkID09IHRydWUuIA0KDQo+ID4NCj4gPiA+DQo+ID4g
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25l
ZCBsb25nIGZsYWdzOw0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgc3RydWN0IHJlcXVlc3QgKnJxID0NCj4gPiA+ID4gc2NzaV9jbWRfdG9fcnEo
c2NtZCk7DQo+ID4gPiA+ICsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHNwaW5fbG9ja19pcnFzYXZlKCZoYmEtPm91dHN0YW5kaW5nX2xvY2ss
DQo+ID4gPiA+IGZsYWdzKTsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIF9fY2xlYXJfYml0KHJxLT50YWcsICZoYmEtDQo+ID4gPiA+ID5vdXRz
dGFuZGluZ19yZXFzKTsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhiYS0NCj4gPiA+ID4gPiBvdXRz
dGFuZGluZ19sb2NrLCBmbGFncyk7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIH0NCj4gPiA+ID4gKw0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBz
ZXRfaG9zdF9ieXRlKHNjbWQsIERJRF9USU1FX09VVCk7DQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4g
V2h5IGRvZXMgTUNRIG1vZGUgc2V0IERJRF9SRVFVRVVFLCB3aGlsZSBsZWdhY3kgbW9kZSBzZXRz
DQo+ID4gPiBESURfVElNRV9PVVQ/DQo+ID4gPg0KPiA+IE5vcm1hbCBTQ1NJIFBNIGNvbW1hbmRz
IHVzZSBESURfUkVRVUVVRSwgbWF0Y2hpbmcgdGhlIGV4aXN0aW5nDQo+ID4gTUNRIGZvcmNlLWNv
bXBsZXRpb24gYmVoYXZpb3IuIFJlc2VydmVkIGludGVybmFsIGRldmljZS1tYW5hZ2VtZW50DQo+
ID4gY29tbWFuZHMgY29udGludWUgdG8gdXNlIERJRF9USU1FX09VVCwgcmlnaHQgPw0KPiA+DQo+
IA0KPiBTb3JyeSwgSSBkb24ndCBnZXQgaXQuDQo+IEkgbWVhbiwgaW4gTUNRIG1vZGUsIHRoZSB1
ZnNoY2RfbWNxX2ZvcmNlX2NvbXBsX29uZSBmdW5jdGlvbg0KPiBoYW5kbGVzIHRoZSBzYW1lIHVu
Y29tcGxldGVkIGNvbmRpdGlvbiwgYnV0IHdoeSBpcyB0aGUgcHJvY2Vzc2luZw0KPiBsb2dpYyBk
aWZmZXJlbnQ/DQo+IA0KPiBpZiAoIXRlc3RfYml0KFNDTURfU1RBVEVfQ09NUExFVEUsICZjbWQt
PnN0YXRlKSkgew0KPiAgICAgc2V0X2hvc3RfYnl0ZShjbWQsIERJRF9SRVFVRVVFKTsNCj4gICAg
IHVmc2hjZF9yZWxlYXNlX3Njc2lfY21kKGhiYSwgY21kKTsNCj4gICAgIHNjc2lfZG9uZShjbWQp
Ow0KDQpQbGFuIHRvIHVzZSBESURfUkVRVUVVRSBmb3Igbm9ybWFsIFNDU0kgY29tbWFuZHMsIHNp
bmNlIHRoaXMgbWF0Y2hlcw0KdGhlIGV4aXN0aW5nIE1DUSBmb3JjZS1jb21wbGV0aW9uIGJlaGF2
aW9yLg0KDQpGb3IgcmVzZXJ2ZWQgaW50ZXJuYWwgY29tbWFuZHMsIHRoZXNlIHJlc3VsdCBhcmUg
cmV0dXJuZWQgZGlyZWN0bHkgdG8gdGhlDQpVRlMgY29yZSBjYWxsZXIgcmF0aGVyIHRoYW4gZ29p
bmcgdGhyb3VnaCB0aGUgbm9ybWFsIHNjc2lfZXhlY3V0ZV9jbWQoKQ0KcmV0cnkgZmxvdy4gVGhl
cmVmb3JlLCBJIHBsYW4gdG8gY29udGludWUgdXNpbmcgRElEX1RJTUVfT1VUIGZvciB0aG9zZQ0K
Y29tbWFuZHMuDQoNCg0KDQpCZXN0Lg0K
