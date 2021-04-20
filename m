Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCF1C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E04C461363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhDTAJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:42 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:43890 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbhDTAJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:39 -0400
Received: by mail-pj1-f43.google.com with SMTP id f6-20020a17090a6546b029015088cf4a1eso3636427pjs.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gZjBHMnbFwArhElq5SxCR+7NhHwo64ZHSzq0dH12irM=;
        b=Hsbe1PbN8tqUHjEYmygIy4mPbFYKZlTNGvMhd1eYqBi7LWra5SOgVruV3SranE8knU
         piLo8XsqnKamZFSatXqO4fB2Y3vI1Nq7mrLA3giILonzL5fDg4cCo1RY9i6Ply0rWwyV
         Y9YJcTdKivTsd6Hc94zwTEm+PyxfBEI1jOxinl6pupdWYjGI5/sasC8RXnYjkkxeud3i
         r2KvCXGtjFaDbeBRz1HOVN/sgk4UTm1h1MuOCM7XQ/jSuxsfliJ5bwblaTOs/4RAw82h
         RVYiTzeUvIE4MAwEYiifVcPvfv1NfegBP3Nbkvkaf1jrAcRHJ1AVGoISB7XyC26iI1Li
         DLeA==
X-Gm-Message-State: AOAM531GVyc0yslxwWpIQIfVBBN/9YYZ3ABF9lZnfRcem1coAb+MumAm
        9NAQk9SnAi24QhMI7j1i73Y=
X-Google-Smtp-Source: ABdhPJwotImIBiBxyKHCcTnJJ3AXmuzjhIaeDFHpeiExjkFSv2a7v+6NQBvOaW5Ks7AR44/vMQ93Tw==
X-Received: by 2002:a17:90a:fb89:: with SMTP id cp9mr1746412pjb.47.1618877348531;
        Mon, 19 Apr 2021 17:09:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 014/117] ch: Pass union scsi_status to driver_byte()
Date:   Mon, 19 Apr 2021 17:07:02 -0700
Message-Id: <20210420000845.25873-15-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ch.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index cb74ab1ae5a4..663af5ed20de 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -187,7 +187,8 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned buflength,
 	   enum dma_data_direction direction)
 {
-	int errno, retries = 0, timeout, result;
+	int errno, retries = 0, timeout;
+	union scsi_status result;
 	struct scsi_sense_hdr sshdr;
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
@@ -195,7 +196,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
  retry:
 	errno = 0;
-	result = scsi_execute_req(ch->device, cmd, direction, buffer,
+	result.combined = scsi_execute_req(ch->device, cmd, direction, buffer,
 				  buflength, &sshdr, timeout * HZ,
 				  MAX_RETRIES, NULL);
 
