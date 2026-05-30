Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C7F37DEA3;
	Sat, 30 May 2026 11:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780140462; cv=none; b=LLkCfbBHvOqEzkromK+g4F+iTLR298iHmXzr0gmZn1GDL7jB9770rCuI77hikdA/xLhJe6jPviyarM1YjjjlBFU8yMvAJ6UKNoPcXcEfI6A+LpqNA5nmUxzMGA6By7d4VcDx+bshc96ZuBTi6eqz8XF0UtmBIF+z7zDKMUv4i3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780140462; c=relaxed/simple;
	bh=DTRAzkJQj2Gb0eLZVNnuYrb56urciUYqUruxJLkJCH4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BFdnIvJDQDScm9uWecqCJNvI6mTFShymVHB1yIFfH6Sb7R06GtyW6cqDlaQ36Socz3xLhQ6J7eRZyF9XR2byfStdUj0bv/Qj2tDY1GGyJRXM8YBAd+X+YWosYRGeWfL4MywMMTTcjCfgfxECDItVk5nSM1SnJKyhYpY2JwvpJAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from mail2012.asrmicro.com (mail2012.asrmicro.com [10.1.24.123])
	by spam.asrmicro.com with ESMTPS id 64UBQaBu024832
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Sat, 30 May 2026 19:26:36 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by mail2012.asrmicro.com
 (10.1.24.123) with Microsoft SMTP Server (TLS) id 15.0.847.32; Sat, 30 May
 2026 19:26:29 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Sat, 30 May 2026 19:26:11 +0800
From: =?utf-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= <hongjiefang@asrmicro.com>
To: Bart Van Assche <bvanassche@acm.org>,
        "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: core: handle PM SSU timeout before SCSI EH
Thread-Topic: [PATCH v2] scsi: ufs: core: handle PM SSU timeout before SCSI
 EH
Thread-Index: AQHc77SXToiye5PISUmqBeFrmsszRLYmbWGQ
Date: Sat, 30 May 2026 11:26:11 +0000
Message-ID: <e2e3743feaa0476d944f17cecf978407@exch02.asrmicro.com>
References: <20260528113433.367083-1-hongjiefang@asrmicro.com>
 <88ffd4c6-798c-4e0a-ba72-a3b3a027c39d@acm.org>
In-Reply-To: <88ffd4c6-798c-4e0a-ba72-a3b3a027c39d@acm.org>
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
X-MAIL:spam.asrmicro.com 64UBQaBu024832

