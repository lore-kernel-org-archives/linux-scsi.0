From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 04/18] libosd: OSDv1 preliminary implementation
Date: Tue, 4 Nov 2008 19:03:47 +0100
Message-ID: <20081104180347.GA9818@uranus.ravnborg.org>
References: <491073BB.4000900@panasas.com> <1225817069-5969-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755349AbYKDSHm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1225817069-5969-1-git-send-email-bharrosh@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, open-osd ml <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Sami.Iren@seagate.com, Pete Wyckoff <pw@padd.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 04, 2008 at 06:44:29PM +0200, Boaz Harrosh wrote:
> Implementation of the most basic OSD functionality and
> infrastructure. Mainly Format, Create/Remove Partition,
> Create/Remove Object, and read/write.
> 
> - Add Makefile and Kbuild to compile libosd.ko
> - osd_initiator.c Implementation file for osd_initiator.h
>   and osd_sec.h APIs
> - osd_debug.h - Some kprintf macro definitions

A few comments below.

	Sam


> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Reviewed-by: Benny Halevy <bhalevy@panasas.com>
> ---
>  drivers/scsi/osd/Kbuild          |   26 +++
>  drivers/scsi/osd/Makefile        |   37 +++
>  drivers/scsi/osd/osd_debug.h     |   27 +++
>  drivers/scsi/osd/osd_initiator.c |  450 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 540 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/osd/Kbuild
>  create mode 100755 drivers/scsi/osd/Makefile
>  create mode 100644 drivers/scsi/osd/osd_debug.h
>  create mode 100644 drivers/scsi/osd/osd_initiator.c
> 
> diff --git a/drivers/scsi/osd/Kbuild b/drivers/scsi/osd/Kbuild
> new file mode 100644
> index 0000000..b4678e0
> --- /dev/null
> +++ b/drivers/scsi/osd/Kbuild
> @@ -0,0 +1,26 @@
> +#
> +# Kbuild for the OSD modules
> +#
> +# Copyright (C) 2008 Panasas Inc.  All rights reserved.
> +#
> +# Authors:
> +#   Boaz Harrosh <bharrosh@panasas.com>
> +#   Benny Halevy <bhalevy@panasas.com>
> +#
> +# This program is free software; you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License version 2
> +#
> +
> +ifneq ($(OSD_INC),)
> +# we are built out-of-tree Kconfigure everything as on
> +
> +CONFIG_SCSI_OSD_INITIATOR=m
> +EXTRA_CFLAGS += -DCONFIG_SCSI_OSD_INITIATOR -DCONFIG_SCSI_OSD_INITIATOR_MODULE
> +
> +EXTRA_CFLAGS += -I$(OSD_INC)
> +# EXTRA_CFLAGS += -DCONFIG_SCSI_OSD_DEBUG
> +
> +endif
> +
> +libosd-objs := osd_initiator.o
> +obj-$(CONFIG_SCSI_OSD_INITIATOR) += libosd.o

When you submit for inclusion please clean this up.
1) use ccflags-y as replacement for EXTRA_CFLAGS
2) use libosd-y as replacement for libosd-objs

> +
> +#ifdef CONFIG_SCSI_OSD_INITIATOR_MODULE
> +MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
> +MODULE_DESCRIPTION("open-osd initiator library libosd.ko");
> +MODULE_LICENSE("GPL");
> +#endif

no ifdef around here.

> +void osd_dev_init(struct osd_dev *osdd, struct scsi_device *scsi_dev)
> +{
> +	memset(osdd, 0, sizeof(*osdd));
> +	osdd->scsi_dev = scsi_dev;
> +	osdd->def_timeout = BLK_DEFAULT_SG_TIMEOUT;
> +	/* TODO: Allocate pools for osd_request attributes ... */
> +}
> +EXPORT_SYMBOL(osd_dev_init);
kernel-doc comments for all exported funtions / variables.
