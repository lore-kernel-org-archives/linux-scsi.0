From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: 09 Jun 2004 12:51:23 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086807083.3741.21.camel@patibmrh9>
References: <1086710016.3647.4.camel@patibmrh9><20040609080013.GS13836@suse
	.de>  <20040609082045.GT13836@suse.de><1086798154.7074.24.camel@patibmrh9>
	 <1086805796.3741.5.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:52662 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265907AbUFISve
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2004 14:51:34 -0400
In-Reply-To: <1086805796.3741.5.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

> Also something's broken (far far outside of the kernel) in plscsi.  I
> found success only by patching the trivial sgio.c that I posted in this
> thread, as shown below.

Ah. That is, despite the patch inserting idefloppy_blockpc_cmd,

ioctl(fd, SG_GET_VERSION_NUM, &vn) returns negative.

Pat LaVarre

P.S. More specifically,

plscsi, with perhaps excessively paranoid automagic, therefore chose not
to try 2.4 style ioctl SG_IO, complaining:

// sgioOpen.ioctl: Invalid argument
// plscsi.sclOpenNext: "/dev/hdd" not opened

By contrast, my back-of-the-envelope sgio.c was quietly stepping past
this trouble without complaint, in fact requiring vn at or beyond 30,000
only from devices that do support ioctl fd SG_GET_VERSION &vn.  The
trivial patch to get that fragment of code to behave as sensitively as
plscsi is of course:

--- sgio.was.c	2004-06-08 09:33:33.000000000 -0600
+++ sgio.c	2004-06-09 12:43:16.899046392 -0600
@@ -61,12 +61,15 @@ int main(int argc, char * argv[])
 	--argc; ++argv;
 	for (ix = 0; ix < argc; ++ix)
 	{
-		int fd = open(argv[ix], O_NONBLOCK|O_RDWR);
+		int fd = open(argv[ix], O_NONBLOCK);
 		if (fd < 0) {
 			perror("open");
 		} else {
 			int vn = 0;
-			if (0 <= ioctl(fd, SG_GET_VERSION_NUM, &vn)) {
+			if (ioctl(fd, SG_GET_VERSION_NUM, &vn) < 0) {
+				perror("ioctl SG_GET_VERSION_NUM");
+				; /* fallthru to talk anyhow */
+			} else {
 				if (vn < 30000) {
 					perror("ioctl SG_GET_VERSION_NUM");
 					continue;


