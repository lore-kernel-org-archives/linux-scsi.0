Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B751228D95;
	Wed,  4 Dec 2024 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331806; cv=none; b=neXjjL//S5XH7a20rqiGVn9SjJMhA3VlSh/CA6LKP8Uf29z0Rb2cdtXeJLTvOunv3eksaH8XJKoaqzRMVIVB527aGAp6tziicF4R4zChD2nuIG76tO3VvLh6vFJzQ8Ekdq9WD3SoN2+Ul+6o3aO7fyzoyHi6OO4xGY7SpNBKfD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331806; c=relaxed/simple;
	bh=gT7/ZYx16a7GEXmiOrl/ZD/dAbbUaDgi3E1RX5rX1qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcONo5ny5fwl7Xy0bLZ11WVkbhuDwUCGOgv9TSjGbdBJxdmhnERlae4JkkRDG3RUbIJH3frIuFvhsyPbb77ZlniyoXqwjNMHdoSSy0rpVmz+zJzBlqXWSWm6J76OSXHJvCR8dLqTHPE/ATMneJ+HAhmNElmlieAtkcdBHhX/QLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJUaG+nC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJUaG+nC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C16C4CED1;
	Wed,  4 Dec 2024 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331806;
	bh=gT7/ZYx16a7GEXmiOrl/ZD/dAbbUaDgi3E1RX5rX1qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJUaG+nCZbHVrwXRsQHbRnlvspORwKclJncIKu8w75E0pGHiR1MnhKVnwR9qiuAVs
	 f4lG2scUCqaY2b7YscZdFCOLqY3rV5kTc7U8UQhB286mtDvqnswyhiGn9prkcOGwn2
	 5TsRqd06Z05W98dcSCKPIlYMbFusJrlKo/oCbqV0WQGI+wCy9XrqCHL0Gwz6JqHcp8
	 qCp20EJhdFoggegOZkcIV3XgwPBP8uw9DtwaSpLoDtYX/iO5gTE4n468TL7w08pG55
	 hudoHteZZcZ7yF+mZfrA+Zvgw/d9aazHdA4vuLwYOTt/32wLeYmZqLYd3mU68tnrLB
	 /+grFz/rPpdqQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 7/9] scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset
Date: Wed,  4 Dec 2024 10:51:53 -0500
Message-ID: <20241204155157.2214959-7-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155157.2214959-1-sashal@kernel.org>
References: <20241204155157.2214959-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.230
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
index c08518258f001..3b819c6b15a56 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3505,6 +3505,7 @@ static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user
 	int i, cmd_nr, cmd_type, bt;
 	int retval = 0;
 	unsigned int blk;
+	bool cmd_mtiocget;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3618,6 +3619,7 @@ static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user
 			 */
 			if (mtc.mt_op != MTREW &&
 			    mtc.mt_op != MTOFFL &&
+			    mtc.mt_op != MTLOAD &&
 			    mtc.mt_op != MTRETEN &&
 			    mtc.mt_op != MTERASE &&
 			    mtc.mt_op != MTSEEK &&
@@ -3731,17 +3733,28 @@ static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user
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

