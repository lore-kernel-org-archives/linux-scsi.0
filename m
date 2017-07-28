From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 05/22] zfcp: fix queuecommand for scsi_eh commands when DIX enabled
Date: Fri, 28 Jul 2017 12:30:51 +0200
Message-ID: <9ef47a2f823cf6010b28fd2bf0b235311aaeb996.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37035 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751925AbdG1KbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:15 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SASwJR015532
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:15 -0400
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2byyg8346k-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:14 -0400
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:12 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAV9U338994098
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDDF05208C
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:27:13 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C147252090
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:27:13 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, stable@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Steffen Maier <maier@linux.vnet.ibm.com>

Since commit db007fc5e20c ("[SCSI] Command protection operation"),
scsi_eh_prep_cmnd() saves scmd->prot_op and temporarily resets it to
SCSI_PROT_NORMAL.
Other FCP LLDDs such as qla2xxx and lpfc shield their queuecommand()
to only access any of scsi_prot_sg...() if
(scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL).

Do the same thing for zfcp, which introduced DIX support with
commit ef3eb71d8ba4 ("[SCSI] zfcp: Introduce experimental support for
DIF/DIX").

Otherwise, TUR SCSI commands as part of scsi_eh likely fail in zfcp,
because the regular SCSI command with DIX protection data, that scsi_eh
re-uses in scsi_send_eh_cmnd(), of course still has
(scsi_prot_sg_count() != 0) and so zfcp sends down bogus requests to the
FCP channel hardware.

This causes scsi_eh_test_devices() to have (finish_cmds == 0)
[not SCSI device is online or not scsi_eh_tur() failed]
so regular SCSI commands, that caused / were affected by scsi_eh,
are moved to work_q and scsi_eh_test_devices() itself returns false.
In turn, it unnecessarily escalates in our case in scsi_eh_ready_devs()
beyond host reset to finally scsi_eh_offline_sdevs()
which sets affected SCSI devices offline with the following kernel message:

"kernel: sd H:0:T:L: Device offlined - not ready after error recovery"

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: ef3eb71d8ba4 ("[SCSI] zfcp: Introduce experimental support for DIF/DIX")
Cc: <stable@vger.kernel.org> #2.6.36+
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 3b69ec5e69ed..e894ec92076c 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2257,7 +2257,8 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
 	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd, 0);
 
-	if (scsi_prot_sg_count(scsi_cmnd)) {
+	if ((scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) &&
+	    scsi_prot_sg_count(scsi_cmnd)) {
 		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
 				       scsi_prot_sg_count(scsi_cmnd));
 		retval = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
-- 
2.11.2
