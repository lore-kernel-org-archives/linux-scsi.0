Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC25C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28435613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbhDTAKb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:31 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:45729 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbhDTAKW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:22 -0400
Received: by mail-pl1-f180.google.com with SMTP id p16so14718381plf.12
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fPhKCgVRBOhHEvfJlCriskOFqzFG6mYCOiE1s2/iSDY=;
        b=ovp3UkYKmpWZCQYzey5AQ3nJdlpN2lkUFif1s6p/ZpSK8Ni2Q8p8bsxOHgNoC6T06H
         XlfzEoTBReReeDCHmQvANmEB5WJeVIk5WU7iFuXwjGQsn1ZNO5sbrxPA0pjU6xqBfxSV
         tzcOSYcv9YyBGhSCdAvzFATSOKl2Im/IkRujEC78p4mYjOyyJukhvKB8dR3jelUIFX7k
         VOs8zK2f6pBSS2NvVOM5YBWnfr6MSeEIuhL8dnmjyA0IF6ClYjvmvn4hYzy55VuDkQWG
         snR3OkDoA8V+0VA0+luU6/Z2oS3RfbhlQsJ9ASTn5xM2t9uT4wgSx0jQXBRzutbKZ2Ea
         6P8A==
X-Gm-Message-State: AOAM532DfnfaJo0ySPttq1010OR/isrJWIjlnx6gsuytjRs+LxQHqD+Y
        Of3Y2F/UgQouGYmHdVDJO8o=
X-Google-Smtp-Source: ABdhPJz/1tqyo1WJfefPqW2HWWbmJXN9s66O6TItKPDhT9J/VFdnbbqiY5CLNoOB5axO+3V0Pa9mkg==
X-Received: by 2002:a17:90a:ce8d:: with SMTP id g13mr1783728pju.85.1618877392021;
        Mon, 19 Apr 2021 17:09:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 052/117] hptiop: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:40 -0700
Message-Id: <20210420000845.25873-53-bvanassche@acm.org>
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
 drivers/scsi/hptiop.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index db4c7a7ff4dd..4cb92937164a 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -735,32 +735,32 @@ static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
 	case IOP_RESULT_SUCCESS:
 		scsi_set_resid(scp,
 			scsi_bufflen(scp) - le32_to_cpu(req->dataxfer_length));
-		scp->result = (DID_OK<<16);
+		scp->status.combined = (DID_OK<<16);
 		break;
 	case IOP_RESULT_BAD_TARGET:
-		scp->result = (DID_BAD_TARGET<<16);
+		scp->status.combined = (DID_BAD_TARGET<<16);
 		break;
 	case IOP_RESULT_BUSY:
-		scp->result = (DID_BUS_BUSY<<16);
+		scp->status.combined = (DID_BUS_BUSY<<16);
 		break;
 	case IOP_RESULT_RESET:
-		scp->result = (DID_RESET<<16);
+		scp->status.combined = (DID_RESET<<16);
 		break;
 	case IOP_RESULT_FAIL:
-		scp->result = (DID_ERROR<<16);
+		scp->status.combined = (DID_ERROR<<16);
 		break;
 	case IOP_RESULT_INVALID_REQUEST:
-		scp->result = (DID_ABORT<<16);
+		scp->status.combined = (DID_ABORT<<16);
 		break;
 	case IOP_RESULT_CHECK_CONDITION:
 		scsi_set_resid(scp,
 			scsi_bufflen(scp) - le32_to_cpu(req->dataxfer_length));
-		scp->result = SAM_STAT_CHECK_CONDITION;
+		scp->status.combined = SAM_STAT_CHECK_CONDITION;
 		memcpy(scp->sense_buffer, &req->sg_list, SCSI_SENSE_BUFFERSIZE);
 		goto skip_resid;
 
 	default:
-		scp->result = DRIVER_INVALID << 24 | DID_ABORT << 16;
+		scp->status.combined = DRIVER_INVALID << 24 | DID_ABORT << 16;
 		break;
 	}
 
@@ -1024,12 +1024,12 @@ static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 			cpu_to_be32(((u32 *)scp->cmnd)[3]),
 			_req->index, _req->req_virt);
 
-	scp->result = 0;
+	scp->status.combined = 0;
 
 	if (scp->device->channel ||
 			(scp->device->id > hba->max_devices) ||
 			((scp->device->id == (hba->max_devices-1)) && scp->device->lun)) {
-		scp->result = DID_BAD_TARGET << 16;
+		scp->status.combined = DID_BAD_TARGET << 16;
 		free_req(hba, _req);
 		goto cmd_done;
 	}
