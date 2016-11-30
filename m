From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 1/5] qla2xxx: Only allow operational MBX to proceed during RESET.
Date: Wed, 30 Nov 2016 12:24:53 -0800
Message-ID: <1480537497-16429-2-git-send-email-himanshu.madhani@cavium.com>
References: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0058.outbound.protection.outlook.com ([104.47.38.58]:31584
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753868AbcK3UZd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Nov 2016 15:25:33 -0500
In-Reply-To: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 52 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 23698c9..b31c36b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -10,6 +10,43 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 
+struct rom_cmd {
+	uint16_t cmd;
+} rom_cmds[] = {
+	{ MBC_LOAD_RAM },
+	{ MBC_EXECUTE_FIRMWARE },
+	{ MBC_READ_RAM_WORD },
+	{ MBC_MAILBOX_REGISTER_TEST },
+	{ MBC_VERIFY_CHECKSUM },
+	{ MBC_GET_FIRMWARE_VERSION },
+	{ MBC_LOAD_RISC_RAM },
+	{ MBC_DUMP_RISC_RAM },
+	{ MBC_LOAD_RISC_RAM_EXTENDED },
+	{ MBC_DUMP_RISC_RAM_EXTENDED },
+	{ MBC_WRITE_RAM_WORD_EXTENDED },
+	{ MBC_READ_RAM_EXTENDED },
+	{ MBC_GET_RESOURCE_COUNTS },
+	{ MBC_SET_FIRMWARE_OPTION },
+	{ MBC_MID_INITIALIZE_FIRMWARE },
+	{ MBC_GET_FIRMWARE_STATE },
+	{ MBC_GET_MEM_OFFLOAD_CNTRL_STAT },
+	{ MBC_GET_RETRY_COUNT },
+	{ MBC_TRACE_CONTROL },
+};
+
+static int is_rom_cmd(uint16_t cmd)
+{
+	int i;
+	struct  rom_cmd *wc;
+
+	for (i = 0; i < ARRAY_SIZE(rom_cmds); i++) {
+		wc = rom_cmds + i;
+		if (wc->cmd == cmd)
+			return 1;
+	}
+
+	return 0;
+}
 
 /*
  * qla2x00_mailbox_command
@@ -92,6 +129,17 @@
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
+	/* check if ISP abort is active and return cmd with timeout */
+	if ((test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
+	    test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
+	    test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags)) &&
+	    !is_rom_cmd(mcp->mb[0])) {
+		ql_log(ql_log_info, vha, 0x1005,
+		    "Cmd 0x%x aborted with timeout since ISP Abort is pending\n",
+		    mcp->mb[0]);
+		return QLA_FUNCTION_TIMEOUT;
+	}
+
 	/*
 	 * Wait for active mailbox commands to finish by waiting at most tov
 	 * seconds. This is to serialize actual issuing of mailbox cmds during
@@ -178,6 +226,7 @@
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
+		wait_time = jiffies;
 		if (!wait_for_completion_timeout(&ha->mbx_intr_comp,
 		    mcp->tov * HZ)) {
 			ql_dbg(ql_dbg_mbx, vha, 0x117a,
@@ -186,6 +235,9 @@
 			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		}
+		if (time_after(jiffies, wait_time + 5 * HZ))
+			ql_log(ql_log_warn, vha, 0x1015, "cmd=0x%x, waited %d msecs\n",
+			    command, jiffies_to_msecs(jiffies - wait_time));
 	} else {
 		ql_dbg(ql_dbg_mbx, vha, 0x1011,
 		    "Cmd=%x Polling Mode.\n", command);
-- 
1.8.3.1

