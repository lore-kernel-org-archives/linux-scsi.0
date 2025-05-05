Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACEF2F664B;
	Mon,  5 May 2025 23:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487082; cv=none; b=gplRsM4+bvoJeeoBj0VqckNZskaovM06H2e5vBoM5JYfc+xkewAvgUY+pzB+QNN8i6DbVs8ZmKe7YWuRUZp/aUwGkCwT7c2NyzWmbftkuphMv4NM3BGSsbrPRKBXpLzwGbw7XY1JT524zFcDLykiqUEqJOWFwCwO87krYEtVTzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487082; c=relaxed/simple;
	bh=+TWGb/mEEB6UbAXTVc60y86UuV0WiChWROSIQVpztFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEFUxv+jAB/YAagaoK456UdjipxTzK3efVdvdZ6DpXK81vLGvUy5bBmgykiBR73We9REKrEI1kxFAZTflTb1j58TFCRr8hX/mby6xh49bwt2YsKqRJwTuRJ0h4k59nKAASbC0gGo4fvYErXzmZkP+9QuNfp6ha89n29eYggU0Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YxjlT86a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YxjlT86a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1141AC4CEED;
	Mon,  5 May 2025 23:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746487081;
	bh=+TWGb/mEEB6UbAXTVc60y86UuV0WiChWROSIQVpztFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxjlT86arEEK05pwKrtNIcPw/trcX8mSh0FknPNHcOhcdV89CI4Ros++xdpUSzdqc
	 wLJoKUKu0cis0eZKwP6aRxSWERvvLURj8Xhuly/EPXGfhPOGviSJW5sHai9dqgqd5m
	 8s1AY00lRsLgjbmSX5BL6UTwnW5YzGirtuZclx7l5FuWf5O4tPCB+4N78FeG0jQ8uq
	 eG0gi1Beh0tMQ+vB63M/TZc7jDwhIDUH1CYOSAr3a23ET8Nt8fVzYJ319XpmGhdDOB
	 lh8FJRb/ubSQTo+8kYm+7x5xVQ0ZzXiAfgds0lxTgk36S96EKQ50rOviXsQVRRxa+R
	 1CXxfth0hafRg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 143/153] scsi: st: Restore some drive settings after reset
Date: Mon,  5 May 2025 19:13:10 -0400
Message-Id: <20250505231320.2695319-143-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505231320.2695319-1-sashal@kernel.org>
References: <20250505231320.2695319-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.181
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
index 26827e94d5e38..dc0c6508d254b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -947,7 +947,6 @@ static void reset_state(struct scsi_tape *STp)
 		STp->partition = find_partition(STp);
 		if (STp->partition < 0)
 			STp->partition = 0;
-		STp->new_partition = STp->partition;
 	}
 }
 
@@ -2916,14 +2915,17 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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
@@ -3624,9 +3626,25 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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
index c0ef0d9aaf8a2..f6ac5ffe7df6f 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -166,12 +166,14 @@ struct scsi_tape {
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
2.39.5

