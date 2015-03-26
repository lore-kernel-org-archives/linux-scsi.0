From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [V2 PATCH 03/11] aacraid: 4KB sector support
Date: Thu, 26 Mar 2015 10:41:24 -0400
Message-ID: <1427380892-1978-4-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37842 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbbCZOrX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2015 10:47:23 -0400
In-Reply-To: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Achim.Leubner@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Add 4KB sector support

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aachba.c  |  240 +++++++++++++++++++++++++++++++--------
 drivers/scsi/aacraid/aacraid.h |   11 ++-
 2 files changed, 200 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index b32e77d..aee3eaa 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -111,6 +111,41 @@
 #define BYTE2(x) (unsigned char)((x) >> 16)
 #define BYTE3(x) (unsigned char)((x) >> 24)
 
+/* MODE_SENSE data format */
+typedef struct {
+	struct {
+		u8	data_length;
+		u8	med_type;
+		u8	dev_par;
+		u8	bd_length;
+	} __attribute__((packed)) hd;
+	struct {
+		u8	dens_code;
+		u8	block_count[3];
+		u8	reserved;
+		u8	block_length[3];
+	} __attribute__((packed)) bd;
+		u8	mpc_buf[3];
+} __attribute__((packed)) aac_modep_data;
+
+/* MODE_SENSE_10 data format */
+typedef struct {
+	struct {
+		u8	data_length[2];
+		u8	med_type;
+		u8	dev_par;
+		u8	rsrvd[2];
+		u8	bd_length[2];
+	} __attribute__((packed)) hd;
+	struct {
+		u8	dens_code;
+		u8	block_count[3];
+		u8	reserved;
+		u8	block_length[3];
+	} __attribute__((packed)) bd;
+		u8	mpc_buf[3];
+} __attribute__((packed)) aac_modep10_data;
+
 /*------------------------------------------------------------------------------
  *              S T R U C T S / T Y P E D E F S
  *----------------------------------------------------------------------------*/
