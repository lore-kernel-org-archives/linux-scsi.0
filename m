From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: gdth SCSI driver(?) fails with more than 4GB of memory
Date: Tue, 18 Jul 2006 09:30:19 -0400
Message-ID: <1153229420.3704.17.camel@mulgrave.il.steeleye.com>
References: <20060717184659.04ae83e7.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:34260 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932198AbWGRNav (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jul 2006 09:30:51 -0400
In-Reply-To: <20060717184659.04ae83e7.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Andreas Barth <aba@not.so.argh.org>

On Mon, 2006-07-17 at 18:46 -0700, Andrew Morton wrote:
> If the kernel has 6GB, I directly get error messages like:
> SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
> sda: Write Protect is off
> sda: got wrong page
> sda: assuming drive cache: write through
> SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
> sda: Write Protect is off
> sda: got wrong page
> 
> The disk array controller is of type GDT8114RZ and has the most current
> firmware version. The box has 4 Xeon CPUs, and physical 6 GB of memory.
> The /-device is on the controller in question.
> 
> The full log (for 4 and for 6 GB) is put up on
> http://neualius.turmzimmer.net/~aba/6GB

My strongest suspicion here is that the device is lying when it claims
to support 64 bit DMA. Can you try this?  It will turn off 64 bit DMA
and only allow 32 bit DMA on your 6GB platform.  If that works, we'll
beed help from the gdth people to understand the issue.

Thanks,

James

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 43afd47..83cf3ca 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -1543,7 +1543,7 @@ static int __init gdth_init_pci(gdth_pci
         if (prot_ver < 0x2b)      /* FW < x.43: no 64-bit DMA support */
             ha->dma64_support = 0;
         else 
-            ha->dma64_support = 1;
+            ha->dma64_support = 0;
     }
 
     return 1;


