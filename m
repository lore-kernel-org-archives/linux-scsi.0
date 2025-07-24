Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1288256C87
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 09:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753350850; cv=none; b=SDeToZaJDpIOyujFXhjWeQ5v4mZfBmZN158kyS2Upqhr9C5hHblCsUYeI2+Vu03in92hzSg9mZyoeZ2hJVZCJ1YX/CUof2OSdn6yqWDAv9+dnYFrwFgJJelT7evT2qHs7cYrA2vh8V7YQRtSnF41UDwaeetuSUUHCS+8MdVx4s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753350850; c=relaxed/simple;
	bh=WcF6xpokxwzlJrNXM5/RyUhYhU2INZSxrM92z372VH0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=E5Gfhgl0CO5Ez4Ae2az51cqcsg+zCeq4s78rYlY3nVveaFC3GhepbwmP1nNrKbmdHaV53yCjknf6LIRxnR64CDSMspfQqcvu72Wl5VOHQS/J+lt5Z42L9H5JjSAt33W+ahxge0IP1lGFXEKSctmQt8bnlgtZbt6+EPvqMOhB4uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C8eauC+7; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C8eauC+7"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae36e88a5daso146742366b.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 02:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753350846; x=1753955646; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3afnkN64rgkJ4PGIlgJYgq8kxAPT8TglLMcyleOp7QM=;
        b=C8eauC+7q/n2sCtRJjmx0ubUlR54U+faIhg5WTieG5r3+WWGkZGzMMvUKxLZm4psQh
         yHQFzBi2zh+ga23B4FXOrkq4kLsuxGu4BYMXvxxQjhHjoQib5d+B+ji9Sod2Gck3xWEK
         DZEPHDVDp8SOrb+v/jN2XayC+pPzHZq9zYx8zDnG/HatR2FhbEZRzUCEFOo3IHqZSzMK
         aR8uEFgb8wNEVr5w+/o/MXdLd1pp++Tx19WTIkkXB1r/WRmx1nWGBS86wkyCtATn1B+d
         +10kkptVUlW1jQS5gFRy6V5lnDEOvs7dYVG3/43bFEqBl2zWb3MqhOcQOOLLhtLZS7Ja
         IGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753350846; x=1753955646;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3afnkN64rgkJ4PGIlgJYgq8kxAPT8TglLMcyleOp7QM=;
        b=s9EHPF2GcGitljXdpAxmM6v7CEk/n7fo3fW9v2HnRAsDgBkCW8bZ20iZNNYIkvGxie
         MOc9QrpVNanJQ9j0SA0xgeIafaAaTwMk+LWqlMSdPsOlMxSG3o0WUSb1fRPe/eD/JS1P
         7A+4BxKHBrN62oijgUGo3HndQro4cUWBdW9i6OH2sTj2CYcCgXC5nbXbFK5bcyKI8VeN
         UA0e2vVUYwTdcaUAmLUqqWtyR+GEtljRTqEa5hQmrbY7SYBPpPQBkfzXQLP6wyLngqwU
         Zt6Ah/Gj3lViQpOB3ST4lrMDeQYKXc3HKvyKndNh1rPhcDP9kR5dCsH2V+rQltR0Wepd
         TyyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQbUWh078TIS1ZfoFaLyBBlPJyQIPmgvqm/S0yDcd+Y8/naGbKXlyCqBMceXBdm2ReP2j+Sc3D8iMB@vger.kernel.org
X-Gm-Message-State: AOJu0YxkXb333zdJrEoxrrIgg8KXjHyvyEujnmr98+oqZ6Tm0SkDEME2
	yKAcp6I/1SF1QjEcSzHk4snoM61pndhDL5lFWuL4OCrm1fF62tEUdxGmk2+lsSRvV3c=
X-Gm-Gg: ASbGncu5mOaJ6prX6m3p2rt/b8TZDlbhXsm+C5WWV1VdEO27SCaG6RyzRcBki+wkbdN
	h1V0p45Ud8u21hmpscf0GqE5A1JYX0ik1yIWX3FbM3qcuXpATNUOB3MPGUfBJbdE3uM20yWgh0x
	jhuuwyNYiddaP8CZgeWiokf0gRdckDuz/CTqK17d0RlY2vNdtYX7zaxovPItuyYa0GOxIO9LyeG
	Q5i5bngNWg8RRfpk9/SLY359iVynpge0HDjM5BUdIcBTfSNrO9C7PctZK1JEJ75x3mT4DPEUTxH
	7lOQXwg1mbuSRY8ChxwgldzQlU77bi3dXPBgp0Crabx80//X6+360YJnaeIpex0f/Cilq0YJZqD
	vRPa9rXxPF48tnsSnPgqrKGVKsJ6jhZXPgW+2h9QjnRBOUqytg1Au83pbEDr3fbL4jNi25HRnxp
	JM1UwP6g==
