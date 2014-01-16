From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 1/7] Target/core: use sense_reason_t for se_cmd->pi_err
Date: Thu, 16 Jan 2014 15:55:50 +0200
Message-ID: <1389880556-21059-2-git-send-email-sagig@mellanox.com>
References: <1389880556-21059-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:51863 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752481AbaAPN4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 08:56:06 -0500
In-Reply-To: <1389880556-21059-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@daterainc.com
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, oren@mellanox.com

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 include/target/target_core_base.h |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d1b2435..5165cf7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -466,10 +466,9 @@ enum target_prot_version {
 	TARGET_DIF_V2 = 2,
 };
 
-enum target_pi_error {
-	TARGET_GUARD_CHECK_FAILED = 0x1,
-	TARGET_APPTAG_CHECK_FAILED = 0x2,
-	TARGET_REFTAG_CHECK_FAILED = 0x3,
+enum target_guard_type {
+	TARGET_DIX_GUARD_CRC = 1,
+	TARGET_DIX_GUARD_IP = 2,
 };
 
 struct se_dif_v1_tuple {
@@ -572,8 +571,8 @@ struct se_cmd {
 	u32			prot_length;
 	struct scatterlist	*t_prot_sg;
 	unsigned int		t_prot_nents;
-	enum target_prot_ho	prot_handover;
-	enum target_pi_error	pi_err;
+	enum target_prot_ho     prot_handover;
+	sense_reason_t		pi_err;
 	u32			block_num;
 };
 
-- 
1.7.1

