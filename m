Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062A8563FCF
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 19:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790710117; cv=none; b=ceIKQd0nQTW83edH2PB6teLopXcpvzixZxo9zOhCczST29IXSP+HSgi+Op7GO9CuE5Esrzvtyr2XjUFkVZrdUNzQXdVRfFQunUYpy7DQ+oRr+N9An3xjEeE0gTpTT1ZMQ3qrtAHCyUNXzDa7JS8qutmsUUFFiyEdzwZ7uV2KFdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790710117; c=relaxed/simple;
	bh=BLFi2XiT6nC6etUHZyQ8bcKPOaRJdcdTG5bKjH1nIe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XzECUc07A6VCNe+sJa4KbCEV52EFMbZE5wsDoK/4snaAO2WrzyBzw5S/ZiuqeLalaBVXqXesyEsl3I1JSLrq3KwU4vDIL3VXlj3Tmx0eNsrsqgUklgzNKUhyFjdsF0oC7+kqzclGIs9Gwm3GHPVfB/qp/CqH5ftI0yAPyrl91MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O5NIYNX+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O5NIYNX+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790710115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wyxBMrbB0D6OS4SwkaUNiT/LmQdT2Gk3g/Uqy/3ZnWQ=;
	b=O5NIYNX+k1FqGC6Uk53VnAfwAlnfTrfjUEBi8vtPQJjkFEWMw/5FBjTM5/TFHG5viBwflf
	4sJVHgP1bpUqW+Cfa1DZ8GuM3b6bxxxZ/SIS0MYkqD36w7JJG3MkVPcwIskcOzk1SD19fX
	8vokhZDz0GFzLqT6unvz8ATfisp/kQU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-281-Cbg9-PtXNDWtm-UU6HjnNQ-1; Tue,
 29 Sep 2026 15:28:33 -0400
X-MC-Unique: Cbg9-PtXNDWtm-UU6HjnNQ-1
X-Mimecast-MFC-AGG-ID: Cbg9-PtXNDWtm-UU6HjnNQ_1790710112
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73F5F1834592;
	Tue, 29 Sep 2026 19:28:32 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5ECC41956047;
	Tue, 29 Sep 2026 19:28:31 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH v4 3/4] scsi: st: Restore the drive buffering mode after reset
Date: Tue, 29 Sep 2026 15:28:20 -0400
Message-ID: <20260929192821.997675-4-loberman@redhat.com>
In-Reply-To: <20260929192821.997675-1-loberman@redhat.com>
References: <20260929192821.997675-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

A device reset also returns the drive's buffered mode to its default.
check_tape() reads the buffered mode with MODE SENSE on every open, so
st follows the drive and a mode set by the user with MTSETDRVBUFFER is
lost without any indication.  The value is also written back by every
later MODE SELECT, including the one that restores a changed block size.

Unlike density and block size, the buffered mode has no "changed" state
that could be used to restore it.  Record the value set with
MTSETDRVBUFFER and restore it after a reset together with density and
block size: when MTREW, MTSEEK or MTEOM clear the reset condition, and
after MTLOAD and MTRETEN.  It is restored first, so that the MODE SELECTs
for density and block size carry the right value.

The buffered mode is a drive setting, not a property of the medium, so
it is not cleared when a new session starts.

Suggested-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Assisted-by: Claude sashiko
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
v4: no changes.
v3: new patch (Kai Mäkisara).

 drivers/scsi/st.c | 43 ++++++++++++++++++++++++++++---------------
 drivers/scsi/st.h |  2 ++
 2 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index aa4d2ce..f548197 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2963,9 +2963,11 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		direction = DMA_TO_DEVICE;
 
 		memset((STp->buffer)->b_data, 0, 12);
-		if (cmd_in == MTSETDRVBUFFER)
+		if (cmd_in == MTSETDRVBUFFER) {
 			(STp->buffer)->b_data[2] = (arg & 7) << 4;
-		else
+			STp->drv_buffer_changed = 1;	/* At least we tried ;-) */
+			STp->changed_drv_buffer = arg & 7;
+		} else
 			(STp->buffer)->b_data[2] =
 			    STp->drv_buffer << 4;
 		(STp->buffer)->b_data[3] = 8;	/* block descriptor length */
