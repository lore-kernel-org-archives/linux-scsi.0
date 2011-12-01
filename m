From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] [SCSI] mpt2sas: Fix leak on mpt2sas_base_attach() error path
Date: Wed, 30 Nov 2011 17:14:22 -0800
Message-ID: <1322702062-26952-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:53990 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752283Ab1LABO3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2011 20:14:29 -0500
Received: by mail-gx0-f179.google.com with SMTP id v5so1073708ggn.10
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2011 17:14:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>, linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Commit 911ae9434f83 ("[SCSI] mpt2sas: Added NUNA IO support in driver
which uses multi-reply queue support of the HBA") added new
allocations to the beginning of mpt2sas_base_attach(), which means
directly returning an error on failure of mpt2sas_base_map_resources()
will leak those allocations.

Fix this by doing "goto out_free_resources" in this place too, as the
rest of the function does.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index beda04a..a7b2a16 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4206,7 +4206,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 
 	r = mpt2sas_base_map_resources(ioc);
 	if (r)
-		return r;
+		goto out_free_resources;
 
 	if (ioc->is_warpdrive) {
 		ioc->reply_post_host_index[0] =
-- 
1.7.5.4

