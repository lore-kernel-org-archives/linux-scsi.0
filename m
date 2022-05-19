Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFDAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 12:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbiESMbc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 08:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237857AbiESMbV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 08:31:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B078117E17
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 05:31:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q18so4644902pln.12
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 05:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tK/AJbYf1XLJtnLnu5sGOjPU2zh83JUlra3tpMUdFzw=;
        b=SCl7IKILEOanhfBdDuNFyasgNUq/3btd61yuAkRGzrwxEDNuy90fWtBcAGY7bzjT3T
         GWtIAI2z7FH8j203YwZqqmVsswrMrYd5+RZquFwB5RoBscSouxI915SkSP90yIdXud1J
         kjOJDngQlYySGWQysTd7WXrE/wo7xKTjX1u2v3sJ4Rgno5XimG4b5XOhkOA66jn9N8wM
         zhxyLb+zXPj5sMrQv4+NJaJ48qVpuyX+wDzdIbyS8ZusIIcyanWG8i6C4hvF7tjznSdl
         iRFrxloiSCA4RGRe41+lq6tW6aurySLgM+y1XAGzLmZ993loBuO6WqQn4ZKY2lzdzvT6
         NkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tK/AJbYf1XLJtnLnu5sGOjPU2zh83JUlra3tpMUdFzw=;
        b=u/yiDV+O5oMEcp2Kv1BcpwImAmLkViNZSWFQPk1EeD66jIufipa/XFq5QMqXei3IFC
         Bn3q0XAR3RVx6zT+CstqyCM4O7GGR3zxlqInsJ/USIMOFqAiwPUutmt3jSSXdmlGeMln
         mM6DU1ys4U78al3lBe3hVHQieptdnCq7mMLrVHTR+Yyt1V5RAG7lbfirgHSxzgjGnQ1Y
         cczoPI8lXWKq99p2tgXFlPzcLiMSlSqyg/RK2AbkF+N8V0wRouDOWjkLNz3FfAzzPqBk
         m4/5HTisVDilRY/MfuzzDSgv96TXT31xhN2yFQi05AewiGIQMCnCeJ6Qb5Cw422N6Ncv
         PAiw==
X-Gm-Message-State: AOAM5331YWXgfSMyuSDAKIHpdMtWT7u8WiBLCu65tI7gFrmFtX4CJJet
        WUH0chHh9gVm0/4e1plAS0hHT+P9kxo=
X-Google-Smtp-Source: ABdhPJwlfr4Y9rRGjESIAJhp2lix7E35sbFoWBEn9qkSHfsxc3vbj8vfBCLdaPavjM5Z1EMd3OqUHA==
X-Received: by 2002:a17:902:a9ca:b0:161:54a6:af3f with SMTP id b10-20020a170902a9ca00b0016154a6af3fmr4712423plr.48.1652963480090;
        Thu, 19 May 2022 05:31:20 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z26-20020aa79e5a000000b005180f4733a8sm3581797pfq.106.2022.05.19.05.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 05:31:19 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 3/4] lpfc: rework lpfc_vmid_get_appid() to be protocol independent
Date:   Thu, 19 May 2022 05:31:09 -0700
Message-Id: <20220519123110.17361-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220519123110.17361-1-jsmart2021@gmail.com>
References: <20220519123110.17361-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rework lpfc_vmid_get_appid() arguments to remove scsi cmd dependency.
It's now callable by nvme path.

Fixup scsi calling path for arg change.

Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h | 5 +++--
 drivers/scsi/lpfc/lpfc_scsi.c | 7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 913844f01bf5..b1be0dd0337a 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -671,8 +671,9 @@ int lpfc_vmid_cmd(struct lpfc_vport *vport,
 int lpfc_vmid_hash_fn(const char *vmid, int len);
 struct lpfc_vmid *lpfc_get_vmid_from_hashtable(struct lpfc_vport *vport,
 					      uint32_t hash, uint8_t *buf);
-int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
-			       scsi_cmnd * cmd, union lpfc_vmid_io_tag *tag);
+int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid,
+			enum dma_data_direction iodir,
+			union lpfc_vmid_io_tag *tag);
 void lpfc_vmid_vport_cleanup(struct lpfc_vport *vport);
 int lpfc_issue_els_qfpa(struct lpfc_vport *vport);
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 70d0a4d3d92e..f5f4409e24cd 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5446,9 +5446,10 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		uuid = lpfc_is_command_vm_io(cmnd);
 
 		if (uuid) {
-			err = lpfc_vmid_get_appid(vport, uuid, cmnd,
-				(union lpfc_vmid_io_tag *)
-					&cur_iocbq->vmid_tag);
+			err = lpfc_vmid_get_appid(vport, uuid,
+					cmnd->sc_data_direction,
+					(union lpfc_vmid_io_tag *)
+						&cur_iocbq->vmid_tag);
 			if (!err)
 				cur_iocbq->cmd_flag |= LPFC_IO_VMID;
 		}
-- 
2.26.2

