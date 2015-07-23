From: Spencer Baugh <sbaugh@catern.com>
Subject: Re: [PATCH] target: add support for START_STOP_UNIT SCSI opcode
Date: Thu, 23 Jul 2015 15:27:46 -0700
Message-ID: <877fpqfr19.fsf@ponos.purestorage.com>
References: <1437516477-30554-1-git-send-email-sbaugh@catern.com> <20150723093618.GA5382@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from catern.com ([104.131.201.120]:44156 "EHLO mail.catern.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbbGWW1t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jul 2015 18:27:49 -0400
In-Reply-To: <20150723093618.GA5382@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Spencer Baugh <sbaugh@catern.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Brian Bunker <brian@purestorage.com>

From: Brian Bunker <brian@purestorage.com>

AIX servers using VIOS servers that virtualize FC cards will have a
problem booting without support for START_STOP_UNIT.

v2: Cite sb3r36 exactly, clean up if conditions

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/target/target_core_sbc.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index e318ddb..85c3c0a 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -154,6 +154,38 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 	return 0;
 }
 
+static sense_reason_t
+sbc_emulate_startstop(struct se_cmd *cmd)
+{
+	unsigned char *cdb = cmd->t_task_cdb;
+
+	/*
+	 * See sb3r36 section 5.25
+	 * Immediate bit should be set since there is nothing to complete
+	 * POWER CONDITION MODIFIER 0h
+	 */
+	if (!(cdb[1] & 1) || cdb[2] || cdb[3])
+		return TCM_INVALID_CDB_FIELD;
+
+	/*
+	 * See sb3r36 section 5.25
+	 * POWER CONDITION 0h START_VALID - process START and LOEJ
+	 */
+	if (cdb[4] >> 4 & 0xf)
+		return TCM_INVALID_CDB_FIELD;
+
+	/*
+	 * See sb3r36 section 5.25
+	 * LOEJ 0h - nothing to load or unload
+	 * START 1h - we are ready
+	 */
+	if (!(cdb[4] & 1) || (cdb[4] & 2) || (cdb[4] & 4))
+		return TCM_INVALID_CDB_FIELD;
+
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
+	return 0;
+}
+
 sector_t sbc_get_write_same_sectors(struct se_cmd *cmd)
 {
 	u32 num_blocks;
@@ -1069,6 +1101,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		size = 0;
 		cmd->execute_cmd = sbc_emulate_noop;
 		break;
+	case START_STOP:
+		size = 0;
+		cmd->execute_cmd = sbc_emulate_startstop;
+		break;
 	default:
 		ret = spc_parse_cdb(cmd, &size);
 		if (ret)
-- 
2.5.0.rc3
