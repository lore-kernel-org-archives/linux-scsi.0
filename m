From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] Yet another scsi_cmnd leak?
Date: Mon, 3 Oct 2005 11:34:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0510031127470.4824-100000@iolanthe.rowland.org>
References: <433C4E7A.7010205@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:63157 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932300AbVJCPek
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2005 11:34:40 -0400
In-Reply-To: <433C4E7A.7010205@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 29 Sep 2005, Mike Christie wrote:

> Alan Stern wrote:
> > James:
> > 
> > This report is based on 2.6.14-rc2-git6.  The code in your scsi-misc-2.6 
> > git tree is somewhat different (and I don't know which is more current), 
> > but it still contains the same bug.
> > 
> > 
> > In scsi_prep_fn, a request can get deferred if scsi_init_io fails to 
> > allocate an sg table.  When this happens, the scsi_cmnd isn't released and 
> > the request is not marked DONTPREP.
> > 
> > Then when scsi_prep_fn is called again, the request may be killed for 
> > a number of reasons.  The code branches to the kill: label near the end of 
> > the routine, which returns BLKPREP_KILL.
> > 
> > Isn't it true that when this happens, the scsi_cmnd allocated during the
> > original prep will never be released?
> > 
> > It appears that scsi_prep_fn is undecided about whether or not the request
> > is allowed to have a scsi_cmnd already.  The jumps to kill: seem to assume
> > that it isn't, but the code for allocating a new scsi_cmnd tests for an
> > existing one first.
> > 
> 
> The gotos used to be just a return BLKPREP* and were added so I did not 
> have to write DID_NO_CONNECT or unplug multiple times :) I think you are 
> right and we need to further unwind what a previous prep had done 
> becuase when we return with BLKPREP_KILL we only hear about this command 
> again if it's request has a end_io function or waiting completion.

I'm still not very clear about the conditions under which a request on the
queue can be partially prepared -- for example, scsi_cmnd assigned but 
not the sg table.  For the normal submission pathways, it looks like this 
happens only when the sg allocation fails.  In those cases it wouldn't 
hurt to release the scsi_cmnd before deferring.  Or before returning 
BLKPREP_KILL.

But what about other pathways?  As long as the special scsi_request things 
exist, I don't know what should be done.  I saw you had submitted patches 
to get rid of them; how far has that progressed?

Alan Stern

