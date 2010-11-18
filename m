From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer
	derefs in scsi_error.c and reduce size as well
Date: Thu, 18 Nov 2010 21:06:42 +0000
Message-ID: <20101118210642.GA24236@flint.arm.linux.org.uk>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net> <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com> <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35794 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760479Ab0KRVHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 16:07:34 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, "David S. Miller" <davem@davemloft.net>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Nov 18, 2010 at 09:49:29PM +0100, Jesper Juhl wrote:
> @@ -617,10 +623,10 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
>  
>  static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
>  {
> -	if (!scmd->device->host->hostt->eh_abort_handler)
> -		return FAILED;
> -
> -	return scmd->device->host->hostt->eh_abort_handler(scmd);
> +    struct scsi_host_template *hostt = scmd->device->host->hostt;
> +    if (!hostt->eh_abort_handler)
> +        return FAILED;
> +    return hostt->eh_abort_handler(scmd);

Not that I have much to do with SCSI anymore... I spotted the above.
Is there any particular reason for using spaces to indent here rather
than our usual tabs?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
