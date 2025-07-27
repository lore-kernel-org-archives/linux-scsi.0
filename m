Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3591E260A
	for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2025 17:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753639188; cv=pass; b=G85lMlNTyzgGwpst2Sxii6fW59X1aNTVx2+SFblHt+PvB0As/xK1v1eQPPjdxp0fu5Pr6Jnt9lQz+4RC/1k8uVkLzd7xMg7EK9U1tVyTyFOgl2cglOo0cqc05v85k2Ur4O990FsqyIH0MQnAmwOjTbKKMtilc+XAiuHuZZWBJS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753639188; c=relaxed/simple;
	bh=L+GY1u7aN1JWbTdJo9NgBHuFOM3Qhm+s2AIc2wrVdSE=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To; b=a6krwctH09YzNJEA06Es7YouWqaigVaEJjVd4i4xb0VNoBzrG+zXU0fErIU6x4XJIZSYRovOQO9wYvc5E+GnUBog7jSUTo2a15lgP5QRKMc9UyFnFzYjeLG8dZAoOLYKSeqw3wPiOuhf8TXPKw3YBlu3nSADlmvwWSVFTKyYLvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de; spf=none smtp.mailfrom=garloff.de; dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b=XXTjZyK/; dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b=hrzSe/Ge; arc=pass smtp.client-ip=85.215.255.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=garloff.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b="XXTjZyK/";
	dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b="hrzSe/Ge"
ARC-Seal: i=1; a=rsa-sha256; t=1753639183; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=owRQXJDkuS67mRnSgAk0rhCiWB1f7XLlhRPL5gF0by5mhOwCObDBP7AlKjaduuQmAI
    MfVneRiWZt/GBTjINJGU/3SMmJq0l5kL1SFSRu3+bh9jIN1O2rGNfszqAcy9Kpz77wh+
    6AIAsiq5rQOpQe25hGW4tVQL7TTw8X7gSNJuZWmxXdIf5cTgliIK0ejcjJuAFtEwTZE5
    AFumvPsBJAYab7Mf7kofXyarsa80ID4nKMJXAeJjoXk+t7dAj8bK3fLswWXqElirYsLp
    klRHXg61/9P/btdrmAC+5iLEcCwSoRCirHvPn7Qd7R/ZqnibrI1ocYhoz3am4HX1D5IY
    JERg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1753639183;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:To:From:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=MUurFtzDlPSGihq5qoICJFbaVGgVqOPH/MSC0EzkjGM=;
    b=KQMfXGh40wLl49/ikeDgkDWQYIQL03utQDitH0UEHuQmo1+JDGBxiODTvWNYi6W4iZ
    +ow17/zIVd9upexlvFKE28zHD/CyqTWfdmSMs6gBUMsqjSHNWPXatFlutEXbVukDNyX4
    69T90ilGOrLar+C+G+4TT0TETxeGzE8MCB/xUCGUvTojg1pobLucPmtXF5ixA3UwVGB5
    8zKK99Ho46hoS+plmp+EEB2e2f869cfAtIxZJ8MkJ4wM8gCneWk/JVH10yRpHtvdOWjL
    eyP93YKwe5bo/8vD46F4SfmgtYgtaJ8ErGvAZEnOgeLzoSea6Qsc7LfzQYlivkp/maFN
    iYuw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753639183;
    s=strato-dkim-0002; d=garloff.de;
    h=In-Reply-To:References:To:From:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=MUurFtzDlPSGihq5qoICJFbaVGgVqOPH/MSC0EzkjGM=;
    b=XXTjZyK/5/HQQZxyjgQmrvBMG3A7yDeNROCbwu2azhWqkjaEzHL7v1hSBA49fgs4A9
    /qm2+0FPMAstYf4iTr7AUOJSv6tWKNm5GKvWNKf6JaSI/LjWa8L889+e0qdmFkFMeo74
    kQYnL48UQUEbyavuA21l8pFc6yFRHSP41CjPCpHU0L/LjeI7KQoYGYHXSk/w4tDRRdzj
    WvL6zodjYO/LFXM8DABCdbeskWDJgajSjDh5Gpzt8yMDmLiZc5iynBk90ALDXFYjPg93
    kqzWpbKnfFdVkIRl2Hn1xjM/AdEvfMC3orJc8zD+zDaLa1Z5UX46VH0kcOPO5RvDc+z8
    5wfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753639183;
    s=strato-dkim-0003; d=garloff.de;
    h=In-Reply-To:References:To:From:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=MUurFtzDlPSGihq5qoICJFbaVGgVqOPH/MSC0EzkjGM=;
    b=hrzSe/GeeXG+2dqxP74Sj0CyVTMAaPT1VVKJ4HwM084cZpXu8KTrx+E71868KIUcOj
    4E6K6KD+PwQmMke5MwAA==
