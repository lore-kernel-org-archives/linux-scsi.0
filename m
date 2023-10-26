Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D79C25B6E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 21:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjJZVVs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjJZVVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 17:21:47 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADDD10E;
        Thu, 26 Oct 2023 14:21:44 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 2998F14667A; Thu, 26 Oct 2023 17:21:44 -0400 (EDT)
From:   Phillip Susi <phill@thesusis.net>
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v8 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
In-Reply-To: <52f44651-ce94-468f-a43b-02d512294fe4@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <20230927141828.90288-5-dlemoal@kernel.org>
 <87v8b73lsh.fsf@vps.thesusis.net>
 <0177ab41-6a7b-42ff-bf84-97d173efb838@kernel.org>
 <87r0luspvx.fsf@vps.thesusis.net>
 <1a6f1768-fd48-42df-9f1a-4b203baf6ddf@kernel.org>
 <87y1g1unwg.fsf@vps.thesusis.net>
 <e5a256fa-f1f6-4474-8e9e-b9f4bd6dced7@kernel.org>
 <87lebxrnt7.fsf@vps.thesusis.net>
 <52f44651-ce94-468f-a43b-02d512294fe4@kernel.org>
Date:   Thu, 26 Oct 2023 17:21:44 -0400
Message-ID: <877cn95bbr.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain

Damien Le Moal <dlemoal@kernel.org> writes:

> On 10/21/23 06:23, Phillip Susi wrote:
> Looks like a deadlock somewhere, likely with the device remove that you
> triggered with the "echo 1 > /sys/block/sdf/device/delete".
>
> Can you send the exact list of commands & events you executed to get to that
> point ? Also please share your kernel config.

I wrote auto to /sys/block/sd[ef]/device/power/config and 10000 to
/sys/block/sd[ef]/device/power/auto_suspend_delay_ms, and auto to the
control file of their corresponding ata8 port ( both drives are behind
an PMP in an eSATA dock on ata8 ).  As I said before, it the dmesg
showed that the ata port only suspended after BOTH drives had suspended,
which is as it should be.  The problem seems to be after I echo 1 >
/sys/block/sdf/device/delete, when this happens:

Oct 26 16:43:00 faldara kernel: ata8.15: failed to read PMP GSCR[0] (Emask=0x100)
Oct 26 16:43:00 faldara kernel: ata8.15: PMP revalidation failed (errno=-5)
Oct 26 16:43:05 faldara kernel: ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct 26 16:43:05 faldara kernel: ata8.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
Oct 26 16:43:05 faldara kernel: ata8.01: SATA link up 3.0 Gbps (SStatus
123 SControl 320)

Then I get the hung task.  I reverted the PuiS patch that I have been
working on, and the hang no longer happens, however, the above errors do
still happen.  I think that is a problem in itself, and may or may not
be related to the hang.  I see no reason why the PMP revalidation should
fail after the two disks and the port are runtime pm suspended, but for
some reason, with my patch applied, that then leads to the hang.

Here is my git log showing your two patches applied on the upstream
kernel, plus my patch:


--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=log.txt
Content-Description: git log

commit bb5db8bb505171fd2b8b67c3f22b16d8355d2a8b
Author: Phillip Susi <phill@thesusis.net>
Date:   Mon Oct 16 17:03:51 2023 -0400

    Olibata: don't start disks on resume
    
    Disks with Power Up In Standby enabled that required the
    SET FEATURES command to start up were being issued the
    command during resume.  Suppress this until the disk
    is actually accessed.

commit 4f1a1a9da4ff833417fa520d097b3f07c20e3c5d
Author: Damien Le Moal <dlemoal@kernel.org>
Date:   Thu Oct 12 16:18:00 2023 +0900

    [PATCH 2/2] ata: libata-core: Improve ata_dev_power_set_active()
    
    Improve the function ata_dev_power_set_active() by having it do nothing
    for a disk that is already in the active power state. To do that,
    introduce the function ata_dev_power_is_active() to test the current
    power state of the disk and return true if the disk is in the PM0:
    active or PM1: idle state (0xff value for the count field of the CHECK
    POWER MODE command output).
    
    To preserve the existing behavior, if the CHECK POWER MODE command
    issued in ata_dev_power_is_active() fails, the drive is assumed to be in
    standby mode and false is returned.
    
    With this change, issuing the VERIFY command to access the disk media to
    spin it up becomes unnecessary most of the time during system resume as
    the port reset done by libata-eh on resume often result in the drive to
    spin-up (this behavior is not clearly defined by the ACS specifications
    and may thus vary between disk models).
    
    Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

