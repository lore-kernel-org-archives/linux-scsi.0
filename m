From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 7 Jan 2014 11:08:22 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401071057130.1296-100000@iolanthe.rowland.org>
References: <52CC20A0.7060606@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <52CC20A0.7060606@ubuntu.com>
Sender: linux-pm-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 7 Jan 2014, Phillip Susi wrote:

> On 1/7/2014 10:25 AM, Alan Stern wrote:
> > This doesn't seem like a good idea.  The way to speed up resumes is
> > to allow sd's resume routine to return while the disk is still
> > spinning up (i.e., make the spin-up asynchronous).  There already
> > have been patches submitted to do this; I don't know what happened
> > to them.
> 
> Sure, if that is your *only* goal.  I also want the disk to not spin
> up *at all* if possible.  There's no sense spinning up all of your
> disks every time you resume when you very rarely access some of them.

Okay, that's a different matter.  There's a much simpler way to 
accomplish this.  The patch below will avoid spinning up drives that 
were already in runtime suspend when the system sleep started.  
(If a drive wasn't in runtime suspend then presumably it was used 
recently; therefore it's likely to be used again in the near future and 
so it _should_ be spun up.)

Warning: This patch is completely untested.  I didn't even try to
compile it.  Still, it should give you a good idea as to what is really
needed here.

Alan Stern



Index: usb-3.13/drivers/scsi/scsi_pm.c
===================================================================
--- usb-3.13.orig/drivers/scsi/scsi_pm.c
+++ usb-3.13/drivers/scsi/scsi_pm.c
@@ -71,14 +71,11 @@ scsi_bus_resume_common(struct device *de
 {
 	int err = 0;
 
+	if (pm_runtime_status_suspended(dev))
+		return err;
+
 	if (scsi_is_sdev_device(dev))
 		err = scsi_dev_type_resume(dev, cb);
-
-	if (err == 0) {
-		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-	}
 	return err;
 }
 

