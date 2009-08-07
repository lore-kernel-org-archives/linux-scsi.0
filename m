From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 5/9] mpt2sas: Excessive log info causes sas iounit page time out
Date: Fri, 7 Aug 2009 19:36:43 +0530
Message-ID: <20090807140636.GF5807@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:34931 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbZHGO2n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 10:28:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org


Inhibit 0x3117 loginfos - during cable pull, there are too many printks going 
to the syslog, this is have impact on how fast the interrupt routine can handle
keeping up with command completions; this was the root cause to the config 
pages timeouts.
---
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index f3da592..ed9965e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -440,6 +440,10 @@ _base_sas_log_info(struct MPT2SAS_ADAPTER *ioc , u32 log_info)
 	if (sas_loginfo.dw.bus_type != 3 /*SAS*/)
 		return;
 
+	/* each nexus loss loginfo */
+	if (log_info == 0x31170000)
+		return;
+
 	/* eat the loginfos associated with task aborts */
 	if (ioc->ignore_loginfos && (log_info == 30050000 || log_info ==
 	    0x31140000 || log_info == 0x31130000))
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 22a9542..25c8d82 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2767,6 +2767,10 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	char *desc_ioc_state = NULL;
 	char *desc_scsi_status = NULL;
 	char *desc_scsi_state = ioc->tmp_string;
+	u32 log_info = le32_to_cpu(mpi_reply->IOCLogInfo);
+
+	if (log_info == 0x31170000)
+		return;
 
 	switch (ioc_status) {
 	case MPI2_IOCSTATUS_SUCCESS:
