Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527413CCA11;
	Wed,  3 Jun 2026 11:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780484966; cv=none; b=aHOTAoaxn9cWaCE7UlYnPFkewPtNGMvCDmpYWwEhe0z8S8JphTK5aP/CNzP1NKWHiHE+C7F/V91bpjOhHtyULmPL6EYRWmKJ92D+b4IvPeC2XjED30NdvtgtOWP69RHLKDEujb9D4495Xic5aJa6UlGsy8/qhzDTpX2ASzRO3uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780484966; c=relaxed/simple;
	bh=l8NAMlLRWjb4PWGamPU3tyFYH4VQA1Jkmzi3GWgkSKI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d7rmP+I+H7yq2wPl9ewKD3xCiZA+gyCksOCt6XZivui1d8g4slVOq4wLmB81P8/qFuMByuGw4kiVUTEcizADtbR0eAo2puFkbBlCBaARslvy0EvDBahl6uQV3cWFlq3FU83hBtPZeQovI8Pyd2Stq9u+CqSfpY2EM2JDYqBiko4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch01.asrmicro.com (exch01.asrmicro.com [10.1.24.121])
	by spam.asrmicro.com with ESMTPS id 653B8GYL064086
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Wed, 3 Jun 2026 19:08:16 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch01.asrmicro.com
 (10.1.24.121) with Microsoft SMTP Server (TLS) id 15.0.847.32; Wed, 3 Jun
 2026 19:08:21 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Wed, 3 Jun 2026 19:08:08 +0800
From: =?utf-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= <hongjiefang@asrmicro.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Topic: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Index: AQHc8o1Awukd7b9NBk+4vV9CGfadLrYsZsGAgABEegCAAABAsA==
Date: Wed, 3 Jun 2026 11:08:08 +0000
Message-ID: <27ad241130a34ece8d2645b687f6ffc7@exch02.asrmicro.com>
References: <20260602124103.1581617-1-hongjiefang@asrmicro.com>
 <7404d3067b87d33bb446a1b7f4432b5ae9d98486.camel@mediatek.com>
 <5c2f95f00b484bca9c5df97219230acc@exch02.asrmicro.com>
In-Reply-To: <5c2f95f00b484bca9c5df97219230acc@exch02.asrmicro.com>
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
X-MAIL:spam.asrmicro.com 653B8GYL064086

