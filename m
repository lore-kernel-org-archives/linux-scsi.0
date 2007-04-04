From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 3/4] [SCSI]stex: fix reset recovery for console device
Date: Wed, 4 Apr 2007 10:31:42 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F0327ED0D@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:62716 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980AbXDDRaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 13:30:05 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>



> -----Original Message-----
> From: Ed Lin 
> Sent: Monday, April 02, 2007 4:02 PM
> To: James Bottomley
> Cc: linux-scsi; linux-kernel; jeff; Promise_Linux
> Subject: RE: [PATCH 3/4] [SCSI]stex: fix reset recovery for 
> console device
> 
> 
> 
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> > Sent: Monday, April 02, 2007 11:28 AM
> > To: Ed Lin
> > Cc: linux-scsi; linux-kernel; jeff; Promise_Linux
> > Subject: RE: [PATCH 3/4] [SCSI]stex: fix reset recovery for 
> > console device
> > 
> > 
> > On Mon, 2007-04-02 at 11:14 -0700, Ed Lin wrote:
> > > I just saw the routine name scsi_eh_try_stu, and didn't notice the
> > > allow_restart (partly because I thought it was not harmful...).
> > > But the TEST_UNIT_READY must stay.
> > 
> > Sure ... I was just checking since your change log implied 
> you'd seen
> > the problem from the error handler ... however, we can add it ...
> > there's a possibility of getting spin up on init from sd anyway.
> > 
> 
> You make the decision. But after reconsideration, I think it's better
> to remove unused code. It also needs change since the patch about
> id mapping is modified in another mail.
> 
> How about the attachment here?
>

Sorry. I think the mail server has problem with attachment. The patch
is here in plain text. Sorry for the inconvenience. I have problem with
linux-scsi mail list, if you have comment please cc me. Thanks.
--Ed Lin




After reset completed, the scsi error handler sends out TEST_UNIT_READY
to
the device. For 'normal' devices this command will be handled by
firmware.
However, because the RAID console only interfaces to scsi mid layer, the
firmware will not process this command for it. This will make the
console
to be offlined right after reset. Add the handling in driver to fix this
problem.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 4c6ce6a..85c779b 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -601,6 +601,13 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 			stex_invalid_field(cmd, done);
 		return 0;
 	}
+	case TEST_UNIT_READY:
+		if (id == host->max_id - 1) {
+			cmd->result = DID_OK << 16 | COMMAND_COMPLETE <<
8;
+			done(cmd);
+			return 0;
+		}
+		break;
 	case INQUIRY:
 		if (id != host->max_id - 1)
 			break; 
