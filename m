From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: timeout during sas discovery (aic94xx)
Date: Tue, 29 Aug 2006 08:53:43 -0500
Message-ID: <1156859623.3458.3.camel@mulgrave.il.steeleye.com>
References: <20060828231832.GA1037@us.ibm.com>  <44F3D428.60705@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:10409 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750833AbWH2Nxt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 09:53:49 -0400
In-Reply-To: <44F3D428.60705@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com, alexisb@us.ibm.com

On Mon, 2006-08-28 at 22:44 -0700, Darrick J. Wong wrote:
> Uh... I don't think that phy_reset function ever gets called.  My
> ten-second grep of the libsas/aic94xx code doesn't yield and takers.
> Maybe one of those functions that gets called after time index 575.791
> should be doing that?

I see the same thing occasionally in my sata on expanders setup.

The problem is that the error handling in the SMP functions isn't
robust.  Try this patch; it works for me(tm), but it's obviously wrong
since it simply blasts a reset.

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_discover.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_discover.c	2006-08-28 11:46:47.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_discover.c	2006-08-28 17:32:08.000000000 -0500
@@ -136,10 +136,15 @@ static int sas_execute_task(struct sas_t
 			res2 = i->dft->lldd_abort_task(task);
 			SAS_DPRINTK("came back from abort task\n");
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				if (res2 == TMF_RESP_FUNC_COMPLETE)
-					continue; /* Retry the task */
-				else
-					goto ex_err;
+				if (res2 != TMF_RESP_FUNC_COMPLETE) {
+					/* bigger hammer */
+					SAS_DPRINTK("Resetting device\n");
+					sas_device_reset(task->dev, 1);
+					/* wait for things to settle */
+					msleep(500);
+					/* Retry the task */
+					continue;
+				}
 			}
 		}
 		if (task->task_status.stat == SAM_BUSY ||
Index: BUILD-2.6/drivers/scsi/libsas/sas_init.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_init.c	2006-08-28 11:55:32.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_init.c	2006-08-28 17:33:10.000000000 -0500
@@ -173,6 +173,19 @@ static struct sas_function_template sft 
 	.get_linkerrors = sas_get_linkerrors,
 };
 
+int sas_device_reset(struct domain_device *dev, int hard_reset)
+{
+	struct sas_rphy *rphy = dev->rphy;
+	struct sas_port *port = dev_to_sas_port(rphy->dev.parent);
+	struct sas_phy *phy;
+
+	mutex_lock(&port->phy_list_mutex);
+	list_for_each_entry(phy, &port->phy_list, port_siblings)
+		sas_phy_reset(phy, hard_reset);
+	mutex_unlock(&port->phy_list_mutex);
+	return 0;
+}
+
 struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *dft)
 {
Index: BUILD-2.6/drivers/scsi/libsas/sas_internal.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_internal.h	2006-08-28 12:00:43.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_internal.h	2006-08-28 12:01:35.000000000 -0500
@@ -75,6 +75,8 @@ int sas_smp_get_phy_events(struct sas_ph
 
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
 
+int sas_device_reset(struct domain_device *dev, int hard_reset);
+
 void sas_hae_reset(void *);
 
 static inline void sas_queue_event(int event, spinlock_t *lock,


