From: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] scsi_error thread exits in TASK_INTERRUPTIBLE state.
Date: Wed, 19 Oct 2005 03:54:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.58.0510190349590.20634@localhost.localdomain>
References: <5bdc1c8b0510181402o2d9badb0sd18012cf7ff2a329@mail.gmail.com>
 <1129693423.8910.54.camel@mindpipe> <1129695564.8910.64.camel@mindpipe>
 <Pine.LNX.4.58.0510190300010.20634@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:65424 "EHLO
	ms-smtp-03.nyroc.rr.com") by vger.kernel.org with ESMTP
	id S1750910AbVJSHzN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 03:55:13 -0400
In-Reply-To: <Pine.LNX.4.58.0510190300010.20634@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Revell <rlrevell@joe-job.com>
Cc: Mark Knecht <markknecht@gmail.com>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, rmk@arm.linux.org.uk, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, andmike@us.ibm.com, linux-scsi@vger.kernel.org


Found in the -rt patch set.  The scsi_error thread likely will be in the
TASK_INTERRUPTIBLE state upon exit.  This patch fixes this bug.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.14-rc4/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.14-rc4.orig/drivers/scsi/scsi_error.c	2005-10-19 03:37:55.000000000 -0400
+++ linux-2.6.14-rc4/drivers/scsi/scsi_error.c	2005-10-19 03:38:59.000000000 -0400
@@ -1645,6 +1645,12 @@
 		set_current_state(TASK_INTERRUPTIBLE);
 	}

+	/*
+	 * There's a good chance that the loop will exit in the
+	 * TASK_INTERRUPTIBLE state.
+	 */
+	__set_current_state(TASK_RUNNING);
+
 	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d"
 					  " exiting\n",shost->host_no));


