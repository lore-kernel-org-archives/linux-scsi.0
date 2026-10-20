Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533299;
	b=FjwqUERAgQVOIktAE5cbxUo7lU9hRrnFMUJpJg0xRbF+262CU5ZvrnfqPiVE8W9Q7oEA
	 78SYhsUdxk+IakEEdwOjGhDj+hkG8kO1xD1qq/nDOxVngITrETJxgdTCxkxghUC+WhvjP
	 zXD8Mh7/VhOa4YUR9idR99dx8KY7y3zm0lWaN5TuDj1kjLESwuNaSEBRErmhlxubvaJ9F
	 FdUZTuo5IYtW0Qrr4wbWndb7mdy9gJkgnJKAPkRtu937ljnFdX4coeK6dM/lqUMTSB0DY
	 /njt3vJk2jsOG/jaWUqZdb7KtknPynjEhOlNMzsL3XvfsQj/CaM5vTCIvTcNVHP0m9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533299;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=3OTPHtHhVUMIT+NWFEN5/mmRIvv8BU1Kwwt6/o60whk=;
	b=hjKz9kxT/jGcHUHWgJ8RXlaNtpTpHqzX9J7J+b+kSF2nLP611rcuVQz5NQZig0bt8FEm
	 hRZNo0gSgYpFgZp8prJwTUOFhmajucev4YqpH1mZ9zj7Cf6YlOcGMpndcp9h+WQgYKRW0
	 uOxum58wDhD2yE9bIUYnpn7ur9l0znczRBGGvk5s1JhuSdotRmFtMUl0AnXDueY1PCigh
	 g8yxsJs5GLK1mt3nW5JWDZJgxFB7TzpkJ2ZX6LBEEQXsgLqCYzJU3wILJtc6WdROmAClF
	 KBWbC0l/qz57XyYCUtUR/SFlQheRAaHSDz5v13XVFl6YCg/AUZ7DgUm+IWHd5UPIYnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V0FU68Q3;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Gcjgl1A5;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AE9606A31A
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 21:54:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43AE9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V0FU68Q3;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Gcjgl1A5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792533298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3OTPHtHhVUMIT+NWFEN5/mmRIvv8BU1Kwwt6/o60whk=;
	b=V0FU68Q3667Y3QYgzn3x6xm/kIlDfXcjDfHClIwKQ25D37lLM0k6M/xa50C7tlNay7e3tl
	NEb7ha5bOtLAjlR5dAPDJWGz3r+RQ38q/CWTH7ashx/vmvfoE+k2wZkDF5kPGt5vZXuQRT
	1ZcOpuItH2H648u+2bsVgARXD1TMZaY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-eEflQRphOY6coXjt1XaLKQ-1; Tue, 20 Oct 2026 21:54:56 +0000
X-MC-Unique: eEflQRphOY6coXjt1XaLKQ-1
X-Mimecast-MFC-AGG-ID: eEflQRphOY6coXjt1XaLKQ_1792533295
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e82060977so26742185a.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792533295; x=1793138095; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3OTPHtHhVUMIT+NWFEN5/mmRIvv8BU1Kwwt6/o60whk=;
        b=Gcjgl1A55dgDc+s92wAaserrFNuCgm3EHQoS9i2gzuJuJaficop87K9qagGWa5AlVc
         y6iLiIgNRUTRjvBYq0yzDFbMMm2RpUTjAUBDyMvl/8FHbjIkkkmoyUBKqOm/ekSv/6V7
         Ad/QSpdUjStd+TgVnTJVSnCfyqeM7qfHxyqbFuKpHZzn1G69CHa9CqTNcNsNdBVY2e6T
         FCEjPzY4266aMpg3seb6gU878ATICn7U/ONDCTJj4MSFGaPstTjj/vdaY5OtsxbozTRf
         K50SbJ3mV+eU2BfMOlFcvqQPqwAZE5ZGwrf+haHFMSNueNpG955kLiEr+a4gZ+KN3haX
         SafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533295; x=1793138095;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3OTPHtHhVUMIT+NWFEN5/mmRIvv8BU1Kwwt6/o60whk=;
        b=2tsSt4HCZNXFJ6lh8BohTwC5gqLIqMjuJw05n5bWMlT8R01EfGTe9RawLaUTGUvmqo
         6vRJUNMnYmev8gzbZEeWybsruBK067F42ytf9dGe3I+m6OGltSADM0vjWQgNPCsfwmRX
         P8E+PksttYECl5bOaUip9lL/7zlEWFpBW/mci8O2zXp4JpAnX4yDp6aeh6bF7Kp6ni1p
         6kpFH1L8rmZcUN9CHYYB3Qwf9bBERVZ8h23UmT3jTfFPN9dKeuFJGU+n4slRje4oDgvU
         K9O7dKavFGkLUpnOcQTUTmy3K+F4dNkTjkYVzcOL/+HFYHVPesBdxgycAK7RLOBBcF7k
         rw2A==
X-Forwarded-Encrypted: i=1; AKwUvBwO3HEUWtgjekZMOXyb1tKqdZN77y5VHmMBWuxfIgb0JV12HLfHChMHLmlw617AgnU21Yl+u7torNZ8@vger.kernel.org
X-Gm-Message-State: AFq9FYILosQEn6MAVSyBnrQKtbEWdmjFmEs7yjb7kGTo00kQgkfuvXad
	RI3+YBATHhSKUaW16JyvLR5wo+Ih3JbbsnN2VW3cXmzJtHjykPQlqVtnyOtONuaNVKzef2GjBvm
	O3RkI0T663PYaiKg3MpaQO5fUc6reBKiH+4XfNUBrCooKs1JVaYhnEQ+ENxQ4kzA=
