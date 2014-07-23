From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Wed, 23 Jul 2014 21:13:41 +0100
Message-ID: <20140723201341.GA10292@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723141028.GA22724@sucs.org>
 <20140723141558.GA9705@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20140723141558.GA9705@infradead.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 23, 2014 at 07:15:58AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 23, 2014 at 03:10:28PM +0100, Sitsofe Wheeler wrote:
> > I'm not sure this alone will work - won't sdev_bflags/bflags have
> > already been built at this point?
> 
> They've been built up, but we can still or new values into it.  It looks
> fine to me from review, but if you can test it on an actualy hypverv
> setup that would be valueable feedback.

The previous patches didn't work for me with a Windows 2012 R2 host with a
3.16.0-rc6.x86_64-00076-g2f7d2ec-dirty guest. After applying
https://patchwork.kernel.org/patch/4541201 (which needed a small fixup) and
https://patchwork.kernel.org/patch/4598601 and the attached debugging output
patch here's the result I got:

hv_vmbus: registering driver hv_storvsc
scsi0 : storvsc_host_t
scsi 0:0:0:0: scsi_get_device_flags_keyed: key: 3
scsi 0:0:0:0: scsi_get_device_flags_keyed: Post SCSI_DEVINFO_GLOBAL
scsi 0:0:0:0: scsi_get_device_flags_keyed: No sdev_bflags
scsi 0:0:0:0: sdev->scsi_level: 5
scsi 0:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
scsi 0:0:0:0: scsi_add_lun: Have BLIST_TRY_VPD_PAGES? No
scsi 0:0:0:0: storvsc_device_configure: Added BLIST_TRY_VPD_PAGES
scsi1 : storvsc_host_t
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: scsi_get_device_flags_keyed: key: 3
scsi 1:0:0:0: scsi_get_device_flags_keyed: Post SCSI_DEVINFO_GLOBAL
scsi 1:0:0:0: scsi_get_device_flags_keyed: No sdev_bflags
scsi 1:0:0:0: sdev->scsi_level: 5
scsi 1:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
scsi 1:0:0:0: scsi_add_lun: Have BLIST_TRY_VPD_PAGES? No
scsi 1:0:0:0: storvsc_device_configure: Added BLIST_TRY_VPD_PAGES
scsi 1:0:0:1: scsi_get_device_flags_keyed: key: 5
scsi 1:0:0:1: scsi_get_device_flags_keyed: Post SCSI_DEVINFO_GLOBAL
scsi 1:0:0:1: scsi_get_device_flags_keyed: No sdev_bflags
scsi 1:0:0:1: scsi_get_device_flags_keyed: key: 5
scsi 1:0:0:1: scsi_get_device_flags_keyed: Post SCSI_DEVINFO_GLOBAL
scsi 1:0:0:1: scsi_get_device_flags_keyed: No sdev_bflags
scsi 1:0:0:1: sdev->scsi_level: 0
scsi 1:0:0:1: Direct-Access     ADATA    SSD S510 120GB   5.2. PQ: 0 ANSI: 0
scsi 1:0:0:1: scsi_add_lun: Have BLIST_TRY_VPD_PAGES? No
scsi 1:0:0:1: storvsc_device_configure: Added BLIST_TRY_VPD_PAGES
scsi 1:0:0:3: scsi_get_device_flags_keyed: key: 0
scsi 1:0:0:3: scsi_get_device_flags_keyed: Post SCSI_DEVINFO_GLOBAL
scsi 1:0:0:3: scsi_get_device_flags_keyed: No sdev_bflags
scsi 1:0:0:3: sdev->scsi_level: 5
scsi 1:0:0:3: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
scsi 1:0:0:3: scsi_add_lun: Have BLIST_TRY_VPD_PAGES? No
scsi 1:0:0:3: storvsc_device_configure: Added BLIST_TRY_VPD_PAGES
sd 1:0:0:0: sd_try_rc16_first: sdp->scsi_level: 5
sd 1:0:0:0: [sdb] 2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)
sd 1:0:0:0: [sdb] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:0: [sdb] sd_revalidate_disk: Skipped extended inquiries
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 0f 00 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: sd_try_rc16_first: sdp->scsi_level: 5
ata_piix 0000:00:07.1: version 2.13
sd 1:0:0:0: sd_try_rc16_first: sdp->scsi_level: 5
sd 1:0:0:0: [sdb] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:0: [sdb] sd_revalidate_disk: Skipped extended inquiries
 sdb: unknown partition table
