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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CD2C48BE8
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 23:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7030761358
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 23:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhFRXcZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 19:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhFRXcZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 19:32:25 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48186C061574
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 16:30:14 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f10so3361732plg.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 16:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j6MTIe2qwUVBjmzmH2LBNdGnSBRZGfX2pPBBTeWlkSQ=;
        b=UfMpSQKTxLRK2gSsukxoha/rQy94JNbR7NnZokTC3bI26gLM4Ko1k+Urncq4UeKtMc
         byxaK8zDL+xVZ7YVLpOXDM0JfeRkBRYneCSYtHCga5ObmMbx9eavLETjSpK1u+sS9STI
         ls7Tz8+kW4hm7THnPi3m8dDta+9ImxO74jAnkl7+YY0eLo56KC+TuLJokWurqmm/cqMn
         Z7Xuv3m+fo44GL9qehjr7M6yp9lTpFl+tU0ZHtQz3worhsLfH4jH3AxVmWhf2OVqGHzs
         +cq8Ik70TyGNKXXnJ2tDbt2UkJ2IeT7AKUtjK665fAFEaHVM59cRPNCj09DxjZ25BcS2
         dd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j6MTIe2qwUVBjmzmH2LBNdGnSBRZGfX2pPBBTeWlkSQ=;
        b=szi2Lmpukql1EEqjyJto+09uTEXHystNOmfULiwOz3I6WStp33zeqrcH2xSDLYNCOl
         XAsNiW/x23uNDyU1jaI6o+Rh7ekCZfFvijV3SLo8v2rH5kSYaxfjMG6HmufJVwB+uwPx
         fHO8s5cB3fPP7pKKngEWJX61LmTcNdpVhzQPNRP+VGcPg1gm8PmkT2l+OPNNVs/KpiaB
         ifUE7lI/d2x8h9nT705c5fwZinOSAxyaEP8EHuO+WnbrFZ7d/ir5uGRGwAzzrXU651mL
         EKtczEBW9Lalt/7uR5aniJrTQkU+ODwl63S3bug0P4PPmUPalPk5g843Lal90xCxhnkX
         J2CA==
X-Gm-Message-State: AOAM530Piqa/ZrAFn5l51OzLsLxzp9Aiiqyfqot+tTyIiZm7xjR2rpV1
        Y4s6WEz3CV1hDyGGPePm5uH8Ril703c=
X-Google-Smtp-Source: ABdhPJwcrtaWtVzpANw12m6sRteTmIgky9uN34B2/4ZDeoJMe5pkrk72p5LGapDkwnqzWBORS3luAQ==
X-Received: by 2002:a17:902:b487:b029:115:9655:b6c with SMTP id y7-20020a170902b487b029011596550b6cmr6833775plr.40.1624059013402;
        Fri, 18 Jun 2021 16:30:13 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p20sm10067858pgi.94.2021.06.18.16.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 16:30:13 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     ram.vegesna@broadcom.com, dan.carpenter@oracle.com,
        James Smart <jsmart2021@gmail.com>
Subject: [PATCH] elx: efct: fix pointer error checking in debugfs init
Date:   Fri, 18 Jun 2021 16:30:04 -0700
Message-Id: <20210618233004.83769-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

debugfs_create_xxx routines, which return pointers, are being checked
for error by looking for NULL values. The routines may return
pointer-munged -Exxx codes, so they should be using IS_ERR() to adapt.

There are two cases:
- the first case is on initial directory creation, which actually
  doesn't need to be checked. So remove the check.
- creation of the sessions subdirectory. Modify this creation to
  create under the initial directory created, and fix failure check.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_xport.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index 78b6a47599c3..9495cedcc0b9 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -43,16 +43,13 @@ efct_xport_init_debugfs(struct efct *efct)
 	if (!efct_debugfs_root) {
 		efct_debugfs_root = debugfs_create_dir("efct", NULL);
 		atomic_set(&efct_debugfs_count, 0);
-		if (!efct_debugfs_root) {
-			efc_log_err(efct, "failed to create debugfs entry\n");
-			goto debugfs_fail;
-		}
 	}
 
 	/* Create a directory for sessions in root */
 	if (!efct->sess_debugfs_dir) {
-		efct->sess_debugfs_dir = debugfs_create_dir("sessions", NULL);
-		if (!efct->sess_debugfs_dir) {
+		efct->sess_debugfs_dir = debugfs_create_dir("sessions",
+							efct_debugfs_root);
+		if (IS_ERR(efct->sess_debugfs_dir)) {
 			efc_log_err(efct,
 				    "failed to create debugfs entry for sessions\n");
 			goto debugfs_fail;
-- 
2.26.2

