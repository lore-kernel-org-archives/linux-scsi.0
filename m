Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997581DD0FF
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 09:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887163; cv=none; b=X4kHw92Vo777EIP9iBTT81yYABadg+hVUoqKhtmbS9Jgr1MMzTt0veKWHPMcIIzJh229XsGx6/G84vqV5Fn5yVgNsMKxlOrm13C0eZ2ur7tpwmihLndubBcyQ2kSPhwbrRKeoSAkX+OYw/UzMhONWfZf1ELAlMurM32N1nEK3To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887163; c=relaxed/simple;
	bh=nmHcOvT01GZAENA7MCHMQ4A2pRTqQAqR0679py1cyLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F3JKaMIVugLwWJ3oT4q/4Tep8XbjVjLuOz+blLL25EX+wcYmlEI4/zCHyhwoPKFcy3ZzuUonO5oZ/AGsJY3bMgGNVAvnJ865afMrp5I8GS3L5vVD8ZzIR7RxjJMwdGmHEMx4bzR14n2PBohkSQ7b3oW5SO0eExwbpuITEvqPwfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=c8llg1/j; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="c8llg1/j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=N11RRwHX+clsLwhnPodKuSOd7SrqM693Ulg6o6cTJEU=;
	b=c8llg1/jCpnzA+vFwMi8Z74PPxFicBvCkrekn8ZYvtjMBO+vYyo0vDxqrZPBtS/NVWOqehJC6FfQz
	 otlD/DUSHTZBc8gcHR3SYeSfesu8yLk7qvq5tfmVIWlRGBgG3Mvu/FCn8KcXhuuRl61xkp4XjmrlbR
	 7zjoUiuVnCvdtHF5Xqh3OPlVUN/PmFHgjMJ15hCQ/nrzT6hopVy+4yrXEmTcGJoaCm1oJqygG5og8P
	 rF0chzHJqXZN472TlVVbvo9YGDDJv2PPELD0RPrcWsXY1MJk1yisBus3Al26wzRbUYhQp8ACy+1UD0
	 WErDr5OBYvYZBlD5qm9XBLzG6HeATrQ==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id 963cc97a-9c25-11ef-9ac8-005056bd6ce9;
	Wed, 06 Nov 2024 11:57:52 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 2/3] scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset
Date: Wed,  6 Nov 2024 11:57:22 +0200
Message-ID: <20241106095723.63254-3-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106095723.63254-1-Kai.Makisara@kolumbus.fi>
References: <20241106095723.63254-1-Kai.Makisara@kolumbus.fi>
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
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
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

