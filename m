From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [bug] SCSI/SLUB - latest -git: WARNING: at mm/slub.c:2443
	kmem_cache_destroy, scsi_put_host_cmd_pool()
Date: Tue, 22 Apr 2008 08:39:59 -0500
Message-ID: <1208871600.3105.1.camel@localhost.localdomain>
References: <20080419085758.GA18612@elte.hu>
	 <1208611357.3280.5.camel@localhost.localdomain>
	 <20080421134925.GK9554@elte.hu>
	 <1208793440.3640.22.camel@localhost.localdomain>
	 <20080422131020.GB7311@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59997 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234AbYDVNkG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 09:40:06 -0400
In-Reply-To: <20080422131020.GB7311@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <clameter@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2008-04-22 at 15:10 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > Thanks ... it looks like we may have trouble from devices that alter 
> > the unchecked isa dma flag after scsi_host_alloc.  The guilty parties 
> > appear to be gdth, eata, u14-34f, ultrastor, BusLogic and advansys.
> > 
> > The trouble is that if you alloc the host with it one way and free it 
> > with it the other, the wrong freelist is used and the ref counts are 
> > invalid.
> > 
> > Try this pseudo fix: it avoids allocating the freelist until add time 
> > (by which time they should all have fixed the flag).  It still doesn't 
> > change the fact that the host is allocated in the wrong region, but 
> > that shouldn't matter too much.
> 
> ok - do you intend to push this pseudo-fix upstream? If yes then please 
> consider it fixed as far as i'm concerned - i'll re-reply if the warning 
> resurfaces (it wasnt lethal to the bootup otherwise). Or if you've got 
> some other approach/fix then i can test that too.

It's certainly the line of least resistance.  The more correct fix would
be to haul unchecked_isa_dma out of the host and make everything use the
template, so it becomes immutable (as it should be).  However, that's a
lot of work and given that Andi's gunning for unchecked_isa_dma anyway,
probably not worth it.

So, unless I think of something better in the next few days, this is the
way I'll fix it.

James


