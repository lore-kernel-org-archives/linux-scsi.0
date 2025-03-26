Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B831F426F;
	Wed, 26 Mar 2025 16:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743007946; cv=none; b=eB/vgXOj5TbdYmqDK0iWaz9hBRV6fzWKiBYUYsOSe3Cl50g5foEG719ACjCQL0qGhNSGILhdc/D7AdCdF7kKVyXUywsgaNgdZwZdtxaAiTNGZy6HJhRSF+ulauRbCgGkT8a/KPkVEJVno6KraF7AESuQY5YtpL6dqItUO4Nwwiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743007946; c=relaxed/simple;
	bh=HNvDSaKI43Gmw7okUujqwa4owv+5Vvzm79hkohFgX2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CJ9fPvOsrLS0XCdUZ8LegS49OJ+X56pAf2ilbPL6I8ryNqNOBuN3d5Cj72JXEHPIb7ski8qUx5y6v6/dcpkIYS83Igei6vxsmEzr7iHqLE8WFHSTE1/CKcfzjlUWJhs/s/U/vI4w0eBetwk1/OOujbGUjrkAEWeyVBUllzTvqt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=pa0GWthu; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="pa0GWthu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1743007880;
	bh=HNvDSaKI43Gmw7okUujqwa4owv+5Vvzm79hkohFgX2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=pa0GWthuNZ4/Fo0/SyMJgCIPiF5eMjLdJs8mWj3ipJsfsTs4ZTNMWDi07/ASxq6CL
	 EeRgSXhploM8mkuKPhLGV9EeMTRLepkBssk0XvlY/bVZdqrNFiP9GdF50qDta6MMCP
	 Fno1IDPCGrCsxsqmMHleKxyRLJ7fBoRZxuk++Wco=
X-QQ-mid: bizesmtpip2t1743007866ts577ud
X-QQ-Originating-IP: 47EvV1pGikHzHLCQzj/iZjWDctezyilcm5X1Th4G4KY=
Received: from [IPV6:240e:668:120a::212:156] ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 27 Mar 2025 00:51:04 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9519405561713743635
EX-QQ-RecipientCnt: 12
Message-ID: <F8C142341D03C19E+0f802042-6f12-43f3-bd2f-ce5463f6ae11@uniontech.com>
Date: Thu, 27 Mar 2025 00:51:03 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH v3] scsi: Bypass certain SCSI commands on disks
 with "use_192_bytes_for_3f" attribute
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, bvanassche@acm.org,
 zhanjun@uniontech.com, niecheng1@uniontech.com, guanwentao@uniontech.com,
 Xinwei Zhou <zhouxinwei@uniontech.com>, Xu Rao <raoxu@uniontech.com>,
 Yujing Ming <mingyujing@uniontech.com>
References: <798FB027101C5650+20250318061125.477498-1-wangyuli@uniontech.com>
 <yq17c4j9pcr.fsf@ca-mkp.ca.oracle.com>
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
In-Reply-To: <yq17c4j9pcr.fsf@ca-mkp.ca.oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------dDls60ovBSf9hRwycZV7gBn0"
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: OCS1m6WKrGZ8MaUUE2ukvYlYU1ZiaOnaBb7kqpieIecNFMBGvv6bwkhJ
	+0zJpBucKP81wUl/EFtpsFwc+4e0PsRQGRemlh8ebxdaqo0oNYyUDCalsQu99fZoHWQZ9ul
	8PDR8vNsiGkuAikd1xxH6RJff/arIZ4FK19FQNc1kA0ZfOwwJn3qaAJ8HO1nE4N9ashvkXy
	UQ/7NS2sCvU7/BEvqgylcauklPGrvo4GIvMTui4EGS70ZDd0u17ljPMlLr6js0hvx8oMip2
	D8G/OR6lZM3iHbXh9+KJRkUhBz3LwRuEJS47JiJ4fi35Tpfb009K45HXM5fQK1maOWvUVYD
	L/SDkF1ZpyJ0P3zQOY4IAMSgjVz0h9zOuaMKj6kY8KvywpBS1fCK8QjOTlF6+Lt4E9Ed1ca
	kTc2oi4rhXZ+8vpy3s7o8f72crxJUDkg8EvOL1jJtan1sQsPztx3rt7IEkWYsdoe7I9NEnM
	zaWleSxqVROkaX8G34M9QZmyY8zWwOXYR3kDBno1BAWIxx6zESb3NWfoN9SdyrqjmvqLpJ9
	dCtXUc8ba38qse/y74Ch7Q62w2z4x+LaCiGsyVMI4ZaQahXruae19Z46gs2AO4IdeQ+jy8d
	n0GvVcIzZDIHbCiY/PaQ2Ka4R48LZ0HL1vKsdgZ+JepizM0fs6hmGQWcBrIuEHVczQJXk2f
	ZlVg7H0ufHYhquWcrsylQ0XopGSsqftEgisrnZoaViDXK7t1ACm6z9hha6BT3zS7GB9dnMQ
	spEuKVBeQv1A7ZqnP4rGRmilwOzs7rdyxD24K7V2XC5azSAhbdmVGI2OflJPVli2vcRJOrq
	Q25AlrNzJ7XRz3GgCOEbEkGz2pYYTcioAG951QU+t9qZTaMc9o2sMplYmgkF+VMhIbUHFnM
	Gd8OSMrnWlpiXmwYcN38LmQ5tnVVL+AQVhBYWNDvvYccp/JDdik2NqGTwRfgb9F3/HpBc/+
	MJGw6oNJ7aUCJ8qyWkMCzWdxIbBS+U13zWezx1KDPDGaCQw2YzcJCqcZnfGN3G/V9gOKusa
	KIjxrJDG1UOXUE2tP0Oqyp74opa9eaF3ZEyFPkp+2Crazlv+AyiXfXexEcHc4dogXhsB+ne
	Uf2zM+PztlL
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------dDls60ovBSf9hRwycZV7gBn0
Content-Type: multipart/mixed; boundary="------------0KBuTpe10EV8LGvwoO7ULCvS";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, bvanassche@acm.org,
 zhanjun@uniontech.com, niecheng1@uniontech.com, guanwentao@uniontech.com,
 Xinwei Zhou <zhouxinwei@uniontech.com>, Xu Rao <raoxu@uniontech.com>,
 Yujing Ming <mingyujing@uniontech.com>
