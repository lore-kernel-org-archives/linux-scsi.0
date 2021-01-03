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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAC0C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7486207CD
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbhACASN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbhACASM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:18:12 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D6DC06179E
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:17:07 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id iq13so7685056pjb.3
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xcWlHSzISTzHimq9m8us/OZQ3dcrHRgpNzn9MODjlJM=;
        b=iowWBwUcf1TzOLOE73wGHh9FHmWOiAQygXleGWGvlza9ECevL/Gmkn/ungMv5QRAyz
         BtKvEa8QzH+M8gCm0NcsVZz8kaFyEJUEoDaIWpphy7wkl7Pw2jnwYVZ76ii94Lf0Tckr
         s7hOtae9yQfQkwtoj+kowd7i2fqFn25K3wvqMNYoeUiw4gkzRUYTTLPzsGFwGU+2eaGD
         BFldqIbPAPpluixMAOReW3UqrDgDZ3f4r5NsRSuAVFgSyNLpNnxcaeCuuNqN0R9PE4Nc
         zLuhMwijXj47xqTkRP+01WWsLTx/BPMX0xY/jrRYsqL+aU+0kIsawmdvXfrmQFL77rIv
         m8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xcWlHSzISTzHimq9m8us/OZQ3dcrHRgpNzn9MODjlJM=;
        b=kEJgRCeFJe7zzza7mquDJhkjBqOeHOismuQjEbryTA0+QVib9+DosdBa9U62q9DIO0
         QlnoyPkyQbQaMhoio9qUzWIiT5j1BBxcEbEfVippR8zzWF7d8QS70I10/HWb4n8JvK14
         JeHuROmdprIZGQ8A7aPOyNxT50KFtDzSbQSKfDJEK9KqDYHXrduYm+Mr1z37HE9JDLsn
         3MqjaCHUt9R9+c662vtLxdojbCDx3SHr0eqM7OpaUVD6oOtC7Av7q6S4/l2GeQj6wAJH
         TJXVlzDR4gVFKa3ibpVLc2iKgAQ088S9cQt4CZKG3GZaBnEvSwJM1UqNgFYC56diOSLt
         E4RQ==
X-Gm-Message-State: AOAM5328h4hqcV+kZAWJyzTGmiVzQt+wL48nSSvaMfqJlLMH4ixg4g/r
        +Q6R1b4US+Sd8rf7d6Q+RQ1s3j7chgM=
X-Google-Smtp-Source: ABdhPJyVt6xcktCH7r5Jn8og0jaO1uLzxso9M+cB0VkoJ3GDbmXlmXAss7tstF/4DaCq9yGfhWfGgg==
X-Received: by 2002:a17:90a:ce0c:: with SMTP id f12mr24077713pju.89.1609633026904;
        Sat, 02 Jan 2021 16:17:06 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:17:06 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/15] lpfc: Prevent duplicate requests to unregister with cpuhp framework
Date:   Sat,  2 Jan 2021 16:16:31 -0800
Message-Id: <20210103001639.1995-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103001639.1995-1-jsmart2021@gmail.com>
References: <20210103001639.1995-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the lpfc offline routine, called for various reasons such as
sysfs attribute, driver unload, or port error, the driver is calling
__lpfc_cpuhp_remove() to destroy the hot plug data. Unfortunately, if
the port then attempts to come back online, such as after the port error,
the cpuhp elements are no longer valid.

Fix by only calling the cpuhp removal if the adapter is in the process
of unloading and the port will not be restarted.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 593b175702eb..af926768bcae 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3602,7 +3602,11 @@ lpfc_offline(struct lpfc_hba *phba)
 			spin_unlock_irq(shost->host_lock);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
-	__lpfc_cpuhp_remove(phba);
+	/* If OFFLINE flag is clear (i.e. unloading), cpuhp removal is handled
+	 * in hba_unset
+	 */
+	if (phba->pport->fc_flag & FC_OFFLINE_MODE)
+		__lpfc_cpuhp_remove(phba);
 
 	if (phba->cfg_xri_rebalancing)
 		lpfc_destroy_multixri_pools(phba);
-- 
2.26.2

