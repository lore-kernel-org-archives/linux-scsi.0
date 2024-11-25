Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC31A376E0
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 14:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732543421; cv=none; b=HvpklxwkDCTNR/irnmcanj6eIdTf2pA1K2W8DxVsaolIvt+qq+o8sSogVHQU0eSzhaGNVwwHFuxaRBaxH/WmVMLqTm2zGFOkNXB7ZXksfJiJrb6XTzhtjb/9i55VopU8D8TW1am2NDZB4JbOYW5Cl1NGmr2av2oCipuc4P0Y4Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732543421; c=relaxed/simple;
	bh=xdVsFpk78aVyLxBrTCMaTBWrqjHFfXeYjpqnbg2DY+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qsE8P3Ruri8BobY8qX4HSWvWR0HGizvRlZziDMTD+/s8c2FdiUGKwUQ3MRddgBC4h1JnSAXQyVDpqutK/XBHneeVeU2AZXvGZ7sAWrX3O7Swd7KOsm1TDrXP6R4XcLT2C7VGJyFDL3TnAScSm9FE8T7zT3edUX+vu+AQAyLMijE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=tfX8VrEw; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="tfX8VrEw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=qM72bWVvmIeEbt3irAHb3j16yFGCfq336oGxPw2oDZE=;
	b=tfX8VrEw8lSC+0WobCWOu2N40BFcP5KtDwRufA+lXdaxqFcUiruvk4aKFw0l1bZKaKZAC936acVZ4
	 sjTa86Qi0jQ8iX9diDduOIbYhpmuQ8G84tGJ7n9Uxj9XmUU5bsGnf1rEn/HHFDUEdperDYZUkIpFyR
	 PCV4MEeBysJ7PaqOpL7rg1tVxcVL0mXLeurHSTeoptakTaH32EooatdWWZvIirRjKnYu88VBRTNc+8
	 ZvEEOfUKsmVnnX5PH6+g/lehMb1u5aERmbDsMs4t11dWFqHnffal+/YSMt94W5jYThiqSAS/utR69m
	 FsrI7ExGxGHP+QepxdEwKaEjDoN3fhA==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 0135e6dc-ab36-11ef-8882-005056bdd08f;
	Mon, 25 Nov 2024 16:03:10 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 1/4] scsi: st: Restore some drive settings after reset
Date: Mon, 25 Nov 2024 16:02:58 +0200
Message-ID: <20241125140301.3912-2-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Some of the allowed operations put the tape into a known position
to continue operation assuming only the tape position has changed.
But reset sets partition, density and block size to drive default
values. These should be restored to the values before reset.

Normally the current block size and density are stored by the drive.
If the settings have been changed, the changed values have to be
saved by the driver across reset.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/st.c | 26 +++++++++++++++++++++-----
 drivers/scsi/st.h |  2 ++
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e8ef27d7ef61..a0667a0ae4c9 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -952,7 +952,6 @@ static void reset_state(struct scsi_tape *STp)
 		STp->partition = find_partition(STp);
 		if (STp->partition < 0)
 			STp->partition = 0;
-		STp->new_partition = STp->partition;
 	}
 }
 
@@ -2925,14 +2924,17 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		if (cmd_in == MTSETDENSITY) {
 			(STp->buffer)->b_data[4] = arg;
 			STp->density_changed = 1;	/* At least we tried ;-) */
+			STp->changed_density = arg;
 		} else if (cmd_in == SET_DENS_AND_BLK)
 			(STp->buffer)->b_data[4] = arg >> 24;
 		else
 			(STp->buffer)->b_data[4] = STp->density;
 		if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) {
 			ltmp = arg & MT_ST_BLKSIZE_MASK;
-			if (cmd_in == MTSETBLK)
+			if (cmd_in == MTSETBLK) {
 				STp->blksize_changed = 1; /* At least we tried ;-) */
+				STp->changed_blksize = arg;
+			}
 		} else
 			ltmp = STp->block_size;
 		(STp->buffer)->b_data[9] = (ltmp >> 16);
@@ -3631,9 +3633,23 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 				retval = (-EIO);
 				goto out;
 			}
-			reset_state(STp);
-			/* remove this when the midlevel properly clears was_reset */
-			STp->device->was_reset = 0;
+			reset_state(STp); /* Clears pos_unknown */
+
+			/* Fix the device settings after reset, ignore errors */
+			if (mtc.mt_op == MTREW || mtc.mt_op == MTSEEK ||
+				mtc.mt_op == MTEOM) {
+				if (STp->can_partitions) {
+					/* STp->new_partition contains the
+					 *  latest partition set
+					 */
+					STp->partition = 0;
+					switch_partition(STp);
+				}
+				if (STp->density_changed)
+					st_int_ioctl(STp, MTSETDENSITY, STp->changed_density);
+				if (STp->blksize_changed)
+					st_int_ioctl(STp, MTSETBLK, STp->changed_blksize);
+			}
 		}
 
 		if (mtc.mt_op != MTNOP && mtc.mt_op != MTSETBLK &&
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 7a68eaba7e81..2105c6a5b458 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -165,12 +165,14 @@ struct scsi_tape {
 	unsigned char compression_changed;
 	unsigned char drv_buffer;
 	unsigned char density;
+	unsigned char changed_density;
 	unsigned char door_locked;
 	unsigned char autorew_dev;   /* auto-rewind device */
 	unsigned char rew_at_close;  /* rewind necessary at close */
 	unsigned char inited;
 	unsigned char cleaning_req;  /* cleaning requested? */
 	int block_size;
+	int changed_blksize;
 	int min_block;
 	int max_block;
 	int recover_count;     /* From tape opening */
-- 
2.43.0

