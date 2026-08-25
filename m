Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCFD222599
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787660138; cv=none; b=tXfs2wA2ieFkmdisEKno1Mv/nTZHMDyD/3u0OzwgVQTbXQ47wDWvFJMSfxQub5+E2+5xx+nrCRr8RKdt2DtTxrtJgHyAN/dGk6+4NB/LT7yK2Wz48Tg0P0KaVk67OSGU4Zo+qYkNxO+pbyEJ5NBC8sDK6719/8xJVlPiqddvo9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787660138; c=relaxed/simple;
	bh=tPI25LBbzEUlVY4G6iSxo4xndETr23r78k973ETS/Kw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KkJp8HxjY0N0KSATvkfLatVHxDGAbL6q2MsCd905NhEOn8azGT8ayzEyNe/3fjYTOltXSWEayYr95Mh3cxV41TI6neP0no9JA6wQE9v0hboz0KWqvpXaf6HWnQBi1Os5Fdx7xiNzcOFinw1bkS/SDvrdM2ENsPs3TrMyeEww0dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ta5q76yH; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ta5q76yH"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-39647184c73so703537a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:15:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787660136; x=1788264936;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HhvMWehaYarF1fHcwJryLLOMmkaUKt8qKV303hVFQvY=;
        b=LQ/PYoEcHN8VksCnzc7Uv2XdRfdP8GaAscdqb3jzBEWePIxfKhe7zWC/VMDWovLtxC
         YoyR/PDTHHAd5q2OZvoi9p1BUTEr+QfTNPuD5bvQ550UX3td4w7T6fDDBnBRmtb4lcNP
         wz7sOjwsFB2J8Qr1JNx0WW1kaOexrFAmt3pQz5OW6h4IFSap2K5QBtFhY9a6trNi4T7y
         Ypq+1qHiGHJiIXbOl7AC8EEY8sybAUb9Hnloh194hZHgVuaMyId7DkKxWiQRTlrCuuHE
         34PHoKpKwjM7jljOFvvebJ+8YuyB++VEDRfC92vVr73zOiUefWftwKmguC4BYlrQ9GJe
         y2og==
X-Gm-Message-State: AFuF++nlUhVqiEN1XiRU90OAKsgrWsUD2oecn7hi2id7qU9Xp1Ao+i2b
	z7QbmABEHfIgr+V7A0q8u94PcNfGtGNFzN5SE5eQHtXSbQ7/FlBC6WbQbCSOjZx3NTA7gcN6WP/
	wl8HpVOtW4N9xGY72HbzUL+chglQd2Jc8HI/Il7tHnwo/d6V56Eh1MldQTQa6VKbBRplgYgwxbd
	+8t7WGRlygSZj3cvpTpZZ5uhpmvAsnLqdJ9q8JjigsHr3MomA72d8QhK278HD9vj0a3NlINJAbH
	JLVurUg56yLdZJAykj2giZS
X-Gm-Gg: AR+sD10lOv7XQmF61PAP4lIauVMxWPuhnoRxV5ZhYzw07r1nHED+U1RlM1XRt9Mx7lF
	8JyScLF+BiapJB+olN2jSVXuXp+5ukDChEbqLMR0+nM1ZnA0OZG4zhwPah8Mf21MO2EduWDOzPV
	MqUDftP2bf+18xwHI+yyRyt9h7V7LcRv2JkltuOLPWCgaLJ5GmS3oMXRFcXD5w1saV4DIv6YzrS
	gTWoWn5itDiTPs/Fqmu6bkY2n3g5J7Bd7jHXdIEOGqidy8T0GHZkk5pKYO57LCkXmBB6+LEMXAu
	1YQghKewypSVwvHGBTPOtWnnkxc9VAoAmX8ct0JJylxi2M2F+7hFuw+rtNC6cF+37sGzWno4TzI
	BIjm+9zs+4+hnEtTicDHGSUErAwXmjZV9PRbtPtxJb4gWTLghhSvwi+CrAl7QC6NG93frX7n2CG
	lS2XlXs4zI071RcCDQg68BLvMcExqeTcy5K3WUOckUmrI=
X-Received: by 2002:a17:90b:4b42:b0:390:84db:888e with SMTP id 98e67ed59e1d1-39645b1c818mr6325464a91.7.1787660135786;
        Tue, 25 Aug 2026 05:15:35 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39645a4b71bsm1311670a91.3.2026.08.25.05.15.35
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:15:35 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c1630a90890so327005166b.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787660133; x=1788264933; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HhvMWehaYarF1fHcwJryLLOMmkaUKt8qKV303hVFQvY=;
        b=Ta5q76yHeqVBWl1qTmT1/dzV2YDmXAocUzPvowCR3d+T/0tlO+f4/gILDByOvezEPF
         WYzUyNvTdhD8K3U9MJpM2M8gadpBM3xBSOtHuKMkIX8UWLUvOVU9+cFv1+ElmbF54OND
         MAXuJSx0OYaBCY9TDltkQ2Q7ZAMOeGRHa5W+0=
