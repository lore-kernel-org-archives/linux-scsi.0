Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B89D1E0B7D
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 08:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730969800; cv=none; b=Z63wwNF9V55O3kn5px/0JludQees9FC/H/i4IhwRfSbX3njTe0O79Sr9WcIYU+bjrtk+iU+nDNWm2UQIXUmvqViFDP7ZuvSQpWFo70fOKJP8qfoWvxwIDcpQtD48y3j9+3kYXOLdmvfQ8j6L794kPuUiOXfzjKLyJ5Rzl5H6jPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730969800; c=relaxed/simple;
	bh=qu2S4s0SnCZhtAaFHz6asPaLoRBnKoJtNUmQzz3yyoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=puGtm0Q9bvK25levLB1jtCA4OuhfONteA5KK0XUg5AyYPtPdAjXspIAdfxhoWHGfdlBF0TwU7qrQy5gq1D4zKNh6epeiqhWlwEjVG87tCJFYzvKVRCpyqhI+AflbOeloPoU3ns7Xp6JwM9T/SAZ3HKj+bUwxRVeI2TPwJIipmfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JB6Tr1Dp; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JB6Tr1Dp"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-84fdb038aaaso271449241.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2024 00:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730969798; x=1731574598; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E/yGZZaMEVC4v1kS/VoIgUaTu4umRI+PaLTQ7ycTMeY=;
        b=JB6Tr1Dp7ptcGwIEHfmxhuqskwc3MM6rbbZ0tBBEqPmqUWexa1hAeRyX1ay9kSONaO
         ynKn5opRXHR+RkUFfI9dLKAGN5ATzmma40+d4u4J5oH7CeNZyKr67+Qz91uWZP2YmOgU
         Irj0mT04+3pzDY2GJlILJpWf/m42OUhv6Ldyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730969798; x=1731574598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E/yGZZaMEVC4v1kS/VoIgUaTu4umRI+PaLTQ7ycTMeY=;
        b=tt2xaNWgcplTLudfUeoh7QzVoA3Mu5/noNIOgR0CF/JNBKtomglMylpROWdMFYufve
         anwcLEZcJitbzktNAiZ2quHdXgZfj9BCusutBaSZcK1l/mkW/8TEL9E2HhsZzxWYN4sA
         YlLpkC1O3DCUlaTc0pWEKDTXVtjWKstmdsVjkWUnXxBxTEO7yV7jVaFtLZiSy/YWMyrh
         ppfNu5Pa2CeR5HvFKvl1FPzPGwf5Iti4RfRaWy/tTqFZ1Om6abl48I/Z6IX36AvvHM5D
         GK+N2R8LhxbrV5VGsEP8Oztb6qtgHcXgDDQlsvzmfmEa36YXMNju0r/LaquoI9sb0b1u
         CHEg==
X-Gm-Message-State: AOJu0YyndJ9DIdaXjf9Yiec0cAGHH2xcyfLjbXRvjqURxt9oJdaAOzky
	T3hmqEmSOizrutNBAqiIkiNzEf7eXmMStGM4aJC+YkO3g85UHwu23tYSkObeJD06wu6ITWBtQld
	sMPPU+mcKUnMhdDrvexHwbqpODh/2pv4P2xX7LG1sEyUewEBErw==
X-Google-Smtp-Source: AGHT+IH/25nz1xA83CGqJUyOWA5AbmEyc/CPZv0jCl6809kku0jk9mVBTzpmsGqvuqn72KO418iZR7Ln6h5uGUDPeB0=
X-Received: by 2002:a05:6102:4190:b0:4a3:d4bd:257a with SMTP id
 ada2fe7eead31-4a962ef6bfamr22243726137.23.1730969797860; Thu, 07 Nov 2024
 00:56:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240923174833.45345-1-thenzl@redhat.com> <026951b5-69ea-49c7-b48b-5d426ccd1ec5@redhat.com>
In-Reply-To: <026951b5-69ea-49c7-b48b-5d426ccd1ec5@redhat.com>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Thu, 7 Nov 2024 14:26:26 +0530
Message-ID: <CABvwm=M5F8MSLx0RY4hC=m+hH9=fh+56Kk=iRknRos=HFwC+ug@mail.gmail.com>
Subject: Re: [PATCH] megaraid_sas: fix for a potential deadlock
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com, 
	sumit.saxena@broadcom.com, ranjan.kumar@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000ef449d06264ecfa9"

