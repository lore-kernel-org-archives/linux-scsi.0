From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] sanitize ->bios_param prototype
Date: Fri, 25 Oct 2002 12:18:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210251718.g9PHIpP03406@localhost.localdomain>
References: <hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA24682
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2002 10:18:57 -0700
In-Reply-To: Message from Christoph Hellwig <hch@lst.de>
   of "Fri, 25 Oct 2002 04:17:35 +0200." <20021025041735.A28857@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

hch@lst.de said:
> (aka Scsi_Disk or Disk) to each and every lowlevel driver, although
> this structure should be privated to the sd driver.

> All bios_param implementation do only use two fields:  .device and
> .capacity.  This patch passes down those two directly and gets rid of
> 99% of the sd.h inclusions (*).

> I've tried to not break any driver with this patch, but given the
> number of compiler errors in the current tree I might have missed one
> or two. 

I'm getting:

Loading scsi_mod module
/lib/scsi_mod.o: unresolved symbol __udivdi3

The problem seems to be the definition of sector_t for the division.  If I 
make this fix:

===== drivers/scsi/scsicam.c 1.10 vs edited =====
--- 1.10/drivers/scsi/scsicam.c Thu Oct 24 19:29:22 2002
+++ edited/drivers/scsi/scsicam.c       Fri Oct 25 12:10:40 2002
@@ -80,11 +80,11 @@
        if (ret || ip[0] > 255 || ip[1] > 63) {
                ip[0] = 64;
                ip[1] = 32;
-               if ((capacity / (ip[0] * ip[1])) > 65534) {
+               if (((unsigned long)capacity / (ip[0] * ip[1])) > 65534) {
                        ip[0] = 255;
                        ip[1] = 63;
                }
-               ip[2] = capacity / (ip[0] * ip[1]);
+               ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
        }
 
        return 0;

Then everything works fine.  This is obviously not the correct fix, but it's 
as good as the previous code, so it should be OK.

James



