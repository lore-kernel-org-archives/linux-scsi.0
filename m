From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Myson Century USB enclosure problem
Date: Sat, 19 Nov 2005 20:52:21 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511192041510.23404-100000@netrider.rowland.org>
References: <20051119205222.GA3851@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-users-admin@lists.sourceforge.net>
In-Reply-To: <20051119205222.GA3851@one-eyed-alien.net>
Sender: linux-usb-users-admin@lists.sourceforge.net
Errors-To: linux-usb-users-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
To: Chuan-kai Lin <cklin@cs.pdx.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB users list <linux-usb-users@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 19 Nov 2005, Matthew Dharm wrote:

> Do you have MD or other advanced partition features turned on?  If so,
> turning them off might help.
> 
> Matt

That could well help, but it doesn't solve the underlying problem.  I've
thought for a long time that this could bite someone, but it's the first 
time I've seen an actual example.

When asked to read the last 8 sectors on the disk, your drive returned all
but the last 64 bytes of data and then for some reason complained that the
command was invalid (it wasn't).  The SCSI core retried exactly the same
command, and the second time it succeeded.  But meanwhile the SCSI core
thought the error message indicated that the drive prefers 6-byte
READ/WRITE commands instead of the ususal 10-byte form.  So it switched
over to using 6-byte commands, and from then on the drive didn't work at
all.

The patch below is a first step toward correcting the problem.  It makes 
the SCSI core revert back to using the 10-byte commands when the 6-byte 
version gets an error.  This isn't a final solution, because there's a 
possibility it could lead to an infinite retry loop if the drive doesn't 
like either the 6- or 10-byte command form.  But at least it's a start.

Alan Stern


--- a/drivers/scsi/scsi_lib.c	Mon Nov 14 09:46:18 2005
+++ b/drivers/scsi/scsi_lib.c	Sat Nov 19 20:40:13 2005
@@ -894,6 +894,16 @@
 				 */
 				scsi_requeue_command(q, cmd);
 				result = 0;
+			} else if (!cmd->device->use_10_for_rw &&
+			    (cmd->cmnd[0] == READ_6 ||
+			     cmd->cmnd[0] == WRITE_6)) {
+				cmd->device->use_10_for_rw = 1;
+				/*
+				 * This will cause a retry with a 10-byte
+				 * command.
+				 */
+				scsi_requeue_command(q, cmd);
+				result = 0;
 			} else {
 				scsi_end_request(cmd, 0, this_count, 1);
 				return;



-------------------------------------------------------
This SF.Net email is sponsored by the JBoss Inc.  Get Certified Today
Register for a JBoss Training Course.  Free Certification Exam
for All Training Attendees Through End of 2005. For more info visit:
http://ads.osdn.com/?ad_id=7628&alloc_id=16845&op=click
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
