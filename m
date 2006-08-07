From: Andreas Barth <aba@not.so.argh.org>
Subject: Re: Fw: gdth SCSI driver(?) fails with more than 4GB of memory
Date: Mon, 7 Aug 2006 17:26:06 +0200
Message-ID: <20060807152606.GR18390@mails.so.argh.org>
References: <20060717184659.04ae83e7.akpm@osdl.org> <200607180840.11877.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from neualius.turmzimmer.net ([217.160.169.58]:21438 "EHLO
	neualius.turmzimmer.net") by vger.kernel.org with ESMTP
	id S932145AbWHGP0w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:26:52 -0400
Content-Disposition: inline
In-Reply-To: <200607180840.11877.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-scsi@vger.kernel.org

* Rolf Eike Beer (eike-kernel@sf-tec.de) [060718 08:46]:
> Andreas Barth wrote:
> 
> > [please Cc me, I'm currently not subscribed.]
> 
> > I have noticed that one of my boxes stopped to boot correctly after
> > adding more memory (in total 6 GB) and loading an adjusted kernel for
> > that.  After some testing around, we noticed that it is enough for the
> > kernel to boot correctly if we limit the kernel to use 4GB of memory.
> >
> > If the kernel has 6GB, I directly get error messages like:
> > SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
> > sda: Write Protect is off
> > sda: got wrong page
> > sda: assuming drive cache: write through
> > SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
> > sda: Write Protect is off
> > sda: got wrong page
> 
> This is from sd.c::sd_read_cache_type
> 
> > Any hints for me how I can use the full 6 GB of memory (and/or what I
> > should try out to find the bug)?
> 
> Please change the printk in sd.c around 1482 that is
> 
> printk(KERN_ERR "%s: got wrong page\n", diskname);
> 
> to
> 
> printk(KERN_ERR "%s: got wrong page (expect: 0x%x, got 0x%x)\n",
> diskname, modepage, buffer[offset]);

With this patch, it returns now:
SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
sda: Write Protect is off
sda: got wrong page (expect: 0x8, got 0x0)
sda: assuming drive cache: write through
SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
sda: Write Protect is off
sda: got wrong page (expect: 0x8, got 0x0)

(Full log with your and this patch:
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
put at http://neualius.turmzimmer.net/~aba/6G/kernel-20060807.log .
If you rather want your patch alone, please tell me.)



Cheers,
Andi
-- 
  http://home.arcor.de/andreas-barth/
