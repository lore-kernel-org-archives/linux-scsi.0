Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A42C4332B
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0A7C20753
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q4ijIFXt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCVSNU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:13:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38472 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgCVSNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 14:13:20 -0400
Received: by mail-pf1-f194.google.com with SMTP id z25so1958171pfa.5
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 11:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fhKQjLdJwrp1LzEHOkRHw+RGMbbMgZH9HHJPU4beZ18=;
        b=q4ijIFXtZrbbytX52FxZGJzDiVqOg+oj2ebItmnzd1HF368WAsXhwJXrXiuD+tLFO1
         o470Gpl18eZhbbY35kCSbtcH1GQQkCiAX5e1UL8mMkqgP5az3/tFhgQplMyHq8XTR62Q
         seUM6UdpJ0nlHRi2HzvBDn07wHVgcI4eWO2bcxx3NRE12fvF0P7Zvvm23hMOqvqi9AHI
         peSne/0/Bd0JfymzdTwjnXmPlsIUSpS4XESk+Tjjtt76fmd1Ol1Fm/9/6zvcFvEDyAms
         WE/wOV+VE5OiaWn2dDMgurSgYYX8PTuq4JAu3iVRqYZknq/x+4juCaY5Ta2MeMWg2V0D
         WjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fhKQjLdJwrp1LzEHOkRHw+RGMbbMgZH9HHJPU4beZ18=;
        b=VHxu9axd+cnrugygDvxdcFyADf9M1VURXs9ipkt7TviIh4oI+jrxYNsaPL1gzVhozO
         QWHF1a80TUsetZzjoySI6vuodyK7RKfdwMlhc7Umh5jqOdrYdsE5nR6UB5yZbXyeIhbG
         3VClLegeLBSSASb0flpGwZw0T9jhsJd1ITh5Db1RolEUb5DT0QlqWkec7AihYtbfjjo8
         HNscGVQou9rW0Ax0Ju++e53oYndDk+pJsp9OmrLkhtDwoakbovZYd1rfcma2K1Sgqkrf
         6PEBWkq7Ts2ie8/kHPX/sGx6dqvMGOd6qugrMcPGHhXtQh/UaACmeZPfdnd5emCZgw/s
         Im4A==
X-Gm-Message-State: ANhLgQ3GLJeAmPap1N/3SSVDwr5lZmwAAKZVrcctEDwRW9S9qluK0ecY
        GYyfR1bKz/NJk5dmRYbp2aZtbmrx
X-Google-Smtp-Source: ADFU+vvIXe/rIvtzH4wcKT1UjrGatN3yOkqhtuH3E8UFjQ07tZxD40OhvvxKH/lavGLt5s/AZjTNUw==
X-Received: by 2002:aa7:9e42:: with SMTP id z2mr20080706pfq.109.1584900798500;
        Sun, 22 Mar 2020 11:13:18 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id bt19sm1331657pjb.3.2020.03.22.11.13.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:13:17 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 06/12] lpfc: Fix update of wq consumer index in lpfc_sli4_wq_release
Date:   Sun, 22 Mar 2020 11:12:58 -0700
Message-Id: <20200322181304.37655-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200322181304.37655-1-jsmart2021@gmail.com>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The lpfc_sli4_wq_release() routine iterates for each interim
value when updating the wq consuemr index.  This wastes cycles
and possibly confuses things as thevalue itterates (and the modulo
logic is being applied).

There's no reason for this. Just set it to the value from the hw.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 780ff187e9a3..52ccaebd6f2c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -230,25 +230,16 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe128 *wqe)
  * This routine will update the HBA index of a queue to reflect consumption of
  * Work Queue Entries by the HBA. When the HBA indicates that it has consumed
  * an entry the host calls this function to update the queue's internal
- * pointers. This routine returns the number of entries that were consumed by
- * the HBA.
+ * pointers.
  **/
-static uint32_t
+static void
 lpfc_sli4_wq_release(struct lpfc_queue *q, uint32_t index)
 {
-	uint32_t released = 0;
-
 	/* sanity check on queue memory */
 	if (unlikely(!q))
-		return 0;
+		return;
 
-	if (q->hba_index == index)
-		return 0;
-	do {
-		q->hba_index = ((q->hba_index + 1) % q->entry_count);
-		released++;
-	} while (q->hba_index != index);
-	return released;
+	q->hba_index = index;
 }
 
 /**
-- 
2.16.4

