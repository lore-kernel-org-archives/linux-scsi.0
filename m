Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1058C07E9C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C891C61CD1
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhGGSqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhGGSqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:39 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C716C061768
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:43:58 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 145so3082305pfv.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5tH2/DTXmjYGTFufvhLqLupDSMJ7Y2vU3YGAlX27NgI=;
        b=fFIsQ6cxEZIaUYsM6A/yquypJx/VPNI1x3CqENaYgeZS8S5a01/AFlLDsCvxGPpNtr
         VQyaoP7f5ei/Hg79q4okZVL3v+fvVva88YQUupJ4FdPuA4MaocqLrZEKyX2CVjwh3CBu
         AmFzXCjKzwf0hRPu+oxwI7StIxPO5ZjOfiNH9WyF9f8ntEyFuZdGD1OALUpeLnxSvXiB
         dTkWzCFKD2XfxtGyCKxDhjdG5TgyJe/Vx47EDd8c63zk0rxAt7SjhhcxweW1eHkPkOYa
         6J1GZVm3YooiP9FQf8ATOclW7tVSkwckBF4s5NG6WLxh8C/au/BryU8V5kaFP5u+Hb4x
         QnhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5tH2/DTXmjYGTFufvhLqLupDSMJ7Y2vU3YGAlX27NgI=;
        b=WtMSmya6AdTmlLnwQDQRzKJ6Rr/vmoW2e9691b9KaI5Ltm8gKXeSYsOpHnuphZtwUy
         qJn4g0TSkHnjz7ivYVBO5AXynptZ/idIIlyJXdYzZ02nAIxpUJb8UZ/O9oisIDXjD5n2
         Esu9rxA3R0E/xZicoNevUdmdH5Acd9bTEFMNt2fTU7QXUkF9j/0LIW/7uM/EwlwOyaWm
         cvMiJVDc70XWepY3TqoZJnbCiVQOO5sGxNFgVKpm0HgamUjg3jzASkDWtM5CTe2icZr0
         y9r5fsrGIFlPPo9IXcEj0uRi33tcas0lu4rVzkar8ZHSWGQuBzM9RM+IhioSHYqN+jdn
         aGTQ==
X-Gm-Message-State: AOAM533Jfq0qqW/ioCfEMloiFynn8g7ct5CVMqlJCIdQpHdNkT1xM88Z
        DE80AwipIEAVMxl+8/d7rzx2czVziZA=
X-Google-Smtp-Source: ABdhPJxLY3Ng0ckx+5Mmg8ij0F/PzdHUVAGoMHofc0JpRVlTaOtcAjsaT5w/Q5Cfsn+VjmXURbcXbA==
X-Received: by 2002:a63:2c8a:: with SMTP id s132mr27587227pgs.65.1625683438012;
        Wed, 07 Jul 2021 11:43:58 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:43:57 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 04/20] lpfc: Fix function description comments for vmid routines
Date:   Wed,  7 Jul 2021 11:43:35 -0700
Message-Id: <20210707184351.67872-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update comment headers for functions lpfc_vmid_cmd and lpfc_vmid_poll

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c   | 5 ++---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 610b6dabb3b5..1acb8820a08e 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3884,9 +3884,8 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 /**
  * lpfc_vmid_cmd - Build and send a FDMI cmd to the specified NPort
  * @vport: pointer to a host virtual N_Port data structure.
- * @ndlp: ndlp to send FDMI cmd to (if NULL use FDMI_DID)
- * cmdcode: FDMI command to send
- * mask: Mask of HBA or PORT Attributes to send
+ * @cmdcode: application server command code to send
+ * @vmid: pointer to vmid info structure
  *
  * Builds and sends a FDMI command using the CT subsystem.
  */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 51f4058a75b8..6867b02219b0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4845,7 +4845,7 @@ lpfc_sli4_fcf_redisc_wait_tmo(struct timer_list *t)
 
 /**
  * lpfc_vmid_poll - VMID timeout detection
- * @ptr: Map to lpfc_hba data structure pointer.
+ * @t: Timer context used to obtain the pointer to lpfc hba data structure.
  *
  * This routine is invoked when there is no I/O on by a VM for the specified
  * amount of time. When this situation is detected, the VMID has to be
-- 
2.26.2

