Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775DFCA9ECB
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56C8D2087F
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfJaLFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 07:05:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:37432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727033AbfJaLFb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Oct 2019 07:05:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C877CB34F;
        Thu, 31 Oct 2019 11:05:27 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/24] target_core: Fixup target_complete_cmd() usage
Date:   Thu, 31 Oct 2019 12:04:35 +0100
Message-Id: <20191031110452.73463-8-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191031110452.73463-1-hare@suse.de>
References: <20191031110452.73463-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_complete_cmd() occasionally still uses the linux-specific
SCSI result values; fix it up to use SAM result values throughout.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c   |  6 +++---
 drivers/target/target_core_iblock.c |  2 +-
 drivers/target/target_core_pr.c     |  8 ++++----
 drivers/target/target_core_sbc.c    | 10 +++++-----
 drivers/target/target_core_spc.c    | 14 +++++++-------
 drivers/target/target_core_xcopy.c  |  2 +-
 6 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 385e4cf9cfa6..b53b6d7f173e 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -123,7 +123,7 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
@@ -255,7 +255,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	}
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd_with_length(cmd, GOOD, rd_len + 4);
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, rd_len + 4);
 	return 0;
 }
 
@@ -424,7 +424,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 out:
 	transport_kunmap_data_sg(cmd);
 	if (!rc)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return rc;
 }
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 6949ea8bc387..bbafa984226e 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -436,7 +436,7 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 	if (ret)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 5e931690e697..4fef561b201c 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -234,7 +234,7 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 out_unlock:
 	spin_unlock(&dev->dev_reservation_lock);
 out:
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
@@ -297,7 +297,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	spin_unlock(&dev->dev_reservation_lock);
 out:
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
 }
 
@@ -3680,7 +3680,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	}
 
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
 }
 
@@ -4070,7 +4070,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 	}
 
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
 }
 
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index f1e81886122d..6e45924fb3da 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -67,7 +67,7 @@ sbc_emulate_readcapacity(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd_with_length(cmd, GOOD, 8);
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, 8);
 	return 0;
 }
 
@@ -130,7 +130,7 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd_with_length(cmd, GOOD, 32);
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, 32);
 	return 0;
 }
 
@@ -202,14 +202,14 @@ sbc_execute_write_same_unmap(struct se_cmd *cmd)
 			return ret;
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
 static sense_reason_t
 sbc_emulate_noop(struct se_cmd *cmd)
 {
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
@@ -1214,7 +1214,7 @@ sbc_execute_unmap(struct se_cmd *cmd)
 err:
 	transport_kunmap_data_sg(cmd);
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
 }
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 6d4cf2643c0a..84f7fefc2998 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -754,7 +754,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 	kfree(buf);
 
 	if (!ret)
-		target_complete_cmd_with_length(cmd, GOOD, len);
+		target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, len);
 	return ret;
 }
 
@@ -1099,7 +1099,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd_with_length(cmd, GOOD, length);
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, length);
 	return 0;
 }
 
@@ -1117,7 +1117,7 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
 	int i;
 
 	if (!cmd->data_length) {
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 		return 0;
 	}
 
@@ -1160,7 +1160,7 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
 	transport_kunmap_data_sg(cmd);
 
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
 }
 
@@ -1193,7 +1193,7 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
@@ -1260,7 +1260,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd_with_length(cmd, GOOD, 8 + lun_count * 8);
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, 8 + lun_count * 8);
 	return 0;
 }
 EXPORT_SYMBOL(spc_emulate_report_luns);
@@ -1268,7 +1268,7 @@ EXPORT_SYMBOL(spc_emulate_report_luns);
 static sense_reason_t
 spc_emulate_testunitready(struct se_cmd *cmd)
 {
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 425c1070de08..30475bf73faf 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -1043,7 +1043,7 @@ static sense_reason_t target_rcr_operating_parameters(struct se_cmd *se_cmd)
 	put_unaligned_be32(42, &p[0]);
 
 	transport_kunmap_data_sg(se_cmd);
-	target_complete_cmd(se_cmd, GOOD);
+	target_complete_cmd(se_cmd, SAM_STAT_GOOD);
 
 	return TCM_NO_SENSE;
 }
-- 
2.16.4

