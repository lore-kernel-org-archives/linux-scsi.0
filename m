Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C171113B297
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 21:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275629; cv=none; b=MvkvGa9NpzqhEVxDP0wpJnDjEfF3t1Qy0wtRe6x/MM5EmjOvlArjSmpduoMV0P+3jepkYWmyEr2GzV9/THiMoqkoPQ6aqtXOHjPEBgq6yS8v5DVkS7MfB9CgdM9dHo3roLtO0w1+wyxLvxCwQG6h4QB2m8j4rQyVrgKWGEdUOxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275629; c=relaxed/simple;
	bh=Ox3/oYXoJp8nstMiMv+a7JZFUPCauSSDl+qiodMwQDQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=isgtqFwt4VF8P2A9FfZ8YlS5UamvKF1WvLyDoL1zTOT4NxKFJvF/syMp+4zEQ4aIW7Uk2q9DdR4SbV2xHOS6XM2kjj+k3WyOC9IscyBfqmzuELKTFO3TMlG3mxY/SOwf7Yi+Nnx4ae8Wqqh+er45ig9TvmY4SMv17FmK9E8gsJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H2Prdvz/; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2Prdvz/"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2f15e48f35bso1312251fa.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 14:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724275626; x=1724880426; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ox3/oYXoJp8nstMiMv+a7JZFUPCauSSDl+qiodMwQDQ=;
        b=H2Prdvz/6HrGh5Z2NHekBALa5eYhk5Xl3FHvscV3VlkTrlDG/lxkjIPZtMPdP1Lo08
         IfvP7eJTkgWJUM0KkN/np1SkZqncsh7g6x2mFzoAr5iBiCMrypRFtYXR5FZ29s42PgGL
         b6b09HJJvzMEwop0iXi7JVZ3rRinps9DgSBYLcDGA5oJHg54DDHbsAizvsOWoHqMcFan
         7nnkOVXoQ0F3sg1IPnpVg1nL2Gk1YE4DRyC2dqgKC5D7pBSf1lPyAt8L/GXacAEf2YrP
         F7XdH+GiWUq2psfpjz/3mujbNFLcalXeIUlx8CLtl4fEk9Q0m3/ix+2YMqgJJtU2tdE2
         KolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724275626; x=1724880426;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ox3/oYXoJp8nstMiMv+a7JZFUPCauSSDl+qiodMwQDQ=;
        b=dyLaLC9w3XpVwnIFV8bQMou2ITV0OuoeUcmm9nKaQkt262Pq/Tl/Zy1GaVxXbeIoGq
         Ruc4K1d06z08CYwkYcmQ9G4WFJyHaN0qet5flf/krbb3JnvoNLuycoywBOBmeepviM/o
         T1MnAVnRilUdh9Hcz1gWzLa/5fNKYjEjCl+cwjWml2271pQiTPVIEMW6102I/Sxx1237
         KAsGv0w57xGO0YWFyyx/8NaevsjahmmO09G1xitFLeQmC1MIMACG3C4e09H4DqTYyHT5
         NrTvCPY7zI0wNdcw0Id3ix2Ba20apomYPmbJlT4r7KIZZXPqOwHi4U54O8nqKDV416Bf
         Cm6Q==
X-Gm-Message-State: AOJu0YysJgVfvnjLQ0Q58IJaaYdxzXNqI1x9a0WawwNhNp5d8DHdRNgB
	6yH+wQKtXf2gvmARhtC9yTN0dgGyGqbJAU+RX1KHPKtAjDXoeuAz
X-Google-Smtp-Source: AGHT+IFSpEmP8YEL9A1ZGI8sPSl1GQrLNz1cY61NGO1a/45sBAOyIWDC1rB5oWk+ivwNWKXqJzyJ9A==
X-Received: by 2002:a05:651c:b07:b0:2f3:edb2:d7b2 with SMTP id 38308e7fff4ca-2f3f88ea60fmr27082471fa.20.1724275625092;
        Wed, 21 Aug 2024 14:27:05 -0700 (PDT)
