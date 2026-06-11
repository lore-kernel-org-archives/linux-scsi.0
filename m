Received: from mail-dy1-f225.google.com (mail-dy1-f225.google.com [74.125.82.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E583FADF7
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 15:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781191669; cv=none; b=DcjnS0CHDd1863VeY82HtK4l7jXG98wDH8Qs4BKfE1dQiQweZ9mvEIjr1wqkFtcXQMT0QQVKkEsK630SlHGLXRHSQRObgeHsL/vfS407lU1S5o6j2NQTJgBKnX36nSdemLVGlVZAjCWeiQZIb/3ogfB3nolOn2p27mg9awZiS/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781191669; c=relaxed/simple;
	bh=xETqdZf6SLWXonSYRtymuS5zk3yWU2EdRj+5hCx/oAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IolxRWRU+sLyB1/LkS0EQb0dRZ1XrXdi4Ec+Loyna5Yy/mCrSNy+PUlepUP9X4J/3zWg786FoxoApwdwbeiq9vPa4+2CZHyqjoJe7QEFd4xObfjOlgmSiXzYdZscPsy814Wf7s/Ws/b8yPNOAapnObTc+eMBTu2fGanB9KZK1XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=THP0TfX3; arc=none smtp.client-ip=74.125.82.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="THP0TfX3"
Received: by mail-dy1-f225.google.com with SMTP id 5a478bee46e88-304fb780deaso8095664eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 08:27:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781191667; x=1781796467;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xETqdZf6SLWXonSYRtymuS5zk3yWU2EdRj+5hCx/oAQ=;
        b=P9OuowA34ebur3eR7yUcmIYcW4AHxtAxNRe28q7g/b9ueRBsw7BgIBcUVWGViTeraV
         TYs7pjkQBy0IuJTiyOOYXWAm9NwtooK4iKXp1xdDJKCczsZsTLtf9Hvgmn/uw3sr9bgL
         60nlwPxuiI94r05hlSaP7FTlcEkwX5RR9Mp+q3AcQIoVlT3BBsaW/SuZnQdypPasI13E
         t14Fcf+7MFwJlIpHoRLQmXtL9tor/Zs3lKPWN4yrfoJ/SOIYUlYCytOy0Hnkfm1lHLvj
         UeLFvS7QuTM5IdL0dzk8jgbA6+3F7g+ldiN16T173WeoAyX9hEUeNNCBeZLuvtaqHXUe
         EB8A==
X-Forwarded-Encrypted: i=1; AFNElJ90BZJrAjrrOxSrg/Js4/md5JAVIuKVQ8BIQ2TjpzYV9JP/Rb9FmntiHMI+RVdAkWXnI2/J2m3oldoE@vger.kernel.org
X-Gm-Message-State: AOJu0YykrJZ5+LXHH2nq7dYjGDqUsE/934wLi1RGU3Mr0c2voJRcHG9f
	dPCBjMKaEdYe+hVjrCF5UJiEON0aLupBro5LIT2/nAsNOt/nTD8MsD6qjqiHdXm9at6Do/y3AQE
	3EodUFxvrEH58I6a8D68KDHLU+tqY4tRlqMVFQQMAD7WIlda8+sYOpjNExTYjHBls09wZLw/ERO
	hDFbn9vHJEmq40ZA0UmAxoYsM8KFmDm2zZGzY92DtdE3Sv2hnN3ULwmeNgnHPwaQgk8STF1pEPz
	kwim7T5I9EwFQNT
X-Gm-Gg: Acq92OFRbSJe8ZWzV1E1WA1q/3IRyhh2pjxA6q8AknD6l2vCJi0aZTXYJQe7ptgtIN8
	DkL7TVXbYZFdTHynAijMZEVHVmcFUAuC3faHPTm+qvT2aoaFJlCzzFABLKt+KGjvcwCA3kYP7pT
	xTVHnOL73MUmRMwWYgVyYkcp4Uk6sEjSNQ664aR90oo+L4LUQLerF3qGCAe4zzgA18CDXai+7Dx
	r10h9kfW8sXOAhdR142nPNOFeKtdbFjFTvSrIPYutLaZSfemKM6x1H8oS7I4Z53v/Xj6ywkurIk
	a0fu9xL376bdBmBeSuDDDmHEK81/tIjTH1WfDo3lVbBH+ZvnsdDKIopubPEfi81VkzuiHCUU2h2
	ILqHJB4ehvo7jKu6q5IRH7FRdjMymG/gAkUczok9XD8YdOyiPxnuuhnS4yotU9dapTwIEOSH/oF
	uUj2/MRIbow2tGssixWEHp09OWvYewRB1yzsoxsqgzMdN13zimDmmSo7QnuzO0Ej/+1ZxHBA==
X-Received: by 2002:a05:7300:7255:b0:2ed:e12:3769 with SMTP id 5a478bee46e88-30804bbcbddmr2382993eec.31.1781191666673;
        Thu, 11 Jun 2026 08:27:46 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-30806e890c5sm121713eec.22.2026.06.11.08.27.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2026 08:27:46 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3969ddebd36so33278561fa.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 08:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781191664; x=1781796464; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xETqdZf6SLWXonSYRtymuS5zk3yWU2EdRj+5hCx/oAQ=;
        b=THP0TfX3uI0FrqDV7ANMgBwRFzGC+WxH3IdgWkYZJ0wmemXrx3EKao0TXMa9GtV5fO
         42Pt9coA1gaoKtcv7zh2zdXfPVY8TzUgJfU/RnFCVOJk0l45S1NorSxHOQDvRDWpCcl/
         vponUQJu+2+LqyUT8j1GOejfyPDyL8Ado1FSc=
X-Forwarded-Encrypted: i=1; AFNElJ8O2pG/TYhah36Zoy9aobvmJFBxGpqKDuIeTvGg9SeD5NzJ+/oukFz3ud5fwbJjq8LZk8wUzd46d+F7@vger.kernel.org
X-Received: by 2002:a05:651c:50a:b0:396:7f3c:2723 with SMTP id 38308e7fff4ca-3991a13edd8mr9023651fa.21.1781191664014;
        Thu, 11 Jun 2026 08:27:44 -0700 (PDT)
X-Received: by 2002:a05:651c:50a:b0:396:7f3c:2723 with SMTP id
 38308e7fff4ca-3991a13edd8mr9023491fa.21.1781191663442; Thu, 11 Jun 2026
 08:27:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
 <20260609121806.2121755-5-sumit.saxena@broadcom.com> <ef99d13c-426b-4c12-99ec-ac2b1bacc295@oracle.com>
In-Reply-To: <ef99d13c-426b-4c12-99ec-ac2b1bacc295@oracle.com>
From: Sumit Saxena <sumit.saxena@broadcom.com>
Date: Thu, 11 Jun 2026 20:57:09 +0530
X-Gm-Features: AVVi8CdIG7LZO2u_FaAlcYAYMzD3DqjO9GiXl9heSONr9TKGQdssytHoTWvHhoA
Message-ID: <CAL2rwxq85gD_Mnszof1XE1-5_nR1kzN=k6KY4JXBW4-4TE+Rnw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] scsi: use percpu counters for iostat counters in
 struct scsi_device
To: John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, 
	bvanassche@acm.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000007033f90653fc003a"

--0000000000007033f90653fc003a
Content-Type: multipart/alternative; boundary="00000000000060756b0653fc0081"

--00000000000060756b0653fc0081
Content-Type: text/plain; charset="UTF-8"

> I think that Bart originally suggested this idea, not me.
You're right. I will ensure Bart is credited for his suggestions in the
next revision.
>
>
https://lore.kernel.org/linux-scsi/20260420113846.1401374-4-sumit.saxena@broadcom.com/
>
> I just queried if we could use percpu_counter_init_many() with an array
> of counters, which you said you would check.
I missed handling this part, rest of the feedback is incorporated in this
patch.
I think we can use percpu_counter_init_many() in place of individual calls.
I will
accommodate it in the next revision.

Thanks,
Sumit

--00000000000060756b0653fc0081
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">&gt; I think that Bart originally suggested this idea, not=
 me.<br>You&#39;re right. I will ensure Bart is credited for his suggestion=
s in the next revision.<br>&gt;<br>&gt; <a href=3D"https://lore.kernel.org/=
linux-scsi/20260420113846.1401374-4-sumit.saxena@broadcom.com/">https://lor=
e.kernel.org/linux-scsi/20260420113846.1401374-4-sumit.saxena@broadcom.com/=
</a><br>&gt;<br>&gt; I just queried if we could use percpu_counter_init_man=
y() with an array<br>&gt; of counters, which you said you would check.<br>I=
 missed handling this part, rest of the feedback is incorporated in this pa=
tch.<br>I think we can use percpu_counter_init_many() in place of individua=
l calls. I will<div>accommodate it in the next revision.<br><br>Thanks,<br>=
Sumit<br><br></div></div>

--00000000000060756b0653fc0081--

--0000000000007033f90653fc003a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ifscJ8gSasrjdgcsGC9lCyPXLwfNEU5C3Mbnua8OK6sTBpf6mvY88HW/6AoKiSpfo5jxCZQOm4Zz
oJWD5ea7ThJ2XdDk1rRtGUkwFgN9GRNfOoiIwkkA7EdEfV0eQkVqNgkqUyBSABXcduul2sd4/JQO
SsVmTdSKid7L6yZsqk5b3Xj+GMJwPdRfeKP2SRoys0SVnajc9Di+9Jy7uGKxxtb562egZauDFX/0
o0UgYfZrbwWfzJDYMLKzlrOD0M8yGkD8BnyIiVECAwEAAaOCAd0wggHZMA4GA1UdDwEB/wQEAwIF
oDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3Nl
Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1Ud
IAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAy
hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNVHQ4EFgQURSmmYGaiq6dg3CEvXQGHEXJF
8xwwDQYJKoZIhvcNAQELBQADggIBAAl0pcCjujKdwmgtiGl2naEY5wB4G601Kuu3032tR7wmgZLg
k+lg9fhAA0boPsi1FE1Pwb93YDBGr/naS/oQ9JglSMeEVzeRvCqjFS4FpouBAFHB77c8w3ZwJ3+t
FSRJW9SbW0DADBn5t8GAjv2aSm5vDorqFe9MKOYEe50yYDQEUAsEt5QkrLTcEx9ntvVb25MxI8vM
bdfqna+/TyCmFmnGAz58jiw5DxLn++6wMmAk0SeUEuMrAlRIyhte6BBSBQ5cL1P+DWSqQbm/pwCq
NhySSLNtTi2dKJvvg6Ax9au913KiJj6uZfPlh6/0kaVKM5GhIABUcm3c6g2qD7ITJxB/p1kjYKLa
hVrtrjK7000lHKTPFr6MWB4Ggx7yKQ9yIlPMKKF/Lj8FabYCqeM5ovG7kaK8FYXug5vjNjN0nedR
X3P8o+8aL6WFIAAAKm2DqZh3252Gcken8v5c+f0SXWSJFvemfFNgrJiQFnFVrOE5v7qwvM/KvVCA
dYm4Ph9QYI0sm+Xitx8MkdOJtq5mcPWowGi8UiCgkOidv4ki1SA0wptfquUhbfS9b2M3XUHCEIUX
4ECvIjR3f+E0NbBIfPccWfYUaDLvo2qhLYS3KQbhKdXcJ83ha17mbVNZbDDo9upNcLO/oPyDbCNF
J6UpXZmis1wnCynhK4kQfwFhW7H+MYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0Eg
MjAyMwIMdI2Nfq/Vk8dzZMUnMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCDf+mQv
ltzzdzTt3CCrQhF3cMxSTjvEPmvh1sQ4xybN2TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjA2MTExNTI3NDRaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBIK8VISWeqyfhbgjmBKHZObrdx5ven9fDprl+RdbAv
Ghbi6pIa80xCZm2bipSsrYfIP6zwE+jlcNLV6zQ9u3/btlb1Bu+rJgOt+cVpenk6INFIpYchQqys
495HfhBj1y0FBlyucj38eojgpH7krIuyDTk9/NYBsvXJhv/4QB4dWYXKMtOQG9EEE/k7Y7ioLXRb
pOTRhv2acrv3j70FtP3KDTRX62rmVPhzlRLKfx1wDUO6fY1EyTfqJY8KXyeW5PQC0H9PZSJ0kZLg
tD4BkW/2Wkr+FKuIl8WszEjqzMGV+8z0y3PC/pFgjkmVcClerYPyNGbuVv+6r/PkICjZiWvc
--0000000000007033f90653fc003a--
