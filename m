From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] mvsas: fix build warning, clean prototypes
Date: Sat, 23 Feb 2008 16:53:44 -0500
Message-ID: <20080223215344.GA28102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:53127 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbYBWVxp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Feb 2008 16:53:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei@marvell.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

- Fix build 'make randconfig' build warning spotted by Toralf Foerster:

drivers/scsi/mvsas.c: In function 'mvs_hexdump':
drivers/scsi/mvsas.c:715: error: implicit declaration of function 'isalnum'

- Remove unneeded prototypes (spotted by hch)

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
NOTE:  A proper fix, as noted in initial review (and by hch), would
be to convert this driver over to using lib/hexdump.c, to eliminate
a hand-rolled hexdump function.


 drivers/scsi/mvsas.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 30e20e6..d4a6ac3 100755
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -35,6 +35,7 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
+#include <linux/ctype.h>
 #include <scsi/libsas.h>
 #include <asm/io.h>
 
@@ -632,15 +633,6 @@ static int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			   void *funcdata);
 static u32 mvs_read_phy_ctl(struct mvs_info *mvi, u32 port);
 static void mvs_write_phy_ctl(struct mvs_info *mvi, u32 port, u32 val);
-static u32 mvs_read_port(struct mvs_info *mvi, u32 off, u32 off2, u32 port);
-static void mvs_write_port(struct mvs_info *mvi, u32 off, u32 off2,
-				u32 port, u32 val);
-static u32 mvs_read_port_cfg_data(struct mvs_info *mvi, u32 port);
-static void mvs_write_port_cfg_data(struct mvs_info *mvi, u32 port, u32 val);
-static void mvs_write_port_cfg_addr(struct mvs_info *mvi, u32 port, u32 addr);
-static u32 mvs_read_port_vsr_data(struct mvs_info *mvi, u32 port);
-static void mvs_write_port_vsr_data(struct mvs_info *mvi, u32 port, u32 val);
-static void mvs_write_port_vsr_addr(struct mvs_info *mvi, u32 port, u32 addr);
 static u32 mvs_read_port_irq_stat(struct mvs_info *mvi, u32 port);
 static void mvs_write_port_irq_stat(struct mvs_info *mvi, u32 port, u32 val);
 static void mvs_write_port_irq_mask(struct mvs_info *mvi, u32 port, u32 val);
@@ -649,9 +641,6 @@ static u32 mvs_read_port_irq_mask(struct mvs_info *mvi, u32 port);
 static u32 mvs_is_phy_ready(struct mvs_info *mvi, int i);
 static void mvs_detect_porttype(struct mvs_info *mvi, int i);
 static void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
-static void mvs_free_reg_set(struct mvs_info *mvi, struct mvs_port *port);
-static u8 mvs_assign_reg_set(struct mvs_info *mvi, struct mvs_port *port);
-static u32 mvs_is_sig_fis_received(u32 irq_status);
 
 static int mvs_scan_finished(struct Scsi_Host *, unsigned long);
 static void mvs_scan_start(struct Scsi_Host *);
