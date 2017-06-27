From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v3 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Tue, 27 Jun 2017 08:28:39 +0200
Message-ID: <201706270828.40336.linux@rainbow-software.org>
References: <cover.1498461406.git.fthain@telegraphics.com.au> <201706262127.03911.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:55970 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdF0G2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 02:28:46 -0400
In-Reply-To: <201706262127.03911.linux@rainbow-software.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

On Monday 26 June 2017, Ondrej Zary wrote:
> On Monday 26 June 2017 09:30:33 Finn Thain wrote:
> > Ondrej, would you please test this new series?
> >
> > Changed since v1:
> > - PDMA transfer residual is calculated earlier.
> > - End of DMA flag check is now polled (if there is any residual).
> >
> > Changed since v2:
> > - Bail out of transfer loops when Gated IRQ gets asserted.
> > - Make udelay conditional on board type.
> > - Drop sg_tablesize patch due to performance regression.
> >
> >
> > Finn Thain (1):
> >   g_NCR5380: Cleanup comments and whitespace
> >
> > Ondrej Zary (3):
> >   g_NCR5380: Fix PDMA transfer size
> >   g_NCR5380: End PDMA transfer correctly on target disconnection
> >   g_NCR5380: Re-work PDMA loops
> >
> >  drivers/scsi/g_NCR5380.c | 239
> > +++++++++++++++++++++++------------------------ 1 file changed, 116
> > insertions(+), 123 deletions(-)

BTW. I've probably found the DTC write corruption.
Added the following check (13 is host buffer index register) - and it triggers 
sometimes: the value is 1 instead of 0. As we use only 16-bit writes, I don't 
see how the value could ever be odd. Looks like a bug in the chip.
The index register corrupts during the transfer, not after IRQ or timeout. The 
same check at beginning of pwrite() did not trigger.

The index register is not writable so we must(?) reset the PDMA engine to 
recover. However, this quick attempt to fix does not work, maybe we should 
reload the block count and continue?

--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -595,7 +603,13 @@ static inline int generic_NCR5380_pwrite(struct 
NCR5380_hostdata *hostdata,
                                goto out_wait;
                        }
                }
-
+               idx = NCR5380_read(13);
+               if (idx != 0) {
+                       printk("host idx=%d, start=%d\n", idx, start);
+                       NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
+                       NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
+                       goto out_wait;
+               }
                if (hostdata->io_port && hostdata->io_width == 2)
                        outsw(hostdata->io_port + hostdata->c400_host_buf,
                                                        src + start, 64);


-- 
Ondrej Zary
