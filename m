Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8498142070;
	Wed, 26 Feb 2025 02:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740537224; cv=none; b=CBS8IYq+LZwU8pEwGY/U9JdwWoaEE3hpnEYi4C7iWPUlMI9e/EBXbxIuwlo85CyOitc5JnYll4kYUutbMl+cg1l9HJgMLaKKf70hn6LaGVv0SsvAxf/tCA4hZnuYZW+FcqEhocX+m1hGPkYfhxdGfSNyzpmh4+LMD6dLv8hKj9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740537224; c=relaxed/simple;
	bh=pnzoR3G97fGxG8EieXVRTWZHaNGSuX1v/Z4EVU4uLMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UzjoLkqYOofuy13pldq7HQdIgtzRM5IG6CyuLhNrIuM/197M3UWBY7UPTrf2dhyV5pFOenWvFEFRmDCDcBYuG0oee/yRM0NWzcL7rvdwFoEkDrGHb1LLw66h0rPm1tTCrdniRvFjR1mu0Uaq9p6v69iFrD9dcabeos+8EqmuSHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=UMpP+5B3; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="UMpP+5B3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1740537162;
	bh=pnzoR3G97fGxG8EieXVRTWZHaNGSuX1v/Z4EVU4uLMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=UMpP+5B39OmkkhTqvydhSoYm/nenJStMq/02Qzzn9+ZuVNXbZpklDHP5Is/ZkrqoC
	 gkObG3XDPCU5z7I0Jh5iWCUNhZQpeeD6cE7pYLw1c8s4fTDKaG6bTq7cMwiVFDUDqJ
	 WezJpJtTJwwZyTCfCjwsxs2gtl9bPxtwe5e6D6e0=
X-QQ-mid: bizesmtpip3t1740537098t7ppo3u
X-QQ-Originating-IP: EFXs5myBNLZQnGcxTf8wJs/hXERYiPRAY/PLbfbVWic=
Received: from [IPV6:240e:668:120a::212:156] ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 26 Feb 2025 10:31:36 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7930221262135158092
Message-ID: <4EB8ECD64F601331+e2f01a1f-8da5-4e7b-b909-d920a792756a@uniontech.com>
Date: Wed, 26 Feb 2025 10:31:36 +0800
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
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stern@rowland.harvard.edu, zhanjun@uniontech.com, niecheng1@uniontech.com,
 guanwentao@uniontech.com, chenlinxuan@uniontech.com,
 Xinwei Zhou <zhouxinwei@uniontech.com>, Xu Rao <raoxu@uniontech.com>,
 Yujing Ming <mingyujing@uniontech.com>
