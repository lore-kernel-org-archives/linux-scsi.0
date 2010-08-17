From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 1/2] fusion: select BLK_DEV_BSG
Date: Tue, 17 Aug 2010 11:35:40 -0700
Message-ID: <20100817113540.83e98a77.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:31351 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936299Ab0HQShN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2010 14:37:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, Eric Moore <Eric.Moore@lsi.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fusion selects SCSI_SAS_ATTRS which needs BLK_DEV_BSG, so also select
BLK_DEV_BSG in fusion.

Fixes the kconfig warning:

warning: (SCSI_SAS_LIBSAS && SCSI || SCSI_MPT2SAS && SCSI_LOWLEVEL && PCI && SCSI || FUSION_SAS && FUSION && PCI && SCSI) selects SCSI_SAS_ATTRS which has unmet direct dependencies (SCSI && BLK_DEV_BSG)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
---
 drivers/message/fusion/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100810.orig/drivers/message/fusion/Kconfig
+++ linux-next-20100810/drivers/message/fusion/Kconfig
@@ -49,6 +49,7 @@ config FUSION_SAS
 	tristate "Fusion MPT ScsiHost drivers for SAS"
 	depends on PCI && SCSI
 	select SCSI_SAS_ATTRS
+	select BLK_DEV_BSG
 	---help---
 	  SCSI HOST support for a SAS host adapters.
 
