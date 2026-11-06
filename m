Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972658;
	b=kRAjg6YIxZq5MoZfk4WjUfUO6mM68puQUOcC9yaOEQoVW/suQebQr9SGMHvrxXNd5pzV
	 6N0/JlXx2py2RU6fJpkCjnMLjfSVpSG6RArD7hKJenySl6V2urM5pEAQlLle3jgriU5aW
	 PAmFOq3/0/Iz3UvgNjL5IoL0yOC2jR3vDbeEyigMTK1WnVL1Y9YqTqVTDUNjHSTIMFjFR
	 sVI1Ec73Vu5vl3GxPPsEJ3/7Qw7LVhE7wDM/m9nj4micMzggI5HdPqG2ZU4EQbnMIlL+a
	 OB1MpwI01kuZUC8dai8wy0zgVeJx53RvHJjk1W64y/X0gJTvk5dy7rQN9nbdxafSv8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972658;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=gfOdoxVzmcRZMFFbD4C2XKWaD4ECzjOlzqXWcBdDuyg=;
	b=PyszUhArXt62jExOqbNHdqKG7TUnmmiGbnnJFBz+4c1kWg2hlJg/YGa3d7EHRdevIgpT
	 LFt/MnQYVT/ZBJHhju2bkX+5+In3PiHTnOre2BCTxETSP4Q2lmp5ZCjxBNgA+Oq0Zi5B4
	 hGYY71Fu6hQbm3pddZQOp82zK7raDbJV7MXCBygFtQUN0DEZlYDQxqyL8vwIirZyZLBNX
	 uYlfx6lwlythKyVIlTV+2ToI7Ihe4VMBjwMYvDwClAqraXgFLw9Sb20eMQRO0vy+LodWH
	 kzyEuGuOIJBd+goz6tIdAI4NDImp0NyKF0xd9leCLO20Hgdp5XDectxg7Cv2/BPksEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Nh58QYRn;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=RK07y3OM;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BB2606A33C
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 13:44:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82BB2606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Nh58QYRn;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=RK07y3OM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793972656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gfOdoxVzmcRZMFFbD4C2XKWaD4ECzjOlzqXWcBdDuyg=;
	b=Nh58QYRnT9SQSAN43yBv5k9L3UZq+dMAVtPcFi+fDujuSJ5pCQfwt8gSV7voonmLtYLIo0
	hA5+lErE6NEmnU8NGfC66YrGV4yo5QvvHCVX+0NV6+nRiVSs2+sW5LGj0HvYKGB8o6SM3i
	JPO9M2V8II4xOxycgJt9FIzI1/tRYgs=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-7DU8YCXuOFCsTaJPQ31H7A-1; Fri, 06 Nov 2026 08:44:15 -0500
X-MC-Unique: 7DU8YCXuOFCsTaJPQ31H7A-1
X-Mimecast-MFC-AGG-ID: 7DU8YCXuOFCsTaJPQ31H7A_1793972654
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-869553205a7so9917877b3.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 Nov 2026 05:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793972654; x=1794577454; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gfOdoxVzmcRZMFFbD4C2XKWaD4ECzjOlzqXWcBdDuyg=;
        b=RK07y3OMOkKkjbts3EQuQ30Phro3KCi0lLLMApt04jGO2vqcY0a/U5+7ut0nI+4fpj
         mPuPABkXudcnPR3eDOlu1R2WQXqg5PGjPfbpiIR18qLtOJFXRTjmS2mIMuHS7QVcAAIE
         QZ4pmci01YGtDMQT2nRI4GqC3RRAIsYQjPLboR8SOYOkYMToKR3ZwPJLUaMmgyjD6iJb
         RzKGWxRRaIxbXfjC88QPT3yvByzDxPiEU7zWh3UsFhIEfERRlPn7UeAilbUDU+VkFK0i
         MzdOjACoC6JxX/nChnHRBuCXbmwLrOLufX2lamAIwOEuXWNm4DmqQmYT6LahDSdE2rpj
         0XaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972654; x=1794577454;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gfOdoxVzmcRZMFFbD4C2XKWaD4ECzjOlzqXWcBdDuyg=;
        b=uWRLSO0DUMgVsVcaSVwT4rv6XWjD4XpSufuBHFEel49OuQ/ZlB4Mp3MhhrxmYvgMr1
         GvMGZC5aTkGlUHaApy/4zHNqFlTW5tDZl3G8zoq3qLJjne1zunjEulv4LGOtP7Ruv9ji
         B54MmABcXpyaGG8wY4MdlzguDwuZZtwcUqGAP5ASBA85Q2V5v9UipHj894A3C8HWEVa+
         XoJnld9+xQjkEXOYFiNU430MdZbvcEF+MonmkdzLz12hUpzE1LUgzZiVs483wwHD7cKv
         U1FZ80sJIDFtFHL3ns3kVqIh/Af47FLT3kGvGagN2EsEpmBZK65CJtvcttS7w5LtcXeo
         z6Dw==
X-Forwarded-Encrypted: i=1; AL+hErHx49gyWUYqSA6kGAMfzlocyY0JwzRIOunTFcCxY+nlvw3uSCOhtm1B7uSkiEoZkcokla/B2zYRy0LR@vger.kernel.org
X-Gm-Message-State: APuU4Z/PH1D1CbW7kdIbmmXYtJsbPENybNTgj1QSM/OXKm4DxYfKpakk
	8O4hFFDnJiyboD4RqWsygVSdLKizDOkAp0KjnN/UwhhoGReK4yLdi7qjrYrqYlfZDb4U3r8Qyeh
	iCR6CqZgt6vKtjJAd2h4QL6ba/yZ2mfMC2B43bRC1FWcU92+qtOoO4ETo/kXRaQ0=
