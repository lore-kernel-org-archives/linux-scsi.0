Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64D11D47A0
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731687652; cv=none; b=std3R/xGwsnnpb3QtJd+CTnHsSAIxXveTxwvdqz6r6oy8fpRqBCy/jBE94upAiQLz6y7y4xSAUy2nSsWczVaMsybCLZS6JZI1JyA8GyHcT2MqN1DDe80SWeq8p7pX+PpsR9LlWRSayz/XUcBOhOV5FSVIAWUPXAj/BvyCXwe1Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731687652; c=relaxed/simple;
	bh=MehBn7CCGh/3HP9kagQDvVk5Bwy40XwSzvDoJyd+Pko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oMpE1jyCdp1CPl/sQr+szLChzOigyW5JI+rBAyOl5oGRYZgypRFQALP7Ahjf3Ltw7DgoQN3K67f2JJRV+eSr/JPf0aDFK0sopX8Uslc+JxG00gCmPGlzbbBtXMVZ9MNIsjz0SP7qVyYKSSU75jbU7F05XTQeP5o9SwHsBtAN2t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=VqcJGnAt; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="VqcJGnAt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=XB6jfO0Z+XGDAFYBbaKVj+ZnqWmTIEXFGmkQ3heoNeI=;
	b=VqcJGnAtJxDYbaig7JnTjBasC98LAE+wHfjudP68KJ4YfLFkVnm6ewPhBjnkTsLOa4/gp5mvQwsis
	 HQYOlQyM9Dtj7dFh96LmClU256cPrZVGzVUn2uclh3K7K+5ZHue79ki6BB6Erh+wI2aBEzA/9rNRUJ
	 xhfaS2aifeMajEcrDDSG8hnI+f8CB+MLrJ4Z82QN9mKG4wSZCeNggvqU54DuydF5kVxpeH3xfwSIIH
	 LY3JIDplrTKLK3Jh633oq4+TNWKqJ73DXT5Hsxt7lWPRam3CcZUu2il2P6skqBBVdJ7LJMP73hCg+C
	 i4qtM4ZSWVJi3tMkJTKvc3bmzBMeSnw==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id 91b6ae52-a36d-11ef-9b34-005056bd6ce9;
	Fri, 15 Nov 2024 18:20:46 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 2/2] scsi: st: Restore some drive settings after reset
Date: Fri, 15 Nov 2024 18:20:03 +0200
Message-ID: <20241115162003.3908-3-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
References: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Some of the allowed operations put the tape into a known position
to continue operation, assuming only the tape position has changed.
But reset sets partition, density and block size to drive default
values. These should be restored to the values before reset. This
is only done for the operations not starting a new tape session.

Normally the current block size and density are stored by the drive.
If the settings have been changed, the changed values have to be
saved by the driver across reset.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c | 22 ++++++++++++++++++++--
 drivers/scsi/st.h |  2 ++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 3acaa3561c81..0008843e33a8 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -955,7 +955,6 @@ static void reset_state(struct scsi_tape *STp)
 		STp->partition = find_partition(STp);
 		if (STp->partition < 0)
 			STp->partition = 0;
-		STp->new_partition = STp->partition;
 	}
 }
 
@@ -2928,14 +2927,17 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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
@@ -3635,6 +3637,22 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 				goto out;
 			}
 			reset_state(STp); /* Clears pos_unknown */
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

