Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FAC2D7ADC;
	Mon,  5 May 2025 22:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485723; cv=none; b=bSoVzjFb5q7TQZ4CMj9XpEwJK1WyGX/ZxrWNu3P9JVl0+AQLTe4gGdmSgKQaAIUS9AbOIIW/JINzjJurj74aU1+TNomtbv/Vd42+6XGNCnf3BnvGmwE09MXUbtwlhR3QXWNw332mIckP9RSA5VNvt8X4UMO2l6EdGn2LcOs+uJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485723; c=relaxed/simple;
	bh=u4M2ri7s0pD3GKep1Ohl7DW42zCEi08RdWR3N8ij7v4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pr7Ji9ccMPfX25MlHfWxlGz5SRobChhBDnKSIX6u2x389p8TG2U+h7TLh6toaCnWNEl+thYl+mbN/ON8+mfeph3XFDZCVZHhtXgTfoVv46JN0qwlnM/ijWbgXo3WJQdm2rRE4vS8Zz0fAQXrxzVKpIEgMhwqzQEPR5nFubUsHio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sBpRC/tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sBpRC/tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6578C4CEEE;
	Mon,  5 May 2025 22:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485722;
	bh=u4M2ri7s0pD3GKep1Ohl7DW42zCEi08RdWR3N8ij7v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBpRC/tIRNlXDMXER/D4v9QfG/vugQaz4sLYwW+UeOQBAKoVu5+y1l05V3glIS1MK
	 nZtkZmeJ1B3yJC/jUXyS0Tg+IYvI9c++Cu51GY0CMcVAlZfVbPIZL8SDpTtWLmBvKp
	 Oq3E6gNU/yL9U32NEa8hcBCBOsopi4Fzl22f5Urb+3GpYjKD8OdxJEX0U2/2EUiEMm
	 d2GkELN+Ly8l+skttc7Z1Kgkpm1pItwl6xf7RlDakP9uM39wAWrNl+h5oE1bsa8Xon
	 ZAznKcttxoz1uYBezK06qIRBMrIkY3W7NXVhfxojnuRAhT0R19BYvVpuWsMQSMEkWe
	 Ib13Tt0AAoyfw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 444/486] scsi: st: Restore some drive settings after reset
Date: Mon,  5 May 2025 18:38:40 -0400
Message-Id: <20250505223922.2682012-444-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit 7081dc75df79696d8322d01821c28e53416c932c ]

Some of the allowed operations put the tape into a known position to
continue operation assuming only the tape position has changed.  But reset
sets partition, density and block size to drive default values. These
should be restored to the values before reset.

Normally the current block size and density are stored by the drive.  If
the settings have been changed, the changed values have to be saved by the
driver across reset.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250120194925.44432-2-Kai.Makisara@kolumbus.fi
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 24 +++++++++++++++++++++---
 drivers/scsi/st.h |  2 ++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1cfd7e71dcdde..3e982c166baf9 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -952,7 +952,6 @@ static void reset_state(struct scsi_tape *STp)
 		STp->partition = find_partition(STp);
 		if (STp->partition < 0)
 			STp->partition = 0;
-		STp->new_partition = STp->partition;
 	}
 }
 
@@ -2926,14 +2925,17 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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
@@ -3634,9 +3636,25 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 				retval = (-EIO);
 				goto out;
 			}
-			reset_state(STp);
+			reset_state(STp); /* Clears pos_unknown */
 			/* remove this when the midlevel properly clears was_reset */
 			STp->device->was_reset = 0;
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
index 1aaaf5369a40f..6d31b894ee84c 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -165,6 +165,7 @@ struct scsi_tape {
 	unsigned char compression_changed;
 	unsigned char drv_buffer;
 	unsigned char density;
+	unsigned char changed_density;
 	unsigned char door_locked;
 	unsigned char autorew_dev;   /* auto-rewind device */
 	unsigned char rew_at_close;  /* rewind necessary at close */
@@ -172,6 +173,7 @@ struct scsi_tape {
 	unsigned char cleaning_req;  /* cleaning requested? */
 	unsigned char first_tur;     /* first TEST UNIT READY */
 	int block_size;
+	int changed_blksize;
 	int min_block;
 	int max_block;
 	int recover_count;     /* From tape opening */
-- 
2.39.5

