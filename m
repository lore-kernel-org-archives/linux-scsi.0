Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E46E259CAC
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 19:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741116278; cv=none; b=FW+7W7UsdASrqK+5m5XiP5aWXtxGRfAZidRccy9325qqWUgNOrXibTup9dEsSUQDLrTnnR1t0Bh6572iQQhdGf3AxFhz7/EoUbcsMYmOWekXDCMCH2CWMAYvpKx+ArMeHP057h8AHCWHL4ind92fjCTA4VehI1KxO+BNvT6OWTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741116278; c=relaxed/simple;
	bh=QOmVFNx8O7Zhas8zONn63Xq+ZvHgBoPMhAECahg+lj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ub1aICh0H3mBqJGbIcgAiBK48ZQJIXKMwt+mTpsd1XeG2N1cuh/ikkH238wRvnRG43zZbSU5g7+CTM2PsHBtttDL1k3/KN6fZgLFd4tSQRSQ0nMAn3KjTJFE9UtuZb8ZKtsFMDKCweGIVBDSMhOaplaKOoXumW4JSlQrUJwJ4WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=D2kNDFbN; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="D2kNDFbN"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e4d3f92250so8193465a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 04 Mar 2025 11:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1741116275; x=1741721075; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4skgHlC6+L8eybONXUnSlyB75LDd39cO1LcFUkjFZeM=;
        b=D2kNDFbN34zXVijouLiFJ5FJt0NEimeTGlhVBIWAqMqPY3UgUZzb8705RQ2gvkXhp/
         /6Eyxoukke9pken0SBdbAXhskhCLva7oSW7TYP5b+FeS+Kc5bVQ7Y55yjX0ztS6UCyfW
         GTARGVk5yDGGhSWowdpiOIH3VHoFT/k79Z864=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741116275; x=1741721075;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4skgHlC6+L8eybONXUnSlyB75LDd39cO1LcFUkjFZeM=;
        b=izKDLuPV3MpAtFdtvCq56mSMe1Dz04UPguD3OjXIWOKHtUtkB/tvECE81BPcprMEfY
         4HfQuFbPN7KdvTXqyUJcutl0CfLLphUcHGvlTbp5k1eqJPHLVTe74tjRdA9uSxVXy+wK
         rVFvr5zLlC3jXi8NUTZSegRi7Erqa2nkFo5kLqyREt9/QxiqCuzJRBw5r0+eCc6KWV6K
         jImqbIwDZPV6DIRPE4627oYFUt2kvv0eaB1r6Av/Va4ZS0u5PeZpttUYp+XMcIGvN3uU
         4NfoWLxlc5YcH/UqoguJNTnpOcmqqPLPBPQSSKYmJDL+wAtSPMMx5agQRzT+Z/PxkXk2
         Enwg==
X-Forwarded-Encrypted: i=1; AJvYcCVr+Q0/CUMOWLh0bEuFmgQPLqRmzHFdWMa16YmujGPIZDJkEuuxiLypQS4MWvxvGibrZsUVf1rJL27v@vger.kernel.org
X-Gm-Message-State: AOJu0YyKgzWenoDR+AW6QEFp8TVtnjvVNYF5iP7xTlOZ95f+2KMtZjx4
	h83c48yHakI/6LvbKBQT6Ok783EWeBQR2x6HFkW1809rQWp1VsFKTtGYrXebjYmSk1mOO4F0xh7
	yyc8ybToViIqWVQSWsCzDOVy+jk8CTFhgbQeH
X-Gm-Gg: ASbGncs9/z1sGoSf7rIfgyhWG1VJPyDOx+IbH8ALC1w0keHKkzIP3/lgB8s07miSmrY
	CLgYlaR+RkLD7wjcGUOohNe2s2XGQaP1Rgfip9rrXrqI/UhEjDtpaz9ofSVkp8QZUwe4bvqhsGb
	v7spm4FpWzveWzOpLhWfoITADhuT4=
X-Google-Smtp-Source: AGHT+IFPMgscvxNI1aYhWWzBZU71jpdjADir2Csbk58nf9JT6IMPa39ZhbMKK9PjbqIcr8BcCGRi+twcBWAocPcbvgg=
X-Received: by 2002:a05:6402:4404:b0:5dc:c9ce:b01b with SMTP id
 4fb4d7f45d1cf-5e59f386d6emr240902a12.8.1741116274647; Tue, 04 Mar 2025
 11:24:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303094004.93770-1-chandrakanth.patil@broadcom.com> <440e8b87-7c4b-47e7-a1c8-8b15f248ecdd@oracle.com>
