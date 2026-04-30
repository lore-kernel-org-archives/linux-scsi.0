Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1367F2DB7BB;
	Thu, 30 Apr 2026 02:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777516874; cv=none; b=kbWXNRPdWHRfwygyLJTaze23/aVJqDaIDoa8uk9Ni+b35YTspwXWoMQTR94h+h27I08jQ2G8lBMPJ8sRy2b6f638euBgojbnU1Xj2ENphCtzhlrJVGvqUO9szq5heKTOhHbCkgYNsCdA/woxWSmHyCf3eGqZf/j5XNctdiSjsNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777516874; c=relaxed/simple;
	bh=BSwcBDogC5/26mocS2YMMuV2l+cCKwkLxHj8WiYOdNc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ac57e4G16gk9jekWo/ceMQiNTZNWnQtMggyQ2Toj76sYpEwDKnLg6zQKksgDphw8g1jDT61Sc4ck/TEVBiEGU2ABl7rE6OWQVVw933hQk394MDJF8Qql6UOvRqX2GOZVgfa2PJU78d50ZSVwimue98hZU59HlEGol0Gx/X7Dklk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch01.asrmicro.com (exch01.asrmicro.com [10.1.24.121])
	by spam.asrmicro.com with ESMTPS id 63U2ebv9074159
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Thu, 30 Apr 2026 10:40:37 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch01.asrmicro.com
 (10.1.24.121) with Microsoft SMTP Server (TLS) id 15.0.847.32; Thu, 30 Apr
 2026 10:40:36 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Thu, 30 Apr 2026 10:40:36 +0800
From: =?utf-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= <hongjiefang@asrmicro.com>
To: Bart Van Assche <bvanassche@acm.org>,
        "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: core: call hibern8 notify when hibern8
 cmd failed
Thread-Topic: [PATCH v2] scsi: ufs: core: call hibern8 notify when hibern8
 cmd failed
Thread-Index: AQHc1/SKWlWQTbPwVkeIYO/9yfHr+LX24plQ
Date: Thu, 30 Apr 2026 02:40:35 +0000
Message-ID: <568f953d989a410fa573127a4c3c22d4@exch02.asrmicro.com>
References: <20260429112355.4125408-1-hongjiefang@asrmicro.com>
 <13b1b7e8-4cd1-420a-94a4-e8528d2eb723@acm.org>
In-Reply-To: <13b1b7e8-4cd1-420a-94a4-e8528d2eb723@acm.org>
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
X-MAIL:spam.asrmicro.com 63U2ebv9074159

