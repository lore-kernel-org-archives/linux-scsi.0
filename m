From: Willem Riede <wrlk@riede.org>
Subject: Re: Scsi error handler strategy question - now with [PATCH]
Date: Sun, 18 Jan 2004 10:20:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040118152005.GO4339@linnie.riede.org>
References: <20040104232425.GM4339@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:59027 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S261825AbUARPUG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 10:20:06 -0500
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.10/8.12.10) with ESMTP id i0IFK5EM011443
	for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2004 10:20:05 -0500
Content-Disposition: inline
In-Reply-To: <20040104232425.GM4339@linnie.riede.org> (from wrlk@riede.org on Sun, Jan 04, 2004 at 18:24:25 -0500)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2004.01.04 18:24, Willem Riede wrote:
> While testing the ide-scsi error handling, I observed that my ATAPI
> device gets offlined too easily.
> 
[snip]
> 
> Am I allowed to submit a patch that will also retry on that condition?

Below is the patch I developed to make the error recovery robust for
my OnStream DI-30 with osst and ide-scsi.

I realize that there may be objections to applying this to the main scsi
subsystem because the slowdown may be extreme for say a fiber connected
SAN with hundreds of disks, but it is absolutely necessary for my ATAPI
devices. So if you don't want to apply this, tell me, and I'll work it 
into a ide-scsi specific error strategy handler.

Thanks, Willem Riede.

--- linux-2.6.1-1.34/drivers/scsi/scsi_error.c	2004-01-09 01:59:03.000000000 -0500
+++ linux-2.6.1-test/drivers/scsi/scsi_error.c	2004-01-18 08:59:30.000000000 -0500
@@ -282,6 +282,11 @@
 			(scmd->sense_buffer[13] == 0x01)) {
 			return NEEDS_RETRY;
 		}
+		/* same for reset occurred and not ready to ready transition */
+		if (((scmd->sense_buffer[12] & ~1) == 0x28) &&
+			(scmd->sense_buffer[13] == 0x00)) {
+			return NEEDS_RETRY;
+		}
 		return SUCCESS;
 
 		/* these three are not supported */
@@ -713,9 +718,11 @@
 static int scsi_eh_tur(struct scsi_cmnd *scmd)
 {
 	static unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
-	int retry_cnt = 1, rtn;
+	int retry_cnt = 32, rtn;
 
 retry_tur:
+	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: send TUR, attempt %d\n",
+					  current->comm, 33-retry_cnt));
 	memcpy(scmd->cmnd, tur_command, sizeof(tur_command));
 
 	/*
@@ -747,8 +754,10 @@
 	if (rtn == SUCCESS)
 		return 0;
 	else if (rtn == NEEDS_RETRY)
-		if (retry_cnt--)
+		if (retry_cnt--) {
+			scsi_sleep(HZ);
 			goto retry_tur;
+		}
 	return 1;
 }
 
