From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: 09 Jun 2004 12:29:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086805796.3741.5.camel@patibmrh9>
References: <1086710016.3647.4.camel@patibmrh9><20040609080013.GS13836@suse
	.de>  <20040609082045.GT13836@suse.de><1086798154.7074.24.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:30387 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265906AbUFISaJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2004 14:30:09 -0400
In-Reply-To: <1086798154.7074.24.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Jens A:

> a) kernel.org 2.6.7-rc3 plus the patch of this thread,
> b) PATAPI drive connected as /dev/hdd,
> c) open of /dev/hdd with flags O_NONBLOCK|O_RDWR, ioctl SG_IO
> d) cdb = x 1B 00:00:00 00 00 // Stop
> e) cdb = x 1B 00:00:00 01 00 // Start

Yes now "Hn" (i.e. expecting no data) works here, every time I try.

Cool instant demo of how helpful linux-scsi folk are, thank you.

> For data transfer, it's more tricky. Well actually, if you restrict
> yourself to non-bio backed request, then it becomes pretty trivial!
> ide-floppy expects a contig buffer, a bio is scattered by nature.

Yes "Hi" (i.e. expecting data in) gives me zeroes.

> ...

Also something's broken (far far outside of the kernel) in plscsi.  I
found success only by patching the trivial sgio.c that I posted in this
thread, as shown below.

Pat LaVarre

--- sgio.c	2004-06-08 09:33:33.000000000 -0600
+++ sgio-up.c	2004-06-09 12:23:28.901649448 -0600
@@ -17,14 +17,14 @@ static void populate(sg_io_hdr_t * sih)
 	memset(&static_cdb, '\0', sizeof static_cdb);
 	sih->cmdp = static_cdb;
 	sih->cmd_len = 6;
-	memcpy(sih->cmdp, "\x12\0\0\0\x24\0", sih->cmd_len);
+	memcpy(sih->cmdp, "\x1B\0\0\0\x01\0", sih->cmd_len);
 
 	memset(&static_data, '\0', sizeof static_data);
 	sih->dxferp = static_data;
-	sih->dxfer_len = 0x24;
-	sih->dxfer_direction = SG_DXFER_NONE;
+	sih->dxfer_len = 0x00;
 	sih->dxfer_direction = SG_DXFER_TO_DEV;
 	sih->dxfer_direction = SG_DXFER_FROM_DEV;
+	sih->dxfer_direction = SG_DXFER_NONE;
 
 	memset(&static_sense, '\0', sizeof static_sense);
 	sih->sbp = static_sense;
--- sgio-up.c	2004-06-09 12:23:28.901649448 -0600
+++ sgio-dn.c	2004-06-09 12:23:58.069215304 -0600
@@ -17,7 +17,7 @@ static void populate(sg_io_hdr_t * sih)
 	memset(&static_cdb, '\0', sizeof static_cdb);
 	sih->cmdp = static_cdb;
 	sih->cmd_len = 6;
-	memcpy(sih->cmdp, "\x1B\0\0\0\x01\0", sih->cmd_len);
+	memcpy(sih->cmdp, "\x1B\0\0\0\x00\0", sih->cmd_len);
 
 	memset(&static_data, '\0', sizeof static_data);
 	sih->dxferp = static_data;


