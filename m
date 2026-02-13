Received: from mail.he1.boomer41.net (mail.he1.boomer41.net [178.63.148.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DEB280CC1
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 19:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.148.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771012729; cv=none; b=Q/E8h5H3ZNHRAEcqDIaycMqmKXT/LHIHE0HjeiDclhK91/B0mjLDqgaLDk+vE3FSrdWBp0ymLFyXZzhBGmKUpmzk54eq3Z5AO6+DwBagger7DwjK/Q3xuX9TBaRmEQjL5UkEdTzGIvWT9CiOAT4osbO45KvbQCanknrfo92Q75w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771012729; c=relaxed/simple;
	bh=netHqHWcmp1s1ydaDDi2r3u2y89ewoPGmZASKtgIrkc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TXq9Wfp0osO8VTuiizDo5Wk9FBFBntHJBm+AZXtIMahzvMxGjQTrB1BKGQKUf7Tk2cppUNcOsYT02SV4GHCs0akJkz+hgmJbsOY9lFIZ28LAzCgy225BgU9m2im7LIfyPFJWbZaGw64HgXdpLO3Y73VV65Oyq+7DBhI3Yav6bus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=stephan-brunner.net; spf=pass smtp.mailfrom=stephan-brunner.net; dkim=pass (4096-bit key) header.d=stephan-brunner.net header.i=@stephan-brunner.net header.b=K9UJqsFB; arc=none smtp.client-ip=178.63.148.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=stephan-brunner.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stephan-brunner.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=stephan-brunner.net header.i=@stephan-brunner.net header.b="K9UJqsFB"
From: Stephan Brunner <s.brunner@stephan-brunner.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stephan-brunner.net;
	s=mail; t=1771012665;
	bh=netHqHWcmp1s1ydaDDi2r3u2y89ewoPGmZASKtgIrkc=;
	h=From:To:Cc:Subject:Date;
	b=K9UJqsFBazmhwgXKG6NOd+UXa0+ZvZIpjnFOR4gkBGpIKjmTE6o1UUBQHJmSeANWG
	 czdBDJII6J7ZTv9N/RbndDm4Yx843gW3+mAXAmkdiAVdHMkC2oDo7CgNB4nrdZalS0
	 0P+ILQ67rKz32XI9vGZrCSJ5TEtPjZjIwUpZgYFEWr6RmOokh9Op6QFBlkyLnZXqKM
	 TFZT0MIqimoSnJTZpLEYAt+8O1nzUpg1hTZHHVSXeTJtins/AaVUa1PFAApa/gp4+1
	 6IIgw86/8RrR+zclV+U6jnfVUOtD6kO0yvGY9b//4rf/MT5bVBG2gDlbNt1g4eN7VY
	 KN40BvVPA8cAdRmwm1n398qnbxiwtTx9xbgQSuA5WcBI6gYEf7kYyt60nd3wM4yJgb
	 h4ttjgMky8tsOSJC+NtW0sSc1aUUDun7RjDlX2fZBwrPBSnA0b5t6xv/ugrizUlXsL
	 Gq9t3kKnbYh4OvLxp5gAcAEyeb0FoMQAc0HQGe3/bpOUsOzs6vUm25W4ERyjpbF+Ip
	 d1m8ztoMeQBtUOrYZo2PhLnkGOJHGeQHH7ht/t2GyEgFgo7Wo415zQdPK8rsQyWnem
	 aUgeNb8NSMoYr7aPgiBgR0XegyjiBlQzC7mrR59YXxE6CCTg6gcMSNOUiJKZzy3C2a
	 OYna1xkapp8ekOw7GSaX+3zk=
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	Stephan Brunner <s.brunner@stephan-brunner.net>
Subject: [PATCH] drivers/scsi: Log spin up retries as standalone messages instead of continuations
Date: Fri, 13 Feb 2026 20:57:11 +0100
Message-ID: <ea0a0facf69c1b3029292897d4b8cf90cab0d0aa.1771012198.git.s.brunner@stephan-brunner.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On disks where the first spin up does not immediately succeed,
the log messages will be printed like this:

> sd 0:0:0:0: [sda] Spinning up disk...
> .ready
> sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/466 GiB)

The single ".ready" message looks ugly and can not be easily matched
to other messages concerning this particular disk, especially when a lot
is going on in dmesg.

So, make the messages standalone.
Additionally, make the "spin up failed" message a warning to be able to
distinguish it from normal messages.

The new messages look like this:

> sd 0:0:0:0: [sda] Spinning up disk...
> sd 0:0:0:0: [sda] Retrying to spin up disk...
> sd 0:0:0:0: [sda] Disk ready
> sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/466 GiB)

Signed-off-by: Stephan Brunner <s.brunner@stephan-brunner.net>
---
 drivers/scsi/sd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d76996d6cbc9..21c88e87e59d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2532,7 +2532,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 						0x11 : 1,
 				};
 
-				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
+				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...\n");
 				scsi_execute_cmd(sdkp->device, start_cmd,
 						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
@@ -2542,7 +2542,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			}
 			/* Wait 1 second for next try */
 			msleep(1000);
-			printk(KERN_CONT ".");
+			sd_printk(KERN_NOTICE, sdkp, "Retrying to spin up disk...\n");
 
 		/*
 		 * Wait for USB flash devices with slow firmware.
@@ -2572,9 +2572,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 
 	if (spintime) {
 		if (scsi_status_is_good(the_result))
-			printk(KERN_CONT "ready\n");
+			sd_printk(KERN_NOTICE, sdkp, "Disk ready\n");
 		else
-			printk(KERN_CONT "not responding...\n");
+			sd_printk(KERN_WARNING, sdkp, "Disk not responding\n");
 	}
 }
 
-- 
2.52.0

