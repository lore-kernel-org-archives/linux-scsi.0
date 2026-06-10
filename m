Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409E03E44E0
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 10:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781088686; cv=none; b=ezxMevlfmWzbI0yeoPY8Cb7Py7D1wjxjsKmitidnT3ghP7VXxfVb/ZMuf3Tp2k7GqowQlrQamV11Gdzb0n9PCqxStIPxss/fYKNp8Frah+7ASLBTQSSW3A+yLvIk3UQtCQj9LkzPz7jBgceKaAm6Z9UasnOS21shv1XshJNNn7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781088686; c=relaxed/simple;
	bh=u9xZUUfGLIzCC48MsO793gADROAJqbMVryShW1o7CVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZqZD71pJU7/IQ4K/25GtZgY6k+ssnU1RZsELJzChQvSmjo5aP//A8fpS6WkcHHsx7YfW8AafwqzfPmqNG+8oB2b1eMcPyLC03N4YSuWjtshqnLUioVOEhqmndlElf38zMC5vnoLYPayoqeBmYajx9Z0/urdlbKPuOiLCPlk8ipY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9TPR0O9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9TPR0O9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED191F00893;
	Wed, 10 Jun 2026 10:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781088684;
	bh=9eNtEnWJbr6xyeGRtEQ112hjGHB18HlY3yVzhoWMwgk=;
	h=From:To:Cc:Subject:Date;
	b=H9TPR0O9P5mwmKyoVhGyFugxMtKXZAs7Ce9tbYFkoYO+2iSzqWW11y0+XNRlIVqvU
	 RfWZuE6tMmMgRhMbujw5Ulj7009QFJFX3C8c4xjzjJ9VelkDQ5oAfmvjWxKlGfR51D
	 IyAfL+GZtWc14nKS5P1d+q/D5XXnVyQ5MrxG04g4Pm+wvsxZ5BkBgq+ME3p8LghDmr
	 b9SNg7aN5AVlkg5SzzKYZJgvgsfyLyfHXb6HynoKqXIFK7Ij7SLlMgfgv/l+IALRy5
	 KufFS3m0KndnR7z4Dlvlc1X10WtR4+LbdFuQZPWC4OvYW/rxbys+dUtEFkatDPecR6
	 PQDw9KreNtgGA==
From: Hannes Reinecke <hare@kernel.org>
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH] scsi_error: send device reset if asynchronous abort failed
Date: Wed, 10 Jun 2026 12:51:19 +0200
Message-ID: <20260610105119.30903-1-hare@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current SCSI EH implementation requires us to enter the error
handler before a device reset can be send, requiring us to wait for
all outstanding commands on the _host_ before a device reset can be
issued. This is causing a noticeable I/O stall on SAS JBODs if an
individual device fails.

But a device reset has a very well defined scope, so there really should
not be any implications to _other_ devices on the same host when the
device reset is issued.
So it should be possible to issue a device reset directly from
scsi_eh_abort_handler() once a command abort fails without having to
wait for outstanding commands on any other devices on the same host.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/scsi_error.c | 17 ++++++++++++++++-
 drivers/scsi/scsi_priv.h  |  1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..23dc50332f58 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -58,6 +58,7 @@
 #define HOST_RESET_SETTLE_TIME  (10)
 
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
+static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_cmnd *scmd);
 static enum scsi_disposition scsi_try_to_abort_cmd(const struct scsi_host_template *,
 						   struct scsi_cmnd *);
 
@@ -170,7 +171,16 @@ scmd_eh_abort_handler(struct work_struct *work)
 				    "cmd abort %s\n",
 				    (rtn == FAST_IO_FAIL) ?
 				    "not send" : "failed"));
-		goto out;
+		if (scsi_host_eh_past_deadline(shost))
+			goto out;
+		rtn = scsi_try_bus_device_reset(scmd);
+		if (rtn != SUCCESS) {
+			scmd_printk(KERN_INFO, scmd,
+				    "device reset %s\n",
+				    (rtn == FAST_IO_FAIL) ?
+				    "not send" : "failed");
+			goto out;
+		}
 	}
 	set_host_byte(scmd, DID_TIME_OUT);
 	if (scsi_host_eh_past_deadline(shost)) {
@@ -1013,6 +1023,11 @@ static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
+	/* Device reset had already been issued, escalate to next level */
+	if (scmd->eh_eflags & SCSI_EH_RESET_SCHEDULED)
+		return FAILED;
+
+	scmd->eh_eflags |= SCSI_EH_RESET_SCHEDULED;
 	rtn = hostt->eh_device_reset_handler(scmd);
 	if (rtn == SUCCESS)
 		__scsi_report_device_reset(scmd->device, NULL);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 7a193cc04e5b..be0570cea445 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -39,6 +39,7 @@ static inline u8 scsi_ml_byte(int result)
  * Scsi Error Handler Flags
  */
 #define SCSI_EH_ABORT_SCHEDULED	0x0002	/* Abort has been scheduled */
+#define SCSI_EH_RESET_SCHEDULED	0x0004  /* Reset has been scheduled */
 
 #define SCSI_SENSE_VALID(scmd) \
 	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
-- 
2.51.0

