From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Fix miscalculation of sg_io timeout in
	CDROM_SEND_PACKET handler.
Date: Wed, 30 Jul 2008 10:18:53 -0500
Message-ID: <1217431134.3335.15.camel@localhost.localdomain>
References: <488D17DE.5000801@splhi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49874 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbYG3PS7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 11:18:59 -0400
In-Reply-To: <488D17DE.5000801@splhi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Wright <timw@splhi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2008-07-27 at 17:50 -0700, Tim Wright wrote:
> @@ -629,7 +629,7 @@ int scsi_cmd_ioctl(struct file *file, st
>                         hdr.sbp = cgc.sense;
>                         if (hdr.sbp)
>                                 hdr.mx_sb_len = sizeof(struct 
> request_sense);
> -                       hdr.timeout = cgc.timeout;
> +                       hdr.timeout = jiffies_to_msecs(cgc.timeout);
>                         hdr.cmdp = ((struct cdrom_generic_command 
> __user*) arg)->cmd;
>                         hdr.cmd_len = sizeof(cgc.cmd);

I'm afraid this patch is completely whitespace damaged:  the tabs have
all become spaces and the mailer has broken some of the lines.

Since it's a one liner, I can make the fix directly, but if you look at

Documentation/SubmittingPatches

It has some good advice about how to fix your email tool to prevent this
from happening in future.

James


