Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4E6C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Dec 2021 22:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbhLHXAq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Dec 2021 18:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240862AbhLHXAp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2021 18:00:45 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FE2C0617A2
        for <linux-scsi@vger.kernel.org>; Wed,  8 Dec 2021 14:57:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id t1-20020a5b03c1000000b005f6ee3e97easo6885202ybp.16
        for <linux-scsi@vger.kernel.org>; Wed, 08 Dec 2021 14:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nCfxssMPsD1q0PyBbkNGtQFLjh9qoKfE83Oexh+AmmA=;
        b=YBx3RFczyrcSsixyAF7h7KOLkaoHrPZWobhhDnkGZnOHeqQ6N4k1n+eDUypoARW6XS
         pxFCSN7KMfB4y0z+nkNJC1Sw6sKPfrZlXmQDBYhp2uyDjiRz62ARepwRcOZ2lj3JbdUs
         lOhrILxaVoaJ3uKiB1jHMD80dciECooXdDtlAapvBze31ztONDK7y0jFlWUB7eVuKtq5
         MEE6IdKwYhSit6NQC/M9W3sgmnMt9r34YwCtXwPgzNulKJWmXxXxHhrLH7jjt3OXVizp
         J2g/mDnypmNG5cezxnaw9YSQxVwqorYiWVeC7ACovkrC6hggHrW5e2sp7gkFp2IseH5n
         2m4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nCfxssMPsD1q0PyBbkNGtQFLjh9qoKfE83Oexh+AmmA=;
        b=FNS9yuqCIDAaGJglbfwCetMNrZ6M0rW3SgVGOpdIUCtCwmpO5HT+LgeqqvLfdIKR/j
         dxB8x/SQnhB6si6KG0Un8akwcjV/pynKc7LGgms6AubSYe7HzG3V56Mc66ohnQoba6yB
         6906yNU8w6BfnldwNX1Z1fmCKoqH/Iz/Cd+Pl55++YEVuCYzWm88mi2A3hwEosr86ogo
         bRYwMc8JjgyiOfieYErvkPYRG4XIcWQMlzajSGxuqor8lzcJHGs5AGuwDKeCgjkSGxeo
         GBED5vwFI+c6FnEHp7zFmAKbL9bYwR2wCAK09lKGcN1cuFwZlCOiTZdVVX9aQd8rd/zw
         QFKw==
X-Gm-Message-State: AOAM53332hXmGJD2WmhbHS4FpZP9KLniKCzSTNQbzEqY53yQ8qAB1/Ka
        uNrelXlLNxCYx4T0BPw1p+/6DfJVzQQ=
X-Google-Smtp-Source: ABdhPJwhWwgj5Q80ol/VS55EsbWI8O4643ncWp8nGwhdNJDuYwgHDsQcQforxY1tB0qDeeSnSsbP39mGtc0=
X-Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2cd:202:5e01:df39:4a79:a13])
 (user=khazhy job=sendgmr) by 2002:a25:e090:: with SMTP id x138mr1877571ybg.501.1639004232010;
 Wed, 08 Dec 2021 14:57:12 -0800 (PST)
Date:   Wed,  8 Dec 2021 14:56:37 -0800
Message-Id: <20211208225637.1054164-1-khazhy@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH] scsi: docs: update notes about scsi_times_out
From:   Khazhismel Kumykov <khazhy@google.com>
To:     Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-doc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        Hannes Reinecke <hare@suse.com>,
        Khazhismel Kumykov <khazhy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

eh_timed_out() is not limited by scmd->allowed, and can reset timer
forever, and retries happen in the abort handler.

Fixes: c829c394165f ("[SCSI] FC transport : Avoid device offline cases by stalling aborts until device unblocked")

Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 Documentation/scsi/scsi_eh.rst | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

I'm by no means a scsi expert, but this section didn't seem to line up
with the code that's actually written. Aiming to at least save the
confusion for the next person :) As written, it seems like scsi drivers
implementing eh_timed_out can only issue RESET_TIMER a finite number of
times, but e.g. virtio_scsi relies on being able to reset indefinitely.

(thanks bart for the pointer to where the RESET_TIMER change happened!)


diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
index 7d78c2475615..4c56a33a716f 100644
--- a/Documentation/scsi/scsi_eh.rst
+++ b/Documentation/scsi/scsi_eh.rst
@@ -95,19 +95,18 @@ function
 
     - BLK_EH_RESET_TIMER
 	This indicates that more time is required to finish the
-	command.  Timer is restarted.  This action is counted as a
-	retry and only allowed scmd->allowed + 1(!) times.  Once the
-	limit is reached, action for BLK_EH_DONE is taken instead.
+	command.  Timer is restarted.
 
     - BLK_EH_DONE
         eh_timed_out() callback did not handle the command.
 	Step #2 is taken.
 
- 2. scsi_abort_command() is invoked to schedule an asynchrous abort.
-    Asynchronous abort are not invoked for commands which the
-    SCSI_EH_ABORT_SCHEDULED flag is set (this indicates that the command
-    already had been aborted once, and this is a retry which failed),
-    or when the EH deadline is expired. In these case Step #3 is taken.
+ 2. scsi_abort_command() is invoked to schedule an asynchrous abort. which may
+    issue a retry scmd->allowed + 1 times.  Asynchronous abort are not invoked
+    for commands which the SCSI_EH_ABORT_SCHEDULED flag is set (this indicates
+    that the command already had been aborted once, and this is a retry which
+    failed), when retries are exceeded, or when the EH deadline is expired. In
+    these case Step #3 is taken.
 
  3. scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD) is invoked for the
     command.  See [1-4] for more information.
-- 
2.34.1.400.ga245620fadb-goog

