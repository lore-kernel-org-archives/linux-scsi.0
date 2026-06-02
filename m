Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441E62AE7A;
	Tue,  2 Jun 2026 05:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780378015; cv=none; b=r3nBM9Y6A9rFFCOaEpMV9j84pFD2NOlerK4PNTZoubL6pyAhLNS95z3aAikQ1xy7ySd9Qe2Y5zgZLUwbPpKbXhkrfN8hddaiKRrJG+6cD2rIY9MeTvS1STp1pY3VR0nDroFWpNf3YZltP4NZi9/VKjFvho+TzFen1yvYsVIwd/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780378015; c=relaxed/simple;
	bh=Zdymhpl8nPYHAHZYbXbh8+0tETiEwy6yteQJYTzX1RE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IBqRT5TzNCOyK0k2YlUKTcWwCe947wpaEOYC8pEFuWVlL3Cn8E6K5qtASSPpCqEyp5bBcKQxycYc9Ix9J0lsMrqihzFo+tImSuXarcv73TarbaFq3Q/PxX6aOUUS+7JbkKll/9s6WFxLtE9TYib4E2bJfFrOPYF5H+6vVnWN5LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch01.asrmicro.com (exch01.asrmicro.com [10.1.24.121])
	by spam.asrmicro.com with ESMTPS id 6525PsPf043879
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Tue, 2 Jun 2026 13:25:54 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch01.asrmicro.com
 (10.1.24.121) with Microsoft SMTP Server (TLS) id 15.0.847.32; Tue, 2 Jun
 2026 13:25:56 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Tue, 2 Jun 2026 13:25:56 +0800
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
Subject: RE: [PATCH v3] scsi: ufs: core: handle PM SSU timeout before SCSI EH
Thread-Topic: [PATCH v3] scsi: ufs: core: handle PM SSU timeout before SCSI
 EH
Thread-Index: AQHc8e30kTD4w00lK0W0zHRuj40B8rYqu1xA
Date: Tue, 2 Jun 2026 05:25:56 +0000
Message-ID: <09e266caba584fc488029a6bcd951777@exch02.asrmicro.com>
References: <20260601045658.1232848-1-hongjiefang@asrmicro.com>
 <27613670-be13-4923-ae6a-f9a32f1a053b@acm.org>
In-Reply-To: <27613670-be13-4923-ae6a-f9a32f1a053b@acm.org>
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
X-MAIL:spam.asrmicro.com 6525PsPf043879

