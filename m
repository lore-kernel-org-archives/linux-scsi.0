From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to
 MegaRAID SAS driver
Date: Wed, 15 Sep 2010 14:06:24 -0400
Message-ID: <1284573984.8296.83.camel@mulgrave.site>
References: <AANLkTineJ0dFcqi5v1h75EYgpBOSqvHsSSTi=VJWsjM0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTineJ0dFcqi5v1h75EYgpBOSqvHsSSTi=VJWsjM0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bo yang <boyang1288@gmail.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, bo.yang@lsi.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-09-07 at 13:08 -0400, bo yang wrote:
> Re-Submit:

This still doesn't apply:

> To add the OCR support, driver need to do:
> 		a). reset the controller chips -- Xscale and Gen2 which
> 		will change the function calls and add the reset function
> 		related to this two chips.
> 		
> 		b). during the reset, driver will store the pending cmds
> 		which not returned by FW to driver's pending queue.  Driver
> 		will re-issue those pending cmds again to FW after the OCR
> 		finished.
> 		
> 		c). In driver's timeout routine, driver will report to
> 		OS as reset. Also driver's queue routine will block the
> 		cmds until the OCR finished.
> 		
> 		d). in Driver's ISR routine, if driver get the FW state as
> 		state change, FW in Failure status and FW support online controller
> 		reset (OCR), driver will start to do the controller reset.
> 		
> 		e). In driver's IOCTL routine, the application cmds will wait for the
> 		OCR to finish, then issue the cmds to FW.
> 
> Signed-off-by Bo Yang<bo.yang@lsi.com>
> 
> ---
>  Documentation/scsi/ChangeLog.megaraid_sas |   33 +
>  drivers/scsi/megaraid/megaraid_sas.c      |  761 +++++++++++++++++++++++++++---
>  drivers/scsi/megaraid/megaraid_sas.h      |   88 +++
>  3 files changed, 823 insertions(+), 59 deletions(-)
> diff -rupN old/Documentation/scsi/ChangeLog.megaraid_sas
> new/Documentation/scsi/ChangeLog.megaraid_sas
> --- old/Documentation/scsi/ChangeLog.megaraid_sas	2010-09-06
> 03:13:15.000000000 -0400
> +++ new/Documentation/scsi/ChangeLog.megaraid_sas	2010-09-06
> 04:48:10.000000000 -0400

This set of lines is still broken

> @@ -1,3 +1,36 @@
> +1 Release Date:	Thur.  May 03, 2010 09:12:45 PST 2009 -
> +			(emaild-id:megaraidlinux@lsi.com)
> +			Bo Yang
> +
> +2 Current Version : 00.00.04.17.1-rc1
> +3 Older Version   : 00.00.04.17.1-rc1
> +
> +1.	Add the Online Controller Reset (OCR) to the Driver.
> +	OCR is the new feature for megaraid_sas driver which
> +	will allow the fw to do the chip reset which will not
> +	affact the OS behavious.
> +
> +	To add the OCR support, driver need to do:
> +		a). reset the controller chips -- Xscale and Gen2 which
> +		will change the function calls and add the reset function
> +		related to this two chips.
> +		
> +		b). during the reset, driver will store the pending cmds
> +		which not returned by FW to driver's pending queue.  Driver
> +		will re-issue those pending cmds again to FW after the OCR
> +		finished.
> +		
> +		c). In driver's timeout routine, driver will report to
> +		OS as reset. Also driver's queue routine will block the
> +		cmds until the OCR finished.
> +		
> +		d). in Driver's ISR routine, if driver get the FW state as
> +		state change, FW in Failure status and FW support online controller
> +		reset (OCR), driver will start to do the controller reset.
> +		
> +		e). In driver's IOCTL routine, the application cmds will wait for the
> +		OCR to finish, then issue the cmds to FW.
> +		
>  1 Release Date    : Thur.  Oct 29, 2009 09:12:45 PST 2009 -
>  			(emaild-id:megaraidlinux@lsi.com)
>  			Bo Yang
> diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c
> new/drivers/scsi/megaraid/megaraid_sas.c
> --- old/drivers/scsi/megaraid/megaraid_sas.c	2010-09-06 03:13:15.000000000 -0400
> +++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-09-06 03:17:11.000000000 -0400
> @@ -104,8 +104,14 @@ static u32 megasas_dbg_lvl;
>  spinlock_t poll_aen_lock;
> 
>  static void
> -megasas_complete_cmd(struct megasas_instance *instance, struct
> megasas_cmd *cmd,

As is this.

You can check this yourself: just try to apply the patch you get back
from the mailing list.

James
