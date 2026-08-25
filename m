Received: from mail-pf1-f227.google.com (mail-pf1-f227.google.com [209.85.210.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1053DA7D9
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787660296; cv=none; b=pRFihQJnemlJREeXwHUKyScRxhItVHB9F0uTkAPg0ReaqzmV/ZNgc6Xsy8kB20pzcb4QStetRKo1btw9+jXqUapk4d6N+yVxnwHznF91CgeCftm+o0gmfnb5ft88/JIFuYeQg+X0rNunNUPASy4uUGt8KPrZn1lOFSJAPEAHs9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787660296; c=relaxed/simple;
	bh=Sx9FwfWQJu77q/p9ytKRZxVjjtef6eYI45tqGLRtads=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N02s4IhhWT5mtJUsBgkq0jA1NtPQqSaAuVJUN0BUbeAweqUlZ1cUrPUCvdX3PNDnzR+iXtWirq0aJQqHbKB3fULm9/DaMCo+gfYTdGAI6IqOijB97AfRpuxB4g0/CjaMvVchEumCoAoI4IXaUSVMos2JbuQR+96Cb/qOPhW+wY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=K0qs8AcK; arc=none smtp.client-ip=209.85.210.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="K0qs8AcK"
Received: by mail-pf1-f227.google.com with SMTP id d2e1a72fcca58-84faf87d19dso4490241b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787660294; x=1788265094;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tLTIdKdpiYUwiG6K5UXOoRvzn3RPKuIEtOMCR/cx/x4=;
        b=j1/9xcb9tloA6MMqFy5tTbTSsOrwp6Tf7+pD+K/FEyUNIMHTYCR2zIgwFmBP+yMn0s
         GLkSZ7PENxUm1rM+GPZemP9/BxoanXnNVIiETcyyFmKCgVNZXAwh8YV+73F/2lNP5qMa
         6RHROFHmVCJyw8mQLDBVzajzZXYR9i+Ib6tnZgvAATwlv3SRCJRrgSK/aEAU7wmBZDHn
         m/MvCe0aSL/GLr4pyVJo3iRRBI5QPjAWxXVjElwcsYqJArm/dH03VzU9F00zGdm/3sVn
         nbvWjhP30Ac0ot4R/m5VhUR6dxEX0v1mVK+n7xo/DeSn6BwpInSZmyEvCK4p34NR0Yz/
         hUrg==
X-Gm-Message-State: AFuF++lhXdq/riIEjjLUL6LSLM/v/DmZcc6kzPet6MmpefsxhYgHJrYd
	u3Mul2v6UqSCkQxhHrXLVtzMl/BZ6Ui/fuGhE2ae+4MRx7eguWlQPE8AdXpa7fyhaIX8jR5e5eL
	b3fTi2iDOdnUGDP2fj09p7NBKYUVojKNB1LOimArLb//Won3tQP7D6WGhgL7fI8izaHrZuxnJXw
	2fstNlPFjQlMRJrIAem/zCDnjDvcrDtfnBJGs1ieeXhaHI7djgJT77ELaku/8EhPYortaKwEwHM
	BSNqZJpQWPL+0HyFkQQmTcn
X-Gm-Gg: AR+sD11L4p5HnumU68diniZUHDulXFGqMGq/RBIgQ4P4TIH5+H5+5PABRhZwbQMiNnG
	bSyARQFqsODNZ0wWA6vz8+R+FqOLTnWWDCBhqyrtGZzHa1Mki7bMv5RowH7vicpyquIRAPYS8t3
	6y5UWQ7MoYVzFWbdryTb+mhszTYhC/2wkc/PQ6hI3TXN8ci8hMSTdOOYpP7Apa8vKnMHNdZVH7T
	bswcf1oNwFsGy7b9K57TKhyp53DD6yYYNh0t36h1mVuzpfY9XFcpW2DSazVkb8mCoCpMMoHV5a9
	h/ZtkfLDlWNagoatfxHNJRdeH1ipF6rqef8tiThtbg4HcbOZpfwYHzBBuvSUV6LiJcW/fdR+pH3
	THY47+D2XkVZj6sCs4MI1qhWVcQjycsrDdMYKOmw9zbw2GaX+eE71nJ6HSWF9zVkBQxAQyQDCyB
	aaJFfoAVJpQ6UwZIXQXhUlLdfBPRL7VFvYwxc/jCMT7GhB4Q==
X-Received: by 2002:a05:6a00:e1b:b0:84e:b7ed:7d50 with SMTP id d2e1a72fcca58-8520ba65912mr46111092b3a.16.1787660293439;
        Tue, 25 Aug 2026 05:18:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-85210950706sm4905510b3a.4.2026.08.25.05.18.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:18:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c1f3117bc6bso428743166b.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787660291; x=1788265091; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tLTIdKdpiYUwiG6K5UXOoRvzn3RPKuIEtOMCR/cx/x4=;
        b=K0qs8AcKOqiWi8+c+ljhTkCRI8ZBqbMznhN9p6qZGe4yGB5NWh5H6SfKxiBKBZrkky
         LEUMh7sYZ2cY/KbsDKegOCHXSAYKpPNnHTsqlUnuzTzn902ATe2lvAIu5tCvC8qFMLQz
         jOGooWA1lx/CeYcNd3vWNokdiv821/rEzAcxU=
X-Received: by 2002:a17:907:8995:b0:c24:4128:c19d with SMTP id a640c23a62f3a-c24e584dc37mr609648766b.4.1787660291033;
        Tue, 25 Aug 2026 05:18:11 -0700 (PDT)
X-Received: by 2002:a17:907:8995:b0:c24:4128:c19d with SMTP id
 a640c23a62f3a-c24e584dc37mr609639566b.4.1787660290381; Tue, 25 Aug 2026
 05:18:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-15-chandrakanth.patil@broadcom.com> <20260818182309.9BCE91F000E9@smtp.kernel.org>
In-Reply-To: <20260818182309.9BCE91F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:47:57 +0530
X-Gm-Features: AcwNN1XxWOS-t-cETKeYz4WuuGdacYiSrUAXp5lWX9Lwkr9YfULJaZMrwWQKTk8
Message-ID: <CABvwm=MxRTEjcrFBr33O5pnOhOwX_kezpPojgvFBynXnBQZ-Qw@mail.gmail.com>
Subject: Re: [PATCH 14/17] mpi3mr: Fix out-of-bounds read in PCIe topology
 change events
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000aa78540659de1833"

--000000000000aa78540659de1833
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:53=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 4 potential issu=
e(s) to consider:
>
> New issues:
> - [High] The newly added bounds check reads `topo_evt->num_entries` direc=
tly from a DMA-mapped buffer, and the subsequent loop condition re-reads it=
, creating a Time-Of-Check to Time-Of-Use (TOCTOU) race condition.
>
> Pre-existing issues:
> - [High] The bounds check for PCIe and SAS topology change events fails t=
o protect the bottom-half event handlers from out-of-bounds reads because e=
arly returns in the top-half do not prevent the malformed event from being =
queued.
> - [High] The bounds check uses an untrusted `event_data_length` without v=
erifying it against the actual physical dimensions of the hardware reply bu=
ffer, allowing an out-of-bounds read in the top-half handler.
> - [High] Missing `dma_rmb()` after polling the phase bit in DMA-mapped re=
ply descriptors, which can lead to processing stale descriptor data on weak=
ly ordered architectures.
> --
>
> --- Patch [14]: [PATCH 14/17] mpi3mr: Fix out-of-bounds read in PCIe topo=
logy change events ---
> commit 8553af34c1ff3c0cff0462ca66842979af8cb4d4
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: Fix out-of-bounds read in PCIe topology change events
>
> The number of entries in a PCIe topology change event is used to walk
> the entry array without being compared against the amount of event
> data that was received. Bound the entry count to the received event data
> before use.
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3=
mr_os.c
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -2753,11 +2753,26 @@ static void mpi3mr_pcietopochg_evt_th(struct mp=
i3mr_ioc *mrioc,
> >       struct mpi3_event_data_pcie_topology_change_list *topo_evt =3D
> >           (struct mpi3_event_data_pcie_topology_change_list *)event_rep=
ly->event_data;
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
> This isn't a bug introduced by this patch, but could this calculation
> exceed the actual physical dimensions of the hardware reply buffer?
>
> Because avail_len is derived strictly from the untrusted event_data_lengt=
h,
> a compromised or malicious device could provide a value larger than the
> allocated DMA reply buffer (mrioc->reply_sz).
>
> Should we verify event_data_length against mrioc->reply_sz to prevent
> the bounds check from being artificially inflated, which would lead to an
> out-of-bounds read?
>
> The SAS topology handler mpi3mr_sastopochg_evt_th() appears to share this
> exact pattern.
>
> > +     if (avail_len < offsetof(struct mpi3_event_data_pcie_topology_cha=
nge_list, port_entry)) {
> > +             ioc_err(mrioc, "PCIe topology event: event data too small=
 (%u bytes)\n",
> > +                     avail_len);
> > +             return;
> > +     }
> > +     max_entries =3D (avail_len -
> > +                   offsetof(struct mpi3_event_data_pcie_topology_chang=
e_list, port_entry)) /
> > +                   sizeof(struct mpi3_event_pcie_topo_port_entry);
> > +     if (topo_evt->num_entries > max_entries) {
> > +             ioc_err(mrioc, "PCIe topology event: num_entries(%d) exce=
eds max(%d)\n",
> > +                     topo_evt->num_entries, max_entries);
> > +             return;
> > +     }
>
> [Severity: High]
> This is a pre-existing issue, but does this early return actually prevent
> the malformed event from being processed by the bottom-half handler?
>
> When mpi3mr_pcietopochg_evt_th() returns early here, the process_evt_bh f=
lag
> remains set in mpi3mr_os_handle_events():
>
> drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_os_handle_events() {
>     ...
>         case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
>         {
>                 process_evt_bh =3D 1;
>                 mpi3mr_pcietopochg_evt_th(mrioc, event_reply);
>                 break;
>         }
>     ...
> }
>
> Since process_evt_bh remains 1, the event is queued to the worker thread.
> The bottom-half handler mpi3mr_pcietopochg_evt_bh() will then blindly
> iterate up to the unvalidated event_data->num_entries, causing an
> out-of-bounds read past the end of the allocated fwevt heap buffer.
>
> Would it be safer to clear process_evt_bh or return a status from the
> top-half handler to prevent queuing malformed events? The SAS topology
> handler mpi3mr_sastopochg_evt_bh() is likely vulnerable to the exact
> same incomplete fix flaw.
>
> >
> >       for (i =3D 0; i < topo_evt->num_entries; i++) {
> >               handle =3D le16_to_cpu(topo_evt->port_entry[i].attached_d=
ev_handle);
> >               if (!handle)
>
> [Severity: High]
> Is this loop vulnerable to a Time-Of-Check to Time-Of-Use (TOCTOU) race
> condition?
>
> The newly added bounds check reads topo_evt->num_entries directly from a
> DMA-mapped buffer, and this loop condition continually re-evaluates it.
>
> Because the loop body contains functions that acquire spinlocks
> (e.g., mpi3mr_get_tgtdev_by_handle()), which act as full compiler memory
> barriers, the compiler is forced to re-fetch num_entries from DMA memory
> on every iteration.
>
> If a malicious device alters num_entries in DMA memory after the initial
> max_entries check, could it extend the loop beyond bounds?
>
> Should we cache num_entries in a local variable before the bounds check
> and use the local variable for the loop condition? The SAS topology handl=
er
> mpi3mr_sastopochg_evt_th() appears to have the identical issue.
>
> [Severity: High]
> This isn't a bug introduced by this patch, but is a dma_rmb() barrier nee=
ded
> after polling the phase bit in the DMA-mapped reply descriptors?
>
> Looking at mpi3mr_process_op_reply_q() in drivers/scsi/mpi3mr/mpi3mr_fw.c=
:
>
> drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_process_op_reply_q() {
>     ...
>         if ((le16_to_cpu(reply_desc->reply_flags) &
>             MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
>                 atomic_dec(&op_reply_q->in_use);
>                 return 0;
>         }
>
>         do {
>                 if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
>                         break;
>
>                 req_q_idx =3D le16_to_cpu(reply_desc->request_queue_id) -=
 1;
>     ...
> }
>
> The driver polls the hardware DMA ring by checking the reply_flags phase =
mask.
> Without a subsequent dma_rmb(), weakly ordered CPU architectures (such as
> ARM64) can speculatively execute out-of-order reads and fetch the rest of
> the descriptor payload (like request_queue_id) before the hardware has
> actually committed the updated descriptor.
>
> Could this result in processing corrupted or stale descriptor payloads?
> There appears to be a similar polling loop for the admin reply queue in
> mpi3mr_process_admin_reply_q() lacking a dma_rmb() before accessing
> request_queue_ci.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D14

Thanks for the review.

New issues:
- The TOCTOU observation is valid and will be fixed in the v2
submission. num_entries is now cached in a local variable before the
bounds check and used for the
  loop condition to prevent re-fetching from DMA memory.

Pre-existing issues:
- The event_data_length check against reply_sz is addressed in
"mpi3mr: Fix out-of-bounds read of event data" in this same series.
- The top-half early return behavior and missing dma_rmb() memory
barriers are pre-existing in the driver and will be addressed in a
separate follow-up patch series.

--000000000000aa78540659de1833
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
oIHHMC8GCSqGSIb3DQEJBDEiBCBIr4g76/uHu3XAkd+UYwHeDLv+5chEU8aYPjKD2Flo1jAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjE4MTFaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAT9xW8gXAr
ojlKwV+GRQBpANbIvLujctBvAM0v/pgYbUA5Kah0apSIChWUOsy2ZB7aQhJhVkHVnOhaCeKI9oRT
yjAdfJXraHHbZqJnuFG+jWY8BzQfPgYPqm0Hwis/0jFj5k5049O0w2hS2NQP0b7e+AQUsmYxAVJ1
hawWW6L2o9uAlywjtlNkurJ3hFyOQxhkXWvHIBi+aTwy+qBySMTvqTNY86mnNiEVbLmZ9V0CepWq
7L7Nk4kyFGtCSEGC4+0W/hGz9y+XhulPo7sWb0JsSb+89q5uEmte/U/7RGB9BmyfVXruYV5EGg6n
zHAEeD+GaMI/PLT9mSz04WzLH/PU
--000000000000aa78540659de1833--
