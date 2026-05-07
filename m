Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCE7363C73;
	Thu,  7 May 2026 12:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778155637; cv=none; b=PDdPGEU9/bzN9tswjM92cwstmqIukheCdSdoFdyBCuuyXeLsX26ipSjKNc4Mkr7OfKQ9lKFLHhYFij7vb6Xa+qUEFsT0pU8abyB40UwMAVT9jCFItgppCV8mnL+78ZBBB3L3SUKZXbLHAJ9LmBMT4IhQ1mNWtG+eKKdcE9/wl5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778155637; c=relaxed/simple;
	bh=Vj8GfuD44c2OofLT407RkIPeHJr/xRj0cikaZ2vXvaM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UWsKnKcIoRv1rs8oPS0WxpNjMOM+MOkWgJm5CwslvNd8XzdSQHuhPxW8Kf+q31Vz95mhqiNtdFHwOgFP6f+3Gjn+GuFcrodSKmQjifb1uKHsQpeQfzcR1SKopWpHCYQpUV9rUZnnIMjZBqrURxCLLdSjxS08cjJoSyQaC+XKvy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch03.asrmicro.com (exch03.asrmicro.com [10.1.24.118])
	by spam.asrmicro.com with ESMTPS id 647C6FBx011356
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Thu, 7 May 2026 20:06:15 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch03.asrmicro.com
 (10.1.24.118) with Microsoft SMTP Server (TLS) id 15.0.847.32; Thu, 7 May
 2026 20:06:20 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Thu, 7 May 2026 20:06:19 +0800
From: =?utf-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= <hongjiefang@asrmicro.com>
To: Bean Huo <beanhuo@iokpp.de>, Bart Van Assche <bvanassche@acm.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com"
	<avri.altman@wdc.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>
Subject: RE: [PATCH v5] scsi: ufs: core: call hibern8 notify when hibern8
 cmd failed
Thread-Topic: [PATCH v5] scsi: ufs: core: call hibern8 notify when hibern8
 cmd failed
Thread-Index: AQHc3Fofud/MF+W+vEKD4imTEpLr3LYAVKsA///WjYCAAAfnAIAAOhEAgAILMrA=
Date: Thu, 7 May 2026 12:06:18 +0000
Message-ID: <de0673010f31419bafb1657e4f3a5dd0@exch02.asrmicro.com>
References: <20260502143012.2859480-1-hongjiefang@asrmicro.com>
	 <897db8bf4c82af97cd7bbb2b908bb9e2654b3103.camel@iokpp.de>
	 <67965bf50abc4300ac9bd3aced2f18d8@exch02.asrmicro.com>
	 <a349ab70dbed9355785bec38c7e05658f3c948a6.camel@iokpp.de>
	 <619d81fe-1db1-41b6-b9b2-a2546a030881@acm.org>
 <28d21b7e89f72aec8962aec75a6cddb5f8a2b714.camel@iokpp.de>
In-Reply-To: <28d21b7e89f72aec8962aec75a6cddb5f8a2b714.camel@iokpp.de>
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
X-MAIL:spam.asrmicro.com 647C6FBx011356