commit bb7e1fcd9e3a207820e4b828e9f4f02986942d8d
Author: Damien Le Moal <dlemoal@kernel.org>
Date:   Thu Oct 12 16:17:59 2023 +0900

    ata: libata-eh: Spinup disk on resume after revalidation
    
    Move the call to ata_dev_power_set_active() to transition a disk in
    standby power mode to the active power mode from
    ata_eh_revalidate_and_attach() before doing revalidation to the end of
    ata_eh_recover(), after the link speed for the device is reconfigured
    (if that was necessary). This is safer as this ensure that the VERIFY
    command executed to spinup the disk is executed with the drive properly
    reconfigured first.
    
    Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

commit 727fb83765049981e342db4c5a8b51aca72201d8
Merge: 8cb1f10d8c4b 5c15c60e7be6
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Oct 13 23:19:16 2023 -0700

    Merge tag 'input-for-v6.6-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
    
    Pull input fixes from Dmitry Torokhov:
    
     - a reworked way for handling reset delay on SMBus-connected Synaptics
       touchpads (the original one, while being correct, uncovered an old
       bug in fallback to PS/2 code that was fixed separately; the new one
       however avoids having delay in serio port "fast" resume, and instead
       has the wait in the RMI4 code)
    
     - a fix for potential crashes when devices with Elan controllers (and
       Synaptics) fall back to PS/2 code. Can't be hit without the original
       patch above, but still good to have it fixed
    
     - a couple new device IDs in xpad Xbox driver
    
     - another quirk for Goodix driver to deal with stuff vendors put in
       ACPI tables
    
     - a fix for use-after-free on disconnect for powermate driver
    
     - a quirk to not initialize PS/2 mouse port on Fujitsu Lifebook E5411
       laptop as it makes keyboard not usable and the device uses
       hid-over-i2c touchpad anyways
    
    * tag 'input-for-v6.6-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input:
      Input: powermate - fix use-after-free in powermate_config_complete
      Input: xpad - add PXN V900 support
      Input: synaptics-rmi4 - handle reset delay when using SMBus trsnsport
      Input: psmouse - fix fast_reconnect function for PS/2 mode
      Revert "Input: psmouse - add delay when deactivating for SMBus mode"
      Input: goodix - ensure int GPIO is in input for gpio_count == 1 && gpio_int_idx == 0 case
      Input: i8042 - add Fujitsu Lifebook E5411 to i8042 quirk table
      Input: xpad - add HyperX Clutch Gladiate Support

--=-=-=
Content-Type: text/plain


And here is my patch, which basically checks for PuiS during system
resume, and either forces the disk to suspend or resume depending on
whether it is PuiS.  Since I have not even engaged in any system
suspend/resume for this test, this patch should not have any effect.

So far in my testing of this patch on my 3 internal drives that I have
enabled PuiS on, it appears to work in so much as after a
suspend/resume, the runtime status of the disks is suspended ( as long
as I have *enabled* runtime pm on them, otherwise not ).  Another
problem seems to be that while the disks are left suspended after system
resume, they very quickly are resumed due to begnign IO eminating from
either ext4 or udsisks2 that does not cause a drive to spin up when it
is suspended with hdparm -y.  This would be the case of either FLUSH
CASH or CHECK POWER CONDITION not causing the drive to spin itself up
when given the commands, but the runtime pm core does not know that
these commands can be completed without resuming the disk, so it resumes
them first.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-libata-don-t-start-disks-on-resume.patch

From 77a3511d4058e3afccc4ba745c8c6ad6f7ac07a3 Mon Sep 17 00:00:00 2001
From: Phillip Susi <psusi@ubuntu.com>
Date: Mon, 16 Dec 2013 18:30:55 -0500
Subject: [PATCH] libata: don't start disks on resume

Disks with Power Up In Standby enabled that required the
SET FEATURES command to start up were being issued the
command during resume.  Suppress this until the disk
is actually accessed.
---
 drivers/ata/libata-core.c | 25 +++++++++++++++++++++----
 drivers/ata/libata-eh.c   | 19 ++++++++++++++++++-
 drivers/ata/libata.h      |  1 +
 include/linux/libata.h    |  1 +
 4 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 7c261907a1d0..cd4718fe02e1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1912,7 +1912,20 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 			goto err_out;
 	}
 
