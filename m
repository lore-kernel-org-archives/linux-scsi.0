From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] [SCSI] aic7xxx: use kmemdup
Date: Thu, 19 May 2016 19:38:32 +0530
Message-ID: <1463666915-16906-2-git-send-email-falakreyaz@gmail.com>
References: <1463666915-16906-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463666915-16906-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use kmemdup when some other buffer is immediately copied into allocated
region. It replaces call to allocation followed by memcpy, by a single
call to kmemdup.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 64ab9ea..2672c39 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6940,10 +6940,10 @@ ahc_loadseq(struct ahc_softc *ahc)
 	if (cs_count != 0) {
 
 		cs_count *= sizeof(struct cs);
-		ahc->critical_sections = kmalloc(cs_count, GFP_ATOMIC);
+		ahc->critical_sections = kmemdup(cs_table, cs_count,
+						 GFP_ATOMIC);
 		if (ahc->critical_sections == NULL)
 			panic("ahc_loadseq: Could not malloc");
-		memcpy(ahc->critical_sections, cs_table, cs_count);
 	}
 	ahc_outb(ahc, SEQCTL, PERRORDIS|FAILDIS|FASTMODE);
 
-- 
1.9.1
