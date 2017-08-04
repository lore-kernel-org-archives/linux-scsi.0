From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH] aacraid: Fix out of bounds in aac_get_name_resp
Date: Fri, 4 Aug 2017 03:51:41 -0700
Message-ID: <150184390108.30112.458253019139897272.stgit@rslab209.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0082.outbound.protection.outlook.com ([104.47.41.82]:56580
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751877AbdHDAe6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Aug 2017 20:34:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: Bart.VanAssche@wdc.com, David Carroll <david.carroll@microsemi.com>, gana.sridaran@microsemi.com, dan.carpenter@oracle.com

We terminate the aac_get_name_resp on a byte that is outside the bounds of
the structure. Extend the return response by one byte to remove the
appearance of out of bounds reference.

Thank you Dan for reporting the issue.
Thank you Bart Van Assche <Bart.VanAssche@wdc.com> for suggesting the
FIELD_SIZEOF macro.

Fixes: b836439faf04 ("aacraid: 4KB sector support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Carroll <david.carroll@microsemi.com>
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  |    9 +++++++--
 drivers/scsi/aacraid/aacraid.h |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 707ee2f5954d..a875175d58d1 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -549,7 +549,9 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 	if ((le32_to_cpu(get_name_reply->status) == CT_OK)
 	 && (get_name_reply->data[0] != '\0')) {
 		char *sp = get_name_reply->data;
-		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)] = '\0';
+		int data_size = FIELD_SIZEOF(struct aac_get_name_resp, data);
+
+		sp[data_size - 1] = '\0';
 		while (*sp == ' ')
 			++sp;
 		if (*sp) {
@@ -579,12 +581,15 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 static int aac_get_container_name(struct scsi_cmnd * scsicmd)
 {
 	int status;
+	int data_size;
 	struct aac_get_name *dinfo;
 	struct fib * cmd_fibcontext;
 	struct aac_dev * dev;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 
+	data_size = FIELD_SIZEOF(struct aac_get_name_resp, data);
+
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
 
 	aac_fib_init(cmd_fibcontext);
@@ -593,7 +598,7 @@ static int aac_get_container_name(struct scsi_cmnd * scsicmd)
 	dinfo->command = cpu_to_le32(VM_ContainerConfig);
 	dinfo->type = cpu_to_le32(CT_READ_NAME);
 	dinfo->cid = cpu_to_le32(scmd_id(scsicmd));
-	dinfo->count = cpu_to_le32(sizeof(((struct aac_get_name_resp *)NULL)->data));
+	dinfo->count = cpu_to_le32(data_size - 1);
 
 	status = aac_fib_send(ContainerCommand,
 		  cmd_fibcontext,
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 69812994b81e..92fabf2b0c24 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2275,7 +2275,7 @@ struct aac_get_name_resp {
 	__le32		parm3;
 	__le32		parm4;
 	__le32		parm5;
-	u8		data[16];
+	u8		data[17];
 };
 
 #define CT_CID_TO_32BITS_UID 165
