From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Mon, 12 Oct 2015 07:51:05 -0700
Message-ID: <1444661465.2205.2.camel@HansenPartnership.com>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
	 <20150925151802.GB20282@lst.de>
	 <1443202278.2188.13.camel@HansenPartnership.com>
	 <20150930151449.GC26299@lst.de> <20150930215303.GI2627@mtj.duckdns.org>
	 <1443652494.2185.57.camel@HansenPartnership.com>
	 <20151002125608.GB14899@lst.de>
	 <1443792301.2209.4.camel@HansenPartnership.com>
	 <20151002133423.GA15867@lst.de>
	 <1443793497.2209.10.camel@HansenPartnership.com>
	 <20151004074556.GA13932@lst.de> <561BAB72.1070205@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34590 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbbJLOvo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 10:51:44 -0400
In-Reply-To: <561BAB72.1070205@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

On Mon, 2015-10-12 at 14:45 +0200, Hannes Reinecke wrote:
> On 10/04/2015 09:45 AM, Christoph Hellwig wrote:
> > On Fri, Oct 02, 2015 at 06:44:57AM -0700, James Bottomley wrote:
> >> I think I prefer restoring that to having to build in every dh module to
> >> get them to work.  If we take your proposed fix for the sync module load
> >> in the current scheme, any non-built in modules would never attach, so
> >> we'd be moving towards the conclusion that *every* device handler has to
> >> be non-modular.
> > 
> > You don't need to build every module in to make it work.  In 4.2 and earlier
> > we already only auto load modules when dm-multipath explicitly attaches
> > to them.  That will still work in 4.3+.  In fact we will now autoload
> > when activating through sysfs as well.  With the change I sent to Paul
> > we still won't autoload at scan time, which would be really useful to have,
> > but wasn't implemented previously.
> > 
> >> Skimming the code it looks like dh should be using the driver binding
> >> model rather than reinventing it.  That would decouple it better and
> >> make sure binding happened regardless of when the module was loaded.
> > 
> > I tried this early on but gave up because I ran into too many problems.
> > I can try to give it a spin again.
> 
> You cannot easily use the driver model here as the scsi_device is
> already (potentially) bound to the ULDs.
> If you were to go with the driver model you'd have to introduce
> another sub device between scsi_target and scsi_device.

I was thinking more like what we do today for the ULD's: 3 of them use
the driver binding and one uses the class interface model.  Why can't we
also use the class interface model for dh?

James


