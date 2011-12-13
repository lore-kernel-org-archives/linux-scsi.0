From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v5 5/6] ata: add ata port system PM callbacks
Date: Wed, 14 Dec 2011 02:57:47 +0800
Message-ID: <1323802667.3060.2.camel@hp6530s>
References: <Pine.LNX.4.44L0.1112131038360.1888-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3947 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab1LMS71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2011 13:59:27 -0500
In-Reply-To: <Pine.LNX.4.44L0.1112131038360.1888-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>

On Tue, 2011-12-13 at 23:47 +0800, Alan Stern wrote:
> On Tue, 13 Dec 2011, Lin Ming wrote:
> 
> > I just realized that the ata port runtime PM status need to be updated
> > after system resume.
> > 
> > I tried below patch.
> > Unfortunately, it causes a problem that sd can't resume correctly.
> > 
> > During system resume, ata port is resumed first and then sd resumed.
> > 
> > When ata port resumed, device_resume(...) calls pm_runtime_put_sync(..),
> > which causes ata port to be runtime suspended immediately.
> > 
> > So sd resume fails because it requires ata port to be active to handle
> > start device command.
> > 
> > This seems a PM core's bug.
> > 
> > device_resume(...) should not runtime suspend the parent device, because
> > its children have not resumed yet.
> > 
> > Alan, 
> > 
> > What do you think?
> 
> This appears to be the first time this problem has come up.  But it is 
> a real problem.
> 
> If a child device was runtime-suspended when a system suspend began, 
> then there will be nothing to prevent its parent from 
> runtime-suspending as soon as it is woken up during the system resume.  
> Then when the time comes to resume the child, the resume will fail 
> because the parent is already back at low power.
> 
> On the other hand, there are some devices which should remain at low 
> power across an entire suspend-resume cycle.  The details depend on the 
> device and the platform.
> 
> This suggests that the PM core is not the right place to solve the 
> problem.  One possible solution is for the subsystem or device driver 
> to call pm_runtime_get_sync(dev->parent) at the start of the 
> system-resume procedure and pm_runtime_put_sync(dev->parent) at the 
> end.

How about below?
(Not tested yet)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index a633076..5cf9a19 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -71,9 +71,17 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
 static int scsi_bus_resume_common(struct device *dev)
 {
 	int err = 0;
+	bool put = false;
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		if (dev->parent && pm_runtime_suspended(dev->parent)) {
+			pm_runtime_get_sync(dev->parent);
+			put = true;
+		}
 		err = scsi_dev_type_resume(dev);
+		if (put)
+			pm_runtime_put_sync(dev->parent);
+	}
 
 	if (err == 0) {
 		pm_runtime_disable(dev);



> 
> Alan Stern
> 


