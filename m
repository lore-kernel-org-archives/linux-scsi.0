From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Fri, 9 Dec 2005 20:35:29 +0100 (CET)
Message-ID: <200512091938.jB9JbnnQ025362@einhorn.in-berlin.de>
References: <4399CF7B.7060708@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <4399CF7B.7060708@s5r6.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: linux-scsi@vger.kernel.org
Cc: patmans@us.ibm.com, adq_dvb@lidskialf.net, linux1394-devel@lists.sourceforge.net, James.Bottomley@steeleye.com, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

scsi: dont allow DMA_TO_DEVICE with zero data length

When preparing a request in scsi_lib or in a SCSI high-level driver,
always set a transfer direction of DMA_NONE if data length is zero,
even for alleged write requests. (Extended patch derived from Jens
Axboe's version.)

Write requests with request buffer length == 0 lead to kernel panic
or oops if channeled through sbp2:
http://marc.theaimsgroup.com/?l=linux1394-devel&m=113399994920181
http://marc.theaimsgroup.com/?l=linux1394-user&m=112152701817435

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

---
 drivers/scsi/scsi_lib.c |    8 ++++----
 drivers/scsi/sd.c       |    8 ++++----
 drivers/scsi/st.c       |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -uprN -X linux/Documentation/dontdiff linux/drivers/scsi.orig/scsi_lib.c linux/drivers/scsi/scsi_lib.c
--- linux/drivers/scsi.orig/scsi_lib.c	2005-11-24 23:10:21.000000000 +0100
+++ linux/drivers/scsi/scsi_lib.c	2005-12-09 20:11:59.000000000 +0100
@@ -1266,12 +1266,12 @@ static int scsi_prep_fn(struct request_q
 		} else {
 			memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
 			cmd->cmd_len = req->cmd_len;
-			if (rq_data_dir(req) == WRITE)
+			if (!req->data_len)
+				cmd->sc_data_direction = DMA_NONE;
+			else if (rq_data_dir(req) == WRITE)
 				cmd->sc_data_direction = DMA_TO_DEVICE;
-			else if (req->data_len)
-				cmd->sc_data_direction = DMA_FROM_DEVICE;
 			else
-				cmd->sc_data_direction = DMA_NONE;
+				cmd->sc_data_direction = DMA_FROM_DEVICE;
 			
 			cmd->transfersize = req->data_len;
 			cmd->allowed = 3;
diff -uprN -X linux/Documentation/dontdiff linux/drivers/scsi.orig/sd.c linux/drivers/scsi/sd.c
--- linux/drivers/scsi.orig/sd.c	2005-11-24 23:10:21.000000000 +0100
+++ linux/drivers/scsi/sd.c	2005-12-09 20:13:12.000000000 +0100
@@ -236,12 +236,12 @@ static int sd_init_command(struct scsi_c
 
 		memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
 		SCpnt->cmd_len = rq->cmd_len;
-		if (rq_data_dir(rq) == WRITE)
+		if (!rq->data_len)
+			SCpnt->sc_data_direction = DMA_NONE;
+		else if (rq_data_dir(rq) == WRITE)
 			SCpnt->sc_data_direction = DMA_TO_DEVICE;
-		else if (rq->data_len)
-			SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 		else
-			SCpnt->sc_data_direction = DMA_NONE;
+			SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 
 		this_count = rq->data_len;
 		if (rq->timeout)
diff -uprN -X linux/Documentation/dontdiff linux/drivers/scsi.orig/st.c linux/drivers/scsi/st.c
--- linux/drivers/scsi.orig/st.c	2005-11-24 23:10:21.000000000 +0100
+++ linux/drivers/scsi/st.c	2005-12-09 20:14:29.000000000 +0100
@@ -4208,12 +4208,12 @@ static int st_init_command(struct scsi_c
 	memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
 	SCpnt->cmd_len = rq->cmd_len;
 
-	if (rq_data_dir(rq) == WRITE)
+	if (!rq->data_len)
+		SCpnt->sc_data_direction = DMA_NONE;
+	else if (rq_data_dir(rq) == WRITE)
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
-	else if (rq->data_len)
-		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	else
-		SCpnt->sc_data_direction = DMA_NONE;
+		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 
 	SCpnt->timeout_per_command = rq->timeout;
 	SCpnt->transfersize = rq->data_len;




-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
