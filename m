Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB521CEAAE
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2024 15:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732029012; cv=none; b=ACbQiyH2+hLuTkD7CxUYlssyHsPYmOhxrZnefS1Q+aRRpdoIkHQwD0CWDdG42jpslqPcAej+xxXjZxP/wTf9OJA7y1n3zKU55zFUesPhspOpmFESfXkZtxTVKTMGZK+VR2loW91otf1dNiHtUtnrAhkHPwM0HZh8Ie1sUYCwCEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732029012; c=relaxed/simple;
	bh=Hw3WQVJJnCNWh+oIRJkI8w7Y91ruiQ37u66cECcyLac=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=aOwYrW3bM68eCaGFU8A05GhyI3EbftrsaF4U5oPamaJDUgnZJ4vx69+cKckUQPjqP43Ga1EQTbUMsS4xmakp5nRsclWypo+ndYLzL8adww1I8cs+9UCIAbx82Xeun0LMVRaWjIPpi2RMzbcDnP1dz1qC11AF7IQ63oRmZwT1DbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=MHaj90Ms; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="MHaj90Ms"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=jrXjs/CpkaiwNVNSNg8wg1jRKUvEsWE5eYNdnOh+VUw=;
	b=MHaj90MsJLbTdPS913dLT1u6QtYcLTAeb264ilo/eUZ9+HM6aPZpKSyAOpxZsImLmxlncu5CFl8Wq
	 PNGYBqZHxbpEXyi7JO4xCPtLRjQtgbjCjc7Ye7In8gDI5Wmd0ZnFq57bd5XtVjEsFYBkZ5qkwjm0vd
	 td8HV2GTcj59UZKipaNf8osX18aPcmYC7hi7NzI2mwMKjz8oZYRa5YQpzoPaSNaVTwOUa4+eWb4X38
	 rmF80bn1Sso/kLI7CjBSEAomeXyV4904q/RSRxksw6n3i6AYG7/ixsD2SQDWuagoVTno+p/HzPkgs/
	 YSsuoIEqApDtMLPUmistn2BM7cM+UfQ==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 5838060f-a688-11ef-887d-005056bdd08f;
	Tue, 19 Nov 2024 17:09:59 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH 1/2] scsi: st: Remove use of device->was_reset
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <50e7550c-cfeb-4a14-ac56-58b2a94f0f82@redhat.com>
Date: Tue, 19 Nov 2024 17:09:49 +0200
Cc: linux-scsi@vger.kernel.org,
 loberman@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <56AC8EEF-9695-477B-AA2A-19F8B9E8C9A2@kolumbus.fi>
References: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
 <20241115162003.3908-2-Kai.Makisara@kolumbus.fi>
 <7E2EA0D1-63ED-44A8-A12B-C9B78C28B0E5@kolumbus.fi>
 <BED6505B-A8FD-4445-B61B-5F43899DAD54@kolumbus.fi>
 <50e7550c-cfeb-4a14-ac56-58b2a94f0f82@redhat.com>
To: John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3826.200.121)



> On 18. Nov 2024, at 23.36, John Meneghini <jmeneghi@redhat.com> wrote:
>=20
>=20
> On 11/16/24 10:35, Kai M=C3=A4kisara (Kolumbus) wrote:
>>=20

...

>> Besides Power on/Reset, the same problem applies to the New Media =
case.
>=20
> It seems to me this would apply for any Unit Attention. A hardware =
device can set a unit attention when ever acted upon by a third party.  =
It is difficult to test this type of event w/out a multi-initiator =
bus... some kind of configuration that connects multiple host to the =
same SCSI target/lun device.  Large tape library configurations can do =
this. I don't have a test bed like this.

Yes, this applies to all Unit Attentions. I just mentioned the ones st =
is interested in.

>=20
>> One solution might be the following: the midlevel maintains counters =
for
>> the Power on/Reset and the Media change UNIT ATTENTIONs. The ULDs
>> can read these counters (using wrappers). If the ULD find for a =
device that
>> the counter value has changed, then the event corresponding to the =
counter
>> has occurred. The problem of clearing event flags is avoided,
>=20
> I'm not sure I understand what problem you are trying to solve... are =
you trying to get the mid layer to report Unit Attentions to all ULDs =
that are attached?  That is, you want the mid layer to report the UA to =
all ULDs, not just the last/latest ULD?

I would rather say that midlevel provides a method for all ULDs to see =
if certain
Unit Attentions have happened. One gets all the sense data, but others =
can
at least see that something has happened.

>=20
>> A drawback comes from the counter wrap-arounds. If, e.g., four-bit =
counters
>> are used and there are 16 Power on/Resets between the checks by the =
ULD,
>> the event is missed when the counter is used.=20
>=20
> I don't think that would be a problem. As long as the latest and =
highest priority UA is reported, older, lower priority UAs can be =
overwritten.  For example, a New Media UA followed by a POR UA - the =
Power On reset should take precedence.

My text seems to be somewhat ambiguous. I meant that there would be two
counters, one for New Media events and one for PORs. St needs to know
which one (or both) has occurred.

...

>> Other solutions that have come into my mind are much more complicated
>> than the counters. Here are examples:
>> - the UNIT ATTENTIONs would be sent to all ULDs attached to the =
device
>>   when they issue the next SCSI command
>> - the ULDs would have possibility to register a callback for UNIT =
ATTENTIONs
>=20
> This is actually what the SCSI device is supposed to do.  If you have =
a truly SCSI compliant tape device, designed to support multi-initiator =
access, unit attentions are supposed to be maintained on an I_T by I_T =
basis. So a device reset from one I_T will set a UA on all I_Ts, and =
clearing one I_T will clear only that I_T nexus UA.  But I'm sure that =
some of the older, legacy, tape devices don't do this.

Yes, this is what has motivated the suggestions above. SCSI does send =
Unit
Attentions to all initiators. Linux could extend this so that all ULDs =
attached to
a device get the Unit Attentions. However, one big problem is, where to =
find
someone to implement this?

