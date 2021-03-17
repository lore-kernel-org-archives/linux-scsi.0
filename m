Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A0BC4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06B5A64F72
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhCQJNn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhCQJNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:05 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E261C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:05 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x16so1010298wrn.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MQ2nUtCGw1bWUZ6dO/5J8SDUuDM4eCtKGGa2VlanAmM=;
        b=d2Ja2o6tgRGuZu/1gD3cCuRyuA6S6GgUOdhpFLU7iMpXFvkyR0pN3bcibvKm5/vjJT
         YZgukf4UNqYRhDxIpmHDYNPSp07nFKO58rgOk6dR2BMf8HESOZ+DSdkz866QBjDNtzKL
         gC7yavFODON/KcwZduZibWrosEZTVcu1tRBMngCMsXt+55z9TnN5Wp103xRnXcEF0fDf
         RoyiXMRtKLQ8K9sTSsp+qF/HpqpsnjRQ+1wFHZmUXBMKBpLPj2K0gb/rudm9/Ro6PdA1
         yWw9jfy5qs/HQa5xNrMLNReG0nUDtCcRvke6d/OZYJZfhv2Mel8Kawnyeh1QBdkZAHs6
         0vMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MQ2nUtCGw1bWUZ6dO/5J8SDUuDM4eCtKGGa2VlanAmM=;
        b=kPS7eTw1PnfWhxArlJTYvAhKy6y0PF38lkkTu3QA720JXJGmHgeUf2TXywb7wR2YP2
         gmV70/eewcD1QNavvbLKAUu4YSQH1AnRNeEIuxsuMUCSl0h5mZJ9j3z2oIIq+Aj1MEzm
         OADrfcbXO75jI4H62qjLSdp73srwJXvJERgxNugFBXfw/hrS86tDYlP9hLkFkeRz/9Ar
         YeSwUxp2FtMH+q2bXaxSKKUVVjlUaCkzFB1XZ6c3rpt+S6wc7JHDKWP4Y1cJSC3hAHAF
         0McIAXR8kaj3g3/XJUv3fQgmP/qRGi2Nz5M5sr2ybUu71DYA0QTeZ9iaxbzCzjnhNS3i
         xjUw==
X-Gm-Message-State: AOAM530qE5BO/6clKijpd3j0D7djq88XguL8rzBFmmjrXzM091sdMy8Y
        aq5cc0KxPq5H/HtllXd98uujXA==
X-Google-Smtp-Source: ABdhPJzR8BmRIRcZ128t7v/YyGXxw48N5CaIKvpt5OSTSELrl5gNmzdel2YmItSBmal7vekMwK6VJg==
X-Received: by 2002:adf:fac1:: with SMTP id a1mr3451873wrs.98.1615972383807;
        Wed, 17 Mar 2021 02:13:03 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 23/36] scsi: isci: remote_node_table: Fix a bunch of kernel-doc misdemeanours
