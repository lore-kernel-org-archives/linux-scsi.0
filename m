Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77A0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345207AbiA1WWR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:17 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:45945 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346551AbiA1WWC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:22:02 -0500
Received: by mail-pf1-f173.google.com with SMTP id 128so7417540pfe.12
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:22:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VXTeOq4UEW6MQiEk+UOkmk0I17UNOcHVM+xH4jZLZhQ=;
        b=hc4YnHSYVe+oGEpzdYlHVadL/K4ixdSmXZ8Z8qoTOGFy87dcZ3+8ugfkwal1Df955A
         qFLD9ZcbNbIpINLvhmOib9rGy1QqMiw0iOd3f6DJkRJT7Fg1C9nOsUUe+8ysA5qZIhwz
         UOmOcxbA2RwpPzL8XKuL1MwBhF/fPSDHq9uo77t/OWa4vPygMD9vK41p/oXT3VW+5pLr
         YV0RCcqs7FVhoL+xBHVGUH/sLdlknFTpeiHL0uSvJikpWWJS832vgL7jDDYjJITaG2IC
         52m4kjCJ4i8AuVF4DYxcBL3yuXqWHYdczgqdcMKdR8Owv4ExmChXKByn8X8jUKlBlnYN
         5H6w==
X-Gm-Message-State: AOAM5337oETTpBfpxoglUNiXKhId6mf+TDy8bM7inAi5HcVzdp6LVGfy
        VU6NXvbWP2Zeb+UnNuFMpJM=
X-Google-Smtp-Source: ABdhPJxtMvrBfMm/RJi3G01a83VNynJZEZZolatbprauA0H2DByp8js7P84sROF9LHdfxG47owJuFg==
X-Received: by 2002:a63:8743:: with SMTP id i64mr950534pge.490.1643408521854;
        Fri, 28 Jan 2022 14:22:01 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:22:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 44/44] scsi: core: Remove struct scsi_pointer from struct scsi_cmnd
Date:   Fri, 28 Jan 2022 14:19:09 -0800
Message-Id: <20220128221909.8141-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6794d7322cbd..4fd2c522e914 100644
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
+	 * The fields below can be modified by the SCSI LLD but the fields
+	 * above not.
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
