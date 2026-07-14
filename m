Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA342F8E94
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 06:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=222.66.158.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784012233; cv=none; b=J9K+O0+Oq5gxRWu0yLlvOUObN1ojUVTPZWnILzWWesWpO32OOfGmkEJsSsdNEbPCZmdfe/KvNixwmg13MzHFky0QEEfI8tTEz+iEeshlmeZt7jFYEkK/sDT5XrDQFGCqrUd0g3qDAG8rCVSmUIoqdSsTYh/coyhSRXf7m1K3WSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784012233; c=relaxed/simple;
	bh=DN+lupsFEn6wv+ZWV4X58757icEvEGStkZznsCyQ1Wc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BpXG5y1WUq2ha8AHM0tgKPMOiXCEx0arSDUdAE5xKijBsFO+lV3DZ0Au0LfAf9h0wAjhtovvCXG6SJi7ulso1odrbUrvn2R9J9ISlMNsdQihi99v7oCqPeUPGLfn+VNpWqgKnAiSTBjDe9QqA3asxzrS0eRpWlu23f0WvqMNYts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com; spf=pass smtp.mailfrom=unisoc.com; dkim=pass (2048-bit key) header.d=unisoc.com header.i=@unisoc.com header.b=TmKK1o15; arc=none smtp.client-ip=222.66.158.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unisoc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unisoc.com header.i=@unisoc.com header.b="TmKK1o15"
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTPS id 66E6uTS4081992
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 14 Jul 2026 14:56:29 +0800 (+08)
	(envelope-from kui.sun@unisoc.com)
Received: from SHDLP.spreadtrum.com (zeshmbx.spreadtrum.com [10.0.1.206])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4gzqp63lcvz2PTxKd;
	Tue, 14 Jul 2026 14:55:58 +0800 (CST)
Received: from zeshmbx08.spreadtrum.com (10.29.3.106) by
 zeshmbx.spreadtrum.com (10.0.1.206) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 14 Jul 2026 14:56:21 +0800
Received: from zeshmbx08.spreadtrum.com ([fe80::e01e:2441:3a50:dadb]) by
 zeshmbx08.spreadtrum.com ([fe80::e01e:2441:3a50:dadb%17]) with mapi id
 15.00.1497.048; Tue, 14 Jul 2026 14:56:21 +0800
From: =?utf-8?B?5a2Z6a2BIChLdWkgU3VuKQ==?= <kui.sun@unisoc.com>
To: Bart Van Assche <bvanassche@acm.org>,
        Neil Armstrong
	<neil.armstrong@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "andre.draszik@linaro.org" <andre.draszik@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        =?utf-8?B?5ZSQ5pyI5p6XIChZdWVsaW4gVGFuZyk=?= <yuelin.tang@unisoc.com>,
        =?utf-8?B?6ZmI5paH6LaFIChXZW5jaGFvIENoZW4p?= <Wenchao.Chen@unisoc.com>,
        =?utf-8?B?5byg5aaC5rOJIChSYWluIFpoYW5nKQ==?= <Rain.Zhang@unisoc.com>
Subject: =?utf-8?B?5Zue5aSNOiDnrZTlpI06IFtSRkNdIFNpZ25pZmljYW50IFJhbmRvbSBJL08g?=
 =?utf-8?B?UGVyZm9ybWFuY2UgUmVncmVzc2lvbiBpbiBMaW51eCBLZXJuZWwgNi4xOCAo?=
 =?utf-8?B?VXAgdG8gMjcuNyUpIExpa2VseSBDYXVzZWQgYnkgQ29tbWl0IDNjN2FjNDBk?=
 =?utf-8?Q?7322?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUkZDXSBTaWduaWZpY2FudCBSYW5kb20gSS9PIFBlcmZvcm1h?=
 =?utf-8?B?bmNlIFJlZ3Jlc3Npb24gaW4gTGludXggS2VybmVsIDYuMTggKFVwIHRvIDI3?=
 =?utf-8?Q?.7%)_Likely_Caused_by_Commit_3c7ac40d7322?=
