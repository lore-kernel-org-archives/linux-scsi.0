Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37BD2989B4
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753112759; cv=none; b=UEdi1czGDw0BO5Ael3FpTL6khcaB1q83nSD/P8SHqaOgbjPyRlu6u9SAIzfwL7cK7eT0MzJCBfPmE5utDARXFjLf++d2yYqjo7slHvQI96t5P2PoiCbM8vrhDYxmR4ZX2IZg7zUbTr8WELVcpseoOV44IiRl6u8/ss8XBnxvvCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753112759; c=relaxed/simple;
	bh=DrqkWgE6vdL7Ro/82IEbtRTwhAxnrWH9r0F2MMCpxDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m0LOqtfwCWq7S3Pa2sN4OiVtwFnPJDUhlfX2O5RzrId6EHAD89hAjiUfqzAp7fVie0HFKQbVvFO+8Hc3odO6IRaxtJf0yw4bbLacIfb3kOZqTCthJsEKBAZWz9Ura83Dh0OKbdjZ2ZHjtbDJPmcJbbFPz2hH9tfVLmJIzDl5Los=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AOwvpfqQ; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AOwvpfqQ"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-32b595891d2so35041151fa.2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 08:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1753112756; x=1753717556; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VoN/3GepvSphOmE6rZEBn7W5mUFTf5RKCbdpAe5XiSQ=;
        b=AOwvpfqQ7s5VsHDBMmwIqv5HyKOm5RI2bCmquh4keHIK4aS2fxZ2C4i5gK/XO6DXTX
         VcjC4fMLRJZl+hK9YvfVKwMNZLzSIkB6T8b2As94kjFrpSDFfCoSqfp/W7NFAvN0cZWK
         go3we1ad1VJJFseA60Q18kkVCKV95C1YCXd/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753112756; x=1753717556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VoN/3GepvSphOmE6rZEBn7W5mUFTf5RKCbdpAe5XiSQ=;
        b=RUoCl7jyOOcDAQCsCO1PKTwGWkwuB3jzZdHWP6S3MlJ/r70ofXjty/2Yv4lK1dnNkw
         nk1jUV0oh+Hafy1YxgL5d7KqyoZwEhYKeb2NV4ZJaT2/0P8eQAejCkZeFxed4x6xqwfw
         5yGpK1cUww+R1nwaGwguh02zA5eN32vP/rcLDM3m5u8BM8dg7GaFxkIVgtqoGeOdFqHg
         4y3zrTiam3jUjnnqYpF6icNRlnKxwaL6XLWlNoLSCsy6G1znfvCHdYfsi4rZ63c0UVXZ
         NCsgPl+MG+sx16/MnP5x97P4wG8nRSlUeJeykQuoiYq1Mfp5uSg1p66S5ieugg7bbLYo
         GdPw==
X-Forwarded-Encrypted: i=1; AJvYcCVNIIV2+fOmeXBBDpjmm3LoP0qmfkB0PFgkjk45dAYi+h7ZRM4fWetD+qQ33DQkxcI2D5PaRwy4K354@vger.kernel.org
X-Gm-Message-State: AOJu0YxNqORwWOI+HwgL0TtS9Mv2N23b9tnAeFIskFaLgc+0L/o/Cop4
	5pwBKCXSs9NTCaRaSuirX5rAHW6gfd1301KCa+TcTUHXsasm/x07tjiH6zb/Y50kkRPYWX3q6be
	EVB1kEQnQncoOj4J2TN8+VRNHGnZbwo+SOiThO4I=
X-Gm-Gg: ASbGnctqBNOI5WUa2DT+T9xGXhxNXKXtihePbb8Qm48oeKu6UwV8am1OtZROrsi1kKs
	Y2NWp3Bq2PmA2K9+uqYYYZeAGWKdDKLbw39vhu87BQLNzN8DO9iIyzmNHbag/mfQhpWRroqeGB0
	FQfiMQtRsDsgqU7DUDEjWUhpH//a7LyBDjxONkdgfHTrA5RAbg6JTg/bCUL2X9ozBndLKIZ0Uhy
	eaG4zE=
