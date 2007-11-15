From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH rebased] tgt: fix build when dprintk is defined
Date: Thu, 15 Nov 2007 11:37:30 +0200
Message-ID: <473C135A.9070301@panasas.com>
References: <20071114165236.54f93155.randy.dunlap@oracle.com> <473C0CC7.6090306@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa10.bezeqint.net ([192.115.104.24]:57610 "EHLO
	sa10.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbXKOJhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 04:37:39 -0500
In-Reply-To: <473C0CC7.6090306@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: michaelc@cs.wisc.edu, scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

From: Randy Dunlap <rdunlap@xenotime.net>

Fix scsi_tgt_lib build when dprintk is defined:

drivers/scsi/scsi_tgt_lib.c: In function 'scsi_tgt_cmd_destroy':
drivers/scsi/scsi_tgt_lib.c:183: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'unsigned int'
drivers/scsi/scsi_tgt_lib.c: In function 'scsi_tgt_cmd_done':
drivers/scsi/scsi_tgt_lib.c:330: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
drivers/scsi/scsi_tgt_lib.c: In function 'scsi_tgt_transfer_response':
drivers/scsi/scsi_tgt_lib.c:345: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
drivers/scsi/scsi_tgt_lib.c: In function 'scsi_tgt_init_cmd':
drivers/scsi/scsi_tgt_lib.c:368: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'unsigned int'
drivers/scsi/scsi_tgt_lib.c: In function 'scsi_tgt_kspace_exec':
drivers/scsi/scsi_tgt_lib.c:499: warning: format '%lu' expects type 'long unsigned int', but argument 9 has type 'unsigned int'
drivers/scsi/scsi_tgt_lib.c: In function 'scsi_tgt_kspace_it_nexus_rsp':
drivers/scsi/scsi_tgt_lib.c:620: error: 'mid' undeclared (first use in this function)
drivers/scsi/scsi_tgt_lib.c:620: error: (Each undeclared identifier is reported only once
drivers/scsi/scsi_tgt_lib.c:620: error: for each function it appears in.)
make[2]: *** [drivers/scsi/scsi_tgt_lib.o] Error 1

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/scsi_tgt_lib.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 5fd5fca..fad03a4 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -180,7 +180,7 @@ static void scsi_tgt_cmd_destroy(struct work_struct *work)
 		container_of(work, struct scsi_tgt_cmd, work);
 	struct scsi_cmnd *cmd = tcmd->rq->special;
 
-	dprintk("cmd %p %d %lu\n", cmd, cmd->sc_data_direction,
+	dprintk("cmd %p %d %u\n", cmd, cmd->sc_data_direction,
 		rq_data_dir(cmd->request));
 	scsi_unmap_user_pages(tcmd);
 	scsi_host_put_command(scsi_tgt_cmd_to_host(cmd), cmd);
@@ -327,7 +327,7 @@ static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
 {
 	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
 
-	dprintk("cmd %p %lu\n", cmd, rq_data_dir(cmd->request));
+	dprintk("cmd %p %u\n", cmd, rq_data_dir(cmd->request));
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
@@ -341,7 +341,7 @@ static int scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
 	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
 	int err;
 
-	dprintk("cmd %p %lu\n", cmd, rq_data_dir(cmd->request));
+	dprintk("cmd %p %u\n", cmd, rq_data_dir(cmd->request));
 
 	err = shost->hostt->transfer_response(cmd, scsi_tgt_cmd_done);
 	switch (err) {
@@ -473,7 +473,7 @@ int scsi_tgt_kspace_exec(int host_no, u64 itn_id, int result, u64 tag,
 	}
 	cmd = rq->special;
 
-	dprintk("cmd %p scb %x result %d len %d bufflen %u %lu %x\n",
+	dprintk("cmd %p scb %x result %d len %d bufflen %u %u %x\n",
 		cmd, cmd->cmnd[0], result, len, cmd->request_bufflen,
 		rq_data_dir(rq), cmd->cmnd[0]);
 
@@ -594,7 +594,7 @@ int scsi_tgt_kspace_it_nexus_rsp(int host_no, u64 itn_id, int result)
 	struct Scsi_Host *shost;
 	int err = -EINVAL;
 
-	dprintk("%d %d %llx\n", host_no, result, (unsigned long long) mid);
+	dprintk("%d %d\n", host_no, result);
 
 	shost = scsi_host_lookup(host_no);
 	if (IS_ERR(shost)) {
-- 
1.5.3.1

