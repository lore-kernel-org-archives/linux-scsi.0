From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset
 to MegaRAID SAS driver
Date: Sun, 05 Sep 2010 15:04:10 -0300
Message-ID: <1283709850.15944.1277.camel@mulgrave.site>
References: <AANLkTiktJycDkXu+FHQanTNe-djvvTe9V=9KfSkLcXZd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab0IESET (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Sep 2010 14:04:19 -0400
In-Reply-To: <AANLkTiktJycDkXu+FHQanTNe-djvvTe9V=9KfSkLcXZd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <boyang1288@gmail.com>
Cc: bo.yang@lsi.com, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, jayant.Daftardar@lsi.com

On Wed, 2010-08-11 at 16:45 -0400, bo yang wrote:
> To add the Online Controller Reset  (OCR) support, driver need to do:
> 		a). reset the controller chips -- Xscale and Gen2 which will change
> the function calls and add the reset function
> 		related to this two chips.
> 		
> 		b). during the reset, driver will store the pending cmds which not
> returned by FW to driver's pending queue.  Driver
> 		will re-issue those pending cmds again to FW after the OCR finished.
> 		
> 		c). In driver's timeout routine, driver will report to OS as reset.
> Also driver's queue routine will block the
> 		cmds until the OCR finished.
> 		
> 		d). in Driver's ISR routine, if driver get the FW state as state
> change, FW in Failure status and FW support online controller
> 		reset (OCR), driver will start to do the controller reset.
> 		
> 		e). In driver's IOCTL routine, the application cmds will wait for
> the OCR to finish, then issue the cmds to FW.
> 
> Signed-off-by Bo Yang<bo.yang@lsi.com>

This patch is full of line breaks which prevent application, like this
one:

> diff -rupN old/Documentation/scsi/ChangeLog.megaraid_sas
> new/Documentation/scsi/ChangeLog.megaraid_sas
> --- old/Documentation/scsi/ChangeLog.megaraid_sas	2010-08-10
> 04:58:36.000000000 -0400
> +++ new/Documentation/scsi/ChangeLog.megaraid_sas	2010-08-10
> 04:56:30.000000000 -0400
> @@ -1,3 +1,36 @@
> +1 Release Date    : Thur.  May 03, 2010 09:12:45 PST 2009 -
> +			(emaild-id:megaraidlinux@lsi.com)
> +			Bo Yang
[snip]

and this one
> diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c
> new/drivers/scsi/megaraid/megaraid_sas.c
> --- old/drivers/scsi/megaraid/megaraid_sas.c	2010-08-10 04:55:41.000000000 -0400
> +++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-08-10 04:56:30.000000000 -0400
> @@ -107,6 +107,12 @@ static void
>  megasas_complete_cmd(struct megasas_instance *instance, struct
> megasas_cmd *cmd,
>  		     u8 alt_status);

Since not every long line is broken, this looks like some type of cut
and paste error ... anyway, could you fix it up, please?

Thanks,

James


