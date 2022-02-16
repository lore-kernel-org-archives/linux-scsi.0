Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8F7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbiBPVEs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiBPVEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:37 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02AF2B0483
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:24 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so7572994pjl.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gXAcwAjg+3y4mhvxhJT9Ev7Cj8iE4juolwO8/6/Gqn8=;
        b=x4w6nCH31vgnv9y6aw5xfN4lbq1C01LR7GK0nlDteqU0X73WKGq64N9JIVDwIr2YVv
         u78imvZC3VQv46yn42f5GYKEpqgU5/BBcda0lIXUVTwkFAy87k6BmIwdLIIZ1iAq68Po
         HbtFO9rapKeBt+wsPxi/Sl5gzJFpk08ghVbpR2Ra8eSqeMfyEN0BP6fpcfs9Pb+Bpm2P
         cNFzwAjMuabYk24h2XRPS0L7BkUchv/7F3uupmNIVJyBvm0920iux2oyp+ibmoqWdRWZ
         UuM3xNfVclEaUufG+zce9gmP9u4+tfB+mydcclDZ8Kct1Naejt/xTD/la9T01x1+QJJj
         Oplw==
X-Gm-Message-State: AOAM532qQaoX/Ln4R8SR09izQoc2evEBYnP2cP0NQHZ8T3Yg3jwPWLtJ
        TojuPWvCxc+GtS3nbH5bQno=
X-Google-Smtp-Source: ABdhPJziPcoiTk6Gy58ai/cPVue2UEdnGum2iEjdhbJKhTutG2eH1xOmL4jvGLRrUBvL738yZyb0Ow==
X-Received: by 2002:a17:90a:4386:b0:1b9:24b9:b205 with SMTP id r6-20020a17090a438600b001b924b9b205mr3825679pjg.218.1645045464271;
        Wed, 16 Feb 2022 13:04:24 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:04:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 50/50] scsi: core: Remove struct scsi_pointer from struct scsi_cmnd
Date:   Wed, 16 Feb 2022 13:02:33 -0800
Message-Id: <20220216210233.28774-51-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove struct scsi_pointer from struct scsi_cmnd since the previous patches
removed all users of that member of struct scsi_cmnd. Additionally, reorder
the members of struct scsi_cmnd such that the statement that the field
below can be modified by the SCSI LLD is again correct.

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index ff1c4b51f7ae..7a19c8bbaed9 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -123,11 +123,15 @@ struct scsi_cmnd {
 				 * command (auto-sense). Length must be
 				 * SCSI_SENSE_BUFFERSIZE bytes. */
 
+	int flags;		/* Command flags */
+	unsigned long state;	/* Command completion state */
+
+	unsigned int extra_len;	/* length of alignment and padding */
+
 	/*
-	 * The following fields can be written to by the host specific code. 
-	 * Everything else should be left alone. 
+	 * The fields below can be modified by the LLD but the fields above
+	 * must not be modified.
 	 */
-	struct scsi_pointer SCp;	/* Scratchpad used by some host adapters */
 
 	unsigned char *host_scribble;	/* The host adapter is allowed to
 					 * call scsi_malloc and get some memory
@@ -138,10 +142,6 @@ struct scsi_cmnd {
 					 * to be at an address < 16Mb). */
 
 	int result;		/* Status code from lower level driver */
-	int flags;		/* Command flags */
-	unsigned long state;	/* Command completion state */
-
-	unsigned int extra_len;	/* length of alignment and padding */
 };
 
 /* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
