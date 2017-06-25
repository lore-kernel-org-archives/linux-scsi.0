From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v2 0/5] g_NCR5380: PDMA fixes and cleanup
Date: Sun, 25 Jun 2017 11:26:23 +0200
Message-ID: <201706251126.23739.linux@rainbow-software.org>
References: <cover.1498285948.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:57156 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbdFYJ0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jun 2017 05:26:39 -0400
In-Reply-To: <cover.1498285948.git.fthain@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

On Saturday 24 June 2017 08:37:36 Finn Thain wrote:
> Ondrej, would you please test this new series?
>
> Changed since v1:
> - PDMA transfer residual is calculated earlier.
> - End of DMA flag check is now polled (if there is any residual).
>
>
> Finn Thain (2):
>   g_NCR5380: Limit sg_tablesize to avoid PDMA read overruns on DTC436
>   g_NCR5380: Cleanup comments and whitespace
>
> Ondrej Zary (3):
>   g_NCR5380: Fix PDMA transfer size
>   g_NCR5380: End PDMA transfer correctly on target disconnection
>   g_NCR5380: Re-work PDMA loops
>
>  drivers/scsi/g_NCR5380.c | 231
> ++++++++++++++++++++++------------------------- 1 file changed, 107
> insertions(+), 124 deletions(-)

It mostly works, but there are some problems:

It's not reliable - we continue the data transfer after poll_politely2
returns zero but we don't know if it returned because of host buffer
being ready of because of an IRQ. So if a device disconnects during write,
we continue to fill the buffer and only then find out that wait for
53c80 registers timed out. Then PDMA gets disabled:
[ 3458.774251] sd 2:0:1:0: [sdb] tag#0 53c80 registers not accessible, device will be reset
[ 3458.774251] sd 2:0:1:0: [sdb] tag#0 switching to slow handshake

We can just reset and continue with a new PDMA transfer. Found no problems
with reads. But when this happens during a write, we might have lost some
data buffers that we need to transfer again. The chip's PDMA block counter
does not seem to be very helpful here - testing shows that either one buffer
is missing in the file or is duplicated.

That's why my code had separate host buffer ready and IRQ checks. Host
buffer first - if it's ready, transfer the data. If not, check for IRQ - 
if it was an error, rollback 2 buffers (the same if the host buffer is not
ready in time).



There's also a performance regression on DTC436 - the sg_tablesize limit
affects performance badly.
Before:
# hdparm -t --direct /dev/sdb

/dev/sdb:
 Timing O_DIRECT disk reads:   4 MB in  3.21 seconds =   1.25 MB/sec

Now:
# hdparm -t --direct /dev/sdb

/dev/sdb:
 Timing O_DIRECT disk reads:   4 MB in  4.89 seconds = 837.69 kB/sec

We should limit the transfer size instead:
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -45,7 +45,8 @@
        int c400_blk_cnt; \
        int c400_host_buf; \
        int io_width; \
-       int pdma_residual
+       int pdma_residual; \
+       int board;

 #define NCR5380_dma_xfer_len            generic_NCR5380_dma_xfer_len
 #define NCR5380_dma_recv_setup          generic_NCR5380_pread
@@ -247,7 +248,6 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
        case BOARD_DTC3181E:
                ports = dtc_3181e_ports;
                magic = ncr_53c400a_magic;
-               tpnt->sg_tablesize = 1;
                break;
        }

@@ -317,6 +317,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
        }
        hostdata = shost_priv(instance);

+       hostdata->board = board;
        hostdata->io = iomem;
        hostdata->region_size = region_size;

@@ -625,6 +626,9 @@ static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
        /* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
        if (transfersize % 128)
                transfersize = 0;
+       /* Limit transfers to 512B to prevent random write corruption on DTC */
+       if (hostdata->board == BOARD_DTC3181E && transfersize > 512)
+               transfersize = 512;

        return min(transfersize, DMA_MAX_SIZE);
 }


No data corruption and no performance regression:
# hdparm -t --direct /dev/sdb

/dev/sdb:
 Timing O_DIRECT disk reads:   4 MB in  3.25 seconds =   1.23 MB/sec

As the data corruption affects only writes, we could keep transfersize
unlimited for reads:
+       /* Limit write transfers to 512B to prevent random corruption on DTC */
+       if (hostdata->board == BOARD_DTC3181E &&
+           cmd->sc_data_direction == DMA_TO_DEVICE && transfersize > 512)
+               transfersize = 512;

So we can get some performance gain at least for reads:
# hdparm -t --direct /dev/sdb

/dev/sdb:
 Timing O_DIRECT disk reads:   6 MB in  4.17 seconds =   1.44 MB/sec


-- 
Ondrej Zary
