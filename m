Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C306AC0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbjGLRxk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjGLRxh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:37 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1F21FE4
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:35 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-682ae5d4184so1594788b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184414; x=1691776414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HrGqteqRW2igwkluV6hTlpF+FO5gBCOahMtsnlOpmyg=;
        b=KTOdvU2OiK9smhFLTXcALP3NyZ+2auhnVY3LbY9dpmwWsYpUThBuyFpzZyGzNMwGP+
         GhONu7p3j/hoRLOZne8oSCryz1fh41zJFTwZ3uromPUDl1BmrIpKl5MgFpJbiufAxb56
         AGHsDTZLFq15FFLl/6Bwa2vbxv3nRC9w6AIoIcrB5aCGxPzP0CmBgLNSUwksrR/qkIgJ
         ggL+sA/X/9YDAoFQ/UMxlpFNrEhODnn/o2d2nlLdamBmKme4ZVKiBGV5nYvWq7KYPhMu
         4/5QBMYD2+cotJblO09H3znaJH8Hv+EOtEUhaqn6hOYIOaBq3Pk/kaa8DZKnoGnf139v
         ZgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184414; x=1691776414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HrGqteqRW2igwkluV6hTlpF+FO5gBCOahMtsnlOpmyg=;
        b=NSBxphxLv6YKFJtu8hUYwFZUHhNg4mj6BqoJZN0oKmevoF1EMzp7pOus62qX3ua/g1
         roctUpJy76Alqtiytpp36SBM4TtfdxI8iZtx6BmU4L54ymrCbGb7XIQgF/T9e71hIWAq
         0lGUBb0ewr7b0IRhAkLEngxnrd3NY+IysjlTQSC5PdP/VaQPb9mUqoRvE7XgDP6pH/Av
         sXCLcNy1RrUVLuQ22CgWASw9Bq9bJi8bzd2cZrpSB87TzyFOKPKjBnY+T5MHBNnUksV9
         NnIwWmMEeFN+LyC9zug2gnUl1z3C1TKNdvEQCjiVTYPCyssgprsKo0S8eq3GPeWuolYs
         WKBA==
X-Gm-Message-State: ABy/qLY22yAxKMNw1+Czf7BfuYPdvLuGI4srouZtPiRoh7tZJM/IAreo
        4kAbMm8XMqUKxv8GhqZMqIL70JQSmWo=
X-Google-Smtp-Source: APBJJlGVdUerIufM3aJkUo5vQpIQCpuJOrf4TLOUM35IgyZikHad5vlR2WvLIQ4N4lCYzkN6YrsJTQ==
X-Received: by 2002:a17:902:da89:b0:1a6:6bdb:b548 with SMTP id j9-20020a170902da8900b001a66bdbb548mr110598plx.1.1689184414429;
        Wed, 12 Jul 2023 10:53:34 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:34 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/12] lpfc: Simplify fcp_abort transport callback log message
Date:   Wed, 12 Jul 2023 11:05:12 -0700
Message-Id: <20230712180522.112722-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is reaching into a nvme_fc_cmd_iu ptr that belongs to the
transport during an abort.  This could cause an unintentional ptr
dereference into memory that the driver does not own.  Since the
nvme_fc_cmd_iu ptr was for logging purposes only, simplify the log message
such that the nvme_fc_cmd_iu reference is no longer needed.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 8db7cb99903d..3ee5cde481f3 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1864,7 +1864,6 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_nvme_fcpreq_priv *freqpriv;
 	unsigned long flags;
 	int ret_val;
-	struct nvme_fc_cmd_iu *cp;
 
 	/* Validate pointers. LLDD fault handling with transport does
 	 * have timing races.
@@ -1988,16 +1987,10 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 		return;
 	}
 
-	/*
-	 * Get Command Id from cmd to plug into response. This
-	 * code is not needed in the next NVME Transport drop.
-	 */
-	cp = (struct nvme_fc_cmd_iu *)lpfc_nbuf->nvmeCmd->cmdaddr;
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_ABTS,
 			 "6138 Transport Abort NVME Request Issued for "
-			 "ox_id x%x nvme opcode x%x nvme cmd_id x%x\n",
-			 nvmereq_wqe->sli4_xritag, cp->sqe.common.opcode,
-			 cp->sqe.common.command_id);
+			 "ox_id x%x\n",
+			 nvmereq_wqe->sli4_xritag);
 	return;
 
 out_unlock:
-- 
2.38.0

