From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sanitize ->bios_param prototype
Date: Fri, 25 Oct 2002 19:53:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025195328.A3124@lst.de>
References: <hch@lst.de> <200210251718.g9PHIpP03406@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210251718.g9PHIpP03406@localhost.localdomain>; from James.Bottomley@steeleye.com on Fri, Oct 25, 2002 at 12:18:51PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Fri, Oct 25, 2002 at 12:18:51PM -0500, James Bottomley wrote:
> hch@lst.de said:
> > (aka Scsi_Disk or Disk) to each and every lowlevel driver, although
> > this structure should be privated to the sd driver.
> 
> > All bios_param implementation do only use two fields:  .device and
> > .capacity.  This patch passes down those two directly and gets rid of
> > 99% of the sd.h inclusions (*).
> 
> > I've tried to not break any driver with this patch, but given the
> > number of compiler errors in the current tree I might have missed one
> > or two. 
> 
> I'm getting:
> 
> Loading scsi_mod module
> /lib/scsi_mod.o: unresolved symbol __udivdi3
> 
> The problem seems to be the definition of sector_t for the division.  If I 
> make this fix:

Ooops - I tested without CONFIG_LBD defined where it's 32bit so I
couldn't trap this bug.  I think the right fix would be
to use sector_div (warning, hand-edit patch):

--- 1.10/drivers/scsi/scsicam.c Thu Oct 24 19:29:22 2002
+++ edited/drivers/scsi/scsicam.c       Fri Oct 25 12:10:40 2002
@@ -80,11 +80,12 @@
        if (ret || ip[0] > 255 || ip[1] > 63) {
                ip[0] = 64;
                ip[1] = 32;
-               if ((capacity / (ip[0] * ip[1])) > 65534) {
+               if (((unsigned long)capacity / (ip[0] * ip[1])) > 65534) {
                        ip[0] = 255;
                        ip[1] = 63;
                }
-               ip[2] = capacity / (ip[0] * ip[1]);
+         	sector_div(capacity, (ip[0] * ip[1]));      
+		ip[2] = capacity;
        }
 
        return 0;

