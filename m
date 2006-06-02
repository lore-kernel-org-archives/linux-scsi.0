From: Mark Lord <lkml@rtr.ca>
Subject: Re: [patch 02/25] drivers/scsi/sd.c: fix uninitialized variable in
 handling medium errors
Date: Fri, 02 Jun 2006 18:21:08 -0400
Message-ID: <4480B9D4.60006@rtr.ca>
References: <200606020338.k523cAbw029209@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:5342 "EHLO mail.rtr.ca")
	by vger.kernel.org with ESMTP id S1751514AbWFBWVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2006 18:21:09 -0400
In-Reply-To: <200606020338.k523cAbw029209@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

akpm@osdl.org wrote:
> From: Mark Lord <lkml@rtr.ca>
> 
> When scsi_get_sense_info_fld() fails (returns 0), it does NOT update the
> value of first_err_block.  But sd_rw_intr() merrily continues to use that
> variable regardless, possibly making incorrect decisions about retries and
> the like.
> 
> This patch removes the randomness there, by using the first sector of the
> request (SCpnt->request->sector) in such cases, instead of first_err_block.
> 
> Signed-off-by: Mark Lord <lkml@rtr.ca>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>

By the way.  I have a more complete fix for the root issue here now,
for an older SUSE-9 kernel (prepared for a client).

The problem with the current implementation, is that when a libata drive
(possibly also a USB2 or Firewire drive) hits a bad sector at block 50 of a 100
block request, SCSI will fail the first 50 blocks of that request,
in a very painfully slow fashion (it literally can take *hours* to complete).

Correct behaviour is to just fail the actual bad block. One method for doing this
is to walk over the failed request, issuing each block one at a time to the LLD,
and passing/failing them one at a time.  This avoids failing "good" blocks,
while giving near-instant recovery from errors.

My patch for SUSE-9 does exactly that, with a minimum of fuss.
It would be good to see something like that implemented ASAP upstream,
and I'm sure that James (or Christoph) could code something like this
in their sleep.  Or use my patch as a starting point if they're too busy.

Cheers

Mark Lord
