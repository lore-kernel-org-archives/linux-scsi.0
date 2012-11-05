From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] [SCSI] mv_sas: Fix confusion between enum sas_device_type
 and enum sas_dev_type
Date: Mon, 05 Nov 2012 13:21:55 +0000
Message-ID: <1352121715.3043.99.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57661 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038Ab2KENV7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Nov 2012 08:21:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The enumeration of standard types is called enum sas_device_type and
is defined in <scsi/scsi_transport_sas.h> along with the Linux
internal structures, whereas the enumeration with Linux extensions is
called enum sas_dev_type and is defined in <scsi/sas.h> along with the
standard-defined structures.  All clear?  Apparently not; I can't
think why.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mvsas/mv_sas.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a3776d6..9f91359 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1153,10 +1153,10 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
 			phy->identify.device_type =
 				phy->att_dev_info & PORT_DEV_TYPE_MASK;
 
-			if (phy->identify.device_type == SAS_END_DEV)
+			if (phy->identify.device_type == SAS_END_DEVICE)
 				phy->identify.target_port_protocols =
 							SAS_PROTOCOL_SSP;
-			else if (phy->identify.device_type != NO_DEVICE)
+			else if (phy->identify.device_type != SAS_PHY_UNUSED)
 				phy->identify.target_port_protocols =
 							SAS_PROTOCOL_SMP;
 			if (oob_done)

