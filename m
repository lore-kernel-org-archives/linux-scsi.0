From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] libsas: flush initial device discovery before completing
	->scan_finished()
Date: Wed, 16 Feb 2011 19:06:54 -0800
Message-ID: <20110217030633.4303.61603.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab1BQCqO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 21:46:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, David Milburn <dmilburn@redhat.com>, jacek.danecki@intel.com, jack_wang@usish.com, lindar_liu@usish.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com, Srinivas <satyasrinivasp@hcl.in>

During initial scan libsas drivers start their phys and notify libsas
with PORTE_BYTES_DMAED events as port links are established.  This
notification in turn causes libsas to post DISCE_DISCOVER_DOMAIN events
to the queue.  Calling scsi_flush_work() at the end of scan_finished
guarantees that all preceding PORTE_BYTES_DMAED events have been
registered in the queue, but it does not guarantee that the resulting
DISCE_DISCOVER_DOMAIN events have been processed because
flush_workqueue() explicitly avoids live-locking with incoming work.

Introduce sas_flush_discovery() to guarantee that all initial discovery
events have completed.  It is called after the driver determines all
initial PORTE_BYTES_DMAED events have had a chance to enter the queue.
This does not cover BCNs that are generated during expander bring up,
only the initial sas_discover_domain() event.

Cc: David Milburn <dmilburn@redhat.com>
Cc: Srinivas <satyasrinivasp@hcl.in>
Cc: jack_wang@usish.com
Cc: lindar_liu@usish.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 drivers/scsi/mvsas/mv_sas.c         |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c    |    2 +-
 include/scsi/libsas.h               |   13 +++++++++++++
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 3b7e83d..f763daa 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -972,7 +972,7 @@ static int asd_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	if (time < HZ)
 		return 0;
 	/* Wait for discovery to finish */
-	scsi_flush_work(shost);
+	sas_flush_discovery(shost);
 	return 1;
 }
 
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index adedaa9..e34c378 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -440,7 +440,7 @@ int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	if (time < HZ)
 		return 0;
 	/* Wait for discovery to finish */
-	scsi_flush_work(shost);
+	sas_flush_discovery(shost);
 	return 1;
 }
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6ae059e..997cf59 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -253,7 +253,7 @@ int pm8001_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	if (time < HZ)
 		return 0;
 	/* Wait for discovery to finish */
-	scsi_flush_work(shost);
+	sas_flush_discovery(shost);
 	return 1;
 }
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 5173bba..d4ada3b 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -405,6 +405,19 @@ static inline void sas_phy_disconnected(struct asd_sas_phy *phy)
 	phy->linkrate = SAS_LINK_RATE_UNKNOWN;
 }
 
+/* Before returning from ->scan_finished() an LLDD calls this routine to
+ * ensure that all port notifications have been promoted to domain
+ * discovery events, and that initial domain discovery has completed
+ */
+static inline void sas_flush_discovery(struct Scsi_Host *shost)
+{
+	/* flush port events */
+	scsi_flush_work(shost);
+
+	/* flush domain discovery events queued by the port events */
+	scsi_flush_work(shost);
+}
+
 /* ---------- Tasks ---------- */
 /*
       service_response |  SAS_TASK_COMPLETE  |  SAS_TASK_UNDELIVERED |

