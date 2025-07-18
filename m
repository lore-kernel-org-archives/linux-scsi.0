Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0580E2DECC4
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 15:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752853426; cv=none; b=efov565h0qoRLCOn4xarxr8DPXNuxPM02kvQq+R8uunogjwldFJJZNeWkmhsggorz1olsF7U4V0hRWQal7cUOpC/YvQMcXIrqB/4RUJXD5gYMAHRkDsHLfKMg1Ek5ip7SQH6urnrBNgx9y1tAED829LSjTGYTziq4DSdQ1jZ4nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752853426; c=relaxed/simple;
	bh=/7P3+9ThTCQUqSpGlumRCnB6up4rq6Yn17fGe17APfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dlJRwmXvKpccKW4ZUiqvGDtGP+VaV2HkF1iyXJIHsKdHTcDzivF1EW+/d5Phu/sm8X55BEtOlilLB3dB9VtmSeVC+TN5ELlf//KOl3I18eP1RRpj4oJJu9d+el8kXlIHX9iDrMj0RGARy8ClNYEfkSEEh33TZBbY0Qv5P7Yds5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=alo/7Vh4; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="alo/7Vh4"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-558fa0b2cc8so1745767e87.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 08:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1752853421; x=1753458221; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+fJAbDxsitEVACTPNYXh5v/vw8NCsN4YRGq9uGMFNAk=;
        b=alo/7Vh4kBt+FSeIbHqSzj9WLXYEzOljjnfJo87jzr9x9m7+cjn3jTkx7Wac6sDYkT
         LeJgkBPK2eRneXsTWfOfbftiXGF5wmNzypz/3dnwzX9kE6/GzY7fLGwMcKr7v0ewj/LC
         vfC/JO+lSnyL++TcFbAPH3rM++FZaVpEmLYZ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752853421; x=1753458221;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+fJAbDxsitEVACTPNYXh5v/vw8NCsN4YRGq9uGMFNAk=;
        b=RK6v/Ws/FwCBnuS+UyyzC0mQ1uTHN9J+kvGQAgn35gmj56DvjGr0DCSxdLr0nH9+z7
         0daHkzEIKXz/9uwzxdXI6V4+Pg6Je8UuFKu0GkYhOSJB3rZlc36bpCsEYFNkew9osSaZ
         +GpdmhVEoT4nXpR+g21xlLo6oozMlkVEaGsqstT3UrMPByKWUXZz2vDNmC5Fw39Pyhv9
         Toag6f6fwdENtC0MHYrOq1oT3v9eRlBYkVd2+Rh/2WVX8Ji5d2KvvJQX8YzSAYCLfqnK
         I84iRUXWfdLu6MTOa1658S9i+3+/5WrP8whNXQ8Ynd6zHzUUdcdbNKm5Fo7dsGXE3sJy
         YWcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyVRvKmm2c8lg7qHFCd4q9TJwIFoqVC6+kBxW9/0/IWm5ulfui5/TnjeXukSeMXdG1T8vGZxsopNXX@vger.kernel.org
X-Gm-Message-State: AOJu0YzJDghCx4wrJmxoRPadqrViIqGWJ56JsWuXOSxRi8r/qBvBFOV/
	491csjbNIV58YI3pyoWHY9OjVtjcPJ8U38p3ZRAv+JFZbfjzxrIM9YRW+ZCljt0lAvjDZGKNf47
	m/hGK/So69J5RCoVWFXf8ErH+dR/rB3vS3330V4rTFC3anNI0t824
X-Gm-Gg: ASbGncv+0OrxjumUT+WSVZbhKv8/AYnDX4bUsRL4JV+YY3ZjlpVB50UhrR1T2doGq8f
	8mcDumkI7cXRAKYYXLAbQoWGr37j/X/4k5TrbbjVjJO68da/Bf3Xuh5eaN8A+emoH2/pZf1AFuX
	SOnoslqAu9mHV2VcCiQjRdThS6BfYK8L0yl3BzF6Rmj498YDtKAkLb0Uqa+dLvUSaA6BmPVqa3V
	d2NHig=
