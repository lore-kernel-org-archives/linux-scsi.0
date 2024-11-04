Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163CA1B21B0
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 11:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730719634; cv=none; b=P6HV7YqXUGmUqZm4vo2gIcYwXQu/+DbmxOrTTw4cZuODFeYwOlILxwMVs3yIwGlkUCGgcvZDuyzm5uzVzO+B8L71eCa/pecHkqLKrqIlar8OhN3itQnjgxKIw1N/kK3usuMp9FUG/rpXc8TggjTZjpajA3uIeOOgsDb5PYlcKKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730719634; c=relaxed/simple;
	bh=EKzcOqXkev1HDdDEvFYEpziVWcbrNvF2MvGzf3tmk70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TB5YpT+AWbyxRoslWETI28V7lAHg/V/y1NOftZBJuLsmT1cCXJSgPqCLL212pQviCrD5quXpw7euSCgZJx/F/DVl7p0Bm/y3W5D4ajU3C/NH2aZP2OnhVna1TrDpezdbrcKUfq78wwkQFr1QZPFhLriTK4wzlCxPK4TcntMECsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=q1j4hI0h; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="q1j4hI0h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=pNtiOEFbYepsFznXLFUZugf4Oedsf9UkzgKJFcnhwEs=;
	b=q1j4hI0hNrRvUgSUwbUs0GRRRD43OGBEXuXgeOxcVoUauebHAkTRpi/1DUcSMp3AjkDDosY8QQnUt
	 8k4NtRpS++gLvkDc7CfaojFsaWBTYLJcjVYk8Svl3i9WIW0qm0jSqG0zxZGty5UgxNrkVEl+atgJZ0
	 B4C0SD2UW5XVY10Npy3Gg7cnmhoHBgj/TNDJ6gUCa3w0DhJqfpkJ5wRPeyUIwQeP5n54oEW6YMz0wE
	 6bQ/svKU74NhHtCkS2anXmyW5+lM51lsBUaFG3YOnCj8oVjhX3qyhz5HGOACByetIEpaLWQbpnXfU9
	 hVTImLbLARta1scmSp70r3u2Zst8e9w==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id b4e4e09f-9a9f-11ef-8872-005056bdd08f;
	Mon, 04 Nov 2024 13:26:59 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 2/2] scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset
Date: Mon,  4 Nov 2024 13:26:23 +0200
Message-ID: <20241104112623.2675-3-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241104112623.2675-1-Kai.Makisara@kolumbus.fi>
References: <20241104112623.2675-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Most drives rewind the tape when the device is reset. Reading
and writing are not allowed until something is done to make
the tape position match the user's expectation (e.g.,
rewind the tape). Add MTIOCGET and MTLOAD to operations allowed
after reset. MTIOCGET is modified to not touch the tape if
pos_unknown is non-zero. The tape location is known after MTLOAD.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 8d27e6caf027..c9038284bc89 100644
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

