Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8587E188A3A
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731692750; cv=none; b=PEP4Tqcqq+AicyRzPoy+XbYASjd/LiVrx3cI9//BlkhQDC0JM1O9SA/Fypny61kwByVUMKolLCMga0RfL4HXFx8/1IYtoIYU5IJJVqUuLtFaQklHbthHuwA3wSqc0THTz51qcknhSVuuP9DJpW2uvRPLb7rhHptSybSv/+rvT3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731692750; c=relaxed/simple;
	bh=w9hlLDF7xjpkQYRDcwkIB9eEkGYh8j+aLYB/SU13+7Y=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YyOn+Wrp0fblGT39q1QH91Hb268QozqwOERipLQHE/DKM3ULohObH9sjMUbxrN4YtXPIco07Lfif8I+h+FCRHofGg4qWERsarGFvcirtRbkYGibEJTYvXMxkhwcjtH/E/tb96mlyh9K92vA6VzlAYDXetmG3FFEmu+AeCp2lpcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=eh2JMG5Q; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="eh2JMG5Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=w9hlLDF7xjpkQYRDcwkIB9eEkGYh8j+aLYB/SU13+7Y=;
	b=eh2JMG5Q4LiQIo98SLWM0fSoXb2r6P/+eloVIpEmAnA4mQEJRc6PAsxLJxfGdcN/e5Swe2aca3msA
	 Ky3dBdXngzbhZbeilz+sJEIwRHAnNgaBYiT2dUGaL29j6gzsEg2W0r8lZf8byJYL62wFZ2J5GOZkyY
	 0RJHZ8UdzUYxyUZntwdOrVapCHnxQpquiOumynoufYfGRxzqIPr+FXoTzulltKN3BZZlL7BEItPLtx
	 Xluyh8HcaYSViS/ILb+bzNakAMVChdKKmigmf5igGqr7uMDQHq+xvHchYjJApOfyh17T8o4aZmNBn4
	 A3t/ArgX8rxUxCUkqHAHq1bjuMPdp3Q==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id 6faad07c-a379-11ef-8268-005056bdf889;
	Fri, 15 Nov 2024 19:45:43 +0200 (EET)
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
In-Reply-To: <20241115162003.3908-2-Kai.Makisara@kolumbus.fi>
Date: Fri, 15 Nov 2024 19:45:33 +0200
Cc: martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 loberman@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <7E2EA0D1-63ED-44A8-A12B-C9B78C28B0E5@kolumbus.fi>
References: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
 <20241115162003.3908-2-Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
 jmeneghi@redhat.com
X-Mailer: Apple Mail (2.3826.200.121)


> On 15. Nov 2024, at 18.20, Kai M=C3=A4kisara =
<Kai.Makisara@kolumbus.fi> wrote:
>=20
> Don't use the was_reset flag set by scsi error handling. It is enough =
to
> recognize device resets based in the UNIT ATTENTION sense data. (The
> retry counts are zero and either REQ_OP_DRV_OUT or REC_OP_DRV_IN are
> used to prevent retries by midlevel.)
>=20

Please hold this patch until the problem below has been solved.


The following came into my mind when I looked at John's debugging data =
he
sent to linux-scsi today.

I still think that UNIT ATTENTIONs (UAs) reach the high level device =
without
problems. The problem is that the device attached to the target first =
issuing
a SCSI command after reset gets the UA. As long as this is st device,
there are no problems. But, if it is the sg device attached to the same =
target,
the tape device misses it.

The device->was_reset flag stays set in many (most?) cases forever, =
unless
someone resets it. (Scsi_error resets it only if the associated kthread =
ends
up locking the device door.) Because the flag stays set, the st device =
can
notice it even if the sg device gets the UA.

Using a flag set by an other layer is ugly (to put it mildly). Even =
uglier is that
st clears the flag when it has noticed that it is set.

And there are cases where the device reset does not originate from the
same computer.

Does anyone have any suggestions?

