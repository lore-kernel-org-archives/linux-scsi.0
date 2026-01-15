Received: from mail-yw1-f226.google.com (mail-yw1-f226.google.com [209.85.128.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CA433E350
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 08:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768466766; cv=none; b=XQzmS8pkM+n/8jpmIgyYZT8N0hx3x+p0HC6WAOJ7iEYsBVFyAyN5HLdTkZQs5DK/Xe1G5kFcKhxUqLIR5QUACcaCQoGRorpmZgbvdWsmVntCMccBoolaxfhQjFfUJNNJ6ikhOJGhj+F1UYr6c0SZuzlL/KOOtPcbsI1BGVSguz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768466766; c=relaxed/simple;
	bh=uGGG4qn5ONYmcCWojw9CJ54zcAXno6J87zR9AJhSabw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fypPUYiXyQdtlMNqyCCkkd14+DHAQEiJZv8cvUPWPrqDugvz0YLgTJrXpw6z9lTRxvC0r5UgUIO0W/FrXsqcZW3buWbhWFGAlh3Vebg2wNZzut5bIqnteTSOqG2Lv86lHpXTX+awP+QK4gyg8CCBhfHBO35Ufcl1B6ECeeFOnoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PWwbmk5+; arc=none smtp.client-ip=209.85.128.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PWwbmk5+"
Received: by mail-yw1-f226.google.com with SMTP id 00721157ae682-78c66bdf675so6047277b3.2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 00:46:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768466763; x=1769071563;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZE0BgTwE7s+RduB8knshQNrqgWLOS7D0SIiYrfLvxGw=;
        b=s9UG84qnYBIOS38jLwyluLwvpXG5SbySEv4r5771MgcSZLU/nI4Uq9VRJRWralCK+I
         qbCf/62bayBVldC7hSClT719HOCBwiU+VfrfNhnosKcp69DpFhMqI5xInljbpYCUQAA5
         qd3BcuBwcWqIzn43P4qvhI/b2MXHdaLYFIgJB50zsNXMv+Nnl1xOU/Us2MchAddYsGPz
         SOUNpLQxSHaMFtSfmYQyEsEwhrTdwqqeuVOIak9WwlRjBhCqsheWBPXXru1V00hi1LU4
         0KJVv1TYLttDamXbVqTuYlO/NWhgAxVLAyabsYCw4NDKlicUGGgwmEc5jF0vBSwLsOY7
         0Ypg==
X-Gm-Message-State: AOJu0Yy/qR3SB2i5ZgK2Dwul2b66wod/CKwkis7ERSlhIZUkNltEHwbc
	I31Sb1d5cmGw5WrEbfONeuWmbeBiJu678n+D6tlFun0rJUXnD2q45vZKX1Nj8PqByxEPWfrCTx6
	c8o6nUnWMLwsPXFu+vXLqSbR7wgqSlWR+YmPVz/rRFDwu1qQUENczuptsW6HGx7F9LOJ35yn8Zz
	qpi+F6/CJTByRi9r3cWe8cEsz76G6o8hhf39tMHJ/mBaUVemQDWQTD0Cu8bHWk94kBaJeJD3jin
	PjTL7jEad6WtXPi
X-Gm-Gg: AY/fxX5+J6y4kLRdb/TR+TDQRg1rkNNRj3yJieQ49tFrxtCy0JpFs+6NyIYOqwSuVpn
	1eb9QtNHQ/2JRjbk6HHZx35S97L63ik+cNIrjjiEacKawtApT9rm3IMw7ICgjywo1CHNb1bauK4
	VFjSdQr/M2dEW8NFNkguuu8oPQB57+E2VdLdCZweWRitq8y7jIQ2YjKPxhvT48tTZ5gk+mnjLng
	+lzk+zl+zrdBRoHndjYe5VRBkf0IThUrU6wjl4UjKEuR2G2OhXO0ak4dh3IHZ1xhlvNbnijB7EW
	ecYJa0i5izkVip2BaqU11qtUDpInxHLxCc6iDcCg0td8XY/DqnsxTUeIU5qsDhqRbLCzC78xtRF
	3o58yAYcWvIC1BjlYDZc6JBW0z2dKiChYYONoB3Utmla/iQ/lPx/zbcAqbUAJRQudGhhFhzaP6q
	dMVwnvejnKWpO+ifg5cs4RfLaQbtnSe8nhzlh49Nh9hb+kNzc=
X-Received: by 2002:a05:690e:13c1:b0:646:7ec9:4c0d with SMTP id 956f58d0204a3-64901aa6c80mr4249681d50.1.1768466763060;
        Thu, 15 Jan 2026 00:46:03 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-793af1ba51esm1917187b3.21.2026.01.15.00.46.02
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jan 2026 00:46:03 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b876b03afc5so137415166b.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 00:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768466760; x=1769071560; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZE0BgTwE7s+RduB8knshQNrqgWLOS7D0SIiYrfLvxGw=;
        b=PWwbmk5+FkQzJs6Ck1w7rxVd1OrHL0S7u53Cbqpr3GqHGWgZSkfZygQV8Mjf2JIe/T
         rWDNaCSKCByio5KZDk9Bcynoev3sdbPDl04UmAesrjgZEk4UjB3RA0OcpvnWBmTYmjoc
         WuUISfB8/tlCIVj1ZG0j7HULAbPDnlARK6cv0=
X-Received: by 2002:a17:907:d86:b0:b76:bcf5:a388 with SMTP id a640c23a62f3a-b87612a1d31mr495849666b.50.1768466760416;
        Thu, 15 Jan 2026 00:46:00 -0800 (PST)
X-Received: by 2002:a17:907:d86:b0:b76:bcf5:a388 with SMTP id
 a640c23a62f3a-b87612a1d31mr495847966b.50.1768466760000; Thu, 15 Jan 2026
 00:46:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
 <20260112081037.74376-3-ranjan.kumar@broadcom.com> <ad1547ce-7a44-4fdc-8bcf-670ce069fe5f@kernel.org>
 <CAMFBP8MDRv7uieV+ZYjdVSLkUp-ZihJgWcSAT=yCCUZ14FXdDg@mail.gmail.com>
In-Reply-To: <CAMFBP8MDRv7uieV+ZYjdVSLkUp-ZihJgWcSAT=yCCUZ14FXdDg@mail.gmail.com>
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
Date: Thu, 15 Jan 2026 14:15:47 +0530
X-Gm-Features: AZwV_Qguawl-WIdwbodMB_fvb58Lpk0zBLtH1n7QdG2Y7sNVkPmC8jdQc1vXCSI
Message-ID: <CAMFBP8Mn426WFsTBs6COEJhCKEkPdkAp8GX_BqPNagEyC_-cJw@mail.gmail.com>
Subject: Re: [PATCH v1 2/7] mpi3mr: Rename log data save helper to reflect
 threaded/BH context
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com, 
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com, 
	salomondush@google.com
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000013de3906486941d5"

--00000000000013de3906486941d5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Damien,

On Tue, Jan 13, 2026 at 12:57=E2=80=AFPM Ranjan Kumar <ranjan.kumar@broadco=
m.com> wrote:
>
> Hi Damien,
>
> On Mon, Jan 12, 2026 at 7:43=E2=80=AFPM Damien Le Moal <dlemoal@kernel.or=
g> wrote:
> >
> > On 1/12/26 09:10, Ranjan Kumar wrote:
> > > Log data events can be processed from BH and threaded contexts.
> > > Rename the save helper to document its intended usage and improve
> > > readability of the event handling flow.
> > >
> > > Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> > > ---
> > >  drivers/scsi/mpi3mr/mpi3mr.h     | 2 +-
> > >  drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
> > >  drivers/scsi/mpi3mr/mpi3mr_os.c  | 8 +++++++-
> > >  3 files changed, 10 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3m=
r.h
> > > index 31d68c151b20..611a51a353c9 100644
> > > --- a/drivers/scsi/mpi3mr/mpi3mr.h
> > > +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> > > @@ -1508,7 +1508,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3=
mr_ioc *mrioc,
> > >       struct mpi3mr_drv_cmd *drv_cmd);
> > >  int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
> > >       struct mpi3mr_drv_cmd *drv_cmd);
> > > -void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_d=
ata,
> > > +void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *even=
t_data,
> > >       u16 event_data_size);
> > >  struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
> > >       struct mpi3mr_ioc *mrioc, u16 handle);
> > > diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/m=
pi3mr_app.c
> > > index 0e5478d62580..37cca0573ddc 100644
> > > --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> > > +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> > > @@ -2920,7 +2920,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct =
bsg_job *job)
> > >  }
> > >
> > >  /**
> > > - * mpi3mr_app_save_logdata - Save Log Data events
> > > + * mpi3mr_app_save_logdata_th - Save Log Data events
> > >   * @mrioc: Adapter instance reference
> > >   * @event_data: event data associated with log data event
> > >   * @event_data_size: event data size to copy
> > > @@ -2932,7 +2932,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct =
bsg_job *job)
> > >   *
> > >   * Return:Nothing
> > >   */
> > > -void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_d=
ata,
> > > +void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *even=
t_data,
> > >       u16 event_data_size)
> > >  {
> > >       u32 index =3D mrioc->logdata_buf_idx, sz;
> > > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mp=
i3mr_os.c
> > > index d4ca878d0886..4dbf2f337212 100644
> > > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > > @@ -1962,7 +1962,7 @@ static void mpi3mr_pcietopochg_evt_bh(struct mp=
i3mr_ioc *mrioc,
> > >  static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
> > >       struct mpi3mr_fwevt *fwevt)
> > >  {
> > > -     mpi3mr_app_save_logdata(mrioc, fwevt->event_data,
> > > +     mpi3mr_app_save_logdata_th(mrioc, fwevt->event_data,
> > >           fwevt->event_data_size);
> > >  }
> > >
> > > @@ -3058,6 +3058,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc=
 *mrioc,
> > >       }
> > >       case MPI3_EVENT_DEVICE_INFO_CHANGED:
> > >       case MPI3_EVENT_LOG_DATA:
> > > +     {
> >
> > The curly brackets are not necessary.
> [Ranjan] :  The extra braces around the MPI3_EVENT_LOG_DATA case are
> unnecessary.
> I=E2=80=99ll remove them in the next revision.
> >
> > > +             sz =3D event_reply->event_data_length * 4;
> > > +             mpi3mr_app_save_logdata_th(mrioc,
> > > +                 (char *)event_reply->event_data, sz);
> >
> > Do you really need the cast here ?
> [Ranjan]:
> The cast to (char *) is not required since event_reply->event_data is
> already compatible with the helper prototype.
> I=E2=80=99ll drop the cast as well.
> I=E2=80=99ll address these and resend in v2.
>
[Ranjan]: The cast is required here since event_data is __le32 * and
the existing helper takes a byte buffer.
Removing it results in an incompatible pointer type build error.
I=E2=80=99ll keep the cast and remove curly brackets and will resend v2.
> >
> > > +             break;
> > > +     }
> > >       case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
> > >       case MPI3_EVENT_ENCL_DEVICE_ADDED:
> > >       {
> >
> >
> > --
> > Damien Le Moal
> > Western Digital Research
>
> Thanks,
> Ranjan

--00000000000013de3906486941d5
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
MjAyMwIMDcMaKRu9LrbAxERoMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCCci724
aChc+l+cZcN2ouKTY/u2RBJmfa9TOqK3X8jumjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjAxMTUwODQ2MDBaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB6AsBAgF0sobnmYxwpFuSD3iTahwEVgrmuUrOFB47x
vGAMheIkBQfLZpguyyalbIWwcqa4q/vduHKip9/WzPVbqDEh87KEXDBCB8ehyISh63X2nx+df9E1
N/Q6J89c7Qc5S1+q7eRuwrZPau/NSrc7XDHeTEKX/c9/nfvOC8ENIq1Od2iRr4VQeO4dz/79K9iu
o3V9B6dQzVz89o/FgGEBykUMsC2V+w9lIr8S/I9Us3pXfAsS/J5Hw9Pn3bVhin5v/20NqfcLK9J1
aXfc99ZIuMOTms9wHMYlvvBV0cB1HGezneueM9YENtxlaHYGC/ScUJzHoDuiGiw3btPq26R6
--00000000000013de3906486941d5--
