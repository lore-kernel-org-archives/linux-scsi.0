From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] wd33c93 updates
Date: 24 Feb 2003 10:40:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1046101213.2288.5.camel@mulgrave>
References: <20030223153007.A9377@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA13844
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2003 07:40:16 -0800
In-Reply-To: <20030223153007.A9377@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2003-02-23 at 09:30, Christoph Hellwig wrote:
> The PC98 folks have some updates in their tree to make the generic
> wd33c93 driver usable in PIO mode, but unfortunately the way they do it
> (include a header specific to their lowlevel driver in wd33c93.c
> conditionally) is rather ugly.

OK much as I dislike looking at driver clean ups, this one stood out. 
We don't need each driver to get the command direction by parsing, the
mid-layer now does it for you.

James

===== drivers/scsi/wd33c93.c 1.8 vs edited =====
--- 1.8/drivers/scsi/wd33c93.c	Sun Feb 23 09:24:23 2003
+++ edited/drivers/scsi/wd33c93.c	Sun Feb 23 13:54:03 2003
@@ -304,44 +304,10 @@
  * will be a DATA_OUT phase with this command, false otherwise.
  * (Thanks to Joerg Dorchain for the research and suggestion.)
  */
-static int
+static inline int
 is_dir_out(Scsi_Cmnd * cmd)
 {
-	switch (cmd->cmnd[0]) {
-	case WRITE_6:
-	case WRITE_10:
-	case WRITE_12:
-	case WRITE_LONG:
-	case WRITE_SAME:
-	case WRITE_BUFFER:
-	case WRITE_VERIFY:
-	case WRITE_VERIFY_12:
-	case COMPARE:
-	case COPY:
-	case COPY_VERIFY:
-	case SEARCH_EQUAL:
-	case SEARCH_HIGH:
-	case SEARCH_LOW:
-	case SEARCH_EQUAL_12:
-	case SEARCH_HIGH_12:
-	case SEARCH_LOW_12:
-	case FORMAT_UNIT:
-	case REASSIGN_BLOCKS:
-	case RESERVE:
-	case MODE_SELECT:
-	case MODE_SELECT_10:
-	case LOG_SELECT:
-	case SEND_DIAGNOSTIC:
-	case CHANGE_DEFINITION:
-	case UPDATE_BLOCK:
-	case SET_WINDOW:
-	case MEDIUM_SCAN:
-	case SEND_VOLUME_TAG:
-	case 0xea:
-		return 1;
-	default:
-		return 0;
-	}
+	return cmd->sc_data_direction == SCSI_DATA_WRITE;
 }
 
 static struct sx_period sx_table[] = {

