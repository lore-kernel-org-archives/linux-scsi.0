From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/1] be2iscsi: Fix for 64K data
Date: Wed, 14 Jul 2010 23:58:06 +0530
Message-ID: <20100714182749.GA25200@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:59447 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756892Ab0GNS2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2010 14:28:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   This patch fixes a wraparound issue when the length=65536 for an sge.
Since it was defined as a short, the length becomes zero

This patch has been made over  scsi-rc-fixes-2.6 tree pulled today

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index dd5b105..38e6d32 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1764,7 +1764,7 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
 	      unsigned int num_sg, struct beiscsi_io_task *io_task)
 {
 	struct iscsi_sge *psgl;
-	unsigned short sg_len, index;
+	unsigned int sg_len, index;
 	unsigned int sge_len = 0;
 	unsigned long long addr;
 	struct scatterlist *l_sg;
-- 
1.6.5.2

