Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90086C41620
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A03D64F33
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhCQJNs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhCQJNM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:12 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4D0C06175F
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e18so1004339wrt.6
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=INYaEaBKekTmocE41+zT9bavsNeUW3SsypgM5hto0Go=;
        b=LU0MfM5VANlz8Slj6C6ags2MZIeEQa5EYWniMaJEraXg9Zygc+80pbha8ds8vB2gO5
         Gr46OwwH2LPxxqqTWkZ0gwNP/GKglfNqGEJ2S62m4GFVwEVEucMri5byPMwyaSUC2v0Q
         i/2WUUqltY9W9s92n7HZv28+8vt+I/YTFDFLi5/jzNj9UeKKyzOxSqT1FSTkZdybwjKm
         N1X91jPLwH7sWFacydU7Dwcv0jn9bQiFJa/69stdk3crrCfVbavNOloWACIYctqiVhaf
         jloCALTCkZF5KuMNBgJRwFJtrSrTzgy/6HcNuX4feeovknp6fh3YEsXFm4zTQTsxc4dc
         nekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=INYaEaBKekTmocE41+zT9bavsNeUW3SsypgM5hto0Go=;
        b=XdOIqO1MNrhPeXqvzzTOwuxNHxtkRMnLFIEnFdLdxk5pJ87dAQAHAbHRU4R9Tsju0h
         s5cqoJe5+UnRLMfvnr1dHDKLL5WJReE7TlWEikf2+oEEqFkZtjNrQuDRKIA/0FuaXTor
         Mkp82BFJv1m/WphQdbtAzcS5b/igoEq7fWHIfuoPytCNASEUW1WOimdNmvpBmJ+yBeGI
         +Z7m/BNLullkhXtvKQA6powMEMywC9/FK47fSSNnUSsi7uscATsR+6wQufA4Ao3Ztkbl
         UGq6msl9AN4LW66TA5QTnX9uJTjcKc+uQhLfLyjeD1ttle6I/3RZH2kqdS6cx/bHgjvr
         DBwg==
X-Gm-Message-State: AOAM530xSpJJsZGAe4czUqbHqwliVyVQW2wNOn0zIWqJEJeY69RqVdTd
        7vd1VxjAMksfbsBRsx9vwUSWHg==
X-Google-Smtp-Source: ABdhPJzoU2irxWjqTIRpGWlYPDPXkS9wIYcZMq3Rz/xuBQlkWluHwYVbpFEDm9ZakMHSHGopBeFqDA==
X-Received: by 2002:adf:b30f:: with SMTP id j15mr3361475wrd.132.1615972390441;
        Wed, 17 Mar 2021 02:13:10 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 30/36] scsi: isci: remote_node_table: Provide some missing params and remove others
Date:   Wed, 17 Mar 2021 09:12:24 +0000
Message-Id: <20210317091230.2912389-31-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/remote_node_table.c:113: warning: Function parameter or member 'group_table_index' not described in 'sci_remote_node_table_clear_group_index'
 drivers/scsi/isci/remote_node_table.c:113: warning: Excess function parameter 'set_index' description in 'sci_remote_node_table_clear_group_index'
 drivers/scsi/isci/remote_node_table.c:262: warning: Function parameter or member 'group_index' not described in 'sci_remote_node_table_set_group'
 drivers/scsi/isci/remote_node_table.c:383: warning: Function parameter or member 'group_table_index' not described in 'sci_remote_node_table_allocate_single_remote_node'
 drivers/scsi/isci/remote_node_table.c:383: warning: Excess function parameter 'table_index' description in 'sci_remote_node_table_allocate_single_remote_node'
 drivers/scsi/isci/remote_node_table.c:516: warning: Function parameter or member 'remote_node_index' not described in 'sci_remote_node_table_release_single_remote_node'
 drivers/scsi/isci/remote_node_table.c:562: warning: Function parameter or member 'remote_node_index' not described in 'sci_remote_node_table_release_triple_remote_node'
 drivers/scsi/isci/remote_node_table.c:588: warning: Function parameter or member 'remote_node_index' not described in 'sci_remote_node_table_release_remote_node_index'

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/remote_node_table.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/isci/remote_node_table.c b/drivers/scsi/isci/remote_node_table.c
index 1036ab936626e..1bcaf528c1c99 100644
--- a/drivers/scsi/isci/remote_node_table.c
+++ b/drivers/scsi/isci/remote_node_table.c
@@ -99,7 +99,7 @@ static u32 sci_remote_node_table_get_group_index(
  * sci_remote_node_table_clear_group_index()
  * @remote_node_table: This the remote node table in which to clear the
  *    selector.
- * @set_index: This is the remote node selector in which the change will be
+ * @group_table_index: This is the remote node selector in which the change will be
  *    made.
  * @group_index: This is the bit index in the table to be modified.
  *
@@ -250,9 +250,8 @@ static void sci_remote_node_table_clear_group(
 	remote_node_table->available_remote_nodes[dword_location] = dword_value;
 }
 
-/**
+/*
  * sci_remote_node_table_set_group()
- * @remote_node_table:
  *
  * THis method sets an entire remote node group in the remote node table.
  */
@@ -366,7 +365,7 @@ void sci_remote_node_table_initialize(
  * sci_remote_node_table_allocate_single_remote_node()
  * @remote_node_table: The remote node table from which to allocate a
  *    remote node.
- * @table_index: The group index that is to be used for the search.
+ * @group_table_index: The group index that is to be used for the search.
  *
  * This method will allocate a single RNi from the remote node table.  The
  * table index will determine from which remote node group table to search.
@@ -426,7 +425,7 @@ static u16 sci_remote_node_table_allocate_single_remote_node(
  * sci_remote_node_table_allocate_triple_remote_node()
  * @remote_node_table: This is the remote node table from which to allocate the
  *    remote node entries.
- * @group_table_index: THis is the group table index which must equal two (2)
+ * @group_table_index: This is the group table index which must equal two (2)
  *    for this operation.
  *
  * This method will allocate three consecutive remote node context entries. If
@@ -506,7 +505,7 @@ u16 sci_remote_node_table_allocate_remote_node(
  * sci_remote_node_table_release_single_remote_node()
  * @remote_node_table: This is the remote node table from which the remote node
  *    release is to take place.
- *
+ * @remote_node_index: This is the remote node index that is being released.
  * This method will free a single remote node index back to the remote node
  * table.  This routine will update the remote node groups
  */
@@ -552,6 +551,7 @@ static void sci_remote_node_table_release_single_remote_node(
  * sci_remote_node_table_release_triple_remote_node()
  * @remote_node_table: This is the remote node table to which the remote node
  *    index is to be freed.
+ * @remote_node_index: This is the remote node index that is being released.
  *
  * This method will release a group of three consecutive remote nodes back to
  * the free remote nodes.
@@ -577,6 +577,7 @@ static void sci_remote_node_table_release_triple_remote_node(
  *    to be freed.
  * @remote_node_count: This is the count of consecutive remote nodes that are
  *    to be freed.
+ * @remote_node_index: This is the remote node index that is being released.
  *
  * This method will release the remote node index back into the remote node
  * table free pool.
-- 
2.27.0

