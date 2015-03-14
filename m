From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.0-rc3
Date: Sat, 14 Mar 2015 14:18:35 -0400
Message-ID: <1426357115.2180.57.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45487 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260AbbCNSSi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2015 14:18:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a simple fix for a domain revalidation crash which has recently
turned up in the libsas code (applies to mvsas, isc and aic94xx).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

James Bottomley (1):
      libsas: Fix Kernel Crash in smp_execute_task

And the diffstat:

 drivers/scsi/libsas/sas_discover.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 62b58d3..60de662 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -500,6 +500,7 @@ static void sas_revalidate_domain(struct work_struct *work)
 	struct sas_discovery_event *ev = to_sas_discovery_event(work);
 	struct asd_sas_port *port = ev->port;
 	struct sas_ha_struct *ha = port->ha;
+	struct domain_device *ddev = port->port_dev;
 
 	/* prevent revalidation from finding sata links in recovery */
 	mutex_lock(&ha->disco_mutex);
@@ -514,8 +515,9 @@ static void sas_revalidate_domain(struct work_struct *work)
 	SAS_DPRINTK("REVALIDATING DOMAIN on port %d, pid:%d\n", port->id,
 		    task_pid_nr(current));
 
-	if (port->port_dev)
-		res = sas_ex_revalidate_domain(port->port_dev);
+	if (ddev && (ddev->dev_type == SAS_FANOUT_EXPANDER_DEVICE ||
+		     ddev->dev_type == SAS_EDGE_EXPANDER_DEVICE))
+		res = sas_ex_revalidate_domain(ddev);
 
 	SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
 		    port->id, task_pid_nr(current), res);



