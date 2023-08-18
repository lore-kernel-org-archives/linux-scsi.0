Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404A9EE4992
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 22:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241315AbjHRWA4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 18:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241299AbjHRWAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 18:00:36 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A73A2D58
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2023 15:00:33 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bbff6b2679so10909985ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2023 15:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692396033; x=1693000833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0o8mHhzupwszEmNqN85M/fT34kJaGw1d668flMasK2k=;
        b=pXRnBnb3YGWuT80vxyv4nN986wl2D1wpu9wPIfSMx57Nrxx9YNlDH3+oaXFg4hLu6y
         ntPkJTB5B0kbB3VPwGMfyTSpoSqXdiQpwkD0LpkJbkVpFREmuZ/1P5ErET5nlXPkxZLP
         AgL4GG826kwkpeeLtswCWrHFZ15NTNPMN8w8kxYco4K7ejilj0MxLezHw6dYhW+TDgsW
         MPeO89yJKnRw9wXROCupoNxN3mEBzV/ofQWARA54mpAjbGO1g/CauVKYvQct4VUEemWa
         0Sy5a7RrmfFf4u4KUYIz3p9S1qW+MOsYlUSi8esBaWZa5idFpqWG19nlx9Vonpi4IKzY
         bF/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692396033; x=1693000833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0o8mHhzupwszEmNqN85M/fT34kJaGw1d668flMasK2k=;
        b=SVg0a9wsLX1d8o4t2r7hBXVUkews0UieJMSOZA7h1puqCsgldD2KEqnV7I4ECScx7c
         Hjr/jLGqjlX9KBWkrQuC9i4tfreIl/82W3pBWDYdDzZlI8s0LDB1v5hcdzQh+VP5ugOy
         h0Yf9AFMSs0+7QtOGdpWTJhdRCOTlUK5v9oisi/OS/JveO/ILlnX+fXlQu6GgI109j6G
         tYKzswGKc9HQOhYxgsw1D6SrMMAFE65MN3exaXTEpN1AUrZ7s2HjUpugKrnuQwyYs4ze
         sJtuSTZaY75dJu8QRCrQM/IcBuMxkMaemKjUflsDpO7uOcvcYTrqayrhjSZe3pdOWeuP
         DZGw==
X-Gm-Message-State: AOJu0Yx4MEcX97KdZ8Xsx1kEw/SW+vahRpgYd/py2LCihrg5r/1AmDR4
        +zTnpygL8XHr6jlQOEKtDTN6nDFzIXkpM3HL1eX0+zP6
X-Google-Smtp-Source: AGHT+IFBZbLYA7M/+b2sw05Z2uAO6hrau2N+qVZtyceJc5gWtdDr+41ibYl1EhFZLrYiCrtu3UZ4qA==
X-Received: by 2002:a17:902:9898:b0:1b9:ebf4:5d2 with SMTP id s24-20020a170902989800b001b9ebf405d2mr452748plp.33.1692396032712;
        Fri, 18 Aug 2023 15:00:32 -0700 (PDT)
Received: from google.com ([2620:15c:2c5:13:4f6e:2bd9:cb46:7849])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902e54100b001b89c313185sm2228060plf.205.2023.08.18.15.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 15:00:32 -0700 (PDT)
Date:   Fri, 18 Aug 2023 15:00:27 -0700
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Message-ID: <ZN/p+4J6vDR0iX/s@google.com>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <20230817214137.462044-2-ipylypiv@google.com>
 <ZN6vB0COt0eJU93A@x1-carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZN6vB0COt0eJU93A@x1-carbon>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 17, 2023 at 11:36:43PM +0000, Niklas Cassel wrote:
