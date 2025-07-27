Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D9F223316
	for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2025 18:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753639437; cv=pass; b=TJ3aGmnQz/EouA6PX0vDjQuezjgKXXESh4AycMVDQcyhkwHbMDnX4Bo+DbJJPCJ/g8pH4u6ZIUjhQVavsMdn+KLP+5DlYydZI8KrhYoLMS48tDxw7H+lJAep+GlY0ZzZUdxzdX5FwqfXqleK49dalTs4FkavDQgr/6P7QcjMEXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753639437; c=relaxed/simple;
	bh=7Rrj6BiRSOgGKoR6LtvffnB3VuDQGNMFHXAoFDUfOwU=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To; b=JZgejVsdyDRXgyFvyp85tKl93tbrg+nVbh4a3OP52DAtvhwDW99+wNB5Icjpefj/hJLFOgThxmqEMu56gj/S9GgYvsVk8B5CG5WGSc2DatMi0uTMCqDD6ahgjNwKSnIcL2EA0JYiTW/IQbqu3SGWgLitW23pScGbnbsCphp1yTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de; spf=none smtp.mailfrom=garloff.de; dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b=WD3V0RRm; dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b=bTTBnoxP; arc=pass smtp.client-ip=85.215.255.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=garloff.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b="WD3V0RRm";
	dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b="bTTBnoxP"
ARC-Seal: i=1; a=rsa-sha256; t=1753639247; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ANE/jm7Mg6nIV9V/FvCcwZ837wiRLmhBE0anDRXSXSQX36bGKDboLyBorCy29Ou1dr
    fg8lCxNt+Lb7bW79YSZto4I7rgOcOSbQbzImVOBmQNncHP/LbusSv8+6EJW32jDTSYqF
    b2v/sDAAZuZP/iWphS9mITccyb/q0vLhnpSPXOWLshZQrLuEYw+Fb48JptMlMxHeNo8M
    cbCTbAbNwGAOJNBzRZEY+UH9RM5rAVnG/x4KdQNU47yYBPmvckXjSxVwgC+Fu77VBUJQ
    vfcZPUUb0P91DUhDpf/c6chxdr6E7UOscOq2pFCf54EiDMl0yXoe3EHWnMqzTejx8pzs
    w6AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1753639247;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:To:From:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=aqfj/O5NHRdSz4FlFX8hxG9vEyGC/E22uEvXGS7LT/E=;
    b=C+DJW2LOoeQvYZJ1irO2vABG3ogF2CYCQ+vDSMysoi0CH4oX2NYg1+g1nGFNLqc1j5
    f011tRoAJK9lVh/O7HOTxuvOuNEiMpFFpewlHt3KvZDnXJTSJ0FUny9U6CACV2ywp9Jy
    TMcXTIWoDPkNvPbkXSXsujzexsV20eCbm6bVKOLI1n9CEz1IEtCRGVNWfepUKiiYunKU
    DqkBQsej7A16YvECONqHn8FJ1fhV4/XK8jlsAhaSr/1+IUXb+L90PJSX5t1dNou3fGY9
    S/VYK3Wvds54ywaXMLMa6D1zEEPu2LucrBl/eOzkUaNhtm9h4IKMNypSLykMbzicJHeW
    41pA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753639247;
    s=strato-dkim-0002; d=garloff.de;
    h=In-Reply-To:References:To:From:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=aqfj/O5NHRdSz4FlFX8hxG9vEyGC/E22uEvXGS7LT/E=;
    b=WD3V0RRmJuNiEfW6tN5Gr2SYDe05Ft25RdWELsYUAR7elCAGdt5QZ+GL3S4BSCC8ng
    lKlTnr2g/coW/BsNMDd0JQp+Qh7wHiiPkL9/TdSD/4BkW5pwHOQgSNDPSRmzmAjFLS/L
    zhjNX7J3+WUqqnXBJL8wiT+TAKUaHULGjRiE8RQF3hDXHtFaiU7lo/R3hcfYETojWThz
    JIKZiaBIAnjzQcoKYyajEeZiavhGQMv4LKX85b0kPldphspHXSBZlptZZcqC6XQwuERO
    btxd4g+zyYHW5Xn2omJ7X4Lpzc1JZ4TnvkeFSDiDsFALp07GamZjEu6KEvK4duFyUPZa
    4Iiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753639247;
    s=strato-dkim-0003; d=garloff.de;
    h=In-Reply-To:References:To:From:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=aqfj/O5NHRdSz4FlFX8hxG9vEyGC/E22uEvXGS7LT/E=;
    b=bTTBnoxPQaqKoxf+Iv7KE7ffVbregscxd5VvH0YVybWojCmlEBjZ3eY4PlGuCCVFSe
    ciVoH1H4cLhq2gmB2bCg==
