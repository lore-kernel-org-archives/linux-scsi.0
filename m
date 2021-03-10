Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0632C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 00:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A353364FC5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 00:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhCKAAE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:00:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhCJX7x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Mar 2021 18:59:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB9C764F8B;
        Wed, 10 Mar 2021 23:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615420793;
        bh=DtyWon8YLRRlkYslhTTrdUCKlpz16BXEUxu8TcoudZ8=;
        h=Date:From:To:Cc:Subject:From;
        b=jQXHNOYwR1jI9T9PVbwQC2eSsLfE+GAZK4OCebnlBPhGDCPBVgNE3dehQug76lgwG
         03NL2l4RYBSsu/jgrfbLJJuFqIVq4ts+gqI/kWdC4H5axIbYJX+j+JCI+srL4Pax0B
         MdQlUdkOkLhCqMAZDmNHILDM6fJMD1Edad3LdQ+P/G4feUt+MgSepgFReomsH/8vZz
         UgU0gT79MtA/IBoX54M+GA/Fe/DnG8P47zjh7awlRohAKEm0WAstmPAwM9Qf7L5nbi
         xRh4R0599EZwgTagRsf4FlEL+0RhI/h572n+HBqrZ4opFjS2dAVpDoqYxiUxQ48YmZ
         DGrx4GymN1WWw==
Date:   Wed, 10 Mar 2021 17:59:51 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: mpt3sas: Replace unnecessary dynamic allocation
 with a static one
Message-ID: <20210310235951.GA108661@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dynamic memory allocation isn't actually needed and it can be
replaced by statically allocating memory for struct object
io_unit_pg3 with 36 hardcoded entries for its GPIOVal array.

Also, this helps the with ongoing efforts to enable -Warray-bounds
by fixing the following warning:

drivers/scsi/mpt3sas/mpt3sas_ctl.c: In function ‘BRM_status_show’:
drivers/scsi/mpt3sas/mpt3sas_ctl.c:3257:63: warning: array subscript 24 is above array bounds of ‘U16[1]’ {aka ‘short unsigned int[1]’} [-Warray-bounds]
 3257 |  backup_rail_monitor_status = le16_to_cpu(io_unit_pg3->GPIOVal[24]);
./include/uapi/linux/byteorder/little_endian.h:36:51: note: in definition of macro ‘__le16_to_cpu’
   36 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
      |                                                   ^
drivers/scsi/mpt3sas/mpt3sas_ctl.c:3257:31: note: in expansion of macro ‘le16_to_cpu’
 3257 |  backup_rail_monitor_status = le16_to_cpu(io_unit_pg3->GPIOVal[24]);

Link: https://github.com/KSPP/linux/issues/109
Link: https://lore.kernel.org/lkml/202103101058.16ED27BE3@keescook/
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 24 ++++++++----------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 43a3bf8ff428..d00431f553e1 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -992,7 +992,7 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1 {
  *one and check the value returned for GPIOCount at runtime.
  */
 #ifndef MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX
-#define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (1)
+#define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (36)
 #endif
 
 typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_3 {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 44f9a05db94e..bc56e058a523 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3203,7 +3203,7 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
-	Mpi2IOUnitPage3_t *io_unit_pg3 = NULL;
+	Mpi2IOUnitPage3_t io_unit_pg3;
 	Mpi2ConfigReply_t mpi_reply;
 	u16 backup_rail_monitor_status = 0;
 	u16 ioc_status;
@@ -3220,17 +3220,10 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	if (ioc->pci_error_recovery || ioc->remove_host)
 		goto out;
 
-	/* allocate upto GPIOVal 36 entries */
-	sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
-	io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
-	if (!io_unit_pg3) {
-		rc = -ENOMEM;
-		ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
-			__func__, sz);
-		goto out;
-	}
+	sz = sizeof(io_unit_pg3);
+	memset(&io_unit_pg3, 0, sz);
 
-	if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz) !=
+	if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, &io_unit_pg3, sz) !=
 	    0) {
 		ioc_err(ioc, "%s: failed reading iounit_pg3\n",
 			__func__);
@@ -3246,19 +3239,18 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 		goto out;
 	}
 
-	if (io_unit_pg3->GPIOCount < 25) {
-		ioc_err(ioc, "%s: iounit_pg3->GPIOCount less than 25 entries, detected (%d) entries\n",
-			__func__, io_unit_pg3->GPIOCount);
+	if (io_unit_pg3.GPIOCount < 25) {
+		ioc_err(ioc, "%s: iounit_pg3.GPIOCount less than 25 entries, detected (%d) entries\n",
+			__func__, io_unit_pg3.GPIOCount);
 		rc = -EINVAL;
 		goto out;
 	}
 
 	/* BRM status is in bit zero of GPIOVal[24] */
-	backup_rail_monitor_status = le16_to_cpu(io_unit_pg3->GPIOVal[24]);
+	backup_rail_monitor_status = le16_to_cpu(io_unit_pg3.GPIOVal[24]);
 	rc = snprintf(buf, PAGE_SIZE, "%d\n", (backup_rail_monitor_status & 1));
 
  out:
-	kfree(io_unit_pg3);
 	mutex_unlock(&ioc->pci_access_mutex);
 	return rc;
 }
-- 
2.27.0

