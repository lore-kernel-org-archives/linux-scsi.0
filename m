Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F8DC3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 21:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAD6920828
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 21:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1Kv4ISw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbfH0V23 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 17:28:29 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44650 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfH0V23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 17:28:29 -0400
Received: by mail-pf1-f194.google.com with SMTP id c81so209164pfc.11
        for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2019 14:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yTvT+uVbv5xJcCebYgwfHsHmYCsadwDWT/g151BqdC8=;
        b=L1Kv4ISwZXDiZPJrndeHCb7omu89MGxk6Dnvmvm3KDmujBCQG6bDpOWFDkXtDfg8w2
         5GgdrM1hjqsfAp3lKp7eVohLRsFbrbMSG2NvLU/ElER95Myn+LkfGAkZvzJJQbriMUWq
         MnFZMgzlmVVQ0U5nmlDvpkQMwLQQ/7eQnNDRaZMDeFuz4s53G9dG83lyS86J3gaOf8Py
         aCDifE8rf9yY/DZ2kklZ/RIUVyLBhz3kGeh8w8vir1DZhcrSTVJBRxC8vjDuA10KvNoB
         RV+nkl+6nyteahzAwXZDNvC7JD4/hTXpvdLUEN4msiZMWmDXZoxYZRfiRShYs2+pN4Zo
         U+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yTvT+uVbv5xJcCebYgwfHsHmYCsadwDWT/g151BqdC8=;
        b=AprJpv3vigG82Upa+uTnZGineNaTl9AuVjyGdCWIFj380Jw1Waahww4vUl/tfv7XXm
         NOZrZF5HzwuTJIlqlGFVKRUW6PKeCxnF3F9j5Rj5gfDQfY7I6svIWfHaZ9IAeA2spl/U
         pdcxTW8jajLgKkvUOhfXiZmgUzZxfzDCkPQkk+qguNAVrctBhGLnEW/ALMkj+fMAK7nt
         kPt+Rs6stP66sPpfNG40jUw4Ao61vBLQr7OdIltm/iUqELyc8eIaryI5xPOLP1bKiX9g
         TuoE2w7LApPKKY7h7jR+A5jzy95B8K4xQgrPVaLmA7WgqkXmez3EP9VlcLIMldNrNtbn
         AYbw==
X-Gm-Message-State: APjAAAW4ukv8ZxDl1CbPFnEYjOJLR4gGA3hlqFOsZ9nsgS7moOqenNfc
        XTUdgKIviSHwXOc4BoDB2NXApYpO
X-Google-Smtp-Source: APXvYqw7e7jV2wdMbJg3rd6q1JocmwyFEXuY7Ux23E+i2knsed+s+GszrjSQ85weZ9b69vPNCFlksA==
X-Received: by 2002:a63:4522:: with SMTP id s34mr464698pga.362.1566941308591;
        Tue, 27 Aug 2019 14:28:28 -0700 (PDT)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j1sm248321pfh.174.2019.08.27.14.28.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 27 Aug 2019 14:28:28 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH] lpfc: Raise config max for lpfc_fcp_mq_threshold variable
Date:   Tue, 27 Aug 2019 14:28:23 -0700
Message-Id: <20190827212823.30107-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Raise the config max for lpfc_fcp_mq_threshold variable to 256.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
CC: Hannes Reinecke <hare@suse.de>

---
Martin, this fix applies 5.3/scsi-fixes patch:
  scsi: lpfc: Mitigate high memory pre-allocation by SCSI-MQ
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 +-
 drivers/scsi/lpfc/lpfc_sli4.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 491a999056aa..25aa7a53d255 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5713,7 +5713,7 @@ LPFC_ATTR_RW(nvme_embed_cmd, 1, 0, 2,
  *      0    = Set nr_hw_queues by the number of CPUs or HW queues.
  *      1,128 = Manually specify the maximum nr_hw_queue value to be set,
  *
- * Value range is [0,128]. Default value is 8.
+ * Value range is [0,256]. Default value is 8.
  */
 LPFC_ATTR_R(fcp_mq_threshold, LPFC_FCP_MQ_THRESHOLD_DEF,
 	    LPFC_FCP_MQ_THRESHOLD_MIN, LPFC_FCP_MQ_THRESHOLD_MAX,
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 2d1823e449aa..a4be83d1f37e 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -46,7 +46,7 @@
 
 /* FCP MQ queue count limiting */
 #define LPFC_FCP_MQ_THRESHOLD_MIN	0
-#define LPFC_FCP_MQ_THRESHOLD_MAX	128
+#define LPFC_FCP_MQ_THRESHOLD_MAX	256
 #define LPFC_FCP_MQ_THRESHOLD_DEF	8
 
 /* Common buffer size to accomidate SCSI and NVME IO buffers */
-- 
2.13.7

