From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [REPOST][PATCH] FC transport : Avoid device offline cases by
	stalling aborts until device unblocked
Date: Sun, 12 Mar 2006 08:15:56 -0600
Message-ID: <1142172957.3297.10.camel@mulgrave.il.steeleye.com>
References: <43E8B19F.8050006@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:23761 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750743AbWCLOQE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Mar 2006 09:16:04 -0500
In-Reply-To: <43E8B19F.8050006@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-02-07 at 09:41 -0500, James Smart wrote:
> Following the recommendation from Christoph....
> 
> This moves the eh_timed_out functionality from the scsi_host_template
> to the transport_template. Given that this is now a transport function,
> the EH_RESET_TIMER case no longer caps the timer reschedulings. The
> transport guarantees that this is not an infinite condition.
> 
> This patch is dependent upon Christoph's change of:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113923531412919&w=2

Your patch won't apply.

It looks like this:

> @@ -29,6 +29,7 @@
>   #include <scsi/scsi_dbg.h>
>   #include <scsi/scsi_device.h>
>   #include <scsi/scsi_eh.h>
> +#include <scsi/scsi_transport.h>
>   #include <scsi/scsi_host.h>
>   #include <scsi/scsi_ioctl.h>
>   #include <scsi/scsi_request.h>

is the problem ... for some reason there are two extra spaces in the
lines surrounding the context diffs.

James


