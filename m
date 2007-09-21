From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] libata: clean up R/W recovery mode page
Date: Fri, 21 Sep 2007 07:55:25 -0400
Message-ID: <20070921115525.GA22118@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


commit 14052d9ba16b826e4bc79db4b2b77e451faf0b01
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Sep 21 07:54:49 2007 -0400

    [libata] SCSI: clean up R/W recovery mode page
    
    Clear ARRE, we don't do auto-reallocation on reads, just on writes.
    
    Also, hardcode the size of the array using RW_RECOVERY_MPAGE_LEN,
    following the style of the surrounding code.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/libata-scsi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

14052d9ba16b826e4bc79db4b2b77e451faf0b01
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index cd192c1..29e2cf6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -71,11 +71,10 @@ static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 #define ALL_SUB_MPAGES 0xff
 
 
-static const u8 def_rw_recovery_mpage[] = {
+static const u8 def_rw_recovery_mpage[RW_RECOVERY_MPAGE_LEN] = {
 	RW_RECOVERY_MPAGE,
 	RW_RECOVERY_MPAGE_LEN - 2,
-	(1 << 7) |	/* AWRE, sat-r06 say it shall be 0 */
-	    (1 << 6),	/* ARRE (auto read reallocation) */
+	(1 << 7),	/* AWRE */
 	0,		/* read retry count */
 	0, 0, 0, 0,
 	0,		/* write retry count */