X-Google-Smtp-Source: AGHT+IFHYymL9oDH+OmJ63UR7HAgIqk6CZwcN+nCiNZRoJ6YszCboGJRFm+lcNwnTOALwkzfBVj61A==
X-Received: by 2002:a17:907:971a:b0:ae3:67c7:54a6 with SMTP id a640c23a62f3a-af2f865c46bmr576812766b.34.1753350845774;
        Thu, 24 Jul 2025 02:54:05 -0700 (PDT)
Received: from puffmais.c.googlers.com (8.239.204.35.bc.googleusercontent.com. [35.204.239.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af47f44eab2sm88202166b.84.2025.07.24.02.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:54:05 -0700 (PDT)
From: =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Date: Thu, 24 Jul 2025 10:54:00 +0100
Subject: [PATCH] scsi: ufs: core: move some irq handling back to hardirq
 (with time limit)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250724-ufshcd-hardirq-v1-1-6398a52f8f02@linaro.org>
X-B4-Tracking: v=1; b=H4sIALcCgmgC/x3MQQqAIBBA0avErBNqLIWuEi1Ex5yN1UgRRHdPW
 r7F/w8UEqYCU/OA0MWFt1zRtw345PJKikM1YIdjZ1GrM5bkg0pOAsuhvNVoohmQRgM12oUi3/9
 wXt73A9nf2U9gAAAA
X-Change-ID: 20250723-ufshcd-hardirq-c7326f642e56
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>, 
 Tudor Ambarus <tudor.ambarus@linaro.org>, 
 Will McVicker <willmcvicker@google.com>, 
 Manivannan Sadhasivam <mani@kernel.org>, kernel-team@android.com, 
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
X-Mailer: b4 0.14.2

Commit 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service
routine to a threaded IRQ handler") introduced a massive performance
drop for various work loads on UFSHC versions < 4 due to the extra
latency introduced by moving all of the IRQ handling into a threaded
handler. See below for a summary.

To resolve this performance drop, move IRQ handling back into hardirq
context, but apply a time limit which, once expired, will cause the
remainder of the work to be deferred to the threaded handler.

Above commit is trying to avoid unduly delay of other subsystem
interrupts while the UFS events are being handled. By limiting the
amount of time spent in hardirq context, we can still ensure that.

The time limit itself was chosen because I have generally seen
interrupt handling to have been completed within 20 usecs, with the
occasional spikes of a couple 100 usecs.

This commits brings UFS performance roughly back to original
performance, and should still avoid other subsystem's starvation thanks
to dealing with these spikes.

fio results on Pixel 6:
  read / 1 job     original    after    this commit
    min IOPS        4,653.60   2,704.40    3,902.80
    max IOPS        6,151.80   4,847.60    6,103.40
    avg IOPS        5,488.82   4,226.61    5,314.89
    cpu % usr           1.85       1.72        1.97
    cpu % sys          32.46      28.88       33.29
    bw MB/s            21.46      16.50       20.76

  read / 8 jobs    original    after    this commit
    min IOPS       18,207.80  11,323.00   17,911.80
    max IOPS       25,535.80  14,477.40   24,373.60
    avg IOPS       22,529.93  13,325.59   21,868.85
    cpu % usr           1.70       1.41        1.67
    cpu % sys          27.89      21.85       27.23
    bw MB/s            88.10      52.10       84.48

  write / 1 job    original    after    this commit
    min IOPS        6,524.20   3,136.00    5,988.40
    max IOPS        7,303.60   5,144.40    7,232.40
    avg IOPS        7,169.80   4,608.29    7,014.66
    cpu % usr           2.29       2.34        2.23
    cpu % sys          41.91      39.34       42.48
    bw MB/s            28.02      18.00       27.42

  write / 8 jobs   original    after    this commit
    min IOPS       12,685.40  13,783.00   12,622.40
    max IOPS       30,814.20  22,122.00   29,636.00
    avg IOPS       21,539.04  18,552.63   21,134.65
    cpu % usr           2.08       1.61        2.07
    cpu % sys          30.86      23.88       30.64
    bw MB/s            84.18      72.54       82.62

Closes: https://lore.kernel.org/all/1e06161bf49a3a88c4ea2e7a406815be56114c4f.camel@linaro.org
Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine to a threaded IRQ handler")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
---
 drivers/ufs/core/ufshcd.c | 192 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 153 insertions(+), 39 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 13f7e0469141619cfc5e180aa730171ff01b8fb1..a117c6a30680f4ece113a7602b61f9f09bd4fda5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -111,6 +111,9 @@ enum {
 /* bMaxNumOfRTT is equal to two after device manufacturing */
 #define DEFAULT_MAX_NUM_RTT 2
 
+/* Time limit in usecs for hardirq context */
+#define HARDIRQ_TIMELIMIT 20
+
 /* UFSHC 4.0 compliant HC support this mode. */
 static bool use_mcq_mode = true;
 
@@ -5603,14 +5606,31 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
  * __ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
  * @completed_reqs: bitmask that indicates which requests to complete
+ * @time_limit: maximum amount of jiffies to spend executing command completion
+ *
+ * This completes the individual requests as per @completed_reqs with an
+ * optional time limit. If a time limit is given and it expired before all
+ * requests were handled, the return value will indicate which requests have not
+ * been handled.
+ *
+ * Return: Bitmask that indicates which requests have not been completed due to
+ *time limit expiry.
  */
-static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
-					unsigned long completed_reqs)
+static unsigned long __ufshcd_transfer_req_compl(struct ufs_hba *hba,
+						 unsigned long completed_reqs,
+						 unsigned long time_limit)
 {
 	int tag;
 
-	for_each_set_bit(tag, &completed_reqs, hba->nutrs)
+	for_each_set_bit(tag, &completed_reqs, hba->nutrs) {
 		ufshcd_compl_one_cqe(hba, tag, NULL);
+		__clear_bit(tag, &completed_reqs);
+		if (time_limit && time_after_eq(jiffies, time_limit))
+			break;
+	}
+
+	/* any bits still set represent unhandled requests due to timeout */
+	return completed_reqs;
 }
 
 /* Any value that is not an existing queue number is fine for this constant. */
@@ -5633,16 +5653,29 @@ static void ufshcd_clear_polled(struct ufs_hba *hba,
 	}
 }
 
-/*
- * Return: > 0 if one or more commands have been completed or 0 if no
- * requests have been completed.
+/**
+ * ufshcd_poll_impl - handle SCSI and query command completion helper
+ * @shost: Scsi_Host instance
+ * @queue_num: The h/w queue number, or UFSHCD_POLL_FROM_INTERRUPT_CONTEXT when
+ *             invoked from the interrupt handler
+ * @time_limit: maximum amount of jiffies to spend executing command completion
+ * @__pending: Pointer to store any still pending requests in case of time limit
+ *             expiry
+ *
+ * This handles completed commands with an optional time limit. If a time limit
+ * is given and it expires, @__pending will be set to the requests that could
+ * not be completed in time and are still pending.
+ *
+ * Return: true if one or more commands have been completed, false otherwise.
  */
-static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
+static int ufshcd_poll_impl(struct Scsi_Host *shost, unsigned int queue_num,
+			    unsigned long time_limit, unsigned long *__pending)
 {
 	struct ufs_hba *hba = shost_priv(shost);
 	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
 	struct ufs_hw_queue *hwq;
+	unsigned long pending = 0;
 
 	if (hba->mcq_enabled) {
 		hwq = &hba->uhq[queue_num];
@@ -5656,19 +5689,39 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
 		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
 		  hba->outstanding_reqs);
-	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
-		/* Do not complete polled requests from interrupt context. */
+	if (time_limit) {
+		/* Do not complete polled requests from hardirq context. */
 		ufshcd_clear_polled(hba, &completed_reqs);
 	}
+
+	if (completed_reqs)
+		pending = __ufshcd_transfer_req_compl(hba, completed_reqs,
+						      time_limit);
+
+	completed_reqs &= ~pending;
 	hba->outstanding_reqs &= ~completed_reqs;
+
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
-	if (completed_reqs)
-		__ufshcd_transfer_req_compl(hba, completed_reqs);
+	if (__pending)
+		*__pending = pending;
 
 	return completed_reqs != 0;
 }
 
+/*
+ * ufshcd_poll - SCSI interface of blk_poll to poll for IO completions
+ * @shost: Scsi_Host instance
+ * @queue_num: The h/w queue number
+ *
+ * Return: > 0 if one or more commands have been completed or 0 if no
+ * requests have been completed.
+ */
+static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
+{
+	return ufshcd_poll_impl(shost, queue_num, 0, NULL);
+}
+
 /**
  * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
  * invoked from the error handler context or ufshcd_host_reset_and_restore()
@@ -5722,13 +5775,19 @@ static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 /**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
+ * @time_limit: maximum amount of jiffies to spend executing command completion
  *
  * Return:
- *  IRQ_HANDLED - If interrupt is valid
- *  IRQ_NONE    - If invalid interrupt
+ *  IRQ_HANDLED     - If interrupt is valid
+ *  IRQ_WAKE_THREAD - If further interrupt processing should be delegated to the
+ *                    thread
+ *  IRQ_NONE        - If invalid interrupt
  */
-static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
+static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba,
+					     unsigned long time_limit)
 {
+	unsigned long pending;
+
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
 	 * In order to prevent other interrupts starvation the DB is read once
@@ -5744,12 +5803,19 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 		return IRQ_HANDLED;
 
 	/*
-	 * Ignore the ufshcd_poll() return value and return IRQ_HANDLED since we
-	 * do not want polling to trigger spurious interrupt complaints.
+	 * Ignore the ufshcd_poll() return value and return IRQ_HANDLED or
+	 * IRQ_WAKE_THREAD since we do not want polling to trigger spurious
+	 * interrupt complaints.
 	 */
-	ufshcd_poll(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
+	ufshcd_poll_impl(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT,
+			 time_limit, &pending);
 
-	return IRQ_HANDLED;
+	/*
+	 * If a time limit was set, some requests completions might not have
+	 * been handled yet and will need to be dealt with in the threaded
+	 * interrupt handler.
+	 */
+	return pending ? IRQ_WAKE_THREAD : IRQ_HANDLED;
 }
 
 int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask)
