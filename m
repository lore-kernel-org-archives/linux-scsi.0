Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2D4C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16A8E64F37
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhCQJXh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCQJXC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:23:02 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F292C06174A;
        Wed, 17 Mar 2021 02:23:02 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id m186so21527876qke.12;
        Wed, 17 Mar 2021 02:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T1GtPUBuZOnjHCoV7VnCDLRvu8oNFBYaa7m3OGdlXM4=;
        b=R3VkjbpSXw8SDj0VbR+QLejzXFrZjibSDxyNYVnd/wSzqlA6uh9dQLBgu+TFq6ddQu
         BfNxOFhU2h9iIG9Uc9TfSnpIVWk0chHlDq2JhYdISat7f8T9y6TLrF+ipcViGkMO+C1d
         QLU2bH+dlBDadXS65JgahHISCJU0D6IjF2mAS+Y5nkxAErbzmJP0eriA7+uVWtYH8Qht
         gSrk2QAu7oLyOAMecDyAlnghM7cEMmJ7lWLqNSG1DEN8lpoNEQPAr3r2IPRc0vLQFgWi
         jzTKoaUUjvOryZopVqy8ICBA+A+JPQnXxiu5hWSAcyt/mxDJNbo9mJ6IsRiJBxwxhU3W
         ZQ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T1GtPUBuZOnjHCoV7VnCDLRvu8oNFBYaa7m3OGdlXM4=;
        b=lgLAfHkl2i21LrKYHCsIXOLF/zt9zLScz259zFIvxN2DlWCbHD3VquxqHUOrtTo4/T
         NyNaJkbx3b1rL5FIWRS/RCh5UMXeUsxXZC8JkCg7DEugd9eMptp9vu81kZQ3Cw2N/Lnl
         BfgVCHJrmeX1i/Y+/ADdUOsCySYxnbIwbuISU70oXHIhZuToNXA6kmmCPtH1XzO+LZEg
         jqDBho/LjKI0qrOTQvZgVnTFIPUfDPazbQySiUWgacsxjAnDYsV2ny7kVu4CT57VCb8u
         0GpIOsnyq28M84MvqRVa1vlSTj6h5prO0ROMzEpPEDi0RQ2EejMjNtC1jx9dsQtqUZoP
         H4nQ==
X-Gm-Message-State: AOAM53299FdtyLOTAqONg9qOrjpkagGQvLNYz856btQuOtnt8ecqfoSw
        /Q9fVgQcgjO7XiJfeCDZSsQ=
X-Google-Smtp-Source: ABdhPJxlRq9BQwbDy+PNehFWbmAuadPYti1qZC23Bjc/Bjx3+EQkxi1O2EWv6lE2lu15UN71XwVA2g==
X-Received: by 2002:a37:a404:: with SMTP id n4mr3623992qke.439.1615972981545;
        Wed, 17 Mar 2021 02:23:01 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.48])
        by smtp.gmail.com with ESMTPSA id z5sm15248539qtc.42.2021.03.17.02.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:23:00 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] scsi: fnic:  Rudimentary spelling fixes throughout the file fnic_trace.c
Date:   Wed, 17 Mar 2021 14:52:40 +0530
Message-Id: <20210317092240.927822-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Rudimentary typo fixes throughout the file.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/fnic/fnic_trace.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 9d52d83161ed..4a7536bb0ab3 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -153,7 +153,7 @@ int fnic_get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
 			if (rd_idx > (fnic_max_trace_entries-1))
 				rd_idx = 0;
 			/*
-			 * Continure dumpping trace buffer entries into
+			 * Continue dumping trace buffer entries into
 			 * memory file till rd_idx reaches write index
 			 */
 			if (rd_idx == wr_idx)
@@ -189,7 +189,7 @@ int fnic_get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
 				  tbp->data[3], tbp->data[4]);
 			rd_idx++;
 			/*
-			 * Continue dumpping trace buffer entries into
+			 * Continue dumping trace buffer entries into
 			 * memory file till rd_idx reaches write index
 			 */
 			if (rd_idx == wr_idx)
@@ -632,7 +632,7 @@ void fnic_fc_trace_free(void)
  * fnic_fc_ctlr_set_trace_data:
  *       Maintain rd & wr idx accordingly and set data
  * Passed parameters:
- *       host_no: host number accociated with fnic
+ *       host_no: host number associated with fnic
  *       frame_type: send_frame, rece_frame or link event
  *       fc_frame: pointer to fc_frame
  *       frame_len: Length of the fc_frame
@@ -715,13 +715,13 @@ int fnic_fc_trace_set_data(u32 host_no, u8 frame_type,
  * fnic_fc_ctlr_get_trace_data: Copy trace buffer to a memory file
  * Passed parameter:
  *       @fnic_dbgfs_t: pointer to debugfs trace buffer
- *       rdata_flag: 1 => Unformated file
- *                   0 => formated file
+ *       rdata_flag: 1 => Unformatted file
+ *                   0 => formatted file
  * Description:
  *       This routine will copy the trace data to memory file with
  *       proper formatting and also copy to another memory
- *       file without formatting for further procesing.
- * Retrun Value:
+ *       file without formatting for further processing.
+ * Return Value:
  *       Number of bytes that were dumped into fnic_dbgfs_t
  */

@@ -785,10 +785,10 @@ int fnic_fc_trace_get_data(fnic_dbgfs_t *fnic_dbgfs_prt, u8 rdata_flag)
  *      @fc_trace_hdr_t: pointer to trace data
  *      @fnic_dbgfs_t: pointer to debugfs trace buffer
  *      @orig_len: pointer to len
- *      rdata_flag: 0 => Formated file, 1 => Unformated file
+ *      rdata_flag: 0 => Formatted file, 1 => Unformatted file
  * Description:
  *      This routine will format and copy the passed trace data
- *      for formated file or unformated file accordingly.
+ *      for formatted file or unformatted file accordingly.
  */

 void copy_and_format_trace_data(struct fc_trace_hdr *tdata,
--
2.30.2

