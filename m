From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 06/29] cxlflash: Change rht_needs_ws from bool to u8
Date: Fri, 11 Sep 2015 16:10:17 -0500
Message-ID: <1442005817-46536-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:55888 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbbIKVKg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:10:36 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 17:10:35 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 5017F6E8041
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:02:16 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLAW0163897726
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 21:10:32 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLAUbu027264
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:10:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Fix sparse sizeof(bool) warning by changing type from bool to u8.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 2 +-
 drivers/scsi/cxlflash/superpipe.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 1fa4af6..cf2a85d 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -737,7 +737,7 @@ static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
 	struct afu *afu = cfg->afu;
 	struct ctx_info *ctxi = NULL;
 	struct llun_info **lli = NULL;
-	bool *ws = NULL;
+	u8 *ws = NULL;
 	struct sisl_rht_entry *rhte;
 
 	ctxi = kzalloc(sizeof(*ctxi), GFP_KERNEL);
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index fffb179..72d53cf 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -97,7 +97,7 @@ struct ctx_info {
 	u32 rht_out;		/* Number of checked out RHT entries */
 	u32 rht_perms;		/* User-defined permissions for RHT entries */
 	struct llun_info **rht_lun;       /* Mapping of RHT entries to LUNs */
-	bool *rht_needs_ws;	/* User-desired write-same function per RHTE */
+	u8 *rht_needs_ws;	/* User-desired write-same function per RHTE */
 
 	struct cxl_ioctl_start_work work;
 	u64 ctxid;
-- 
2.1.0

