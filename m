Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DE4C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA661207DF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cl8bVgyV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgHQIyo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgHQIyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 04:54:37 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73911C061388;
        Mon, 17 Aug 2020 01:54:37 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 189so7158484pgg.13;
        Mon, 17 Aug 2020 01:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6trBPHS9S/UpnG7t9zPTQG9eTrRzdIZ0hGY6nWo8pT0=;
        b=cl8bVgyVtDdOuybu7ntzDzVYdGgYTFj4kXvX/Q/SW7SNmWNG4ijca7Pi51LL43Gy/c
         fGmqeOrUZHiD3EXKBc/QB0aYtBdni4rBXpzCBtH6DHxHnP0p4hcHbp54foY8Sf9y5bq1
         3Jr8lSpeanDwpaxSHPeZ2vU/UrVw8OrgNvdEWSjKhiCQibLJLVl+qpOUY/i3UM8ISxRa
         VrzoCdHHjq1gC10tv6f4hGmwJF3QrZga15f8nH30xEgER7SLCE804KzeVHXGJMwIM4vn
         YEHygXBdktDk+IzpzxcEfWqY0x8wg0pO/uAHTO90jm8c860oZFr6aXzGTj603h7Tb52o
         BUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6trBPHS9S/UpnG7t9zPTQG9eTrRzdIZ0hGY6nWo8pT0=;
        b=lhL2YPpv1FtpfGme7tWbq1jJ2eDudGaDY8/Ud2EMxUuqtsgzWh3NIE0ELE11l6N++Q
         bvc3l5NnXScJ7oze+OijOeqkAPkaDt5TRolCI76PBeBBzqsSnOlMmwq+ycAmco1976A3
         ssPNPw9+0gfPwHTWqDa8NpF/KVOloiUDNIk3O3qfk3nvU1LsHZIY7FWnTUAoQAE0jLBA
         qnlpneXpFZ+JYpvQDTwbSUEFNhcMQ+7NSk+owuYofJ0QkYBFExb8Mgi/bGdAiuuufVgi
         RnwhqJrXQvQEvC2CkHzb3ByYMtyO/B7SOlwZqQa0bkDHjt4obLNQogA6sL93WsH+1v8t
         F2Og==
X-Gm-Message-State: AOAM531mxDNfJoIjGlpHc7LVOJxhbd9xzwSj/nQ74f2m/GVdJOiKUQe/
        gqICIRSUtHU20wBWaQ4PiXE=
X-Google-Smtp-Source: ABdhPJwjAV9PFZKFZKeGA8kArDIlyD0PRcA0bJOuTXRTyct2hX3bCII6uKRIp7rPH/jH1Bjpszui/A==
X-Received: by 2002:a62:52d6:: with SMTP id g205mr10856808pfb.144.1597654477011;
        Mon, 17 Aug 2020 01:54:37 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id x12sm18236990pff.48.2020.08.17.01.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:54:36 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Cc:     keescook@chromium.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 2/8] scsi: esas2r: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:24:03 +0530
Message-Id: <20200817085409.25268-3-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085409.25268-1-allen.cryptic@gmail.com>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/esas2r/esas2r.h      | 2 +-
 drivers/scsi/esas2r/esas2r_init.c | 4 +---
 drivers/scsi/esas2r/esas2r_main.c | 4 ++--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index e30d2f1f5368..b99434e24868 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -992,7 +992,7 @@ int esas2r_write_vda(struct esas2r_adapter *a, const char *buf, long off,
 int esas2r_read_fs(struct esas2r_adapter *a, char *buf, long off, int count);
 int esas2r_write_fs(struct esas2r_adapter *a, const char *buf, long off,
 		    int count);
-void esas2r_adapter_tasklet(unsigned long context);
+void esas2r_adapter_tasklet(struct tasklet_struct *t);
 irqreturn_t esas2r_interrupt(int irq, void *dev_id);
 irqreturn_t esas2r_msi_interrupt(int irq, void *dev_id);
 void esas2r_kickoff_timer(struct esas2r_adapter *a);
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index eb7d139ffc00..55387c14fb8d 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -401,9 +401,7 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 		return 0;
 	}
 
-	tasklet_init(&a->tasklet,
-		     esas2r_adapter_tasklet,
-		     (unsigned long)a);
+	tasklet_setup(&a->tasklet, esas2r_adapter_tasklet);
 
 	/*
 	 * Disable chip interrupts to prevent spurious interrupts
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7b49e2e9fcde..7ffa9406ab4d 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1546,9 +1546,9 @@ void esas2r_complete_request_cb(struct esas2r_adapter *a,
 }
 
 /* Run tasklet to handle stuff outside of interrupt context. */
-void esas2r_adapter_tasklet(unsigned long context)
+void esas2r_adapter_tasklet(struct tasklet_struct *t)
 {
-	struct esas2r_adapter *a = (struct esas2r_adapter *)context;
+	struct esas2r_adapter *a = from_tasklet(a, t, tasklet);
 
 	if (unlikely(test_bit(AF2_TIMER_TICK, &a->flags2))) {
 		clear_bit(AF2_TIMER_TICK, &a->flags2);
-- 
2.17.1

