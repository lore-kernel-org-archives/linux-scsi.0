From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/5] libata: Report zeroed read after Trim and max discard size
Date: Thu, 26 Nov 2009 22:46:03 -0500
Message-ID: <yq18wds3a10.fsf@sermon.lab.mkp.net>
References: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>
	<1259254843-8326-5-git-send-email-martin.petersen@oracle.com>
	<4B0F3186.6000903@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4B0F3186.6000903@teksavvy.com> (Mark Lord's message of "Thu, 26
	Nov 2009 20:55:18 -0500")
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:

Mark> Is that correct, or should it be this:

Mark>        if (ata_id_has_trim(id) && (id[ATA_ID_ADDITIONAL_SUPP] &
Mark>        0x4020) == 0x4020)

Good spotting!  You are right, I need both bits to be set...


libata: Report zeroed read after Trim and max discard size

Our current Trim payload is a single sector that can accommodate 64 *
65535 blocks being unmapped.  Report this value in the Block Limits
Maximum Unmap LBA count field.

If a storage device supports Trim and the DRAT and RZAT bits are set,
report TPRZ=1 in Read Capacity(16).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e0995c4..08d4ab7 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2116,8 +2116,10 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	 * that we support some form of unmap - in thise case via WRITE SAME
 	 * with the unmap bit set.
 	 */
-	if (ata_id_has_trim(args->id))
+	if (ata_id_has_trim(args->id)) {
+		put_unaligned_be32(65535 * 512 / 8, &rbuf[20]);
 		put_unaligned_be32(1, &rbuf[28]);
+	}
 
 	return 0;
 }
@@ -2412,8 +2414,12 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		rbuf[14] = (lowest_aligned >> 8) & 0x3f;
 		rbuf[15] = lowest_aligned;
 
-		if (ata_id_has_trim(args->id))
-			rbuf[14] |= 0x80;
+		if (ata_id_has_trim(args->id)) {
+			rbuf[14] |= 0x80; /* TPE */
+
+			if (ata_id_has_zero_after_trim(args->id))
+				rbuf[14] |= 0x40; /* TPRZ */
+		}
 	}
 
 	return 0;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index e2595e8..dfa2298 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -75,6 +75,7 @@ enum {
 	ATA_ID_EIDE_DMA_TIME	= 66,
 	ATA_ID_EIDE_PIO		= 67,
 	ATA_ID_EIDE_PIO_IORDY	= 68,
+	ATA_ID_ADDITIONAL_SUPP	= 69,
 	ATA_ID_QUEUE_DEPTH	= 75,
 	ATA_ID_MAJOR_VER	= 80,
 	ATA_ID_COMMAND_SET_1	= 82,
@@ -816,6 +817,16 @@ static inline int ata_id_has_trim(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_has_zero_after_trim(const u16 *id)
+{
+	/* DSM supported, deterministic read, and read zero after trim set */
+	if (ata_id_has_trim(id) &&
+	    (id[ATA_ID_ADDITIONAL_SUPP] & 0x4020) == 0x4020)
+		return 1;
+
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
