From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: possible bug in rmmod scsi controllers?
Date: Thu, 10 Jun 2004 12:53:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040610195304.GA7182@us.ibm.com>
References: <DB7891DD5641F14391475AFFF42568F50551A25E@azsmsx407>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:43693 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262772AbUFJTxF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 15:53:05 -0400
Content-Disposition: inline
In-Reply-To: <DB7891DD5641F14391475AFFF42568F50551A25E@azsmsx407>
List-Id: linux-scsi@vger.kernel.org
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: linux-scsi@vger.kernel.org, "Boji T Kannanthanam (Kannanthanam, Boji T)" <boji.t.kannanthanam@intel.com>

Jiang, Dave [dave.jiang@intel.com] wrote:
> While playing around with scsi_debug on 2.6.7-rc3, I noticed that
> whenever I rmmod scsi_debug, the sync cache command always fails. After
> a little looking around it seems that whenever scsi_remove_host() is
> called, the host state is set to SHOST_CANCEL. If the disk is configured
> as write-back cache, then a SYNCH_CACHE command is issued. However, in
> scsi_dispatch_cmd() function in scsi.c a check is done to see if
> SHOST_CANCEL state is set and if so the command is rejected. Therefore
> the sync cache command always fails during unload. Something such as
> below fixes the problem:
> 
> --- scsi.c.old	2004-06-10 10:43:02.478538016 -0700
> +++ scsi.c	2004-06-10 10:41:52.627157040 -0700
> @@ -576,7 +576,8 @@
>  	}
>  
>  	spin_lock_irqsave(host->host_lock, flags);
> -	if (unlikely(test_bit(SHOST_CANCEL, &host->shost_state))) {
> +	if (unlikely(test_bit(SHOST_CANCEL, &host->shost_state)) &&
> +			unlikely(cmd->device->sdev_state == SDEV_DEL)) {
>  		cmd->result = (DID_NO_CONNECT << 16);
>  		scsi_done(cmd);
>  	} else {
> 
> However, this is a quick hack and I'm sure there are better ways to do
> this. There was a similar issue on 2.6.5 with the device state that was
> fixed in 2.6.6 which exposed this issue. 
> 

This is something we should try and fix, but the change here would allow
more command to flow to a scsi host in cases of unexpected disconnect
where we may not want them.

Currently right now with the scsi_remove_host call there is no way to
know that a host is being removed cleanly (i.e., rmmod) or that it is
being removed for a unexpected disconnect where it wishes no more IOs to
be sent.

I do not have a counter proposal at this time. If the LLDD could
differentiate these two cases we could possibly export and have the LLDD
use the scsi_forget_host function to remove child devices prior to
calling scsi_remove_host in the clean (rmmod) cases. There would need to
be more work if we wanted to address possible race issues of someone
trying to add a device at the sametime a rmmod was happening.

-andmike
--
Michael Anderson
andmike@us.ibm.com

