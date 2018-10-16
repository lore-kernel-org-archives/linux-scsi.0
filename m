From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v2] scsi: mark expected switch fall-throughs
Date: Tue, 16 Oct 2018 20:13:46 +0200
Message-ID: <20181016181346.GA26469@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Willem Riede <osst@riede.org>, Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, osst-users@lists.sourceforge.net, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 1195463 ("Missing break in switch")
Addresses-Coverity-ID: 1195464 ("Missing break in switch")
Addresses-Coverity-ID: 1195465 ("Missing break in switch")
Addresses-Coverity-ID: 1195466 ("Missing break in switch")
Addresses-Coverity-ID: 114973 ("Missing break in switch")
Addresses-Coverity-ID: 114983 ("Missing break in switch")
Addresses-Coverity-ID: 114984 ("Missing break in switch")
Addresses-Coverity-ID: 114985 ("Missing break in switch")
Addresses-Coverity-ID: 114988 ("Missing break in switch")
Addresses-Coverity-ID: 114994 ("Missing break in switch")
Addresses-Coverity-ID: 114995 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Remove drivers/scsi/ips.c from this patch, as it turned out to be
   an actual bug in that driver. So, a separate patch to address such
   bug has already been sent:
	
	https://lore.kernel.org/patchwork/patch/1000333/

 drivers/scsi/hpsa.c | 5 +++++
 drivers/scsi/osst.c | 6 ++++++
 drivers/scsi/ppa.c  | 1 +
 drivers/scsi/st.c   | 4 ++++
 4 files changed, 16 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f903983..fb6a356 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4662,6 +4662,7 @@ static int fixup_ioaccel_cdb(u8 *cdb, int *cdb_len)
 	case WRITE_6:
 	case WRITE_12:
 		is_write = 1;
+		/* fall through */
 	case READ_6:
 	case READ_12:
 		if (*cdb_len == 6) {
@@ -5092,6 +5093,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 	switch (cmd->cmnd[0]) {
 	case WRITE_6:
 		is_write = 1;
+		/* fall through */
 	case READ_6:
 		first_block = (((cmd->cmnd[1] & 0x1F) << 16) |
 				(cmd->cmnd[2] << 8) |
@@ -5102,6 +5104,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		break;
 	case WRITE_10:
 		is_write = 1;
+		/* fall through */
 	case READ_10:
 		first_block =
 			(((u64) cmd->cmnd[2]) << 24) |
@@ -5114,6 +5117,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		break;
 	case WRITE_12:
 		is_write = 1;
+		/* fall through */
 	case READ_12:
 		first_block =
 			(((u64) cmd->cmnd[2]) << 24) |
@@ -5128,6 +5132,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		break;
 	case WRITE_16:
 		is_write = 1;
+		/* fall through */
 	case READ_16:
 		first_block =
 			(((u64) cmd->cmnd[2]) << 56) |
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 7a1a1ed..8af608d 100644
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
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index ee86a0c..d29999b 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -717,6 +717,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 			}
 			cmd->SCp.phase++;
 		}
+		/* fall through */
 
 	case 2:		/* Phase 2 - We are now talking to the scsi bus */
 		if (!ppa_select(dev, scmd_id(cmd))) {
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 307df2f..f1351ec 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -337,12 +337,14 @@ static void st_analyze_sense(struct st_request *SRpnt, struct st_cmdstatus *s)
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
@@ -2721,6 +2723,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 	switch (cmd_in) {
 	case MTFSFM:
 		chg_eof = 0;	/* Changed from the FSF after this */
+		/* fall through */
 	case MTFSF:
 		cmd[0] = SPACE;
 		cmd[1] = 0x01;	/* Space FileMarks */
@@ -2735,6 +2738,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		break;
 	case MTBSFM:
 		chg_eof = 0;	/* Changed from the FSF after this */
+		/* fall through */
 	case MTBSF:
 		cmd[0] = SPACE;
 		cmd[1] = 0x01;	/* Space FileMarks */
-- 
2.7.4
