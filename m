From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH v2] xen/scsiback: add error handling for xenbus_printf
Date: Sat, 16 Jun 2018 01:06:12 +0800
Message-ID: <1529082372-59097-1-git-send-email-jiazhouyang09@gmail.com>
References: <1528775185-39467-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528775185-39467-1-git-send-email-jiazhouyang09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When xenbus_printf fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling xenbus_printf.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
v1->v2:
- Use xenbus_dev_error to report errors.
---
 drivers/xen/xen-scsiback.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 7bc88fd..cec2133 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1027,8 +1027,10 @@ static void scsiback_do_add_lun(struct vscsibk_info *info, const char *state,
 			scsiback_del_translation_entry(info, vir);
 		}
 	} else if (!try) {
-		xenbus_printf(XBT_NIL, info->dev->nodename, state,
-			      "%d", XenbusStateClosed);
+		if (xenbus_printf(XBT_NIL, info->dev->nodename, state,
+			      "%d", XenbusStateClosed))
+			xenbus_dev_error(info->dev, err,
+				"%s: writing %s", __func__, state);
 	}
 }
 
@@ -1067,8 +1069,10 @@ static void scsiback_do_1lun_hotplug(struct vscsibk_info *info, int op,
 	snprintf(str, sizeof(str), "vscsi-devs/%s/p-dev", ent);
 	val = xenbus_read(XBT_NIL, dev->nodename, str, NULL);
 	if (IS_ERR(val)) {
-		xenbus_printf(XBT_NIL, dev->nodename, state,
-			      "%d", XenbusStateClosed);
+		if (xenbus_printf(XBT_NIL, dev->nodename, state,
+			      "%d", XenbusStateClosed))
+			xenbus_dev_error(info->dev, err,
+				"%s: writing %s", __func__, state);
 		return;
 	}
 	strlcpy(phy, val, VSCSI_NAMELEN);
@@ -1079,8 +1083,10 @@ static void scsiback_do_1lun_hotplug(struct vscsibk_info *info, int op,
 	err = xenbus_scanf(XBT_NIL, dev->nodename, str, "%u:%u:%u:%u",
 			   &vir.hst, &vir.chn, &vir.tgt, &vir.lun);
 	if (XENBUS_EXIST_ERR(err)) {
-		xenbus_printf(XBT_NIL, dev->nodename, state,
-			      "%d", XenbusStateClosed);
+		if (xenbus_printf(XBT_NIL, dev->nodename, state,
+			      "%d", XenbusStateClosed))
+			xenbus_dev_error(info->dev, err,
+				"%s: writing %s", __func__, state);
 		return;
 	}
 
-- 
2.7.4
