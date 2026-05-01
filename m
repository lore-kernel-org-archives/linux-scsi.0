Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72EA3921D8;
	Fri,  1 May 2026 12:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777640050; cv=none; b=U/sRXvV4RSRQGCzhzhjKsit/aB0JJwkkzoXJmt3yy8W9NVzjsc4PX/RQW5yEinZYRvQpSnhQsgWsW8mp/WqRU0Akq1MYvM0DGUYgFxwB8vDdUxTLKKrYimSAZ8RdPB9+JA1gz7OFgFROtvNE9pxup/eUwwN/5HCnMNt++sDioCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777640050; c=relaxed/simple;
	bh=QVKDAzoQViTfrhogX9yehRfdlLX2M5oovOO97em8QeI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TbIPWLeYl1401FKPGX2t/Upl3TMRi2GFuMv7rns3HTOx2alvuLJCLuFI4CY7Jn5FmRB7KNMw4dSHNGBPmzJtrBaG3oNLO+i6mXLZ1kGd6HuJc/+oIhicBaJWYqIrOcMZ56zE/8d6gnXunrKcxG30URq5azSy7ZJmfL04JMrUS54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch03.asrmicro.com (exch03.asrmicro.com [10.1.24.118])
	by spam.asrmicro.com with ESMTPS id 641CrEAQ063989
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Fri, 1 May 2026 20:53:14 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch03.asrmicro.com
 (10.1.24.118) with Microsoft SMTP Server (TLS) id 15.0.847.32; Fri, 1 May
 2026 20:53:19 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Fri, 1 May 2026 20:53:19 +0800
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
Subject: RE: [PATCH v3] scsi: ufs: core: call hibern8 notify when hibern8
 cmd failed
Thread-Topic: [PATCH v3] scsi: ufs: core: call hibern8 notify when hibern8
 cmd failed
Thread-Index: AQHc2Mck4hiMRbEbWEeHWuWIforbC7X5H8NA
Date: Fri, 1 May 2026 12:53:18 +0000
Message-ID: <0929fb5c93ce47e28e44f15c22cb8e99@exch02.asrmicro.com>
References: <20260430042212.3712251-1-hongjiefang@asrmicro.com>
 <26d908a7-8f95-4f73-b2bf-78923e55b3e8@acm.org>
In-Reply-To: <26d908a7-8f95-4f73-b2bf-78923e55b3e8@acm.org>
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
X-MAIL:spam.asrmicro.com 641CrEAQ063989

PiBGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgW21haWx0bzpidmFuYXNzY2hlQGFjbS5vcmddDQo+IFNl
bnQ6IEZyaWRheSwgTWF5IDEsIDIwMjYgMTozMSBBTQ0KPiBUbzogRmFuZyBIb25namllICA8aG9u
Z2ppZWZhbmdAYXNybWljcm8uY29tPjsNCj4gYWxpbS5ha2h0YXJAc2Ftc3VuZy5jb207IGF2cmku
YWx0bWFuQHdkYy5jb207DQo+IEphbWVzLkJvdHRvbWxleUBIYW5zZW5QYXJ0bmVyc2hpcC5jb207
IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tDQo+IENjOiBsaW51eC1zY3NpQHZnZXIua2VybmVs
Lm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IHYzXSBzY3NpOiB1ZnM6IGNvcmU6IGNhbGwgaGliZXJuOCBub3RpZnkgd2hlbiBoaWJlcm44IGNt
ZA0KPiBmYWlsZWQNCj4gDQo+IE9uIDQvMjkvMjYgOToyMiBQTSwgSG9uZ2ppZSBGYW5nIHdyb3Rl
Og0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3Vmcy91ZnNoY2QuaCBiL2luY2x1ZGUvdWZzL3Vm
c2hjZC5oDQo+ID4gaW5kZXggODU2M2I2NjQ4OTc2Li40ZjdjNjE5ZGIzMjQgMTAwNjQ0DQo+ID4g
LS0tIGEvaW5jbHVkZS91ZnMvdWZzaGNkLmgNCj4gPiArKysgYi9pbmNsdWRlL3Vmcy91ZnNoY2Qu
aA0KPiA+IEBAIC0yNzAsNiArMjcwLDcgQEAgc3RydWN0IHVmc19jbGtfaW5mbyB7DQo+ID4gICBl
bnVtIHVmc19ub3RpZnlfY2hhbmdlX3N0YXR1cyB7DQo+ID4gICAJUFJFX0NIQU5HRSwNCj4gPiAg
IAlQT1NUX0NIQU5HRSwNCj4gPiArCVJPTExCQUNLX0NIQU5HRSwNCj4gPiAgIH07DQo+ID4NCj4g
PiAgIHN0cnVjdCB1ZnNfcGFfbGF5ZXJfYXR0ciB7DQo+IA0KPiBUaGlzIGxvb2tzIGJldHRlciB0
byBtZSBidXQgdHJpZ2dlcnMgY29tcGlsZXIgd2FybmluZ3M6DQo+IA0KPiBkcml2ZXJzL3Vmcy9o
b3N0L3Vmcy1leHlub3MuYzoxNjE0OjEwOiBlcnJvcjogZW51bWVyYXRpb24gdmFsdWUNCj4gJ1JP
TExCQUNLX0NIQU5HRScgbm90IGhhbmRsZWQgaW4gc3dpdGNoIFstV2Vycm9yLC1Xc3dpdGNoXQ0K
PiAgIDE2MTQgfCAgICAgICAgIHN3aXRjaCAoc3RhdHVzKSB7DQo+ICAgICAgICB8ICAgICAgICAg
ICAgICAgICBefn5+fn4NCj4gZHJpdmVycy91ZnMvaG9zdC91ZnMtZXh5bm9zLmM6MTY1NDoxMDog
ZXJyb3I6IGVudW1lcmF0aW9uIHZhbHVlDQo+ICdST0xMQkFDS19DSEFOR0UnIG5vdCBoYW5kbGVk
IGluIHN3aXRjaCBbLVdlcnJvciwtV3N3aXRjaF0NCj4gICAxNjU0IHwgICAgICAgICBzd2l0Y2gg
KHN0YXR1cykgew0KPiAgICAgICAgfCAgICAgICAgICAgICAgICAgXn5+fn5+DQo+IGRyaXZlcnMv
dWZzL2hvc3QvdWZzLWV4eW5vcy5jOjE2ODc6MTA6IGVycm9yOiBlbnVtZXJhdGlvbiB2YWx1ZQ0K
PiAnUk9MTEJBQ0tfQ0hBTkdFJyBub3QgaGFuZGxlZCBpbiBzd2l0Y2ggWy1XZXJyb3IsLVdzd2l0
Y2hdDQo+ICAgMTY4NyB8ICAgICAgICAgc3dpdGNoIChzdGF0dXMpIHsNCj4gICAgICAgIHwgICAg
ICAgICAgICAgICAgIF5+fn5+fg0KPiANCj4gVGhlc2Ugd2FybmluZ3MgY2FuIGJlIHJlcHJvZHVj
ZWQgb24gYW55IExpbnV4IGRldmVsb3BtZW50IHN5c3RlbSBieQ0KPiBpbnN0YWxsaW5nIENsYW5n
IGFuZCBieSBydW5uaW5nIHRoZSBmb2xsb3dpbmcgY29tbWFuZDoNCj4gDQo+IGJ1aWxkLXNjc2kt
ZHJpdmVycyAtYw0KPiANCj4gU2VlIGFsc28gaHR0cHM6Ly9naXRodWIuY29tL2J2YW5hc3NjaGUv
YnVpbGQtc2NzaS1kcml2ZXJzDQo+IA0KDQpPa2F5LCBJIHdpbGwgZml4IGFuZCB1cGRhdGUgaXQu
DQoNCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KQmVzdC4NCg==