DQo+IEZyb206IEJlYW4gSHVvIFttYWlsdG86YmVhbmh1b0Bpb2twcC5kZV0NCj4gU2VudDogV2Vk
bmVzZGF5LCBNYXkgNiwgMjAyNiA4OjQ0IFBNDQo+IFRvOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5h
c3NjaGVAYWNtLm9yZz47IEZhbmcgSG9uZ2ppZSjmlrnmtKrmnbApDQo+IDxob25namllZmFuZ0Bh
c3JtaWNyby5jb20+OyBhbGltLmFraHRhckBzYW1zdW5nLmNvbTsNCj4gYXZyaS5hbHRtYW5Ad2Rj
LmNvbTsgSmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbTsNCj4gbWFydGluLnBl
dGVyc2VuQG9yYWNsZS5jb20NCj4gQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBjYW4uZ3VvQG9zcy5xdWFsY29tbS5jb20NCj4g
U3ViamVjdDogUmU6IFtQQVRDSCB2NV0gc2NzaTogdWZzOiBjb3JlOiBjYWxsIGhpYmVybjggbm90
aWZ5IHdoZW4gaGliZXJuOCBjbWQNCj4gZmFpbGVkDQo+IA0KPiBPbiBXZWQsIDIwMjYtMDUtMDYg
YXQgMTE6MTYgKzAyMDAsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBPbiA1LzYvMjYgMTA6
NDcgQU0sIEJlYW4gSHVvIHdyb3RlOg0KPiA+ID4gVGhhbmtzIGZvciB0aGUgZXhwbGFuYXRpb24u
IEhvd2V2ZXIsIHRoZSBrZXJuZWwgZGV2ZWxvcG1lbnQgcHJhY3RpY2UgaXMNCj4gdG8NCj4gPiA+
IG5vdA0KPiA+ID4gbWVyZ2UgaW5mcmFzdHJ1Y3R1cmUgd2l0aG91dCBhdCBsZWFzdCBvbmUgaW4t
dHJlZSB1c2VyLiBQbGVhc2UgcmVzdWJtaXQNCj4gdGhpcw0KPiA+ID4gcGF0Y2ggdG9nZXRoZXIg
d2l0aCB5b3VyIHBsYXRmb3JtIGRyaXZlciAob3IgYXQgbGVhc3QgdGhlIGhpYmVybjhfbm90aWZ5
DQo+ID4gPiBjYWxsYmFjayB0aGF0IGhhbmRsZXMgUk9MTEJBQ0tfQ0hBTkdFKSBzbyByZXZpZXdl
cnMgY2FuIHZlcmlmeSB0aGUNCj4gZGVzaWduIGlzDQo+ID4gPiBjb3JyZWN0IGFuZCBhY3R1YWxs
eSB3b3JrcyBhcyBpbnRlbmRlZC4NCj4gPiA+DQo+ID4gPiBAQmFydCwgYW55IGlkZWE/DQo+ID4N
Cj4gPiBFdmVyeW9uZSB3aG8gd29ya3Mgb24gQW5kcm9pZCBzbWFydHBob25lcyBoYXMgdG8gZGVh
bCB3aXRoIHRoZQ0KPiBmb2xsb3dpbmc6DQo+ID4gLSBUaGUgdXBzdHJlYW0tZmlyc3QgcG9saWN5
Lg0KPiA+IC0gTm90IGRpc2Nsb3NpbmcgYW55IGFzcGVjdCBvZiB0aGUgcGhvbmUgdW5kZXIgZGV2
ZWxvcG1lbnQgdW50aWwgaXQgaGFzDQo+ID4gwqDCoCBiZWVuIGFubm91bmNlZCBwdWJsaWNseS4N
Cj4gPg0KPiA+IFR5cGljYWxseSB0d28geWVhcnMgZWxhcHNlIGJldHdlZW4gdGhlIHN0YXJ0IG9m
IHRlc3Rpbmcga2VybmVsIGNvZGUgZm9yDQo+ID4gYSBuZXcgcGhvbmUgYW5kIHB1YmxpYyBhbm5v
dW5jZW1lbnQuIEFub3RoZXIgMSAtIDQgeWVhcnMgZWxhcHNlIGFmdGVyDQo+ID4gYSBwaG9uZSBo
YXMgYmVlbiBhbm5vdW5jZWQgdW50aWwgYWxsIGtlcm5lbCBjb2RlIGZvciBhIHNtYXJ0cGhvbmUg
aXMNCj4gPiB1cHN0cmVhbS4gSW5zaXN0aW5nIG9uIG5vdCBtZXJnaW5nIGFueSBjb2RlIHVwc3Ry
ZWFtIHVudGlsIGEgdXNlciBmb3INCj4gPiB0aGUgY29kZSBpcyB1cHN0cmVhbSBtYWtlcyB0aGUg
am9iIG9mIHNtYXJ0cGhvbmUga2VybmVsIGRldmVsb3BlcnMNCj4gPiBoYXJkZXIgdGhhbiBuZWNl
c3NhcnkuDQo+ID4NCj4gPiBUaGlzIGlzIHdoeSBJJ20gZmluZSB3aXRoIGRldmlhdGluZyBmcm9t
IHRoZSBydWxlIGV4cGxhaW5lZCBpbiB5b3VyDQo+ID4gZW1haWwgZm9yIHNtYWxsIGNoYW5nZXMu
DQo+ID4NCj4gPiBUaGFua3MsDQo+ID4NCj4gPiBCYXJ0Lg0KPiANCj4gDQo+IFRoYW5rcyBCYXJ0
Lg0KPiANCj4gDQo+IEBGYW5nIEhvbmdqaWUsDQo+IA0KPiBJIHJlc3BlY3QgdGhlIHByYWN0aWNh
bCBjb25zdHJhaW50cyBCYXJ0IGRlc2NyaWJlZCwgYnV0IG15IGNvbmNlcm4gaXMgYWJvdXQNCj4g
ZGVzaWduIHZhbGlkYXRpb24sIG5vdCBkaXNjbG9zdXJlLiBDb3VsZCB5b3UgYXQgbGVhc3Qgc2hv
dyBhIG1pbmltYWwNCj4gaGliZXJuOF9ub3RpZnkgaGFuZGxlciB0aGF0IHVzZXMgUk9MTEJBQ0tf
Q0hBTkdFPw0KPiANCj4gSXQgZG9lc24ndCBuZWVkIHRvIGJlIHRoZSBmdWxsIHBsYXRmb3JtIGRy
aXZlciwganVzdCBlbm91Z2ggdG8gZGVtb25zdHJhdGUNCj4gd2hhdA0KPiAicm9sbGJhY2siIG1l
YW5zIGNvbmNyZXRlbHkgKGUuZy4sIHVuZG8gY2xvY2sgZ2F0aW5nLCByZXN0b3JlIFBIWSBzdGF0
ZSwgZXRjLikuDQo+IFdpdGhvdXQgdGhhdCwgd2UncmUgbWVyZ2luZyBhbiBBUEkgd2hvc2Ugc2Vt
YW50aWNzIGFyZSB1bnZlcmlmaWFibGUuDQo+IA0KPiBFc3BlY2lhbGx5LCBvdGhlciB2ZW5kb3Jz
IChTUywgUWNvbSwgTVRLLCBldGMuKSBzaG91bGQgYmUgYWJsZSB0byBzZWUgdGhlDQo+IGRpcmVj
dGlvbiBhbmQgdW5kZXJzdGFuZCB3aGV0aGVyIHRoZXkgYWxzbyBuZWVkIHRvIGhhbmRsZQ0KPiBS
T0xMQkFDS19DSEFOR0UgaW4NCj4gdGhlaXIgb3duIGhpYmVybjhfbm90aWZ5IGNhbGxiYWNrcy4N
Cj4gDQo+IE90aGVyd2lzZSwgcGxlYXNlIGluY2x1ZGUgdGhpcyBwYXRjaCBhcyBwYXJ0IG9mIHlv
dXIgcGxhdGZvcm0gZHJpdmVyIHBhdGNoDQo+IHNlcmllcyB3aGVuIHlvdSBzdWJtaXQgaXQsIHNv
IHJldmlld2VycyBjYW4gZXZhbHVhdGUgdGhlIGluZnJhc3RydWN0dXJlIGFuZA0KPiBpdHMgY29u
c3VtZXIgdG9nZXRoZXIuDQo+IA0KDQpXZSBoYXZlIGRpc2NvdmVyZWQgdGhhdCBvbiBvdXIgbmV3
IHBsYXRmb3JtLCB0aGUgVUlDIGVycm9yIGludGVycnVwdCBtdXN0IGJlDQp0ZW1wb3JhcmlseSBk
aXNhYmxlZCB3aGVuIGVudGVyaW5nIG9yIGV4aXRpbmcgaGliZXJuODsgb3RoZXJ3aXNlLA0KaXQg
d2lsbCBpbnRlcmZlcmUgd2l0aCB0aGUgZXhlY3V0aW9uIG9mIHRoZSBoaWJlcm44IGNvbW1hbmQg
aXRzZWxmLg0KT2YgY291cnNlLCB0aGlzIGlzIG1lcmVseSBhIHNwZWNpZmljIGNvcm5lci1jYXNl
IGxpbWl0YXRpb24gaW4gdGhlIGNvbnRyb2xsZXINCmRlc2lnbiBhbmQgaGFzIG5vIGltcGFjdCBv
biBkYXRhIHRyYW5zbWlzc2lvbi4gRHVlIHRvIHRoaXMgbGltaXRhdGlvbiwgDQp0aGUgVUlDIGVy
cm9yIG11c3QgYmUgcmUtZW5hYmxlZCByZWdhcmRsZXNzIG9mIHdoZXRoZXIgdGhlIGhpYmVybjgg
Y29tbWFuZA0KZXhlY3V0ZXMgc3VjY2Vzc2Z1bGx5LCBhcyBmYWlsdXJlIHRvIGRvIHNvIHdpbGwg
YWZmZWN0IHRoZSBtb25pdG9yaW5nIG9mIHRoZQ0KYWN0dWFsIFVJQyBlcnJvcnMgZHVyaW5nIHN1
YnNlcXVlbnQgZGF0YSB0cmFuc21pc3Npb24uDQoNCg0KPiBLaW5kIFJlZ2FyZHMsDQo+IEJlYW4N
Cg0KDQpCZXN0Lg0KDQo=
