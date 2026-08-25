Received: from mail-yx1-f98.google.com (mail-yx1-f98.google.com [74.125.224.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D4040242D
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787660052; cv=none; b=S5l+s2b4oD0X90+h1cQsRIOhVtSe8ij6VFkBERYELxSVqVdYgVTM0OYcxYMEGkPri8i7XqlPN8NFFUcv/dYmACR8tKE9Qj93ZUvb8hTXYvL5cdcYqxYdoWqMb/S+1zvb2hvRaa28wgYOS2KoI2QB6AfWsCtvIKPbC90qNj8Z6Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787660052; c=relaxed/simple;
	bh=xqAxp5POpHN4eHwRlZDrglz0YxD3vxEUa/Sv1R4TqoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XIIDCSs5EqjMBHyKxmKDL9yXv+8UVv76rudeH2dBPvIZIL04ORboqjA4CWxFftEMpB59pgWRiJ9kf/Bl2lVVQyRnmiq/ctKvCH1VOp/LEwTl8BC+kc6NORo0YeIKytlh26azOf+97MTJ31KSfDxuYQGhTuH57rR5pAqQbzVeu9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Z4gXsOdE; arc=none smtp.client-ip=74.125.224.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Z4gXsOdE"
Received: by mail-yx1-f98.google.com with SMTP id 956f58d0204a3-66c71239c48so6408557d50.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787660040; x=1788264840;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OzUKV3GZAkjBgEmjQ7qTz3QzJqxoxWQzTbZllMeNGRo=;
        b=pKiMZfNTitw6OZH13hjYnlDve9ChzdsbK2THRxYkCIw+lJDgLbiAfr9x+qzxU0n+qL
         ++to9N3M4nnbNnjPXSBo291eDv6wcZUrrVUWIy0TjP7YvwsgRX90S3oQUWjToaelGMe5
         1MHxM9rru6mLQm3axtZN7Y9b3fRhqIaBikPuODagjF5vyoNXsyJN+0kQzAqc94pekfb2
         TaCRh8YoGtZ53tWXGXuOM7cb81RJUUzaFTpshxRr89pSOzlA/mMBRS69ljpHKgREtwho
         BOIABoEqRkj93gXoA3qyL1OUDgwKy3+ih+qyCRPrSh1U5Kv9PekkKgfrznKqaLHBez2Y
         Z7BQ==
X-Gm-Message-State: AFuF++kcJ8XgOv1Uyp529RV2+IKb5xIjLvgDqfqdGiPfpGF1/sep/FjG
	V87RYq10a1PYFUfQFBUZYnYxrteUGIvI3jgIcQfkElphZBe838xYPsMVFGHWhhpKTS4n67GMd17
	fhnSundR9aW3pEYC963ihNC2MV8A+zMXMXv7xZoTSwwpjPq982kwWSBS8sT8vEvjqm1DUdLbRd7
	HqRY2LWoZOjhJ0XdsFF0sw+T3zHKC33U4iXCwOQp8aCGze/ac432L48e+Fsj6COBkQlV2Ub+RnY
	X/Ec1147G4tqbHkII8X3rMB
X-Gm-Gg: AR+sD11Kr+PRtMjW+SnR7MpshaSJi7vRcr80/5a4MEZxbGo/ifGgtyCN2dvGcFnfKBq
	EgnLbTKxbHHm6fA5vwogTqFWHlflmhA+yA5UfDO/sJf25MlxdFisOuZn3h0u8ggGRaPSot141zo
	TH3KLDmriE90F6HZfvLMsUYLjVtSVhHptrYfTmgQFwqnqz2F4yntG+584mK6YKWykeTj6ZoojV+
	6QjoHnsk4uPy81YMfeuUhx2N3RZrzJLVBDj+e9CdIyphWLf/8/ShisDGFWADEV9tpf3pYqfx3wX
	0DW/Y3FSro/Z5UeCVxgbGoxT0/XzeuY3aMFxCmcSWPglvYnsAuxuMA6ZJARMKDLDer+Nwxw2IdG
	tSNIYDjFnLl2kbyj3OS5HKJ+m44FxcuUqjUG3ud0ZtoAEGjC+3TPfEmeuHfolSYX0E0wEH7VBOI
	Gfc7dkuVntvXNuO4+5PexOvHQgdHgHB9Zq9WnPldp/ez4=
X-Received: by 2002:a53:e642:0:b0:66c:cf0e:d9d3 with SMTP id 956f58d0204a3-66ce4a4214amr9680186d50.23.1787660039679;
        Tue, 25 Aug 2026 05:13:59 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-66cf49ec517sm66073d50.18.2026.08.25.05.13.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:13:59 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15f4732dfaso152698666b.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787660038; x=1788264838; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OzUKV3GZAkjBgEmjQ7qTz3QzJqxoxWQzTbZllMeNGRo=;
        b=Z4gXsOdEf8QcV4hfrE+Z/e42NLzejNl9muQ7PONVUO0g8/hupfQsYvYmR57E7eR2WJ
         qIjg1OL4MJW9bUuMnuuX0RVbqBkZUhwRVt2KQxIl90YgA3s/DLL0FTg/6XEuaGj2gBDY
         SSiMoeCHoU6Ag4cOiGApe48/LvAVKSzyvbhTg=
X-Received: by 2002:a17:907:72c4:b0:c24:4128:c19f with SMTP id a640c23a62f3a-c2491e838dcmr3144572166b.11.1787660037828;
        Tue, 25 Aug 2026 05:13:57 -0700 (PDT)
X-Received: by 2002:a17:907:72c4:b0:c24:4128:c19f with SMTP id
 a640c23a62f3a-c2491e838dcmr3144560366b.11.1787660037107; Tue, 25 Aug 2026
 05:13:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-11-chandrakanth.patil@broadcom.com> <20260818181045.7CBF71F000E9@smtp.kernel.org>
In-Reply-To: <20260818181045.7CBF71F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:43:44 +0530
X-Gm-Features: AcwNN1UTq6wJv08bfjrK9RzwoxMPphpXriGAnLWliGSFxCINI_cq8Fu9mwi7JSg
Message-ID: <CABvwm=OQ252QjjQP3E7kUCcguzuFpC5DAbFmiCJnpeY4Lf27ng@mail.gmail.com>
Subject: Re: [PATCH 10/17] mpi3mr: Fix out-of-bounds read in SAS topology
 change events
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000090e6840659de09d6"

--00000000000090e6840659de09d6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:40=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Missing bounds checking in PCIe topology change event handlers.
> - [High] Incomplete fix: early return in SAS top-half bypasses bottom-hal=
f cancellation.
> - [High] Event data length is unbounded by host DMA buffer size.
> --
>
> --- Patch [10]: [PATCH 10/17] mpi3mr: Fix out-of-bounds read in SAS topol=
ogy change events ---
> commit bab975c5553e402733c8341f728b4c3f336df543
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: Fix out-of-bounds read in SAS topology change events
>
> The number of entries in a SAS topology change event is used to walk
> the entry array without being compared against the amount of event data
> that was received, so the walk can run past the end of the buffer.
>
> Work out how many entries the payload can hold and skip the event if it
> claims more.
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3=
mr_os.c
> > index b18e7ea873030..1291c60b4d98c 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
>
> [ ... ]
>
> > @@ -2819,11 +2819,26 @@ static void mpi3mr_sastopochg_evt_th(struct mpi=
3mr_ioc *mrioc,
> >       struct mpi3_event_data_sas_topology_change_list *topo_evt =3D
> >           (struct mpi3_event_data_sas_topology_change_list *)event_repl=
y->event_data;
> >       int i;
> > -     u16 handle;
> > -     u8 reason_code;
> > +     u16 handle, avail_len;
> > +     u8 reason_code, max_entries;
> >       struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> >       struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data =3D NULL;
> >
> > +     avail_len =3D event_reply->event_data_length * 4;
>
> [Severity: High]
> This is a pre-existing issue, but does event_reply->event_data_length
> need to be validated against the host DMA buffer size before being used?
>
> Since event_data_length is provided by the firmware, if it exceeds the
> hardware DMA reply frame size (mrioc->reply_sz), could this calculation
> artificially inflate avail_len and defeat the bounds check?
>
> Also, looking at mpi3mr_os_handle_events(), this unvalidated length
> appears to be used for a memory copy:
>
> mpi3mr_os_handle_events() {
>     ...
>     sz =3D event_reply->event_data_length * 4;
>     fwevt =3D mpi3mr_alloc_fwevt(sz);
>     ...
>     memcpy(fwevt->event_data, event_reply->event_data, sz);
> }
>
> Could this result in an out-of-bounds read from the DMA reply frame pool?
>
> > +     if (avail_len < offsetof(struct mpi3_event_data_sas_topology_chan=
ge_list, phy_entry)) {
> > +             ioc_err(mrioc, "SAS topology event: event data too small =
(%u bytes)\n",
> > +                     avail_len);
> > +             return;
>
> [Severity: High]
> This isn't a bug introduced by this patch, but does returning early here
> leave the bottom-half handler scheduled with unvalidated data?
>
> In mpi3mr_os_handle_events(), the bottom-half scheduling flag is set
> before the top-half runs:
>
> mpi3mr_os_handle_events() {
>     ...
>     process_evt_bh =3D 1;
>     mpi3mr_sastopochg_evt_th(mrioc, event_reply);
> }
>
> If we hit this early return (or the one below), process_evt_bh remains 1.
> When mpi3mr_sastopochg_evt_bh() subsequently runs, it will iterate over t=
he
> unvalidated event_data->num_entries, potentially reading out-of-bounds.
>
> Should this function clear the bottom-half scheduling flag or return an e=
rror
> code when validation fails?
>
> > +     }
> > +     max_entries =3D (avail_len -
> > +                   offsetof(struct mpi3_event_data_sas_topology_change=
_list, phy_entry)) /
> > +                   sizeof(struct mpi3_event_sas_topo_phy_entry);
> > +     if (topo_evt->num_entries > max_entries) {
> > +             ioc_err(mrioc, "SAS topology event: num_entries(%d) excee=
ds max(%d)\n",
> > +                     topo_evt->num_entries, max_entries);
> > +             return;
> > +     }
> > +
> >       for (i =3D 0; i < topo_evt->num_entries; i++) {
> >               handle =3D le16_to_cpu(topo_evt->phy_entry[i].attached_de=
v_handle);
> >               if (!handle)
>
> [Severity: High]
> This is a pre-existing issue, but should a similar bounds check be applie=
d
> to the PCIe topology change events?
>
> Looking at mpi3mr_pcietopochg_evt_th() and mpi3mr_pcietopochg_evt_bh(),
> both handlers blindly iterate over the variable-length port_entry array
> using the unvalidated num_entries provided by firmware:
>
> mpi3mr_pcietopochg_evt_th() {
>     ...
>     for (i =3D 0; i < topo_evt->num_entries; i++) {
>         handle =3D le16_to_cpu(topo_evt->port_entry[i].attached_dev_handl=
e);
>     ...
> }
>
> Could a maliciously large num_entries provided by a device cause an
> out-of-bounds memory read here as well?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D10

Thanks for the review.

New issues:
- None. This patch specifically bounds the num_entries iteration count
in SAS topology change events against the received event data payload
length.

Pre-existing issues:
- The event_data_length check against reply_sz is addressed in
"mpi3mr: Fix out-of-bounds read of event data" in this same series.
- The PCIe topology change event bounds check is addressed in "mpi3mr:
Fix out-of-bounds read in PCIe topology change events" in this same
series.
- The top-half early return behavior and bottom-half event handling
structure are pre-existing in the driver design and will be addressed
in a
  separate follow-up patch series.

--00000000000090e6840659de09d6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
tJVewHuOmXgWQxNWV7Oiszu1d9xAcqyj65s1PrEIIaHnxEM3eTK+teecLEy8QymZjjDTrCHg4x36
2AczdlQAIiq5TSAucGja5VP8g1zTnfL/RAxEZvLS471GABptArolXY2hMVHdVEYcTduZlu8aHARc
phXveOB5/l3bPqpMVf2aFalv4ab733Aw6cPuQkbtwpMFifp9Y3s/0HGBfADomK4OeDTDJfuvCp8g
a907E48SjOJBGkh6c6B3ace2XH+CyB7+WBsoK6hsrV5twAXSe7frgP4lN/4Cm2isQl3D7vXM3PBQ
ddI2aZzmewTfbgZptt4KCUhZh+t7FGB6ZKppQ++Rx0zsGN1s71MtjJnhXvJyPs9UyL1n7KQPTEX/
07kwIwdMjxC/hpbZmVq0mVccpMy7FYlTuiwFD+TEnhmxGDTVTJ267fcfrySVBHioA7vugeXaX3yL
SqGQdCWnsz5LyCxWvcfI7zjiXJLwefechLp0LWEBIH5+0fJPB1lfiy1DUutGDJTh9WZHeXfVVFsf
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGpzCCBI+g
AwIBAgIMAgfxQ1Z7DrZKmCE/MA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI1MDYyMDEwMzUwNFoXDTI3MDYyMTEwMzUwNFowgekxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEOMAwGA1UEBBMFUGF0aWwxFTATBgNVBCoTDENoYW5kcmFrYW50aDEWMBQGA1UEChMNQlJP
QURDT00gSU5DLjEoMCYGA1UEAwwfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTEuMCwG
CSqGSIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAJwyF5qSHwwr1zJWkKvkMnY7V/sVFYYjTpjgxS4XA76pD6eLsZvS
4J73HkKSNEzORxBE7OyZSnuBJ9zeeRcypuItG9YrHm+0OSF0psIWsH15FBYJ0nvsUnlFbCSNvOdr
Co0WJ1KTe/7caj014uRZM2j7zH1vC+9fjEgrJdDRZakZXarl8M7k9okvVj1N+EuHiYUMvsAuMadE
a3p31Z6QdvMpr+30UdJXHshV1mXca+UBpCx26GbY6NgxhHM2LtHiaCK8Vn4HMofDkFg4nQ6eK4ai
uCiTtPj5aNlkdpcCzcZ+j1eCu6ZfPIq2ycwDaHi8d6Dwcgm+XoxDmD97Ehp2FOkCAwEAAaOCAeMw
ggHfMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggr
BgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1l
Y2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2Ny
NnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGg
MgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5
LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWlt
ZWNhMjAyMy5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTAT
BgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNV
HQ4EFgQUyqNnwId/JCbRPslVl3nm48YRek0wDQYJKoZIhvcNAQELBQADggIBAKPmllSh8cRXzNRs
3OATCVDgrdOfIsZMB9UVXcYQ+HtR1fu9bafeyuuupF9gcCmi+onLsANYRKaEDjC8h+V5FMAgm6TI
bww4EFGpWvP/XEVKrpcpMkYNMLw89lagx9ZZDhx9DmfQMI9gG9MPpCkSMEPnJvEs7gqtOo08aL1+
ts10tGfePsHF/I42Da21hJIJ01XN+Z91y//1cJkHwCBvDmoB8gdMXp3g4sjzahTxRZ25BdZB9W+n
0jfWJXFKtp9MYS1SaVo17usfrlTeyaH3zPyDvfAfGoLB5+i8vyVL6wta2vgVpfsL9iwhbJnAIxr+
ljECWkh1weDJw3UnV6nooG1RztnwqbG4eAG/KSCToXgVH9qSDv5S1lve5mvhv9AHzLjGLs+QtMeg
WEdMM4G0PWyibzGgNrmVgKaLjV6EMo/IZW7KjBtvjyKQZhes90D4GyxXv+/mrTo2rruz53+FoSc/
nuyLmg/SxnnZRaf7JGHFvu0IbwkeINwdHynAanOg9AD4zits7k7jjQ0fwIdhCaoRA3ao7PXUL1t8
LfSp/K5DCYsrXNqitPmQaAAGAiG4d4WDxBev6vtoyH7ejLcuCKkxCefrLO5qYnuDHsMNCObdslAe
tMVer+USn6AqB//6EwmqdiLr4o20UQ79jxNFMAEKdwyNkA8mVCVUAtTe3mPrMYICVzCCAlMCAQEw
YjBSMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xv
YmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0EgMjAyMwIMAgfxQ1Z7DrZKmCE/MA0GCWCGSAFlAwQCAQUA
oIHHMC8GCSqGSIb3DQEJBDEiBCCWC7DlnV0yN71WpDDaWDCbBtCqgbTDAyN1sHQt3eDybDAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjEzNThaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBCzJJ/cwka
mqEmfwv+wgUhYVXEjynjLzXz3D2BTI8UQfpKOCt/PGd9Yx6cHjd29SzBLi1yfYl0jnw7X+w9rhOj
5Gt2Nhh6IjrjyzCsdVdhf6Ppms9iefPhnhnOkOuAxvy1Kmdm1iPYzAxV1JYMYklG0msuNnk2cGE1
j8WXeZ+ub48FFpCJ9S5RuZ2al6pJvbKBKcEQB4KlSyIqFci4bpHvijPijzbp8zNxgxL5vXwWS3s8
Zn5uCb7fuuRY92KF+5MDptSjfN4cxRZyRcJYsolDos4DcXUuXfMlg8eYY9OXK+os8Zc1phnHJ46N
HRcuQZ8OEY+TPHWA94PgJgQVNjxz
--00000000000090e6840659de09d6--
