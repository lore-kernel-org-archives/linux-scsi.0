Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9EF6C4332F
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Dec 2021 00:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354477AbhLDAaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 19:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354412AbhLDAaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 19:30:16 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2B4C061751
        for <linux-scsi@vger.kernel.org>; Fri,  3 Dec 2021 16:26:52 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 200so4656632pga.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 16:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wo2Im+69e7cDpOGpRnEBqx1Tl2DuIRRR2RoQczgIUYA=;
        b=MPR9jxb2RHIwlZkoYGFp137Nnr5zlb11ITBEIa0ySrfDvA4w3hug3xBYs97V4xiddX
         dfjCFyyk+Sw+QCFtMYra9isRXhMn5Up4CnnFrt/L3RKCqGXQ7hsyDOJ5d4zT0K0NzDz5
         f03m+Ed4Argt/89CAkqx1wj+VYIzOW6MZ1HutVeV+3p+PMCZgZSLc2SJYmG1Oemmxbdf
         DNllz2tN3R1phx01+5Zvhl798qGyJ5u6/hqpAC7L5O1b/GHoiLetal98M44ntsvd7wod
         byOefC95meVfXtiK5B4XFwJTr1X95AL5GIVDOJ+Tb5+V8G4p1u7P2d2J+APxeSqsiKLS
         lvPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wo2Im+69e7cDpOGpRnEBqx1Tl2DuIRRR2RoQczgIUYA=;
        b=NAnawR36y+p+Lo84b9dO9J7ZzxnmN7rpauCwGHP8amPIpb/DJyxRF1bG8UA8F4Z/FN
         H4aJ+MdqEPXIdKnimYQuDy/rXPUMGAEA5X9HvYPG/am+bLGbJ3d4iMqfimQXQyoJFGYM
         0fvObvkgFIeflOlTgse3nGo7QN6VC60hhODyRazJj4wmptUowB1eeDeqW1r0amHD+zzm
         IOA5ubHjhkh7XiVvAR2o5NHsKHGQqozK2/XSVoazk7loJkGNM3b4JqoKXFCxZAnLYrYK
         K8p69AjPnDkXSrWD8qokBGzL9oa6NjP+qptkkBzLRgkiDwOa+GjB75dnfp+PGw81BB6k
         WM6g==
X-Gm-Message-State: AOAM531s0Yv12zJlEV9PdZimgD+e7jIGUPsCtzzT/Dx6GGw+wu/cRhD0
        ufbC1xCp+szVKTdKc9O8A7oyPd10dKk=
X-Google-Smtp-Source: ABdhPJw9mk6t3DeBb+djusdr3FA5ATrL9d3L/6Q1pWsFHEuNDw61/2x+rvEpZG9U3PxX+M4Yy4Tkcw==
X-Received: by 2002:a05:6a00:114d:b0:4a2:87bd:37f with SMTP id b13-20020a056a00114d00b004a287bd037fmr22380199pfm.82.1638577611864;
        Fri, 03 Dec 2021 16:26:51 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q17sm4970707pfu.117.2021.12.03.16.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:26:51 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 2/9] lpfc: Change return code on ios received during link bounce
Date:   Fri,  3 Dec 2021 16:26:37 -0800
Message-Id: <20211204002644.116455-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211204002644.116455-1-jsmart2021@gmail.com>
References: <20211204002644.116455-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During heavy I/O testing with issue_lip to bounce the link, occasionally
I/O is terminated with status 3 result 9, which means the RPI is
suspended.  The io is completed and this type of error will result in
immediate retry by the scsi layer. The retry count expires and the io
fails and returns error to the application.

To avoid these quick retry/retries exhausted scenarios change the return
code given to the midlayer to DID_REQUEUE rather than DID_ERROR. This
gets them retried, and eventually succeed when the link recovers.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw.h   | 2 +-
 drivers/scsi/lpfc/lpfc_scsi.c | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 634f8fff7425..61c9db31d9da 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -3746,7 +3746,7 @@ typedef struct {
 #define IOERR_ILLEGAL_COMMAND         0x06
 #define IOERR_XCHG_DROPPED            0x07
 #define IOERR_ILLEGAL_FIELD           0x08
-#define IOERR_BAD_CONTINUE            0x09
+#define IOERR_RPI_SUSPENDED           0x09
 #define IOERR_TOO_MANY_BUFFERS        0x0A
 #define IOERR_RCV_BUFFER_WAITING      0x0B
 #define IOERR_NO_CONNECTION           0x0C
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 6ccf573acdec..5a3da38a9067 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4393,6 +4393,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		if (lpfc_cmd->result == IOERR_INVALID_RPI ||
 		    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 		    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
+		    lpfc_cmd->result == IOERR_RPI_SUSPENDED ||
 		    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
 			cmd->result = DID_REQUEUE << 16;
 			break;
@@ -4448,10 +4449,11 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 				 "9039 Iodone <%d/%llu> cmd x%px, error "
-				 "x%x SNS x%x x%x Data: x%x x%x\n",
+				 "x%x SNS x%x x%x LBA x%llx Data: x%x x%x\n",
 				 cmd->device->id, cmd->device->lun, cmd,
-				 cmd->result, *lp, *(lp + 3), cmd->retries,
-				 scsi_get_resid(cmd));
+				 cmd->result, *lp, *(lp + 3),
+				 (u64)scsi_get_lba(cmd),
+				 cmd->retries, scsi_get_resid(cmd));
 	}
 
 	lpfc_update_stats(vport, lpfc_cmd);
-- 
2.26.2

