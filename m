From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] mpt2sas: issue reset is not uninitialized
Date: Wed, 3 Dec 2014 13:09:41 +0300
Message-ID: <20141203100941.GB29583@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The issue_reset variables were never set to zero.  This bug was found
with static analysis.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 58e4521..98bd546 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3236,7 +3236,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
 	u16 smid;
 	u32 ioc_state;
 	unsigned long timeleft;
-	u8 issue_reset;
+	bool issue_reset = 0;
 	int rc;
 	void *request;
 	u16 wait_state_count;
@@ -3341,7 +3341,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
 	u16 smid;
 	u32 ioc_state;
 	unsigned long timeleft;
-	u8 issue_reset;
+	bool issue_reset = 0;
 	int rc;
 	void *request;
 	u16 wait_state_count;
