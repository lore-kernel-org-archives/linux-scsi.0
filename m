From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: recent scsi changes break fc4 build
Date: Sun, 19 Jun 2005 11:43:31 -0400
Message-ID: <42B592A3.8050600@pobox.com>
References: <20050618.231646.91312440.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070404020109070508050705"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:13462 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262228AbVFSPng (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 11:43:36 -0400
In-Reply-To: <20050618.231646.91312440.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

This is a multi-part message in MIME format.
--------------070404020109070508050705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David S. Miller wrote:
> Please, at the very least, try to compile the changes you send the
> Linus instead of doing a cut&paste job and hoping for the best.
> 
> Thanks a lot.
> 
> drivers/fc4/fc.c: In function `fcp_scsi_done':
> drivers/fc4/fc.c:768: warning: unused variable `flags'
> drivers/fc4/fc.c: In function `fcp_scsi_abort':
> drivers/fc4/fc.c:910: warning: unused variable `flags'
> drivers/fc4/fc.c: In function `fcp_scsi_dev_reset':
> drivers/fc4/fc.c:987: error: `flags' undeclared (first use in this function)
> drivers/fc4/fc.c:987: error: (Each undeclared identifier is reported only once
> drivers/fc4/fc.c:987: error: for each function it appears in.)
> drivers/fc4/fc.c: In function `fcp_scsi_host_reset':
> drivers/fc4/fc.c:1033: error: `flags' undeclared (first use in this function)

Regardless of Christoph's comments, 3 out of 4 problems you list are 
probably my fault.

fc4/fc doesn't get built for me, under 'make allyesconfig', one of the 
few that fell through the cracks.  Sorry.

Does the attached patch work for you?

	Jeff



--------------070404020109070508050705
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/fc4/fc.c b/drivers/fc4/fc.c
--- a/drivers/fc4/fc.c
+++ b/drivers/fc4/fc.c
@@ -765,8 +765,6 @@ void fcp_release(fc_channel *fcchain, in
 
 static void fcp_scsi_done (Scsi_Cmnd *SCpnt)
 {
-	unsigned long flags;
-
 	if (FCP_CMND(SCpnt)->done)
 		FCP_CMND(SCpnt)->done(SCpnt);
 }
@@ -907,8 +905,6 @@ int fcp_scsi_abort(Scsi_Cmnd *SCpnt)
 	 */
 
 	if (++fc->abort_count < (fc->can_queue >> 1)) {
-		unsigned long flags;
-
 		SCpnt->result = DID_ABORT;
 		fcmd->done(SCpnt);
 		printk("FC: soft abort\n");
@@ -931,6 +927,7 @@ void fcp_scsi_reset_done(Scsi_Cmnd *SCpn
 
 int fcp_scsi_dev_reset(Scsi_Cmnd *SCpnt)
 {
+	unsigned long flags;
 	fcp_cmd *cmd;
 	fcp_cmnd *fcmd;
 	fc_channel *fc = FC_SCMND(SCpnt);
@@ -1028,6 +1025,7 @@ static int __fcp_scsi_host_reset(Scsi_Cm
 
 int fcp_scsi_host_reset(Scsi_Cmnd *SCpnt)
 {
+	unsigned long flags;
 	int rc;
 
 	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);

--------------070404020109070508050705--