X-Gm-Gg: AYBFou1y4PP9zHfTnLNgnxa5zMtu+tPNx9GyH/m+FNscN1ztiUCLev/BPRUFCH2Ve7k
	bTSxrFvVECuPkhpM1+03j6lLun5DC/8aE+2mEPdGIPCb9w5Hu+0Uyn+SKJNOS9mUMfcbEoR6J1S
	UuAz2K1qi/nvCKQMaddE3xAATuTcHSmbld2Wtu7cJRph6UA6kSOvAZdhtbyfqEruxrrbdLbScUd
	qPZQxgkk6t3l+OJESdDG+CtwIt0MAUlHs8CmITP5nZ57ea2PNWBt83HWcyW5ToLA8cVf1c0hvYB
	N3IyxGvvPOSewZDx1AecLxQ0h9UQjD7mCshntxL+CAlhoXrpdvxtuj+54zKxkFdaSXNTpLOqJHc
	lF7tED+vtTNaSIsL80r0ZLQ/KsjnMZIAcTRY5eUmRqFvSBgieHvKjjICQYUY8IoqgFSnb12oxfU
	r2+LGHR1iwJcUIp1HD4dVKciYQDdG7RxaqDBs5YQrB9d8B1bsQtFjP+KFS4cJfIWVO26m1id4=
X-Received: by 2002:a05:690c:c50e:b0:8b3:4deb:7ce1 with SMTP id 00721157ae682-8b34deb8019mr3630717b3.14.1793972654460;
        Fri, 06 Nov 2026 05:44:14 -0800 (PST)
X-Received: by 2002:a05:690c:c50e:b0:8b3:4deb:7ce1 with SMTP id 00721157ae682-8b34deb8019mr3630577b3.14.1793972653998;
        Fri, 06 Nov 2026 05:44:13 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b33f7f061bsm19101907b3.21.2026.11.06.05.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:44:13 -0800 (PST)
Message-ID: <51dba0cd5655a635be2980267d51c4cb3dfa0314.camel@redhat.com>
Subject: Re: [PATCH] scsi: st: Avoid truncating the tape name for large tape
 numbers
From: Laurence Oberman <loberman@redhat.com>
To: xujiahao <xujiahao@cmss.chinamobile.com>, John Meneghini
	 <jmeneghi@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen"
	 <mkp@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 06 Nov 2026 08:44:11 -0500
In-Reply-To: <20261106021730.3409119-1-xujiahao@cmss.chinamobile.com>
References: <20261106021730.3409119-1-xujiahao@cmss.chinamobile.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-11-06 at 10:17 +0800, xujiahao wrote:
> create_one_cdev() builds the class device name in a 10-byte buffer as
> "n" (no-rewind devices) + tape->name + a one-character mode suffix.
> tape->name is a DISK_NAME_LEN (32) byte array holding "st%d", and the
> tape index comes from an idr with an upper bound of ST_MAX_TAPES - 1
> (131071, six digits), so "n" + "st131071" + suffix + terminator needs
> 11 bytes.=C2=A0 Names of tapes with large index numbers are truncated
> today
> and lose the mode suffix, which leaves the rewind modes of such a
> tape
> with the same name.
>=20
> Size the buffer after the actual requirement, DISK_NAME_LEN + 2, and
> pass sizeof(name) to snprintf() so the two cannot drift apart again.
>=20
> GCC reports with -Wformat-truncation=3D2:
>=20
> =C2=A0 drivers/scsi/st.c:4393:31: warning: '%s' directive output may be
> truncated writing up to 31 bytes into a region of size between 9 and
> 10 [-Wformat-truncation=3D]
>=20
> Signed-off-by: xujiahao <xujiahao@cmss.chinamobile.com>
> ---
> =C2=A0drivers/scsi/st.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index e9d41e3cc..311781987 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4366,7 +4366,7 @@ static int create_one_cdev(struct scsi_tape
> *tape, int mode, int rew)
> =C2=A0	struct cdev *cdev;
> =C2=A0	struct device *dev;
> =C2=A0	struct st_modedef *STm =3D &(tape->modes[mode]);
> -	char name[10];
> +	char name[DISK_NAME_LEN + 2];
> =C2=A0	int dev_num =3D tape->index;
> =C2=A0
> =C2=A0	cdev_devno =3D MKDEV(SCSI_TAPE_MAJOR, TAPE_MINOR(dev_num,
> mode, rew));
> @@ -4390,7 +4390,7 @@ static int create_one_cdev(struct scsi_tape
> *tape, int mode, int rew)
> =C2=A0	}
> =C2=A0
> =C2=A0	i =3D mode << (4 - ST_NBR_MODE_BITS);
> -	snprintf(name, 10, "%s%s%s", rew ? "n" : "",
> +	snprintf(name, sizeof(name), "%s%s%s", rew ? "n" : "",
> =C2=A0		 tape->name, st_formats[i]);
> =C2=A0
> =C2=A0	dev =3D device_create(&st_sysfs_class, &tape->device-
> >sdev_gendev,

Hi,

Thanks for the patch.

The arithmetic is correct, but the truncation only occurs with tape
indices >=3D 100000, which is not a configuration anyone will
realistically
have. So this addresses a W=3D2 format-truncation warning rather than a
real-world problem, and I'd prefer not to churn st.c for that.

NAK for now.

Regards,
Laurence

