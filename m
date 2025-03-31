Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C11429A9;
	Mon, 31 Mar 2025 03:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743390612; cv=none; b=izn1u6dO7cN7Ve6UsexnzIx5Y1ivASq5w1cQ9JK8NuWYghMatg9XBnkbZiGbmhGhIRzgXnYpoXSblLoI1Wq4eSsFj9zTPeWbcyEB7Z5ZXxG7INcs0ABVdurF63JT1Vf87Ufn85os1Kwqrl0iE0B5/ceocC3lJqUZu6FTv/Nymo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743390612; c=relaxed/simple;
	bh=wwEd1rz8ocELqW18+zDtSWqbMKmvURbNq9h4YF2HPTE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d9nZjOtdE7zyDKRxBb3oq9U7onopHqUUuC/m0v5rkhbxC9vmU94rlayU76OvDT3K5l5ROrhA5jHTnUPodRHaiLphfwzTPmmqPhm4oCTw1qc1z15FPRZKyYEUQyQ4Qd3vG729+WvB1qST8FlAk0InZwpym2G7p8Obi5mqoapzYbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZQx0k43ycztRZt;
	Mon, 31 Mar 2025 11:08:38 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F5FA1800B4;
	Mon, 31 Mar 2025 11:10:04 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (7.185.36.197) by
 dggpemf500017.china.huawei.com (7.185.36.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 31 Mar 2025 11:10:03 +0800
Received: from dggpemf500016.china.huawei.com ([7.185.36.197]) by
 dggpemf500016.china.huawei.com ([7.185.36.197]) with mapi id 15.02.1544.011;
 Mon, 31 Mar 2025 11:10:03 +0800
From: Jiangjianjun <jiangjianjun3@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Jiangjianjun <jiangjianjun3@huawei.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, lixiaokeng <lixiaokeng@huawei.com>,
	"hewenliang (C)" <hewenliang4@huawei.com>, "Yangkunlin(Poincare)"
	<yangkunlin7@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1JGQyBQQVRDSCB2MyAwMC8xOV0gc2NzaTogc2NzaV9lcnJvcjog?=
 =?gb2312?Q?Introduce_new_error_handle_mechanism?=
Thread-Topic: [RFC PATCH v3 00/19] scsi: scsi_error: Introduce new error
 handle mechanism
Thread-Index: AQHblH3V6Xb/i2HlPkKfsoLGhpqxW7Nx0E4AgAk83YCAEZ0cMA==
Date: Mon, 31 Mar 2025 03:10:03 +0000
Message-ID: <9740056c3b1b4da796d86e67cba4c292@huawei.com>
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
 <f35b2485-588b-40c4-a2e7-1bb65fb7a9fc@suse.de>
 <Z9uwP4axlXOSWxQD@infradead.org>
In-Reply-To: <Z9uwP4axlXOSWxQD@infradead.org>
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

U29ycnkgZm9yIGxhdGUgbWVzc2FnZSEgSSdtIHdvcmtpbmcgb24gZml4aW5nIGFuZCB0ZXN0aW5n
IHRoZXNlIGlzc3VlcyBiZWZvcmUgcmUtZW1haWxpbmcuDQoNCi0tLS0t08q8/tStvP4tLS0tLQ0K
t6K8/sjLOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+IA0Kt6LLzcqxvOQ6
IDIwMjXE6jPUwjIwyNUgMTQ6MDYNCsrVvP7IyzogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2Uu
ZGU+DQqzrcvNOiBKaWFuZ2ppYW5qdW4gPGppYW5namlhbmp1bjNAaHVhd2VpLmNvbT47IGplamJA
bGludXguaWJtLmNvbTsgbWFydGluLnBldGVyc2VuQG9yYWNsZS5jb207IGxpbnV4LXNjc2lAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaXhpYW9rZW5nIDxs
aXhpYW9rZW5nQGh1YXdlaS5jb20+OyBoZXdlbmxpYW5nIChDKSA8aGV3ZW5saWFuZzRAaHVhd2Vp
LmNvbT47IFlhbmdrdW5saW4oUG9pbmNhcmUpIDx5YW5na3VubGluN0BodWF3ZWkuY29tPg0K1vfM
4jogUmU6IFtSRkMgUEFUQ0ggdjMgMDAvMTldIHNjc2k6IHNjc2lfZXJyb3I6IEludHJvZHVjZSBu
ZXcgZXJyb3IgaGFuZGxlIG1lY2hhbmlzbQ0KDQpPbiBGcmksIE1hciAxNCwgMjAyNSBhdCAxMDow
MTo0MEFNICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6DQo+IDMuIFRoZSBjdXJyZW50IEVI
IGZyYW1ld29yayBpcyBkZXNpZ25lZCBhcm91bmQgJ3N0cnVjdCBzY3NpX2NtbmQnLg0KPiBXaGlj
aCBtZWFucyB0aGF0IHRoZSBjb21tYW5kIF9pbml0aWF0aW5nXyB0aGUgZXJyb3IgaGFuZGxpbmcg
Y2FuIG9ubHkgDQo+IGJlIHJldHVybmVkIG9uY2UgdGhlIF9lbnRpcmVfIGVycm9yIGhhbmRsaW5n
ICh3aXRoIGFsbA0KPiBlc2NhbGF0aW9ucykgaXMgZmluaXNoZWQuIEFuZCBtb3JlIG9mdGVuIHRo
YW4gbm90LCB0aGUgYXBwbGljYXRpb24gaXMgDQo+IHdhaXRpbmcgb24gdGhhdCBjb21tYW5kIHRv
IGJlIGNvbXBsZXRlZCBiZWZvcmUgdGhlIG5leHQgSS9PIGlzIHNlbnQuIA0KPiBBbmQgdGhhdCBy
ZWFsbHkgbGltaXRzIHRoZSBlZmZlY3RpdmVuZXNzIG9mIGFueSBpbXByb3ZlZCBlcnJvciANCj4g
aGFuZGxlcjsgdGhlIGFwcGxpY2F0aW9uIHVsdGltYXRpdmVseSBoYXMgdG8gd2FpdCBmb3IgYSBo
b3N0IHJlc2V0IA0KPiBiZWZvcmUgaXQgY2FuIGNvbnRpbmUuDQoNCkFuZCBzb21lb25lIG5lZWRz
IHRvIGdldCB5b3VyIG9sZCBzZXJpZXMgdG8gZml4IHRoYXQgbWVyZ2VkIGJlZm9yZSB3ZSBldmVu
IHN0YXJ0IHRhbGtpbmcgYWJvdXQgYW55IG1ham9yIEVIIGNoYW5nZS4NCg0K
