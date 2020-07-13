Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252ABC43445
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A362072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uKjnZBDe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgGMHqv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbgGMHqu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:46:50 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3884FC061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so12176471wmh.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OYcU6QrkQ8vEFK16KZ0JwglvYSsa1RsL+nSDllm7Llo=;
        b=uKjnZBDeRyG1EknaFH0tWOPAPon6eULfa3m5fG1bU65epw0uIKT1OznCzv4UwRgUqZ
         S0C2ZTHAALw5KBHRlcQ6tQ4tIoZ5JR6aWHfn2UGJ925S8pXbmooOT1SrFsCJi7DTVOq/
         jBuic+m7tzQpyDe3+0X4jCTcOAB5l9KSZ8BC1bEyt4ztVxYtX3GLy6et1SEr4P+q2wLV
         5uz/DGRedkh1YS9IVBL/NOlcE9c4+tWnxSMHfTgfB+Iy8kXmj0gfQkUi3a1sZUUh1rvu
         KsDAf8i6JIbuWr049BRZQWS9WQYgQ8p1k6rz5M/rCYHVxEPAi7WSm9twDYhA/J028FnR
         XqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OYcU6QrkQ8vEFK16KZ0JwglvYSsa1RsL+nSDllm7Llo=;
        b=Kh7yKrFXqOxkQm9outbL4WkMhXP/41vXr1dWqGMyPMnV+7NFazDmN8WW2El4jAgZN9
         swH+hSpCA8rpbZM0ml16m+vWaRvCnjHxR1h3RZtyAF5ZKJk6Ann9Xn60pN2ZBuGNHw9Q
         UUmHvFxU2iq7q/M1pgfcW28qRmuoH2AUtl8Sw9nnnAiFlEARKnTqkk1rBkaWn2f8pL8V
         f8hoJXu4QB0nE+LbnF06Yoyy8hF2MYLrj2TCJRjF0sHXl0toZOelObcNTA7BqxVByOQT
         B/UDBO74SFbVgvkJb3gy8b3uINx0ODCuqaLUr9e7islz9KLvgs/ZfmwPMOYzvJ9+ey6H
         7udw==
X-Gm-Message-State: AOAM533tLi7udoydu5GHw9XTkBRWqNihn6Du6nbphE3vpSe79C+VASLj
        FeRhv5ynD0ShJQ9YBKfinAjvVbPTlp8=
X-Google-Smtp-Source: ABdhPJzGscVP1ElymIXE2dpq/IRxoRsASHBFkVI7l8pQoqBu7zCJ+lMpQ0+XfXZWaqZru4F1cZgZgg==
X-Received: by 2002:a1c:28a:: with SMTP id 132mr17366357wmc.109.1594626408932;
        Mon, 13 Jul 2020 00:46:48 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:46:48 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 01/29] scsi: libfc: fc_exch: Supply some missing kerneldoc struct/function attributes/params
Date:   Mon, 13 Jul 2020 08:46:17 +0100
Message-Id: <20200713074645.126138-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/libfc/fc_exch.c:66: warning: Function parameter or member 'left' not described in 'fc_exch_pool'
 drivers/scsi/libfc/fc_exch.c:66: warning: Function parameter or member 'right' not described in 'fc_exch_pool'
 drivers/scsi/libfc/fc_exch.c:100: warning: Function parameter or member 'lport' not described in 'fc_exch_mgr'
 drivers/scsi/libfc/fc_exch.c:727: warning: Function parameter or member 'ep' not described in 'fc_invoke_resp'
 drivers/scsi/libfc/fc_exch.c:727: warning: Function parameter or member 'sp' not described in 'fc_invoke_resp'
 drivers/scsi/libfc/fc_exch.c:727: warning: Function parameter or member 'fp' not described in 'fc_invoke_resp'

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/libfc/fc_exch.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 52e8666598531..16eb3b60ed582 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -49,6 +49,8 @@ static struct workqueue_struct *fc_exch_workqueue;
  * @total_exches: Total allocated exchanges
  * @lock:	  Exch pool lock
  * @ex_list:	  List of exchanges
+ * @left:	  Cache of free slot in exch array
+ * @right:	  Cache of free slot in exch array
  *
  * This structure manages per cpu exchanges in array of exchange pointers.
  * This array is allocated followed by struct fc_exch_pool memory for
@@ -60,7 +62,6 @@ struct fc_exch_pool {
 	u16		 next_index;
 	u16		 total_exches;
 
-	/* two cache of free slot in exch array */
 	u16		 left;
 	u16		 right;
 } ____cacheline_aligned_in_smp;
@@ -74,6 +75,7 @@ struct fc_exch_pool {
  * @ep_pool:	    Reserved exchange pointers
  * @pool_max_index: Max exch array index in exch pool
  * @pool:	    Per cpu exch pool
+ * @lport:	    Local exchange port
  * @stats:	    Statistics structure
  *
  * This structure is the center for creating exchanges and sequences.
@@ -702,6 +704,9 @@ int fc_seq_exch_abort(const struct fc_seq *req_sp, unsigned int timer_msec)
 
 /**
  * fc_invoke_resp() - invoke ep->resp()
+ * @ep:	   The exchange to be operated on
+ * @fp:	   The frame pointer to pass through to ->resp()
+ * @sp:	   The sequence pointer to pass through to ->resp()
  *
  * Notes:
  * It is assumed that after initialization finished (this means the
-- 
2.25.1

