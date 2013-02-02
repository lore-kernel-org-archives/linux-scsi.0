From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
Date: Sat, 02 Feb 2013 18:45:26 +0800
Message-ID: <510CEE46.80308@intel.com>
References: <Pine.LNX.4.44L0.1302011026070.1752-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1302011026070.1752-100000@iolanthe.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Derek Basehore <dbasehore@chromium.org>, James Bottomley <JBottomley@Parallels.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/01/2013 11:28 PM, Alan Stern wrote:
> On Fri, 1 Feb 2013, Aaron Lu wrote:
> 
>> Hi Derek,
>>
>> On 12/21/2012 12:35 PM, Derek Basehore wrote:
>>> We no longer wait for the disk to spin up in sd_resume. It now enters the
>>> request to spinup the disk into the elevator and returns.
>>>
>>> A function is scheduled under the scsi_sd_probe_domain to wait for the command
>>> to spinup the disk to complete. This function then checks for errors and cleans
>>> up after the sd resume function.
>>>
>>> This allows system resume to complete much faster on systems with an HDD since
>>> spinning up the disk is a significant portion of resume time.
>>
>> An alternative way of possibly solving this problem from PM's point of
>> view might be:
>> 1 Set both ata port and scsi device's runtime status to RPM_SUSPENDED
>>   in their system suspend callback;
>> 2 On resume, do nothing in their system resume callback;
>> 3 With request based runtime PM introduced here:
>>   http://thread.gmane.org/gmane.linux.power-management.general/30405
>>   When a request comes for the HDD after system resume, both the ata
>>   port and the scsi device will be runtime resumed, which involves
>>   re-initialize the ata link(in ata port's runtime resume callback) and
>>   spin up the HDD(in sd's runtime resume callback).
>>
>> To make HDD un-affetcted by runtime PM during normal use, a large enough
>> autosuspend_delay can be set for it.
>>
>> Just my 2 cents, I've not verified or tried in any way yet :-)
> 
> It's a good idea.  The problem is that it won't work if CONFIG_PM_SLEEP
> is enabled but CONFIG_PM_RUNTIME isn't.

Right, what a pity... thanks for the hint.

But the code is really simple if we ignore this problem(with some proper
modifications to scsi bus PM callbacks, see the delayed_resume branch if
you are interested), so I'm tempted to post it here :-)

 drivers/ata/libata-core.c | 22 +++++++++++-----------
 drivers/scsi/scsi_pm.c    | 14 +++++++++++---
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 497adea..38000fc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5355,10 +5355,19 @@ static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
 
 static int ata_port_suspend(struct device *dev)
 {
+	int ret;
+
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return ata_port_suspend_common(dev, PMSG_SUSPEND);
+	ret = ata_port_suspend_common(dev, PMSG_SUSPEND);
+	if (!ret) {
+		__pm_runtime_disable(dev, false);
+		pm_runtime_set_suspended(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return ret;
 }
 
 static int ata_port_do_freeze(struct device *dev)
@@ -5393,16 +5402,7 @@ static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
 
 static int ata_port_resume(struct device *dev)
 {
-	int rc;
-
-	rc = ata_port_resume_common(dev, PMSG_RESUME);
-	if (!rc) {
-		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-	}
-
-	return rc;
+	return 0;
 }
 
 /*
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d9956b6..d0b6997 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -127,13 +127,21 @@ static int scsi_bus_prepare(struct device *dev)
 static int scsi_bus_suspend(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	return scsi_bus_suspend_common(dev, pm ? pm->suspend : NULL);
+	int ret;
+
+	ret = scsi_bus_suspend_common(dev, pm ? pm->suspend : NULL);
+	if (!ret) {
+		__pm_runtime_disable(dev, false);
+		pm_runtime_set_suspended(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return ret;
 }
 
 static int scsi_bus_resume(struct device *dev)
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	return scsi_bus_resume_common(dev, pm ? pm->resume : NULL);
+	return 0;
 }
 
 static int scsi_bus_freeze(struct device *dev)
-- 
1.8.1


Below branch has all the code necessary to try this out:
https://github.com/aaronlu/linux.git delayed_resume

And you will have to enable runtime PM for both ata port and scsi device,
it works for HDD and normal ODD(ZPODD needs some extra work), tested on
my thinkpad R61i with a HDD and an ODD.

But yeah, as Alan has said, this can't be a general solution.
But someday it may be, when CONFIG_RUNTIME_PM and CONFIG_PM_SLEEP are
regarded as base functions of the kernel and always compiled in :-)

Sorry for the noise.

-Aaron
