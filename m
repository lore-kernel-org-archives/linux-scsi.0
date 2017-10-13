From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] scsi: scsi_transport_fc: make the function argument as const
Date: Fri, 13 Oct 2017 17:00:34 +0200
Message-ID: <1507906834-31150-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This is a followup patch for: https://lkml.org/lkml/2017/10/13/476

Make the function argument of fc_attach_transport as const as it is
only stored in the const field 'f' (made const in the patch in the link)
of a fc_internal structure.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
This change allows some fc_function_template structures to be const.
I will send the patches for structure constification after this gets 
applied.

 drivers/scsi/scsi_transport_fc.c | 2 +-
 include/scsi/scsi_transport_fc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8c46a6d..fb30ede 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2162,7 +2162,7 @@ enum blk_eh_timer_return
 }
 
 struct scsi_transport_template *
-fc_attach_transport(struct fc_function_template *ft)
+fc_attach_transport(const struct fc_function_template *ft)
 {
 	int count;
 	struct fc_internal *i = kzalloc(sizeof(struct fc_internal),
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index e8644ee..60fff05 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -784,7 +784,7 @@ static inline void u64_to_wwn(u64 inm, u8 *wwn)
 }
 
 struct scsi_transport_template *fc_attach_transport(
-			struct fc_function_template *);
+			const struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
 void fc_remove_host(struct Scsi_Host *);
 struct fc_rport *fc_remote_port_add(struct Scsi_Host *shost,
-- 
1.9.1
