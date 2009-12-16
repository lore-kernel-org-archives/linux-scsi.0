From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/10] mpt2sas: Delete volume before HBA detach.
Date: Wed, 16 Dec 2009 18:50:06 +0530
Message-ID: <20091216131944.GB31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:54600 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755991AbZLPNsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:48:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org


The driver hangs when doing `rmmod mpt2sas` if there are any
IR volumes present.The hang is due the scsi midlayer trying to access the
IR volumes after the driver releases controller resources.  Perhaps when
scsi_remove_host is called,the scsi mid layer is sending some request.
This doesn't occur for bare drives becuase the driver is already reporting
those drives deleted prior to calling mpt2sas_base_detach.
To solve this issue, we need to delete the volumes as well.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 55ee014..c2b455e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5998,6 +5998,8 @@ _scsih_remove(struct pci_dev *pdev)
 	struct _sas_port *mpt2sas_port;
 	struct _sas_device *sas_device;
 	struct _sas_node *expander_sibling;
+	struct _raid_device *raid_device, *next;
+	struct MPT2SAS_TARGET *sas_target_priv_data;
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 
@@ -6011,6 +6013,21 @@ _scsih_remove(struct pci_dev *pdev)
 	if (wq)
 		destroy_workqueue(wq);
 
+	/* release all the volumes */
+	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
+	    list) {
+		if (raid_device->starget) {
+			sas_target_priv_data =
+			    raid_device->starget->hostdata;
+			sas_target_priv_data->deleted = 1;
+			scsi_remove_target(&raid_device->starget->dev);
+		}
+		printk(MPT2SAS_INFO_FMT "removing handle(0x%04x), wwid"
+		    "(0x%016llx)\n", ioc->name,  raid_device->handle,
+		    (unsigned long long) raid_device->wwid);
+		_scsih_raid_device_remove(ioc, raid_device);
+	}
+
 	/* free ports attached to the sas_host */
  retry_again:
 	list_for_each_entry(mpt2sas_port,
