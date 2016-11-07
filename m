From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 1/2] qla2xxx: do not queue commands when unloading
Date: Mon,  7 Nov 2016 17:53:30 -0200
Message-ID: <1478548411-17932-2-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1478548411-17932-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478548411-17932-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When the driver is unloading, in qla2x00_remove_one(), there is a single
call/point in time to abort ongoing commands, qla2x00_abort_all_cmds(),
which is still several steps away from the call to scsi_remove_host().

If more commands continue to arrive and be processed during that interval,
when the driver is tearing down and releasing its structures, it might
potentially hit an oops due to invalid memory access:

    Unable to handle kernel paging request for data at address 0x00000138
    <...>
    NIP [d000000004700a40] qla2xxx_queuecommand+0x80/0x3f0 [qla2xxx]
    LR [d000000004700a10] qla2xxx_queuecommand+0x50/0x3f0 [qla2xxx]

So, fail commands in qla2xxx_queuecommand() if the UNLOADING bit is set.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ace65db..fdb135b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -707,6 +707,11 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 	srb_t *sp;
 	int rval;
 
+	if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags))) {
+		cmd->result = DID_NO_CONNECT << 16;
+		goto qc24_fail_command;
+	}
+
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure) {
 			ql_dbg(ql_dbg_aer, vha, 0x9010,
-- 
1.8.3.1
