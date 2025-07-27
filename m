Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374A21DC1AB
	for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2025 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753639130; cv=pass; b=bZ2e/ntRspGB6x2FtQMag3QrcsVICX0miuz3oGkF7h1UpGD4HVXoFZi+aqElZlZxXlOhDeIssdxtB40B51ob76fz0jIDmE+Cqqw9BXtfQ4vzGIMqdJ2HJyVw+AH5nbmvg81FVw3VYajTspn7tcn/DVUpW4tqdQBJuEcSVqeVgxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753639130; c=relaxed/simple;
	bh=DY9wnwBtnksXvfM8NCQmlVQDwC2ahgcZpsbVrpPaYr8=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To; b=ojc42jn5yyylowKMArDPwxoDgvnNikPhXvA4ZklK8LUqRIlgOx0SWBbsJG1PzzmJwohv8UiVQprxISPyS/cuaFce4yQZNvso7PYHE5F2BNZxChY7U1due5MxgDTFgZhkWK5Ax1KVFdYinZIgo7C24ht4J5OiL09S553M6ISOvYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de; spf=none smtp.mailfrom=garloff.de; dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b=P6ZmmZF4; dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b=QYW1ojZ5; arc=pass smtp.client-ip=85.215.255.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=garloff.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b="P6ZmmZF4";
	dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b="QYW1ojZ5"
ARC-Seal: i=1; a=rsa-sha256; t=1753639120; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ayRdoi2468kvo0GSL+EonxT17NIosDDbqhIRVyHelLI1y6GXnB/twW0VIzieRfhwNX
    nuvW7244gUdhswT3Vku6hzB4BCWTQvr/bgDksmHQO2YvpoV0BX8rVKCt+ovtKZ3B87Zw
    RIGoW2hXXH79/p7kYGpGtNN8wk1DMR5kyR4WbApSowjyk/qAk/472SJ5/z8Qkk/97Swj
    HpNSxhz9MLAPRavDEA58BMv52V+kqxCPWWGCFgDCIUSqTzZsGjKYOErNBwvvbED8cvG8
    4LmU42ElhvhEu6qLCPkU/qMayVEafm1P2LK2T+AqceYw3AqG91RmPi/LWszz8Ebuz0XC
    sqmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1753639120;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:To:From:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=wavFCnQzRo5ujqo7n2oapOLiGCP2CQ+bQKP63brHZDw=;
    b=KXcZVX4BAZVcuCznWJVkmpreae8FHZbXaeHUvMdWJtIaQkgRkHojY1lYp/4kTQnp30
    /Udj5FBY02y9g9uOxxHHa5Ehg3Pz58mrVxKC2dHelIdvJ77fnVF1kLPZXsQm8MpLsJLG
    8Jd6oM6qO4ShOjZ7OuFZCEwYmB3V2ILqyk1X4bl/QJFRpT8oKUyJZw4rIe156/2h04A+
    +LmANmfAUsbXEHM6WF89f3E3NGuAGk7m4LieHp5sCFY/DMwJgLcwQvphNnI5lncd+Nvp
    sMDL5Vs62p/veyfq2Al1P+w3ulOWyLviGRk9B7qfrRWixlsoyOQNASgZVsWhbVaRtkaZ
    VHjA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753639120;
    s=strato-dkim-0002; d=garloff.de;
    h=In-Reply-To:References:To:From:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=wavFCnQzRo5ujqo7n2oapOLiGCP2CQ+bQKP63brHZDw=;
    b=P6ZmmZF4zjqMI3cdN0rwZDbsLkOqgbhu3zg7pnJj9hE2yMyZiaQDVI5+ZymTsP/L6N
    Q4iH5WYjbwTq4mv0ZVvAV/zJzFZuY2qL4e0OVS8txrtd41vJhMGqupKXJwCZK6tFsGwO
    qLb8wejvMkVVCoBqAlqS1lkl1Blo8JP8bBzmzgfq3j+ol/b1PmBqg967T7Sx973pbWXm
    D7y1toux+QEy/LaPg4HxWD37JvyxUIefCQfwhC05aTqTfMmD1+oCTG75+IIjCDxOzzpy
    W6iXt20KvpuMlIqAKsKpaVrRaAgDOFwIzwjbMn66cOqxLPs/9ZqlL/t5wQpziZg/WDj1
    5yiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753639120;
    s=strato-dkim-0003; d=garloff.de;
    h=In-Reply-To:References:To:From:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=wavFCnQzRo5ujqo7n2oapOLiGCP2CQ+bQKP63brHZDw=;
    b=QYW1ojZ5xmaHjEBSUCoaS+mmIblOuBL/CyCO9xNZ03q2wBmtQuoUg94Zu75SZTio2D
    6nfSbbDVC9iRS3MCHjCw==
