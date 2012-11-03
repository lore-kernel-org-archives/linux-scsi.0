From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 7/16] drivers/scsi/gdth.c: use WARN
Date: Sat,  3 Nov 2012 11:58:28 +0100
Message-ID: <1351940317-14812-8-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Achim Leubner <achim_leubner@adaptec.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

If (count) is also merged into WARN, for further conciseness.

A simplified version of the semantic patch that makes part of this
transformation is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/gdth.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d72274..0dbcb27 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2318,11 +2318,10 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                 break;
             buffer += cpnow;
         }
-    } else if (count) {
-        printk("GDT-HA %d: SCSI command with no buffers but data transfer expected!\n",
-               ha->hanum);
-        WARN_ON(1);
     }
+	else
+		WARN(count, "GDT-HA %d: SCSI command with no buffers but data transfer expected!\n",
+			     ha->hanum);
 }
 
 static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
