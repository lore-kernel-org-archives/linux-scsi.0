From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 11/17] bfa: firmware statistics update
Date: Mon, 13 May 2013 02:33:29 -0700
Message-ID: <1368437615-9867-12-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50388 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120Ab3EMJww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:52:52 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

Get RDS drop interrupts and REC (Read Exchange Concise) related stats
from firmware.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_defs_svc.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index 3e8e224..d151e2b 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -105,6 +105,9 @@ struct bfa_fw_ioim_stats_s {
 					 *  an error condition*/
 	u32	wait_for_si;		/*  FW wait for SI */
 	u32	rec_rsp_inval;		/*  REC rsp invalid */
+	u32     rec_rsp_xchg_comp;	/*  REC rsp xchg complete */
+	u32     rec_rsp_rd_si_ownd;	/*  REC rsp read si owned */
+
 	u32	seqr_io_abort;		/*  target does not know cmd so abort */
 	u32	seqr_io_retry;		/*  SEQR failed so retry IO */
 
@@ -483,6 +486,14 @@ struct bfa_fw_ct_mod_stats_s {
 };
 
 /*
+ * RDS mod stats
+ */
+struct bfa_fw_rds_stats_s {
+	u32	no_fid_drop_err; /* RDS no fid drop error */
+	u32	rsvd;		 /* 64bit align */
+};
+
+/*
  * IOC firmware stats
  */
 struct bfa_fw_stats_s {
@@ -497,6 +508,7 @@ struct bfa_fw_stats_s {
 	struct bfa_fw_mac_mod_stats_s	macmod_stats;
 	struct bfa_fw_ct_mod_stats_s	ctmod_stats;
 	struct bfa_fw_eth_sndrcv_stats_s	ethsndrcv_stats;
+	struct bfa_fw_rds_stats_s	rds_stats;
 };
 
 #define BFA_IOCFC_PATHTOV_MAX	60
-- 
1.7.12