X-Received: by 2002:a17:907:3d4e:b0:c20:1bc5:7002 with SMTP id a640c23a62f3a-c246a4ad6abmr3940787766b.3.1787660133500;
        Tue, 25 Aug 2026 05:15:33 -0700 (PDT)
X-Received: by 2002:a17:907:3d4e:b0:c20:1bc5:7002 with SMTP id
 a640c23a62f3a-c246a4ad6abmr3940775666b.3.1787660132791; Tue, 25 Aug 2026
 05:15:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-12-chandrakanth.patil@broadcom.com> <20260818181602.2719A1F000E9@smtp.kernel.org>
In-Reply-To: <20260818181602.2719A1F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:45:20 +0530
X-Gm-Features: AcwNN1Vj3-x4W8uyf0ZQ0D-GhLSmLG_9lfaEMri9xwMdLkB88szqvGzTvwlvjIc
Message-ID: <CABvwm=McLhOrzxvQAbYRu0Ex8Biiyo0XB8vQQyyufxVdwbFKsg@mail.gmail.com>
Subject: Re: [PATCH 11/17] mpi3mr: Fix out-of-bounds read of event data
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000004306040659de0f70"

--0000000000004306040659de0f70
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:46=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 4 potential issu=
e(s) to consider:
>
> New issues:
> - [High] Bottom-half event handlers perform out-of-bounds heap reads on t=
he `fwevt` buffer because they trust unvalidated loop bounds against the ne=
wly clamped allocation size.
>
> Pre-existing issues:
> - [High] Top-half event handlers perform out-of-bounds DMA reads on the r=
eply buffer due to missing or flawed bounds checking for variable-length ar=
rays.
> - [High] `MPI3_EVENT_DEVICE_INFO_CHANGED` incorrectly falls through to `M=
PI3_EVENT_LOG_DATA`, silently dropping events and bypassing its required bo=
ttom-half processing.
> - [High] Accessing a potentially freed work item during event cleanup via=
 `cancel_work_sync`.