X-Gm-Gg: AYBFou3yDFRU6I6KnDFzA36mQkwpkQTNWd6hDtACKTSSj2sUUKeuYbKKyF3NsIl3il6
	IfLqftFcX3uFMAd83oRBovLM/IS76ZKjTCIHas+Xi97ojwfGuo+qxea4EIggH7Sp4VKdqEhT4YZ
	XBecHyzz/7Y9FOF8JE365kZhwM1jzGiqkXLHGOEo6Te7Ppq0ogA54TOdAfC/PpmNheIWn4G3BVg
	TUv40ZL9W/AgKbNo8kiXgf9879zx2USd+ziInd0XJkUq/mIZGi/GVXIzp99e3cj/Ew6bMzXNLk/
	q5SDvA6zl7CJaMu4yEUagEHxTpvYhzpTAQqNaxnQxB+6OeB1pecxrd1WRryZpJwbEyIOpZ29Ksn
	k3dy7FV8jEh3Tx1AZPMa6mhkCqCHHtbD8YObv
X-Received: by 2002:a05:620a:45aa:b0:93e:c173:f694 with SMTP id af79cd13be357-93f57fbb83dmr96058585a.40.1792533295398;
        Tue, 20 Oct 2026 14:54:55 -0700 (PDT)
X-Received: by 2002:a05:620a:45aa:b0:93e:c173:f694 with SMTP id af79cd13be357-93f57fbb83dmr96056085a.40.1792533294955;
        Tue, 20 Oct 2026 14:54:54 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56df222dsm87495785a.26.2026.10.20.14.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 14:54:54 -0700 (PDT)
Message-ID: <d530c5c6785af95c5dde07f305bbdf2ff1266be5.camel@redhat.com>
Subject: Re: [PATCH] scsi: mpt3sas: Register devices during SANITIZE
From: Laurence Oberman <loberman@redhat.com>
To: vince@palmit.com.au, linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, 
	James.Bottomley@HansenPartnership.com, mkp@kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org
Date: Tue, 20 Oct 2026 17:54:53 -0400
In-Reply-To: <20261020210856.42835-1-vince@palmit.com.au>
References: <20261020210856.42835-1-vince@palmit.com.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Wed, 2026-10-21 at 07:08 +1000, vince@palmit.com.au wrote:
> A SAS disk being sanitized responds to TEST UNIT READY with NOT
> READY, ASC 0x04, ASCQ 0x1b. mpt3sas discovery maps this sense to
> DEVICE_START_UNIT and issues START UNIT repeatedly. The drive stays
> NOT READY until the sanitize operation completes, causing discovery
> to exhaust its retry budget and decline SCSI device registration.
>=20
> Allow registration only for the SANITIZE IN PROGRESS sense, so sd/sg
> can expose the target while retaining its actual NOT READY state.
> All other sense dispositions are unchanged.
>=20
> On an LSI SAS3008 with an HGST HUH728080AL4200, unpatched Linux
> 7.2.11 retried discovery 145 times without registering the device.
> Linux 6.18.55 registered the same sanitizing drive. With the
> equivalent 7.2.11 fix the disk registered as /dev/sda (0 B) and
> /dev/sg0 while TEST UNIT READY still reported 02/04/1b and 47.32%
> SANITIZE progress. Another SAS drive continued to enumerate.
>=20
> This updated variant uses the named 0x041b sense constant introduced
> in newer kernels. It passed static review on the current SCSI
> for-next branch but has not been independently boot-tested there.
>=20
> Fixes: aee682fad6cd ("scsi: mpt3sas: Improve device discovery and
> readiness handling for slow devices")
> Assisted-by: LLM
> Signed-off-by: Vincent YUE <vince@palmit.com.au>
> ---
> =C2=A0drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
> =C2=A01 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 085d4672d..a77bbc3d2 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -7700,7 +7700,9 @@ _scsih_determine_disposition(struct
> MPT3SAS_ADAPTER *ioc,
> =C2=A0				u16 scode =3D
> scsi_sense_code(sense_info.asc,
> =C2=A0							=C2=A0=C2=A0=C2=A0
> sense_info.ascq);
> =C2=A0
> -				if (scode =3D=3D
> +				if (scode =3D=3D
> LU_NOT_READY_SANITIZE_IN_PROGRESS)
> +					rc =3D DEVICE_READY;
> +				else if (scode =3D=3D
> =C2=A0				=C2=A0=C2=A0=C2=A0
> LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED ||
> =C2=A0				=C2=A0=C2=A0=C2=A0 scode =3D=3D
> =C2=A0				=C2=A0=C2=A0=C2=A0
> LU_NOT_ACCESSIBLE_TARGET_PORT_IN_STANDBY_STATE ||
> --
> 2.56.0
>=20
>=20
Hello

The patch looks good. I am curious, though, how the drive got into the
sanitize state before it was registered. Was SANITIZE issued while the
drive was registered under 6.18 (or via mpt3sas passthrough), followed
by a reboot into 7.2.11? Or did the drive come up already sanitizing,
for example after a power cycle part way through an operation started
elsewhere? Since a sanitize persists across power-on, the second case
would mean a drive in this state is simply invisible on the unpatched
kernel, which strengthens the case for the fix.

Reviewed-by: Laurence Oberman loberman@redhat.com