In-Reply-To: <440e8b87-7c4b-47e7-a1c8-8b15f248ecdd@oracle.com>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Wed, 5 Mar 2025 00:54:21 +0530
X-Gm-Features: AQ5f1Jps35jOO8vDX9bwNv2qFOLLl2XpOcwjPKXgFOkjAD8CUSOnW4uO-dE5YDk
Message-ID: <CABvwm=NpqfPBsFKWQ0OvFmV=n7p003BUvAUvgezcexhcbx1koA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mpi3mr: Task Abort EH Support
To: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Chandrakanth Patil <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, sathya.prakash@broadcom.com, 
	sumit.saxena@broadcom.com, prayas.patel@broadcom.com, 
	rajsekhar.chundru@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000169070062f89396d"

--000000000000169070062f89396d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 11:08=E2=80=AFPM Himanshu Madhani
<himanshu.madhani@oracle.com> wrote:
>
>
> Hi Chandrakanth,
>
> Code looks fine =E2=80=A6 just couple of small nits into messages for bet=
ter
> readability.
>
> On 3/3/25 01:40, Chandrakanth Patil wrote:
> > Task Abort support is added to handle SCSI command timeouts, ensuring
> > recovery and cleanup of timed-out commands. This completes the error
> > handling framework for mpi3mr driver, which already includes device
> > reset, target reset, bus reset, and host reset.
> >
> > Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> > Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> > ---
> >   drivers/scsi/mpi3mr/mpi3mr_os.c | 99 ++++++++++++++++++++++++++++++++=
+
> >   1 file changed, 99 insertions(+)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3=
mr_os.c
> > index e3547ea42613..6a8f3d3a5668 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -3839,6 +3839,18 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8=
 tm_type,
