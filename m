From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] scsi: Fix SRP_ATTRS Kconfig
Date: Mon, 30 Jul 2007 11:12:10 -0500
Message-ID: <15156.0195409276$1185811948@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:37948 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbXG3QMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:12:15 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l6UF66bU011351
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jul 2007 11:06:06 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6UGCDh3192782
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jul 2007 10:12:13 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6UGCCH9030396
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jul 2007 10:12:13 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Since the srp transport class was added, if scsi tgt support is not
selected, the current Kconfig allows for enabling a dependent device
driver, such as ibmvscsi, which does a select of SCSI_SRP_ATTRS. This
does not, however, enable SCSI_TGT also. This fixes this up to prevent
the following build problem:

ERROR: ".scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko] undefined!
ERROR: ".scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko] undefined!

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 scsi-pending-2.6.git-bjking1/drivers/scsi/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/Kconfig~scsi_tgt_kconfig_fix drivers/scsi/Kconfig
--- scsi-pending-2.6.git/drivers/scsi/Kconfig~scsi_tgt_kconfig_fix	2007-07-30 10:44:34.000000000 -0500
+++ scsi-pending-2.6.git-bjking1/drivers/scsi/Kconfig	2007-07-30 10:45:00.000000000 -0500
@@ -291,7 +291,8 @@ source "drivers/scsi/libsas/Kconfig"
 
 config SCSI_SRP_ATTRS
 	tristate "SRP Transport Attributes"
-	depends on SCSI && SCSI_TGT
+	depends on SCSI
+	select SCSI_TGT
 	help
 	  If you wish to export transport-specific information about
 	  each attached SRP device to sysfs, say Y.
_
