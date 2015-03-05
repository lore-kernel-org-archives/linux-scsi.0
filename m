From: Praveen Murali <pmurali@logicube.com>
Subject: RE: [libsas] Kernel Crash in smp_execute_task
Date: Thu, 5 Mar 2015 00:44:51 +0000
Message-ID: <6e045e99401a48139dea1d4f4c745e2b@EX01.lg.local>
References: <154a8ccd0622409b84859abb1c3259f3@EX01.lg.local>
	 <68a5e8f0ce4f4630bafe5f3505334f3e@EX01.lg.local>,<1425514713.7581.46.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o149.mxlogic.net ([208.65.144.82]:33906 "EHLO
	p02c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbbCEAy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 19:54:26 -0500
In-Reply-To: <1425514713.7581.46.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>

________________________________________
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Sent: Wednesday, March 4, 2015 4:18 PM
To: Praveen Murali
Cc: linux-scsi@vger.kernel.org; dan.j.williams@intel.com
Subject: Re: [libsas] Kernel Crash in smp_execute_task

On Wed, 2015-03-04 at 23:29 +0000, Praveen Murali wrote:
>> On second thoughts, should we even let smp commands/requests thru for
>> sas end devices (dev->dev_type == SAS_END_DEV) ? if so, wont the
>> following patch more sense? (also, in my last mail the kernel logs
>> were all messed up; sorry dint realize that when I sent the mail.
>> Trying to fix it here)

>I think the bug is deeper than this: we shouldn't be trying expander
>revalidation on non-expander devices.  If the device changes from end to
>expander via hotplug, we'll see the remove and add (via the identify
>frame) so the device type should be correct by the time we do the
>revalidation.

>Does this fix the problem?

Yes, that fixes the issue. So if my understanding is correct, what you are saying is we need to do something like

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 629a086..e1060d7 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -445,6 +445,7 @@ static void sas_revalidate_domain(struct work_struct *work)
        int res = 0;
        struct sas_discovery_event *ev = to_sas_discovery_event(work);
        struct asd_sas_port *port = ev->port;
+       struct domain_device *ddev = port->port_dev;
        struct sas_ha_struct *ha = port->ha;
 
        /* prevent revalidation from finding sata links in recovery */
@@ -460,7 +461,7 @@ static void sas_revalidate_domain(struct work_struct *work)
        SAS_DPRINTK("REVALIDATING DOMAIN on port %d, pid:%d\n", port->id,
                    task_pid_nr(current));
 
-       if (port->port_dev)
+       if (ddev && (ddev->dev_type == EDGE_DEV || ddev->dev_type == FANOUT_DEV))
                res = sas_ex_revalidate_domain(port->port_dev);
 
        SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",

instead of putting the exclusion in smp_execute_task; is that right?

Thanks,
Praveen

>James

---
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 62b58d3..60de662 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -500,6 +500,7 @@ static void sas_revalidate_domain(struct work_struct *work)
        struct sas_discovery_event *ev = to_sas_discovery_event(work);
        struct asd_sas_port *port = ev->port;
        struct sas_ha_struct *ha = port->ha;
+       struct domain_device *ddev = port->port_dev;

        /* prevent revalidation from finding sata links in recovery */
        mutex_lock(&ha->disco_mutex);
@@ -514,8 +515,9 @@ static void sas_revalidate_domain(struct work_struct *work)
        SAS_DPRINTK("REVALIDATING DOMAIN on port %d, pid:%d\n", port->id,
                    task_pid_nr(current));

-       if (port->port_dev)
-               res = sas_ex_revalidate_domain(port->port_dev);
+       if (ddev && (ddev->dev_type == SAS_FANOUT_EXPANDER_DEVICE ||
+                    ddev->dev_type == SAS_EDGE_EXPANDER_DEVICE))
+               res = sas_ex_revalidate_domain(ddev);

        SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
                    port->id, task_pid_nr(current), res);



