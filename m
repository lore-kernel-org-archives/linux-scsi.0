From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [RESEND] SCSI: ips: remove pointless #warning
Date: Tue, 19 May 2015 11:38:17 -0700
Message-ID: <1432060697.14737.1.camel@HansenPartnership.com>
References: <3121960.dnOqT9LCth@wuerfel>
	 <1432043572.3007.14.camel@HansenPartnership.com>
	 <2850783.725LtIIUFq@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33974 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842AbbESSi2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2015 14:38:28 -0400
In-Reply-To: <2850783.725LtIIUFq@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org

On Tue, 2015-05-19 at 15:56 +0200, Arnd Bergmann wrote:
> On Tuesday 19 May 2015 06:52:52 James Bottomley wrote:
> > On Tue, 2015-05-19 at 15:33 +0200, Arnd Bergmann wrote:
> > > The ips driver contains
> > > 
> > >  #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
> > > 
> > > which gets printed by the compiler every time this driver gets
> > > build for something other than those three architectures. The same
> > > is true for most other drivers, but none of them prints a warning like
> > > this.
> > > 
> > > Let's remove the warning now to reduce the amount of clutter.
> > > 
> > > FWIW, I've reviewed the driver and found a few oddities, but nothing
> > > that needs to be fixed or that would be architecture specific.
> > 
> > In principle I don't disagree.  However this warning was a specific
> > request of the driver writers.  Since the driver is pretty much dead,
> > I'm not sure anyone is going to check or fix it for non-intel any time
> > soon.
> 
> My main interest here is to get a clean build of ARM 'allmodconfig'.
> 
> If you prefer another approach, we could also add 'depends on X86 || IA64'
> into Kconfig, which would also avoid that warning.

Actually, no, that would cause problems if anyone is actually using this
driver on non-intel.  What about this?  It captures the intent of the
original but gets rid of the warning.

James

---

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 7542f11..6242872 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -206,10 +206,6 @@ module_param(ips, charp, 0);
 #define IPS_VERSION_HIGH        IPS_VER_MAJOR_STRING "." IPS_VER_MINOR_STRING
 #define IPS_VERSION_LOW         "." IPS_VER_BUILD_STRING " "
 
-#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
-#warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
-#endif
-
 #define IPS_DMA_DIR(scb) ((!scb->scsi_cmd || ips_is_passthru(scb->scsi_cmd) || \
                          DMA_NONE == scb->scsi_cmd->sc_data_direction) ? \
                          PCI_DMA_BIDIRECTIONAL : \
@@ -6788,6 +6784,11 @@ ips_remove_device(struct pci_dev *pci_dev)
 static int __init
 ips_module_init(void)
 {
+#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
+        printk(KERN_ERR, "ips: This driver has only been tested on the x86/ia64/x86_64 platforms\n");
+        add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
+#endif
+
 	if (pci_register_driver(&ips_pci_driver) < 0)
 		return -ENODEV;
 	ips_driver_template.module = THIS_MODULE;