@@ -6310,7 +6376,7 @@ static void ufshcd_complete_requests(struct ufs_hba *hba, bool force_compl)
 	if (hba->mcq_enabled)
 		ufshcd_mcq_compl_pending_transfer(hba, force_compl);
 	else
-		ufshcd_transfer_req_compl(hba);
+		ufshcd_transfer_req_compl(hba, 0);
 
 	ufshcd_tmc_handler(hba);
 }
@@ -7012,12 +7078,16 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
  * ufshcd_sl_intr - Interrupt service routine
  * @hba: per adapter instance
  * @intr_status: contains interrupts generated by the controller
+ * @time_limit: maximum amount of jiffies to spend executing command completion
  *
  * Return:
- *  IRQ_HANDLED - If interrupt is valid
- *  IRQ_NONE    - If invalid interrupt
+ *  IRQ_HANDLED     - If interrupt is valid
+ *  IRQ_WAKE_THREAD - If further interrupt processing should be delegated to the
+ *                    thread
+ *  IRQ_NONE        - If invalid interrupt
  */
-static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
+static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status,
+				  unsigned long time_limit)
 {
 	irqreturn_t retval = IRQ_NONE;
 
@@ -7031,7 +7101,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_transfer_req_compl(hba);
+		retval |= ufshcd_transfer_req_compl(hba, time_limit);
 
 	if (intr_status & MCQ_CQ_EVENT_STATUS)
 		retval |= ufshcd_handle_mcq_cq_events(hba);
@@ -7040,15 +7110,25 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 }
 
 /**
- * ufshcd_threaded_intr - Threaded interrupt service routine
+ * ufshcd_intr_helper - hardirq and threaded interrupt service routine
  * @irq: irq number
  * @__hba: pointer to adapter instance
+ * @time_limit: maximum amount of jiffies to spend executing
+ *
+ * Interrupts are initially served from hardirq context with a time limit, but
+ * if there is more work to be done than can be completed before the limit
+ * expires, remaining work is delegated to the IRQ thread. This helper does the
+ * bulk of the work in either case - if @time_limit is set, it is being run from
+ * hardirq context, otherwise from the threaded interrupt handler.
  *
  * Return:
- *  IRQ_HANDLED - If interrupt is valid
- *  IRQ_NONE    - If invalid interrupt
+ *  IRQ_HANDLED     - If interrupt was fully handled
+ *  IRQ_WAKE_THREAD - If further interrupt processing should be delegated to the
+ *                    thread
+ *  IRQ_NONE        - If invalid interrupt
  */