DQo+IEZyb206IEJhcnQgVmFuIEFzc2NoZSBbbWFpbHRvOmJ2YW5hc3NjaGVAYWNtLm9yZ10NCj4g
U2VudDogVGh1cnNkYXksIEFwcmlsIDMwLCAyMDI2IDEyOjIzIEFNDQo+IFRvOiBGYW5nIEhvbmdq
aWUgPGhvbmdqaWVmYW5nQGFzcm1pY3JvLmNvbT47DQo+IGFsaW0uYWtodGFyQHNhbXN1bmcuY29t
OyBhdnJpLmFsdG1hbkB3ZGMuY29tOw0KPiBKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNo
aXAuY29tOyBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbQ0KPiBDYzogbGludXgtc2NzaUB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6
IFtQQVRDSCB2Ml0gc2NzaTogdWZzOiBjb3JlOiBjYWxsIGhpYmVybjggbm90aWZ5IHdoZW4gaGli
ZXJuOCBjbWQNCj4gZmFpbGVkDQo+IA0KPiBPbiA0LzI5LzI2IDQ6MjMgQU0sIEhvbmdqaWUgRmFu
ZyB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91ZnMvdWZzaGNkLmggYi9pbmNsdWRl
L3Vmcy91ZnNoY2QuaA0KPiA+IGluZGV4IDg1NjNiNjY0ODk3Ni4uYzFjYjMwZDhhYTRhIDEwMDY0
NA0KPiA+IC0tLSBhL2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+ID4gKysrIGIvaW5jbHVkZS91ZnMv
dWZzaGNkLmgNCj4gPiBAQCAtMzU1LDcgKzM1NSw4IEBAIHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRf
b3BzIHsNCj4gPiAgIAkJCQkgIGJvb2wgaXNfc2NzaV9jbWQpOw0KPiA+ICAgCXZvaWQJKCpzZXR1
cF90YXNrX21nbXQpKHN0cnVjdCB1ZnNfaGJhICosIGludCwgdTgpOw0KPiA+ICAgCXZvaWQgICAg
KCpoaWJlcm44X25vdGlmeSkoc3RydWN0IHVmc19oYmEgKiwgZW51bSB1aWNfY21kX2RtZSwNCj4g
PiAtCQkJCQllbnVtIHVmc19ub3RpZnlfY2hhbmdlX3N0YXR1cyk7DQo+ID4gKwkJCQkJZW51bSB1
ZnNfbm90aWZ5X2NoYW5nZV9zdGF0dXMsDQo+ID4gKwkJCQkJaW50IGNtZF9yZXQpOw0KPiA+ICAg
CWludAkoKmFwcGx5X2Rldl9xdWlya3MpKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KPiA+ICAgCXZv
aWQJKCpmaXh1cF9kZXZfcXVpcmtzKShzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCj4gPiAgIAlpbnQg
ICAgICgqc3VzcGVuZCkoc3RydWN0IHVmc19oYmEgKiwgZW51bSB1ZnNfcG1fb3AsDQo+IA0KPiBQ
YXNzaW5nIHRoZSBmdWxsICdjbWRfcmV0JyB2YWx1ZSB0byB0aGUgaGliZXJuOF9ub3RpZnkgdmVu
ZG9yIG9wZXJhdGlvbg0KPiBtYXkgbWFrZSB0aGUgVUZTIGRyaXZlciBoYXJkZXIgdG8gbWFpbnRh
aW4gdGhhbiBuZWNlc3NhcnkuDQo+IEltcGxlbWVudGF0aW9ucyBvZiB0aGlzIHZlbmRvciBvcGVy
YXRpb24gbWF5IHRlc3QgZm9yIHNwZWNpZmljIHZhbHVlcyBvZg0KPiAnY21kX3JldCcuIEhlbmNl
LCB3aGVuIG1ha2luZyBhbnkgY2hhbmdlIGluIHRoZSBjb2RlIHRoYXQgY2FsbHMNCj4gLmhpYmVy
bjhfbm90aWZ5KCkgcmVnYXJkaW5nIHRoZSByZXR1cm4gdmFsdWUsIGFsbCBpbXBsZW1lbnRhdGlv
bnMgb2YNCj4gLmhpYmVybjhfbm90aWZ5KCkgd291bGQgaGF2ZSB0byBiZSByZXZpZXdlZC4NCj4g
DQo+IEhhcyBpdCBiZWVuIGNvbnNpZGVyZWQgdG8gYWRkIGEgdGhpcmQgdmFsdWUgaW4gZW51bQ0K
PiB1ZnNfbm90aWZ5X2NoYW5nZV9zdGF0dXMsIGUuZy4gUk9MTEJBQ0tfQ0hBTkdFPyBUaGF0IHNo
b3VsZCBiZQ0KPiBzdWZmaWNpZW50IGZvciBoaWJlcm44X25vdGlmeSBpbXBsZW1lbnRhdGlvbnMs
IGlzbid0IGl0Pw0KPiANCg0KQWRkaW5nIGEgdGhpcmQgZW51bSB2YWx1ZSB0byBoYW5kbGUgdGhp
cyBpcyB0aGUgbW9yZSByZWFzb25hYmxlIGFwcHJvYWNoLiANClRoaXMgd291bGQgbm90IGFmZmVj
dCB0aGUgZXhpc3RpbmcgdmVuZG9yIGltcGxlbWVudGF0aW9ucywgDQphbmQgdGhlIGNoYW5nZSB3
b3VsZCBiZSBjb25maW5lZCB0byBpbnRlcm5hbCBmdW5jdGlvbnMgd2l0aGluIHRoZSB1ZnMgY29y
ZS4NCg0KUGFzcyBgUk9MTEJBQ0tfQ0hBTkdFYCB3aGVuIHRoZSBoaWJlcm44IGNvbW1hbmQgcmV0
dXJucyBhIGZhaWx1cmUsIA0KYW5kIHVzZSBgUE9TVF9DSEFOR0VgIG90aGVyd2lzZS4NCg0KPiBU
aGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpCZXN0Lg0KDQo=
