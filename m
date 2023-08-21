Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F091CEE49AE
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjHUUlM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjHUUke (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 16:40:34 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270931AA
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 13:40:15 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-68a3cae6e1eso1239841b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 13:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692650414; x=1693255214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eSjxJ5z+yzrp/fvY2sPSKwh+ARBvkS0ZxL8OHiMRPwU=;
        b=X3rEwlWpHYo1YAxClHy27HC+K095Y1KWkWHtFQlUUPugrZAOAuuj27EshvUzykxSXm
         EuY1LrEb/L7DJaLDslpnJ3dyOackWYderKnspzJoiCOGWxnJPW3swdFF/DWLYyaW2szf
         zucfiNaBmZOLrSveoxpJzxufFwW750aGEagWuQFhQqeI8AhNA/H5FYN5h8/2V5QKuZnX
         wDWH2Gd4wCeNz4m5dDgi9i6l/ZHB/CPKq1r85+oXhdixzbi488YIogHuVr/WVdxZai9i
         I6KDB50/tZRFYL8xtgQO9mULXeajS0hjM7PgkTkvbMiqT4MBSUJXDHFsqZMTEHcyNJFK
         otuA==
X-Gm-Message-State: AOJu0YySFtg20fXX0pWcCwKmU6kNg2/duX9dMMCok1O3iXJNnoXUBW8C
        9Tt+t/Eaaf+HELWiVqsz64I=
X-Google-Smtp-Source: AGHT+IFF0K/58IdzPzrUdnSH9fd75fCJT7xzpWoXKH7dYIxcavJzt2fWjih4ue1uFMJRF2F4EypZqQ==
X-Received: by 2002:a05:6a00:896:b0:68a:582b:6b6d with SMTP id q22-20020a056a00089600b0068a582b6b6dmr2885674pfj.1.1692650414395;
        Mon, 21 Aug 2023 13:40:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef58:6534:ec7a:8ab2])
        by smtp.gmail.com with ESMTPSA id v24-20020aa78098000000b006888029fd63sm6579787pff.9.2023.08.21.13.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 13:40:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Don Brace <don.brace@microchip.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH] scsi: core: Improve type safety of scsi_rescan_device()
Date:   Mon, 21 Aug 2023 13:40:07 -0700
Message-ID: <20230821204009.3601639-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Most callers of scsi_rescan_device() have the scsi_device pointer
available. Pass a struct scsi_device pointer to scsi_rescan_device()
instead of a struct device pointer. This change prevents that a
pointer to another struct device pointer would be passed accidentally to
scsi_rescan_device().

Remove the scsi_rescan_device() declaration from the scsi_priv.h header
file since it duplicates the declaration in <scsi/scsi_host.h>.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-scsi.c             | 2 +-
 drivers/scsi/aacraid/commsup.c        | 2 +-
 drivers/scsi/mvumi.c                  | 2 +-
 drivers/scsi/scsi_lib.c               | 2 +-
 drivers/scsi/scsi_priv.h              | 1 -
 drivers/scsi/scsi_scan.c              | 4 ++--
 drivers/scsi/scsi_sysfs.c             | 4 ++--
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 drivers/scsi/storvsc_drv.c            | 2 +-
 drivers/scsi/virtio_scsi.c            | 2 +-
 include/scsi/scsi_host.h              | 2 +-
 11 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 370d18aca71e..f5c36c8c243a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4884,7 +4884,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 			}
 
 			spin_unlock_irqrestore(ap->lock, flags);
-			scsi_rescan_device(&(sdev->sdev_gendev));
+			scsi_rescan_device(sdev);
 			scsi_device_put(sdev);
 			spin_lock_irqsave(ap->lock, flags);
 		}
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 3f062e4013ab..013a9a334972 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1451,7 +1451,7 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 #endif
 				break;
 			}
