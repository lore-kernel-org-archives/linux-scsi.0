Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EA6C43381
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 16:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADCA12310E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 16:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgLUQXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 11:23:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbgLUQXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Dec 2020 11:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608567741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JsaAJBHqubdRAQb5CKtk/rEujCkt80qc4CgCqukMEgs=;
        b=TAHtnyVSODeSSMbHGDLGcpyMAx6KR4vvFz4wWIQmCSL4C9brYdybCZO5ejNhTMmsvw7NYA
        u+976eZzwQu76lrKd1M5CPu7LekLpSXJk+5Jv1LsmdbbeLinkmkrX/AkfeAWeHFwxfCiyA
        Ch+VAU8gpwtXhy2vT4pz8lOpDqO3htU=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-V-8qLPLzNauJdVdAOWpRgg-1; Mon, 21 Dec 2020 11:22:20 -0500
X-MC-Unique: V-8qLPLzNauJdVdAOWpRgg-1
Received: by mail-ot1-f69.google.com with SMTP id d10so2264893ote.22
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 08:22:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JsaAJBHqubdRAQb5CKtk/rEujCkt80qc4CgCqukMEgs=;
        b=Pea6+lzjHKci9TDy2uTzjwW8K1/AjabkBt26lARa5dzQlKlyYg7WsyQVkFdQ1MMkLV
         x+RbX8SB3T0BO4UU39mQE+SigwhB9t0M8O7bpjzuJ2XbzwpUwRn6xfSHUOgNuNgKxz5j
         eHro3iMgQQguIHEsorV2uPBvmy3Pp2GDMJEcvKmVgPwtMBPaeIZfz89lvSrFotrLMrDJ
         bgtppUG+jjX3ARB5mf8Im6d+l+BJ0Rw1agIKjKDLYufDd/zhWlmLE+GYJLRRiCCuaBDB
         LpVpg+HX2js15O+8qxTS2VUHCsOodqCSdp43VB0uhoTQEfV9eZvjBAhLB92Hcgs3SqXz
         BqIA==
X-Gm-Message-State: AOAM533OH7VBUm+JkC2S1OSg8vfWUuBa3gmw2QxwGvnneviHVf8zUAxM
        uXT1TEoWWluwHUAK7wW61VIlkbLSjTAKlGhAzJaU++sW8elGPkJSjRdcf9rVFvmJZEmAgqiwecM
        NUU8j8sLwSEqoXjL4HaAnIQ==
X-Received: by 2002:a05:6830:1bc6:: with SMTP id v6mr12472041ota.33.1608567738898;
        Mon, 21 Dec 2020 08:22:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwScQjxH+sKjnbs2a3cOOUeqJmfpCfnYSsPY+fJ/WnUiSpKosz8iLroTPNMtoECzxMSpw7s7A==
X-Received: by 2002:a05:6830:1bc6:: with SMTP id v6mr12472030ota.33.1608567738740;
        Mon, 21 Dec 2020 08:22:18 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id 8sm4000851otq.18.2020.12.21.08.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 08:22:18 -0800 (PST)
From:   trix@redhat.com
To:     khalid@gonehiking.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] [SCSI] BusLogic: add printf attribute to log function
Date:   Mon, 21 Dec 2020 08:22:12 -0800
Message-Id: <20201221162212.3755805-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Attributing the function allows the compiler to more thoroughly
check the use of the function with -Wformat and similar flags.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/BusLogic.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 6182cc8a0344..b701fc8ba789 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1289,6 +1289,7 @@ static int blogic_slaveconfig(struct scsi_device *);
 static void blogic_qcompleted_ccb(struct blogic_ccb *);
 static irqreturn_t blogic_inthandler(int, void *);
 static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset);
+__printf(2, 4)
 static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapter *, ...);
 static int __init blogic_setup(char *);
 
-- 
2.27.0

