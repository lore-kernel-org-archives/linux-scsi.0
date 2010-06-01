From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Usage of scsi_get_lba.
Date: Tue, 1 Jun 2010 18:42:46 +0900
Message-ID: <20100601184214X.fujita.tomonori@lab.ntt.co.jp>
References: <94500BE52867E04AB51827CFE16FC752028F714B9E@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:35279 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757Ab0FAJnA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2010 05:43:00 -0400
In-Reply-To: <94500BE52867E04AB51827CFE16FC752028F714B9E@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya.Prakash@lsi.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, Eric.Moore@lsi.com, Kashyap.Desai@lsi.com

On Tue, 1 Jun 2010 13:25:24 +0530
"Prakash, Sathya" <Sathya.Prakash@lsi.com> wrote:

> I was trying to use scsi_get_lba to get the lba associated with a particular scsi_cmnd. I am able to get proper values when I send I/O through dd or FS. But when I use the sg interface either sg_dd or sg_raw the value I am getting through scsi_get_lba is not matching with the one in the CDB.
> 
> Do we need to have some change in sg module for handling this, or is there anything wrong in the way I access the scsi_get_lba or sending command through sg?
> 
> Any suggestion or help is highly appreciated.

Seems that scsi_get_lba() can't use REQ_TYPE_BLOCK_PC commands (via
sg, bsg, etc) because request->__sector is not set.

We need to parse sc->cmnd like this.

The following scsi_get_transfer_info() is taken from scsi_debug. Some
(like libata) have similar code so it would make sense to convert it
to a library function.


diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a5e885a..5bd697e 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
+#include <scsi/scsi.h>
 
 struct Scsi_Host;
 struct scsi_device;
@@ -264,9 +265,75 @@ static inline unsigned char scsi_get_prot_type(struct scsi_cmnd *scmd)
 	return scmd->prot_type;
 }
 
+static inline void scsi_get_transfer_info(unsigned char *cmd,
+					  unsigned long long *lba, unsigned int *num,
+					  unsigned int *ei_lba)
+{
+	*ei_lba = 0;
+
+	switch (*cmd) {
+	case VARIABLE_LENGTH_CMD:
+		*lba = (u64)cmd[19] | (u64)cmd[18] << 8 |
+			(u64)cmd[17] << 16 | (u64)cmd[16] << 24 |
+			(u64)cmd[15] << 32 | (u64)cmd[14] << 40 |
+			(u64)cmd[13] << 48 | (u64)cmd[12] << 56;
+
+		*ei_lba = (u32)cmd[23] | (u32)cmd[22] << 8 |
+			(u32)cmd[21] << 16 | (u32)cmd[20] << 24;
+
+		*num = (u32)cmd[31] | (u32)cmd[30] << 8 | (u32)cmd[29] << 16 |
+			(u32)cmd[28] << 24;
+		break;
+
+	case WRITE_SAME_16:
+	case WRITE_16:
+	case READ_16:
+		*lba = (u64)cmd[9] | (u64)cmd[8] << 8 |
+			(u64)cmd[7] << 16 | (u64)cmd[6] << 24 |
+			(u64)cmd[5] << 32 | (u64)cmd[4] << 40 |
+			(u64)cmd[3] << 48 | (u64)cmd[2] << 56;
+
+		*num = (u32)cmd[13] | (u32)cmd[12] << 8 | (u32)cmd[11] << 16 |
+			(u32)cmd[10] << 24;
+		break;
+	case WRITE_12:
+	case READ_12:
+		*lba = (u32)cmd[5] | (u32)cmd[4] << 8 | (u32)cmd[3] << 16 |
+			(u32)cmd[2] << 24;
+
+		*num = (u32)cmd[9] | (u32)cmd[8] << 8 | (u32)cmd[7] << 16 |
+			(u32)cmd[6] << 24;
+		break;
+	case WRITE_SAME:
+	case WRITE_10:
+	case READ_10:
+	case XDWRITEREAD_10:
+		*lba = (u32)cmd[5] | (u32)cmd[4] << 8 |	(u32)cmd[3] << 16 |
+			(u32)cmd[2] << 24;
+
+		*num = (u32)cmd[8] | (u32)cmd[7] << 8;
+		break;
+	case WRITE_6:
+	case READ_6:
+		*lba = (u32)cmd[3] | (u32)cmd[2] << 8 |
+			(u32)(cmd[1] & 0x1f) << 16;
+		*num = (0 == cmd[4]) ? 256 : cmd[4];
+		break;
+	default:
+		break;
+	}
+}
+
 static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 {
-	return blk_rq_pos(scmd->request);
+	if (scmd->request->cmd_type == REQ_TYPE_BLOCK_PC) {
+		unsigned long long lba;
+		unsigned int num;
+		unsigned int ei_lba;
+		scsi_get_transfer_info(scmd->cmnd, &lba, &num, &ei_lba);
+		return lba;
+	} else
+		return blk_rq_pos(scmd->request);
 }
 
 static inline unsigned scsi_prot_sg_count(struct scsi_cmnd *cmd)

