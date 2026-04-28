Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08A73191D0;
	Tue, 28 Apr 2026 05:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777354525; cv=none; b=RzX+qaBFVSbekQ2tniqwSwnJc5Sq2reO9m8rD2HqW7YVnNWQWezTkK/N4Zouv7ueAZW6yCUpvxqEkL2s5MjPMYWqQI0dFxoZw0CKophPIDgy1VVZVWfy7+VaMhaJIFbiRyKH2yu0Qkg8rCAfljFtwMu3Dys6mCyQn6QeJ/nV/rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777354525; c=relaxed/simple;
	bh=d5ch7ZeWFcad56htEl+YCUSBKkWI2+kCW3Zqb2e3+po=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QXJwMzWux+7SlSxI/s7hTkxAlDjQF5OKbDd66bUh6CmG8yE0ULQzlhhIBXAlQwtehkFo6unJq2FniWIb70ppq2J6GSrQvmMCWjfyf1OuwfRhtrQZYSvZnFDQYrYHPN/yoxhDzzgNCn5/Jly7tENo8s4SCCt1ajfC78sGhqXu0v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 63S5YPG1022116
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Tue, 28 Apr 2026 13:34:25 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch02.asrmicro.com
 (10.1.24.122) with Microsoft SMTP Server (TLS) id 15.0.847.32; Tue, 28 Apr
 2026 13:34:28 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Tue, 28 Apr 2026 13:34:28 +0800
From: =?utf-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= <hongjiefang@asrmicro.com>
To: Bart Van Assche <bvanassche@acm.org>,
        "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: core: call hibern8 notify when hibern8 cmd
 failed
Thread-Topic: [PATCH] scsi: ufs: core: call hibern8 notify when hibern8 cmd
 failed
Thread-Index: AQHc1D444V0kRE2bg0yph9I2HVaaqLXz93fQ
Date: Tue, 28 Apr 2026 05:34:27 +0000
Message-ID: <637d83215e374406bbeaa89e2ba166b0@exch02.asrmicro.com>
References: <20260422072102.1204886-1-hongjiefang@asrmicro.com>
 <c4d34bff-a540-4a1e-94d3-c3b820524103@acm.org>
In-Reply-To: <c4d34bff-a540-4a1e-94d3-c3b820524103@acm.org>
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
X-MAIL:spam.asrmicro.com 63S5YPG1022116

