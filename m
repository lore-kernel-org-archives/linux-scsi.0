Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1A5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 14:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D5760D07
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 14:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238757AbhKIOfS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 09:35:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238712AbhKIOfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 09:35:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636468347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pH5eEmfZFFcaZUWOBY6oRbR08LQ9bDdpxnVfGSCOWas=;
        b=ei8oMi7t8/mAJk5jU2N5naQ/ZCCBoDyKqluHtXDuaHD0DggtkrwiDDmuyzEgCK4rlCWPfT
        EN/scxzVV1oUkRgsZ0Xp19zxiCRvXjTjfDLWJ6wy5OennK2C5M4NpNcb/TMs3OZnzgvL/O
        1/XSWYFFrbXWzVPgEmJsZSB0LFyYMpI=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-ynCUGt0MPEWFBvI2fHEsDQ-1; Tue, 09 Nov 2021 09:32:26 -0500
X-MC-Unique: ynCUGt0MPEWFBvI2fHEsDQ-1
Received: by mail-lj1-f200.google.com with SMTP id q13-20020a2e750d000000b00218c953d0b8so1850078ljc.21
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 06:32:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pH5eEmfZFFcaZUWOBY6oRbR08LQ9bDdpxnVfGSCOWas=;
        b=zuAljmYHeGiT7rGoQY71CF5t31wtG1NqXLy2/a9y0It2X1ioF7nEHVGgvuMInoF+K6
         oUb1ouXMLAmLjlDR4lewWGsLzuWxYZ4D3uX2g/Wo6pMtMWxQvfjpF/LI/1VvB+D827qf
         biUt7uSDdfxoJ22GJL+AaX7gewKaetdzUSPHvztXQmbXTEyGkZJxJX8m9G8pjeucl16E
         k958G4wmC89i0qVG+wQszIym3ZxY+aSHGo0E4YQ2IPfYEHbPpj73HQLKLdXwgebNw6OT
         FVuaYLRJkJhC8QCTFgl/irq7X5xELJz8Y7C2/X3TXow58ZxBtWaKMymLgNo/r7VeF3VC
         NXZQ==
X-Gm-Message-State: AOAM531BkcSQpG8qaZeUJXiumRF4bwFe4Yiw3BWAS02T1AY2Xh/9kgNd
        iSC1CpLqcwx/I10Y46WwgFL9R7mZNALcL+UFLKfJ8KYR22Z6fsRdF2wrWyeJxD577E8MZ9AhBbc
        YTSD4K36ZtDhum1aD1qgRiiRrSre5YRBh/GWAhw==
X-Received: by 2002:a19:7902:: with SMTP id u2mr7464907lfc.644.1636468344979;
        Tue, 09 Nov 2021 06:32:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznbxoM0GiHxxENT8H6XVRT7SRWQnAl3RKAh/79JZLW7I5kndgWOfFP3RSuEDQQbU47YsX1M52GehxkJWXoda4=
X-Received: by 2002:a19:7902:: with SMTP id u2mr7464881lfc.644.1636468344768;
 Tue, 09 Nov 2021 06:32:24 -0800 (PST)
MIME-Version: 1.0
References: <20211109115219.GE16587@kili>
In-Reply-To: <20211109115219.GE16587@kili>
From:   Ewan Milne <emilne@redhat.com>
Date:   Tue, 9 Nov 2021 09:32:12 -0500
Message-ID: <CAGtn9rnUKN1w4czt3OmEMab8P2w35Jr9TMhVD-OF0kJvz59oOg@mail.gmail.com>
Subject: Re: [PATCH] scsi: qla2xxx: edif: fix off by one bug in qla_edif_app_getfcinfo()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Larry Wisneski <Larry.Wisneski@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks fine.  (The break; test could perhaps be moved prior to the
ql_dbg() call above
but that's not all that critical.  Or, that ql_dbg()) call could
potentially move outside the list
traversal since it is invariant, Marvell you might want to look at that.)

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

On Tue, Nov 9, 2021 at 6:56 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The > comparison needs to be >= to prevent accessing one element beyond
> the end of the app_reply->ports[] array.
>
> Fixes: 7878f22a2e03 ("scsi: qla2xxx: edif: Add getfcinfo and statistic bsgs")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/scsi/qla2xxx/qla_edif.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index 2e37b189cb75..53d2b8562027 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -865,7 +865,7 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>                             "APP request entry - portid=%06x.\n", tdid.b24);
>
>                         /* Ran out of space */
> -                       if (pcnt > app_req.num_ports)
> +                       if (pcnt >= app_req.num_ports)
>                                 break;
>
>                         if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
> --
> 2.20.1
>

