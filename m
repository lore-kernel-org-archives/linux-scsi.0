Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA4B0C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348487AbhK2Tvj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:39 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:34782 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378405AbhK2Tti (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:38 -0500
Received: by mail-pl1-f177.google.com with SMTP id y8so13041764plg.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2eowHEMEaomOtvfvRCh+rFzyDDZg9uyicwuaqpBFZK8=;
        b=6gXU/Qj3ClbEn1IKlaOxv2753laqJj4JzWAxMLGfOrt6v8+lKa6zufOX9EuD4xe4Gw
         bakXGyMa934veQJIyjdolqwR3kxIK0CWl+/dgssMsif3Gq2OHZu3ZNNcDf0MaSECHrZP
         vFDlmWCY2GaXCofto3OCS8C4D+b1cNWCcyVQQylgmbpt4fBDVmQ2OdidopR5df64Vrln
         K1XcqPu4PDlTUh1aAsIEdQBgHRz1nyE6MGbJKKYNANiuZYHijD1ykTgJ1V75/XQsIKAJ
         VZhx3QiuEBNlM+2sv3uc4hCv7wttUmWB6+17aNHfB3batI6AAkUq7cpm9eU2LYeKkYd2
         TJHg==
X-Gm-Message-State: AOAM531dh+6pcHRPSEvvQLFkwOPaaakQVd6lXqdKSMLhqFRZWC06gY0K
        GPHygDDcKxHhamTUm/FUrHs=
X-Google-Smtp-Source: ABdhPJxw3xPG1FueKkeSkhTjcDmXxt+uePRYgZTcKBAR61sQVfqvKKmuP03XN9jc7b2ckp99QeWxEA==
X-Received: by 2002:a17:90b:3e85:: with SMTP id rj5mr194209pjb.172.1638215180771;
        Mon, 29 Nov 2021 11:46:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:20 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 03/12] scsi: core: Show SCMD_LAST in text form
Date:   Mon, 29 Nov 2021 11:46:00 -0800
Message-Id: <20211129194609.3466071-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
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
 
