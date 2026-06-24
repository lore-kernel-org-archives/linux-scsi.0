Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24B63815CB;
	Wed, 24 Jun 2026 06:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782281472; cv=none; b=LIhmuC0+SPlR+NqhU66p4KxgMm6HwybzuowRg7Tlx8I+AUS3qqDWVt/Z4IXqh1jd5weO/+AgvGIMcCE6yX2DHTvcgAdfzr28p8S9Pf2ooKhHLN8aR7qC5w8qygEhpJyFbDhDysPt0L9DLlOhSYIOeBhVo62iF4kk1dR4nQsuQ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782281472; c=relaxed/simple;
	bh=ci9nYdIhzU87Tg/cUNxcFVynHXUV0/f88ZKyLFGQTms=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=kwV2EevywdUA/6A4PeVOGbfYO4SJGnOrka0/eGbGJNuIzFg67j/klO/cSZmvvS/gCeUxTG43kvaRgfKM1eXSzN9P1gcJp+PACQpGBTqtoz7wvx+FOuNWYfY5y1ROXZUT7G9KipL5tYJZk/EEGvXIV/DyoH7AucBYT3uYcmfs88w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=i5X3AMHF; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="i5X3AMHF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=ci9nYdIhzU87Tg/cUNxcFVynHXUV0/f88ZKyLFGQTms=; b=i
	5X3AMHFcxWxDpVWhYXa08tfHxGfcJ2pp975KqI91274vLYqHxM6RbKorWrB0kQb5
	NPDBohul754QGXKErHXlL4y8KBpAa0jOx5QzkNMETpoACrhrzyqx07xRXHcQQPTo
	XRFQaLf3D5GbIBG/O2k7QmaU30cyjYoS5NPSJNIBSg=
Received: from haoxiang_li2024$163.com ( [36.112.3.223] ) by
 ajax-webmail-wmsvr-40-108 (Coremail) ; Wed, 24 Jun 2026 14:10:38 +0800
 (CST)
Date: Wed, 24 Jun 2026 14:10:38 +0800 (CST)
From: haoxiang_li2024  <haoxiang_li2024@163.com>
To: Don.Brace@microchip.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	david.carroll@microsemi.com, justin.lindley@microsemi.com,
	scott.teel@microsemi.com, storagedev@microchip.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re:Re: [PATCH] scsi: hpsa: fix DMA mapping leak on IOACCEL2 reset
 path
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260403(27802f6d) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <SJ2PR11MB8369CC3A2E487829E96057BAE1EF2@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260622160028.1240496-1-haoxiang_li2024@163.com>
 <SJ2PR11MB8369CC3A2E487829E96057BAE1EF2@SJ2PR11MB8369.namprd11.prod.outlook.com>
