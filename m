From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] [SCSI] Automatic LUN removal
Date: Thu, 14 Feb 2013 11:36:33 -0500
Message-ID: <1360859795-30448-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903Ab3BNQgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2013 11:36:38 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1EGabrE010015
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2013 11:36:37 -0500
Received: from emilne.csb (dhcp-185-251.bos.redhat.com [10.16.185.251])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r1EGabxY000379
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2013 11:36:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

This patch adds the capability to configure the kernel to
automatically remove LUNs when a rescan of a SCSI target
finds that LUNs that were previously reported are no longer
being reported.  This is only done when a target is scanned
using REPORT LUNS, to avoid removing LUNs due to transport
errors (in other words, the target must be accessible).

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/Kconfig     |  8 +++++++
 drivers/scsi/scsi_scan.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5d1e614..9642c87 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -292,6 +292,14 @@ config SCSI_ENHANCED_UA
 	 primarily useful when storage arrays that can be reconfigured
 	 are attached to the system, otherwise you can say N here.
 
+config SCSI_AUTOMATIC_LUN_REMOVAL
+	bool "Automatic LUN removal"
+	depends on SCSI
+	help
+	 If you want LUNs to be automatically removed when a SCSI target
+	 is rescanned and the REPORT LUNS result indicates that LUNs are
+	 no longer present, say Y.  Otherwise, say N.
+
 menu "SCSI Transports"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1bbbc43..a0d0d97 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1318,6 +1318,11 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret = 0;
+#ifdef CONFIG_SCSI_AUTOMATIC_LUN_REMOVAL
+	unsigned long flags;
+	struct scsi_device *sdev_i;
+	bool found;
+#endif
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1490,6 +1495,55 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		}
 	}
 
+#ifdef CONFIG_SCSI_AUTOMATIC_LUN_REMOVAL
+	/*
+	 * See if all of the LUNs that we know about on the target are
+	 * still being reported in the REPORT LUNS data.  If any are not,
+	 * they have been removed from the target.  Remove those LUNs.
+	 *
+	 * We only do this for REPORT LUNS scanning, because we do not
+	 * want to remove LUNs if they are inaccessible due to a transport
+	 * error.  Here, the target has responded to a command.
+	 */
+restart:
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(sdev_i, &starget->devices, same_target_siblings) {
+		/*
+		 * Don't remove the sdev used for the REPORT LUNS command here.
+		 * It will be removed at the end of the function if necessary.
+		 */
+		if (sdev_i == sdev)
+			continue;
+		if (sdev_i->sdev_state == SDEV_DEL)
+			continue;
+		found = 0;
+		for (lunp = &lun_data[1]; lunp <= &lun_data[num_luns]; lunp++) {
+			lun = scsilun_to_int(lunp);
+			if (memcmp(&lunp->scsi_lun[sizeof(lun)], "\0\0\0\0", 4))
+				continue;
+			else if (lun > sdev->host->max_lun)
+				continue;
+			else if (lun == sdev_i->lun) {
+				found = 1;
+				break;
+			}
+		}
+		if (!found) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			sdev_printk(KERN_INFO, sdev_i,
+				    "LUN %d is no longer present, removing\n",
+				    sdev_i->lun);
+			__scsi_remove_device(sdev_i);
+			/*
+			 * Once the device has been removed, the iterator
+			 * is no longer valid and we have to start again.
+			 */
+			goto restart;
+		}
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+#endif
+
  out_err:
 	kfree(lun_data);
  out:
-- 
1.7.11.7

