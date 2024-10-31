Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B74342AA5
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 01:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730336453; cv=none; b=HKi0sW8WdTTH8/TjQG2Sc9ptyZSXA5hhbWF5abJP/NDxRkZZC7gUxY87/ohu8SI06xJ7fctA9T08qEYkMw5AnLTTO+sP3lcu4VuwGx2sBfLDaQLSUYCnwA+k4IX8MH6TLNm3oBAb0255282uTFF1PkdYovsL5OUIHqUKs99d7cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730336453; c=relaxed/simple;
	bh=zX31+Yy5s+OEYYug7rJ0UMPbtIDSwyZFEhO/watTPvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=behYRBk7DU+X8trfpJ+qpTpbGX+hmO0BHAEdMBd1MY0/abw/t9GP1mBTjAzo9v44IF0EK9RbJjBsXlPYYIgCKstRzrFxrSPV3ypLlG9nGl5UqXGPzyG9IdIsH5yNHZAFG5lUl3iHlBbXs7Gtbiwa99CIQRVGAIuORl9eU+ocPnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CReKTNg+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CReKTNg+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730336450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=di8pGQdZsDvyC4JdkaVDe+HgICS9D1R4yOLMiu65I58=;
	b=CReKTNg+gEK3wXdj7g9lG89bYUXYvc3sNrfu9NJUX6B6vFA2g+Pe4sZhgsgAbsaHhtMMHP
	Vmg9lObrB+XSGFOLU+8AK7u8o7ZkP2HqrIyXGgJKI8RxS6/zTpZ97tgICPbh+kS8XxSgV6
	5+WqnqsmDnQVbwQE0pPsqVc/fncyeG0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-190-Mf5tud4lNxyUnfkPICiL9w-1; Wed,
 30 Oct 2024 21:00:46 -0400
X-MC-Unique: Mf5tud4lNxyUnfkPICiL9w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A76F19560BF;
	Thu, 31 Oct 2024 01:00:45 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen3.rmtusnh.csb (unknown [10.22.88.108])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E87D01956054;
	Thu, 31 Oct 2024 01:00:43 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: linux-scsi@vger.kernel.org,
	Kai.Makisara@kolumbus.fi,
	martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	loberman@redhat.com
Subject: [PATCH 3/3] scsi: st: clear pos_unknown when the por ua is expected
Date: Wed, 30 Oct 2024 21:00:32 -0400
Message-ID: <20241031010032.117296-4-jmeneghi@redhat.com>
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

From: Kai Makisara <kai.makisara@kolumbus.fi>

The change for commit 9604eea5bd3a ("scsi: st: Add third party poweron
reset handling") was introduced to handle the problem where an
unexpected power/on reset resulted in an undetected position lost
condition which caused lost data as the driver flushed data and wrote a
file mark at the beginning of the tape.

To solve this problem code was added which detected the unexpected a
power on/reset Unit Attention in st_chk_results(). This correctly set
pos_unknown in the driver and prevented further access to the device
until the tape is re-positioned or rewound.

The problem with this solution is that it is catching POR Unit Attentions
that are expected as well as those that are unexpected. This results in
an unwanted EIO response to MTIOCGET.

The change for commit 3d882cca73be ("scsi: st: Fix input/output error on
empty drive reset") attempts to fix this problem by returning success in
flush_buffer() when ready != to ST_READY. However, once ST_READY is set,
if pos_unknown remains uncleared, MTIOGET can still return EIO. This is
confusing as some tape drives will set a POR UA when the system
reboots or the driver is reloaded.

Fixes: 3d882cca73be ("scsi: st: Fix input/output error on empty drive reset")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219419
Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
Tested-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/st.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e9d1cb6c8a86..0260361d19fa 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3538,6 +3538,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	int i, cmd_nr, cmd_type, bt;
 	int retval = 0;
 	unsigned int blk;
+	bool cmd_mtiocget;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3651,6 +3652,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 			 */
 			if (mtc.mt_op != MTREW &&
 			    mtc.mt_op != MTOFFL &&
+			    mtc.mt_op != MTLOAD &&
 			    mtc.mt_op != MTRETEN &&
 			    mtc.mt_op != MTERASE &&
 			    mtc.mt_op != MTSEEK &&
@@ -3764,17 +3766,28 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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
+		/* flush fails -> modify status accordingly */
+		if (cmd_mtiocget && STp->pos_unknown) {
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
@@ -3788,7 +3801,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		    ((STp->density << MT_ST_DENSITY_SHIFT) & MT_ST_DENSITY_MASK);
 		mt_status.mt_blkno = STps->drv_block;
 		mt_status.mt_fileno = STps->drv_file;
-		if (STp->block_size != 0) {
+		if (STp->block_size != 0 && mt_status.mt_blkno >= 0) {
 			if (STps->rw == ST_WRITING)
 				mt_status.mt_blkno +=
 				    (STp->buffer)->buffer_bytes / STp->block_size;
-- 
2.47.0

