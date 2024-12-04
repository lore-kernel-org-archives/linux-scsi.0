Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADC42242FB;
	Wed,  4 Dec 2024 17:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331767; cv=none; b=ZkCFpxgh/DfcNDIJxxVCkv8Xyum2lXUTBOneCZWkwEDpZniiHnkxJmXt4uoeX2Vkb1W/8F/Avzvl3gALIiqgaB/DlIPk/PAHzW2A1+WEM7s7M+HKZkvHlkHgHNbAzbiqXAfJRxSfQKJPWVZkwhiQjfiIO3o0y9qQmuOPsqgSPr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331767; c=relaxed/simple;
	bh=kIF/3vJX6uvuasAaMfyZVn/i7AkJYONkysE4GuS2f4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhCHFYmpvnBhFsCoawOChNq9SskYDWdtDgRVfbuF/y/Xu4kGFIWnHAhpak0zd7VxUWoO5psCZc+NmgrBUC6DuMvl25VwC7/GfVa7ZQQ4iZ+CE6p9fz8qDaaNmNEvWZhEBIC7Hjufhvk9h2mnixs1dzRBZd9TqYOsFqR8XMfc8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtgKu20T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtgKu20T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05A8C4CECD;
	Wed,  4 Dec 2024 17:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331767;
	bh=kIF/3vJX6uvuasAaMfyZVn/i7AkJYONkysE4GuS2f4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtgKu20Tx+0kjoLu7xyo3/0ZFIwWFdWHJb6HLIbW6heyKz8wmhCqg23u2qgklolTA
	 qJQXoTgDH9Si2BwgMDN4yTYbbLhXEOJ/oRxjce7SsYf+zt4b1leKZlSiDcitvxXZdm
	 sod3s0OzLKCnsqz1SuvYGLHn0GVbIAWNTVhk4+MoS2fEcdTBBeaIKuDko6my9iXSOX
	 ug4Jwo+MJv67DKwta4TiLtmtpRqmlyjMYz1TyJIrhS1/6QQJh+csnjD20+SQ2Iqele
	 PMsyPWWtyAVIWVubHxB0WEMbi99jLrUUmxtlljjlcLx6t+3WCurJPH8cgPGobBhrY5
	 katN7UP0HcSKg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 10/15] scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset
Date: Wed,  4 Dec 2024 10:50:49 -0500
Message-ID: <20241204155105.2214350-10-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155105.2214350-1-sashal@kernel.org>
References: <20241204155105.2214350-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.119
Content-Transfer-Encoding: 8bit

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit 0b120edb37dc9dd8ca82893d386922eb6b16f860 ]

Most drives rewind the tape when the device is reset. Reading and writing
are not allowed until something is done to make the tape position match the
user's expectation (e.g., rewind the tape). Add MTIOCGET and MTLOAD to
operations allowed after reset. MTIOCGET is modified to not touch the tape
if pos_unknown is non-zero. The tape location is known after MTLOAD.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219419#c14
Link: https://lore.kernel.org/r/20241106095723.63254-3-Kai.Makisara@kolumbus.fi
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index b91da7b51814a..b3caa3b9722d1 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3504,6 +3504,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	int i, cmd_nr, cmd_type, bt;
 	int retval = 0;
 	unsigned int blk;
+	bool cmd_mtiocget;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3617,6 +3618,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 			 */
 			if (mtc.mt_op != MTREW &&
 			    mtc.mt_op != MTOFFL &&
+			    mtc.mt_op != MTLOAD &&
 			    mtc.mt_op != MTRETEN &&
 			    mtc.mt_op != MTERASE &&
 			    mtc.mt_op != MTSEEK &&
@@ -3730,17 +3732,28 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		goto out;
 	}
 
+	cmd_mtiocget = cmd_type == _IOC_TYPE(MTIOCGET) && cmd_nr == _IOC_NR(MTIOCGET);
+
 	if ((i = flush_buffer(STp, 0)) < 0) {
-		retval = i;
-		goto out;
-	}
-	if (STp->can_partitions &&
-	    (i = switch_partition(STp)) < 0) {
-		retval = i;
-		goto out;
+		if (cmd_mtiocget && STp->pos_unknown) {
+			/* flush fails -> modify status accordingly */
+			reset_state(STp);
+			STp->pos_unknown = 1;
+		} else { /* return error */
+			retval = i;
+			goto out;
+		}
+	} else { /* flush_buffer succeeds */
+		if (STp->can_partitions) {
+			i = switch_partition(STp);
+			if (i < 0) {
+				retval = i;
+				goto out;
+			}
+		}
 	}
 
-	if (cmd_type == _IOC_TYPE(MTIOCGET) && cmd_nr == _IOC_NR(MTIOCGET)) {
+	if (cmd_mtiocget) {
 		struct mtget mt_status;
 
 		if (_IOC_SIZE(cmd_in) != sizeof(struct mtget)) {
-- 
2.43.0

