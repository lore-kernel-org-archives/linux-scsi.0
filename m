Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C110382F26
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 23:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781219692; cv=pass; b=rRpqz5ffalYlYGjh31a+x5s0XlIMS1ZGJpzIQbHucAaRuooxHhAVr18mRt00eq2RdKMtKiC3XBNn02puolzIzdOIPqed2/whp6enWv8GZX0q9Ezh+L/CXVhDvORlOQTaifVoivBosLOhIXguOVHlDpACqLHowz00OO/y3rYCZ6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781219692; c=relaxed/simple;
	bh=SDuNW4DOYbM/LU2KIbJc8jA8cg9SXoyNM0Pf8/UucQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MCUMSBrYCC5HWEWvbvy4TH2BZ+SsaiovFPdyuVOCFXMO+BVoaOXNO6293baz306ciW1VomWl96HNI4o3WVMmYDwlJ1K8PZt14xDE6L3hatiZXCh0mRFJ5WCmg2BR7Fx32fwDW5DCWBvMCDSfwb8SqCXTD4xflQAyV1SfY0DLdMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com; spf=pass smtp.mailfrom=arista.com; dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b=O5NHANJB; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="O5NHANJB"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec405a6ea5so60556766b.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 16:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781219689; cv=none;
        d=google.com; s=arc-20240605;
        b=bDnrxph6IgbLDfVZPudj6Kk7j/c3XKduS0TSI0RqOJwxoJ8fjQCHqtr+OcdNWSa3L6
         DKPVHynJWObyWCOqvDL4liEbwEYBXdudCYxXmBA4K2Ej5wPi0OYA2/yKrh2EE0gzByek
         /yGBG2p2yvNTehETBm6jwzd8fa+oqEYHEuxzBbsgyuq6CIjtq5swoPVycfCfMtoNugKm
         bDMeeLZ/Qic9y0aDg81RYsegrjlduJ5bE7pQfOiSGStQPjiuhMEpYYkMP1YJtzBebggt
         uoAxFqWGpFoMHEKPTPnI0VemMNhKDkxwCdYmCLbSCHMago9XN/9JeWZfghG7wmAnFxws
         AaSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0ZqakqEpgu30/29D6Zy6J4ujejKu003rEEGBzzqhukM=;
        fh=0RZWjFf0Xcq0koEx0cTvbby93A1iIZqK8eQQpP8YFSM=;
        b=WMLgntnHC2ljnOB6uIRlowzX2LpgR5Oq3sMQ6zJ17xg+KZ6yO/ib7hkH7AyImPY8/L
         eLXgZXGT+hv/6a8/DiNRmxQvyttNX9QEYtAgNJ3MkyHO4Mc/m3o7FdZrXyZ8jXoRAIYu
         8N/ZQ8aPsG5qUBrY+9QReDZn6JW6s7JnenCsOyZ4QZKAEqrIkymVfOUD6rvacNoUueXs
         wX63vypoCj+Sr9CF+zPfJPG24p4CWuL3BiDWMdFCdnfCEyNfick7SaBzVFPE7P+DX4Qm
         8NBNxE692aHiBrS1MDj+2VaXrjHm4G9ZKOffFD9HFy3B5uCe18BpAcGzVHTJykkkX5jp
         eH3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1781219689; x=1781824489; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZqakqEpgu30/29D6Zy6J4ujejKu003rEEGBzzqhukM=;
        b=O5NHANJBczf4Xr5DLfkg9xG7wCIu6wpyaLijj5+UJm1S7yZaN9yLKSS15W85P5E20n
         x0ec0pZU+qRlo05S+Z4snJO/ShEmRO8SRm4iZGJyQ3LnOR4zO8EIEbj5Jnh2NmZAkh9j
         f55efnqeYI4oVmT06n5a40jXcIF6OlJrhmRC4x81KE4Ql9y1kErUSUT4JZRC4L/nJyui
         z3vqvi/H6o82OVkaqBsywbn/XofN5afucy/Ara58by0lincAubxdlYijWivfIJH4nX3s
         lWRIYXgflONvHZMTbewEiZIXiL3TkuoFTi4kL7TcFDVpGAy9MZU9gR7DIOuG6mqcbTbH
         +2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781219689; x=1781824489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0ZqakqEpgu30/29D6Zy6J4ujejKu003rEEGBzzqhukM=;
        b=NUT1xqptDKjRUOHqPPvJT3o/QbdjuHNRmr7fdvT9Oz+kJ9t9mihOpd81ukT9irplVe
         Fw6Xm+Fik9tbzgI84Eu8XIsalfoMAxG6VBhD04P0DIUkzTe5iLvFrObojsZGp/c3L2C/
         9j5lPk02JWv8iF1fmlCE59Ii5LY/cSPTaB+AN80CaHtWU2Fa2KLV7Bp7cmeta9QcmKGt
         8IWBD0qfQvJJkKA15/OL+yEEldMe4Jqc7UNXG6bHhuPQ+TdMhy6TmhEzzFwI1Uxf8LqT
         WmNz+41PK+3MJfpbzNd0uzmj44yJZ1NqCI7j2cZfiNRR/rTmPTaMnpMSuWDecnw3SZsc
         0wlw==
