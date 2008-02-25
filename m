From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH] [8/22] Remove random noop unchecked_isa_dma users
Date: Mon, 25 Feb 2008 06:19:37 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F482A67CDA@ADPE2K703.adaptec.com>
References: <200802251235.889863872@firstfloor.org>
 <20080224233521.1EC2D1B4183@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:41422 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYBYOTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 09:19:39 -0500
In-Reply-To: <20080224233521.1EC2D1B4183@basil.firstfloor.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

ACK (for ips portion, see no harm other chunks).

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Andi Kleen
> Sent: Sunday, February 24, 2008 6:35 PM
> To: linux-scsi@vger.kernel.org; James.Bottomley@HansenPartnership.com
> Subject: [PATCH] [8/22] Remove random noop unchecked_isa_dma users
>
>
> Lots of drivers set it to 0. Remove that. Patch should be a nop.
>
> Signed-off-by: Andi Kleen <ak@suse.de>
>
> ---
>  drivers/scsi/arm/acornscsi.c |    1 -
>  drivers/scsi/arm/cumana_1.c  |    1 -
>  drivers/scsi/dc395x.c        |    1 -
>  drivers/scsi/eata_pio.c      |    2 --
>  drivers/scsi/hptiop.c        |    1 -
>  drivers/scsi/ips.c           |    1 -
>  drivers/scsi/mac_scsi.c      |    1 -
>  drivers/scsi/scsi_debug.c    |    1 -
>  8 files changed, 9 deletions(-)
>
> Index: linux/drivers/scsi/arm/acornscsi.c
> ===================================================================
> --- linux.orig/drivers/scsi/arm/acornscsi.c
> +++ linux/drivers/scsi/arm/acornscsi.c
> @@ -2983,7 +2983,6 @@ static struct scsi_host_template acornsc
>         .this_id                = 7,
>         .sg_tablesize           = SG_ALL,
>         .cmd_per_lun            = 2,
> -       .unchecked_isa_dma      = 0,
>         .use_clustering         = DISABLE_CLUSTERING,
>         .proc_name              = "acornscsi",
>  };
> Index: linux/drivers/scsi/arm/cumana_1.c
> ===================================================================
> --- linux.orig/drivers/scsi/arm/cumana_1.c
> +++ linux/drivers/scsi/arm/cumana_1.c
> @@ -222,7 +222,6 @@ static struct scsi_host_template cumanas
>         .this_id                = 7,
>         .sg_tablesize           = SG_ALL,
>         .cmd_per_lun            = 2,
> -       .unchecked_isa_dma      = 0,
>         .use_clustering         = DISABLE_CLUSTERING,
>         .proc_name              = "CumanaSCSI-1",
>  };
> Index: linux/drivers/scsi/dc395x.c
> ===================================================================
> --- linux.orig/drivers/scsi/dc395x.c
> +++ linux/drivers/scsi/dc395x.c
> @@ -4761,7 +4761,6 @@ static struct scsi_host_template dc395x_
>         .cmd_per_lun            = DC395x_MAX_CMD_PER_LUN,
>         .eh_abort_handler       = dc395x_eh_abort,
>         .eh_bus_reset_handler   = dc395x_eh_bus_reset,
> -       .unchecked_isa_dma      = 0,
>         .use_clustering         = DISABLE_CLUSTERING,
>  };
>
> Index: linux/drivers/scsi/eata_pio.c
> ===================================================================
> --- linux.orig/drivers/scsi/eata_pio.c
> +++ linux/drivers/scsi/eata_pio.c
> @@ -815,8 +815,6 @@ static int register_pio_HBA(long base, s
>         else
>                 hd->primary = 1;
>
> -       sh->unchecked_isa_dma = 0;      /* We can only do PIO */
> -
>         hd->next = NULL;        /* build a linked list of all HBAs */
>         hd->prev = last_HBA;
>         if (hd->prev != NULL)
> Index: linux/drivers/scsi/hptiop.c
> ===================================================================
> --- linux.orig/drivers/scsi/hptiop.c
> +++ linux/drivers/scsi/hptiop.c
> @@ -903,7 +903,6 @@ static struct scsi_host_template driver_
>         .eh_device_reset_handler    = hptiop_reset,
>         .eh_bus_reset_handler       = hptiop_reset,
>         .info                       = hptiop_info,
> -       .unchecked_isa_dma          = 0,
>         .emulated                   = 0,
>         .use_clustering             = ENABLE_CLUSTERING,
>         .proc_name                  = driver_name,
> Index: linux/drivers/scsi/ips.c
> ===================================================================
> --- linux.orig/drivers/scsi/ips.c
> +++ linux/drivers/scsi/ips.c
> @@ -6842,7 +6842,6 @@ ips_register_scsi(int index)
>         sh->sg_tablesize = sh->hostt->sg_tablesize;
>         sh->can_queue = sh->hostt->can_queue;
>         sh->cmd_per_lun = sh->hostt->cmd_per_lun;
> -       sh->unchecked_isa_dma = sh->hostt->unchecked_isa_dma;
>         sh->use_clustering = sh->hostt->use_clustering;
>         sh->max_sectors = 128;
>
> Index: linux/drivers/scsi/mac_scsi.c
> ===================================================================
> --- linux.orig/drivers/scsi/mac_scsi.c
> +++ linux/drivers/scsi/mac_scsi.c
> @@ -592,7 +592,6 @@ static struct scsi_host_template driver_
>         .this_id                        = 7,
>         .sg_tablesize                   = SG_ALL,
>         .cmd_per_lun                    = CMD_PER_LUN,
> -       .unchecked_isa_dma              = 0,
>         .use_clustering                 = DISABLE_CLUSTERING
>  };
>
> Index: linux/drivers/scsi/scsi_debug.c
> ===================================================================
> --- linux.orig/drivers/scsi/scsi_debug.c
> +++ linux/drivers/scsi/scsi_debug.c
> @@ -221,7 +221,6 @@ static struct scsi_host_template sdebug_
>         .sg_tablesize =         256,
>         .cmd_per_lun =          16,
>         .max_sectors =          0xffff,
> -       .unchecked_isa_dma =    0,
>         .use_clustering =       ENABLE_CLUSTERING,
>         .module =               THIS_MODULE,
>  };
