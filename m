Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4ACC4332D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DA9C650D5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhCPD5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:57:22 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:34434 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbhCPD5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:57:10 -0400
Received: by mail-pg1-f174.google.com with SMTP id l2so21746844pgb.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2021 20:57:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t84EP1W525ylvAuKzNqn2JEhH53MCiZR6dOth7u/Zr8=;
        b=CotIWVvmSvtSxzjJaJfgXYiAkn98cZ5ylW1JAPnQ3Dxkk3jExmf7OSLmuN90kB6VV6
         lmsDR5/R+vGW4hEUBujG60nkx2hGpBzDmEHeDszuXKEXb/OjhvsWaUzbFkzNAO+4BuVS
         Rop13vDwzLofqU0k6XCR2YSPcfXMmJrW7OPGxvp2pJPDTMKVQc4epzVRel0c6z0K4inL
         crrkwgLjc59k6jY8S0Zsjc7UjKISLIU7UlMdtGuoFYGt3OYqR0XuS0iMkt3sCqoBOLSr
         ysyBO0cXzaQPBXLX+ioSl4U4/dSwxVOyVlXfqBdbzpnL0IXF2ENrU0es7bqM7GqLMDEO
         xZmw==
X-Gm-Message-State: AOAM533QqagWIsPJo5tY6p2yn07+l2Wr9O1LmD9HOQL2OuS39Ht1Go4n
        USxswqyLKZPrCvhN7j+G5/o=
X-Google-Smtp-Source: ABdhPJymY8h/+AfN1FtRfdZimsJ8TNGwV23h8ndO3mgpmPG3WK7Wdu/5gUo3N1wDgquOFrDI3h80ww==
X-Received: by 2002:a62:7556:0:b029:1ff:5bf8:72b3 with SMTP id q83-20020a6275560000b02901ff5bf872b3mr13246273pfc.33.1615867030053;
        Mon, 15 Mar 2021 20:57:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:8641:766a:ce30:8278])
        by smtp.gmail.com with ESMTPSA id fs9sm1031673pjb.40.2021.03.15.20.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 20:57:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 6/7] qla2xxx: Simplify qla8044_minidump_process_control()
Date:   Mon, 15 Mar 2021 20:56:54 -0700
Message-Id: <20210316035655.2835-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316035655.2835-1-bvanassche@acm.org>
References: <20210316035655.2835-1-bvanassche@acm.org>
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
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nx2.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 68a16c95dcb7..792c55fcec8c 100644
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