X-RZG-AUTH: ":J3kWYWCveu3U88BfwGxYwcN+YZ41GOdzUdLW+J8VEEt2iJSgSWY/glqoxjGO"
Received: from mail.garloff.de
    by smtp.strato.de (RZmta 52.1.2 DYNA|AUTH)
    with ESMTPSA id L60c3716RHxhbBT
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate)
    for <linux-scsi@vger.kernel.org>;
    Sun, 27 Jul 2025 19:59:43 +0200 (CEST)
Received: from [192.168.155.137] (ap5.garloff.de [192.168.155.10])
	by mail.garloff.de (Postfix) with ESMTPSA id 8D29B62479
	for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2025 19:59:43 +0200 (CEST)
Content-Type: multipart/mixed; boundary="------------u03dPNZt7n2mqrh3xYskfIc4"
Message-ID: <2678e985-71da-4602-a9bc-ed26ca03da65@garloff.de>
Date: Sun, 27 Jul 2025 19:59:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Patch [2/3] Avoid querying VPD pages without eager_unmap.
From: Kurt Garloff <kurt@garloff.de>
To: linux-scsi@vger.kernel.org
References: <021904d2-f59d-44f3-9eec-6dfd7379b3f0@garloff.de>
 <b8ae15bd-7a26-4f7c-ae61-ad282bc59562@garloff.de>
