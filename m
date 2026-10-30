Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793400185;
	b=LjgR9u18nBAiEl4IswTUy3Blcq2Wh9Mj1YehK6+OwoSQBGtPIriyszXbDMXrbjbRFqS9
	 X4j2XZkZsjGFeDW0jXN0K0EGItSqfVrcOiyFWrDTdjSsxd15d0pfPPg3F2NcdJ9zVhZXc
	 zmVdJHdIMwleLkeUzhhaYSdXbUMAtx0vMrLqatGW13GNsf8uJN/9+wy82Vzja9GYOzKGE
	 8ySgMXFdRuo0MdA4gYgiPBp0GNNNU1QzGDI6B/0+AkAseP4SSytcqvchLxRfwCQ5EG7bN
	 VJ6I48cjULyW7NebTl2p9E9FceUU101TOwKC1MMRzzZlzNPcPwGZDaAb70TcmhibBUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400185;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=o//jy+71D40/uKY5u9bkIVT6n2V7hmHxHi0TQnVwEyw=;
	b=qxQaOb/NOaxQWJ3QBLFkHKp/hNLFJdtfuOYREzzbS7+FOrfOgRYAya42BeqIkqeHgE1n
	 GMNHDCz1k8upk8bfKS/viBxoQbJPRvJrcy+0uIybd3qFUUGbUGLYnvNzVFCHyqyDtrslj
	 xeMhHoYGN36QY7cDHqP56B7YYPCGnhvxrc2vCYKOQb54yXZ7N8sfYhkDd+6LD53TFvTRa
	 aE7a7a/Uc8ufTAGr1BPpf6O6Ng7ypF1c9jG30eAmQJmqCGHfWRWHW23NykVn5eH6gorxm
	 r30NBgA/6eMsPG08HqqCq9nq4u4Up19UFG4xdF5hnNOqWdn9ldER97iIiVbp7CbUwxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=I4In9Zbq;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7962B606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 22:43:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7962B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=I4In9Zbq
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jGbj408N7zlfvq2;
	Fri, 30 Oct 2026 22:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1793400177; x=1795992178; bh=o//jy
	+71D40/uKY5u9bkIVT6n2V7hmHxHi0TQnVwEyw=; b=I4In9Zbq4wWg5xJx61MbV
	RO1Dk4V4fcJq4JF4C0xuT848ngtXz1QA2raoLbKw4wdcKNtNq5yEAebjZVEy3deu
	G/T2FZPJnN4zaA25rDQKEGKb8Cp6V6FOJrn+nMVJTZA5N4GnIEsg9N0RaPpRWM9X
	R/LG9lAYqh9gA32RM+JWs2LZlE4ABXx3BW03gvtiF/qdaimy8DYlKRbOEtzTeWzY
	hPTbAFkky/UnMTVL8dbwJLwVuOUKNC3aNP4W1wQyCtxhgBrN+Ydqpa3hDvkomgqX
	R5tWbrPi+MchDoA7It7pJ2JKTReyLOLGriBYfEZf3jPVH4f9U3S9eL43mlUK7vXi
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dJNocJYpQruU; Fri, 30 Oct 2026 22:42:57 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (57.237.82.34.bc.googleusercontent.com [34.82.237.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jGbhw62JDzlfvqJ;
	Fri, 30 Oct 2026 22:42:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Alexey Charkov <alchark@flipper.net>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH 4/5] scsi: core: Escalate persistent UNIT ATTENTION conditions
Date: Fri, 30 Oct 2026 15:42:38 -0700
Message-ID: <5c34851674a67879e175251b9bfe6ccf091e390a.1793400000.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
In-Reply-To: <cover.1793400000.git.bvanassche@acm.org>
References: <cover.1793400000.git.bvanassche@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Recover from persistent UNIT ATTENTION conditions in the SCSI midlayer
instead of maintaining a per-device quirk list for targets such as
BIWIN BWU2A05* UFS devices that fail to clear power-on or reset UNIT
ATTENTION on WRITE commands while clearing it on commands such as TEST
UNIT READY, READ, and SYNCHRONIZE CACHE.

If a non-removable block request that is not failfast receives the same
UNIT ATTENTION repeatedly, retry it twice and invoke the error handler
thereafter, instead of letting scsi_io_completion_action() retry
uncounted until the command runtime limit is exceeded. The error
handler clears the UNIT ATTENTION by sending TEST UNIT READY. Track
this with a dedicated per-command counter and the additional sense code
of the most recent UNIT ATTENTION instead of scmd->retries.
scmd->retries is also incremented for other retry reasons and by the
error handler, and a target may report multiple queued UNIT ATTENTION
conditions with different additional sense codes. On most
architectures the new fields occupy an existing hole in struct
scsi_cmnd. Limit the number of error handler invocations for commands
with unlimited retries since scsi_eh_flush_done_q() does not limit
these.

Only apply this escalation when the sense data is evaluated by
scsi_decide_disposition() and leave the behavior of the exported
scsi_check_sense() function unchanged. libata calls scsi_check_sense()
from its own error handler, which translates FAILED into an ATA port
reset and never sends TEST UNIT READY.

Reported-by: Alexey Charkov <alchark@flipper.net>
Closes: https://lore.kernel.org/linux-scsi/20261028-biwin-tua-quirk-v1-1-=
767a12c9b9cc@flipper.net/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 81 ++++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_lib.c   |  2 +
 include/scsi/scsi_cmnd.h  |  7 ++++
 3 files changed, 81 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 321806cbcf2e..b8d3c6f2ad33 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -58,6 +58,16 @@
 #define BUS_RESET_SETTLE_TIME   (10)
 #define HOST_RESET_SETTLE_TIME  (10)
=20
+/*
+ * Number of times a command is retried if it receives the same UNIT ATT=
ENTION
+ * repeatedly before the error handler is invoked to clear that conditio=
n.
+ */
+#define SCSI_UA_RETRIES		2
+/*
+ * Maximum number of error handler invocations for a command with unlimi=
ted
+ * retries that keeps receiving the same UNIT ATTENTION.
+ */
+#define SCSI_UA_EH_ROUNDS	3
 /* Maximum number of TEST UNIT READY commands sent to clear a UNIT ATTEN=
TION. */
 #define SCSI_EH_CLEAR_UA_TURS	4
 /* Delay in milliseconds before a TEST UNIT READY command is retried. */
@@ -565,17 +575,15 @@ static inline void set_scsi_ml_byte(struct scsi_cmn=
d *cmd, u8 status)
 }