@@ -3611,16 +3613,19 @@ out:
 }
 
 /*
- * Re-apply a density and block size that were changed by the user before a
- * device reset (a negative value means "not changed").  A unit attention
- * still pending after the operation (e.g. new medium after a load) fails the
- * first MODE SELECT, so retry each once.  As in the other post-reset restore
- * path, errors are ignored and one setting failing does not prevent
- * restoring the other.
+ * Re-apply a drive buffering mode, density and block size that were changed
+ * by the user before a device reset (a negative value means "not changed").
+ * The buffering mode goes first: the other MODE SELECTs send the current
+ * STp->drv_buffer.  A unit attention still pending after the operation
+ * (e.g. new medium after a load) fails the first MODE SELECT, so retry each
+ * once.  As in the other post-reset restore path, errors are ignored and one
+ * setting failing does not prevent restoring the others.
  */
-static void st_restore_changed_settings(struct scsi_tape *STp, int density,
-					int blksize)
+static void st_restore_changed_settings(struct scsi_tape *STp, int drv_buffer,
+					int density, int blksize)
 {
+	if (drv_buffer >= 0 && st_int_ioctl(STp, MTSETDRVBUFFER, drv_buffer))
+		st_int_ioctl(STp, MTSETDRVBUFFER, drv_buffer);
 	if (density >= 0 && st_int_ioctl(STp, MTSETDENSITY, density))
 		st_int_ioctl(STp, MTSETDENSITY, density);
 	if (blksize >= 0 && st_int_ioctl(STp, MTSETBLK, blksize))
@@ -3635,7 +3640,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	int retval = 0;
 	unsigned int blk;
 	bool cmd_mtiocget;
-	int restore_density = -1, restore_blksize = -1;
+	int restore_drv_buffer = -1, restore_density = -1, restore_blksize = -1;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3778,6 +3783,9 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 					STp->partition = 0;
 					switch_partition(STp);
 				}
+				if (STp->drv_buffer_changed)
+					st_int_ioctl(STp, MTSETDRVBUFFER,
+						     STp->changed_drv_buffer);
 				if (STp->density_changed)
 					st_int_ioctl(STp, MTSETDENSITY, STp->changed_density);
 				if (STp->blksize_changed)
@@ -3789,6 +3797,8 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 				 * new session, which clears the "changed" flags:
 				 * save the values and restore them afterwards.
 				 */
+				if (STp->drv_buffer_changed)
+					restore_drv_buffer = STp->changed_drv_buffer;
 				if (STp->density_changed)
 					restore_density = STp->changed_density;
 				if (STp->blksize_changed)
@@ -3878,7 +3888,8 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 			 * does not wait and the drive may still be loading.
 			 */
 			if (!retval && STp->ready == ST_READY)
-				st_restore_changed_settings(STp, restore_density,
+				st_restore_changed_settings(STp, restore_drv_buffer,
+							    restore_density,
 							    restore_blksize);
 			goto out;
 		}
@@ -3899,7 +3910,8 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		else
 			retval = st_int_ioctl(STp, mtc.mt_op, mtc.mt_count);
 		if (!retval && mtc.mt_op == MTRETEN && !STp->immediate &&
-		    (restore_density >= 0 || restore_blksize >= 0)) {
+		    (restore_drv_buffer >= 0 || restore_density >= 0 ||
+		     restore_blksize >= 0)) {
 			/*
 			 * Retension reloads the medium and the drive may
 			 * report a new medium.  Let check_tape() start the new
@@ -3909,7 +3921,8 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 			 */
 			if (check_tape(STp, file) >= 0 &&
 			    STp->ready == ST_READY)
-				st_restore_changed_settings(STp, restore_density,
+				st_restore_changed_settings(STp, restore_drv_buffer,
+							    restore_density,
 							    restore_blksize);
 		}
 		goto out;
@@ -4517,7 +4530,7 @@ static int st_probe(struct scsi_device *SDp)
 	tpnt->modes[0].defined = 1;
 
 	tpnt->density_changed = tpnt->compression_changed =
-	    tpnt->blksize_changed = 0;
+	    tpnt->blksize_changed = tpnt->drv_buffer_changed = 0;
 	mutex_init(&tpnt->lock);
 
 	idr_preload(GFP_KERNEL);
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 0d7c4b8..c580024 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -162,10 +162,12 @@ struct scsi_tape {
 	unsigned char in_use;
 	unsigned char blksize_changed;
 	unsigned char density_changed;
+	unsigned char drv_buffer_changed;
 	unsigned char compression_changed;
 	unsigned char drv_buffer;
 	unsigned char density;
 	unsigned char changed_density;
+	unsigned char changed_drv_buffer;
 	unsigned char door_locked;
 	unsigned char autorew_dev;   /* auto-rewind device */
 	unsigned char rew_at_close;  /* rewind necessary at close */
-- 
2.43.0