X-Google-Smtp-Source: AGHT+IHuOgFMY2TZUhDndmyZAaY+FIpinJdCwehxGuKF/DE97OGi8th6y+FAu9LbmquoJ9bjHgHxHGmQhYhsYDpWZDo=
X-Received: by 2002:a05:6512:6ca:b0:553:297b:3d4e with SMTP id
 2adb3069b0e04-55a23f9d33fmr3029332e87.52.1752853420970; Fri, 18 Jul 2025
 08:43:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <30f8ea8d-79c4-4e5c-b354-51ad8146a61c@acm.org> <20250717194025.3218107-1-salomondush@google.com>
In-Reply-To: <20250717194025.3218107-1-salomondush@google.com>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Fri, 18 Jul 2025 09:43:23 -0600
X-Gm-Features: Ac12FXy-sTcVsKKpjOxr1yC-VpNPTOXl0Qp8qEdzlFX7gJL9eKzfRJGnc7Y9eyQ
Message-ID: <CAFdVvOx-xegmdGO8xgwpE3i0BvgXD0C1jKjNWKNjTFuifWmuxg@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: mpi3mr: Emit uevent on controller diagnostic fault
To: Salomon Dushimirimana <salomondush@google.com>
Cc: bvanassche@acm.org, James.Bottomley@hansenpartnership.com, 
	kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	mpi3mr-linuxdrv.pdl@broadcom.com, sreekanth.reddy@broadcom.com, 
	sumit.saxena@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000088f7f4063a35fd6d"

--00000000000088f7f4063a35fd6d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2025 at 1:40=E2=80=AFPM Salomon Dushimirimana
<salomondush@google.com> wrote:
>
> Introduces a uevent mechanism to notify userspace when the controller
> undergoes a reset due to a diagnostic fault. A new function,
> mpi3mr_fault_event_emit(), is added and called from the reset path. This
> function filters for a diagnostic fault type
> (MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT) and generates a uevent
> containing details about the event:
>
> - DRIVER: mpi3mr in this case
> - HBA_NUM: scsi host id
> - EVENT_TYPE: indicates fatal error
> - RESET_TYPE: type of reset that has occurred
> - RESET_REASON: specific reason for the reset
>
> This will allow userspace tools to subscribe to these events and take
> appropriate action.
What is the reason for userpace tools to know these events and what
user space tools we are talking about here?  Also, on what basis it is
decided only diag fault reset is considered as FATAL.  I would prefer
to understand the actual requirement before ACKing this patch.  If we
need this kind of user space notification then it would be better to
make it generic and let the notification sent for all firmware fault
codes.

