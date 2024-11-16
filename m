Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A38F1B815
	for <linux-scsi@vger.kernel.org>; Sat, 16 Nov 2024 15:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731771370; cv=none; b=JW9JSGU6vuXb527gAtgoGSXDV8BOQBWeJXmip44+JmLtf8htZo+9rZT/f/A13rGae28NP4BqIq75J7HC5ob5rZ2yhkU17CyRz2R1XHLWoDgMF7FuoC7q3OyiVpp5Ttnbmp39MY1wHOjYpeJLAuQuTenogN8ttplBDGV7CcKb4mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731771370; c=relaxed/simple;
	bh=kHGF2V9smfyd57T3oPA81LOd5bK/lopqOwMpMYjSbB4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OLgD1m4f/PoQkHk+gHmA5GGjXfmJOIXuHKXsyvPT9tFq313DbRpi5DR2t51hnYCgR0SXdSumKm5UfzeNdoDVSV3eLLtnBhW0IJcl/Q4Wi3K6T6K/odB5b9G2NiIq8RcLHxzhFKTjnJf2GyMHv4T1ansXXty9cZMheH5Rbpv0sPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=tl+Ju4HO; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="tl+Ju4HO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=YiO+z2kLgN4l76tSn0AXsjGj96aZwPsVy5IcPg9JzOo=;
	b=tl+Ju4HO+UVb2lU4SR8/tp+tQ7iUNAA/inok2DLu932s7iYYUDBlPIxgv5hUaiZjFHF0V3lhn+Oq9
	 gVyL8UR4XmWfvbauZYe8H1LkMEPLGXyzLpRcCDkiiBr2Fuk1iWrsaAik51FqkahEf4JnUKCGSWezv6
	 dQFhwjXn/lbAFR/j5FVKUghtjCu71qqbQOxTSJBq3Z5NZubp8lzUzTthYtgE7QPpM1Hs73dIg3gG8I
	 cfj6DLfevs+V/q8+uVTdb7odjME+9PGaELAsQM6AutXQA04bXjkJ8IFOSInRJkKlK3vtkqIvUSIH4y
	 DNpXlqrAxnPyInDj9RZSqpWlsowAvDg==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id 7c32b577-a430-11ef-8269-005056bdf889;
	Sat, 16 Nov 2024 17:36:02 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH 1/2] scsi: st: Remove use of device->was_reset
From: =?utf-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
In-Reply-To: <7E2EA0D1-63ED-44A8-A12B-C9B78C28B0E5@kolumbus.fi>
Date: Sat, 16 Nov 2024 17:35:51 +0200
Cc: loberman@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <BED6505B-A8FD-4445-B61B-5F43899DAD54@kolumbus.fi>
References: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
 <20241115162003.3908-2-Kai.Makisara@kolumbus.fi>
 <7E2EA0D1-63ED-44A8-A12B-C9B78C28B0E5@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
 jmeneghi@redhat.com
X-Mailer: Apple Mail (2.3826.200.121)



> On 15. Nov 2024, at 19.45, Kai M=C3=A4kisara (Kolumbus) =
<kai.makisara@kolumbus.fi> wrote:
>=20
...
>=20
> I still think that UNIT ATTENTIONs (UAs) reach the high level device =
without
> problems. The problem is that the device attached to the target first =
issuing
> a SCSI command after reset gets the UA. As long as this is st device,
> there are no problems. But, if it is the sg device attached to the =
same target,
> the tape device misses it.
>=20
...
>=20
> And there are cases where the device reset does not originate from the
> same computer.
>=20
> Does anyone have any suggestions?

Besides Power on/Reset, the same problem applies to the New Media case.

One solution might be the following: the midlevel maintains counters for
the Power on/Reset and the Media change UNIT ATTENTIONs. The ULDs
can read these counters (using wrappers). If the ULD find for a device =
that
the counter value has changed, then the event corresponding to the =
counter
has occurred. The problem of clearing event flags is avoided,

A drawback comes from the counter wrap-arounds. If, e.g., four-bit =
counters
are used and there are 16 Power on/Resets between the checks by the ULD,
the event is missed when the counter is used. (The ULDs should also =
check
the sense data they do receive. It is possible/probable that the event =
is
recognized based on the sense data even if the counter check misses it.)

This solution is easy to implement. I have a test implementation running =
and
it seems to be working.


Other solutions that have come into my mind are much more complicated=20
than the counters. Here are examples:
- the UNIT ATTENTIONs would be sent to all ULDs attached to the device
  when they issue the next SCSI command
- the ULDs would have possibility to register a callback for UNIT =
ATTENTIONs

