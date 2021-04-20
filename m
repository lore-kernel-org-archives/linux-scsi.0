Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2818C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4D94613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhDTCOk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:40 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:34793 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhDTCOk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:40 -0400
Received: by mail-pg1-f179.google.com with SMTP id z16so25557191pga.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zFbN8saB6T93YtUOIUueNaMRZiAEDaBUE7y0+opFg+g=;
        b=SnRe0x2InUX8P5rG07WF7Y0mKdhUx6OCBpGA38Mlpqqgux9FKuYnCB6kovrwiBKL1n
         2cnrrd9OI6LshaSlrYf4sb0Z8kh3GagaunhOVOYt5qUROM2pnIyD4P7i3LkL2bUfhZOR
         McYALc81ukQdzTONaymHIK3xqM6wlrw8EnqvIEXkqPdKqs6PrcoDTtfpLtbQcsF+4WuJ
         PlRNCD0w/l6CzeXIZZgrPluezhybsxdjgA6yOp/lsVeCwmRXMj3M/2Ocsf6GLR7QXBBo
         spY84doylKdjXNIN1Yow/7FuhP/7FA+bUBd7VCueSwJTnTWAf9Z7Exjtzn1u/JkEAKlH
         a0WA==
X-Gm-Message-State: AOAM530btDFCHkJJPD4aIu4h/3TfP9+xEDax3wRfS8cbb0TO89bBXyB3
        DPPlrAntTbwhT9D9S+J3rb0=
X-Google-Smtp-Source: ABdhPJz+9U7AAtH1CbPGkK5NwU7rXkp2s9/TfXplKEyDCSUYmVv2/Xr6Lz86yTjqQ8uNtDBe51xSYg==
X-Received: by 2002:a62:878d:0:b029:257:ba2e:b6b2 with SMTP id i135-20020a62878d0000b0290257ba2eb6b2mr21797717pfe.11.1618884849528;
        Mon, 19 Apr 2021 19:14:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>
Subject: [PATCH 091/117] smartpqi: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:36 -0700
Message-Id: <20210420021402.27678-1-bvanassche@acm.org>
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

Cc: Don Brace <don.brace@microchip.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 25c0409e98df..55bdc2c180a8 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3001,7 +3001,7 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 			sense_data_length);
 	}
 
-	scmd->result = scsi_status;
+	scmd->status.combined = scsi_status;
 	set_host_byte(scmd, host_byte);
 }
 
@@ -3091,7 +3091,7 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 		scsi_build_sense_buffer(0, scmd->sense_buffer, HARDWARE_ERROR,
 			0x3e, 0x1);
 
-	scmd->result = scsi_status;
+	scmd->status.combined = scsi_status;
 	set_host_byte(scmd, host_byte);
 }
 
@@ -3188,7 +3188,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 		case PQI_RESPONSE_IU_RAID_PATH_IO_SUCCESS:
 		case PQI_RESPONSE_IU_AIO_PATH_IO_SUCCESS:
 			if (io_request->scmd)
-				io_request->scmd->result = 0;
+				io_request->scmd->status.combined = 0;
 			fallthrough;
 		case PQI_RESPONSE_IU_GENERAL_MANAGEMENT:
 			break;
@@ -5333,9 +5333,9 @@ static bool pqi_raid_bypass_retry_needed(struct pqi_io_request *io_request)
 		return false;
 
 	scmd = io_request->scmd;
-	if ((scmd->result & 0xff) == SAM_STAT_GOOD)
+	if ((scmd->status.combined & 0xff) == SAM_STAT_GOOD)
 		return false;
-	if (host_byte(scmd->result) == DID_NO_CONNECT)
+	if (host_byte(scmd->status) == DID_NO_CONNECT)
 		return false;
 
 	device = scmd->device->hostdata;
@@ -5719,7 +5719,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	 * This is necessary because the SML doesn't zero out this field during
 	 * error recovery.
 	 */
-	scmd->result = 0;
+	scmd->status.combined = 0;
 
 	hw_queue = pqi_get_hw_queue(ctrl_info, scmd);
 	queue_group = &ctrl_info->queue_groups[hw_queue];
