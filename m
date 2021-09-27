Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CC3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 19:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E071B60EFD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 19:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbhI0TWg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 15:22:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236225AbhI0TWg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Sep 2021 15:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632770457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g6nj5fy4MdHCKDQCQljsKVyIqJ6/syuqVb25dhcm+eM=;
        b=YlA++6TWDQ5pE85ok9/xUcI5qfFMHEtAvVWfK4RwlGaciiU8qE7UZRyirn5Eeo+5BYJvPA
        QCaWeLy0rj1UnlRjrD1fEL+SKPz9kbuFt0/jqDo0kgM81IPsqTzSH99oOZCJtAg9AMUGTD
        yJgTXp4pbVRb3++aDY7xUoJw2aQ5qBE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-pN3iFRrGN7SlwI2jV3DTyg-1; Mon, 27 Sep 2021 15:20:56 -0400
X-MC-Unique: pN3iFRrGN7SlwI2jV3DTyg-1
Received: by mail-lf1-f71.google.com with SMTP id x29-20020ac259dd000000b003f950c726e1so16710080lfn.14
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 12:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g6nj5fy4MdHCKDQCQljsKVyIqJ6/syuqVb25dhcm+eM=;
        b=NjfgppVasIPrSb5BGToG5bChefNtF08jH7FHOXvdoWsVGScMDe7gkHo3uUocLs+Buc
         DjtPoYkqvmcvUepPd36BD8gsQNYS/dkVxgGMHO3zgGYgTIbF7klUXWog8DB2NgAkU7hN
         oCS21j9q4FHnytYzeEBbpNz4sssD2yzbgTJW1RfBphY/gzi/GHer6VKQu9uuYCvOmWN+
         bQ0wZ5zfGOqkHkk5CVJWExHALX5bQSfpxKeA9kvpDje1nxPHNQfY5zqapf5BnowtoHc8
         330cXQwGrMCdSrvXe1DiW6utPnJB7Qh4fpCZvG+Ck7EMCcj9HrvDxoQ+hjaZRRfNfSP8
         dd+w==
X-Gm-Message-State: AOAM5304x4oaxOXc7JHAn8RV3np/gIfrhD54c8tqZ2SOcvV/bjU7d0cP
        tGNVfYq6ADI7J30LBKbSiRqhI9sE47hQBnYeYQTpll/glnUQdZ8lRXjFevw4cka3rjO7jUIZmA1
        xBl1453A6ASmJ9ibelvBaFMf5z3PXx8AKmJ2b8g==
X-Received: by 2002:a2e:a596:: with SMTP id m22mr1643309ljp.262.1632770454517;
        Mon, 27 Sep 2021 12:20:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO+r4UMjsXOlFZGGVS7wP7RwNvWZxXSq5yKPUMemiJg7MZp1UyFBEHkwQrVxfbjPDBUljeusCrPpVKKzglDPY=
X-Received: by 2002:a2e:a596:: with SMTP id m22mr1643293ljp.262.1632770454331;
 Mon, 27 Sep 2021 12:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210925035154.29815-1-njavali@marvell.com>
In-Reply-To: <20210925035154.29815-1-njavali@marvell.com>
From:   Ewan Milne <emilne@redhat.com>
Date:   Mon, 27 Sep 2021 15:20:43 -0400
Message-ID: <CAGtn9r=GNVEWc=4gsPJaS+Q=SNQ8cLw2=DtE6wWGsrZ+i2CVsA@mail.gmail.com>
Subject: Re: [PATCH] qla2xxx: Fix excessive messages during device logout
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks for posting this.  Martin, can we get this in soon?  The
logging could be overwhelming.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

On Fri, Sep 24, 2021 at 11:52 PM Nilesh Javali <njavali@marvell.com> wrote:
>
> From: Arun Easi <aeasi@marvell.com>
>
> Disable default logging of some IO path messages which can be
> turned back on by setting ql2xextended_error_logging.
>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index ece60267b971..b26f2699adb2 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2634,7 +2634,7 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>         }
>
>         if (unlikely(logit))
> -               ql_log(ql_log_warn, fcport->vha, 0x5060,
> +               ql_log(ql_dbg_io, fcport->vha, 0x5060,
>                    "NVME-%s ERR Handling - hdl=%x status(%x) tr_len:%x resid=%x  ox_id=%x\n",
>                    sp->name, sp->handle, comp_status,
>                    fd->transferred_length, le32_to_cpu(sts->residual_len),
> @@ -3491,7 +3491,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
>
>  out:
>         if (logit)
> -               ql_log(ql_log_warn, fcport->vha, 0x3022,
> +               ql_log(ql_dbg_io, fcport->vha, 0x3022,
>                        "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
>                        comp_status, scsi_status, res, vha->host_no,
>                        cp->device->id, cp->device->lun, fcport->d_id.b.domain,
> --
> 2.19.0.rc0
>

