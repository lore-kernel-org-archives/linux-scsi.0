Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A6BC4332E
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BDC64F21
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhCRD3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 23:29:08 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:35787 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhCRD2z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 23:28:55 -0400
Received: by mail-pl1-f174.google.com with SMTP id e14so581291plj.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 20:28:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+0tbxfnmah7usx0zbzOV8PfgFfcKPXhVDUPTh4o5nMs=;
        b=JVLIjG11L2s6XUrz+34NNClu26VO5ELNjnmRztapad3Y8HcYRkmizm5i5Fulsmmq29
         0MKCY8aZf8sJaf+qOylAvOhBTacrCfFe2NrsWzMMTUNrYtRbeP4T9ZIps2+A4Udyu1fl
         YIQJF67Fla2A/2CVvldxfX6L/blGx03GaOYyygHzSgHCBi4Jxgp+62B4xEZPFGD+xiwY
         UPZZV5Yr15GmFGzH0LTb7MHhbinKDF+6P3jlG6mHJDgaeX9akA5xYA1ijAgL4QpSRR33
         FvScYO+S12TfFlUIUDgDN8cs8dGu/rh3/EUDPUoTNtTUCWFI9tR0Dgsx5+jIFmkaQrBI
         PYAg==
X-Gm-Message-State: AOAM532EiZ69dQFdDE9prlMj9q9YbyjWakzZYiG7nURL7IZvW9/Yqemu
        s9DJ9ncVSERDABVWkwE30s0=
X-Google-Smtp-Source: ABdhPJwMoV24qWMIbPjduK+Kp9ozHTzmNtINRCVhQ2dcUC9svKmGqGrzRknh8KtzrKPveyIxwa9z0g==
X-Received: by 2002:a17:902:e84a:b029:e6:d1ee:a1ed with SMTP id t10-20020a170902e84ab02900e6d1eea1edmr63640plg.78.1616038134828;
        Wed, 17 Mar 2021 20:28:54 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7fb2:1f41:ab33:bae6])
        by smtp.gmail.com with ESMTPSA id y68sm473687pgy.5.2021.03.17.20.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 20:28:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 5/6] qla2xxx: Simplify qla8044_minidump_process_control()
Date:   Wed, 17 Mar 2021 20:28:39 -0700
Message-Id: <20210318032840.7611-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210318032840.7611-1-bvanassche@acm.org>
References: <20210318032840.7611-1-bvanassche@acm.org>
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
