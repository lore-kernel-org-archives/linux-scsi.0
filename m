From: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>
Subject: [PATCH v2 1/1] be2iscsi: add block valid bit to iBFT flag
Date: Fri, 16 Jan 2015 19:44:08 +0000
Message-ID: <1efcc1ff-0b88-4247-a8c2-5099f9fd0b20@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:17426 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbbAPToq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jan 2015 14:44:46 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>

>From: Michael Christie [mailto:michaelc@cs.wisc.edu] 
>Sent: Friday, January 16, 2015 8:28 AM
>To: Minh Duc Tran
>Cc: linux-scsi@vger.kernel.org; Jayamohan Kallickal
>Subject: Re: [PATCH 1/1] be2iscsi: add block valid bit to iBFT flag

>I think we are misunderstanding each other on my comments. You need to modify your patch so it fixes the problem in a general way for all drivers.


Ok got it!  This is the new patch with changes for both be2iscsi and qla4xxx.


------
Signed-off-by: Minh Tran <minh.tran@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c | 4 ++--
 drivers/scsi/qla4xxx/ql4_def.h  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f319340..650b537 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -429,7 +429,7 @@ static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
                             auth_data.chap.intr_secret);
                break;
        case ISCSI_BOOT_TGT_FLAGS:
-               rc = sprintf(str, "2\n");
+               rc = sprintf(str, "3\n");
                break;
        case ISCSI_BOOT_TGT_NIC_ASSOC:
                rc = sprintf(str, "0\n");
@@ -466,7 +466,7 @@ static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char *buf)

        switch (type) {
        case ISCSI_BOOT_ETH_FLAGS:
-               rc = sprintf(str, "2\n");
+               rc = sprintf(str, "3\n");
                break;
        case ISCSI_BOOT_ETH_INDEX:
                rc = sprintf(str, "0\n");
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 8f6d0fb..ab17a2f 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -796,7 +796,7 @@ struct scsi_qla_host {
 #define CHAP_DMA_BLOCK_SIZE    512
        struct workqueue_struct *task_wq;
        unsigned long ddb_idx_map[MAX_DDB_ENTRIES / BITS_PER_LONG];
-#define SYSFS_FLAG_FW_SEL_BOOT 2
+#define SYSFS_FLAG_FW_SEL_BOOT 3
        struct iscsi_boot_kset *boot_kset;
        struct ql4_boot_tgt_info boot_tgt;
        uint16_t phy_port_num;
--
1.8.3.1
