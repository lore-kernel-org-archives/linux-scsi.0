Received: from outbound.baidu.com (mx16.baidu.com [111.202.115.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D6E21B905;
	Thu, 30 Jul 2026 03:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785383593; cv=none; b=m93ketXqwL04ry+y8PPTGc0vgj5XQXfv/WvJpTxSekt0z7IVSalr7iGhXMUKl7lwXoUfZvuGPf4/Ug2iwl5pT1x2j8EiAQeXMHYPYq8VocxFe19XcDwP1sm9r4PzfZdxIprlRHaPhYtJKh+3aRmkGALaqI6Th9ysrKcEmctksS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785383593; c=relaxed/simple;
	bh=RLZ6zKZw5mwAKScLmy5admfnsoSWI3anVJ5hFG9sHvo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M/lSObssDQUhn5jN1GDN7B/AhUwy+z1mQsIlieRaHqwbpcZHaE6y2ufBq9KSN64Asw5QmjtZ4HKkIcVMC2+k3itGWkPcjYG8FHd1Vjt5lFpIGjEFQ1SzxlqBpKvF4JNxpbyHd/As8iqeZmTf5pZCVhTQfNWKyobhJq1ARrdGIcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=eY4Oj2H0; arc=none smtp.client-ip=111.202.115.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="eY4Oj2H0"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.48
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>, Sreekanth Reddy
	<sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, Ranjan Kumar
	<ranjan.kumar@broadcom.com>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, "MPT-FusionLinux.pdl@broadcom.com"
	<MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBzY3NpOiBtcHQzc2FzOiBmaXggaW52YWxpZCBrZnJl?=
 =?gb2312?Q?e_of_embedded_event=5Fdata_in_event_callback?=
Thread-Topic: [PATCH] scsi: mpt3sas: fix invalid kfree of embedded event_data
 in event callback
Thread-Index: AQHdDQ3qhcMnoM/vokyTlO75m80Lm7aFkvJw
Date: Thu, 30 Jul 2026 03:50:50 +0000
Message-ID: <5a93a696e52a4ae9b660abc51b7aef65@baidu.com>
References: <20260706060840.2287-1-lirongqing@baidu.com>
In-Reply-To: <20260706060840.2287-1-lirongqing@baidu.com>
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
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1785383454;
	bh=RLZ6zKZw5mwAKScLmy5admfnsoSWI3anVJ5hFG9sHvo=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=eY4Oj2H0/LxwxXoM9RFQxM6oWTJweMWUHl3TC4NYQENp9VhGI6fJI5r0FDBTrInJn
	 orIQqBCn1Rd3OvIkoYbjchxJBWiNZY4eCBHdfg2G6iQnBFVdHL4C8eHZxhkcVvDatA
	 l0IwWA5r7oWZYCuVd1h8bztX/P+KC9VS3wt5zA5sjrWhYOAijNqkbV0ohMp1N9A7gD
	 BcgayEhfsESo584lPZZU1EB/6y/tYekTaqMK483+nyX3+/Fq8I8TRCCGmzzbvqHz3G
	 blTcMJVaJdVuQX0s01dGAtkhrWnKew5qQWaYQK4eG5fcWesul+3uk/lgHjGDy+u5+N
	 aMB4qo3rlDiZQ==

DQoNCj4gDQo+IEZyb206IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gDQo+
IGZ3X2V2ZW50LT5ldmVudF9kYXRhIGlzIGEgZmxleGlibGUgYXJyYXkgbWVtYmVyIGVtYmVkZGVk
IHdpdGhpbiB0aGUNCj4gZndfZXZlbnRfd29yayBzdHJ1Y3R1cmUgKGFsbG9jYXRlZCBhcyBhIHNp
bmdsZSBremFsbG9jKS4gQ2FsbGluZw0KPiBrZnJlZShmd19ldmVudC0+ZXZlbnRfZGF0YSkgb24g
aXQgaXMgaW52YWxpZCBhbmQgY2FuIGNvcnJ1cHQgdGhlIGhlYXAsIHNpbmNlIGl0DQo+IGlzIG5v
dCBhIHNlcGFyYXRlbHkgYWxsb2NhdGVkIHBvaW50ZXIuDQo+IA0KPiBUaGUgc3Vic2VxdWVudCBm
d19ldmVudF93b3JrX3B1dCgpIHdpbGwgZGVjcmVtZW50IHRoZSByZWZjb3VudCB0byB6ZXJvDQo+
IGFuZCBjYWxsIGZ3X2V2ZW50X3dvcmtfZnJlZSgpLCB3aGljaCBmcmVlcyB0aGUgZW50aXJlIGZ3
X2V2ZW50X3dvcmsNCj4gc3RydWN0dXJlIChpbmNsdWRpbmcgdGhlIGVtYmVkZGVkIGV2ZW50X2Rh
dGEpLiBUaGUgZXh0cmEga2ZyZWUoKSBpcyB0aGVyZWZvcmUNCj4gYm90aCB3cm9uZyBhbmQgcmVk
dW5kYW50Lg0KPiANCj4gUmVtb3ZlIHRoZSBlcnJvbmVvdXMga2ZyZWUoZndfZXZlbnQtPmV2ZW50
X2RhdGEpIGNhbGwgaW4gdGhlDQo+IE1QSTJfRVZFTlRfU0FTX1RPUE9MT0dZX0NIQU5HRV9MSVNU
IGVycm9yIHBhdGguIFRoZSBQQ0lFIHRvcG9sb2d5DQo+IGNoYW5nZSBsaXN0IGhhbmRsZXIgYWxy
ZWFkeSBoYW5kbGVzIHRoaXMgY29ycmVjdGx5IHdpdGhvdXQgdGhlIGV4dHJhIGtmcmVlLg0KPiAN
Cj4gRml4ZXM6IGFkNTk1NzE5MzEwNzJlNmYgKCJzY3NpOiBtcHQzc2FzOiBBZGQgZmlybXdhcmUg
ZXZlbnQgcmVxdWV1ZQ0KPiBzdXBwb3J0IGZvciBidXN5IGRldmljZXMiKQ0KPiBTaWduZWQtb2Zm
LWJ5OiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQoNClBpbmcNCg0KW0xpLFJv
bmdxaW5nXSANCg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19zY3Np
aC5jIHwgMSAtDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfc2NzaWguYw0KPiBiL2RyaXZlcnMv
c2NzaS9tcHQzc2FzL21wdDNzYXNfc2NzaWguYw0KPiBpbmRleCAxMmNhZmZlLi5jYTAxYTQ5IDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvbXB0M3Nhcy9tcHQzc2FzX3Njc2loLmMNCj4gKysr
IGIvZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19zY3NpaC5jDQo+IEBAIC0xMjI2Nyw3ICsx
MjI2Nyw2IEBAIG1wdDNzYXNfc2NzaWhfZXZlbnRfY2FsbGJhY2soc3RydWN0DQo+IE1QVDNTQVNf
QURBUFRFUiAqaW9jLCB1OCBtc2l4X2luZGV4LA0KPiAgCQlpZiAoIWZ3X2V2ZW50LT5yZXRyaWVz
KSB7DQo+IA0KPiAgCQkJaW9jX2Vycihpb2MsICJmYWlsdXJlIGF0ICVzOiVkLyVzKCkhXG4iLCAg
X19GSUxFX18sIF9fTElORV9fLA0KPiBfX2Z1bmNfXyk7DQo+IC0JCQlrZnJlZShmd19ldmVudC0+
ZXZlbnRfZGF0YSk7DQo+ICAJCQlmd19ldmVudF93b3JrX3B1dChmd19ldmVudCk7DQo+ICAJCQly
ZXR1cm4gMTsNCj4gIAkJfQ0KPiAtLQ0KPiAyLjkuNA0KDQo=
