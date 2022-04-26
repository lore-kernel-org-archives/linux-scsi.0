Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34221C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 18:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350445AbiDZSQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 14:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350685AbiDZSQq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 14:16:46 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2528B6C973
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 11:13:37 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id p12so6984773pfn.0
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 11:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VtiVzAIp0GNC+cldpKRPRn6jYBasSiFNXF9azXgLzzQ=;
        b=SwYSL14tQF2azYgJfHgQTW4pDsmQinyADoi9Fr0hlKdD1zbtokBTcRkLglkfFF7aJ7
         4eF2g+XZRqd+wkPD83AD2E5nmxniLaUvR+0CAV3HNd3scBDXFJILWh0PHpNg8XI40M8c
         zjSo0Jl1xA1hvH/kx1/hC21s6rhYe1fVMWF6oM0g5HeJATjZyusAVmwb9thx+yIsS15Y
         BeSnC+OM3MPIQSUbWr1y3WcgfnW4ya+Zx07508qDJ8SYvWZVkZKVT6wcwx7b34Ly5W+f
         hrmxfp0WSLyK7faOwUVtOm7lt9uIgEhNKHE+bhsU2IhkTXsNYqcv/061leJfZ9PiORaW
         aaog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VtiVzAIp0GNC+cldpKRPRn6jYBasSiFNXF9azXgLzzQ=;
        b=q7fj58HMvfCIHDWznj/15av6o39ZzFHk0WuM3fQTmly1Yk+9cfz+UPQ53XEt85awPc
         WMUZUGw0Ie4etbSttVx/hn3hKYX/uq5FfrG2tVi9n1Es7MigLOA6Ic1NMuVeuwibwnbN
         SQstv941WgLRu3VF1A5/9vc9toYoHUYLZUzMA8fybEH0Q1dGpP6o8d4B9FTnczEBIw/5
         vPLKclZ3ynvb37RDBMlECgfPYC4z/rTFuuzaFHxQf53PHWfCB684pNblztovo98iTMyv
         9brQd+X1uvJcNvAaovWqUU+iU3/NgHQVjLTZgGz6jFcHOHJR30SPrtRBksxSxw5RTfxr
         6TDg==
X-Gm-Message-State: AOAM533QOkr1Es3vkGt2LFh46BghpCerC5FhFMBWRIPDMC+T0K5GSMB3
        jO+zmgwbsbdjRvpwRFNAgqz2B8nm6rw=
X-Google-Smtp-Source: ABdhPJyHe/eu5qV/q7sgVLPpAxUibc9RgbFssfEdFQjirG14jWbtD5BIHlkwwry6hdHEXoaNN6kEig==
X-Received: by 2002:a05:6a00:1a0a:b0:4fc:d6c5:f3f1 with SMTP id g10-20020a056a001a0a00b004fcd6c5f3f1mr26039743pfv.45.1650996816501;
        Tue, 26 Apr 2022 11:13:36 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o1-20020a629a01000000b0050d606c1c2csm2838748pfe.54.2022.04.26.11.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:13:36 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] lpfc: Remove unnecessary null ndlp check in lpfc_sli_prep_wqe()
Date:   Tue, 26 Apr 2022 11:13:15 -0700
Message-Id: <20220426181315.8990-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Smatch had the following warning:
drivers/scsi/lpfc/lpfc_sli.c:22305 lpfc_sli_prep_wqe() error: we previously assumed 'ndlp' could be null (see line 22298)

Remove the unnecessary null check

Fixes: d51cf5bd926c ("scsi: lpfc: Fix field overload in lpfc_iocbq data structure")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8bf62697317a..f7815fe0da82 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22284,7 +22284,7 @@ lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
 				bf_set(wqe_ct, &wqe->els_req.wqe_com, 1);
 				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
 				       phba->vpi_ids[job->vport->vpi]);
-			} else if (pcmd && ndlp) {
+			} else if (pcmd) {
 				bf_set(wqe_ct, &wqe->els_req.wqe_com, 0);
 				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
 				       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
-- 
2.26.2

