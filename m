From: "jack wang" <jack_wang@usish.com>
Subject: RE: [PATCH] drivers/scsi/pm8001: introduce missing kfree
Date: Mon, 2 Aug 2010 09:34:05 +0800
Message-ID: <4B727C2D637F4C98A716EA3AA8060F6D@usish.com.cn>
References: <Pine.LNX.4.64.1008011923120.2222@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:48039 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0HBBaw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Aug 2010 21:30:52 -0400
In-Reply-To: <Pine.LNX.4.64.1008011923120.2222@ask.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Julia Lawall' <julia@diku.dk>, lindar_liu@usish.com, "'James E.J. Bottomley'" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-jan


[Jack]Looks good to me! Thanks!
Acked-by: Jack Wang<jack_wang@usish.com>


From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier f,f1;
position p1,p2;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
<... when != x
     when != if (...) { <+...x...+> }
     when != (x) == NULL
     when != (x) != NULL
     when != (x) == 0
     when != (x) != 0
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return <+...x...+>;
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
Another problem with this code is that there is no error checking for the
calls to kzalloc that are used to initialize fw_control_context.  But the
existing error handling code mostly returns the result of pm8001_tag_alloc,
which uses constants of the enumerated type exec_status, defined in
include/scsi/libsas.h, and it is not clear which of these values should be
used in the case of insufficient memory.  Nevertheless, one of the
functions affected by this patch does return -ENOMEM in case of
insufficient memory.

 drivers/scsi/pm8001/pm8001_hwi.c    |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index 58d1134..9793aa6 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4199,8 +4199,10 @@ static int pm8001_chip_get_nvmd_req(struct
pm8001_hba_info *pm8001_ha,
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	if (rc) {
+		kfree(fw_control_context);
 		return rc;
+	}
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->ccb_tag = tag;
 	ccb->fw_control_context = fw_control_context;
@@ -4276,8 +4278,10 @@ static int pm8001_chip_set_nvmd_req(struct
pm8001_hba_info *pm8001_ha,
 		ioctl_payload->length);
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	if (rc) {
+		kfree(fw_control_context);
 		return rc;
+	}
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->fw_control_context = fw_control_context;
 	ccb->ccb_tag = tag;
@@ -4387,6 +4391,7 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info
*pm8001_ha,
 			fw_control->len, 0) != 0) {
 				PM8001_FAIL_DBG(pm8001_ha,
 					pm8001_printk("Mem alloc
failure\n"));
+				kfree(fw_control_context);
 				return -ENOMEM;
 		}
 	}
@@ -4401,8 +4406,10 @@ pm8001_chip_fw_flash_update_req(struct
pm8001_hba_info *pm8001_ha,
 	fw_control_context->virtAddr = buffer;
 	fw_control_context->len = fw_control->len;
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	if (rc) {
+		kfree(fw_control_context);
 		return rc;
+	}
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->fw_control_context = fw_control_context;
 	ccb->ccb_tag = tag;
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

