Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2474FC5DF60
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 046ED2178F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfKGFWM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 00:22:12 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33531 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfKGFWM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 00:22:12 -0500
Received: by mail-pg1-f193.google.com with SMTP id h27so1173036pgn.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 21:22:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=52YNfvqeMMQOXqCejA5BhSKdxlrXi+wD0MjRVZBDQV0=;
        b=mdggNIVIbrEk/YQLcVK/lZvwgZocSTmWlQLoWIQb/0m+ES7IVanrqQ/k2BYymi7q7I
         B/iV0yuBRcWRuZ4MUe9jil4NYQmNyZHixAvaA3Q0pvGd1YQIVevrkmqTyLO/vWXMR04Z
         VvfIQI+Kx5ImJqV9wpGZoJffHiPPG6W/aB7TF54NIZNrWOUNMvVGZvjvKilEgSxs89yP
         NOOpUyPl/uNeb8KAhmlcjF9KDjYSky9D/1uklCO6QytsoVMx8+zfM20bPD2ASVDEFoy9
         JqfkfyEb5nT7z5JkUl4l6XuQbY5KCtGnEkCM2eOett60I/TIl/pzaXKarDAXC5Nq3I8H
         v28g==
X-Gm-Message-State: APjAAAUSYhKkW5ysI/LCwl+vcts6RFNd73tkD8W8Wd7/FASx/cbNl3Cu
        4mJPjopxi69fwqjUM/Og/0E=
X-Google-Smtp-Source: APXvYqxl+x0arBnhqGf3VZ2Yc6D/3XyTlpbHJ4fIYdPhttlix3T3s8axKC/ya5YBl7HWvdGTFe4spw==
X-Received: by 2002:a63:7cf:: with SMTP id 198mr2149974pgh.372.1573104131534;
        Wed, 06 Nov 2019 21:22:11 -0800 (PST)
Received: from localhost.net ([2601:647:4000:1075:7917:b099:7983:671c])
        by smtp.gmail.com with ESMTPSA id m13sm719961pga.70.2019.11.06.21.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 21:22:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/3] lpfc: Fix a kernel warning triggered by lpfc_sli4_enable_intr()
Date:   Wed,  6 Nov 2019 21:21:56 -0800
Message-Id: <20191107052158.25788-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107052158.25788-1-bvanassche@acm.org>
References: <20191107052158.25788-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following lockdep warning:

============================================
WARNING: possible recursive locking detected
5.4.0-rc6-dbg+ #2 Not tainted
--------------------------------------------
systemd-udevd/130 is trying to acquire lock:
ffffffff826b05d0 (cpu_hotplug_lock.rw_sem){++++}, at: irq_calc_affinity_vectors+0x63/0x90

but task is already holding lock:

ffffffff826b05d0 (cpu_hotplug_lock.rw_sem){++++}, at: lpfc_sli4_enable_intr+0x422/0xd50 [lpfc]

other info that might help us debug this:

 Possible unsafe locking scenario:
       CPU0
       ----
  lock(cpu_hotplug_lock.rw_sem);
  lock(cpu_hotplug_lock.rw_sem);

*** DEADLOCK ***
 May be due to missing lock nesting notation
2 locks held by systemd-udevd/130:
 #0: ffff8880d53fe210 (&dev->mutex){....}, at: __device_driver_lock+0x4a/0x70
 #1: ffffffff826b05d0 (cpu_hotplug_lock.rw_sem){++++}, at: lpfc_sli4_enable_intr+0x422/0xd50 [lpfc]

stack backtrace:
CPU: 1 PID: 130 Comm: systemd-udevd Not tainted 5.4.0-rc6-dbg+ #2
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
 dump_stack+0xa5/0xe6
 __lock_acquire.cold+0xf7/0x23a
 lock_acquire+0x106/0x240
 cpus_read_lock+0x41/0xe0
 irq_calc_affinity_vectors+0x63/0x90
 __pci_enable_msix_range+0x10a/0x950
 pci_alloc_irq_vectors_affinity+0x144/0x210
 lpfc_sli4_enable_intr+0x4b2/0xd50 [lpfc]
 lpfc_pci_probe_one+0x1411/0x22b0 [lpfc]
 local_pci_probe+0x7c/0xc0
 pci_device_probe+0x25d/0x390
 really_probe+0x170/0x510
 driver_probe_device+0x127/0x190
 device_driver_attach+0x98/0xa0
 __driver_attach+0xb6/0x1a0
 bus_for_each_dev+0x100/0x150
 driver_attach+0x31/0x40
 bus_add_driver+0x246/0x300
 driver_register+0xe0/0x170
 __pci_register_driver+0xde/0xf0
 lpfc_init+0x134/0x1000 [lpfc]
 do_one_initcall+0xda/0x47e
 do_init_module+0x10a/0x3b0
 load_module+0x4318/0x47c0
 __do_sys_finit_module+0x134/0x1d0
 __x64_sys_finit_module+0x47/0x50
 do_syscall_64+0x6f/0x2e0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: dcaa21367938 ("scsi: lpfc: Change default IRQ model on AMD architectures")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 28e6a763f106..37e57fd9ba5d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11580,9 +11580,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 		retval = 0;
 		if (!retval) {
 			/* Now, try to enable MSI-X interrupt mode */
-			get_online_cpus();
 			retval = lpfc_sli4_enable_msix(phba);
-			put_online_cpus();
 			if (!retval) {
 				/* Indicate initialization to MSI-X mode */
 				phba->intr_type = MSIX;
-- 
2.23.0

