From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] Revert "[SCSI] libsas: fix sas port naming"
Date: Fri, 20 Apr 2012 00:27:41 -0700
Message-ID: <20120420072433.18797.58788.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2DTHL5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 03:11:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

This reverts commit a692b0eec5efae382dfa800e8b4b083f172921a7.

Tom reports:

[    8.741033] ------------[ cut here ]------------
[    8.741038] WARNING: at fs/sysfs/dir.c:508 sysfs_add_one+0xc1/0xf0()
[    8.741040] Hardware name: To Be Filled By O.E.M.
[    8.741041] sysfs: cannot create duplicate filename

...and missing 2 out of 4 drives connected to mvsas.  Commit a692b0ee
made the assumption that all the phy ids an lldd registers to libsas are
unique.  However, in the "multi-chip" case mvsas does a rather annoying
duplication of phy ids in the array passed to libsas.  So, for example,
chip0 has phy0-3 at ha phy index 0-3 and chip1 has its phy0-3 at ha phy
index 4-7.  The more natural model would be to create a scsi_host (and
sas_ha) per chip (controller), but for now revert the naming fix which
unfortunately means dealing with unpredictable end-device names for a
bit longer.

Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Patrick Thomson <patrick.s.thomson@intel.com>
Reported-by: Tom Rini <trini@ti.com>
Tested-by: Tom Rini <trini@ti.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Any heartburn if I submit this plus the pending libsas-fixes to Linus?
I don't want to miss rc4.

 drivers/scsi/libsas/sas_port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 1cf7d75..e884a8c 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -123,7 +123,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 
 	if (!port->port) {
-		port->port = sas_port_alloc(phy->phy->dev.parent, phy->id);
+		port->port = sas_port_alloc(phy->phy->dev.parent, port->id);
 		BUG_ON(!port->port);
 		sas_port_add(port->port);
 	}