--000000000000ef449d06264ecfa9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 9:57=E2=80=AFPM Tomas Henzl <thenzl@redhat.com> wrot=
e:
>
> On 9/23/24 19:48, Tomas Henzl wrote:
> > This fixes a 'possible circular locking dependency detected' warning
> >       CPU0                    CPU1
> >       ----                    ----
> >  lock(&instance->reset_mutex);
> >                               lock(&shost->scan_mutex);
> >                               lock(&instance->reset_mutex);
> >  lock(&shost->scan_mutex);
> >
> >
> > Fix this but temporarily releasing the reset_mutex.
> >
> > Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/m=
egaraid/megaraid_sas_base.c
> > index 6c79c350a4d5..253cc1159661 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -8907,8 +8907,11 @@ megasas_aen_polling(struct work_struct *work)
> >                                                  (ld_target_id / MEGASA=
S_MAX_DEV_PER_CHANNEL),
> >                                                  (ld_target_id % MEGASA=
S_MAX_DEV_PER_CHANNEL),
> >                                                  0);
> > -                     if (sdev1)
> > +                     if (sdev1) {
> > +                             mutex_unlock(&instance->reset_mutex);
> >                               megasas_remove_scsi_device(sdev1);
> > +                             mutex_lock(&instance->reset_mutex);
> > +                     }
> >
> >                       event_type =3D SCAN_VD_CHANNEL;
> >                       break;
>
> Hi Chandrakanth,
>
> can you please review this patch?
>
> Thanks, Tomas
>

Patch looks good to me.

Acked-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

--000000000000ef449d06264ecfa9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBV4wggRGoAMCAQICDEdtED9Zj45VgZuf5zANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwOTM0MzhaFw0yNTA5MTAwOTM0MzhaMIGa
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGzAZBgNVBAMTEkNoYW5kcmFrYW50aCBQYXRpbDEuMCwGCSqG
SIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAOPMhBafUXswA97gXTj1d5WoUBuCuq3xszdg5lAM1AHavwkVYXn9nKUH
7QgAR6GV/PyPyloLcAeIkTarJRpxB885+xOyR4EAA8zRk9mirwq7GotMjSmRA81Ne5tpqZObHbsv
ELVogt2xoFkQFwDZznRDVQ1RRWO8gLU/7clg4TWqNxSsRF7PfM2U1sk6If8qHVMdtHLukGibl0Tv
4SxjDQ1M8uqWXeJcdYM4lQc+PSKyTNqPy/KLt1enu6lmA236FXBhPFSg3+EeZ9Ma7ZMj++uMpnwz
jLZb2F4wVMfuh/ZTi4ty6G3wQ/OIFcK4EkaKubAqreTT+LEu5XOFi10KHncCAwEAAaOCAeAwggHc
MA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9z
ZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
dDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFs
c2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+
oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
tI7aNGRrv6gHqOPkFli9EdvR2xcwDQYJKoZIhvcNAQELBQADggEBAI0Px1+MF4ubFWlBurQFxZRv
/K8V2fysp6NhKRpdJ43KozsApD438TU9DdNe8wW1MrCV3sRXZhlEkkukkfppzYRuoemmIdd4Rajh
Dh+uglOx3CYSKKOEWSbVIaDVMBQvVtqfZlGJgLRmLpO2agb8V/eY85IoMoM9hJkTll7OoTo+Lhon
W2v5XKnfV6+4iODhAb65bwLbcNq6dxzr1Yy/fGnIBfoR2qrX9UBDDxjZRpxJGdt7i0CcvsX7p2ia
SgP+hUBq9GTgLiFqCGyh/gCm2DTB/TyYel0QsIP29qWC1F5mG+GOoSjagi/2SxnNI6LzK+4xfgvc
80IlL0UapzuyZFExggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgxHbRA/WY+OVYGbn+cwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIF2pSTqq
LlAjf1IidHHobkqdTPwwXOobHHr2Ai09ZpgnMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI0MTEwNzA4NTYzOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB5g/VKxPezWw7KvC5vqrqZLFZn
GyCUwVKVkyb9A/pPLtL2uVbJ5s0Qp3YYcjkIwUGRS0RCavZGTq/1AEKs9ZdEw2seGNQDNWqoYiJ9
uNMQqH5isiXcwAON77+JARc2UkuQX2LZjsjyCXtCnWPfuPXm3Z0riMxQH0D/C3SWMiZMaMkHCr9z
LSTQlcHU/Ig2yGuL5N4TOL97oq0GGqBCVHPDAl1fERtwHQd1tUQB2pNE8qtckiBDdz8Io9ep4k9L
RSZQvmbK5Xibe4vc66fGHM5JV9WyR8whaChfbmvjkd4AHz2bn7gyXj3WXnUKfmmXQIjkwyPCt29K
EerItR+3rjns
--000000000000ef449d06264ecfa9--
