Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DEEC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 23:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49F276103B
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 23:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344774AbhIXX2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 19:28:47 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:47035 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344528AbhIXX2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 19:28:46 -0400
Received: by mail-pg1-f181.google.com with SMTP id m21so11272614pgu.13
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2021 16:27:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vocZNIC8OCGC2RcRp9mKbg9JbpPSvjrRrQksJbwOgbI=;
        b=eIb7ZgQjdkciakqyQ6jx44v9M/HE0/DWkj8fbCkrJrsS4BEYPAG4zVObfi3d+4K8nY
         0dSBdHMgG6FbHHj4kXpLDr+zw29FPnyxX94bfcAGvR0RoSHYktm2qp6Q8lgXf88XpH4i
         JhiPiZzG5nM9Cs1KJL6SRpSNmhP9m1tGbIDQClowDXLx1mEL4OeBB7bSFXzDDAn7aUQy
         o+g3Kez5BQgmbyeE+LNtiqhFPxyKCDrFVAA4hqrVqZLREPl3CVCxD8fWJqbee11ssK5F
         UwzSuYK0HVnyGjNM21X5Q9tAoC0MYXNgigpJV4+7m/chkOEn/0hVb3ZiykV86b1+sW5Z
         tJ7Q==
X-Gm-Message-State: AOAM531AbXLj3qwxixplOesAI5PMQue84nS4PmMZqmts7vlqeW4UyqjO
        K22SsPCgH6LjIJ3elxUo2wk=
X-Google-Smtp-Source: ABdhPJyE8pcWcd0th1grSaFwVigPZyDIW2u6M8fom0QhxwTa/u/80/d+oKiS61owTmI08Liw9oginA==
X-Received: by 2002:aa7:9807:0:b0:44b:28b0:747e with SMTP id e7-20020aa79807000000b0044b28b0747emr12205763pfl.42.1632526031926;
        Fri, 24 Sep 2021 16:27:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ee5b:ba55:22d5:49c9])
        by smtp.gmail.com with ESMTPSA id b142sm10200043pfb.17.2021.09.24.16.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:27:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Don Brace <don.brace@microchip.com>,
        Brian King <brking@us.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Hannes Reinecke <hare@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH 2/2] scsi: Register SCSI device sysfs attributes earlier
Date:   Fri, 24 Sep 2021 16:26:35 -0700
Message-Id: <20210924232635.1637763-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210924232635.1637763-1-bvanassche@acm.org>
References: <20210924232635.1637763-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A quote from Documentation/driver-api/driver-model/device.rst:
"Word of warning:  While the kernel allows device_create_file() and
device_remove_file() to be called on a device at any time, userspace has
strict expectations on when attributes get created.  When a new device is
registered in the kernel, a uevent is generated to notify userspace (like
udev) that a new device is available.  If attributes are added after the
device is registered, then userspace won't get notified and userspace will
not know about the new attributes."

Hence register SCSI device sysfs attributes before the SCSI host shost_dev
uevent is emitted instead of after that event has been emitted.

