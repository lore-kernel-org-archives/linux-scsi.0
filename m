Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C1A2744F
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2025 16:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765555787; cv=none; b=lo+VXQF6gstwqq/ZCdb1uWSKVduF3q8XUDFuQoQri2hZOSg2eWEQXypW7Dpe2Nbe2/QAgnYW6N1Ykw6XMdAOf95qJohoAnAR9eZ9s181COuwZ750VnizxxjIVDJgGcVqzNQNgx6IVU09jKhk+MEpvi6hEazcJ/Q/aHqzKCWZ0jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765555787; c=relaxed/simple;
	bh=AujmfkTbwqP/E76dqaUB4ui8t16Yu04oX7oiQB9mivk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=g2+g71SGw+2GQ1TDDQ6uH7+728wrPD2aYXu4TyvZeR/dwDrSyyhVVRsn5we8k+q1GVp9BADohancF9rP95eMbQwseaDc+jgQSUhLTbAW/Me/x5XlPLPZNmqakCvyerwIccYc4Xs+xMJttnYd9gTFssoFWJWHFlys2al6D2eEYSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S881/Trp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S881/Trp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765555784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jIpmMJZ0GT1pC3qJFArOYF4YEjADQGB0G916qA4tzCc=;
	b=S881/TrpFkRvUfu4VtulrRIOuZ/ZeqN8rdY7chV6OtHeLgxHFkG9BOmJWDZSi/Hxz59uwy
	4M1CcxjqNCZhcitwjgdd2REfFRu5VvR2GLwgJFt9Ty9lWLFeRsqMNOrSQWZI0cwaPmwpDO
	3GqFs0DUhE6eXvqfOb/BKY248YnR1d8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-8hy7skLgMa-srw0JXGcgqw-1; Fri,
 12 Dec 2025 11:09:40 -0500
X-MC-Unique: 8hy7skLgMa-srw0JXGcgqw-1
X-Mimecast-MFC-AGG-ID: 8hy7skLgMa-srw0JXGcgqw_1765555779
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8791C195608D;
	Fri, 12 Dec 2025 16:09:39 +0000 (UTC)
Received: from mrabek-thinkpadp1gen7.tpbc.com (unknown [10.45.225.244])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 83E69180045B;
	Fri, 12 Dec 2025 16:09:36 +0000 (UTC)
From: =?UTF-8?q?Michal=20R=C3=A1bek?= <mrabek@redhat.com>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: =?UTF-8?q?Michal=20R=C3=A1bek?= <mrabek@redhat.com>,
	Tomas Henzl <thenzl@redhat.com>,
	Changhui Zhong <czhong@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>
Subject: [PATCH] scsi: sg: fix occasional bogus elapsed time that exceeds timeout
Date: Fri, 12 Dec 2025 17:08:23 +0100
Message-ID: <20251212160900.64924-1-mrabek@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

A race condition was found in sg_proc_debug_helper(). It was observed on
a system using an IBM LTO-9 SAS Tape Drive (ULTRIUM-TD9) and monitoring
/proc/scsi/sg/debug every second. A very large elapsed time would
sometimes appear. This is caused by two race conditions.

We reproduced the issue with an IBM ULTRIUM-HH9 tape drive on an x86_64
architecture. A patched kernel was built, and the race condition could
not be observed anymore after the application of this patch. A reproducer
C program utilising the scsi_debug module was also built by
Changhui Zhong and can be viewed here:

https://github.com/MichaelRabek/linux-tests/blob/master/drivers/scsi/sg/sg_race_trigger.c

The first race happens between the reading of hp->duration in
sg_proc_debug_helper() and request completion in sg_rq_end_io().
The hp->duration member variable may hold either of two types of
information:
 #1 - The start time of the request. This value is present while
      the request is not yet finished.

 #2 - The total execution time of the request (end_time - start_time).

