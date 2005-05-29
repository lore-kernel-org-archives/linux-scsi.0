From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] Re: [PATCH 1/4] aic7xxx/aic79xx: call scsi_set_device()
Date: Sun, 29 May 2005 04:52:56 -0400
Message-ID: <429982E8.4000503@pobox.com>
References: <20050529074029.GA25962@havoc.gtf.org> <20050529082422.GA19685@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010400090802050201000606"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:28134 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261287AbVE2IxA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 04:53:00 -0400
In-Reply-To: <20050529082422.GA19685@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010400090802050201000606
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Christoph Hellwig wrote:
> scsi_add_host connects the host to the device tree.  scsi_set_device
> is obsolete and should go away ASAP.

Someone needs to tell authors of newer drivers not to use 
scsi_set_device(), until it can be deleted...

	Jeff



--------------010400090802050201000606
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -388,7 +388,7 @@ Summary:
    scsi_remove_device - detach and remove a SCSI device
    scsi_remove_host - detach and remove all SCSI devices owned by host
    scsi_report_bus_reset - report scsi _bus_ reset observed
-   scsi_set_device - place device reference in host structure
+   scsi_set_device - place device reference in host structure (DEPRECATED)
    scsi_track_queue_full - track successive QUEUE_FULL events 
    scsi_unblock_requests - allow further commands to be queued to given host
    scsi_unregister - [calls scsi_host_put()]
@@ -741,7 +741,7 @@ void scsi_report_bus_reset(struct Scsi_H
 
 
 /**
- * scsi_set_device - place device reference in host structure
+ * scsi_set_device - place device reference in host structure (DEPRECATED)
  * @shost: a pointer to a scsi host instance
  * @pdev: pointer to device instance to assign
  *
@@ -750,6 +750,11 @@ void scsi_report_bus_reset(struct Scsi_H
  *      Might block: no
  *
  *      Defined in: include/scsi/scsi_host.h .
+ *
+ *	Notes:  Do not use this function, it only exists for a few
+ *	ancient drivers.  Add struct device* to scsi_add_host()
+ *	instead.
+ *
  **/
 void scsi_set_device(struct Scsi_Host * shost, struct device * dev)
 
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1157,10 +1157,6 @@ mptscsih_probe(struct pci_dev *pdev, con
 		sh->sg_tablesize = numSGE;
 	}
 
-	/* Set the pci device pointer in Scsi_Host structure.
-	 */
-	scsi_set_device(sh, &ioc->pcidev->dev);
-
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 	hd = (MPT_SCSI_HOST *) sh->hostdata;
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -7034,7 +7034,7 @@ ips_register_scsi(int index)
 	sh->max_channel = ha->nbus - 1;
 	sh->can_queue = ha->max_cmds - 1;
 
-	IPS_ADD_HOST(sh, NULL);
+	IPS_ADD_HOST(sh, &ha->pcidev->dev);
 	return 0;
 }
 
diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
--- a/drivers/scsi/ips.h
+++ b/drivers/scsi/ips.h
@@ -111,7 +111,7 @@
       #define IPS_UNREGISTER_HOSTS(SHT)
       #define IPS_ADD_HOST(shost,device)   do { scsi_add_host(shost,device); scsi_scan_host(shost); } while (0)
       #define IPS_REMOVE_HOST(shost)       scsi_remove_host(shost)
-      #define IPS_SCSI_SET_DEVICE(sh,ha)   scsi_set_device(sh, &(ha)->pcidev->dev)
+      #define IPS_SCSI_SET_DEVICE(sh,ha)
       #define IPS_PRINTK(level, pcidev, format, arg...)                 \
             dev_printk(level , &((pcidev)->dev) , format , ## arg)
    #endif
diff --git a/drivers/scsi/libata-core.c b/drivers/scsi/libata-core.c
--- a/drivers/scsi/libata-core.c
+++ b/drivers/scsi/libata-core.c
@@ -3365,7 +3365,6 @@ static void ata_host_init(struct ata_por
 	host->max_channel = 1;
 	host->unique_id = ata_unique_id++;
 	host->max_cmd_len = 12;
-	scsi_set_device(host, ent->dev);
 	scsi_assign_lock(host, &host_set->lock);
 
 	ap->flags = ATA_FLAG_PORT_DISABLED;
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -814,7 +814,6 @@ megaraid_io_attach(adapter_t *adapter)
 
 	// export the parameters required by the mid-layer
 	scsi_assign_lock(host, adapter->host_lock);
-	scsi_set_device(host, &adapter->pdev->dev);
 
 	host->irq		= adapter->irq;
 	host->unique_id		= adapter->unique_id;
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2720,9 +2720,7 @@ static int nsp32_detect(Scsi_Host_Templa
 	host->unique_id = data->BaseAddress;
 	host->n_io_port	= data->NumAddress;
 	host->base      = (unsigned long)data->MmioAddress;
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,63))
-	scsi_set_device(host, &PCIDEV->dev);
-#else
+#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,63))
 	scsi_set_pci_device(host, PCIDEV);
 #endif
 

--------------010400090802050201000606--
