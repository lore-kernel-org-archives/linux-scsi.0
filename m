From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: [PATCH/RESEND 1/2] Hard disk S3 resume time optimization
Date: Thu, 5 Sep 2013 17:38:53 -0700
Message-ID: <20130906003852.GC25263@linux.intel.com>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: tj@kernel.org, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

This is the final draft of the non-blocking hard disk resume patch. I've
included some performance results to demonstrate the real benefits
of this patch. Please note that this patch provides a MASSIVE performance
improvement in hard disk resume. It's too valuable to ignore, so I really
need the help of the maintainers to get this implemented. Even if this
patch is deemed the wrong approach I hope you won't abandon the idea
altogether. There is so much potential in this kind of optimization and
I'm highly motivated to make this work.

To demonstrate the substantial performance improvement I've run the 
AnalyzeSuspend tool on three different platforms patched with the new 
behavior. Each is running Ubuntu Raring with a kernel built from the 
upstream kernel source.

The complete analysis and graphical outputs of the tool are available
online at 01.org:
https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-optimization-simpler-approach

Here's a synopsis of the results.

-------------------------------------------------------
[Computer One]
PLATFORM: Ubuntu Raring Ringtail (13.04)
KERNEL: 3.11.0-rc7
CPU: Intel(R) Core(TM) i7-3960X CPU @ 3.30GHz
SATA: Intel C600/X79 series chipset 6-Port SATA AHCI (r5)
DISK CONFIG:
    ATA1: 240 GB SSD
    ATA2: 3 TB Hard Disk
    ATA3: 500 GB Hard Disk
    ATA4: DVD-ROM (with cd inserted)
    ATA5: 2 TB Hard Disk
    ATA6: 1 TB Hard Disk
RESUME TIME WITHOUT PATCH: 11656 ms
RESUME TIME WITH PATCH: 1110 ms

IMPROVEMENT: 10.5X speedup

-------------------------------------------------------
[Computer Two]
PLATFORM: Ubuntu Raring Ringtail (13.04)
KERNEL: 3.11.0-rc7
CPU: Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
SATA: Intel 7 Series/C210 Series Chipset Family 6-port SATA [AHCI mode] (r4)
DISK CONFIG:
    ATA1: 320 GB Hard Disk
    ATA2 - ATA6: Empty slots
RESUME TIME WITHOUT PATCH: 5416 ms
RESUME TIME WITH PATCH: 448 ms

IMPROVEMENT: 12X speedup

-------------------------------------------------------
[Computer Three]
PLATFORM: Ubuntu Raring Ringtail (13.04)
KERNEL: 3.11.0-rc7
CPU: Intel(R) Core(TM) i7-4770S CPU @ 3.10GHz
SATA: Intel Lynx Point 6-port SATA Controller 1 [AHCI mode] (r2)
DISK CONFIG:
    ATA1,3,4,6: Empty Slots
    ATA2: DVD-ROM (empty)
    ATA5: 500 GB Hard Disk
RESUME TIME WITHOUT PATCH: 5385 ms
RESUME TIME WITH PATCH: 688 ms

IMPROVEMENT: 7.8X speedup

-------------------------------------------------------

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

 drivers/ata/libata-core.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c24354d..6cf0c15 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5415,6 +5415,40 @@ static int ata_port_resume(struct device *dev)
 	return rc;
 }
 
+static int ata_port_resume_async(struct device *dev)
+{
+	struct ata_port *ap = to_ata_port(dev);
+	struct ata_link *link;
+	unsigned long flags;
+	int ret = 0;
+
+	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
+		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	ap->pm_mesg = PMSG_RESUME;
+	ap->pm_result = NULL;
+	ap->pflags |= ATA_PFLAG_PM_PENDING;
+	ata_for_each_link(link, ap, HOST_FIRST) {
+		link->eh_info.action |= ATA_EH_RESET;
+		link->eh_info.flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+	}
+
+	ata_port_schedule_eh(ap);
+
+	spin_unlock_irqrestore(ap->lock, flags);
+
+ out:
+	pm_runtime_disable(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+	return ret;
+}
+
 /*
  * For ODDs, the upper layer will poll for media change every few seconds,
  * which will make it enter and leave suspend state every few seconds. And
@@ -5451,7 +5485,7 @@ static int ata_port_runtime_resume(struct device *dev)
 
 static const struct dev_pm_ops ata_port_pm_ops = {
 	.suspend = ata_port_suspend,
-	.resume = ata_port_resume,
+	.resume = ata_port_resume_async,
 	.freeze = ata_port_do_freeze,
 	.thaw = ata_port_resume,
 	.poweroff = ata_port_poweroff,

