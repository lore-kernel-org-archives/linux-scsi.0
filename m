Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9C02EEE74
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 07:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781681577; cv=none; b=tyJ6ifjVYxVAefvIs0AUn65qSG1GoxOWCelccYLnvgOEsNc60WOUp40oqoOf24MGsRi0nh+GtMPWIyhoLE2szl0buHHYrvwhO+lsw4tqEgHSyMVCsGTCZqzcPUjPC9eAve6ZRiigShOI1nvZaNpGLoKjV2Ad27FXqfPKwe2RPI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781681577; c=relaxed/simple;
	bh=p4RkDgQFgCxBa7/7//8SVHL4hpSdn9uleE3VRGddbKs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mq4kB6qUpGFCrERTI1bWkJthhd64V1hEBadPLPDq8aCqgltL0Nosag6Eym9Oxn+tSrM/3dC5qc91IouJY99TN5euN1PGASLpvUynv6A73fH+tALeCzwxh8YJasnA5RnmPpDCotdeqtiEsjRRBrFUDZFk+wJdUdzHRrlDz7NggK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cBRnz9H6; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cBRnz9H6"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-36babe2c4bdso3366547a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 00:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781681575; x=1782286375;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4RkDgQFgCxBa7/7//8SVHL4hpSdn9uleE3VRGddbKs=;
        b=EKcTJGKiaqS1eceKI9KvmTmmoDFZp8yFJEtEdDX7zreuW75K339U7le0V3G/E62ymM
         cJS7Y7nePVySNfTKFzHOn/i24liQxMa4MQ5fICuk7OzNAll7o5FR84Ot7ufiofcymXfc
         mcGx8/jVs0GSWtCKD+AdLByzlo7yzbBXtAUVfDGtT1FkIYXKxGzAIDNdaLbVLA90CDs1
         mHm/ybSMfrewvXetTQ0zUj9wgxCWSm6Z38loTy2qBQvtmyOTb31qoM9YgRl5wbmmmFAd
         8XEN0mLLhqKuFNMV/0WBcdN6HmBpjKDhyM4cYRgW094Ex6frNtIRgYfG4V+SO9fQhYy/
         /TGQ==
X-Forwarded-Encrypted: i=1; AFNElJ83ES61ewka8GJXS901vY6hFbx2dp6vY8KV8nvwin0EyIKFZp7zS/cO05IhxXtmrDxjB/sn/78AQ7qW@vger.kernel.org
X-Gm-Message-State: AOJu0YyVCqL5asgZHUJZ8fCLTpc8isz6aRmq1eel/NSC8S5QL7YjiGuQ
	1l0uaS70aDKiGWnu3cuTbJxe/MHnMdH/2g7k0fgcFxqEPITwyq8f2fb0rECstQrhRVSTRcbMvZE
	sIAXx83oE7DbVGfJGnaYGioMMAvQUkc/bReLB7MLYe5oAHQP/YcMx8qe+QO7wjK68nvBEsp0jCJ
	As7yjdiqtAaXANv/7hs77wHNXxvAl5mC7/1nPO17vpKPq4qwl8HbQRkjBgxft9bW8r59kCsm8PH
	ukt1VVGO6isrFMD
X-Gm-Gg: AfdE7cns6mAkg+Gqu6J9moQqC8WKH63bySeuO8POTDGev6TfsRxUhXdMDSBjSBoYgO7
	ozCE//ytUgTP6yI8Vp9NHYabISME/Ab40jhmPZ+964Aoe1tunPRl5X63/Jsr/1U+uqayOL+YvzI
	g+o6BTkAUutPUXBUJErnoOQEpZNBke2yqO+dHbU1J1SNk5r+DjODOKnuvdSec/wEmaRLRhsGUxz
	851IlLn+x7HsLm2OEn6tdfN6uDvu+fjhT3X1WX5JrSUTYznJWInsxiEzqV+CfiqxLIYHnSK2/zg
	ORlmGTG9Pg+reJCzJZGAdu15zfrWr9cBSfIfMmnNfdeOj7PvLJmfi/GeAQE3eD1MM2NJhimjOvO
	/2NpgewItH3rIHw+UZrcRhxLOQbaXx3yScvt7niLICBmpzijrAxy51SithsGdW/Oe9t6o5gJy37
	4BMeRDkuvhec+pnIj5Sg7QWc/VN/PquovfYQ/h07l8Op7ESmjB
X-Received: by 2002:a17:90b:5890:b0:36b:71e6:3de3 with SMTP id 98e67ed59e1d1-37c92ea967emr2727821a91.3.1781681575302;
        Wed, 17 Jun 2026 00:32:55 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-37c521fb190sm478404a91.6.2026.06.17.00.32.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jun 2026 00:32:55 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5aa5bff0253so2904076e87.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 00:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781681573; x=1782286373; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p4RkDgQFgCxBa7/7//8SVHL4hpSdn9uleE3VRGddbKs=;
        b=cBRnz9H6FwBOcmRhXqYlgJU2hjBWNnovm3xWvyB/FlKxovZd1kk8It/2cBmF8Z6lsv
         QJb9HgELH0bqZ3zEXDXxkgV8aWMAU141b1U3wiKXrKxm8aPPghlP+9GVuGSbr7lHZ1QY
         h/mrGpJYpINQdRoQhEI1FkH0Id6AR3X59OXxQ=
X-Forwarded-Encrypted: i=1; AFNElJ8+tTpodzY6yJ8bklPpDpVTNzVjnAmsNyWkOb4rorSyR4vT+jMQyowKekgumXJxULwnpnosBInXOX2v@vger.kernel.org
X-Received: by 2002:a05:6512:3a92:b0:5a8:86a8:2e09 with SMTP id 2adb3069b0e04-5ad46fbc807mr686835e87.7.1781681572955;
        Wed, 17 Jun 2026 00:32:52 -0700 (PDT)
