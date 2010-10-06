From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: [PATCH 3/3] be2iscsi: SGE Len == 64K
Date: Wed, 6 Oct 2010 23:46:47 +0530
Message-ID: <20101006181647.GA25814@emulex.com>
Reply-To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:45196 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752114Ab0JFSSN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 14:18:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch fixes a overflow problem  when sge-len == 65536.

This was submitted earlier. Looks like it was missed
http://www.spinics.net/lists/linux-scsi/msg44947.html

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com> 
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 8220bde..75a85aa 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2040,7 +2040,7 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
 	      unsigned int num_sg, struct beiscsi_io_task *io_task)
 {
 	struct iscsi_sge *psgl;
-	unsigned short sg_len, index;
+	unsigned int sg_len, index;
 	unsigned int sge_len = 0;
 	unsigned long long addr;
 	struct scatterlist *l_sg;
-- 
1.7.1

