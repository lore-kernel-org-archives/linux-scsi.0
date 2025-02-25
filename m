Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F315D2690D7;
	Tue, 25 Feb 2025 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740489257; cv=none; b=OER8ouSK21VaKyliedYdrOFCFWpfjPyj8wgxUP6HCFwWOXPr9k4xqdvzHHYiQ+3VGGzepLRWErHXSWq65cbWl9LXcwyjRlElBC+tGOnSp5jN/mtYCT8VXoUzppAcFDVVYR///Y3sA7y9AFccBCuP7jDU45ejB0SLR9DdqlWOu4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740489257; c=relaxed/simple;
	bh=RwX3oSR1luX3Wb3W4lgKOFBSU88ndS6ozVoLUC0kTtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KnNgvme9BqacLEvhPmmnCjwy4Z2p42rafSb0C/PwqM1devRViRIeXTGOZxk314VJzNJWmiXkJ3Nea/CKxlbZ9xtTWIXjUvjJWxxBIAMeDZdqyauODcWAzadA9CO67QRgxDutFaNK3L2m6hgohvh4Re37Yss6HnM3QvyxQnH1TP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=FtN1w/6v; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="FtN1w/6v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1740489182;
	bh=RwX3oSR1luX3Wb3W4lgKOFBSU88ndS6ozVoLUC0kTtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=FtN1w/6vFw1VCH9UHTW50Z1faIq8qf4Yau3XA24clUsyo/+J/ZKg8biX1JUJ5S17x
	 wpwT69GAolfyELJChYO8UPp4KszQXzoWpZTzqvRE1YRuJNkVNbPBQgfDwKKx0nwExF
	 9HgJblql5CGAYMpXgq23XL8Y6uuh5WYj6Utc+/EA=
X-QQ-mid: bizesmtpip3t1740489116thwmj9a
X-QQ-Originating-IP: 6/30mZr5TR8b9ztJw35yzmcO8NNodfukdK+u0UiyNT8=
Received: from [IPV6:240e:668:120a::212:156] ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 25 Feb 2025 21:11:54 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2494615995650422906
Message-ID: <0A01BD2F489C764A+647ab6a7-35e5-4aa4-b8d1-c177be1724c6@uniontech.com>
Date: Tue, 25 Feb 2025 21:11:54 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH v3] scsi: Bypass certain SCSI commands on disks
 with "use_192_bytes_for_3f" attribute
To: Bart Van Assche <bvanassche@acm.org>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stern@rowland.harvard.edu, zhanjun@uniontech.com, niecheng1@uniontech.com,
 guanwentao@uniontech.com, chenlinxuan@uniontech.com,
 Xinwei Zhou <zhouxinwei@uniontech.com>, Xu Rao <raoxu@uniontech.com>,
 Yujing Ming <mingyujing@uniontech.com>
References: <ADB8844D07D40320+20250224034832.40529-1-wangyuli@uniontech.com>
 <ad1ba59a-3a67-4b3c-a05d-c4e56405cc19@acm.org>
Content-Language: en-US
From: WangYuli <wangyuli@uniontech.com>
Autocrypt: addr=wangyuli@uniontech.com; keydata=
 xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSKP+nX39DN
 IVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAxFiEEa1GMzYeuKPkg
 qDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMBAAAKCRDF2h8wRvQL7g0UAQCH
 3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfPbwD/SrncJwwPAL4GiLPEC4XssV6FPUAY
 0rA68eNNI9cJLArOOARmgSyJEgorBgEEAZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7
 VTL0dvPDofBTjFYDAQgHwngEGBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIb
 DAAKCRDF2h8wRvQL7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkU
 o9ERi7qS/hbUdUgtitI89efbY0TVetgDsyeQiwU=
