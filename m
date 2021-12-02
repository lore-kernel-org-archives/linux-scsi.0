Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051F6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Dec 2021 01:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354231AbhLBBNl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 20:13:41 -0500
Received: from mail-pj1-f44.google.com ([209.85.216.44]:46943 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344347AbhLBBNk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2021 20:13:40 -0500
Received: by mail-pj1-f44.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so3245846pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 01 Dec 2021 17:10:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Oi99Bjz4Tlpn+Wv0LD+NKMYmuxl3Dp3Yvw8/iqgcjQ=;
        b=3JbV2hxd4AkpgQ35gXsiWD0q4XzrH5q19yMddO67gPv5sfFw2Ha5SYrIFzaS+3e1q4
         i16yi2FtJKGfIxSSJykfj0vLa8qiB8c0vB+LPatr9FIwkyaxXjaIwrh1HRdgMvNBtfDL
         ypcg0aPDRoriZxVcGiRrZUI/za/yM1isX11C7QFsJ0NqKxE/fs1x20avqqWIzG8xj1C1
         7QsUkXiFaJWqZr0NqIUtpZiigv+ZhBfNBNI//Wfh1iUebwiGL1P/ROhl44BdLhMHG8fA
         d/3N/Ds2ZlYDVgNAhSyXNzXM1NFqBz6mhJGAfxdtdVT+x94rjG5b04KQGeLhB3w9rIrX
         mPpg==
X-Gm-Message-State: AOAM532oiBcMRe7t8LkBmr2OrRMuGRQx42UP+ZAKVbtwRA4Z7uK/shrx
        Zq53xpsw4cn9yjSIrBYxhqNdkUb5uBg=
X-Google-Smtp-Source: ABdhPJwJuTH2i8LIY7QGWVkyf7daa2PM9nyCAccu83sNxgm9F6A0GQlIu5rtIoNjT2a+PmDOdQuFfA==
X-Received: by 2002:a17:902:d505:b0:142:175d:1d4 with SMTP id b5-20020a170902d50500b00142175d01d4mr11739044plg.50.1638407418481;
        Wed, 01 Dec 2021 17:10:18 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7344:c0bd:a55f:88b8])
        by smtp.gmail.com with ESMTPSA id f19sm1053997pfv.76.2021.12.01.17.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 17:10:17 -0800 (PST)
Subject: Re: [PATCH v3 02/17] scsi: core: Fix a race between scsi_done() and
 scsi_times_out()
To:     Keith Busch <kbusch@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-3-bvanassche@acm.org>
 <20211201214309.GA3836713@dhcp-10-100-145-180.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4d3002b5-8d3d-a856-db83-58b60acb8e2a@acm.org>
Date:   Wed, 1 Dec 2021 17:10:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211201214309.GA3836713@dhcp-10-100-145-180.wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/21 1:43 PM, Keith Busch wrote:
> If the the timeout handler successfully sets the state to complete, and
> the lld returns BLK_EH_RESET_TIMER, who gets to complete this command?

That's a longstanding problem, isn't it? Anyway, how about replacing this
patch with the two untested patches below?


Subject: [PATCH 1/2] scsi: core: Rename scsi_cmnd.state

Prepare for removal of SCMD_STATE_COMPLETE. This patch does not change
any functionality.

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/hosts.c      |  2 +-
  drivers/scsi/scsi_error.c |  2 +-
  drivers/scsi/scsi_lib.c   | 12 ++++++------
  include/scsi/scsi_cmnd.h  |  4 ++--
  4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f69b77cbf538..f5869bd13bcf 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -572,7 +572,7 @@ static bool scsi_host_check_in_flight(struct request *rq, void *data,
  	int *count = data;
  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);

-	if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state))
+	if (test_bit(SCMD_STATE_INFLIGHT, &cmd->in_flight))
  		(*count)++;

  	return true;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9cb0f9df621a..7b603b259ae2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -353,7 +353,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
  		 * so return RESET_TIMER to allow error handling another shot
  		 * at this command.
  		 */
-		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
+		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->in_flight))
  			return BLK_EH_RESET_TIMER;
  		if (scsi_abort_command(scmd) != SUCCESS) {
  			set_host_byte(scmd, DID_TIME_OUT);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 621d841d819a..6bb0e2726d51 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -280,7 +280,7 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
  	unsigned long flags;

  	rcu_read_lock();
-	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
+	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->in_flight);
  	if (unlikely(scsi_host_in_recovery(shost))) {
  		spin_lock_irqsave(shost->host_lock, flags);
  		if (shost->host_failed || shost->host_eh_scheduled)
@@ -1138,7 +1138,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)

  	jiffies_at_alloc = cmd->jiffies_at_alloc;
  	retries = cmd->retries;
