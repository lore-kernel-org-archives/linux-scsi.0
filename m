From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] add missing free sgtable in scsi_init_io error path
Date: Wed, 03 Mar 2004 22:24:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4046CB9D.1010602@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090908080709000407090900"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39693 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261473AbUCDGYh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2004 01:24:37 -0500
Received: from cs.wisc.edu ([199.108.226.254])
	(authenticated (0 bits))
	by sabe.cs.wisc.edu (8.11.3/8.11.3) with ESMTP id i246OTO09606
	(using TLSv1/SSLv3 with cipher RC4-MD5 (128 bits) verified NO)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Mar 2004 00:24:36 -0600
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090908080709000407090900
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I was testing different errors while running multipath, and becuase of a 
bug in dm-multiapth I hit the "Incorrect number of segments after 
building list" error. The attached patch just adds a missing 
scsi_release_buffers() at the bottom of the scsi_init_io where the table 
was allocated successfully, but you can return BLKPREP_KILL when someone 
messes up segment counts.

Mike Christie

--------------090908080709000407090900
Content-Type: text/plain;
 name="sgfree.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sgfree.patch"

--- linux-2.6.4-rc1-orig/drivers/scsi/scsi_lib.c	2004-02-27 14:21:02.000000000 -0800
+++ linux-2.6.4-rc1-scsi/drivers/scsi/scsi_lib.c	2004-03-03 00:22:31.030243228 -0800
@@ -917,6 +917,7 @@ static int scsi_init_io(struct scsi_cmnd
 			req->current_nr_sectors);
 
 	/* release the command and kill it */
+	scsi_release_buffers(cmd);
 	scsi_put_command(cmd);
 	return BLKPREP_KILL;
 }

--------------090908080709000407090900--

