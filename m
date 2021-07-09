Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D59AC07E9C
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 867BE613CA
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhGIU3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:29:36 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:43621 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhGIU3f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:29:35 -0400
Received: by mail-pj1-f44.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso6723287pjp.2
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1DtGlfo68SFtzRKcdMwNBvWjsRGvEXgsFbZoOOszlFQ=;
        b=eaWQyu3X53BXKUbiFlVqh0hettdt9dtA4uItxcPyGJqRiTVy3+irlzrcoZ1fpHDjes
         qQ82cKJkF32WkiWE0HInEklz8P1ffv0VghXU9t5VBjzkBDE89m5jp5380szbFNjst88F
         wCD+p7uNkx61+MdH516qSZgHfLz5MkpcKcm2hqZMnbmjFWQ9gg13C3gSxhAoS143+0CY
         61d+b1cv9X3opR21d/U7lF8wfJMto+eWpc08zlbp3H0d27uE/iyj6d8hq0JZXOCiCEhJ
         zmCMzJMLNufpmzO+4yF0mrTWW4L0sInSsHTY/MfUSJXEox42sJbjeEb28u/TxgEi8aql
         /fig==
X-Gm-Message-State: AOAM530MaNVQcI8l9NFo7mLr1Skiwsr74YGTte0AzF6/VIoI6tNF9tsf
        BoHk0xomHgsgMmd81iGnpCo=
X-Google-Smtp-Source: ABdhPJyG1igKpzebMICABML9ZtuCBGOihk/fzN203zU4C14su9OF91zXmKv28ePUEhHM4XENygnFOA==
X-Received: by 2002:a17:90a:4490:: with SMTP id t16mr656740pjg.183.1625862410937;
        Fri, 09 Jul 2021 13:26:50 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:26:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 01/19] scsi: Fix the documentation of the scsi_execute() time parameter
Date:   Fri,  9 Jul 2021 13:26:20 -0700
Message-Id: <20210709202638.9480-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The unit of the scsi_execute() timeout parameter is 1/HZ seconds instead of
one second, just like the timeouts used in the block layer. Fix the
documentation header above the definition of the scsi_execute() macro.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Fixes: "[SCSI] use scatter lists for all block pc requests and simplify hw handlers" # v2.6.16.28
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7184f93dfe15..4b56e06faa5e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -194,7 +194,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  * @bufflen:	len of buffer
  * @sense:	optional sense buffer
  * @sshdr:	optional decoded sense header
- * @timeout:	request timeout in seconds
+ * @timeout:	request timeout in HZ
  * @retries:	number of times to retry request
  * @flags:	flags for ->cmd_flags
  * @rq_flags:	flags for ->rq_flags
