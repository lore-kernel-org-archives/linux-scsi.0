From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [ADVANSYS] Add basic highmem/DMA support
Date: Wed, 23 Jun 2004 16:35:17 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D924A5.5020705@torque.net>
References: <20040508003906.GA26338@gondor.apana.org.au>		<20040519103800.GA9891@gondor.apana.org.au>	<1086026538.2004.7.camel@mulgrave>  <40D69F56.2000307@torque.net> <1087828082.1797.17.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030002080806030903050600"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:25093 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S266014AbUFWGfr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 02:35:47 -0400
In-Reply-To: <1087828082.1797.17.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Gene Heskett <gene.heskett@verizon.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030002080806030903050600
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Mon, 2004-06-21 at 03:41, Douglas Gilbert wrote:
> 
>>I just tested it in lk 2.6.7-bk2 and the advansys driver is
>>broken. The disk access light stays on for several seconds
>>while it tries to read the partition table after which it
>>announces "unknown partition table". Since my rootfs is on
>>that disk it's all downhill from there.
> 
> 
> To be sure: the inquiry goes through and produces the correct result,
> and the read capacity, but then the read partition table fails?
> 
> If so, I think that sounds like a failure in the use_sg != 0 path.

Here are some more datapoints. There are at least 3 categories
of adapters handled by the advansys driver:
   - ISA: broken in lk 2.6 series
   - PCI narrow (8 bit SCSI bus e.g. ABP-940U): working in 2.6.7-bk2
   - PCI wide (16 bit SCSI bus, e.g. ASB-3940U2W): broken in 2.6.7-bk2
     but was working in lk 2.6.7

By playing around with the U2W adapter I found that it does
work when use_sg==0 but the returned data becomes incorrect
30 bytes into the transfer when use_sg==2. It is almost as if
the scatter gather DMA kicks off ok then stalls taking
several seconds to complete (with no timeout).

This was tested with:
   sg_dd if=/dev/sg1 of=t bs=512 count=63
   sg_dd if=/dev/sg1 of=tt bs=512 count=65

Since the sg driver bypasses scatter gather when the transfer
is <= 32 KB then the first sg_dd works and the second one
fails as described above.

Any suggestions for further testing?

Attached is a small patch to bump the version number
and fix the compile error when ADVANSYS_DEBUG is
defined.

Doug Gilbert



--------------030002080806030903050600
Content-Type: text/plain;
 name="advansys_267bk2deb"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="advansys_267bk2deb"

--- linux/drivers/scsi/advansys.c	2004-06-22 16:56:10.000000000 +1000
+++ linux/drivers/scsi/advansys.c267bk2deb	2004-06-23 16:28:45.599854928 +1000
@@ -1,4 +1,4 @@
-#define ASC_VERSION "3.3GJ"    /* AdvanSys Driver Version */
+#define ASC_VERSION "3.3K"    /* AdvanSys Driver Version */
 
 /*
  * advansys.c - Linux Host Driver for AdvanSys SCSI Adapters
@@ -9198,9 +9198,7 @@
 " timeout_per_command %d, timeout_total %d, timeout %d\n",
         s->timeout_per_command, s->timeout_total, s->timeout);
 
-    printk(
-" internal_timeout %u, flags %u\n",
-        s->internal_timeout, s->flags);
+    printk(" internal_timeout %u\n", s->internal_timeout);
 
     printk(
 " scsi_done 0x%lx, done 0x%lx, host_scribble 0x%lx, result 0x%x\n",

--------------030002080806030903050600--