Fixes: 86b87cde0b55 ("scsi: core: host template attribute groups")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/ahci.h                    |  2 +-
 drivers/ata/libahci.c                 | 10 +++----
 drivers/ata/libata-sata.c             |  8 +++---
 drivers/ata/libata-scsi.c             |  4 +--
 drivers/firewire/sbp2.c               |  4 +--
 drivers/s390/scsi/zfcp_ext.h          |  2 +-
 drivers/s390/scsi/zfcp_sysfs.c        | 22 +++++++--------
 drivers/scsi/aacraid/linit.c          |  6 ++---
 drivers/scsi/hpsa.c                   | 14 +++++-----
 drivers/scsi/ipr.c                    | 12 ++++-----
 drivers/scsi/megaraid/megaraid_mbox.c |  4 +--
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c    | 10 +++----
 drivers/scsi/myrb.c                   | 10 +++----
 drivers/scsi/myrs.c                   | 10 +++----
 drivers/scsi/scsi_sysfs.c             | 39 ++++++++++++---------------
 drivers/scsi/smartpqi/smartpqi_init.c | 16 +++++------
 drivers/usb/storage/scsiglue.c        |  4 +--
 include/linux/libata.h                |  4 +--
 include/scsi/scsi_device.h            |  2 ++
 include/scsi/scsi_host.h              |  2 +-
 21 files changed, 92 insertions(+), 95 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index a1f632bb6c8b..150ad2c1a723 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -377,7 +377,7 @@ struct ahci_host_priv {
 extern int ahci_ignore_sss;
 
 extern struct attribute *ahci_shost_attrs[];
-extern struct device_attribute *ahci_sdev_attrs[];
+extern struct attribute *ahci_sdev_attrs[];
 
 /*
  * This must be instantiated by the edge drivers.  Read the comments
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 7df5d11e6bd2..adee64189616 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -122,11 +122,11 @@ struct attribute *ahci_shost_attrs[] = {
 };
 EXPORT_SYMBOL_GPL(ahci_shost_attrs);
 
-struct device_attribute *ahci_sdev_attrs[] = {
-	&dev_attr_sw_activity,
-	&dev_attr_unload_heads,
-	&dev_attr_ncq_prio_supported,
-	&dev_attr_ncq_prio_enable,
+struct attribute *ahci_sdev_attrs[] = {
+	&dev_attr_sw_activity.attr,
+	&dev_attr_unload_heads.attr,
+	&dev_attr_ncq_prio_supported.attr,
+	&dev_attr_ncq_prio_enable.attr,
 	NULL
 };
 EXPORT_SYMBOL_GPL(ahci_sdev_attrs);
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 8f3ff830ab0c..f7f3c66181c6 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -922,10 +922,10 @@ DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
 	    ata_ncq_prio_enable_show, ata_ncq_prio_enable_store);
 EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_enable);
 
-struct device_attribute *ata_ncq_sdev_attrs[] = {
-	&dev_attr_unload_heads,
-	&dev_attr_ncq_prio_enable,
-	&dev_attr_ncq_prio_supported,
+struct attribute *ata_ncq_sdev_attrs[] = {
+	&dev_attr_unload_heads.attr,
+	&dev_attr_ncq_prio_enable.attr,
+	&dev_attr_ncq_prio_supported.attr,
 	NULL
 };
 EXPORT_SYMBOL_GPL(ata_ncq_sdev_attrs);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1fb4611f7eeb..460b8722c3bc 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -234,8 +234,8 @@ static void ata_scsi_set_invalid_parameter(struct ata_device *dev,
 				     field, 0xff, 0);
 }
 
-struct device_attribute *ata_common_sdev_attrs[] = {
-	&dev_attr_unload_heads,
+struct attribute *ata_common_sdev_attrs[] = {
+	&dev_attr_unload_heads.attr,
 	NULL
 };
 EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 4d5054211550..df5566f45c7b 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1578,8 +1578,8 @@ static ssize_t sbp2_sysfs_ieee1394_id_show(struct device *dev,
 
 static DEVICE_ATTR(ieee1394_id, S_IRUGO, sbp2_sysfs_ieee1394_id_show, NULL);
 
-static struct device_attribute *sbp2_scsi_sysfs_attrs[] = {
-	&dev_attr_ieee1394_id,
+static struct attribute *sbp2_scsi_sysfs_attrs[] = {
+	&dev_attr_ieee1394_id.attr,
 	NULL
 };
 
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 9b48673789a3..6be80aba7c12 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -184,7 +184,7 @@ extern const struct attribute_group *zfcp_sysfs_adapter_attr_groups[];
 extern const struct attribute_group *zfcp_unit_attr_groups[];
 extern const struct attribute_group *zfcp_port_attr_groups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
-extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
+extern struct attribute *zfcp_sysfs_sdev_attrs[];
 extern struct attribute *zfcp_sysfs_shost_attrs[];
 bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port);
 
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 72e3acaff457..688fc2d47c8e 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -672,17 +672,17 @@ ZFCP_DEFINE_SCSI_ATTR(zfcp_in_recovery, "%d\n",
 ZFCP_DEFINE_SCSI_ATTR(zfcp_status, "0x%08x\n",
 		      atomic_read(&zfcp_sdev->status));
 
-struct device_attribute *zfcp_sysfs_sdev_attrs[] = {
-	&dev_attr_fcp_lun,
-	&dev_attr_wwpn,
-	&dev_attr_hba_id,
-	&dev_attr_read_latency,
-	&dev_attr_write_latency,
-	&dev_attr_cmd_latency,
-	&dev_attr_zfcp_access_denied,
-	&dev_attr_zfcp_failed,
-	&dev_attr_zfcp_in_recovery,
-	&dev_attr_zfcp_status,
+struct attribute *zfcp_sysfs_sdev_attrs[] = {
+	&dev_attr_fcp_lun.attr,
+	&dev_attr_wwpn.attr,
+	&dev_attr_hba_id.attr,
+	&dev_attr_read_latency.attr,
+	&dev_attr_write_latency.attr,
+	&dev_attr_cmd_latency.attr,
+	&dev_attr_zfcp_access_denied.attr,
+	&dev_attr_zfcp_failed.attr,
+	&dev_attr_zfcp_in_recovery.attr,
+	&dev_attr_zfcp_status.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 7e6b913d3fce..45cf0f16d06d 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -605,9 +605,9 @@ static struct device_attribute aac_unique_id_attr = {
 
 
 
-static struct device_attribute *aac_dev_attrs[] = {
-	&aac_raid_level_attr,
-	&aac_unique_id_attr,
+static struct attribute *aac_dev_attrs[] = {
+	&aac_raid_level_attr.attr,
+	&aac_unique_id_attr.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4668f5aac1e3..edbc019358c5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -936,13 +936,13 @@ static DEVICE_ATTR(ctlr_num, S_IRUGO,
 static DEVICE_ATTR(legacy_board, S_IRUGO,
 	host_show_legacy_board, NULL);
 
-static struct device_attribute *hpsa_sdev_attrs[] = {
-	&dev_attr_raid_level,
-	&dev_attr_lunid,
-	&dev_attr_unique_id,
-	&dev_attr_hp_ssd_smart_path_enabled,
-	&dev_attr_path_info,
-	&dev_attr_sas_address,
+static struct attribute *hpsa_sdev_attrs[] = {
+	&dev_attr_raid_level.attr,
+	&dev_attr_lunid.attr,
+	&dev_attr_unique_id.attr,
+	&dev_attr_hp_ssd_smart_path_enabled.attr,
+	&dev_attr_path_info.attr,
+	&dev_attr_sas_address.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 562887803ecd..923682b72e97 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4732,12 +4732,12 @@ static struct device_attribute ipr_raw_mode_attr = {
 	.store = ipr_store_raw_mode
 };
 
-static struct device_attribute *ipr_dev_attrs[] = {
-	&ipr_adapter_handle_attr,
-	&ipr_resource_path_attr,
-	&ipr_device_id_attr,
-	&ipr_resource_type_attr,
-	&ipr_raw_mode_attr,
+static struct attribute *ipr_dev_attrs[] = {
+	&ipr_adapter_handle_attr.attr,
+	&ipr_resource_path_attr.attr,
+	&ipr_device_id_attr.attr,
+	&ipr_resource_type_attr.attr,
+	&ipr_raw_mode_attr.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 0877608fee90..bb614134a362 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -314,8 +314,8 @@ static struct attribute *megaraid_shost_attrs[] = {
 static DEVICE_ATTR_ADMIN_RO(megaraid_mbox_ld);
 
 // Host template initializer for megaraid mbox sysfs device attributes
-static struct device_attribute *megaraid_sdev_attrs[] = {
-	&dev_attr_megaraid_mbox_ld,
+static struct attribute *megaraid_sdev_attrs[] = {
+	&dev_attr_megaraid_mbox_ld.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 10668d85944e..75d70d2cfd45 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1940,7 +1940,7 @@ mpt3sas_config_update_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
 
 /* ctl shared API */
 extern struct attribute *mpt3sas_host_attrs[];
-extern struct device_attribute *mpt3sas_dev_attrs[];
+extern struct attribute *mpt3sas_dev_attrs[];
 void mpt3sas_ctl_init(ushort hbas_to_enumerate);
 void mpt3sas_ctl_exit(ushort hbas_to_enumerate);
 u8 mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 61b567691387..33fc399bd809 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3976,11 +3976,11 @@ sas_ncq_prio_enable_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(sas_ncq_prio_enable);
 
-struct device_attribute *mpt3sas_dev_attrs[] = {
-	&dev_attr_sas_address,
-	&dev_attr_sas_device_handle,
-	&dev_attr_sas_ncq_prio_supported,
-	&dev_attr_sas_ncq_prio_enable,
+struct attribute *mpt3sas_dev_attrs[] = {
+	&dev_attr_sas_address.attr,
+	&dev_attr_sas_device_handle.attr,
+	&dev_attr_sas_ncq_prio_supported.attr,
+	&dev_attr_sas_ncq_prio_enable.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 1378ff0d1967..61e0d8a74007 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -2182,11 +2182,11 @@ static ssize_t flush_cache_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(flush_cache);
 
-static struct device_attribute *myrb_sdev_attrs[] = {
-	&dev_attr_rebuild,
-	&dev_attr_consistency_check,
-	&dev_attr_raid_state,
-	&dev_attr_raid_level,
+static struct attribute *myrb_sdev_attrs[] = {
+	&dev_attr_rebuild.attr,
+	&dev_attr_consistency_check.attr,
+	&dev_attr_raid_state.attr,
+	&dev_attr_raid_level.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 0b82e67a07bf..4672545d9c55 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1286,11 +1286,11 @@ static ssize_t consistency_check_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(consistency_check);
 
-static struct device_attribute *myrs_sdev_attrs[] = {
-	&dev_attr_consistency_check,
-	&dev_attr_rebuild,
-	&dev_attr_raid_state,
-	&dev_attr_raid_level,
+static struct attribute *myrs_sdev_attrs[] = {
+	&dev_attr_consistency_check.attr,
+	&dev_attr_rebuild.attr,
+	&dev_attr_raid_state.attr,
+	&dev_attr_raid_level.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2591e7ade4b1..dec393235106 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1328,7 +1328,7 @@ static int scsi_target_add(struct scsi_target *starget)
  **/
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
-	int error, i;
+	int error;
 	struct scsi_target *starget = sdev->sdev_target;
 
 	error = scsi_target_add(starget);
@@ -1381,23 +1381,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		}
 	}
 
-	/* add additional host specific attributes */
-	if (sdev->host->hostt->sdev_attrs) {
-		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
-			error = device_create_file(&sdev->sdev_gendev,
-					sdev->host->hostt->sdev_attrs[i]);
-			if (error)
-				return error;
-		}
-	}
-
-	if (sdev->host->hostt->sdev_groups) {
-		error = sysfs_create_groups(&sdev->sdev_gendev.kobj,
-				sdev->host->hostt->sdev_groups);
-		if (error)
-			return error;
-	}
-
 	scsi_autopm_put_device(sdev);
 	return error;
 }
@@ -1437,10 +1420,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		if (res != 0)
 			return;
 
-		if (sdev->host->hostt->sdev_groups)
-			sysfs_remove_groups(&sdev->sdev_gendev.kobj,
-					sdev->host->hostt->sdev_groups);
-
 		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
 			bsg_unregister_queue(sdev->bsg_dev);
 		device_unregister(&sdev->sdev_dev);
@@ -1592,8 +1571,10 @@ static struct device_type scsi_dev_type = {
 
 void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
+	int i, j = 0;
 	unsigned long flags;
 	struct Scsi_Host *shost = sdev->host;
+	struct scsi_host_template *hostt = shost->hostt;
 	struct scsi_target  *starget = sdev->sdev_target;
 
 	device_initialize(&sdev->sdev_gendev);
@@ -1601,6 +1582,20 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	sdev->sdev_gendev.type = &scsi_dev_type;
 	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+	sdev->sdev_gendev.groups = sdev->gendev_attr_groups;
+	if (hostt->sdev_attrs) {
+		sdev->gendev_first_attr_group = (struct attribute_group){
+			.attrs = hostt->sdev_attrs,
+		};
+		sdev->gendev_attr_groups[j++] = &sdev->gendev_first_attr_group;
+	}
+	if (hostt->sdev_groups) {
+		for (i = 0; j + 1 < ARRAY_SIZE(sdev->gendev_attr_groups) &&
+			     hostt->sdev_groups[i]; i++) {
+			sdev->gendev_attr_groups[j++] = hostt->sdev_groups[i];
+		}
+	}
+	WARN_ON_ONCE(j + 1 >= ARRAY_SIZE(sdev->gendev_attr_groups));
 
 	device_initialize(&sdev->sdev_dev);
 	sdev->sdev_dev.parent = get_device(&sdev->sdev_gendev);
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0b3e150c9f86..826efca1cca4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6915,14 +6915,14 @@ static DEVICE_ATTR(ssd_smart_path_enabled, 0444, pqi_ssd_smart_path_enabled_show
 static DEVICE_ATTR(raid_level, 0444, pqi_raid_level_show, NULL);
 static DEVICE_ATTR(raid_bypass_cnt, 0444, pqi_raid_bypass_cnt_show, NULL);
 
-static struct device_attribute *pqi_sdev_attrs[] = {
-	&dev_attr_lunid,
-	&dev_attr_unique_id,
-	&dev_attr_path_info,
-	&dev_attr_sas_address,
-	&dev_attr_ssd_smart_path_enabled,
-	&dev_attr_raid_level,
-	&dev_attr_raid_bypass_cnt,
+static struct attribute *pqi_sdev_attrs[] = {
+	&dev_attr_lunid.attr,
+	&dev_attr_unique_id.attr,
+	&dev_attr_path_info.attr,
+	&dev_attr_sas_address.attr,
+	&dev_attr_ssd_smart_path_enabled.attr,
+	&dev_attr_raid_level.attr,
+	&dev_attr_raid_bypass_cnt.attr,
 	NULL
 };
 
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index e5a971b83e3f..ee214a4e5fb6 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -588,8 +588,8 @@ static ssize_t max_sectors_store(struct device *dev, struct device_attribute *at
 }
 static DEVICE_ATTR_RW(max_sectors);
 
-static struct device_attribute *sysfs_device_attr_list[] = {
-	&dev_attr_max_sectors,
+static struct attribute *sysfs_device_attr_list[] = {
+	&dev_attr_max_sectors.attr,
 	NULL,
 };
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c0c64f03e107..0785726f4da8 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1388,7 +1388,7 @@ extern int ata_link_nr_enabled(struct ata_link *link);
  */
 extern const struct ata_port_operations ata_base_port_ops;
 extern const struct ata_port_operations sata_port_ops;
-extern struct device_attribute *ata_common_sdev_attrs[];
+extern struct attribute *ata_common_sdev_attrs[];
 
 /*
  * All sht initializers (BASE, PIO, BMDMA, NCQ) must be instantiated
@@ -1421,7 +1421,7 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.sdev_attrs		= ata_common_sdev_attrs
 
 #ifdef CONFIG_SATA_HOST
-extern struct device_attribute *ata_ncq_sdev_attrs[];
+extern struct attribute *ata_ncq_sdev_attrs[];
 
 #define ATA_NCQ_SHT(drv_name)					\
 	ATA_SUBBASE_SHT(drv_name),				\
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 09a17f6e93a7..3ef754fef579 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -226,6 +226,8 @@ struct scsi_device {
 
 	struct device		sdev_gendev,
 				sdev_dev;
+	struct attribute_group  gendev_first_attr_group;
+	const struct attribute_group *gendev_attr_groups[6];
 
 	struct execute_work	ew; /* used to get process context on put */
 	struct work_struct	requeue_work;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5afdc094a445..aa1207ab9d2e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -481,7 +481,7 @@ struct scsi_host_template {
 	/*
 	 * Pointer to the SCSI device properties for this host, NULL terminated.
 	 */
-	struct device_attribute **sdev_attrs;
+	struct attribute **sdev_attrs;
 
 	/*
 	 * Pointer to the SCSI device attribute groups for this host,
