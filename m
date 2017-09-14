From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: libiscsi: Fix an error handling path in 'iscsi_session_setup()'
Date: Thu, 14 Sep 2017 07:47:40 +0200
Message-ID: <20170914054740.23129-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: lduncan@suse.com, cleech@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

All error handling paths in this function go through
'iscsi_host_dec_session_cnt()' except this one.
Fix it and properly decrement the number of active sessions in such a case.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/libiscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index bd4605a34f54..5d195375ba75 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2779,7 +2779,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 		       "must be a power of 2.\n", total_cmds);
 		total_cmds = rounddown_pow_of_two(total_cmds);
 		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
-			return NULL;
+			goto dec_session_count;
 		printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
 		       total_cmds);
 	}
-- 
2.11.0
