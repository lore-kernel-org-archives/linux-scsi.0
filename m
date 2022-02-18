Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EC6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbiBRTx4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238670AbiBRTxf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:35 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BC93818B
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:18 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so9510583pjm.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gXAcwAjg+3y4mhvxhJT9Ev7Cj8iE4juolwO8/6/Gqn8=;
        b=med3iQa14nFz71UsXfRSj9F7rEfWf9C/HK9NJqOWpbUV5yCUr5kndAXHy91sGHf0QX
         peVHOP3xGXRNfaVnuDsNM0jaCXiN8CzZeMIkX0l9us1NudKW6forEpRD526jI/NB+rRX
         3X8h6fucNIw1ytiSq8xzvGdz6EVcPtZA3uVlrtOCMGaJQUFxKHMyYBiEKIsc0GvaDBBM
         X1F5FuwCkrH6ilPLG4Zs6ouQYFEPOfXe1/ItobzJrm/RgvA/rHlhjYKyi5fblSUsSkpf
         X9sNMKZfSiNIurt8cIsHSu3apDL3e87p66c1M7axYMU//Drv73LG/6ngnp4KybXXZ61y
         j9Kw==
X-Gm-Message-State: AOAM531xJXVnnxAnXcWAtsumbTEnndekL4zLnYvhbwD+zWboNO3qOklH
        TVKomDJqgx7OnPqIPYVLJwE=
X-Google-Smtp-Source: ABdhPJw0NB6DJKtT04HyT3XheqTXa8zcOy9Xm1qdbT5Lh3Pr7aT7/YOzoqkY5iftQfiDlRDfGJytpA==
X-Received: by 2002:a17:902:7613:b0:14d:ad07:2f9d with SMTP id k19-20020a170902761300b0014dad072f9dmr8922284pll.12.1645213998347;
        Fri, 18 Feb 2022 11:53:18 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:53:17 -0800 (PST)
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
Subject: [PATCH v5 49/49] scsi: core: Remove struct scsi_pointer from struct scsi_cmnd
Date:   Fri, 18 Feb 2022 11:51:17 -0800
Message-Id: <20220218195117.25689-50-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
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