References: <ADB8844D07D40320+20250224034832.40529-1-wangyuli@uniontech.com>
 <ad1ba59a-3a67-4b3c-a05d-c4e56405cc19@acm.org>
 <0A01BD2F489C764A+647ab6a7-35e5-4aa4-b8d1-c177be1724c6@uniontech.com>
 <3b6cca0d-7aa5-43b6-8f4a-429f17558121@acm.org>
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
In-Reply-To: <3b6cca0d-7aa5-43b6-8f4a-429f17558121@acm.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------xAOa79yi3ABp7zku3yDVyCG9"
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NDtUtlvFer7vmXbGnhouoKZcWo/uzLyiyXThVmGj/n0tyrEqThKXHtW2
	TEMMSBCSX4mqGbcxc2ELOwte/tTf8WeXWJ28i9D/Yt/s9BlXJKJAPS9mfn8UhKC1KEe/OfH
	PRVYMXgkc2bk6cD1Kd+/Dq5LE/G6pm/T5oxuCgZiRP3B7x+OBsfzDEgSZrt7IuGOA788txN
	Ox3aYwsrKXICYxvibEjlDfelmXBqKONIj748MFUfVwmxKClWJSKspvLPy7SpagA8sC6Y8zN
	sIonJBGsI1rvLQqw0xeY66yuGM7xs7AnmTR8Ozc1d2j7jnq2FVzzPEeGyEmAXcekhOZ3VIf
	D9KVjU2Xos0AotH2BfRmQvOgy6zMvRLBRLAlgCZtR6XmzCgbvWTiOeFnL5DEgybIpK/b6c+
	p7ZqAturmmsn2PcQR5MBbftUVi2nMu58Fp/5iC9sfQuLX3TiWTahxACE8Lt2CpP6uPGhsTL
	UkdYA25VXQt9Rwyr5a7A2fqNMQNgiYxw8W3Q2dCokuYFp+t0dKE4wWzhZYIOAOLM6ayRblT
	/giQf/9aackg3CDTuhC/s1QEg0txybDymsu8ttSo0p5Xb8Z3rnQ0H5CUoqZjAQ2QcPUxkrm
	5UVXcR7PDzp0Z/KiaO8pNPLvwOElTz5PipkX/dbtPztM5e8QSFdd+siIkFBW9XfeF9RrHIu
	Rli21DNE81MaFfAgo6Dy0SIqx34frEHnkqUWmsNFEcSDc2Vz8tqmhla5dCHrVJd2AG4gvSS
	IkDwP7n8Ft+1VkD1gVCUVTaCMcQx9dWLvBN/0/1yb5K/6v6hpD0swMhOJlK35O+bSLaa50k
	Nmw8437ZHCEWjVcxkKRryG3dZQV2zmDZ9zDI0d/twfEbROTEx35m8xRkc1esVBQSqgLicBc
	iK0/MLMER4BjybdxdPC/ld14zQHvKLwYY27wA7S8+O4IvTRI0wFuff+RhK80/jRgVYW4Jcv
	i/GKwkEhd85EXABlFw2WpDXWr2MB8sTecS8yrB86fhmtbuo9+jFWs2QIdEcWJcsGnEVRsvf
	Ab30jHJKKWBIftMczlH30UupEXn05R6qAJrBDZW5Ctw56jrjYseLam4hRIVAw3XVVtGX3CS
	Q==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------xAOa79yi3ABp7zku3yDVyCG9
Content-Type: multipart/mixed; boundary="------------f7tnVTZer3R6bdctOBlJjYS0";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: Bart Van Assche <bvanassche@acm.org>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stern@rowland.harvard.edu, zhanjun@uniontech.com, niecheng1@uniontech.com,
 guanwentao@uniontech.com, chenlinxuan@uniontech.com,
 Xinwei Zhou <zhouxinwei@uniontech.com>, Xu Rao <raoxu@uniontech.com>,
 Yujing Ming <mingyujing@uniontech.com>
Message-ID: <e2f01a1f-8da5-4e7b-b909-d920a792756a@uniontech.com>
Subject: Re: [RESEND PATCH v3] scsi: Bypass certain SCSI commands on disks
 with "use_192_bytes_for_3f" attribute
References: <ADB8844D07D40320+20250224034832.40529-1-wangyuli@uniontech.com>
 <ad1ba59a-3a67-4b3c-a05d-c4e56405cc19@acm.org>
 <0A01BD2F489C764A+647ab6a7-35e5-4aa4-b8d1-c177be1724c6@uniontech.com>
 <3b6cca0d-7aa5-43b6-8f4a-429f17558121@acm.org>
In-Reply-To: <3b6cca0d-7aa5-43b6-8f4a-429f17558121@acm.org>

--------------f7tnVTZer3R6bdctOBlJjYS0
Content-Type: multipart/mixed; boundary="------------g70P2ViavHlgOVjGx7l8fjPX"

