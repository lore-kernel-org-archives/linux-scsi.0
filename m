Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40B4C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 937816109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhDTALt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:49 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:36384 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbhDTALG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:11:06 -0400
Received: by mail-pl1-f169.google.com with SMTP id g16so1822396plq.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o9MOQF56pRR74SORwC9yfTAfR6HFmUWE31VmpD+WiHU=;
        b=B3PBalh1JpXQb4sD0pslKgX7fcixgfASmErmFUduZ6jY6UIPN6cnSQlJlI6m4rWkPq
         iImZ0ly9c5sl7S3Lmetvr5Ie8ExHb5O9juw1Uc1QQ64l0A84v6ERQXjqze360pJsOE4w
         zb6vb+7OZIpqE1TEbn2lK5NQSOfPMqzg45yqLfpre2464QeHS6tIE4n9l3Jx5gKLdd1+
         34yI0PvHX3LVQbQRSX01fu4swLKwR2ZCuVePgs7m+wtASdZMZCf4tW78bWNoeZ2KzvMe
         lKQ6a2MZ0hcslGOG+D+O3GDxCCWO0u/EUNLoxWAdH3sLwHmLXOxKAw+fZZq6GyoMoEVB
         6DsA==
X-Gm-Message-State: AOAM533YoOL9AQ3e3/8lF2ysxrQ96bmA8mJoCnF0P6eZyBx3qHhH/5Xl
        ZX8hRCwEb4y6DzATaBaVOPBni7qF4MB+lw==
X-Google-Smtp-Source: ABdhPJzQq7etywuGvXkyQSwLJgPa9VIl0PuLAZZKFu+39U3Q8c4WcvDJLoMrUmkOsbXxPe8y5Kqr/g==
X-Received: by 2002:a17:90b:1646:: with SMTP id il6mr1827267pjb.27.1618877435983;
        Mon, 19 Apr 2021 17:10:35 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 090/117] scsi_debug: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:18 -0700
Message-Id: <20210420000845.25873-91-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 70165be10f00..819d872ee8ea 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5458,24 +5458,24 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		ns_from_boot = ktime_get_boottime_ns();
 
 	/* one of the resp_*() response functions is called here */
-	cmnd->result = pfp ? pfp(cmnd, devip) : 0;
-	if (cmnd->result & SDEG_RES_IMMED_MASK) {
-		cmnd->result &= ~SDEG_RES_IMMED_MASK;
+	cmnd->status.combined = pfp ? pfp(cmnd, devip) : 0;
+	if (cmnd->status.combined & SDEG_RES_IMMED_MASK) {
+		cmnd->status.combined &= ~SDEG_RES_IMMED_MASK;
 		delta_jiff = ndelay = 0;
 	}
-	if (cmnd->result == 0 && scsi_result != 0)
-		cmnd->result = scsi_result;
-	if (cmnd->result == 0 && unlikely(sdebug_opts & SDEBUG_OPT_TRANSPORT_ERR)) {
+	if (cmnd->status.combined == 0 && scsi_result != 0)
+		cmnd->status.combined = scsi_result;
+	if (cmnd->status.combined == 0 && unlikely(sdebug_opts & SDEBUG_OPT_TRANSPORT_ERR)) {
 		if (atomic_read(&sdeb_inject_pending)) {
 			mk_sense_buffer(cmnd, ABORTED_COMMAND, TRANSPORT_PROBLEM, ACK_NAK_TO);
 			atomic_set(&sdeb_inject_pending, 0);
-			cmnd->result = check_condition_result;
+			cmnd->status.combined = check_condition_result;
 		}
 	}
 
-	if (unlikely(sdebug_verbose && cmnd->result))
+	if (unlikely(sdebug_verbose && cmnd->status.combined))
 		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
-			    __func__, cmnd->result);
+			    __func__, cmnd->status.combined);
 
 	if (delta_jiff > 0 || ndelay > 0) {
 		ktime_t kt;
@@ -5582,10 +5582,10 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	return 0;
 
 respond_in_thread:	/* call back to mid-layer using invocation thread */
-	cmnd->result = pfp != NULL ? pfp(cmnd, devip) : 0;
-	cmnd->result &= ~SDEG_RES_IMMED_MASK;
-	if (cmnd->result == 0 && scsi_result != 0)
-		cmnd->result = scsi_result;
+	cmnd->status.combined = pfp != NULL ? pfp(cmnd, devip) : 0;
+	cmnd->status.combined &= ~SDEG_RES_IMMED_MASK;
+	if (cmnd->status.combined == 0 && scsi_result != 0)
+		cmnd->status.combined = scsi_result;
 	cmnd->scsi_done(cmnd);
 	return 0;
 }