X-RZG-AUTH: ":J3kWYWCveu3U88BfwGxYwcN+YZ41GOdzUdLW+J8VEEt2iJSgSWY/glqoxjGO"
Received: from mail.garloff.de
    by smtp.strato.de (RZmta 52.1.2 DYNA|AUTH)
    with ESMTPSA id L60c3716RI0lbBk
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate)
    for <linux-scsi@vger.kernel.org>;
    Sun, 27 Jul 2025 20:00:47 +0200 (CEST)
Received: from [192.168.155.137] (ap5.garloff.de [192.168.155.10])
	by mail.garloff.de (Postfix) with ESMTPSA id CA43B62479
	for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2025 20:00:46 +0200 (CEST)
Content-Type: multipart/mixed; boundary="------------IS4o05Sea7qUDbsv7rADI8NT"
Message-ID: <bb781675-50eb-40d0-a877-18eb3c3be6fd@garloff.de>
Date: Sun, 27 Jul 2025 20:00:44 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Patch [3/3] Enable eager_unmap by default.
From: Kurt Garloff <kurt@garloff.de>
To: linux-scsi@vger.kernel.org
References: <021904d2-f59d-44f3-9eec-6dfd7379b3f0@garloff.de>
 <b8ae15bd-7a26-4f7c-ae61-ad282bc59562@garloff.de>
 <2678e985-71da-4602-a9bc-ed26ca03da65@garloff.de>
Content-Language: en-US
Autocrypt: addr=kurt@garloff.de; keydata=
 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
In-Reply-To: <2678e985-71da-4602-a9bc-ed26ca03da65@garloff.de>
Content-Transfer-Encoding: 7bit

This is a multi-part message in MIME format.
--------------IS4o05Sea7qUDbsv7rADI8NT
Content-Type: multipart/alternative;
 boundary="------------b6k4a950m1sLjShINJlBgNar"

--------------b6k4a950m1sLjShINJlBgNar
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


--------------b6k4a950m1sLjShINJlBgNar
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

--------------b6k4a950m1sLjShINJlBgNar--
--------------IS4o05Sea7qUDbsv7rADI8NT
Content-Type: text/x-patch; charset=UTF-8; name="eager-unmap-3.diff"
Content-Disposition: attachment; filename="eager-unmap-3.diff"
Content-Transfer-Encoding: base64

