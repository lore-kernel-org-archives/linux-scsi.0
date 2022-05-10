Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE9DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 20:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbiEJUAu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 16:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiEJUAn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 16:00:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CA25A59F
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 13:00:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id n10so179298pjh.5
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 13:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1qsp3v6JLdFkpkDuPdqdTA04998UbyaxHTh9mj+8HL4=;
        b=K/R2+YWadyMquiVrAfC9DWx0IvLH2EvbP0RTf3Caqpr04h2UWFJ/Tn3rZyeDgsoaP6
         YYTuZSJ/aJUAPCrauoxAWcDY58737fm+jBXDt9D3cvXC1HbGYKkHG2dDCcOJLsPWmErD
         adoBvVAmBpqBvONadbYU0ScFb/TBzoCdq9g80Dl1re0ftN1U4n97Y3G4yhBeA1FsFp1Z
         4YhoIcgXhYYfGuLbz7rPoy1mmhmwSYg/SDUxNf6+xIKoOJu6/YsgENNlnLpLegi/Q/JB
         77af+2impLs+NOxPpU6tc0B/sZaAGTtsFr8Lt8XYhXNW6OdUAbrJZf6DkVmjCNl/AXw+
         9esg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1qsp3v6JLdFkpkDuPdqdTA04998UbyaxHTh9mj+8HL4=;
        b=y0iJRjzj6PxS5NnKQLb/L3UXRURuH4xo7I4N0rn9sk/hJjuV71nje7AH3tcoN80+vA
         EGOUSjrJ6veOV6AWgEj/tP8URuzL8n6VYb9qPWOuJ5Dsa5TfG7tlzKWN7L8Ad5xK4Dhd
         +eF88QnsUExgoR8hfjGHAnOMxeuA1/I6NX/32iSkYw6rgl0EppnTKyubpneoabAodcqV
         ritCP4DNg3ujrE7UqYh0K74vWAvNOn9Tyg1mWEh8rUxeLXeWE5g2yXw9lB4AMozuw7c6
         DbZ8Kv33LHT55WPAZUZx714Yxi5C+SIAqlt6in23NJ5TJA2MzVMEj1EbpN8MVrRod0yk
         wi6w==
X-Gm-Message-State: AOAM530R7BmaShznrUxw1SZEJoUzuvT7zQUvyZh4keWrsrAx2QC4FINl
        VrSXKHlTwE5RcD8jugsCBU3/+nbjpBQ=
X-Google-Smtp-Source: ABdhPJxyKknKiZyGftIej6kY1tR27U9WAkOOYQOKQ/xTPnnIdNIfZaj2vahF2PHsXIEw/MkG7jJxhA==
X-Received: by 2002:a17:902:c404:b0:15e:9aa2:3abc with SMTP id k4-20020a170902c40400b0015e9aa23abcmr21954792plk.172.1652212839365;
        Tue, 10 May 2022 13:00:39 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh2-20020a170902a98200b0015e8d4eb2d2sm2422679plb.284.2022.05.10.13.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 13:00:38 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     linux-nvme@lists.infradead.org, James Smart <jsmart2021@gmail.com>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH 3/4] lpfc: rework lpfc_vmid_get_appid() to be protocol independent
Date:   Tue, 10 May 2022 13:00:27 -0700
Message-Id: <20220510200028.37399-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220510200028.37399-1-jsmart2021@gmail.com>
References: <20220510200028.37399-1-jsmart2021@gmail.com>
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

