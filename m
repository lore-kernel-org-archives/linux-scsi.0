Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.1 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550CCC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 15:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2603564E8E
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 15:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhBOPnt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Feb 2021 10:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhBOPnY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2021 10:43:24 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5601C061797
        for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2021 07:40:33 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id cv23so3933552pjb.5
        for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2021 07:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TNweTJAKjAFpD6e4hnHJJDvDmzaZBh3DS1A4WdeyZEo=;
        b=OcVVaOnudTUBWGg1yTtq0/CbYIRDdcu0N/akscFOsI5Xi/MEs4P17RD7ua5OXZNU1t
         8Wh6PaoRQSo4K2qAswA/oyz4bdlhy5yfeCRwj4/+UbkwCoCAibkDZ+bqyhif1YZZeBrH
         132sTACNLxdw5au4jgbHpFL2aQjozLbVHdw8o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TNweTJAKjAFpD6e4hnHJJDvDmzaZBh3DS1A4WdeyZEo=;
        b=h8XIJ7CaUZWvdWQ4gpzW90vxbKpPWdLuYfIKi1Q5XMx+o5kRbSm0qJm9bqeRjSAXXu
         VJt5ID8XGDvObL5G2S/uHSH4D5d6fYjAoiljOH1XKMIusMmO3+dig0/f3Tc+fR70JU+9
         iqQj6BJ+bYLNnkZzP0sL87cKJJ2PrHlJm8hi6zKfPOijUE60ITzkCr6lp/USPlg2ep2B
         SHYMakrKN1JgDjOlYjejNTVo/vDLy4DVnJsj9PhfQM2TsFmt8/+8ZowNdlxgZ/gxbgx5
         IX6bMPd0/ar8XOoAfTwgPyg+2Q+B++yFSBUsmNgZm4WakNgUqC6Cg5Rp5AEqz040XEUY
         rm3w==
X-Gm-Message-State: AOAM532E7+VVBzk6/YCIoasiowccmbtTNbRHIRbKPQ/JAbTl5PZgCTct
        EQl0SBEKgQWCZHB4Y0nejtmOb/ApnZrv7y66U+JGcclFPR166quTO09ZM7opNB+1dCloDN25U2O
        D6/3+ronGpTgAflFlXkMTAI7YAPFdK6jfsn7ZTkXuA7f0U62dTPJGW//jfvBPkHkLarXo8u5DFF
        WpbPiMwx23
X-Google-Smtp-Source: ABdhPJwAr3DAUiDoYyKCq/qWDNuI04dGiqwnusxvSp1pw2yp/yXyVBt0JKIKShppzm65g/IqryODvg==
X-Received: by 2002:a17:90a:ac14:: with SMTP id o20mr11994661pjq.171.1613403632815;
        Mon, 15 Feb 2021 07:40:32 -0800 (PST)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id m4sm18031341pgu.4.2021.02.15.07.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 07:40:32 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v4 4/5] scsi_debug: add new defer type for mq poll
Date:   Mon, 15 Feb 2021 13:10:47 +0530
Message-Id: <20210215074048.19424-5-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210215074048.19424-1-kashyap.desai@broadcom.com>
References: <20210215074048.19424-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000070e24605bb61ce23"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000070e24605bb61ce23

From: Douglas Gilbert <dgilbert@interlog.com>

Add a new sdeb_defer_type enumeration: SDEB_DEFER_POLL for requests
that have REQ_HIPRI set in cmd_flags field. It is expected that
these requests will be polled via the mq_poll entry point which
is driven by calls to blk_poll() in the block layer. Therefore
timer events are not 'wired up' in the normal fashion.

There are still cases with short delays (e.g. < 10 microseconds)
where by the time the command response processing occurs, the delay
is already exceeded in which case the code calls scsi_done()
directly. In such cases there is no window for mq_poll() to be
called.

