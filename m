From: Jens Axboe <axboe@suse.de>
Subject: [PATCH] 3ware bad queuecommand returns
Date: Fri, 19 Nov 2004 09:43:13 +0100
Message-ID: <20041119084312.GW26240@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:20413 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261317AbUKSIyi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 03:54:38 -0500
Received: from [62.242.22.158] (helo=zx2000.home.kernel.dk)
	by virtualhost.dk with esmtp (Exim 3.36 #1)
	id 1CV4XP-0007pH-00
	for linux-scsi@vger.kernel.org; Fri, 19 Nov 2004 09:54:39 +0100
Received: from axboe by zx2000.home.kernel.dk with local (Exim 4.30)
	id 1CV4Wx-000146-4R
	for linux-scsi@vger.kernel.org; Fri, 19 Nov 2004 09:54:11 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.dk, James Bottomley <James.Bottomley@steeleye.com>
Cc: linuxraid@amcc.com, Linus Torvalds <torvalds@osdl.org>

Hi,

If your ->queuecommand() completes a command through done, it must not
return non-zero to the mid layer so that it takes ownership of the
command again.

Signed-off-by: Jens Axboe <axboe@suse.de>


===== drivers/scsi/3w-9xxx.c 1.4 vs edited =====
--- 1.4/drivers/scsi/3w-9xxx.c	2004-07-16 17:20:43 +02:00
+++ edited/drivers/scsi/3w-9xxx.c	2004-11-18 22:55:58 +01:00
@@ -1746,6 +1746,7 @@ static int twa_scsi_queue(struct scsi_cm
 		twa_free_request_id(tw_dev, request_id);
 		SCpnt->result = (DID_ERROR << 16);
 		done(SCpnt);
+		reval = 0;
 	}
 
 	return retval;
===== drivers/scsi/3w-xxxx.c 1.47 vs edited =====
--- 1.47/drivers/scsi/3w-xxxx.c	2004-10-07 05:20:16 +02:00
+++ edited/drivers/scsi/3w-xxxx.c	2004-11-18 22:55:31 +01:00
@@ -2067,6 +2067,7 @@ static int tw_scsi_queue(struct scsi_cmn
 		tw_state_request_finish(tw_dev, request_id);
 		SCpnt->result = (DID_ERROR << 16);
 		done(SCpnt);
+		retval = 0;
 	}
 out:
 	return retval;

-- 
Jens Axboe