Date:   Wed, 17 Mar 2021 09:12:17 +0000
Message-Id: <20210317091230.2912389-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/remote_node_table.c:66: warning: Incorrect use of kernel-doc format:  *
 drivers/scsi/isci/remote_node_table.c:80: warning: Function parameter or member 'remote_node_table' not described in 'sci_remote_node_table_get_group_index'
 drivers/scsi/isci/remote_node_table.c:80: warning: Function parameter or member 'group_table_index' not described in 'sci_remote_node_table_get_group_index'
 drivers/scsi/isci/remote_node_table.c:80: warning: expecting prototype for This file contains the implementation of the SCIC_SDS_REMOTE_NODE_TABLE(). Prototype was for sci_remote_node_table_get_group_index() instead
 drivers/scsi/isci/remote_node_table.c:101: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:131: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:161: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:194: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:227: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:256: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:283: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:310: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:368: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:428: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:465: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:508: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:553: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_table.c:576: warning: Cannot understand  *

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/remote_node_table.c | 51 +++++++++++++--------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/isci/remote_node_table.c b/drivers/scsi/isci/remote_node_table.c
index 301b3141945ec..1036ab936626e 100644
--- a/drivers/scsi/isci/remote_node_table.c
+++ b/drivers/scsi/isci/remote_node_table.c
@@ -53,17 +53,15 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-/**
+/*
  * This file contains the implementation of the SCIC_SDS_REMOTE_NODE_TABLE
  *    public, protected, and private methods.
- *
- *
  */
 #include "remote_node_table.h"
 #include "remote_node_context.h"
 
 /**
- *
+ * sci_remote_node_table_get_group_index()
  * @remote_node_table: This is the remote node index table from which the
  *    selection will be made.
  * @group_table_index: This is the index to the group table from which to
@@ -98,8 +96,8 @@ static u32 sci_remote_node_table_get_group_index(
 }
 
 /**
- *
- * @out]: remote_node_table This the remote node table in which to clear the
+ * sci_remote_node_table_clear_group_index()
+ * @remote_node_table: This the remote node table in which to clear the
  *    selector.
  * @set_index: This is the remote node selector in which the change will be
  *    made.
@@ -128,8 +126,8 @@ static void sci_remote_node_table_clear_group_index(
 }
 
 /**
- *
- * @out]: remote_node_table This the remote node table in which to set the
+ * sci_remote_node_table_set_group_index()
+ * @remote_node_table: This the remote node table in which to set the
  *    selector.
  * @group_table_index: This is the remote node selector in which the change
  *    will be made.
@@ -158,8 +156,8 @@ static void sci_remote_node_table_set_group_index(
 }
 
 /**
- *
- * @out]: remote_node_table This is the remote node table in which to modify
+ * sci_remote_node_table_set_node_index()
+ * @remote_node_table: This is the remote node table in which to modify
  *    the remote node availability.
  * @remote_node_index: This is the remote node index that is being returned to
  *    the table.
@@ -191,8 +189,8 @@ static void sci_remote_node_table_set_node_index(
 }
 
 /**
- *
- * @out]: remote_node_table This is the remote node table from which to clear
+ * sci_remote_node_table_clear_node_index()
+ * @remote_node_table: This is the remote node table from which to clear
  *    the available remote node bit.
  * @remote_node_index: This is the remote node index which is to be cleared
  *    from the table.
@@ -224,8 +222,8 @@ static void sci_remote_node_table_clear_node_index(
 }
 
 /**
- *
- * @out]: remote_node_table The remote node table from which the slot will be
+ * sci_remote_node_table_clear_group()
+ * @remote_node_table: The remote node table from which the slot will be
  *    cleared.
  * @group_index: The index for the slot that is to be cleared.
  *
@@ -253,7 +251,7 @@ static void sci_remote_node_table_clear_group(
 }
 
 /**
- *
+ * sci_remote_node_table_set_group()
  * @remote_node_table:
  *
  * THis method sets an entire remote node group in the remote node table.
@@ -280,7 +278,7 @@ static void sci_remote_node_table_set_group(
 }
 
 /**
- *
+ * sci_remote_node_table_get_group_value()
  * @remote_node_table: This is the remote node table that for which the group
  *    value is to be returned.
  * @group_index: This is the group index to use to find the group value.
@@ -307,8 +305,8 @@ static u8 sci_remote_node_table_get_group_value(
 }
 
 /**
- *
- * @out]: remote_node_table The remote that which is to be initialized.
+ * sci_remote_node_table_initialize()
+ * @remote_node_table: The remote that which is to be initialized.
  * @remote_node_entries: The number of entries to put in the table.
  *
  * This method will initialize the remote node table for use. none
@@ -365,8 +363,8 @@ void sci_remote_node_table_initialize(
 }
 
 /**
- *
- * @out]: remote_node_table The remote node table from which to allocate a
+ * sci_remote_node_table_allocate_single_remote_node()
+ * @remote_node_table: The remote node table from which to allocate a
  *    remote node.
  * @table_index: The group index that is to be used for the search.
  *
@@ -425,7 +423,7 @@ static u16 sci_remote_node_table_allocate_single_remote_node(
 }
 
 /**
- *
+ * sci_remote_node_table_allocate_triple_remote_node()
  * @remote_node_table: This is the remote node table from which to allocate the
  *    remote node entries.
  * @group_table_index: THis is the group table index which must equal two (2)
@@ -462,7 +460,7 @@ static u16 sci_remote_node_table_allocate_triple_remote_node(
 }
 
 /**
- *
+ * sci_remote_node_table_allocate_remote_node()
  * @remote_node_table: This is the remote node table from which the remote node
  *    allocation is to take place.
  * @remote_node_count: This is ther remote node count which is one of
@@ -505,8 +503,9 @@ u16 sci_remote_node_table_allocate_remote_node(
 }
 
 /**
- *
- * @remote_node_table:
+ * sci_remote_node_table_release_single_remote_node()
+ * @remote_node_table: This is the remote node table from which the remote node
+ *    release is to take place.
  *
  * This method will free a single remote node index back to the remote node
  * table.  This routine will update the remote node groups
@@ -550,7 +549,7 @@ static void sci_remote_node_table_release_single_remote_node(
 }
 
 /**
- *
+ * sci_remote_node_table_release_triple_remote_node()
  * @remote_node_table: This is the remote node table to which the remote node
  *    index is to be freed.
  *
@@ -573,7 +572,7 @@ static void sci_remote_node_table_release_triple_remote_node(
 }
 
 /**
- *
+ * sci_remote_node_table_release_remote_node_index()
  * @remote_node_table: The remote node table to which the remote node index is
  *    to be freed.
  * @remote_node_count: This is the count of consecutive remote nodes that are
-- 
2.27.0

