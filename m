From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ide-scsi oops
Date: Tue, 24 Dec 2002 10:47:40 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E07A09C.60800@torque.net>
References: <3E07710C.4010300@splentec.com> <20021223213913.GQ7990@linnie.riede.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

Willem Riede wrote:
> On 2002.12.23 15:24 Luben Tuikov wrote:
> 
>>kernel 2.5.52 + Willem's patch, at boot:
>>----------------------------------------
>>
>>scsi2 : SCSI host adapter emulation for IDE ATAPI devices
>>   Vendor: SONY      Model: CDU5211           Rev: YYS2
>>   Type:   CD-ROM                             ANSI SCSI revision: 02
>>ide-scsi: abort called for 40
>>Unable to handle kernel NULL pointer dereference at virtual address 00000030
> 
> 
> The only place I can think of that might do that is:
> 
> --- ide-scsi.c-rev.1	Sat Dec 21 17:32:48 2002
> +++ ide-scsi.c	Mon Dec 23 16:31:19 2002
> @@ -289,6 +289,7 @@
>  	pc->timeout = jiffies + WAIT_READY;
>  	/* NOTE! Save the failed packet command in "rq->buffer" */
>  	rq->buffer = (void *) failed_command->special;
> +	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
>  	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
>  		printk ("ide-scsi: %s: queue cmd = ", drive->name);
>  		hexdump(pc->c, 6);
> @@ -876,7 +877,8 @@
>  			/* is cmd active?
>  			 *  need to lock so this stuff doesn't change under us */
>  			spin_lock_irqsave(&ide_lock, flags);
> -			if (scsi->pc && scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
> +			if (scsi->pc && scsi->pc->scsi_cmd && 
> +					scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
>  				/* yep - let's give it some more time - 
>  				 * we can do that, we're in _our_ error kernel thread */
>  				spin_unlock_irqrestore(&ide_lock, flags);


Willem,
I used sg_reset (in sg3_utils, see www.torque.net/sg) to
do a device reset on my ATAPI cdrom with your above patch
applied (and after my hack to scsi_error.c).

It seemed to work but there was a bit of noise from the
ide subsystem. Perhaps it was assuming that a stuck
command was the cause of the device reset.

$ sg_reset -d /dev/sg1
sg_reset: starting device reset
ide-scsi: reset called for 0
sg_reset: completed device reset
[root@frig root]# hdd: ide_timer_expiry: hwgroup->busy was 0 ??
hdd: ATAPI reset complete


My "scsi" devices:
$ lsscsi
[0:0:8:0]    disk    FUJITSU  MAM3184MP        0105  /dev/sda
[2:0:0:0]    CDROM   CREATIVE CD5233E          1.00  /dev/sr0


BTW Perhaps /sys/block (i.e. sysfs) should use "scd" rather
than "sr" for SCSI cdroms.


Doug Gilbert

