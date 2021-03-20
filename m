Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD7DC433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78DBA61937
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCTXYw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 19:24:52 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:45612 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhCTXYP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2021 19:24:15 -0400
Received: by mail-pg1-f175.google.com with SMTP id n11so6154287pgm.12
        for <linux-scsi@vger.kernel.org>; Sat, 20 Mar 2021 16:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=73EC2KzqpTqzE9VJFT6gqXuYYsYR6UX9nfEh/uhD7Ho=;
        b=lhsMJ90M+DNnwg5CNazCI/CvzVcjA8ekU6KNYwQ0/z12mXbSNn6lQv5yWwjCF5BpkO
         tmKzqHEFsPTkep4gKFiWBi7b+eBkuPlA3lNlb5qHqjm0GCXe4H1S0eYUKQygT1SCDbYd
         Seu/slXuDp4ajydqxVdv4q9vXNt9q+pfDkM4pWT09Ese1F1yAbIW/DB+LIOqw2YktPdY
         6sQDvPlTRMz4Thnu3mtaT9ZGbY+U0Pncl7EvCeNIkKZcJjJDfAphTpswFDCbLMjBznf7
         pcXqxfYPdCHklFbu6pUzDSCSe7I+YATTKP6VImGKDx+alKxjMfKAMlpdTEKtX/Y4te8I
         NJ/w==
X-Gm-Message-State: AOAM532R+KFTXbJjJCTbSvf54wY9L81bOHOAInk55JVwq6lUF4yB7lfZ
        xct5nBWe4V7yfP9D14Xs5/Y=
X-Google-Smtp-Source: ABdhPJypu4hmLWFlQkNiUJcna7ieYgbmE7YRtFz8Vq22WEa139M27Sd4AbqBt8Vhn39eDQgLJehhiA==
X-Received: by 2002:a63:508:: with SMTP id 8mr2803872pgf.220.1616282654511;
        Sat, 20 Mar 2021 16:24:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:9252:a76b:2952:3189])
        by smtp.gmail.com with ESMTPSA id u7sm8869159pfh.150.2021.03.20.16.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 16:24:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH v3 5/7] qla2xxx: Simplify qla8044_minidump_process_control()
Date:   Sat, 20 Mar 2021 16:23:57 -0700
Message-Id: <20210320232359.941-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210320232359.941-1-bvanassche@acm.org>
References: <20210320232359.941-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following Coverity complaint:

    CID 177490 (#1 of 1): Unused value (UNUSED_VALUE)
    assigned_value: Assigning value from opcode & 0xffffff7fU to opcode
    here, but that stored value is overwritten before it can be used.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nx2.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 7c413f93d53e..5ceecc9642fc 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -2226,19 +2226,16 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
 		if (opcode & QLA82XX_DBG_OPCODE_WR) {
 			qla8044_wr_reg_indirect(vha, crb_addr,
 			    crb_entry->value_1);
-			opcode &= ~QLA82XX_DBG_OPCODE_WR;
 		}
 
 		if (opcode & QLA82XX_DBG_OPCODE_RW) {
 			qla8044_rd_reg_indirect(vha, crb_addr, &read_value);
 			qla8044_wr_reg_indirect(vha, crb_addr, read_value);
-			opcode &= ~QLA82XX_DBG_OPCODE_RW;
 		}
 
 		if (opcode & QLA82XX_DBG_OPCODE_AND) {
 			qla8044_rd_reg_indirect(vha, crb_addr, &read_value);
 			read_value &= crb_entry->value_2;
-			opcode &= ~QLA82XX_DBG_OPCODE_AND;
 			if (opcode & QLA82XX_DBG_OPCODE_OR) {
 				read_value |= crb_entry->value_3;
 				opcode &= ~QLA82XX_DBG_OPCODE_OR;
@@ -2249,7 +2246,6 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
 			qla8044_rd_reg_indirect(vha, crb_addr, &read_value);
 			read_value |= crb_entry->value_3;
 			qla8044_wr_reg_indirect(vha, crb_addr, read_value);
-			opcode &= ~QLA82XX_DBG_OPCODE_OR;
 		}
 		if (opcode & QLA82XX_DBG_OPCODE_POLL) {
 			poll_time = crb_entry->crb_strd.poll_timeout;
@@ -2269,7 +2265,6 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
 					    crb_addr, &read_value);
 				}
 			} while (1);
-			opcode &= ~QLA82XX_DBG_OPCODE_POLL;
 		}
 
 		if (opcode & QLA82XX_DBG_OPCODE_RDSTATE) {
@@ -2283,7 +2278,6 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
 			qla8044_rd_reg_indirect(vha, addr, &read_value);
 			index = crb_entry->crb_ctrl.state_index_v;
 			tmplt_hdr->saved_state_array[index] = read_value;
-			opcode &= ~QLA82XX_DBG_OPCODE_RDSTATE;
 		}
 
 		if (opcode & QLA82XX_DBG_OPCODE_WRSTATE) {
@@ -2303,7 +2297,6 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
 			}
 
 			qla8044_wr_reg_indirect(vha, addr, read_value);
-			opcode &= ~QLA82XX_DBG_OPCODE_WRSTATE;
 		}
 
 		if (opcode & QLA82XX_DBG_OPCODE_MDSTATE) {
@@ -2316,7 +2309,6 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
 			read_value |= crb_entry->value_3;
 			read_value += crb_entry->value_1;
 			tmplt_hdr->saved_state_array[index] = read_value;
-			opcode &= ~QLA82XX_DBG_OPCODE_MDSTATE;
 		}
 		crb_addr += crb_entry->crb_strd.addr_stride;
 	}
