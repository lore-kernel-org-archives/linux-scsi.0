From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 6/9] mpt2sas: Remove loop inside config request
Date: Fri, 7 Aug 2009 19:37:14 +0530
Message-ID: <20090807140708.GG5807@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:46623 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbZHGO3O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 10:29:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org

This restriction is introduced just to avoid loop of 
config_request. Retry must be limited so we have restricted 
config request to maximum 2 times.
---
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 8dcfa38..55a1b20 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -249,6 +249,12 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	retry_count = 0;
 
  retry_config:
+	if (retry_count) {
+		if (retry_count > 2) /* attempt only 2 retries */
+			return -EFAULT;
+		printk(MPT2SAS_INFO_FMT "%s: attempting retry (%d)\n",
+		    ioc->name, __func__, retry_count);
+	}
 	wait_state_count = 0;
 	ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
