Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D5DACA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 02:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5085F214E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 02:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KWSwIAyx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbfKECEN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 21:04:13 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45906 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729597AbfKECEM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 21:04:12 -0500
Received: by mail-ot1-f68.google.com with SMTP id 77so11847477oti.12
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 18:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dRN8qUK9p07oi9DFItx5rsYOqF6ZTGQlqK1NAdnB7/8=;
        b=KWSwIAyxGI1SjW9vKC4DqM6a7agS0bJ2dIKU5jJFILbQcIUK0/HTDRCsndWB20MAcB
         doO+iiG/hMdEyakGetxQf9hGCyI0wHRo+b6zEO9FJRsH4yGzZOe4HswbjJMrQ0nPONr9
         gk5WLhIqkMBuoRdTBj6IMwZ+ut0q0cFboJU11jl5FfGMlETiuurCSQ86vYCKl9pbS4yE
         JtGc+lHar16aNoXcl/f8vnNhUV/yU4mOuXEU5TXjYswmj67v2nbt1kfBfpFZkvBKN3wN
         vr1Pm4wVBdQCq1nioCSTn4V6vFyUw53zuIwic8vCRmGnWoiFGDttLKJlzBZRSGD8cjuH
         9SUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dRN8qUK9p07oi9DFItx5rsYOqF6ZTGQlqK1NAdnB7/8=;
        b=lmYHMxdal5tQHNF6cfprX8jr8OeCWsfIB8GWaO+5yVrCo5HeZvYIfgKcdqrm4mYct0
         N7SIjZxUfDO+wtxld0JQgoxThExJgqjGiSyB9iyn1qpnVS4p8WeB6qqXaTPuWUzClMfN
         JIvLX0wo9rPdfAzvHcPMpfhISmRWWVZwmJs7ivWE9YUnJWcfNvrmmHo4gUxeVjKqbOPe
         dp8V0LWJrjcaLtNDUXEND5fS0wGm8IJpjO2MKX5WLeoAYm4M/LhriRrNqhv76YIDQeBr
         vFP9hZubChoOqMBson1Aybryltj4qiiUY51OWYSPDLmBgKKiAaXhwCT4LO586NtDbEME
         KPHg==
X-Gm-Message-State: APjAAAVehWs9nSRBvgoA3L5fXjWyp04z7LlDSyY7Gbtf+S5EaHYdAVBv
        mVILqFmKvwb4WLZtUtQdpft6I1hMqqICog95W9o=
X-Google-Smtp-Source: APXvYqxLgh0FtX+LDDEJR+usbcy/rQeTD5t2IWayV7qR2pw7VYffjzgFcBc9IPZy3MzfY4vAjjAI884gJ1ScmYOUd4E=
X-Received: by 2002:a9d:30d2:: with SMTP id r18mr20175959otg.6.1572919452065;
 Mon, 04 Nov 2019 18:04:12 -0800 (PST)
MIME-Version: 1.0
References: <20191104090151.129140-1-hare@suse.de> <20191104090151.129140-49-hare@suse.de>
In-Reply-To: <20191104090151.129140-49-hare@suse.de>
From:   adam radford <aradford@gmail.com>
Date:   Mon, 4 Nov 2019 18:04:01 -0800
Message-ID: <CAHtARFFUw7qW2xs9TG7U4-LJ_9ho3+VcAQ6VoUwk30bPcSibkQ@mail.gmail.com>
Subject: Re: [PATCH 48/52] 3w-9xxx: Kill unreachable code in twa_interrupt()
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 4, 2019 at 1:04 AM Hannes Reinecke <hare@suse.de> wrote:
>
> twa_fill_sense() can never return '1', so the check is pointless.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/3w-9xxx.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 3337b1e80412..b275ce3b0fbd 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1339,12 +1339,6 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
>                                         cmd->result = (DID_OK << 16);
>                                 }
>
> -                               /* If error, command failed */
> -                               if (error == 1) {
> -                                       /* Ask for a host reset */
> -                                       cmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
> -                               }
> -
>                                 /* Report residual bytes for single sgl */
>                                 if ((scsi_sg_count(cmd) <= 1) && (full_command_packet->command.newcommand.status == 0)) {
>                                         if (full_command_packet->command.newcommand.sg_list[0].length < scsi_bufflen(tw_dev->srb[request_id]))
> --
> 2.16.4
>

Acked-by: Adam Radford <aradford@gmail.com>
