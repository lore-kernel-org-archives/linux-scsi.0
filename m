From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 4/4] libata: implement libata.spindown_compat
Date: Wed, 21 Mar 2007 00:55:48 +0900
Message-ID: <20070320155548.GI6152@htj.dyndns.org>
References: <20070320150718.GF6152@htj.dyndns.org> <20070320151359.GG6152@htj.dyndns.org> <20070320152533.GH6152@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.229]:60557 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbXCTPzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 11:55:54 -0400
Received: by nz-out-0506.google.com with SMTP id s1so902874nze
        for <linux-scsi@vger.kernel.org>; Tue, 20 Mar 2007 08:55:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20070320152533.GH6152@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br

Now that libata uses sd->manage_start_stop, libata spins down disk on
shutdown.  In an attempt to compensate libata's previous shortcoming,
shutdown(8) syncs and spins down disks attached via libata.  Some
disks spin back up just to spin down again on STANDBYNOW1 if the
command is issued when the disk is spun down, so this double spinning
down causes problem.

This patch implements module parameter libata.spindown_compat which,
when set to one (default value), prevents libata from spinning down
disks on shutdown thus avoiding double spinning down.  Note that
libata spins down disks for suspend to mem and disk, so with
libata.spindown_compat set to one, disks should be properly spun down
in all cases without modifying shutdown(8).

shutdown(8) should be fixed eventually tho.  Some drive do spin up on
SYNCHRONZE_CACHE even when their cache is clean.  Those disks
currently spin up briefly when sd tries to shutdown the device and
then the machine powers off immediately, which can't be good for the
head.  We can't skip SYNCHRONIZE_CACHE during shudown as it can be
dangerous data integrity-wise.

So, this spindown_compat parameter is already scheduled for removal by
the end of the next year and here's what shutdown(8) should do.

  1. Check whether /sys/modules/libata/parameters/spindown_compat
     exists.  If it does, write 0 to it.

  For each libata harddisk {

    2. Check whether /sys/class/scsi_disk/h:c:i:l/manage_start_stop
       exists.  If so, write 1 to it and continue; otherwise, fall
       through to #3.

    3. Synchronize cache and spin down as before.

  }

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
Henrique, does it look good enough?  How do we coordinate this with
distributions?  I can take care of suse and I guess Alan/Jeff can do
so for redhat.  So, that leaves us with Debian, Ubuntu, Gentoo...

 Documentation/feature-removal-schedule.txt |   19 +++++++++++++++++++
 drivers/ata/libata-core.c                  |    6 ++++++
 drivers/ata/libata-scsi.c                  |   14 +++++++++++++-
 drivers/ata/libata.h                       |    1 +
 4 files changed, 39 insertions(+), 1 deletion(-)

Index: work/Documentation/feature-removal-schedule.txt
===================================================================
--- work.orig/Documentation/feature-removal-schedule.txt
+++ work/Documentation/feature-removal-schedule.txt
@@ -324,3 +324,22 @@ Why:	the i8xx_tco watchdog driver has be
 Who:	Wim Van Sebroeck <wim@iguana.be>
 
 ---------------------------
+
+What:	libata.spindown_compat module parameter
+When:	Dec 2008
+Why:	halt(8) synchronizes caches for and spins down libata disks
+	because libata didn't use to spin down disk on system halt
+	(only synchronized caches).
+	Spin down on system halt is now implemented and can be tested
+	using sysfs node /sys/class/scsi_disk/h:c:i:l/manage_start_stop.
+	Because issuing spin down command to an already spun down disk
+	makes some disks spin up just to spin down again, the old
+	behavior needs to be maintained till userspace tool is updated
+	to check the sysfs node and not to spin down disks with the
+	node set to one.
+	This module parameter is to give userspace tool the time to
+	get updated and should be removed after userspace is
+	reasonably updated.
+Who:	Tejun Heo <htejun@gmail.com>
+
+---------------------------
Index: work/drivers/ata/libata-core.c
===================================================================
--- work.orig/drivers/ata/libata-core.c
+++ work/drivers/ata/libata-core.c
@@ -97,6 +97,12 @@ int noacpi;
 module_param(noacpi, int, 0444);
 MODULE_PARM_DESC(noacpi, "Disables the use of ACPI in suspend/resume when set");
 
+int ata_spindown_compat = 1;
+module_param_named(spindown_compat, ata_spindown_compat, int, 0644);
+MODULE_PARM_DESC(spindown_compat, "Enable backward compatible spindown "
+		 "behavior.  Will be removed.  More info can be found in "
+		 "Documentation/feature-removal-schedule.txt\n");
+
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Library module for ATA devices");
 MODULE_LICENSE("GPL");
Index: work/drivers/ata/libata-scsi.c
===================================================================
--- work.orig/drivers/ata/libata-scsi.c
+++ work/drivers/ata/libata-scsi.c
@@ -944,9 +944,21 @@ static unsigned int ata_scsi_start_stop_
 		}
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
-	} else
+	} else {
+		/* XXX: This is for backward compatibility, will be
+		 * removed.  Read Documentation/feature-removal-schedule.txt
+		 * for more info.
+		 */
+		if (ata_spindown_compat &&
+		    (system_state == SYSTEM_HALT ||
+		     system_state == SYSTEM_POWER_OFF)) {
+			scmd->result = SAM_STAT_GOOD;
+			return 1;
+		}
+
 		/* Issue ATA STANDBY IMMEDIATE command */
 		tf->command = ATA_CMD_STANDBYNOW1;
+	}
 
 	/*
 	 * Standby and Idle condition timers could be implemented but that
Index: work/drivers/ata/libata.h
===================================================================
--- work.orig/drivers/ata/libata.h
+++ work/drivers/ata/libata.h
@@ -57,6 +57,7 @@ extern int atapi_enabled;
 extern int atapi_dmadir;
 extern int libata_fua;
 extern int noacpi;
+extern int ata_spindown_compat;
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
