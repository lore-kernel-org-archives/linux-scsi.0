From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v3 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Mon, 26 Jun 2017 21:27:03 +0200
Message-ID: <201706262127.03911.linux@rainbow-software.org>
References: <cover.1498461406.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:47783 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbdFZT1U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 15:27:20 -0400
In-Reply-To: <cover.1498461406.git.fthain@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

On Monday 26 June 2017 09:30:33 Finn Thain wrote:
> Ondrej, would you please test this new series?
>
> Changed since v1:
> - PDMA transfer residual is calculated earlier.
> - End of DMA flag check is now polled (if there is any residual).
>
> Changed since v2:
> - Bail out of transfer loops when Gated IRQ gets asserted.
> - Make udelay conditional on board type.
> - Drop sg_tablesize patch due to performance regression.
>
>
> Finn Thain (1):
>   g_NCR5380: Cleanup comments and whitespace
>
> Ondrej Zary (3):
>   g_NCR5380: Fix PDMA transfer size
>   g_NCR5380: End PDMA transfer correctly on target disconnection
>   g_NCR5380: Re-work PDMA loops
>
>  drivers/scsi/g_NCR5380.c | 239
> +++++++++++++++++++++++------------------------ 1 file changed, 116
> insertions(+), 123 deletions(-)

No apparent change in behavior, the first write test resulted in:
[  842.830802] sd 2:0:1:0: [sdb] tag#0 53c80 registers not accessible, device will be reset
[  842.830802] sd 2:0:1:0: [sdb] tag#0 switching to slow handshake

Checking for IRQ after poll_politely2 does not seem right because we can
miss the buffer ready signal.

According to my tests, buffer ready signal is most important - if there is
any data to read/write, do the transfer. If not, only then check why - maybe
we got an IRQ (that terminated PDMA). Or no IRQ, sometimes the wait for buffer
ready times out - we need to terminate PDMA manually then (reset).

Then 53C80 registers should become ready.

This is a log from writing 230 MB file using my code with some debug
prints, on a NCR53C400. No 53C80 timeouts, only disconnects and some host
buffer timeouts (maybe the drive sometimes just slows down without
disconnecting?)
[ 3378.503828] basr=0x10 csr=0xd5 at start=512
[ 3461.257973] w basr=0x10 csr=0x95 at start=3840
[ 3461.838225] w basr=0x10 csr=0x95 at start=3840
[ 3462.683446] w basr=0x10 csr=0x95 at start=3840
[ 3463.416911] w basr=0x10 csr=0x95 at start=3840
[ 3465.117804] scsi host2: 53C400w: host buffer not ready in time
[ 3465.276375] w basr=0x10 csr=0x95 at start=3328
[ 3466.457701] w basr=0x10 csr=0x95 at start=1792
[ 3467.019643] scsi host2: 53C400w: host buffer not ready in time
[ 3467.619058] scsi host2: 53C400w: host buffer not ready in time
[ 3467.799619] w basr=0x10 csr=0x95 at start=3840
[ 3552.123501] w basr=0x10 csr=0x95 at start=2304
[ 3552.771223] w basr=0x10 csr=0x95 at start=1280
[ 3554.556451] w basr=0x10 csr=0x95 at start=2816
[ 3555.229646] w basr=0x10 csr=0x95 at start=1792
[ 3555.630632] scsi host2: 53C400w: host buffer not ready in time
[ 3555.774560] w basr=0x10 csr=0x95 at start=768
[ 3625.541608] w basr=0x10 csr=0x95 at start=3328
[ 3640.099861] w basr=0x10 csr=0x95 at start=1792
[ 3641.442671] w basr=0x10 csr=0x95 at start=2816
[ 3641.865469] w basr=0x10 csr=0x95 at start=768
[ 3642.939223] w basr=0x10 csr=0x95 at start=1280
[ 3643.356858] w basr=0x10 csr=0x95 at start=3328
[ 3643.701636] w basr=0x10 csr=0x95 at start=3840
[ 3645.153405] w basr=0x10 csr=0x95 at start=2304
[ 3646.135642] w basr=0x10 csr=0x95 at start=1280
[ 3647.007321] w basr=0x10 csr=0x95 at start=2816
[ 3648.065874] w basr=0x10 csr=0x95 at start=3328
[ 3650.071961] w basr=0x10 csr=0x95 at start=1280
[ 3650.827630] w basr=0x10 csr=0x95 at start=1792
[ 3651.827011] w basr=0x10 csr=0x95 at start=2816
[ 3652.559984] w basr=0x10 csr=0x95 at start=2816
[ 3653.203566] w basr=0x10 csr=0x95 at start=3328
[ 3653.594376] w basr=0x10 csr=0x95 at start=1280
[ 3653.903437] w basr=0x10 csr=0x95 at start=3840
[ 3654.305753] w basr=0x10 csr=0x95 at start=1792
[ 3654.676009] w basr=0x10 csr=0x95 at start=2304
[ 3655.367686] w basr=0x10 csr=0x95 at start=2816
[ 3655.733854] w basr=0x10 csr=0x95 at start=768
[ 3656.075023] w basr=0x10 csr=0x95 at start=3328
[ 3656.493046] w basr=0x10 csr=0x95 at start=2816
[ 3657.208089] w basr=0x10 csr=0x95 at start=1280
[ 3657.537223] w basr=0x10 csr=0x95 at start=1280

And this is from reading the file back:
[ 3799.053067] basr=0x10 csr=0xd5 at start=512
[ 3801.056337] basr=0x10 csr=0xd5 at start=3584
[ 3976.323836] scsi host2: 53C400r: host buffer not ready in time
[ 3976.404699] basr=0x10 csr=0xd5 at start=512
[ 3977.800647] basr=0x10 csr=0xd5 at start=512
[ 3979.240611] scsi host2: 53C400r: host buffer not ready in time
[ 3979.320698] basr=0x10 csr=0xd5 at start=512
[ 3980.040220] scsi host2: 53C400r: host buffer not ready in time
[ 3980.096401] basr=0x10 csr=0xd5 at start=512
[ 3980.394854] scsi host2: 53C400r: host buffer not ready in time


-- 
Ondrej Zary
