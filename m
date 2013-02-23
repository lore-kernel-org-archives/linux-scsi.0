From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Sat, 23 Feb 2013 10:31:11 +0100
Message-ID: <51288C5F.1080802@suse.de>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B402950D7A4E0@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab3BWIbW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Feb 2013 03:31:22 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950D7A4E0@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Bart Van Assche <bvanassche@acm.org>

On 02/21/2013 05:15 PM, Elliott, Robert (Server Storage) wrote:
> Regarding changes like this:
> -			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%d] "
> +			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%llu] "
>   			"FCP_ResponseInfo=%08xh\n", ioc->name,
>   			sc->device->host->host_no, sc->device->channel,
>   			sc->device->id, sc->device->lun,
>
> It might be preferable to print the LUN values in hex rather than decimal,
 > particularly if they are large values.  SAM-5 includes some guidance for
 > displaying LUNs, shown below.
>
> One important goal is to match the format, if any, that the user must use
 > in a configuration file or command line argument, so cutting-and-pasting
 > the LUN value works.  So, the answer might differ for prints from 
different
 > drivers.  If a driver expects decimal input values, then print decimal.
>
Yes. And no.

The patchset is meant to be as a drop-in replacement, ie with _no_ user 
visible changes.
So I retained the original output.

Also, the above number is identical to the sysfs representation, where
the user will find a device like

/sys/class/scsi_device/X:Y:Z:L

with each X, Y, Z, and L being a decimal number.

_If_ we were to change that we would have to do it consistently for all 
instances, plus the sysfs layout.

But I guess we need to have a discussion about this, as I think not 
everybody agrees with that assessment.

Would be a nice topic for LSF, though.

Cheers,

Hannes