Content-Language: en-US
Autocrypt: addr=kurt@garloff.de; keydata=
 xsFNBFPOcbQBEACwCji59LkgneDQbfcGS3EZW+Ez35y30Bpq3GJPHf9/nq8D7Q8LhjIvHOd9
 ky/FFNr8dx7f6lRqQUrcaeA7dasJwJjLBzkKEVKnZwHS3ytsi0lzlc+UcxdePYBsvT7mx1dD
 aCaibPkqUHxYSpRfPQXxaWT11CMmYuAKDdUdnuXl/b7Z5X+xQofiYjwOxMXCz4EgrfLq41/G
 Y1sAyNxdZexz2cjTWKImO/vCBPe84tt6lJR3fwanLSNJCgZv5jYLelLQVr/Las4gIoqAyIg7
 X/mbkzMeaAMMJwCJo9buo4d6LTQ6vV1KzCKZxzlLUzzxyDRxfB6yHsGVBtaCHqbWQIXIijUD
 x8I7uHN7ZS1fHnunKJ3raZbcIEQ5g2Y5i8fkKNGzdKIQOS75VvDaBExEpNIhSWXvDHyrj7nq
 f2fJGJqy0ZYuoLJhnD0X99LrrHjR6sJIVGm3SWfESckPAFexM7U8rZmZxkN3MmE6rHJJya0y
 TDb4oeMO1+swokQ1CKbl+robI6X5Um4nWh2K+28CJBU0BMjbhDsUh8KWwuCsUUbHezS5SPm+
 9b5Bjudozgjnjb2GjGS4ZSJST08VkaibdN/KfIYnPt2qlYHk4qEcoN7uySnztRa/ZpgkjeGp
 Bp0qivLb0ZFq0eDb/m2odCHW0KTbI+WFg6VAuXO94hVfM+NHMwARAQABzR5LdXJ0IEdhcmxv
 ZmYgPGt1cnRAZ2FybG9mZi5kZT7CwZcEEwEKAEECGwMFCwkIBwMFFQoJCAsFFgIDAQACHgEC
 F4ACGQEWIQRmafc0DTHpXsVWVJDeTxs6K//FvwUCX24B+wUJFubFRwAKCRDeTxs6K//Fv9gL
 D/9QU3QXrZjdFY66nZeyq0thTtVQ6nRgjp4LWJkGng9Fy3lpX8Uw9rGpPaSjcUaPn9l60Jo3
 zTZNVAuXgh0tePZufKM0nx9pBssAliXvxY8d4oa8aF+aBG/D4vCuRAkMhPluQ3mlHyIZ0qeK
 XANJH9dtTaRJkpkAn0K1rAIhZsoRZI5D1geK4vo5kaT7DV1X8as2AiZR6Jrc+BNc2XBRFmx2
 aK4ZN/WNpzzzFDnNw1bkm6Jt5SVBbMMcguyu68d4EfPrRZ1iqsf6Yi8Pi+Gvyo+D8FZk+yhu
 QBOwO3Vm+tg49amzpZfBLxzV8T6Mi4lELPmzKjlzpY4KfpTMCAVlMAxTuPA3kCrwlopHlXm6
 wV8jo0/VcWh+jFdg+nVNMXa/z9iYZOjr2TpuqdGoEyzBnPLbI/btIfzII/ZgNtjOpB2of3uG
 y5k23+qSQe4c2hHGnsSkFza3tNWNYpG5Glxjjo8hDvnEyFc6clmStZLuyP0EOWIFWqy3b8FA
 AdRDKw9aB/GQYtdX6zxlNl53h9bosNEw7wgCMpRfifu9KJCNbJUZ3GaRdS6S7txjjnrtlby/
 9KiPljMtX5h0JctsEezcsAN9utkC+N/siDhfqW5srkPzw3elpgN6wikXGY249Pks1olNEqLP
 9JDVtT7COnrsQv+x7AI3iUehQAlemhAICbZ5Ls7BTQRTznG0ARAAun+5wyqvP6Fe1KkE8cAl
 z6pPAvscC5fxP8QZqrYcQgy1tcCiSyWuTcf1Zbb62JEdfgVrH908lirUjkinkpGMq0sN82Qv
 JD+41vF+OFnUbLDqb02pKIt0y8jhVOYT86Aa3Q3F7eql/mVQA1UJVbF/7Jc+nmyau18bzOFr
 /CNpnJ8x6ZZs8fgiZGalVmPGcj1+L5DwiuJxvr/xCMY3+WEiDjqTgEQ8EPOxaG/DRokWIci+
 AdKslT6kA+JAlKiBF4agg3nCokVCVGIbw/egyivla+/BBq/FaS958hhPanUFq/tCNPbDVB2g
 T5J7/N2j6rLYnBmc+XO5lCQypwAU8waJ4+BJRjuYmD7aXsBOgn0dX/fN8OpVIEyH6hfHSCkT
 a6ltNBs3QMPmZi1JHI0dGeWSZ6Wb1Tw33fQzzAyEAZm43NH0YTZGCS/9+xgH7WFl2fHtQXza
 MzGvcBRpbxYnQGZlupkXZICgGHguDi9Z54iZ3gXV8r84kdRlhmkiE+6QjQMi4tzBxBdRcIV2
 dpX6Xp3Mzaqp6Blz3DBEtFk9mrvXgt+BNsxHc8xtR86imzXAHjAcDf41XcJvZvI6lGYrgREt
 XzkxYB9EAaC3kYv2ZDeq10eNBv7ZYLFoCcrHMC1XnI0IkM/zgEzvN+1T+zPI4DtoZ98isveA
 pohKA69o7HmVo/UAEQEAAcLBfAQYAQoAJgIbDBYhBGZp9zQNMelexVZUkN5PGzor/8W/BQJf
 bgIBBQkW5sVNAAoJEN5PGzor/8W/mwEP/ReMsLTGE44N+f6Q2K9gWNM++htBvOIgxW0sO2jd
 S8XETNlIcswLfSNExYj0l+CwmBPGRCeH6dP3jIzhGe1xq8wwyfXHYT1o2xFtPSitScGN5XbE
 bsyTNSZ3w6103IJDhCd809l3Day68X7XfR9dXY/akDf9/mcdq4KuQI+N++xuEk39M3aKtMtP
 5tAMF6QasPHUP/oIa0o1eSIbnJkVTGTlIZPSsZ0SE34FktcEsvtZjr1x4QiE1AN5OrjJfsGt
 89+4Yq4Do35eK26Rf3dHrCOiSdm6SNu3kGeIAo6pYKYGzVA9qPAWwMY89A7PSXMyen9v4Hj+
 oPKeRi6lOGOwLa0ognYo6/mYTl2g1U6e4YSawOykqoOF0V3TYyksTT+IYxfLNaYY5mBgOZsa
 SxSux9ZZw3ZQDS+8TL5eBoA9gP8wBpfR2agTLvSFpDmjvOJITwW/eBYdXDpaUzRCnM0yL4xA
 6EQ+Tp/qhz1vhVD8MA1aFVuhvXFyv1sltSm5nqlBA8/4nLMZqslJZ5VLVtkEXiSEh/7Mj9xg
 +WPo2/4FAu2ngbxN5/qWuPBnjQN7KKOhLSV7uf07XlmLwcPw+LFsoFjc54WrmieJuCnH/UVQ
 6dmc1ZUGwVkPKj/1orKQwaVSKdT9DAhbTowyDfPxESLmruJLx4AWj6jZML1VE+fnnAIS
