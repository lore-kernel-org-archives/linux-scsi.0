Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E3BC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0B25207BB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BmkVY0fv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgGUQm6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730807AbgGUQmy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:54 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46294C0619DB
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:54 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 22so3481837wmg.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eqUDrvqp47gD9IcVnzMp1ejaV+Kp3xiawYLE5j2QDM4=;
        b=BmkVY0fv9v0/nDQ2O9/Z4PhE/KjvOh31PPQoFLXaiJK9CJzVEos9o1gVkAvQsqUSPA
         QwVzEpu+r0bTUmxG515TI9eXFGA95IiPDbxD4g7+zLSsllv0eLWaPv1Wnfol0yyI5pRM
         E9Bvd0a9sMISnVs2KSG4V0PJGZenB0N8C23+jHJo4WP2ztN+63/j9E4eVhRt7ntdUYzS
         PuK+5V5F92vBYRk9GvroDMvQBTI+0OgwP8DRoNEeiEjDCDir0q/06G2XmI9oo8nebPf4
         n6TZj/yLggcoyLyucMOhGACv+IAYw316esHeRq+4xVtiPqUy3SJXU8UuwjMmMNuo+vOr
         Ny7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eqUDrvqp47gD9IcVnzMp1ejaV+Kp3xiawYLE5j2QDM4=;
        b=iYitKYHbOXJH8ajtxCz2o1NxESQjAeII9EzW84HhT4e5Z6yeFlJZ5EbWdkXWxjfVXH
         CTtBUqzSzvR/U+i6Ddr3SxJCZmE7MpqWpUZ/E48ui8OomW8y91y0nrWbkTwViSbB6bbx
         Uv4lWbsSRKl0forPkz8mr1HXxFmEndF+z6JT/KpJSzh9DOLV11X3JE1ilOaRM4p/3i91
         d0edx3JicxxkX2IGm5dgEhsMDLPhPMdN5gKeUF4R43h7o/YzXHl5GOHL6Bjm4YON4JV8
         3S+7srtm/zhQQoEc8bVnBd0MLzMwhYnDS5NFu7OW7YME92nJ++iGeHpPMR8eTx4T0OFG
         iSmw==
X-Gm-Message-State: AOAM530Oy3bm2fxzBf5HQbaWxdAmfnR+Jsvu8Rk4ppjPvVGny5oO1nIx
        +GpFXtWBUwgdwPIdJ65Gc6bFOw==
X-Google-Smtp-Source: ABdhPJx0B8Wdrsoo7SAmS8qt/qKe11hLMQ1sM9yMXdqkvY9Eyz/wo+eMOYd+Tcxm7w7qCPq6Tf5NBw==
X-Received: by 2002:a7b:c116:: with SMTP id w22mr4584794wmi.97.1595349773040;
        Tue, 21 Jul 2020 09:42:53 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:52 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Karen Xie <kxie@chelsio.com>,
        Dimitris Michailidis <dm@chelsio.com>
Subject: [PATCH 40/40] scsi: cxgbi: cxgb3i: cxgb3i: Remove bad documentation and demote kerneldoc header
Date:   Tue, 21 Jul 2020 17:41:48 +0100
Message-Id: <20200721164148.2617584-41-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Also move the header block above the correct function.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c:390: warning: Function parameter or member 'dev' not described in 'arp_failure_skb_discard'
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c:390: warning: Function parameter or member 'skb' not described in 'arp_failure_skb_discard'
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c:390: warning: Excess function parameter 'c3cn' description in 'arp_failure_skb_discard'
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c:390: warning: Excess function parameter 'req_completion' description in 'arp_failure_skb_discard'
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c:895: warning: Function parameter or member 'csk' not described in 'l2t_put'
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c:895: warning: Excess function parameter 'c3cn' description in 'l2t_put'

Cc: Karen Xie <kxie@chelsio.com>
Cc: Dimitris Michailidis <dm@chelsio.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index f2714c54a5196..2b48954b6b1ef 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -375,10 +375,8 @@ static inline void make_tx_data_wr(struct cxgbi_sock *csk, struct sk_buff *skb,
 	}
 }
 
-/**
+/*
  * push_tx_frames -- start transmit
- * @c3cn: the offloaded connection
- * @req_completion: request wr_ack or not
  *
  * Prepends TX_DATA_WR or CPL_CLOSE_CON_REQ headers to buffers waiting in a
  * connection's send queue and sends them on to T3.  Must be called with the
@@ -886,11 +884,6 @@ static int alloc_cpls(struct cxgbi_sock *csk)
 	return -ENOMEM;
 }
 
-/**
- * release_offload_resources - release offload resource
- * @c3cn: the offloaded iscsi tcp connection.
- * Release resources held by an offload connection (TID, L2T entry, etc.)
- */
 static void l2t_put(struct cxgbi_sock *csk)
 {
 	struct t3cdev *t3dev = (struct t3cdev *)csk->cdev->lldev;
@@ -902,6 +895,10 @@ static void l2t_put(struct cxgbi_sock *csk)
 	}
 }
 
+/*
+ * release_offload_resources - release offload resource
+ * Release resources held by an offload connection (TID, L2T entry, etc.)
+ */
 static void release_offload_resources(struct cxgbi_sock *csk)
 {
 	struct t3cdev *t3dev = (struct t3cdev *)csk->cdev->lldev;
-- 
2.25.1

