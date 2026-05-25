Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFA82853EE;
	Mon, 25 May 2026 02:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779674415; cv=none; b=M1jm4VEREejpoIatUqRq0DwihrZUaBhT3eVgHsyyUxFZ737UUO38+L8mf5Q7s1GYXeANQ8aFz5jbFiwM4Q8U4o5zCf8n+e3Lv6TcKdZIv3QR/9JjutlCY1gEk2LYhTMziUfdYvfi3hkXs7O6S42mHLDv0XlQyRYfqQyWiu5clLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779674415; c=relaxed/simple;
	bh=egraaHi8JzntwEF1Muqlxi96+hR/RQZdOV+JO9cNdDk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G1VJZwAdKofb5LtGx9D7r+NPOu8plCRlo9pz2bLlJCbG19txotBBWorkKlPz/ebCnzNYPyNLNdXhfwoo4+7YWf4Tkl4isT5n6mrx5AdCcSktCMJRXzzWxIi3HLov9FtGiquHe9qmSgw8rczBKAHDalaB0LB131LyA/Iak+qvK54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch03.asrmicro.com (exch03.asrmicro.com [10.1.24.118])
	by spam.asrmicro.com with ESMTPS id 64P1xUg5034251
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Mon, 25 May 2026 09:59:30 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch03.asrmicro.com
 (10.1.24.118) with Microsoft SMTP Server (TLS) id 15.0.847.32; Mon, 25 May
 2026 09:59:32 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Mon, 25 May 2026 09:59:31 +0800
From: =?gb2312?B?RmFuZyBIb25namllKLe9uum93Ck=?= <hongjiefang@asrmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "jgarzik@redhat.com" <jgarzik@redhat.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: core: pair EH runtime PM get/put with eh_noresume
 snapshot
Thread-Topic: [PATCH] scsi: core: pair EH runtime PM get/put with
 eh_noresume snapshot
Thread-Index: AQHc6sJdJnBzh7lQV0aRMS/HT6kWcLYd/gWQ
Date: Mon, 25 May 2026 01:59:30 +0000
Message-ID: <e6f4f65a206d4208bce55caa9e1aaf6d@exch02.asrmicro.com>
References: <20260523033438.3547549-1-hongjiefang@asrmicro.com>
 <88f98e04-4ccc-416c-b677-f49a46ec97fb@rowland.harvard.edu>
In-Reply-To: <88f98e04-4ccc-416c-b677-f49a46ec97fb@rowland.harvard.edu>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
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
X-MAIL:spam.asrmicro.com 64P1xUg5034251

