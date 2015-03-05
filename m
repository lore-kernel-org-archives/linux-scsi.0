From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [libsas] Kernel Crash in smp_execute_task
Date: Wed, 04 Mar 2015 16:18:33 -0800
Message-ID: <1425514713.7581.46.camel@HansenPartnership.com>
References: <154a8ccd0622409b84859abb1c3259f3@EX01.lg.local>
	 <68a5e8f0ce4f4630bafe5f3505334f3e@EX01.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58421 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368AbbCEASf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 19:18:35 -0500
In-Reply-To: <68a5e8f0ce4f4630bafe5f3505334f3e@EX01.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>

On Wed, 2015-03-04 at 23:29 +0000, Praveen Murali wrote:
> On second thoughts, should we even let smp commands/requests thru for
> sas end devices (dev->dev_type == SAS_END_DEV) ? if so, wont the
> following patch more sense? (also, in my last mail the kernel logs
> were all messed up; sorry dint realize that when I sent the mail.
> Trying to fix it here)

I think the bug is deeper than this: we shouldn't be trying expander
revalidation on non-expander devices.  If the device changes from end to
expander via hotplug, we'll see the remove and add (via the identify
frame) so the device type should be correct by the time we do the
revalidation.

Does this fix the problem?

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



