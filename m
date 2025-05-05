Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F86339097;
	Mon,  5 May 2025 22:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484623; cv=none; b=DqAhFdRV15RAYwtQpZxEnhAM62yEGfFYu8LGuge0dcZ7edmQszFG+LbuUj5ZsWE8MZeduvYeQK+KaHV1kLPJ0z40fM/A/j0Isd//0yom5eXSC7yZrtOQZa7z7n9qKz13AOMq9QYzCLqMihQMckfGduTzJhtlbP/hFSwux4Is4HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484623; c=relaxed/simple;
	bh=e32HKCNMgAKfpyaf7qVVWS2dVmcDhU5ubmpdQauNCgE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJ8pZlx527yo5lj4Ywj0FDuQFt7HOFQe+zIZeq3JkrTa4cPpJQXbkl0ngIqCbiB4uxEuTS8UlwmPJtMgf+hGW9218CBvmY7WVg6AXy+VDLN1CgaqzzIG0LWvC8gq+nbkUdyOfQpLBGMct9JcJoPH8Sdp6gqbgVwTqpei2X588KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VC9aMDm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VC9aMDm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9D0C4CEED;
	Mon,  5 May 2025 22:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484623;
	bh=e32HKCNMgAKfpyaf7qVVWS2dVmcDhU5ubmpdQauNCgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VC9aMDm0dRwVFQRw15glSxxHJtwvxBKDc6wo6pMZtbnI3XJI9r0zykrAu3r0RSPkO
	 7ZCk5kiDZBqm+umZbQ155Red+toRO36RXcTDyJ1W/lP8TQyWqcJHPrYyusmdkIm2cf
	 Hg/OMlgdozQjKXFmzlYk7Uy+IZMwDbHKCMbWWdTHz2mwbWYlJh8XVd6geLOcQWl6sU
	 w8BtL5uxI1KxSOG25NYCENxy/cY85rMrrXtKMQIGrFe99iHWoDAHT2JEOLT/kmZPgH
	 qKbPM5NfKlrmAOqxphyPRYmdDIVmuc9qhaARE4O3Pm0hEEpvx03MfgfTrBMzUkeEhP
	 sc7fdDnueyeRg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 568/642] scsi: st: Restore some drive settings after reset
Date: Mon,  5 May 2025 18:13:04 -0400
Message-Id: <20250505221419.2672473-568-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 4add423f2f415..7dec7958344ea 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -952,7 +952,6 @@ static void reset_state(struct scsi_tape *STp)
 		STp->partition = find_partition(STp);
 		if (STp->partition < 0)
 			STp->partition = 0;
-		STp->new_partition = STp->partition;
 	}
 }
 
@@ -2929,14 +2928,17 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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
@@ -3637,9 +3639,25 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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