-static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
+static irqreturn_t ufshcd_intr_helper(int irq, void *__hba,
+				      unsigned long time_limit)
 {
 	u32 last_intr_status, intr_status, enabled_intr_status = 0;
 	irqreturn_t retval = IRQ_NONE;
@@ -7062,15 +7142,22 @@ static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
 	 * if the reqs get finished 1 by 1 after the interrupt status is
 	 * read, make sure we handle them by checking the interrupt status
 	 * again in a loop until we process all of the reqs before returning.
+	 * This done until the time limit is exceeded, at which point further
+	 * processing is delegated to the threaded handler.
 	 */
-	while (intr_status && retries--) {
+	while (intr_status && !(retval & IRQ_WAKE_THREAD) && retries--) {
 		enabled_intr_status =
 			intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 		ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
 		if (enabled_intr_status)
-			retval |= ufshcd_sl_intr(hba, enabled_intr_status);
+			retval |= ufshcd_sl_intr(hba, enabled_intr_status,
+						 time_limit);
 
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
+
+		if (intr_status && time_limit && time_after_eq(jiffies,
+							       time_limit))
+			retval |= IRQ_WAKE_THREAD;
 	}
 
 	if (enabled_intr_status && retval == IRQ_NONE &&
@@ -7087,6 +7174,20 @@ static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
 	return retval;
 }
 
+/**
+ * ufshcd_threaded_intr - Threaded interrupt service routine
+ * @irq: irq number
+ * @__hba: pointer to adapter instance
+ *
+ * Return:
+ *  IRQ_HANDLED - If interrupt was fully handled
+ *  IRQ_NONE    - If invalid interrupt
+ */
+static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
+{
+	return ufshcd_intr_helper(irq, __hba, 0);
+}
+
 /**
  * ufshcd_intr - Main interrupt service routine
  * @irq: irq number
@@ -7094,20 +7195,33 @@ static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
  *
  * Return:
  *  IRQ_HANDLED     - If interrupt is valid
- *  IRQ_WAKE_THREAD - If handling is moved to threaded handled
+ *  IRQ_WAKE_THREAD - If handling is moved to threaded handler
  *  IRQ_NONE        - If invalid interrupt
  */
 static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
 	struct ufs_hba *hba = __hba;
+	unsigned long time_limit = jiffies +
+		usecs_to_jiffies(HARDIRQ_TIMELIMIT);
 
-	/* Move interrupt handling to thread when MCQ & ESI are not enabled */
-	if (!hba->mcq_enabled || !hba->mcq_esi_enabled)
-		return IRQ_WAKE_THREAD;
-
-	/* Directly handle interrupts since MCQ ESI handlers does the hard job */
-	return ufshcd_sl_intr(hba, ufshcd_readl(hba, REG_INTERRUPT_STATUS) &
-				   ufshcd_readl(hba, REG_INTERRUPT_ENABLE));
+	/*
+	 * Directly handle interrupts when MCQ & ESI are enabled since MCQ
+	 * ESI handlers do the hard job.
+	 */
+	if (hba->mcq_enabled && hba->mcq_esi_enabled)
+		return ufshcd_sl_intr(hba,
+				      ufshcd_readl(hba, REG_INTERRUPT_STATUS) &
+				      ufshcd_readl(hba, REG_INTERRUPT_ENABLE),
+				      0);
+
+	/* Otherwise handle interrupt in thread */
+	if (!time_limit)
+		/*
+		 * To deal with jiffies wrapping, we just add one so that other
+		 * code can reliably detect if a time limit was requested.
+		 */
+		time_limit++;
+	return ufshcd_intr_helper(irq, __hba, time_limit);
 }
 
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
@@ -7540,7 +7654,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 				__func__, pos);
 		}
 	}
-	__ufshcd_transfer_req_compl(hba, pending_reqs & ~not_cleared_mask);
+	__ufshcd_transfer_req_compl(hba, pending_reqs & ~not_cleared_mask, 0);
 
 out:
 	hba->req_abort_count = 0;
@@ -7696,7 +7810,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag);
+		__ufshcd_transfer_req_compl(hba, 1UL << tag, 0);
 		goto release;
 	}
 

---
base-commit: 58ba80c4740212c29a1cf9b48f588e60a7612209
change-id: 20250723-ufshcd-hardirq-c7326f642e56

Best regards,
-- 
André Draszik <andre.draszik@linaro.org>

