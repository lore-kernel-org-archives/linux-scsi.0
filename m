From: Andrew Morton <akpm@osdl.org>
Subject: aic7xxx deadlock in 2.6.0-test10
Date: Sun, 23 Nov 2003 23:08:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031123230853.0bc8defb.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:5870 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263596AbTKXHCh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 02:02:37 -0500
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org


One of my less-used boxes if taking an NMI watchdog hit on boot in test10:

(gdb) bt
#0  0xc02dc427 in .text.lock.scsi () at drivers/scsi/scsi.c:1049
#1  0xf70e5df8 in ?? ()
#2  0xc02df24a in scsi_report_bus_reset (shost=0xf70f6e48, channel=-150053384) at drivers/scsi/scsi_error.c:1625
#3  0xc02fbc96 in ahc_send_async (ahc=0xf70e5df8, channel=65 'A', target=4294967295, lun=4144983544, code=-134635520, arg=0x0) at drivers/scsi/aic7xxx/aic7xxx_osm.c:4075
#4  0xc02ee031 in ahc_reset_channel (ahc=0xf70f7df8, channel=65 'A', initiate_reset=1) at drivers/scsi/aic7xxx/aic7xxx_core.c:6077
#5  0xc02f7040 in ahc_linux_initialize_scsi_bus (ahc=0xf70f7df8) at drivers/scsi/aic7xxx/aic7xxx_osm.c:1846
#6  0xc02f6dc3 in ahc_linux_register_host (ahc=0xf70f7df8, template=0xf70f6df8) at drivers/scsi/aic7xxx/aic7xxx_osm.c:1737
#7  0xc02f5cc8 in ahc_linux_detect (template=0xc04a4ea0) at drivers/scsi/aic7xxx/aic7xxx_osm.c:908
#8  0xc05c47d5 in ahc_linux_init () at drivers/scsi/aic7xxx/aic7xxx_osm.c:5054
#9  0xc05ac865 in do_initcalls () at init/main.c:497
#10 0xc05ac8dc in do_basic_setup () at init/main.c:537
#11 0xc010512d in init (unused=0x0) at init/main.c:579

ahc_linux_register_host() is calling ahc_linux_initialize_scsi_bus() under
ahc_lock(ahc, &s).  But scsi_report_bus_reset() is taking host->host_lock
inside shost_for_each_device(), and that is the same (already held) lock.


This patch gets things going again of course.  Could someone please take a
look at fixing this for real?

I'm not sure why this has suddenly started happening actually.

--- 25/drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-deadlock-fix	2003-11-23 23:03:52.000000000 -0800
+++ 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-11-23 23:03:59.000000000 -0800
@@ -1734,8 +1734,8 @@ ahc_linux_register_host(struct ahc_softc
     LINUX_VERSION_CODE  < KERNEL_VERSION(2,5,0)
 	scsi_set_pci_device(host, ahc->dev_softc);
 #endif
-	ahc_linux_initialize_scsi_bus(ahc);
 	ahc_unlock(ahc, &s);
+	ahc_linux_initialize_scsi_bus(ahc);
 	ahc->platform_data->dv_pid = kernel_thread(ahc_linux_dv_thread, ahc, 0);
 	ahc_lock(ahc, &s);
 	if (ahc->platform_data->dv_pid < 0) {

_

