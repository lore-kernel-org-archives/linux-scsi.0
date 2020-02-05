Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01110C352A1
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 18:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCE52217F4
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 18:44:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aRg9jp3V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgBESoE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 13:44:04 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38111 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgBESoD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2020 13:44:03 -0500
Received: by mail-pl1-f196.google.com with SMTP id t6so1241489plj.5
        for <linux-scsi@vger.kernel.org>; Wed, 05 Feb 2020 10:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5T8MzJpEKCZQD1TpWCDlzD98e7wG/FbZy8dik7t5eOA=;
        b=aRg9jp3VaplFOBgt2oPDi8HqIKx0WGZwBoRnQ1n0qNlh8vjzzZviyN+h94Gi7BZaFg
         93DLnwMLm8qK9JZrzSgL1jBYWrDfjZ/oSvLyP9bPgFhTyugPMUXMpLRuURwojLD2LRbq
         BN3tCsj0ZBNTv2tr/7QeYdiWYxRH3v+pOt7KU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5T8MzJpEKCZQD1TpWCDlzD98e7wG/FbZy8dik7t5eOA=;
        b=UXJoSApbBsUUGlNdoBp+Szr4AHo0nFsvBjpKHehEjntaYrLWilQOTRDmjLcWmZI4wS
         p75+kCKvEomvT2PTLXouqU0+v8zPzUWVt+H0DrPyIkr5V7Re5kqefMwfr8pyWDrP5enw
         AzLX5+auJ12zldDW7Glonde1Wn/Zur9o3Mrn9Oms4KyRnVXh1/6kecORHAfXJTK2VSVk
         /OZK7TZQq5QfVzCjPE2PsG8cN7Hbf/U6+Y//w3tyhuNowPKkeVA0ePJqBvbIJq1cWtmS
         zSar5Oto0mbQvegx/H3+FmDU0z6Z5H58A3huM4EcgwDcjXaDQh52P20DVMuIqNTy+/XB
         mQ1g==
X-Gm-Message-State: APjAAAWHUwoRIN6de2v1nbMbJjf91x3xR4EUsexGAcTjy7UfWxA/1yPW
        lBEvrord1rWqYZPPbmRRyUB5QA==
X-Google-Smtp-Source: APXvYqyi42gAF8IDbEUzCkaIHLkoaxQsvKZJxw52io5DKj8A4zY2JCiFQSxn/xClzcAGrKziS7dQIQ==
X-Received: by 2002:a17:902:9b93:: with SMTP id y19mr36176082plp.89.1580928243216;
        Wed, 05 Feb 2020 10:44:03 -0800 (PST)
Received: from localhost ([2620:15c:202:1:4cc0:7eee:97c9:3c1a])
        by smtp.gmail.com with ESMTPSA id c26sm238920pfj.8.2020.02.05.10.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 10:44:02 -0800 (PST)
From:   Gwendal Grignou <gwendal@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>,
        Guenter Roeck <groeck@chromium.org>
Subject: [PATCH] ata/scsi: Prevent FS corruption on chromebook pixel2  at reboot
Date:   Wed,  5 Feb 2020 10:43:58 -0800
Message-Id: <20200205184358.116927-1-gwendal@chromium.org>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Samus, even when rebooting, the root device is power cycled.
Normally, during reboot, root device is not power cycled, so the device
does not have to flush its volatle drive cache to permanent media.

However, in case of Samus, given the SSD is power cycled, we force the SSD
to flush its cache by issuing a SCSI START_STOP command, translated into
an ATA STANDBY command.

Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 drivers/ata/ahci.c         | 25 +++++++++++++++++++++++++
 drivers/scsi/sd.c          |  5 +++--
 include/scsi/scsi_device.h |  1 +
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index dd92faf197d5e..0677c9f1d14af 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -29,6 +29,7 @@
 #include <linux/msi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <linux/libata.h>
 #include <linux/ahci-remap.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
@@ -88,6 +89,8 @@ static void ahci_mcp89_apple_enable(struct pci_dev *pdev);
 static bool is_mcp89_apple(struct pci_dev *pdev);
 static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 				unsigned long deadline);
+static int ahci_slave_configure(struct scsi_device *sdev);
+
 #ifdef CONFIG_PM
 static int ahci_pci_device_runtime_suspend(struct device *dev);
 static int ahci_pci_device_runtime_resume(struct device *dev);
@@ -99,6 +102,7 @@ static int ahci_pci_device_resume(struct device *dev);
 
 static struct scsi_host_template ahci_sht = {
 	AHCI_SHT("ahci"),
+	.slave_configure	= ahci_slave_configure,
 };
 
 static struct ata_port_operations ahci_vt8251_ops = {
@@ -1398,6 +1402,27 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 {}
 #endif
 
+static int ahci_slave_configure(struct scsi_device *sdev)
+{
+	/*
+	 * Machines cutting power to the SSD during a warm reboot must send
+	 * a STANDBY_IMMEDIATE before to prevent unclean shutdown of the disk.
+	 */
+	static struct dmi_system_id sysids[] = {
+		{
+			/* x86-samus, the Chromebook Pixel 2. */
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Samus"),
+			},
+		},
+		{ /* sentinel */ }
+	};
+	if (dmi_check_system(sysids))
+		sdev->send_stop_reboot = 1;
+	return ata_scsi_slave_config(sdev);
+}
+
 /*
  * On the Acer Aspire Switch Alpha 12, sometimes all SATA ports are detected
  * as DUMMY, or detected but eventually get a "link down" and never get up
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5abdf03083ae8..248e04cc46a9e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3533,8 +3533,9 @@ static void sd_shutdown(struct device *dev)
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp, NULL);
 	}
-
-	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
+	if ((sdkp->device->send_stop_reboot ||
+	     system_state != SYSTEM_RESTART) &&
+	    sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 202f4d6a43421..eca9e5cf281f2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -199,6 +199,7 @@ struct scsi_device {
 	unsigned broken_fua:1;		/* Don't set FUA bit */
 	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
 	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
+	unsigned send_stop_reboot:1;	/* Send START_STOP_UNIT at reboot */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
-- 
2.25.0.341.g760bfbb309-goog

