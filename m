From: Andrew Morton <akpm@digeo.com>
Subject: [patch] remove scsi_eh_retry_cmd
Date: Mon, 10 Mar 2003 22:27:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030310222748.68ba7ad3.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id WAA20813
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2003 22:26:59 -0800 (PST)
Received: from digeo-e2k04.digeo.com ([192.168.2.24])
 by digeo-nav01.digeo.com (NAVGW 2.5.2.12) with SMTP id M2003031022285805246
 for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2003 22:28:58 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Compile warnings are useful...

diff -puN drivers/scsi/scsi_error.c~a drivers/scsi/scsi_error.c
--- 25/drivers/scsi/scsi_error.c~a	2003-03-10 22:26:27.000000000 -0800
+++ 25-akpm/drivers/scsi/scsi_error.c	2003-03-10 22:26:33.000000000 -0800
@@ -597,28 +597,6 @@ static int scsi_request_sense(struct scs
 }
 
 /**
- * scsi_eh_retry_cmd - Retry the original command
- * @scmd:	Original failed SCSI cmd.
- *
- * Notes:
- *    This function will *not* return until the command either times out,
- *    or it completes.
- **/
-static int scsi_eh_retry_cmd(struct scsi_cmnd *scmd)
-{
-	int rtn = SUCCESS;
-
-	for (; scmd->retries < scmd->allowed; scmd->retries++) {
-		scsi_setup_cmd_retry(scmd);
-		rtn = scsi_send_eh_cmnd(scmd, scmd->timeout_per_command);
-		if (rtn != NEEDS_RETRY)
-			break;
-	}
-
-	return rtn;
-}
-
-/**
  * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
  * @scmd:	Original SCSI cmd that eh has finished.
  * @done_q:	Queue for processed commands.

_

