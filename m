Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3D8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbiBIH0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiBIH0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:26:30 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01B9C0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:26:32 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 873741F383;
        Wed,  9 Feb 2022 07:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644391591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=trPWasI71h7k+cEsc37QinYDgs+dI5KFMbMnTUm/oZs=;
        b=BzMyyx+pP+8Ay8Zd1Pcd+Hq4q5cM5sC3lvY4s8zarK0dVFspCFr0jyRvzYw8NrecED9jSA
        IWd5lq7elJV07PIAZyTs2CRhgx4xK4QMyBljwcN3UPZEf8+hZtkuqD7kFhfI/5yu3KHK0m
        f+dABylCMcx83mbt3FPY8TrIDCGbnmg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644391591;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=trPWasI71h7k+cEsc37QinYDgs+dI5KFMbMnTUm/oZs=;
        b=jyP1VrvaM1bSIMmykhnfMbOz03JojkfUU0SaHOIFSmWoPNQxLmzYNvTTr5I9bAtnwohafH
        Dltm05WeJYqM4RAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E5F451332F;
        Wed,  9 Feb 2022 07:26:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jW2INqZsA2LtBwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:26:30 +0000
Message-ID: <4983e3e3-6706-c257-5a4e-7e9ad0e95533@suse.de>
Date:   Wed, 9 Feb 2022 08:26:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 03/44] scsi: Remove drivers/scsi/scsi.h
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Russell King <linux@armlinux.org.uk>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Oliver Neukum <oliver@neukum.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-4-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> The following two header files have the same file name: include/scsi/scsi.h
> and drivers/scsi/scsi.h. This is confusing. Remove the latter since the
> following note was added in drivers/scsi/scsi.h in 2004:
> 
> "NOTE: this file only contains compatibility glue for old drivers. All
> these wrappers will be removed sooner or later. For new code please use
> the interfaces declared in the headers in include/scsi/"
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/a2091.c               |  6 +++-
>   drivers/scsi/a3000.c               |  6 +++-
>   drivers/scsi/aha152x.c             |  9 ++++--
>   drivers/scsi/aha1740.c             |  6 +++-
>   drivers/scsi/arm/acornscsi.c       |  6 +++-
>   drivers/scsi/arm/arxescsi.c        |  6 +++-
>   drivers/scsi/arm/cumana_2.c        |  6 +++-
>   drivers/scsi/arm/eesox.c           |  6 +++-
>   drivers/scsi/arm/fas216.c          |  6 +++-
>   drivers/scsi/arm/powertec.c        |  6 +++-
>   drivers/scsi/arm/queue.c           |  6 +++-
>   drivers/scsi/gvp11.c               |  6 +++-
>   drivers/scsi/ips.c                 |  8 ++++--
>   drivers/scsi/megaraid.c            |  8 ++++--
>   drivers/scsi/mvme147.c             |  6 +++-
>   drivers/scsi/pcmcia/aha152x_stub.c | 10 +++++--
>   drivers/scsi/pcmcia/nsp_cs.c       |  5 ++--
>   drivers/scsi/pcmcia/qlogic_stub.c  | 10 +++++--
>   drivers/scsi/qlogicfas.c           |  6 +++-
>   drivers/scsi/qlogicfas408.c        |  6 +++-
>   drivers/scsi/scsi.h                | 46 ------------------------------
>   drivers/scsi/sg.c                  |  8 ++++--
>   drivers/scsi/sgiwd93.c             |  6 +++-
>   drivers/usb/image/microtek.c       |  8 ++++--
>   drivers/usb/storage/debug.c        |  1 -
>   25 files changed, 121 insertions(+), 82 deletions(-)
>   delete mode 100644 drivers/scsi/scsi.h
> 
[ .. ]

> diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
> index df82a349e969..332c6d573904 100644
> --- a/drivers/scsi/pcmcia/aha152x_stub.c
> +++ b/drivers/scsi/pcmcia/aha152x_stub.c
> @@ -40,13 +40,17 @@
>   #include <linux/slab.h>
>   #include <linux/string.h>
>   #include <linux/ioport.h>
> -#include <scsi/scsi.h>
>   #include <linux/major.h>
>   #include <linux/blkdev.h>
> -#include <scsi/scsi_ioctl.h>
>   
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi.h>

Duplicate include line

> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
>   #include <scsi/scsi_host.h>
> +#include <scsi/scsi_ioctl.h>
> +#include <scsi/scsi_tcq.h>
>   #include "aha152x.h"
>   
>   #include <pcmcia/cistpl.h>
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index a78a86511e94..dcffda384eaf 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -41,10 +41,9 @@
>   #include <asm/io.h>
>   #include <asm/irq.h>
>   
> -#include <../drivers/scsi/scsi.h>
> -#include <scsi/scsi_host.h>
> -
>   #include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_host.h>
>   #include <scsi/scsi_ioctl.h>
>   
>   #include <pcmcia/cistpl.h>
> diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
> index 828d53faf09a..1c21d1b12988 100644
> --- a/drivers/scsi/pcmcia/qlogic_stub.c
> +++ b/drivers/scsi/pcmcia/qlogic_stub.c
> @@ -38,14 +38,18 @@
>   #include <linux/string.h>
>   #include <linux/ioport.h>
>   #include <asm/io.h>
> -#include <scsi/scsi.h>
>   #include <linux/major.h>
>   #include <linux/blkdev.h>
> -#include <scsi/scsi_ioctl.h>
>   #include <linux/interrupt.h>
>   
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi.h>

