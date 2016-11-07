From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 2/2] qla2xxx: fix invalid DMA access after command aborts in PCI device remove
Date: Mon,  7 Nov 2016 17:53:31 -0200
Message-ID: <1478548411-17932-3-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1478548411-17932-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41762 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751032AbcKGTxw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2016 14:53:52 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uA7Jrqpk010233
        for <linux-scsi@vger.kernel.org>; Mon, 7 Nov 2016 14:53:52 -0500
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26juyfd40t-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Nov 2016 14:53:51 -0500
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 7 Nov 2016 17:53:44 -0200
In-Reply-To: <1478548411-17932-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

If a command is aborted in the kernel but not in the adapter, it might be
considered complete and its DMA memory released, but it is still alive in
the adapter, which will trigger an invalid DMA access upon its completion
(in the DMA operations to deliver the command response to the driver).

On powerpc platforms with IOMMU/EEH capabilities, the problem is observed
during PCI device removal with ongoing IO requests -- which might trigger
an EEH event very often, pointing to a 'TCE Request Page Access Error'.

In that path, which is qla2x00_remove_one(), the commands are aborted in
qla2x00_abort_all_cmds(), which does not perform an abort in the adapter
as is done in qla2xxx_eh_abort() for example.

So, this patch changes qla2x00_abort_all_cmds() to abort commands in the
adapter too, with a call to qla2xxx_eh_abort(), which already implements
all the logic to submit abort requests and handle responses.

Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fdb135b..c50dd22 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1456,6 +1456,15 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 			sp = req->outstanding_cmds[cnt];
 			if (sp) {
+				/* Get a reference to the sp and drop the lock.
+				 * The reference ensures this sp->done() call
+				 * - and not the call in qla2xxx_eh_abort() -
+				 * ends the SCSI command (with result 'res').
+				 */
+				sp_get(sp);
+				spin_unlock_irqrestore(&ha->hardware_lock, flags);
+				qla2xxx_eh_abort(GET_CMD_SP(sp));
+				spin_lock_irqsave(&ha->hardware_lock, flags);
 				req->outstanding_cmds[cnt] = NULL;
 				sp->done(vha, sp, res);
 			}
-- 
1.8.3.1