X-Gm-Message-State: AOJu0Yw8vjW6WIM+l2jB0e9Yv9uI/fb+8n0BmZjQOvx7GVu4P2n5Bonl
	NkqO3AZsAnY+qUo7VOcA09ZgB9X8nz6ENWBc0wlDGDjPCA+ihoJV+SxjVb5krRfjlWfZHaE25fQ
	o32Zd7pSharKxxjI5zlEpGLwbowgVel+7e+xod0KI
X-Gm-Gg: Acq92OEFuh0x8VNPRpSD4T/12AEa7molJMke0PpECcGfgiAhR1wobg0j77gcg3HW4th
	MCb86OGYguy9btI++EVLxXM+1XUxDfJ4Ox4YAB8T0fwQ2C8eeH+/q8dmuIokCvz5fpo1XbUEjhZ
	U+HiZaRENani5cRC9khi8UcdVMfK2QFBTzmmNX82+Q+mGdyd8LyaRPMVrRIYY/bZlWrTPNap0aL
	kszPwfUHk4NcmFmgH+BzAiSZVH8KDRdknYq3L4PLiIYgivDHfVmC6HvCdMIIiM6mSPBTB2Lsk/C
	kWufdGW0JnJffFITxxZkRQaC2GpmG+c0OOv028I=
X-Received: by 2002:a17:906:8a56:b0:bec:18d5:ddee with SMTP id
 a640c23a62f3a-bfe2681acd0mr2816166b.4.1781219688682; Thu, 11 Jun 2026
 16:14:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926233642.268514-1-sushrut@arista.com>
In-Reply-To: <20250926233642.268514-1-sushrut@arista.com>
From: Sushrut Shirole <sushrut@arista.com>
Date: Thu, 11 Jun 2026 16:14:12 -0700
X-Gm-Features: AVVi8CeL-RuOvPM7DBWX_6oGkKh_Bfx0FEVWpwpGkL-kKi_Iemk-vQV3nVRRY5c
Message-ID: <CACW+J6c9Bjrzv2O1sEvYxwOGrhS8bnetvGMxU=DuHhxzTmt9AQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: sd: Add sd_stop_on_restart parameter for restart
 device shutdown
To: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This issue appears to have been addressed by commit 8fdfdb148816
("scsi: sd: Add manage_restart device attribute to scsi_disk"), merged
in November 2025.

8fdfdb148816 introduces a per-device sysfs attribute manage_restart
which allows stopping a disk on system restart, solving the same
problem this patch was targeting but with finer-grained per-device
control rather than a global module parameter.

Closing this patch as superseded.

Thanks,
Sushrut


On Fri, Sep 26, 2025 at 4:36=E2=80=AFPM sushrut <sushrut@arista.com> wrote:
>
> From: Sushrut Shirole <sushrut@arista.com>
>
> Currently, sd_shutdown() skips calling sd_start_stop_device() during
> system restart (SYSTEM_RESTART) to avoid delays during reboot, under
> the assumption that storage devices will maintain power and don't need
> to be explicitly stopped.
>
> However, this assumption doesn't hold for all system designs. Unlike
> traditional servers that can maintain storage power during restart,
> some enterprise network equipment, embedded systems, and specialized
> hardware use centralized power management that immediately cuts power
> to all components during restart. This can result in:
>
> - Filesystem corruption due to incomplete writes
> - SSD firmware corruption during metadata update operations,
>   potentially leading to unrecoverable device failure
> - Elevated SMART error counters (e.g., Unexpected_Power_Loss_Ct)
> - Potential data loss in systems without proper power-fail protection
>
> While the kernel provides manage_shutdown and manage_runtime_start_stop
> flags for fine-grained control in other scenarios, there's currently no
> mechanism to ensure proper device shutdown during restart for systems
> that require it.
>
> Add a module parameter 'sd_stop_on_restart' (default: false) to allow
> administrators to enable device stop operations during system restart.
> This maintains backward compatibility while providing the flexibility
> needed for diverse hardware configurations.
>
> The parameter follows established patterns in other SCSI drivers
> (e.g., smartpqi's disable_ctrl_shutdown) and provides a clean
> administrative interface via /sys/module/sd_mod/parameters/.
>
> Signed-off-by: Sushrut Shirole <sushrut@arista.com>
> ---
>  drivers/scsi/sd.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5b8668accf8e..d280b395026d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -116,6 +116,10 @@ static DEFINE_IDA(sd_index_ida);
>  static mempool_t *sd_page_pool;
>  static struct lock_class_key sd_bio_compl_lkclass;
>
> +static bool sd_stop_on_restart;
> +module_param(sd_stop_on_restart, bool, 0644);
> +MODULE_PARM_DESC(sd_stop_on_restart, "Issue STOP UNIT command on system =
restart (default: false)");
> +
>  static const char *sd_cache_types[] =3D {
>         "write through", "none", "write back",
>         "write back, no read (daft)"
> @@ -4172,6 +4176,9 @@ static void sd_shutdown(struct device *dev)
>
>         if ((system_state !=3D SYSTEM_RESTART &&
>              sdkp->device->manage_system_start_stop) ||
> +           (system_state =3D=3D SYSTEM_RESTART &&
> +            sdkp->device->manage_system_start_stop &&
> +            sd_stop_on_restart) ||
>             (system_state =3D=3D SYSTEM_POWER_OFF &&
>              sdkp->device->manage_shutdown) ||
>             (system_state =3D=3D SYSTEM_RUNNING &&
> --
> 2.51.0
>
