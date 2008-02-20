From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic94xx: failing on high load (another data point)
Date: Wed, 20 Feb 2008 10:22:49 -0600
Message-ID: <1203524569.3109.31.camel@localhost.localdomain>
References: <479FB3ED.3080401@hopnet.net>
	 <20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net>
	 <20080130192947.GA21785@tree.beaverton.ibm.com>
	 <47B4682C.4020505@hopnet.net>
	 <1203089323.3058.20.camel@localhost.localdomain>
	 <47B9958A.8080104@hopnet.net>
	 <1203438140.3103.24.camel@localhost.localdomain>
	 <1203479322.3103.53.camel@localhost.localdomain>
	 <47BBF8C5.1030205@hopnet.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45008 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933965AbYBTQW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 11:22:58 -0500
In-Reply-To: <47BBF8C5.1030205@hopnet.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Hopkins <vger@hopnet.net>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org

On Wed, 2008-02-20 at 17:54 +0800, Keith Hopkins wrote:
> On 02/20/2008 11:48 AM, James Bottomley wrote:
> > On Tue, 2008-02-19 at 10:22 -0600, James Bottomley wrote:
> >> I'll see if I can come up with patches to fix this ... or at least
> >> mitigate the problems it causes.
> > 
> > Darrick's working on the ascb sequencer use after free problem.
> > 
> > I looked into some of the error handling in libsas, and apparently
> > that's a bit of a huge screw up too.  There are a number of places where
> > we won't complete a task that is being errored out and thus causes
> > timeout errors.  This patch is actually for libsas to fix all of this.
> > 
> > I've managed to reproduce some of your problem by firing random resets
> > across a disk under load, and this recovers the protocol errors for me.
> > However, I can't reproduce the TMF timeout which caused the sequencer
> > screw up, so you still need to wait for Darrick's fix as well.
> > 
> > James
> > 
> 
> Hi James, Darrick,
> 
>   Thanks again for looking more into this.  I'll wait for Darrick's
> patch and try it together with this libsas patch.  Should I leave
> James' first patch in also?

Yes, that's a requirement just to get the REQ_TASK_ABORT for the
protocol errors actually to work ...

I'm afraid this is like peeling an onion as I said .. and you're going
to build up layers of patches.  However, the ones that are obvious bug
fixes and I can test (all of them so far), I'm putting in the rc fixes
tree of SCSI, so you can download a rollup here:

http://www.kernel.org/pub/linux/kernel/people/jejb/scsi-rc-fixes-2.6.diff

James


