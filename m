From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Oops unplugging USB stick
Date: 13 May 2004 11:39:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084466344.2066.24.camel@mulgrave>
References: <200405131803.52676.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:47338 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264288AbUEMQjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 12:39:08 -0400
In-Reply-To: <200405131803.52676.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: usb-storage@lists.one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Thu, 2004-05-13 at 11:03, Oliver Neukum wrote:
> May 13 16:48:20 macbeth kernel: usb 1-1: USB disconnect, address 2
> May 13 16:48:20 macbeth kernel: sd 1:0:0:0: Illegal state transition offline->cancel
> May 13 16:48:20 macbeth kernel: Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1640
> May 13 16:48:20 macbeth kernel: Call Trace:
> May 13 16:48:20 macbeth kernel:  [<c0304bda>] scsi_device_set_state+0xea/0x140
[...]

That's not actually an oops, it's just a warning that there's an error
in the state model....the machine proceeded normally after the messages
appeared, didn't it?  Actually, this one looks to be a residual of the
fix to a previous problem.  Does the attached make the message go away?

James

===== drivers/scsi/scsi_lib.c 1.126 vs edited =====
--- 1.126/drivers/scsi/scsi_lib.c	Wed Mar 31 16:32:26 2004
+++ edited/drivers/scsi/scsi_lib.c	Thu May 13 11:35:39 2004
@@ -1610,7 +1610,9 @@
 
 	case SDEV_CANCEL:
 		switch (oldstate) {
+		case SDEV_CREATED:
 		case SDEV_RUNNING:
+		case SDEV_OFFLINE:
 			break;
 		default:
 			goto illegal;
@@ -1619,9 +1621,7 @@
 
 	case SDEV_DEL:
 		switch (oldstate) {
-		case SDEV_CREATED:
 		case SDEV_CANCEL:
-		case SDEV_OFFLINE:
 			break;
 		default:
 			goto illegal;

