From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] mpt3sas: fix an out of bound write
Date: Fri, 19 Jan 2018 16:22:05 +0100
Message-ID: <20180119152205.5461-1-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49138 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755925AbeASPWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 10:22:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, hare@suse.de, Tomas Henzl <thenzl@redhat.com>

cpu_msix_table is allocated to store online cpus, but pci_irq_get_affinity
may return cpu_possible_mask which is then used to access cpu_msix_table.
That causes bad user experience.
Fix limits access to only online cpus, I've also added an additonal test
to protect from an unlikely change in cpu_online_mask.

Fixes: 1d55abc0e98a0bf35f3af80665aac564e3b30572 scsi: mpt3sas: switch to pci_alloc_irq_vectors

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 13d6e4ec3..59a87ca32 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2410,8 +2410,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 				continue;
 			}
 
-			for_each_cpu(cpu, mask)
+			for_each_cpu_and(cpu, mask, cpu_online_mask) {
+				if (cpu >= ioc->cpu_msix_table_sz)
+					break;
 				ioc->cpu_msix_table[cpu] = reply_q->msix_index;
+			}
 		}
 		return;
 	}
-- 
2.14.3
