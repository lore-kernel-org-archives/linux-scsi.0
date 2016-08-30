From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 2/2] fusion: mptbase: Remove deprecated
 create_singlethread_workqueue
Date: Wed, 31 Aug 2016 00:33:25 +0530
Message-ID: <05a0e321c521d102e5a908bb4173e684e8a16c9a.1472583639.git.bhaktipriya96@gmail.com>
References: <cover.1472583639.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1472583639.git.bhaktipriya96@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

The workqueues "ioc->reset_work_q" and "ioc->fw_event_q" queue a single
work item &ioc->fault_reset_work and &fw_event->work, respectively and
hence don't require ordering. Hence, they have been converted to use
alloc_workqueue().

The WQ_MEM_RECLAIM flag has been set to ensure forward progress under
memory pressure since the workqueue belongs to a storage driver which is
being used on a memory reclaim path.

Since there are fixed number of work items, explicit concurrency
limit is unnecessary here.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/message/fusion/mptbase.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5537f8d..89c7ed1 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1865,8 +1865,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)

 	snprintf(ioc->reset_work_q_name, MPT_KOBJ_NAME_LEN,
 		 "mpt_poll_%d", ioc->id);
-	ioc->reset_work_q =
-		create_singlethread_workqueue(ioc->reset_work_q_name);
+	ioc->reset_work_q = alloc_workqueue(ioc->reset_work_q_name,
+					    WQ_MEM_RECLAIM, 0);
 	if (!ioc->reset_work_q) {
 		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
 		    ioc->name);
@@ -1992,7 +1992,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->fw_event_list);
 	spin_lock_init(&ioc->fw_event_lock);
 	snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN, "mpt/%d", ioc->id);
-	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
+	ioc->fw_event_q = alloc_workqueue(ioc->fw_event_q_name,
+					  WQ_MEM_RECLAIM, 0);
 	if (!ioc->fw_event_q) {
 		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
 		    ioc->name);
--
2.1.4
