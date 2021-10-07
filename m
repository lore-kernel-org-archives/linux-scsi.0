Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD82C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26A4561108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242359AbhJGUcr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:47 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:52959 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242399AbhJGUcl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:41 -0400
Received: by mail-pj1-f43.google.com with SMTP id oa4so5095497pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rf6op0nTRGSllEw3n8I/Sg51JXj9o8wIqjao92E//qE=;
        b=XdMhkPkYBzixozjmTbSWx2P1Hk7FEvbZrhhFopvIX+LNbl7o48fD2QeAe6a6CiPMTn
         +z7/wpHjZTpE+NRcJCRw2Z7LnyHVxKB2o48x6mU8n4ijSF0NcGJMCS3uOK5ZhoyG9bPT
         ObTs7zNJ1f5JSsyUvpzBXbm/3oGubmnEU9kp1PJwgmmwmNCbXPgbmMd7kypqTKTnc7c7
         pzMraL1Dg+H9gdGZmWdJs90ZyMmOURbPrv6vXtACiPqOh6uMkbhq6OGBuuY8DVkjBeWf
         disu8CcFZu3dtpJTJDo0rRCgy7FzS2noqKcCME+6GFLxDH3jJ5jQA3Q53fDXDdeJV7Ar
         FUCg==
X-Gm-Message-State: AOAM533XHQhalThsW/J78B1WlpJ6hqVdg7koq4tGUrXRpqqV/dOKFaDr
        J0/FcWFIjas0XRpHEQ+g8m4=
X-Google-Smtp-Source: ABdhPJwsiflLnRQ/8JjEY5oXZq9LUWqdKhqeZlTSoQhzgkYwxCH2OOjVNUvQpcPEAzaAYtYkkp6KUw==
X-Received: by 2002:a17:902:76c4:b0:13e:2f2c:bdaf with SMTP id j4-20020a17090276c400b0013e2f2cbdafmr5615734plt.70.1633638647272;
        Thu, 07 Oct 2021 13:30:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncanb@suse.com>, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 44/88] libiscsi: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:39 -0700
Message-Id: <20211007202923.2174984-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Reviewed-by: Lee Duncan <lduncanb@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 712a45368385..7beedc59d0c6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -468,7 +468,7 @@ static void iscsi_free_task(struct iscsi_task *task)
 		 * it will decide how to return sc to scsi-ml.
 		 */
 		if (oldstate != ISCSI_TASK_REQUEUE_SCSIQ)
-			sc->scsi_done(sc);
+			scsi_done(sc);
 	}
 }
 
@@ -1807,7 +1807,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
 	scsi_set_resid(sc, scsi_bufflen(sc));
-	sc->scsi_done(sc);
+	scsi_done(sc);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
