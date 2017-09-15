From: Dave Carroll <david.carroll@microsemi.com>
Subject: [PATCH RESEND] aacraid: Fix 2T+ drives on SmartIOC-2000
Date: Fri, 15 Sep 2017 11:04:28 -0600
Message-ID: <20170915170428.15237-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0077.outbound.protection.outlook.com ([104.47.41.77]:61015
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751401AbdIORFD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 13:05:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Dave Carroll <david.carroll@microsemi.com>, linux-scsi <linux-scsi@vger.kernel.org>, aacraid@microsemi.com, Scott Benesh <scott.benesh@microsemi.com>, Brian King <brking@linux.vnet.ibm.com>, stable@vger.kernel.org

The logic for supporting large drives was previously tied to 4Kn support
for SmartIOC-2000. As SmartIOC-2000 does not support volumes using 4Kn
drives, use the intended option flag AAC_OPT_NEW_COMM_64 to determine 
support for volumes greater than 2T.

cc: stable@vger.kernel.org
Signed-off-by: Dave Carroll <david.carroll@microsemi.com>

---
 drivers/scsi/aacraid/aachba.c  | 12 ++++++------
 drivers/scsi/aacraid/aacraid.h |  5 +++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 4591113..18a1a1f 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -695,13 +695,13 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 	int status;
 
 	dresp = (struct aac_mount *) fib_data(fibptr);
-	if (!(fibptr->dev->supplement_adapter_info.supported_options2 &
-	    AAC_OPTION_VARIABLE_BLOCK_SIZE))
+	if (!aac_supports_2T(fibptr->dev)) {
 		dresp->mnt[0].capacityhigh = 0;
-	if ((le32_to_cpu(dresp->status) != ST_OK) ||
-	    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE)) {
-		_aac_probe_container2(context, fibptr);
-		return;
+		if ((le32_to_cpu(dresp->status) == ST_OK) &&
+			(le32_to_cpu(dresp->mnt[0].vol) != CT_NONE)) {
+			_aac_probe_container2(context, fibptr);
+			return;
+		}
 	}
 	scsicmd = (struct scsi_cmnd *) context;
 
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 6981299..998fbad 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2701,6 +2701,11 @@ static inline int aac_is_src(struct aac_dev *dev)
 	return 0;
 }
 
+static inline int aac_supports_2T(struct aac_dev *dev)
+{
+	return (dev->adapter_info.options & AAC_OPT_NEW_COMM_64);
+}
+
 char * get_container_type(unsigned type);
 extern int numacb;
 extern char aac_driver_version[];
-- 
2.8.4
