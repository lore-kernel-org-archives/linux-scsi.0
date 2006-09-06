From: Olaf Hering <olaf@aepfle.de>
Subject: Re: Linux 2.6.18-rc6
Date: Wed, 6 Sep 2006 14:09:54 +0200
Message-ID: <20060906120954.GA12548@aepfle.de>
References: <Pine.LNX.4.64.0609031939100.27779@g5.osdl.org> <20060905122656.GA3650@aepfle.de> <1157490066.3463.73.camel@mulgrave.il.steeleye.com> <1157494837.22705.151.camel@localhost.localdomain> <1157498567.3463.91.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750780AbWIFMKU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1157498567.3463.91.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Linus Torvalds <torvalds@osdl.org>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 05, James Bottomley wrote:

> On Wed, 2006-09-06 at 08:20 +1000, Benjamin Herrenschmidt wrote:
> > Yes, it's a PCI error.
> 
> Thanks, and the cat of /proc/scsi_host/host<n>/signalling?
> 
> My suspicion is the register doesn't actually exist on this card so it
> doesn't actually respond on the bus.  However, on my equivalent
> everything works; largely I think because the only PC's I have don't
> know how to signal a PCI error.

Where is that area mapped?
It crashes already if I read port 0.
Everything works if I also add the second hunk to disable signalling.

Index: linux-2.6.17/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- linux-2.6.17.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ linux-2.6.17/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2539,8 +2539,15 @@ static void ahc_linux_set_iu(struct scsi
 static void ahc_linux_get_signalling(struct Scsi_Host *shost)
 {
        struct ahc_softc *ahc = *(struct ahc_softc **)shost->hostdata;
-       u8 mode = ahc_inb(ahc, SBLKCTL);
+       int i;
+       u8 mode;
+       for (i=0;i!=SBLKCTL;i++) {
+               printk("i 0x%02x ",i);
+               mode = ahc_inb(ahc, i);
+               printk("m 0x%02x\n",mode);
 
+       }
+       mode = ahc_inb(ahc, SBLKCTL);
        if (mode & ENAB40)
                spi_signalling(shost) = SPI_SIGNAL_LVD;
        else if (mode & ENAB20)
@@ -2566,8 +2573,8 @@ static struct spi_function_template ahc_
        .show_iu        = 1,
        .set_qas        = ahc_linux_set_qas,
        .show_qas       = 1,
-#endif
        .get_signalling = ahc_linux_get_signalling,
+#endif
 };
 
 