X-RZG-AUTH: ":J3kWYWCveu3U88BfwGxYwcN+YZ41GOdzUdLW+J8VEEt2iJSgSWY/glqoxjGO"
Received: from mail.garloff.de
    by smtp.strato.de (RZmta 52.1.2 DYNA|AUTH)
    with ESMTPSA id L60c3716RHwebAy
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate)
    for <linux-scsi@vger.kernel.org>;
    Sun, 27 Jul 2025 19:58:40 +0200 (CEST)
Received: from [192.168.155.137] (ap5.garloff.de [192.168.155.10])
	by mail.garloff.de (Postfix) with ESMTPSA id BF83362479
	for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2025 19:58:39 +0200 (CEST)
Content-Type: multipart/mixed; boundary="------------ptMhzKIYuZTkHnbDE7pSvgxs"
Message-ID: <b8ae15bd-7a26-4f7c-ae61-ad282bc59562@garloff.de>
Date: Sun, 27 Jul 2025 19:58:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Patch [1/3] Support eager_unmap for non ldpme sd devs
From: Kurt Garloff <kurt@garloff.de>
To: linux-scsi@vger.kernel.org
References: <021904d2-f59d-44f3-9eec-6dfd7379b3f0@garloff.de>
Content-Language: en-US
Autocrypt: addr=kurt@garloff.de; keydata=
 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
In-Reply-To: <021904d2-f59d-44f3-9eec-6dfd7379b3f0@garloff.de>
Content-Transfer-Encoding: 7bit

This is a multi-part message in MIME format.
--------------ptMhzKIYuZTkHnbDE7pSvgxs
Content-Type: multipart/alternative;
 boundary="------------nDqhjkE4FUxzbBFQo6ALg0Ue"

--------------nDqhjkE4FUxzbBFQo6ALg0Ue
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


--------------nDqhjkE4FUxzbBFQo6ALg0Ue
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body text="#000000" bgcolor="#deddda">
    <br>
  </body>
</html>

--------------nDqhjkE4FUxzbBFQo6ALg0Ue--
--------------ptMhzKIYuZTkHnbDE7pSvgxs
Content-Type: text/x-patch; charset=UTF-8; name="eager-unmap-1.diff"
Content-Disposition: attachment; filename="eager-unmap-1.diff"
Content-Transfer-Encoding: base64