-	if (!tried_spinup && (id[2] == 0x37c8 || id[2] == 0x738c)) {
+	if (flags & ATA_READID_NOSTART && id[2] == 0x37c8)
+	{
+		/*
+		 * the drive has powered up in standby, and returned incomplete IDENTIFY info
+		 * so we can't revalidate it yet.  We have also been asked to avoid starting the
+		 * drive, so stop  here and leave the drive asleep and the EH pending, to be
+		 * restarted on later IO request
+		 */
+		dev->flags |= ATA_DFLAG_SLEEPING;
+		return -EAGAIN;
+	}
+
+	if (!(flags & ATA_READID_NOSTART) &&
+	    !tried_spinup && (id[2] == 0x37c8 || id[2] == 0x738c)) {
 		tried_spinup = 1;
 		/*
 		 * Drive powered-up in standby mode, and requires a specific
@@ -3956,6 +3969,8 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 
 	/* re-read ID */
 	rc = ata_dev_reread_id(dev, readid_flags);
+	if (rc == -EAGAIN)
+		return rc;
 	if (rc)
 		goto fail;
 
@@ -5172,6 +5187,10 @@ static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 		spin_lock_irqsave(ap->lock, flags);
 	}
 
+	/* on system resume, don't wake PuiS drives */
+	if (mesg.event == PM_EVENT_RESUME)
+		ehi_flags |= ATA_EHI_NOSTART;
+	
 	/* Request PM operation to EH */
 	ap->pm_mesg = mesg;
 	ap->pflags |= ATA_PFLAG_PM_PENDING;
@@ -5269,9 +5288,7 @@ static void ata_port_resume_async(struct ata_port *ap, pm_message_t mesg)
 static int ata_port_pm_resume(struct device *dev)
 {
 	ata_port_resume_async(to_ata_port(dev), PMSG_RESUME);
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	printk(KERN_INFO "resume device: %p", dev);
 	return 0;
 }
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 09be31723a3c..e77805ba46b0 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -22,6 +22,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include "../scsi/scsi_transport_api.h"
+#include <linux/pm_runtime.h>
 
 #include <linux/libata.h>
 
@@ -3042,6 +3043,8 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 
 		if (ehc->i.flags & ATA_EHI_DID_RESET)
 			readid_flags |= ATA_READID_POSTRESET;
+		if (ehc->i.flags & ATA_EHI_NOSTART)
+			readid_flags |= ATA_READID_NOSTART;
 
 		if ((action & ATA_EH_REVALIDATE) && ata_dev_enabled(dev)) {
 			WARN_ON(dev->class == ATA_DEV_PMP);
@@ -3071,9 +3074,23 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 			ata_eh_about_to_do(link, dev, ATA_EH_REVALIDATE);
 			rc = ata_dev_revalidate(dev, ehc->classes[dev->devno],
 						readid_flags);
-			if (rc)
+			if (rc == -EAGAIN) {
+				rc = 0; /* start required but suppressed, handle later */
+				printk(KERN_INFO "sdev: %p", &dev->sdev->sdev_dev);
+				pm_runtime_disable(&dev->sdev->sdev_dev);
+				pm_runtime_set_suspended(&dev->sdev->sdev_dev);
+				pm_runtime_enable(&dev->sdev->sdev_dev);
+
+				continue;
+			}
+			else if (rc)
 				goto err;
 
+			printk(KERN_INFO "sdev: %p", &dev->sdev->sdev_dev);
+			pm_runtime_disable(&dev->sdev->sdev_dev);
+			pm_runtime_set_active(&dev->sdev->sdev_dev);
+			pm_runtime_enable(&dev->sdev->sdev_dev);
+
 			ata_eh_done(link, dev, ATA_EH_REVALIDATE);
 
 			/* Configuration may have changed, reconfigure
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 05ac80da8ebc..cc13777d2811 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -19,6 +19,7 @@
 enum {
 	/* flags for ata_dev_read_id() */
 	ATA_READID_POSTRESET	= (1 << 0), /* reading ID after reset */
+	ATA_READID_NOSTART	= (1 << 1), /* do not start drive */
 
 	/* selector for ata_down_xfermask_limit() */
 	ATA_DNXFER_PIO		= 0,	/* speed down PIO */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2a7d2af0ed80..77769351ab99 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -328,6 +328,7 @@ enum {
 
 	/* ata_eh_info->flags */
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
+	ATA_EHI_NOSTART		= (1 << 1),  /* don't start the disk */
 	ATA_EHI_NO_AUTOPSY	= (1 << 2),  /* no autopsy */
 	ATA_EHI_QUIET		= (1 << 3),  /* be quiet */
 	ATA_EHI_NO_RECOVERY	= (1 << 4),  /* no recovery */
-- 
2.41.0


--=-=-=--
