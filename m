From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 1/2] fusion/mptfc: Remove deprecated
 create_singlethread_workqueue
Date: Wed, 31 Aug 2016 00:33:05 +0530
Message-ID: <0a490fd1f70f3010595444ca911d6e733f345684.1472583639.git.bhaktipriya96@gmail.com>
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

The workqueue "fc_rescan_work_q" queues multiple work items viz
&ioc->fc_rescan_work, &ioc->fc_lsc_work, &ioc->fc_setup_reset_work,
which require strict execution ordering.
Hence, an ordered dedicated workqueue has been used.

WQ_MEM_RECLAIM has been set since the workqueue is belongs to a storage
driver which is being used on a memory reclaim path and hence, requires
forward progress under memory pressure.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/message/fusion/mptfc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index d8bf84a..129e132 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1324,7 +1324,8 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	snprintf(ioc->fc_rescan_work_q_name, sizeof(ioc->fc_rescan_work_q_name),
 		 "mptfc_wq_%d", sh->host_no);
 	ioc->fc_rescan_work_q =
-		create_singlethread_workqueue(ioc->fc_rescan_work_q_name);
+		alloc_ordered_workqueue(ioc->fc_rescan_work_q_name,
+					WQ_MEM_RECLAIM);
 	if (!ioc->fc_rescan_work_q)
 		goto out_mptfc_probe;

--
2.1.4
