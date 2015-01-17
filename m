From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 1/1] be2iscsi: add block valid bit to iBFT flag
Date: Fri, 16 Jan 2015 18:34:53 -0600
Message-ID: <54B9AE2D.9020205@cs.wisc.edu>
References: <1efcc1ff-0b88-4247-a8c2-5099f9fd0b20@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060900060201090904020900"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44440 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbbAQAfD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2015 19:35:03 -0500
In-Reply-To: <1efcc1ff-0b88-4247-a8c2-5099f9fd0b20@CMEXHTCAS2.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>

This is a multi-part message in MIME format.
--------------060900060201090904020900
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 01/16/2015 01:44 PM, Minh Duc Tran wrote:
>> From: Michael Christie [mailto:michaelc@cs.wisc.edu] 
>> Sent: Friday, January 16, 2015 8:28 AM
>> To: Minh Duc Tran
>> Cc: linux-scsi@vger.kernel.org; Jayamohan Kallickal
>> Subject: Re: [PATCH 1/1] be2iscsi: add block valid bit to iBFT flag
> 
>> I think we are misunderstanding each other on my comments. You need to modify your patch so it fixes the problem in a general way for all drivers.
> 
> 
> Ok got it!  This is the new patch with changes for both be2iscsi and qla4xxx.
> 

Could you try the attached patch. It is not even compile tested. It will
allow ibft and non ibft drivers to export info in the same way. When
drivers and userspace supports some of the other things like radius
chap, we can add defines for those too.


--------------060900060201090904020900
Content-Type: text/x-patch;
 name="iscsi-boot-match-ibft-flags.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iscsi-boot-match-ibft-flags.patch"

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f319340..cd4aff9 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -429,7 +429,8 @@ static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
 			     auth_data.chap.intr_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
-		rc = sprintf(str, "2\n");
+		rc = sprintf(str, "%u\n",
+			     ISCSI_BOOT_FLAG_VALID | ISCSI_BOOT_FLAG_FW_BOOT_SEL);
 		break;
 	case ISCSI_BOOT_TGT_NIC_ASSOC:
 		rc = sprintf(str, "0\n");
@@ -466,8 +467,9 @@ static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char *buf)
 
 	switch (type) {
 	case ISCSI_BOOT_ETH_FLAGS:
-		rc = sprintf(str, "2\n");
-		break;
+		rc = sprintf(str, "%u\n",
+			     ISCSI_BOOT_FLAG_VALID | ISCSI_BOOT_FLAG_FW_BOOT_SEL);
+  		break;
 	case ISCSI_BOOT_ETH_INDEX:
 		rc = sprintf(str, "0\n");
 		break;
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 8f6d0fb..0380669 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -796,7 +796,6 @@ struct scsi_qla_host {
 #define CHAP_DMA_BLOCK_SIZE    512
 	struct workqueue_struct *task_wq;
 	unsigned long ddb_idx_map[MAX_DDB_ENTRIES / BITS_PER_LONG];
-#define SYSFS_FLAG_FW_SEL_BOOT 2
 	struct iscsi_boot_kset *boot_kset;
 	struct ql4_boot_tgt_info boot_tgt;
 	uint16_t phy_port_num;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6d25879..b63985f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5705,7 +5705,8 @@ static ssize_t qla4xxx_show_boot_eth_info(void *data, int type, char *buf)
 
 	switch (type) {
 	case ISCSI_BOOT_ETH_FLAGS:
-		rc = sprintf(str, "%d\n", SYSFS_FLAG_FW_SEL_BOOT);
+		rc = sprintf(str, "%d\n",
+			     ISCSI_BOOT_FLAG_VALID | ISCSI_BOOT_FLAG_FW_BOOT_SEL);
 		break;
 	case ISCSI_BOOT_ETH_INDEX:
 		rc = sprintf(str, "0\n");
@@ -5814,7 +5815,8 @@ qla4xxx_show_boot_tgt_info(struct ql4_boot_session_info *boot_sess, int type,
 			     (char *)&boot_conn->chap.intr_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
-		rc = sprintf(str, "%d\n", SYSFS_FLAG_FW_SEL_BOOT);
+		rc = sprintf(str, "%d\n",
+			     ISCSI_BOOT_FLAG_VALID | ISCSI_BOOT_FLAG_FW_BOOT_SEL);
 		break;
 	case ISCSI_BOOT_TGT_NIC_ASSOC:
 		rc = sprintf(str, "0\n");
diff --git a/include/linux/iscsi_boot_sysfs.h b/include/linux/iscsi_boot_sysfs.h
index 2a8b165..e120c2a 100644
--- a/include/linux/iscsi_boot_sysfs.h
+++ b/include/linux/iscsi_boot_sysfs.h
@@ -16,6 +16,9 @@
 #ifndef _ISCSI_BOOT_SYSFS_
 #define _ISCSI_BOOT_SYSFS_
 
+#define ISCSI_BOOT_FLAG_VALID			0x1
+#define ISCSI_BOOT_FLAG_FW_BOOT_SELECTED	0x2
+
 /*
  * The text attributes names for each of the kobjects.
 */

--------------060900060201090904020900--
