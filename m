From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix scsi cmnd retries in error handling
Date: Mon, 1 Nov 2010 21:02:32 +0800
Message-ID: <AANLkTikYv-4STgVob=7j70Mo2fuLOR=zc3=WTD7x3Kig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36577 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570Ab0KANCe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 09:02:34 -0400
Received: by wwe15 with SMTP id 15so6005031wwe.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2010 06:02:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There are two instances of increment and test of retries of scsi cmnd
in functions scsi_decide_disposition() and scsi_eh_flush_done_q()
respectively.

One of the increments is overwork when the corresponding cmnds are same.
The overwork is fixed in scsi_decide_disposition().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_error.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-11-01 20:39:38.000000000 +0800
@@ -1541,7 +1541,7 @@ int scsi_decide_disposition(struct scsi_
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if ((++scmd->retries) <= scmd->allowed
+	if (scmd->retries < scmd->allowed
 	    && !scsi_noretry_cmd(scmd)) {
 		return NEEDS_RETRY;
 	} else {
