Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FD4285056
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 15:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762271259; cv=none; b=Lw+SWZp3H+rnWd2YSCWYk8/QOQc743ttYDUYns13IrKpXKFdZnRplid7pbHifKvg04sT83Mvk+2XtMJwvoevHfh1WyFbT+Hl914vMDfHBcTL4q1FExgNzCeKsolVZs1uidD5t/EgVb54cyboA2OOsvZzjiDTaYm1a+VXohjNC2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762271259; c=relaxed/simple;
	bh=zaMy0vsICvTfcET1HzzBXYuwnqLere+oiKxd8HGhhPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsDpgHSsN6/fG5YAzyOzDkPKMtWw3emllx6TU3YjtUDZXW4dJ86FLznG551IY4lOnonrPI9K2KJbLdpBiXTXTrep4o5x5iowqZo92rwgnkV9FVtXDKm8qWbrG2Ixp1R0ITkBlLZE0nejfLJiS4ZQ+/iUMzw4E7cFbuzQOcy79yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BphY3iwN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BphY3iwN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762271256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHP+7pFTiueSTyvj31pK0VeIKd+vF0I9LECvmFzxfbE=;
	b=BphY3iwNFJhSZb2z0IWsZ6xuVCZ9vlVL1lqueAhmWfofgcLW+NzgEpnMQrG6aSmA3QxxwC
	LOumD0N43/q1UrqVHvB5gvS6mzvxUV3hcTGkGKWA5v9yNEOOocnl+EnlE789ggyUPdBVp7
	+EudFxyZQSJHl9F4KDFowKhiBwCk00Q=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-39-zaZCugujOX-gOh10553wYw-1; Tue,
 04 Nov 2025 10:47:35 -0500
X-MC-Unique: zaZCugujOX-gOh10553wYw-1
X-Mimecast-MFC-AGG-ID: zaZCugujOX-gOh10553wYw_1762271254
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B48918001E7;
	Tue,  4 Nov 2025 15:47:34 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.80.207])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4DDE419560B2;
	Tue,  4 Nov 2025 15:47:32 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	linux-scsi@vger.kernel.org
Cc: David Jeffery <djeffery@redhat.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH 2/2] st: skip buffer flush for information ioctls
Date: Tue,  4 Nov 2025 10:46:23 -0500
Message-ID: <20251104154709.6436-2-djeffery@redhat.com>
In-Reply-To: <20251104154709.6436-1-djeffery@redhat.com>
References: <20251104154709.6436-1-djeffery@redhat.com>
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
to verify ID information for the device when there has been any type of
reset event to their tape devices.

The st driver currently will fail all standard scsi ioctls if a call to
flush_buffer fails in st_ioctl. This causes ioctls which otherwise have no
effect on tape state to succeed or fail based on events unrelated to the
requested ioctl.

This makes scsi information ioctls unreliable after a reset even
if no buffering is in use. With a reset setting the pos_unknown field,
flush_buffer will report failure and fail all ioctls. So any application
expecting to use ioctls to check the identify the device will be unable to
do so in such a state.

For scsi information ioctls, avoid the need for a buffer flush and allow
the ioctls to execute regardless of buffer state.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by:     Laurence Oberman <loberman@redhat.com>
---

 drivers/scsi/st.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 87f0e303fdd6..d4d2c8e3f912 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3542,30 +3542,34 @@ static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef *STm,
 		goto out;
 	}
 
-	if ((i = flush_buffer(STp, 0)) < 0) {
-		retval = i;
-		goto out;
-	} else { /* flush_buffer succeeds */
-		if (STp->can_partitions) {
-			i = switch_partition(STp);
-			if (i < 0) {
-				retval = i;
-				goto out;
-			}
-		}
-	}
-	mutex_unlock(&STp->lock);
-
 	switch (cmd_in) {
+	case SCSI_IOCTL_GET_IDLUN:
+	case SCSI_IOCTL_GET_BUS_NUMBER:
+	case SCSI_IOCTL_GET_PCI:
+		break;
 	case SG_IO:
 	case SCSI_IOCTL_SEND_COMMAND:
 	case CDROM_SEND_PACKET:
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-		break;
+		if (!capable(CAP_SYS_RAWIO)) {
+			retval = -EPERM;
+			goto out;
+		}
+		fallthrough;
 	default:
-		break;
+		if ((i = flush_buffer(STp, 0)) < 0) {
+			retval = i;
+			goto out;
+		} else { /* flush_buffer succeeds */
+			if (STp->can_partitions) {
+				i = switch_partition(STp);
+				if (i < 0) {
+					retval = i;
+					goto out;
+				}
+			}
+		}
 	}
+	mutex_unlock(&STp->lock);
 
 	retval = scsi_ioctl(STp->device, file->f_mode & FMODE_WRITE,
 			    cmd_in, (void __user *)arg);
-- 
2.51.0

