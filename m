Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A0841737E;
	Wed,  8 Jul 2026 09:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783503331; cv=none; b=IFc6xxW0JUTSpDfa8+JhG/0IpApdfmbXB2OJpcsY1UwpgfYHLumu+lUWMTLG+P6nS56duzheZo+II7tlgJeOba6i9eb2mzu9GODnX21oeQAnMDu0u7CEvh/B06Y1e1y7YWfq2zCEUbgythMaJqbpQyq0yI8Ls1NChv+b0eqAAVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783503331; c=relaxed/simple;
	bh=RaJbDKo/4Zb5/sFLTa9BbTzw+PvkLCMoYuvqSsqX9/k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F2H5PGAUu7hnBGnT2AsorWFnITGeUEe2SHi9sYvFaLMo+Jge3i+J5CWODq7NVwAUG8uPf4w4ukw89iWOEbXP5LF7V+F1Xoldzx3FmysOgP3yHoHXW4bM0Kat9XXANqsjiYsfxN9Jiroi9x/zPzKv3iG6ZapnIECotX6ObP5QBkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=eg2Fj5GQ; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="eg2Fj5GQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=oV
	oziyIhsTu5aIdmvF2NqXcCqPeTD5isrHNLUZ6Orbg=; b=eg2Fj5GQZmy3srrHA0
	Aaqtrdfo6loWvOcX+jJEGOzUXolocCkzhWdEhOL5QRIxxsCiLR7v/tltY9qdJPxC
	ru5Og49IbwHfb5Od3YdM8G2DLPlBLXk1gg1+pzWAMVlb6zr6/pHsOVLxjS2RNUwC
	u/4BOhy2C7LudM4nXjY4sNVG8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnl0jKGU5qSA9pIg--.37410S2;
	Wed, 08 Jul 2026 17:35:07 +0800 (CST)
From: kensanya@163.com
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: [PATCH] target/stat: implement scsiPortBusyStatuses counter
Date: Wed,  8 Jul 2026 17:34:33 +0800
Message-Id: <20260708093433.838647-1-kensanya@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnl0jKGU5qSA9pIg--.37410S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3AryxCFyUCw18ZFyfXFy3CFg_yoW7uw18pF
	WUJr45ArWDKFW8Ka18JF4jkry3tw1IgFW2ka4xXas5Aws8trW3Cw1DJFW2vFs5JFWkG343
	Wa1qyrZ8Ka1IqrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UDEfrUUUUU=
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbC6gumgmpOGcujjgAA3e

From: TanZheng <tanzheng@kylinos.cn>

Implement RFC 4455 scsiPortBusyStatuses (ConfigFS busy_count) by adding a
per-CPU busy_statuses counter to scsi_port_stats, incrementing it when
the target sends SAM_STAT_BUSY, and summing all CPUs in the show handler.

Signed-off-by: TanZheng <tanzheng@kylinos.cn>
---
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_stat.c      | 26 ++++++++++++++++++++++++--
 drivers/target/target_core_transport.c | 23 +++++++++++++++++------
 include/target/target_core_base.h      |  1 +
 4 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 763e6d26e187..a91f873d1845 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -161,6 +161,7 @@ void	target_queued_submit_work(struct work_struct *work);
 void	target_stat_setup_dev_default_groups(struct se_device *);
 void	target_stat_setup_port_default_groups(struct se_lun *);
 void	target_stat_setup_mappedlun_default_groups(struct se_lun_acl *);
+void	target_stat_count_busy_status(struct se_cmd *cmd);
 
 /* target_core_xcopy.c */
 extern struct se_portal_group xcopy_pt_tpg;
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 083205052be2..374aab290c07 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -21,12 +21,25 @@
 #include <linux/seq_file.h>
 #include <linux/configfs.h>
 
+#include <scsi/scsi_proto.h>
+
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
 #include <target/target_core_fabric.h>
 
 #include "target_core_internal.h"
 
