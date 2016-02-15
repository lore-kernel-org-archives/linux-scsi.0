From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv7 15/23] scsi_dh_alua: Add new blacklist flag 'BLIST_SYNC_ALUA'
Date: Mon, 15 Feb 2016 09:24:42 +0100
Message-ID: <1455524690-121073-16-git-send-email-hare@suse.de>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbcBOIY5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2016 03:24:57 -0500
In-Reply-To: <1455524690-121073-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add a new blacklist flag BLIST_SYNC_ALUA to instruct the
alua device handler to use synchronous command submission
for ALUA commands.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 ++
 drivers/scsi/scsi_devinfo.c                | 2 ++
 drivers/scsi/scsi_scan.c                   | 3 +++
 include/scsi/scsi_device.h                 | 1 +
 include/scsi/scsi_devinfo.h                | 1 +
 5 files changed, 9 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 43bf6ac..9d5a861 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -366,6 +366,8 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 		/* port group has changed. Update to new port group */
 		rcu_assign_pointer(h->pg, pg);
 	}
+	if (sdev->synchronous_alua)
+		pg->flags |= ALUA_SYNC_STPG;
 	alua_rtpg_queue(h->pg, sdev, NULL);
 	spin_unlock(&h->pg_lock);
 
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 47b9d13..b4ef0c6 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -218,6 +218,8 @@ static struct {
 	{"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
+	{"NETAPP", "LUN C-Mode", NULL, BLIST_SYNC_ALUA},
+	{"NETAPP", "INF-01-00", NULL, BLIST_SYNC_ALUA},
 	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1f02e84..420239c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -964,6 +964,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_NO_DIF)
 		sdev->no_dif = 1;
 
+	if (*bflags & BLIST_SYNC_ALUA)
+		sdev->synchronous_alua = 1;
+
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
 	if (*bflags & BLIST_TRY_VPD_PAGES)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9173ab5a..4af2b24 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -176,6 +176,7 @@ struct scsi_device {
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 	unsigned broken_fua:1;		/* Don't set FUA bit */
 	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
+	unsigned synchronous_alua:1;	/* Synchronous ALUA commands */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 96e3f56..9f750cb 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -37,5 +37,6 @@
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
 #define BLIST_MAX_1024		0x40000000 /* maximum 1024 sector cdb length */
+#define BLIST_SYNC_ALUA		0x80000000 /* Synchronous ALUA commands */
 
 #endif
-- 
1.8.5.6