Y29tbWl0IDliMzg4MmViZWQ4NmIwN2QwNjMwYmY0NzdlYmE4ZDAyMjU2ODY0NzkKQXV0aG9y
OiBLdXJ0IEdhcmxvZmYgPGt1cnRAZ2FybG9mZi5kZT4KRGF0ZTogICBTdW4gSnVsIDI3IDE3
OjI0OjQ0IDIwMjUgKzAwMDAKCiAgICBFbmFibGUgZWFnZXJfdW5tYXAgYnkgZGVmYXVsdC4K
ICAgIAogICAgVGhpcyBpcyB0aGUgbW9zdCByaXNreSBwaWVjZS4gRXZlbiB0aG91Z2ggd2Ug
dGVzdCBmb3IgU0JDID49IDMsIHRoZXJlCiAgICBpcyBhIGNoYW5jZSB0aGF0IGEgaGFyZHdh
cmUgdmVuZG9yIGhhcyBzY3Jld2VkIHVwIGFuZCBsb2NrcyB1cCB1cG9uCiAgICBnZXR0aW5n
IHJlcXVlc3RzIGZvciBWUEQgcGFnZXMgb3IgdXBvbiByZWNlaXZpbmcgdW5tYXAvd3MxNi93
czEwCiAgICBjb21tYW5kcyBkZXNwaXRlIGhhdmluZyBjbGFpbWVkIHN1cHBvcnQgZm9yIGl0
LgogICAgSXQgd29ya3Mgb24gdHdvIGRpZmZlcmVudCBraW5kcyBvZiBVU0ItTlZNZSBlbmNs
b3N1cmVzIHRoYXQgSSB1c2VkCiAgICBmb3IgdGVzdGluZyAoU2FicmVudCBSVEwgOTIxMCBh
bmQgcGxhaW4gUmVhbHRlayA5MjEwQiBiYXNlZCBvbmVzKS4KICAgIAogICAgSSBzdWdnZXN0
IHRvIGVuYWJsZSB0aGlzIGFuZCByZXZlcnQgdGhpcyBwYXRjaCBpZiB0aGVyZSBpcyBzaWdu
aWZpY2FudAogICAgZmFsbG91dCBkdXJpbmcgdGhlIHJjIHBoYXNlLgogICAgCiAgICBTaWdu
ZWQtb2ZmLWJ5OiBLdXJ0IEdhcmxvZmYgPGt1cnRAZ2FybG9mZi5kZT4KCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3Njc2kvc2QuYyBiL2RyaXZlcnMvc2NzaS9zZC5jCmluZGV4IDhjZmE4ZDU3
OWU1NS4uNTY0NDc4MzQ2ZDliIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc2QuYworKysg
Yi9kcml2ZXJzL3Njc2kvc2QuYwpAQCAtNzksMTEgKzc5LDExIEBAIE1PRFVMRV9BVVRIT1Io
IkVyaWMgWW91bmdkYWxlIik7CiBNT0RVTEVfREVTQ1JJUFRJT04oIlNDU0kgZGlzayAoc2Qp
IGRyaXZlciIpOwogTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwogCi1zdGF0aWMgaW50IHNkX2Vh
Z2VyX3VubWFwID0gMDsKK3N0YXRpYyBpbnQgc2RfZWFnZXJfdW5tYXAgPSAxOwogbW9kdWxl
X3BhcmFtX25hbWVkKGVhZ2VyX3VubWFwLCBzZF9lYWdlcl91bm1hcCwgaW50LCBTX0lSVUdP
IHwgU19JV1VTUik7CiBNT0RVTEVfUEFSTV9ERVNDKGVhZ2VyX3VubWFwLCAidXNlIHVubWFw
L3dzMTAvd3MxNiBhbHNvIGZvciBkZXZpY2VzICIKIAkJInRoYXQgc3VwcG9ydCBpdCBpbiBM
QlAgcGFnZSB3aXRob3V0IGNsYWltaW5nIExCUE1FICIKLQkJIih0aGlubHkgcHJvdmlzaW9u
ZWQgZGV2aWNlcyksIGRlZmF1bHQgPSAwIik7CisJCSIodGhpbmx5IHByb3Zpc2lvbmVkIGRl
dmljZXMpLCBkZWZhdWx0ID0gMSIpOwogCiBNT0RVTEVfQUxJQVNfQkxPQ0tERVZfTUFKT1Io
U0NTSV9ESVNLMF9NQUpPUik7CiBNT0RVTEVfQUxJQVNfQkxPQ0tERVZfTUFKT1IoU0NTSV9E
SVNLMV9NQUpPUik7Cg==

--------------IS4o05Sea7qUDbsv7rADI8NT--
