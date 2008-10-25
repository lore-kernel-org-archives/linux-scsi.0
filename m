From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Sat, 25 Oct 2008 15:11:33 -0500
Message-ID: <1224965493.3449.7.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0810251548300.7245-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51321 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbYJYULh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Oct 2008 16:11:37 -0400
In-Reply-To: <Pine.LNX.4.44L0.0810251548300.7245-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Luciano Rocha <luciano@eurotux.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-Kernel <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 2008-10-25 at 15:50 -0400, Alan Stern wrote:
> On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:
> 
> > [Adding CCs]
> > 
> > On Wednesday, 22 of October 2008, Luciano Rocha wrote:
> > > 
> > > Hello,
> > > 
> > > An external HDD, usb-encased, works fine under 2.6.26.5, but under
> > > 2.6.27.2 I get hundreds of errors per second, of 'No Sense [current]'.
> 
> You can use usbmon to capture the details of what happens when you plug
> in the drive.  Instructions are in the kernel source file
> Documentation/usb/usbmon.txt.

Try reversing this patch (apply with patch -p1 -R)

James

---

commit 10dab22664914505dcb804d9ad09cad6bc94d349
Author: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Date:   Thu Sep 11 21:39:36 2008 -0400

    [SCSI] sd: Fix handling of NO_SENSE check condition
    
    The current handling of NO_SENSE check condition is the same as
    RECOVERED_ERROR, and assumes that in both cases, the I/O was fully
    transferred.
    
    We have seen cases of arrays returning with NO_SENSE (no error), but
    the I/O was not completely transferred, thus residual set.  Thus,
    rather than return good_bytes as the entire transfer, set good_bytes
    to 0, so that the midlayer then applies the residual in calculating
    the transfer, and for sd, will fail the I/O and fall into a retry
    path.
    
    Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7c4d2e6..55e6ed4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1054,7 +1054,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		good_bytes = sd_completed_bytes(SCpnt);
 		break;
 	case RECOVERED_ERROR:
-	case NO_SENSE:
 		/* Inform the user, but make sure that it's not treated
 		 * as a hard error.
 		 */
@@ -1063,6 +1062,15 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		good_bytes = scsi_bufflen(SCpnt);
 		break;
+	case NO_SENSE:
+		/* This indicates a false check condition, so ignore it.  An
+		 * unknown amount of data was transferred so treat it as an
+		 * error.
+		 */
+		scsi_print_sense("sd", SCpnt);
+		SCpnt->result = 0;
+		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+		break;
 	case ABORTED_COMMAND:
 		if (sshdr.asc == 0x10) { /* DIF: Disk detected corruption */
 			scsi_print_result(SCpnt);