In-Reply-To: <b8ae15bd-7a26-4f7c-ae61-ad282bc59562@garloff.de>
Content-Transfer-Encoding: 7bit

This is a multi-part message in MIME format.
--------------u03dPNZt7n2mqrh3xYskfIc4
Content-Type: multipart/alternative;
 boundary="------------0yK4jZ2vcDdCeezV7WKZMTNl"

--------------0yK4jZ2vcDdCeezV7WKZMTNl
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


--------------0yK4jZ2vcDdCeezV7WKZMTNl
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

--------------0yK4jZ2vcDdCeezV7WKZMTNl--
--------------u03dPNZt7n2mqrh3xYskfIc4
Content-Type: text/x-patch; charset=UTF-8; name="eager-unmap-2.diff"
Content-Disposition: attachment; filename="eager-unmap-2.diff"
Content-Transfer-Encoding: base64

Y29tbWl0IGU4OTI5YTJiZDYzOGJmNTA1OTc5NjE0YTkzN2RjYmY0NDYxMDg0ZGQKQXV0aG9y
OiBLdXJ0IEdhcmxvZmYgPGt1cnRAZ2FybG9mZi5kZT4KRGF0ZTogICBTdW4gSnVsIDI3IDE2
OjE3OjQ2IDIwMjUgKzAwMDAKCiAgICBBdm9pZCBxdWVyeWluZyBWUEQgcGFnZXMgd2l0aG91
dCBlYWdlcl91bm1hcC4KICAgIAogICAgSWYgd2UgYXJlIG5lcnZvdXMgYWJvdXQgU0JDID49
IDMgZGV2aWNlcyB0aGF0IHN0aWxsIGxvY2sgdXAgd2hlbiBhc2tlZAogICAgZm9yIHRoZSBW
UEQgcGFnZXMsIHdlIHNob3VsZCBhdm9pZCBkb2luZyBpdCB1bmxlc3MgZXhwbGljaXRseSBh
c2tlZCBmb3IKICAgIGJ5IHNldHRpbmcgZWFnZXJfdW5tYXAuCiAgICAKICAgIERvY3VtZW50
IHRoZSBuZXcgcGFyYW1ldGVyLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBLdXJ0IEdhcmxv
ZmYgPGt1cnRAZ2FybG9mZi5kZT4KCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3Njc2kv
c2QtcGFyYW1ldGVycy5yc3QgYi9Eb2N1bWVudGF0aW9uL3Njc2kvc2QtcGFyYW1ldGVycy5y
c3QKaW5kZXggODdkNTU0MDA4YmZiLi5lMGM5YzI5Yjc2MzkgMTAwNjQ0Ci0tLSBhL0RvY3Vt
ZW50YXRpb24vc2NzaS9zZC1wYXJhbWV0ZXJzLnJzdAorKysgYi9Eb2N1bWVudGF0aW9uL3Nj
c2kvc2QtcGFyYW1ldGVycy5yc3QKQEAgLTI1LDMgKzI1LDIwIEBAIFRvIG1vZGlmeSB0aGUg
Y2FjaGluZyBtb2RlIHdpdGhvdXQgbWFraW5nIHRoZSBjaGFuZ2UgcGVyc2lzdGVudCwgcHJl
cGVuZAogInRlbXBvcmFyeSAiIHRvIHRoZSBjYWNoZSB0eXBlIHN0cmluZy4gRS5nLjo6CiAK
ICAgIyBlY2hvICJ0ZW1wb3Jhcnkgd3JpdGUgYmFjayIgPiBjYWNoZV90eXBlCisKKz09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KK0xpbnV4IFND
U0kgRGlzayBEcml2ZXIgKHNkX21vZCkgbW9kdWxlIFBhcmFtZXRlcnMKKz09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KKworc2QuZWFnZXJfdW5t
YXAgY29udHJvbHMgdGhlIHN1cHBvcnQgb2YgZGlzY2FyZCBvcGVyYXRpb25zIGZvciBTQ1NJ
IGRldmljZXMKK3RoYXQgZG8gbm90IGFkdmVydGl6ZSB0aGluIHByb3Zpc2lvbmluZyAoTERQ
TUUpLiBUaGlzIGlzIHR5cGljYWxseSB0aGUgY2FzZQorZm9yIE5WTWUgVVNCIGVuY2xvc3Vy
ZXMuCisKK3NkLmVhZ2VyX3VubWFwPTEgZm9yY2VzIGF0dGFjaGluZyBWUEQgcGFnZXMgaWYg
dGhlIGRldmljZSBjbGFpbXMgU0JDID49IDMKK3N1cHBvcnQuIFRoZSB1bm1hcC93czE2L3dz
MTAgY2FwYWJpbGl0eSB3aWxsIGJlIGRldGVjdGVkIHRoZW4gYW5kIHN0b3JlZC4KK0l0IGVu
YWJsZXMgc2VuZGluZyBkb3duIGRpc2NhcmQgY29tbWFuZHMgdG8gU0NTSSBzdG9yYWdlIGlm
IGFueSBvZgordW5tYXAvd3MxNi93czEwIGlzIHN1cHBvcnRlZCwgZXZlbiBpZiBMRFBNRSBp
cyBub3Qgc2V0LgorCitBcyB0aGUgVlBEIHBhZ2UgcmVhZCBoYXBwZW5zIHVwb24gU0NTSSBz
Y2FubmluZyBhbmQgc2RfcmV2YWxpZGF0ZV9kaXNrKCkKK3RpbWUsIGNoYW5naW5nIHRoaXMg
cGFyYW1ldGVyIGFuZCB0aGVuIHJlLWF0dGFjaGluZyB0aGUgVVNCIFNDU0kgZGlzaword2ls
bCBiZSBlZmZlY3RpdmUuCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2QuYyBiL2RyaXZl
cnMvc2NzaS9zZC5jCmluZGV4IGVhMzhmZTE1NDllNS4uOGNmYThkNTc5ZTU1IDEwMDY0NAot
LS0gYS9kcml2ZXJzL3Njc2kvc2QuYworKysgYi9kcml2ZXJzL3Njc2kvc2QuYwpAQCAtMzMx
MSw2ICszMzExLDEwIEBAIHN0YXRpYyB2b2lkIHNkX3JlYWRfYXBwX3RhZ19vd24oc3RydWN0
IHNjc2lfZGlzayAqc2RrcCwgdW5zaWduZWQgY2hhciAqYnVmZmVyKQogCiBzdGF0aWMgdW5z
aWduZWQgaW50IHNkX2Rpc2NhcmRfbW9kZShzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwKQogewor
CS8qIAorCSAqIElmIGVhZ2VyX3VubWFwIGlzIHNldCAoYW5kIHNvbWUgZGlzY2FyZCBtZXRo
b2QgaXMgc3VwcG9ydGVkKSwKKwkgKiB3ZSBjYW4gZGlzY2FyZCBibG9ja3MgZXZlbiB3aXRo
b3V0IGxicG1lLgorCSAqLwogCWlmICghc2RrcC0+bGJwbWUgJiYgIXNkX2VhZ2VyX3VubWFw
KQogCQlyZXR1cm4gU0RfTEJQX0ZVTEw7CiAKQEAgLTM3NjgsMTEgKzM3NzIsMTcgQEAgc3Rh
dGljIGludCBzZF9yZXZhbGlkYXRlX2Rpc2soc3RydWN0IGdlbmRpc2sgKmRpc2spCiAKIAls
aW0gPSBxdWV1ZV9saW1pdHNfc3RhcnRfdXBkYXRlKHNka3AtPmRpc2stPnF1ZXVlKTsKIAlz
YmNfdmVyc2lvbiA9IHNkX3NiY192ZXJzaW9uKHNkcCk7Ci0JaWYgKHNkcC0+c2NzaV9sZXZl
bCA+PSBTQ1NJXzMgJiYgc2JjX3ZlcnNpb24gPj0gMyAmJiBzZHAtPnNraXBfdnBkX3BhZ2Vz
KSB7Ci0JCXNkX3ByaW50ayhLRVJOX05PVElDRSwgc2RrcCwKLQkJCSJTQkMgdmVyc2lvbiAl
dSwgY2xlYXIgc2tpcF92cGRfcGFnZXNcbiIsIHNiY192ZXJzaW9uKTsKLQkJc2RwLT5za2lw
X3ZwZF9wYWdlcyA9IDA7Ci0JCXNjc2lfYXR0YWNoX3ZwZChzZHApOworCS8qIAorCSAqIFRo
aXMgb3ZlcnJpZGVzIEJMSVNUX1NLSVBfVlBEX1BBR0VTIGZvciBTQkMgPj0zIHdpdGggZWFn
ZXJfdW5tYXAuCisJICogVGhpcyBoYXBwZW5zIG9uIFVTQiBzdG9yYWdlIGFkYXB0ZXJzLgor
CSAqLworCWlmIChzZHAtPnNjc2lfbGV2ZWwgPj0gU0NTSV8zICYmIHNiY192ZXJzaW9uID49
IDMgJiYgc2RfZWFnZXJfdW5tYXApIHsKKwkJaWYgKHNkcC0+c2tpcF92cGRfcGFnZXMpIHsK
KwkJCXNkX3ByaW50ayhLRVJOX05PVElDRSwgc2RrcCwKKwkJCQkiZWFnZXJfdW5tYXAgc2V0
IGFuZCBTQkMgdmVyc2lvbiAldSwgY2xlYXIgc2tpcF92cGRfcGFnZXNcbiIsIHNiY192ZXJz
aW9uKTsKKwkJCXNkcC0+c2tpcF92cGRfcGFnZXMgPSAwOworCQkJc2NzaV9hdHRhY2hfdnBk
KHNkcCk7CisJCX0KIAl9IGVsc2UKIAkJc2RfcHJpbnRrKEtFUk5fREVCVUcsIHNka3AsCiAJ
CQkiU0JDIHZlcnNpb24gJXUsIFNDU0kgbGV2ZWwgJWksIHNraXBfdnBkX3BhZ2VzICVpXG4i
LAo=

--------------u03dPNZt7n2mqrh3xYskfIc4--
