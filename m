Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CF31DE3A3
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 08:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730969851; cv=none; b=t71tYZwFhZMi4xepbzTpB4kQEtsjsrC5BlHzLFYTi7fazx+jJ5xUO/+QnoW9UyxRorRQ/+tldlrXqtb+1lwzu4Jj2xfCdDuZdJdgFq96Pbk5SGksihaccEY0tNv6FN+8Rjyu8pch++/GyybfriLFEJ5hTxeiGjNWknCisAtkcO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730969851; c=relaxed/simple;
	bh=d3s+RWisqE8aZ6sDim5SmmD4NGTK3DVKfa9FFQhqYVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VIvutYVXtMKbzT+9fUCqH/PT9hcGryDhj75pFhkC06/1faaW1AVCvpNskDD633rl5GHQfP8Jl5+vlAh7NBe1fcG8hAGHIi6RkknzmN5LCfQlG3LbyrFQ11+4/Q0yT/Gf0lxyt4zyTRgiEo58XmpJQXcq96LLVsEyunmOfK9bPvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=MV7/0Reu; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MV7/0Reu"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-50dc984bf5dso330398e0c.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2024 00:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730969849; x=1731574649; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dJDILdHGH6h0+ueZ+0FyfoHclZa1sIHneqxRiL9xNsI=;
        b=MV7/0ReuakXyILPOqC8vQnUoq6+IICZ3ZLDSNekVvktApam5Lm8R4xqor8blcjoir9
         8HxPOKwNNAGwiiejPL7zrSU04xwb2vvaoQ+jH3iMNEjew4FGEoECjpsUjD+TiNKASiaK
         lb003ma22JHHEA1fROpzjmzShp6HJZzahOHII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730969849; x=1731574649;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJDILdHGH6h0+ueZ+0FyfoHclZa1sIHneqxRiL9xNsI=;
        b=F/VudHnKrAPGbIuO+06t1Regfp2iF1rOtFYmcqWYVGawUZJ0a0pvj9/6LltpdhXNep
         CcnvBHb6Jp75iz7cvklpebZ8JCw2crk88j9GlV1751cuIZlHMYnM1VxBkBpHeMT58YT+
         2GxDkg8jJ3jZeGneHhGALRFNJNgwoS6cM1046/2CH8I3rkam1C88Lkb4rjRDNu6QyU6f
         NiAJ6UZRFEdfUgeoznQaYUgWYoYH44BqbaN9EvozuGJRfXii9207pAcZVdZRuLQL5WmS
         tUYThX2c3nVp834aE8sKP3hLUe6PZ8MsqPesrFvdQtsiXJynUnl5EWDVPHB3VW8lixs+
         UL7A==
X-Gm-Message-State: AOJu0Yx4/EqAZGy7LzTT4IN03tx3rONV1jiUGngZ2GUt1ENSWdLcWT+o
	7OgEh9RLyUkXqJgGUHC4E4tfOzlNU93EW3pTj0XYhWtd2nWUieukdL8tmHlpoi4/8cOHzFfwWog
	HkTuUvDK2vpZYBmwTuTMTHHCZTi8FN89fbETc
X-Google-Smtp-Source: AGHT+IGkHAfFAYm+6lhaqG3tebZRrr5Z5Vmod+FHq+KEvGK25m5HVOFGiO2QnVRXkKVU3cAA4Oaj8SBBXtP9sUhvrnw=
X-Received: by 2002:a05:6122:46a1:b0:50d:6a43:d525 with SMTP id
 71dfb90a1353d-513fa2eefdamr178495e0c.1.1730969848981; Thu, 07 Nov 2024
 00:57:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240923174833.45345-1-thenzl@redhat.com>
In-Reply-To: <20240923174833.45345-1-thenzl@redhat.com>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Thu, 7 Nov 2024 14:27:17 +0530
Message-ID: <CABvwm=NNbtLa1e7aqCCV8ebkDYfhES+jNurbZXK4eA+FcdtDCw@mail.gmail.com>
Subject: Re: [PATCH] megaraid_sas: fix for a potential deadlock
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com, 
	sumit.saxena@broadcom.com, ranjan.kumar@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000fc7f6006264ed2a9"

--000000000000fc7f6006264ed2a9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2024 at 11:18=E2=80=AFPM Tomas Henzl <thenzl@redhat.com> wr=
ote:
>
> This fixes a 'possible circular locking dependency detected' warning
>       CPU0                    CPU1
>       ----                    ----
>  lock(&instance->reset_mutex);
>                               lock(&shost->scan_mutex);
>                               lock(&instance->reset_mutex);
>  lock(&shost->scan_mutex);
>
>
> Fix this but temporarily releasing the reset_mutex.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
> index 6c79c350a4d5..253cc1159661 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -8907,8 +8907,11 @@ megasas_aen_polling(struct work_struct *work)
>                                                    (ld_target_id / MEGASA=
S_MAX_DEV_PER_CHANNEL),
>                                                    (ld_target_id % MEGASA=
S_MAX_DEV_PER_CHANNEL),
>                                                    0);
> -                       if (sdev1)
> +                       if (sdev1) {
> +                               mutex_unlock(&instance->reset_mutex);
>                                 megasas_remove_scsi_device(sdev1);
> +                               mutex_lock(&instance->reset_mutex);
> +                       }
>
>                         event_type =3D SCAN_VD_CHANNEL;
>                         break;
> --
> 2.46.0
>

Patch looks good to me.
Acked-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

--000000000000fc7f6006264ed2a9
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
MDIwAgxHbRA/WY+OVYGbn+cwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIC5b1bwM
c0USmJMyTmECi+VRXlx5b07DV8bpEkzaDdKzMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI0MTEwNzA4NTcyOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBZW0bx931daArTeLJcXV2gSGcb
rX35aFRWpBfkHPnMGqVFDWPsjndxjFirlV6sdKnnJfURqmnHqDqe8fZQheIYhFHTTNlEkXyg2WL1
q8C988x5Vh9rltvwmPAUIJStjNFJTJLdCGfep19HGAAHMrWQGweW2q0y/4Uvv2ALdzoOB2HUQN7K
Exjble4s2f/4QsBjxgRsljMKMFMEQh6MkY9qKaZsm/D6hWufH33onl5dNkqw/MjSeUEpqm8xUroI
0i+mRrw4I/CFUeh3zGBMXIjMBdcVPjKsWiBG1AMj6yELCsg+audPzZnTJnuXe7zBcfNgsrXUE4hf
uO5PHIznu11H
--000000000000fc7f6006264ed2a9--