+void target_stat_count_busy_status(struct se_cmd *cmd)
+{
+	struct se_lun *lun = cmd->se_lun;
+
+	if (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+		return;
+
+	if (cmd->scsi_status == SAM_STAT_BUSY && lun && lun->lun_stats)
+		this_cpu_inc(lun->lun_stats->busy_statuses);
+}
+
 #ifndef INITIAL_JIFFIES
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
 #endif
@@ -483,13 +496,22 @@ static ssize_t target_stat_port_busy_count_show(struct config_item *item,
 {
 	struct se_lun *lun = to_stat_port(item);
 	struct se_device *dev;
+	struct scsi_port_stats *stats;
+	unsigned int cpu;
+	u64 sum = 0;
 	ssize_t ret = -ENODEV;
 
 	rcu_read_lock();
 	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev) {
-		/* FIXME: scsiPortBusyStatuses  */
-		ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
+		/* scsiPortBusyStatuses */
+		if (lun->lun_stats) {
+			for_each_possible_cpu(cpu) {
+				stats = per_cpu_ptr(lun->lun_stats, cpu);
+				sum += stats->busy_statuses;
+			}
+		}
+		ret = snprintf(page, PAGE_SIZE, "%llu\n", sum);
 	}
 	rcu_read_unlock();
 	return ret;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fad03a15c969..bc3e683e8bdf 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -829,6 +829,17 @@ void transport_copy_sense_to_cmd(struct se_cmd *cmd, unsigned char *sense)
 }
 EXPORT_SYMBOL(transport_copy_sense_to_cmd);
 
+static int target_queue_status(struct se_cmd *cmd)
+{
+	int ret;
+
+	ret = cmd->se_tfo->queue_status(cmd);
+	if (!ret)
+		target_stat_count_busy_status(cmd);
+
+	return ret;
+}
+
 static void target_handle_abort(struct se_cmd *cmd)
 {
 	bool tas = cmd->transport_state & CMD_T_TAS;
@@ -843,7 +854,7 @@ static void target_handle_abort(struct se_cmd *cmd)
 			pr_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x, ITT: 0x%08llx\n",
 				 cmd->t_task_cdb[0], cmd->tag);
 			trace_target_cmd_complete(cmd);
-			ret = cmd->se_tfo->queue_status(cmd);
+			ret = target_queue_status(cmd);
 			if (ret) {
 				transport_handle_queue_full(cmd, cmd->se_dev,
 							    ret, false);
@@ -2170,7 +2181,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 
 queue_status:
 	trace_target_cmd_complete(cmd);
-	ret = cmd->se_tfo->queue_status(cmd);
+	ret = target_queue_status(cmd);
 	if (!ret)
 		goto check_stop;
 queue_full:
@@ -2487,7 +2498,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
 	case DMA_NONE:
 queue_status:
 		trace_target_cmd_complete(cmd);
-		ret = cmd->se_tfo->queue_status(cmd);
+		ret = target_queue_status(cmd);
 		break;
 	default:
 		break;
@@ -2685,7 +2696,7 @@ static void target_complete_ok_work(struct work_struct *work)
 	case DMA_NONE:
 queue_status:
 		trace_target_cmd_complete(cmd);
-		ret = cmd->se_tfo->queue_status(cmd);
+		ret = target_queue_status(cmd);
 		if (ret)
 			goto queue_full;
 		break;
@@ -3599,7 +3610,7 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 		translate_sense_reason(cmd, reason);
 
 	trace_target_cmd_complete(cmd);
-	return cmd->se_tfo->queue_status(cmd);
+	return target_queue_status(cmd);
 }
 EXPORT_SYMBOL(transport_send_check_condition_and_sense);
 
@@ -3615,7 +3626,7 @@ int target_send_busy(struct se_cmd *cmd)
 
 	cmd->scsi_status = SAM_STAT_BUSY;
 	trace_target_cmd_complete(cmd);
-	return cmd->se_tfo->queue_status(cmd);
+	return target_queue_status(cmd);
 }
 EXPORT_SYMBOL(target_send_busy);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 002b0fc57587..61a230331124 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -764,6 +764,7 @@ struct scsi_port_stats {
 	u64			cmd_pdus;
 	u64			tx_data_octets;
 	u64			rx_data_octets;
+	u64			busy_statuses;
 };
 
 struct se_lun {
-- 
2.25.1