@@ -438,7 +473,7 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 	if ((le32_to_cpu(get_name_reply->status) == CT_OK)
 	 && (get_name_reply->data[0] != '\0')) {
 		char *sp = get_name_reply->data;
-		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)-1] = '\0';
+		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)] = '\0';
 		while (*sp == ' ')
 			++sp;
 		if (*sp) {
@@ -539,6 +574,14 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 		if ((le32_to_cpu(dresp->status) == ST_OK) &&
 		    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
 		    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
+			if (!(fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+			    AAC_OPTION_VARIABLE_BLOCK_SIZE)) {
+				dresp->mnt[0].fileinfo.bdevinfo.block_size = 0x200;
+				fsa_dev_ptr->block_size = 0x200;
+			} else {
+				fsa_dev_ptr->block_size =
+					le32_to_cpu(dresp->mnt[0].fileinfo.bdevinfo.block_size);
+			}
 			fsa_dev_ptr->valid = 1;
 			/* sense_key holds the current state of the spin-up */
 			if (dresp->mnt[0].state & cpu_to_le32(FSCS_NOT_READY))
@@ -571,7 +614,9 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 	int status;
 
 	dresp = (struct aac_mount *) fib_data(fibptr);
-	dresp->mnt[0].capacityhigh = 0;
+	if (!(fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+	    AAC_OPTION_VARIABLE_BLOCK_SIZE))
+		dresp->mnt[0].capacityhigh = 0;
 	if ((le32_to_cpu(dresp->status) != ST_OK) ||
 	    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE)) {
 		_aac_probe_container2(context, fibptr);
@@ -586,7 +631,12 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 
 	dinfo = (struct aac_query_mount *)fib_data(fibptr);
 
-	dinfo->command = cpu_to_le32(VM_NameServe64);
+	if (fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+	    AAC_OPTION_VARIABLE_BLOCK_SIZE)
+		dinfo->command = cpu_to_le32(VM_NameServeAllBlk);
+	else
+		dinfo->command = cpu_to_le32(VM_NameServe64);
+
 	dinfo->count = cpu_to_le32(scmd_id(scsicmd));
 	dinfo->type = cpu_to_le32(FT_FILESYS);
 
@@ -621,7 +671,12 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(stru
 
 		dinfo = (struct aac_query_mount *)fib_data(fibptr);
 
-		dinfo->command = cpu_to_le32(VM_NameServe);
+		if (fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+		    AAC_OPTION_VARIABLE_BLOCK_SIZE)
+			dinfo->command = cpu_to_le32(VM_NameServeAllBlk);
+		else
+			dinfo->command = cpu_to_le32(VM_NameServe);
+
 		dinfo->count = cpu_to_le32(scmd_id(scsicmd));
 		dinfo->type = cpu_to_le32(FT_FILESYS);
 		scsicmd->SCp.ptr = (char *)callback;
@@ -982,7 +1037,8 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 		memset(readcmd2, 0, sizeof(struct aac_raw_io2));
 		readcmd2->blockLow = cpu_to_le32((u32)(lba&0xffffffff));
 		readcmd2->blockHigh = cpu_to_le32((u32)((lba&0xffffffff00000000LL)>>32));
-		readcmd2->byteCount = cpu_to_le32(count<<9);
+		readcmd2->byteCount = cpu_to_le32(count *
+			dev->fsa_dev[scmd_id(cmd)].block_size);
 		readcmd2->cid = cpu_to_le16(scmd_id(cmd));
 		readcmd2->flags = cpu_to_le16(RIO2_IO_TYPE_READ);
 		ret = aac_build_sgraw2(cmd, readcmd2,
@@ -997,7 +1053,8 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 		readcmd = (struct aac_raw_io *) fib_data(fib);
 		readcmd->block[0] = cpu_to_le32((u32)(lba&0xffffffff));
 		readcmd->block[1] = cpu_to_le32((u32)((lba&0xffffffff00000000LL)>>32));
-		readcmd->count = cpu_to_le32(count<<9);
+		readcmd->count = cpu_to_le32(count *
+			dev->fsa_dev[scmd_id(cmd)].block_size);
 		readcmd->cid = cpu_to_le16(scmd_id(cmd));
 		readcmd->flags = cpu_to_le16(RIO_TYPE_READ);
 		readcmd->bpTotal = 0;
@@ -1062,6 +1119,7 @@ static int aac_read_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32
 {
 	u16 fibsize;
 	struct aac_read *readcmd;
+	struct aac_dev *dev = fib->dev;
 	long ret;
 
 	aac_fib_init(fib);
@@ -1069,7 +1127,8 @@ static int aac_read_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32
 	readcmd->command = cpu_to_le32(VM_CtBlockRead);
 	readcmd->cid = cpu_to_le32(scmd_id(cmd));
 	readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
-	readcmd->count = cpu_to_le32(count * 512);
+	readcmd->count = cpu_to_le32(count *
+		dev->fsa_dev[scmd_id(cmd)].block_size);
 
 	ret = aac_build_sg(cmd, &readcmd->sg);
 	if (ret < 0)
@@ -1104,7 +1163,8 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 		memset(writecmd2, 0, sizeof(struct aac_raw_io2));
 		writecmd2->blockLow = cpu_to_le32((u32)(lba&0xffffffff));
 		writecmd2->blockHigh = cpu_to_le32((u32)((lba&0xffffffff00000000LL)>>32));
-		writecmd2->byteCount = cpu_to_le32(count<<9);
+		writecmd2->byteCount = cpu_to_le32(count *
+			dev->fsa_dev[scmd_id(cmd)].block_size);
 		writecmd2->cid = cpu_to_le16(scmd_id(cmd));
 		writecmd2->flags = (fua && ((aac_cache & 5) != 1) &&
 						   (((aac_cache & 5) != 5) || !fib->dev->cache_protected)) ?
@@ -1122,7 +1182,8 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 		writecmd = (struct aac_raw_io *) fib_data(fib);
 		writecmd->block[0] = cpu_to_le32((u32)(lba&0xffffffff));
 		writecmd->block[1] = cpu_to_le32((u32)((lba&0xffffffff00000000LL)>>32));
-		writecmd->count = cpu_to_le32(count<<9);
+		writecmd->count = cpu_to_le32(count *
+			dev->fsa_dev[scmd_id(cmd)].block_size);
 		writecmd->cid = cpu_to_le16(scmd_id(cmd));
 		writecmd->flags = (fua && ((aac_cache & 5) != 1) &&
 						   (((aac_cache & 5) != 5) || !fib->dev->cache_protected)) ?
@@ -1190,6 +1251,7 @@ static int aac_write_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 {
 	u16 fibsize;
 	struct aac_write *writecmd;
+	struct aac_dev *dev = fib->dev;
 	long ret;
 
 	aac_fib_init(fib);
@@ -1197,7 +1259,8 @@ static int aac_write_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 	writecmd->command = cpu_to_le32(VM_CtBlockWrite);
 	writecmd->cid = cpu_to_le32(scmd_id(cmd));
 	writecmd->block = cpu_to_le32((u32)(lba&0xffffffff));
-	writecmd->count = cpu_to_le32(count * 512);
+	writecmd->count = cpu_to_le32(count *
+		dev->fsa_dev[scmd_id(cmd)].block_size);
 	writecmd->sg.count = cpu_to_le32(1);
 	/* ->stable is not used - it did mean which type of write */
 
@@ -2329,10 +2392,10 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		cp[5] = (capacity >> 16) & 0xff;
 		cp[6] = (capacity >> 8) & 0xff;
 		cp[7] = (capacity >> 0) & 0xff;
-		cp[8] = 0;
-		cp[9] = 0;
-		cp[10] = 2;
-		cp[11] = 0;
+		cp[8] = (fsa_dev_ptr[cid].block_size >> 24) & 0xff;
+		cp[9] = (fsa_dev_ptr[cid].block_size >> 16) & 0xff;
+		cp[10] = (fsa_dev_ptr[cid].block_size >> 8) & 0xff;
+		cp[11] = (fsa_dev_ptr[cid].block_size) & 0xff;
 		cp[12] = 0;
 
 		alloc_len = ((scsicmd->cmnd[10] << 24)
@@ -2369,10 +2432,10 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		cp[1] = (capacity >> 16) & 0xff;
 		cp[2] = (capacity >> 8) & 0xff;
 		cp[3] = (capacity >> 0) & 0xff;
-		cp[4] = 0;
-		cp[5] = 0;
-		cp[6] = 2;
-		cp[7] = 0;
+		cp[4] = (fsa_dev_ptr[cid].block_size >> 24) & 0xff;
+		cp[5] = (fsa_dev_ptr[cid].block_size >> 16) & 0xff;
+		cp[6] = (fsa_dev_ptr[cid].block_size >> 8) & 0xff;
+		cp[7] = (fsa_dev_ptr[cid].block_size) & 0xff;
 		scsi_sg_copy_from_buffer(scsicmd, cp, sizeof(cp));
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;
@@ -2385,30 +2448,64 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 
 	case MODE_SENSE:
 	{
-		char mode_buf[7];
 		int mode_buf_length = 4;
+		u32 capacity;
+		aac_modep_data mpd;
+
+		if (fsa_dev_ptr[cid].size <= 0x100000000ULL)
+			capacity = fsa_dev_ptr[cid].size - 1;
+		else
+			capacity = (u32)-1;
 
 		dprintk((KERN_DEBUG "MODE SENSE command.\n"));
-		mode_buf[0] = 3;	/* Mode data length */
-		mode_buf[1] = 0;	/* Medium type - default */
-		mode_buf[2] = 0;	/* Device-specific param,
-					   bit 8: 0/1 = write enabled/protected
-					   bit 4: 0/1 = FUA enabled */
+		memset((char *)&mpd, 0, sizeof(aac_modep_data));
+
+		/* Mode data length */
+		mpd.hd.data_length = sizeof(mpd.hd) - 1;
+		/* Medium type - default */
+		mpd.hd.med_type = 0;
+		/* Device-specific param,
+		   bit 8: 0/1 = write enabled/protected
+		   bit 4: 0/1 = FUA enabled */
+		mpd.hd.dev_par = 0;
+
 		if (dev->raw_io_interface && ((aac_cache & 5) != 1))
-			mode_buf[2] = 0x10;
-		mode_buf[3] = 0;	/* Block descriptor length */
+			mpd.hd.dev_par = 0x10;
+		if (scsicmd->cmnd[1] & 0x8)
+			mpd.hd.bd_length = 0;	/* Block descriptor length */
+		else {
+			mpd.hd.bd_length = sizeof(mpd.bd);
+			mpd.hd.data_length += mpd.hd.bd_length;
+			mpd.bd.block_length[0] =
+				(fsa_dev_ptr[cid].block_size >> 16) & 0xff;
+			mpd.bd.block_length[1] =
+				(fsa_dev_ptr[cid].block_size >> 8) &  0xff;
+			mpd.bd.block_length[2] =
+				fsa_dev_ptr[cid].block_size  & 0xff;
+			if (capacity > 0xffffff) {
+				mpd.bd.block_count[0] = 0xff;
+				mpd.bd.block_count[1] = 0xff;
+				mpd.bd.block_count[2] = 0xff;
+			} else {
+				mpd.bd.block_count[0] = (capacity >> 16) & 0xff;
+				mpd.bd.block_count[1] = (capacity >> 8) & 0xff;
+				mpd.bd.block_count[2] = capacity  & 0xff;
+			}
+		}
 		if (((scsicmd->cmnd[2] & 0x3f) == 8) ||
 		  ((scsicmd->cmnd[2] & 0x3f) == 0x3f)) {
-			mode_buf[0] = 6;
-			mode_buf[4] = 8;
-			mode_buf[5] = 1;
-			mode_buf[6] = ((aac_cache & 6) == 2)
+			mpd.hd.data_length += 3;
+			mpd.mpc_buf[0] = 8;
+			mpd.mpc_buf[1] = 1;
+			mpd.mpc_buf[2] = ((aac_cache & 6) == 2)
 				? 0 : 0x04; /* WCE */
-			mode_buf_length = 7;
+			mode_buf_length = sizeof(mpd);
 			if (mode_buf_length > scsicmd->cmnd[4])
 				mode_buf_length = scsicmd->cmnd[4];
 		}
-		scsi_sg_copy_from_buffer(scsicmd, mode_buf, mode_buf_length);
+		scsi_sg_copy_from_buffer(scsicmd,
+					 (char *)&mpd,
+					 mode_buf_length);
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
 
@@ -2416,34 +2513,77 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	}
 	case MODE_SENSE_10:
 	{
-		char mode_buf[11];
+		u32 capacity;
 		int mode_buf_length = 8;
+		aac_modep10_data mpd10;
+
+		if (fsa_dev_ptr[cid].size <= 0x100000000ULL)
+			capacity = fsa_dev_ptr[cid].size - 1;
+		else
+			capacity = (u32)-1;
 
 		dprintk((KERN_DEBUG "MODE SENSE 10 byte command.\n"));
-		mode_buf[0] = 0;	/* Mode data length (MSB) */
-		mode_buf[1] = 6;	/* Mode data length (LSB) */
-		mode_buf[2] = 0;	/* Medium type - default */
-		mode_buf[3] = 0;	/* Device-specific param,
-					   bit 8: 0/1 = write enabled/protected
-					   bit 4: 0/1 = FUA enabled */
+		memset((char *)&mpd10, 0, sizeof(aac_modep10_data));
+		/* Mode data length (MSB) */
+		mpd10.hd.data_length[0] = 0;
+		/* Mode data length (LSB) */
+		mpd10.hd.data_length[1] = sizeof(mpd10.hd) - 1;
+		/* Medium type - default */
+		mpd10.hd.med_type = 0;
+		/* Device-specific param,
+		   bit 8: 0/1 = write enabled/protected
+		   bit 4: 0/1 = FUA enabled */
+		mpd10.hd.dev_par = 0;
+
 		if (dev->raw_io_interface && ((aac_cache & 5) != 1))
-			mode_buf[3] = 0x10;
-		mode_buf[4] = 0;	/* reserved */
-		mode_buf[5] = 0;	/* reserved */
-		mode_buf[6] = 0;	/* Block descriptor length (MSB) */
-		mode_buf[7] = 0;	/* Block descriptor length (LSB) */
+			mpd10.hd.dev_par = 0x10;
+		mpd10.hd.rsrvd[0] = 0;	/* reserved */
+		mpd10.hd.rsrvd[1] = 0;	/* reserved */
+		if (scsicmd->cmnd[1] & 0x8) {
+			/* Block descriptor length (MSB) */
+			mpd10.hd.bd_length[0] = 0;
+			/* Block descriptor length (LSB) */
+			mpd10.hd.bd_length[1] = 0;
+		} else {
+			mpd10.hd.bd_length[0] = 0;
+			mpd10.hd.bd_length[1] = sizeof(mpd10.bd);
+
+			mpd10.hd.data_length[1] += mpd10.hd.bd_length[1];
+
+			mpd10.bd.block_length[0] =
+				(fsa_dev_ptr[cid].block_size >> 16) & 0xff;
+			mpd10.bd.block_length[1] =
+				(fsa_dev_ptr[cid].block_size >> 8) & 0xff;
+			mpd10.bd.block_length[2] =
+				fsa_dev_ptr[cid].block_size  & 0xff;
+
+			if (capacity > 0xffffff) {
+				mpd10.bd.block_count[0] = 0xff;
+				mpd10.bd.block_count[1] = 0xff;
+				mpd10.bd.block_count[2] = 0xff;
+			} else {
+				mpd10.bd.block_count[0] =
+					(capacity >> 16) & 0xff;
+				mpd10.bd.block_count[1] =
+					(capacity >> 8) & 0xff;
+				mpd10.bd.block_count[2] =
+					capacity  & 0xff;
+			}
+		}
 		if (((scsicmd->cmnd[2] & 0x3f) == 8) ||
 		  ((scsicmd->cmnd[2] & 0x3f) == 0x3f)) {
-			mode_buf[1] = 9;
-			mode_buf[8] = 8;
-			mode_buf[9] = 1;
-			mode_buf[10] = ((aac_cache & 6) == 2)
+			mpd10.hd.data_length[1] += 3;
+			mpd10.mpc_buf[0] = 8;
+			mpd10.mpc_buf[1] = 1;
+			mpd10.mpc_buf[2] = ((aac_cache & 6) == 2)
 				? 0 : 0x04; /* WCE */
-			mode_buf_length = 11;
+			mode_buf_length = sizeof(mpd10);
 			if (mode_buf_length > scsicmd->cmnd[8])
 				mode_buf_length = scsicmd->cmnd[8];
 		}
-		scsi_sg_copy_from_buffer(scsicmd, mode_buf, mode_buf_length);
+		scsi_sg_copy_from_buffer(scsicmd,
+					 (char *)&mpd10,
+					 mode_buf_length);
 
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 284db39..9e38b20 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -857,6 +857,7 @@ struct fsa_dev_info {
 	u8		deleted;
 	char		devname[8];
 	struct sense_data sense_data;
+	u32		block_size;
 };
 
 struct fib {
@@ -960,6 +961,8 @@ struct aac_supplement_adapter_info
 #define AAC_OPTION_IGNORE_RESET		cpu_to_le32(0x00000002)
 #define AAC_OPTION_POWER_MANAGEMENT	cpu_to_le32(0x00000004)
 #define AAC_OPTION_DOORBELL_RESET	cpu_to_le32(0x00004000)
+/* 4KB sector size */
+#define AAC_OPTION_VARIABLE_BLOCK_SIZE	cpu_to_le32(0x00040000)
 #define AAC_SIS_VERSION_V3	3
 #define AAC_SIS_SLOT_UNKNOWN	0xFF
 
@@ -1589,6 +1592,7 @@ struct aac_srb_reply
 #define		VM_CtHostWrite64	20
 #define		VM_DrvErrTblLog		21
 #define		VM_NameServe64		22
+#define		VM_NameServeAllBlk	30
 
 #define		MAX_VMCOMMAND_NUM	23	/* used for sizing stats array - leave last */
 
@@ -1611,8 +1615,13 @@ struct aac_fsinfo {
 	__le32  fsInodeDensity;
 };	/* valid iff ObjType == FT_FILESYS && !(ContentState & FSCS_NOTCLEAN) */
 
+struct  aac_blockdevinfo {
+	__le32	block_size;
+};
+
 union aac_contentinfo {
-	struct aac_fsinfo filesys;	/* valid iff ObjType == FT_FILESYS && !(ContentState & FSCS_NOTCLEAN) */
+	struct	aac_fsinfo		filesys;
+	struct	aac_blockdevinfo	bdevinfo;
 };
 
 /*
-- 
1.7.7.3

