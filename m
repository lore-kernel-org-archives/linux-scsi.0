From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH resend] scsi tgt: fix build when dprintk is defined
Date: Wed, 14 Nov 2007 16:52:36 -0800
Message-ID: <20071114165236.54f93155.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:15886 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbXKOAxL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2007 19:53:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, jejb <james.bottomley@steeleye.com>
Cc: scsi <linux-scsi@vger.kernel.org>

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
 drivers/scsi/scsi_tgt_lib.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.24-rc2-git4.orig/drivers/scsi/scsi_tgt_lib.c
+++ linux-2.6.24-rc2-git4/drivers/scsi/scsi_tgt_lib.c
@@ -180,7 +180,7 @@ static void scsi_tgt_cmd_destroy(struct 
 		container_of(work, struct scsi_tgt_cmd, work);
 	struct scsi_cmnd *cmd = tcmd->rq->special;
 
-	dprintk("cmd %p %d %lu\n", cmd, cmd->sc_data_direction,
+	dprintk("cmd %p %d %u\n", cmd, cmd->sc_data_direction,
 		rq_data_dir(cmd->request));
 	scsi_unmap_user_pages(tcmd);
 	scsi_host_put_command(scsi_tgt_cmd_to_host(cmd), cmd);
@@ -327,7 +327,7 @@ static void scsi_tgt_cmd_done(struct scs
 {
 	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
 
-	dprintk("cmd %p %lu\n", cmd, rq_data_dir(cmd->request));
+	dprintk("cmd %p %u\n", cmd, rq_data_dir(cmd->request));
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
@@ -342,7 +342,7 @@ static int scsi_tgt_transfer_response(st
 	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
 	int err;
 
-	dprintk("cmd %p %lu\n", cmd, rq_data_dir(cmd->request));
+	dprintk("cmd %p %u\n", cmd, rq_data_dir(cmd->request));
 
 	err = shost->hostt->transfer_response(cmd, scsi_tgt_cmd_done);
 	switch (err) {
@@ -365,7 +365,7 @@ static int scsi_tgt_init_cmd(struct scsi
 
 	cmd->request_bufflen = rq->data_len;
 
-	dprintk("cmd %p cnt %d %lu\n", cmd, cmd->use_sg, rq_data_dir(rq));
+	dprintk("cmd %p cnt %d %u\n", cmd, cmd->use_sg, rq_data_dir(rq));
 	count = blk_rq_map_sg(rq->q, rq, cmd->request_buffer);
 	if (likely(count <= cmd->use_sg)) {
 		cmd->use_sg = count;
@@ -496,7 +496,7 @@ int scsi_tgt_kspace_exec(int host_no, u6
 	}
 	cmd = rq->special;
 
-	dprintk("cmd %p scb %x result %d len %d bufflen %u %lu %x\n",
+	dprintk("cmd %p scb %x result %d len %d bufflen %u %u %x\n",
 		cmd, cmd->cmnd[0], result, len, cmd->request_bufflen,
 		rq_data_dir(rq), cmd->cmnd[0]);
 
@@ -617,7 +617,7 @@ int scsi_tgt_kspace_it_nexus_rsp(int hos
 	struct Scsi_Host *shost;
 	int err = -EINVAL;
 
-	dprintk("%d %d %llx\n", host_no, result, (unsigned long long) mid);
+	dprintk("%d %d\n", host_no, result);
 
 	shost = scsi_host_lookup(host_no);
 	if (IS_ERR(shost)) {
