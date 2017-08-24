From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] mptsas: Fixup device hotplug for VMWare ESXi
Date: Thu, 24 Aug 2017 14:52:43 +0200
Message-ID: <1503579163-104386-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41051 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752983AbdHXMwv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 08:52:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

VMWare ESXi emulates an mptsas HBA, but exposes all drives as
direct-attached SAS drives.
This it not how the driver originally envisioned things; SAS drives
were supposed to be connected via an expander, and only SATA drives
would be direct attached.
As such any hotplug event for direct-attach SAS drives was silently
ignored, and the guest failed to detect new drives from within a
VMWare ESXi environment.

Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1030850
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/message/fusion/mptsas.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index f6308ad..b9bd6aa 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4352,11 +4352,10 @@ static void mptsas_expander_delete(MPT_ADAPTER *ioc,
 			return;
 
 		phy_info = mptsas_refreshing_device_handles(ioc, &sas_device);
-		/* Only For SATA Device ADD */
-		if (!phy_info && (sas_device.device_info &
-				MPI_SAS_DEVICE_INFO_SATA_DEVICE)) {
+		/* Device hostplug */
+		if (!phy_info) {
 			devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-				"%s %d SATA HOT PLUG: "
+				"%s %d HOT PLUG: "
 				"parent handle of device %x\n", ioc->name,
 				__func__, __LINE__, sas_device.handle_parent));
 			port_info = mptsas_find_portinfo_by_handle(ioc,
-- 
1.8.5.6
