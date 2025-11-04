Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176FE27586E
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 15:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762271253; cv=none; b=YNawCsnUgQ58qpjPKeWkJvhvym50J7k/bvJjycHDxFhAX1hpetfYbHucprnRyMQvQ2aOCRFcmCw1fHNrsJZSq1hM45JNkPJvOwL+TGbgRorIK97tCHia4JJtwO29I0ehXBXQMIw3JMd5Z3P/w2vKPj8rCgNe7LaRB3S2lHF1HfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762271253; c=relaxed/simple;
	bh=SC9Z9MnCshsBz+eaiWEleXD4S0isgGjIZ6PESCCLfgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tGk6LFsJmIdDeqsxWbAxX32YA1M++ZAaxaNpzkDVcLX+ChY29Nvw96BwV0J/83imu9c/wjW8LZpfPh5hhu7XeKFnuQgIFW6IScIceNHtHBKSpO0xV9SI0HphTxaSo8Jgofgvs0QbqAo4KjEu8rdBiDrWs8JGjsxFuLOGVNA4/Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ezdrSfMR reason="signature verification failed"; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ezdrSfMR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762271249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UQOjYLJ5Xsy4bjIvLUgMG3UX+Pp6KSQzRLephac221o=;
	b=ezdrSfMREG2Djw7OWGHXNyM8azYgah7aQPfyJFQyjK+oVYCFW0qqqPZ2Zv+kLOBRqIu3hq
	WAZoy/pVAB6jU1f9hACyDE1NY9Itwy8g1Ua1OuCyTnFDraNkOyczEb7/RYIVWPqGnKspGE
	7AIg3vHZjE34SwFFRSVtOms3NptFl/M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-278-SqXik1DxMxSKM_JIRe_cjQ-1; Tue,
 04 Nov 2025 10:47:26 -0500
X-MC-Unique: SqXik1DxMxSKM_JIRe_cjQ-1
X-Mimecast-MFC-AGG-ID: SqXik1DxMxSKM_JIRe_cjQ_1762271245
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E334318001D6;
	Tue,  4 Nov 2025 15:47:24 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.80.207])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A893219560A2;
	Tue,  4 Nov 2025 15:47:23 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	linux-scsi@vger.kernel.org
Cc: David Jeffery <djeffery@redhat.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH 1/2] st: separate st-unique ioctl handling from scsi common ioctl  handling
Date: Tue,  4 Nov 2025 10:46:22 -0500
Message-ID: <20251104154709.6436-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The st ioctl function currently interleaves code for handling various st
specific ioctls with parts of code needed for handling ioctls common to
all scsi devices. Separate out st's code for the common ioctls into a more
manageable, separate function.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by:     Laurence Oberman <loberman@redhat.com>
---

 drivers/scsi/st.c | 85 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 62 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 74a6830b7ed8..87f0e303fdd6 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3526,8 +3526,60 @@ static int partition_tape(struct scsi_tape *STp, int size)
 out:
 	return result;
 }
-
 
+/*
+ * Handles any extra state needed for ioctls which are not st-specific.
+ * Called with the scsi_tape lock held, released before return
+ */
+static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef *STm,
+			    struct file *file, unsigned int cmd_in,
+			    unsigned long arg)
+{
+	int i, retval = 0;
+
+	if (!STm->defined) {
+		retval = -ENXIO;
+		goto out;
+	}
+
+	if ((i = flush_buffer(STp, 0)) < 0) {
+		retval = i;
+		goto out;
+	} else { /* flush_buffer succeeds */
+		if (STp->can_partitions) {
+			i = switch_partition(STp);
+			if (i < 0) {
+				retval = i;
+				goto out;
+			}
+		}
+	}
+	mutex_unlock(&STp->lock);
+
+	switch (cmd_in) {
+	case SG_IO:
+	case SCSI_IOCTL_SEND_COMMAND:
+	case CDROM_SEND_PACKET:
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		break;
+	default:
+		break;
+	}
+
+	retval = scsi_ioctl(STp->device, file->f_mode & FMODE_WRITE,
+			    cmd_in, (void __user *)arg);
+	if (!retval && cmd_in == SCSI_IOCTL_STOP_UNIT) {
+		/* unload */
+		STp->rew_at_close = 0;
+		STp->ready = ST_NO_TAPE;
+	}
+
+	return retval;
+out:
+	mutex_unlock(&STp->lock);
+	return retval;
+}
 
 /* The ioctl command */
 static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
@@ -3565,6 +3617,15 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	if (retval)
 		goto out;
 
+	switch(cmd_in) {
+	case MTIOCPOS:
+	case MTIOCGET:
+	case MTIOCTOP:
+		break;
+	default:
+		return st_common_ioctl(STp, STm, file, cmd_in, arg);
+	}
+
 	cmd_type = _IOC_TYPE(cmd_in);
 	cmd_nr = _IOC_NR(cmd_in);
 
@@ -3876,29 +3937,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		}
 		mt_pos.mt_blkno = blk;
 		retval = put_user_mtpos(p, &mt_pos);
-		goto out;
-	}
-	mutex_unlock(&STp->lock);
-
-	switch (cmd_in) {
-	case SG_IO:
-	case SCSI_IOCTL_SEND_COMMAND:
-	case CDROM_SEND_PACKET:
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-		break;
-	default:
-		break;
 	}
-
-	retval = scsi_ioctl(STp->device, file->f_mode & FMODE_WRITE, cmd_in, p);
-	if (!retval && cmd_in == SCSI_IOCTL_STOP_UNIT) {
-		/* unload */
-		STp->rew_at_close = 0;
-		STp->ready = ST_NO_TAPE;
-	}
-	return retval;
-
  out:
 	mutex_unlock(&STp->lock);
 	return retval;
-- 
2.51.0

