Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3FFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 15:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 509E76103D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 15:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbhJLPUe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 11:20:34 -0400
Received: from comms.puri.sm ([159.203.221.185]:51836 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhJLPUd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 11:20:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id D6D32DFAC1;
        Tue, 12 Oct 2021 08:18:31 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WF3Tp6OFxLqq; Tue, 12 Oct 2021 08:18:31 -0700 (PDT)
Message-ID: <2d3b0e8f422b7ff08a5c4ce804a1884eaf9b5d60.camel@puri.sm>
Subject: Re: [PATCH] scsi: sd: print write through due to no caching mode
 page as warning
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     dgilbert@interlog.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Oct 2021 17:18:26 +0200
In-Reply-To: <20210122083000.32598-1-martin.kepplinger@puri.sm>
References: <20210122083000.32598-1-martin.kepplinger@puri.sm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am Freitag, dem 22.01.2021 um 09:30 +0100 schrieb Martin Kepplinger:
> For SD cardreaders it's extremely common not to find cache on disk.
> The following error messages are thus very common and don't point
> to a real error one could try to fix but rather describe how the disk
> works:
> 
> sd 0:0:0:0: [sda] No Caching mode page found
> sd 0:0:0:0: [sda] Assuming drive cache: write through
> 
> Print these messages as warnings instead of errors.
> 
> Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> ---
>  drivers/scsi/sd.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e7c52d6df4dc..db0171c81c5b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2808,7 +2808,8 @@ sd_read_cache_type(struct scsi_disk *sdkp,
> unsigned char *buffer)
>                         }
>                 }
>  
> -               sd_first_printk(KERN_ERR, sdkp, "No Caching mode page
> found\n");
> +               sd_first_printk(KERN_WARNING, sdkp,
> +                               "No Caching mode page found\n");
>                 goto defaults;
>  
>         Page_found:
> @@ -2863,7 +2864,7 @@ sd_read_cache_type(struct scsi_disk *sdkp,
> unsigned char *buffer)
>                                 "Assuming drive cache: write
> back\n");
>                 sdkp->WCE = 1;
>         } else {
> -               sd_first_printk(KERN_ERR, sdkp,
> +               sd_first_printk(KERN_WARNING, sdkp,
>                                 "Assuming drive cache: write
> through\n");
>                 sdkp->WCE = 0;
>         }


hi Bart and all who it may concern,

does this "consmetic" change have any chance of being acceptible? At
least it'd be nice if messages sent as error are real errors that needs
fixing.

the patch still applies.

thank you,

                               martin


