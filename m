Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BC718E1A
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 01:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730336448; cv=none; b=otcE8Yh5nLBipo2o1Z+1GeDdTlVzIXg2VgdsV2DGBH8vhySIDgEbhdtpQMn4VGUGfb0q4DV/kE9un7767qJ7SSKFzHL8/NlEJiEKC80FmSMjpaQ2BwCn8j6cta0zUL6TFwlt55zsx3Bub1Ue24gObTBvn6xr7Ypr1kEClcixiWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730336448; c=relaxed/simple;
	bh=LoG6lQ8EcFrrcx+uHSM2692NxO2J62QbqVQvIKaLRpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Nyz0MK71rnzL67VwmccDt7BV+OI7rk/woxgRf6pLqGQuK37EbngSR48Ju6vzfqH0G/KNdHAGIuMKX4JoxtBEWnGrt6UPWkcejJo0jYk/lQtmPuF/WuFMTP6w0IrFDyGot8IFXXkSVj3UlTAOfBZIWRN6hfebqBRVOfSo88BRxLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i8/fXUiV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8/fXUiV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730336444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zV2CqiFJ/81MvsUoQTp9efLKrMQCNW6MCzItPNj5jFM=;
	b=i8/fXUiVd4qmAWcEAwrOw9bF2dXVjZ/gpNPGJAlBN81d7rHrTxY/yGuoBkom5ReA1ferMn
	sP0yKeQFQUGpUANIwotxeX6aylw79tuRszSQdvApCVCF15mHAhRH9eqha59Lq/Iglo3Gph
	7TXuANQLMdPUikKMpObtBcs0EvC0GSk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-sGtup4OJOuyOZa3jc8I4fw-1; Wed,
 30 Oct 2024 21:00:42 -0400
X-MC-Unique: sGtup4OJOuyOZa3jc8I4fw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67AB6195609F;
	Thu, 31 Oct 2024 01:00:41 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen3.rmtusnh.csb (unknown [10.22.88.108])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E1BE91956054;
	Thu, 31 Oct 2024 01:00:39 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: linux-scsi@vger.kernel.org,
	Kai.Makisara@kolumbus.fi,
	martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	loberman@redhat.com
Subject: [PATCH 1/3] scsi: st: instrument the pos_unknown code
Date: Wed, 30 Oct 2024 21:00:30 -0400
Message-ID: <20241031010032.117296-2-jmeneghi@redhat.com>
In-Reply-To: <20241031010032.117296-1-jmeneghi@redhat.com>
References: <20241031010032.117296-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Add debugging printfs to the various code paths that use pos_unknown.
This code is a little chatty but nothing has been added to the datapath.
It has been used to help debug a number of customer reported problems
from the field since the change for commit 9604eea5bd3a ("scsi: st: Add
third party poweron reset handling") was added.

To enable:

  echo 1 > /sys/module/st/drivers/scsi:st/debug_flag

Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/st.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index d50bad3a2ce9..9c0f9779768e 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -418,6 +418,10 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 
 	STp->pos_unknown |= STp->device->was_reset;
 
+	DEBC_printk(STp, "%s: %d: pos_unknown %x was_reset %x ready %x, result %d\n",
+			__func__, __LINE__, STp->pos_unknown, STp->device->was_reset,
+			STp->ready, result);
+
 	if (cmdstatp->have_sense &&
 	    scode == RECOVERED_ERROR
 #if ST_RECOVERED_WRITE_FATAL
@@ -834,6 +838,10 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	int backspace, result;
 	struct st_partstat *STps;
 
+	DEBC_printk(STp, "%s: %d: pos_unknown %x was_reset %x ready %x\n",
+		__func__, __LINE__, STp->pos_unknown, STp->device->was_reset,
+		STp->ready);
+
 	if (STp->ready != ST_READY)
 		return 0;
 
@@ -1050,6 +1058,10 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 	struct inode *inode = file_inode(filp);
 	int mode = TAPE_MODE(inode);
 
+	DEBC_printk(STp, "%s: %d: pos_unknown %x was_reset %x ready %x\n",
+			__func__, __LINE__, STp->pos_unknown,
+			STp->device->was_reset, STp->ready);
+
 	STp->ready = ST_READY;
 
 	if (mode != STp->current_mode) {
@@ -1085,6 +1097,9 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 			STps->drv_file = 0;
 		}
 		new_session = 1;
+		DEBC_printk(STp, "%s: %d: CHKRES_NEW_SESS pos_unknown %x was_reset %x ready %x\n",
+				__func__, __LINE__, STp->pos_unknown, STp->device->was_reset,
+				STp->ready);
 	}
 	else {
 		STp->cleaning_req |= saved_cleaning;
@@ -1101,6 +1116,12 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 			STp->ps[0].drv_file = STp->ps[0].drv_block = (-1);
 			STp->partition = STp->new_partition = 0;
 			STp->door_locked = ST_UNLOCKED;
+
+			DEBC_printk(STp,
+				"%s: %d: CHKRES_NOT_READY pos_unknown %x was_reset %x ready %x\n",
+				__func__, __LINE__, STp->pos_unknown, STp->device->was_reset,
+				STp->ready);
+
 			return CHKRES_NOT_READY;
 		}
 	}
@@ -1237,9 +1258,16 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 		}
 	}
 
+	DEBC_printk(STp, "%s: %d: CHKRES_READY pos_unknown %x was_reset %x ready %x\n",
+			__func__, __LINE__, STp->pos_unknown, STp->device->was_reset,
+			STp->ready);
+
 	return CHKRES_READY;
 
  err_out:
+	DEBC_printk(STp, "%s: %d: pos_unknown %x was_reset %x ready %x retval %d\n",
+			__func__, __LINE__, STp->pos_unknown, STp->device->was_reset,
+			STp->ready, retval);
 	return retval;
 }
 
@@ -1352,6 +1380,9 @@ static int st_flush(struct file *filp, fl_owner_t id)
 	if (file_count(filp) > 1)
 		return 0;
 
+	DEBC_printk(STp, "%s: %d: pos_unknown %x was_reset %x ready %x\n",
+			__func__, __LINE__, STp->pos_unknown, STp->device->was_reset, STp->ready);
+
 	if (STps->rw == ST_WRITING && !STp->pos_unknown) {
 		result = st_flush_write_buffer(STp);
 		if (result != 0 && result != (-ENOSPC))
-- 
2.47.0

