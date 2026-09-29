Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C73568552
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 19:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790710118; cv=none; b=KLe69PBu5BJfpQDzVqOQ80jm2WZRbkGXbKBg2qcTlFkjT7wXaq6M4VZbC/8C3F1Njyb39gP6INHGVQ+x0CtBt2a+uewdXAZjy9wNXYzbemGtCtMprMz0ZCbpC0Zk73bKCoU8h/ZPLVrxNYoagvJup2C+x0X4JK7rPraXE3bgOZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790710118; c=relaxed/simple;
	bh=T/SSzfxKCCZ1aIvdDjlGkONoe05QUsn9SLknwx2rUQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mETN/wIPQktD8R83Hb+U4+E4MZOkMno9ctwPorsoN7R+ktr9uuB83Pa9TRBkGe9yU+5sH7CLNeUWQZFF83y5xyxh5F9A1xqMHXbIyCb03aoMRBn0RaRzewmDr+cSrimVmEwGAz5+on6LfZbUE7GVu8nTOQqNBTfcl+Tc8QS8EQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iajgD/XG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iajgD/XG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790710115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ajYvwdrEGCc1He/UJOaBqOKLlqj/8lzls1Rvti171jE=;
	b=iajgD/XG3qRzatwdgQ4GEZwsADAxEppfvdRCVd6MEE6EpFeQqsSzhT5hJbvRVw67VeZDCR
	883eErRK5vkaH8qW2TSoxLRYbqtgol6l2gFOVpZMnuQ2tLpqu76qkqjEwMLC4nh+6a8eqc
	8E/OhSgJ4gsY2ox1wuguMwvIWRjkWRI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-lPKQ3jKqNDOAmNt77RjpPQ-1; Tue,
 29 Sep 2026 15:28:31 -0400
X-MC-Unique: lPKQ3jKqNDOAmNt77RjpPQ-1
X-Mimecast-MFC-AGG-ID: lPKQ3jKqNDOAmNt77RjpPQ_1790710110
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 905FE1840C44;
	Tue, 29 Sep 2026 19:28:30 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 450761956047;
	Tue, 29 Sep 2026 19:28:29 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH v4 2/4] scsi: st: Record the tape position after a successful MTLOAD
Date: Tue, 29 Sep 2026 15:28:19 -0400
Message-ID: <20260929192821.997675-3-loberman@redhat.com>
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

Commit 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed
after device reset") allows MTLOAD to clear the reset condition because
the tape location is known after MTLOAD.  But the driver does not record
it: reset_state() sets the file and block numbers to -1, and
do_load_unload() leaves them there.  check_tape() sets them to 0 only for
a new session, which requires a new-medium unit attention.  Drives that
do not report one when the medium was already loaded (seen with IBM LTO
drives) keep reporting file/block -1 in MTIOCGET and no BOT, although the
tape is at the beginning.

After a successful load, reset the partition and the state of all
partitions, as the new-session path in check_tape() does: partition 0,
position at BOT, EOF state cleared and no pending write.  Otherwise the
driver may still record the previous partition, so that a later MTSETPART
to that partition is not performed; a read after loading at EOD fails
with EIO; and a partition left in the ST_WRITING state by a partition
switch in read() or write() makes st_flush() write a filemark at the
beginning of partition 0 when the device is closed.

Fixes: 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset")
Suggested-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Assisted-by: Claude sashiko
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
v4: reset the state of all partitions after the load, as a new session
    does; a stale ST_WRITING state made st_flush() write a filemark at
    BOT of partition 0 (Sashiko).  Reproduced on an IBM LTO-5: write in
    partition 0, MTSETPART 1, read(), MTLOAD, close.
v3: set the partition to 0 for all partitions, not only when the current
    partition is 0 (Kai Mäkisara).
v2: also reset the EOF state after the load, as MTREW does (Sashiko).

 drivers/scsi/st.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 6e5e6f6..aa4d2ce 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2686,6 +2686,30 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		else {
 			STp->rew_at_close = STp->autorew_dev;
 			retval = check_tape(STp, filp);
+			/*
+			 * LOAD leaves the medium at the beginning of partition
+			 * 0.  check_tape() records that only for a new session;
+			 * without a new-medium unit attention (the medium was
+			 * already loaded) the partition and the partition state
+			 * would be left as before the load.  Reset them as a
+			 * new session does, for all partitions: a stale
+			 * ST_WRITING state would make st_flush() write a
+			 * filemark at the beginning of partition 0.
+			 */
+			if (retval == CHKRES_READY) {
+				int i;
+
+				STp->partition = STp->new_partition = 0;
+				for (i = 0; i < ST_NBR_PARTITIONS; i++) {
+					STps = &(STp->ps[i]);
+					STps->rw = ST_IDLE;
+					STps->eof = ST_NOEOF;
+					STps->at_sm = 0;
+					STps->last_block_valid = 0;
+					STps->drv_block = 0;
+					STps->drv_file = 0;
+				}
+			}
 			if (retval > 0)
 				retval = 0;
 		}
-- 
2.43.0