X-Received: by 2002:a05:6512:3a92:b0:5a8:86a8:2e09 with SMTP id
 2adb3069b0e04-5ad46fbc807mr686816e87.7.1781681572321; Wed, 17 Jun 2026
 00:32:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
 <20260609121806.2121755-4-sumit.saxena@broadcom.com> <93a82831-608d-4462-a019-26b3adc7089c@suse.de>
In-Reply-To: <93a82831-608d-4462-a019-26b3adc7089c@suse.de>
From: Sumit Saxena <sumit.saxena@broadcom.com>
Date: Wed, 17 Jun 2026 13:02:33 +0530
X-Gm-Features: AVVi8CeV9cCaIlYv6pzM4uN1dthXF9_k7_n2grggNDmHz6dv9lgdHQpICMKOJ0A
Message-ID: <CAL2rwxrDPL0RgwvPHzGz6MorMGMQc0gZuOQpU_8-dgFEKetnOA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] block: drop shared-tag fairness throttling
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000047259806546e11bf"

--00000000000047259806546e11bf
Content-Type: multipart/alternative; boundary="00000000000038b18d06546e116a"

--00000000000038b18d06546e116a
Content-Type: text/plain; charset="UTF-8"

> What tests did you perform?
> I'm pretty sure you see an improvement when having just a few drives,
> but what about having a lot of them (ie tens of drives)?
> The whole point of this was to increase fairness between drives, so
> of course removing it will make an individual drive going faster ...

Initially, we ran tests with 8 drives and saw positive results. However, we
completed
tests with 16 drives and are seeing performance drops at higher iodepths
(>=128) with this patch.
This appears to be due to the removal of the per-queue throttle
(hctx_may_queue).
We are currently running additional tests to better understand this
behavior. I will provide an update
once I have more meaningful data.

Thanks,
Sumit

--00000000000038b18d06546e116a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br>&gt; What tests did you perform?<br>&gt; I&#39;m p=
retty sure you see an improvement when having just a few drives,<br>&gt; bu=
t what about having a lot of them (ie tens of drives)?<br>&gt; The whole po=
int of this was to increase fairness between drives, so<br>&gt; of course r=
emoving it will make an individual drive going faster ...<br><div><span sty=
le=3D"font-family:arial,sans-serif;color:rgb(31,31,31);letter-spacing:0.2px=
;background-color:transparent"><br></span></div><div><span style=3D"font-fa=
mily:arial,sans-serif;color:rgb(31,31,31);letter-spacing:0.2px;background-c=
olor:transparent">Initially, we ran tests with 8 drives and saw positive re=
sults. However, we completed</span></div><div><div style=3D"color:rgb(31,31=
,31);letter-spacing:0.2px"><font face=3D"arial, sans-serif">tests with 16 d=
rives and are seeing performance drops at higher iodepths (&gt;=3D128) with=
 this patch.</font></div><div style=3D"color:rgb(31,31,31);letter-spacing:0=
.2px"><font face=3D"arial, sans-serif">This appears to be due to the remova=
l of the per-queue throttle (hctx_may_queue).</font></div><div style=3D"col=
or:rgb(31,31,31);letter-spacing:0.2px"><span style=3D"letter-spacing:0.2px;=
background-color:transparent"><font face=3D"arial, sans-serif">We are curre=
ntly running additional tests to better understand this behavior. I will pr=
ovide an update</font></span></div><div style=3D"color:rgb(31,31,31);letter=
-spacing:0.2px"><span style=3D"letter-spacing:0.2px;background-color:transp=
arent"><font face=3D"arial, sans-serif">once I have more meaningful data.</=
font></span></div></div><div style=3D"color:rgb(31,31,31);letter-spacing:0.=
2px"><span style=3D"letter-spacing:0.2px;background-color:transparent"><fon=
t face=3D"arial, sans-serif"><br></font></span></div><div style=3D"color:rg=
b(31,31,31);letter-spacing:0.2px"><span style=3D"letter-spacing:0.2px;backg=
round-color:transparent"><font face=3D"arial, sans-serif">Thanks,</font></s=
pan></div><div style=3D"color:rgb(31,31,31);letter-spacing:0.2px"><span sty=
le=3D"letter-spacing:0.2px;background-color:transparent"><font face=3D"aria=
l, sans-serif">Sumit</font></span></div></div>

--00000000000038b18d06546e116a--

--00000000000047259806546e11bf
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
MjAyMwIMdI2Nfq/Vk8dzZMUnMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCCfIqFQ
eS+UyCGAl8Xch0qbWKF/5r+//3j35HiUmbVKgjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjA2MTcwNzMyNTNaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDQ0DVlwM8/RvFFeW2+ie3AO83RpwDSPYCqqkImahAA
sp8IytQcKhqVKBsIDgO9YkcNdp9XPqak75PPSIvba4X8PyxyU10Qjjofa7qpT5EQHZikabcTSkoV
YQnWbRD6BUtRoKT4U6qTLPiQ/Q2++KFBrmcGwQnGR4d6VhN7Zk5y0nJYEETyOm73VIRpySzYHpTt
sALv2cpbadT2iGlPkgDuGgWyXX/qDUevdirke2LQh0FXRJo0jxi20J9QA7lLrnXItEWIcCP8cdwN
vbZLMTPM6x6BX/CHj3iD91jAf1jk1RqFwIoN9xWYgvFuW/ZWHxZg1P1zAtttcDlViyJYSmsG
--00000000000047259806546e11bf--
