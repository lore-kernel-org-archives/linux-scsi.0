From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: [RFC][PATCH]SCSI signal(I/O) failure causes no response
Date: Wed, 14 Apr 2004 10:07:46 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404140107.AA03169@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:63452 "EHLO
	fgwmail7.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S263679AbUDNBHz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 21:07:55 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76]) by fgwmail7.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i3E17rEr016170 for <linux-scsi@vger.kernel.org>; Wed, 14 Apr 2004 10:07:53 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s0.gw.fujitsu.co.jp by m6.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i3E17rab018554 for <linux-scsi@vger.kernel.org>; Wed, 14 Apr 2004 10:07:53 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail503.fjmail.jp.fujitsu.com (fjmail503-0.fjmail.jp.fujitsu.com [10.59.80.100]) by s0.gw.fujitsu.co.jp (8.12.10)
	id i3E17qvN004102 for <linux-scsi@vger.kernel.org>; Wed, 14 Apr 2004 10:07:52 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan501-0.fjmail.jp.fujitsu.com [10.59.80.120])
 by fjmail503.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HW4004PFZ543T@fjmail503.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Wed, 14 Apr 2004 10:07:52 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Emoore@lsil.com

Hi all,

We are planning to use linux for enterprise server.
Since the response time on hardware failure is important factor,
we are measuring the response time in case of the error by making
pseudo errors.

We generated some SCSI signal failure in the test.
When I cut the I/O signal during read command from host, 
I expected the command finished with error soon.
But the result was the command didn't finish forever(and no error
message was displayed).

I added some messages in order to investigate what has occurred.
>From the messages, the sequence was:

1.Fusion MPT driver issues read command to its firmware.
  (our server has LSI53C1030 as SCSI adapter)
  Then the firmware returns protocol error for the command.
  Fusion MPT driver makes DID_RESET status by protocol error 
  and sends it to SCSI midlayer.

2.SCSI midlayer analyzes the status from LLD.
  SCSI midlayer schedules command retry because the status is just
  DID_RESET status.
  (When the status has DID_RESET plus some sense code, the retry
   sequence depends on the sense code. But when the status has only
   DID_RESET, SCSI midlayer schedules command retry)

Sequence 1. and 2. are repeated infinitely and it causes no response.

To prevent this problem, I proposed Eric Moore to change the DID_RESET
status to DID_SOFT_ERROR in fusion MPT driver.
But he suggested me to change SCSI midlayer to prevent infinite loop.

So, I made following patch to prevent the problem.
(patch is based on kernel 2.6.5)

Comments welcome.

Thanks,
Masao Fukuchi

///
diff -uarN linux-2.6.5/drivers/scsi/scsi_lib.c linux-didreset/drivers/scsi/scsi_lib.c
--- linux-2.6.5/drivers/scsi/scsi_lib.c	2004-04-13 18:53:52.000000000 +0900
+++ linux-didreset/drivers/scsi/scsi_lib.c	2004-04-13 20:32:23.000000000 +0900
@@ -852,8 +852,10 @@
 		 * recovery reasons.  Just retry the request
 		 * and see what happens.  
 		 */
-		scsi_requeue_command(q, cmd);
-		return;
+		if (++cmd->retries < cmd->allowed) {
+			scsi_requeue_command(q, cmd);
+			return;
+		}
 	}
 	if (result) {
 		printk("SCSI error : <%d %d %d %d> return code = 0x%x\n",
