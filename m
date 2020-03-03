Return-Path: <SRS0=hRFu=4U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EA4C3F2D7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 00:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38AB72465E
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 00:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgCCAVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 19:21:33 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:56972 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgCCAVd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2020 19:21:33 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 377D92A449;
        Mon,  2 Mar 2020 19:21:29 -0500 (EST)
Date:   Tue, 3 Mar 2020 11:21:27 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 16/42] docs: scsi: convert g_NCR5380.txt to ReST
In-Reply-To: <a66e9ea704be6a7aa81b9864ad66a32b75ab808d.1583136624.git.mchehab+huawei@kernel.org>
Message-ID: <alpine.LNX.2.22.394.2003030954230.9@nippy.intranet>
References: <cover.1583136624.git.mchehab+huawei@kernel.org> <a66e9ea704be6a7aa81b9864ad66a32b75ab808d.1583136624.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2 Mar 2020, Mauro Carvalho Chehab wrote:

> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Acked-by: Finn Thain <fthain@telegraphics.com.au>

> ---
>  .../scsi/{g_NCR5380.txt => g_NCR5380.rst}     | 89 ++++++++++++-------
>  Documentation/scsi/index.rst                  |  1 +
>  Documentation/scsi/scsi-parameters.txt        |  6 +-
>  MAINTAINERS                                   |  2 +-
>  drivers/scsi/g_NCR5380.c                      |  2 +-
>  5 files changed, 63 insertions(+), 37 deletions(-)
>  rename Documentation/scsi/{g_NCR5380.txt => g_NCR5380.rst} (41%)
> 
> diff --git a/Documentation/scsi/g_NCR5380.txt b/Documentation/scsi/g_NCR5380.rst
> similarity index 41%
> rename from Documentation/scsi/g_NCR5380.txt
> rename to Documentation/scsi/g_NCR5380.rst
> index 37b1967a00a9..a282059fec43 100644
> --- a/Documentation/scsi/g_NCR5380.txt
> +++ b/Documentation/scsi/g_NCR5380.rst
> @@ -1,7 +1,13 @@
> -README file for the Linux g_NCR5380 driver.
> +.. SPDX-License-Identifier: GPL-2.0
> +.. include:: <isonum.txt>
>  
> -(c) 1993 Drew Eckhard
> -NCR53c400 extensions (c) 1994,1995,1996 Kevin Lentin
> +==========================================
> +README file for the Linux g_NCR5380 driver
> +==========================================
> +
> +Copyright |copy| 1993 Drew Eckhard
> +
> +NCR53c400 extensions Copyright |copy| 1994,1995,1996 Kevin Lentin
>  
>  This file documents the NCR53c400 extensions by Kevin Lentin and some
>  enhancements to the NCR5380 core.
> @@ -26,43 +32,62 @@ time. More info to come in the future.
>  This driver works as a module.
>  When included as a module, parameters can be passed on the insmod/modprobe
>  command line:
> +
> +  ============= ===============================================================
>    irq=xx[,...]	the interrupt(s)
>    base=xx[,...]	the port or base address(es) (for port or memory mapped, resp.)
>    card=xx[,...]	card type(s):
> -		0 = NCR5380,
> -		1 = NCR53C400,
> -		2 = NCR53C400A,
> -		3 = Domex Technology Corp 3181E (DTC3181E)
> -		4 = Hewlett Packard C2502
> +
> +		==  ======================================
> +		0   NCR5380,
> +		1   NCR53C400,
> +		2   NCR53C400A,
> +		3   Domex Technology Corp 3181E (DTC3181E)
> +		4   Hewlett Packard C2502
> +		==  ======================================
> +  ============= ===============================================================
>  
>  These old-style parameters can support only one card:
> -  ncr_irq=xx   the interrupt
> -  ncr_addr=xx  the port or base address (for port or memory
> -               mapped, resp.)
> -  ncr_5380=1   to set up for a NCR5380 board
> -  ncr_53c400=1 to set up for a NCR53C400 board
> +
> +  ============= =================================================
> +  ncr_irq=xx    the interrupt
> +  ncr_addr=xx   the port or base address (for port or memory
> +                mapped, resp.)
> +  ncr_5380=1    to set up for a NCR5380 board
> +  ncr_53c400=1  to set up for a NCR53C400 board
>    ncr_53c400a=1 to set up for a NCR53C400A board
> -  dtc_3181e=1  to set up for a Domex Technology Corp 3181E board
> -  hp_c2502=1   to set up for a Hewlett Packard C2502 board
> -
> -E.g. Trantor T130B in its default configuration:
> -modprobe g_NCR5380 irq=5 base=0x350 card=1
> -or alternatively, using the old syntax,
> -modprobe g_NCR5380 ncr_irq=5 ncr_addr=0x350 ncr_53c400=1
> -
> -E.g. a port mapped NCR5380 board, driver to probe for IRQ:
> -modprobe g_NCR5380 base=0x350 card=0
> -or alternatively,
> -modprobe g_NCR5380 ncr_addr=0x350 ncr_5380=1
> -
> -E.g. a memory mapped NCR53C400 board with no IRQ:
> -modprobe g_NCR5380 irq=255 base=0xc8000 card=1
> -or alternatively,
> -modprobe g_NCR5380 ncr_irq=255 ncr_addr=0xc8000 ncr_53c400=1
> +  dtc_3181e=1   to set up for a Domex Technology Corp 3181E board
> +  hp_c2502=1    to set up for a Hewlett Packard C2502 board
> +  ============= =================================================
> +
> +E.g. Trantor T130B in its default configuration::
> +
> +	modprobe g_NCR5380 irq=5 base=0x350 card=1
> +
> +or alternatively, using the old syntax::
> +
> +	modprobe g_NCR5380 ncr_irq=5 ncr_addr=0x350 ncr_53c400=1
> +
> +E.g. a port mapped NCR5380 board, driver to probe for IRQ::
> +
> +	modprobe g_NCR5380 base=0x350 card=0
> +
> +or alternatively::
> +
> +	modprobe g_NCR5380 ncr_addr=0x350 ncr_5380=1
> +
> +E.g. a memory mapped NCR53C400 board with no IRQ::
> +
> +	modprobe g_NCR5380 irq=255 base=0xc8000 card=1
> +
> +or alternatively::
> +
> +	modprobe g_NCR5380 ncr_irq=255 ncr_addr=0xc8000 ncr_53c400=1
>  
>  E.g. two cards, DTC3181 (in non-PnP mode) at 0x240 with no IRQ
> -and HP C2502 at 0x300 with IRQ 7:
> -modprobe g_NCR5380 irq=0,7 base=0x240,0x300 card=3,4
> +and HP C2502 at 0x300 with IRQ 7::
> +
> +	modprobe g_NCR5380 irq=0,7 base=0x240,0x300 card=3,4
>  
>  Kevin Lentin
>  K.Lentin@cs.monash.edu.au
> diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
> index aad8359357e6..4b577c9e804e 100644
> --- a/Documentation/scsi/index.rst
> +++ b/Documentation/scsi/index.rst
> @@ -20,5 +20,6 @@ Linux SCSI Subsystem
>     dc395x
>     dpti
>     FlashPoint
> +   g_NCR5380
>  
>     scsi_transport_srp/figures
> diff --git a/Documentation/scsi/scsi-parameters.txt b/Documentation/scsi/scsi-parameters.txt
> index 266fd3b2398a..864bbf7f737b 100644
> --- a/Documentation/scsi/scsi-parameters.txt
> +++ b/Documentation/scsi/scsi-parameters.txt
> @@ -57,13 +57,13 @@ parameters may be changed at runtime by the command
>  			See header of drivers/scsi/NCR_D700.c.
>  
>  	ncr5380=	[HW,SCSI]
> -			See Documentation/scsi/g_NCR5380.txt.
> +			See Documentation/scsi/g_NCR5380.rst.
>  
>  	ncr53c400=	[HW,SCSI]
> -			See Documentation/scsi/g_NCR5380.txt.
> +			See Documentation/scsi/g_NCR5380.rst.
>  
>  	ncr53c400a=	[HW,SCSI]
> -			See Documentation/scsi/g_NCR5380.txt.
> +			See Documentation/scsi/g_NCR5380.rst.
>  
>  	ncr53c8xx=	[HW,SCSI]
>  
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1e2ab816fe66..451a3f67d23a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11533,7 +11533,7 @@ M:	Finn Thain <fthain@telegraphics.com.au>
>  M:	Michael Schmitz <schmitzmic@gmail.com>
>  L:	linux-scsi@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/scsi/g_NCR5380.txt
> +F:	Documentation/scsi/g_NCR5380.rst
>  F:	drivers/scsi/NCR5380.*
>  F:	drivers/scsi/arm/cumana_1.c
>  F:	drivers/scsi/arm/oak.c
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 2ab774e62e40..2cc676e3df6a 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -20,7 +20,7 @@
>   * Added ISAPNP support for DTC436 adapters,
>   * Thomas Sailer, sailer@ife.ee.ethz.ch
>   *
> - * See Documentation/scsi/g_NCR5380.txt for more info.
> + * See Documentation/scsi/g_NCR5380.rst for more info.
>   */
>  
>  #include <asm/io.h>
> 
