From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 02/10] mpt3sas: Fixed memory leaks in driver
Date: Tue, 10 Oct 2017 18:41:15 +0530
Message-ID: <1507641083-20207-3-git-send-email-Sreekanth.Reddy@broadcom.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Fixed below memory leak in driver,

* While removing Expander devices - we are removing expander
 device entry from the list before freeing it's child devices,
 so while freeing child device we are finding its parent device
 node as NULL and so we are not freeing the child device's
 allocated data structures.
 Updated the driver to remove the expander device from the list
 only after freeing all its child devices.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 9594166..600e8ef 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5274,8 +5274,6 @@ mpt3sas_expander_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
 	    sas_address);
-	if (sas_expander)
-		list_del(&sas_expander->list);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 	if (sas_expander)
 		_scsih_expander_node_remove(ioc, sas_expander);
@@ -7476,7 +7474,6 @@ _scsih_remove_unresponding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 	list_for_each_entry_safe(sas_expander, sas_expander_next, &tmp_list,
 	    list) {
-		list_del(&sas_expander->list);
 		_scsih_expander_node_remove(ioc, sas_expander);
 	}
 
@@ -8102,7 +8099,6 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
  * _scsih_expander_node_remove - removing expander device from list.
  * @ioc: per adapter object
  * @sas_expander: the sas_device object
- * Context: Calling function should acquire ioc->sas_node_lock.
  *
  * Removing object and freeing associated memory from the
  * ioc->sas_expander_list.
@@ -8114,6 +8110,7 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
 	struct _sas_node *sas_expander)
 {
 	struct _sas_port *mpt3sas_port, *next;
+	unsigned long flags;
 
 	/* remove sibling ports attached to this expander */
 	list_for_each_entry_safe(mpt3sas_port, next,
@@ -8141,6 +8138,10 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
 	    sas_expander->handle, (unsigned long long)
 	    sas_expander->sas_address);
 
+	spin_lock_irqsave(&ioc->sas_node_lock, flags);
+	list_del(&sas_expander->list);
+	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+
 	kfree(sas_expander->phy);
 	kfree(sas_expander);
 }
-- 
2.4.3
