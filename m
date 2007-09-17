From: Satyam Sharma <satyam@infradead.org>
Subject: [PATCH -mm][resend] mpt fusion: Shut up uninitialized variable
 warnings
Date: Tue, 18 Sep 2007 04:12:41 +0530 (IST)
Message-ID: <alpine.LFD.0.999.0709180407480.8863@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-922654524-1190068964=:8863"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35141 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbXIQWj4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 18:39:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Moore <eric.moore@lsi.com>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-922654524-1190068964=:8863
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


drivers/message/fusion/mptctl.c: In function ‘mptctl_mpt_command’:
drivers/message/fusion/mptctl.c:1764: warning: ‘bufIn.len’ may be used uninitialized in this function
drivers/message/fusion/mptctl.c:1765: warning: ‘bufOut.len’ may be used uninitialized in this function

come because gcc gets confused by some "goto" statements in above function.
The warnings have been verified to be bogus, however, the function does
initialize these later (after the offending goto's) in the function anyway.
So let's move those initializations to top of function, thereby also shutting
up these warnings.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Eric Moore <eric.moore@lsi.com>

---

[ Had not copied Andrew and linux-scsi@ last time,
  don't yet see this in any of the SCSI git trees. ]

 drivers/message/fusion/mptctl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc4-mm1/drivers/message/fusion/mptctl.c~fix	2007-09-02 21:51:14.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/message/fusion/mptctl.c	2007-09-02 21:54:25.000000000 +0530
@@ -1773,7 +1773,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	ulong 		timeout;
 	struct scsi_device *sdev;
 
+	/* bufIn and bufOut are used for user to kernel space transfers
+	 */
 	bufIn.kptr = bufOut.kptr = NULL;
+	bufIn.len = bufOut.len = 0;
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
@@ -2107,11 +2110,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	psge = (char *) (((int *) mf) + karg.dataSgeOffset);
 	flagsLength = 0;
 
-	/* bufIn and bufOut are used for user to kernel space transfers
-	 */
-	bufIn.kptr = bufOut.kptr = NULL;
-	bufIn.len = bufOut.len = 0;
-
 	if (karg.dataOutSize > 0)
 		sgSize ++;
 
--464262402-922654524-1190068964=:8863--
