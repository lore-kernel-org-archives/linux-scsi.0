From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 1/4] scsi_debug: allow to specify inquiry vendor and model
Date: Wed,  9 Aug 2017 12:44:01 +0200
Message-ID: <1502275444-27676-2-git-send-email-hare@suse.de>
References: <1502275444-27676-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37843 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751862AbdHIKoP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 06:44:15 -0400
In-Reply-To: <1502275444-27676-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Doug Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

For testing purposes we need to be able to pass in the inquiry
vendor and model.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_debug.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index dc095a2..c8a3f8d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -953,9 +953,9 @@ static int fetch_to_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 }
 
 
-static const char * inq_vendor_id = "Linux   ";
-static const char * inq_product_id = "scsi_debug      ";
-static const char *inq_product_rev = "0186";	/* version less '.' */
+static char sdebug_inq_vendor_id[9] = "Linux   ";
+static char sdebug_inq_product_id[17] = "scsi_debug      ";
+static char sdebug_inq_product_rev[5] = "0186";	/* version less '.' */
 /* Use some locally assigned NAAs for SAS addresses. */
 static const u64 naa3_comp_a = 0x3222222000000000ULL;
 static const u64 naa3_comp_b = 0x3333333000000000ULL;
@@ -975,8 +975,8 @@ static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
 	arr[0] = 0x2;	/* ASCII */
 	arr[1] = 0x1;
 	arr[2] = 0x0;
-	memcpy(&arr[4], inq_vendor_id, 8);
-	memcpy(&arr[12], inq_product_id, 16);
+	memcpy(&arr[4], sdebug_inq_vendor_id, 8);
+	memcpy(&arr[12], sdebug_inq_product_id, 16);
 	memcpy(&arr[28], dev_id_str, dev_id_str_len);
 	num = 8 + 16 + dev_id_str_len;
 	arr[3] = num;
@@ -1408,9 +1408,9 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr[6] = 0x10; /* claim: MultiP */
 	/* arr[6] |= 0x40; ... claim: EncServ (enclosure services) */
 	arr[7] = 0xa; /* claim: LINKED + CMDQUE */
-	memcpy(&arr[8], inq_vendor_id, 8);
-	memcpy(&arr[16], inq_product_id, 16);
-	memcpy(&arr[32], inq_product_rev, 4);
+	memcpy(&arr[8], sdebug_inq_vendor_id, 8);
+	memcpy(&arr[16], sdebug_inq_product_id, 16);
+	memcpy(&arr[32], sdebug_inq_product_rev, 4);
 	/* version descriptors (2 bytes each) follow */
 	put_unaligned_be16(0xc0, arr + 58);   /* SAM-6 no version claimed */
 	put_unaligned_be16(0x5c0, arr + 60);  /* SPC-5 no version claimed */
@@ -4152,6 +4152,12 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 module_param_named(fake_rw, sdebug_fake_rw, int, S_IRUGO | S_IWUSR);
 module_param_named(guard, sdebug_guard, uint, S_IRUGO);
 module_param_named(host_lock, sdebug_host_lock, bool, S_IRUGO | S_IWUSR);
+module_param_string(inq_vendor, sdebug_inq_vendor_id,
+		    sizeof(sdebug_inq_vendor_id), S_IRUGO|S_IWUSR);
+module_param_string(inq_product, sdebug_inq_product_id,
+		    sizeof(sdebug_inq_product_id), S_IRUGO|S_IWUSR);
+module_param_string(inq_rev, sdebug_inq_product_rev,
+		    sizeof(sdebug_inq_product_rev), S_IRUGO|S_IWUSR);
 module_param_named(lbpu, sdebug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, sdebug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, sdebug_lbpws10, int, S_IRUGO);
@@ -4203,6 +4209,9 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
 MODULE_PARM_DESC(host_lock, "host_lock is ignored (def=0)");
+MODULE_PARM_DESC(inq_vendor, "SCSI INQUIRY vendor string (def=\"Linux\")");
+MODULE_PARM_DESC(inq_product, "SCSI INQUIRY product string (def=\"scsi_debug\")");
+MODULE_PARM_DESC(inq_rev, "SCSI INQUIRY revision string (def=\"scsi_debug\")");
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
-- 
1.8.5.6