--------------g70P2ViavHlgOVjGx7l8fjPX
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgQmFydCwNCg0KT24gMjAyNS8yLzI2IDA0OjU0LCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+DQo+IEhhcyBpdCBiZWVuIGNvbnNpZGVyZWQgdG8gdHJ1bmNhdGUgdGhlIE1PREUgU0VO
U0UgYnVmZmVyIHRvIDE5MiBieXRlcw0KPiBpbnN0ZWFkIG9mIHJlamVjdGluZyB0aGUgTU9E
RSBTRU5TRSBjb21tYW5kPw0KPg0KPg0KQWxhbiBTdGVybiBoYXMgcmFpc2VkIGEgcmVsYXRl
ZCBpc3N1ZSBiZWZvcmUuIE15IHRha2Ugb24gdGhpcyBpcyANCm91dGxpbmVkIGJlbG93Lg0K
DQpJIHBlcnNvbmFsbHkgdGhpbmsgdGhhdCBpdCBpcyBub3QgYXBwcm9wcmlhdGUgdG8gbW9k
aWZ5IGl0IGRpcmVjdGx5DQp0byAxOTIuIEFmdGVyIGFsbCwgaXQgaXMgY2FsbGVkIGJ5IHRo
ZSB1c2VyIHRocm91Z2ggaW9jdGwsIGFuZCB0aGUNCmtlcm5lbCBpdHNlbGYgd2lsbCBub3Qg
Y29uc3RydWN0IHN1Y2ggYSBkYXRhIGZyYW1lLiBBcyBzaG93biBpbiB0aGUNCmZvbGxvd2lu
ZyBjb2RlOg0KDQpzZF9yZWFkX3dyaXRlX3Byb3RlY3RfZmxhZyhzdHJ1Y3Qgc2NzaV9kaXNr
ICpzZGtwLCB1bnNpZ25lZCBjaGFyICpidWZmZXIpDQogwqDCoMKgwqDCoCB7DQogwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGludCByZXM7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHN0cnVjdCBzY3NpX2RldmljZSAqc2RwID0gc2RrcC0+ZGV2aWNlOw0KIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBzdHJ1Y3Qgc2NzaV9tb2RlX2RhdGEgZGF0YTsNCiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgaW50IG9sZF93cCA9IHNka3AtPndyaXRlX3Byb3Q7DQoNCiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgc2V0X2Rpc2tfcm8oc2RrcC0+ZGlzaywgMCk7DQogwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChzZHAtPnNraXBfbXNfcGFnZV8zZikgew0Kc2Rf
Zmlyc3RfcHJpbnRrKEtFUk5fTk9USUNFLCBzZGtwLCAiQXNzdW1pbmcgV3JpdGUgRW5hYmxl
ZFxuIik7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1
cm47DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0NCg0KIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAoc2RwLT51c2VfMTkyX2J5dGVzX2Zvcl8zZikgew0KcmVzID0gc2RfZG9f
bW9kZV9zZW5zZShzZHAsIDAsIDB4M0YsIGJ1ZmZlciwgMTkyLCAmZGF0YSwgTlVMTCk7DQoN
Cg0KTGluazogDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMTM3OTAyRkVFMDNDQ0Iz
Qis2MTMwMjI3Zi05ZGRjLTQwNDMtOTk0NS1kYTQ2NWMyOGQ5ZDFAdW5pb250ZWNoLmNvbS8N
Cg0KLS0gDQpXYW5nWXVsaQ0K
--------------g70P2ViavHlgOVjGx7l8fjPX
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

--------------g70P2ViavHlgOVjGx7l8fjPX--

--------------f7tnVTZer3R6bdctOBlJjYS0--

--------------xAOa79yi3ABp7zku3yDVyCG9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZ759CAUDAAAAAAAKCRDF2h8wRvQL7lYV
AQDlgt3lmyKrSI8spTwU1k34ewMv8doiPEqMzcEatn/sCQEAv3nNELSEOqrsDc4KF5ezFd4jEF68
NOmlza7lAer61AA=
=T7n1
-----END PGP SIGNATURE-----

--------------xAOa79yi3ABp7zku3yDVyCG9--
