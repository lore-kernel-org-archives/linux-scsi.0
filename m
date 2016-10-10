From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 15/23] scsi_dh_alua: Add new blacklist flag
 'BLIST_SYNC_ALUA'
Date: Mon, 10 Oct 2016 23:24:11 +0200
Message-ID: <9c10ea3c-76e5-8aad-4b30-1fd34d9bf288@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36378 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbcJJVYe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2016 17:24:34 -0400
Received: by mail-lf0-f67.google.com with SMTP id b75so310281lfg.3
        for <linux-scsi@vger.kernel.org>; Mon, 10 Oct 2016 14:24:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Stewart, Sean" <Sean.Stewart@netapp.com>, "George, Martin" <Martin.George@netapp.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>, "Schremmer, Steven" <Steven.Schremmer@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Hannes,

Try #2.
Is this needed for RDAC(INF-01-00) devices?


Thank you.

---cut---
commit 851cde9909dd8b6fb90fab7f4e815c8f86c85a0d
Author: Hannes Reinecke <hare@suse.de>
Date:   Fri Feb 19 09:17:12 2016 +0100

    scsi_dh_alua: Add new blacklist flag 'BLIST_SYNC_ALUA'

    Add a new blacklist flag BLIST_SYNC_ALUA to instruct the
    alua device handler to use synchronous command submission
    for ALUA commands.

    Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Hannes Reinecke <hare@suse.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a3cb069..fbbe85e 100644
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
index bbfbfd9..3408578 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -220,6 +220,8 @@ static struct {
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
---
