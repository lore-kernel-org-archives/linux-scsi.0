From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 34/41] scsi: osst: mark expected switch fall-throughs
Date: Tue, 27 Nov 2018 22:33:04 -0600
Message-ID: <c4e37b918b0e3aa338406b7adea6c2e9760b360b.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Willem Riede <osst@riede.org>, osst-users@lists.sourceforge.net
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114983 ("Missing break in switch")
Addresses-Coverity-ID: 114984 ("Missing break in switch")
Addresses-Coverity-ID: 114985 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/osst.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 664c1238a87f..7e877b43785d 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -216,12 +216,14 @@ static void osst_analyze_sense(struct osst_request *SRpnt, struct st_cmdstatus *
 		switch (sense[0] & 0x7f) {
 		case 0x71:
 			s->deferred = 1;
+			/* fall through */
 		case 0x70:
 			s->fixed_format = 1;
 			s->flags = sense[2] & 0xe0;
 			break;
 		case 0x73:
 			s->deferred = 1;
+			/* fall through */
 		case 0x72:
 			s->fixed_format = 0;
 			ucp = scsi_sense_desc_find(sense, SCSI_SENSE_BUFFERSIZE, 4);
@@ -591,6 +593,7 @@ static void osst_init_aux(struct osst_tape * STp, int frame_type, int frame_seq_
 		dat->dat_list[0].flags    = frame_type==OS_FRAME_TYPE_MARKER?
 							OS_DAT_FLAGS_MARK:OS_DAT_FLAGS_DATA;
 		dat->dat_list[0].reserved = 0;
+		/* fall through */
 	  case	OS_FRAME_TYPE_EOD:
 		aux->update_frame_cntr    = htonl(0);
 		par->partition_num        = OS_DATA_PARTITION;
@@ -4086,6 +4089,7 @@ static int osst_int_ioctl(struct osst_tape * STp, struct osst_request ** aSRpnt,
 	switch (cmd_in) {
 	 case MTFSFM:
 		chg_eof = 0; /* Changed from the FSF after this */
+		/* fall through */
 	 case MTFSF:
 		if (STp->raw)
 		   return (-EIO);
@@ -4101,6 +4105,7 @@ static int osst_int_ioctl(struct osst_tape * STp, struct osst_request ** aSRpnt,
 
 	 case MTBSF:
 		chg_eof = 0; /* Changed from the FSF after this */
+		/* fall through */
 	 case MTBSFM:
 		if (STp->raw)
 		   return (-EIO);
@@ -4312,6 +4317,7 @@ static int osst_int_ioctl(struct osst_tape * STp, struct osst_request ** aSRpnt,
 					   name, STp->block_size);
 			 return 0;
 		 }
+		/* fall through */
 	 case MTSETDENSITY:       /* Set tape density */
 	 case MTSETDRVBUFFER:     /* Set drive buffering */
 	 case SET_DENS_AND_BLK:   /* Set density and block size */
-- 
2.17.1
