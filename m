From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct
 Scsi_Host->cmd_serial_number to atomic_t
Date: Mon, 27 Sep 2010 23:14:29 -0400
Message-ID: <20100928031429.GA9523@linux.intel.com>
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org>
 <4C93BB8E.2080501@cisco.com>
 <4C9427B6.9050404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C9427B6.9050404@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Joe Eykholt <jeykholt@cisco.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2010 at 09:45:10PM -0500, Mike Christie wrote:
> You could also convert drivers to the host tagging if you needed a
> unique id for each command sent to a host.

I just wanted to make people aware of a problem with the host tagging
-- scsi_cmnd->tag is always 0!

Watch this:

scsi_prep_fn:
		ret = scsi_setup_blk_pc_cmnd(sdev, req);

scsi_setup_blk_pc_cmnd:
	cmd = scsi_get_cmd_from_req(sdev, req);

scsi_get_cmd_from_req:
	cmd->tag = req->tag;

scsi_request_fn:
		if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
			blk_start_request(req);

blk_queue_start_tag
	rq->tag = tag;

(and yes, they're called in this order)

I encountered this while writing the UAS driver, and decided to just
use the rq->tag directly instead.  I would favour deleting scmd->tag in
order to save others the confusion.

In fact, looking at the users of scmd->tag, it appears there is a common
misconception that it contains the tag type (HEAD / SIMPLE / ORDERED).  I
have no idea where this comes from, but it means the following patch to
delete scmd's ->tag is almost certainly wrong ... but it preserves the
existing behaviour!


diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 5d2f148..37ff654 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1531,7 +1531,6 @@ part2:
 	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), cmd->device->lun);
 
 	len = 1;
-	cmd->tag = 0;
 
 	/* Send message(s) */
 	data = tmp;
@@ -2240,7 +2239,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					}
 					initialize_SCp(cmd->next_link);
 					/* The next command is still part of this process */
-					cmd->next_link->tag = cmd->tag;
+					cmd->next_link->tag = 0;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
 					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun));
 					collect_stats(hostdata, cmd);
@@ -2604,7 +2603,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 		do_abort(instance);
 	} else {
 		hostdata->connected = tmp;
-		dprintk(NDEBUG_RESELECTION, ("scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->target, tmp->lun, tmp->tag));
+		dprintk(NDEBUG_RESELECTION, ("scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->target, tmp->lun, 0));
 	}
 }
 
@@ -2789,7 +2788,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 		if (cmd == tmp) {
 			dprintk(NDEBUG_ABORT, ("scsi%d : aborting disconnected command.\n", instance->host_no));
 
-			if (NCR5380_select(instance, cmd, (int) cmd->tag))
+			if (NCR5380_select(instance, cmd, 0))
 				return FAILED;
 			dprintk(NDEBUG_ABORT, ("scsi%d : nexus reestablished.\n", instance->host_no));
 
diff --git a/drivers/scsi/bfa/bfa_cb_ioim_macros.h b/drivers/scsi/bfa/bfa_cb_ioim_macros.h
index 3906ed9..57f2f7d 100644
--- a/drivers/scsi/bfa/bfa_cb_ioim_macros.h
+++ b/drivers/scsi/bfa/bfa_cb_ioim_macros.h
@@ -143,19 +143,8 @@ bfa_cb_ioim_get_taskattr(struct bfad_ioim_s *dio)
 	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
 	u8         task_attr = UNTAGGED;
 
-	if (cmnd->device->tagged_supported) {
-		switch (cmnd->tag) {
-		case HEAD_OF_QUEUE_TAG:
-			task_attr = HEAD_OF_Q;
-			break;
-		case ORDERED_QUEUE_TAG:
-			task_attr = ORDERED_Q;
-			break;
-		default:
-			task_attr = SIMPLE_Q;
-			break;
-		}
-	}
+	if (cmnd->device->tagged_supported)
+		task_attr = SIMPLE_Q;
 
 	return task_attr;
 }
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index ff6a28c..f506970 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -431,7 +431,7 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
 	memcpy(sc->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
 	sc->sdb.length = len;
 	sc->sdb.table.sgl = (void *) (unsigned long) addr;
-	sc->tag = tag;
+	sc->request->tag = tag;
 	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
 				     cmd->tag);
 	if (err)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ee02d38..42e40de 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1031,8 +1031,6 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 		cmd = req->special;
 	}
 
-	/* pull a tag out of the request if we have one */
-	cmd->tag = req->tag;
 	cmd->request = req;
 
 	cmd->cmnd = req->cmd;
diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index a87e21c..c00e363 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -117,7 +117,7 @@ int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, u64 itn_id,
 	ev.p.cmd_req.data_len = scsi_bufflen(cmd);
 	memcpy(ev.p.cmd_req.scb, cmd->cmnd, sizeof(ev.p.cmd_req.scb));
 	memcpy(ev.p.cmd_req.lun, lun, sizeof(ev.p.cmd_req.lun));
-	ev.p.cmd_req.attribute = cmd->tag;
+	ev.p.cmd_req.attribute = 0;
 	ev.p.cmd_req.tag = tag;
 
 	dprintk("%p %d %u %x %llx\n", cmd, shost->host_no,
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 2689445..39cae91 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -665,10 +665,6 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
 	memcpy(e->cdb, cmd->cmnd, e->cdbLen);
 
 	e->tag = SIMPLE_QUEUE_TAG;
-	if (sdev->tagged_supported &&
-	    (cmd->tag == HEAD_OF_QUEUE_TAG ||
-	     cmd->tag == ORDERED_QUEUE_TAG))
-		e->tag = cmd->tag;
 
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE)
 		e->flags = PVSCSI_FLAG_CMD_DIR_TOHOST;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a5e885a..829e341 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -127,8 +127,6 @@ struct scsi_cmnd {
 					 * to be at an address < 16Mb). */
 
 	int result;		/* Status code from lower level driver */
-
-	unsigned char tag;	/* SCSI-II queued command tag */
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
