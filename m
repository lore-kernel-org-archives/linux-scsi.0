Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30414C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0218120866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HYAqT/6I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbfHNX5q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:46 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39857 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729789AbfHNX5p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:45 -0400
Received: by mail-pf1-f196.google.com with SMTP id f17so336469pfn.6
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PfRaxnZCHcEhlnCXr03SswVRFUECQbb2J1Ml+8xWeEo=;
        b=HYAqT/6Id4PgBXyb3UZyUHHtTU/UUS9AgzqwqUBqS8q0RPGveCIuwXUFpG/FZoUgPY
         RVoaSOMpB4ig7EwxHaYDApS19uaT4g6U2VcnaKE5jUnlbapNAvskE3TbOESDvRMqVKti
         em8nNpBHffjDC0iDZU6OZasuD0hec8vUBeHVDMCP6uAiA3q40QsGo08jtZESyA05FIIQ
         JhGBW9QFI7uZfgLlca8kpDY8rrDSGWX2Qd6QhRvjUCpzhl5LAStAu3GhexQh3zz7yKlB
         bv5z//vBRJgW+FjiNn5wsgWJA+zpVF2oC0cF/CvaQiLSHfLI+69Tfue8sIcJYQKuMK6Y
         NtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PfRaxnZCHcEhlnCXr03SswVRFUECQbb2J1Ml+8xWeEo=;
        b=oymQYIoMI7zQZOKbnSJw+qRIUSLjC6+bdLoMamsCUUgKIeyRjakdt3lZOVIxO4HfGC
         zStc1dlP0aocPMKb63wVXVyqny6aq3bYbDp082ETuFv6Vy3sz+PCpiT8RFb8Fm7eXLli
         k2+E0HF6RzTaucL7HHPnQboZ7CM7cuodmEn2y2UHZ6Ez9rnhEAtvZqPj6iLZ5Q9Ot4+s
         TjIcP65/KDX9Vhwp8zdfjEjApNYWiOD9xWPMyj/vTOrROa0XIRW9rIZyXixxyBGfw8tf
         C31mTv0VAtwvK0vHeTF3hrO/1ERwAidg/WKQMRLC8nxus05v/PIW7r4Ja0Kn/fjKXNy8
         ru0Q==
X-Gm-Message-State: APjAAAVEQ0LK1bIWwJkkFUJiaj6gAy5A5DjAkRgePoU9+RZ9y3/gaP2R
        BawJW0evTDS09qOveIpAcTEOy+Ap
X-Google-Smtp-Source: APXvYqysUM5jphEMk4JFA8T8qoYKKaqno3AM96+Zv+YdEnLH539znGgexOiD5tRc4GQE+AJnsyUOeQ==
X-Received: by 2002:a63:e010:: with SMTP id e16mr1332012pgh.285.1565827064704;
        Wed, 14 Aug 2019 16:57:44 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:44 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 29/42] lpfc: Fix upcall to bsg done in non-success cases
Date:   Wed, 14 Aug 2019 16:56:59 -0700
Message-Id: <20190814235712.4487-30-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi transport fc bsg interface does not expect the
bsg_job_done() callback to be done if the bsg request call
returns failure. Several of the HST_VENDOR cases in the driver
unconditionally call bsg_job_done() regardless of the returning
value.

Fix the code to only call bsg_job_done() if the call to
lpfc_bsg_request() will return success.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index c7f66239ca70..9b9858078076 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5449,7 +5449,9 @@ lpfc_bsg_get_ras_config(struct bsg_job *job)
 	bsg_reply->result = rc;
 
 	/* complete the job back to userspace */
-	bsg_job_done(job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
+	if (!rc)
+		bsg_job_done(job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -5528,8 +5530,9 @@ lpfc_bsg_set_ras_config(struct bsg_job *job)
 	bsg_reply->result = rc;
 
 	/* complete the job back to userspace */
-	bsg_job_done(job, bsg_reply->result,
-		       bsg_reply->reply_payload_rcv_len);
+	if (!rc)
+		bsg_job_done(job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 	return rc;
 }
@@ -5589,7 +5592,9 @@ lpfc_bsg_get_ras_lwpd(struct bsg_job *job)
 	bsg_reply->result = rc;
 
 	/* complete the job back to userspace */
-	bsg_job_done(job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
+	if (!rc)
+		bsg_job_done(job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 	return rc;
 }
@@ -5671,7 +5676,9 @@ lpfc_bsg_get_ras_fwlog(struct bsg_job *job)
 
 ras_job_error:
 	bsg_reply->result = rc;
-	bsg_job_done(job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
+	if (!rc)
+		bsg_job_done(job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 	return rc;
 }
@@ -5742,8 +5749,9 @@ lpfc_get_trunk_info(struct bsg_job *job)
 				phba->sli4_hba.link_state.logical_speed / 1000;
 job_error:
 	bsg_reply->result = rc;
-	bsg_job_done(job, bsg_reply->result,
-		       bsg_reply->reply_payload_rcv_len);
+	if (!rc)
+		bsg_job_done(job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 	return rc;
 
 }
-- 
2.13.7

