From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH] xen/scsiback: add error handling for xenbus_printf
Date: Tue, 12 Jun 2018 11:46:25 +0800
Message-ID: <1528775185-39467-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When xenbus_printf fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling xenbus_printf.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
 drivers/xen/xen-scsiback.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 7bc88fd..13ab54c 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1027,8 +1027,9 @@ static void scsiback_do_add_lun(struct vscsibk_info *info, const char *state,
 			scsiback_del_translation_entry(info, vir);
 		}
 	} else if (!try) {
-		xenbus_printf(XBT_NIL, info->dev->nodename, state,
-			      "%d", XenbusStateClosed);
+		if (xenbus_printf(XBT_NIL, info->dev->nodename, state,
+			      "%d", XenbusStateClosed))
+			pr_err("xenbus_printf error %s\n", state);
 	}
 }
 
@@ -1067,8 +1068,9 @@ static void scsiback_do_1lun_hotplug(struct vscsibk_info *info, int op,
 	snprintf(str, sizeof(str), "vscsi-devs/%s/p-dev", ent);
 	val = xenbus_read(XBT_NIL, dev->nodename, str, NULL);
 	if (IS_ERR(val)) {
-		xenbus_printf(XBT_NIL, dev->nodename, state,
-			      "%d", XenbusStateClosed);
+		if (xenbus_printf(XBT_NIL, dev->nodename, state,
+			      "%d", XenbusStateClosed))
+			pr_err("xenbus_printf error %s\n", state);
 		return;
 	}
 	strlcpy(phy, val, VSCSI_NAMELEN);
@@ -1079,8 +1081,9 @@ static void scsiback_do_1lun_hotplug(struct vscsibk_info *info, int op,
 	err = xenbus_scanf(XBT_NIL, dev->nodename, str, "%u:%u:%u:%u",
 			   &vir.hst, &vir.chn, &vir.tgt, &vir.lun);
 	if (XENBUS_EXIST_ERR(err)) {
-		xenbus_printf(XBT_NIL, dev->nodename, state,
-			      "%d", XenbusStateClosed);
+		if (xenbus_printf(XBT_NIL, dev->nodename, state,
+			      "%d", XenbusStateClosed))
+			pr_err("xenbus_printf error %s\n", state);
 		return;
 	}
 
-- 
2.7.4