=20
 /**
- * scsi_check_sense - Examine scsi cmd sense
+ * __scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
+ * @escalate_ua: Whether to invoke the SCSI error handler for UNIT ATTEN=
TION
+ *	conditions that persist after retries.
  *
- * Return value:
- *	SUCCESS or FAILED or NEEDS_RETRY or ADD_TO_MLQUEUE
- *
- * Notes:
- *	When a deferred error is detected the current command has
- *	not been executed and needs retrying.
+ * Return: SUCCESS, FAILED, NEEDS_RETRY or ADD_TO_MLQUEUE.
  */
-enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
+static enum scsi_disposition __scsi_check_sense(struct scsi_cmnd *scmd,
+						bool escalate_ua)
 {
 	struct request *req =3D scsi_cmd_to_rq(scmd);
 	struct scsi_device *sdev =3D scmd->device;
@@ -722,6 +730,40 @@ enum scsi_disposition scsi_check_sense(struct scsi_c=
mnd *scmd)
 		    sshdr.sense_code =3D=3D
 		    LU_NOT_READY_INITIALIZING_COMMAND_REQUIRED)
 			return FAILED;
+		/*
+		 * Retry a UNIT ATTENTION that is reported repeatedly with the
+		 * same additional sense code SCSI_UA_RETRIES times on the
+		 * normal completion path for non-removable block requests,
+		 * then invoke the error handler so TEST UNIT READY can clear a
+		 * stuck UNIT ATTENTION. Use a dedicated counter instead of
+		 * scmd->retries since the latter is also incremented for
+		 * other retry reasons and by the error handler. Comparing the
+		 * additional sense code prevents escalation if a target
+		 * reports multiple queued UNIT ATTENTION conditions.
+		 */
+		if (escalate_ua && sshdr.sense_key =3D=3D UNIT_ATTENTION &&
+		    !sdev->removable && !scsi_noretry_cmd(scmd)) {
+			u8 asc =3D scsi_sense_asc(&sshdr);
+
+			if (scmd->ua_asc !=3D asc) {
+				scmd->ua_asc =3D asc;
+				scmd->ua_count =3D 0;
+			}
+			if (scmd->ua_count < U8_MAX)
+				scmd->ua_count++;
+			if (scmd->ua_count <=3D SCSI_UA_RETRIES)
+				return NEEDS_RETRY;
+			/*
+			 * scsi_eh_flush_done_q() limits the number of error
+			 * handler invocations unless retries are unlimited.
+			 * Pass the UNIT ATTENTION upwards in the latter case
+			 * once SCSI_UA_EH_ROUNDS attempts to clear it failed.
+			 */
+			if (scmd->allowed =3D=3D SCSI_CMD_RETRIES_NO_LIMIT &&
+			    scmd->ua_count > SCSI_UA_RETRIES + SCSI_UA_EH_ROUNDS)
+				return SUCCESS;
+			return FAILED;
+		}
 		/*
 		 * Pass the UA upwards for a determination in the completion
 		 * functions.
@@ -796,6 +838,27 @@ enum scsi_disposition scsi_check_sense(struct scsi_c=
mnd *scmd)
 		return SUCCESS;
 	}
 }
+
+/**
+ * scsi_check_sense - Examine scsi cmd sense
+ * @scmd:	Cmd to have sense checked.
+ *
+ * Return value:
+ *	SUCCESS or FAILED or NEEDS_RETRY or ADD_TO_MLQUEUE
+ *
+ * Notes:
+ *	When a deferred error is detected the current command has
+ *	not been executed and needs retrying.
+ *
+ *	Unlike the sense data evaluation by scsi_decide_disposition(), this
+ *	function never invokes the SCSI error handler for UNIT ATTENTION
+ *	conditions that persist after retries. Callers with their own error
+ *	handler, e.g. libata, rely on this.
+ */
+enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
+{
+	return __scsi_check_sense(scmd, false);
+}
 EXPORT_SYMBOL_GPL(scsi_check_sense);