X-Google-Smtp-Source: AGHT+IHe+XfTIMCRAPUlFlbIkU/tflsFbW21MdMyfHp/6XCnDfQb6bDuEaT4rRTsszgpW5/nSEEe9gnMe/G5FaXzkrE=
X-Received: by 2002:a2e:b890:0:b0:32a:8c12:babf with SMTP id
 38308e7fff4ca-330a7ae414amr30893801fa.2.1753112755706; Mon, 21 Jul 2025
 08:45:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <30f8ea8d-79c4-4e5c-b354-51ad8146a61c@acm.org> <20250717194025.3218107-1-salomondush@google.com>
 <CAFdVvOx-xegmdGO8xgwpE3i0BvgXD0C1jKjNWKNjTFuifWmuxg@mail.gmail.com> <CAPE3x15Qxy5+C3_1v6a6YBoz03=NVoJMz-yfc6qih_=_js8=ug@mail.gmail.com>
In-Reply-To: <CAPE3x15Qxy5+C3_1v6a6YBoz03=NVoJMz-yfc6qih_=_js8=ug@mail.gmail.com>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Mon, 21 Jul 2025 09:45:37 -0600
X-Gm-Features: Ac12FXw5DZe5BWwrJJeGdf__5xPK_A-GGmxWMXE3oIwKFHGDrodRAJm3PDz7znM
Message-ID: <CAFdVvOw3pGhd2Y+C90jSOWNhq-+JiS1CRaWmHBm=SHBP_cjBSA@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: mpi3mr: Emit uevent on controller diagnostic fault
To: Salomon Dushimirimana <salomondush@google.com>
Cc: bvanassche@acm.org, James.Bottomley@hansenpartnership.com, 
	kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	mpi3mr-linuxdrv.pdl@broadcom.com, sreekanth.reddy@broadcom.com, 
	sumit.saxena@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000168636063a725fa4"