If sg_proc_debug_helper() executes *after* the value of hp->duration
was changed from #1 to #2, but *before* srp->done is set to 1 in
sg_rq_end_io(), a fresh timestamp is taken in the else branch, and the
elapsed time (value type #2) is subtracted from a timestamp, which
cannot yield a valid elapsed time (which is a type #2 value as well).

To fix this issue, the value of hp->duration must change under the
protection of the sfp->rq_list_lock in sg_rq_end_io().
Since sg_proc_debug_helper() takes this read lock, the change to
srp->done and srp->header.duration will happen atomically from the
perspective of sg_proc_debug_helper() and the race condition is thus
eliminated.

The second race condition happens between sg_proc_debug_helper() and
sg_new_write(). Even though hp->duration is set to the current time
stamp in sg_add_request() under the write lock's protection, it gets
overwritten by a call to get_sg_io_hdr(), which calls copy_from_user() to
copy struct sg_io_hdr from userspace into kernel space. hp->duration is
set to the start time again in sg_common_write(). If
sg_proc_debug_helper() is called between these two calls, an arbitrary
value set by userspace (usually zero) is used to compute the elapsed time.

To fix this issue, hp->duration must be set to the current timestamp again
after get_sg_io_hdr() returns successfully. A small race window still
exists between get_sg_io_hdr() and setting hp->duration, but this window
is only a few instructions wide and does not result in observable issues
in practice, as confirmed by testing.

Additionally, we fix the format specifier from %d to %u for printing
unsigned int values in sg_proc_debug_helper().

Signed-off-by: Michal Rábek <mrabek@redhat.com>
Suggested-by: Tomas Henzl <thenzl@redhat.com>
Tested-by: Changhui Zhong <czhong@redhat.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/sg.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b3af9b78fa12..57fba34832ad 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -731,6 +731,8 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 		sg_remove_request(sfp, srp);
 		return -EFAULT;
 	}
+	hp->duration = jiffies_to_msecs(jiffies);
+
 	if (hp->interface_id != 'S') {
 		sg_remove_request(sfp, srp);
 		return -ENOSYS;
@@ -815,7 +817,6 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		return -ENODEV;
 	}
 
-	hp->duration = jiffies_to_msecs(jiffies);
 	if (hp->interface_id != '\0' &&	/* v3 (or later) interface */
 	    (SG_FLAG_Q_AT_TAIL & hp->flags))
 		at_head = 0;
@@ -1338,9 +1339,6 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 				      "sg_cmd_done: pack_id=%d, res=0x%x\n",
 				      srp->header.pack_id, result));
 	srp->header.resid = resid;
-	ms = jiffies_to_msecs(jiffies);
-	srp->header.duration = (ms > srp->header.duration) ?
-				(ms - srp->header.duration) : 0;
 	if (0 != result) {
 		struct scsi_sense_hdr sshdr;
 
@@ -1389,6 +1387,9 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 			done = 0;
 	}
 	srp->done = done;
+	ms = jiffies_to_msecs(jiffies);
+	srp->header.duration = (ms > srp->header.duration) ?
+				(ms - srp->header.duration) : 0;
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
 	if (likely(done)) {
@@ -2533,6 +2534,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 	const sg_io_hdr_t *hp;
 	const char * cp;
 	unsigned int ms;
+	unsigned int duration;
 
 	k = 0;
 	list_for_each_entry(fp, &sdp->sfds, sfd_siblings) {
@@ -2570,13 +2572,17 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 			seq_printf(s, " id=%d blen=%d",
 				   srp->header.pack_id, blen);
 			if (srp->done)
-				seq_printf(s, " dur=%d", hp->duration);
+				seq_printf(s, " dur=%u", hp->duration);
 			else {
 				ms = jiffies_to_msecs(jiffies);
-				seq_printf(s, " t_o/elap=%d/%d",
+				duration = READ_ONCE(hp->duration);
+				if (duration)
+					duration = (ms > duration ?
+						    ms - duration : 0);
+				seq_printf(s, " t_o/elap=%u/%u",
 					(new_interface ? hp->timeout :
 						  jiffies_to_msecs(fp->timeout)),
-					(ms > hp->duration ? ms - hp->duration : 0));
+					duration);
 			}
 			seq_printf(s, "ms sgat=%d op=0x%02x\n", usg,
 				   (int) srp->data.cmd_opcode);
-- 
2.51.0