Same here.

> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
>   #include <scsi/scsi_host.h>
> +#include <scsi/scsi_ioctl.h>
> +#include <scsi/scsi_tcq.h>
>   #include "../qlogicfas408.h"
>   
>   #include <pcmcia/cistpl.h>
> diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
> index 8f709002f746..8f05e3707d69 100644
> --- a/drivers/scsi/qlogicfas.c
> +++ b/drivers/scsi/qlogicfas.c
> @@ -31,8 +31,12 @@
>   #include <asm/irq.h>
>   #include <asm/dma.h>
>   
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
>   #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
>   #include "qlogicfas408.h"
>   
>   /* Set the following to 2 to use normal interrupt (active high/totempole-
> diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
> index 30a88849a626..3e065d5fc80c 100644
> --- a/drivers/scsi/qlogicfas408.c
> +++ b/drivers/scsi/qlogicfas408.c
> @@ -55,8 +55,12 @@
>   #include <asm/irq.h>
>   #include <asm/dma.h>
>   
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
>   #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
>   #include "qlogicfas408.h"
>   
>   /*----------------------------------------------------------------*/
> diff --git a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
> deleted file mode 100644
> index 4fd75a3aff66..000000000000
> --- a/drivers/scsi/scsi.h
> +++ /dev/null
> @@ -1,46 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/*
> - *  scsi.h Copyright (C) 1992 Drew Eckhardt
> - *         Copyright (C) 1993, 1994, 1995, 1998, 1999 Eric Youngdale
> - *  generic SCSI package header file by
> - *      Initial versions: Drew Eckhardt
> - *      Subsequent revisions: Eric Youngdale
> - *
> - *  <drew@colorado.edu>
> - *
> - *       Modified by Eric Youngdale eric@andante.org to
> - *       add scatter-gather, multiple outstanding request, and other
> - *       enhancements.
> - */
> -/*
> - * NOTE:  this file only contains compatibility glue for old drivers.  All
> - * these wrappers will be removed sooner or later.  For new code please use
> - * the interfaces declared in the headers in include/scsi/
> - */
> -
> -#ifndef _SCSI_H
> -#define _SCSI_H
> -
> -#include <scsi/scsi_cmnd.h>
> -#include <scsi/scsi_device.h>
> -#include <scsi/scsi_eh.h>
> -#include <scsi/scsi_tcq.h>
> -#include <scsi/scsi.h>
> -
> -/*
> - * Some defs, in case these are not defined elsewhere.
> - */
> -#ifndef TRUE
> -#define TRUE 1
> -#endif
> -#ifndef FALSE
> -#define FALSE 0
> -#endif
> -
> -struct Scsi_Host;
> -struct scsi_cmnd;
> -struct scsi_device;
> -struct scsi_target;
> -struct scatterlist;
> -
> -#endif /* _SCSI_H */
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 6b43e97bd417..bbd75026ec93 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -49,11 +49,15 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
>   #include <linux/uio.h>
>   #include <linux/cred.h> /* for sg_check_file_access() */
>   
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_dbg.h>
> -#include <scsi/scsi_host.h>
> +#include <scsi/scsi_device.h>
>   #include <scsi/scsi_driver.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_host.h>
>   #include <scsi/scsi_ioctl.h>
> +#include <scsi/scsi_tcq.h>
>   #include <scsi/sg.h>
>   
>   #include "scsi_logging.h"
> diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
> index cf1030c9dda1..e797d89c873b 100644
> --- a/drivers/scsi/sgiwd93.c
> +++ b/drivers/scsi/sgiwd93.c
> @@ -28,7 +28,11 @@
>   #include <asm/sgi/ip22.h>
>   #include <asm/sgi/wd.h>
>   
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_tcq.h>
>   #include "wd33c93.h"
>   
>   struct ip22_hostdata {
> diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
> index b8dc6fa6a5a3..874ea4b54ced 100644
> --- a/drivers/usb/image/microtek.c
> +++ b/drivers/usb/image/microtek.c
> @@ -130,11 +130,15 @@
>   #include <linux/spinlock.h>
>   #include <linux/usb.h>
>   #include <linux/proc_fs.h>
> -
>   #include <linux/atomic.h>
>   #include <linux/blkdev.h>
> -#include "../../scsi/scsi.h"
> +
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
>   #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
>   
>   #include "microtek.h"
>   
> diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
> index d7f50b7a079e..576be66ad962 100644
> --- a/drivers/usb/storage/debug.c
> +++ b/drivers/usb/storage/debug.c
> @@ -36,7 +36,6 @@
>   
>   #include "usb.h"
>   #include "debug.h"
> -#include "scsi.h"
>   
>   
>   void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
