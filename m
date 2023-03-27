Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648FAC761A6
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Mar 2023 18:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbjC0SkG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Mar 2023 14:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbjC0SkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2023 14:40:04 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B66C4480
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 11:39:54 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-545cb3c9898so112159057b3.7
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 11:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679942389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VpSWyRH9eMhLPnmDuLtpqQLSo6wJG2qakuBQ/6EgySE=;
        b=Q/oGiuSz/aIquLjojRc/Q9V9adA1Tqb62e7A6JPYkCWYQVLMddYVQWNnPSmEYN3Co4
         a87t1CpMT0xBTO6Av2e29gdh6sxH6dVECKXIGYnLsyL2J35UqePTQiDD+gRg80gqpMY3
         KONrh76ppcK47nCh6+jM8aT/VL++QhYbOEhqDWSpfkH4qjziNWYQMPgz+MTuz+1vWOYW
         iT7cAyhHQ3k/VOSZatqNjI5GEAqk8RD5+celCh/TUBAMxddnyvvr6niidvofsMn2cPxH
         BmLNj0Xq10hZAHI055ZiF7HhjsALGQCc9rHjQP1PxjBB44l8KYN13woBaxB35lVNANlj
         Li4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679942389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VpSWyRH9eMhLPnmDuLtpqQLSo6wJG2qakuBQ/6EgySE=;
        b=dqr3bBZvq6lj0TYJI5CfhMesC/Yg1hrMHd2K+qDnXTXysQupCTNucxkA/KAyREl1Hl
         /+GzhZqU35Lk2e8FHo3Aqk44rEoYYj9k6aDZQgeBCsFCbYK8EVvjHTHdeQNzQHuFceQT
         ceHuGEoilwFsx3bu97Y5OLxS/MMzJhGMkzkieO8iNGkYotKawioLmTpLOsAILlcHhm0v
         8X8xbkkqVU+THk+Xk+sz4d42VJbNZydYUOTvVIWjjPXW1GmeDG5IYOqKAOXGk3XniWHA
         bLA27imT558dmtfkeUk/7orHgFNQk5Q00/qzC5uBqkdPcLpooNjc1UP5bhqJhO2GK/oT
         QJ6Q==
X-Gm-Message-State: AAQBX9fx5bmavMjfOyHNx/p+lvNtU5m9NUDIepa1o+c82QKsssiDYPK8
        uXFhrjb1WJwOTbLwPdDZgiPGFsOoFYNxltFLK8g=
X-Google-Smtp-Source: AKy350Z5QgmQpmfIKEVRJMjBzJVazb7APyKRZfxNFqNVMQNV+E2Qhz0z10ZmjzM+9x9s93kb1BXaDuBm8ZuVj6pLErQ=
X-Received: by 2002:a81:ae23:0:b0:53c:6fda:835f with SMTP id
 m35-20020a81ae23000000b0053c6fda835fmr5749495ywh.0.1679942389231; Mon, 27 Mar
 2023 11:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230317015602.1748372-1-windhl@126.com>
In-Reply-To: <20230317015602.1748372-1-windhl@126.com>
From:   Justin Tee <justintee8345@gmail.com>
Date:   Mon, 27 Mar 2023 11:39:38 -0700
Message-ID: <CABPRKS9dqusoWNWSOE0B87VrrFR5JR9otydPVQRMRddXQCt-6A@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix potential memory leak
To:     Liang He <windhl@126.com>
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Liang,

@@ -1200,6 +1200,11 @@ lpfc_bsg_hba_set_event(struct bsg_job *job)
        spin_unlock_irqrestore(&phba->ct_ev_lock, flags);

        if (&evt->node =3D=3D &phba->ct_ev_waiters) {
+
+               spin_lock_irqsave(&phba->ct_ev_lock, flags);
+               lpfc_bsg_event_unref(evt);
+               spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+
                /* no event waiting struct yet - first call */
                dd_data =3D kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL=
);
                if (dd_data =3D=3D NULL) {

if (&evt->node =3D=3D &phba->ct_ev_waiters) was true, then that means the
ct_ev_waiters list was empty so the *evt ptr is not pointing to a real
lpfc_bsg_event structure.  I think we would even crash trying to
decrement evt=E2=80=99s kref because evt is an uninitialized lpfc_bsg_event
structure and not pointing to anything real.  We=E2=80=99re about to kzallo=
c a
new evt with lpfc_bsg_event_new in this same if statement clause
anyways.  I=E2=80=99m not clear on the reasoning behind the suggestion to c=
all
lpfc_bsg_event_unref(evt) there.


@@ -1292,6 +1297,9 @@ lpfc_bsg_hba_get_event(struct bsg_job *job)
         * an error indicating that there isn't anymore
         */
        if (evt_dat =3D=3D NULL) {
+               spin_lock_irqsave(&phba->ct_ev_lock, flags);
+               lpfc_bsg_event_unref(evt);
+               spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
                bsg_reply->reply_payload_rcv_len =3D 0;
                rc =3D -ENOENT;
                goto job_error;

Similar argument here.  If (evt_dat =3D=3D NULL) was true, then that means
there was nothing of interest in the ct_ev_waiters list or that the
ct_ev_waiters list was empty.  In either case, we shouldn=E2=80=99t call
lpfc_bsg_event_unref(evt) because we would be decrementing the wrong
reg_id evt=E2=80=99s kref or even crash if the ct_ev_waiters list was empty
trying to kref_put an uninitialized lpfc_bsg_event structure.

Regards,
Justin

On Thu, Mar 16, 2023 at 7:02=E2=80=AFPM Liang He <windhl@126.com> wrote:
>
> In lpfc_bsg_hba_get_event() and lpfc_bsg_hba_set_event(), we
> should keep the refcount balance when there is some error or
> the *evt* will be replaced.
>
> Fixes: f1c3b0fcbb81 ("[SCSI] lpfc 8.3.4: Add bsg (SGIOv4) support for ELS=
/CT support")
> Signed-off-by: Liang He <windhl@126.com>
> ---
>  drivers/scsi/lpfc/lpfc_bsg.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index 852b025e2fec..aa535bc14758 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -1200,6 +1200,11 @@ lpfc_bsg_hba_set_event(struct bsg_job *job)
>         spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
>
>         if (&evt->node =3D=3D &phba->ct_ev_waiters) {
> +
> +               spin_lock_irqsave(&phba->ct_ev_lock, flags);
> +               lpfc_bsg_event_unref(evt);
> +               spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
> +
>                 /* no event waiting struct yet - first call */
>                 dd_data =3D kmalloc(sizeof(struct bsg_job_data), GFP_KERN=
EL);
>                 if (dd_data =3D=3D NULL) {
> @@ -1292,6 +1297,9 @@ lpfc_bsg_hba_get_event(struct bsg_job *job)
>          * an error indicating that there isn't anymore
>          */
>         if (evt_dat =3D=3D NULL) {
> +               spin_lock_irqsave(&phba->ct_ev_lock, flags);
> +               lpfc_bsg_event_unref(evt);
> +               spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
>                 bsg_reply->reply_payload_rcv_len =3D 0;
>                 rc =3D -ENOENT;
>                 goto job_error;
> --
> 2.25.1
>
