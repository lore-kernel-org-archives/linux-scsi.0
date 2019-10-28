Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C000CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 19:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 377F821721
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 19:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kr+58qlw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfJ1T6y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 15:58:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44493 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJ1T6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 15:58:54 -0400
Received: by mail-pf1-f193.google.com with SMTP id q26so3999177pfn.11;
        Mon, 28 Oct 2019 12:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=mUUwYm2J4X9AJ/m0x6sMLtjI+0msH+IroBSGwyonZQg=;
        b=Kr+58qlwc2ermSgdCkMendRK93dGnsQ9/wcP+2QXe/ZhgaKwKYBHjpXqbKD0s+/i49
         wqCOQIRuPqk4i1wpLLZlD6DdrUqRixVQyNe/4u9QVfCwiAZ/jTFaM6AC+XBVTn7+FYW1
         oWSX46ptaB74p2i76Z1aB/q396JNSy4hfgOJYPy+fsUuyfzJwffFI/AQVuFGzucvIyOV
         hEOIfIIpoRDnDxAyLt6A6UmJImPw+FDV8xPUPAzDCTXb5YZ9/6Z9fW+HbZtPm3hZdanV
         zEdkG7sk4etqQXxYYM7wDTIxHwWeUSPd6x+em0hFXw+3BjvTWI8oZG/fcoWIiuOmo0Gr
         sNFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=mUUwYm2J4X9AJ/m0x6sMLtjI+0msH+IroBSGwyonZQg=;
        b=j1A3hBxyI7WiaQY/2pUFOSlxjn8B1OQUj6VSk0doXLX9aNi5akxe4NiBQhsNXIRTWT
         r4ldGptQmSD2ToxMib4z3LyB+OpkDjB5JStiQffb01JdONV3ZwoOB3uWBHPeUH08/uBp
         LfFsfLUmt9I9GVibAEPAAzhNAv7oQuKL8qPMOK2K2Q9XhTxNicUhewycc/nqrNgfKaPx
         EEv9+2Z5H/50zlAxyu9wHOTtGKi/4SjaxvIP4bsUzAhYRh6tS226kcP32n7B6QAdckbl
         AcbyiBtunaLSIIiaLDI1uBA2cmrmQ54sZdmV/PfmuoGRS/vG1zfi0Zmv0kKj3b1z+x7H
         gyxQ==
X-Gm-Message-State: APjAAAXni5ZzTqU0dsGDD4Ev1uFqFjZVfq/pk7ZFnt1Ot+fsL7eRVwtZ
        RGfTYAmOdyrqMgW+XXxVUgY=
X-Google-Smtp-Source: APXvYqxmNOlFl+8UCIExMbtEghL6rJkdU+mbae+gk/jlG2s6cpuUnqbwShlRdqMyzSqgb7CMfJzAig==
X-Received: by 2002:a17:90a:9201:: with SMTP id m1mr1376390pjo.74.1572292731971;
        Mon, 28 Oct 2019 12:58:51 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id x192sm12472924pfc.109.2019.10.28.12.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:58:51 -0700 (PDT)
Date:   Tue, 29 Oct 2019 01:28:44 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     QLogic-Storage-Upstream@qlogic.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] scsi: qla4xxx: ql4_init.c: Remove Unneeded variable status
Message-ID: <20191028195844.GA28740@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove unneeded variable status in qla4xxx_process_ddb_changed()

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 2bf5e3e639e1..8942c48740cb 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1167,7 +1167,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
 				uint32_t state, uint32_t conn_err)
 {
 	struct ddb_entry *ddb_entry;
-	int status = QLA_ERROR;
 
 	/* check for out of range index */
 	if (fw_ddb_index >= MAX_DDB_ENTRIES)
@@ -1189,7 +1188,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
 	ddb_entry->ddb_change(ha, fw_ddb_index, ddb_entry, state);
 
 exit_ddb_event:
-	return status;
+	return QLA_ERROR;
 }
 
 /**
-- 
2.20.1