-	in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
+	in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->in_flight);
  	/*
  	 * Zero out the cmd, except for the embedded scsi_request. Only clear
  	 * the driver-private command data if the LLD does not supply a
@@ -1158,7 +1158,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
  	cmd->jiffies_at_alloc = jiffies_at_alloc;
  	cmd->retries = retries;
  	if (in_flight)
-		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
+		__set_bit(SCMD_STATE_INFLIGHT, &cmd->in_flight);
  	cmd->budget_token = budget_token;

  }
@@ -1367,7 +1367,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
  		spin_unlock_irq(shost->host_lock);
  	}

-	__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
+	__set_bit(SCMD_STATE_INFLIGHT, &cmd->in_flight);

  	return 1;

@@ -1597,7 +1597,7 @@ void scsi_done(struct scsi_cmnd *cmd)

  	if (unlikely(blk_should_fake_timeout(scsi_cmd_to_rq(cmd)->q)))
  		return;
-	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
+	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->in_flight)))
  		return;
  	trace_scsi_dispatch_cmd_done(cmd);
  	blk_mq_complete_request(scsi_cmd_to_rq(cmd));
@@ -1691,7 +1691,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
  			goto out_dec_host_busy;
  		req->rq_flags |= RQF_DONTPREP;
  	} else {
-		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
+		clear_bit(SCMD_STATE_COMPLETE, &cmd->in_flight);
  	}

  	cmd->flags &= SCMD_PRESERVED_FLAGS;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 477a800a9543..6cbfbfbbb803 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -60,7 +60,7 @@ struct scsi_pointer {
  /* flags preserved across unprep / reprep */
  #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED)

-/* for scmd->state */
+/* for scmd->in_flight */
  #define SCMD_STATE_COMPLETE	0
  #define SCMD_STATE_INFLIGHT	1

@@ -139,7 +139,7 @@ struct scsi_cmnd {

  	int result;		/* Status code from lower level driver */
  	int flags;		/* Command flags */
-	unsigned long state;	/* Command completion state */
+	unsigned long in_flight;/* Command completion state */

  	unsigned int extra_len;	/* length of alignment and padding */
  };




Subject: [PATCH 2/2] scsi: core: Fix a race between scsi_done() and scsi_times_out()

If scsi_done() and scsi_times_out() are called concurrently, make sure
that only one of these two functions proceeds. If scsi_done() is called
while scsi_times_out() is in progress and if scsi_times_out() returns
BLK_EH_RESET_TIMER, complete the command. If scsi_times_out() returns
BLK_EH_RESET_TIMER, allow scsi_done() to complete the command.

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Keith Busch <kbusch@kernel.org>
Fixes: 065990bd198e ("scsi: set timed out out mq requests to complete")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/scsi_error.c  | 35 +++++++++++++++++++++--------------
  drivers/scsi/scsi_lib.c    | 16 +++++++++++++---
  drivers/scsi/virtio_scsi.c |  4 ++--
  include/scsi/scsi_cmnd.h   | 12 ++++++++++--
  4 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7b603b259ae2..42dd967167e6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -330,6 +330,15 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
  	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
  	enum blk_eh_timer_return rtn = BLK_EH_DONE;
  	struct Scsi_Host *host = scmd->device->host;
+	int old = SCMD_STATE_SUBMITTED;
+
+	/*
+	 * scsi_done() may be called concurrently with scsi_times_out(). Only
+	 * one of these two functions should proceed. Hence return early if
+	 * scsi_done() won the race.
+	 */
+	if (!atomic_try_cmpxchg(&scmd->state, &old, SCMD_STATE_TIMED_OUT))
+		return BLK_EH_DONE;

  	trace_scsi_dispatch_cmd_timeout(scmd);
  	scsi_log_completion(scmd, TIMEOUT_ERROR);
@@ -341,26 +350,24 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
  		rtn = host->hostt->eh_timed_out(scmd);

  	if (rtn == BLK_EH_DONE) {
-		/*
-		 * Set the command to complete first in order to prevent a real
-		 * completion from releasing the command while error handling
-		 * is using it. If the command was already completed, then the
-		 * lower level driver beat the timeout handler, and it is safe
-		 * to return without escalating error recovery.
-		 *
-		 * If timeout handling lost the race to a real completion, the
-		 * block layer may ignore that due to a fake timeout injection,
-		 * so return RESET_TIMER to allow error handling another shot
-		 * at this command.
-		 */
-		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->in_flight))
-			return BLK_EH_RESET_TIMER;
  		if (scsi_abort_command(scmd) != SUCCESS) {
  			set_host_byte(scmd, DID_TIME_OUT);
  			scsi_eh_scmd_add(scmd);
  		}
