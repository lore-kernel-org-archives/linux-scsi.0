From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: On patch "Let scsi_cmnd->cmnd use request->cmd buffer"
Date: Sun, 4 May 2008 14:44:35 +0200 (CEST)
Message-ID: <tkrat.46744b15c43493a1@s5r6.in-berlin.de>
References: <tkrat.5db1d90bfe8d480e@s5r6.in-berlin.de>
	<481DA8EF.3010405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <481DA8EF.3010405@panasas.com>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: sbp2: use correct size of command descriptor block

Boaz Harrosh wrote:
> cmd->cmd_len is now guarantied to be set properly at all cases.
> And some commands you want to support will not be set correctly
> by COMMAND_SIZE().

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -1539,15 +1539,13 @@ static void sbp2_prep_command_orb_sg(str
 
 static void sbp2_create_command_orb(struct sbp2_lu *lu,
 				    struct sbp2_command_info *cmd,
-				    unchar *scsi_cmd,
-				    unsigned int scsi_use_sg,
-				    unsigned int scsi_request_bufflen,
-				    struct scatterlist *sg,
-				    enum dma_data_direction dma_dir)
+				    struct scsi_cmnd *SCpnt)
 {
 	struct sbp2_fwhost_info *hi = lu->hi;
 	struct sbp2_command_orb *orb = &cmd->command_orb;
 	u32 orb_direction;
+	unsigned int scsi_request_bufflen = scsi_bufflen(SCpnt);
+	enum dma_data_direction dma_dir = SCpnt->sc_data_direction;
 
 	/*
 	 * Set-up our command ORB.
@@ -1580,13 +1578,14 @@ static void sbp2_create_command_orb(stru
 		orb->data_descriptor_lo = 0x0;
 		orb->misc |= ORB_SET_DIRECTION(1);
 	} else
-		sbp2_prep_command_orb_sg(orb, hi, cmd, scsi_use_sg, sg,
+		sbp2_prep_command_orb_sg(orb, hi, cmd, scsi_sg_count(SCpnt),
+					 scsi_sglist(SCpnt),
 					 orb_direction, dma_dir);
 
 	sbp2util_cpu_to_be32_buffer(orb, sizeof(*orb));
 
 	memset(orb->cdb, 0, 12);
-	memcpy(orb->cdb, scsi_cmd, COMMAND_SIZE(*scsi_cmd));
+	memcpy(orb->cdb, SCpnt->cmnd, SCpnt->cmd_len);
 }
 
 static void sbp2_link_orb_command(struct sbp2_lu *lu,
@@ -1669,16 +1668,13 @@ static void sbp2_link_orb_command(struct
 static int sbp2_send_command(struct sbp2_lu *lu, struct scsi_cmnd *SCpnt,
 			     void (*done)(struct scsi_cmnd *))
 {
-	unchar *scsi_cmd = (unchar *)SCpnt->cmnd;
 	struct sbp2_command_info *cmd;
 
 	cmd = sbp2util_allocate_command_orb(lu, SCpnt, done);
 	if (!cmd)
 		return -EIO;
 
-	sbp2_create_command_orb(lu, cmd, scsi_cmd, scsi_sg_count(SCpnt),
-				scsi_bufflen(SCpnt), scsi_sglist(SCpnt),
-				SCpnt->sc_data_direction);
+	sbp2_create_command_orb(lu, cmd, SCpnt);
 	sbp2_link_orb_command(lu, cmd);
 
 	return 0;

-- 
Stefan Richter
-=====-==--- -=-= --=--
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
Don't miss this year's exciting event. There's still time to save $100. 
Use priority code J8TL2D2. 
http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
