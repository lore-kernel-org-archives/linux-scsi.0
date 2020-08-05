Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D825C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7A622CF7
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:46:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="chwC3CUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgHEJqT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 05:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbgHEJp1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 05:45:27 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52B2C0617A0
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 02:45:24 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id o1so24958591plk.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2020 02:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Vs4ohT5ml+/RHTL8m+5tUUhTKflTPiKuw9gqdGTRkSA=;
        b=chwC3CUuzjhRvovtpePtnn+xxLaZBEBhwsyhRx9UDtch5OYSH5QUjY6R1+njKn8k6H
         Gx9be3a+QS3ovtfK5gvPfysTfpwkXEpqaSLAdXSAOC8QvD4khIJd+rl15CfC2crQjTar
         OnI2bIaYy7eFtNBlqECTWDXWri4eN1nQm50bo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Vs4ohT5ml+/RHTL8m+5tUUhTKflTPiKuw9gqdGTRkSA=;
        b=UxMKCsMgIKUrjkwJZCZTk6X8UG8YF8J5ZReAANdHa8po1dEMJVeNJudPZyNfmp7kfj
         reyw4rfknQi/W9MZn1tWakrzyU8PrWr5ge65+ck3U2DWYsJZUVJTX79vz3Ouk+P7dUDM
         t8ktvIKMJ50OsoOvjh+r8lWvA8e/GMoeZUh7f35QS8RgG1YL4iFMWOsTtWEcnR9GdXvk
         6ZZVzvP658HMsjLDTCMPiOQin/VqeXeFfQvSFyR5qZeyqtpPYGpyA5amOKZ7oqs30FVO
         W5/OEy67c5eq/oxvMKHdEHOXBS7h7Oz8lLpllS+gtEyozYa4hR2nCoaZVw+DmPmWQ745
         iDig==
X-Gm-Message-State: AOAM531kG+wbeema0G2Yxs3z324ZEjhe2BptUv49Z5UPv54PHqauowx6
        E+96ECjM8OVWmtIPAFagwCALu1JGULR1Rwm1oG63Vws19j5W0DEWPmtsl8XXtX9iojkQ/mVel23
        s94YK2Ru2Wj8eTad3quUvSLTX+04JGY5uH1zUJD2jt0/HSGjFZxuB3/zijQMlll8QJbT0oof0za
        fnXJdS9w==
X-Google-Smtp-Source: ABdhPJypzbVp8Jew6AoGp0c+0W5f3t7Tbw3uOgAwFhsnMAXuwS2XLSynTsvLo3gNd4Pi1X009XSAKg==
X-Received: by 2002:a17:902:7b82:: with SMTP id w2mr2340875pll.39.1596620723799;
        Wed, 05 Aug 2020 02:45:23 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id e9sm2632346pfh.151.2020.08.05.02.45.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 02:45:23 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hare@suse.de, jsmart2021@gmail.com, emilne@redhat.com,
        mkumar@redhat.com, Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH 4/5] scsi: Added routine to set SCMD_NORETRIES_ABORT bit for outstanding io on scsi_dev
Date:   Wed,  5 Aug 2020 08:21:01 +0530
Message-Id: <1596595862-11075-5-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added a new routine scsi_set_noretries_abort_io_device()to set
SCMD_NORETRIES_ABORT for all the inflight/pending IO's on a particular
scsi device at that particular instant.

Export the symbol so the routine can be called by scsi_transport_fc.c

Added new function declaration scsi_set_noretries_abort_io_device in
scsi_priv.h

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/scsi_error.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h  |  1 +
 2 files changed, 54 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3222496..938d770 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -271,6 +271,59 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 	call_rcu(&scmd->rcu, scsi_eh_inc_host_failed);
 }
 
+static bool
+scsi_set_noretries_abort_io(struct request *rq, void *priv, bool reserved)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	struct scsi_device *sdev = scmd->device;
+
+	/* only set SCMD_NORETRIES_ABORT on ios on a specific sdev */
+	if (sdev != priv)
+		return true;
+	/* we don't want this command reissued on abort success
+	 * so set SCMD_NORETRIES_ABORT bit to ensure it
+	 * won't get reissued
+	 */
+	if (READ_ONCE(rq->state) == MQ_RQ_IN_FLIGHT)
+		set_bit(SCMD_NORETRIES_ABORT, &scmd->state);
+	return true;
+}
+
+static int
+__scsi_set_noretries_abort_io_device(struct scsi_device *sdev)
+{
+
+	if (sdev->sdev_state != SDEV_RUNNING)
+		return -EINVAL;
+
+	if (blk_queue_init_done(sdev->request_queue)) {
+
+		blk_mq_quiesce_queue(sdev->request_queue);
+		blk_mq_tagset_busy_iter(&sdev->host->tag_set,
+				scsi_set_noretries_abort_io, sdev);
+		blk_mq_unquiesce_queue(sdev->request_queue);
+	}
+	return 0;
+}
+
+/*
+ * scsi_set_noretries_abort_io_device - set the SCMD_NORETRIES_ABORT
+ * bit for all the pending io's on a device
+ * @sdev:	scsi_device
+ */
+int
+scsi_set_noretries_abort_io_device(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	int ret  = -EINVAL;
+
+	mutex_lock(&shost->scan_mutex);
+	ret = __scsi_set_noretries_abort_io_device(sdev);
+	mutex_unlock(&shost->scan_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(scsi_set_noretries_abort_io_device);
+
 /**
  * scsi_times_out - Timeout function for normal scsi commands.
  * @req:	request that is timing out.
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index d12ada0..1bbffd3 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -81,6 +81,7 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
 int scsi_noretry_cmd(struct scsi_cmnd *scmd);
+extern int scsi_set_noretries_abort_io_device(struct scsi_device *sdev);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
-- 
1.8.3.1

