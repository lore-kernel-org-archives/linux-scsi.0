Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3DBC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED75207DF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:55:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ARN7DkZq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgHQIy5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgHQIyq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 04:54:46 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C6AC061388;
        Mon, 17 Aug 2020 01:54:45 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m71so7910724pfd.1;
        Mon, 17 Aug 2020 01:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lDmZSaB9SDsuHRMCoS4mSkpLKS8AQi0WM0y0umCFAfM=;
        b=ARN7DkZqBaOJ2CSCPA2npO8s8jVmPE2GVZq8gro0ceYQ+wn+he80p3n41djo7NzhnV
         6l6ji36C0sm/yXaeqpiF2Y2MDBJSCBsXmRg0UdNHMGZTJHQIefxQpZi4lATRCpNvgThF
         KdjNkwZCbZLWYTCnrOJm7+O27kCFnASn7iELJo3fUKcgQMjeF0V0SETxxE8p/Fq5zAOj
         V0Oj5K5yzDgnI2EcVA8xvEBTiO+aF/4GF13g7Sa9j1wiwtU7e0bwUtsZEN1QlGs6hOIu
         pIx6oaHry1qw0DGPvp9GRBbMnc1+igxjEHLSPVicFCGea7pkEPH1b7/FFiZZXaL6Q6Nz
         cRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lDmZSaB9SDsuHRMCoS4mSkpLKS8AQi0WM0y0umCFAfM=;
        b=IC2Qd069WTcHRirDbXIpSRHvJ6Yke4YkUDpO5WIB2rM3ZmV3b0M+4C14LgM+aZ2Yc5
         P0aRKUpgaEFGxb57+t52Cayw8Sfqwdoz1wvoQEG3KO4oNpixcdrR2RK00GIqaluwJzVs
         tkq/+xEmgMCeP2DwmJ1H6hl6KfxM3BPHnWe5Zk4M5Su7cIo63oKBxxifUUcz0x/HPeIg
         BFfJsnG/IEWgVMgfT05q8tN/pr87x4qK9cAEhpR5gEC2oyD/xvi692CpzpuMoB7wGSEN
         DmlNtakZZh7iD4poyqIh+T1CEwIQvJ/dkYkRxi3amvUAQaRfuK2L7wdadtotibDhrLpm
         8u0Q==
X-Gm-Message-State: AOAM531k7ZcqeAzJwu0V7i46noYi3Rbu6XzxEjNV738MNANPRjeCvef2
        2M2pv9UWR2/t66YueIHPaCADX4H6WFUxAw==
X-Google-Smtp-Source: ABdhPJyVPcS+QO1XpTezGIF49izLpHDxWvhsJOVJBH8xcafcgG3FsCBY46X4INpr0WC4C/0DkTVuJA==
X-Received: by 2002:a63:67c5:: with SMTP id b188mr8533979pgc.412.1597654485371;
        Mon, 17 Aug 2020 01:54:45 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id x12sm18236990pff.48.2020.08.17.01.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:54:44 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Cc:     keescook@chromium.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 4/8] scsi: isci: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:24:05 +0530
Message-Id: <20200817085409.25268-5-allen.cryptic@gmail.com>
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
 drivers/scsi/isci/host.c | 4 ++--
 drivers/scsi/isci/host.h | 2 +-
 drivers/scsi/isci/init.c | 3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 7b5deae68d33..599adebd039e 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1113,9 +1113,9 @@ void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_ta
  * @data: This parameter specifies the ISCI host object
  *
  */
-void isci_host_completion_routine(unsigned long data)
+void isci_host_completion_routine(struct tasklet_struct *t)
 {
-	struct isci_host *ihost = (struct isci_host *)data;
+	struct isci_host *ihost = from_tasklet(ihost, t, completion_tasklet);
 	u16 active;
 
 	spin_lock_irq(&ihost->scic_lock);
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 6bc3f022630a..6abe23682d9b 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -478,7 +478,7 @@ void isci_tci_free(struct isci_host *ihost, u16 tci);
 void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_task *task);
 
 int isci_host_init(struct isci_host *);
-void isci_host_completion_routine(unsigned long data);
+void isci_host_completion_routine(struct tasklet_struct *t);
 void isci_host_deinit(struct isci_host *);
 void sci_controller_disable_interrupts(struct isci_host *ihost);
 bool sci_controller_has_remote_devices_stopping(struct isci_host *ihost);
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 085e285f427d..32a0117b5ff4 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -511,8 +511,7 @@ static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
 	init_waitqueue_head(&ihost->eventq);
 	ihost->sas_ha.dev = &ihost->pdev->dev;
 	ihost->sas_ha.lldd_ha = ihost;
-	tasklet_init(&ihost->completion_tasklet,
-		     isci_host_completion_routine, (unsigned long)ihost);
+	tasklet_setup(&ihost->completion_tasklet, isci_host_completion_routine);
 
 	/* validate module parameters */
 	/* TODO: kill struct sci_user_parameters and reference directly */
-- 
2.17.1