-			scsi_rescan_device(&device->sdev_gendev);
+			scsi_rescan_device(device);
 			break;
 
 		default:
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 73aa7059b556..6cfbac518085 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1500,7 +1500,7 @@ static void mvumi_rescan_devices(struct mvumi_hba *mhba, int id)
 
 	sdev = scsi_device_lookup(mhba->shost, 0, id, 0);
 	if (sdev) {
-		scsi_rescan_device(&sdev->sdev_gendev);
+		scsi_rescan_device(sdev);
 		scsi_device_put(sdev);
 	}
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d84209a96b48..b0169ffaefd2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2445,7 +2445,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 		envp[idx++] = "SDEV_MEDIA_CHANGE=1";
 		break;
 	case SDEV_EVT_INQUIRY_CHANGE_REPORTED:
-		scsi_rescan_device(&sdev->sdev_gendev);
+		scsi_rescan_device(sdev);
 		envp[idx++] = "SDEV_UA=INQUIRY_DATA_HAS_CHANGED";
 		break;
 	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f42388ecb024..65c993c97909 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -138,7 +138,6 @@ extern int scsi_complete_async_scans(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, u64, enum scsi_scan_mode);
 extern void scsi_forget_host(struct Scsi_Host *);
-extern void scsi_rescan_device(struct device *);
 
 /* scsi_sysctl.c */
 #ifdef CONFIG_SYSCTL
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e046dd51d326..712eebceda35 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1622,9 +1622,9 @@ int scsi_add_device(struct Scsi_Host *host, uint channel,
 }
 EXPORT_SYMBOL(scsi_add_device);
 
-void scsi_rescan_device(struct device *dev)
+void scsi_rescan_device(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct device *dev = &sdev->sdev_gendev;
 
 	device_lock(dev);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 60317676e45f..24f6eefb6803 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -747,7 +747,7 @@ static ssize_t
 store_rescan_field (struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
 {
-	scsi_rescan_device(dev);
+	scsi_rescan_device(to_scsi_device(dev));
 	return count;
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
@@ -840,7 +840,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 		 * waiting for pending I/O to finish.
 		 */
 		blk_mq_run_hw_queues(sdev->request_queue, true);
-		scsi_rescan_device(dev);
+		scsi_rescan_device(sdev);
 	}
 
 	return ret == 0 ? count : -EINVAL;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6aaaa7ebca37..ed694d939964 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2257,7 +2257,7 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 			device->advertised_queue_depth = device->queue_depth;
 			scsi_change_queue_depth(device->sdev, device->advertised_queue_depth);
 			if (device->rescan) {
-				scsi_rescan_device(&device->sdev->sdev_gendev);
+				scsi_rescan_device(device->sdev);
 				device->rescan = false;
 			}
 		}
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 659196a2f63a..6bfd88495edb 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -470,7 +470,7 @@ static void storvsc_device_scan(struct work_struct *work)
 	sdev = scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
 	if (!sdev)
 		goto done;
-	scsi_rescan_device(&sdev->sdev_gendev);
+	scsi_rescan_device(sdev);
 	scsi_device_put(sdev);
 
 done:
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index bd5633667d01..9d1bdcdc1331 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -325,7 +325,7 @@ static void virtscsi_handle_param_change(struct virtio_scsi *vscsi,
 	/* Handle "Parameters changed", "Mode parameters changed", and
 	   "Capacity data has changed".  */
 	if (asc == 0x2a && (ascq == 0x00 || ascq == 0x01 || ascq == 0x09))
-		scsi_rescan_device(&sdev->sdev_gendev);
+		scsi_rescan_device(sdev);
 
 	scsi_device_put(sdev);
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 70b7475dcf56..b07db65906dd 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -764,7 +764,7 @@ scsi_template_proc_dir(const struct scsi_host_template *sht);
 #define scsi_template_proc_dir(sht) NULL
 #endif
 extern void scsi_scan_host(struct Scsi_Host *);
-extern void scsi_rescan_device(struct device *);
+extern void scsi_rescan_device(struct scsi_device *);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern int scsi_host_busy(struct Scsi_Host *shost);
