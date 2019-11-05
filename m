Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12218CA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 02:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6118217F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 02:49:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tw+r9jFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfKECta (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 21:49:30 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40679 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbfKECta (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 21:49:30 -0500
Received: by mail-pg1-f195.google.com with SMTP id 15so12942325pgt.7
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 18:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7tn558fPuT0si6k/egwfr95dqMkT3EjhtN/MJIbSkEk=;
        b=Tw+r9jFm2F2Uxer7KsUXS56zAhH43kFR8sZ8JKqyIzyqXw+8FnvCO1oCwy8j7Xijo7
         ZTUtCBc5BpJPPkxfRlVepkwXXR+F7WCPqgnHrS9WeDmTvkNVhRGXcrxxTgdlXBBa8eby
         /SONfqqPnFXo2KEJZP5tKefB6Dmp3AKB5XbEAmVrthnDN5EHD5d9IJAkdu6U5fdowOpa
         09TGt9B/Eh/oUXrP5IPiuW7FPVtC1mVZ05XUo6ukEDYHySw9I4wp2nzverGSyqIA58cY
         gNgONEstoEYvHvQBctS+slkzQsq0zMec87Deqt3vt9x362ZvKSyavj2WeX73AVzlWXR3
         UC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7tn558fPuT0si6k/egwfr95dqMkT3EjhtN/MJIbSkEk=;
        b=SUvEsiXLRe2fwf1lf3YprX52FINNBc2MqiqNDTfzhVCgw1QvZyDJs70r0P4fufZZ5J
         26RKsjj3ORWULwTVSFfgmqHaV0Tmo5SvrCZwzLSXCZbuAVskx8qpEhAjVcHAfEChK35L
         DDLWXwLgwB7Dr/vuDYuB+TJXr8u7Nm38YinIoiX7GuO92puzOCp57+g4K3wxxZac5pWp
         dy7VqH6zjrX5hKWl0Koj5Q43IOuY5eKilcmHZ4hWVhdG3/upR+NeiYEcIj9d8b44u7Wn
         w+8rys+cRvdl5a6A9li95nyOLZIOFvBY84kucU33pYecZ9K5rCvrHaYRBpOz31lX009l
         3Z0Q==
X-Gm-Message-State: APjAAAV9KIFZaheiBhKaaJmPOFFPoOWapenmdOQmr0tQ00VDZnnJ0dBw
        F73NyWnEFBQmHvUwgsVrj3c=
X-Google-Smtp-Source: APXvYqyNWyNX6dLe5uRdfZK8dfMj7i5GryJM4yUe48+4pMqObPHDta/rPCcw6QSp4RsQTkvhIjPisA==
X-Received: by 2002:a17:90a:32e5:: with SMTP id l92mr3144927pjb.40.1572922169596;
        Mon, 04 Nov 2019 18:49:29 -0800 (PST)
Received: from xplor.waratah.dyndns.org (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id z23sm16125971pgu.16.2019.11.04.18.49.28
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 04 Nov 2019 18:49:29 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 5DA32360079; Tue,  5 Nov 2019 15:49:25 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     schmitz@debian.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] scsi: scsi-lib.c: increase cmd_size by sizeof(struct scatterlist)
Date:   Tue,  5 Nov 2019 15:49:10 +1300
Message-Id: <1572922150-4358-1-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1572656814.git.fthain@telegraphics.com.au>
References: <cover.1572656814.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In scsi_mq_setup_tags(), cmd_size is calculated based on zero size
for the scatter-gather list in case the low level driver uses SG_NONE
in its host template.

cmd_size is passed on to the block layer for calculation of the request
size, and we've seen NULL pointer dereference errors from the block
layer in drivers where SG_NONE is used and a mq IO scheduler is active,
apparently as a consequence of this (see commit 68ab2d76e4be for the
cxflash driver, and a recent patch by Finn Thain converting the three
m68k NFR5380 drivers to avoid setting SG_NONE).

Try to avoid these errors by accounting for at least one sg list entry
when caculating cmd_size, regardless of whether the low level driver
set a zero sg_tablesize.

Tested on 030 m68k with the atari_scsi driver - setting sg_tablesize to
SG_NONE no longer results in a crash when loading this driver.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
CC: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d47d637..d38b0e1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1867,7 +1867,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size;
 
-	sgl_size = scsi_mq_inline_sgl_size(shost);
+	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
+				scsi_mq_inline_sgl_size(shost));
 	cmd_size = sizeof(struct scsi_cmnd) + shost->hostt->cmd_size + sgl_size;
 	if (scsi_host_get_prot(shost))
 		cmd_size += sizeof(struct scsi_data_buffer) +
-- 
1.7.0.4

