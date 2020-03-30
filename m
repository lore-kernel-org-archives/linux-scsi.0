Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72554C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 02:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53AE420675
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 02:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgC3CwA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Mar 2020 22:52:00 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:51298 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgC3CwA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Mar 2020 22:52:00 -0400
Received: by mail-pj1-f67.google.com with SMTP id w9so6938940pjh.1
        for <linux-scsi@vger.kernel.org>; Sun, 29 Mar 2020 19:51:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DxQG1ML2sgW/gNHiNXmztkVvTGSKdlkC2Otw92a93gs=;
        b=sIENkqwj8U9o8lnX2NQZK2q7nym+SbLQw7NHyKOX3AGiRrIUPnJREE7b4tOLBHt2MV
         ymVImdVtVaySI4t/vvVXJHO9PlS3tMQJ2d4jft3I8uz8vr8FvqyABd5BOtdWzE6lj1RF
         MlhKsOU1MA495JTCF9Mg32gcxS51hHUnFg7akqHxDqM234z/7QyhY0j+wceFezH3ttEh
         ctabK7UI4anPvwbVAl5QcrntwupWneTtqzR4HvkRO5/nPQCE3fR/Ek46ie61du73L//h
         cOjd3nkikNLMafgaX9mgqEXU8VjJLDhtogvvK7Kdn2UjvFPxA+ifLgG6sBq1eWTLIEXp
         Z+AA==
X-Gm-Message-State: ANhLgQ2OYEmFbzRtRHDP3Zl5DArSuFu7CMIljWSGbhkNUuQxr7S2ljH8
        8AHR3xZXfdHgrqvkfM9BFRuf4oX/o/Q=
X-Google-Smtp-Source: ADFU+vvTMALG7BDe/2tbyzILiylYLbM3LFNu50AjwKfrZhvYHP6OYhr0AjIHmxiz6cP0JbESkzn4bw==
X-Received: by 2002:a17:902:7d84:: with SMTP id a4mr9758823plm.31.1585536718794;
        Sun, 29 Mar 2020 19:51:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1d21:aef6:5c03:df86])
        by smtp.gmail.com with ESMTPSA id 67sm8937690pfe.168.2020.03.29.19.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 19:51:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Merlijn Wajer <merlijn@archive.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@kernel.org
Subject: [PATCH] sr: Fix sr_block_release()
Date:   Sun, 29 Mar 2020 19:51:51 -0700
Message-Id: <20200330025151.10535-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following two complaints:

WARNING: CPU: 3 PID: 1326 at kernel/locking/mutex-debug.c:103 mutex_destroy+0x74/0x80
Modules linked in: scsi_debug sd_mod t10_pi brd scsi_transport_iscsi af_packet crct10dif_pclmul sg aesni_intel glue_helper virtio_balloon button crypto_simd cryptd intel_agp intel_gtt agpgart ip_tables x_tables ipv6 nf_defrag_ipv6 autofs4 ext4 crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom ata_generic pata_acpi virtio_blk virtio_net net_failover failover ata_piix xhci_pci ahci libahci xhci_hcd i2c_piix4 libata virtio_pci usbcore i2c_core virtio_ring scsi_mod usb_common virtio [last unloaded: scsi_debug]
CPU: 3 PID: 1326 Comm: systemd-udevd Not tainted 5.6.0-rc1-dbg+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
RIP: 0010:mutex_destroy+0x74/0x80
Call Trace:
 sr_kref_release+0xb9/0xd0 [sr_mod]
 scsi_cd_put+0x79/0x90 [sr_mod]
 sr_block_release+0x54/0x70 [sr_mod]
 __blkdev_put+0x2ce/0x3c0
 blkdev_put+0x68/0x220
 blkdev_close+0x4d/0x60
 __fput+0x170/0x3b0
 ____fput+0x12/0x20
 task_work_run+0xa2/0xf0
 exit_to_usermode_loop+0xeb/0xf0
 do_syscall_64+0x2be/0x300
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7fa16d40aab7

BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0x98/0x420
Read of size 8 at addr ffff8881c6e4f4b0 by task systemd-udevd/1326

CPU: 3 PID: 1326 Comm: systemd-udevd Tainted: G        W         5.6.0-rc1-dbg+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
 dump_stack+0xa5/0xe6
 print_address_description.constprop.0+0x46/0x60
 __kasan_report.cold+0x7b/0x94
 kasan_report+0x16/0x20
 check_memory_region+0x140/0x1b0
 __kasan_check_read+0x15/0x20
 __mutex_unlock_slowpath+0x98/0x420
 mutex_unlock+0x16/0x20
 sr_block_release+0x5c/0x70 [sr_mod]
 __blkdev_put+0x2ce/0x3c0
hardirqs last  enabled at (1875522): [<ffffffff81bb0696>] _raw_spin_unlock_irqrestore+0x56/0x70
 blkdev_put+0x68/0x220
 blkdev_close+0x4d/0x60
 __fput+0x170/0x3b0
 ____fput+0x12/0x20
 task_work_run+0xa2/0xf0
 exit_to_usermode_loop+0xeb/0xf0
 do_syscall_64+0x2be/0x300
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7fa16d40aab7

Allocated by task 3201:
 save_stack+0x23/0x90
 __kasan_kmalloc.constprop.0+0xcf/0xe0
 kasan_kmalloc+0xd/0x10
 kmem_cache_alloc_trace+0x161/0x3c0
 sr_probe+0x12f/0xb60 [sr_mod]
 really_probe+0x183/0x5d0
 driver_probe_device+0x13f/0x1a0
 __device_attach_driver+0xe6/0x150
 bus_for_each_drv+0x101/0x160
 __device_attach+0x183/0x230
 device_initial_probe+0x17/0x20
 bus_probe_device+0x110/0x130
 device_add+0xb7b/0xd40
 scsi_sysfs_add_sdev+0xe8/0x360 [scsi_mod]
 scsi_probe_and_add_lun+0xdc4/0x14c0 [scsi_mod]
 __scsi_scan_target+0x12d/0x850 [scsi_mod]
 scsi_scan_channel+0xcd/0xe0 [scsi_mod]
 scsi_scan_host_selected+0x182/0x190 [scsi_mod]
 store_scan+0x1e9/0x200 [scsi_mod]
 dev_attr_store+0x42/0x60
 sysfs_kf_write+0x8b/0xb0
 kernfs_fop_write+0x158/0x250
 __vfs_write+0x4c/0x90
 vfs_write+0x145/0x2c0
 ksys_write+0xd7/0x180
 __x64_sys_write+0x47/0x50
 do_syscall_64+0x6f/0x300
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 1326:
 save_stack+0x23/0x90
 __kasan_slab_free+0x13a/0x190
 kasan_slab_free+0x12/0x20
 kfree+0x109/0x410
 sr_kref_release+0xc1/0xd0 [sr_mod]
 scsi_cd_put+0x79/0x90 [sr_mod]
 sr_block_release+0x54/0x70 [sr_mod]
 __blkdev_put+0x2ce/0x3c0
 blkdev_put+0x68/0x220
 blkdev_close+0x4d/0x60
 __fput+0x170/0x3b0
 ____fput+0x12/0x20
 task_work_run+0xa2/0xf0
 exit_to_usermode_loop+0xeb/0xf0
 do_syscall_64+0x2be/0x300
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Cc: Merlijn Wajer <merlijn@archive.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@kernel.org>
Fixes: 51a858817dcd ("scsi: sr: get rid of sr global mutex")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0f1a926f6341..e8b2e014770c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -551,10 +551,12 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 static void sr_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
+
 	mutex_lock(&cd->lock);
 	cdrom_release(&cd->cdi, mode);
-	scsi_cd_put(cd);
 	mutex_unlock(&cd->lock);
+
+	scsi_cd_put(cd);
 }
 
 #ifndef CONFIG_COMPAT
