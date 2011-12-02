From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] [SCSI] mpt2sas: Fix leak on mpt2sas_base_attach() error
 path
Date: Fri, 2 Dec 2011 09:20:30 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A604726F2D60@inbmail02.lsi.com>
References: <1322702062-26952-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:41758 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756485Ab1LBDui convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 22:50:38 -0500
In-Reply-To: <1322702062-26952-1-git-send-email-roland@kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, James Bottomley <jejb@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch seem to be fine.
Please consider this patch as acked by me.

Regards,
Nagalakshmi


-----Original Message-----
From: Roland Dreier [mailto:roland@purestorage.com] On Behalf Of Roland Dreier
Sent: Thursday, December 01, 2011 6:44 AM
To: James E.J. Bottomley
Cc: Nandigama, Nagalakshmi; linux-scsi@vger.kernel.org
Subject: [PATCH] [SCSI] mpt2sas: Fix leak on mpt2sas_base_attach() error path

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

