From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sym53c500_cs PCMCIA SCSI driver (round 3 - the charm?)
Date: Sun, 25 Apr 2004 15:34:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040425153420.A27073@infradead.org>
References: <20040420172447.A27454@infradead.org> <20040425030154.52120DBDB@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:45325 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263095AbUDYOeV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Apr 2004 10:34:21 -0400
Content-Disposition: inline
In-Reply-To: <20040425030154.52120DBDB@gherkin.frus.com>; from rct@gherkin.frus.com on Sat, Apr 24, 2004 at 10:01:54PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-scsi@vger.kernel.org

On Sat, Apr 24, 2004 at 10:01:54PM -0500, Bob Tracy wrote:
> Barring any remaining issues (Christoph?), I think we're finally ready
> for prime time :-).

there's still a bunch of minor issues.  If you don't have them cleaned
up until James' next push to Linux I'd say include the current variant
and fix it up later, else I'd say wait for the next revision.

> +*  proc_info() is deprecated in 2.6.  Set this to 1 if you want to
> +*  see the entries under /proc that were there in earlier kernels.
> +*/
> +#define PROC_INFO 1

please set this to 0 for submission.  in fact I think it should really
go away for submission.  if you want it for personal use - fine.  But
a new 2.6 driver shouldn't implement ->proc_info anymore but rather
use sysfs if nessecery.

> +#include <linux/stat.h>

I don't think you need this one at all.

> +#include <asm/bitops.h>

use linux/bitops.h instead.

> +/* Static function prototypes: needed for scsi_host_template initializer. */
> +
> +static int SYM53C500_abort(struct scsi_cmnd *);
> +static const char *SYM53C500_info(struct Scsi_Host *);
> +#if PROC_INFO
> +static int SYM53C500_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
> +#endif
> +static int SYM53C500_queue(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
> +static int SYM53C500_host_reset(struct scsi_cmnd *);
> +static int SYM53C500_biosparm(struct scsi_device *, struct block_device *, sector_t, int *);

What speaks against removing this and declaring the host template after
all these function but before the pcmcia interface code?

(sorry for not answering your previous mail on this, have been busy)

> +static dev_link_t *dev_list = NULL;

you don't need to initialize this to NULL, the compiler will do for you.

> +	if (irq_level > 0) {
> +		if (request_irq(irq_level, SYM53C500_intr, 0, "SYM53C500", host)) {
> +			printk("SYM53C500: unable to allocate IRQ %d\n", irq_level);
> +			goto err_free_scsi;
> +		}
> +		tpnt->can_queue = 1;
> +		DEB(printk("SYM53C500: allocated IRQ %d\n", irq_level));
> +	} else if (irq_level == 0) {
> +		tpnt->can_queue = 0;
> +		DEB(printk("SYM53C500: No interrupts detected\n"));
> +		goto err_free_scsi;
> +	} else {
> +		DEB(printk("SYM53C500: Shouldn't get here!\n"));
> +		goto err_free_scsi;
> +	}

can_queue = 0 isn't valid anymore in 2.6.

> +static int
> +SYM53C500_abort(struct scsi_cmnd *SCpnt)
> +{
> +	DEB(printk("SYM53C500_abort called\n"));
> +	return FAILED;		/* Don't know how to abort */
> +}

no need to implement it if it returns FAILED always.

> +	/*
> +	*  The standard comment seen at this point in almost
> +	*  every low-level SCSI driver is:
> +	*
> +	*  XXX: this really needs to move into generic code...
> +	*
> +	*  In 2.6, it evidently has been: a debug printk() will
> +	*  show dev_list to be NULL on entry into the while().
> +	*
> +	while (dev_list != NULL)
> +		SYM53C500_detach(dev_list);
> +	*/

I'd say just kill this..