+		return rtn;
  	}

+	/* The order of the atomic_try_cmpxchg() calls below is important. */
+	old = SCMD_STATE_TIMED_OUT;
+	if (atomic_try_cmpxchg(&scmd->state, &old, SCMD_STATE_SUBMITTED))
+		return rtn;
+	old = SCMD_STATE_COMPLETE_AFTER_TIMEOUT;
+	WARN_ON_ONCE(!atomic_try_cmpxchg(&scmd->state, &old,
+					 SCMD_STATE_COMPLETED));
+	WARN_ON_ONCE(scmd->submitter != SUBMITTED_BY_BLOCK_LAYER);
+	trace_scsi_dispatch_cmd_done(scmd);
+	blk_mq_complete_request(scsi_cmd_to_rq(scmd));
+
  	return rtn;
  }

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6bb0e2726d51..797ad188e7a2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1586,6 +1586,8 @@ static blk_status_t scsi_prepare_cmd(struct request *req)

  void scsi_done(struct scsi_cmnd *cmd)
  {
+	int old;
+
  	switch (cmd->submitter) {
  	case SUBMITTED_BY_BLOCK_LAYER:
  		break;
@@ -1597,8 +1599,15 @@ void scsi_done(struct scsi_cmnd *cmd)

  	if (unlikely(blk_should_fake_timeout(scsi_cmd_to_rq(cmd)->q)))
  		return;
-	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->in_flight)))
-		return;
+	for (;;) {
+		old = SCMD_STATE_SUBMITTED;
+		if (atomic_try_cmpxchg(&cmd->state, &old, SCMD_STATE_COMPLETED))
+			break;
+		old = SCMD_STATE_TIMED_OUT;
+		if (atomic_try_cmpxchg(&cmd->state, &old,
+				       SCMD_STATE_COMPLETE_AFTER_TIMEOUT))
+			return;
+	}
  	trace_scsi_dispatch_cmd_done(cmd);
  	blk_mq_complete_request(scsi_cmd_to_rq(cmd));
  }
@@ -1691,7 +1700,8 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
  			goto out_dec_host_busy;
  		req->rq_flags |= RQF_DONTPREP;
  	} else {
-		clear_bit(SCMD_STATE_COMPLETE, &cmd->in_flight);
+		BUILD_BUG_ON(SCMD_STATE_SUBMITTED != 0);
+		atomic_set(&cmd->state, SCMD_STATE_SUBMITTED);
  	}

  	cmd->flags &= SCMD_PRESERVED_FLAGS;
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 19f7d7b90625..9ea3ec308ecd 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -620,8 +620,8 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
  	 * we're using independent interrupts (e.g. MSI).  Poll the
  	 * virtqueues once.
  	 *
-	 * In the abort case, scsi_done() will do nothing, because the
-	 * command timed out and hence SCMD_STATE_COMPLETE has been set.
+	 * In the abort case, scsi_done() will do nothing. See also the
+	 * scsi_done() implementation.
  	 */
  	virtscsi_poll_requests(vscsi);

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6cbfbfbbb803..350b47792a4d 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -53,6 +53,14 @@ struct scsi_pointer {
  	volatile int phase;
  };

+enum scsi_cmd_state {
+	SCMD_STATE_SUBMITTED = 0,	/* Owned by device or not submitted. */
+	SCMD_STATE_COMPLETED = 1,	/* scsi_done() is in progress. */
+	SCMD_STATE_TIMED_OUT = 2,	/* Inside timeout handler. */
+	SCMD_STATE_COMPLETE_AFTER_TIMEOUT = 3, /* Complete after timeout
+						* handler finished. */
+} __packed;
+
  /* for scmd->flags */
  #define SCMD_TAGGED		(1 << 0)
  #define SCMD_INITIALIZED	(1 << 1)
@@ -61,8 +69,7 @@ struct scsi_pointer {
  #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED)

  /* for scmd->in_flight */
-#define SCMD_STATE_COMPLETE	0
-#define SCMD_STATE_INFLIGHT	1
+#define SCMD_STATE_INFLIGHT	0

  enum scsi_cmnd_submitter {
  	SUBMITTED_BY_BLOCK_LAYER = 0,
@@ -92,6 +99,7 @@ struct scsi_cmnd {
  	int retries;
  	int allowed;

+	atomic_t state; /* See also enum scsi_cmd_state */
  	unsigned char prot_op;
  	unsigned char prot_type;
  	unsigned char prot_flags;