Add 'mq_polls' counter that increments on each scsi_done() called
via the mq_poll entry point. Can be used to show (with 'cat
/proc/scsi/scsi_debug/<host_id>') that blk_poll() is causing
completions rather than some other mechanism.

This patch is improvement over previous patch 
"scsi_debug: iouring iopoll support"

Changes since version 3
  - Fix IO hang issue. Do not return from schedule_resp. Use new defer
    type for mq poll to queue the REQ_HIPRI IOs.

Changes since version 2 [sent 20210206 to linux-scsi list]
  - the sdebug_blk_mq_poll() callback didn't cope with the
    uncommon case where sqcp->sd_dp is NULL. Fix.

Changes since version 1 [sent 20210201 to linux-scsi list]
  - harden SDEB_DEFER_POLL which broke under testing
  - add mq_polls counter for debug output

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>


---
 drivers/scsi/scsi_debug.c | 148 ++++++++++++++++++++++++--------------
 1 file changed, 94 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 746eec521f79..c50de49a2c2f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -322,17 +322,19 @@ struct sdeb_store_info {
 	container_of(d, struct sdebug_host_info, dev)
 
 enum sdeb_defer_type {SDEB_DEFER_NONE = 0, SDEB_DEFER_HRT = 1,
-		      SDEB_DEFER_WQ = 2};
+		      SDEB_DEFER_WQ = 2, SDEB_DEFER_POLL = 3};
 
 struct sdebug_defer {
 	struct hrtimer hrt;
 	struct execute_work ew;
+	ktime_t cmpl_ts;/* time since boot to complete this cmd */
 	int sqa_idx;	/* index of sdebug_queue array */
 	int qc_idx;	/* index of sdebug_queued_cmd array within sqa_idx */
 	int hc_idx;	/* hostwide tag index */
 	int issuing_cpu;
 	bool init_hrt;
 	bool init_wq;
+	bool init_poll;
 	bool aborted;	/* true when blk_abort_request() already called */
 	enum sdeb_defer_type defer_t;
 };
@@ -357,6 +359,7 @@ static atomic_t sdebug_completions;  /* count of deferred completions */
 static atomic_t sdebug_miss_cpus;    /* submission + completion cpus differ */
 static atomic_t sdebug_a_tsf;	     /* 'almost task set full' counter */
 static atomic_t sdeb_inject_pending;
+static atomic_t sdeb_mq_poll_count;  /* bumped when mq_poll returns > 0 */
 
 struct opcode_info_t {
 	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff */
@@ -4730,7 +4733,6 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 	struct scsi_cmnd *scp;
 	struct sdebug_dev_info *devip;
 
-	sd_dp->defer_t = SDEB_DEFER_NONE;
 	if (unlikely(aborted))
 		sd_dp->aborted = false;
 	qc_idx = sd_dp->qc_idx;
@@ -4745,6 +4747,7 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 		return;
 	}
 	spin_lock_irqsave(&sqp->qc_lock, iflags);
+	sd_dp->defer_t = SDEB_DEFER_NONE;
 	sqcp = &sqp->qc_arr[qc_idx];
 	scp = sqcp->a_cmnd;
 	if (unlikely(scp == NULL)) {
@@ -5434,13 +5437,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	sd_dp = sqcp->sd_dp;
 	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 
-	/* Do not complete IO from default completion path.
-	 * Let it to be on queue.
-	 * Completion should happen from mq_poll interface.
-	 */
-	if ((sqp - sdebug_q_arr) >= (submit_queues - poll_queues))
-		return 0;
-
 	if (!sd_dp) {
 		sd_dp = kzalloc(sizeof(*sd_dp), GFP_ATOMIC);
 		if (!sd_dp) {
@@ -5517,40 +5513,66 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				kt -= d;
 			}
 		}
-		if (!sd_dp->init_hrt) {
-			sd_dp->init_hrt = true;
-			sqcp->sd_dp = sd_dp;
-			hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC,
-				     HRTIMER_MODE_REL_PINNED);
-			sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
-			sd_dp->sqa_idx = sqp - sdebug_q_arr;
-			sd_dp->qc_idx = k;
+		sd_dp->cmpl_ts = ktime_add(ns_to_ktime(ns_from_boot), kt);
+		if (cmnd->request->cmd_flags & REQ_HIPRI) {
+			spin_lock_irqsave(&sqp->qc_lock, iflags);
+			if (!sd_dp->init_poll) {
+				sd_dp->init_poll = true;
+				sqcp->sd_dp = sd_dp;
+				sd_dp->sqa_idx = sqp - sdebug_q_arr;
+				sd_dp->qc_idx = k;
+			}
+			sd_dp->defer_t = SDEB_DEFER_POLL;
+			spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+		} else {
+			if (!sd_dp->init_hrt) {
+				sd_dp->init_hrt = true;
+				sqcp->sd_dp = sd_dp;
+				hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC,
+					     HRTIMER_MODE_REL_PINNED);
+				sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
+				sd_dp->sqa_idx = sqp - sdebug_q_arr;
+				sd_dp->qc_idx = k;
+			}
+			sd_dp->defer_t = SDEB_DEFER_HRT;
+			/* schedule the invocation of scsi_done() for a later time */
+			hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
 		}
 		if (sdebug_statistics)
 			sd_dp->issuing_cpu = raw_smp_processor_id();
-		sd_dp->defer_t = SDEB_DEFER_HRT;
-		/* schedule the invocation of scsi_done() for a later time */
-		hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
 	} else {	/* jdelay < 0, use work queue */
-		if (!sd_dp->init_wq) {
-			sd_dp->init_wq = true;
-			sqcp->sd_dp = sd_dp;
-			sd_dp->sqa_idx = sqp - sdebug_q_arr;
-			sd_dp->qc_idx = k;
-			INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
-		}
-		if (sdebug_statistics)
-			sd_dp->issuing_cpu = raw_smp_processor_id();
-		sd_dp->defer_t = SDEB_DEFER_WQ;
 		if (unlikely((sdebug_opts & SDEBUG_OPT_CMD_ABORT) &&
 			     atomic_read(&sdeb_inject_pending)))
 			sd_dp->aborted = true;
-		schedule_work(&sd_dp->ew.work);
-		if (unlikely((sdebug_opts & SDEBUG_OPT_CMD_ABORT) &&
-			     atomic_read(&sdeb_inject_pending))) {
+		sd_dp->cmpl_ts = ns_to_ktime(ns_from_boot);
+		if (cmnd->request->cmd_flags & REQ_HIPRI) {
+			spin_lock_irqsave(&sqp->qc_lock, iflags);
+			if (!sd_dp->init_poll) {
+				sd_dp->init_poll = true;
+				sqcp->sd_dp = sd_dp;
+				sd_dp->sqa_idx = sqp - sdebug_q_arr;
+				sd_dp->qc_idx = k;
+			}
+			sd_dp->defer_t = SDEB_DEFER_POLL;
+			spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+		} else {
+			if (!sd_dp->init_wq) {
+				sd_dp->init_wq = true;
+				sqcp->sd_dp = sd_dp;
+				sd_dp->sqa_idx = sqp - sdebug_q_arr;
+				sd_dp->qc_idx = k;
+				INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
+			}
+			sd_dp->defer_t = SDEB_DEFER_WQ;
+			schedule_work(&sd_dp->ew.work);
+		}
+		if (sdebug_statistics)
+			sd_dp->issuing_cpu = raw_smp_processor_id();
+		if (unlikely(sd_dp->aborted)) {
 			sdev_printk(KERN_INFO, sdp, "abort request tag %d\n", cmnd->request->tag);
 			blk_abort_request(cmnd->request);
 			atomic_set(&sdeb_inject_pending, 0);
+			sd_dp->aborted = false;
 		}
 	}
 	if (unlikely((SDEBUG_OPT_Q_NOISE & sdebug_opts) && scsi_result == device_qfull_result))
@@ -5779,11 +5801,12 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 		   dix_reads, dix_writes, dif_errors);
 	seq_printf(m, "usec_in_jiffy=%lu, statistics=%d\n", TICK_NSEC / 1000,
 		   sdebug_statistics);