Message-ID: <0f802042-6f12-43f3-bd2f-ce5463f6ae11@uniontech.com>
Subject: Re: [RESEND PATCH v3] scsi: Bypass certain SCSI commands on disks
 with "use_192_bytes_for_3f" attribute
References: <798FB027101C5650+20250318061125.477498-1-wangyuli@uniontech.com>
 <yq17c4j9pcr.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq17c4j9pcr.fsf@ca-mkp.ca.oracle.com>

--------------0KBuTpe10EV8LGvwoO7ULCvS
Content-Type: multipart/mixed; boundary="------------wh0C0ScSAfIWlhh6EGSeTiuW"

--------------wh0C0ScSAfIWlhh6EGSeTiuW
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgTWFydGluIEsuIFBldGVyc2VuLA0KDQpPbiAyMDI1LzMvMjEgMDk6MDgsIE1hcnRpbiBL
LiBQZXRlcnNlbiB3cm90ZToNCj4gSSBhbSByZWFsbHkgbm90IGEgZmFuIG9mIHVzaW5nIGlu
LWtlcm5lbCB3b3JrYXJvdW5kcyB0byBpbnRlcmNlcHQNCj4gcGFzc3Rocm91Z2ggY29tbWFu
ZHMuDQo+DQo+IFdoeSBkb2VzIGRvZXMgbHNodyBwZXJmb3JtIGEgTU9ERSBTRU5TRSBpbiB0
aGUgZmlyc3QgcGxhY2U/IFdoYXQNCj4gaW5mb3JtYXRpb24gaXMgaXQgbG9va2luZyBmb3Ig
dGhhdCBpc24ndCBhdmFpbGFibGUgaW4gc3lzZnM/DQoNCkkga25vdyB0aGlzIGlzIGEgd29y
a2Fyb3VuZCB0byBzb2x2ZSB0aGUgcHJvYmxlbSBhdCB0aGUgYXBwbGljYXRpb24gbGF5ZXIu
DQoNClRoZSBwcm9ibGVtIGlzIHRoYXQgdGhlIGtlcm5lbCBkb2VzIG5vdCBrbm93IHdoYXQg
b3BlcmF0aW9ucyB0aGUgDQphcHBsaWNhdGlvbiB3aWxsIGRvIHRvIHRoZSBkaXNrIHRocm91
Z2ggaW9jdGwuDQoNCkludGVyY2VwdGluZyB0aGlzIGlsbGVnYWwgY29tbWFuZCBpbiBrZXJu
ZWwgbW9kZSB3aWxsIGhlbHAgaW1wcm92ZSB0aGUgDQpzdGFiaWxpdHkgb2YgdGhlIHN5c3Rl
bS4NCg0KVGhlIGZvbGxvd2luZyBpcyB0aGUgbG9nIG9mIHRoZSBleGNlcHRpb24gSSBjYXVn
aHQ6DQoNCjEwOjIyOjIyIDIwMjRdIHF1ZXVlIGNtZCA9PT09PTFhIDAwIDNmIDAwIGZmIDAw
IDEwOjIyOjIyIDIwMjRdIENQVTogNyANClBJRDogNjAwMCBDb21tOiBsc2h3IFRhaW50ZWQ6
IEcgTyA0LjE5LjAtYXJtNjQtZGVza3RvcHRlc3QgIzE5NyAxMDoyMjoyMiANCjIwMjRdIEhh
cmR3YXJlIG5hbWU6IFRIVEYgQ2hhb1hpYW5nIFNlcmllcy9USFRGLUZURDMwMDAtWlgyMDAt
TUYyODFDLCANCkJJT1MgS0w0LjI4LkJYQy5ELjAxNi4yNDEwMjUuUiAxMC8yNS8yMDI0IDE3
OjUxOjUxIDEwOjIyOjIyIDIwMjRdIENhbGwgDQp0cmFjZTogMTA6MjI6MjIgMjAyNF0gZHVt
cF9iYWNrdHJhY2UrMHgwLzB4MWEwIDEwOjIyOjIyIDIwMjRdIA0Kc2hvd19zdGFjaysweDI0
LzB4MzAgMTA6MjI6MjIgMjAyNF1kdW1wX3N0YWNrKzB4YTgvMHhjYyAxMDoyMjoyMiAyMDI0
XSANCnF1ZXVlY29tbWFuZCsweGJjLzB4MTk4IFt1c2Jfc3RvcmFnZV0gMTA6MjI6MjIgMjAy
NF0gDQpzY3NpX2Rpc3BhdGNoX2NtZCsweGE0LzB4Mjk4IDEwOjIyOjIyIDIwMjRdc2NzaV9y
ZXF1ZXN0X2ZuKzB4NDdjLzB4N2E4IA0KMTA6MjI6MjIgMjAyNF0gX19ibGtfcnVuX3F1ZXVl
KzB4NTAvMHg4OCAxMDoyMjoyMiAyMDI0XSANCmJsa19leGVjdXRlX3JxX25vd2FpdCsweGUw
LzB4MTYwIDEwOjIyOjIyIDIwMjRdIA0Kc2dfY29tbW9uX3dyaXRlLmlzcmEuMTErMHgyNTQv
MHg2YzAgMTA6MjI6MjIgMjAyNF0gDQpzZ19uZXdfd3JpdGUuaXNyYS4xMisweDE3OC8weDMw
OCAxMDoyMjoyMiAyMDI0XSBzZ19pb2N0bCsweGViNC8weDExZDggDQoxMDoyMjoyMiAyMDI0
XSBkb192ZnNfaW9jdGwrMHhiMC8weDg2OCAxMDoyMjoyMiAyMDI0XSANCmtzeXNfaW9jdGwr
MHg4NC8weGI4IDEwOjIyOjIyIDIwMjRdIF9fYXJtNjRfc3lzX2lvY3RsKzB4MjgvMHgzOCAx
MDoyMjoyMiANCjIwMjRdIGVsMF9zdmNfY29tbW9uKzB4YTAvMHgxOTAgMTA6MjI6MjIgMjAy
NF0gZWwwX3N2Y19oYW5kbGVyKzB4YWMvMHhiOCANCjEwOjIyOjIyIDIwMjRdIGVsMF9zdmMr
MHg4LzB4Yw0KDQpJIGVuY291bnRlcmVkIHRoaXMgcHJvYmxlbSBpbiBtdWx0aXBsZSBkZXZp
Y2VzLCBjYXVzaW5nIHRoZSBkaXNrIHRvIGJlIA0KdW5yZWNvZ25pemFibGUuIEkgdGhpbmsg
aXQgaXMgbmVjZXNzYXJ5IHRvIGRvIHRoaXMgdG8gbWFrZSB0aGUgc3lzdGVtIA0KbW9yZSBy
b2J1c3QuDQoNClRoYW5rcywNCi0tIA0KV2FuZ1l1bGkNCg==
--------------wh0C0ScSAfIWlhh6EGSeTiuW
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

--------------wh0C0ScSAfIWlhh6EGSeTiuW--

--------------0KBuTpe10EV8LGvwoO7ULCvS--

--------------dDls60ovBSf9hRwycZV7gBn0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZ+QwdwUDAAAAAAAKCRDF2h8wRvQL7noi
AQCiqoqQfgfAb6kDKpEN/3lSxPSeekNexdpaVGwx3UlT4AEAovtQ0WiyGblwYaHHE6Vno31h6KRr
+lpihlvug0JohAI=
=nGzX
-----END PGP SIGNATURE-----

--------------dDls60ovBSf9hRwycZV7gBn0--