=20
 static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
@@ -2271,7 +2334,7 @@ enum scsi_disposition scsi_decide_disposition(struc=
t scsi_cmnd *scmd)
 	case SAM_STAT_TASK_ABORTED:
 		goto maybe_retry;
 	case SAM_STAT_CHECK_CONDITION:
-		rtn =3D scsi_check_sense(scmd);
+		rtn =3D __scsi_check_sense(scmd, true);
 		if (rtn =3D=3D NEEDS_RETRY)
 			goto maybe_retry;
 		/* if rtn =3D=3D FAILED, we have no sense information;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ab39514cc0c6..ccbc1d4193e0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1272,6 +1272,8 @@ static void scsi_initialize_rq(struct request *rq)
 	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc =3D jiffies;
 	cmd->retries =3D 0;
+	cmd->ua_asc =3D 0;
+	cmd->ua_count =3D 0;
 }
=20
 /**
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 2f2364c96457..5a8f7a45dc6d 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -98,6 +98,13 @@ struct scsi_cmnd {
 	enum scsi_cmnd_submitter submitter;
=20
 	unsigned short cmd_len;
+	/*
+	 * Additional sense code of the most recent UNIT ATTENTION and the
+	 * number of consecutive UNIT ATTENTIONs with that additional sense
+	 * code. Only used by the SCSI core.
+	 */
+	u8 ua_asc;
+	u8 ua_count;
 	enum dma_data_direction sc_data_direction;
=20
 	unsigned char cmnd[32]; /* SCSI CDB */