DQo+IEZyb206IEJhcnQgVmFuIEFzc2NoZSBbbWFpbHRvOmJ2YW5hc3NjaGVAYWNtLm9yZ10NCj4g
U2VudDogVHVlc2RheSwgSnVuZSAyLCAyMDI2IDE6NDIgQU0NCj4gVG86IEZhbmcgSG9uZ2ppZSjm
lrnmtKrmnbApIDxob25namllZmFuZ0Bhc3JtaWNyby5jb20+Ow0KPiBhbGltLmFraHRhckBzYW1z
dW5nLmNvbTsgYXZyaS5hbHRtYW5Ad2RjLmNvbTsNCj4gSmFtZXMuQm90dG9tbGV5QEhhbnNlblBh
cnRuZXJzaGlwLmNvbTsgbWFydGluLnBldGVyc2VuQG9yYWNsZS5jb207DQo+IHBldGVyLndhbmdA
bWVkaWF0ZWsuY29tOyBiZWFuaHVvQG1pY3Jvbi5jb20NCj4gQ2M6IGxpbnV4LXNjc2lAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjNdIHNjc2k6IHVmczogY29yZTogaGFuZGxlIFBNIFNTVSB0aW1lb3V0IGJlZm9yZSBT
Q1NJDQo+IEVIDQo+IA0KPiBPbiA1LzMxLzI2IDk6NTYgUE0sIEhvbmdqaWUgRmFuZyB3cm90ZToN
Cj4gPiBAQCAtOTQ2Niw3ICs5NDk5LDcgQEAgc3RhdGljIGVudW0gc2NzaV90aW1lb3V0X2FjdGlv
bg0KPiB1ZnNoY2RfZWhfdGltZWRfb3V0KHN0cnVjdCBzY3NpX2NtbmQgKnNjbWQpDQo+ID4gICB7
DQo+ID4gICAJc3RydWN0IHVmc19oYmEgKmhiYSA9IHNob3N0X3ByaXYoc2NtZC0+ZGV2aWNlLT5o
b3N0KTsNCj4gPg0KPiA+IC0JaWYgKCFoYmEtPnN5c3RlbV9zdXNwZW5kaW5nKSB7DQo+ID4gKwlp
ZiAoIWhiYS0+cG1fb3BfaW5fcHJvZ3Jlc3MgfHwgIXVmc2hjZF9pc19zY3NpX2NtZChzY21kKSkg
ew0KPiA+ICAgCQkvKiBBY3RpdmF0ZSB0aGUgZXJyb3IgaGFuZGxlciBpbiB0aGUgU0NTSSBjb3Jl
LiAqLw0KPiA+ICAgCQlyZXR1cm4gU0NTSV9FSF9OT1RfSEFORExFRDsNCj4gPiAgIAl9DQo+IA0K
PiBJIHRoaW5rIHdlIHdhbnQgdG8gYXZvaWQgU0NTSSBlcnJvciBoYW5kbGVyIGFjdGl2YXRpb24g
Zm9yIGFsbCBjb21tYW5kcw0KPiB0aGF0IHRpbWUgb3V0IHdoaWxlIGEgcG93ZXIgbWFuYWdlbWVu
dCBvcGVyYXRpb24gaXMgaW4gcHJvZ3Jlc3MsDQo+IGluY2x1ZGluZyBkZXZpY2UgbWFuYWdlbWVu
dCBjb21tYW5kcy4NCj4gDQo+IFBsZWFzZSBjb25zaWRlciBjb21wbGV0aW5nIGNvbW1hbmRzIGZy
b20gaW5zaWRlIHRoZSB0aW1lb3V0IGhhbmRsZXINCj4gaW5zdGVhZCBvZiBhZGRpbmcgZm9yY2Vf
Y29tcGwgc3VwcG9ydCBmb3IgdGhlIGxlZ2FjeSBzaW5nbGUgZG9vcmJlbGwNCj4gbW9kZS4gVGhl
IHZlcnkgbGlnaHRseSB0ZXN0ZWQgcGF0Y2ggYmVsb3cgc2hvdWxkIHJlYWxpemUgdGhpcy4NCj4g
DQoNClRoYW5rcywgdGhpcyBtYWtlcyBzZW5zZS4NCkkgd2lsbCByZXdvcmsgdGhlIHBhdGNoIGlu
IHRoYXQgZGlyZWN0aW9uIGZvciB2NC4gSXQgd2lsbCB1c2UNCmhiYS0+cG1fb3BfaW5fcHJvZ3Jl
c3MgZm9yIGFsbCBQTSB0aW1lb3V0IGNvbW1hbmRzIGFuZCBubyBsb25nZXINCnJlbGF5IG9uIHRo
ZSBleHRyYSBsZWdhY3kgc2luZ2xlLWRvb3JiZWxsIGZvcmNlLWNvbXBsZXRpb24gcGF0aC4NCg0K
Rm9yIHJlZ3VsYXIgU0NTSSBjb21tYW5kcyBpdCByZWxlYXNlcyB0aGUgU0NTSSBjb21tYW5kIHJl
c291cmNlcyBiZWZvcmUNCnNjc2lfZG9uZSgpLiBGb3IgaW50ZXJuYWwgZGV2aWNlLW1hbmFnZW1l
bnQgY29tbWFuZHMgaXQgb25seQ0KY29tcGxldGVzIHRoZSByZXF1ZXN0LCBzaW5jZSB0aG9zZSBj
b21tYW5kcyBkbyBub3QgdXNlIHRoZQ0KdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoKSBsaWZldGlt
ZSBydWxlcy4NCg0KDQoNCkJlc3QuDQoNCg==
