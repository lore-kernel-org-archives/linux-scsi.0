From: Eric Kerin <eric@bootseg.com>
Subject: Re: [PATCH] 2.6.0 aic7xxx and aic79xx stale pci_device list entry
Date: Sat, 03 Jan 2004 06:12:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073128375.5478.12.camel@opiate>
References: <1073076654.2048.19.camel@opiate>
	 <1073120514.4429.0.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf06.cluster1.charter.net ([209.225.28.206]:53521 "EHLO
	mxsf06.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S263205AbUACLPN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Jan 2004 06:15:13 -0500
In-Reply-To: <1073120514.4429.0.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: linux-scsi@vger.kernel.org

On Sat, 2004-01-03 at 04:01, Arjan van de Ven wrote: 
> On Fri, 2004-01-02 at 21:50, Eric Kerin wrote:
> > Loading the aic7xxx or aic79xx modules, on a machine that did not
> > contain the card, left a stale entry in the pci_device list.  This
> > caused an oops upon loading the next module that registered a
> > pci_device. 
> > 
> > The patches below will unregister the pci_device if it successfully
> > registers the device, but does not find any cards. 
> > 
> > Comments are appreciated.
> 
> well in 2.6 modules are supposed to remain loaded even though no device
> is found (since one can be hotplugged later) so that part of the driver
> needs changing; other than that yes the driver needs to deregister
> itself....

Yea, I saw examples of both cases (remain loaded, or don't remain
loaded), but there was a comment in include/linux/pci.h that said "For
the module case, a hotplug daemon of some sort should load a module in
response to an insert event."  So I put a little more weight on the ones
that unload being correct.  Oh well live and learn.

Here's a new patch, now it will leave the module loaded if it
successfully registers the pci device.

Eric Kerin



--- aic7xxx_osm.c.original	2004-01-02 03:56:32.000000000 -0500
+++ aic7xxx_osm.c	2004-01-03 05:03:41.000000000 -0500
@@ -844,6 +844,7 @@ ahc_linux_detect(Scsi_Host_Template *tem
 {
 	struct	ahc_softc *ahc;
 	int     found;
+	int	pci_reg_state;
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
@@ -891,8 +892,9 @@ ahc_linux_detect(Scsi_Host_Template *tem
 	 */
 	ahc_list_lockinit();
 
+	pci_reg_state = -1;
 #ifdef CONFIG_PCI
-	ahc_linux_pci_init();
+	pci_reg_state = ahc_linux_pci_init();
 #endif
 
 #ifdef CONFIG_EISA
@@ -913,6 +915,10 @@ ahc_linux_detect(Scsi_Host_Template *tem
 	spin_lock_irq(&io_request_lock);
 #endif
 	aic7xxx_detect_complete++;
+	if(pci_reg_state == 0 && found == 0){
+		return(1); 
+	}
+
 	return (found);
 }
 


--- aic79xx_osm.c.original	2004-01-02 02:46:43.000000000 -0500
+++ aic79xx_osm.c	2004-01-03 05:05:52.000000000 -0500
@@ -856,6 +856,7 @@ ahd_linux_detect(Scsi_Host_Template *tem
 {
 	struct	ahd_softc *ahd;
 	int     found;
+	int	pci_reg_state;
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
@@ -906,8 +907,9 @@ ahd_linux_detect(Scsi_Host_Template *tem
 	 */
 	ahd_list_lockinit();
 
+	pci_reg_state = -1;
 #ifdef CONFIG_PCI
-	ahd_linux_pci_init();
+	pci_reg_state = ahd_linux_pci_init();
 #endif
 
 	/*
@@ -924,6 +926,10 @@ ahd_linux_detect(Scsi_Host_Template *tem
 	spin_lock_irq(&io_request_lock);
 #endif
 	aic79xx_detect_complete++;
+	if(pci_reg_state == 0 && found == 0){
+		return(1); 
+	}
+
 	return (found);
 }
 