>
> Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
> ---
> Changes in v2:
> - Addressed feedback from Bart regarding use of __free(kfree) and more
>
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 37 +++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 1d7901a8f0e40..a050c4535ad82 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1623,6 +1623,42 @@ static inline void mpi3mr_set_diagsave(struct mpi3=
mr_ioc *mrioc)
>         writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
>  }
>
> +/**
> + * mpi3mr_fault_uevent_emit - Emit uevent for a controller diagnostic fa=
ult
> + * @mrioc: Pointer to the mpi3mr_ioc structure for the controller instan=
ce
> + * @reset_type: The type of reset that has occurred
> + * @reset_reason: The specific reason code for the reset
> + *
> + * This function is invoked when the controller undergoes a reset. It sp=
ecifically
> + * filters for MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT and ignores =
other
> + * reset types, such as soft resets.
> + */
> +static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc, u16 reset=
_type,
> +       u16 reset_reason)
> +{
> +       struct kobj_uevent_env *env __free(kfree);
> +
> +       if (reset_type !=3D MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT)
> +               return;
> +
> +       env =3D kzalloc(sizeof(*env), GFP_KERNEL);
> +       if (!env)
> +               return;
> +
> +       if (add_uevent_var(env, "DRIVER=3D%s", mrioc->driver_name))
> +               return;
> +       if (add_uevent_var(env, "HBA_NUM=3D%u", mrioc->id))
> +               return;
> +       if (add_uevent_var(env, "EVENT_TYPE=3DFATAL_ERROR"))
> +               return;
> +       if (add_uevent_var(env, "RESET_TYPE=3D%s", mpi3mr_reset_type_name=
(reset_type)))
> +               return;
> +       if (add_uevent_var(env, "RESET_REASON=3D%s", mpi3mr_reset_rc_name=
(reset_reason)))
> +               return;
> +
> +       kobject_uevent_env(&mrioc->shost->shost_gendev.kobj, KOBJ_CHANGE,=
 env->envp);
> +}
> +
>  /**
>   * mpi3mr_issue_reset - Issue reset to the controller
>   * @mrioc: Adapter reference
> @@ -1741,6 +1777,7 @@ static int mpi3mr_issue_reset(struct mpi3mr_ioc *mr=
ioc, u16 reset_type,
>             ioc_config);
>         if (retval)
>                 mrioc->unrecoverable =3D 1;
> +       mpi3mr_fault_uevent_emit(mrioc, reset_type, reset_reason);
>         return retval;
>  }
>
> --
> 2.50.0.727.gbf7dc18ff4-goog
>

--00000000000088f7f4063a35fd6d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
v82E+npLwqC8bSHh1m6BJewfpawx72uKM9aFs6SVpLPtN6a5369OCwVeEwkk2FeFU9tZXWBnI4Wu
d1Q4a3vhOColD6PdTWv74Ez2I3ahCkmpeEQ1YMt61TUH3W8NUJJeYN2xkR6OGsA1AgMBAAGjggHc
MIIB2DAOBgNVHQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRw
Oi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcnQwQQYIKwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJz
b25hbHNpZ24yY2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZo
dHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRC
MEAwPqA8oDqGOGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3JsMCYGA1UdEQQfMB2BG3NhdGh5YS5wcmFrYXNoQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
VyBc/F5XGkYNCP9Rb96mru8lU4AwDQYJKoZIhvcNAQELBQADggEBACiysbqj0ggjcc9uzOpBkt1Q
nGtvHhd9pbNmshJRUoNL11pQEzupSsUkDoAa6hPrOaJVobIO+yC84D4GXQc13Jk0QZQhRJJRYLwk
vdq704JPh4ULIwofTWqwsiZ1OvINzX9h9KEw/+h+Mc3YUCO7tvKBGLJTUaUhrjxyjLQdEK1Xp/8B
kYd5quZssxYPJ3nl37Moy/U9ZM2F0Ivv4U3wyP5y5cdmBUBAGOd94rH60fVDVogEo5F9gXrZhT/4
jKzCG3LclOOzLinCkK2J5GYngIUHSmnqk909QPG6jkx5RJWwkpTzm+AAVbJ9a+1F/8iR3FiDddEK
8wQJuWG84jqd/9wxggJgMIICXAIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIFgDt0UP
54zD0WzEbxit0IE6IMKg3GJ1MzCMPeS7+3ZaMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI1MDcxODE1NDM0MVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAB7yTa+YOBqAgP8rsXG5xw/dKvpyOrWb3o/bLAAWpbpq
k5U9fqGZXrxRXzYIXnf78HvtrrXfMNTld0vpvzNKDUTSFbYt5G7hkKaa6r4s/kLsyqN7R14eUiLM
CadYAUEqimPHMYX7CK2ugBqwvVa8G1q0j8gTQ1nyfUdHasI+tj97d4ETYXf7QxnuK1RvyQfWVKA0
7OiNeJ57nRy3NhZPRdQT1afRytgE0sTuMHyezyA2y+ykZNgAU/kY0jyg1fldv+fpr89o5087AtNp
xoJdPeO4S42LMLK3ctxwflgqgBAoEANiNO5GXaZCuNz4nS+jInSoP9Z4lz1jwBUN4Yncjp8=
--00000000000088f7f4063a35fd6d--