DQo+IEZyb206IEFsYW4gU3Rlcm4gW21haWx0bzpzdGVybkByb3dsYW5kLmhhcnZhcmQuZWR1XQ0K
PiBTZW50OiBTYXR1cmRheSwgTWF5IDIzLCAyMDI2IDEwOjQyIFBNDQo+IFRvOiBGYW5nIEhvbmdq
aWUot7266b3cKSA8aG9uZ2ppZWZhbmdAYXNybWljcm8uY29tPg0KPiBDYzogSmFtZXMuQm90dG9t
bGV5QGhhbnNlbnBhcnRuZXJzaGlwLmNvbTsNCj4gbWFydGluLnBldGVyc2VuQG9yYWNsZS5jb207
IGpnYXJ6aWtAcmVkaGF0LmNvbTsgbWluZy5tLmxpbkBpbnRlbC5jb207DQo+IGxpbnV4LXNjc2lA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0hdIHNjc2k6IGNvcmU6IHBhaXIgRUggcnVudGltZSBQTSBnZXQvcHV0IHdpdGgN
Cj4gZWhfbm9yZXN1bWUgc25hcHNob3QNCj4gDQo+IE9uIFNhdCwgTWF5IDIzLCAyMDI2IGF0IDEx
OjM0OjM4QU0gKzA4MDAsIEhvbmdqaWUgRmFuZyB3cm90ZToNCj4gPiBzaG9zdC0+ZWhfbm9yZXN1
bWUgaXMgY3VycmVudGx5IGNvbnN1bHRlZCB0d2ljZSBpbiBvbmUgZXJyb3IgaGFuZGxpbmcNCj4g
PiBpdGVyYXRpb246IG9uY2UgYmVmb3JlIHNjc2lfYXV0b3BtX2dldF9ob3N0KCkgYW5kIG9uY2Ug
YWdhaW4gYmVmb3JlDQo+ID4gc2NzaV9hdXRvcG1fcHV0X2hvc3QoKS4NCj4gPg0KPiA+IFRoYXQg
aXMgcmFjeSB3aGVuIGEgUE0tdHJpZ2dlcmVkIGVycm9yIHBhdGggZmxpcHMgc2hvc3QtPmVoX25v
cmVzdW1lDQo+IHdoaWxlDQo+ID4gdGhlIFNDU0kgRUggdGhyZWFkIGlzIHN0aWxsIHJ1bm5pbmcu
DQo+ID4NCj4gPiBUaGUgcHJvYmxlbSBmbG93IGxvb2tzIGxpa2UgdGhpczoNCj4gPiBQTSBwYXRo
DQo+ID4gICB1ZnNoY2Rfc2V0X2Rldl9wd3JfbW9kZSgpDQo+ID4gICAgIHNob3N0LT5laF9ub3Jl
c3VtZSA9IDENCj4gPiAgICAgdWZzaGNkX2V4ZWN1dGVfc3RhcnRfc3RvcCAgPC0tIHRyaWdnZXIg
RUgNCj4gPiAgICAgLi4uDQo+ID4gICAgIHNob3N0LT5laF9ub3Jlc3VtZSA9IDANCj4gPg0KPiA+
IEVIIHBhdGgNCj4gPiAgIHNjc2lfZXJyb3JfaGFuZGxlcigpDQo+ID4gICAgIGlmICghc2hvc3Qt
PmVoX25vcmVzdW1lKQ0KPiA+ICAgICAgIHNjc2lfYXV0b3BtX2dldF9ob3N0KCkgIDwtLSBza2lw
cGVkDQo+ID4gICAgIC4uLg0KPiA+ICAgICBpZiAoIXNob3N0LT5laF9ub3Jlc3VtZSkNCj4gPiAg
ICAgICAgc2NzaV9hdXRvcG1fcHV0X2hvc3QoKSAgPC0tIGV4ZWN1dGVkIGxhdGVyDQo+ID4NCj4g
PiBJbiB0aGF0IGNhc2Ugb25lIEVIIGl0ZXJhdGlvbiBjYW4gc2tpcCBhdXRvcmVzdW1lIG9uIGVu
dHJ5IGFuZCBzdGlsbCBkcm9wIGENCj4gPiBydW50aW1lIFBNIHJlZmVyZW5jZSBvbiBleGl0LiBU
aGF0IGxlYXZlcyBhbiB1bm1hdGNoZWQgcnVudGltZSBQTSBwdXQNCj4gYW5kDQo+ID4gY2FuIHRy
aWdnZXIgYSBydW50aW1lIFBNIHVzYWdlIGNvdW50IHVuZGVyZmxvdy4NCj4gPg0KPiA+IEZpeCB0
aGlzIGJ5IHNuYXBzaG90dGluZyBzaG9zdC0+ZWhfbm9yZXN1bWUgb25jZSBhdCB0aGUgYmVnaW5u
aW5nIG9mDQo+IGVhY2gNCj4gPiBFSCBpdGVyYXRpb24gYW5kIGJ5IGNhbGxpbmcgc2NzaV9hdXRv
cG1fcHV0X2hvc3QoKSBvbmx5IGlmIHRoZSBzYW1lDQo+ID4gaXRlcmF0aW9uIHN1Y2Nlc3NmdWxs
eSBhY3F1aXJlZCBhIHJ1bnRpbWUgUE0gcmVmZXJlbmNlIHRocm91Z2ggdGhlDQo+ID4gc2NzaV9h
dXRvcG1fZ2V0X2hvc3QoKS4NCj4gPg0KPiA+IEZpeGVzOiBhZTA3NTFmZmM3N2UgKCJbU0NTSV0g
YWRkIGZsYWcgdG8gc2tpcCB0aGUgcnVudGltZSBQTSBjYWxscyBvbiB0aGUNCj4gaG9zdCIpDQo+
ID4gU2lnbmVkLW9mZi1ieTogSG9uZ2ppZSBGYW5nIDxob25namllZmFuZ0Bhc3JtaWNyby5jb20+
DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvc2NzaS9zY3NpX2Vycm9yLmMgfCAyMSArKysrKysrKysr
KysrKy0tLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDcgZGVs
ZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfZXJyb3Iu
YyBiL2RyaXZlcnMvc2NzaS9zY3NpX2Vycm9yLmMNCj4gPiBpbmRleCAxNDcxMjdmYjRkYjkuLmQ4
M2JmYTI0ZjE4NCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvc2NzaV9lcnJvci5jDQo+
ID4gKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfZXJyb3IuYw0KPiA+IEBAIC0yMzQyLDYgKzIzNDIs
OCBAQCBzdGF0aWMgdm9pZCBzY3NpX3VuamFtX2hvc3Qoc3RydWN0IFNjc2lfSG9zdA0KPiAqc2hv
c3QpDQo+ID4gIGludCBzY3NpX2Vycm9yX2hhbmRsZXIodm9pZCAqZGF0YSkNCj4gPiAgew0KPiA+
ICAJc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QgPSBkYXRhOw0KPiA+ICsJYm9vbCBhdXRvcG1fZ2V0
Ow0KPiA+ICsJYm9vbCBza2lwX2F1dG9wbTsNCj4gPg0KPiA+ICAJLyoNCj4gPiAgCSAqIFdlIHVz
ZSBUQVNLX0lOVEVSUlVQVElCTEUgc28gdGhhdCB0aGUgdGhyZWFkIGlzIG5vdA0KPiA+IEBAIC0y
MzgzLDEyICsyMzg1LDE3IEBAIGludCBzY3NpX2Vycm9yX2hhbmRsZXIodm9pZCAqZGF0YSkNCj4g
PiAgCQkgKiB3aGF0IHdlIG5lZWQgdG8gZG8gdG8gZ2V0IGl0IHVwIGFuZCBvbmxpbmUgYWdhaW4g
KGlmIHdlDQo+IGNhbikuDQo+ID4gIAkJICogSWYgd2UgZmFpbCwgd2UgZW5kIHVwIHRha2luZyB0
aGUgdGhpbmcgb2ZmbGluZS4NCj4gPiAgCQkgKi8NCj4gPiAtCQlpZiAoIXNob3N0LT5laF9ub3Jl
c3VtZSAmJg0KPiBzY3NpX2F1dG9wbV9nZXRfaG9zdChzaG9zdCkgIT0gMCkgew0KPiA+IC0JCQlT
Q1NJX0xPR19FUlJPUl9SRUNPVkVSWSgxLA0KPiA+IC0JCQkJc2hvc3RfcHJpbnRrKEtFUk5fRVJS
LCBzaG9zdCwNCj4gPiAtCQkJCQkgICAgICJzY3NpX2VoXyVkOiB1bmFibGUgdG8NCj4gYXV0b3Jl
c3VtZVxuIiwNCj4gPiAtCQkJCQkgICAgIHNob3N0LT5ob3N0X25vKSk7DQo+ID4gLQkJCWNvbnRp
bnVlOw0KPiA+ICsJCWF1dG9wbV9nZXQgPSBmYWxzZTsNCj4gPiArCQlza2lwX2F1dG9wbSA9IHNo
b3N0LT5laF9ub3Jlc3VtZTsNCj4gPiArCQlpZiAoIXNraXBfYXV0b3BtKSB7DQo+IA0KPiBTaW5j
ZSB0aGlzIGlzIHRoZSBvbmx5IHBsYWNlIHlvdSB1c2UgdGhlIHNraXBfYXV0b3BtIHZhcmlhYmxl
LCB5b3UgbWF5DQo+IGFzIHdlbGwgbm90IGludHJvZHVjZSBpdCBhdCBhbGwuICBKdXN0IHRlc3Qg
c2hvc3QtPmVoX25vcmVzdW1lIGRpcmVjdGx5Lg0KPiANCj4gQWxhbiBTdGVybg0KPiANCg0KU2tp
cF9hdXRvcG0gaXMgbm90IHJlcXVpcmVkLCBJIHdpbGwgdXBkYXRlIGl0LiANCg0KPiA+ICsJCQlp
ZiAoc2NzaV9hdXRvcG1fZ2V0X2hvc3Qoc2hvc3QpICE9IDApIHsNCj4gPiArCQkJCVNDU0lfTE9H
X0VSUk9SX1JFQ09WRVJZKDEsDQo+ID4gKwkJCQkJc2hvc3RfcHJpbnRrKEtFUk5fRVJSLCBzaG9z
dCwNCj4gPiArCQkJCQkJICAgICAic2NzaV9laF8lZDogdW5hYmxlIHRvDQo+IGF1dG9yZXN1bWVc
biIsDQo+ID4gKwkJCQkJCSAgICAgc2hvc3QtPmhvc3Rfbm8pKTsNCj4gPiArCQkJCWNvbnRpbnVl
Ow0KPiA+ICsJCQl9DQo+ID4gKwkJCWF1dG9wbV9nZXQgPSB0cnVlOw0KPiA+ICAJCX0NCj4gPg0K
PiA+ICAJCWlmIChzaG9zdC0+dHJhbnNwb3J0dC0+ZWhfc3RyYXRlZ3lfaGFuZGxlcikNCj4gPiBA
QCAtMjQwNyw3ICsyNDE0LDcgQEAgaW50IHNjc2lfZXJyb3JfaGFuZGxlcih2b2lkICpkYXRhKQ0K
PiA+ICAJCSAqIHdoaWNoIGFyZSBzdGlsbCBvbmxpbmUuDQo+ID4gIAkJICovDQo+ID4gIAkJc2Nz
aV9yZXN0YXJ0X29wZXJhdGlvbnMoc2hvc3QpOw0KPiA+IC0JCWlmICghc2hvc3QtPmVoX25vcmVz
dW1lKQ0KPiA+ICsJCWlmIChhdXRvcG1fZ2V0KQ0KPiA+ICAJCQlzY3NpX2F1dG9wbV9wdXRfaG9z
dChzaG9zdCk7DQo+ID4gIAl9DQo+ID4gIAlfX3NldF9jdXJyZW50X3N0YXRlKFRBU0tfUlVOTklO
Ryk7DQo+ID4gLS0NCj4gPiAyLjI1LjENCj4gPg0KDQpCZXN0Lg0K