ata_piix 0000:00:07.1: Hyper-V Virtual Machine detected, ATA device ignore set
sd 1:0:0:0: sd_try_rc16_first: sdp->scsi_level: 5
sd 1:0:0:0: [sdb] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:0: [sdb] sd_revalidate_disk: Skipped extended inquiries
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 0:0:0:0: [sda] 8388608 512-byte logical blocks: (4.29 GB/4.00 GiB)
scsi2 : ata_piix
scsi3 : ata_piix
ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
sd 1:0:0:1: Attached scsi generic sg2 type 0
libphy: Fixed MDIO Bus: probed
hv_vmbus: registering driver hv_netvsc
sd 1:0:0:3: Attached scsi generic sg3 type 0
hv_netvsc: hv_netvsc channel opened successfully
sd 0:0:0:0: [sda] sd_revalidate_disk: Extended inquiry check...
sd 0:0:0:0: [sda] sd_revalidate_disk: Skipped extended inquiries
sd 1:0:0:1: sd_try_rc16_first: sdp->scsi_level: 0
sd 1:0:0:3: sd_try_rc16_first: sdp->scsi_level: 5
sd 1:0:0:1: [sdc] 234441648 512-byte logical blocks: (120 GB/111 GiB)
sd 1:0:0:1: [sdc] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:1: [sdc] sd_revalidate_disk: Skipped extended inquiries
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 0f 00 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: sd_try_rc16_first: sdp->scsi_level: 5
sd 0:0:0:0: [sda] sd_revalidate_disk: Extended inquiry check...
sd 0:0:0:0: [sda] sd_revalidate_disk: Skipped extended inquiries
 sda: sda1
sd 0:0:0:0: sd_try_rc16_first: sdp->scsi_level: 5
sd 0:0:0:0: [sda] sd_revalidate_disk: Extended inquiry check...
sd 0:0:0:0: [sda] sd_revalidate_disk: Skipped extended inquiries
sd 0:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:1: [sdc] Write Protect is off
sd 1:0:0:3: [sdd] 199229440 512-byte logical blocks: (102 GB/95.0 GiB)
sd 1:0:0:3: [sdd] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:3: [sdd] sd_revalidate_disk: Skipped extended inquiries
sd 1:0:0:3: [sdd] Write Protect is off
sd 1:0:0:3: [sdd] Mode Sense: 0f 00 00 00
sd 1:0:0:3: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:1: [sdc] Mode Sense: 0f 00 00 00
sd 1:0:0:3: sd_try_rc16_first: sdp->scsi_level: 5
sd 1:0:0:1: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:3: [sdd] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:3: [sdd] sd_revalidate_disk: Skipped extended inquiries
 sdd: unknown partition table
sd 1:0:0:3: sd_try_rc16_first: sdp->scsi_level: 5
sd 1:0:0:3: [sdd] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:3: [sdd] sd_revalidate_disk: Skipped extended inquiries
sd 1:0:0:3: [sdd] Attached SCSI disk
sd 1:0:0:1: sd_try_rc16_first: sdp->scsi_level: 0
sd 1:0:0:1: [sdc] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:1: [sdc] sd_revalidate_disk: Skipped extended inquiries
 sdc: sdc1
sd 1:0:0:1: sd_try_rc16_first: sdp->scsi_level: 0
sd 1:0:0:1: [sdc] sd_revalidate_disk: Extended inquiry check...
sd 1:0:0:1: [sdc] sd_revalidate_disk: Skipped extended inquiries
ata1.00: host indicates ignore ATA devices, ignored
sd 1:0:0:1: [sdc] Attached SCSI disk
tsc: Refined TSC clocksource calibration: 3200.069 MHz

sda is a 4 GByte VHDX attached to Hyper-V's IDE interface.
sdb is a 1 GByte VHDX attached to Hyper-V's SCSI interface.
sdc is a 111.8 GByte SSD being passed through Hyper-V's SCSI interface.
sdd is a 95 GByte VHDX being passed through Hyper-V's SCSI interface.

-- 
Sitsofe | http://sucs.org/~sits/

--fdj2RfSjLxBAspz7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Add-debugging-output-to-SCSI-disk-initalisation-to-t.patch"

>From abc3c29ce756f8be6aa8a945a8c81b29d396dbb6 Mon Sep 17 00:00:00 2001
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Date: Wed, 23 Jul 2014 15:41:31 +0000
Subject: [PATCH] Add debugging output to SCSI disk initalisation to trace LBP
 testing.

---
 drivers/scsi/scsi.c         |  5 +++++
 drivers/scsi/scsi_devinfo.c |  7 +++++++
 drivers/scsi/scsi_scan.c    | 10 ++++++++--
 drivers/scsi/sd.c           | 28 ++++++++++++++++++++++++++++
 drivers/scsi/storvsc_drv.c  |  1 +
 5 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..6a7a854 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -992,11 +992,13 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 	if (sdev->skip_vpd_pages)
 		goto fail;
 
