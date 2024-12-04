Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8C7227B8B;
	Wed,  4 Dec 2024 16:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331524; cv=none; b=SPGwy2o2ObUWSfFQsX5bhmoMpFi0oUMVziCt/wSu44hAUPVYVvqr1rGUuipwOipSqOusaFXrLdeksqqUT6mxkMgmZz0Wj42TIqXv3IgpZp1NLixmH2GnfN9JIuJkXUEDj+qMvUIIBEJvuwbgZjY1lZE7wTWe7224TDS/c0oduds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331524; c=relaxed/simple;
	bh=vxfjZNs/9h/Xsh/1x7vZN8w3mOTuUt5TKOYUMerjhcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLnwvDsxN6EMK8hpaTl1hoIij+KNmS3FUM0d2tt9lv8DQTypr9hSZh8bnvV3rnvaxEUNchShf8wv7zWDnmUYgt+Kp6ZCYM4AME27HJXDNmq03crht8662BH+981AMSWTPQjcpzAkdzvur6FJn5W+SinOiqtx4qlsojHgfH9zqHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AA5xvYiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AA5xvYiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC119C4CED1;
	Wed,  4 Dec 2024 16:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331523;
	bh=vxfjZNs/9h/Xsh/1x7vZN8w3mOTuUt5TKOYUMerjhcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AA5xvYiGkaqx9BQ5YdHpHaYwO/Kh/mklgAujCfqlY7u389YjjwnH4UUiJ5qAXL6+j
	 D3++wTGbDGVDO73bGjQqVeqwHYLyX6qgFHFMqEYWLxiGmen8zZCGnZZbGK+2j0b+Kw
	 Svo7nZKtkhKBquEYsffCgwK60H5d1CBY4Gc/Fg/Q5I0Wi3CEZ1zodb4TiOsCs8xf5z
	 2voad9VKxMkfN2mS64MsAjWR6YfYyhAVzN8EMO2gHCGDCgDQa9+HKvpv+tqbhtWOX7
	 kxAobU9QKoSqWpZC5dw/g5UkoxIg4Vy4S/aGdW1Nqe88TOd2+zpBErFQN80UrLfrJt
	 THIDlfo21if8A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 27/36] scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset
Date: Wed,  4 Dec 2024 10:45:43 -0500
Message-ID: <20241204154626.2211476-27-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204154626.2211476-1-sashal@kernel.org>
References: <20241204154626.2211476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.1
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
index 8d27e6caf0277..c9038284bc893 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3506,6 +3506,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	int i, cmd_nr, cmd_type, bt;
 	int retval = 0;
 	unsigned int blk;
+	bool cmd_mtiocget;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3619,6 +3620,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 			 */
 			if (mtc.mt_op != MTREW &&
 			    mtc.mt_op != MTOFFL &&
+			    mtc.mt_op != MTLOAD &&
 			    mtc.mt_op != MTRETEN &&
 			    mtc.mt_op != MTERASE &&
 			    mtc.mt_op != MTSEEK &&
@@ -3732,17 +3734,28 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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

