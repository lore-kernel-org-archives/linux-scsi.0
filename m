Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A567BC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8933460E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhJGUbk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:40 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:44638 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbhJGUbj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:39 -0400
Received: by mail-pj1-f53.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so6083192pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Zvejwbxr0RoImsBn1iUhSjlzaoSFnI22+3R9qJ6IfA=;
        b=sF/5o+1NGiRCP9DbyvL6Ezv+1n8ii6lZPXFTY4+co8V0iKusodq61eHFe++md6Paxf
         QV+xVhU7WSTjXpjEbYByVsDHg0qjdagFswkAkuwLBfXaREmH7dbSB3P5SMHQQpkd06aX
         OZ97ZFfc+xM1WGnCp44oBOJ++nWbNLh8eytoQebg4bWq9FXHYeMqiPgWVMDX+ek7xUxU
         Yn0MLE/GD95MBvJZjtkYFFm8fAnTM2iUWknCMAZXQ/CVwr423Z0WjdWLe2HdbyCMFzka
         w/51nL4VOuj+cMNZ2T19tfaZlpnQWiTdh41aJa988G94Mss9GVfVggPfuc/V3cItzATV
         pWdg==
X-Gm-Message-State: AOAM531IYBgvNs+avsYwSBNgUORVZhLOKWZqi9KTRsuOnPaoPB0I9GlN
        1s7VmV/GMS/uSx41Kqa4YuY=
X-Google-Smtp-Source: ABdhPJzoJqPAskLFPM02uxT3tUobAnfWxK1gR5KUFg9A19x73ArJlz9bo/GHzwetc7peXC9/pU/z+A==
X-Received: by 2002:a17:90a:19d2:: with SMTP id 18mr7572547pjj.62.1633638585006;
        Thu, 07 Oct 2021 13:29:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v3 07/88] zfcp_scsi: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:02 -0700
Message-Id: <20211007202923.2174984-8-bvanassche@acm.org>
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

Acked-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/s390/scsi/zfcp_fsf.c  | 2 +-
 drivers/s390/scsi/zfcp_scsi.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index c1f979296c1a..4f1e4385ce58 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2501,7 +2501,7 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 	zfcp_dbf_scsi_result(scpnt, req);
 
 	scpnt->host_scribble = NULL;
-	(scpnt->scsi_done) (scpnt);
+	scsi_done(scpnt);
 	/*
 	 * We must hold this lock until scsi_done has been called.
 	 * Otherwise we may call scsi_done after abort regarding this
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 9da9b2b2a580..e0a6d8c1f198 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -60,7 +60,7 @@ static void zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
 {
 	set_host_byte(scpnt, result);
 	zfcp_dbf_scsi_fail_send(scpnt);
-	scpnt->scsi_done(scpnt);
+	scsi_done(scpnt);
 }
 
 static
@@ -78,7 +78,7 @@ int zfcp_scsi_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scpnt)
 	if (unlikely(scsi_result)) {
 		scpnt->result = scsi_result;
 		zfcp_dbf_scsi_fail_send(scpnt);
-		scpnt->scsi_done(scpnt);
+		scsi_done(scpnt);
 		return 0;
 	}
 