> >       tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, handle);
> >
> >       if (scmd) {
> > +             if (tm_type =3D=3D MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK)=
 {
> > +                     cmd_priv =3D scsi_cmd_priv(scmd);
> > +                     if (!cmd_priv)
> > +                             goto out_unlock;
> > +
> > +                     struct op_req_qinfo *op_req_q;
> > +
> > +                     op_req_q =3D &mrioc->req_qinfo[cmd_priv->req_q_id=
x];
> > +                     tm_req.task_host_tag =3D cpu_to_le16(cmd_priv->ho=
st_tag);
> > +                     tm_req.task_request_queue_id =3D
> > +                             cpu_to_le16(op_req_q->qid);
> > +             }
> >               sdev =3D scmd->device;
> >               sdev_priv_data =3D sdev->hostdata;
> >               scsi_tgt_priv_data =3D ((sdev_priv_data) ?
> > @@ -4387,6 +4399,92 @@ static int mpi3mr_eh_dev_reset(struct scsi_cmnd =
*scmd)
> >       return retval;
> >   }
> >
> > +/**
> > + * mpi3mr_eh_abort- Abort error handling callback
>
>
> ^^^ function comment should be reworded as "Callback function for abort
> error handling"
>
> > + * @scmd: SCSI command reference
> > + *
> > + * Issue Abort Task Management if the command is in LLD scope
> > + * and verify if it is aborted successfully and return status
> > + * accordingly.
> > + *
> > + * Return: SUCCESS of successful abort the scmd else FAILED
> > + */
> > +static int mpi3mr_eh_abort(struct scsi_cmnd *scmd)
> > +{
> > +     struct mpi3mr_ioc *mrioc =3D shost_priv(scmd->device->host);
> > +     struct mpi3mr_stgt_priv_data *stgt_priv_data;
> > +     struct mpi3mr_sdev_priv_data *sdev_priv_data;
> > +     struct scmd_priv *cmd_priv;
> > +     u16 dev_handle, timeout =3D MPI3MR_ABORTTM_TIMEOUT;
> > +     u8 resp_code =3D 0;
> > +     int retval =3D FAILED, ret =3D 0;
> > +     struct request *rq =3D scsi_cmd_to_rq(scmd);
> > +     unsigned long scmd_age_ms =3D jiffies_to_msecs(jiffies - scmd->ji=
ffies_at_alloc);
> > +     unsigned long scmd_age_sec =3D scmd_age_ms / HZ;
> > +
> > +     sdev_printk(KERN_INFO, scmd->device,
> > +                 "%s: attempting abort task for scmd(%p)\n", mrioc->na=
me, scmd);
> > +
> > +     sdev_printk(KERN_INFO, scmd->device,
> > +                 "%s: scmd(0x%p) is outstanding for %lus %lums, timeou=
t %us, retries %d, allowed %d\n",
> > +                 mrioc->name, scmd, scmd_age_sec, scmd_age_ms % HZ, rq=
->timeout / HZ,
> > +                 scmd->retries, scmd->allowed);
> > +
> > +     scsi_print_command(scmd);
> > +
> > +     sdev_priv_data =3D scmd->device->hostdata;
> > +     if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> > +             sdev_printk(KERN_INFO, scmd->device,
> > +                         "%s: device is not available, abort task is n=
ot issued\n",
> ^^^
> This message can be reworded as
> "%s: Device not available, Skip issuing abort task\n"
>
> > +                         mrioc->name);
> > +             retval =3D SUCCESS;
> > +             goto out;
> > +     }
> > +
> > +     stgt_priv_data =3D sdev_priv_data->tgt_priv_data;
> > +     dev_handle =3D stgt_priv_data->dev_handle;
> > +
> > +     cmd_priv =3D scsi_cmd_priv(scmd);
> > +     if (!cmd_priv->in_lld_scope ||
> > +         cmd_priv->host_tag =3D=3D MPI3MR_HOSTTAG_INVALID) {
> > +             sdev_printk(KERN_INFO, scmd->device,
> > +                         "%s: scmd is not in LLD scope, abort task is =
not issued\n",
>
> Same here, message should be reworded
> "%s: scmd (0x%p) not in LLD scope, Skip issuing Abort Task.\n"
>
> Also add scmd pointer for easy debugging in the future.
>
> > +                         mrioc->name);
> > +             retval =3D SUCCESS;
> > +             goto out;
> > +     }
> > +
> > +     if (stgt_priv_data->dev_removed) {
> > +             sdev_printk(KERN_INFO, scmd->device,
> > +                         "%s: device(handle =3D 0x%04x) is removed, ab=
ort task is not issued\n",
>
> This message should be reworded as
> "%s: Device (handle =3D 0x%04x) removed, Skip issuing Abort Task.\n"
>
> > +                         mrioc->name, dev_handle);
> > +             retval =3D FAILED;
> > +             goto out;
> > +     }
> > +
> > +     ret =3D mpi3mr_issue_tm(mrioc, MPI3_SCSITASKMGMT_TASKTYPE_ABORT_T=
ASK,
> > +                           dev_handle, sdev_priv_data->lun_id, MPI3MR_=
HOSTTAG_BLK_TMS,
> > +                           timeout, &mrioc->host_tm_cmds, &resp_code, =
scmd);
> > +
> > +     if (ret)
> > +             goto out;
> > +
> > +     if (cmd_priv->in_lld_scope) {
> > +             sdev_printk(KERN_INFO, scmd->device,
> > +                         "%s: scmd was not terminated, abort task is f=
ailed\n",
>
> This message could be reworded as
> "%s: Abort task failed. scmd (0x%p) was not terminated.\n"
>
>
> > +                         mrioc->name);
> > +             goto out;
> > +     }
> > +
> > +     retval =3D SUCCESS;
> > +out:
> > +     sdev_printk(KERN_INFO, scmd->device,
> > +                 "%s: abort task is %s for scmd(%p)\n", mrioc->name,
> > +                 ((retval =3D=3D SUCCESS) ? "SUCCESS" : "FAILED"), scm=
d);
> > +
>
> Message printed for Successful case should be "SUCCEEDED" for better
> readability. Something like
>
> "%s: Abort Task %s for scmd (0x%p)\n"
>
> > +     return retval;
> > +}
> > +
> >   /**
> >    * mpi3mr_scan_start - Scan start callback handler
> >    * @shost: SCSI host reference
> > @@ -5069,6 +5167,7 @@ static const struct scsi_host_template mpi3mr_dri=
ver_template =3D {
> >       .scan_finished                  =3D mpi3mr_scan_finished,
> >       .scan_start                     =3D mpi3mr_scan_start,
> >       .change_queue_depth             =3D mpi3mr_change_queue_depth,
> > +     .eh_abort_handler               =3D mpi3mr_eh_abort,
> >       .eh_device_reset_handler        =3D mpi3mr_eh_dev_reset,
> >       .eh_target_reset_handler        =3D mpi3mr_eh_target_reset,
> >       .eh_bus_reset_handler           =3D mpi3mr_eh_bus_reset,
>
> once you fix these messages feel free to add
>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
>
> --
> Himanshu Madhani                                Oracle Linux Engineering

Thanks for the review, Himanshu.
I have made the suggested changes and resubmitted the patch as V2.

--000000000000169070062f89396d
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
80IlL0UapzuyZFExggJgMIICXAIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgxHbRA/WY+OVYGbn+cwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIKMIdE+/
GQn85SeCJPAj/C2aBgjCHXNlVlWpF81jtaoxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI1MDMwNDE5MjQzNVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGGk779jZf11sddve9Qib1QxSFZwj/udVLM+3qU2PxAn
QHkjCP0Wpbv6fP7z23y89umz6ExnNVD3LTkZ+Vyj1nIIGLvGAU8FQZo1kol8qlqwxYFk1CP4AqQH
EDe959B5BKlf4YvZquWV/soZK8hftf/IVoIc9wtUFLw8Zkvv3PtW5fKA4EUcFoIQePZeCvYdylR+
+pB7v3os81Q5zRvOqIbnCVITPD8mYOebkJvKEwAnTUODVbkVUVi7CwHQIvChwvmnKDSJLSquaYNp
silj8b7H/qyaff0aDFJcoIwu8TkcAcL1ZZgiJFBOYuZeL7LPXdGqKymqMpo29UyzZ3voB0M=
--000000000000169070062f89396d--
