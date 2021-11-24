Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348F6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhKXAzi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:38 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:45039 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhKXAzh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:37 -0500
Received: by mail-pf1-f182.google.com with SMTP id b68so913055pfg.11
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2eowHEMEaomOtvfvRCh+rFzyDDZg9uyicwuaqpBFZK8=;
        b=02E2lZWvlnzFUHrOhJNp8x/6ovBM51GTahzRVFgm6dXZRybI6vnpn6UrFIfgJbMvZU
         RsvttS+gcbWxor+RIqhgK7nL131H7tWMWhGhXFvpv6/63OAbgydnJMzO6JC67a6vAFhe
         U8pfO+lJ+aZyXiwbts3gFdZze9M2arXCZiXjMUEM8i0l/voOaVS1w+C8zb1mVenFAEp/
         JbtNa3hRb9Tzic9MlfPyeAGx27Q5we9lZkuTVN7oSNrnt2qd4HOfi2u3RwfYw7DMqzzO
         n7608tVLQUEAG6aSOZAt5yBL5zaTsKS2eTsiDF3l6ZbHYIfHhIBUE4lzky/nBxFej3jQ
         qL/Q==
X-Gm-Message-State: AOAM530VzccsLzXZZgy7PY3RaoY5sKQR3s0dcHOT5haj33pOwcK5bqSg
        azBbKQi5m1DxbP7JfTqnf8M=
X-Google-Smtp-Source: ABdhPJz9FG+NOpW61LczZhUzQk8idPw4tWJxCJ3IRRu8j2RlF25WGDPCJrnfF7CWU56lQGQJ3nMEtw==
X-Received: by 2002:a63:f110:: with SMTP id f16mr6960554pgi.136.1637715148885;
        Tue, 23 Nov 2021 16:52:28 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:28 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 03/13] scsi: core: Show SCMD_LAST in text form
Date:   Tue, 23 Nov 2021 16:52:07 -0800
Message-Id: <20211124005217.2300458-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI debugfs code supports showing information about pending
commands, including translating SCSI command flags from numeric into
text format. Also convert the SCMD_LAST flag from numeric into text
form.

Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index d9109771f274..db8517f1a485 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -9,6 +9,7 @@
 static const char *const scsi_cmd_flags[] = {
 	SCSI_CMD_FLAG_NAME(TAGGED),
 	SCSI_CMD_FLAG_NAME(INITIALIZED),
+	SCSI_CMD_FLAG_NAME(LAST),
 };
 #undef SCSI_CMD_FLAG_NAME
 
