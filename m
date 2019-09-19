Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE79C3A5A6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 07:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACBB6207FC
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 07:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tFdvkVKt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbfISHz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 03:55:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46720 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbfISHz4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 03:55:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id a3so1379870pgm.13;
        Thu, 19 Sep 2019 00:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=mRA/d6yGGyz12Y4WV+zZOQ6cVlrDjX67UkfMk4HR8Jk=;
        b=tFdvkVKtsCwrK5ccV9e4F6GfeW594gYwXdFnfFjeLRahIGNr5KYP6NiWNcLzG7yzsZ
         TXXjmiIgVen0njMvik8r3Ev9O5+1jSr1Ek6VDkl7WzoetHsPBDxKuAYe6qtanGJRsY5H
         O8YfYxJsICIAEt9FreSjT6nGZo9aydpxHyCWPdaK/Lu0mIkpPOcqyB4lVfJfLfcteaXz
         BeDjAmP9NOMHI7GIdxjBUOaaZDYg2g8GWPmXWUZ3LYyZx4eHqs4i+g7CqkzTSsalPkE4
         OuhAg6N2RF10LGb9RvD2oZGArrj8M86S3jegXeFxeY9FXO+lXWw5JNhutr9MHGb/cpnk
         h6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=mRA/d6yGGyz12Y4WV+zZOQ6cVlrDjX67UkfMk4HR8Jk=;
        b=QUwzqTMCva+/cuzcw5lwCWCY73x7LSUUZkK0zZRXfe8mpakPRxuoZq5QOCHNwLPzq/
         E9KGe8eFYVDxsk7zEPtlUzMkQmC0YqpkM7Zh5PQEqV2WGBf8hINBkzTj6/weAEJJ3Fcq
         jGkj8k2TxpfxRQ/n7jORafzLqaODxaECO9pj8TM03i9UG20cVDO3xAnN+oblGiOp+Txb
         UHbj3PqFujjKy1hFA4o8q9qKiXMqJW3QpP4yptWX+7zt3oGzZybDBgOH3JbmQKlWsPB/
         tVFllNs6Whqv01o8gI422VG/l6iQoWNe8Zild4z4mfhsiNai1NpAjsEHbcLtZFMA44rM
         6QaQ==
X-Gm-Message-State: APjAAAU/6oyhudfqZLECQXhVkWjQTkM597DZHatiyMcJ8IhCc6Awbn/S
        fj3/TQmz36PU9QZEoDyhH+0=
X-Google-Smtp-Source: APXvYqz0S6vjX8lv6pJA2Q7Ow4MnUHlRHR4fLO0C6TbcxfLfC1MXOmSSPTd3zeH252UmaqYFxU16zA==
X-Received: by 2002:a17:90a:17c5:: with SMTP id q63mr2237368pja.106.1568879753903;
        Thu, 19 Sep 2019 00:55:53 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id s21sm4377625pjr.24.2019.09.19.00.55.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 00:55:53 -0700 (PDT)
Date:   Thu, 19 Sep 2019 16:55:48 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        QLogic-Storage-Upstream@cavium.com, austindh.kim@gmail.com
Subject: [PATCH] scsi: qedf: Remove always false 'tmp_prio < 0' statement
Message-ID: <20190919075548.GA112801@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since tmp_prio is declared as u8, the following statement is always false.
   tmp_prio < 0

So remove 'always false' statement.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 1659d35..59ca98f 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -596,7 +596,7 @@ static void qedf_dcbx_handler(void *dev, struct qed_dcbx_get *get, u32 mib_type)
 		tmp_prio = get->operational.app_prio.fcoe;
 		if (qedf_default_prio > -1)
 			qedf->prio = qedf_default_prio;
-		else if (tmp_prio < 0 || tmp_prio > 7) {
+		else if (tmp_prio > 7) {
 			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
 			    "FIP/FCoE prio %d out of range, setting to %d.\n",
 			    tmp_prio, QEDF_DEFAULT_PRIO);
-- 
2.6.2

