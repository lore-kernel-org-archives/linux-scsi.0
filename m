From: Willem Riede <wrlk@riede.org>
Subject: Re: ide-scsi oops
Date: Mon, 23 Dec 2002 16:39:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021223213913.GQ7990@linnie.riede.org>
References: <3E07710C.4010300@splentec.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="iFRdW5/EC4oqxDHL"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E07710C.4010300@splentec.com>; from luben@splentec.com on Mon, Dec 23, 2002 at 15:24:44 -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 2002.12.23 15:24 Luben Tuikov wrote:
> kernel 2.5.52 + Willem's patch, at boot:
> ----------------------------------------
> 
> scsi2 : SCSI host adapter emulation for IDE ATAPI devices
>    Vendor: SONY      Model: CDU5211           Rev: YYS2
>    Type:   CD-ROM                             ANSI SCSI revision: 02
> ide-scsi: abort called for 40
> Unable to handle kernel NULL pointer dereference at virtual address 00000030

The only place I can think of that might do that is:

--- ide-scsi.c-rev.1	Sat Dec 21 17:32:48 2002
+++ ide-scsi.c	Mon Dec 23 16:31:19 2002
@@ -289,6 +289,7 @@
 	pc->timeout = jiffies + WAIT_READY;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
 	rq->buffer = (void *) failed_command->special;
+	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
 		hexdump(pc->c, 6);
@@ -876,7 +877,8 @@
 			/* is cmd active?
 			 *  need to lock so this stuff doesn't change under us */
 			spin_lock_irqsave(&ide_lock, flags);
-			if (scsi->pc && scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
+			if (scsi->pc && scsi->pc->scsi_cmd && 
+					scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
 				/* yep - let's give it some more time - 
 				 * we can do that, we're in _our_ error kernel thread */
 				spin_unlock_irqrestore(&ide_lock, flags);

Thanks for testing. Willem Riede.
--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rev1.patch"

--- ide-scsi.c-rev.1	Sat Dec 21 17:32:48 2002
+++ ide-scsi.c	Mon Dec 23 16:31:19 2002
@@ -289,6 +289,7 @@
 	pc->timeout = jiffies + WAIT_READY;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
 	rq->buffer = (void *) failed_command->special;
+	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
 		hexdump(pc->c, 6);
@@ -876,7 +877,8 @@
 			/* is cmd active?
 			 *  need to lock so this stuff doesn't change under us */
 			spin_lock_irqsave(&ide_lock, flags);
-			if (scsi->pc && scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
+			if (scsi->pc && scsi->pc->scsi_cmd && 
+					scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
 				/* yep - let's give it some more time - 
 				 * we can do that, we're in _our_ error kernel thread */
 				spin_unlock_irqrestore(&ide_lock, flags);

--iFRdW5/EC4oqxDHL--
