From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] aic94xx: Don't free ABORT_TASK SCBs that are timed out
	(Was: Re: aic94xx: failing on high load)
Date: Tue, 19 Feb 2008 12:52:26 -0600
Message-ID: <1203447146.3103.32.camel@localhost.localdomain>
References: <479FB3ED.3080401@hopnet.net>
	 <20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net>
	 <20080130192947.GA21785@tree.beaverton.ibm.com>
	 <47B4682C.4020505@hopnet.net>
	 <1203089323.3058.20.camel@localhost.localdomain>
	 <47B9958A.8080104@hopnet.net>
	 <1203438140.3103.24.camel@localhost.localdomain>
	 <20080219184359.GA5414@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58707 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbYBSSwd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 13:52:33 -0500
In-Reply-To: <20080219184359.GA5414@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Keith Hopkins <vger@hopnet.net>, Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>, Peter Bogdanovic <pbog@us.ibm.com>, Gilbert Wu <Gilbert_Wu@adaptec.com>

On Tue, 2008-02-19 at 10:44 -0800, Darrick J. Wong wrote:
> If we send an ABORT_TASK ascb that doesn't return within the timeout period,
> we should not free that ascb because the sequencer is still holding onto it.
> Hopefully it will fix what James Bottomley describes below:
> 
> On Tue, Feb 19, 2008 at 10:22:20AM -0600, James Bottomley wrote:
> 
> > Unfortunately, there's a bug in TMF timeout handling in the driver, it
> > leaves the sequencer entry pending, but frees the ascb.  If the
> > sequencer ever picks this up it will get very confused, as it does a
> > while down in the trace:
> > 
> > > aic94xx: BUG:sequencer:dl:no ascb?!
> > > aic94xx: BUG:sequencer:dl:no ascb?!
> > 
> > That's where the sequencer adds an ascb to the done list that we've
> > already freed.  From this point on confusion reigns and the error
> > handler eventually offlines the device.
> > 
> > I'll see if I can come up with patches to fix this ... or at least
> > mitigate the problems it causes.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Actually, unfortunately, this is only a tiny part of it.  The message
that triggered all of this is

> sas: sas_scsi_find_task: aborting task 0xffff81033c3d3d80
> aic94xx: tmf timed out
> aic94xx: tmf came back

That's caused by a timeout at asd_enqueue_internal() further up in the
code base.

James


