From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/9] blk: In elv_abort_queue skip requests with
	REQ_DONTPREP set
Date: Wed, 5 May 2010 10:21:50 +0200
Message-ID: <20100505082150.GY27497@kernel.dk>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com> <1272944228-30511-3-git-send-email-andmike@linux.vnet.ibm.com> <20100504104709.GO27497@kernel.dk> <20100504175855.GB16156@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43908 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933453Ab0EEIVx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2010 04:21:53 -0400
Content-Disposition: inline
In-Reply-To: <20100504175855.GB16156@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

On Tue, May 04 2010, Mike Anderson wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, May 03 2010, Mike Anderson wrote:
> > > Having REQ_DONTPREP set on a request can indicated that resources have been
> > > allocated for this request. In elv_abort_queue skip requests with
> > > REQ_DONTPREP set to avoid leaking resources.
> > 
> > This also seems weird, are you coding the API backwards from what SCSI
> > currently has implemented?
> > 
> 
> Yes I was coding to current SCSI implementation.
> 
> > Would seem a lot cleaner to separate dont-prep from already-prepped.
> > 
> 
> I assumed to do this we would need another request flag indicating
> ??REQ_PREPPED?? that would need to be set in the prep function. Then
> this flag would be checked vs REQ_DONTPREP to call the unprep_fn or did you
> mean something else?

Yeah, something like that, cleanly seperating the state of needing
unprep vs never being prepped. As that's a driver state, most drivers
should be able to get that info without needing an extra flag. But it's
probably cleaner to add the REQ_PREPPED flag and only call back into the
driver if the rq really needs an unprep.

-- 
Jens Axboe

