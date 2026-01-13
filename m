Received: from mail-dy1-f225.google.com (mail-dy1-f225.google.com [74.125.82.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CFF342CB1
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 18:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768328929; cv=none; b=t4T5SsF+V+yamgp3qF0qi9QwfBQZhDxuP3DVgbpvhq13q4bVKu4I/8UtEIq/WeGIbRvjdAAzpB1Aj2tXSRaStLC17Cmjwt49zanJWWYjbigxYiiZlKUVtfprJd9KZ7/jEg+BUJWV/m43a5+EZQxI+Fi2KLyWi3llayPgjftxrpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768328929; c=relaxed/simple;
	bh=55kcgtQ4zoEbhxZ2ckbIQfTPoABlz0OVGF0wP5Y/JAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eqdSCNruNq/QWF92QduhqIvwutCH9M1KVpVBCOzKMC4YQaaebFuhwxpc18/4C2eOKx35H6Z7rqrOELgyjJB1uboVmDIxVaqF5gFKV16+6D5PSsOQf6h0+uZApI8sZPYBHY4Bt1r/+7DB6MUr9ad1eTMyNyVsQYJ7iym93m3c/ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=We0GCTas; arc=none smtp.client-ip=74.125.82.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="We0GCTas"
Received: by mail-dy1-f225.google.com with SMTP id 5a478bee46e88-2ae57f34e22so8205260eec.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 10:28:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768328928; x=1768933728;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o9Sgx8fPsH1VF8BkbHPl+wj7A5WY+lxS46pDTpmKtzw=;
        b=X/y1O++aaO6gv3w7ZKOuWRScmOtRRxxFi5CSGlUBlJ8/AwPc1fc0sAidpoQH1wK28x
         2OJYu9ZJO6rW7LhwjVRy99ZMMpPaU7o4r3VDs4Pga8OcQ9DhQIhQ2RsmOjUcLGd/nYKV
         NImE1FS7cv1huN631DljoJhu1GEe/DszQeZ3+6OCdgKClKDNg3P0E3XjTJ3Hc/7jJLK7
         +qBKMdL9efq8w8QtHLX8CFo3i/lwKKJJ6dfaU5ee3dB70JViWsokW4Jne0sN+oUs1PV4
         4tv0Gzyqx+BwVKibqFeoYZhbOhlMsNzAI3Ib8AYOYzvqSq1oXCi7wSiKT+eJklbbyh3N
         +Bpg==
X-Gm-Message-State: AOJu0Yx7OFTMbc8W3QeMCT4uO/ewck8f4CVTjElbZFSLKLYsY2Eu86ed
	bSGcMEMXJ0p4WcBYl4ufjzlN7wGzsQD0NVixRnUrryof4y/3zicjDp1rX7suAZxZVHx7l32oS6U
	Aw1d6+/0zhr62mZxT/+CjEjN0SruF6OrkqCW1ZWaLB/wLqO6BRZtr+BDq2G9gwoewlbhkcOgJ/J
	oELVAMS3EEwZLhq59jFhQ4Ikr/d/uAxjdjuzaDUFUSEDMPA4Rgwpum/kg34bnONiZjHOtfTPhZA
	h0JVjdemD3Ks666
X-Gm-Gg: AY/fxX7dZABOvAQ94Zk00pJvsNv5JwepzhD8yv/jQEJ1ERLuPmDYeOAfEH+1tiI541A
	dbeHhFPMmEJ/QxEOcsue15E6qK9NRb9AKjCApEd443Bba2gD2qDzKV08hB+9j2iFBmCeNjdcdqX
	MBWX+hhQmNq0ayo9V+rJNVLgSMkkCuNzk/xa2GiHf+w/IOPoci6Aw6YW07mGitEpY2KhDpvC3Nn
	f5NuPfMH23qDx8t70BAnJx3tizfBhMHtEq68NnV5ylwvs9nIpOpCdgcX5ZVSpH9uR0yJfzXk9nA
	SIETn7kThfRKNpt1+LMX7kAaeflBwZf0pyv2gzW1vfluQzDRwX9KAnO4pVjqjd6OKGNwWFI/J4D
	5/ksibQwwBv0/Gk+4z1ddXQ3kZthn8Uh0QPUfUIarmiCEAOxxTd6ZHk/5gTbaC1orWD2S
X-Google-Smtp-Source: AGHT+IFfpE7cSFhuCvbaEHc/y+wq5hIZr4tSBiKwURZhcD69kOKTP15PxFYZ6wu1ywWHsYMvysyrtDQxmKbn
X-Received: by 2002:a05:7301:3f99:b0:2a4:3592:cf75 with SMTP id 5a478bee46e88-2b17d2959a3mr18200648eec.25.1768328927475;
        Tue, 13 Jan 2026 10:28:47 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2b1706acf81sm2931056eec.6.2026.01.13.10.28.46
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jan 2026 10:28:47 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b871328f6caso278206066b.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 10:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768328925; x=1768933725; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o9Sgx8fPsH1VF8BkbHPl+wj7A5WY+lxS46pDTpmKtzw=;
        b=We0GCTaskQdbck1Dj6UmuSuSqCag0r18iV/+hhU1p45nMsbyKaxMLOmWUf1x1ijpV3
         Q/YtxELJ8YtZNm9x6TsKIDG2cqNXm+iUwlnLyEvnLR4OxrG9YvjkSh2eT0mRGXWidEdI
         l6gP6VqqB2DjfaJcSiVyUjeKa9kUsPG+4V84s=
X-Received: by 2002:a17:907:720b:b0:b87:2f29:206f with SMTP id a640c23a62f3a-b8760fe1034mr5408266b.17.1768328925256;
        Tue, 13 Jan 2026 10:28:45 -0800 (PST)
X-Received: by 2002:a17:907:720b:b0:b87:2f29:206f with SMTP id
 a640c23a62f3a-b8760fe1034mr5406066b.17.1768328924773; Tue, 13 Jan 2026
 10:28:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
 <20260112081037.74376-7-ranjan.kumar@broadcom.com> <c6b01448-e314-4997-91fb-5d1937459ed0@kernel.org>
In-Reply-To: <c6b01448-e314-4997-91fb-5d1937459ed0@kernel.org>
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
Date: Tue, 13 Jan 2026 23:58:30 +0530
X-Gm-Features: AZwV_QgTchMr-8K07r4Ci6lHseKwoIR-und53lwW0bhVrnm7tNCzrcNbXvvTkes
Message-ID: <CAMFBP8P_vRfzAXU_MT+1+ZuzmP32UgpC_NXnCqEpjG8DGtqOYw@mail.gmail.com>
Subject: Re: [PATCH v1 6/7] mpi3mr: Record and report controller firmware faults
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com, 
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com, 
	salomondush@google.com
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000007510a906484929ca"

--0000000000007510a906484929ca
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Damien,

On Mon, Jan 12, 2026 at 7:55=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> On 1/12/26 09:10, Ranjan Kumar wrote:
> > +static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc)
> > +{
> > +     struct kobj_uevent_env *env;
> > +
> > +     env =3D kzalloc(sizeof(*env), GFP_KERNEL);
> > +     if (!env)
> > +             return;
> > +
> > +     if (add_uevent_var(env, "DRIVER=3D%s", mrioc->driver_name))
> > +             return;
>
> All the returns in this function are leaking env...
>
> > +     if (add_uevent_var(env, "IOC_ID=3D%u", mrioc->id))
> > +             return;
> > +     if (add_uevent_var(env, "FAULT_CODE=3D0x%08x", mrioc->saved_fault=
_code))
> > +             return;
> > +     if (add_uevent_var(env, "FAULT_INFO0=3D0x%08x",
> > +          mrioc->saved_fault_info[0]))
> > +             return;
> > +     if (add_uevent_var(env, "FAULT_INFO1=3D0x%08x",
> > +          mrioc->saved_fault_info[1]))
> > +             return;
> > +     if (add_uevent_var(env, "FAULT_INFO2=3D0x%08x",
> > +         mrioc->saved_fault_info[2]))
> > +             return;
> > +
> > +     kobject_uevent_env(&mrioc->shost->shost_gendev.kobj,
> > +         KOBJ_CHANGE, env->envp);
>
> Please align the arguments after the "(".
>
> > +     kfree(env);
> > +}
>
[Ranjan]: I will resend v2 by fixing the leak and alignment.
>
> --
> Damien Le Moal
> Western Digital Research

--0000000000007510a906484929ca
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
zZSItX49nLoa4TBbzuCzoINrv59QeSCVlVdAYussUS3840ZjvcYHSQx3tqYcBN+an07lDASmGEM5
7PEXJPVInjl/Fva3ksL3r8anR4PWc3Xz5jLD8Xg6BU4zmIcR/t1GlqWuz8uTWmQtm40C9m91Q9a+
2alIIV6BTs8IG2ELtt4EfcVvi5af+Hu878sGeBtMx6Z9ljoKl3MfvDdtUNO4bkJ97a7PXy/CKxiy
TApQj4qg9SKQcsH0xzQan67XeXjkvk4frNDhRikCAwEAAaOCAd0wggHZMA4GA1UdDwEB/wQEAwIF
oDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3Nl
Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1Ud
IAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAy
hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNVHQ4EFgQUfLdm66N7GfDsoL8cYp3s4YdO
isMwDQYJKoZIhvcNAQELBQADggIBAA/lnAxDb9jbesclnBxWIKUSxAMIrq4XKO5WKHUYIOOzd2sL
o59fH9AWg1AfVONfWIUNdWDrmNNLs0+drSKaZbGx2RWMbaL9ubo7+BTQV33ZRBxnnkmc9QszlOo5
m6FB9uPOGB9LvJMCkJ8S7hNc9G/p7dB79s1IKc8JGEDIrsgX3s4xSCJA20WdePHY5rLh5ySwXyI2
3sVTUC+oK0HJFRo+TpdMMtdpOetWzIkUbGceiOA2ur8372+0KOmvlIHA/jEnW3BRfmB2vmdk+raY
C/xbXY9JEfS6D881+X/90w+cCQ7nuA1OELebS1RbSdXT6YkRDPWYA/DPFhOYCAiMwVAPRaAH1AQc
8J8yTDigwRUCq4qKCYU9YnqQh3YZRbUYnW+i3+rAO2SUbKl0VM5y0tq+GOGLC7w+v6yGossZmy+6
3w72qp/Colr4r5ZaROb+L2FXqk4tL/HfkRhliyPPPNIjre2mIkvFuShk5A5FcvQYCzDtejAz9JHq
ZVJ1ZD+auQDbIUxT+Dn9bI5XkQnWJ9KrlcORtztdYTDafN8VQuweS3JY0X/VCNBNZkiYXd7fzOza
hvkw/S+v8cIfiakLKBREtiBHqWLdVf5CNDVYpd17yz0LGz0TKARbfuK/EiKflA10pnnnOB33Ru9D
WPp9aHW3szGYr3+H9AHS6IDwkIxyMYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0Eg
MjAyMwIMDcMaKRu9LrbAxERoMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCCmtovB
DfpjT6tvUmfNgjVfbq0CMbl0TzbGXrhGc7+gTzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjAxMTMxODI4NDVaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCT4UM7QaCk5cWBECS5g4WAk6fkhby5IRuqFwuD4kZz
DEsin4Ti7b6Cu2bNAeyXaRon8EPDb+ejMMX7Uh+O/c8QkfL6O88BEgv5a4QVOS/AaxA79ebW6R6/
804J+gfuMtJ9UKm50TMuf2nGDkwpCAk1PTLV05G49RNQl0Yd8TZpB7u4NsEbKafkyFp1/dSYvFMD
Txwi67VP+mBmxkstdSPRGuiHqq/jdZ0TO5TvG8olMXXmMfboPLRr0R2lOZn+GFQG6Z8VYwbf2+Ns
MwaIKyoCkCP0ibCNHu1VofEsXFWBGFbjclrjIgyfjCyGci7hOAHK0CCIUb5QpACRvbqkHvoW
--0000000000007510a906484929ca--
