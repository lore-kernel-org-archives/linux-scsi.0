From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: (as73) Do a minimal transfer for disk-cache mode-sense
	page
Date: 30 Jul 2003 16:04:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059599085.1849.264.camel@mulgrave>
References: <Pine.LNX.4.44L0.0307301622410.2990-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:41735 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S272256AbTG3VFQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2003 17:05:16 -0400
In-Reply-To: <Pine.LNX.4.44L0.0307301622410.2990-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2003-07-30 at 15:36, Alan Stern wrote:
> 	It sets the DBD flag to prevent the transfer of unwanted Block 
> Descriptors.

I'm afraid I think we've already been around the houses on this one and
decided that we can't do it.

The problem is that most CD-ROMS and some USB storage devices follow one
of the ATAPI packet specifications which has the DBD bit as reserved,
and someone actually found one which gets annoyed if DBD is set.

> 	It uses 512 (the actual buffer size) as an upper limit, not 128
> as in the current code.

This is fine since the magic buffer size is 512 bytes.

> 	It transfers only the first 4 bytes of the cache page; the 
> information we want is in the 3rd byte.

I didn't actually spot this anywhere in the patch.


> -		len = data.length;
> -		if (len > 128)
> -			len = 128;
> -		res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer,
> +		len = data.header_length + data.block_descriptor_length + 4;
> +		if (len <= 512)
> +			res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer,
>  				       len, &data);
> +		else
> +			res = SAM_STAT_BUSY;

Won't work.  SAM_STAT_BUSY will cause an immediate retry, which still
won't get satisfied.  I think you need to follow the original logic but
change 128 to 512

James


