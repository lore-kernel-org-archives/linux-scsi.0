From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH-mm] scsi: use unaligned endian helpers rather than
	byteshifting
Date: Wed, 03 Dec 2008 14:33:06 -0600
Message-ID: <1228336386.5551.66.camel@localhost.localdomain>
References: <1228333043.5412.35.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35029 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133AbYLCUdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 15:33:04 -0500
In-Reply-To: <1228333043.5412.35.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-12-03 at 11:37 -0800, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Depends on the unaligned access work in -mm.  Just so you can see what the
> transition would look like.  See in particular the READ/WRITE6 bits
> as just reading the full 32 bits and masking ends up being better on
> lots of arches. (x86/powerpc/SH at least)

Well, as I've said before, I'm not particularly interested in moving
SCSI over to the generic accessors.  It does look like the proponents of
SCSI specific ones gave up as well (most driver writers even open coded
their own over the u32 one we already have).

However, things like this

> @@ -1479,29 +1480,18 @@ static void io_callback(void *context, struct fib * fibptr)
>  		switch (scsicmd->cmnd[0]) {
>  		case WRITE_6:
>  		case READ_6:
> -			lba = ((scsicmd->cmnd[1] & 0x1F) << 16) |
> -			    (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
> +			lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[0]) & 0x1fffff;
>  			break;

Make me think absolutely no way.  It's far less readable than the
original.  The first thing that leaps to the mind of any SCSI person
seeing this is what on earth is the opcode doing loaded as part of that
expression.   It takes a bit of thought to see it's loaded and then
discarded by the and operation.

James


