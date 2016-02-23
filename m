From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v3] mptbase: fixup error handling paths in mpt_attach()
Date: Tue, 23 Feb 2016 09:00:12 -0500
Message-ID: <1456236012-27300-1-git-send-email-emilne@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wuninsu@gmail.com, thenzl@redhat.com, sreekanth.reddy@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu
List-Id: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

mpt_attach() was not checking for the failure to create fw_event_q.
Also, iounmap() was not being called in all error cases after ioremap()
had been called by mpt_mapresources().

Reported-by: Insu Yun <wuninsu@gmail.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/message/fusion/mptbase.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5dcc031..d3b130a 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1801,8 +1801,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ioc->pcidev = pdev;
 	if (mpt_mapresources(ioc)) {
-		kfree(ioc);
-		return r;
+		goto out_free_ioc;
 	}
 
 	/*
@@ -1871,9 +1870,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!ioc->reset_work_q) {
 		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
 		    ioc->name);
-		pci_release_selected_regions(pdev, ioc->bars);
-		kfree(ioc);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto out_unmap_resources;
 	}
 
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %p\n",
@@ -1995,16 +1993,27 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ioc->fw_event_lock);
 	snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN, "mpt/%d", ioc->id);
 	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
+	if (!ioc->fw_event_q) {
+		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
+		    ioc->name);
+		r = -ENOMEM;
+		goto out_remove_ioc;
+	}
 
 	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
 	    CAN_SLEEP)) != 0){
 		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
 		    ioc->name, r);
 
+		destroy_workqueue(ioc->fw_event_q);
+		ioc->fw_event_q = NULL;
+
 		list_del(&ioc->list);
 		if (ioc->alt_ioc)
 			ioc->alt_ioc->alt_ioc = NULL;
 		iounmap(ioc->memmap);
+		if (pci_is_enabled(pdev))
+			pci_disable_device(pdev);
 		if (r != -5)
 			pci_release_selected_regions(pdev, ioc->bars);
 
@@ -2012,7 +2021,6 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc->reset_work_q = NULL;
 
 		kfree(ioc);
-		pci_set_drvdata(pdev, NULL);
 		return r;
 	}
 
@@ -2040,6 +2048,24 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 			msecs_to_jiffies(MPT_POLLING_INTERVAL));
 
 	return 0;
+
+out_remove_ioc:
+	list_del(&ioc->list);
+	if (ioc->alt_ioc)
+		ioc->alt_ioc->alt_ioc = NULL;
+
+	destroy_workqueue(ioc->reset_work_q);
+	ioc->reset_work_q = NULL;
+
+out_unmap_resources:
+	iounmap(ioc->memmap);
+	pci_disable_device(pdev);
+	pci_release_selected_regions(pdev, ioc->bars);
+
+out_free_ioc:
+	kfree(ioc);
+
+	return r;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -6229,7 +6255,7 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
 	memcpy(ioc->board_assembly, pbuf->BoardAssembly, sizeof(ioc->board_assembly));
 	memcpy(ioc->board_tracer, pbuf->BoardTracerNumber, sizeof(ioc->board_tracer));
 
-	out:
+out:
 
 	if (pbuf)
 		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
-- 
2.1.0