Thread-Index: Ad0PYz14eL5yCSXkTdewaVgxWTlWPgA1fqOAADuDkfAAYJ4dgAAppvVw
Date: Tue, 14 Jul 2026 06:56:21 +0000
Message-ID: <0ece89c4070a4ef58001bb5ed5e41bb1@zeshmbx08.spreadtrum.com>
References: <12a8417dc8644a71b9cb25c53c93805a@zeshmbx08.spreadtrum.com>
 <d426b4d5-cdf5-4090-8e94-62e652f712dc@acm.org>
 <7863f3e51a8e4d52acdd24a6aea9cf5f@zeshmbx08.spreadtrum.com>
 <60f358dd-82b7-486d-baba-a51c3fa5e9d5@acm.org>
In-Reply-To: <60f358dd-82b7-486d-baba-a51c3fa5e9d5@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MAIL:SHSQR01.spreadtrum.com 66E6uTS4081992
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1784012196;
	bh=DN+lupsFEn6wv+ZWV4X58757icEvEGStkZznsCyQ1Wc=;
	h=From:To:CC:Subject:Date:References:In-Reply-To;
	b=TmKK1o15eGy49t7iQatiZlrYP/5sUg++KYx5FawhbjaqSphKPm4+IYUyAzEnqnuZZ
	 XiXKyKnJCjAPG7S6ofCDKDlQ4rxBQiJlUUHRKJihhh3TcXaXXbeNulcImeQXBF3XQI
	 9v+hYuVn1nXFZxmXmoFfjG8nrcDzYEKDsbB84LYP7UkDcu68iSwGBvZg8H/oq7kmvN
	 LA85XkEua7EIT+8j75fSPkHwsVWn7LCSBDs8VkZEEtIif9V2miJ9l28IdcnoXhzO7T
	 3VYp/OO8Q5EoW8D0I3n9PcSsFvEAR73fBIpQHJuVQkn0YkR1QrRRcsvzXvbD3oNezQ
	 ZkV+eUE1ZWdlQ==

