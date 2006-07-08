From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] scsi_lib.c: do not requeue on success
Date: Fri, 7 Jul 2006 21:09:09 -0700 (PDT)
Message-ID: <20060708040909.60001.qmail@web31815.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31815.mail.mud.yahoo.com ([68.142.206.168]:52047 "HELO
	web31815.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932503AbWGHEJK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 00:09:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Do not requeue on success.  I.e. when result is 0, success,
we do not want to requeue.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 08af9aa..841f958 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -932,7 +932,7 @@ void scsi_io_completion(struct scsi_cmnd
         * are leftovers and there is some kind of error
         * (result != 0), retry the rest.
         */
-       if (scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
+       if (scsi_end_request(cmd, 1, good_bytes, !!result) == NULL)
                return;
 
        /* good_bytes = 0, or (inclusive) there were leftovers and


