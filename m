Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C62A188CC9;
	Wed,  3 Jun 2026 05:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780463867; cv=none; b=GHA0olZBzWA4CqgqmpRogOYFqL9N9uW4UkYHXjdkGMX+JgUXO/2rQ3s4isAs5BBwgQ8asSR9gX75BVXA94aud6UDO2kTbgxIg08Uwpk9R4L3vVFxa3eDrTVZQLJyKxWnXro8fMPc4+yDlz/mcs1Uwyl2uPL1TfAixTsf0uoe33o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780463867; c=relaxed/simple;
	bh=n27OX+Otx0YOmbsoLiQzpiT4MuAEosm/H3ISEmkdhH8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KQySQPVyy1YXv5zQQn3FLr9osbq9EYD0pGx2A8y8AJDvZUh7hefaMGXXxKT8edvU78Ovc6mwZBSHn5cTEjkKjPwi1CGBUv062Nfg6azzUfEis8omJvN6IG13dMnnTbFX378rUL6/d8UivQssan3jTezb+RcxwCq8hKu8LVVtK+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 6535GpBX015350
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Wed, 3 Jun 2026 13:16:51 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (10.1.24.122) by exch02.asrmicro.com
 (10.1.24.122) with Microsoft SMTP Server (TLS) id 15.0.847.32; Wed, 3 Jun
 2026 13:16:53 +0800
Received: from exch02.asrmicro.com ([::1]) by exch02.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Wed, 3 Jun 2026 13:16:53 +0800
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
Subject: RE: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Topic: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Index: AQHc8rW9wukd7b9NBk+4vV9CGfadLrYsSZig
Date: Wed, 3 Jun 2026 05:16:52 +0000
Message-ID: <3007575a0de64bdf8577cf3b1abafbea@exch02.asrmicro.com>
References: <20260602124103.1581617-1-hongjiefang@asrmicro.com>
 <3f210420-ccfe-4cc4-87aa-8d810d580aa0@acm.org>
In-Reply-To: <3f210420-ccfe-4cc4-87aa-8d810d580aa0@acm.org>
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
X-MAIL:spam.asrmicro.com 6535GpBX015350

DQo+IEZyb206IEJhcnQgVmFuIEFzc2NoZSBbbWFpbHRvOmJ2YW5hc3NjaGVAYWNtLm9yZ10NCj4g
U2VudDogV2VkbmVzZGF5LCBKdW5lIDMsIDIwMjYgMTozMiBBTQ0KPiBUbzogRmFuZyBIb25namll
KOaWuea0quadsCkgPGhvbmdqaWVmYW5nQGFzcm1pY3JvLmNvbT47DQo+IGFsaW0uYWtodGFyQHNh
bXN1bmcuY29tOyBhdnJpLmFsdG1hbkB3ZGMuY29tOw0KPiBKYW1lcy5Cb3R0b21sZXlASGFuc2Vu
UGFydG5lcnNoaXAuY29tOyBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsNCj4gcGV0ZXIud2Fu
Z0BtZWRpYXRlay5jb207IGJlYW5odW9AbWljcm9uLmNvbQ0KPiBDYzogbGludXgtc2NzaUB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6
IFtQQVRDSCB2NF0gc2NzaTogdWZzOiBjb3JlOiBoYW5kbGUgUE0gY29tbWFuZHMgdGltZW91dCBi
ZWZvcmUNCj4gU0NTSSBFSA0KPiANCj4gT24gNi8yLzI2IDU6NDEgQU0sIEhvbmdqaWUgRmFuZyB3
cm90ZToNCj4gPiAtCXJldHVybiBzY3NpX2hvc3RfYnVzeShoYmEtPmhvc3QpID8gU0NTSV9FSF9S
RVNFVF9USU1FUiA6DQo+IFNDU0lfRUhfRE9ORTsNCj4gPiArCS8qDQo+ID4gKwkgKiB1ZnNoY2Rf
bGlua19yZWNvdmVyeSgpIG1heSBhbHJlYWR5IGhhdmUgY29tcGxldGVkIEBzY21kLCBlLmcuDQo+
IHZpYQ0KPiA+ICsJICogdGhlIGV4aXN0aW5nIE1DUSBmb3JjZS1jb21wbGV0aW9uIHBhdGguDQo+
ID4gKwkgKi8NCj4gPiArCWlmICghdGVzdF9iaXQoU0NNRF9TVEFURV9DT01QTEVURSwgJnNjbWQt
PnN0YXRlKSkgew0KPiANCj4gVGhlIGFib3ZlIHRlc3QgY2FuIGJlIGxlZnQgb3V0IGlmIHNjc2lf
ZG9uZSgpIHdvdWxkIGJlIGNhbGxlZCBiZWZvcmUNCj4gdWZzaGNkX2xpbmtfcmVjb3ZlcnkoKSwg
aXNuJ3QgaXQ/IE90aGVyd2lzZSB0aGlzIHBhdGNoIGxvb2tzIGdvb2QgdG8gbWUuDQoNCkkgdGhp
bmsgc2NzaV9kb25lKCkgaGFzIHRvIHN0YXkgYWZ0ZXIgdWZzaGNkX2xpbmtfcmVjb3ZlcnkoKS4N
ClRoZSByZWFzb24gaXMgdGhhdCBzY3NpX2RvbmUoKSB3YWtlcyB0aGUgYmxrX2V4ZWN1dGVfcnEo
KS9zY3NpX2V4ZWN1dGVfY21kKCkNCndhaXRlci4gSWYgdGhhdCBoYXBwZW5zIGJlZm9yZSBsaW5r
IHJlY292ZXJ5IGZpbmlzaGVzLCBzY3NpX2NoZWNrX3Bhc3N0aHJvdWdoKCkNCm1heSByZXRyeSB0
aGUgUE0gY29tbWFuZCB3aGlsZSB0aGUgaG9zdCBpcyBzdGlsbCBpbiByZWNvdmVyeSAvIHJlc2V0
IHN0YXRlLA0Kd2hpY2ggd291bGQgYnJpbmcgYmFjayB0aGUgb3JpZ2luYWwgcmV0cnktdnMtcmVj
b3ZlcnkgcmFjZSB0aGlzIHBhdGNoIGlzDQp0cnlpbmcgdG8gYXZvaWQuDQoNCg0KDQpCZXN0Lg0K
