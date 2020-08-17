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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E14C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB8742080D
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WmbN/sEc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgHQIye (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgHQIyd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 04:54:33 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421F2C061388;
        Mon, 17 Aug 2020 01:54:33 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ep8so7377463pjb.3;
        Mon, 17 Aug 2020 01:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nOJuhLui4k7rvz/wos+0nsCIYbwj7zan4woC4Ksv4tU=;
        b=WmbN/sEcHhuhCQ5aYnsNMtgOfzo7imWBnx5Crm1NhU5y5BmwSjvzdXxZ0ifIsV6mAX
         QJRV2IIBMTTzUUwaWwLo5sD9jQdAcitrBnSJo4h101GQpXbNMyYwA+rnuXyFPVMc2jeL
         xMnCTpldluKCOE5Wplbkyky5t1Rm0K12cZUvsQgL0pUhiOvYdw2SvvzBMgm7xXSbyHGu
         XwGTxij5YikrfxMI6lMJNzz+0rcD3uzIiI8UqxO1+n8TgCMG7RyupeLeeZCnYT5zm6wj
         KjUOtzdKJd18oBZVvIeFaFe54yfZAi1zwvKAFB9C+7oL3N7c+hvUqBr0YZ3NkrIreJ6M
         +cMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nOJuhLui4k7rvz/wos+0nsCIYbwj7zan4woC4Ksv4tU=;
        b=Z9jdDmXQej0ZREVoopNNgCxWwkSMprOiiFZouICkDbA77hH05L/BpEklKUBTCY3q8h
         tnIFU/hio3AL8wAlN60uqpRHv65BggDaNUpT1jjabmARtDIJF6iWd74Krew9mfLDAeUn
         S3OcU3l9OMthxQGwv21Gspd1o/8HeCrw1r7rIHqCklW6UTLydXK7QuRTtEnLbpAEYi5u
         O+Ye+na1XaTdYd2H2xmuzfem/0Lp+PhwkOEc5D0gTONqcqxTx/L4X3LoeIIEQ9jrOVKw
         ExJ9QhQDAPvqdHbC4egBQzxGEaJB28KfP+bwF3nsNJLoZ0ZpByiseYZfdEzNrinJ1g12
         7fMg==
X-Gm-Message-State: AOAM532dONyKQUJtk2wda8JxWBneBAVB3Ep0qPMk2FtSHYNNO9QpqZxm
        UAAivsdmyo5arf0a2u3lqP4=
X-Google-Smtp-Source: ABdhPJw0P1ye0j2Opb2/IQN8p1LCLJGojSk4DSVYAKSXBrIS17h5vBynZuXvCPJffCyh7ajJeAgK/g==
X-Received: by 2002:a17:90b:f09:: with SMTP id br9mr11691708pjb.11.1597654472576;
        Mon, 17 Aug 2020 01:54:32 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id x12sm18236990pff.48.2020.08.17.01.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:54:32 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Cc:     keescook@chromium.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 1/8] scsi: aic94xx: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:24:02 +0530
Message-Id: <20200817085409.25268-2-allen.cryptic@gmail.com>
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
 drivers/scsi/aic94xx/aic94xx_hwi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 9256ab7b2522..1e4d32246cb9 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -248,7 +248,7 @@ static void asd_get_max_scb_ddb(struct asd_ha_struct *asd_ha)
 
 /* ---------- Done List initialization ---------- */
 
-static void asd_dl_tasklet_handler(unsigned long);
+static void asd_dl_tasklet_handler(struct tasklet_struct *t);
 
 static int asd_init_dl(struct asd_ha_struct *asd_ha)
 {
@@ -261,8 +261,7 @@ static int asd_init_dl(struct asd_ha_struct *asd_ha)
 	asd_ha->seq.dl = asd_ha->seq.actual_dl->vaddr;
 	asd_ha->seq.dl_toggle = ASD_DEF_DL_TOGGLE;
 	asd_ha->seq.dl_next = 0;
-	tasklet_init(&asd_ha->seq.dl_tasklet, asd_dl_tasklet_handler,
-		     (unsigned long) asd_ha);
+	tasklet_setup(&asd_ha->seq.dl_tasklet, asd_dl_tasklet_handler);
 
 	return 0;
 }
@@ -711,9 +710,9 @@ static void asd_chip_reset(struct asd_ha_struct *asd_ha)
 
 /* ---------- Done List Routines ---------- */
 
-static void asd_dl_tasklet_handler(unsigned long data)
+static void asd_dl_tasklet_handler(struct tasklet_struct *t)
 {
-	struct asd_ha_struct *asd_ha = (struct asd_ha_struct *) data;
+	struct asd_ha_struct *asd_ha = from_tasklet(asd_ha, t, seq.dl_tasklet);
 	struct asd_seq_data *seq = &asd_ha->seq;
 	unsigned long flags;
 
-- 
2.17.1