Y29tbWl0IGExNGQzNzc1NzhhZjNjOGZjOGRkMWFmYjE4ZjNlZDRhZTk1ZmRlMzkKQXV0aG9y
OiBLdXJ0IEdhcmxvZmYgPGt1cnRAZ2FybG9mZi5kZT4KRGF0ZTogICBTdW4gSnVsIDI3IDE1
OjUxOjUxIDIwMjUgKzAwMDAKCiAgICBlYWdlcl91bm1hcDogRW5hYmxlIHVubWFwIGZvciBk
ZXZzIHdpdGhvdXQgbGJwbWUuCiAgICAKICAgIFdlIHRyeSB0byByZXRyaWV2ZSBWUEQgZGF0
YSBpZiBTQ1NJX0xFVkVMID49IDMgYW5kIFNCQyA+PSAzLgogICAgV2UgdXNlIHRoZSBoZWxw
IGZyb20gTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4K
ICAgIHRvIGNoZWNrIHRoZSBTQkMgdmVyc2lvbiwgc28gd2UgYXZvaWQgcXVlcnlpbmcgVlBE
IHBhZ2VzIGZvciBvbGQKICAgIGRldmljZXMgdGhhdCBtYXkgcmVhY3QgdW5ncmFjaW91c2x5
LgogICAgCiAgICBEZWZhdWx0IHRvIHVzaW5nIHVubWFwIGZvciBkZXZpY2VzIHRoYXQgc3Vw
cG9ydCBpdCAoU1NEcykKICAgIGV2ZW4gaWYgTEJQTUUgaXMgbm90IHNldCBJRiBzeXNhZG1p
biB3YW50cyBzbyBieSBzZXR0aW5nIHNkJ3MKICAgIGVhZ2VyX3VubWFwIG1vZHVsZSBwYXJh
bWV0ZXIgdG8gbm9uLXplcm8uIERlZmF1bHQgdG8gMCB0byBub3QgY2hhbmdlCiAgICBwcmV2
aW91cyBiZWhhdmlvciBieSBkZWZhdWx0LgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBLdXJ0
IEdhcmxvZmYgPGt1cnRAZ2FybG9mZi5kZT4KCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
c2QuYyBiL2RyaXZlcnMvc2NzaS9zZC5jCmluZGV4IGVlYWE2YWYyOTRiOC4uZWEzOGZlMTU0
OWU1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc2QuYworKysgYi9kcml2ZXJzL3Njc2kv
c2QuYwpAQCAtNzksNiArNzksMTIgQEAgTU9EVUxFX0FVVEhPUigiRXJpYyBZb3VuZ2RhbGUi
KTsKIE1PRFVMRV9ERVNDUklQVElPTigiU0NTSSBkaXNrIChzZCkgZHJpdmVyIik7CiBNT0RV
TEVfTElDRU5TRSgiR1BMIik7CiAKK3N0YXRpYyBpbnQgc2RfZWFnZXJfdW5tYXAgPSAwOwor
bW9kdWxlX3BhcmFtX25hbWVkKGVhZ2VyX3VubWFwLCBzZF9lYWdlcl91bm1hcCwgaW50LCBT
X0lSVUdPIHwgU19JV1VTUik7CitNT0RVTEVfUEFSTV9ERVNDKGVhZ2VyX3VubWFwLCAidXNl
IHVubWFwL3dzMTAvd3MxNiBhbHNvIGZvciBkZXZpY2VzICIKKwkJInRoYXQgc3VwcG9ydCBp
dCBpbiBMQlAgcGFnZSB3aXRob3V0IGNsYWltaW5nIExCUE1FICIKKwkJIih0aGlubHkgcHJv
dmlzaW9uZWQgZGV2aWNlcyksIGRlZmF1bHQgPSAwIik7CisKIE1PRFVMRV9BTElBU19CTE9D
S0RFVl9NQUpPUihTQ1NJX0RJU0swX01BSk9SKTsKIE1PRFVMRV9BTElBU19CTE9DS0RFVl9N
QUpPUihTQ1NJX0RJU0sxX01BSk9SKTsKIE1PRFVMRV9BTElBU19CTE9DS0RFVl9NQUpPUihT
Q1NJX0RJU0syX01BSk9SKTsKQEAgLTMzMDUsNyArMzMxMSw3IEBAIHN0YXRpYyB2b2lkIHNk
X3JlYWRfYXBwX3RhZ19vd24oc3RydWN0IHNjc2lfZGlzayAqc2RrcCwgdW5zaWduZWQgY2hh
ciAqYnVmZmVyKQogCiBzdGF0aWMgdW5zaWduZWQgaW50IHNkX2Rpc2NhcmRfbW9kZShzdHJ1
Y3Qgc2NzaV9kaXNrICpzZGtwKQogewotCWlmICghc2RrcC0+bGJwbWUpCisJaWYgKCFzZGtw
LT5sYnBtZSAmJiAhc2RfZWFnZXJfdW5tYXApCiAJCXJldHVybiBTRF9MQlBfRlVMTDsKIAog
CWlmICghc2RrcC0+bGJwdnBkKSB7CkBAIC0zMzQ4LDcgKzMzNTQsNyBAQCBzdGF0aWMgdm9p
ZCBzZF9yZWFkX2Jsb2NrX2xpbWl0cyhzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwLAogCiAJCXNk
a3AtPm1heF93c19ibG9ja3MgPSAodTMyKWdldF91bmFsaWduZWRfYmU2NCgmdnBkLT5kYXRh
WzM2XSk7CiAKLQkJaWYgKCFzZGtwLT5sYnBtZSkKKwkJaWYgKCFzZF9lYWdlcl91bm1hcCAm
JiAhc2RrcC0+bGJwbWUpCiAJCQlnb3RvIGNvbmZpZ19hdG9taWM7CiAKIAkJbGJhX2NvdW50
ID0gZ2V0X3VuYWxpZ25lZF9iZTMyKCZ2cGQtPmRhdGFbMjBdKTsKQEAgLTM0MzAsNyArMzQz
Niw3IEBAIHN0YXRpYyB2b2lkIHNkX3JlYWRfYmxvY2tfcHJvdmlzaW9uaW5nKHN0cnVjdCBz
Y3NpX2Rpc2sgKnNka3ApCiB7CiAJc3RydWN0IHNjc2lfdnBkICp2cGQ7CiAKLQlpZiAoc2Rr
cC0+bGJwbWUgPT0gMCkKKwlpZiAoIXNkX2VhZ2VyX3VubWFwICYmIHNka3AtPmxicG1lID09
IDApCiAJCXJldHVybjsKIAogCXJjdV9yZWFkX2xvY2soKTsKQEAgLTM2ODYsNiArMzY5Miw0
NSBAQCBzdGF0aWMgdm9pZCBzZF9yZWFkX2Jsb2NrX3plcm8oc3RydWN0IHNjc2lfZGlzayAq
c2RrcCkKIAlrZnJlZShidWZmZXIpOwogfQogCisKK2VudW0geworCUlOUVVJUllfREVTQ19T
VEFSVCAgICAgID0gNTgsCisJSU5RVUlSWV9ERVNDX0VORAk9IDc0LAorCUlOUVVJUllfREVT
Q19TSVpFICAgICAgID0gMiwKK307CisKKy8qKiBFeHRyYWN0IFNCQyB2ZXJzaW9uIGZyb20g
SU5RVUlSWSAqLworc3RhdGljIHVuc2lnbmVkIGludCBzZF9zYmNfdmVyc2lvbihzdHJ1Y3Qg
c2NzaV9kZXZpY2UgKnNkcCkKK3sKKwl1bnNpZ25lZCBpbnQgaTsKKwl1bnNpZ25lZCBpbnQg
bWF4OworCisJaWYgKHNkcC0+aW5xdWlyeV9sZW4gPCBJTlFVSVJZX0RFU0NfU1RBUlQgKyBJ
TlFVSVJZX0RFU0NfU0laRSkKKwkJcmV0dXJuIDA7CisKKwltYXggPSBtaW5fdCh1bnNpZ25l
ZCBpbnQsIHNkcC0+aW5xdWlyeV9sZW4sIElOUVVJUllfREVTQ19FTkQpOworCW1heCA9IHJv
dW5kZG93bihtYXgsIElOUVVJUllfREVTQ19TSVpFKTsKKworCWZvciAoaSA9IElOUVVJUllf
REVTQ19TVEFSVCA7IGkgPCBtYXggOyBpICs9IElOUVVJUllfREVTQ19TSVpFKSB7CisJCXUx
NiBkZXNjID0gZ2V0X3VuYWxpZ25lZF9iZTE2KCZzZHAtPmlucXVpcnlbaV0pOworCisJCXN3
aXRjaCAoZGVzYykgeworCQljYXNlIDB4MDYwMDoKKwkJCXJldHVybiA0OworCQljYXNlIDB4
MDRjMDogY2FzZSAweDA0YzM6IGNhc2UgMHgwNGM1OiBjYXNlIDB4MDRjODoKKwkJCXJldHVy
biAzOworCQljYXNlIDB4MDMyMDogY2FzZSAweDAzMjI6IGNhc2UgMHgwMzI0OiBjYXNlIDB4
MDMzQjoKKwkJY2FzZSAweDAzM0Q6IGNhc2UgMHgwMzNFOgorCQkJcmV0dXJuIDI7CisJCWNh
c2UgMHgwMTgwOiBjYXNlIDB4MDE5YjogY2FzZSAweDAxOWM6CisJCQlyZXR1cm4gMTsKKwkJ
fQorCX0KKworCXJldHVybiAwOworfQorCisKIC8qKgogICoJc2RfcmV2YWxpZGF0ZV9kaXNr
IC0gY2FsbGVkIHRoZSBmaXJzdCB0aW1lIGEgbmV3IGRpc2sgaXMgc2VlbiwKICAqCXBlcmZv
cm1zIGRpc2sgc3BpbiB1cCwgcmVhZF9jYXBhY2l0eSwgZXRjLgpAQCAtMzY5OSw2ICszNzQ0
LDcgQEAgc3RhdGljIGludCBzZF9yZXZhbGlkYXRlX2Rpc2soc3RydWN0IGdlbmRpc2sgKmRp
c2spCiAJc3RydWN0IHF1ZXVlX2xpbWl0cyBsaW07CiAJdW5zaWduZWQgY2hhciAqYnVmZmVy
OwogCXVuc2lnbmVkIGludCBkZXZfbWF4OworCXVuc2lnbmVkIGludCBzYmNfdmVyc2lvbjsK
IAlpbnQgZXJyOwogCiAJU0NTSV9MT0dfSExRVUVVRSgzLCBzZF9wcmludGsoS0VSTl9JTkZP
LCBzZGtwLApAQCAtMzcyMSw2ICszNzY3LDE2IEBAIHN0YXRpYyBpbnQgc2RfcmV2YWxpZGF0
ZV9kaXNrKHN0cnVjdCBnZW5kaXNrICpkaXNrKQogCXNkX3NwaW51cF9kaXNrKHNka3ApOwog
CiAJbGltID0gcXVldWVfbGltaXRzX3N0YXJ0X3VwZGF0ZShzZGtwLT5kaXNrLT5xdWV1ZSk7
CisJc2JjX3ZlcnNpb24gPSBzZF9zYmNfdmVyc2lvbihzZHApOworCWlmIChzZHAtPnNjc2lf
bGV2ZWwgPj0gU0NTSV8zICYmIHNiY192ZXJzaW9uID49IDMgJiYgc2RwLT5za2lwX3ZwZF9w
YWdlcykgeworCQlzZF9wcmludGsoS0VSTl9OT1RJQ0UsIHNka3AsCisJCQkiU0JDIHZlcnNp
b24gJXUsIGNsZWFyIHNraXBfdnBkX3BhZ2VzXG4iLCBzYmNfdmVyc2lvbik7CisJCXNkcC0+
c2tpcF92cGRfcGFnZXMgPSAwOworCQlzY3NpX2F0dGFjaF92cGQoc2RwKTsKKwl9IGVsc2UK
KwkJc2RfcHJpbnRrKEtFUk5fREVCVUcsIHNka3AsCisJCQkiU0JDIHZlcnNpb24gJXUsIFND
U0kgbGV2ZWwgJWksIHNraXBfdnBkX3BhZ2VzICVpXG4iLAorCQkJc2JjX3ZlcnNpb24sIHNk
cC0+c2NzaV9sZXZlbCwgc2RwLT5za2lwX3ZwZF9wYWdlcyk7CiAKIAkvKgogCSAqIFdpdGhv
dXQgbWVkaWEgdGhlcmUgaXMgbm8gcmVhc29uIHRvIGFzazsgbW9yZW92ZXIsIHNvbWUgZGV2
aWNlcwo=

--------------ptMhzKIYuZTkHnbDE7pSvgxs--