Received: from p200300c58710ea38238d6e8507432297.dip0.t-ipconnect.de (p200300c58710ea38238d6e8507432297.dip0.t-ipconnect.de. [2003:c5:8710:ea38:238d:6e85:743:2297])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c04a4c5999sm50865a12.64.2024.08.21.14.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 14:27:04 -0700 (PDT)
Message-ID: <0e552232c1759ba1749acb9b606a03670bbe1ba1.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>,  Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>, Alim
 Akhtar <alim.akhtar@samsung.com>, Eric Biggers <ebiggers@google.com>,
 Minwoo Im <minwoo.im@samsung.com>, Maramaina Naresh
 <quic_mnaresh@quicinc.com>
Date: Wed, 21 Aug 2024 23:27:03 +0200
In-Reply-To: <20240821182923.145631-3-bvanassche@acm.org>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTA4LTIxIGF0IDExOjI5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDIyICsrKysrKy0tLS0tLS0tLS0tLS0tLS0K
PiDCoGluY2x1ZGUvdWZzL3Vmc2hjZC5owqDCoMKgwqDCoCB8wqAgNyArKysrLS0tCj4gwqAyIGZp
bGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDE5IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnNo
Y2QuYwo+IGluZGV4IGQwYWU2ZTUwYmVjYy4uZTEyZjMwYjhhODNjIDEwMDY0NAo+IC0tLSBhL2Ry
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMKPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5j
Cj4gQEAgLTI1ODUsNiArMjU4NSw3IEBAIGludCB1ZnNoY2Rfc2VuZF91aWNfY21kKHN0cnVjdCB1
ZnNfaGJhICpoYmEsCj4gc3RydWN0IHVpY19jb21tYW5kICp1aWNfY21kKQo+IMKgwqDCoMKgwqDC
oMKgwqB1ZnNoY2RfaG9sZChoYmEpOwo+IMKgwqDCoMKgwqDCoMKgwqBtdXRleF9sb2NrKCZoYmEt
PnVpY19jbWRfbXV0ZXgpOwo+IMKgwqDCoMKgwqDCoMKgwqB1ZnNoY2RfYWRkX2RlbGF5X2JlZm9y
ZV9kbWVfY21kKGhiYSk7Cj4gK8KgwqDCoMKgwqDCoMKgV0FSTl9PTihoYmEtPnVpY19hc3luY19k
b25lKTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqByZXQgPSBfX3Vmc2hjZF9zZW5kX3VpY19jbWQo
aGJhLCB1aWNfY21kLCB0cnVlKTsKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFyZXQpCj4gQEAgLTQy
NTUsNyArNDI1Niw2IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3VpY19wd3JfY3RybChzdHJ1Y3QgdWZz
X2hiYQo+ICpoYmEsIHN0cnVjdCB1aWNfY29tbWFuZCAqY21kKQo+IMKgwqDCoMKgwqDCoMKgwqB1
bnNpZ25lZCBsb25nIGZsYWdzOwo+IMKgwqDCoMKgwqDCoMKgwqB1OCBzdGF0dXM7Cj4gwqDCoMKg
wqDCoMKgwqDCoGludCByZXQ7Cj4gLcKgwqDCoMKgwqDCoMKgYm9vbCByZWVuYWJsZV9pbnRyID0g
ZmFsc2U7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgbXV0ZXhfbG9jaygmaGJhLT51aWNfY21kX211
dGV4KTsKPiDCoMKgwqDCoMKgwqDCoMKgdWZzaGNkX2FkZF9kZWxheV9iZWZvcmVfZG1lX2NtZCho
YmEpOwo+IEBAIC00MjY2LDE1ICs0MjY2LDYgQEAgc3RhdGljIGludCB1ZnNoY2RfdWljX3B3cl9j
dHJsKHN0cnVjdCB1ZnNfaGJhCj4gKmhiYSwgc3RydWN0IHVpY19jb21tYW5kICpjbWQpCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dF91bmxvY2s7Cj4gwqDCoMKgwqDC
oMKgwqDCoH0KPiDCoMKgwqDCoMKgwqDCoMKgaGJhLT51aWNfYXN5bmNfZG9uZSA9ICZ1aWNfYXN5
bmNfZG9uZTsKPiAtwqDCoMKgwqDCoMKgwqBpZiAodWZzaGNkX3JlYWRsKGhiYSwgUkVHX0lOVEVS
UlVQVF9FTkFCTEUpICYKPiBVSUNfQ09NTUFORF9DT01QTCkgewo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqB1ZnNoY2RfZGlzYWJsZV9pbnRyKGhiYSwgVUlDX0NPTU1BTkRfQ09NUEwp
Owo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKgo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgKiBNYWtlIHN1cmUgVUlDIGNvbW1hbmQgY29tcGxldGlvbiBpbnRlcnJ1
cHQgaXMKPiBkaXNhYmxlZCBiZWZvcmUKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICogaXNzdWluZyBVSUMgY29tbWFuZC4KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICovCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHVmc2hjZF9yZWFkbChoYmEsIFJF
R19JTlRFUlJVUFRfRU5BQkxFKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVl
bmFibGVfaW50ciA9IHRydWU7Cj4gLcKgwqDCoMKgwqDCoMKgfQo+IMKgwqDCoMKgwqDCoMKgwqBz
cGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7Cj4gwqDC
oMKgwqDCoMKgwqDCoHJldCA9IF9fdWZzaGNkX3NlbmRfdWljX2NtZChoYmEsIGNtZCwgZmFsc2Up
Owo+IMKgwqDCoMKgwqDCoMKgwqBpZiAocmV0KSB7Cj4gQEAgLTQzMTgsOCArNDMwOSw2IEBAIHN0
YXRpYyBpbnQgdWZzaGNkX3VpY19wd3JfY3RybChzdHJ1Y3QgdWZzX2hiYQo+ICpoYmEsIHN0cnVj
dCB1aWNfY29tbWFuZCAqY21kKQo+IMKgwqDCoMKgwqDCoMKgwqBzcGluX2xvY2tfaXJxc2F2ZSho
YmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOwo+IMKgwqDCoMKgwqDCoMKgwqBoYmEtPmFjdGl2
ZV91aWNfY21kID0gTlVMTDsKPiDCoMKgwqDCoMKgwqDCoMKgaGJhLT51aWNfYXN5bmNfZG9uZSA9
IE5VTEw7Cj4gLcKgwqDCoMKgwqDCoMKgaWYgKHJlZW5hYmxlX2ludHIpCj4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHVmc2hjZF9lbmFibGVfaW50cihoYmEsIFVJQ19DT01NQU5EX0NP
TVBMKTsKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHJldCkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgdWZzaGNkX3NldF9saW5rX2Jyb2tlbihoYmEpOwo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgdWZzaGNkX3NjaGVkdWxlX2VoX3dvcmsoaGJhKTsKPiBAQCAtNTQ3
MiwxMSArNTQ2MSwxMiBAQCBzdGF0aWMgaXJxcmV0dXJuX3QKPiB1ZnNoY2RfdWljX2NtZF9jb21w
bChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzIgaW50cl9zdGF0dXMpCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBoYmEtPmVycm9ycyB8PSAoVUZTSENEX1VJQ19ISUJFUk44X01BU0sg
Jgo+IGludHJfc3RhdHVzKTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoaW50cl9zdGF0dXMg
JiBVSUNfQ09NTUFORF9DT01QTCAmJiBjbWQpIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgY21kLT5hcmd1bWVudDIgfD0gdWZzaGNkX2dldF91aWNfY21kX3Jlc3VsdChoYmEpOwo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjbWQtPmFyZ3VtZW50MyA9IHVmc2hjZF9n
ZXRfZG1lX2F0dHJfdmFsKGhiYSk7CgpCYXJ0LCAKCk15IG9ubHkgY29uY2VybiBpcywgcmVtb3Zp
bmcgZGlzYWJsaW5nIFVJQyBjb21wbGV0aW9uIElSUSwgYW5kIGtlZXBpbmcKaXMudWNjcyAxLCB0
aGVuIHdlIGRvbid0IHJlYWQgaXRzIHN0YXR1cyBpbiBjYXNlIG9mIHVmc2hjZF91aWNfcHdyX2N0
cmwKcGF0aCwgd2hldGhlciB0aGlzIHdpbGwgYWZmZWN0IHRoZSBuZXh0IFVJQyBhY2Nlc3MgcmVz
dWx0LgoKT3RoZXIgdGhpbmdzIGxvb2sgZ29vZCB0byBtZS4KCktpbmQgcmVnYXJkcywKQmVhbgo=

