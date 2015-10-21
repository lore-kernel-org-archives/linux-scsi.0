From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 06/37] cxlflash: Fix to avoid sizeof(bool)
Date: Wed, 21 Oct 2015 15:11:34 -0500
Message-ID: <1445458294-43022-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:39585 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbbJUUM6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:12:58 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:12:58 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 91EA719D8041
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:01:05 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKBpj810289480
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 13:11:51 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKCrvR032701
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:12:55 -0600
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

Using sizeof(bool) is considered poor form for various reasons and
sparse warns us of that. Correct by changing type from bool to u8.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/cxlflash/superpipe.c | 2 +-
 drivers/scsi/cxlflash/superpipe.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index ffa68cc..28aa9d9 100644
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