> On Thu, Aug 17, 2023 at 02:41:36PM -0700, Igor Pylypiv wrote:
> 
> Hello Igor,
> 
> > For Command Duration Limits policy 0xD (command completes without
> > an error) libata needs FIS in order to detect the ATA_SENSE bit and
> > read the Sense Data for Successful NCQ Commands log (0Fh).
> > 
> > Set return_fis_on_success for commands that have a CDL descriptor
> > since any CDL descriptor can be configured with policy 0xD.
> > 
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> > ---
> >  drivers/scsi/libsas/sas_ata.c | 3 +++
> >  include/scsi/libsas.h         | 1 +
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> > index 77714a495cbb..da67c4f671b2 100644
> > --- a/drivers/scsi/libsas/sas_ata.c
> > +++ b/drivers/scsi/libsas/sas_ata.c
> > @@ -207,6 +207,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
> >  	task->ata_task.use_ncq = ata_is_ncq(qc->tf.protocol);
> >  	task->ata_task.dma_xfer = ata_is_dma(qc->tf.protocol);
> >  
> > +	/* CDL policy 0xD requires FIS for successful (no error) completions */
> > +	task->ata_task.return_fis_on_success = ata_qc_has_cdl(qc);
> 
> In ata_qc_complete(), for a successful command, we call fill_result_tf()
> if (qc->flags & ATA_QCFLAG_RESULT_TF):
> https://github.com/torvalds/linux/blob/v6.5-rc6/drivers/ata/libata-core.c#L4926
> 
> My point is, I think that you should set
> task->ata_task.return_fis_on_success = ata_qc_wants_result(qc);
> 
> where ata_qc_wants_result()
> returns true if ATA_QCFLAG_RESULT_TF is set.
> 
> (ata_set_tf_cdl() will set both ATA_QCFLAG_HAS_CDL and ATA_QCFLAG_RESULT_TF).
> 
> That way, e.g. an internal command (i.e. a command issued by
> ata_exec_internal_sg()), which always has ATA_QCFLAG_RESULT_TF set,
> will always gets an up to date tf status and tf error value back,
> because the SAS HBA will send a FIS back.
> 
> If we don't do this, then libsas will instead fill in the tf status and
> tf error from the last command that returned a FIS (which might be out
> of date).

Hi Niklas,

Thanks for the suggestion! I'll update the check to ATA_QCFLAG_RESULT_TF in v2.

> 
> 
> > +
> >  	if (qc->scsicmd)
> >  		ASSIGN_SAS_TASK(qc->scsicmd, task);
> >  
> > diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> > index 159823e0afbf..9e2c69c13dd3 100644
> > --- a/include/scsi/libsas.h
> > +++ b/include/scsi/libsas.h
> > @@ -550,6 +550,7 @@ struct sas_ata_task {
> >  	u8     use_ncq:1;
> >  	u8     set_affil_pol:1;
> >  	u8     stp_affil_pol:1;
> > +	u8     return_fis_on_success:1;
> >  
> >  	u8     device_control_reg_update:1;
> >  
> > -- 
> > 2.42.0.rc1.204.g551eb34607-goog
> > 
> 
> Considering that libsas return value is defined like this:
> https://github.com/torvalds/linux/blob/v6.5-rc6/include/scsi/libsas.h#L507
> 
> Basically, if you returned a FIS in resp->ending_fis, you should return
> SAS_PROTO_RESPONSE. If you didn't return a FIS for your command, then
> you return SAS_SAM_STAT_GOOD (or if it is an error, a SAS_ error code
> that is not SAS_PROTO_RESPONSE, as you didn't return a FIS).
> 
> Since you have implemented this only for pm80xx, how about adding something
> like this to sas_ata_task_done:
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 77714a495cbb..e1c56c2c00a5 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -114,6 +114,15 @@ static void sas_ata_task_done(struct sas_task *task)
>                 }
>         }
>  
> +       /*
> +        * If a FIS was requested for a good command, and the lldd returned
> +        * SAS_SAM_STAT_GOOD instead of SAS_PROTO_RESPONSE, then the lldd
> +        * has not implemented support for sas_ata_task.return_fis_on_success
> +        * Warn about this once. If we don't return FIS on success, then we
> +        * won't be able to return an up to date TF.status and TF.error.
> +        */
> +       WARN_ON_ONCE(ata_qc_wants_result(qc) && stat->stat == SAS_SAM_STAT_GOOD);

I'm a bit hesitant about adding this warning. pm80xx manual states that FIS
is not getting returned for PIO Read commands. ata_dev_read_id() sends
ATA_CMD_ID_ATA (0xEC) PIO command during bus probe resulting in this warning
getting triggered every time. Checking for !PIO doesn't seem to be the right
thing to do. I'll hold off from adding the warning.

> +
>         if (stat->stat == SAS_PROTO_RESPONSE ||
>             stat->stat == SAS_SAM_STAT_GOOD ||
>             (stat->stat == SAS_SAM_STAT_CHECK_CONDITION &&
> 

Thanks,
Igor
