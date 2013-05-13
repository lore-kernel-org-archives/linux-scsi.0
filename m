From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 09/17] bfa: driver compatibility with 32bit libs
Date: Mon, 13 May 2013 02:33:27 -0700
Message-ID: <1368437615-9867-10-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50332 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024Ab3EMJvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:51:05 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

Replaced usage of void * with u64 in data structure shared between
brocade user space libraries and the bfa driver to address pointer
size changes across 32-bit vs 64-bit to have the compatibility between
32bit library and 64bit driver and vice versa.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfad_bsg.c | 7 ++++---
 drivers/scsi/bfa/bfad_bsg.h | 4 +++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index f31acfa..9863b1c 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3371,7 +3371,8 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 		goto out;
 	}
 
-	if (copy_from_user((uint8_t *)bsg_fcpt, bsg_data->payload,
+	if (copy_from_user((uint8_t *)bsg_fcpt,
+				(void *)(unsigned long)bsg_data->payload,
 				bsg_data->payload_len)) {
 		kfree(bsg_fcpt);
 		rc = -EIO;
@@ -3525,8 +3526,8 @@ out_free_mem:
 	kfree(rsp_kbuf);
 
 	/* Need a copy to user op */
-	if (copy_to_user(bsg_data->payload, (void *) bsg_fcpt,
-			 bsg_data->payload_len))
+	if (copy_to_user((void *)(unsigned long)bsg_data->payload,
+			(void *)bsg_fcpt, bsg_data->payload_len))
 		rc = -EIO;
 
 	kfree(bsg_fcpt);
diff --git a/drivers/scsi/bfa/bfad_bsg.h b/drivers/scsi/bfa/bfad_bsg.h
index 3ef321c..b0b5ac7 100644
--- a/drivers/scsi/bfa/bfad_bsg.h
+++ b/drivers/scsi/bfa/bfad_bsg.h
@@ -819,10 +819,12 @@ struct bfa_bsg_fcpt_s {
 };
 #define bfa_bsg_fcpt_t struct bfa_bsg_fcpt_s
 
+#pragma pack(1)
 struct bfa_bsg_data {
 	int payload_len;
-	void *payload;
+	u64 payload;
 };
+#pragma pack()
 
 #define bfad_chk_iocmd_sz(__payload_len, __hdrsz, __bufsz)	\
 	(((__payload_len) != ((__hdrsz) + (__bufsz))) ?		\
-- 
1.7.12

