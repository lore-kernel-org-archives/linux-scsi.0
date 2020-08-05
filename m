Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2E5C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FAC82075A
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Q6dck2lX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgHEJpk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 05:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgHEJpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 05:45:17 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3099C061757
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 02:45:16 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p1so24940419pls.4
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2020 02:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BX+qEUXJP3Gj5JCJCCKYSqHBd/iu1VMbpZI+qGsbNeg=;
        b=Q6dck2lXg83kERKGtkvDYtYOO9kv77oIxHdGHK5RnJU+0tT0f0FJa1q9b6G6W1S2hE
         mJvzYeIKWoVcHwZEG7tgxquw4SmnhVIJFyowkSL1JTznV6gLHbBiIR1aF2vO8jdoCYvn
         ikhf9srKFtL6LbKAKI+zBKosaE2RdJD/eK0gU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BX+qEUXJP3Gj5JCJCCKYSqHBd/iu1VMbpZI+qGsbNeg=;
        b=aglsAV+FVFK8Y72yHuiqPYg4ofLTYE/Lyl2JQ6pElHhqvSJ9YjQvZLzppAmfNMVR1z
         prhlNnRh+Mw6Cc4VCg2Xjr/Rqshv7oPOfHMkbfUZgsufspN5y6j2YhfCEHVzf5kH6ut2
         MkxBAARKIcG82KTu4KpcH0KRVKqZ/+SGuEw6Sfhiq2VdZOV8NJeZRVn7zx9Zj/eMikmn
         dN6Fr6zW5y4RLUCz/+VqlPZmYtuM9Sjp34SnlxsxLd7c6lJ8AwQW6CJiNEwsw3eHr09Z
         saphjdB5uJMkBDnFus7Uq/6pR/13MxbuNMOGfucmjdB1lxxyjYeQYGgoU25svGjpPJ4f
         s0Jg==
X-Gm-Message-State: AOAM533BUk3iPtspm9L+PBMOPg86XxwoqJTHie0w8uem5ehHs7MMETSI
        re6KgeNdW5/fmazVpiWVoZ+64mxEPI9a19cCv/orcCaLCqWfJTCThPZIqBiIsRIpd/I4mty1Nl4
        CFj1IyTHOkJ3mR1CYNuMb/tsBtmE8sG9cKLjN4X+3AzM3lAop+cxIEpQ0M2EDHIvPHbuJOYMrYr
        O+KT03+A==
X-Google-Smtp-Source: ABdhPJy1YYB/NanEAFnu/oludmnmc8za/DQS+H6Hm8wea9AUctKGszhukbl5Ojb+DvZUYnkINeQS6g==
X-Received: by 2002:a17:90b:3907:: with SMTP id ob7mr2507314pjb.124.1596620715718;
        Wed, 05 Aug 2020 02:45:15 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id e9sm2632346pfh.151.2020.08.05.02.45.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 02:45:15 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hare@suse.de, jsmart2021@gmail.com, emilne@redhat.com,
        mkumar@redhat.com, Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH 1/5] scsi: Added a new macro in scsi_cmnd.h
Date:   Wed,  5 Aug 2020 08:20:58 +0530
Message-Id: <1596595862-11075-2-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added a new macro SCMD_NORETRIES_ABORT in scsi_cmnd.h

The SCMD_NORETRIES_ABORT macro  defines the third bit postion
in scmd->state

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 include/scsi/scsi_cmnd.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index e76bac4..e1883fe 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -64,6 +64,9 @@ struct scsi_pointer {
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
 #define SCMD_STATE_INFLIGHT	1
+#define SCMD_NORETRIES_ABORT	2 /* If this bit is set then there won't be any
+				   * retries of scmd on abort success
+				   */
 
 struct scsi_cmnd {
 	struct scsi_request req;
-- 
1.8.3.1

