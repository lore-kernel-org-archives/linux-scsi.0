From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] libsas: fix definition of wideport, include local sas address
Date: Fri, 01 Oct 2010 13:55:52 -0700
Message-ID: <20101001205552.30032.87278.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33181 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab0JAUzF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2010 16:55:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Patrick Thomson <patrick.s.thomson@intel.com>, linux-scsi@vger.kernel.org, Jack Wang <jack_wang@usish.com>

To date libsas has only looked at the attached sas address when
determining the formation of wide ports.  The specification and some
hardware expects that phys with different addresses will not form a wide
port unless the local peer phys also match each other.  Introduce a flag
to select stricter behavior at sas_register_ha() time.  The flag can be
dropped once it is known that all libsas users expect the same behavior.

Current drivers just initialize this field to zero and get the
traditional behavior.

Reported-by: Patrick Thomson <patrick.s.thomson@intel.com>
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Cc: Jack Wang <jack_wang@usish.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_port.c |   18 +++++++++++++-----
 include/scsi/libsas.h          |    2 ++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index fe8b74c..5257fdf 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -28,6 +28,17 @@
 #include <scsi/scsi_transport_sas.h>
 #include "../scsi_sas_internal.h"
 
+static bool phy_is_wideport_member(struct asd_sas_port *port, struct asd_sas_phy *phy)
+{
+	struct sas_ha_struct *sas_ha = phy->ha;
+
+	if (memcmp(port->attached_sas_addr, phy->attached_sas_addr,
+		   SAS_ADDR_SIZE) != 0 || (sas_ha->strict_wide_ports &&
+	     memcmp(port->sas_addr, phy->sas_addr, SAS_ADDR_SIZE) != 0))
+		return false;
+	return true;
+}
+
 /**
  * sas_form_port -- add this phy to a port
  * @phy: the phy of interest
@@ -45,8 +56,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	unsigned long flags;
 
 	if (port) {
-		if (memcmp(port->attached_sas_addr, phy->attached_sas_addr,
-			   SAS_ADDR_SIZE) != 0)
+		if (!phy_is_wideport_member(port, phy))
 			sas_deform_port(phy);
 		else {
 			SAS_DPRINTK("%s: phy%d belongs to port%d already(%d)!\n",
@@ -62,9 +72,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 		port = sas_ha->sas_port[i];
 		spin_lock(&port->phy_list_lock);
 		if (*(u64 *) port->sas_addr &&
-		    memcmp(port->attached_sas_addr,
-			   phy->attached_sas_addr, SAS_ADDR_SIZE) == 0 &&
-		    port->num_phys > 0) {
+		    phy_is_wideport_member(port, phy) && port->num_phys > 0) {
 			/* wide port */
 			SAS_DPRINTK("phy%d matched wide port%d\n", phy->id,
 				    port->id);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3dec194..5173bba 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -361,6 +361,8 @@ struct sas_ha_struct {
 	/* The class calls this to send a task for execution. */
 	int lldd_max_execute_num;
 	int lldd_queue_size;
+	int strict_wide_ports; /* both sas_addr and attached_sas_addr must match
+				* their siblings when forming wide ports */
 
 	/* LLDD calls these to notify the class of an event. */
 	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);

