Received: from mail-yw1-f225.google.com (mail-yw1-f225.google.com [209.85.128.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FFA369980
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 07:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768289257; cv=none; b=NSd50UzR8w/Vw67bxUYmpOklP/d+Uen6PJSgX2bQdZBBmRBxLjhYgs3XMP0S0RyQ3XbrHmSXeeAGp8AjVPxElcInE1fS+N39c5cAukyOOZueCB1tSO3mfAQ8KgVkd72OkMbrLqg4xjHkzhJDVFBUZyXC2UhytUCLRQfmZcV3MQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768289257; c=relaxed/simple;
	bh=oId1zue55veNwSeMki8Lhpcd+35wGfGI3jW90/aFOd4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FSk/llwPDMjMZ3/7/FaT+ktlYpdscMq8dnwCi+9y7Qn1uqmS5fydOyVj5IDdGcPLG4E297J6TGKKmcVrT9dfIB+ZXvFfasqTM+U3AWbljBNCKcAtY/+jz5Gg9n4FQW5JkMdMuQQqhivy/IbI/FtC9JgkU/7tKlfIEsBFqWjI58M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=crj/CkqR; arc=none smtp.client-ip=209.85.128.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="crj/CkqR"
Received: by mail-yw1-f225.google.com with SMTP id 00721157ae682-79274e0e56bso24932967b3.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 23:27:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768289255; x=1768894055;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e0Udf6/BnxwSHtNBik2YEHou+e31MREEAXwrvxUyv2Y=;
        b=XSPeD7DBViZ1QKHlcnYFNIKn8pvUHlVLf4kw9M/Mfso/gqAZam+nEK6HvuisqnGZcU
         7ugmtJsz35o37ZsM+X8N4yQ98S2zbkiHgGXdPmAbeDfivbuC2a+4rFyQJSdMOYzlCO+X
         hwlWTcnVoyzyK379kmddsqazIvyPbEG940c5qelG3sXh4q19m5wNoRziE3TwYPtVa/VC
         tc0yD5Oos9+/A+2qmsUadfMKuStfhwc+LL6nfkP6QzYEQ3N15XjjZ1CHcA9E4vCnJyTK
         Lpdkw/BuVD/Ryl0rL0nRWbWZO7KJ0yz43CTbJ19OPvbSDZ5oN4pQ0dXY1E+Cw8yTztAw
         P7bw==
X-Gm-Message-State: AOJu0Yz6WVw5rgDy6611gFPhfRgrTRADAAIJQ1W75eoBXXDMBf6Yb4JC
	/1t6F+3StRZPJGhqOGX8m+mNsJVrHCUbMtlTMO5+AiUbEhe8z1QloZYSAxBkGYds3zjShDVksH2
	30Opo36/sAv9uFETwx1qC1wPkdGyZHHCgWJzGvcGgRkAfghzE0wgaiq1llvvBazNesrZnOuLTs0
	7FrXyzqs95sE6wvzZeIzSFBlpoE1wL3R3bMuHwOlsq0v+og0CrmrKW5uZhPPE1RyeWN/MkDABFE
	HHxV0sg6jnmGdIb
X-Gm-Gg: AY/fxX7BjMKY97l4MY5gS/yLzk8wjK3RnnoZ+llEzd/2bt3fxx/1VE5rIAmJGpMdEDV
	0jkcUOS/1SHr9kdClJ2yIL03xkq712+8Khtcfl49erYTzGkjBgmxKhc97AUi5coeqZdbg3GWj9N
	YkVXHLCa0cbA3ZZujwgw1a1dnWKph0LZPkGPkn/VKJhl7E9iXcGV6yoozcNIOckiBgLb2PuaFX9
	rek+CgYJy2yCy5XwwllooLidsCniFwWEmfjEuLq954nVPsxC5Uaj0mApD+Tu2jhjSJTLxwwV16u
	xNi4xzoIdtjcw7HFfKkpAs04lf/pDHz9Rzu2+w7Lzs95/IcCBUu2Aeafnparrryx15jKOeCwRNv
	ombFlwHmK65TuHjdI1O00uJzMZQqHK8t3VleQyKz83GZFGH/IBzi2ouUkUkfN0vi957tO
X-Google-Smtp-Source: AGHT+IFgPpRSdyr2OCG+LmY6KCaT43niuEqDwcNqkAQNd3vDzWcypmfnbk1gV4IFRp4IS/RrRhZxiLPw5+pG
X-Received: by 2002:a05:690c:6f88:b0:78f:84c6:f9dc with SMTP id 00721157ae682-790b5711a07mr180631647b3.68.1768289255113;
        Mon, 12 Jan 2026 23:27:35 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-7927c92716bsm5455757b3.6.2026.01.12.23.27.33
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2026 23:27:35 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b87264858ebso162564366b.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 23:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768289252; x=1768894052; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e0Udf6/BnxwSHtNBik2YEHou+e31MREEAXwrvxUyv2Y=;
        b=crj/CkqRmdazLKlDa6cKsZhCuap6sE3SpuiV9XHsPFqgY03lghcqRiucbWdZOkMmb4
         AydYmyxunzd4L4AurdFqtLvjqw4yZbNdko6Vmyt11c0tRCP38/GiJ832ooorj+MqIF9O
         TX1PZMfpQs3+96IR0lNZvudH9ta5GX/XpouDk=
X-Received: by 2002:a17:906:9f8e:b0:b77:f4a:ca1b with SMTP id a640c23a62f3a-b84451c0394mr1813152366b.16.1768289252153;
        Mon, 12 Jan 2026 23:27:32 -0800 (PST)
X-Received: by 2002:a17:906:9f8e:b0:b77:f4a:ca1b with SMTP id
 a640c23a62f3a-b84451c0394mr1813150666b.16.1768289251644; Mon, 12 Jan 2026
 23:27:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
 <20260112081037.74376-3-ranjan.kumar@broadcom.com> <ad1547ce-7a44-4fdc-8bcf-670ce069fe5f@kernel.org>
In-Reply-To: <ad1547ce-7a44-4fdc-8bcf-670ce069fe5f@kernel.org>
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
Date: Tue, 13 Jan 2026 12:57:19 +0530
X-Gm-Features: AZwV_QhDo8pf3WZ1NKTojYqFKj0zpPb-IScmZYkks2YsSMygGWDZmOzopdy-D2A
Message-ID: <CAMFBP8MDRv7uieV+ZYjdVSLkUp-ZihJgWcSAT=yCCUZ14FXdDg@mail.gmail.com>
Subject: Re: [PATCH v1 2/7] mpi3mr: Rename log data save helper to reflect
 threaded/BH context
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com, 
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com, 
	salomondush@google.com
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000c4066106483fece0"

--000000000000c4066106483fece0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Damien,

On Mon, Jan 12, 2026 at 7:43=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> On 1/12/26 09:10, Ranjan Kumar wrote:
> > Log data events can be processed from BH and threaded contexts.
> > Rename the save helper to document its intended usage and improve
> > readability of the event handling flow.
> >
> > Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> > ---
> >  drivers/scsi/mpi3mr/mpi3mr.h     | 2 +-
> >  drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
> >  drivers/scsi/mpi3mr/mpi3mr_os.c  | 8 +++++++-
> >  3 files changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.=
h
> > index 31d68c151b20..611a51a353c9 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr.h
> > +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> > @@ -1508,7 +1508,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr=
_ioc *mrioc,
> >       struct mpi3mr_drv_cmd *drv_cmd);
> >  int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
> >       struct mpi3mr_drv_cmd *drv_cmd);
> > -void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_dat=
a,
> > +void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_=
data,
> >       u16 event_data_size);
> >  struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
> >       struct mpi3mr_ioc *mrioc, u16 handle);
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi=
3mr_app.c
> > index 0e5478d62580..37cca0573ddc 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> > @@ -2920,7 +2920,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bs=
g_job *job)
> >  }
> >
> >  /**
> > - * mpi3mr_app_save_logdata - Save Log Data events
> > + * mpi3mr_app_save_logdata_th - Save Log Data events
> >   * @mrioc: Adapter instance reference
> >   * @event_data: event data associated with log data event
> >   * @event_data_size: event data size to copy
> > @@ -2932,7 +2932,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bs=
g_job *job)
> >   *
> >   * Return:Nothing
> >   */
> > -void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_dat=
a,
> > +void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_=
data,
> >       u16 event_data_size)
> >  {
> >       u32 index =3D mrioc->logdata_buf_idx, sz;
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3=
mr_os.c
> > index d4ca878d0886..4dbf2f337212 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -1962,7 +1962,7 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3=
mr_ioc *mrioc,
> >  static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
> >       struct mpi3mr_fwevt *fwevt)
> >  {
> > -     mpi3mr_app_save_logdata(mrioc, fwevt->event_data,
> > +     mpi3mr_app_save_logdata_th(mrioc, fwevt->event_data,
> >           fwevt->event_data_size);
> >  }
> >
> > @@ -3058,6 +3058,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *=
mrioc,
> >       }
> >       case MPI3_EVENT_DEVICE_INFO_CHANGED:
> >       case MPI3_EVENT_LOG_DATA:
> > +     {
>
> The curly brackets are not necessary.
[Ranjan] :  The extra braces around the MPI3_EVENT_LOG_DATA case are
unnecessary.
I=E2=80=99ll remove them in the next revision.
>
> > +             sz =3D event_reply->event_data_length * 4;
> > +             mpi3mr_app_save_logdata_th(mrioc,
> > +                 (char *)event_reply->event_data, sz);
>
> Do you really need the cast here ?
[Ranjan]:
The cast to (char *) is not required since event_reply->event_data is
already compatible with the helper prototype.
I=E2=80=99ll drop the cast as well.
I=E2=80=99ll address these and resend in v2.

>
> > +             break;
> > +     }
> >       case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
> >       case MPI3_EVENT_ENCL_DEVICE_ADDED:
> >       {
>
>
> --
> Damien Le Moal
> Western Digital Research

Thanks,
Ranjan

--000000000000c4066106483fece0
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
MjAyMwIMDcMaKRu9LrbAxERoMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCDvaglK
M06zqPRSOMHpgYOVbjK6OgOnK2FRJ76zMIvppTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjAxMTMwNzI3MzJaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCHXWvuKhUCpYP0px2X11Fz28b6KficIZXpTly7s51K
CqWZNafaB5F8P+p89LZq8rufEeyFaaBY3G3no8nfjI9GI0fwzKVCsRvalUJ0QlPnUpSqVq8yFoif
aC9p+KgrrzgIsiFs375vi4Z7hwbiDv8RZa8Ri2Z802Eg8Ohu4GmuX4IQU2jyW5VRkDhfwEYfparZ
BWXTYgPaqjyF4PMA0GVXLpKpfYOfnrwCDX/JVcCdTfgVafatyw6xlgcyDKyd5tqnH5OffIFElDnm
AYAMHOh+MvlGVW5YZrybOgUp9YPersdYCM/08kqiiazbHwlxWMAmxd0gADEfAhZhtUP95b3m
--000000000000c4066106483fece0--
