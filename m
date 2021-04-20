Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF49EC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACE8461107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbhDTCOx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:53 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:38784 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbhDTCOr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:47 -0400
Received: by mail-pf1-f180.google.com with SMTP id g16so11190562pfq.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fb1r8SYMSROeCi7Ay8yJ2wnRS/0/wthWehKMGFFGyLM=;
        b=cmXHkAZ1iubEQEsWVPQg5arJN7Fxw9JDVrsjuZOJOI5KwSYEYwmPB/+iJFfvUmPAjc
         iFAKXLZ2a0bSBqqp/fKb9uWCcdno2I1AE+mtle+b2t8Z4l6WRYe8kWjohuD3Tcn+hMJd
         FGHqoqVDFVF5pSOjJuV2F+IR6GJ/Prfd6DqR4Ze8tJ8c38zSJa/RaZ+sRYh7GEAld5Hb
         bF9ciRTE0jXLJzvih2u9vfbb84TgGtovvKBaIYd418x2q8IoHNUdvyFRv4OHEEldnraF
         KIFe3B6JHreaMB7MUgozJ/E/K9eRgnwuALKG9d3uF76YIoeCAC+DdVNzKAxUrQ0eOkaa
         GTMg==
X-Gm-Message-State: AOAM532ZaSciPYHQTzx8C1AqzCZc603E36ebGRBgfmTYKzgz8nMAA1qC
        8iw2FVSVTf+O9l/HGfL05gc=
X-Google-Smtp-Source: ABdhPJyr8lrzvZC7vIS+eD7He5hTuS1dS4ewyEBdHg7EUCZtSaAYvuKDE629/gtSEe/DxQeK3Mq/7w==
X-Received: by 2002:a62:2742:0:b029:222:b711:3324 with SMTP id n63-20020a6227420000b0290222b7113324mr22487949pfn.7.1618884856575;
        Mon, 19 Apr 2021 19:14:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 097/117] target: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:42 -0700
Message-Id: <20210420021402.27678-7-bvanassche@acm.org>
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

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/loopback/tcm_loop.c | 4 ++--
 drivers/target/target_core_pscsi.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 66ea91c52175..2206495f908c 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -565,10 +565,10 @@ static int tcm_loop_queue_data_or_status(const char *func,
 
 		memcpy(sc->sense_buffer, se_cmd->sense_buffer,
 				SCSI_SENSE_BUFFERSIZE);
-		sc->result = SAM_STAT_CHECK_CONDITION;
+		sc->status.combined = SAM_STAT_CHECK_CONDITION;
 		set_driver_byte(sc, DRIVER_SENSE);
 	} else
-		sc->result = scsi_status;
+		sc->status.combined = scsi_status;
 
 	set_host_byte(sc, DID_OK);
 	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index fd617bc4113e..5b562dbd4f11 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1043,13 +1043,13 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 {
 	struct se_cmd *cmd = req->end_io_data;
 	struct pscsi_plugin_task *pt = cmd->priv;
-	int result = scsi_req(req)->result;
+	union scsi_status result = scsi_req(req)->status;
 	enum sam_status scsi_status = status_byte(result) << 1;
 
 	if (scsi_status != SAM_STAT_GOOD) {
 		pr_debug("PSCSI Status Byte exception at cmd: %p CDB:"
 			" 0x%02x Result: 0x%08x\n", cmd, pt->pscsi_cdb[0],
-			result);
+			result.combined);
 	}
 
 	pscsi_complete_cmd(cmd, scsi_status, scsi_req(req)->sense);
@@ -1062,7 +1062,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 	default:
 		pr_debug("PSCSI Host Byte exception at cmd: %p CDB:"
 			" 0x%02x Result: 0x%08x\n", cmd, pt->pscsi_cdb[0],
-			result);
+			result.combined);
 		target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION);
 		break;
 	}