+	printk(KERN_NOTICE "Don't skip\n");
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
 	if (result < 4)
 		goto fail;
 
+	printk(KERN_NOTICE "Got all pages\n");
 	/* If the user actually wanted this page, we can skip the rest */
 	if (page == 0)
 		return 0;
@@ -1008,13 +1010,16 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 	if (i < result && i >= buf_len)
 		/* ran off the end of the buffer, give us benefit of doubt */
 		goto found;
+	printk(KERN_NOTICE "Couldn't find page\n");
 	/* The device claims it doesn't support the requested page */
 	goto fail;
 
  found:
+	printk(KERN_NOTICE "Read vpd page\n");
 	result = scsi_vpd_inquiry(sdev, buf, page, buf_len);
 	if (result < 0)
 		goto fail;
+	printk(KERN_NOTICE "Read vpd page success\n");
 
 	return 0;
 
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index f969aca..cbde61f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -619,14 +619,21 @@ int scsi_get_device_flags_keyed(struct scsi_device *sdev,
 				return devinfo->flags;
 		}
 	}
+	sdev_printk(KERN_NOTICE, sdev,
+		    "scsi_get_device_flags_keyed: key: %d\n",
+		    sdev->scsi_level);
 	/* nothing found, return nothing */
 	if (key != SCSI_DEVINFO_GLOBAL)
 		return 0;
 
+	sdev_printk(KERN_NOTICE, sdev,
+		    "scsi_get_device_flags_keyed: Post SCSI_DEVINFO_GLOBAL\n");
 	/* except for the global list, where we have an exception */
 	if (sdev->sdev_bflags)
 		return sdev->sdev_bflags;
 
+	sdev_printk(KERN_NOTICE, sdev,
+		    "scsi_get_device_flags_keyed: No sdev_bflags\n");
 	return scsi_default_dev_flags;
 }
 EXPORT_SYMBOL(scsi_get_device_flags_keyed);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 492cd70..7de78b8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -734,6 +734,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
 		sdev->scsi_level++;
 	sdev->sdev_target->scsi_level = sdev->scsi_level;
+	sdev_printk(KERN_NOTICE, sdev, "sdev->scsi_level: %d\n", sdev->scsi_level);
 
 	return 0;
 }
@@ -950,9 +951,14 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
-	if (*bflags & BLIST_TRY_VPD_PAGES)
+	sdev_printk(KERN_NOTICE, sdev,
+		    "scsi_add_lun: Have BLIST_TRY_VPD_PAGES? %s",
+		    ((*bflags & BLIST_TRY_VPD_PAGES) ? "Yes" : "No"));
+	if (*bflags & BLIST_TRY_VPD_PAGES) {
 		sdev->try_vpd_pages = 1;
-	else if (*bflags & BLIST_SKIP_VPD_PAGES)
+		sdev_printk(KERN_NOTICE, sdev,
+			    "scsi_add_lun: Set try_vpd_pages");
+	} else if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
 	transport_configure_device(&sdev->sdev_gendev);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ed2e99e..b905e1e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -636,6 +636,8 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 
 	sdkp->provisioning_mode = mode;
 
+	//dump_stack();
+	sd_printk(KERN_NOTICE, sdkp, "Discard mode: %u\n", mode);
 	switch (mode) {
 
 	case SD_LBP_DISABLE:
@@ -1947,6 +1949,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	unsigned long long lba;
 	unsigned sector_size;
 
+	sd_printk(KERN_NOTICE, sdkp, "Entered read_capacity_16\n");
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
@@ -1985,6 +1988,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		retries--;
 
 	} while (the_result && retries);
