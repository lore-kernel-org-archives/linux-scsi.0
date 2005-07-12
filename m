From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: Redundant this_count check in sd_init_command()
Date: Tue, 12 Jul 2005 15:57:13 -0700
Message-ID: <200507122257.j6CMvHg07091@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr21.intel.com ([143.183.121.13]:37339 "EHLO
	scsfmr001.sc.intel.com") by vger.kernel.org with ESMTP
	id S262448AbVGLW5X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 18:57:23 -0400
Received: from scsfmr101.sc.intel.com (scsfmr101.sc.intel.com [10.3.253.10])
	by scsfmr001.sc.intel.com (8.12.10/8.12.10/d: major-outer.mc,v 1.1 2004/09/17 17:50:56 root Exp $) with ESMTP id j6CMvLMD017870
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2005 22:57:21 GMT
Received: from unix-os.sc.intel.com (unix-os.sc.intel.com [172.25.110.7])
	by scsfmr101.sc.intel.com (8.12.10/8.12.10/d: major-inner.mc,v 1.2 2004/09/17 18:05:01 root Exp $) with ESMTP id j6CMoA11029467
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2005 22:50:10 GMT
Received: from kwchenmobl1 (kwchen-mobl1.amr.corp.intel.com [143.183.251.71])
	by unix-os.sc.intel.com (8.11.6/8.11.2) with ESMTP id j6CMvHg07091
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2005 15:57:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I was going over the scsi I/O submit path, when sd_init_command
construct the scsi command, this_count is already checked in the
previous else if clause.  Why does it need to check it again in
the last else block?

Patch to delete the spurious check.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>


--- linux-2.6.12/drivers/scsi/sd.c.orig	2005-07-12 15:48:57.545822227 -0700
+++ linux-2.6.12/drivers/scsi/sd.c	2005-07-12 15:51:37.109296835 -0700
@@ -373,9 +373,6 @@ static int sd_init_command(struct scsi_c
 		SCpnt->cmnd[7] = (unsigned char) (this_count >> 8) & 0xff;
 		SCpnt->cmnd[8] = (unsigned char) this_count & 0xff;
 	} else {
-		if (this_count > 0xff)
-			this_count = 0xff;
-
 		SCpnt->cmnd[1] |= (unsigned char) ((block >> 16) & 0x1f);
 		SCpnt->cmnd[2] = (unsigned char) ((block >> 8) & 0xff);
 		SCpnt->cmnd[3] = (unsigned char) block & 0xff;



