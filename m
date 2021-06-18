Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79421C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 17:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64473613EB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 17:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhFRRVF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 13:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbhFRRVE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 13:21:04 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87149C061574
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 10:18:54 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a127so8136602pfa.10
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 10:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zq3V1KyaUiDdIgd53ZsbIBkBbpYfekyoEo/VMrRcUJ4=;
        b=EwQl7VVKCRyYkQk17iPJv5KVD7ROoDDBQiVkGpEO+ay8ZUSBdWEOJXgjxBUCLEMG0h
         iHS1x6UmnGUTeGEft3u6+fLcVtOG1UGSJcuFvFloCmRd/Yk93dketf+ImAYomZJMhVDe
         yzK+pWXVl27htDBtcxJUX2kaeG1RsklnbKSy+qWoxKmvjDeMVxujAKUir56WpMSnGEYN
         VQ7g+wdxyogSITwgKe1vue/I6bzuaLQmSz6CvSA9UaeetO1JjCWsiQNGZS6sdq50fDwj
         abq9xz2+DgFJ9incsGRpudS3rQc/KCW83eP+iQfqC3wmBweELS8lpVY9rimC3rfmETVU
         x0kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zq3V1KyaUiDdIgd53ZsbIBkBbpYfekyoEo/VMrRcUJ4=;
        b=kWbKaazRqnZVYlDIemG6HDdGkQMnsQVWKymAYMm+xrgqOlGSoXq3S7sPcip6Cx7G5T
         SBbjgq74Xbgfk+VPGHz2h6NSfAmB3KsawPV/7Tkm9A6Hk7Yyr/4MvVcNfJn3z/2X9yEV
         Efp95sVuzC0MUSVdVTBTxi9olD60gTZt4QEPlEHrAF79faNww91THHrCF63tMEQsj4Hy
         UUDo32lPPBJgFW2ZJV7vL3DFWIJnD8w5bkSZC8UUlVxn2ypvzI1bh/wxQw0gXmX0Swm+
         xRaoqGw0xG8adGikfnJcFnV1YzJUlVNFXwrmDiyGN+oZWen+ljpZk5me1W36mqbeAXoW
         oxlQ==
X-Gm-Message-State: AOAM532TCo6k9sBtI68BdUP8e7uYsk1PfUQrYCaRykESqMVwowtTf1Rn
        E7t2s7TWCISshQzggaK2Pg9zRzMkQtI=
X-Google-Smtp-Source: ABdhPJyS5e31Kfbcc7gzAwmsIs3ih+TdN8+WdQO3ZsjNJsKxPLYHG86mTZyRJzjVXBkSP6skrbb4mA==
X-Received: by 2002:a05:6a00:139c:b029:2f7:102c:5393 with SMTP id t28-20020a056a00139cb02902f7102c5393mr6371420pfg.40.1624036733986;
        Fri, 18 Jun 2021 10:18:53 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 25sm9419965pgp.51.2021.06.18.10.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 10:18:53 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     gaurav.srivastava@broadcom.com, linux-mm@kvack.org,
        muneendra.kumar@broadcom.com, hare@suse.de,
        martin.petersen@oracle.com, James Smart <jsmart2021@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] lpfc: Fix build error in lpfc_scsi.c
Date:   Fri, 18 Jun 2021 10:18:42 -0700
Message-Id: <20210618171842.79710-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Integration with VMID patches resulted in a build error when
CONFIG_DEBUG_FS is disabled and driver option CONFIG_SCSI_LPFC_DEBUG_FS
is disabled.

It results in an undefined variable:
lpfc_scsi:5595:3: error: 'uuid' undeclared (first use in this function); did you mean 'upid'?

Fixes: 33c79741deaf ("scsi: lpfc: vmid: Introduce VMID in I/O path")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 46bfe251c2fe..1b248c237be1 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5455,9 +5455,9 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	struct lpfc_io_buf *lpfc_cmd;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int err, idx;
+	u8 *uuid = NULL;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint64_t start = 0L;
-	u8 *uuid = NULL;
 
 	if (phba->ktime_on)
 		start = ktime_get_ns();
-- 
2.26.2

