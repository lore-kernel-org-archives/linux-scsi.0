From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] Retry commands with UNIT_ATTENTION sense codes
Date: Tue, 04 May 2010 16:30:03 -0400
Message-ID: <1273005003.16631.43.camel@mulgrave.site>
References: <20100504144853.D94C72A205@ochil.suse.de>
	 <1272990403.5255.27.camel@mulgrave.site> <4BE0804D.1030406@cs.wisc.edu>
	 <4BE08320.40206@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab0EDUaJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 16:30:09 -0400
In-Reply-To: <4BE08320.40206@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Tue, 2010-05-04 at 15:27 -0500, Mike Christie wrote:
> On 05/04/2010 03:15 PM, Mike Christie wrote:
> > On 05/04/2010 11:26 AM, James Bottomley wrote:
> >> The other patch is fine, but I don't think this is necessary. The
> >> reason is that even returning SUCCESS here, we go straight into
> >> scsi_finish_command() (which passes it up to the driver handler) and
> >> then scsi_io_completion(). There's a catch for UNIT_ATTENTION in
> >> scsi_io_completion
> >
> > The request is sent as a REQ_TYPE_BLOCK_PC (this flag is set for the
> > request in sd_prepare_flush), and scsi_io_completion's blk_pc_request
> > check() that returns the request upwards is before the UNIT_ATTENTION
> 
> I was looking at the wrong source.
> 
> scsi_finish_command checks for REQ_TYPE_BLOCK_PC and sets good_bytes to 
> scsi_bufflen, so when scsi_io_completion calls scsi_end_request, it 
> fails the request before we can get to the UNIT_ATTENTION.

Ah, yes, missed that.

However there are other problems then.  We can't just eat all unit
attentions on the BLOCK_PC path because some of the user programs want
to see them (CD burners for one).  I know the patch allows some to
proceed upwards, but it's risky making all except device not started do
a retry.

I'm a bit stumped on this one ... the intention of BLOCK_PC is that the
caller simply retries if they get a unit attention (which is what all
SCSI code does).  The block code doesn't want to look at the sense data
but at the error return.  I suppose we could make UNIT_ATTENTION
translate to -EAGAIN and have block do the right thing?

James