T24gNy8xNC8yNiAxOjI3IEFNLCAoQmFydCBWYW4gQXNzY2hlKSB3cm90ZToNCj5Eb2VzIHRoaXMg
cGF0Y2ggc2VyaWVzIGZpeCB0aGUgcGVyZm9ybWFuY2UgcmVncmVzc2lvbj8gUGxlYXNlIG5vdGUg
dGhhdCBwYXRjaCA0LzQgb2YgdGhpcyBzZXJpZXMgaXMgbm90IHlldCBwcmVzZW50IGluIHRoZSB1
cHN0cmVhbSBrZXJuZWw6DQo+IFtmMmZzLWRldl0gW1BBVENIIDAvNF0gUmVkdWNlIHRoZSB0aW1l
IHNwZW50IGluIGludGVycnVwdCBjb250ZXh0IChodHRwczovL3NvdXJjZWZvcmdlLm5ldC9wL2xp
bnV4LWYyZnMvbWFpbG1hbi9saW51eC1mMmZzLWRldmVsL3RocmVhZC80YjMzN2M3Zi0yZmJkLTQ3
YjYtOWM4Yy01ODdlN2I1NTEzZjElNDBrZXJuZWwub3JnLyNtc2c1OTM0NTA0OSkuDQpXZSB0cmll
ZCBpbnRlZ3JhdGluZyB0aGUgYWZvcmVtZW50aW9uZWQgRjJGUyBtb2RpZmljYXRpb25zIGFuZCB0
ZXN0ZWQgdGhpcyB2ZXJzaW9uIHVuZGVyIGRlZmF1bHQgc2V0dGluZ3M6ICANCmNhdCAvc3lzL2Zz
L2YyZnMvc2RhNDcvbWF4X2F0Y193cml0ZV9iaW9fc2l6ZQ0KMTYzODQNCkhvd2V2ZXIsIHdlIG9i
c2VydmVkIGFsbW9zdCBubyBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudC46DQpEZXZpY2UJS2VybmVs
IFZlcnNpb24gICAgICAJCQkJCVRlc3QxCVRlc3QyCVRlc3QzCUF2ZXJhZ2UNClQ2MTUJNS4xNQkg
ICAgICAgICAgICAgICAgCQkJCQkxODYwNAkxODMxNAkxNzczMgkxODIxNi42Nw0KVDYxNQk2LjE4
ICAgICAgICAgICAgICAgIAkJCQkJMTMzNzIJMTMwODEJMTMwODEJMTMxNzguMDDvvIjihpMyNy42
NiXvvIkNClQ2MTUJNi4xOO+8iHJldmVydGVkIDNjN2FjNDApIAkJCQkxODMxNAkxODYwNAkxODYw
NAkxODUwNy4zMw0KVDYxNQk2LjE477yIYWRkICJSZWR1Y2UgdGhlIHRpbWUgIHNwZW50Li4uIikg
CTE0MjQ0CTEzMzcyCTEzMjU1CTEzNjIzLjMzDQpUaGFua3MuDQoNCi0tLS0t6YKu5Lu25Y6f5Lu2
LS0tLS0NCuWPkeS7tuS6ujogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+IA0K
5Y+R6YCB5pe26Ze0OiAyMDI25bm0N+aciDE05pelIDE6MjcNCuaUtuS7tuS6ujog5a2Z6a2BIChL
dWkgU3VuKSA8a3VpLnN1bkB1bmlzb2MuY29tPjsgTmVpbCBBcm1zdHJvbmcgPG5laWwuYXJtc3Ry
b25nQGxpbmFyby5vcmc+OyBBbGltIEFraHRhciA8YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+OyBh
bmRyZS5kcmFzemlrQGxpbmFyby5vcmcNCuaKhOmAgTogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5v
cmc7IOWUkOaciOaelyAoWXVlbGluIFRhbmcpIDx5dWVsaW4udGFuZ0B1bmlzb2MuY29tPjsg6ZmI
5paH6LaFIChXZW5jaGFvIENoZW4pIDxXZW5jaGFvLkNoZW5AdW5pc29jLmNvbT4NCuS4u+mimDog
UmU6IOetlOWkjTogW1JGQ10gU2lnbmlmaWNhbnQgUmFuZG9tIEkvTyBQZXJmb3JtYW5jZSBSZWdy
ZXNzaW9uIGluIExpbnV4IEtlcm5lbCA2LjE4IChVcCB0byAyNy43JSkgTGlrZWx5IENhdXNlZCBi
eSBDb21taXQgM2M3YWM0MGQ3MzIyDQoNCg0K5rOo5oSPOiDov5nlsIHpgq7ku7bmnaXoh6rkuo7l
pJbpg6jjgILpmaTpnZ7kvaDnoa7lrprpgq7ku7blhoXlrrnlronlhajvvIzlkKbliJnkuI3opoHn
grnlh7vku7vkvZXpk77mjqXlkozpmYTku7bjgIINCkNBVVRJT046IFRoaXMgZW1haWwgb3JpZ2lu
YXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtz
IG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSByZWNvZ25pemUgdGhlIHNlbmRlciBhbmQg
a25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KDQoNCg0KT24gNy8xMS8yNiA0OjIxIEFNLCDlrZnp
rYEgKEt1aSBTdW4pIHdyb3RlOg0KPiBXZSBoYXZlIGFscmVhZHkgaW5jbHVkZWQgdGhlc2UgdHdv
IGZpeGVzLCB3aGljaCBhcmUgcmVsYXRlZCB0byANCj4gc3RhYmlsaXR5LiBUaGUgaXNzdWUgd2Un
cmUgZW5jb3VudGVyaW5nIGlzIHBlcmZvcm1hbmNlLXJlbGF0ZWQuDQpEb2VzIHRoaXMgcGF0Y2gg
c2VyaWVzIGZpeCB0aGUgcGVyZm9ybWFuY2UgcmVncmVzc2lvbj8gUGxlYXNlIG5vdGUgdGhhdCBw
YXRjaCA0LzQgb2YgdGhpcyBzZXJpZXMgaXMgbm90IHlldCBwcmVzZW50IGluIHRoZSB1cHN0cmVh
bSBrZXJuZWw6DQpbZjJmcy1kZXZdIFtQQVRDSCAwLzRdIFJlZHVjZSB0aGUgdGltZSBzcGVudCBp
biBpbnRlcnJ1cHQgY29udGV4dCAoaHR0cHM6Ly9zb3VyY2Vmb3JnZS5uZXQvcC9saW51eC1mMmZz
L21haWxtYW4vbGludXgtZjJmcy1kZXZlbC90aHJlYWQvNGIzMzdjN2YtMmZiZC00N2I2LTljOGMt
NTg3ZTdiNTUxM2YxJTQwa2VybmVsLm9yZy8jbXNnNTkzNDUwNDkpLg0KDQpUaGFua3MsDQoNCkJh
cnQuDQo=