-	seq_printf(m, "cmnd_count=%d, completions=%d, %s=%d, a_tsf=%d\n",
+	seq_printf(m, "cmnd_count=%d, completions=%d, %s=%d, a_tsf=%d, mq_polls=%d\n",
 		   atomic_read(&sdebug_cmnd_count),
 		   atomic_read(&sdebug_completions),
 		   "miss_cpus", atomic_read(&sdebug_miss_cpus),
-		   atomic_read(&sdebug_a_tsf));
+		   atomic_read(&sdebug_a_tsf),
+		   atomic_read(&sdeb_mq_poll_count));
 
 	seq_printf(m, "submit_queues=%d\n", submit_queues);
 	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
@@ -7246,52 +7269,68 @@ static int sdebug_map_queues(struct Scsi_Host *shost)
 
 static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 {
-	int qc_idx;
-	int retiring = 0;
+	bool first;
+	bool retiring = false;
+	int num_entries = 0;
+	unsigned int qc_idx = 0;
 	unsigned long iflags;
+	ktime_t kt_from_boot = ktime_get_boottime();
 	struct sdebug_queue *sqp;
 	struct sdebug_queued_cmd *sqcp;
 	struct scsi_cmnd *scp;
 	struct sdebug_dev_info *devip;
-	int num_entries = 0;
+	struct sdebug_defer *sd_dp;
 
 	sqp = sdebug_q_arr + queue_num;
+	spin_lock_irqsave(&sqp->qc_lock, iflags);
 
-	do {
-		spin_lock_irqsave(&sqp->qc_lock, iflags);
-		qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
-		if (unlikely((qc_idx < 0) || (qc_idx >= sdebug_max_queue)))
-			goto out;
+	for (first = true; first || qc_idx + 1 < sdebug_max_queue; )   {
+		if (first) {
+			qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
+			first = false;
+		} else {
+			qc_idx = find_next_bit(sqp->in_use_bm, sdebug_max_queue, qc_idx + 1);
+		}
+		if (unlikely(qc_idx >= sdebug_max_queue))
+			break;
 
 		sqcp = &sqp->qc_arr[qc_idx];
+		sd_dp = sqcp->sd_dp;
+		if (unlikely(!sd_dp))
+			continue;
 		scp = sqcp->a_cmnd;
 		if (unlikely(scp == NULL)) {
-			pr_err("scp is NULL, queue_num=%d, qc_idx=%d from %s\n",
+			pr_err("scp is NULL, queue_num=%d, qc_idx=%u from %s\n",
 			       queue_num, qc_idx, __func__);
-			goto out;
+			break;
 		}
+		if (sd_dp->defer_t == SDEB_DEFER_POLL) {
+			if (kt_from_boot < sd_dp->cmpl_ts)
+				continue;
+
+		} else		/* ignoring non REQ_HIPRI requests */
+			continue;
 		devip = (struct sdebug_dev_info *)scp->device->hostdata;
 		if (likely(devip))
 			atomic_dec(&devip->num_in_q);
 		else
 			pr_err("devip=NULL from %s\n", __func__);
 		if (unlikely(atomic_read(&retired_max_queue) > 0))
-			retiring = 1;
+			retiring = true;
 
 		sqcp->a_cmnd = NULL;
 		if (unlikely(!test_and_clear_bit(qc_idx, sqp->in_use_bm))) {
-			pr_err("Unexpected completion sqp %p queue_num=%d qc_idx=%d from %s\n",
+			pr_err("Unexpected completion sqp %p queue_num=%d qc_idx=%u from %s\n",
 				sqp, queue_num, qc_idx, __func__);
-			goto out;
+			break;
 		}
-
 		if (unlikely(retiring)) {	/* user has reduced max_queue */
 			int k, retval;
 
 			retval = atomic_read(&retired_max_queue);
 			if (qc_idx >= retval) {
 				pr_err("index %d too large\n", retval);
-				goto out;
+				break;
 			}
 			k = find_last_bit(sqp->in_use_bm, retval);
 			if ((k < sdebug_max_queue) || (k == retval))
@@ -7299,17 +7338,18 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 			else
 				atomic_set(&retired_max_queue, k + 1);
 		}
+		sd_dp->defer_t = SDEB_DEFER_NONE;
 		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 		scp->scsi_done(scp); /* callback to mid level */
+		spin_lock_irqsave(&sqp->qc_lock, iflags);
 		num_entries++;
-	} while (1);
-
-out:
+	}
 	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+	if (num_entries > 0)
+		atomic_add(num_entries, &sdeb_mq_poll_count);
 	return num_entries;
 }
 
-
 static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 				   struct scsi_cmnd *scp)
 {
-- 
2.18.1


--00000000000070e24605bb61ce23
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg04+IxJk0
Woj+6ShhNFO8tzFWiXkjK61VuXi0WJHvoCwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwMjE1MTU0MDMzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABR7T64umWEbSJEynX/t7GGWTt3P
NBesQfGJnZWXEm0wJda8CwLSSINrw+ffok/ZvevGhP3JXGkj9AYWzcDy7KaRcY7kFr4FqIcLHozR
mMfj7nDEPoALNvSUSzt8m5MV8Li8kdfjROG3OQEVpQPAyzc8Jg8RlbCFov5JkUn/63prXcTzBfE/
oXtWnmu7y2fCPVWcut77CUkqybtt/O5CX29sB6/gGme/EeQLdROmKGZrB6B91XmkSyD5s8SicRuY
U2vd82IYfF7NVLnjzHpLoqu96WaxV0pwiprxUF3W1YQyoD/nX1EaAzGWZUPqTU1s+5tIS1tAayzj
fGkJMwGSvOg=
--00000000000070e24605bb61ce23--
