Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B9F2D8DDA
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 14:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761228398; cv=none; b=WFFJ9WcMhPhG8V6R99Gj6OV/prlR6Fu79IULnJxdyqX0q8i+PIBsCYdb5KEa/4Ao6dBHHUaSZRxXff5Bdm6MEuOyc82eO+56aeOVk1w2qeKFJDk7tWOmo01MGAVotDE8AM2Gq7RsNGCkoZW7bBdVt5Elymxo3MIM7mvHKDz4Zw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761228398; c=relaxed/simple;
	bh=S33Mmc3IxO4AFgXmFCVjnVGqHg9a9DacTlCmOCm7y/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o+mxYoKm8gOcSMWWKxL4q79SU7X3EaIsZVNbrozW2QoIZd9Hx+UeaqHY/b4RtH8MjCUpJIKjd9j3U+WowZ4pj7h3KVcrDHVKtjSFkLAJntIpRTbmkHB+hovGOZIAGHnOfJXrTUSr8yhhO9FoSptTMUhUX962wy5bGh/8bNwwCIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F/10yarZ reason="signature verification failed"; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F/10yarZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761228395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wyY6A/qRieM5Jc+Z3Nt5yvu8FqjEBWBQymSvHHE95zQ=;
	b=F/10yarZPY0WLfGYK48WOEnrNv8h01MaPpQLuOSnevFc7U8UPkd9wHQVhU3XJ3HJcw7E7z
	6HnB8TzlKArYjN5PTepLUto8CQ8BsxFKyDBgWYUIbqpM5ooMlxjYVT5lxdsv2ch1kyZVo3
	kjjCTpscoJQ3+1ljS/t7KxuRMO6kZuU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-591-wgAoR8SLPCmOvvlwQDRUGQ-1; Thu,
 23 Oct 2025 10:06:31 -0400
X-MC-Unique: wgAoR8SLPCmOvvlwQDRUGQ-1
X-Mimecast-MFC-AGG-ID: wgAoR8SLPCmOvvlwQDRUGQ_1761228390
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FA6318002F9;
	Thu, 23 Oct 2025 14:06:30 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.66.136])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6AD6A19560B5;
	Thu, 23 Oct 2025 14:06:28 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	linux-scsi@vger.kernel.org
Cc: David Jeffery <djeffery@redhat.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH] scsi: st: skip buffer flush for information ioctls when there is no buffering
Date: Thu, 23 Oct 2025 10:04:49 -0400
Message-ID: <20251023140531.5197-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

With commit 9604eea5bd3a ("scsi: st: Add third party poweron reset handling")
some customer tape applications fail from being unable to complete ioctls
to verify ID information for the device when there has been any sort of reset
event to their tape devices.

The st driver currently will fail all standard scsi ioctls if a call to
flush_buffer fails in st_ioctl. This effectively allows ioctls which
otherwise have no affect on tape state to function as an indirect method
of flushing buffers when the tape is being used in a buffering mode.

But this also makes scsi information ioctls unreliable after a reset even
if no buffering is in use. With a reset setting the pos_unknown field,
flush_buffer will report failure and fail all ioctls. So any application
expecting to use ioctls to check the identify the device will be unable to
do so in such a state.

Instead of always failing the ioctls, allow the ioctls which will not
otherwise interact with the tape to bypass the call to flush_buffer if
there is no buffering occurring in the st driver.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by:     Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/st.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 74a6830b7ed8..d8ed3bb2304d 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3528,7 +3528,22 @@ static int partition_tape(struct scsi_tape *STp, int size)
 }
 
 
+static bool st_ioctl_bypass_flush(struct scsi_tape *STp, unsigned int cmd_in)
+{
+	switch (cmd_in) {
+	case SCSI_IOCTL_GET_IDLUN:
+	case SCSI_IOCTL_GET_BUS_NUMBER:
+	case SCSI_IOCTL_GET_PCI:
+		break;
+	default:
+		return false;
+	}
+
+	if (STp->buffer->writing || STp->buffer->buffer_bytes)
+		return false;
 
+	return true;
+}
 /* The ioctl command */
 static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 {
@@ -3565,6 +3580,9 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	if (retval)
 		goto out;
 
+	if (st_ioctl_bypass_flush(STp, cmd_in))
+		goto unlock;
+
 	cmd_type = _IOC_TYPE(cmd_in);
 	cmd_nr = _IOC_NR(cmd_in);
 
@@ -3878,6 +3896,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		retval = put_user_mtpos(p, &mt_pos);
 		goto out;
 	}
+unlock:
 	mutex_unlock(&STp->lock);
 
 	switch (cmd_in) {
-- 
2.51.0