In-Reply-To: <ad1ba59a-3a67-4b3c-a05d-c4e56405cc19@acm.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------WyKFM9ljjpPFMEt0017CGUNW"
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: MIYVF5Pddf3wJApsG0UREr+dCSYChXydDKfPURQBbDs0yY3d1wKMy16O
	IDPHMp2DbUAUXbNtrbZGPlqVsQeEi7sGM27c9P3drjq211CMMTxCtmqMx7/nHzJ6p6g4liL
	kQiad1chgOL7A1cTwC/yo3cjztg2qR5etN5oCfyjNe3gmm6YY1foYOrq1c6ClCqlV0+1+ek
	OTR3A5Em+dQ81uoHbYyaWzrd8+28Diakx4gPKaJRvadP6Yq1jjXjecgKG3RrxQHRVSDRcNR
	CB/HvaXjjkm4PClNoQTMhVTsmVjOeqeaVYboeJCJrVOemCqvuAk8K80GIWQHm6iGj0jJzxV
	88E+xnJUGEv1ZjM+yCldZs36P99a0JYwFzjrTuF0o4lKOSDtrp4P0GwPzG+u/8plG74c0rW
	A5iuskI/kgShuksPySNQnqA5EvK/5rc2+m3Oc317hGbLwT2JIcZIbBzqESWF4ZNvuWZtekJ
	4ngMYa8SYtHd/H3/AbuAP2lX4+NeZie8mf4uuG/lvEnjWPOCl5p6cG9PYtdPOhkxbjRMcoO
	OTrUUbMBlUduwIB1DoA1YdZsWQJUp0iYKXWWicTucs/BNwWePvlnx3V7KPQGz2yHK9z7jAm
	ebLJOi1LWNCAhz4c7mifIsm/WBGmkBADkE7cT/eLM/hXQKzfBpnH8pnYKqQdKtldHZmaLNI
	U6arNwuqs9i7fEYQcPBIuhAqoG6BaKogxWs48Y4b3xcbrj49otGK9K/XsLodumeabbRIfgQ
	mehL4xyBpZN0yBiHmxBbP+BCvhgHPO+Ab2+kbC/2ixzUyHqKhm26UFHCfIUwnZIIY992yVy
	le/gYRaRlXJNj62qGLkDTZWRYlzbDTTSzGctrd2xPpa7eeQY18yC1jbRJxMSzPZxL0y862f
	834C14I2e3d8jJ5krjcZJ3w4cy8GrD0WIGMOvAp6itqKHV3OYGsEtIhOF0HqkN2IM/hxePD
	JUAiJbZm2xxRVw2cgKSKr8GAGZys8t69gUPMdgQuRYJiF57ntizRWyoY3i+D7fqS0XkpgVc
	DBKpI/MbnNLzi9XYGxEFlFLux2p7G2idwEGy6PXYvKJZLmdW/1ArN9Q71xY11s+G+KXZAjt
	vtOGvNaMRPTZY1ie48nDog=
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------WyKFM9ljjpPFMEt0017CGUNW
Content-Type: multipart/mixed; boundary="------------OM0ycHiqAXHv0H3uaNPqw9ej";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: Bart Van Assche <bvanassche@acm.org>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stern@rowland.harvard.edu, zhanjun@uniontech.com, niecheng1@uniontech.com,
 guanwentao@uniontech.com, chenlinxuan@uniontech.com,
 Xinwei Zhou <zhouxinwei@uniontech.com>, Xu Rao <raoxu@uniontech.com>,
 Yujing Ming <mingyujing@uniontech.com>
Message-ID: <647ab6a7-35e5-4aa4-b8d1-c177be1724c6@uniontech.com>
Subject: Re: [RESEND PATCH v3] scsi: Bypass certain SCSI commands on disks
 with "use_192_bytes_for_3f" attribute
References: <ADB8844D07D40320+20250224034832.40529-1-wangyuli@uniontech.com>
 <ad1ba59a-3a67-4b3c-a05d-c4e56405cc19@acm.org>
In-Reply-To: <ad1ba59a-3a67-4b3c-a05d-c4e56405cc19@acm.org>

--------------OM0ycHiqAXHv0H3uaNPqw9ej
Content-Type: multipart/mixed; boundary="------------6Mk1ZBCl3qWxES506fPP0gIU"