> --
>
> --- Patch [11]: [PATCH 11/17] mpi3mr: Fix out-of-bounds read of event dat=
a ---
> commit 4872e2f7b284da8f062de528f26e6b6482b6a169
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> Subject: mpi3mr: Fix out-of-bounds read of event data
>
> The commit clamps the event data length read from the reply to what the
> frame can hold. This prevents out-of-bounds reads when caching log data
> and when sizing the buffer allocated for the bottom-half event handlers.
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3=
mr_os.c
> > index 1291c60b4d98c..68b13c2ad2244 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -3170,7 +3170,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *=
mrioc,
> >       case MPI3_EVENT_DEVICE_INFO_CHANGED:
> >       case MPI3_EVENT_LOG_DATA:
>
> [Severity: High]
> This is a pre-existing issue, but does MPI3_EVENT_DEVICE_INFO_CHANGED
> intentionally fall through to MPI3_EVENT_LOG_DATA without setting
> process_evt_bh =3D 1?
>
> Because process_evt_bh is not set, the bottom-half handler is completely
> bypassed, leaving mpi3mr_devinfochg_evt_bh() as effectively dead code:
>
> mpi3mr_fwevt_bh() {
>     ...
>     case MPI3_EVENT_DEVICE_INFO_CHANGED:
>     {
>         dev_pg0 =3D (struct mpi3_device_page0 *)fwevt->event_data;
>         perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
>         if (perst_id !=3D MPI3_DEVICE0_PERSISTENTID_INVALID)
>             mpi3mr_devinfochg_evt_bh(mrioc, dev_pg0);
>     ...
> }
>
> Will this cause the driver to fail to process queue depth changes for tar=
get
> devices?
>
> > -             sz =3D event_reply->event_data_length * 4;
> > +             if (mrioc->reply_sz > offsetof(struct mpi3_event_notifica=
tion_reply, event_data))
> > +                     avail_reply_room =3D mrioc->reply_sz -
> > +                         offsetof(struct mpi3_event_notification_reply=
, event_data);
> > +             else
> > +                     avail_reply_room =3D 0;
> > +             sz =3D min_t(u16, event_reply->event_data_length * 4, ava=
il_reply_room);
> >               mpi3mr_app_save_logdata_th(mrioc,
> >                       (char *)event_reply->event_data, sz);
> >               break;
>
> [ ... ]
>
> > @@ -3204,7 +3209,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *=
mrioc,
> >               dprint_event_th(mrioc,
> >                   "scheduling bottom half handler for event(0x%02x) - (=
0x%08x), ack_required=3D%d\n",
> >                   evt_type, le32_to_cpu(event_reply->event_context), ac=
k_req);
> > -             sz =3D event_reply->event_data_length * 4;
> > +             if (mrioc->reply_sz > offsetof(struct mpi3_event_notifica=
tion_reply, event_data))
> > +                     avail_reply_room =3D mrioc->reply_sz -
> > +                         offsetof(struct mpi3_event_notification_reply=
, event_data);
> > +             else
> > +                     avail_reply_room =3D 0;
> > +             sz =3D min_t(u16, event_reply->event_data_length * 4, ava=
il_reply_room);
> >               fwevt =3D mpi3mr_alloc_fwevt(sz);
>
> [Severity: High]
> Does clamping the allocation size here introduce an out-of-bounds heap re=
ad in
> the bottom-half handlers?
>
> The patch correctly limits the allocation of fwevt to sz, but the payload
> copied into it can still contain an unmodified, untrusted num_entries fro=
m
> the firmware.
>
> When the bottom-half worker executes, won't it iterate up to num_entries,
> reading past the end of the strictly clamped fwevt allocation?
>
> mpi3mr_sastopochg_evt_bh() {
>     ...
>     for (i =3D 0; i < event_data->num_entries; i++) {
>         handle =3D le16_to_cpu(event_data->phy_entry[i].attached_dev_hand=
le);
>     ...
> }
>
> Can this lead to an out-of-bounds read on the kernel heap?
>
> [Severity: High]
> This is a pre-existing issue, but does mpi3mr_pcietopochg_evt_th() also
> lack proper bounds checking before looping over num_entries?
>
> It iterates directly based on the untrusted num_entries:
>
> mpi3mr_pcietopochg_evt_th() {
>     ...
>     for (i =3D 0; i < topo_evt->num_entries; i++) {
>         handle =3D le16_to_cpu(topo_evt->port_entry[i].attached_dev_handl=
e);
>     ...
> }
>
> Similarly, in mpi3mr_sastopochg_evt_th(), the bounds check relies on
> the unclamped event_data_length instead of mrioc->reply_sz:
>
> mpi3mr_sastopochg_evt_th() {
>     avail_len =3D event_reply->event_data_length * 4;
>     ...
>     max_entries =3D (avail_len - offsetof(...)) / sizeof(...);
>     if (topo_evt->num_entries > max_entries) return;
> }
>
> Will this result in out-of-bounds DMA reads during top-half event process=
ing if
> the firmware sends an erroneously large event_data_length?
>
> [Severity: High]
> This is a pre-existing issue, but is there a use-after-free risk during
> driver cleanup?
>
> In mpi3mr_cleanup_fwevt_list(), current_event is read locklessly and pass=
ed to
> mpi3mr_cancel_work():
>
> mpi3mr_cleanup_fwevt_list() {
>     ...
>     if (mrioc->current_event) {
>         fwevt =3D mrioc->current_event;
>         ...
>         mpi3mr_cancel_work(fwevt);
>     ...
> }
>
> Concurrently, the worker thread can drop the reference count and free fwe=
vt
> before clearing mrioc->current_event:
>
> mpi3mr_fwevt_bh() {
>     ...
> out:
>     mpi3mr_fwevt_put(fwevt);
>     mrioc->current_event =3D NULL;
> }
>
> Could mpi3mr_cleanup_fwevt_list() pass a freed fwevt pointer to
> cancel_work_sync(&fwevt->work)?
>
> >               if (!fwevt) {
> >                       dprint_event_th(mrioc,
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D11

Thanks for the review.

New issues:
- The bottom-half event handlers trusting num_entries without
validating against the copied fwevt size is a pre-existing structural
issue in the bottom-half event processing logic.
  This patch specifically fixes the top-half out-of-bounds read by
clamping event data size to avail_reply_room, preventing memcpy() and
mpi3mr_app_save_logdata_th() from reading past
  the end of the reply buffer. Bottom-half payload validation will be
addressed in a separate follow-up patch series.

Pre-existing issues:
- The MPI3_EVENT_DEVICE_INFO_CHANGED fallthrough, top-half DMA bounds
checks, and cleanup race condition in mpi3mr_cleanup_fwevt_list() are
all pre-existing issues in the driver and
  will be addressed in separate follow-up patch series.

--0000000000004306040659de0f70
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
oIHHMC8GCSqGSIb3DQEJBDEiBCCPM/Yr0IepwKzTf9eCJCTF7i+XuMZyk8ZnrXo6VhD+TTAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjE1MzNaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAdIOphxkgK
Iahe0nE3eGktTKlhjO164NoCVL2FjL+c1ouPqV8yCDnPjs6A3vAk3djuG/AmZ9ixUqEDsWrHSohW
2IcmIkNnJ86mEqFZn3LX0dko5usxL9ll4bXkVIY+qmsotC5y5KzTNwcvR8SVZwVwc8TLqbB4I5iA
bpEjjS5+Y5ChjKdLHgbJmCA9fJO8IuLXLn9oJetCoixG7ARRKps/4cGaxIk2EDusvyi+N+Z5xX4S
UAqcH9W8rAy2HMVkZQG9vtajSJaoxe3crf1kG2nmgpy8hu5LCuMnvzlrpeYKtrsS8Lrbd0TKRGy6
TFOj/Ec9K4beOn6luhHxvWjlVum7
--0000000000004306040659de0f70--
