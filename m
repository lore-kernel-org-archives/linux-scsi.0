From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Fri, 09 Dec 2005 17:45:22 -0500
Message-ID: <1134168322.3491.5.camel@mulgrave>
References: <200512091938.jB9JbnnQ025362@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <200512091938.jB9JbnnQ025362@einhorn.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, patmans@us.ibm.com, adq_dvb@lidskialf.net, linux1394-devel@lists.sourceforge.net, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-12-09 at 20:35 +0100, Stefan Richter wrote:
> When preparing a request in scsi_lib or in a SCSI high-level driver,
> always set a transfer direction of DMA_NONE if data length is zero,
> even for alleged write requests. (Extended patch derived from Jens
> Axboe's version.)
> 
> Write requests with request buffer length == 0 lead to kernel panic
> or oops if channeled through sbp2:
> http://marc.theaimsgroup.com/?l=linux1394-devel&m=113399994920181
> http://marc.theaimsgroup.com/?l=linux1394-user&m=112152701817435
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

The problem is that I already picked up Jens' patch in rc fixes, so this
no-longer applies.  However, given that the fix needed to be in four
separate places, which looks rather bad, I propose the following
consolidation instead.

James

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1078,6 +1078,26 @@ static void scsi_generic_done(struct scs
 	scsi_io_completion(cmd, cmd->result == 0 ? cmd->bufflen : 0, 0);
 }
 
+void scsi_setup_blk_pc_cmnd(struct scsi_cmnd *cmd, int retries)
+{
+	struct request *req = cmd->request;
+
+	BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
+	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
+	cmd->cmd_len = req->cmd_len;
+	if (!req->data_len)
+		cmd->sc_data_direction = DMA_NONE;
+	else if (rq_data_dir(req) == WRITE)
+		cmd->sc_data_direction = DMA_TO_DEVICE;
+	else
+		cmd->sc_data_direction = DMA_FROM_DEVICE;
+	
+	cmd->transfersize = req->data_len;
+	cmd->allowed = retries;
+	cmd->timeout_per_command = req->timeout;
+}
+EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
+
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct scsi_device *sdev = q->queuedata;
@@ -1213,18 +1233,7 @@ static int scsi_prep_fn(struct request_q
 				goto kill;
 			}
 		} else {
-			memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
-			cmd->cmd_len = req->cmd_len;
-			if (!req->data_len)
-				cmd->sc_data_direction = DMA_NONE;
-			else if (rq_data_dir(req) == WRITE)
-				cmd->sc_data_direction = DMA_TO_DEVICE;
-			else
-				cmd->sc_data_direction = DMA_FROM_DEVICE;
-			
-			cmd->transfersize = req->data_len;
-			cmd->allowed = 3;
-			cmd->timeout_per_command = req->timeout;
+			scsi_setup_blk_pc_cmnd(cmd, 3);
 			cmd->done = scsi_generic_done;
 		}
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -245,24 +245,10 @@ static int sd_init_command(struct scsi_c
 	 * SG_IO from block layer already setup, just copy cdb basically
 	 */
 	if (blk_pc_request(rq)) {
-		if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
-			return 0;
-
-		memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
-		SCpnt->cmd_len = rq->cmd_len;
-		if (rq_data_dir(rq) == WRITE)
-			SCpnt->sc_data_direction = DMA_TO_DEVICE;
-		else if (rq->data_len)
-			SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-		else
-			SCpnt->sc_data_direction = DMA_NONE;
-
-		this_count = rq->data_len;
+		scsi_setup_blk_pc_cmnd(SCpnt, SD_PASSTHROUGH_RETRIES);
 		if (rq->timeout)
 			timeout = rq->timeout;
 
-		SCpnt->transfersize = rq->data_len;
-		SCpnt->allowed = SD_PASSTHROUGH_RETRIES;
 		goto queue;
 	}
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -320,25 +320,11 @@ static int sr_init_command(struct scsi_c
 	 * these are already setup, just copy cdb basically
 	 */
 	if (SCpnt->request->flags & REQ_BLOCK_PC) {
-		struct request *rq = SCpnt->request;
+		scsi_setup_blk_pc_cmnd(SCpnt, MAX_RETRIES);
 
-		if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
-			return 0;
-
-		memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
-		SCpnt->cmd_len = rq->cmd_len;
-		if (!rq->data_len)
-			SCpnt->sc_data_direction = DMA_NONE;
-		else if (rq_data_dir(rq) == WRITE)
-			SCpnt->sc_data_direction = DMA_TO_DEVICE;
-		else
-			SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-
-		this_count = rq->data_len;
-		if (rq->timeout)
-			timeout = rq->timeout;
+		if (SCpnt->timeout_per_command)
+			timeout = SCpnt->timeout_per_command;
 
-		SCpnt->transfersize = rq->data_len;
 		goto queue;
 	}
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4194,27 +4194,10 @@ static void st_intr(struct scsi_cmnd *SC
  */
 static int st_init_command(struct scsi_cmnd *SCpnt)
 {
-	struct request *rq;
-
 	if (!(SCpnt->request->flags & REQ_BLOCK_PC))
 		return 0;
 
-	rq = SCpnt->request;
-	if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
-		return 0;
-
-	memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
-	SCpnt->cmd_len = rq->cmd_len;
-
-	if (rq_data_dir(rq) == WRITE)
-		SCpnt->sc_data_direction = DMA_TO_DEVICE;
-	else if (rq->data_len)
-		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	else
-		SCpnt->sc_data_direction = DMA_NONE;
-
-	SCpnt->timeout_per_command = rq->timeout;
-	SCpnt->transfersize = rq->data_len;
+	scsi_setup_blk_pc_cmnd(SCpnt, 0);
 	SCpnt->done = st_intr;
 	return 1;
 }




-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