X-NTES-SC: AL_Qu2TAP6Tvkwo7iWcZekfmUwSj+s8WsO0vf4i245fO5B+jCLpyzEDYXpkLHTOzeC2LxuSuwqcbydQy+9XTK1GRYskkxBk2e9GBiBxILWb28fmHw==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <3881ced5.4b48.19ef8408558.Coremail.haoxiang_li2024@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:bCgvCgCntwbedDtq0LoPAA--.9W
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbCxh69LGo7dN7LKgAA3T
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgpPbiAyMDI2LTA2LTIzIDAyOjI2OjQy77yMRG9uLkJyYWNlQG1pY3JvY2hpcC5jb20gd3JvdGXv
vJoKPl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPkZyb206wqBIYW94
aWFuZyBMaSA8aGFveGlhbmdfbGkyMDI0QDE2My5jb20+Cj5TZW50OsKgTW9uZGF5LCBKdW5lIDIy
LCAyMDI2IDExOjAwIEFNCj5UbzrCoEphbWVzLkJvdHRvbWxleUBIYW5zZW5QYXJ0bmVyc2hpcC5j
b20gPEphbWVzLkJvdHRvbWxleUBIYW5zZW5QYXJ0bmVyc2hpcC5jb20+OyBtYXJ0aW4ucGV0ZXJz
ZW5Ab3JhY2xlLmNvbSA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+OyBkYXZpZC5jYXJyb2xs
QG1pY3Jvc2VtaS5jb20gPGRhdmlkLmNhcnJvbGxAbWljcm9zZW1pLmNvbT47IGp1c3Rpbi5saW5k
bGV5QG1pY3Jvc2VtaS5jb20gPGp1c3Rpbi5saW5kbGV5QG1pY3Jvc2VtaS5jb20+OyBzY290dC50
ZWVsQG1pY3Jvc2VtaS5jb20gPHNjb3R0LnRlZWxAbWljcm9zZW1pLmNvbT4KPkNjOsKgc3RvcmFn
ZWRldiA8c3RvcmFnZWRldkBtaWNyb2NoaXAuY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5v
cmcgPGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPjsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZyA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IEhhb3hpYW5nIExpIDxoYW94aWFu
Z19saTIwMjRAMTYzLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgPHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmc+Cj5TdWJqZWN0OsKgW1BBVENIXSBzY3NpOiBocHNhOiBmaXggRE1BIG1hcHBpbmcg
bGVhayBvbiBJT0FDQ0VMMiByZXNldCBwYXRoCj7CoAo+RVhURVJOQUwgRU1BSUw6IERvIG5vdCBj
bGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVu
dCBpcyBzYWZlCj4KPklmIHBoeXNfZGlzay0+aW5fcmVzZXQgaXMgc2V0LCB0aGUgZnVuY3Rpb24g
cmV0dXJucyBkaXJlY3RseSB3aXRob3V0Cj51bmRvaW5nIHRoZSByZXNvdXJjZXMgYWNxdWlyZWQg
Zm9yIHRoZSBjb21tYW5kLiBBZGQgdGhlIG1pc3NpbmcgZXJyb3IKPmNsZWFudXAgYnkgdW5tYXBw
aW5nIHRoZSBJT0FDQ0VMMiBTRyBjaGFpbiBibG9jayB3aGVuIG5lZWRlZCwgdW5tYXBwaW5nCj50
aGUgU0NTSSBjb21tYW5kLCBhbmQgZHJvcHBpbmcgdGhlIG91dHN0YW5kaW5nIElPQUNDRUwgY29t
bWFuZCBjb3VudAo+YmVmb3JlIHJldHVybmluZy4KPgo+Rml4ZXM6IGM1ZGZkMTA2NDE0ZiAoInNj
c2k6IGhwc2E6IGNvcnJlY3QgZGV2aWNlIHJlc2V0cyIpCj5DYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZwo+U2lnbmVkLW9mZi1ieTogSGFveGlhbmcgTGkgPGhhb3hpYW5nX2xpMjAyNEAxNjMuY29t
Pgo+Cj5BY2tlZC1ieTogRG9uIEJyYWNlIDxkb24uYnJhY2VAbWljcm9jaGlwLmNvbQo+VGhhbmtz
IGZvciB5b3VyIHBhdGNoLiBDYW4gZml4IHBvdGVudGlhbCBwZXJmb3JtYW5jZSBpc3N1ZXMgd2l0
aCBkZXZpY2VzIHVuZGVyZ29pbmcgcmVzZXRzLgo+V2hhdCBhYm91dCBhbm90aGVyIHBhdGNoIGZv
ciB3aGVuIGNhbGwgdG8gaHBzYV9tYXBfaW9hY2NlbDJfc2dfY2hhaW5fYmxvY2soKSBmYWlscz8K
PgoKPgoKVGhhbmtzIGZvciB5b3VyIHJldmlldyEgSSBjaGVja2VkIHRoZSBocHNhX21hcF9pb2Fj
Y2VsMl9zZ19jaGFpbl9ibG9jaygpIGZhaWx1cmUgcGF0aC4gSXQKYWxyZWFkeSBkZWNyZW1lbnRz
IGlvYWNjZWxfY21kc19vdXQgYW5kIGNhbGxzICBzY3NpX2RtYV91bm1hcChjbWQpLiBJIHRoaW5r
IHRoaXMgcGF0Y2gKaXMgZW5vdWdoPwoKPi0tLQo+wqBkcml2ZXJzL3Njc2kvaHBzYS5jIHwgNCAr
KysrCj7CoDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykKPgo+ZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS9ocHNhLmMgYi9kcml2ZXJzL3Njc2kvaHBzYS5jCj5pbmRleCBhMWIxMTZjZDQ3
MjMuLjhlZGFkMTgzMGFiZSAxMDA2NDQKPi0tLSBhL2RyaXZlcnMvc2NzaS9ocHNhLmMKPisrKyBi
L2RyaXZlcnMvc2NzaS9ocHNhLmMKPkBAIC01MDE3LDYgKzUwMTcsMTAgQEAgc3RhdGljIGludCBo
cHNhX3Njc2lfaW9hY2NlbDJfcXVldWVfY29tbWFuZChzdHJ1Y3QgY3Rscl9pbmZvICpoLAo+Cj7C
oMKgwqDCoMKgwqDCoCBpZiAocGh5c19kaXNrLT5pbl9yZXNldCkgewo+wqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGNtZC0+cmVzdWx0ID0gRElEX1JFU0VUIDw8IDE2Owo+K8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgYXRvbWljX2RlYygmcGh5c19kaXNrLT5pb2FjY2VsX2NtZHNf
b3V0KTsKPivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNjc2lfZG1hX3VubWFwKGNtZCk7
Cj4rwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAodXNlX3NnID4gaC0+aW9hY2NlbF9t
YXhzZykKPivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBocHNh
X3VubWFwX2lvYWNjZWwyX3NnX2NoYWluX2Jsb2NrKGgsIGNwKTsKPsKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCByZXR1cm4gLTE7Cj7CoMKgwqDCoMKgwqDCoCB9Cj4KPi0tCj4yLjI1LjEK
ClRoYW5rcywKSGFveGlhbmcK
