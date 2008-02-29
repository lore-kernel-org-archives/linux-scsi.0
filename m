From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Fri, 29 Feb 2008 10:47:36 -0600
Message-ID: <1204303656.4003.19.camel@localhost.localdomain>
References: <1203839683.17463.9.camel@homer.simson.net>
	 <1204019283.8731.11.camel@homer.simson.net>
	 <1204033003.11828.22.camel@homer.simson.net>
	 <20080226150845.2196bc1a.akpm@linux-foundation.org>
	 <1204079075.26640.8.camel@homer.simson.net>
	 <1204092010.9934.31.camel@homer.simson.net>
	 <1204096025.1623.9.camel@homer.simson.net> <47C6661E.9010504@gmail.com>
	 <1204186800.7362.7.camel@homer.simson.net> <47C675C6.8000904@gmail.com>
	 <20080228153542.GZ6704@kernel.dk>  <47C6D73E.4030302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41969 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbYB2Qrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Feb 2008 11:47:42 -0500
In-Reply-To: <47C6D73E.4030302@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>


On Fri, 2008-02-29 at 00:46 +0900, Tejun Heo wrote:
> Jens Axboe wrote:
> >> This problem was reported and diagnosed by Mike Galbraith.
> > 
> > Tejun, this patch isn't much cleaner at all. It really shows the pain of
> > these two seperate, yet related, variables.
> 
> Not much cleaner compared to what?  I think padding stuff is bound to be
> somewhat complex.  It's a nasty thing in nature.  I think ->extra_len is
> better than ->raw_data_len because ->extra_len only needs to be updated
> where the dirty jobs are done and extra buffer areas are added.  Any
> better suggestions?

Well, I just investigated a bug report in the SCSI transport class.  Our
SMP handler is broken in exactly the same way.  We rely on the incoming
reported request lengths to size our request data, and they've blown up
from the true length to 512 bytes (the size of our alignment).

With the original patch, I have to run through the whole of libsas and
scsi_transport_sas doing

s/data_len/raw_data_len/

With your update it looks like I have to run through them all doing

s/data_len/data_len - extra_len/

which is even worse.  Can't we put things back to a point where data_len
means exactly that and extra_len means how much we have spare on the
end, so you know you can DMA up to data_len + extra_len if need be?

That way we don't have to sweep through every block driver altering the
way it uses data_len.

James


