From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: pm8001: locking in mpi_sata_completion() is broken
Date: Thu, 15 Dec 2011 17:03:02 +0800
Message-ID: <D9F26C4F671749FE987B29C49D12AA18@usish.com.cn>
References: <20111214092947.GA1537@elgon.mountain> <05B890C6DE854627B79801C1B3B16BBE@usish.com.cn> <20111215061501.GF26939@mwanda>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:33843 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab1LOJEB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2011 04:04:01 -0500
In-Reply-To: <20111215061501.GF26939@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Carpenter' <dan.carpenter@oracle.com>
Cc: lindar_liu@usish.com, linux-scsi@vger.kernel.org

So could you send a patch to not set the flags to 0, or I post a patch to do
this later.
Thanks

Jack
> 
> On Thu, Dec 15, 2011 at 09:26:46AM +0800, Jack Wang wrote:
> > >   2018                          mb();/*in order to force CPU
ordering*/
> > >   2019
> spin_unlock_irqrestore(&pm8001_ha->lock,
> > > flags);
> > >
> > > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > Calling irqrestore before we've done an irqsave.  What are we trying
to
> > > restore?
> > [Jack Wang]
> > We hold spin_lock_irqsave when we process interrupt, so here we need
restore
> > it to do task done clean.
> 
> 
> You're not restoring a previous saved state, flags is set to zero
> here.  You're calling:
> 				spin_unlock_irqrestore(&pm8001_ha->lock, 0);
> 
> The whole function is badly broken.  mpi_sata_event() has similar
> problems.
> 
> With spin_lock_irqsave() and spin_unlock_irqrestore() you first have
> to save the state to "flags" before you can restore it.  Doing it
> the other way round doesn't make any sort sense.
> 
> regards,
> dan carpenter