DQo+IEZyb206IFBldGVyIFdhbmcgKOeOi+S/oeWPiykgW21haWx0bzpwZXRlci53YW5nQG1lZGlh
dGVrLmNvbV0NCj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDMsIDIwMjYgMjo1NSBQTQ0KPiBUbzog
YmVhbmh1b0BtaWNyb24uY29tOyBKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29t
Ow0KPiBGYW5nIEhvbmdqaWUo5pa55rSq5p2wKSA8aG9uZ2ppZWZhbmdAYXNybWljcm8uY29tPjsN
Cj4gYWxpbS5ha2h0YXJAc2Ftc3VuZy5jb207IGF2cmkuYWx0bWFuQHdkYy5jb207DQo+IG1hcnRp
bi5wZXRlcnNlbkBvcmFjbGUuY29tOyBidmFuYXNzY2hlQGFjbS5vcmcNCj4gQ2M6IGxpbnV4LXNj
c2lAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjRdIHNjc2k6IHVmczogY29yZTogaGFuZGxlIFBNIGNvbW1hbmRzIHRp
bWVvdXQgYmVmb3JlDQo+IFNDU0kgRUgNCj4gDQo+IA0KPiBPbiBUdWUsIDIwMjYtMDYtMDIgYXQg
MjA6NDEgKzA4MDAsIEhvbmdqaWUgRmFuZyB3cm90ZToNCj4gPiArwqDCoMKgwqDCoMKgIC8qDQo+
ID4gK8KgwqDCoMKgwqDCoMKgICogdWZzaGNkX2xpbmtfcmVjb3ZlcnkoKSBtYXkgYWxyZWFkeSBo
YXZlIGNvbXBsZXRlZCBAc2NtZCwNCj4gPiBlLmcuIHZpYQ0KPiA+ICvCoMKgwqDCoMKgwqDCoCAq
IHRoZSBleGlzdGluZyBNQ1EgZm9yY2UtY29tcGxldGlvbiBwYXRoLg0KPiA+ICvCoMKgwqDCoMKg
wqDCoCAqLw0KPiA+ICvCoMKgwqDCoMKgwqAgaWYgKCF0ZXN0X2JpdChTQ01EX1NUQVRFX0NPTVBM
RVRFLCAmc2NtZC0+c3RhdGUpKSB7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
aWYgKCFoYmEtPm1jcV9lbmFibGVkKSB7DQo+ID4NCj4gDQo+IEhpIEhvbmdqaWUsDQo+IA0KPiBN
Q1Egd2lsbCBjb21wbGV0ZSBhbGwgdW5jb21wbGV0ZWQgc2NtZCBieSBzZXR0aW5nIGZvcmNlX2Nv
bXBsLg0KPiBIZW5jZSwgaWYgdGhlcmUgYXJlIHN0aWxsIHVuY29tcGxldGVkIHNjbWQsIGl0IHNo
b3VsZCBiZQ0KPiBpbiBsZWdhY3kgbW9kZSwgYW5kIHRoZXJlIGlzIG5vIG5lZWQgdG8gY2hlY2sN
Cj4gaWYgKCFoYmEtPm1jcV9lbmFibGVkKSwgcmlnaHQ/DQo+IA0KDQpUaGUgIWhiYS0+bWNxX2Vu
YWJsZWQgY2hlY2sgaXMgb25seSBmb3IgY2xlYXJpbmcgb3V0c3RhbmRpbmdfcmVxcywNCndoaWNo
IGlzIHRoZSBsZWdhY3kgc2luZ2xlLWRvb3JiZWxsIHNvZnR3YXJlIGJpdG1hcC4NCk1DUSBkb2Vz
IG5vdCB1c2Ugb3V0c3RhbmRpbmdfcmVxcyBmb3IgcmVxdWVzdCB0cmFja2luZy4NCg0KDQo+IA0K
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25l
ZCBsb25nIGZsYWdzOw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBzdHJ1Y3QgcmVxdWVzdCAqcnEgPSBzY3NpX2NtZF90b19ycShzY21kKTsNCj4gPiAr
DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNwaW5f
bG9ja19pcnFzYXZlKCZoYmEtPm91dHN0YW5kaW5nX2xvY2ssDQo+ID4gZmxhZ3MpOw0KPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX2NsZWFyX2JpdChy
cS0+dGFnLCAmaGJhLT5vdXRzdGFuZGluZ19yZXFzKTsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaGJhLQ0K
PiA+ID5vdXRzdGFuZGluZ19sb2NrLCBmbGFncyk7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgfQ0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZXRf
aG9zdF9ieXRlKHNjbWQsIERJRF9USU1FX09VVCk7DQo+ID4NCj4gDQo+IFdoeSBkb2VzIE1DUSBt
b2RlIHNldCBESURfUkVRVUVVRSwgd2hpbGUgbGVnYWN5IG1vZGUgc2V0cw0KPiBESURfVElNRV9P
VVQ/DQo+IA0KTm9ybWFsIFNDU0kgUE0gY29tbWFuZHMgdXNlIERJRF9SRVFVRVVFLCBtYXRjaGlu
ZyB0aGUgZXhpc3RpbmcNCk1DUSBmb3JjZS1jb21wbGV0aW9uIGJlaGF2aW9yLiBSZXNlcnZlZCBp
bnRlcm5hbCBkZXZpY2UtbWFuYWdlbWVudA0KY29tbWFuZHMgY29udGludWUgdG8gdXNlIERJRF9U
SU1FX09VVCwgcmlnaHQgPw0KDQoNCg0KQmVzdC4NCg0KDQo=