--------------6Mk1ZBCl3qWxES506fPP0gIU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgQmFydCBWYW4gQXNzY2hlLA0KDQpPbiAyMDI1LzIvMjUgMDI6MTEsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gbHNodyBpcyBhIHVzZXIgc3BhY2UgdXRpbGl0eS4gdXNlXzE5Ml9i
eXRlc19mb3JfM2YgaXMgbm90IGV4cG9zZWQgdG8NCj4gdXNlciBzcGFjZSBhcyBmYXIgYXMg
SSBrbm93LiBTbyBob3cgY2FuIHRoZSBhYm92ZSBzdGF0ZW1lbnQgYmUgY29ycmVjdD8NCj4N
CkRpc2tzwqBoYXZlwqB0aGXCoGF0dHJpYnV0ZcKgdXNlXzE5Ml9ieXRlc19mb3JfM2YswqB3
aGljaMKgbWVhbnPCoHRoYXTCoGRpc2tzwqBvbmx5wqBhY2NlcHTCoE1PREXCoFNFTlNFwqB0
cmFuc2ZlcsKgbGVuZ3Roc8Kgb2bCoDE5MsKgYnl0ZXMNCg0KSG93ZXZlcizCoHdoZW7CoGxz
aHfCoHNlbmRzwqBNT0RFwqBTRU5TRcKgY29tbWFuZMKgdG/CoGRpc2tzLMKgdXNlXzE5Ml9i
eXRlc19mb3JfM2bCoHdpbGzCoG5vdMKgYmXCoGNvbnNpZGVyZWQswqB3aGljaMKgd2lsbMKg
Y2F1c2XCoHNvbWXCoGRpc2tzwqB3aXRowqB1c2VfMTkyX2J5dGVzX2Zvcl8zZsKgdG/CoGJl
wqB1bnVzYWJsZQ0KDQpUb8Kgc29sdmXCoHRoaXPCoHByb2JsZW0swqBpdMKgaXPCoG5lY2Vz
c2FyecKgdG/CoGRldGVybWluZcKgd2hldGhlcsKgdGhlwqBkZXZpY2XCoGhhc8KgdGhlwqB1
c2VfMTkyX2J5dGVzX2Zvcl8zZsKgYXR0cmlidXRlwqBhdMKgdGhlwqBzY3NpwqBsZXZlbC7C
oElmwqB0aGXCoGRldmljZcKgaGFzwqB1c2VfMTkyX2J5dGVzX2Zvcl8zZizCoHdoZW7CoGxz
aHfCoG9ywqBvdGhlcsKgYXBwbGljYXRpb25zwqBzZW5kwqBNT0RFwqBTRU5TRcKgY29tbWFu
ZMKgdGhyb3VnaMKgaW9jdGwswqB0aGXCoGNvbW1hbmTCoHdpdGjCoHRoZcKgZGF0YcKgbGVu
Z3RowqBmaWVsZMKgb2bCoDB4ZmbCoG5lZWRzwqB0b8KgYmXCoGZpbHRlcmVkwqBvdXTCoHRv
wqBhdm9pZMKgZGV2aWNlwqBhYm5vcm1hbGl0eS4gDQoNCj4NCj4gRnJvbSBpbmNsdWRlL3Nj
c2kvc2NzaV9kZXZpY2UuaDoNCj4NCj4gdW5zaWduZWQgdXNlXzE5Ml9ieXRlc19mb3JfM2Y6
MTsgLyogYXNrIGZvciAxOTIgYnl0ZXMgZnJvbSBwYWdlIDB4M2YgKi8NCj4NCj4gVGhlIGFi
b3ZlIGNvZGUgdXNlcyB1c2VfMTkyX2J5dGVzX2Zvcl8zZiBmb3IgYW5vdGhlciBwdXJwb3Nl
LiBQbGVhc2UgDQo+IHJlc3BlY3QgdGhlIHB1cnBvc2Ugb2YgdGhlIHVzZV8xOTJfYnl0ZXNf
Zm9yXzNmIGJpdGZpZWxkLg0KPg0KPiBUaGFua3MsDQo+DQo+IEJhcnQuDQo+DQo+DQpUaGFu
a3MsDQotLSANCldhbmdZdWxpDQo=
--------------6Mk1ZBCl3qWxES506fPP0gIU
Content-Type: application/pgp-keys; name="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Disposition: attachment; filename="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSK
P+nX39DNIVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAx
FiEEa1GMzYeuKPkgqDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMB
AAAKCRDF2h8wRvQL7g0UAQCH3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfP
bwD/SrncJwwPAL4GiLPEC4XssV6FPUAY0rA68eNNI9cJLArOOARmgSyJEgorBgEE
AZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7VTL0dvPDofBTjFYDAQgHwngE
GBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIbDAAKCRDF2h8wRvQL
7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkUo9ERi7qS
/hbUdUgtitI89efbY0TVetgDsyeQiwU=3D
=3DBlkq
-----END PGP PUBLIC KEY BLOCK-----

--------------6Mk1ZBCl3qWxES506fPP0gIU--

--------------OM0ycHiqAXHv0H3uaNPqw9ej--

--------------WyKFM9ljjpPFMEt0017CGUNW
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZ73BmgUDAAAAAAAKCRDF2h8wRvQL7vr7
AQCKLeuair7/zCaLbMxiUky8fDh9C54r6sZWEWrXWBd75AEAtON+w6pLfxFL1RbBYufRXYvkcAf3
jmt/hhjYzKoVfwU=
=tOa5
-----END PGP SIGNATURE-----

--------------WyKFM9ljjpPFMEt0017CGUNW--