+	sd_printk(KERN_ERR, sdkp, "Past illegal req\n");
 
 	if (the_result) {
 		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY(16) failed\n");
@@ -1995,10 +1999,13 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	sector_size = get_unaligned_be32(&buffer[8]);
 	lba = get_unaligned_be64(&buffer[0]);
 
+	sd_printk(KERN_ERR, sdkp, "Protection check\n");
 	if (sd_read_protection_type(sdkp, buffer) < 0) {
+		sd_printk(KERN_ERR, sdkp, "Protection %d\n", sd_read_protection_type(sdkp, buffer));
 		sdkp->capacity = 0;
 		return -ENODEV;
 	}
+	sd_printk(KERN_ERR, sdkp, "Got past protection check\n");
 
 	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
@@ -2018,8 +2025,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		sd_printk(KERN_NOTICE, sdkp,
 			  "physical block alignment offset: %u\n", alignment);
 
+	sd_printk(KERN_NOTICE, sdkp, "Checking LBPME\n");
 	if (buffer[14] & 0x80) { /* LBPME */
 		sdkp->lbpme = 1;
+		sd_printk(KERN_NOTICE, sdkp, "LBPME OK!\n");
 
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
@@ -2109,6 +2118,9 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 		return 1;
 	if (scsi_device_protection(sdp))
 		return 1;
+	sdev_printk(KERN_NOTICE, sdp,
+		    "sd_try_rc16_first: sdp->scsi_level: %d\n",
+		    sdp->scsi_level);
 	return 0;
 }
 
@@ -2542,24 +2554,29 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	const int vpd_len = 64;
 	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
 
+	sd_printk(KERN_NOTICE, sdkp, "Entered block limits\n");
 	if (!buffer ||
 	    /* Block Limits VPD */
 	    scsi_get_vpd_page(sdkp->device, 0xb0, buffer, vpd_len))
 		goto out;
+	sd_printk(KERN_NOTICE, sdkp, "Started block limits\n");
 
 	blk_queue_io_min(sdkp->disk->queue,
 			 get_unaligned_be16(&buffer[6]) * sector_sz);
 	blk_queue_io_opt(sdkp->disk->queue,
 			 get_unaligned_be32(&buffer[12]) * sector_sz);
 
+	sd_printk(KERN_NOTICE, sdkp, "0x3c...\n");
 	if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;
 
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
 
+		sd_printk(KERN_NOTICE, sdkp, "Testing lbpme...\n");
 		if (!sdkp->lbpme)
 			goto out;
 
+		sd_printk(KERN_NOTICE, sdkp, "...lbpme test done\n");
 		lba_count = get_unaligned_be32(&buffer[20]);
 		desc_count = get_unaligned_be32(&buffer[24]);
 
@@ -2574,6 +2591,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 		if (!sdkp->lbpvpd) { /* LBP VPD page not provided */
 
+			sd_printk(KERN_NOTICE, sdkp, "Entering discard switch with NO LBP VPD\n");
 			if (sdkp->max_unmap_blocks)
 				sd_config_discard(sdkp, SD_LBP_UNMAP);
 			else
@@ -2581,6 +2599,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 		} else {	/* LBP VPD page tells us what to use */
 
+			sd_printk(KERN_NOTICE, sdkp, "Entering discard switch via LBP VPD\n");
 			if (sdkp->lbpu && sdkp->max_unmap_blocks)
 				sd_config_discard(sdkp, SD_LBP_UNMAP);
 			else if (sdkp->lbpws)
@@ -2631,14 +2650,19 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 	unsigned char *buffer;
 	const int vpd_len = 8;
 
+	sd_printk(KERN_NOTICE, sdkp,
+		  "sd_read_block_provisioning: Entered, lbmpe: %u\n",
+		  sdkp->lbpme);
 	if (sdkp->lbpme == 0)
 		return;
+	sd_printk(KERN_NOTICE, sdkp, "sd_read_block_provisioning: Passed lbmpe test\n");
 
 	buffer = kmalloc(vpd_len, GFP_KERNEL);
 
 	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb2, buffer, vpd_len))
 		goto out;
 
+	sd_printk(KERN_NOTICE, sdkp, "sd_read_block_provisioning: Setting block provisioning\n");
 	sdkp->lbpvpd	= 1;
 	sdkp->lbpu	= (buffer[5] >> 7) & 1;	/* UNMAP */
 	sdkp->lbpws	= (buffer[5] >> 6) & 1;	/* WRITE SAME(16) with UNMAP */
@@ -2734,10 +2758,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
 
+		sd_printk(KERN_NOTICE, sdkp, "sd_revalidate_disk: Extended inquiry check...\n");
 		if (sd_try_extended_inquiry(sdp)) {
+			sd_printk(KERN_NOTICE, sdkp, "sd_revalidate_disk: Performing extended inquiries\n");
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
+		} else {
+			sd_printk(KERN_NOTICE, sdkp, "sd_revalidate_disk: Skipped extended inquiries\n");
 		}
 
 		sd_read_write_protect_flag(sdkp, buffer);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5ad2810..5f733c7 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1450,6 +1450,7 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 	 * With this patch we can correctly handle WRITE_SAME_16 issues.
 	 */
 	sdevice->sdev_bflags |= msft_blist_flags;
+	sdev_printk(KERN_NOTICE, sdevice, "storvsc_device_configure: Added BLIST_TRY_VPD_PAGES\n");
 
 	return 0;
 }
-- 
1.9.3


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

--fdj2RfSjLxBAspz7--