--000000000000168636063a725fa4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2025 at 5:31=E2=80=AFPM Salomon Dushimirimana
<salomondush@google.com> wrote:
>
> When the controller encounters a fatal error event, we want to notify
> our userspace tools to react to these events and pull the
> corresponding logs/snapdump from the ioc. There's a list of other
> drivers doing something similar, such as drivers/scsi/qla2xxx,
> drivers/scsi/qedf/qedf_dbg.c, etc.
>
> So the mpi3mr_issue_reset function only supports two types of resets,
> i.e MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET and
> MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT for now. From the code,
> it seems like only diag fault reset generages a snapdump, soft resets
> do not, hence why we only emit the fatal uevent on diag fault.
The driver issues diag fault reset when it observes some anomaly at
the driver level, however, the firmware can fault asynchronously when
there is a problem detected at the firmware level and snapdumps will
be created for those too. So just emitting the event only for diag
fault reset will not help to capture diag data captured for firmware
faults and we may need to filter only based on reset reason and not
based on reset type.
> Thanks,
> Salomon Dushimirimana
>
> Salomon Dushimirimana
>
>
> On Fri, Jul 18, 2025 at 8:43=E2=80=AFAM Sathya Prakash Veerichetty
> <sathya.prakash@broadcom.com> wrote:
> >
> > On Thu, Jul 17, 2025 at 1:40=E2=80=AFPM Salomon Dushimirimana
> > <salomondush@google.com> wrote:
> > >
> > > Introduces a uevent mechanism to notify userspace when the controller
> > > undergoes a reset due to a diagnostic fault. A new function,
> > > mpi3mr_fault_event_emit(), is added and called from the reset path. T=
his
> > > function filters for a diagnostic fault type
> > > (MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT) and generates a uevent
> > > containing details about the event:
> > >
> > > - DRIVER: mpi3mr in this case
> > > - HBA_NUM: scsi host id
> > > - EVENT_TYPE: indicates fatal error
> > > - RESET_TYPE: type of reset that has occurred
> > > - RESET_REASON: specific reason for the reset
> > >
> > > This will allow userspace tools to subscribe to these events and take
> > > appropriate action.
> > What is the reason for userpace tools to know these events and what
> > user space tools we are talking about here?  Also, on what basis it is
> > decided only diag fault reset is considered as FATAL.  I would prefer
> > to understand the actual requirement before ACKing this patch.  If we
> > need this kind of user space notification then it would be better to
> > make it generic and let the notification sent for all firmware fault
> > codes.
> >
> > >
> > > Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
> > > ---
> > > Changes in v2:
> > > - Addressed feedback from Bart regarding use of __free(kfree) and mor=
e
> > >
> > >  drivers/scsi/mpi3mr/mpi3mr_fw.c | 37 +++++++++++++++++++++++++++++++=
++
> > >  1 file changed, 37 insertions(+)
> > >
> > > diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mp=
i3mr_fw.c
> > > index 1d7901a8f0e40..a050c4535ad82 100644
> > > --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > > +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > > @@ -1623,6 +1623,42 @@ static inline void mpi3mr_set_diagsave(struct =
mpi3mr_ioc *mrioc)
> > >         writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
> > >  }
> > >
> > > +/**
> > > + * mpi3mr_fault_uevent_emit - Emit uevent for a controller diagnosti=
c fault
> > > + * @mrioc: Pointer to the mpi3mr_ioc structure for the controller in=
stance
> > > + * @reset_type: The type of reset that has occurred
> > > + * @reset_reason: The specific reason code for the reset
> > > + *
> > > + * This function is invoked when the controller undergoes a reset. I=
t specifically
> > > + * filters for MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT and igno=
res other
> > > + * reset types, such as soft resets.
> > > + */
> > > +static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc, u16 r=
eset_type,
> > > +       u16 reset_reason)
> > > +{
> > > +       struct kobj_uevent_env *env __free(kfree);
> > > +
> > > +       if (reset_type !=3D MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FA=
ULT)
> > > +               return;
> > > +
> > > +       env =3D kzalloc(sizeof(*env), GFP_KERNEL);
> > > +       if (!env)
> > > +               return;
> > > +
> > > +       if (add_uevent_var(env, "DRIVER=3D%s", mrioc->driver_name))
> > > +               return;
> > > +       if (add_uevent_var(env, "HBA_NUM=3D%u", mrioc->id))
> > > +               return;
> > > +       if (add_uevent_var(env, "EVENT_TYPE=3DFATAL_ERROR"))
> > > +               return;
> > > +       if (add_uevent_var(env, "RESET_TYPE=3D%s", mpi3mr_reset_type_=
name(reset_type)))
> > > +               return;
> > > +       if (add_uevent_var(env, "RESET_REASON=3D%s", mpi3mr_reset_rc_=
name(reset_reason)))
> > > +               return;
> > > +
> > > +       kobject_uevent_env(&mrioc->shost->shost_gendev.kobj, KOBJ_CHA=
NGE, env->envp);
> > > +}
> > > +
> > >  /**
> > >   * mpi3mr_issue_reset - Issue reset to the controller
> > >   * @mrioc: Adapter reference
> > > @@ -1741,6 +1777,7 @@ static int mpi3mr_issue_reset(struct mpi3mr_ioc=
 *mrioc, u16 reset_type,
> > >             ioc_config);
> > >         if (retval)
> > >                 mrioc->unrecoverable =3D 1;
> > > +       mpi3mr_fault_uevent_emit(mrioc, reset_type, reset_reason);
> > >         return retval;
> > >  }
> > >
> > > --
> > > 2.50.0.727.gbf7dc18ff4-goog
> > >

--000000000000168636063a725fa4
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
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIBtoxiIA
h63hxKyHmJQssK4VVoiaHhr78X/2DnTV642oMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI1MDcyMTE1NDU1NlowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFc4srus64S7zRcEhjno3ItTIr10O+NyLM9G+LfXtCMr
RGzu7ILkjPiR2kkowwEb1cMreMKYu43J7lYFVKiaxrRoeo+hdAY1hBpa3+T64oArVywbXxfQ6ysZ
egOKwUze81T52Mo0ZNaqORrtrDz4ig6mT4588eJx9t2hJyt6JeFhjvWQUouS2yM8KceewBRWhQ7H
DF5tcLwxssUVXABSScE84AqzJYlJjTbRmgW22wttq9Jg9fcy0pUnxIsTxpfPCvUYJls5tVDRCecx
hEUSSLAh6/Em9GHaKy8zOsabGRJOFMquRAyK8BnFgO8/6w2MFTEQDSzVrxWHlmzCPULo2Io=
--000000000000168636063a725fa4--