DQo+IEZyb206IEJhcnQgVmFuIEFzc2NoZSBbbWFpbHRvOmJ2YW5hc3NjaGVAYWNtLm9yZ10NCj4g
U2VudDogU2F0dXJkYXksIEFwcmlsIDI1LCAyMDI2IDc6MDEgQU0NCj4gVG86IEZhbmcgSG9uZ2pp
ZSA8aG9uZ2ppZWZhbmdAYXNybWljcm8uY29tPjsNCj4gYWxpbS5ha2h0YXJAc2Ftc3VuZy5jb207
IGF2cmkuYWx0bWFuQHdkYy5jb207DQo+IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tOyBKYW1l
cy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tDQo+IENjOiBsaW51eC1zY3NpQHZnZXIu
a2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTog
W1BBVENIXSBzY3NpOiB1ZnM6IGNvcmU6IGNhbGwgaGliZXJuOCBub3RpZnkgd2hlbiBoaWJlcm44
IGNtZA0KPiBmYWlsZWQNCj4gDQo+IE9uIDQvMjIvMjYgMTI6MjEgQU0sIEhvbmdqaWUgRmFuZyB3
cm90ZToNCj4gPiBUaGUgdmVuZG9yIGhpYmVybjggbm90aWZ5IGNhbGxiYWNrIGFsd2F5cyBjYW4g
YmUgZXhlY3V0ZWQgaW4gdGhlDQo+ID4gUFJFX0NIQU5HRSBwaGFzZSBvZiBoaWJlcm44IGVudGVy
L2V4aXQuIEJ1dCBpdCBjYW5ub3QgYmUgZXhlY3V0ZWQNCj4gPiBpbiB0aGUgUE9TVF9DSEFOR0Ug
cGhhc2UgaWYgdGhlIGhpYmVybjggY21kIGZhaWxzLg0KPiA+DQo+ID4gV2hlbiB0aGUgaGliZXJu
OCBjbWQgZmFpbHMsIHRoZSB2ZW5kb3IgaGliZXJuOCBub3RpZnkgY2FsbGJhY2sNCj4gPiBzaG91
bGQgc3RpbGwgaGF2ZSB0aGUgb3Bwb3J0dW5pdHkgdG8gZXhlY3V0ZS4NCj4gPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEhvbmdqaWUgRmFuZyA8aG9uZ2ppZWZhbmdAYXNybWljcm8uY29tPg0KPiA+IC0t
LQ0KPiA+ICAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDkgKysrKy0tLS0tDQo+ID4gICAx
IGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3Jl
L3Vmc2hjZC5jDQo+ID4gaW5kZXggOWNlYjZkNmQ0NzlkLi4wMjA5MWU3MmY4ZGIgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdWZz
L2NvcmUvdWZzaGNkLmMNCj4gPiBAQCAtNDUwMCw5ICs0NTAwLDggQEAgaW50IHVmc2hjZF91aWNf
aGliZXJuOF9lbnRlcihzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiA+ICAgCWlmIChyZXQpDQo+
ID4gICAJCWRldl9lcnIoaGJhLT5kZXYsICIlczogaGliZXJuOCBlbnRlciBmYWlsZWQuIHJldCA9
ICVkXG4iLA0KPiA+ICAgCQkJX19mdW5jX18sIHJldCk7DQo+ID4gLQllbHNlDQo+ID4gLQkJdWZz
aGNkX3ZvcHNfaGliZXJuOF9ub3RpZnkoaGJhLA0KPiBVSUNfQ01EX0RNRV9ISUJFUl9FTlRFUiwN
Cj4gPiAtDQo+IAlQT1NUX0NIQU5HRSk7DQo+ID4gKw0KPiA+ICsJdWZzaGNkX3ZvcHNfaGliZXJu
OF9ub3RpZnkoaGJhLCBVSUNfQ01EX0RNRV9ISUJFUl9FTlRFUiwNCj4gUE9TVF9DSEFOR0UpOw0K
PiA+DQo+ID4gICAJcmV0dXJuIHJldDsNCj4gPiAgIH0NCj4gPiBAQCAtNDUyNiwxMiArNDUyNSwx
MiBAQCBpbnQgdWZzaGNkX3VpY19oaWJlcm44X2V4aXQoc3RydWN0IHVmc19oYmENCj4gKmhiYSkN
Cj4gPiAgIAkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBoaWJlcm44IGV4aXQgZmFpbGVkLiByZXQg
PSAlZFxuIiwNCj4gPiAgIAkJCV9fZnVuY19fLCByZXQpOw0KPiA+ICAgCX0gZWxzZSB7DQo+ID4g
LQkJdWZzaGNkX3ZvcHNfaGliZXJuOF9ub3RpZnkoaGJhLA0KPiBVSUNfQ01EX0RNRV9ISUJFUl9F
WElULA0KPiA+IC0NCj4gCVBPU1RfQ0hBTkdFKTsNCj4gPiAgIAkJaGJhLT51ZnNfc3RhdHMubGFz
dF9oaWJlcm44X2V4aXRfdHN0YW1wID0gbG9jYWxfY2xvY2soKTsNCj4gPiAgIAkJaGJhLT51ZnNf
c3RhdHMuaGliZXJuOF9leGl0X2NudCsrOw0KPiA+ICAgCX0NCj4gPg0KPiA+ICsJdWZzaGNkX3Zv
cHNfaGliZXJuOF9ub3RpZnkoaGJhLCBVSUNfQ01EX0RNRV9ISUJFUl9FWElULA0KPiBQT1NUX0NI
QU5HRSk7DQo+ID4gKw0KPiA+ICAgCXJldHVybiByZXQ7DQo+ID4gICB9DQo+ID4gICBFWFBPUlRf
U1lNQk9MX0dQTCh1ZnNoY2RfdWljX2hpYmVybjhfZXhpdCk7DQo+IA0KPiBUaGlzIGNoYW5nZSBt
YXkgYnJlYWsgZXhpc3RpbmcgaGliZXJuOF9ub3RpZnkoKSBpbXBsZW1lbnRhdGlvbnMuIFBsZWFz
ZQ0KPiBhZGQgYSBuZXcgYXJndW1lbnQgdG8gdWZzaGNkX3ZvcHNfaGliZXJuOF9ub3RpZnkoKSB0
aGF0IHJlcHJlc2VudHMNCj4gd2hldGhlciBvciBub3QgdGhlIG9wZXJhdGlvbiBzdWNjZWVkZWQg
Zm9yIFBPU1RfQ0hBTkdFIGNhbGxiYWNrcy4NCj4gDQoNCk9rYXksIEnigJlsbCBtb2RpZnkgdGhl
IHBhdGNoIGFjY29yZGluZ2x5Lg0KDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCkJlc3QuDQo=
