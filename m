Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7885437C9
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790702312; cv=none; b=DMk+f8GpKBrtpL8C3iMbmmaJDINQIg9oZYMO5AHQ0V9QwsvEzD1b9Dgw7QebjwfSNQI+fPtR/hEFYRphJtCdGT1RPGGIEzjjbAuSTTBLGmxEo5pGscYOpi8ycpTknPapt6UyZypT15mrxE13H+8K3rgJZyru4KPo5d74WQavK3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790702312; c=relaxed/simple;
	bh=L1YmGgXOO7wzIP7tSHmG4LR5lTTSJL6U5Y+rBV+LdpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/tu7RakFbVeHhHSEzO2PNLeV02Zk/Ll1wiN48HsePOFAsQ14PhI2eFjrOhRNVuaI6Q5ZBnJWLvtx19cAhVeoBR0NqzkqDRgJk7hjTjAt+zWk1NtUCtdXHWEnLZj4ZVV3z9vTrti2GC9CIUiH7TuzQVzldYWr0h+gkBEYkXP/Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RbzFVkmk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RbzFVkmk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790702307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YG4VIiAF2QbJlL1xs+yTMT1OirrdQjrLFhlfQ/CswUc=;
	b=RbzFVkmk9Jqy0OTKffE94gJjUKzenMVkKSEwFmDkJhDzoilV2+qIrl/yxNmSACVcbfOir3
	LKW9ZlwU8kP++ts6OQiPuiZl/adgP3uikGaHlAtkmZ5rQzjSk5EEPaxmr9zMYMTaip6fJa
	VrH2VhTc2MEBY7G+cQRlwpw+3PWvSqc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-P3YX9hOZPiKpQpvAgmTPWg-1; Tue,
 29 Sep 2026 13:18:22 -0400
X-MC-Unique: P3YX9hOZPiKpQpvAgmTPWg-1
X-Mimecast-MFC-AGG-ID: P3YX9hOZPiKpQpvAgmTPWg_1790702301
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47E3A1933B57;
	Tue, 29 Sep 2026 17:18:21 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33AB2180058D;
	Tue, 29 Sep 2026 17:18:20 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH v3 1/4] scsi: st: Restore changed drive settings after reset also for MTLOAD and MTRETEN
Date: Tue, 29 Sep 2026 13:18:10 -0400
Message-ID: <20260929171813.844733-2-loberman@redhat.com>
In-Reply-To: <20260929171813.844733-1-loberman@redhat.com>
References: <20260929171813.844733-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

A device reset returns the drive's density and block size to their
defaults.  Commit 7081dc75df79 ("scsi: st: Restore some drive settings
after reset") re-applies values changed by the user when the position is
recovered with MTREW, MTSEEK or MTEOM.  MTLOAD and MTRETEN are also
allowed to clear the reset condition and also leave the same medium at
BOT, but they restore nothing.

Because check_tape() reads the drive's block size with MODE SENSE on
every open, the driver silently switches to the drive default after the
reset.  An application that set fixed-block mode with MTSETBLK and
recovers with MTLOAD or MTRETEN keeps writing, but variable-length
blocks, without any error.

Restore the changed density and block size for MTLOAD and MTRETEN as
well.  Both operations may make the drive report a new medium, and the
new session started by check_tape() clears the "changed" flags and
applies the mode defaults.  So save the values before the operation, let
check_tape() run first (do_load_unload() already calls it for MTLOAD;
call it after MTRETEN), and then re-apply them.  Retry the restore once
in case a unit attention is still pending.
In immediate mode (MT_ST_NOWAIT) MTRETEN may return before the
retension has finished; do not wait for it there.

MTOFFL is not changed: the medium is unloaded and a different one may be
loaded next, for which the mode defaults apply.

Reproduced with scsi_debug (which reports a new medium after MTRETEN and
MTLOAD) and with IBM LTO drives on FC (which do not).

Fixes: 7081dc75df79 ("scsi: st: Restore some drive settings after reset")
Assisted-by: Claude sashiko
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/st.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c4946637..0a4263bef9cb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3586,6 +3586,23 @@ static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef *STm,
 	return retval;
 }
 
+/*
+ * Re-apply a density and block size that were changed by the user before a
+ * device reset (a negative value means "not changed").  A unit attention
+ * still pending after the operation (e.g. new medium after a load) fails the
+ * first MODE SELECT, so retry each once.  As in the other post-reset restore
+ * path, errors are ignored and one setting failing does not prevent
+ * restoring the other.
+ */
+static void st_restore_changed_settings(struct scsi_tape *STp, int density,
+					int blksize)
+{
+	if (density >= 0 && st_int_ioctl(STp, MTSETDENSITY, density))
+		st_int_ioctl(STp, MTSETDENSITY, density);
+	if (blksize >= 0 && st_int_ioctl(STp, MTSETBLK, blksize))
+		st_int_ioctl(STp, MTSETBLK, blksize);
+}
+
 /* The ioctl command */
 static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 {
@@ -3594,6 +3611,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	int retval = 0;
 	unsigned int blk;
 	bool cmd_mtiocget;
+	int restore_density = -1, restore_blksize = -1;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3740,6 +3758,17 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 					st_int_ioctl(STp, MTSETDENSITY, STp->changed_density);
 				if (STp->blksize_changed)
 					st_int_ioctl(STp, MTSETBLK, STp->changed_blksize);
+			} else if (mtc.mt_op == MTLOAD || mtc.mt_op == MTRETEN) {
+				/*
+				 * The same medium ends up at BOT, so the settings
+				 * apply as with MTREW.  The operation may start a
+				 * new session, which clears the "changed" flags:
+				 * save the values and restore them afterwards.
+				 */
+				if (STp->density_changed)
+					restore_density = STp->changed_density;
+				if (STp->blksize_changed)
+					restore_blksize = STp->changed_blksize;
 			}
 		}
 
@@ -3819,6 +3848,9 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 
 		if (mtc.mt_op == MTLOAD) {
 			retval = do_load_unload(STp, file, max(1, mtc.mt_count));
+			if (!retval)
+				st_restore_changed_settings(STp, restore_density,
+							    restore_blksize);
 			goto out;
 		}
 
@@ -3837,6 +3869,19 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 			retval = st_compression(STp, (mtc.mt_count & 1));
 		else
 			retval = st_int_ioctl(STp, mtc.mt_op, mtc.mt_count);
+		if (!retval && mtc.mt_op == MTRETEN && !STp->immediate &&
+		    (restore_density >= 0 || restore_blksize >= 0)) {
+			/*
+			 * Retension reloads the medium and the drive may
+			 * report a new medium.  Let check_tape() start the new
+			 * session (applying the mode defaults) now, as for
+			 * MTLOAD; otherwise it happens at the next open and
+			 * overrides the restored settings.
+			 */
+			if (check_tape(STp, file) >= 0)
+				st_restore_changed_settings(STp, restore_density,
+							    restore_blksize);
+		}
 		goto out;
 	}
 	if (!STm->defined) {
-- 
2.55.0

