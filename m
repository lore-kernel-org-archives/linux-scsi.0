From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: [PATCH v3 1/2] Hard disk S3 resume time optimization
Date: Tue, 27 Aug 2013 14:36:58 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A1706A831E@FMSMSX103.amr.corp.intel.com>
References: <20130823223245.GA11706@todd.e.brandt@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130823223245.GA11706@todd.e.brandt@intel.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is v3 of the non-blocking S3 resume patch. It's been broken into 
two pieces, this part is for the ata subsystem. I've addressed Oliver 
Neukum's comments in particular by removing any potential race 
conditions.

In the previous version I used the ata_port_request_pm function to handle
the call, but it really wasn't intended to be used this way. It's meant
to be called by SAS drives so that the libsas code can handle the blocking
instead of ata. In this version I created a separate function.

I set the async call to ignore the return value of the ata port error
handler since the function which actually creates that return
value, ahci_port_resume, always returns 0. So I don't see any point in 
collecting it.

I've been testing on systems with sata drives of differing sizes on every
AHCI port and there appear to be no issues. One special case I tested
heavily was the case where a 2nd system suspend is called again before
the 1st ata_port resume is finished. The outcome is that the second suspend
has to wait for the current disk resume to finish before it can continue.
Thus in this particular case there is no benefit at all, but also
no issues, and this case should be extremely rare. In that particular
case the dmesg out looks like this (with a 3TB drive on ata5):

[ 1233.424781] PM: Syncing filesystems ... done.
...
[ 1233.708990] calling  4:0:0:0+ @ 3269, parent: target4:0:0
[ 1233.709000] sd 4:0:0:0: [sdd] Synchronizing SCSI cache
... system suspend call for sd, still waiting on ata resume
[ 1236.736079] ata5: link is slow to respond, please be patient (ready=0)
[ 1242.376108] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1242.422093] ata5.00: configured for UDMA/133
... ata finished resuming, sync now completes and disk is stopped
[ 1242.436274] sd 4:0:0:0: [sdd] Stopping disk
[ 1242.446923] sd 4:0:0:0: [sdd] START SUCCESS
[ 1243.058041] call 4:0:0:0+ returned 0 after 9129928 usecs
[ 1243.058097] calling  target4:0:0+ @ 3288, parent: host4
[ 1243.058101] call target4:0:0+ returned 0 after 1 usecs
[ 1243.058155] calling  host4+ @ 3250, parent: ata5
[ 1243.058159] call host4+ returned 0 after 0 usecs
[ 1243.058213] calling  ata5+ @ 3257, parent: 0000:00:1f.2
[ 1243.058344] call ata5+ returned 0 after 122 usecs
[ 1243.058400] calling  0000:00:1f.2+ @ 3255, parent: pci0000:00
[ 1243.072115] call 0000:00:1f.2+ returned 0 after 13386 usecs
[ 1243.072199] PM: suspend of devices complete after 9363.556 msecs

Note - the two patches will function separately but both are required 
to achieve a performance improvement.


Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>

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


