From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 62811] New: Don't Modify the scsi subcmd as LUN value when
 using VENDOR cmd
Date: Thu, 10 Oct 2013 21:38:55 +0400
Message-ID: <1381426735.2109.4.camel@dabdike>
References: <bug-62811-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46328 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756227Ab3JJRi7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Oct 2013 13:38:59 -0400
In-Reply-To: <bug-62811-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2013-10-10 at 17:22 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=62811
> 
>             Bug ID: 62811
>            Summary: Don't Modify the scsi subcmd as LUN value when using
>                     VENDOR cmd
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 3.12rc4
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>           Reporter: yilikernel@gmail.com
>         Regression: No
> 
> Using the VENDOR scsi cmd, We should not to modify the cmd->cmnd [1] as lun
> value. it is useful as a subcmd for USB device, such as STEC usb device.
> 
>  Signed-off-by: Yi Li <yilikernel@gmail.com>
> 
> --- linux/drivers/scsi/scsi.c_orig 2013-09-12 01:51:45.000000000 -0400
> +++ linux/drivers/scsi/scsi.c 2013-09-12 01:59:24.000000000 -0400
> @@ -83,6 +83,9 @@ static void scsi_done(struct scsi_cmnd *
>  /* Do not call reset on error if we just did a reset within 15 sec. */
>  #define MIN_RESET_PERIOD (15*HZ)
> 
> +/* Define a SCSI command VENDOR to get device info For STEC USB devcie */
> +#define STECUSB_VENDOR_CMD_CODE 0xD8
> +
>  /*
>  * Note - the initial logging level can be set here to log events at boot time.
>  * After the system is up, you may enable logging via the /proc interface.
> @@ -700,8 +703,13 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
>  */
>  if (cmd->device->scsi_level <= SCSI_2 &&
>  cmd->device->scsi_level != SCSI_UNKNOWN) {
>  - cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
> - (cmd->device->lun << 5 & 0xe0);
> + /*
> + * Don't Modify the cmnd[1] as LUN value when it is a VENDOR CMD
> + * for STEC disk.
>  + */
> + if (STECUSB_VENDOR_CMD_CODE != cmd->cmnd[0])
> + cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
> + (cmd->device->lun << 5 & 0xe0);

This patch is mangled, so it can't be applied (I'm guessing by bugzilla,
so next time just send directly to the SCSI mailing list).

The patch isn't the way we do things: if there's a problem, we usually
add a quirk (either in USB or SCSI) and a flag.

However, looking at what you're trying to do, it seems that your device
is reporting SCSI_2, which mandates in the standard the setting of the
LUN in the first byte of the CDB.  What are these vendor commands you're
trying to send that are out of spec?  Should your device be reporting
compliance with a SCSI level > 2?

James