DQo+IEZyb206IEJhcnQgVmFuIEFzc2NoZSBbbWFpbHRvOmJ2YW5hc3NjaGVAYWNtLm9yZ10NCj4g
U2VudDogU2F0dXJkYXksIE1heSAzMCwgMjAyNiA1OjQ2IEFNDQo+IFRvOiBGYW5nIEhvbmdqaWUo
5pa55rSq5p2wKSA8aG9uZ2ppZWZhbmdAYXNybWljcm8uY29tPjsNCj4gYWxpbS5ha2h0YXJAc2Ft
c3VuZy5jb207IGF2cmkuYWx0bWFuQHdkYy5jb207DQo+IEphbWVzLkJvdHRvbWxleUBIYW5zZW5Q
YXJ0bmVyc2hpcC5jb207IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tOw0KPiBwZXRlci53YW5n
QG1lZGlhdGVrLmNvbTsgYmVhbmh1b0BtaWNyb24uY29tDQo+IENjOiBsaW51eC1zY3NpQHZnZXIu
a2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIHYyXSBzY3NpOiB1ZnM6IGNvcmU6IGhhbmRsZSBQTSBTU1UgdGltZW91dCBiZWZvcmUg
U0NTSQ0KPiBFSA0KPiANCj4gT24gNS8yOC8yNiA0OjM0IEFNLCBIb25namllIEZhbmcgd3JvdGU6
DQo+ID4gQEAgLTk0NjUsMjMgKzk0OTgsMzAgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2FzeW5jX3Nj
YW4odm9pZCAqZGF0YSwNCj4gYXN5bmNfY29va2llX3QgY29va2llKQ0KPiA+ICAgc3RhdGljIGVu
dW0gc2NzaV90aW1lb3V0X2FjdGlvbiB1ZnNoY2RfZWhfdGltZWRfb3V0KHN0cnVjdCBzY3NpX2Nt
bmQNCj4gKnNjbWQpDQo+ID4gICB7DQo+ID4gICAJc3RydWN0IHVmc19oYmEgKmhiYSA9IHNob3N0
X3ByaXYoc2NtZC0+ZGV2aWNlLT5ob3N0KTsNCj4gPiArCWludCByZXQ7DQo+ID4NCj4gPiAtCWlm
ICghaGJhLT5zeXN0ZW1fc3VzcGVuZGluZykgew0KPiA+ICsJaWYgKCFoYmEtPnBtX29wX2luX3By
b2dyZXNzIHx8IHNjbWQtPmRldmljZSAhPSBoYmEtDQo+ID51ZnNfZGV2aWNlX3dsdW4gfHwNCj4g
PiArCSAgICBzY21kLT5jbW5kWzBdICE9IFNUQVJUX1NUT1ApIHsNCj4gPiAgIAkJLyogQWN0aXZh
dGUgdGhlIGVycm9yIGhhbmRsZXIgaW4gdGhlIFNDU0kgY29yZS4gKi8NCj4gPiAgIAkJcmV0dXJu
IFNDU0lfRUhfTk9UX0hBTkRMRUQ7DQo+ID4gICAJfQ0KPiANCj4gUGxlYXNlIGRvbid0IG1ha2Ug
dGhlIGNvZGUgYW55IG1vcmUgY29tcGxleCB0aGFuIG5lY2Vzc2FyeS4gSWYgYSBwb3dlcg0KPiBt
YW5hZ2VtZW50IG9wZXJhdGlvbiBpcyBpbiBwcm9ncmVzcyBpdCBpcyBndWFyYW50ZWVkIHRoYXQg
bm8gb3RoZXIgU0NTSQ0KPiBjb21tYW5kcyBhcmUgaW4gcHJvZ3Jlc3MuIFNlZSBhbHNvIGJsa19w
cmVfcnVudGltZV9zdXNwZW5kKCkgYW5kDQo+IGJsa190cnlfZW50ZXJfcXVldWUoKS4gSGVuY2Us
IGZvciB0aGUgYWJvdmUgaWYtY29uZGl0aW9uLCB0ZXN0aW5nDQo+IGhiYS0+cG1fb3BfaW5fcHJv
Z3Jlc3MgaXMgc3VmZmljaWVudC4NCj4gDQoNCkkgYWdyZWUgd2l0aCB5b3VyIGNvbW1lbnRzLiBJ
dCB3aWxsIG9ubHkgY2hlY2sgd2hldGhlciBhIFBNIG9wZXJhdGlvbiBpcw0KaW4gcHJvZ3Jlc3Mg
Zm9yIG5vcm1hbCBTQ1NJIGNvbW1hbmRzOg0KICAgIGlmICghaGJhLT5wbV9vcF9pbl9wcm9ncmVz
cyB8fCAhdWZzaGNkX2lzX3Njc2lfY21kKHNjbWQpKQ0KICAgICAgICAgICAgcmV0dXJuIFNDU0lf
RUhfTk9UX0hBTkRMRUQ7DQoJCQkNClRoZSByZWFzb24gZm9yIGtlZXBpbmcgdWZzaGNkX2lzX3Nj
c2lfY21kKCkgaXMgdG8gYXZvaWQgYXBwbHlpbmcgdGhpcw0Kc3BlY2lhbCBQTSB0aW1lb3V0IHBh
dGggdG8gVUZTIGludGVybmFsIGRldmljZS1tYW5hZ2VtZW50IGNvbW1hbmRzLg0KDQoNCj4gPiAg
IAkvKg0KPiA+IC0JICogSWYgd2UgZ2V0IGhlcmUgd2Uga25vdyB0aGF0IG5vIFRNRnMgYXJlIG91
dHN0YW5kaW5nIGFuZCBhbHNvIHRoYXQNCj4gPiAtCSAqIHRoZSBvbmx5IHBlbmRpbmcgY29tbWFu
ZCBpcyBhIFNUQVJUIFNUT1AgVU5JVCBjb21tYW5kLg0KPiBIYW5kbGUgdGhlDQo+ID4gLQkgKiB0
aW1lb3V0IG9mIHRoYXQgY29tbWFuZCBkaXJlY3RseSB0byBwcmV2ZW50IGEgZGVhZGxvY2sgYmV0
d2Vlbg0KPiA+IC0JICogdWZzaGNkX3NldF9kZXZfcHdyX21vZGUoKSBhbmQgdWZzaGNkX2Vycl9o
YW5kbGVyKCkuDQo+ID4gKwkgKiBQTSBTVEFSVCBTVE9QIFVOSVQgY29tbWFuZHMgYXJlIGlzc3Vl
ZCB3aGlsZSBhIFBNIG9wZXJhdGlvbg0KPiBpcyBpbg0KPiA+ICsJICogcHJvZ3Jlc3MuIEhhbmRs
ZSBzdWNoIHRpbWVvdXRzIGRpcmVjdGx5IHRvIGF2b2lkIGVudGVyaW5nIHJlZ3VsYXINCj4gPiAr
CSAqIFNDU0kgRUgsIHdoaWNoIG1heSBkZWFkbG9jayB3aXRoIHRoZSBQTSBvcGVyYXRpb24gYW5k
IG1heSBhbHNvDQo+IG1ha2UNCj4gPiArCSAqIHNjc2lfZXhlY3V0ZV9jbWQoKSByZXRyaWVzIGZh
aWwgd2hpbGUgdGhlIGhvc3QgaXMgc3RpbGwgaW4gcmVjb3ZlcnkuDQo+ID4gICAJICovDQo+IA0K
PiBUaGUgb3JpZ2luYWwgY29tbWVudCBpcyBmaW5lLCBpc24ndCBpdD8NCj4gDQo+ID4gLQlyZXR1
cm4gc2NzaV9ob3N0X2J1c3koaGJhLT5ob3N0KSA/IFNDU0lfRUhfUkVTRVRfVElNRVIgOg0KPiBT
Q1NJX0VIX0RPTkU7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJldHVybiBTQ1NJX0VIX05PVF9I
QU5ETEVEOw0KPiANCj4gVGhpcyBpcyB3cm9uZyBiZWNhdXNlIGl0IG1heSBhY3RpdmF0ZSB0aGUg
U0NTSSBlcnJvciBoYW5kbGVyIGZvciBhIFNUQVJUDQo+IFNUT1AgVU5JVCBjb21tYW5kLiBXZSBk
b24ndCB3YW50IHRoaXMgLSB3ZSB3YW50IHRoZSBlcnJvciB0byBiZQ0KPiBwcm9wYWdhdGVkIHRv
IHRoZSBzY3NpX2V4ZWN1dGVfY21kKCkgY2FsbGVyLg0KPiANCj4gPiArCVdBUk5fT05fT05DRSgh
dGVzdF9iaXQoU0NNRF9TVEFURV9DT01QTEVURSwgJnNjbWQtDQo+ID5zdGF0ZSkpOw0KPiANCj4g
VGhpcyBpcyBhbHNvIHdyb25nLiBBY2NvcmRpbmcgdG8gRG9jdW1lbnRhdGlvbi9wcm9jZXNzL2Nv
ZGluZy1zdHlsZS5yc3QsDQo+IFdBUk4qKCkgc2hvdWxkIG9ubHkgYmUgdXNlZCBmb3IgdGhpcy1z
aG91bGQtbmV2ZXItaGFwcGVuIHNpdHVhdGlvbnMuIElmDQo+IHRoZSBhYm92ZSBzdGF0ZW1lbnQg
aXMgcmVhY2hlZCBpdCBpcyBhbG1vc3QgYSBjZXJ0YWludHkgdGhhdA0KPiBTQ01EX1NUQVRFX0NP
TVBMRVRFIGlzIG5vdCBzZXQuDQo+IA0KDQpJdCB3aWxsIGtlZXAgdGhlIG9yaWdpbmFsIGNvbW1l
bnQgaW4gdWZzaGNkX2VoX3RpbWVkX291dCgpLCByZW1vdmUgdGhlDQpTQ1NJX0VIX05PVF9IQU5E
TEVEIGZhbGxiYWNrIGFmdGVyIGxpbmsgcmVjb3ZlcnksIGFuZCByZW1vdmUgdGhlIFdBUk5fT04N
CmFzIHN1Z2dlc3RlZC4NCg0KDQo+IFRoZSByZXN0IG9mIHRoaXMgcGF0Y2ggbG9va3MgZ29vZCB0
byBtZS4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg0KQmVzdC4NCg==
